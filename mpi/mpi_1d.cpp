#include <mpi.h>
#include <vector>
#include <cmath>
#include <iostream>

#define MIN_ROWS 3

constexpr int Gx[3][3] = {
    {-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
constexpr int Gy[3][3] = {
    {-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

// Compute sobel over [y_start, y_end) in the local tile.
// magdir offsets need to account for fact we have extra rows and missing 2 cols.
void sobel(const uint8_t *local_in, int w,
           float *mag, float *dir,
           int y_start, int y_end)
{
    for (int y = y_start; y < y_end; ++y)
    {
        for (int x = 1; x < w - 1; ++x)
        {
            int img_idx = y * w + x;

            int32_t sx =
                -local_in[img_idx - w - 1] + local_in[img_idx - w + 1] 
                - 2 * local_in[img_idx - 1] + 2 * local_in[img_idx + 1] 
                - local_in[img_idx + w - 1] + local_in[img_idx + w + 1];

            int32_t sy =
                -local_in[img_idx - w - 1] - 2 * local_in[img_idx - w] - local_in[img_idx - w + 1] 
                + local_in[img_idx + w - 1] + 2 * local_in[img_idx + w] + local_in[img_idx + w + 1];

            int magdir_idx = (y - 1) * (w - 2) + (x - 1);

            mag[magdir_idx] = std::sqrt(static_cast<float>(sx * sx + sy * sy));
            dir[magdir_idx] = std::atan2(static_cast<float>(sy), static_cast<float>(sx));
        }
    }
}

int main(int argc, char **argv)
{
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int height = std::stoi(argv[3]);
    int width = std::stoi(argv[4]);

    int active_ranks = std::min(size, height / MIN_ROWS);
    bool is_active = (rank < active_ranks);

    int my_rows = 0;
    int start_row = 0;
    int base_rows = height / active_ranks;
    int remainder = height % active_ranks;

    if (is_active)
    {
        my_rows = base_rows + (rank < remainder ? 1 : 0);
        start_row = rank * base_rows + std::min(rank, remainder);
    }
    // std::cout << "mr " << my_rows << " sr " << start_row << " width " << width << std::endl;

    // Halo buffer: my_rows data rows + 1 ghost row above + 1 ghost row below
    int local_h = is_active ? (my_rows + 2) : 0;
    std::vector<uint8_t> local_in(local_h * width);

    int local_magdir_size = my_rows * (width - 2);
    std::vector<float> mag(local_magdir_size, NAN);
    std::vector<float> dir(local_magdir_size, NAN);

    // MPI FILE READ 
    MPI_File fh;
    MPI_File_open(MPI_COMM_WORLD, argv[1], MPI_MODE_RDONLY, MPI_INFO_NULL, &fh);

    if (is_active)
    {
        MPI_Offset offset = static_cast<MPI_Offset>(start_row) * width;
        // Read data rows into slot 1..my_rows (slot 0 and my_rows+1 are ghost rows)
        MPI_File_read_at(fh, offset,
                         local_in.data() + width, my_rows * width,
                         MPI_UINT8_T, MPI_STATUS_IGNORE);
    }
    MPI_File_close(&fh);

    // ASYNC HALO EXCHANGE 
    MPI_Request reqs[4];
    int n_reqs = 0;

    if (is_active)
    {
        int up = rank - 1;
        int down = rank + 1;

        constexpr int FROM_DOWN_TO_UP = 0, FROM_UP_TO_DOWN = 1;
        if (up >= 0)
        {
            MPI_Irecv(local_in.data(), width, MPI_UINT8_T, up, FROM_UP_TO_DOWN, MPI_COMM_WORLD, &reqs[n_reqs++]);
            MPI_Isend(local_in.data() + width, width, MPI_UINT8_T,up, FROM_DOWN_TO_UP, MPI_COMM_WORLD, &reqs[n_reqs++]);
        }

        if (down < active_ranks)
        {
            MPI_Irecv(local_in.data() + (my_rows + 1) * width, width, MPI_UINT8_T,down, FROM_DOWN_TO_UP, MPI_COMM_WORLD, &reqs[n_reqs++]);
            MPI_Isend(local_in.data() + my_rows * width, width, MPI_UINT8_T, down, FROM_UP_TO_DOWN, MPI_COMM_WORLD, &reqs[n_reqs++]);
        }

        // COMPUTE INTERIOR ROWS
        if (my_rows > 2)
            sobel(local_in.data(), width, mag.data(), dir.data(),
                  2, my_rows); // [2: my_rows]: safe, no ghost dependency
    }

    // Wait for halo exchange to complete before touching boundary rows
    MPI_Waitall(n_reqs, reqs, MPI_STATUSES_IGNORE);

    //  COMPUTE HALO 
    if (is_active)
    {
        if (rank > 0){
            sobel(local_in.data(), width, mag.data(), dir.data(), 1, 2);
        }
        if((rank + 1) < active_ranks){
            sobel(local_in.data(), width, mag.data(), dir.data(), my_rows-1, my_rows + 1);
        }
    }

    // WRITE
    MPI_File_open(MPI_COMM_WORLD, argv[2],
                  MPI_MODE_CREATE | MPI_MODE_WRONLY,
                  MPI_INFO_NULL, &fh);

    if (is_active)
    {
        
        bool is_last  = (rank + 1 == active_ranks);
        bool is_first  = (rank  == 0);
        
        int out_w = width - 2;
        int out_h = base_rows;
        if (is_first) out_h -= 1;
        if (is_last)  out_h -= 1;
        // std::cout << out_w << ", " << out_h << "\n";
        size_t writeout_count = (size_t)out_h * out_w;
        // std::cout << writeout_count << "\n";

        int file_offset_row = start_row;
        if(!is_first) file_offset_row -= 1; 
        size_t file_offset = (size_t) file_offset_row * out_w * sizeof(float);  
        // std::cout << file_offset_row * out_w << "\n"; 

        float* mag_ptr = mag.data() + (is_first ? out_w: 0);
        float* dir_ptr = dir.data() + (is_first ? out_w: 0);
        // std::cout << mag.size() << "; " << out_w * base_rows << "\n";
        // std::cout << (is_first ? out_w: 0) << std::endl;
        
        MPI_File_write_at(fh, file_offset,
                          mag_ptr, writeout_count,
                          MPI_FLOAT, MPI_STATUS_IGNORE);
        MPI_File_write_at(fh, file_offset + static_cast<MPI_Offset>(out_w) * (height-2)*sizeof(float) ,
                          dir_ptr, writeout_count,
                          MPI_FLOAT, MPI_STATUS_IGNORE);
    }
    MPI_File_close(&fh);

    MPI_Finalize();
}