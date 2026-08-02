# A5Q quartic-rescue status

**Date:** 2026-08-01  
**Binding work order:** `GOAL_A5Q_INDEX11_QUARTIC_RESCUE.md`  
**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`

## Verdict

Both maximal `A_5` classes yield an exact reduced degree-eleven closed point
on the authoritative full Schur twist.  For each transported point, the full
degree-four interpolation incidence is empty: its five-coordinate space has
exact square-space dimension `11`, whereas quartic interpolation would force
dimension `9`.

```text
A5Q_INDEX11_CLOSED_POINT_OK
A5Q-INDEX11-CLOSED-POINT-PASS
A5Q-DEGREE4-RESCUE-EMPTY-SCOPED
```

This is a scoped negative result for the proposed degree-four rescue.  It is
not a positive or negative Problem E headline, and it does not assert that
the full twist has no rational point.

## Exact certificates

For `E=C(P(V6))`, `K=E^G`, and `L_i=E^{H_i}`, the primitive-resolvent
certificates in `FIELD_L1.json` and `FIELD_L2.json` prove
`[L_i:K]=11`.  The exact transport is

```text
B_i(v) = sum_(h in H_i) sigma_i(h)^(-1)*((rho6(h)v)_5)^4,
Y_i(v) = B_i(v)e_0,
x_i(v) = J_i Phi_i(Y_i(v)),
P_i(v) = Q(v)^(-1)x_i(v).
```

Reynolds reindexing makes `P_i` `H_i`-fixed, and the retained exact landing
identity gives `F(QP_i)=0` in characteristic zero.  Good-reduction witnesses
prove that all required open conditions are nonempty and that the eleven
projective conjugates are distinct.

| prime | role | class | `det Q` | `det B` | `det J` | coordinate rank/minor | product rank/minor |
|---:|---|---|---:|---:|---:|---:|---:|
| 89 | discovery certificate | 1 | 86 | 55 | 57 | `5 / 60` | `11 / 2` |
| 89 | discovery certificate | 2 | 12 | 78 | 62 | `5 / 23` | `11 / 31` |
| 199 | unused holdout | 1 | 179 | 55 | 3 | `5 / 106` | `11 / 147` |
| 199 | unused holdout | 2 | 167 | 181 | 136 | `5 / 93` | `11 / 94` |

Every displayed determinant is taken in its indicated finite field and is
nonzero.  A nonzero reduced minor proves that the corresponding exact minor
is nonzero; the row and column counts give exact characteristic-zero ranks
`5` and `11`.

## Residual branch

There is no interpolation map `phi`, so no degree-twelve form `F(phi)`, no
division by `g_tau`, and no residual linear factor.  The exact A5Q.3 gate is

```text
NOT_APPLICABLE_EMPTY_INCIDENCE
```

Accordingly this run contains no `POINT.md` or `BRIDGE_A5Q_POS.md`.

## Theorem boundary

The packet proves:

- two explicit exact degree-eleven closed points on the genuine full twist;
- emptiness of the entire degree-four interpolation incidence for each of
  those two points, not merely failure of a bounded search;
- exact group-action screens for the suggested higher-degree, two-cycle, and
  secant variants, without claiming that those variants are globally empty.

It does not prove:

- a `K`-rational point or rational curve on the full twist;
- emptiness for every possible degree-eleven point;
- failure of degree-five or arbitrary reducible-curve constructions;
- any unconditional equivariant-unirationality headline.
