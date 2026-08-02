# DEGREE8_PULLBACK — Goal Q3.1 Schur monodromy

**Marker achieved:** `Q3-SCHUR-MONODROMY-PASS`  
**Scope:** exact orbit-arithmetic + generic monodromy + named residual hypotheses; not a rational component of the special fibre

## Generic monodromy (input)

Harris–Roth–Starr: H_{3,0}(X) smooth irreducible dim 6; I = U×_H U×_H U integral dim 9; eval I→X^3 generically finite of degree 8 (Zinger).  Over C(X^3) the fibre is Spec of one degree-eight field.

After three points split: still one integral degree-eight extension.
Cubic resolvent closure does **not** automatically split the incidence fibre.

## Pullback to A4 stratum (resolvent Galois C3)

Orbit arithmetic on a reduced 8-set with a pure `C3`-action:

```text
fixed_points + 3 · (3-orbits) = 8
⇒ (fixed, 3-orbits) ∈ {(2,2), (5,1), (8,0)}
⇒ at least two fixed points
```

Machine enumeration confirms every partition forces a fixed point
(`c3_always_has_fixed_point_on_reduced_8_set = True`,
min fixed = 2).

**Conditional gate (exact):** if the special fibre is a finite length-8 Hilbert
scheme whose geometric points split over the cyclic cubic, then a
`K_Schur`-rational Hilbert point exists and Theorem B yields a point.

**Hypotheses proved for the installed Schur quartic:**

| Hypothesis | Proved? |
|---|---|
| finite length-8 Hilbert scheme | False |
| split over cyclic cubic | False |
| reduced support | False |
| avoids excess boundary | False |

## Pullback to S4 stratum (resolvent Galois S3)

Fixed-point-free `S3`-actions on an 8-set exist (e.g. orbit type `2+6`).
Length modulo 3 does **not** force a rational support point.

`fixed_point_free_s3_action_exists = True`.

## Schur-specific relation among the three points

The triple is a pairing-residual of a primitive tetrahedron, not a general
point of `X^3`.  On the **split** Klein cubic the resolvent map is dominant
(sealed ranks 9 / 10 / 6).  This packet recomputes an exact rational sample
(status `COMPUTED`, quartet rank `4`,
triple rank `3`, pairing residuals rebuild OK
`True`).

No new identity was found that forces monodromy of the special fibre to drop
into the resolvent group or to fix a component.

## Forbidden inference

Virtual Gromov–Witten count eight alone is **not** a `K_Schur`-point and is
**not** a Hilbert point.

## Decisive outcomes

| Outcome | Achieved |
|---|---|
| one rational component | no |
| odd-degree component + descent | no |
| deg-1 zero-cycle on RC component | no |
| canonical boundary map fixed by monodromy | no |

```text
Q3-SCHUR-MONODROMY-PASS
```
