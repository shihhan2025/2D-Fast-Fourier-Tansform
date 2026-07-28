### Top Architecture

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

### Butterfly Pipeline
| cnt2 | action |
|:-----|:-------|
| 0 | Read Node1 (A) |
| 1 | Write Node1<=Q and Read Node2 (B) |
| 2 | Write Node2<=Q and Butterfly (A+B / A-B) |
| 3 | Complex Multiply and Write Back SRAM |

### Row FFT → Column FFT
```
┌──────────────┐   ┌────────────────────┐                   ┌───────────────────────┐
| 32x32 Matrix |---| Row FFT (5 stages) |---Address      ---| Column FFT (5 stages) |--- Output
└──────────────┘   └────────────────────┘   Mapping Only    └───────────────────────┘
```
- Row FFT Address: row * 32 + column
- Column FFT Address: column + row * 32

### Control count
|:-----|:-------|
| cnt  | element in each row |
| cnt3 | Butterfly group: maxmun value in each stage (15, 7, 3, 1)|
| cnt4 | num. of FFT block (0-1, 0-3, 0-7, 0-15) |
| s    | Butterfly distance (16, 8, 4, 2, 1) |




