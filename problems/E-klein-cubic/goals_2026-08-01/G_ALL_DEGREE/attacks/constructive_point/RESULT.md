# Constructive-point attack

## Verdict

**No exact `K_proj`-rational point was found.**  Consequently this directory
does not claim a landing covariant, does not clear a candidate to a global
homogeneous map, and does not change the Goal G headline.

The sharp exact deduction is:

> Any `K_proj`-point of the certified generic cubic must use at least three
> of the normalized frame coordinates `x,C,D,E,K`, and its projective frame
> ratios must be genuinely nonconstant over the constant field.

The first clause is stronger than a finite search: each of the ten frame
lines is excluded over the larger splitting field `C(x0,...,x4)`.

## 1. No two-frame point

For each pair `U,V` among `x,C,D,E,K`, the producer reconstructs directly
from `certificates/exact_covariants_check.py` the binary cubic

\[
Q_{U,V}(t)=F(U+tV)\in\mathbf Q[x_0,\ldots,x_4,t].
\]

Singular's characteristic-zero absolute-factorization algorithm finds one
nonconstant absolute factor, of multiplicity one, for every `Q_{U,V}`.
Thus every `Q_{U,V}` is absolutely irreducible.  Gauss's lemma makes it
irreducible in `C(x0,...,x4)[t]`, so it has no rational root there.  The two
endpoints are also off the cubic because all five pure coefficients
`F(U)` are nonzero polynomials.

The generic cubic uses the normalized columns `U/tau^deg(U)`.  Passing from
an unnormalized frame line to its normalized version merely rescales `t` by
a nonzero power of `tau`; it cannot create a rational root.  Since

\[
K_{\rm proj}\hookrightarrow \mathbf C(x_0,\ldots,x_4),
\]

none of the ten coordinate lines contains a `K_proj`-point.

This proves only a support statement.  It does **not** exclude a point using
three, four, or five frame coordinates.

## 2. No constant normalized-coordinate point

Expand the 35 coefficients of `generic_cubic.json` simultaneously in the
12 certified secondary basis elements and the monomials in
`t3,t6,t8,t11`.  For a constant projective vector
`c=(c0,...,c4)`, the identity `Phi(c)=0` gives a rational coefficient matrix
with

```text
98 rows, 35 cubic-monomial columns, rank 35.
```

The stored pivot minor is

\[
-\frac{44054019694890986205224724555193555993}
       {79343716147200}\ne0.
\]

Hence all 35 monomials `c_i c_j c_k` vanish, forcing `c=0`.  There is no
constant projective point in the normalized frame.

## 3. Bounded discovery probe

`search_basis_atoms.py` tested the explicitly finite ansatz in which exactly
three coordinates are signed members of the 12-element `K_proj/P0` basis.
All 138,240 presentations fail already at the exact good specialization

```text
p=101, (t3,t6,t8,t11)=(2,3,5,7).
```

This is a rigorous rejection of that finite ansatz only.  It is not an
all-height search and is not used to infer nonexistence of a `K_proj`-point.

## 4. Remaining positive boundary

A positive construction must now have at least three nonzero frame
coordinates and nonconstant invariant-field ratios.  The smallest visible
route is therefore a genuine rational point on one of the ten ternary frame
subcubics (the `xCD` plane is the already-developed example), or a
four/five-coordinate secant or descent construction.  No such point emerged
from the exact arithmetic checked here.

Because there is no candidate, the required denominator clearing and direct
verification in the original Klein equation cannot be performed.  Pairwise
absolute irreducibility must not be promoted to pointlessness of the full
generic cubic.

## Replay

From `problems/E-klein-cubic/goals_2026-08-01`:

```sh
/opt/homebrew/bin/python3 G_ALL_DEGREE/attacks/constructive_point/produce_structural_exclusions.py
/opt/homebrew/bin/python3 G_ALL_DEGREE/attacks/constructive_point/verify.py
```

The bounded discovery probe is separate:

```sh
/opt/homebrew/bin/python3 G_ALL_DEGREE/attacks/constructive_point/search_basis_atoms.py
```

The exact verifier ends with

```text
G_CONSTRUCTIVE_POINT_ATTACK_VERIFY_OK
```
