# Genuine-twist valuation models

## 1. Field and point problem

Let

\[
L=\mathbf C(W),\qquad K_{\rm aff}=L^G.
\]

On the free locus, $L/K_{\rm aff}$ is the genuine generic $G$-torsor.
The primitive covariant matrix

\[
M=[x\ C\ D\ E\ K]
\]

is generically invertible.  Its columns are a $K_{\rm aff}$-basis of the
twisted five-space, and the genuine twist is

\[
Y:\quad \Phi(a)=F(Ma)=0\subset\mathbf P^4_{K_{\rm aff}}.
\]

This is the actual Hilbert--90 model from the binding dossier.  It is distinct
from the fixed-frame Pfaffian plane cubic and from its characteristic cubic.

The projective field satisfies

\[
K_{\rm aff}\simeq K_{\rm proj}(u).
\]

Because $Y$ is proper, the global point problem is unchanged by this purely
transcendental extension.  Locally, this packet makes claims only over the
displayed completions of $K_{\rm aff}$; it does not infer descent of a local
point to a chosen $K_{\rm proj}$-completion.

## 2. Five prime divisors

For the frame degrees

\[
(d_0,\ldots,d_4)=(1,4,5,6,7),
\]

put $V_i=(x,C,D,E,K)_i$ and

\[
P_i=F(V_i)\in\mathbf Z[W]^G,\qquad \deg P_i=3d_i.
\]

The machine payload proves:

| $i$ | column | $P_i$ | degree | source terms | smooth plane attempt | transverse witness attempt |
|---:|---|---|---:|---:|---:|---:|
| 0 | $x$ | $f_3$ | 3 | 5 | 1 | 96 |
| 1 | $C$ | $f_{12}$ | 12 | 150 | 2 | 6 |
| 2 | $D$ | $F(D)$ | 15 | 306 | 1 | 31 |
| 3 | $E$ | $F(E)$ | 18 | 585 | 1 | 6 |
| 4 | $K$ | $F(K)$ | 21 | 1090 | 1 | 72 |

The attempt numbers are deterministic discovery metadata, not probabilistic
proofs.  Each saved matrix and point is replayed exactly.

### Absolute primality

For each $P_i$, the payload gives a $5\times3$ matrix over
$\mathbf F_{23}$.  Restriction along this plane produces a nonzero
homogeneous plane curve.  Its homogeneous gradient ideal has affine-cone
dimension zero, so it has no projective geometric singular point.  Since its
degree is $<23$, Euler's identity introduces no characteristic divisor.

A positive-degree factorization over
$\overline{\mathbf F}_{23}$ would restrict to two nonzero positive-degree
plane curves.  Bézout forces those components to meet, making the restriction
singular.  Hence the restriction and then $P_i\bmod23$ are geometrically
irreducible.  Good reduction proves $P_i$ absolutely irreducible in
characteristic zero.

### Quotient valuation and ramification

Let $E_i=(P_i=0)$ in the source and let $D_i$ be its contraction to the
finite invariant-field quotient.  The form $P_i$ is $G$-invariant and has
source order one along the absolutely prime divisor.  For normalized
valuations,

\[
1=v_{E_i}(P_i)=e(E_i/D_i)v_{D_i}(P_i).
\]

Both right-hand factors are positive integers, so

\[
e(E_i/D_i)=1,\qquad v_{D_i}(P_i)=1.
\]

Thus $P_i$ is a uniformizer of the $K_{\rm aff}$-valuation and there is no
hidden divisorial ramification.

## 3. Proper integral model and Hensel point

Let $R_i$ be the valuation ring (or its henselization/completion).  Every
coefficient of $\Phi$ is an invariant polynomial, hence lies in $R_i$.
The hypersurface

\[
\mathcal Y_i=
\operatorname{Proj}R_i[a_0,\ldots,a_4]/(\Phi)
\]

is a proper integral model of the generic twist.  On the special fibre,

\[
\overline\Phi(e_i)=\overline{P_i}=0.
\]

For $j\ne i$, the derivative at the axis point is the polar coefficient

\[
\frac{\partial\Phi}{\partial a_j}(e_i)
= [a_i^2a_j]\,F\!\left(\sum a_kV_k\right).
\]

At the saved source witness modulo 23:

1. $P_i=0$;
2. $\det M\ne0$;
3. the Klein cubic is smooth;
4. at least one displayed polar coefficient is nonzero.

The nonzero restriction proves that the derivative coefficient is not
divisible by the characteristic-zero prime $P_i$.  It is therefore a unit
at the generic point of $D_i$.  The special point $e_i$ is smooth and
multivariate Hensel yields

\[
\mathcal Y_i(R_i^h)\ne\varnothing,
\qquad
Y(K_{{\rm aff},D_i})\ne\varnothing.
\]

No regularity or semistability of the whole model is asserted or needed for
this positive local conclusion.

## 4. Independent replay design

`produce_axis_divisors.py` reconstructs the literal covariants, performs
sparse plane substitution, and asks Macaulay2 for the gradient-ideal
dimensions.

`verify_axis_divisors.py` does not import the producer.  It instead:

- imports the separately accepted 35-coefficient Hilbert--90 reconstruction;
- proves each saved plane polynomial identity on a
  $(d+1)\times(d+1)$ interpolation grid over $\mathbf F_{23}$;
- recomputes every gradient ideal with Singular;
- recomputes frame determinants and all five axis derivatives by an
  independent finite-field determinant routine;
- checks both exact degree-one zero-cycle combinations.

The full sparse polynomials need not be serialized: the authoritative source
hash, plane restrictions, witnesses, and independent reconstruction form the
certificate.

## 5. Discrete rank-one tropical support

The exact equation has all 35 cubic monomials and, in particular, all five
pure cubes.  For any normalized discrete valuation of its coefficients, the
five pure-cube heights contain two congruent modulo three.  The corresponding
binary lower Newton polygon has an integral-slope edge, which yields an
integral tropical projective value vector after the other weights are made
large.

This is a value-vector theorem only.  It does not lift that vector through
the residue initial form, and it does not apply to higher-rank value groups.

## 6. The $f_5$ Hessian-line probe

The source identity

\[
\det\operatorname{Hess}(F)=32f_5
\]

supplies a canonical kernel line at the generic point of $f_5=0$.  The
separate certificate `hessian_line.json` proves by exact polynomial division
that the restriction of $F$ to the span of $x$ and that kernel is a pure
binary cubic.  Its coefficient ratio has a geometric valuation of order one,
so it is not a cube.  Consequently this line supplies no generic residue
point.  See `HESSIAN_LINE.md` for the theorem and its strict scope.

This is a probe on the source base change of the genuine residue twist.  Any
point supplied by the descended canonical line would remain a point after
that base change, so the noncube excludes it.  No converse descent statement
and no theorem about points away from the line is asserted.

## 7. Strict boundary

The five models prove five local points.  They prove neither a global point
nor an all-valuations theorem.  In particular, the existence of a point at
each $D_i$ supplies no local--global principle over the
transcendence-degree-five field.
