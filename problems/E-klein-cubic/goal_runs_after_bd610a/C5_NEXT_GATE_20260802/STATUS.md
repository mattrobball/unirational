C5-UNDECIDED

# C5 next-gate status (2026-08-02)

This directory advances the C / C5 Fano–common-line front without claiming a
`K_proj`-point or the executable-full-incidence exit.

## Exit

```text
C5-UNDECIDED
```

Partial marker installed:

```text
C5-MORITA-RECORD-INTERPRETER-P23-PASS
```

## Smallest remaining exact gate

```text
G_MORITA_SOURCE_INTERPRETER
```

Exact missing object: a generic interpreter that **consumes every serialized
Morita coefficient record** (factor strings / DAG nodes) from sealed source
leaves, over `K_proj` (or a multiprime oracle strong enough to authorize
`C5-EXECUTABLE-FULL-INCIDENCE`).  See `NEXT_GATE.md`.

### What was already sealed (upstream, read-only)

- Canonical lazy algebra; corrected square-zero / trace incidence.
- Generic Plücker incidence fully serialized over the split ambient field.
- Morita coefficient DAG inventory (390 + 675) with finite-fibre formula check.
- Pairwise Amer–Brumer common-line theorem; not five forms.
- Smooth modular seeds; degree-≤16 covariant exclusion.

### What this packet adds

| File | Role |
|---|---|
| `NEXT_GATE.md` | Exact missing object, equations, dimensions, planned certificate |
| `NOT_TO_DO.md` | Stale RUR quarantine and explicit non-goals |
| `source_leaf_binding.json` | Prose-leaf → sealed evaluation recipe table |
| `produce_record_interpreter.py` | Walks all stored factors + 517 split-DAG nodes at `p=23` |
| `verify_record_interpreter.py` | Independent consumption, checksums, corruption self-test |
| `interpreter_probe.json` | Machine inventory and claim ledger |

Independently verified at the accepted fibre `p=23`, `ζ₁₁=2`, `x=(1,2,3,4,5)`:

1. **1935** stored `ordered_trace_terms` factor walks (720 homogeneous + 1215 chart).
2. All **21** distinct factor tokens resolve (`P,Q,B[i],M[j],G[k],transpose(...)`).
3. Homogeneous **5×78** table equals sealed corner Hermitian tables.
4. Sealed residue line residuals are zero.
5. All **517** split-DAG nodes evaluate; `Δ(v=0)=1`, `det J_minor=5`, `det T=18`.
6. Corrupting a single stored factor (`P→Q`) changes the value; unbound tokens raise.

### What is still open

- Holdout prime with independent bivector specialization of `P` (not only `p=23`).
- Char-0 expansion / preferred length-12 `K_proj` normal form of coefficients.
- `G_HENSEL_ELIMINANT_LINEAR_FACTOR` (successor geometric gate).
- Any `K_proj` common line / original Fano substitution / `BR-FANO-POS`.

Hence `C5-EXECUTABLE-FULL-INCIDENCE` is **not** claimed.  The strongest honest
listed exit remains `C5-UNDECIDED`.

## Replay

```sh
cd goal_runs_after_bd610a/C5_NEXT_GATE_20260802
PYTHONDONTWRITEBYTECODE=1 python3 -u produce_record_interpreter.py
PYTHONDONTWRITEBYTECODE=1 python3 -u verify_record_interpreter.py
```
