#include <mpi.h>
#include <vector>
#include <cmath>
#include <iostream>

#define MIN_ROWS 3

// Sobel kernel
void SISD_sobel(const uint8_t *local_in, int w,
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

#include <immintrin.h>
// #include <fstream>

#define MIN_ROWS 3
#define MIN_COLS 3

// Sobel kernel
static inline __m256i load_u8x8_to_i32(const uint8_t *ptr)
{
    return _mm256_cvtepu8_epi32(_mm_loadl_epi64(reinterpret_cast<const __m128i *>(ptr)));
}

// we shrink the range to [0,1]
// we store the sign and use atan(-t) = atan(t)
// we use for t > 1; atan(x) = pi/2 - atan(1/t)
// and we manually handle 0s

//15th deg approx of atan2
static inline __attribute__((target("avx2,fma")))  __m256 avx2_atan2_15deg_ps(__m256 y, __m256 x)
{
    const __m256 pi        = _mm256_set1_ps( 3.14159265358979f);
    const __m256 pi_2      = _mm256_set1_ps( 1.57079632679490f);
    const __m256 zero      = _mm256_setzero_ps();
    const __m256 one       = _mm256_set1_ps(1.0f);
    const __m256 sign_mask = _mm256_set1_ps(-0.0f);   // 0x80000000

    __m256 ax = _mm256_andnot_ps(sign_mask, x);   // |x|
    __m256 ay = _mm256_andnot_ps(sign_mask, y);   // |y|
    __m256 x_neg = _mm256_cmp_ps(x, zero, _CMP_LT_OQ);  // x < 0
    __m256 y_neg = _mm256_cmp_ps(y, zero, _CMP_LT_OQ);  // y < 0

    // swap = (ay > ax),  t = min/max
    __m256 swap  = _mm256_cmp_ps(ay, ax, _CMP_GT_OQ);
    __m256 t_num = _mm256_blendv_ps(ay, ax, swap);   // min(ax,ay) 
    __m256 t_den = _mm256_blendv_ps(ax, ay, swap);   // max(ax,ay)

    // no div by 0: if den==0 (then num==0; so t=0/1), t=0
    __m256 den_nz = _mm256_cmp_ps(t_den, zero, _CMP_NEQ_OQ);
    __m256 t = _mm256_div_ps(t_num, _mm256_blendv_ps(one, t_den, den_nz)); 

    // polynomial atan(t) for t in [0,1]
    // https://blasingame.engr.tamu.edu/z_zCourse_Archive/P620_18C/P620_zReference/PDF_Txt_Hst_Apr_Cmp_(1955).pdf
    // page 137
    const __m256 a1 = _mm256_set1_ps( 0.99999'93329f);
    const __m256 a3 = _mm256_set1_ps(-0.33329'85605f);
    const __m256 a5 = _mm256_set1_ps( 0.19946'53599f);
    const __m256 a7 = _mm256_set1_ps(-0.13908'53351f);
    const __m256 a9 = _mm256_set1_ps( 0.09642'00441f);
    const __m256 a11= _mm256_set1_ps(-0.05590'98861f);
    const __m256 a13= _mm256_set1_ps( 0.02186'12288f);  
    const __m256 a15= _mm256_set1_ps(-0.00405'40580f);  


    __m256 t2 = _mm256_mul_ps(t, t);

    // (...((a15)t^2  +a13)t^2 ... + a1)*t 
    __m256 p = a15;
    p = _mm256_fmadd_ps(p, t2, a13);
    p = _mm256_fmadd_ps(p, t2, a11);
    p = _mm256_fmadd_ps(p, t2, a9);
    p = _mm256_fmadd_ps(p, t2, a7);
    p = _mm256_fmadd_ps(p, t2, a5);
    p = _mm256_fmadd_ps(p, t2, a3);
    p = _mm256_fmadd_ps(p, t2, a1);
    p = _mm256_mul_ps(p, t);   // atan(t) \in [0, pi/4]

    // If we swapped (|y|>|x|), atan(t) -> pi/2 - atan(t)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi_2, p), swap);

    // If x < 0: atan -> pi - atan  (we're in Q2 or Q3)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi, p), x_neg);

    // Restore sign from y
    __m256 y_sign = _mm256_and_ps(y, sign_mask);
    p = _mm256_xor_ps(p, y_sign);

    return p;
}

// 11-th deg approx of atan2
static inline __attribute__((target("avx2,fma")))  __m256 avx2_atan2_11deg_ps(__m256 y, __m256 x)
{
    const __m256 pi        = _mm256_set1_ps( 3.14159265358979f);
    const __m256 pi_2      = _mm256_set1_ps( 1.57079632679490f);
    const __m256 zero      = _mm256_setzero_ps();
    const __m256 one       = _mm256_set1_ps(1.0f);
    const __m256 sign_mask = _mm256_set1_ps(-0.0f);   // 0x80000000

    __m256 ax = _mm256_andnot_ps(sign_mask, x);   // |x|
    __m256 ay = _mm256_andnot_ps(sign_mask, y);   // |y|
    __m256 x_neg = _mm256_cmp_ps(x, zero, _CMP_LT_OQ);  // x < 0
    __m256 y_neg = _mm256_cmp_ps(y, zero, _CMP_LT_OQ);  // y < 0

    // swap = (ay > ax),  t = min/max
    __m256 swap  = _mm256_cmp_ps(ay, ax, _CMP_GT_OQ);
    __m256 t_num = _mm256_blendv_ps(ay, ax, swap);   // min(ax,ay) 
    __m256 t_den = _mm256_blendv_ps(ax, ay, swap);   // max(ax,ay)

    // no div by 0: if den==0 (then num==0; so t=0/1), t=0
    __m256 den_nz = _mm256_cmp_ps(t_den, zero, _CMP_NEQ_OQ);
    __m256 t = _mm256_div_ps(t_num, _mm256_blendv_ps(one, t_den, den_nz));

    // https://blasingame.engr.tamu.edu/z_zCourse_Archive/P620_18C/P620_zReference/PDF_Txt_Hst_Apr_Cmp_(1955).pdf
    // p135
    const __m256 a1 = _mm256_set1_ps( 0.9999'7726f);
    const __m256 a3 = _mm256_set1_ps(-0.3326'2347f);
    const __m256 a5 = _mm256_set1_ps( 0.1935'4346f);
    const __m256 a7 = _mm256_set1_ps(-0.1164'3287f);
    const __m256 a9 = _mm256_set1_ps( 0.0526'5332f);
    const __m256 a11= _mm256_set1_ps(-0.0117'2120f);  

    __m256 t2 = _mm256_mul_ps(t, t);
    // evaluated as: ((((a11*t2 + a9)*t2 + a7)*t2 + a5)*t2 + a3)*t2 + a1) * t
    __m256 p = a11;
    p = _mm256_fmadd_ps(p, t2, a9);
    p = _mm256_fmadd_ps(p, t2, a7);
    p = _mm256_fmadd_ps(p, t2, a5);
    p = _mm256_fmadd_ps(p, t2, a3);
    p = _mm256_fmadd_ps(p, t2, a1);
    p = _mm256_mul_ps(p, t);   // atan(t) \in [0, pi/4]

    // If we swapped (|y|>|x|), atan(t) -> pi/2 - atan(t)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi_2, p), swap);

    // If x < 0: atan -> pi - atan  (we're in Q2 or Q3)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi, p), x_neg);

    // Restore sign from y
    __m256 y_sign = _mm256_and_ps(y, sign_mask);
    p = _mm256_xor_ps(p, y_sign);

    return p;
}

// 5-th deg approx of atan2
static inline __attribute__((target("avx2,fma")))  __m256 avx2_atan2_5deg_ps(__m256 y, __m256 x)
{
    // https://blasingame.engr.tamu.edu/z_zCourse_Archive/P620_18C/P620_zReference/PDF_Txt_Hst_Apr_Cmp_(1955).pdf
    // 132
    const __m256 pi        = _mm256_set1_ps( 3.14159265358979f);
    const __m256 pi_2      = _mm256_set1_ps( 1.57079632679490f);
    const __m256 zero      = _mm256_setzero_ps();
    const __m256 one       = _mm256_set1_ps(1.0f);
    const __m256 sign_mask = _mm256_set1_ps(-0.0f);   // 0x80000000

    __m256 ax = _mm256_andnot_ps(sign_mask, x);   // |x|
    __m256 ay = _mm256_andnot_ps(sign_mask, y);   // |y|
    __m256 x_neg = _mm256_cmp_ps(x, zero, _CMP_LT_OQ);  // x < 0
    __m256 y_neg = _mm256_cmp_ps(y, zero, _CMP_LT_OQ);  // y < 0

    // swap = (ay > ax),  t = min/max
    __m256 swap  = _mm256_cmp_ps(ay, ax, _CMP_GT_OQ);
    __m256 t_num = _mm256_blendv_ps(ay, ax, swap);   // min(ax,ay) 
    __m256 t_den = _mm256_blendv_ps(ax, ay, swap);   // max(ax,ay)

    // no div by 0: if den==0 (then num==0; so t=0/1), t=0
    __m256 den_nz = _mm256_cmp_ps(t_den, zero, _CMP_NEQ_OQ);
    __m256 t = _mm256_div_ps(t_num, _mm256_blendv_ps(one, t_den, den_nz));

    // polynomial atan(t) for t in [0,1]
    const __m256 a1 = _mm256_set1_ps( 0.995354f);
    const __m256 a3 = _mm256_set1_ps(-0.288679f);
    const __m256 a5 = _mm256_set1_ps( 0.079331f);

    __m256 t2 = _mm256_mul_ps(t, t);
    // evaluated as: ((((a11*t2 + a9)*t2 + a7)*t2 + a5)*t2 + a3)*t2 + a1) * t
    __m256 p = a5;
    p = _mm256_fmadd_ps(p, t2, a3);
    p = _mm256_fmadd_ps(p, t2, a1);
    p = _mm256_mul_ps(p, t);   // atan(t) \in [0, pi/4]

    // If we swapped (|y|>|x|), atan(t) -> pi/2 - atan(t)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi_2, p), swap);

    // If x < 0: atan -> pi - atan  (we're in Q2 or Q3)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi, p), x_neg);

    // Restore sign from y
    __m256 y_sign = _mm256_and_ps(y, sign_mask);
    p = _mm256_xor_ps(p, y_sign);

    return p;
}

// 2-deg approx of atan2
static inline __attribute__((target("avx2,fma")))  __m256 avx2_atan2_2deg_ps(__m256 y, __m256 x)
{
    const __m256 pi        = _mm256_set1_ps( 3.14159265358979f);
    const __m256 pi_2      = _mm256_set1_ps( 1.57079632679490f);
    const __m256 zero      = _mm256_setzero_ps();
    const __m256 one       = _mm256_set1_ps(1.0f);
    const __m256 sign_mask = _mm256_set1_ps(-0.0f);   // 0x80000000

    __m256 ax = _mm256_andnot_ps(sign_mask, x);   // |x|
    __m256 ay = _mm256_andnot_ps(sign_mask, y);   // |y|
    __m256 x_neg = _mm256_cmp_ps(x, zero, _CMP_LT_OQ);  // x < 0
    __m256 y_neg = _mm256_cmp_ps(y, zero, _CMP_LT_OQ);  // y < 0

    // swap = (ay > ax),  t = min/max
    __m256 swap  = _mm256_cmp_ps(ay, ax, _CMP_GT_OQ);
    __m256 t_num = _mm256_blendv_ps(ay, ax, swap);   // min(ax,ay) 
    __m256 t_den = _mm256_blendv_ps(ax, ay, swap);   // max(ax,ay)

    // no div by 0: if den==0 (then num==0; so t=0/1), t=0
    __m256 den_nz = _mm256_cmp_ps(t_den, zero, _CMP_NEQ_OQ);
    __m256 t = _mm256_div_ps(t_num, _mm256_blendv_ps(one, t_den, den_nz));

    //https://www-labs.iro.umontreal.ca/~mignotte/IFT2425/Documents/EfficientApproximationArctgFunction.pdf
    // atan(t) ~ (pi/4)*t + 0.273*t*(1 - t) = t(pi/4 + 0.273 - t*0.273)
    const __m256 c         = _mm256_set1_ps(0.273f);  
    const __m256 pi_4_plus_c = _mm256_set1_ps(0.7853981634f + 0.273f);

    __m256 p = _mm256_mul_ps(t, _mm256_fnmadd_ps(c, t, pi_4_plus_c)); 

    // If we swapped (|y|>|x|), atan(t) -> pi/2 - atan(t)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi_2, p), swap);

    // If x < 0: atan -> pi - atan  (we're in Q2 or Q3)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi, p), x_neg);

    // Restore sign from y
    __m256 y_sign = _mm256_and_ps(y, sign_mask);
    p = _mm256_xor_ps(p, y_sign);

    return p;
}

// linear_approx
static inline __attribute__((target("avx2,fma")))  __m256 avx2_atan2_1deg_ps(__m256 y, __m256 x)
{
    const __m256 pi        = _mm256_set1_ps( 3.14159265358979f);
    const __m256 pi_2      = _mm256_set1_ps( 1.57079632679490f);
    const __m256 zero      = _mm256_setzero_ps();
    const __m256 one       = _mm256_set1_ps(1.0f);
    const __m256 sign_mask = _mm256_set1_ps(-0.0f);   // 0x80000000

    __m256 ax = _mm256_andnot_ps(sign_mask, x);   // |x|
    __m256 ay = _mm256_andnot_ps(sign_mask, y);   // |y|
    __m256 x_neg = _mm256_cmp_ps(x, zero, _CMP_LT_OQ);  // x < 0
    __m256 y_neg = _mm256_cmp_ps(y, zero, _CMP_LT_OQ);  // y < 0

    // swap = (ay > ax),  t = min/max
    __m256 swap  = _mm256_cmp_ps(ay, ax, _CMP_GT_OQ);
    __m256 t_num = _mm256_blendv_ps(ay, ax, swap);   // min(ax,ay) 
    __m256 t_den = _mm256_blendv_ps(ax, ay, swap);   // max(ax,ay)

    // no div by 0: if den==0 (then num==0; so t=0/1), t=0
    __m256 den_nz = _mm256_cmp_ps(t_den, zero, _CMP_NEQ_OQ);
    __m256 t = _mm256_div_ps(t_num, _mm256_blendv_ps(one, t_den, den_nz));

    // https://www-labs.iro.umontreal.ca/~mignotte/IFT2425/Documents/EfficientApproximationArctgFunction.pdf
    // atan(t) ~ (pi/4)*t
    const __m256 pi_4 = _mm256_set1_ps(0.7853981634f);

    __m256 p = _mm256_mul_ps(t, pi_4); 

    // If we swapped (|y|>|x|), atan(t) -> pi/2 - atan(t)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi_2, p), swap);

    // If x < 0: atan -> pi - atan  (we're in Q2 or Q3)
    p = _mm256_blendv_ps(p, _mm256_sub_ps(pi, p), x_neg);

    // Restore sign from y
    __m256 y_sign = _mm256_and_ps(y, sign_mask);
    p = _mm256_xor_ps(p, y_sign);

    return p;
}


void sobel(const uint8_t *local_in, int w,
           float *mag, float *dir,
           int y_start, int y_end,
           int x_start, int x_end)
{
    for (int y = y_start; y < y_end; ++y)
    {
        int x = x_start;
        for (; x <= x_end - 8; x += 8)
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

            __m256 dir_v = avx2_atan2_1deg_ps(sy, sx);
            _mm256_storeu_ps(dir + magdir_idx, dir_v);

        }

        for (; x < x_end; ++x)
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
    std::vector<float> mag(local_magdir_size, NAN);
    std::vector<float> dir(local_magdir_size, NAN);

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
            sobel(
                local_in.data(), width, mag.data(), dir.data(),
                2, my_rows, 
                1, width-1
            ); // [2: my_rows]: safe, no ghost dependency
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
            sobel(
                local_in.data(), width, mag.data(), dir.data(), 
                1, 2, 
                1, width-1
            );  
        }
        if ((rank + 1) < active_ranks)
        {
            sobel(
                local_in.data(), width, mag.data(), dir.data(), 
                my_rows - 1, my_rows + 1,
                1, width-1
            );
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