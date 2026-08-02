# G3H phase5_bls — Route-1 Springer kill

Marker: `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED`  
Route-1 decision: **KILL**

## Kill statement

Route-1 Springer via Q_q is closed as an interface: checklist items 2 and 4 fail with named proofs; Springer quadratic-form theorem shows L_i-isotropy of Q_q is equivalent to the G3P K_proj residual, so the degree-11 cubic point a_i does not open a new path to Q_q-points; map-back remains unsealed; illegal cubic odd-degree descent rejected.

## Checklist (both A5 classes)

| # | Requirement | Status |
|---|---|---|
| 1 | Quadratic over K_proj | YES — Q_q |
| 2 | L_i-point on that object | **NO** (proofs) |
| 3 | Degree 11 odd | YES |
| 4 | Explicit map-back | **NO** |

## Forbidden inferences (rejected)

- Q_q(L_i) nonempty => X_gen(K_proj) nonempty without map-back
- pure cubic odd-degree descent from X_gen(L_i)

## Gates

| Gate | Status |
|---|---|
| `G3H-AI-SECONDARY-TABLE-OPEN` | CLOSED as obstruction (`G3H-AI-SECONDARY-TABLE-OBSTRUCTION`) |
| `G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN` | CLOSED NO (`G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO`) |
| `G3H-SPRINGER-MAPBACK-OPEN` | CLOSED with interface kill (G3P residual) |

## Not claimed

- `G3H-QUADRATIC-SPRINGER-REDUCTION-PASS`
- `G3P-POINT-HEADLINE-POSITIVE`
- Emptiness of X_gen(K_proj)
- Emptiness of Q_q(K_proj) (only equivalence with Q_q(L_i))

Resources: peak RSS 64.1 MB, wall 0.12 s.
