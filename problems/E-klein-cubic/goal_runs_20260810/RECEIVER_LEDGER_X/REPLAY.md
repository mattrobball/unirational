# Replay — RECEIVER_LEDGER_X

All commands from the packet directory
`problems/E-klein-cubic/goal_runs_20260810/RECEIVER_LEDGER_X`.
Toolchain: `python3` and `Macaulay2` only. No third-party python packages.

```sh
python3 scripts/produce_ledger.py                       # ~2 min
python3 scripts/emit_m2.py                              # ~10 s
M2 --script scripts/ledger_ideals.m2 > results/m2_ledger_ideals.txt   # ~40 s
python3 verifier.py                                     # ~6 min
```

Expected terminal markers:

```
PRODUCE_LEDGER_OK                 (55 checks, 0 failures)
LEDGER_IDEALS_M2_OK               (32 row checks, 0 failures)
RECEIVER_LEDGER_X_VERIFY_OK
ALLGREEN                          (107 checks, 0 failures)
```

`verifier.py` reads `results/ledger_exact.json` and `results/m2_ledger_ideals.txt`
if present (for the cross-route consistency checks D and E) but does **not**
import anything from `scripts/`: it rebuilds the representation, the group, the
subgroup lattice and every fixed locus from scratch.

## Files

| file | role |
|---|---|
| `THEOREM.md` | the ledger — main document |
| `REGISTRATION_SNIPPET.md` | proposed NOTEBOOK / manifest text (not applied) |
| `verifier.py` | independent verifier (exact `Q(zeta_11)` + primes 331, 661 + M2 ingest) |
| `scripts/klein_core.py` | exact `Q(zeta_165)` arithmetic, representation, group, subgroup lattice |
| `scripts/produce_ledger.py` | exact producer |
| `scripts/emit_m2.py` | emits the Macaulay2 ideal script |
| `scripts/ledger_ideals.m2` | generated; ideal-theoretic recomputation of all 16 rows |
| `results/ledger_exact.json` | exact ledger payload |
| `results/verifier_output.json` | verifier payload incl. all modular stratum data |
| `results/m2_ledger_ideals.txt` | Macaulay2 transcript |
| `results/producer_stdout.txt`, `results/verifier_stdout.txt` | check logs |

## Reproducibility notes

* `p = 331` and `p = 661` are the two split primes: both satisfy `p ≡ 1 (mod 165)`,
  so `F_p` contains primitive roots of unity of orders 2, 3, 5, 11 and every
  element of `G` is diagonalisable there. Primes `≡ 1 (mod 11)` alone are **not**
  enough — the `C5` eigenpoints are invisible at e.g. 67 and 89.
* At **both** primes the three type-II `V4`-points and (at 661) the two
  exact-`C3` points per eigenline are Galois-conjugate rather than
  `F_p`-rational. Point counts in the ledger are **geometric** counts, obtained
  from exact discriminants in `K` and confirmed by `degree` in Macaulay2 — not
  from `F_p`-rational point counts. This is the same trap FIX-A1 recorded in its
  item 9 (repaired regression primes 397, 419 for the type-II points only).
* `results/ledger_exact.json` records exact `Q(zeta_11)`/`K` coefficient vectors
  for the `F`-values at the isolated eigenpoints; the vectors themselves depend
  on the kernel normalisation, only their (non-)vanishing is invariant.
