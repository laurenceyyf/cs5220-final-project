#include <mpi.h>
#include <vector>
#include <cmath>
#include <iostream>
#include <algorithm>
#include <fstream>

#define MIN_ROWS 3
#define MIN_COLS 3

// ---------------------------------------------------------------------------
// Sobel kernel
//
// local_in  : halo buffer, (my_rows+2) x (local_w) in row-major order
//             row 0         = top ghost row
//             rows 1..my_rows = real data
//             row my_rows+1 = bottom ghost row
//             col 0              = left ghost col
//             cols 1..my_cols    = real data
//             col my_cols+1      = right ghost col
// local_w   : my_cols + 2  (full buffer stride)
// mag / dir : output arrays, my_rows x my_cols, row-major
//
// [y_start, y_end) are coordinates inside local_in (1-based, i.e. y=1 is the
// first real row). [x_start, x_end) are likewise 1-based.
// ---------------------------------------------------------------------------
void sobel(const uint8_t *local_in, int local_w,
           float *mag, float *dir, int out_cols,
           int y_start, int y_end,
           int x_start, int x_end)
{
    for (int y = y_start; y < y_end; ++y)
    {
        for (int x = x_start; x < x_end; ++x)
        {
            int i = y * local_w + x;

            int32_t sx =
                -local_in[i - local_w - 1] + local_in[i - local_w + 1]
                - 2 * local_in[i - 1]       + 2 * local_in[i + 1]
                - local_in[i + local_w - 1] + local_in[i + local_w + 1];

            int32_t sy =
                -local_in[i - local_w - 1] - 2 * local_in[i - local_w] - local_in[i - local_w + 1]
                + local_in[i + local_w - 1] + 2 * local_in[i + local_w] + local_in[i + local_w + 1];

            // Map (y,x) in local_in → (y-1, x-1) in output
            int out_idx = (y - 1) * out_cols + (x - 1);
            mag[out_idx] = std::sqrt(static_cast<float>(sx * sx + sy * sy));
            dir[out_idx] = std::atan2(static_cast<float>(sy), static_cast<float>(sx));
        }
    }
}

// ---------------------------------------------------------------------------
// Inline index helper: row-major into halo buffer
// ---------------------------------------------------------------------------
static inline int LI(int y, int x, int local_w) { return y * local_w + x; }

int main(int argc, char **argv)
{
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    const int height  = std::stoi(argv[3]);
    const int width = std::stoi(argv[4]);

    // -----------------------------------------------------------------------
    // 1. Choose a 2-D process grid
    //    Clamp active_ranks so every tile has at least MIN_ROWS x MIN_COLS px.
    // -----------------------------------------------------------------------
    int max_ranks_r = height / MIN_ROWS;
    int max_ranks_c = width  / MIN_COLS;
    int active_ranks = std::min(size, max_ranks_r * max_ranks_c);

    // MPI_Dims_create wants dims[] pre-initialised to 0 for "choose for me"
    int dims[2] = {0, 0};
    MPI_Dims_create(active_ranks, 2, dims);
    // dims[0] = process-rows, dims[1] = process-cols

    // After Dims_create re-clamp: don't allow more proc-rows/cols than tiles
    dims[0] = std::min(dims[0], max_ranks_r);
    dims[1] = std::min(dims[1], max_ranks_c);
    active_ranks = dims[0] * dims[1];

    bool is_active = (rank < active_ranks);

    // -----------------------------------------------------------------------
    // 2. Build Cartesian communicator (non-periodic, no reorder)
    // -----------------------------------------------------------------------
    MPI_Comm cart_comm = MPI_COMM_NULL;
    int periods[2] = {0, 0};
    // All ranks call this; inactive ranks pass MPI_COMM_NULL after the split.
    // Easiest: create the cart over a sub-communicator of the active ranks.
    MPI_Comm active_comm;
    MPI_Comm_split(MPI_COMM_WORLD, is_active ? 0 : MPI_UNDEFINED, rank, &active_comm);

    int coords[2] = {0, 0};
    if (is_active)
    {
        MPI_Cart_create(active_comm, 2, dims, periods, /*reorder=*/0, &cart_comm);
        MPI_Cart_coords(cart_comm, rank, 2, coords);
        // Note: after reorder=0, rank in cart_comm == rank in active_comm
    }

    // -----------------------------------------------------------------------
    // 3. Tile assignment: same remainder-spread logic as the 1-D version,
    //    applied independently to rows and columns.
    // -----------------------------------------------------------------------
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

    // Halo buffer dimensions: real tile + 1-px ghost border on all four sides
    int local_h = my_rows + 2;   // rows in halo buffer (0=top ghost, my_rows+1=bot ghost)
    int local_w = my_cols + 2;   // cols in halo buffer (0=left ghost, my_cols+1=right ghost)

    std::vector<uint8_t> local_in(is_active ? local_h * local_w : 0, 255);

    int out_cols = my_cols;      // output tile width (no border pixels)
    int local_magdir_size = my_rows * out_cols;
    std::vector<float> mag(local_magdir_size, NAN);
    std::vector<float> dir(local_magdir_size, NAN);

    // -----------------------------------------------------------------------
    // 4. MPI-IO: read this rank's tile from the raw image file.
    //    The file is a flat width*height uint8 raster (row-major).
    //    We use MPI_Type_create_subarray so the MPI-IO layer can optimise
    //    the access pattern collectively.
    // -----------------------------------------------------------------------
    MPI_File fh;
    MPI_File_open(cart_comm, argv[1], MPI_MODE_RDONLY, MPI_INFO_NULL, &fh);

    if (is_active)
    {
        // Describe the full file as a 2-D array [height][width]
        int gsizes[2]  = {height, width};
        // Our sub-array starts at (start_row, start_col) and is my_rows x my_cols
        int subsizes[2] = {my_rows, my_cols};
        int starts[2]   = {start_row, start_col};

        MPI_Datatype filetype;
        MPI_Type_create_subarray(2, gsizes, subsizes, starts,
                                 MPI_ORDER_C, MPI_UINT8_T, &filetype);
        MPI_Type_commit(&filetype);

        // Memory type: halo buffer [local_h][local_w], data at (1,1)
        int mem_gsizes[2]  = {local_h, local_w};
        int mem_subsizes[2] = {my_rows, my_cols};
        int mem_starts[2]   = {1, 1};   // skip the ghost border

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

    std::ofstream out("../data/local_in.bin", std::ios::binary);

    out.write(
        reinterpret_cast<const char*>(local_in.data()),
        local_in.size()
    );

    out.close();
    // -----------------------------------------------------------------------
    // 5. Build MPI_Type_vector for non-contiguous left/right column sends.
    //    Column halo = my_rows elements spaced local_w apart.
    // -----------------------------------------------------------------------

    // col_type: a single ghost column's worth of data from local_in
    MPI_Datatype col_type = MPI_DATATYPE_NULL;
    if (is_active)
    {
        MPI_Type_vector(my_rows, /*count=*/1, /*stride=*/local_w,
                        MPI_UINT8_T, &col_type);
        MPI_Type_commit(&col_type);
    }

    // -----------------------------------------------------------------------
    // 6. Async halo exchange: post all 16 non-blocking ops (up to) at once,
    //    then overlap with interior compute, then Waitall once.
    //
    //    Neighbours via MPI_Cart_shift (returns MPI_PROC_NULL if no neighbour).
    //
    //    Tag scheme — each directional send has a unique tag so matching is
    //    unambiguous even when the grid is non-square:
    //      TAG_U2D : top rank sends its bottom row  → bottom rank's top ghost
    //      TAG_D2U : bottom rank sends its top row  → top rank's bottom ghost
    //      TAG_L2R : left rank sends its right col  → right rank's left ghost
    //      TAG_R2L : right rank sends its left col  → left rank's right ghost
    //    Corner (diagonal) sends carry a combined tag.
    // -----------------------------------------------------------------------
    constexpr int TAG_U2D = 10, TAG_D2U = 11;
    constexpr int TAG_L2R = 20, TAG_R2L = 21;
    // Corner tags: NW→SE, NE→SW, SW→NE, SE→NW
    constexpr int TAG_NW2SE = 30, TAG_NE2SW = 31, TAG_SW2NE = 32, TAG_SE2NW = 33;

    // Max possible requests: 4 directions × 2 (send+recv) + 4 corners × 2 = 16
    MPI_Request reqs[16];
    int n_reqs = 0;

    if (is_active)
    {
        int up, down, left, right;
        MPI_Cart_shift(cart_comm, 0, 1, &up,   &down);   // axis 0 = row axis
        MPI_Cart_shift(cart_comm, 1, 1, &left, &right);  // axis 1 = col axis

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

        // --- Row halos (contiguous) ---
        // Top ghost row ← up's last data row
        if (up != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(0, 1, local_w)], my_cols, MPI_UINT8_T,
                      up, TAG_U2D, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, 1, local_w)], my_cols, MPI_UINT8_T,
                      up, TAG_D2U, cart_comm, &reqs[n_reqs++]);
        }
        // Bottom ghost row ← down's first data row
        if (down != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(my_rows + 1, 1, local_w)], my_cols, MPI_UINT8_T,
                      down, TAG_D2U, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(my_rows, 1, local_w)], my_cols, MPI_UINT8_T,
                      down, TAG_U2D, cart_comm, &reqs[n_reqs++]);
        }

        // --- Column halos (non-contiguous, use col_type) ---
        // Left ghost col ← left's last data col
        if (left != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(1, 0, local_w)], 1, col_type,
                      left, TAG_L2R, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, 1, local_w)], 1, col_type,
                      left, TAG_R2L, cart_comm, &reqs[n_reqs++]);
        }
        // Right ghost col ← right's first data col
        if (right != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(1, my_cols + 1, local_w)], 1, col_type,
                      right, TAG_R2L, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, my_cols, local_w)], 1, col_type,
                      right, TAG_L2R, cart_comm, &reqs[n_reqs++]);
        }

        // --- Corner halos (single byte each) ---
        // NW corner ghost ← NW neighbour's SE data pixel
        if (nw != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(0, 0, local_w)], 1, MPI_UINT8_T,
                      nw, TAG_NW2SE, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, 1, local_w)], 1, MPI_UINT8_T,
                      nw, TAG_SE2NW, cart_comm, &reqs[n_reqs++]);
        }
        // NE corner ghost ← NE neighbour's SW data pixel
        if (ne != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(0, my_cols + 1, local_w)], 1, MPI_UINT8_T,
                      ne, TAG_NE2SW, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(1, my_cols, local_w)], 1, MPI_UINT8_T,
                      ne, TAG_SW2NE, cart_comm, &reqs[n_reqs++]);
        }
        // SW corner ghost ← SW neighbour's NE data pixel
        if (sw != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(my_rows + 1, 0, local_w)], 1, MPI_UINT8_T,
                      sw, TAG_SW2NE, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(my_rows, 1, local_w)], 1, MPI_UINT8_T,
                      sw, TAG_NE2SW, cart_comm, &reqs[n_reqs++]);
        }
        // SE corner ghost ← SE neighbour's NW data pixel
        if (se != MPI_PROC_NULL) {
            MPI_Irecv(&local_in[LI(my_rows + 1, my_cols + 1, local_w)], 1, MPI_UINT8_T,
                      se, TAG_SE2NW, cart_comm, &reqs[n_reqs++]);
            MPI_Isend(&local_in[LI(my_rows, my_cols, local_w)], 1, MPI_UINT8_T,
                      se, TAG_NW2SE, cart_comm, &reqs[n_reqs++]);
        }

        // -----------------------------------------------------------------------
        // 7. Overlap: compute INTERIOR rows/cols while halo messages are in flight.
        //    Interior = rows 2..(my_rows-1), cols 2..(my_cols-1) in local_in
        //    coords — these pixels need none of the ghost border.
        // -----------------------------------------------------------------------
        if (my_rows > 2 && my_cols > 2)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(), out_cols,
                  /*y*/ 2, my_rows,
                  /*x*/ 2, my_cols);
    }

    // Wait for all halo messages before touching any boundary row/col
    MPI_Waitall(n_reqs, reqs, MPI_STATUSES_IGNORE);

    // -----------------------------------------------------------------------
    // 8. Compute boundary rows/cols that depend on ghost data.
    //    We break it into the four edges and four corners to avoid recomputing
    //    pixels computed in the interior pass.
    //
    //    Local_in layout reminder:
    //      y=0            top ghost row
    //      y=1            first real row   ← top edge
    //      y=2..my_rows-1 interior rows    (already done)
    //      y=my_rows      last real row    ← bottom edge
    //      y=my_rows+1    bottom ghost row
    //      x=0            left ghost col
    //      x=1            first real col   ← left edge
    //      x=2..my_cols-1 interior cols    (already done)
    //      x=my_cols      last real col    ← right edge
    //      x=my_cols+1    right ghost col
    // -----------------------------------------------------------------------
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
        // std::cout << has_top << ", "<< has_bottom << ", "<< has_left << ", "<< has_right << std::endl;
        // --- Top edge row (y=1), interior cols only ---
        if (has_top)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(), out_cols,
                  1, 2,
                  has_left ? 2 : 1,
                  has_right ? my_cols : my_cols + 1);

        // --- Bottom edge row (y=my_rows), interior cols only ---
        if (has_bottom)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(), out_cols,
                  my_rows, my_rows + 1,
                  has_left ? 2 : 1,
                  has_right ? my_cols : my_cols + 1);

        // --- Left edge col (x=1), all rows ---
        if (has_left)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(), out_cols,
                  has_top ? 2 : 1,
                  has_bottom ? my_rows : my_rows + 1,
                  1, 2);

        // --- Right edge col (x=my_cols), all rows ---
        if (has_right)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(), out_cols,
                  has_top ? 2 : 1,
                  has_bottom ? my_rows : my_rows + 1,
                  my_cols, my_cols + 1);

        // --- Four corners: only if both adjacent edge neighbours exist ---
        if (has_top && has_left)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(), out_cols,
                  1, 2, 1, 2);
        if (has_top && has_right)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(), out_cols,
                  1, 2, my_cols, my_cols + 1);
        if (has_bottom && has_left)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(), out_cols,
                  my_rows, my_rows + 1, 1, 2);
        if (has_bottom && has_right)
            sobel(local_in.data(), local_w,
                  mag.data(), dir.data(), out_cols,
                  my_rows, my_rows + 1, my_cols, my_cols + 1);

        MPI_Type_free(&col_type);
    }

    // -----------------------------------------------------------------------
    // 9. MPI-IO write
    //    Output layout: two back-to-back planes of floats, each (height-2) x
    //    (width-2), same subarray approach as the read.
    //    Each rank writes my_rows x my_cols floats starting at
    //    (start_row, start_col) in the output plane.
    //    (Border pixels of the image have no Sobel output — the output plane
    //     is (height-2) x (width-2) and our tile's row/col in output space is
    //     still start_row, start_col since we process all pixels in our tile.)
    // -----------------------------------------------------------------------
    if (is_active) {
        std::string filename = "../data/" + std::to_string(rank) + "_magdir.bin";
        std::ofstream df(filename, std::ios::binary);

        if (df.is_open()) {
            // Write the entire mag vector (including potential boundary padding)
            df.write(reinterpret_cast<const char*>(mag.data()), 
                    mag.size() * sizeof(float));

            // Append the entire dir vector
            df.write(reinterpret_cast<const char*>(dir.data()), 
                    dir.size() * sizeof(float));

            df.close();
        } else {
            std::cerr << "Rank " << rank << " failed to open debug file!" << std::endl;
        }
    }   

    MPI_File_open(cart_comm, argv[2],
                  MPI_MODE_CREATE | MPI_MODE_WRONLY,
                  MPI_INFO_NULL, &fh);

    if (is_active)
    {
        // TODO double check 
        bool is_top = (coords[0] == 0); 
        bool is_bottom = (coords[0] == dims[0]-1);
        bool is_left = (coords[1] == 0);  
        bool is_right = (coords[1] == dims[1]-1); 

        int g_out_h = height - 2;
        int g_out_w = width  - 2;

        int local_cols = my_cols; 
        if(is_left) local_cols -= 1; if(is_right) local_cols -= 1; 
        int local_rows = my_rows; 
        if(is_top) local_rows -= 1; if(is_bottom) local_rows -= 1; 

        // Subarray type describing this rank's tile in the output plane
        int f_gsizes[2]   = {g_out_h, g_out_w};
        int f_subsizes[2] = {local_rows, local_cols};
        int f_starts[2]   = {
            is_top ? 0 : start_row - 1,
            is_left ? 0 : start_col - 1
        };
        std::cout<< "writeout " << g_out_h << " "<< g_out_w << " "<< local_rows << " "<< local_cols << " " << is_top << " " << is_left << "\n"; 
        MPI_Datatype out_tile_t;
        MPI_Type_create_subarray(2, f_gsizes, f_subsizes, f_starts,
                                 MPI_ORDER_C, MPI_FLOAT, &out_tile_t);
        MPI_Type_commit(&out_tile_t);
        MPI_Offset plane_bytes = static_cast<MPI_Offset>(g_out_h) * g_out_w * sizeof(float);

        int m_gsizes[2] = {my_rows, my_cols}; 
        int m_subsizes[2] = {local_rows, local_cols}; 
        int m_starts[2] = {is_top?1:0, is_left?1:0}; 
        std::cout<< "\t " << my_rows << " "<< my_cols << " "<< local_rows << " "<< local_cols << " " << is_top << " " << is_left << std::endl; 
        
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
