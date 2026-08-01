# Replay

From this directory run:

```
/opt/homebrew/bin/python3 verify.py
```

The checker independently replays the CRT multiplicities, verifies the frozen
landing-row certificates and their modular ranks, checks the rank-six frame
witness, recomputes the Palatini/Reynolds identity and all six minor syzygies, and
reruns the exact degree-seven Singular solve.

The comparison is lifted to characteristic zero by the exact
`Q(zeta_11)` intertwiner and its checked reduction to the modular `B5`; see
`REPORT.md`.  External project sources are hash-bound in `source_manifest.json`
and checked before any import.
