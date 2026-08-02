# Canonical three-frame Palatini slice

## Outcome

No `K_Schur`-rational point was found.  The exact search does, however,
settle the proposed rational-parametrization shortcut: the generic canonical
three-frame section is a smooth geometrically integral plane quartic of genus
three, so the whole curve has no rational parametrization over `K_Schur` (or
after algebraic closure).

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

## Strict scope

- No `K_Schur`-rational point is constructed or excluded.
- No rational parametrization of the generic plane quartic exists, but this
  does not exclude a rational point on that genus-three curve.
- The finite invariant-ratio census is a bounded exact search, not an
  all-functions theorem.
- No `V14(K_Schur)` or `X_Schur(K_Schur)` point follows.
- Neither binary Q headline is decided.
