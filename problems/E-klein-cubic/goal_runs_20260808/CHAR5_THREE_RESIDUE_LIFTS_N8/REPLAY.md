# Replay

Run from the repository root:

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/CHAR5_THREE_RESIDUE_LIFTS_N8/verify_all.py
```

The verifier first checks `SEAL.json`, then performs the dependency-free DPLL
reconstruction through root degree seven, and finally performs the two exact
PicoSAT replays at root degree eight.

The installed PicoSAT payload is version 0.6.6 for CPython 3.14 on macOS
(`pycosat.cpython-314-darwin.so`).  Its sealed SHA-256 is

```text
b41545dfc38f29d6b9f8aaa49d330383d597e673c2cd66d93a28b175dc00cecf
```

Expected terminal markers include:

```text
CHAR5-THREE-RESIDUE-LIFTS-N8-SEAL-OK
F55-CHAR5-FIXED-THREE-RESIDUE-N2-N7-SUPPORT-UNSAT-EXACT-DPLL
F55-CHAR5-FIXED-THREE-RESIDUE-N8-SUPPORT-UNSAT-SOLVER-REPLAY
CAVEAT_NO_DRAT_OR_RUP_PROOF
F55-CHAR5-FIXED-THREE-RESIDUE-THROUGH-N8-REPLAY-OK
HEADLINE_OPEN_NO_ALL_DEGREE_CUTOFF
```

The `n=8` replay may take roughly one to two minutes and uses substantial
memory because it reconstructs 60,515 coefficient rows and solves a
4,163,268-clause CNF twice.  The replay is exact but is not a DRAT/RUP proof
check.
