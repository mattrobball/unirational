# Exclusion of the ruled curve-image branch

Assume the retraction base

\[
B=V_X(H),\qquad \deg H=d-1,
\]

is irreducible and that the normalized Pluecker graph has one-dimensional
image

\[
\Sigma\subset S=F(X).
\]

The global dichotomy gives

\[
[\Sigma]=nC,\qquad d=5n+1,\qquad n\ge2,
\tag{1.1}
\]

where `C` is an incidence class on the Klein Fano surface.

## 1. Every line in the family meets every involution elliptic

Fix an involution `t`.  The retraction base contains

\[
E_t\subset B.
\]

Let

\[
Y\sim_{\rm bir}\mathbf P(T_S)|_{\Sigma^\nu}
\]

be the normalized line graph.  The inverse image of `E_t` in `Y` contains a
curve which dominates `Sigma^nu`.  Otherwise every component above `E_t`
would map to one of finitely many points of `Sigma`, and its image in `B`
would be contained in a finite union of the corresponding lines.  An
irreducible plane cubic cannot be contained in a finite union of lines.

Therefore a general line parametrized by `Sigma` meets `E_t`.  Put

\[
M_t=\{[\ell]\in S:\ell\cap E_t\ne\varnothing\}.
\tag{1.2}
\]

Then

\[
\Sigma\subset M_t
\tag{1.3}
\]

for every one of the 55 involutions.

## 2. The class of `M_t`

Let

\[
\pi:\mathcal I=\mathbf P(T_S)\to S,
\qquad e:\mathcal I\to X
\]

be the universal line family, and set

\[
\xi=e^*H_X.
\]

The curve `E_t` is the complete intersection of `X` with two hyperplanes, so

\[
[E_t]=H_X^2.
\]

As a cycle on `S`,

\[
[M_t]
=\pi_*e^*[E_t]
=\pi_*(\xi^2).
\tag{2.1}
\]

The tangent-bundle theorem identifies `I` with the projectivized cotangent
bundle whose tautological class is `xi`; the rank-two projective-bundle
formula gives

\[
\pi_*(\xi^2)=c_1(\Omega_S)=K_S=3C.
\tag{2.2}
\]

Thus

\[
[M_t]=3C.
\tag{2.3}
\]

Since `Sigma` is an irreducible component of the effective curve `M_t`, the
residual cycle `M_t-Sigma` is effective.  Intersecting with the ample class
`C` gives

\[
0\le C\cdot(M_t-\Sigma)=5(3-n).
\]

Hence

\[
n\le3.
\tag{2.4}
\]

Together with (1.1),

\[
n\in\{2,3\},
\qquad
(d,n)\in\{(11,2),(16,3)\}.
\tag{2.5}
\]

## 3. The two degrees are already rigorously empty

The durable characteristic-zero self-covariant certificates prove that no
homogeneous `G`-equivariant landing tuple exists in any degree at most 24.
In particular:

- the direct degree-11 Macaulay2 certificate reconstructs the complete
  12-dimensional covariant space and proves its projective landing locus
  empty;
- the accepted bounded landing theorem extends the exact exclusion through
  degree 24.

Therefore neither degree in (2.5) can occur.

### Theorem 3.1

There is no irreducible retraction base whose canonical line map has
one-dimensional image.

Equivalently, for every hypothetical retraction with irreducible base,

\[
\boxed{
\Gamma_{\rm line}\longrightarrow F(X)
\text{ is dominant and generically finite}.}
\tag{3.1}
\]

Consequently every smooth model `Y` of the normalized Pluecker graph satisfies

\[
q(Y)\ge5,\qquad p_g(Y)\ge10,\qquad \rho(Y)\ge25.
\tag{3.2}
\]

## 4. Scope

The argument uses irreducibility of the full base `B` twice:

1. to prove the Pluecker system does not collapse identically;
2. to identify its normalized graph with one ruled family in the
   one-dimensional-image branch.

For reducible `B`, components may be permuted by `G`, some components may be
fixed components of the Pluecker system, and different involution elliptics
may lie on different components.  That branch is not silently excluded here.

The exact new exit is

```text
DELTA1-IRREDUCIBLE-BASE-RULED-BRANCH-EXCLUDED
DELTA1-IRREDUCIBLE-BASE-DOMINATES-FANO-SURFACE
```
