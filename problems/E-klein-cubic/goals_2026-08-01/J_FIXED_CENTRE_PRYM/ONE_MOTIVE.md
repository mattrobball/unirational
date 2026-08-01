# J0 — corrected involution one-motive

## Setup

Fix an involution \(t\).  Its centralizer is \(D_{12}\), and the effective
residual group on the fixed curve is

\[
\bar N=C_G(t)/\langle t\rangle\simeq S_3
 =\langle r,s\mid r^3=s^2=1,\ srs=r^{-1}\rangle .
\]

The target fixed locus is \(X^t=E_t\sqcup L_t\), where \(E_t\) is elliptic
and \(L_t\simeq\mathbf P^1\).  The accepted exact value
\(j(E_t)=8192/11\) is neither \(0\) nor \(1728\), so
\(\operatorname{Aut}(E_t,0)=\{\pm1\}\).

Choose a fixed point of the reflection \(s\) as origin.  Then, for a nonzero
\(q\in E_t[3]\),

\[
 r(P)=P+q,\qquad s(P)=-P.
\]

Changing the orientation of \(r\) replaces \(q\) by \(-q\).
With this origin the three reflections are

\[
s(P)=-P,\qquad rs(P)=q-P,\qquad r^2s(P)=2q-P.
\]

Their affine constants lie in \(\langle q\rangle\), not in the three
nonzero points of \(E_t[2]\).  Each reflection's four fixed points solve
\(2P=iq\), so those fixed sets are torsors under \(E_t[2]\).  In particular,
the verified orbit counts do not by themselves identify the twelve marked
points with the subgroup \(E_t[2]+\langle q\rangle\); no such identification
is used below.

## 1. The affine Albanese class

Let the linear \(S_3\)-action on the Jacobian \(E_t\) be trivial on \(r\)
and inversion on \(s\).  The affine action is encoded by the cocycle

\[
 a(r)=q,\qquad a(s)=0,
\qquad a(gh)=a(g)+g\,a(h).
\]

Restricting to \(\langle q\rangle\simeq\mathbf Z/3\) gives

\[
H^1(S_3,\mathbf Z/3_{\rm sign})\simeq\mathbf Z/3,
\]

and \([a]\) is a generator.  The producer and verifier both enumerate all
maps from the six-element group to \(\mathbf Z/3\): there are nine
cocycles, three coboundaries, and three cohomology classes.

The class is independent of origin: replacing the origin by \(u\) replaces
\(a(g)\) by \(a(g)+g u-u\), a coboundary.  Its restriction to
\(C_3=\langle r\rangle\) is the nonzero class \(q\); its restriction to any
reflection subgroup \(C_2\) is zero because every reflection has fixed
points.  The class for \(D_{12}\) is its inflation through
\(D_{12}\twoheadrightarrow S_3\); the central involution \(t\) acts
trivially on \(E_t\).

This is the precise affine class of \(\operatorname{Alb}^1(E_t)\).

## 2. Picard and Hodge actions are linear

The pullback of a degree-zero divisor class by a translation is

\[
 t_q^*[P-O]=[P-q-(O-q)]=[P-O].
\]

Therefore translation acts trivially on Pic^0.  A reflection acts by
\([-1]\).  Equivalently,

\[
H^{1,0}(E_t)\simeq\operatorname{sign}_{S_3}.
\]

This distinction is load-bearing:

```text
affine action on Alb^1(E_t):  r(P)=P+q, s(P)=-P
pullback on Pic^0(E_t):       r*=+1,     s*=-1
action on H^{1,0}(E_t):      r*=+1,     s*=-1
```

Thus translation acts trivially on Pic^0, and one must not use the affine
translation as a linear Picard or Hodge character.

## 3. Period, index, and norm condition

The period is three because \([a]\) is a nonzero order-three cohomology
class.  The equivariant index is the gcd of degrees of invariant zero-cycles.
Every \(C_3\)-orbit has size divisible by three because \(r\) is a free
translation, while a reflection-fixed point has an \(S_3\)-orbit of size
three.  Hence

\[
\operatorname{per}(\operatorname{Alb}^1(E_t))
=\operatorname{ind}_{S_3}(E_t)=3.
\]

More generally, tracing a degree-\(d\) multisection through the order-three
translation changes its Albanese sum by \(d q\).  If that norm descends to a
base on which \(r\) acts trivially (in particular, if it is forced to be a
constant invariant norm), the necessary condition is

\[
dq=0\quad\Longleftrightarrow\quad 3\mid d.
\]

This is the exact scope of the finite torsion observation: it obstructs only
transition curves for which the geometry proves such an invariant norm and
whose actual degree/multiplicity is prime to three.  It is not a condition on
an arbitrary equivariant map from a source carrying its own affine class;
the identity \(E_t\to E_t\) is the elementary degree-one counterexample.  It
is therefore not a universal obstruction to later centres.

## 4. Marked generalized Jacobians

For a smooth curve \(C\) with reduced marked divisor \(D\), the connected
generalized Jacobian fits into

\[
1\longrightarrow T_D\longrightarrow J(C,D)
\longrightarrow J(C)\longrightarrow0,
\qquad X^*(T_D)=\operatorname{Div}^0(D).
\]

All maps are functorial for automorphisms of the marked curve.  The exact
incidence counts give the following residual \(S_3\)-sets.

### Elliptic component

On \(E_t\), the type-I divisor is one orbit \(S_3/C_2\) of size three and
the type-II divisor is three such orbits.  Thus \(|D_E|=12\), the torus rank
is eleven, and over \(\mathbf Q\)

\[
\operatorname{Div}^0(D_E)
\simeq 3\cdot\mathbf1\oplus4\cdot\mathrm{Std}.
\]

Its character on the identity, transposition, and three-cycle classes is
\((11,3,-1)\).  The abelian quotient is \(E_t\) with the linear sign action;
the degree-one Albanese torsor separately carries \([a]\).

### Rational component

On \(L_t\), the two \(C_6\)-points form \(S_3/C_3\), and its six type-I
points form two copies of \(S_3/C_2\).  Thus \(|D_L|=8\), the torus rank is
seven, and

\[
\operatorname{Div}^0(D_L)
\simeq2\cdot\mathbf1\oplus\operatorname{sign}
       \oplus2\cdot\mathrm{Std}.
\]

Its character is \((7,1,1)\); there is no abelian quotient because
\(J(L_t)=0\).

Restriction, pullback, and norm along subgroup inclusions are the ordinary
maps on these permutation lattices together with restriction/corestriction
of \([a]\).  In particular, restriction to \(C_3\) retains the generator,
restriction to a reflection \(C_2\) kills it, and
\(\operatorname{cor}_{C_3}^{S_3}\operatorname{res}[a]=2[a]=-[a]\neq0\).

## 5. Independence and theorem boundary

The construction is independent of origin up to the canonical cohomology
class, and the generalized Jacobian is independent of an ordering of the
marks because it is defined from the permutation divisor.  It records both
the affine torsor and linear realization without conflating them.

J0 is complete.  It supplies a degree-divisibility condition, not a
contradiction for all resolution trees.  The latter failure is certified in
`CENTRE_REALIZABILITY.md`; the overall headline remains OPEN.
