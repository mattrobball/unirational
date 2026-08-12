# BURNSIDE_ASSESS — replay

Packet: `goal_runs_20260812/BURNSIDE_ASSESS/`
No git. Nothing outside this directory is written.

```text
cd problems/E-klein-cubic/goal_runs_20260812/BURNSIDE_ASSESS
python3 scripts/assemble_symbols.py
python3 verifier.py
```

Expected markers: `ASSEMBLE_BURNSIDE_OK`, then `BURNSIDE_ASSESS_VERIFY_OK` /
`ALLGREEN` (61 checks, 0 failures, 0 skips; groups A=13, B=27, C=8, D=9, E=4).

The assembler and verifier read, but do not write:

- `goal_runs_20260810/RECEIVER_LEDGER_X/results/ledger_exact.json`
- `goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/symbols.json`

Toolchain: `python3` standard library only.
