#include <mpi.h>
#include <vector>
#include <cmath>
#include <iostream>
#include <immintrin.h>

#define MIN_ROWS 3

constexpr int Gx[3][3] = {
    {-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
constexpr int Gy[3][3] = {
    {-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

// Compute sobel over [y_start, y_end) in the local tile.
// magdir offsets need to account for fact we have extra rows and missing 2 cols.
static inline __m256i load_u8x8_to_i32(const uint8_t *ptr)
{
    return _mm256_cvtepu8_epi32(_mm_loadl_epi64(reinterpret_cast<const __m128i *>(ptr)));
}

void sobel(const uint8_t *local_in, int w,
           float *mag, float *dir,
           int y_start, int y_end)
{
    for (int y = y_start; y < y_end; ++y)
    {
        int x = 1;
        for (; x <= w - 9; x += 8)
        {
            int img_idx = y * w + x;

            __m256i top_l = load_u8x8_to_i32(local_in + img_idx - w - 1);
            __m256i top_c = load_u8x8_to_i32(local_in + img_idx - w);
            __m256i top_r = load_u8x8_to_i32(local_in + img_idx - w + 1);
            __m256i mid_l = load_u8x8_to_i32(local_in + img_idx - 1);
            __m256i mid_r = load_u8x8_to_i32(local_in + img_idx + 1);
            __m256i bot_l = load_u8x8_to_i32(local_in + img_idx + w - 1);
            __m256i bot_c = load_u8x8_to_i32(local_in + img_idx + w);
            __m256i bot_r = load_u8x8_to_i32(local_in + img_idx + w + 1);

            __m256i sx_i = _mm256_sub_epi32(top_r, top_l);
            sx_i = _mm256_add_epi32(sx_i, _mm256_slli_epi32(_mm256_sub_epi32(mid_r, mid_l), 1));
            sx_i = _mm256_add_epi32(sx_i, _mm256_sub_epi32(bot_r, bot_l));

            __m256i sy_i = _mm256_sub_epi32(bot_l, top_l);
            sy_i = _mm256_sub_epi32(sy_i, _mm256_slli_epi32(top_c, 1));
            sy_i = _mm256_sub_epi32(sy_i, top_r);
            sy_i = _mm256_add_epi32(sy_i, _mm256_slli_epi32(bot_c, 1));
            sy_i = _mm256_add_epi32(sy_i, bot_r);

            __m256 sx = _mm256_cvtepi32_ps(sx_i);
            __m256 sy = _mm256_cvtepi32_ps(sy_i);
            __m256 mag_v = _mm256_sqrt_ps(_mm256_add_ps(_mm256_mul_ps(sx, sx), _mm256_mul_ps(sy, sy)));

            int magdir_idx = (y - 1) * (w - 2) + (x - 1);
            _mm256_storeu_ps(mag + magdir_idx, mag_v);

            alignas(32) float sx_arr[8];
            alignas(32) float sy_arr[8];
            _mm256_store_ps(sx_arr, sx);
            _mm256_store_ps(sy_arr, sy);
            for (int lane = 0; lane < 8; ++lane)
            {
                dir[magdir_idx + lane] = std::atan2(sy_arr[lane], sx_arr[lane]);
            }
        }

        for (; x < w - 1; ++x)
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
    constexpr int NUM_SECTIONS = 8;
    double times[NUM_SECTIONS];

    MPI_Barrier(MPI_COMM_WORLD);
    double t_total_start = MPI_Wtime();

    // double t_setup_start = MPI_Wtime();
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
    std::vector<float> mag(local_magdir_size);
    std::vector<float> dir(local_magdir_size);

    times[0] = MPI_Wtime() - t_total_start;

    double t_read_start = MPI_Wtime();
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
    times[1] = MPI_Wtime() - t_read_start;

    double t_send_start = MPI_Wtime();

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
            MPI_Isend(local_in.data() + width, width, MPI_UINT8_T, up, FROM_DOWN_TO_UP, MPI_COMM_WORLD, &reqs[n_reqs++]);
        }

        if (down < active_ranks)
        {
            MPI_Irecv(local_in.data() + (my_rows + 1) * width, width, MPI_UINT8_T, down, FROM_DOWN_TO_UP, MPI_COMM_WORLD, &reqs[n_reqs++]);
            MPI_Isend(local_in.data() + my_rows * width, width, MPI_UINT8_T, down, FROM_UP_TO_DOWN, MPI_COMM_WORLD, &reqs[n_reqs++]);
        }
    }
    times[2] = MPI_Wtime() - t_send_start;
    double t_local_comp_start = MPI_Wtime();
    if (is_active)
    {
        // COMPUTE INTERIOR ROWS
        if (my_rows > 2)
            sobel(local_in.data(), width, mag.data(), dir.data(),
                  2, my_rows); // [2: my_rows]: safe, no ghost dependency
    }
    times[3] = MPI_Wtime() - t_local_comp_start;

    double t_wait_start = MPI_Wtime();
    // Wait for halo exchange to complete before touching boundary rows
    MPI_Waitall(n_reqs, reqs, MPI_STATUSES_IGNORE);
    times[4] = MPI_Wtime() - t_wait_start;

    double t_halo_comp_start = MPI_Wtime();
    //  COMPUTE HALO
    if (is_active)
    {
        if (rank > 0)
        {
            sobel(local_in.data(), width, mag.data(), dir.data(), 1, 2);
        }
        if ((rank + 1) < active_ranks)
        {
            sobel(local_in.data(), width, mag.data(), dir.data(), my_rows - 1, my_rows + 1);
        }
    }
    times[5] = MPI_Wtime() - t_halo_comp_start;

    double t_write_start = MPI_Wtime();
    // WRITE
    MPI_File_open(MPI_COMM_WORLD, argv[2],
                  MPI_MODE_CREATE | MPI_MODE_WRONLY,
                  MPI_INFO_NULL, &fh);

    if (is_active)
    {

        bool is_last = (rank + 1 == active_ranks);
        bool is_first = (rank == 0);

        int out_w = width - 2;
        int out_h = base_rows;
        if (is_first)
            out_h -= 1;
        if (is_last)
            out_h -= 1;
        // std::cout << out_w << ", " << out_h << "\n";
        size_t writeout_count = (size_t)out_h * out_w;
        // std::cout << writeout_count << "\n";

        int file_offset_row = start_row;
        if (!is_first)
            file_offset_row -= 1;
        size_t file_offset = (size_t)file_offset_row * out_w * sizeof(float);
        // std::cout << file_offset_row * out_w << "\n";

        float *mag_ptr = mag.data() + (is_first ? out_w : 0);
        float *dir_ptr = dir.data() + (is_first ? out_w : 0);
        // std::cout << mag.size() << "; " << out_w * base_rows << "\n";
        // std::cout << (is_first ? out_w: 0) << std::endl;

        MPI_File_write_at(fh, file_offset,
                          mag_ptr, writeout_count,
                          MPI_FLOAT, MPI_STATUS_IGNORE);
        MPI_File_write_at(fh, file_offset + static_cast<MPI_Offset>(out_w) * (height - 2) * sizeof(float),
                          dir_ptr, writeout_count,
                          MPI_FLOAT, MPI_STATUS_IGNORE);
    }
    MPI_File_close(&fh);
    times[6] = MPI_Wtime() - t_write_start;
    MPI_Barrier(MPI_COMM_WORLD);
    times[7] = MPI_Wtime() - t_total_start;

    MPI_Comm active_comm;
    MPI_Comm_split(MPI_COMM_WORLD, is_active ? 0 : MPI_UNDEFINED, rank, &active_comm);

    if (is_active)
    {
        int active_size;
        MPI_Comm_size(active_comm, &active_size);

        double t_min[NUM_SECTIONS], t_max[NUM_SECTIONS], t_sum[NUM_SECTIONS];

        MPI_Reduce(times, t_min, NUM_SECTIONS, MPI_DOUBLE, MPI_MIN, 0, active_comm);
        MPI_Reduce(times, t_max, NUM_SECTIONS, MPI_DOUBLE, MPI_MAX, 0, active_comm);
        MPI_Reduce(times, t_sum, NUM_SECTIONS, MPI_DOUBLE, MPI_SUM, 0, active_comm);
        int active_rank;
        MPI_Comm_rank(active_comm, &active_rank);

        if (active_rank == 0)
        {
            const char *names[] = {
                "Setup", "Read file", "Send requests", "Local comp",
                "Wait on resps", "Compute received", "Write out", "Total"};
            printf("%-20s;%10s;%10s;%10s\n", "Section", "Min(s)", "Max(s)", "Avg(s)");
            for (int i = 0; i < NUM_SECTIONS; i++)
            {
                printf("%-20s;%10.6f;%10.6f;%10.6f\n",
                       names[i], t_min[i], t_max[i], t_sum[i] / active_size);
            }
        }
        MPI_Comm_free(&active_comm);
    }
    MPI_Finalize();
}
