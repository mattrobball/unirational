# Path A — Schur–Krylov rational parametrization

**Decision exit:** `A-STOP`  
**Headline:** OPEN  
**Base pin:** `89c27e2`

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

## Boundary

No qualifying curve is constructed.  `N-A` is not claimed (would be non-headline
even if claimed).  Expanded coefficients of μ and of z_i in F are not produced;
the multiplication and incidence APIs are sealed structurally.  Headline OPEN.
