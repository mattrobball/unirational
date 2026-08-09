# The degree-25 boundary-extension theorem: corrected statement

Throughout, work over a characteristic-zero algebraically closed field, let
`G=PSL(2,11)`, let `W` be the Klein five-dimensional representation, and let
$X=V(F)\subset\mathbf P(W)$ be the Klein cubic. For an involution `t`, write

\[
W=W_+(t)\oplus W_-(t),\qquad
X^t=E_t\sqcup L_t,
\]

where $E_t=X\cap\mathbf P(W_+(t))$ is a smooth plane cubic and
$L_t=\mathbf P(W_-(t))$ is a line contained in `X`.

## Theorem A — canonical fixed-curve morphism

Let `D` be the reduced union of all 55 elliptics and all 55 fixed lines. The
componentwise prescription

\[
\lambda_D|_{E_t}=[-5],\qquad
\lambda_D|_{L_t}=id
\]

is independent of every allowed marked-origin choice, commutes with the full
residual normalizer `N_G(<t>)/<t> = S3`, is transported correctly by
conjugation in `G`, and glues to a genuine `G`-equivariant morphism

\[
\lambda_D:D\to X.
\]

At a type-I point the three branches are one elliptic and two fixed lines; at
a type-II point they are three elliptics. In both cases the completed local
ring of `D` is

\[
k[[u,v,w]]/(uv,uw,vw).
\]

Thus equality of the three branch values is the complete gluing condition;
there is no tangent or first-derivative matching condition.

## Theorem B — polarization and literal extension obstruction

For the actual plane polarization `L=O_{E_t}(1)`, one has

\[
[-5]^*L\simeq L^{\otimes25}.
\]

A degree-`d` homogeneous tuple whose projectivization is defined everywhere on
`D` and equals `lambda_D` would determine a nowhere-zero section of

\[
M_d=O_D(d)\otimes\lambda_D^*O_X(-1).
\]

On the components,

\[
M_d|_{E_t}\simeq L^{d-25},\qquad
M_d|_{L_t}\simeq O_{P^1}(d-1).
\]

A nowhere-zero regular section on a complete integral curve trivializes its
line bundle. Hence the first restriction forces `d=25` and the second forces
`d=1`. Consequently no homogeneous tuple of any degree defines `lambda_D`
everywhere on `D`. In particular, no degree-25 polynomial tuple does.

Equivalently, on a fixed line with coordinates `[u:v]`, a degree-25 tuple
representing the identity has the form `[u h(u,v):v h(u,v)]` with `h` of
degree 24. Such an `h` has a zero over the algebraic closure, producing a
base point.

## Theorem C — exact landing obstruction

Let

\[
p\in(\operatorname{Sym}^d W^*\otimes W)^G
\]

be homogeneous and satisfy `F(p)=0`. Then for every involution `t`,

\[
p|_{W_+(t)}=0.
\]

Indeed, `t`-equivariance makes the restriction `W_+(t)`-valued. If it were
nonzero, it would induce a rational map

\[
P(W_+(t))=P^2\dashrightarrow E_t.
\]

Every rational map from `P^2` to a smooth genus-one curve is constant: its
restriction to a general line extends to a morphism $\mathbf P^1\to E_t$, hence is
constant, and general points are joined by such lines. Residual-normalizer
equivariance would then force the constant point to be fixed by the residual
`C3`. But that `C3` acts freely on `E_t` as translation by a nonzero
three-torsion point. This is impossible.

At degree 25, let

\[
0\ne\beta_t\in
H^0(E_t,\mathcal O_{E_t}(25)\otimes W_+(t))^{N_G(\langle t\rangle)}
\]

be any normalizer-equivariant coordinate tuple for `[-5]`; the equivariant
polarization identifies its line uniquely up to a nonzero scalar. The landing
restriction image on this space is `{0}`, while `beta_t` is nonzero. Thus

\[
[\beta_t]\ne0
\quad\text{in}\quad
H^0(E_t,\mathcal O_{E_t}(25)\otimes W_+(t))\big/\operatorname{res}_{E_t}(Z_{25})
\]

is the first exact obstruction class.

The canonical `[-5]` restriction is nonconstant and nonzero. Therefore no
landing covariant, in degree 25 or any other degree, restricts to the exact
canonical elliptic boundary datum. The obstruction cannot be removed by
multiplying by an invariant scalar. Conversely, if a common factor is divided
out, perfection of `G` makes it invariant and cubic homogeneity gives
`F(p/h)=0`; the primitive tuple still vanishes on every `W_+(t)`.

## Corollary — requested exit

The proposed theorem

```text
componentwise [-5]/id boundary morphism
    extends to a degree-25 G-equivariant landing polynomial map
```

is false, with first literal obstruction on the fixed lines and an independent
order-zero landing obstruction on the fixed elliptics. The exact scoped exit is

```text
DEGREE25-BOUNDARY-EXTENSION-OBSTRUCTED
```

while the Problem E headline remains open.
