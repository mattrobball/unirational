# Extension complex and first exact obstruction

## 1. The restriction problem must use the correct line bundle

The coordinate sections of the morphism \(\lambda_D\) live in

\[
H^0\!\left(D,\lambda_D^*\mathcal O_X(1)\right)\otimes W.
\]

A homogeneous degree-25 ambient tuple restricts instead to

\[
H^0(D,\mathcal O_D(25))\otimes W.
\]

These bundles are not isomorphic. Their restrictions have degrees \(75,1\) on
an elliptic and a line, whereas \(\mathcal O_D(25)\) has degrees \(75,25\).
Thus the proposed boundary coordinate tuple is not literally an element of the
degree-25 restriction target.

To formulate a rational degree-25 representative, one must choose component
scalar data in

\[
\mathcal A=
\mathcal O_D(25)\otimes\lambda_D^*\mathcal O_X(1)^{-1}
\]

and multiply the pulled-back coordinate tuple by a section of \(\mathcal A\).
On every elliptic that scalar has degree zero; on every line it has degree 24.
This componentwise scalar issue is distinct from the removable *global
invariant common factor* in the universal-object theorem.

The decisive obstruction below already occurs on one elliptic and is
independent of how the line scalars are chosen.

## 2. Exact degree-25 ambient source

Let

\[
M_{25}=\left(\operatorname{Sym}^{25}W^*\otimes W\right)^G.
\]

Order the conjugacy classes as
\((1A,2A,3A,5A,5B,6A,11A,11B)\). Their sizes, the character of \(W\), and the
degree-25 symmetric character are

\[
\begin{array}{c|rrrrrrrr}
 &1A&2A&3A&5A&5B&6A&11A&11B\\ \hline
|C|&1&55&110&132&132&110&60&60\\
\chi_W&5&1&-1&0&0&1&a&\bar a\\
\chi_{\operatorname{Sym}^{25}W^*}
&23751&91&-9&1&1&1&2&2
\end{array}
\]

where \(a+\bar a=-1\) and \(a\bar a=3\). Therefore

\[
\dim M_{25}
=
\frac{5\cdot23751+55\cdot91+110\cdot9+110-120}{660}
=189.
\]

Fix the irreducible labels by \(5a=W\), \(5b=W^*\),
\(\chi_{10a}(2A)=-2\), and \(\chi_{10b}(2A)=2\). Orthogonality with the exact
eight-class character table gives

\[
\begin{aligned}
\operatorname{Sym}^{25}W^*\otimes W\simeq{}&
189\,\mathbf 1\oplus907\,(5a)\oplus905\,(5b)\\
&\oplus1786\,(10a)\oplus1816\,(10b)\oplus1970\,(11)\\
&\oplus2159\,(12a)\oplus2159\,(12b).
\end{aligned}
\]

The underlying dimension is
\(118755=5\binom{29}{4}\). Thus the equivariant source is precisely the
189-dimensional trivial isotypic summand. This independently agrees with the
accepted degree-25 Molien certificate \(c_{25}=189\).

## 3. Exact network target for degree-25 tuples

Put

\[
T_{25}=\left(H^0(D,\mathcal O_D(25))\otimes W\right)^G.
\]

Let \(N=C_G(t)\simeq C_2\times S_3\), and let \(V\simeq V_4\) be a point
stabilizer. The normalization sequence gives the exact representation-ring
identity

\[
\begin{aligned}
[H^0(D,\mathcal O_D(25))\otimes W]
={}&[\operatorname{Ind}_N^G(
 H^0(E_t,\mathcal O_{E_t}(25))\otimes W|_N)]\\
&+[\operatorname{Ind}_N^G(
 H^0(L_t,\mathcal O_{L_t}(25))\otimes W|_N)]\\
&-[\operatorname{Ind}_V^G(k^2\otimes\chi_I\otimes W|_V)]\\
&-[\operatorname{Ind}_V^G(k^2\otimes W|_V)].
\end{aligned}
\]

Here \(\chi_I\) is the \(\mathcal O(1)\)-fiber character at a type-I point;
the type-II fiber character is trivial. The two copies of \(k\) record the
rank-two mismatch among three branches at an ordinary triple point.

The normalization evaluation is surjective. On an elliptic,
\(\deg\mathcal O_{E_t}(25)=75\), so it separates all 12 network points; on a
line, \(\mathcal O_{L_t}(25)\) separates its six type-I points. Hence there is
no hidden \(H^1\) term in this representation-ring identity.

### Elliptic contribution

After passing to the residual \(S_3\),

\[
E_+(t)\simeq\mathbf1\oplus\mathrm{std},
\qquad E_-(t)\simeq\mathrm{std}
\]

with the central \(t\)-sign retained separately on \(E_-\). The cubic
restriction sequence gives

\[
\chi_{H^0(E_t,\mathcal O(25))}=(75,1,0)
\]

on the identity, transposition, and three-cycle classes, hence

\[
H^0(E_t,\mathcal O(25))
\simeq13\,\mathbf1\oplus12\,\mathrm{sgn}
       \oplus25\,\mathrm{std}.
\]

Pairing with the \(t\)-even target \(E_+=\mathbf1\oplus\mathrm{std}\)
contributes \(13+25=38\) invariants.

### Line contribution

On \(L_t\), the central sign in
\(\operatorname{Sym}^{25}(E_-^*)\) cancels the central sign on the
\(E_-\)-target. The invariant count is the multiplicity of
\(\mathrm{std}\) in \(\operatorname{Sym}^{25}(\mathrm{std})\), namely 9.

### Node corrections and full target decomposition

At a type-I point, \(W|_V\) contains the fiber character \(\chi_I\) once, so
the invariant correction is 2. At a type-II point,
\(\dim W^V=2\), so the invariant correction is 4.

Frobenius reciprocity for all eight irreducibles gives

\[
\begin{aligned}
H^0(D,\mathcal O_D(25))\otimes W\simeq{}&
41\,\mathbf1\oplus189\,(5a)\oplus189\,(5b)\\
&\oplus364\,(10a)\oplus378\,(10b)\oplus404\,(11)\\
&\oplus445\,(12a)\oplus445\,(12b).
\end{aligned}
\]

Equivalently, its character is

\[
(24475,43,1,0,0,1,0,0).
\]

Thus

\[
\boxed{\dim T_{25}=38+9-2-4=41.}
\]

The underlying-dimension check is

\[
24475=55(75\cdot5)+55(26\cdot5)-330(2\cdot5).
\]

## 4. Linear kernel and cokernel

Ignoring the landing equation, equivariant exactness gives

\[
0\to
\left(H^0(\mathcal I_D(25))\otimes W\right)^G
\to M_{25}\xrightarrow{r_{25}}T_{25}
\to
\left(H^1(\mathcal I_D(25))\otimes W\right)^G
\to0.
\]

Therefore

\[
\ker r_{25}=
\left(H^0(\mathcal I_D(25))\otimes W\right)^G,
\]

and the displayed \(H^1\) is the exact linear cokernel. This packet does not
claim the rank of the unrestricted linear map \(r_{25}\): that question is
strictly weaker than extension by a *landing* covariant. For the landing
locus, the elliptic projection of the image is computed exactly below—it is
zero—so every scaled representative of the canonical boundary with nonzero
elliptic scalar is outside the landing restriction image.

## 5. Successive infinitesimal neighborhoods

Let \(\mathcal I=\mathcal I_D\), and let
\(D_n=V(\mathcal I^{n+1})\). The obstruction to extending a chosen degree-25
tuple from \(D_n\) to \(D_{n+1}\) lies in

\[
H^1\!\left(
D,
\mathcal I^{n+1}/\mathcal I^{n+2}
\otimes\mathcal O_D(25)\otimes W
\right)^G.
\]

When it vanishes, the choices form a torsor under the corresponding \(H^0\).
At the ordinary triple points, the associated graded must retain the exact
multiple-branch modules \(\mathcal I^n/\mathcal I^{n+1}\); it cannot be
replaced blindly by the symmetric algebra of one normal bundle.

These groups would govern a genuine degree-25 boundary tuple. They are not
reached.

## 6. Zeroth-order landing obstruction

Let

\[
Z=\bigcup_t Z_t,
\qquad Z_t=\mathbf P(E_+(t)).
\]

For every homogeneous landing covariant of every degree, the accepted
plus-plane theorem gives

\[
p\in\left(H^0(\mathcal I_Z(d))\otimes W\right)^G.
\]

In particular, for \(d=25\),

\[
p|_{E_t}=0
\]

for every fixed elliptic. By contrast, the coordinate tuple for
\([-5]:E_t\to E_t\),

\[
\beta_t\in
H^0(E_t,\mathcal O_{E_t}(25))\otimes E_+(t),
\]

is nonzero and basepoint-free. Consequently the elliptic projection of the
landing restriction image is the zero subspace, while the required boundary
class has nonzero projection:

\[
\operatorname{obs}_0(\lambda_D)=\beta_t\ne0.
\]

This is the first genuine obstruction. It is an impossible restriction map
for this exact boundary class, not an inference from an empty generic
covariant search. It terminates the extension problem before any first-order
or higher normal-neighborhood obstruction.
