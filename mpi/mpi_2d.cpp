#include <mpi.h>
#include <vector>
#include <cmath>
#include <iostream>
#include <algorithm>

#define MIN_ROWS 3
#define MIN_COLS 3

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

            int32_t sx_int =
                -local_in[img_idx - w - 1] + local_in[img_idx - w + 1]
                - 2 * local_in[img_idx - 1]       + 2 * local_in[img_idx + 1]
                - local_in[img_idx + w - 1] + local_in[img_idx + w + 1];

            int32_t sy_int =
                -local_in[img_idx - w - 1] - 2 * local_in[img_idx - w] - local_in[img_idx - w + 1]
                + local_in[img_idx + w - 1] + 2 * local_in[img_idx + w] + local_in[img_idx + w + 1];

            int magdir_idx = (y - 1) * (w - 2) + (x - 1);
            mag[magdir_idx] = std::sqrt(static_cast<float>(sx_int * sx_int + sy_int * sy_int));
            dir[magdir_idx] = std::atan2(static_cast<float>(sy_int), static_cast<float>(sx_int));
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

    const int width  = std::stoi(argv[3]);
    const int height = std::stoi(argv[4]);

    // 1. Choose a 2-D process grid so everyone has at least 3 rows, 3 cols
    int max_ranks_r = height / MIN_ROWS;
    int max_ranks_c = width  / MIN_COLS;
    int active_ranks = std::min(size, max_ranks_r * max_ranks_c);

    int dims[2] = {0, 0};
    MPI_Dims_create(active_ranks, 2, dims);
    dims[0] = std::min(dims[0], max_ranks_r);
    dims[1] = std::min(dims[1], max_ranks_c);
    active_ranks = dims[0] * dims[1];
    // dims[0] = process-rows, dims[1] = process-cols

    bool is_active = (rank < active_ranks);

    // 2. Build Cartesian communicator (non-periodic, no reorder)
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

    // 3. Tile assignment     
    int my_rows = 0, start_row = 0;
    int my_cols = 0, start_col = 0;

    if (is_active)
    {
        // Row axis (coords[0])
        int base_rows = height / dims[0];
        int rem_rows  = height % dims[0];
        my_rows   = base_rows + (coords[0] < rem_rows ? 1 : 0);
        start_row = coords[0] * base_rows + std::min(coords[0], rem_rows);

        // Col axis (coords[1])
        int base_cols = width / dims[1];
        int rem_cols  = width % dims[1];
        my_cols   = base_cols + (coords[1] < rem_cols ? 1 : 0);
        start_col = coords[1] * base_cols + std::min(coords[1], rem_cols);
    }

    // Halo buffer dims: real tile + 1-px ghost border on all four sides
    int local_h = my_rows + 2;   
    int local_w = my_cols + 2;   

    std::vector<uint8_t> local_in(is_active ? local_h * local_w : 0, 0);

    int out_cols = my_cols;      
    int local_magdir_size = my_rows * out_cols;
    std::vector<float> mag(local_magdir_size, 0.f);
    std::vector<float> dir(local_magdir_size, 0.f);

    // 4. MPI-IO: read this rank's tile from the raw image file. The file is a flat width*height uint8 row-major ordered.
    MPI_File fh;
    
    if (is_active)
    {
        MPI_File_open(cart_comm, argv[1], MPI_MODE_RDONLY, MPI_INFO_NULL, &fh);
   
        // Describe the full file as a 2-D array [height][width]
        int gsizes[2]  = {height, width};
        // Our sub-array starts at (start_row, start_col) and is my_rows x my_cols big
        int subsizes[2] = {my_rows, my_cols};
        int starts[2]   = {start_row, start_col};

        MPI_Datatype filetype;
        MPI_Type_create_subarray(2, gsizes, subsizes, starts,
                                 MPI_ORDER_C, MPI_UINT8_T, &filetype);
        MPI_Type_commit(&filetype);

        // Memory type: totoal size [local_h][local_w]; read in [my_rows, my_cols]; skip first row, col
        int mem_gsizes[2]  = {local_h, local_w};
        int mem_subsizes[2] = {my_rows, my_cols};
        int mem_starts[2]   = {1, 1};   

        MPI_Datatype memtype;
        MPI_Type_create_subarray(2, mem_gsizes, mem_subsizes, mem_starts,
                                 MPI_ORDER_C, MPI_UINT8_T, &memtype);
        MPI_Type_commit(&memtype);

        MPI_File_set_view(fh, 0, MPI_UINT8_T, filetype, "native", MPI_INFO_NULL);
        MPI_File_read_all(fh, local_in.data(), 1, memtype, MPI_STATUS_IGNORE);

        MPI_Type_free(&filetype);
        MPI_Type_free(&memtype);
        MPI_File_close(&fh);
    }

    // 5. Build MPI_Type_vector for non-contiguous left/right column sends.Column halo = my_rows elements spaced local_w apart.

    MPI_Datatype col_type = MPI_DATATYPE_NULL;
    if (is_active)
    {
        MPI_Type_vector(my_rows, /*count=*/1, /*stride=*/local_w,
                        MPI_UINT8_T, &col_type);
        MPI_Type_commit(&col_type);
    }

    // 6. Async halo exchange: post all 16 non-blocking ops (up to) at once,then overlap with interior compute, then Waitall once.
    // Neighbours via MPI_Cart_shift (returns MPI_PROC_NULL if no neighbour).
    constexpr int TAG_U2D = 10, TAG_D2U = 11;
    constexpr int TAG_L2R = 20, TAG_R2L = 21;

    constexpr int TAG_NW2SE = 30, TAG_NE2SW = 31, TAG_SW2NE = 32, TAG_SE2NW = 33;

    MPI_Request reqs[16];
    int n_reqs = 0;

    if (is_active)
    {
        int up, down, left, right;
        MPI_Cart_shift(cart_comm, 0, 1, &up,   &down);   
        MPI_Cart_shift(cart_comm, 1, 1, &left, &right);  

        // Diagonal neighbours: look them up via coords
        auto cart_rank = [&](int dr, int dc) -> int {
            int nc[2] = {coords[0] + dr, coords[1] + dc};
            if (nc[0] < 0 || nc[0] >= dims[0] || nc[1] < 0 || nc[1] >= dims[1])
                return MPI_PROC_NULL;
            int r;
            MPI_Cart_rank(cart_comm, nc, &r);
            return r;
        };
        int nw = cart_rank(-1, -1);
        int ne = cart_rank(-1, +1);
        int sw = cart_rank(+1, -1);
        int se = cart_rank(+1, +1);

        if (up != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(0, 1, local_w)], my_cols, MPI_UINT8_T,
                      up, TAG_U2D, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, 1, local_w)], my_cols, MPI_UINT8_T,
                      up, TAG_D2U, cart_comm, &reqs[n_reqs++]);
        }
        if (down != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(my_rows + 1, 1, local_w)], my_cols, MPI_UINT8_T,
                      down, TAG_D2U, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(my_rows, 1, local_w)], my_cols, MPI_UINT8_T,
                      down, TAG_U2D, cart_comm, &reqs[n_reqs++]);
        }

        if (left != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(1, 0, local_w)], 1, col_type,
                      left, TAG_L2R, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, 1, local_w)], 1, col_type,
                      left, TAG_R2L, cart_comm, &reqs[n_reqs++]);
        }
        if (right != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(1, my_cols + 1, local_w)], 1, col_type,
                      right, TAG_R2L, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, my_cols, local_w)], 1, col_type,
                      right, TAG_L2R, cart_comm, &reqs[n_reqs++]);
        }

        if (nw != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(0, 0, local_w)], 1, MPI_UINT8_T,
                      nw, TAG_NW2SE, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, 1, local_w)], 1, MPI_UINT8_T,
                      nw, TAG_SE2NW, cart_comm, &reqs[n_reqs++]);
        }
        if (ne != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(0, my_cols + 1, local_w)], 1, MPI_UINT8_T,
                      ne, TAG_NE2SW, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, my_cols, local_w)], 1, MPI_UINT8_T,
                      ne, TAG_SW2NE, cart_comm, &reqs[n_reqs++]);
        }
        if (sw != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(my_rows + 1, 0, local_w)], 1, MPI_UINT8_T,
                      sw, TAG_SW2NE, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(my_rows, 1, local_w)], 1, MPI_UINT8_T,
                      sw, TAG_NE2SW, cart_comm, &reqs[n_reqs++]);
        }
        if (se != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(my_rows + 1, my_cols + 1, local_w)], 1, MPI_UINT8_T,
                      se, TAG_SE2NW, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(my_rows, my_cols, local_w)], 1, MPI_UINT8_T,
                      se, TAG_NW2SE, cart_comm, &reqs[n_reqs++]);
        }

        // 7.Compute: compute [2: my_rows-1, 2:my_cols-1]  while halo messages are in flight.
        if (my_rows > 2 && my_cols > 2)
            sobel(local_in.data(), local_w,
                mag.data(), dir.data(),
                2, my_rows,
                2, my_cols);
    }

    // Wait for all halo messages before touching any boundary row/col
    MPI_Waitall(n_reqs, reqs, MPI_STATUSES_IGNORE);

        // 8. Compute boundary rows/cols that depend on ghost data.
    
    if (is_active)
    {
        int up, down, left, right;
        MPI_Cart_shift(cart_comm, 0, 1, &up,   &down);
        MPI_Cart_shift(cart_comm, 1, 1, &left, &right);

        // Which edges actually have a ghost neighbour?
        bool has_top    = (up    != MPI_PROC_NULL);
        bool has_bottom = (down  != MPI_PROC_NULL);
        bool has_left   = (left  != MPI_PROC_NULL);
        bool has_right  = (right != MPI_PROC_NULL);

        if (has_top)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(),
                  1, 2,
                  has_left ? 2 : 1, has_right ? my_cols : my_cols + 1);

        if (has_bottom)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(),
                  my_rows, my_rows + 1,
                  has_left ? 2 : 1, has_right ? my_cols : my_cols + 1);

        if (has_left)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(),
                  has_top ? 2 : 1,
                  has_bottom ? my_rows : my_rows + 1,
                  1, 2);

        
        if (has_right)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(),
                  has_top ? 2 : 1,
                  has_bottom ? my_rows : my_rows + 1,
                  my_cols, my_cols + 1);

        if (has_top && has_left)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(),
                  1, 2, 
                  1, 2);
        if (has_top && has_right)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(),
                  1, 2, 
                  my_cols, my_cols + 1);
        if (has_bottom && has_left)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(),
                  my_rows, my_rows + 1, 
                  1, 2);
        if (has_bottom && has_right)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(),
                  my_rows, my_rows + 1, 
                  my_cols, my_cols + 1);

        MPI_Type_free(&col_type);
    }

    // 9. MPI-IO write

    if (is_active)
    {
        MPI_File_open(cart_comm, argv[2],
                MPI_MODE_CREATE | MPI_MODE_WRONLY,
                MPI_INFO_NULL, &fh);
        bool is_top = (coords[0] == 0); 
        bool is_bottom = (coords[0] == dims[0]-1);
        bool is_left = (coords[1] == 0);  
        bool is_right = (coords[1] == dims[1]-1); 

        int g_out_h = height - 2;
        int g_out_w = width  - 2;

        int local_rows = my_rows; 
        if(is_top) local_rows -= 1; 
        if(is_bottom) local_rows -= 1; 
        
        int local_cols = my_cols; 
        if(is_left) local_cols -= 1; 
        if(is_right) local_cols -= 1; 

        // Subarray type describing this rank's tile in the output plane
        int f_gsizes[2]   = {g_out_h, g_out_w};
        int f_subsizes[2] = {local_rows, local_cols};
        int f_starts[2]   = {
            is_top ? 0 : start_row - 1,
            is_left ? 0 : start_col - 1
        };

        MPI_Datatype out_tile_t;
        MPI_Type_create_subarray(2, f_gsizes, f_subsizes, f_starts,
                                 MPI_ORDER_C, MPI_FLOAT, &out_tile_t);
        MPI_Type_commit(&out_tile_t);
        MPI_Offset plane_bytes = static_cast<MPI_Offset>(g_out_h) * g_out_w * sizeof(float);

        int m_gsizes[2] = {my_rows, my_cols}; 
        int m_subsizes[2] = {local_rows, local_cols}; 
        int m_starts[2] = {is_top?1:0, is_left?1:0}; 
        
        MPI_Datatype mem_tile_t; 
        MPI_Type_create_subarray(2, m_gsizes, m_subsizes, m_starts, MPI_ORDER_C, MPI_FLOAT, &mem_tile_t); 
        MPI_Type_commit(&mem_tile_t);

        MPI_File_set_view(fh, 0, MPI_FLOAT, out_tile_t, "native", MPI_INFO_NULL);
        MPI_File_write_all(fh, mag.data(), 1, mem_tile_t, MPI_STATUS_IGNORE);

        
        MPI_File_set_view(fh, plane_bytes, MPI_FLOAT, out_tile_t, "native", MPI_INFO_NULL);
        MPI_File_write_all(fh, dir.data(), 1, mem_tile_t, MPI_STATUS_IGNORE);

        MPI_Type_free(&out_tile_t);
        MPI_Type_free(&mem_tile_t);

        MPI_File_close(&fh);
    }


    if (cart_comm != MPI_COMM_NULL) MPI_Comm_free(&cart_comm);
    if (active_comm != MPI_COMM_NULL) MPI_Comm_free(&active_comm);

    MPI_Finalize();
}
