# All-degree obstruction from a \(V_4\)-fixed exceptional path

## Verdict

There is no dominant \(G\)-equivariant rational map

\[
\mathbf P(V)\dashrightarrow S.
\]

Together with the exhaustive generic-torsor reduction, this proves that
the Klein degree-two del Pezzo surface is **not**
\(\operatorname{PSL}_2(\mathbf F_7)\)-unirational.

The already-certified structural theorem excludes odd homogeneous degree.
The argument below excludes every even degree at once.  Its key point is
not a Noether inequality: over a quadruple point of the 21-line Klein
arrangement, a \(V_4\)-stable exceptional path would have to connect two
different fixed points of \(S\), but every rational component of that path
is forced to map constantly.

The exact finite group, eigenspace, and branch-curve inputs are checked by
[wp3_all_degree_path_obstruction.py](wp3_all_degree_path_obstruction.py).
The surface-resolution and tree arguments are proved below.

## 1. Inputs already proved by the homogeneous reduction

Write \(F=x^3y+y^3z+z^3x\), and let
\(\pi:S\to\mathbf P(V)\) be the anticanonical double cover.  The generic
torsor argument in `SPEC.md` proves that \(G\)-unirationality is equivalent
to a \(G\)-equivariant rational map \(\mathbf P(V)\dashrightarrow S\).
After clearing common factors, every such map has a primitive homogeneous
form

\[
v\longmapsto [p(v):h(v)],\qquad
p\in\operatorname{Cov}_G(V,V)_d,\quad
h\in\mathbf C[V]^G_{2d},\quad F(p)=h^2. \tag{1}
\]

The odd-degree theorem in
[WP3_STRUCTURAL_BOUND.md](WP3_STRUCTURAL_BOUND.md) proves that \(d\) cannot
be odd.  It also proves the two facts about an involution \(t\) used here.
If

\[
V=E_+(t)\oplus E_-(t),\qquad \dim E_+=1,\quad\dim E_-=2,
\]

then

\[
S^t=\pi^{-1}\mathbf P(E_-(t))\;\sqcup\;\{s_t^+,s_t^-\}, \tag{2}
\]

where the first component is a smooth genus-one curve and the other two
points lie over \(\mathbf P(E_+(t))\).  In particular, \(S^t\) contains no
rational curve.

We may therefore assume for contradiction that (1) has even degree.

## 2. The two forced endpoint values

For an involution \(s\), put

\[
L_s=\mathbf P(E_-(s))\subset\mathbf P(V).
\]

Primitivity implies that the map is defined at the generic point of every
\(L_s\).  Indeed, if the equation of one \(L_s\) divided every component
of \(p\), equivariance would make the equations of all 21 conjugate lines
divide every component, contradicting primitivity.

For \(v\in E_-(s)\), even homogeneity and equivariance give

\[
s p(v)=p(sv)=p(-v)=p(v).
\]

Thus \(p(v)=a_s(v)e_s\), where \(e_s\) spans \(E_+(s)\) and
\(a_s\ne0\).  Since \(F(e_s)\ne0\), equation (1) gives

\[
\left(\frac{h}{a_s^2}\right)^2=F(e_s)
\quad\hbox{in }\mathbf C(L_s).
\]

Consequently the rational map is constant on \(L_s\), with value one of
the two points over \([e_s]\).  Denote this value by \(b_s\).

Now choose one of the 21 quadruple points \(q\) of the Klein line
arrangement.  The exact checker proves:

* four involution lines \(L_s\) pass through \(q\), and their four target
  eigenlines \([e_s]\) are distinct;
* \(H=\operatorname{Stab}_G(q)\simeq D_8\);
* the unique central involution \(z\in H\) has
  \(q=\mathbf P(E_+(z))\), and \(H\) has no invariant line in \(E_-(z)\).

The first assertion makes \(q\) a mandatory basepoint: if the rational map
were regular there, its restrictions to the four incident curves would
all take the single value at \(q\), contrary to their distinct projected
values.

Blow up the full \(G\)-orbit of these 21 basepoints and let \(A_q\) be the
exceptional curve over \(q\).  The differential of \(z\) at \(q\) is
scalar \(-1\), so \(z\) acts pointwise on

\[
A_q=\mathbf P(T_q\mathbf P(V)).
\]

In any equivariant resolution of the remaining indeterminacy, the strict
transform of \(A_q\) is still pointwise fixed by \(z\).  Its image is
therefore contained in \(S^z\), and (2) shows that the morphism
\(A_q\simeq\mathbf P^1\to S^z\) is constant.  Since \(A_q\) is
\(H\)-stable, that constant is \(H\)-fixed.  Its projection is an
\(H\)-invariant line in \(V\).  The only such line is \(E_+(z)\): any
other one would lie in \(E_-(z)\), while the exact commutator calculation

\[
[H,H]=\{1,z\}
\]

rules out a one-dimensional \(H\)-submodule there because \(z\) acts as
\(-1\).  Hence the constant value \(a_q\) of \(A_q\) satisfies

\[
\pi(a_q)=q=\mathbf P(E_+(z)). \tag{3}
\]

For any incident \(L_s\), the points in (3) and \(\pi(b_s)=[e_s]\) are
distinct: \(q\in\mathbf P(E_-(s))\), whereas \(e_s\in E_+(s)\).

## 3. Equivariant resolution and the path lemma

Start with the preceding equivariant blowup of the 21-point orbit.  In
characteristic zero, elimination of indeterminacies for a rational map
from a smooth surface may be performed by a finite sequence of point
blowups.  To avoid any weighted-projective ambiguity, compose with the
closed embedding of \(S\) defined by
\(\mathcal O_S(2)=\pi^*\mathcal O_{\mathbf P(V)}(2)\).  The resulting
ordinary projective coordinates are represented by the six products
\(p_i p_j\) together with \(h\), all of degree \(2d\).  Primitivity of
\(p\) makes their common base scheme zero-dimensional, and equivariance
makes its ideal \(G\)-stable.  Canonical, functorial principalization of
this invariant ideal is therefore \(G\)-equivariant; on a smooth surface
its centers are finite disjoint unions of point orbits.  The same
conclusion can be obtained from the surface basepoint algorithm by blowing
the full \(G\)-orbit of every transformed basepoint.  This gives a
\(G\)-equivariant sequence

\[
X\longrightarrow \operatorname{Bl}_{Gq}\mathbf P(V)
\longrightarrow\mathbf P(V)
\]

on which the rational map extends to a \(G\)-equivariant morphism
\(f:X\to S\).

Fix an incident pair \((q,L_s)\), and set

\[
K=\langle z,s\rangle\simeq V_4.
\]

On the first blowup \(Y=\operatorname{Bl}_{Gq}\mathbf P(V)\), the curve
\(A_q\) and the strict transform of \(L_s\) meet at the point \(r\)
representing the tangent direction of \(L_s\).  Both curves, and hence
\(r\), are \(K\)-stable.  Write \(\mu:X\to Y\) for the remaining
point-blowup resolution.  Let
\(\operatorname{Exc}_r(\mu)\) denote the reduced union of the
\(\mu\)-exceptional curves whose image is \(r\) (if \(\mu\) were locally
an isomorphism at \(r\), this union would be empty).  Consider only the
local divisor

\[
\widetilde A_q\ \cup\ \operatorname{Exc}_r(\mu)
\ \cup\ \widetilde L_s. \tag{4}
\]

This is precisely the reduced local total transform over \(r\), with its
two endpoint strict transforms included; if the exceptional union is
empty, (4) is simply the original endpoint edge.
Centers away from the successive inverse image of \(r\) do not change
this divisor or its endpoint-to-endpoint path.  The dual graph of (4) is
a tree: initially it is one edge; blowing a smooth point above \(r\)
adds a leaf, while blowing a node subdivides one edge.  There is therefore
a unique path from \(\widetilde A_q\) to \(\widetilde L_s\).

Because \(K\) fixes the two endpoint vertices, it fixes every vertex of
this path.  Indeed, a tree automorphism preserves the unique endpoint-to-
endpoint path, and its vertex at each fixed distance from the first
endpoint is unique.  Thus every component \(C\) on the path is
\(K\)-stable.

Every intermediate component is an exceptional \(\mathbf P^1\).  When it
was created, its center was \(K\)-fixed.  More explicitly, final
\(K\)-stability of its strict transform descends through every later
equivariant blowdown to \(K\)-stability of the exceptional curve at its
birth.  The birth blowdown is equivariant, so its contracted image, the
birth center, is fixed by \(K\).  At such a fixed point, the honest
tangent representation splits over \(\mathbf C\) as

\[
T_x=\chi_1\oplus\chi_2
\]

for two characters of \(K=(C_2)^2\).  The action on the new exceptional
curve \(\mathbf P(T_x)\) factors through the single character
\(\chi_1\chi_2^{-1}\).  Its kernel therefore contains a nonidentity
involution \(t_C\).  That involution acts pointwise on \(C\), and it
continues to do so on the strict transform after later blowups.
An abstract \(V_4\) can act faithfully on \(\mathbf P^1\); the kernel here
is a consequence of this exceptional curve being the projectivization of
an honest two-dimensional representation of the commuting group \(K\),
not a claim about arbitrary \(V_4\)-actions on a rational curve.

The same conclusion holds at the endpoints: \(z\) acts pointwise on
\(A_q\), and \(s\) acts pointwise on \(L_s\).  Equivariance now gives

\[
f(C)\subset S^{t_C}
\]

for every component on the path.  By (2), a morphism from
\(C\simeq\mathbf P^1\) to \(S^{t_C}\) is constant.  Hence every path
component maps to a point.

Adjacent components meet, so their constant images under the morphism
\(f\) are equal.  Propagating along the path gives

\[
a_q=b_s,
\]

contradicting their distinct projections in (3).  No primitive
even-degree landing map exists.  Together with the odd-degree theorem,
this excludes all degrees.

## 4. Why the first-near numerical cluster was not enough

The exact checker additionally verifies, for all 84 incident flags, that
the line joining \(E_+(z)\) and \(E_+(s)\) meets the Klein quartic in four
distinct points.  Its inverse image in \(S\) is therefore elliptic.  This
explains the first failure of the raw multiplicity cluster: a simple
first-near exceptional curve cannot connect the two endpoint values.

The path proof is stronger than iterating multiplicity inequalities.  It
shows that no finite chain of equivariant point blowups can connect them,
independently of the degree and of all Noether/Hodge slack.

## Replay

From the repository root:

~~~text
PYTHONPATH=certificates python3 certificates/wp3_all_degree_path_obstruction.py
~~~

The final marker is

~~~text
WP3_ALL_DEGREE_PATH_OBSTRUCTION_OK
~~~
