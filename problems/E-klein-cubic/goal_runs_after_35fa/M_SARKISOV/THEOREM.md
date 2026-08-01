# Exact equivariant Sarkisov theorem

Let \(V_6\) be the six-dimensional Schur representation of
\(\widetilde G=\operatorname{SL}_2(\mathbf F_{11})\), whose center acts
scalarly on \(\mathbf P(V_6)\). Put

\[
E=\mathbf C(\mathbf P(V_6)),\qquad K=E^G.
\]

The extension \(E/K\) is the connected generic \(G\)-torsor. Let \(W\) be
the five-dimensional Klein module and let \(q_0,\ldots,q_4\) be the installed
degree-eight Reynolds covariants. Dividing by the nonzero degree-eight
invariant \(I_8\) gives a \(K\)-basis

\[
\bar q_i=q_i/I_8
\]

of the descended Klein space. Thus

\[
X_T=\{\Phi(a)=0\}\subset\mathbf P^4_K,
\qquad
\Phi(a)=F\!\left(\sum_{i=0}^4a_i\bar q_i\right).
\]

## Theorem M2.1

The plane \(\Pi_{012}=\{a_3=a_4=0\}\) meets \(X_T\) in a smooth
plane cubic \(C_{012}\). Blowing it up resolves the hyperplane pencil
through \(\Pi_{012}\) and gives

\[
X_T\xleftarrow{\pi}Y=\operatorname{Bl}_{C_{012}}X_T
\xrightarrow{f}\mathbf P^1_K,
\qquad f=[a_3:a_4].
\]

The variety \(Y\) is smooth and Fano, and \(f\) is a degree-3 del Pezzo Mori fibre space
with \(\rho(Y/\mathbf P^1)=1\).

The connected orbit of the 55 involution minus-lines is disjoint from the
center. Its strict transform is a degree-55 multisection. The exceptional
divisor contains a degree-3 multisection. Hence the generic cubic-surface
fibre \(S/K(\mathbf P^1)\) has index one and satisfies

\[
S(K(\mathbf P^1))\ne\varnothing
\quad\text{or}\quad
S\text{ has an integral closed point of degree }4.
\]

## Proof

### Projective-field descent

All five frame columns and \(I_8\) have the same homogeneous degree. Their
ratios are degree-zero functions on \(\mathbf P(V_6)\), so the coordinates
\(a_i\), the plane, center, pencil, blowup, and both contractions are defined
over \(K\). This is a direct projective-torsor descent, not a stable extension
from the affine field.

At the good fibre \((23,\zeta_{11}=2)\), use the exact source point

```text
(13,9,5,5,8,19).
```

The five Reynolds columns form the matrix

```text
18 15  0 11  6
 1 19  8 14 12
11  2 13 21  2
17  3 20 14 19
 9  4 16 17  9
```

with determinant `9`; \(I_8\) has value `10`, and the normalized determinant
is `15`. The first three columns give the plane cubic

\[
-3a_0^3+2a_0^2a_1-4a_0^2a_2+5a_0a_1^2-5a_0a_1a_2
+4a_0a_2^2+2a_1^3-10a_1^2a_2-5a_1a_2^2-2a_2^3
\]

modulo 23. Its gradient ideal is the unit ideal on all three projective
charts. Proper good reduction therefore proves that the characteristic-zero
generic section is smooth.

### Simultaneous avoidance of the line orbit

The exact target action has 660 matrices and exactly 55 involutions. For each
involution \(t\), its minus-eigenspace has dimension two and
\(L_t=\mathbf P(E_-(t))\subset X\). Concatenating a basis of \(E_-(t)\)
with the three plane columns above gives a `5 x 5` matrix. The independent
verifier reconstructs all 55 determinants; all are nonzero modulo 23 and
their deterministic product is `10`.

Thus the incidence norm is not the zero function in characteristic zero, so
the descended coordinate plane is disjoint from every geometric line in the
orbit. The setwise stabilizer of a line is \(D_{12}\), hence the connected
generic torsor turns the orbit into the degree-55 field \(E^{D_{12}}/K\).
Projection from \(\Pi_{012}\) maps every orbit line isomorphically to the
pencil base. On the generic fibre this is one closed point of exact degree
55.

### Extraction and two rays

Because \(C_{012}\) is the transverse intersection of two hyperplanes,

\[
N_{C_{012}/X_T}=\mathcal O_C(1)\oplus\mathcal O_C(1).
\]

The ordinary blowup is smooth with discrepancy one. Its graph is

\[
Y=\{\Phi(a)=0,\ a_3t-a_4s=0\}
\subset\mathbf P^4_a\times\mathbf P^1_{[s:t]}.
\]

Over \([s:t]\), write \(a_3=su\), \(a_4=tu\). The fibre is the cubic
surface

\[
\Phi(a_0,a_1,a_2,su,tu)=0\subset\mathbf P^3.
\]

With \(H=\pi^*\mathcal O_X(1)\), exceptional divisor \(D\), and
\(L=H-D=f^*\mathcal O_{\mathbf P^1}(1)\),

\[
-K_Y=2H-D=H+L.
\]

The product \((\pi,f)\) is the graph embedding, so \(H+L\) is ample.
The exact cones and Cox presentation in `DIVISOR_COX.md` show that the only
two rays are \(\pi\) and \(f\); there is no flop.

### Arithmetic output

The hyperplane \(u=0\) on the generic fibre is \(C_{012}\), whose plane
polarization gives a degree-3 zero-cycle. Together with the degree-55 point,

\[
\operatorname{ind}(S)\mid\gcd(3,55)=1.
\]

Voisin's characteristic-zero cubic-surface theorem yields a rational point
or a point over an extension of degree four. If no rational point exists,
quadratic third-intersection descent rules out residue degree two, so the
second output is genuinely degree four. Closure and normalization give the
claimed quartic multisection.

## Headline boundary

A rational section extends over \(\mathbf P^1\); evaluating at a
\(K\)-point of the base and composing with \(\pi\) gives a \(K\)-point of
the genuine twist, hence the accepted positive bridge. The quartic branch is
only a multisection. This theorem selects neither branch and proves no
negative rigidity statement. Therefore the Problem E headline remains open.
