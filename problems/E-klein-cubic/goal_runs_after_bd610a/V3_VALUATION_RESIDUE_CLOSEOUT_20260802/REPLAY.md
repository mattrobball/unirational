# Replay

From this directory run

```sh
python3 reproduce_f5_degree16_support.py
python3 reproduce_f5_degree16_support.py --full
python3 verify.py
```

The first command reconstructs the 660-element representation, the 151-row
landing system, every support rank through size four, all eight deficient
size-five supports, and the direct `Q*C` witness.  The `--full` command also
re-enumerates all 11,628 size-five supports.

Terminal markers:

```text
V_F5_DEGREE16_SMALL_SUPPORT_QUICK_OK
V_F5_DEGREE16_SMALL_SUPPORT_FULL_OK
V3_VALUATION_RESIDUE_CLOSEOUT_OK
```
