```
checker/
|
├── fft_fixed.m
│     Fixed-point MATLAB reference model.
│     Reproduces every FFT stage using fixed-point arithmetic,
│     matching the RTL implementation.
│
└──  FFT_2D_golden_test.m
     Compares RTL outputs against the MATLAB golden model and
     reports the normalized RMS error.

```
