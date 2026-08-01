# All-order first-gate theorem and exact scope

## Plane gate

Fix an involution and write `W=E_+ direct_sum E_-`, of dimensions three and
two.  For a landing covariant of true odd plane order `m`, write the first
two parity-allowed normal terms as

\[
p=a_m+b_{m+1}+a_{m+2}+\cdots,
\qquad a_m\in E_-,\quad b_{m+1}\in E_+.
\]

In a basis of `E_-`, put `a_m=(A,B)=q(a,b)`, with `gcd(a,b)=1` after vertical
scalar factors are stripped.  The mixed gradient

\[
\operatorname{Sym}^2E_-\longrightarrow E_+^*
\]

has determinant 9 modulo 67 and 46 modulo 89, so is an isomorphism in
characteristic zero.  The normal-order `3m+1` equation is therefore, after a
constant target-basis change,

\[
q^2(a^2C_0+abC_1+b^2C_2)=0.
\]

The Hilbert--Burch syzygies of `(a^2,ab,b^2)` give

\[
(C_0,C_1,C_2)=(bU,-aU+bV,-aV).
\]

Thus the successor belongs to `(a,b)E_+` in every odd order.  On a horizontal
component of `q=0` where it is nonzero, the order `3m+3` equation reduces to
`F(b_(m+1))=0`, hence maps that component to the fixed elliptic cubic.  The
order-three translation in the effective `S_3` action makes the elliptic
trace equivariant only when the mapped horizontal degree is divisible by
three.

This excludes the installed degree-two Fable divisor.  It does not exclude
the primitive locus or mapped degree divisible by three.

## Triple-line recurrence

At a generic triple line let

\[
J_m=(y,z)^m\cap(x,z)^m\cap(x,y)^m.
\]

For `m=2r+1>=3`, the first layer after the accepted minimum-layer gate obeys

\[
(J_{2r+1})_{3r+3}=(xyz)^{r-1}(J_3)_6. \tag{1}
\]

For a monomial of total degree `3r+3`, the three symbolic inequalities imply
that every exponent is at least `r-1`.  Subtracting `(r-1,r-1,r-1)` gives
the order-three inequalities and total degree six; the converse is
immediate.  This proves (1) for every `r`, not just a computed range.

## Complete line-constant coefficient ideals

Fresh Reynolds projection from the authoritative split-67 Klein matrices
gives parameter dimensions two for `(m,tdeg,q)=(1,3,0)` and three for
`(3,6,0)`, where `q` is binary degree along the line.  In weak-composition
order for cubic parameter monomials, all coefficients of the Klein equation
span the row matrices

```text
m=1:
[1 13  0 53]
[0  1 61  0]
[0  0  1  0]

m=3:
[1 13  0 53  0 24 47 14  0 59]
[0  1 61  0 31 11 50 32  9  0]
[0  0  0  0  0  1  0  0  0  0]
[0  0  1  0  6  0  0  0 32  0]
```

On every standard projective chart their Groebner basis is `[1]`.  Both
special-fibre projective schemes are therefore geometrically empty.  Since
67 does not divide 660, Reynolds invariants commute with reduction; after
choosing the representation lattice at a prime above 67, these invariant
spaces are free direct summands over the DVR.  Properness of projective space
then transfers emptiness to characteristic zero.

The tetrahedral action fixes `xyz`.  Cubic homogeneity and (1) propagate the
order-three line-constant unit certificate to every odd order at the first
surviving transverse layer.  This is the precise all-order conclusion.

## Corrected positive-line boundary theorem

Let `H_n` be the complete `A4`-equivariant order-three,
transverse-degree-six source of binary line degree `n`, and let `D_L` be the
invariant cubic cutting out the three `D12` points.  Equivariant evaluation
on this reduced orbit gives, for `n>=2`,

\[
0\longrightarrow H_{n-3}\xrightarrow{D_L}H_n
\longrightarrow H^0(D_L=0,\mathcal H_n)^{A_4}\longrightarrow0.
\]

The quotient has dimension 11.  The assembled duplicate-central-plane map
has rank eight on it, leaving a three-dimensional quotient.  Exact split-67
reconstruction for the three boundary-power residues `4,5,6` gives the same
rank.  The period-three shift follows from the `D12` invariant
`g=U^3+V^3`, whose restriction on each central line is `2h^3`.

At low point degree the residual point map has rank three and its survivor
is exactly `D_L H_(n-3)`.  This recurrence stops: the `m=3` residual `D12`
point module ends in point degree 28.  At boundary power 23, hence point
degree 29, line degree two has a three-dimensional central-compatible
survivor and no residual target; it is not a `D_L` multiple.

Thus finite point torsion cannot prove an infinite `D_L`-divisibility
descent.  This is a structural obstruction to that proposed all-degree
strategy, not a landing covariant.

## Nonlinear boundary classification in line degree four

In line degrees two and three, the whole-line Klein ideals restricted to the
central-compatible source are projectively empty in the split fibre for all
three boundary-power residues.  Their restriction to the three boundary
points is nevertheless nonempty (one independent cubic row).  Therefore
whole-line emptiness does not descend to a unit ideal on the evaluation
quotient, and it cannot force another factor of `D_L`.

In line degree four the central-compatible source has dimension 11 and its
`D_L H_1` subspace has dimension eight.  The three complementary affine
charts are obtained by setting one of the exact quotient linear forms to
one and eliminating its pivot variable.  Two independent Groebner engines,
msolve and Singular, give the unit ideal on every eliminated chart over
`F_67`.  Therefore every geometric split-67 landing point in this source is
a `D_L` multiple.  Conversely, multiplication by `D_L` embeds the nonempty
degree-one landing support, of projective degree 48, into degree four.  The
degree-four special-fibre support is therefore inherited set-theoretically;
there is no primitive point.

The complement of `P(D_L H_1)` is not proper, so this unit-chart result has
no automatic characteristic-zero transfer.  It also gives no recurrence in
arbitrary line degree.  More importantly, even an all-line-degree result on
this first transverse layer would not exclude a class whose leading
triple-line term begins in a higher transverse degree.  No result in this
packet proves `(ID_m)` or decides the generic twisted cubic.
