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
<!--
                  +------------------+
Input  ---------> |        FSM       |
                  +-------+----------+
                            |
                control / address
                            |
                            v
                 +--------------------+
                 |  Address Generator |
                 +-------+------------+
                           |
                   SRAM Address
                           |
                           v
                 +--------------------+
                 |     RA1SH SRAM     |
                 |   1024 x 38 bits   |
                 +--------+-----------+
                          | Q
                          v
                +---------------------+
                |   Butterfly Engine  |
                |   A+B   /   A-B     |
                +---------+-----------+
                          |
                          v
                +---------------------+
                | Complex Multiplier  |
                +--------+------------+
                          |
                          v
                 +----------------+
                 | Write Back     | +-------> SRAM
                 +----------------+
-->                          

### Butterfly Pipeline
| cnt2 | action |
|:-----|:-------|
| 0 | Read Node1 (A) |
| 1 | Write Node1<=Q and Read Node2 (B) |
| 2 | Write Node2<=Q and Butterfly (A+B / A-B) |
| 3 | Complex Multiply and Write Back SRAM |

### Row FFT → Column FFT
```
+--------------+   +--------------------+                   +-----------------------+
| 32x32 Matrix |---| Row FFT (5 stages) |---Address      ---| Column FFT (5 stages) |--- Output
+-------+------+   +-------+------------+   Mapping Only    +-----------------------+
```
- Row FFT Address: row * 32 + column
- Column FFT Address: column + row * 32




