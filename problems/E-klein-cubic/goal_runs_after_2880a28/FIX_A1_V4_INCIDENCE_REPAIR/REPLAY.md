# REPLAY — FIX_A1_V4_INCIDENCE_REPAIR

Exit `FIX-A1-V4-REPAIR-PASS`. Problem E headline: **OPEN**.

## Environment

| Item | Value |
|---|---|
| machine | Apple M-series, macOS (Darwin 25.6.0) |
| python3 | `/opt/homebrew/bin/python3` — 3.13.x, standard library only (`fractions`, `math`, `itertools`, `collections`, `json`, `hashlib`) |
| Macaulay2 | `/opt/homebrew/bin/M2` 1.26.06 (auxiliary check only) |
| not used | GAP, SageMath, Singular, PARI/GP, Magma, msolve. **Never invoke the bare names `gap` or `gp`: in this environment they are git aliases** (`git apply`, `git push`). |
| working directory | `problems/E-klein-cubic/goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR/` |

## Commands

```sh
cd problems/E-klein-cubic/goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR

# 1. producer  (~132 s)  -> v4_exact.json, x_cap_v4line_scheme.json,
#                           incidence_corrected.json, cubic_smoothness.m2,
#                           run_metadata.json
/opt/homebrew/bin/python3 produce_v4_ground_truth.py

# 2. independent verifier  (~275 s)
/opt/homebrew/bin/python3 verify_v4_ground_truth.py
#   terminal marker: FIX_A1_V4_REPAIR_VERIFY_OK

# 3. auxiliary smoothness of the 55 plus-plane cubics  (< 1 s)
/opt/homebrew/bin/M2 --script cubic_smoothness.m2
#   terminal markers: PLUS_PLANE_CUBICS_SINGULAR 0
#                     FIX_A1_PLUS_PLANE_SMOOTH_OK
```

The verifier prints one line per check. **It deliberately prints one `FAIL`
line**, labelled `HARNESS SELF-TEST -- this line is EXPECTED to read FAIL`: it
feeds the harness a false statement and asserts that the failure was recorded,
then removes it. A run is good iff it ends with `FIX_A1_V4_REPAIR_VERIFY_OK`
and shows **60** `PASS` lines and exactly that one labelled `FAIL`.

## Reproducibility

The three sealed JSON payloads and the generated `.m2` file are **byte-identical
across runs** (verified by two consecutive producer runs and `cmp`). No timestamp
and no timing field appears in them; run metadata is written separately to
`run_metadata.json`, which is *not* part of the seal. This implements the
recommendation recorded in `certificates/STRATA_EXACT.md` §5 caveat 1, where the
earlier strata seal was found not to be bit-reproducible.

## Hashes at seal (SHA-256)

| Artifact | SHA-256 |
|---|---|
| `produce_v4_ground_truth.py` | `bc0411a3a50f5605171d6aa9e051aea8487e2fe67d963a8516221d397a1eb922` |
| `verify_v4_ground_truth.py` | `50e10f95debe9aa165a230f77c33ef2e7f6cfc1ecae650f99b01e755eb0a812b` |
| `v4_exact.json` | `46bca2cc8138978d935c33217c6f5658b94e44a4421d02093f2ea40afa0c82b8` |
| `x_cap_v4line_scheme.json` | `fe1305de8c3b2ebd8d858c435eac96157f3d00ac7f2c158fa62d898bd4e8cb94` |
| `incidence_corrected.json` | `71152b8caaf1942bb813c601232461d7503ae1f93515da5b14a16364ae4987cb` |
| `cubic_smoothness.m2` | `2abd0874d209c3bb886088f435b5bd735014b3618672319e8be2441408f1739b` |
| `CORRECTION.md` | `28cd16126b5b43a8a426904b6b293d58f627859488d8978c2ae1356daf375752` |
| `STATUS.md` | `d21a1c1e3227da925d7fee5f241641058ab035123f30b9795fad6ff8877b554e` |

(`REPLAY.md` and `run_metadata.json` are not self-hashed.)

## Inputs

* `certificates/exact_weil_check.py` — the `S`, `T` generators of the exact
  5-dimensional `Q(ζ11)` Weil representation of `PSL(2,11)`. **Rebuilt in-file,
  not imported**, in both the producer and the verifier; the defining relations
  `g² = −11`, `S² = T¹¹ = (ST)³ = 1` and the order-660 closure are re-checked.
* `F = x0²x1 + x1²x2 + x2²x3 + x3²x4 + x4²x0`, hard-coded.
* No other repository artifact is read. The claims quoted in `CORRECTION.md`
  are quoted for adjudication only; nothing is imported from them and no
  existing file is modified.

## What a reviewer should check first

1. `verify_v4_ground_truth.py` really does not import the producer (`grep import`),
   and its methods differ from the producer's as tabulated in its docstring.
2. Section 9 of the verifier output — the four lines that carry the adjudication
   (`candidate claim 1: TRUE`, `candidate claim 2: FALSE`, and the two flag
   lines) are recomputed from the representation, not read from JSON.
3. `CORRECTION.md` §6, the supersession map, against `NOTEBOOK.md` [E34] and
   `certificates/STRATA_EXACT.md` §4.

## Independence from the sibling packet

FIX-A0 (`goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT/`) is being built
concurrently by another worker. Nothing here reads, writes or depends on it. The
two overlap only in that FIX-A1 independently re-derives, for its own use:
`dim W^{σ,+} = 3`, `dim W^{σ,−} = 2`, `P(W^{σ,−}) ⊂ X`, and (auxiliary, via M2)
the smoothness of `X ∩ P(W^{σ,+})` for all 55 involutions. If FIX-A0 reports
anything different for those four items, that is a genuine conflict to
adjudicate; everything else in the two packets is disjoint.
