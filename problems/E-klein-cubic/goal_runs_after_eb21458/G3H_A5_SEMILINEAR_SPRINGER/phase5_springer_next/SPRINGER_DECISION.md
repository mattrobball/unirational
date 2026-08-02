# G3H phase5_next — Springer decision

Marker: `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED`

## Checklist (both A5 classes)

| # | Requirement | Status |
|---|---|---|
| 1 | Quadratic object over \(K_{\\mathrm{proj}}\) | **YES** — \(Q_q\) (secondary \(M\) exact) |
| 2 | \(L_i\)-point on that object | **NOT CERTIFIED** |
| 3 | \([L_i:K_{\\mathrm{proj}}]=11\) odd | **YES** |
| 4 | Explicit map-back to \(X_{\\mathrm{gen}}\) | **NO** |

## Forbidden inferences (rejected)

- \(Q_q(L_i)\\ne\\varnothing\\Rightarrow X_{\\mathrm{gen}}(K_{\\mathrm{proj}})\\ne\\varnothing\) without map-back
- pure cubic odd-degree descent from \(X_{\\mathrm{gen}}(L_i)\)

## Progress vs original phase 5

- dual power-basis calculus for a_i installed (exact equivalent of expansion)
- polar forms L,M,A fully secondary-expanded over K_proj
- C,D formulas as L_i-elements with K_proj secondary structure constants
- named L_i-point hunt on K_proj quadrics (negative)
- residual gate G3H-AI-SECONDARY-TABLE-OPEN for cancelled beta tables

## Residual gates

- `G3H-AI-SECONDARY-TABLE-OPEN`: Fully cancelled secondary-basis numerators/denominators of the power-basis coefficients beta_{r,k} of a_i
- `G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN`: Certified L_i-point on Q_q (or other K_proj quadratic from q,a_i)
- `G3H-SPRINGER-MAPBACK-OPEN`: Explicit inverse-polar / reconstruction map Q_q -- > X_gen

## Decision

Springer is **not applied**. Scoped no-go reaffirmed with expanded polar and
expansion calculus. Primary package exit remains
`G3H-SEMILINEAR-G3-FRAME-PASS` (phase 4) with phase-5 interface no-go.

Resources: peak RSS 66.0 MB, wall 0.33 s.
