# J2.1 — fixed-centre one-motive and failure of resolution invariance

## 1. Fixed exceptional geometry

Let \(C\subset P_t\subset\mathbf P(W)\) be the smooth strict transform of the
curve constructed in `D_COUNTERMODEL_AUDIT.md`.  The involution \(t\) fixes
\(C\) pointwise.  Since it acts trivially tangent to \(P_t\) and by sign in
the two normal directions to \(P_t\), the normal bundle has the canonical
eigenbundle decomposition

\[
N_{C/\mathbf P(W)}=N^+\oplus N^-,
\qquad \operatorname{rk}N^+=1,\quad \operatorname{rk}N^-=2.
\]

Here \(N^+=N_{C/P_t}\), while \(N^-=N_{P_t/\mathbf P(W)}|_C\).  After blowing
up \(C\), the fixed exceptional pieces are

\[
\mathbf P(N^+)\simeq C,
\qquad \mathbf P(N^-)\longrightarrow C
\]

with fibres a point and \(\mathbf P^1\).  Both have
\(\operatorname{Alb}=J(C)\) and \(\operatorname{Pic}^0=J(C)\).  This is the
normal-slice correction required by the fixed-centre blowup formula.

## 2. Residual \(S_3\) system

The component stabilizer is \(H=\langle t\rangle\), while
\(N_G(H)=C_G(t)\) has order \(12\).  Among the \(330\) components in
\(G/H\), exactly

\[
|C_G(t)/H|=12/2=6

\]

are fixed pointwise by \(t\).  The residual group
\(C_G(t)/H\simeq S_3\) permutes them simply transitively.  Their permutation
character on the identity, transposition, and three-cycle classes is
\((6,0,0)\), hence

\[
\mathbf Q[S_3]\simeq
\mathbf1\oplus\operatorname{sign}\oplus2\,\mathrm{Std}.
\]

Thus the fixed exceptional Albanese/Picard system contains every residual
linear channel, including the sign and standard channels missing from the
55 target elliptics alone.

## 3. The affine order-three quotient

Let \(f:C\to E_t\) be the degree-24 second projection from the product
construction.  Index the six fixed components by \(S_3\).  On the component
indexed by (h), use the morphism

\[
f_h=h\circ f:C\longrightarrow E_t,
\]

where \(S_3\) acts affinely on \(E_t\) by
\(r(P)=P+q,\ s(P)=-P\), \(0\ne q\in E_t[3]\).  Left permutation of the
components makes the disjoint-union map \(S_3\)-equivariant.  On degree-one
Albanese torsors its quotient therefore carries the exact generator

\[
[a]\in H^1(S_3,\mathbf Z/3_{\rm sign})\simeq\mathbf Z/3.

\]

Pulling back the twelve marked points on \(E_t\) supplies functorial marked
divisors on the six components; divisor pullback and norm give the same
restriction/corestriction formalism.  The degree (24) is divisible by
three, so even the conditional invariant-norm test is satisfied.

This is a quotient of the centre one-motive, not an assertion that the
source fixed component is isomorphic to \(E_t\).  That is exactly the level
seen by Albanese, Picard, norm, restriction, and incidence data.

## 4. Why no resolution-invariant centre one-motive exists

Before insertion, a chosen principalization need not contain any copy of
\(J(C)\).  After insertion, its fixed exceptional locus contains two
projective-bundle copies over each of six curves and the affine quotient
above.  Both towers resolve the same rational map.  Therefore the direct
system of centre one-motives is changed by an allowed refinement.

One can force invariance only by discarding the added summands.  But a rule
which discards every refinement summand also discards precisely the
Prym/Albanese data proposed for the obstruction.  Conversely, choosing a
canonical algorithm makes the output algorithm-dependent and still requires
a new theorem coupling that choice to the coefficients of \(p\).

There is a separate functoriality gap which remains decisive: equivariant
dominance does not imply dominance on fixed loci.  Hence no general theorem
forces a source fixed component to map nontrivially to \(E_t\).  The affine
class is recoverable when such a quotient is present, but is not a mandatory
invariant of every resolved dominant map.

## 5. Boundary

The local blowup formula and the residual one-motive are functorial for a
**fixed** blowup step.  Their total collection is not invariant under
changing the resolution.  This completes J2.1 by refuting, rather than
proving, its requested invariance statement.
