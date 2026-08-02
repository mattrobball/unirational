# Canonical three-frame Palatini slice

## Outcome

No `K_Schur`-rational point was found.  The exact search does, however,
settle the proposed rational-parametrization shortcut: the generic canonical
three-frame section is a smooth geometrically integral plane quartic of genus
three, so the whole curve has no rational parametrization over `K_Schur` (or
after algebraic closure).  It also completely excludes homogeneous
coordinates from the degree-eight invariant space.

The bounded invariant-rational search also found no point in a natural large
single-quotient ansatz.  This is evidence only at that stated ansatz; it is
not a pointlessness theorem.

## Canonical slice

The six frame columns are

```text
r_i(v) = sum_g (g v)_5^7 g^(-1)e_i,  i=0,...,5.
```

All six use the same scalar seed, so the phrase "most symmetric coordinate
triple" does not intrinsically single out one subset of the multiplicity
labels.  We use the canonical tie-break `(0,1,5)`: these are exactly the three
output indices selected independently by the complete degree-five Reynolds
basis.  The tested curve over the invariant field is

```text
C_015 : I4(r_0 + a r_1 + b r_5) = 0.
```

The functions `a,b` must be homogeneous degree-zero Schur-invariant rational
functions.  Raw source-coordinate guesses are therefore not admissible.

## Exact specialization survey

At twelve deterministic points modulo 23, the producer constructs the
ternary quartic for each of the twenty coordinate triples.  Singular factors
all 240 polynomials exactly in `F_23[z0,z1,z2]`.  Every factor list consists
of a unit and one multiplicity-one quartic; hence all 240 specializations are
irreducible over `F_23`.

For `C_015`, Singular also checks the three standard projective charts of the
Jacobian ideal for every specialization.  All `12*3` chart ideals contain
one, so all twelve curves are smooth over the algebraic closure.  Their
`F_23` point counts are

```text
24, 29, 32, 23, 31, 35, 31, 32, 20, 33, 18, 29.
```

At the installed frame witness `v=(9,18,15,18,2,19)`, the quartic is

```text
6 z2^4 + 9 z1 z2^3 + 15 z1^2 z2^2 + 5 z1^3 z2 + 17 z1^4
+ 11 z0 z2^3 + z0 z1 z2^2 + 18 z0 z1^2 z2 + 10 z0 z1^3
+ 16 z0^2 z2^2 + 19 z0^2 z1 z2 + 22 z0^2 z1^2
+ 3 z0^3 z2 + 21 z0^3 z1.
```

It has the specialized point `[1:0:0]`.  This point occurs only after
specialization and is not a rational section over `K_Schur`.

## Generic genus-three consequence

The exact Schur matrices and Reynolds sums reduce at
`(23,zeta_11-2)` to the modular maps used above, and the installed lift
identifies `I4` with the characteristic-zero Palatini quartic up to nonzero
scalar.  Since one good-reduction fibre has empty projective singular locus,
the discriminant of the invariant ternary quartic is nonzero.  Thus the
generic characteristic-zero `C_015` is smooth.

A smooth plane quartic is geometrically integral: distinct positive-degree
plane components would intersect by Bezout and make the union singular.  Its
genus is `(4-1)(4-2)/2=3`.  Therefore no rational parametrization of the
generic curve exists.  This does not prevent a genus-three curve from having
an isolated `K_Schur`-point.

## Invariant-rational quotient search

Exact split-prime CRT gives the complete invariant-space dimensions

```text
degree       8   10   12   14
dimension    4    4   14   16
```

For each degree the producer selects a complete independent Reynolds basis.
It tests functions of the form

```text
c                         or
c I_i / I_j,
```

where `c in F_23`, `I_i,I_j` belong to the same complete basis in degree
8, 10, 12, or 14.  It also tests the analogous quotients among the fifteen
degree-28 coefficient invariants of `C_015`.  Constants and duplicate sample
behaviors are deduplicated, leaving 14,785 candidate functions for each of
`a` and `b`.

All `14,785^2 = 218,596,225` ordered pairs are defined on at least six common
specializations.  Exact substitution leaves zero survivors.

This excludes only the displayed single-basis-term quotient ansatz in the
good fibre.  It does not cover linear combinations of invariants, higher
degrees, nested rational expressions, formulas with bad reduction, or an
arbitrary element of `K_Schur`.

## Complete degree-eight invariant-linear exclusion

Let `J_0,...,J_3` be the complete degree-eight invariant basis certified by
the split-prime residues `[4,4,4]` at `23,67,89`.  The CRT modulus `137149`
exceeds the elementary dimension bound `binomial(13,5)=1287`.  Write

```text
D = sum_j d_j J_j,   A = sum_j a_j J_j,   B = sum_j b_j J_j.
```

The twelve coefficients define the complete common-degree-eight ansatz

```text
I4(D r_0 + A r_1 + B r_5) = 0.
```

Over `F_529=F_23[u]/(u^2-5)`, the producer exhausts all 530 projective lines
in each of six order-three/order-six two-eigenspaces.  Among the 3,180 lines:

```text
zero restrictions                         2,120
nonzero rank-one fourth powers                12
rank-two restrictions splitting completely  1,048
```

The rank-one equations give three independent mandatory linear forms.  The
rank-two equations deduplicate to 131 four-hyperplane clauses.  An exact
linear SAT replay visits 597 states and proves that every factor choice lies
in one common rank-eight linear subspace of the twelve coefficients.

That terminal subspace has dimension four.  Forty deterministic ordinary
evaluations restrict the remaining landing equations to quartics in four
variables.  Their exact row rank is

```text
35 / binomial(7,4) = 35 / 35.
```

Thus all degree-four coefficient monomials vanish; in particular every pure
fourth power vanishes, leaving only the affine origin.  The special-fibre
projective landing locus is empty.

The four Reynolds invariants lift exactly over `Q(zeta_11)` and form the
complete characteristic-zero degree-eight invariant space.  Scaling a
hypothetical nonzero characteristic-zero twelve-vector integrally at
`(23,zeta_11-2)` would give a nonzero point in the empty special fibre.
Consequently:

> No nonzero common-degree-eight invariant triple `(D,A,B)` makes
> `I4(D r_0 + A r_1 + B r_5)` vanish identically.

Equivalently, the canonical slice has no point whose homogeneous coordinates
all lie in the degree-eight invariant polynomial space.  This is complete at
degree eight, but says nothing about common degree ten or higher.

## Strict scope

- No `K_Schur`-rational point is constructed or excluded.
- No rational parametrization of the generic plane quartic exists, but this
  does not exclude a rational point on that genus-three curve.
- The finite invariant-ratio census is a bounded exact search, not an
  all-functions theorem.
- The invariant-linear theorem is complete only for common homogeneous
  degree eight; higher common degree remains open.
- No `V14(K_Schur)` or `X_Schur(K_Schur)` point follows.
- Neither binary Q headline is decided.
