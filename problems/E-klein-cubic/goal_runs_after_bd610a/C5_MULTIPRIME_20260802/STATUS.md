C5-UNDECIDED

# C5 multiprime Morita holdout status (2026-08-02)

This packet advances generic / multiprime Morita source executability without
claiming a `K_proj`-point or `C5-EXECUTABLE-FULL-INCIDENCE`.

## Exit

```text
C5-UNDECIDED
```

Partial marker installed:

```text
C5-MORITA-MULTIPRIME-HOLDOUT-PASS
```

## What this advances (not a p23 re-walk)

| Item | Result |
|---|---|
| Holdout unused good prime | **`p=353`**, ζ₁₁=58, RUR root 143 |
| Independent bivector `P` | modular degree-12 RUR coeff vector × multiprime Reynolds (not the sealed p=23 wedge table) |
| Multiprime open ledger | `2`, `Pf(Q)`, `s`, `f14`, frame den, corner rank/minor, Morita-module minor **all nonzero** at 23, 199, 331, 353 |
| Stored factor consumption | all **1935** `ordered_trace_terms` walks per fibre (720 homog + 1215 chart) |
| Independent formula match | intended `-Tr(P Mᵀ Q P Gᵀ B G P Q M)/(2 s³)` matches factor walks at every fibre |
| Chart cross-check | all **675** chart coeffs match independent reconstruction |
| Sealed p=23 tables | bivector + corner Hermitian tables match `c2_morita.json` |
| Corruption self-test | flipping stored `P→Q` changes values at every fibre |

### Open ledger (load-bearing minors / denominators)

| prime | role | `s` | `Pf(Q)` | `f14` | corner minor | Morita minor |
|---:|---|---:|---:|---:|---:|---:|
| 23 | accepted seed | 3 | 17 | 17 | 16 | 19 |
| 199 | discovery | 87 | 75 | 198 | 169 | 147 |
| 331 | discovery | 324 | 114 | 6 | 262 | 214 |
| **353** | **holdout** | 203 | 335 | 324 | 45 | 241 |

At holdout `p=353` every homogeneous and chart coefficient is nonzero (390/390, 675/675).

### Relation to rejected next-gate packet

`goal_runs_after_bd610a/C5_NEXT_GATE_20260802/` sealed only a **p=23** factor walk.
That is necessary but not sufficient for the holdout requirement named in
`NEXT_GATE.md`.  This packet supplies the missing multiprime / holdout layer.

p=23 homogeneous checksum prefix `b5dab447821bd4ff` agrees with the prior
p=23-only probe, so the multiprime path is compatible with the accepted fibre.

## What is still open

- Char-0 / preferred length-12 `K_proj` normal form of coefficient classes.
- `G_HENSEL_ELIMINANT_LINEAR_FACTOR` on the `q_0=1` chart.
- Any common line over `K_proj`, original Fano substitution, or `BR-FANO-POS`.

Hence `C5-EXECUTABLE-FULL-INCIDENCE` is **not** claimed.  The strongest honest
listed exit remains `C5-UNDECIDED`.

## Replay

```sh
cd goal_runs_after_bd610a/C5_MULTIPRIME_20260802
PYTHONDONTWRITEBYTECODE=1 python3 -u produce_multiprime_morita.py
PYTHONDONTWRITEBYTECODE=1 python3 -u verify_multiprime_morita.py
```

Producer and verifier are independent: the verifier does not import the producer.
No Magma.  No full `L_a` expansion.  No `BR-FANO-POS` without original equations.
