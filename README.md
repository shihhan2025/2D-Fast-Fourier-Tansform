## 2D FFT Hardware 

A Verilog implementation of a 32×32 Two-Dimensional Fast Fourier Transform (2D FFT) based on the Cooley-Tukey Decimation-In-Frequency (DIF) architecture.

This project was implemented as part of the NCTU ICLab course and focuses on hardware architecture design, pipeline scheduling, memory organization, and FFT computation.

### Project Overview

For an N×N image,
- Perform N row FFTs
- Perform N column FFTs
- Total:
    - **2N one-dimensional FFTs**
    - instead of directly computing the 2D DFT

### Architecture
Main modules include:

- Butterfly computation unit
- Twiddle factor multiplication
- Bit-reverse ordering
- Row FFT engine
- Column FFT engine
- Memory controller
- Control FSM

### Spec.
- Input: clk, rst_n, IN_VALID, FFT2D_IN[7:0]
- Output: OUT_VALID, FFT2D_OUT_R[18:0], FFT2D_OUT_I[18:0]
- It is asynchronous reset and active_low architecture
- Input is unsigned format, where output is 2's complement signed number format


### Directory Structure
```
├── rtl/
│   ├── fft2D.v
│
├── sim/
│   ├── testbench.v
│   ├── pattern.v
|
|── checker/
│   ├── FFT_2D_golden_test.m
│   ├── fft_fixed
|
└── README.md
```
