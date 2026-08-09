# Equivariant extension complex and first obstruction

Let `Y=P(W)`, let `I_D` be the ideal sheaf of the complete reduced network, and
write

\[
A_d=H^0(Y,O_Y(d)\otimes W)^G
    =(\operatorname{Sym}^dW^*\otimes W)^G.
\]

## 1. Zeroth-order restriction

The exact equivariant sequence is

\[
0\to H^0(I_D(d)\otimes W)^G
 \to A_d
 \xrightarrow{\rho_D}
 H^0(D,O_D(d)\otimes W)^G
 \to H^1(I_D(d)\otimes W)^G\to\cdots .
\]

A morphism $\lambda_D:D\to\mathbf P(W)$ determines a line subbundle

\[
\lambda_D^*\mathcal O_{\mathbf P(W)}(-1)\subset W\otimes\mathcal O_D.
\]

Degree-`d` coordinate representatives
are sections of

\[
M_d=O_D(d)\otimes\lambda_D^*O(-1).
\]

A nowhere-zero section gives a literal morphism representative. A section
that is merely nonzero on each generic component gives a rational
representative with boundary base points. The corresponding coordinate tuple
is its image in $H^0(D,\mathcal O_D(d)\otimes W)$.

At `d=25`, the elliptic restriction of every such representative is a nonzero
constant multiple of the canonical `[-5]` coordinate line. It therefore has
ordinary plus-plane order zero.

## 2. Exact source and target

The repository's exact Molien calculation gives

\[
\dim A_{25}=189.
\]

The full target has the exact induced-module normalization presentation

\[
\begin{aligned}
0\to H^0(D,O_D(25)\otimes W)\to
&\operatorname{Ind}_{N}^{G}U_E
 \oplus\operatorname{Ind}_{N}^{G}U_L\\
\to{}&\operatorname{Ind}_{V_4}^{G}Q_I
 \oplus\operatorname{Ind}_{V_4}^{G}Q_{II}\to0,
\end{aligned}
\]

where `N=N_G(<t>)` has order 12,

\[
U_E=H^0(E_t,O_E(25))\otimes W,
\quad
U_L=H^0(L_t,O_L(25))\otimes W,
\]

and `Q_I,Q_II` are the two-copy branch-value quotients at a representative
triple node. Surjectivity follows because `O_E(25)` has degree 75 and only 12
marked nodes, while `O_{P^1}(25)` has only six; all component evaluation maps
are surjective. Taking invariants is exact in characteristic zero.

The invariant dimensions are exact:

- elliptic normalization: `dim U_E^N=38`;
- line normalization: `dim U_L^N=9`;
- type-I node quotient: `dim Q_I^{V4}=2`;
- type-II node quotient: `dim Q_II^{V4}=4`.

Therefore

\[
\dim H^0(D,O_D(25)\otimes W)^G=38+9-2-4=41.
\]

The character computations are finite and replayed by
`verify_boundary_obstruction.py`. On an elliptic, the central involution acts
trivially on $\mathcal O_E(25)$, so only the $W_+$ target contributes. The
residual $S_3$ characters of $H^0(E,\mathcal O_E(25))$ and $W_+$ are
respectively $(75,1,0)$ and $(3,1,0)$ on identity, transpositions, and
three-cycles; hence the invariant dimension is

\[
\frac{225+3}{6}=38.
\]

On a fixed line, the central involution acts by $-1$ on both
$\mathcal O_L(25)$ and $W_-$, while it excludes the $W_+$ target. The dihedral
character average of $\operatorname{Sym}^{25}(W_-^*)\otimes W_-$ is

\[
\frac{52+52+2+2}{12}=9.
\]

At a type-II node the ambient point has trivial $V_4$ character, so the fiber
contributes $\dim W^{V_4}=2$; tensoring with the two-dimensional branch-value
quotient gives 4 invariants. At a type-I point the fiber of
$\mathcal O(25)$ has the corresponding nontrivial character $\chi_i$. Since

\[
W|_{V_4}=\mathbf 1^{\oplus2}\oplus\chi_1\oplus\chi_2\oplus\chi_3,
\]

twisting by $\chi_i$ leaves one invariant line; the branch-value quotient
doubles it, giving 2.

## 3. The desired class is not in the landing image

Define the degree-25 landing locus

\[
Z_{25}=\{p\in A_{25}:F(p)=0\}.
\]

For every `p in Z_25`, the plus-plane theorem gives

\[
p|_{P(W_+(t))}=0
\]

for every involution. Hence the composite

\[
Z_{25}\xrightarrow{\rho_D}
H^0(D,O_D(25)\otimes W)^G
\longrightarrow H^0(E_t,O_E(25)\otimes W)
\]

is identically zero. Choose the normalizer-equivariant degree-25 coordinate
line of `[-5]` and let `beta_t` be any nonzero vector on it. Then

\[
\operatorname{res}_{E_t}(Z_{25})=\{0\},\qquad \beta_t\ne0,
\]

so

\[
[\beta_t]\in
H^0(E_t,\mathcal O_{E_t}(25)\otimes W_+(t))\big/\operatorname{res}_{E_t}(Z_{25})
\]

is an explicit nonzero obstruction class. Every change of degree-25
representative multiplies `beta_t` by a nonzero scalar; multiplying by a scalar
that vanishes identically on `E_t` destroys the boundary restriction rather
than extending it. Thus the desired boundary class is outside the image of the
landing locus. This is an exact nonlinear fiber obstruction, not an inference
from a broad empty search.

The rank of the unrestricted linear map $\rho_D:A_{25}\to H^0(D,\mathcal O_D(25)\otimes W)^G$ is not needed
for this theorem and is not claimed. The literal basepoint-free class is
already impossible by the component line-bundle calculation; after allowing
base points, landing fails on the elliptic projection before any rank question.

## 4. Kernel, cokernel, and infinitesimal neighborhoods

For the unrestricted linear extension problem,

\[
\ker(\rho_D)=H^0(I_D(25)\otimes W)^G.
\]

Since $H^1(\mathbf P(W),\mathcal O(25)\otimes W)=0$, exactness gives

\[
\operatorname{coker}(\rho_D)
\simeq H^1(I_D(25)\otimes W)^G.
\]

For successive neighborhoods `D_n=V(I_D^{n+1})`, extension from `D_n` to
`D_{n+1}` is governed by

\[
H^i\!\left(D,
 (I_D^{n+1}/I_D^{n+2})(25)\otimes W\right)^G,
\qquad i=0,1.
\]

Because `D` is not lci at its triple-axis nodes, the correct terms are the
actual Rees graded pieces `I_D^n/I_D^{n+1}`, not a globally substituted
symmetric power of a normal bundle.

If a landing tuple existed to order `n`, the next landing equation would be
governed by the linearized map

\[
dF_{p_n}:H^0(gr_I^{n+1}O_Y(25)\otimes W)^G
 \to H^0(gr_I^{n+1}O_Y(75))^G,
\]

with obstruction in its cokernel together with the preceding `H^1` extension
class. For the canonical boundary prescription, no positive normal order is
reached: the obstruction is already at ordinary order zero on every elliptic.
