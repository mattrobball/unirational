# J2.2 — exact centre/base-ideal constraints

## 1. Ideal containment and multiplicity

For a hypothetical primitive landing covariant \(p=(p_0,\ldots,p_4)\), put
\(I_p=(p_0,\ldots,p_4)\).  The all-order involution-plane theorem supplies an
odd integer \(m\ge1\) such that

\[
I_p\subset I_{P_t}^{(m)}.
\]

For every reduced plane curve \(\overline C\subset P_t\),
\(I_{P_t}\subset I_{\overline C}\), so

\[
I_p\subset I_{P_t}^{(m)}=I_{P_t}^m\subset I_{\overline C}^m.
\tag{1.1}
\]

The equality of symbolic and ordinary powers holds because \(P_t\) is a
linear complete intersection.  A generic plane model is not contained in
the common zero scheme of the leading normal jet, so its generic order is
exactly \(m\).  The exceptional divisor of its blowup consequently appears
in the total transform with coefficient \(m\), which is odd.

## 2. Incidence and normal characters

The exact data forced on the inserted centre are:

| datum | value |
|---|---|
| ambient forced components | the orbit of 55 plus-planes |
| component stabilizer | \(C_2=\langle t\rangle\) |
| curve orbit size | (660/2=330) |
| setwise plane stabilizer | \(D_{12}=C_G(t)\), order 12 |
| residual group | \(D_{12}/C_2\simeq S_3\) |
| components fixed by \(t\) | \(12/2=6\) |
| normal eigenranks | (+1) of rank 1, (-1) of rank 2 |
| exceptional multiplicity | the common odd plane order \(m\) |

Intersections among the 330 plane models occur only inside the forced base
cosupport.  Equivariant embedded resolution and separation use centres above
that cosupport, after which the strict transforms form a smooth disconnected
centre.

## 3. No new coefficient equation

The operation changes the source model, not the five forms.  Therefore it
leaves unchanged:

- the source degree and primitive gcd of \(p\);
- the odd symbolic plane order \(m\);
- the factorization \(p|_{E_-}=\Delta_t^m h_t\);
- the transition divisors (V(q)) and their horizontal degrees;
- every point-link multiplicity already forced by the transition system;
- every coefficient of the nonlinear identity \(F(p)=0\).

In particular, no equation on \(p\) can distinguish the principalization
before insertion from the principalization after insertion.

## 4. Scope of the three-divisibility gate

The installed first-plane gate proves \(3\mid r_x\) only for a horizontal
component of (V(q)) on which the successor is generically nonzero and whose
elliptic trace descends to a residual-trivial base.  The inserted curve is a
resolution centre, not a newly asserted component of (V(q)).  Hence that
theorem does not constrain its plane-model degree.

The simultaneous construction nevertheless maps \(C\to E_t\) with degree
24, so it also passes the divisibility condition if an invariant norm is
formed.  Its six residual components already carry the affine \(S_3\)-class;
there is no illicit replacement of an affine action by a linear Picard
action.

## 5. Primitive minimality

Primitive minimality is a property of the tuple \(p\), not of a chosen
factorization of the birational source model.  Since the tuple is not
multiplied, composed, or replaced, its primitive degree is unchanged.
Declaring the resulting resolution “nonminimal” only confirms the failure of
resolution invariance; it does not exclude it from the class of equivariant
log resolutions demanded by J2.1.

## 6. Exact consequence

Every listed base-ideal screen is either satisfied or irrelevant to a
refinement of the same ideal.  Thus J2.2 supplies no contradiction.  Any
future coefficient obstruction must be defined directly from \(I_p\) and be
provably unchanged under all principalizations; it cannot be the inventory
of positive-genus centres.
