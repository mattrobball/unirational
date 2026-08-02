# Full-Schur Palatini: ten pencils and the complete degree-nine exclusion

## Outcome

No `K_Schur` point was found.  This packet proves two scoped results:

1. one natural rational pencil is excluded even over the full algebraically
   closed constant field, while nine further pencils are excluded over
   `Q(zeta_11)(x_0,...,x_5)`;
2. **every nonzero constant-coefficient degree-nine polynomial
   self-covariant is excluded**: none lands identically on the Palatini
   quartic.

The second statement uses the complete 19-dimensional degree-nine space, not
a sparse coefficient search.  Neither result excludes arbitrary
`K_Schur`-rational coefficients in the seven-frame equation.

Let `V=V6`, and retain the exact action and Palatini/Reynolds quartic `I4`
from the installed `full_schur_palatinian` packet.  Define five exact odd
self-covariants over `Q(zeta_11)`:

```text
q1(x)   = x,
q3(x)   = sum_g (g x)_5^3 g^(-1)e_0,
q5_j(x) = sum_g (g x)_5^5 g^(-1)e_j,  j in {0,1,5},
```

where `g` runs through `2.PSL(2,11)`.  The three displayed quintics are an
independent basis of the degree-five self-covariant space in the good fibre.
For every unordered pair among

```text
q1, q3, q5_0, q5_1, q5_5,
```

the producer constructs

```text
P_ab(x,t) = I4(q_a(x) + t q_b(x)).
```

The exact `Q(zeta_11)` generators reduce entry by entry at
`(23,zeta_11-2)` to the matrices used by the producer.  Reynolds averaging
therefore commutes with this reduction, and the installed characteristic-zero
lift identifies this `I4`, up to a harmless nonzero scalar, with the Palatini
quartic.

## Exact good-fibre result

Singular factors each of the ten polynomials in
`F_23[x_0,...,x_5,t]`.  In every case the factor list consists only of a unit
and the input polynomial.  Each input has `t`-degree four.  The three largest
inputs have respectively `254395`, `254733`, and `253563` terms.

Consequently none of the ten pencils has a root in
`F_23(x_0,...,x_5)`.  The same computation gives an arithmetic
characteristic-zero consequence.  Give `Q(zeta_11)(x)` the Gauss valuation at
`(23,zeta_11-2)`.  If a rational root `t` had positive valuation, reduction of
`P_ab(x,t)=0` would force `I4(q_a)=0`; if it had negative valuation, division
by `t^4` would force `I4(q_b)=0`.  Both endpoint polynomials have nonzero good
reduction.  Valuation zero would reduce to a root in `F_23(x)`, contradicted
by irreducibility.  Thus all ten pencils have no
`Q(zeta_11)(x)`-rational root.

## The one full-constant-field exclusion

For `P_(q1,q3)`, the replay also factors after extending constants to
`F_(23^m)` for `m=2,3,4`; it remains irreducible in every case.  A hidden
linear factor of an `F_23`-irreducible polynomial of `t`-degree four has a
Frobenius orbit of size at most four, so one of these extensions would reveal
it.  Hence this pencil has no rational root after algebraic closure of the
constant field.  The valuation argument and specialization of a hypothetical
complex factor then exclude a root already in `C(x_0,...,x_5)`, and therefore
also in its invariant subfield `K_Schur`.

This full-constant-field conclusion applies only to the `q1--q3` pencil.  The
other nine were not replayed over all required constant extensions.

## Complete degree-nine self-covariant theorem

The exact self-Molien computation gives

```text
dim Hom_G(Sym^9(V6),V6) = 19
```

in characteristic zero: the split-prime residues are `[19,19,19]` at
`23,67,89`, and the CRT modulus `137149` exceeds the elementary coefficient
bound `6*binomial(14,5)=12012`.  The 19 deterministic Reynolds seeds selected
in the good fibre are independent, hence their exact Reynolds lifts form the
complete characteristic-zero space.

Write a general member as `q_a=sum_(i=0)^18 a_i q_i`.  The landing equation

```text
I4(q_a(x)) = 0
```

is quartic in all 19 coefficients, with `7315` coefficient monomials.  The
decisive proof works at `(23,zeta_11-2)` and then lifts.

### Stabilizer factor certificate

Work over `F_529=F_23[u]/(u^2-5)`.  For one representative of each complete
order-three and order-six conjugacy type, the producer exhausts every line in
each two-dimensional eigenspace.  There are six such eigenspaces and exactly
`6*530=3180` projective lines.  Exact conjugation checks show that the chosen
representatives cover all 110 elements of each type.

For an eigenvector `x`, equivariance confines the degree-nine evaluation to
the `lambda^9` eigenspace.

- On 20 lines the image has rank one.  The equation is a nonzero fourth power
  `c*L_x(a)^4`; the distinct mandatory forms have coefficient rank eight.
- On the other 3160 lines the image has rank two.  Every restricted binary
  quartic splits exactly into four linear factors over `F_529`.  After
  deduplication these give 395 four-hyperplane clauses.

Quotienting by the eight mandatory forms leaves 11 coefficient dimensions.
The exact finite-field matroid/SAT replay explores every factor choice.  Five
terminal rank-nine states require an additional exactly split binary
restriction at a deterministic general evaluation point.  The final replay
has

```text
quotient clauses       395
visited SAT nodes      13612
memoized closed states 5444
adaptive split states  5
open witness           none
terminal coefficient rank 19
```

This is geometric emptiness over the algebraic closure, not merely absence of
`F_529`-rational points.  Each stored binary equation is checked to be a
nonzero scalar times a product of its four stored linear forms.  Its
algebraic zero set is therefore the union of those four hyperplanes; the SAT
tree covers every choice.  Rank 19 leaves only the affine origin and hence no
point of `P^18`.

### Characteristic-zero consequence

The exact Schur generators reduce entry by entry to the good-fibre action,
the 19 Reynolds maps lift and form the complete characteristic-zero space,
and the installed lift identifies `I4` with the Palatini quartic up to a
nonzero scalar.  A hypothetical nonzero characteristic-zero coefficient
vector can be scaled at `(23,zeta_11-2)` to have integral coordinates with at
least one unit.  Reduction would give a nonzero point of the empty special
fibre landing locus.  Thus:

> No nonzero constant-coefficient degree-nine polynomial Schur
> self-covariant over `Q(zeta_11)` lands identically on the Palatini quartic.

The independent terminal marker is

```text
FULL_DEGREE9_CHAR0_PALATINI_LANDING_EXCLUSION_REPLAY_OK
```

## Measured alternative backends (nonverdicts)

Before the factor certificate, exact dense evaluation rows reached rank
`1094` from 1300 `F_23` evaluations and rank `1154` from 1700 component rows
including 200 `F_529` points.  The degree-36 invariant-space ceiling is
`1157`; because the observed rank is three lower, those rows were never
claimed to span the complete landing system.

Direct all-19-variable msolve runs also remained nonverdicts:

- 32 dense quartics timed out at 120 seconds after degree-six matrices up to
  about `5007 x 133694` at 10.55% density;
- 256 dense quartics timed out at 180 seconds after a degree-six matrix
  `26916 x 122763` at 12.55% density;
- after the first six rank-one cuts, 128 residual quartics of exact row rank
  `125/1820` in 13 variables timed out at 300 seconds.

These measured resource floors are not used in the theorem.

## Historical bounded reconnaissance

A separate early modular search tested all `472777` degree-nine coefficient
vectors of support at most three and found no survivor.  It is not used in
the complete-space theorem.

## Strict nonclaims

- no nonzero `b=(b_0,...,b_5)` solving the full frame equation was found;
- no assertion is made about combinations involving three or more frame
  coordinates;
- no assertion is made about arbitrary complex-constant rational roots in
  nine of the ten pencils;
- the degree-nine theorem concerns constant-coefficient polynomial
  self-covariants, not rational functions in `K_Schur`;
- no `V14(K_Schur)` or `X_Schur(K_Schur)` point is constructed;
- neither binary Q headline is proved.
