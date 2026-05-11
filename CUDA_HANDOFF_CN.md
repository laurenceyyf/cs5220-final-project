# CUDA 部分交接说明

这个文档是给组内同学看的，解释 `cs5220-final-project` 里 CUDA 部分做了什么、文件在哪里、实验怎么跑、结果图在哪里，以及报告里几个主要结论为什么成立。

## 1. 项目位置

CUDA 项目目录：

```bash
/global/homes/y/yz3526/CS5220/cs5220-final-project
```

主要 CUDA 代码在：

```text
cuda/
```

主要实验脚本和画图脚本在：

```text
tools/
```

主要实验结果在：

```text
data/cuda_benchmark/
figures/
```

## 2. CUDA 代码文件

### `cuda/kernel.h`

这里定义 CUDA kernel 的配置和 timing 结构。

重要内容：

- `CudaKernelVariant`
  - `NaiveExact`
  - `NaiveAtanApprox`
  - `SharedExact`
  - `SharedAtanApprox`
- `CudaAtanMethod`
  - `Exact`
  - `Approx1Deg`
  - `Approx2Deg`
  - `Approx5Deg`
  - `Approx11Deg`
  - `Approx15Deg`
- `CudaLaunchConfig`
  - block size
  - variant
  - atan method
  - 是否 copy output 回 host
  - GPU 数量
- `CudaTimingBreakdown`
  - `allocation_ms`
  - `h2d_ms`
  - `kernel_ms`
  - `d2h_ms`
  - `free_ms`
  - `cuda_section_ms`

### `cuda/kernel.cu`

这里是 CUDA kernel 的核心实现。

主要实现了两个 kernel：

1. naive kernel
   - 每个 CUDA thread 计算一个 output pixel。
   - 每个 thread 直接从 global memory 读取 3 x 3 input stencil。
   - 依赖 GPU cache 自动利用相邻 stencil 的重叠输入。

2. shared-memory kernel
   - 每个 CUDA block 先把 input tile 加 halo 加载到 shared memory。
   - 然后 `__syncthreads()`。
   - 每个 thread 从 shared memory 里读 3 x 3 stencil。
   - 这个版本是为了测试显式 shared memory tiling 是否比 cache 更好。

这里也实现了不同的 atan2 方向计算方法：

- `Exact`
  - 直接调用 CUDA 的 `atan2f(sum_y, sum_x)`。
- `Approx1Deg`
  - 简单线性近似。
- `Approx2Deg`
  - 项目里原来的 atan approximation。
- `Approx5Deg`
  - 低阶 polynomial approximation。
- `Approx11Deg`
  - 11th-degree polynomial approximation。
- `Approx15Deg`
  - 15th-degree polynomial approximation。

注意：`approx_15deg` 不是“误差 15 度”，而是近似公式最高项到 `t^15`，也就是 15th-degree polynomial approximation。

### `cuda/main.cpp`

这里是 CUDA executable 的 CLI 和 CSV 输出逻辑。

重要命令行参数：

```bash
--variant naive|atan_approx|shared|shared_atan_approx
--atan-method exact|approx_1deg|approx_2deg|approx_5deg|approx_11deg|approx_15deg
--block 16x16
--warmup N
--repeats N
--csv PATH
--csv-append
--no-output-write
--skip-d2h
--measure-error
```

其中：

- `--measure-error` 会在 timed runs 之后，用 CPU exact atan2 计算方向误差。
- 误差计算不进入 CUDA timing，所以不会污染 kernel/H2D/D2H 时间。
- `--no-output-write` 会跳过把输出写到文件，避免文件系统 I/O 影响实验。

### `cuda/cuda_job`

Slurm job 脚本。后来主要改用 interactive GPU node 跑，所以这个脚本不是主路线，但保留了批量 sweep 的配置。

## 3. 实验脚本

### `tools/cuda_profile_sweep.py`

这是最主要的 CUDA benchmark 脚本。

它会：

1. 生成 input image。
2. 编译或复用 CUDA binary。
3. 对多个 variant / atan method / block shape 重复运行。
4. 把 timing 写入 CSV。

常用参数：

```bash
--width 32768
--height 32768
--variants naive shared
--atan-methods exact approx_1deg approx_2deg approx_15deg
--blocks 8x8 16x16 32x8 32x16
--repeats 5
--warmup 1
--measure-error
--skip-build
```

### `tools/plot_cuda_benchmark.py`

从 CSV 生成 CUDA benchmark 图。

主要生成：

- block shape scaling 图
- runtime breakdown 图
- variant comparison 图

### `tools/plot_cuda_roofline.py`

这是早期自己估算 roofline 的脚本。

最后报告里主要使用 Nsight Compute roofline，而不是这个脚本的 hand-counted roofline。这个脚本可以保留作为 sanity check，但不是主证据。

## 4. 主要实验怎么跑

### 4.1 登录 GPU interactive node

```bash
salloc --nodes 1 --qos interactive --time 00:30:00 -C gpu -G 1 --account=m4341_g
```

确认 GPU：

```bash
nvidia-smi -L
```

进入项目：

```bash
cd /global/homes/y/yz3526/CS5220/cs5220-final-project
```

### 4.2 编译 CUDA

```bash
cmake -S cuda -B cuda/build
cmake --build cuda/build
```

确认 CLI：

```bash
cuda/build/sobel_cuda --help
```

### 4.3 4096 x 4096 accuracy sweep

这个实验主要用来测 atan approximation 的误差。

```bash
python3 tools/cuda_profile_sweep.py \
  --width 4096 \
  --height 4096 \
  --variants naive shared \
  --atan-methods exact approx_1deg approx_2deg approx_15deg \
  --blocks 8x8 16x16 32x8 32x16 \
  --repeats 5 \
  --warmup 1 \
  --measure-error
```

输出 CSV：

```text
data/cuda_benchmark/single_gpu/variant_block_shape_sweep/4096x4096/timings.csv
```

主要误差结果：

```text
exact         mean 0.000002 deg, max 0.000014 deg
approx_1deg  mean 1.349571 deg, max 4.074577 deg
approx_2deg  mean 0.081996 deg, max 0.215451 deg
approx_15deg mean 0.000002 deg, max 0.000027 deg
```

### 4.4 32768 x 32768 performance sweep

这个是报告里的主性能实验。

```bash
python3 tools/cuda_profile_sweep.py \
  --width 32768 \
  --height 32768 \
  --variants naive shared \
  --atan-methods exact approx_1deg approx_2deg approx_15deg \
  --blocks 8x8 16x16 32x8 32x16 \
  --repeats 5 \
  --warmup 1 \
  --skip-build
```

输出 CSV：

```text
data/cuda_benchmark/single_gpu/variant_block_shape_sweep/32768x32768/timings.csv
```

这个实验总共有：

```text
2 implementations x 4 atan methods x 4 block sizes x 5 repeats = 160 rows
```

检查 CSV 是否完整：

```bash
python3 - <<'PY'
import csv
from collections import Counter

p='data/cuda_benchmark/single_gpu/variant_block_shape_sweep/32768x32768/timings.csv'
rows=list(csv.DictReader(open(p)))
print('rows:', len(rows))
print(Counter((r['implementation'], r['atan_method']) for r in rows))
print(Counter((r['block_x'], r['block_y']) for r in rows))
PY
```

### 4.5 小图 sanity check

为了检查小图时 block shape 是否更明显，我们也跑过 512 x 512 naive exact。

```bash
python3 tools/cuda_profile_sweep.py \
  --width 512 \
  --height 512 \
  --variants naive \
  --atan-methods exact \
  --blocks 8x8 16x16 32x8 32x16 \
  --repeats 20 \
  --warmup 5 \
  --skip-build \
  --force-input
```

输出 CSV：

```text
data/cuda_benchmark/single_gpu/block_shape_sweep/512x512/timings.csv
```

结果：

```text
8x8    0.01588 ms
16x16  0.01598 ms
32x8   0.01561 ms
32x16  0.01570 ms
```

这个结果不作为主图，因为 kernel 时间只有约 0.016 ms，已经非常接近 timing noise 和 fixed overhead。

## 5. 图在哪里

报告中建议使用这些图。

### 5.1 Sobel stencil overlap

```text
figures/cuda_stencil_overlap.png
```

用途：

- 放在 CUDA implementation 的 naive kernel 部分。
- 解释两个相邻 output pixels 的 3 x 3 stencil 有 6 个 input pixels 重叠。
- 支持 naive kernel 可以依赖 cache locality。

### 5.2 Naive block-size sensitivity

```text
figures/cuda_naive_block_size.png
```

用途：

- 放在 CUDA block-size sensitivity 部分。
- 说明 naive exact kernel 在不同 block shapes 下变化很小。

关键数据：

```text
8x8    13.45 ms
16x16  13.54 ms
32x8   13.58 ms
32x16  13.55 ms
spread 0.96%
```

### 5.3 Shared memory vs naive

```text
figures/cuda_shared_vs_naive.png
```

用途：

- 放在 shared-memory tiling 部分。
- 说明 shared memory 没有帮助，反而变慢。

关键数据：

```text
naive exact best:  13.45 ms
shared exact best: 21.03 ms
shared slower by:  56.3%
```

### 5.4 Runtime breakdown

```text
figures/cuda_runtime_breakdown_best_naive.png
```

用途：

- 放在 runtime breakdown 部分。
- 说明 standalone CUDA benchmark 中 H2D/D2H transfer 占主要时间。

关键数据：

```text
allocation: 5.46 ms
H2D:        296.71 ms
kernel:     13.45 ms
D2H:        645.16 ms
free:       13.13 ms
total:      973.96 ms
```

H2D + D2H 约占：

```text
96.7%
```

### 5.5 All variants summary

```text
data/cuda_benchmark/single_gpu/variant_block_shape_sweep/32768x32768/timings.cuda_variant_comparison.png
```

用途：

- 可以放在 CUDA summary / interpretation 部分。
- 总览所有 implementation、atan method、block shape。
- 不建议作为主证据，因为信息太多。

## 6. 主要结论怎么解释

### 6.1 为什么一个 thread 算一个 pixel

Sobel 的每个 output pixel 只依赖 input 里固定的 3 x 3 neighborhood。不同 output pixels 之间没有数据依赖，所以最自然的 CUDA mapping 是：

```text
one CUDA thread computes one output pixel
```

这样可以把所有 output pixels 并行展开。

### 6.2 为什么 block size 影响不大

在 32768 x 32768 图上，output pixels 超过 10 亿个。无论 block 是 8 x 8、16 x 16、32 x 8 还是 32 x 16，都会产生非常多 CUDA blocks 和 threads，所以 GPU 有足够 work 可以调度。

同时，每个 thread 做的工作几乎一样：

```text
读取 3 x 3 input
计算 Gx/Gy
计算 magnitude/direction
写两个 float output
```

所以 block shape 只影响调度和局部 thread grouping，不改变算法本身，也不改变每个 pixel 的计算量。

结果是 naive exact kernel 只从 13.45 ms 变化到 13.58 ms，spread 只有 0.96%。

### 6.3 为什么 shared memory 没有帮助

shared memory 理论上可以减少 global memory read，因为相邻 Sobel stencils 共享 input pixels。

但是 naive kernel 的访问模式已经很好：

- input 是 row-major。
- 相邻 threads 访问相邻 pixels。
- 相邻 3 x 3 stencils 有大量重叠。
- GPU cache 已经可以复用很多数据。

shared-memory kernel 额外增加了这些开销：

- tile loading
- halo loading
- shared-memory indexing
- boundary checks
- `__syncthreads()`

Sobel 本身 arithmetic intensity 很低，每个 pixel 计算不多，所以这些额外开销超过了 shared memory 的收益。

结果：

```text
naive exact best:  13.45 ms
shared exact best: 21.03 ms
```

### 6.4 atan approximation 怎么实现

exact baseline 用：

```cpp
atan2f(sum_y, sum_x)
```

approximation 的核心思想是把 atan 的输入范围缩小到 `[0, 1]`：

```text
t = min(|Gx|, |Gy|) / max(|Gx|, |Gy|)
```

然后对 `atan(t)` 做近似，再根据 Gx/Gy 的象限恢复完整方向。

这样做的原因：

- 直接用 `Gy / Gx` 会遇到 `Gx -> 0` 时数值很大。
- 用 `min/max` 后，输入范围固定在 `[0, 1]`，更容易用 polynomial approximation。
- approximation 可以用 multiply / add / fma 实现，避免昂贵的 exact `atan2f`。

主要结果：

```text
exact:        13.45 ms
approx_1deg:  13.07 ms
approx_2deg:  13.09 ms
approx_15deg: 13.17 ms
```

误差：

```text
approx_1deg: mean 1.35 deg, max 4.07 deg
approx_2deg: mean 0.082 deg, max 0.215 deg
approx_15deg: almost exact for this input
```

`approx_2deg` 是比较好的 speed/accuracy tradeoff。

### 6.5 为什么 D2H 比 H2D 更久

H2D 只 copy input：

```text
32768 x 32768 uint8 pixels = about 1 GiB
```

D2H copy 两个 output arrays：

```text
magnitude: float
direction: float
```

两个 float arrays 加起来大约：

```text
32766 x 32766 x 2 x 4 bytes = about 8 GiB
```

所以 D2H transfer 比 H2D 更久是合理的。

### 6.6 为什么 standalone CUDA total 被 transfer dominate

best naive exact 的 timing：

```text
kernel: 13.45 ms
H2D:    296.71 ms
D2H:    645.16 ms
total:  973.96 ms
```

H2D + D2H 占 96.7%。

这说明 standalone benchmark 里，主要时间花在 CPU 和 GPU 之间搬数据。

但是如果 Sobel 是更大 GPU pipeline 的一部分，例如后面还有 thresholding、non-maximum suppression、feature extraction 或 neural-network inference，那么 input/output 可以留在 GPU 上，H2D/D2H 可以被 amortize 或避免。

所以 kernel optimization 在 pipeline 场景下仍然有意义。

## 7. Roofline 怎么解释

我们使用 Nsight Compute roofline 看 kernel 本身。

注意：roofline 不包括 H2D/D2H transfer，它只看 GPU kernel。

Nsight roofline 结果没有显示 kernel 明确贴近 memory roof 或 compute roof。也就是说，这个 kernel 没有 saturate 单一硬件上限。

更合理的解释是：

```text
CUDA Sobel kernel 受多种因素共同影响：
- regular global-memory traffic
- cache behavior
- atan2f / sqrtf special-function instructions
- output writes
```

所以报告里不要写 “purely memory-bound”。更稳妥的说法是：

```text
The roofline does not indicate a single saturated hardware limit.
```

runtime breakdown 是解释 standalone benchmark 的主证据；roofline 是解释 kernel-level behavior 的辅助证据。

## 8. 报告里建议的 CUDA 结构

```text
1. CUDA Implementation
  1.1 Thread Mapping and Baseline Kernel
  1.2 Shared-Memory Tiled Kernel
  1.3 Direction Computation Methods
  1.4 Timing Methodology

2. CUDA Block-Size Sensitivity

3. CUDA Shared-Memory Tiling

4. CUDA atan2 Approximation

5. CUDA Runtime Breakdown and Roofline

6. CUDA Summary and Interpretation
```

## 9. 一句话总结

CUDA 部分的核心结论是：

```text
For Sobel edge detection, the simplest one-thread-per-pixel CUDA kernel is already strong. Block shape has limited effect once enough parallelism is exposed; shared memory does not help because cache already captures much of the stencil locality; atan2 approximation modestly reduces kernel time; and standalone total CUDA time is dominated by H2D/D2H transfers, especially because the output consists of two large float arrays.
```

