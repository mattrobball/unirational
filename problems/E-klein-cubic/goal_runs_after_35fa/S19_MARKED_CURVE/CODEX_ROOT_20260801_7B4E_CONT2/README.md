# S19 marked-curve continuation 2

This packet advances the exact S19 frontier but retains the binding exit
`S19-UNDECIDED`.  It supplies a lossless `105 x 20` incidence compression,
independently tests it with a planted positive control, and records an exact
degree-19 trisecant degeneration through all 55 marks.

The main artifacts are:

- `HANKEL_COMPRESSION.md`, `hankel_probe.json`: lossless split-fiber
  incidence criterion and 5,468 bounded modular tests;
- `trisecant_degeneration.json`: exact `Q(zeta_11)` hyperplane and 19
  trisecants covering the 55 marked points;
- `TRISECANT_DEGENERATION.md`: the decisive Hilbert-polynomial audit of that
  union;
- `two_transversal_family_mod67.json`: algebraic-closure audit of the natural
  two-parameter repair family on one modular chart;
- `STATUS.md`, `COMPLETION_AUDIT.md`: requirement-level boundary;
- `run_all.py`, `SEAL.json`, `verify_seal.py`: replay and integrity checks.

Replay from this directory with

```text
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 run_all.py
```

Expected final marker:

```text
S19_CONTINUATION_2_FULL_REPLAY_OK
```
