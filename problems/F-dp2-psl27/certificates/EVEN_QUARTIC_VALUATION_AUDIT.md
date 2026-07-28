# Universal even quartic: toric valuation route audit

## Verdict and scope

The standard monomial/divisorial valuation route does **not** give an
all-degree obstruction to

\[
Q(u,v,w)=h^2,\qquad
Q=F(u\psi+v\phi+wf),
\]

over \(\mathbf C(F,D,C)\).  Every noncentral toric direction considered
below has a point over its henselian completion.  The only direction not
simplified is the central grading ray

\[
\nu(F,D,C)\ \parallel\ (2,3,7).
\]

On that ray the residue equation is the full degree-zero universal
equation, hence the original generic-twist problem rather than a new
obstruction.

This is a route closure.  It neither constructs a global square over
\(\mathbf C(F,D,C)\) nor resolves Problem F.

The exact audit is
[even_quartic_valuation_audit.py](even_quartic_valuation_audit.py).
It uses the checked tensor
[even_quartic_tensor.json](even_quartic_tensor.json).

## Syzygy-adapted normal form

The exact syzygy

\[
X\,\mathrm{id}=C\psi-\frac37D\phi+\frac27Ff
\]

gives the coefficient change

\[
(u,v,w)=
\left(a+Cc,\ b-\frac37Dc,\ \frac27Fc\right).
\]

The audit verifies

\[
Q=Q_0(a,b)+\Delta cL_1(a,b)+\Delta c^2L_2(a,b)
   +F\Delta^2c^4, \tag{1}
\]

with no \(c^3\)-term, where

\[
\begin{aligned}
\Delta={}&C^3+88C^2DF^2+1008CD^4F+1088CD^2F^4-256CF^7\\
 &-1728D^7+60032D^5F^3-22016D^3F^6+2048DF^9
 =X^2. \tag{2}
\end{aligned}
\]

Thus the obvious identity direction has square class \(F\), not a global
square.  Formula (1) is useful structure, but by itself supplies no
anisotropy theorem.

## Exact Newton-fan audit

Write a monomial valuation as

\[
\nu(F)=f,\qquad \nu(D)=d,\qquad \nu(C)=c.
\]

Inside any fixed weighted-homogeneous coefficient, its initial face is
determined by

\[
r=2d-3f,\qquad s=2c-7f. \tag{3}
\]

The audit constructs the Newton polygons of the three diagonal values
\(Q(1,0,0)\), \(Q(0,1,0)\), and \(Q(0,0,1)\).  Their common normal fan has
12 open cones.  On every open cone, at least one diagonal value has a
unique leading monomial

\[
\lambda F^{2i}D^{2j}C^{2k},\qquad \lambda\in\mathbf Q^\times.
\]

Over \(\mathbf C\), this is a square leading unit.  Hensel's lemma then
makes that diagonal value a square in the corresponding completion.

Of the 12 walls, nine have the same diagonal-square property.  The three
exceptions in the \((r,s)\)-plane are

\[
(-1,-3),\qquad (1,0),\qquad (0,1).
\]

The explicit wall checks are:

- The \(F\)-coordinate wall is already among the nine, with the especially
  simple identity

  \[
  Q(0,1,0)=-(2352CD^3)^2.
  \]

- The exceptional \(D\)-coordinate wall has

  \[
  Q(48F^3C,FC,0)
  =-\bigl(196C^2F^3(C^2-256F^7)\bigr)^2.
  \]

- For the noncoordinate wall \((-1,-3)\), take the representative
  \(\nu(F,D,C)=(0,-1,-3)\), put \(t=C/D^3\), and take
  \(\nu(u,v,w)=(0,1,0)\).  The exact leading residue is

  \[
  -5488w_0^3t^3
  (100Fw_0t+7v_0t^2+532w_0).
  \]

  With \(u_0=w_0=1\) and

  \[
  v_0=\frac{t-100Ft-532}{7t^2},
  \]

  it becomes \(-5488t^4\), a nonzero square over \(\mathbf C(F,t)\).

The third exceptional wall, the \(C\)-coordinate wall, is handled in the
next section.

Weighted homogeneity transports these constructions after adding any
multiple of the central grading vector.

## The \(C\)-coordinate wall

The \(C\)-adic special fiber has no immediate diagonal-square
factorization, but it descends exactly to a one-variable function field.
Put

\[
t=\frac{D^2}{F^3},\qquad
u=FDU,\qquad v=\frac D F V,\qquad w=W.
\]

The checker reconstructs a ternary quartic
\(P_t(U,V,W)\in\mathbf Q(t)[U,V,W]\) and verifies

\[
Q(FDU,(D/F)V,W)\big|_{C=0}=F^{18}P_t(U,V,W). \tag{4}
\]

It also checks directly from the Klein covariants that

\[
\det[\psi\ \phi\ f]=196X^2=196\Delta.
\]

Since \(\Delta|_{C=0}\ne0\), the branch quartic in (4) is a linear
transform of the smooth Klein quartic.  Therefore

\[
H^2=P_t(U,V,W)
\]

is a smooth proper degree-2 del Pezzo surface over \(\mathbf C(t)\), hence
geometrically rationally connected.  The theorem of
Graber--Harris--Starr supplies a \(\mathbf C(t)\)-point.  Base change to
\(\mathbf C(F,D)\), followed by smooth Hensel lifting, gives a point over
the \(C\)-adic completion.

This is an existence argument, not an explicit point formula.  Its
hypotheses are exactly the descent identity (4), the determinant check,
and \(\Delta|_{C=0}\ne0\), all asserted by the audit.

## Why the central ray is not progress

For the central valuation

\[
\nu(F,D,C)=(2,3,7),
\]

the audit verifies that the coefficient of \(u^iv^jw^k\) has valuation

\[
4i+8j+9k.
\]

After the natural shifts
\(\nu(u,v,w)=(-4,-8,-9)\), every one of the 15 tensor terms remains in the
initial form.  Its residue field is the degree-zero field, for example

\[
\mathbf C\left(\frac{D^2}{F^3},\frac{CD}{F^5}\right),
\]

and its residue equation is the full universal quartic-square equation.
Deciding whether that residue surface has a point is the same
degree-zero/generic-twist frontier already present in Problem F.  No
valuation complexity has been removed.

## Replay

From the repository root:

~~~text
PYTHONPATH=certificates python3 certificates/even_quartic_valuation_audit.py
~~~

The final marker is

~~~text
EVEN_QUARTIC_VALUATION_ROUTE_AUDIT_OK
~~~
