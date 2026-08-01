# COV structured positive search

This directory is the isolated workspace for the run commissioned by
`../GOAL_COV_STRUCTURED_POSITIVE_SEARCH.md`.

The goal packet's historical output contract names
`problems/E-klein-cubic/goal_runs/COV_STRUCTURED_SEARCH/`.  The current user
instruction instead requires a new folder "here", and the active writable
root is `goals_2026-08-01/`.  Consequently every artifact produced by this
run is contained in this directory.  Parent-repository inputs are read-only
and are identified by commit and SHA-256 in the final seal.

Pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`.

Consumed live head at start: `2140419410cfff2f7d7dcca166acef8c16a0d41b`.

The shared branch advanced during this run.  The final input manifest also
records the verification-time head and hashes every parent input actually
used; none of those inputs changed between the two heads.

The final exit is `COV-NEW-ANSATZ-STRUCTURAL`.  It does not change the open
headline.  See `STATUS.md` and `COMPLETION_AUDIT.md` for the exact boundary.

One-command independent replay:

```text
/opt/homebrew/bin/python3 -B verify_all.py
```

The replay is intentionally substantial: it reconstructs all exact Reynolds
models, modular fixed-plane maps, and the largest mixed landing matrices.
