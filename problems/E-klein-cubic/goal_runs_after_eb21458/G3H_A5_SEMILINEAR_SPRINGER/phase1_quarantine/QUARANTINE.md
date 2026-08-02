# G3H phase 1 — G7B quarantine

Marker: `G3H-G7B-QUARANTINE-PASS`

## Defect (re-verified independently)

The withdrawn construction `p_i = rho(g_i) e_0` with `e_0 = (1:0:0:0:0)` fails:

- `|Stab_G([e_0])| = 11`, orbit size 60
- each maximal A5 meets the stabilizer in the identity only
- coset well-definedness fails (59/60 non-identity h on coset 0)
- equivariance under generators s,t: 44/44 failures

Audit subprocess marker: `G7B-INDUCED-CYCLE-REFUTED`.

## Historical files

G7B packet files are **not rewritten**. Hashes recorded in `quarantine.json`.
Primary G7B exit remains residual projective scaling; induced materialization
is residual with e0 construction refuted.

## Policy for G3H

G3H uses the genuine H-A5 degree-11 landing covariant composed with cubic
compression. Coset orbits of fixed split vectors are forbidden unless
stabilizer+equivariance are proved (they are not for e0).
