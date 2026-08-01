# Finite generation and the corrected boundary recurrence

## What finite generation supplies

For each fixed odd symbolic order `m`, the graded module

\[
 \bigoplus_d (I^{(m)}_d\otimes W)^G
\]

is finite over `R`.  The universal sixty-coordinate model in
`UNIVERSAL_OBJECT.md` is also finite type.  Neither fact bounds the first
primitive solution of the cubic landing equations.  The zero set is not a
module: sums of landing covariants need not land, so testing module
generators is invalid.

No finite generation theorem is proved here for the full symbolic Rees
equalizer with triple-line, point-link, marked, and irrelevant-torsion
layers.  In particular, the local factor recurrence below is not promoted
to a global semigroup recurrence.

## Exact line evaluation recurrence

Let `L=P^1` be the representative `A4` triple line, let

\[
 D_L=(l_1-42l_0)(l_1-58l_0)(l_1-66l_0),
\]

and let

\[
 H_n=\left(\operatorname{Sym}^n L^*\otimes
 (J_3)_6\otimes W\right)^{A_4}
\]

be the order-three first-post-gate line source.  The reduced divisor of
`D_L` is the `A4/V4` orbit of the three `D12` points.  For `n>=2`, the
equivariant global-section sequence of

\[
 0\to\mathcal O_L(n-3)\xrightarrow{D_L}\mathcal O_L(n)
 \to\mathcal O_D(n)\to0
\]

is exact.  Finite-group invariants are exact in characteristic zero and in
characteristic 67.  Hence

\[
 0\to H_{n-3}\xrightarrow{D_L}H_n\to
 H^0(D,\mathcal O_D(n)\otimes(J_3)_6\otimes W)^{A_4}\to0. \tag{1}
\]

The quotient in (1) has dimension 11.  The source dimensions begin

```text
n:       0  1  2  3  4  5  6  7  8
dim H_n: 3  8 11 14 19 22 25 30 33
```

and `dim H_n-dim H_(n-3)=11` for every `n>=3`.

## The recurrence that fails

At a `D12` point the three incident line germs prescribe three copies of a
single central-plane normalization jet.  Their pairwise equality has rank
eight on the eleven-dimensional evaluation quotient, leaving dimension
three.  The exact split-67 reconstruction gives this rank for boundary
powers `4,5,6`.  Multiplication by the dihedral invariant

\[
 g=U^3+V^3
\]

shifts the boundary power by three and restricts to the nonzero scalar
`2h^3` on each central branch.  Thus these three residues describe every
boundary power at the central-equality level.

For powers `4,5,6`, the residual point map has rank three on the remaining
quotient.  Consequently its kernel is exactly `D_L H_(n-3)` in the tested
first degrees.  This equality cannot be iterated all degree.  The residual
`D12`, `m=3` point module is finite length and ends in point degree 28.  At
boundary power 23 the first jet has point degree 29, the residual target is
zero, and the split-67 reconstruction gives a three-dimensional survivor in
line degree two which is not a `D_L` multiple.

This is a precise counterexample to using finite point residuals as an
unbounded divisibility engine.  It is not a global landing state and it is
not a characteristic-zero counterexample to the headline theorem.

## Nonlinear boundary distinction

For line degrees two and three, the complete Klein coefficient ideal on the
central-compatible subspace is projectively empty over the algebraic closure
of `F_67` for each boundary-power residue `4,5,6`.  But after restricting
only to the three boundary points, the cubic row space has rank one and the
projective landing support is nonempty.  Therefore a congruence

\[
 F(q)\equiv0\pmod {D_L}
\]

does not imply `F(q)=0`, and nonlinear divisibility by `D_L` cannot be
deduced from the low-degree unit ideals.

## The line-degree-four primitive support

At line degree four the central-compatible source has dimension 11 and the
subspace `D_L H_1` has dimension eight.  Three exact linear forms cut out
that subspace:

```text
20*z_1 + 63*z_5 + z_6
66*z_0 + 10*z_4 + z_9
53*z_2 +  6*z_3 + z_10.
```

The complement is covered by setting one of these forms to one.  The chart
linear equation is eliminated symbolically before solving, so the solver
sees ten variables and the 24 substituted Klein coefficient cubics, with no
affine-linear coordinate recovery.  On all three charts both msolve and
Singular return the unit ideal over `F_67`.  Consequently the geometric
split-67 support of the line-degree-four central-compatible ideal has no
point outside `P(D_L H_1)`.

This does not make the full support empty.  Multiplication by `D_L` carries
the known degree-one landing scheme into it; that degree-one scheme has a
nonempty saturated support of dimension one on the affine cone and
projective degree 48.  Thus degree four contains inherited landing states
and has no new primitive split-67 points.

The first default msolve run must not be used: its automatic random-linear-
form recovery printed a nominal degree-48 RUR, but direct substitution makes
the required affine chart equation equal `-1`.  The adversarial verifier
records this rejection.  The eliminated-chart certificate is the binding
one.

Because the primitive complement is not proper, emptiness of its special
fibre does not transfer by the proper good-reduction argument used for the
line-constant projective schemes.  The separate exact cyclotomic computation
described below is needed for the transfer.  Computations in the next line
degrees would still be a finite ladder and cannot replace an all-degree
theorem.

The strengthened scheme audit in `LINE4_SCHEME_RIGIDITY.md` proves more in
the split fibre: on all eight inherited projective charts the full chart
algebra has vector-space dimension 48 and the three primitive quotient
coordinates have zero normal form.  Hence the entire split-67 degree-four
scheme equals `D_L` times the degree-one scheme scheme-theoretically.  The
normal Jacobian has rank three everywhere on it.  This replaces the former
set-theoretic statement.

`LINE1_CHAR0_FLATNESS.md` now reconstructs the complete degree-one landing
ideal over `Q(zeta_11)`.  Its exact RREF spans all 760 unisolvent coefficient
rows, and its affine algebra has length 48 both generically and after split-67
reduction.  This proves finite flatness over the localized cyclotomic DVR.
The inclusion `D_L X_1 subset X_4`, special-fibre scheme equality, and
Nakayama then prove `X_4=D_L X_1` in characteristic zero.  The remaining gap
is an all-line-degree mechanism, not the degree-four base change.
