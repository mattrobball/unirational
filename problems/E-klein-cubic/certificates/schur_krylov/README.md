# Path A — Schur–Krylov rational parametrization

**Decision exit:** `A-STOP`  
**Headline:** OPEN  
**Base pin:** `e050464` (cycle-2 collapse on prior A1–A3 seal)

## Replay

```bash
/opt/homebrew/bin/python3 -u certificates/schur_krylov/verify.py
```

Expected markers:

```text
SCHUR_KRYLOV_GATES_A1_A2_A3_VERIFY_OK
SCHUR_KRYLOV_DECISION_A_STOP
HEADLINE_OPEN
```

## Gates

| Gate | Exit | Content |
|---|---|---|
| A1 | `A1-PASS` | P¹ reduction; odd-index step `gcd(55,2)=1` explicit |
| A2 | sealed | monogenic L/F, companion mult. matrices, marked point + V_Z |
| A3 | `A-STOP` | incidence formulated; linear elim of 80 coeffs; 8 GiB floor |
| A3 collapse | `A-STOP` refined | no lossless collapse under 8 GiB; minimal system = Fitting of \(\varphi_\tau\) on 52-dim PGL₂ slice |

## Cycle-2 collapse

See `STRUCTURAL_COLLAPSE.md`.  Full PGL₂ gauge is lossless (55→52 nonlinear
vars) but residual degree ≫3 still exceeds 8 GiB.  No F-rational isotypic /
intermediate-field block reduction exists (H maximal, Aut(L/F)=1).  Non-scalar
λ-specialisations and τ=α are lossy.  Modular rank discovery lives under
`tmp/pathA_collapse/` (shape only; not N-A).

## Boundary

No qualifying curve is constructed.  `N-A` is not claimed (would be non-headline
even if claimed).  Expanded coefficients of μ and of z_i in F are not produced;
the multiplication and incidence APIs are sealed structurally.  Headline OPEN.
