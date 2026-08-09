# The retraction Fano--Rees carrier theorem

## 1. Setup and canonical Pluecker ideal

Let

\[
X=V(F)\subset\mathbf P(W_5)
\]

be the Klein cubic, let `Phi` be the symmetric trilinear polarization with
`Phi(x,x,x)=F(x)`, and assume that

\[
T:\mathbf P(W_5)\dashrightarrow X
\]

is a primitive homogeneous `G`-equivariant landing map whose restriction to
`X` is the identity.  Use the accepted normal form

\[
T=Hx+FQ,
\tag{1.1}
\]

and put

\[
B=V_X(H).
\tag{1.2}
\]

The gauge change

\[
(H,Q)\longmapsto(H+FU,Q-Ux)
\]

does not change the ten forms

\[
\Pi_{ij}=x_iQ_j-x_jQ_i.
\tag{1.3}
\]

They are intrinsic to `T`, since

\[
x_iT_j-x_jT_i=F\Pi_{ij}.
\tag{1.4}
\]

Let `J_line` be the ideal generated on `B` by the `Pi_ij`.  Its normalized
blowup

\[
\Gamma_{\rm line}
=\operatorname{Proj}_B\overline{\mathcal R(J_{\rm line})}
\tag{1.5}
\]

is the normalization of the graph of the rational line map

\[
\lambda:B\dashrightarrow\operatorname{Gr}(2,W_5),
\qquad
x\longmapsto\langle x,Q(x)\rangle.
\tag{1.6}
\]

On the noncollapsed locus of `B`, the complete polar system gives

\[
F(ux+vQ(x))=0
\qquad\text{for all }[u:v]\in\mathbf P^1.
\tag{1.7}
\]

Therefore `lambda` lands in the Fano surface `S=F(X)` of lines on `X`.
Equation (1.5), rather than an arbitrary blowup of `B`, is the carrier model
used below.

## 2. The fixed-line curve on the Fano surface

Fix an involution `t`.  Write

\[
W_5=W_+(t)\oplus W_-(t),
\qquad \dim W_+=3,\quad\dim W_-=2,
\]

and put

\[
E_t=X\cap\mathbf P(W_+),
\qquad
L_t=\mathbf P(W_-).
\]

Since `F` is `t`-invariant and cubic, its mixed decomposition has the form

\[
F(x+y)=F(x)+3\Phi(x,y,y),
\qquad x\in W_+,\ y\in W_-.
\tag{2.1}
\]

The terms with one or three minus variables vanish.  Hence a mixed
`t`-stable line `P(<x,y>)` lies on `X` exactly when

\[
x\in E_t,\qquad \Phi(x,y,y)=0.
\tag{2.2}
\]

Define

\[
R_t=
\{([x],[y])\in E_t\times L_t:\Phi(x,y,y)=0\}.
\tag{2.3}
\]

### Theorem 2.1 — geometry of `R_t`

The map

\[
([x],[y])\longmapsto[\mathbf P(\langle x,y\rangle)]
\tag{2.4}
\]

identifies `R_t` with the one-dimensional component of the fixed locus
`S^t`.  The other fixed component is the isolated point represented by the
line `L_t`.  Moreover:

\[
R_t\to E_t\text{ has degree }2,
\qquad
R_t\to L_t\text{ has degree }3,
\tag{2.5}
\]

and `R_t` is a smooth connected curve of genus four.

### Proof

A `t`-invariant two-dimensional vector subspace is either contained in an
eigenspace or is the sum of one plus and one minus eigenline.  The smooth plane
cubic `E_t` contains no line, while `P(W_-)` itself is the line `L_t`.
Consequently every non-isolated fixed point of `S` is represented uniquely by
a mixed line, and (2.2) proves (2.4).

The fixed locus of a finite-order automorphism on the smooth surface `S` is
smooth in characteristic zero.  Equation (2.3) is a section of

\[
\mathcal O_{E_t}(1)\boxtimes\mathcal O_{\mathbf P^1}(2).
\tag{2.6}
\]

This line bundle is ample, so its zero divisor is connected.  Hence `R_t` is
smooth and irreducible.  The two projection degrees follow directly from the
bidegree.  On `E_t x P1`, if `A` is the class of a vertical `P1` and `B` the
class of a horizontal elliptic curve, then

\[
[R_t]=3A+2B,\qquad K_{E_t\times\mathbf P^1}=-2B.
\]

Thus

\[
R_t^2=12,\qquad K\cdot R_t=-6,
\]

and adjunction gives

\[
2g(R_t)-2=6,\qquad g(R_t)=4.
\]

This proves the theorem.  `square`

### Relation with Roulleau's genus-two curve

Let `C_{L_t}` be the incidence divisor on `S` parametrizing lines meeting
`L_t`.  Roulleau's harmonic-inversion calculation gives

\[
C_{L_t}=D_t+R_t,
\tag{2.7}
\]

where `D_t` is the smooth genus-two component and the residual component has
arithmetic genus four.  The component in (2.3) is the residual curve: its
lines contain a point of `E_t` and are fixed by `t`.  The genus-two component
parametrizes the other residual lines in the planes through `L_t`; those lines
are exchanged in pairs by `t`.

Numerically, if `C` is an incidence class, then

\[
C^2=5,\quad C\cdot D_t=2,\quad D_t^2=-4,\quad K_S=3C,
\]

so

\[
R_t=C-D_t,\quad R_t^2=-3,\quad K_S\cdot R_t=9,
\tag{2.8}
\]

again giving genus four.

## 3. Forced singularity of the retraction base

Every landing tuple vanishes on `P(W_+(t))`.  On `X`, equation (1.1) becomes
`T=Hx`; hence

\[
E_t\subset B
\tag{3.1}
\]

for every involution `t`.

### Proposition 3.1

The divisor `B` is singular along every `E_t`.

### Proof

At `x in E_t`, the differential of `H|_X` vanishes on `T_xE_t` because `H`
vanishes identically on `E_t`.  The involution acts by `-1` on the two normal
directions in `T_xX`.  Since `H` is invariant,

\[
dH_x(v)=dH_x(tv)=dH_x(-v)=-dH_x(v)
\]

for every normal vector `v`, so the normal differential also vanishes.  Thus
`d(H|_X)_x=0`.  `square`

In particular, no hypothetical retraction can have a smooth base surface, and
the codimension-one singularity along the 55 elliptics is forced before any
choice of resolution.

## 4. The normalized carrier above an involution elliptic

The accepted normal-character theorem says that the first nonzero transverse
landing layer along `P(W_+(t))` has odd order and takes values in `W_-(t)`.
Consequently, when a branch of `B` approaches a general point `x in E_t`, the
limiting selected line has the form

\[
\mathbf P(\langle x,y\rangle),\qquad [y]\in L_t.
\tag{4.1}
\]

Let `C` be an irreducible component of the inverse image of `E_t` in
`Gamma_line` which dominates `E_t`, and let `Cnu` be its normalization.
The graph morphism gives

\[
\beta:C^\nu\longrightarrow S.
\tag{4.2}
\]

The incidence relation is closed: every selected line contains its source
point.  Equations (4.1) and (2.2) therefore give a factorization

\[
\begin{CD}
C^\nu @>{\widetilde\beta}>> R_t\\
@V{p}VV @VV{p_t}V\\
E_t @= E_t.
\end{CD}
\tag{4.3}
\]

The map `widetilde beta` is nonconstant.  A constant target line cannot contain
a general point of `E_t`.  Since both source and target are complete curves,
it is finite and dominant.

### Theorem 4.1 — even source degree and genus bound

For every component `C` as above, there is an integer `k>=1` such that

\[
\deg(C^\nu/E_t)=2k,
\qquad
\deg(C^\nu/R_t)=k,
\tag{4.4}
\]

and

\[
g(C^\nu)\ge3k+1.
\tag{4.5}
\]

In particular:

\[
\boxed{\text{no normalized line carrier above }E_t
\text{ is birational to }E_t.}
\tag{4.6}
\]

### Proof

Degree multiplication in (4.3), together with `deg(R_t/E_t)=2`, gives
(4.4).  Riemann--Hurwitz for the degree-`k` map to the genus-four curve gives

\[
2g(C^\nu)-2
=k(2g(R_t)-2)+\deg\operatorname{Ram}
\ge6k,
\]

which is (4.5).  `square`

This theorem is the exact obstruction to the previously tempting
`epsilon=1` carrier assumption.  In the retraction branch, the first possible
source carrier has degree two over `E_t` and genus four; any higher carrier is
a finite cover of this genus-four curve.

## 5. Global dominance of the line map

Let `B_0` be an irreducible component of the reduced base divisor and let
`Y_0` be a smooth model of the normalized line graph over `B_0`.  Suppose
`B_0` contains two distinct involution elliptics `E_t` and `E_s`.  By Theorem
4.1, the image of `Y_0 -> S` contains both curves `R_t` and `R_s`.
These curves are distinct: a curve of lines fixed by two different
involutions would give a positive-dimensional family of lines stabilized by
the generated subgroup, while the exact `V4` character decomposition leaves
only the three isolated minus-lines in the commuting case.

Since the image of the irreducible surface `Y_0` is irreducible and contains
two distinct curves, it has dimension two.  Hence:

### Theorem 5.1

If `B_0` contains two distinct `E_t`, the induced map

\[
Y_0\longrightarrow S
\tag{5.1}
\]

is dominant and generically finite.  Consequently

\[
H^0(S,\Omega_S^p)\hookrightarrow H^0(Y_0,\Omega_{Y_0}^p)
\qquad(p=1,2),
\tag{5.2}
\]

and pullback on `NS(-)_Q` is injective.  For the Klein Fano surface this gives

\[
q(Y_0)\ge5,\qquad p_g(Y_0)\ge10,\qquad \rho(Y_0)\ge25.
\tag{5.3}
\]

In particular, if `B` is irreducible, (5.3) holds for every smooth model of
its normalized line graph.

If no component of `B_red` contains two involution elliptics, then `B_red`
has at least 55 irreducible components.  Since every component has positive
hyperplane degree and `B sim (d-1)H`, this forces

\[
d\ge56.
\tag{5.4}
\]

Thus every hypothetical retraction of coordinate degree at most 55 has an
explicit dominant surface carrier over the Klein Fano surface.

## 6. Residual character and the Hodge carrier

Let

\[
N_G(\langle t\rangle)/\langle t\rangle\simeq S_3.
\]

The order-three element acts on `E_t` by translation by a nonzero 3-torsion
point, so it acts freely on `R_t`.  Riemann--Hurwitz gives genus two for the
quotient.  A residual reflection has two fixed points on `R_t`: the isolated
fixed line of that reflection, which lies on `R_t`, and the unique point of
`R_t cap R_s` for the commuting involution `s`.  The latter uniqueness follows
from

\[
R_t\cdot R_s
=(C-D_t)(C-D_s)
=5-2-2+0=1.
\tag{6.1}
\]

Hence the reflection quotient also has genus two.  The character of
`H^0(R_t,Omega^1)` is therefore

\[
\chi_{R_t}(1)=4,\qquad
\chi_{R_t}(\text{reflection})=0,\qquad
\chi_{R_t}(\text{3-cycle})=1.
\tag{6.2}
\]

It follows that

\[
H^0(R_t,\Omega^1)
\simeq
\mathbf1\oplus\operatorname{sgn}\oplus\operatorname{std}.
\tag{6.3}
\]

The exact `D12` restriction of the Klein module is

\[
W_5|_{D_{12}}
=
(\mathbf1\oplus\operatorname{std})_{t=+1}
\oplus
(\operatorname{std})_{t=-1}.
\tag{6.4}
\]

Therefore

\[
\dim\operatorname{Hom}_{D_{12}}
\bigl(W_5,H^0(R_t,\Omega^1)\bigr)=2.
\tag{6.5}
\]

By Frobenius reciprocity, the orbit of the 55 curves `R_t` contains two copies
of `W_5` in its holomorphic one-forms.

This should be contrasted with the original elliptic fixed curves.  On
`H^0(E_t,Omega^1)`, translations act trivially and reflections act by `-1`,
so this is the sign representation.  Equation (6.4) gives

\[
\operatorname{Hom}_{D_{12}}
\bigl(W_5,H^0(E_t,\Omega^1)\bigr)=0.
\tag{6.6}
\]

Thus the orbit of the 55 elliptics cannot by itself supply the Weil
representation required by the blowup/Hodge carrier theorem.  The genus-four
curves selected by the normalized Pluecker graph can, and every finite source
cover in Theorem 4.1 inherits their differentials by pullback.

## 7. Exact theorem boundary

The packet proves

```text
DELTA1-CANONICAL-PLUECKER-REES-GRAPH
DELTA1-FIXED-LINE-GENUS4-CURVES
DELTA1-NO-BIRATIONAL-ELLIPTIC-LINE-CARRIER
DELTA1-CARRIER-SOURCE-DEGREE-EVEN
DELTA1-IRREDUCIBLE-BASE-LINE-MAP-DOMINANT
DELTA1-GENUS4-CARRIERS-SUPPLY-WEIL-HODGE-MODULE
```

It does not yet prove that the required singular base divisor and its 55
finite Fano carriers cannot exist.
