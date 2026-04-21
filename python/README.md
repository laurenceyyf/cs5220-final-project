# Python Utilities

This folder contains helper scripts for data preparation and correctness checking.

## What Each File Does

- `sticher.py`
  - main program of our python 
  - python stitcher.py [prefix for .img.bin and .magdir.bin file] [height in pixels] [width in pixels]
    - for clarity, we include the height and width as part of the file name
    - but the magdir.bin files have the original sizes, so asdf_100_200.magdir.bin is actually 98 by 198 pixels

- `sobel_reference.py`
  - Computes the reference Sobel output with NumPy.
  - This is the "correct answer" used for comparison.

- `check_output.py`
  - Compares a program output against the Python reference.
  - Prints error statistics and pass/fail.

## Data Format
- we are using fashion mnist as a source of greyscale images
- we stitch fashion mnist images together to create arbitrairly large images to test performance
- a .img.bin file represents a row major ordered array of uint8 representing a greyscale image
- a .magdir.bin file represents two  row major ordered arrays of float 32: an array of calculated magnitudes and an array of directions (in radians).
  - we then interpret this as hue and intensity to create a visualization of the output
## Typical Workflow

### 1. create files

```bash
python3 stitcher.py \
  .test_img \
  1000 \
  2000
```

This creates:

- image files like `test_image_1000_2000.img.bin`
- magnitude and direction files like `test_img_1000_2000.magdir.bin`

### 2. Test program

```bash
./my_program test_img_1000_2000.img.bin > my_program.out.magdir.bin
```
- my program should write out as a row major orderd array of magnitudes (float32) and an row major order array of directions (-pi, pi) (float32) 

### 3. Check a Program Output

```bash
python3 check_output.py \
  test_image_1000_2000.magdir.bin \
  my_program.out.magdir.bin \
  $((100-2)) \
  $((200-2))
```

This script:

1. reads the input image
2. reads the serial / MPI / CUDA output
3. compares the two arrays
