# C6 Morita / K_proj descent of the 12 split lines

**Marker:** `C6-MORITA-DESCENT-OBSTRUCTION`

**Not a headline claim.**  No `K_proj`-point of F_{14,T} and no
`C6-POINT-HEADLINE-POSITIVE`.

## Inputs

Sealed `exact_points.json` (12 height-≤1 u in D(Q), rank 4, common
lines over Q(zeta_11)); C5 Pluecker / Morita DAGs; 6-dimensional
representation generators from `tmp/fano14_twist/fano_covariant_scan.py`.

## Galois structure of the 12 lines

For every sealed line L:

- Gal(Q(zeta_11)/Q)-orbit size **2** (stabilizer order 5 = squares in (Z/11Z)*).
- All fifteen normalized Pluecker coordinates lie in the unique quadratic
  subfield Q(sqrt(-11)) subset Q(zeta_11).
- Coefficientwise vanishing of the five sealed generic Pluecker hyperplanes and
  of the fifteen Grassmann-Pluecker quadrics is independently rebuilt.

Thus each L is a **split-model** common line over Q(sqrt(-11)),
not a Q-point of Gr(2,6).

## Morita / twisted Pluecker equivariance (constant sections)

A K_proj-point of the twisted Fano is a section of the twisted
Pluecker bundle: in the split model one needs

    L(gx) = rho(g) L(x)    for all g in PSL_2(F_11).

For **constant** (x-independent) L this forces rho(g)L=L for all g,
i.e. a G-invariant decomposable bivector.  Over the sealed good prime
p=23, Reynolds projection on wedge^2 V_6 yields

    dim (wedge^2 V)^G = 0

(with |~G|=1320=|SL(2,F_11)| generated from the codex 6D generators).
Likewise V^G=0.  Hence **no constant G-equivariant line or point exists**,
and none of the 12 sealed planes is G-stable (modular plane stabilizers
are proper subgroups; orbit sizes 55-330).

This is the named Morita-chart obstruction for promoting the 12 constant
split lines to K_proj points of F_{14,T}.

## Search for new D(K_proj) points

| Lane | Result |
|------|--------|
| Height-1 u in P^5(Q(sqrt(-11))) multi-prime on D | only projectively-Q hits (the sealed 12, up to sqrt(-11)-scaling) |
| 200000 random height-≤2 genuine Q(sqrt(-11)) trials | 0 hits on D |
| Secondary / covariant residual | C5 degree-≤16 landing exclusion + short Morita-word exclusion retained; no new point |

## Residual gates

1. Constant-split-line descent blocked by Gal-orbit size 2 and (wedge^2 V)^G=0.
2. No new exact u in D(K_proj) in the lanes above.
3. C6.3 bridge not entered.
4. Optional: positive-degree secondary sections / rational-function Morita words.

## Resources

- wall ≈ 20.76 s
- peak RSS ≈ 53.8 MB
- GB / msolve: **not invoked**

## Markers

```text
C6-MORITA-DESCENT-OBSTRUCTION
C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS   # primary packet exit unchanged
C6-EXACT-SPLIT-POINTS-PASS               # retained
```

Headline remains **OPEN**.
