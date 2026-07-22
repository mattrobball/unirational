# A genus-four counterexample to the proposed three-center lemma

## Verdict

The proximity-to-genus implication proposed in
[`three_center_equigeneric_attempt.md`](three_center_equigeneric_attempt.md)
is false for reduced plane octics.  There is a reduced octic with exactly
three canonical-resolution centers having `t=2`, with every other center
having `t=1`, for which both required cluster systems vanish, but whose
normalization has total genus four rather than at most three.

This is a counterexample in the ambient space of reduced plane octics.  It is
**not** asserted here that this octic equals `B_sigma` for a symmetric
determinantal branch map.  Consequently it invalidates the proposed universal
plane-curve lemma, but does not by itself produce a rational `(1,1)`
multisection on the general threefold.

## 1. The octic

Use homogeneous coordinates `[x:y:z]` and put

\[
 \begin{aligned}
  F&=x^3(x-z)^4+xy^2z^4+y^3(x^4+z^4),\\
  H&=(F=0),\qquad L=(y=0),\qquad C=H\cup L=(yF=0).
 \end{aligned}
\]

Thus `H` is a septic and `C` is a reduced octic.  Consider

\[
 p_1=[0:1:0],\qquad p_2=[0:0:1],\qquad p_3=[1:0:1].
\]

They are noncollinear: `p_2,p_3` lie on `L`, while `p_1` does not.

The exact script
[`three_center_genus_counterexample.m2`](three_center_genus_counterexample.m2)
checks the claims below.  Its captured output is in
[`three_center_genus_counterexample.log`](three_center_genus_counterexample.log).

## 2. Irreducibility and complete singular support

Reduction of `F` modulo five has one irreducible factor of degree seven.  It
also contains the smooth `F_5`-point `[1:2:1]`, where the gradient is
`(1,-2,-2)`.  This proves that the reduction is geometrically integral.  In
fact, if an irreducible curve over a finite field split into Frobenius-
conjugate geometric components, every rational point would lie on all those
components and hence would be singular.  Absolute irreducibility of the good
reduction implies absolute irreducibility of `F` over `Q`, and hence over
`C`.

Over `Q`, the radical of the projective Jacobian ideal of `F` is

\[
 (x,z)\cap(x,y)\cap(x-z,y).
\]

Thus the complete singular support of `H` is precisely
`{p_1,p_2,p_3}`.  The same radical calculation for `yF` shows that `C` has no
other singular points.  Finally,

\[
 F(x,0,z)=x^3(x-z)^4.
 \tag{2.1}
\]

Therefore `H` and `L` meet only at `p_2,p_3`, with intersection
multiplicities three and four respectively.

## 3. Local types and canonical-resolution data

### The point `p_1`

In the chart `y=1`, the lowest homogeneous part of `F` at `p_1` is

\[
 x^4+z^4.
\]

It is square-free.  Hence `H`, and therefore `C`, has an ordinary quadruple
point at `p_1`.  Its delta invariant is six, its corrected branch
multiplicity is `r=4`, and this is one `t=floor(r/2)=2` center.  One blowup
separates the four branches.

### The point `p_2`

In the chart `z=1`, the tangent cone of `H` at `p_2` is

\[
 x^3+xy^2+y^3.
\]

This cubic is square-free and is not divisible by `y`.  Thus `H` has an
ordinary triple point, while adjoining the line `L=(y=0)` gives `C` an
ordinary quadruple point.  Again `r=4`, so `p_2` is the second `t=2` center.
The contribution to `delta(H)` is three, and one blowup resolves the branch.

### The point `p_3`

Set `u=x-z`, `v=y` in the chart `z=1`.  Then

\[
 F=(1+u)^3u^4+(1+u)v^2+
     v^3\bigl((1+u)^4+1\bigr).
 \tag{3.1}
\]

After setting `v=u^2w` and dividing by `u^4`, the specialization at `u=0`
is `1+w^2`, which has two simple roots over `C`.  Hence `H` has two smooth
branches `v=u^2w_\pm(u)` meeting to order two: it is an `A_3` tacnode and
contributes two to `delta(H)`.  The line `L` is a third smooth branch with the
same tangent.

At `p_3` the strict curve therefore has multiplicity three.  Since this is
odd, the first exceptional curve is inserted in the corrected branch.  In
the blowup chart `v=uw`, the strict transform of `H` has tangent cone

\[
 u^2+w^2.
\]

At the point `q_3` over the common tangent, the corrected branch has the four
distinct tangent lines

\[
 u\,w\,(u^2+w^2)=0:
\]

the old exceptional curve, the strict transform of `L`, and the two branches
of `H`.  Thus the corrected sequence is

\[
 (r_{p_3},r_{q_3})=(3,4),\qquad
 (t_{p_3},t_{q_3})=(1,2).
\]

The blowup of `q_3` separates all four branches.  Combining the three local
calculations, the complete canonical resolution has exactly the three `t=2`
centers

\[
 p_1,\quad p_2,\quad q_3,
\]

and its only other center, `p_3`, has `t=1`.

## 4. Both cluster systems vanish

In the total-transform basis put

\[
 D=E_{p_1}+E_{p_2}+E_{q_3}.
\]

A line with value at least one at `q_3` must pass through its proper origin
`p_3`.  Consequently a section of `J_D(1)` would be a line through all three
noncollinear points `p_1,p_2,p_3`.  There is no such line, so

\[
 H^0\bigl(J_D(1)\bigr)=0.
\]

A conic with value at least two at each of `p_1,p_2` must have a double point
at both.  In the chosen coordinates the only such conic is a scalar multiple
of `x^2`, the doubled line through `p_1,p_2`.  But `x(p_3)=1`; its value at
`q_3` is therefore zero, not two.  It follows that

\[
 H^0\bigl(J_{2D}(2)\bigr)=0.
\]

This argument uses the actual divisorial values.  In particular, it does not
replace the doubled infinitely-near cluster by an ordinary double point at
`p_3`.

## 5. The normalization has genus four

An integral plane septic has arithmetic genus `15`.  The only singularities
of `H` contribute

\[
 \delta(H)=6+3+2=11.
\]

Therefore

\[
 g(\widetilde H)=15-11=4,
 \qquad g(\widetilde L)=0.
\]

Equivalently, (2.1) gives

\[
 \delta(C)=\delta(H)+H\mathbin\cdot L=11+(3+4)=18.
\]

Since `C` has two irreducible components,

\[
 \delta(C)-\#\operatorname{Irr}(C)+1=18-2+1=17<18.
\]

Thus the total normalization genus is exactly four.  This disproves the
claimed implication to genus at most three, even with both adjoint-cluster
vanishings imposed.
