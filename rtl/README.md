## Top Architecture

```
                  ┌────────────────────────────┐
                  │          Controller        │
                  │  FSM / Counters / Timing   │
                  └────────────┬───────────────┘
                               │
          ┌────────────────────┴────────────────────┐
          │                                         │
          ▼                                         ▼
 ┌─────────────────┐                     ┌─────────────────┐
 │ Address         │                     │ Twiddle ROM     │
 │ Generator       │                     │ (W0~W15)        │
 └────────┬────────┘                     └────────┬────────┘
          │                                       │
          ▼                                       ▼
                 ┌─────────────────────────┐
                 │      RA1SH SRAM         │
                 │      1024 × 38 bits     │
                 └──────────┬──────────────┘
                            │
                            ▼
                 ┌─────────────────────────┐
                 │ Butterfly Engine        │
                 │ Add/Sub + Pipeline      │
                 └──────────┬──────────────┘
                            ▼
                 ┌─────────────────────────┐
                 │ Complex Multiplier      │
                 └──────────┬──────────────┘
                            ▼
                 ┌─────────────────────────┐
                 │ Write Back to SRAM      │
                 └─────────────────────────┘
```


## Butterfly Pipeline
| cnt2 | action |
|:-----|:-------|
| 0 | Read Node1 (A) |
| 1 | Write Node1 Register and Read Node2 (B) |
| 2 | Write Node2 Register and Butterfly (A+B / A-B) |
| 3 | Complex Multiply and Write Back SRAM |


## Row FFT → Column FFT
```
┌──────────────┐   ┌────────────────────┐                    ┌───────────────────────┐
| 32x32 Matrix |---| Row FFT (5 stages) |---   Address    ---| Column FFT (5 stages) |--- Output
└──────────────┘   └────────────────────┘   Mapping Only     └───────────────────────┘
```
- Row FFT Address: row * 32 + column
- Column FFT Address: column + row * 32


## Control count
| Name | Description |
|:-----|:-------|
| cnt  | Element index within each row/column |
| cnt2 | Four-cycle butterfly micro-operation controller |
| cnt3 | Butterfly group index inside one FFT stage (15, 7, 3, 1)|
| cnt4 | FFT block index inside one FFT stage (0-1, 0-3, 0-7, 0-15) |
| s    | Butterfly distance (16 → 8 → 4 → 2 → 1) |


## Design Features
- 32×32 Radix-2 Decimation-in-Time FFT
- 10-stage architecture (5 Row FFT + 5 Column FFT)
- Single-port RA1SH SRAM based in-place computation
- Address remapping instead of physical transpose
- Shared Butterfly Engine across all FFT stages
- Shared Complex Multiplier
- Four-cycle butterfly pipeline
- Fixed-point twiddle factors
- FSM-based hardware scheduling


