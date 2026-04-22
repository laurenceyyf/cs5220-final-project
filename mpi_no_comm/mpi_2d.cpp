#include <mpi.h>
#include <vector>
#include <cmath>
#include <iostream>
#include <algorithm>
// #include <fstream>

#define MIN_ROWS 3
#define MIN_COLS 3

// Sobel kernel
void sobel(const uint8_t *local_in, int w,
           float *mag, float *dir,
           int y_start, int y_end,
           int x_start, int x_end)
{
    for (int y = y_start; y < y_end; ++y)
    {
        for (int x = x_start; x < x_end; ++x)
        {
            int img_idx = y * w + x;

            int32_t sx =
                -local_in[img_idx - w - 1] + local_in[img_idx - w + 1]
                - 2 * local_in[img_idx - 1]       + 2 * local_in[img_idx + 1]
                - local_in[img_idx + w - 1] + local_in[img_idx + w + 1];

            int32_t sy =
                -local_in[img_idx - w - 1] - 2 * local_in[img_idx - w] - local_in[img_idx - w + 1]
                + local_in[img_idx + w - 1] + 2 * local_in[img_idx + w] + local_in[img_idx + w + 1];

            // Map (y,x) in local_in → (y-1, x-1) in output
            int magdir_idx = (y - 1) * (w-2) + (x - 1);
            mag[magdir_idx] = std::sqrt(static_cast<float>(sx * sx + sy * sy));
            dir[magdir_idx] = std::atan2(static_cast<float>(sy), static_cast<float>(sx));
        }
    }
}

static inline int LI(int y, int x, int local_w) { return y * local_w + x; }

int main(int argc, char **argv)
{
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    const int height  = std::stoi(argv[3]);
    const int width = std::stoi(argv[4]);

    ////////////////////////////////////////
    // 1. make 2d grid
    ////////////////////////////////////////
    int max_ranks_r = height / MIN_ROWS;
    int max_ranks_c = width  / MIN_COLS;
    int active_ranks = std::min(size, max_ranks_r * max_ranks_c);

    int dims[2] = {0, 0};
    MPI_Dims_create(active_ranks, 2, dims);

    dims[0] = std::min(dims[0], max_ranks_r);
    dims[1] = std::min(dims[1], max_ranks_c);
    active_ranks = dims[0] * dims[1];

    bool is_active = (rank < active_ranks);

    ////////////////////////////////////////
    // 2. Build Cartesian communicator
    ////////////////////////////////////////
    MPI_Comm cart_comm = MPI_COMM_NULL;
    int periods[2] = {0, 0};

    MPI_Comm active_comm;
    MPI_Comm_split(MPI_COMM_WORLD, is_active ? 0 : MPI_UNDEFINED, rank, &active_comm);

    int coords[2] = {0, 0};
    if (is_active)
    {
        MPI_Cart_create(active_comm, 2, dims, periods, 0, &cart_comm);
        MPI_Cart_coords(cart_comm, rank, 2, coords);
    }

    ////////////////////////////////////////
    // 3. Tile assignment: 
    // - same remainder-spread logic as the 1-D version, applied independently to rows and columns
    ////////////////////////////////////////
    int my_rows = 0, start_row = 0;
    int my_cols = 0, start_col = 0;
    bool is_top=false,is_bot=false,is_left=false,is_right=false; 

    int local_h = 0;
    int local_w = 0;
    int magdir_cols = 0;
    int magdir_rows = 0; 

    if (is_active)
    {
        // Row axis (coords[0])
        int base_rows = height / dims[0];
        int rem_rows  = height % dims[0];
        is_top =( coords[0] == 0); 
        is_bot = (coords[0] + 1 == dims[0]);
        my_rows   = base_rows + (coords[0] < rem_rows ? 1 : 0);
        start_row = coords[0] * base_rows + std::min(coords[0], rem_rows);
        local_h = my_rows + (is_top?0:1) + (is_bot?0:1);
        magdir_rows = local_h - 2;

        // Col axis (coords[1])
        int base_cols = width / dims[1];
        int rem_cols  = width % dims[1];
        is_left = (coords[1] == 0); 
        is_right = (coords[1] + 1 == dims[1]); 
        my_cols   = base_cols + (coords[1] < rem_cols ? 1 : 0);
        start_col = coords[1] * base_cols + std::min(coords[1], rem_cols);
        local_w = my_cols +(is_left? 0: 1) + (is_right? 0: 1);
        magdir_cols = local_w - 2; 
    }

    int local_magdir_size = magdir_rows * magdir_cols;
    std::vector<uint8_t> local_in(is_active ? local_h * local_w : 0);

    std::vector<float> mag(local_magdir_size);//, NAN);
    std::vector<float> dir(local_magdir_size);//, NAN);

    ////////////////////////////////////////
    // 4. MPI-IO: read this rank's tile from the raw image file.
    ////////////////////////////////////////
    
    MPI_File fh;
    MPI_File_open(cart_comm, argv[1], MPI_MODE_RDONLY, MPI_INFO_NULL, &fh);

    if (is_active)
    {
        
        // total image size
        int gsizes[2]  = {height, width};
        // shape of read
        int subsizes[2] = {local_h, local_w};
        int starts[2]   = {
            start_row - (is_top? 0: 1), 
            start_col - (is_left? 0: 1)
        };

        MPI_Datatype filetype;
        MPI_Type_create_subarray(2, gsizes, subsizes, starts,
                                 MPI_ORDER_C, MPI_UINT8_T, &filetype);
        MPI_Type_commit(&filetype);

        // Memory type: local + halo:  [local_h][local_w], local [myrows][my_cols], data starts at (1,1)
        int mem_gsizes[2]  = {local_h, local_w};
        int mem_subsizes[2] = {local_h, local_w};
        int mem_starts[2]   = {0, 0};   

        MPI_Datatype memtype;
        MPI_Type_create_subarray(2, mem_gsizes, mem_subsizes, mem_starts,
                                 MPI_ORDER_C, MPI_UINT8_T, &memtype);
        MPI_Type_commit(&memtype);

        MPI_File_set_view(fh, 0, MPI_UINT8_T, filetype, "native", MPI_INFO_NULL);
        MPI_File_read_all(fh, local_in.data(), 1, memtype, MPI_STATUS_IGNORE);

        MPI_Type_free(&filetype);
        MPI_Type_free(&memtype);
    }
    MPI_File_close(&fh);

    ////////////////////////////////////////
    // 7. Compute interior rows/cols while messages in flight
    ////////////////////////////////////////
    if(is_active){
        sobel(local_in.data(), local_w,
        mag.data(), dir.data(), 
        1, local_h-1,
        1, local_w-1);
    }

    
    ////////////////////////////////////////
    // 9. MPI-IO write
    ////////////////////////////////////////

    // if (is_active) {
    //     // std::string filename = "../data/" + std::to_string(rank) + "_magdir.bin";
    //     // std::ofstream df(filename, std::ios::binary);
    //     if (df.is_open()) {
    //         df.write(reinterpret_cast<const char*>(mag.data()), 
    //                 mag.size() * sizeof(float));
    //         // Append the entire dir vector
    //         df.write(reinterpret_cast<const char*>(dir.data()), 
    //                 dir.size() * sizeof(float));
    //         df.close();
    //     }
    // }   

    MPI_File_open(cart_comm, argv[2],
                  MPI_MODE_CREATE | MPI_MODE_WRONLY,
                  MPI_INFO_NULL, &fh);

    if (is_active)
    { 
    
        int g_out_h = height - 2;
        int g_out_w = width  - 2;


        // Subarray type describing this rank's tile in the output plane
        int f_gsizes[2]   = {g_out_h, g_out_w};
        int f_subsizes[2] = {magdir_rows,magdir_cols};
        int f_starts[2]   = {
            is_top ? 0 : start_row - 1,
            is_left ? 0 : start_col - 1
        };
        // std::cout<< "writeout " << g_out_h << " "<< g_out_w << " "<< local_rows << " "<< local_cols << " " << is_top << " " << is_left << "\n"; 
        MPI_Datatype out_tile_t;
        MPI_Type_create_subarray(2, f_gsizes, f_subsizes, f_starts,
                                 MPI_ORDER_C, MPI_FLOAT, &out_tile_t);
        MPI_Type_commit(&out_tile_t);
        MPI_Offset plane_bytes = static_cast<MPI_Offset>(g_out_h) * g_out_w * sizeof(float);

        int m_gsizes[2] = {magdir_rows, magdir_cols}; 
        int m_subsizes[2] = {magdir_rows, magdir_cols}; 
        int m_starts[2] = {0, 0}; 
        // std::cout<< "\t " << my_rows << " "<< my_cols << " "<< local_rows << " "<< local_cols << " " << is_top << " " << is_left << std::endl; 
        
        MPI_Datatype mem_tile_t; 
        MPI_Type_create_subarray(2, m_gsizes, m_subsizes, m_starts, MPI_ORDER_C, MPI_FLOAT, &mem_tile_t); 
        MPI_Type_commit(&mem_tile_t);

        // mag plane at offset 0
        MPI_File_set_view(fh, 0, MPI_FLOAT, out_tile_t, "native", MPI_INFO_NULL);
        MPI_File_write_all(fh, mag.data(), 1, mem_tile_t, MPI_STATUS_IGNORE);

        // dir plane immediately after mag
        MPI_File_set_view(fh, plane_bytes, MPI_FLOAT, out_tile_t, "native", MPI_INFO_NULL);
        MPI_File_write_all(fh, dir.data(), 1, mem_tile_t, MPI_STATUS_IGNORE);

        MPI_Type_free(&out_tile_t);
        MPI_Type_free(&mem_tile_t);
    }

    MPI_File_close(&fh);

    if (cart_comm != MPI_COMM_NULL) MPI_Comm_free(&cart_comm);
    if (active_comm != MPI_COMM_NULL) MPI_Comm_free(&active_comm);

    MPI_Finalize();
}
