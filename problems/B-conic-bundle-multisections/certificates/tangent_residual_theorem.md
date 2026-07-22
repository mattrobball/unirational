# Tangent residuals give a horizontal rational surface

## The theorem

Let

\[
X=\{F(x,y)=0\}\subset \mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,3)\) over \(\mathbf C\).  Fix a
general line \(L\subset\mathbf P^2_y\), and put

\[
S=X\cap\{y\in L\}.
\]

For a general \(p=(x,y)\in S\), let \(C_x\subset\mathbf P^2_y\) be the
plane cubic \(F(x,-)=0\).  Its tangent line at \(y\) cuts it as

\[
T_yC_x\cdot C_x=2y+\tau_x(y).
\]

Then the closure \(T\) of the points \((x,\tau_x(y))\), as \((x,y)\)
runs over \(S\), is an irreducible rational surface and

\[
\boxed{[T]=10H_x+H_y.}
\]

In particular \(T\to\mathbf P^2_y\) is dominant of degree \(20\).  Hence
\(T\) is a horizontal rational multisection of the conic bundle
\(X\to\mathbf P^2_y\), and

\[
\boxed{X\text{ is unirational.}}
\]

The rest of the note proves every assertion, including the coefficient
degree ten in the displayed class.

## 1. The source surface is rational

The linear system pulled back from lines in \(\mathbf P^2_y\) is
base-point-free on a smooth general \(X\).  Thus a general \(S\) is smooth
and irreducible.  Projection to \(L\simeq\mathbf P^1\) makes \(S\) a conic
bundle: its generic fiber is the conic

\[
F(x,y)=0\quad\text{over }\mathbf C(L).
\]

The field \(\mathbf C(L)\simeq\mathbf C(t)\) is \(C_1\), so this conic has a
rational point.  Projection from that point identifies its function field
with \(\mathbf C(t)(z)\).  Therefore

\[
\boxed{S\text{ is a rational surface.}}
\]

## 2. The universal resultant identity

Choose coordinates \([U:V:W]\) on \(\mathbf P^2_y\) with
\(L=\{W=0\}\).  For the moment fix \(x\), and write the cubic as

\[
f(U,V,W)=g(U,V)+W h(U,V)+W^2(iU+jV)+kW^3,
\]

where \(g\) is a binary cubic and \(h\) a binary quadratic.  For
\(p=[u:v:0]\in C_x\cap L\), the tangent line to \(C_x\) at \(p\) has
equation

\[
P_{U,V,W}(u,v)
=U g_u(u,v)+Vg_v(u,v)+Wh(u,v)=0.
\]

Define the cubic in \((U,V,W)\)

\[
\mathcal R_f(U,V,W)
=\operatorname{Res}_{u,v}\bigl(g,P_{U,V,W}\bigr).
\]

Normalize the sign of the resultant as in the accompanying checker.  If
\(\Delta(g)\) is the discriminant of \(g\), then

\[
\boxed{
\mathcal R_f+\Delta(g)f=W^2q_f,
}
\tag{2.1}
\]

where \(q_f\) is a linear form in \(U,V,W\).  Moreover, each of its three
coefficients is homogeneous of degree five in the ten coefficients of
\(f\).

Here is a coordinate-free verification of the divisibility.  Over a
splitting field, the constant term in \(W\) of the resultant is the product
of the three tangent-line restrictions on \(L\); it is
\(-\Delta(g)g(U,V)\).  The coefficient of \(W\) is a binary quadratic.  At
each of the three roots \(p\) of \(g\), only the factor belonging to that
root survives, so this coefficient takes the same three values as
\(-\Delta(g)h(U,V)\).  The two quadratics are therefore equal.  The terms of
orders zero and one in \(W\) in the left side of (2.1) vanish.  Since that
left side is cubic in \((U,V,W)\), its quotient by \(W^2\) is linear.

The coefficient degree follows directly from the resultant: it has degree
two in the coefficients of the binary cubic and degree three in the
coefficients of the binary quadratic, while the latter coefficients are
linear in those of \(f\).  Both terms on the left of (2.1), and hence the
coefficients of \(q_f\), have degree five.

The checker verifies (2.1) over the universal coefficient ring, verifies
that the three universal coefficients of \(q_f\) have greatest common
divisor one, and gives a substitution by ten quadratic forms for which the
three resulting degree-ten forms have greatest common divisor one.  Thus a
general bidegree-\((2,3)\) equation has no divisorial common factor in the
coefficients of \(q_{F(x,-)}\).  Here one specialization is enough: for each
possible positive common-factor degree, triples having such a factor form the
proper closed image of the corresponding projective multiplication
incidence, and there are only finitely many possible degrees.

## 3. The divisor and its class

Return to the family over \(\mathbf P^2_x\).  Every coefficient of
\(f=F(x,-)\) is a quadratic form in \(x\).  The degree-five covariant
\(q_f\) consequently has coefficients of degree ten in \(x\).  It defines
a divisor

\[
T_q=X\cap\{q_{F(x,-)}(y)=0\}
\quad\text{of class}\quad (10,1).
\]

There is also a useful direct cycle calculation.  The resultant is degree
two in the coefficients of \(g\), degree three in the coefficients of
\(P\), and cubic in \(y=(U,V,W)\).  Hence on the total space it has
bidegree

\[
[\mathcal R]=(10,3).
\]

On \(X\), identity (2.1) reads

\[
\mathcal R=W^2q_f.
\]

Since \(W=0\) cuts out \(S\), this gives the exact divisor equality

\[
\boxed{
\operatorname{div}_X(\mathcal R)=2S+T_q,
\qquad
(10,3)=2(0,1)+(10,1).
}
\tag{3.1}
\]

This also explains the multiplicity two without coordinates.  If

\[
C_x\cap L=p_1+p_2+p_3,
\]

then the three tangent lines restrict to the divisor

\[
(2p_1+r_1)+(2p_2+r_2)+(2p_3+r_3)

=2(C_x\cap L)+(r_1+r_2+r_3)
\]

on \(C_x\), where \(r_i=\tau_x(p_i)\).  Consequently the residual points
\(r_1,r_2,r_3\) lie on the single line \(q_f=0\).  This is also the plane
cubic group-law identity: three collinear points sum to zero, and the
tangent residual sends \(p\) to \(-2p\).

There is an independent Chow calculation of the same class.  In

\[
\mathbf P^2_x\times L_p\times\mathbf P^2_r
\]

write \(H,P,R\) for the three hyperplane classes.  The incidence saying
that \(p\in C_x\cap L\), that \(r\in T_pC_x\), and that \(r\in C_x\) is the
complete intersection of classes

\[
2H+3P,\qquad 2H+2P+R,\qquad 2H+3R.
\]

Pushing its class along \(L_p\) gives

\[
20H^2+36HR+9R^2.
\]

The diagonal \(r=p\) in \(L_p\times\mathbf P^2_r\) has class
\(R^2+PR\).  It occurs with tangent multiplicity two, and twice its
pushforward is \(4HR+6R^2\).  The residual graph therefore pushes forward
to

\[
20H^2+32HR+3R^2
=(2H+3R)(10H+R),
\]

again giving the divisor class \((10,1)\).  On the dense open where \(C_x\)
is smooth and \(L\) is transverse, the incidence is exactly the doubled
diagonal plus the residual graph.  For a general two-parameter family of
plane cubics, cubics reducible with the tangent line as a component and
cubics singular at a point of \(L\) occur in too high codimension to create
an additional surface component.  Thus the calculation is an equality of
top-dimensional cycles, not only a formal expected class.

## 4. The residual divisor is the rational image

Tangency and taking the third intersection point define a rational map on
the open locus where \(C_x\) and the marked point are smooth,

\[
\tau:S\dashrightarrow X,
\qquad
(x,p)\longmapsto(x,\tau_x(p)).
\]

Its image is contained in \(T_q\) by (2.1).  For a general pair consisting
of a smooth plane cubic and a line, the three points \(r_i\) are distinct
and off \(L\).  This is an open condition, and the checker supplies an exact
smooth example.  Hence, for a general \(F\), both \(S\) and \(T_q\) have
degree three over \(\mathbf P^2_x\), and \(\tau\) is a bijection on their
geometric generic fibers.  Irreducibility of \(S\) makes those three points
a transitive Galois set over \(\mathbf C(\mathbf P^2_x)\), so their residual
images are transitive as well.  It follows that

\[
\boxed{
T=T_q\text{ is irreducible and }S\dashrightarrow T\text{ is birational.}
}
\]

In particular the normalization of \(T\) is rational.  Possible isolated
base points of the three coefficients of \(q_f\) only insert whole cubic
curves into this divisor over finitely many values of \(x\); they are not
surface components and do not affect the generic-fiber or class argument.

## 5. Horizontality and the unirational parametrization

Let \(c_y\) be a general conic fiber of
\(\pi_y:X\to\mathbf P^2_y\).  Since

\[
H_x\cdot c_y=2,
\qquad
H_y\cdot c_y=0,
\]

the class calculation gives

\[
T\cdot c_y=(10H_x+H_y)\cdot c_y=20.
\]

Thus \(T\to\mathbf P^2_y\) is dominant of degree \(20\).  Let
\(\widetilde T\) be its normalization; it is rational by Section 4.  Base
change of the conic bundle by \(\widetilde T\) has its tautological rational
point, so it is birational to \(\widetilde T\times\mathbf P^1\).  The projection

\[
X\times_{\mathbf P^2_y}\widetilde T\dashrightarrow X
\]

is dominant of degree \(20\).  This is the promised unirational
parametrization and completes the proof.

## 6. Exact local check

Run

```bash
python3 certificates/tangent_residual_local_checks.py
```

The checked output is recorded in
[`tangent_residual_local_checks.log`](tangent_residual_local_checks.log).
