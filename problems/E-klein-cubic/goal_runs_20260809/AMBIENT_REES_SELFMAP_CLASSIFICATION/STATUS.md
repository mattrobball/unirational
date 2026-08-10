# Ambient Rees selfmap classification: status

**Date:** 2026-08-09  
**Exit:** `FULL-G-AMBIENT-SELFMAP-CLASSIFICATION-UNDECIDED`

## Executive verdict

The ambient problem has two binding structural conclusions.

First, ambient landing maps are closed under postcomposition by every dominant
rational \(G\)-selfmap of \(X\). Since the accepted tangent-residual theorem
produces a nonidentity selfmap of degree at least \(3\) with iterates of
unbounded degree,

\[
\boxed{
\text{the ambient landing set is empty, or its restriction degrees are
unbounded.}
}
\]

Consequently the requested identity, degree-one, and uniform finite-profile
theorems are false conditional on nonemptiness. The correct headline target is

```text
NO-DOMINANT-G-AMBIENT-LANDING-MAP
```

Second, the new theorem-forced good-reduction calculation proves genuine
bounded progress:

```text
AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22
DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24
```

No nonzero homogeneous landing tuple exists in coordinate degree at most
\(21\). A primitive \(G\)-retraction has coordinate degree at least \(24\).

The headline emptiness theorem is not yet proved.

## 1. Postcomposition theorem

Let \(A\) be represented by \(P\) with \(F(P)=0\), and let
\(\sigma:X\dashrightarrow X\) have ambient coordinate lifts \(S\). Since
\(\sigma\) lands on \(X\),

\[
F(S)=FB
\]

for a polynomial \(B\). Therefore

\[
F(S(P))=F(P)B(P)=0.
\]

Thus \(\sigma\circ A\) is again an ambient landing map. If \(A|_X=\varphi\),
then

\[
(\sigma\circ A)|_X=\sigma\circ\varphi,
\qquad
\deg((\sigma\circ A)|_X)=\deg(\sigma)\deg(\varphi).
\]

This is the exact reason a nonempty ambient category cannot have bounded
restriction degree.

## 2. Low-degree ambient landing theorem

Every landing tuple vanishes on every involution plus-plane. At the split good
prime \(67\), exact Reynolds averaging and the characteristic-zero Molien
dimensions give the following kernels for restriction to one representative
plus-plane:

| coordinate degree | covariant dimension | plus-plane kernel |
|---:|---:|---:|
| 15 | 32 | 0 |
| 16 | 41 | 0 |
| 17 | 49 | 2 |
| 18 | 59 | 3 |
| 19 | 73 | 7 |
| 20 | 86 | 11 |
| 21 | 100 | 16 |

For degrees \(17,18,19\), the exact coefficients of \(F(P)\) span all cubic
coefficient monomials. For degrees \(20,21\), the degree-four Macaulay ranks
are respectively

\[
1001=\dim \operatorname{Sym}^4(\mathbf F_{67}^{11})^\vee
\]

and

\[
3876=\dim \operatorname{Sym}^4(\mathbf F_{67}^{16})^\vee.
\]

Hence all five projective landing loci are empty. Proper specialization gives
the characteristic-zero result. Combined with the sealed exclusion through
degree \(14\),

\[
\boxed{\text{every nonzero ambient landing tuple has degree at least }22.}
\]

See `LOW_DEGREE_DOMINANT_MAPS.md` and
`verify_low_degree_dominant_maps.py`.

## 3. New retraction transform and degree bound

For a hypothetical retraction use the accepted normal form

\[
T=Hx+FQ
\]

and polar invariants \(R,S\), with \(\Delta=R^2+4S\). Define

\[
J=2H+FR,
\qquad
V=2Q-Rx.
\]

The polar system gives the exact identity

\[
\boxed{F(V)=J\Delta.}
\]

It also gives

\[
F^4\Delta=
9\Phi(x,x,T)^2-12F\Phi(x,T,T).
\]

On every involution plus-plane, \(T=0\) forces

\[
H=Fu,\qquad Q=-ux,\qquad R=-2u
\]

after restricting \(F\) to that plane. Therefore

\[
J|_{W_+(t)}=V|_{W_+(t)}=0.
\]

The exact invariant restriction map is injective in every degree at most
\(22\); its first special-fibre kernel is one-dimensional in degree \(23\).
If the retraction degree satisfied \(d\le23\), then \(J\) would have degree at
most \(22\), hence \(J=0\), and \(H=-FR/2\), contradicting
\(\gcd(H,F)=1\). Thus

\[
\boxed{d\ge24.}
\]

At \(d=24\), the problem is the finite divisibility locus

\[
0\ne V\in K_{21},
\qquad
J_{23}\mid F(V),
\]

where the good-reduction covariant kernel has dimension \(16\) and the scalar
degree-\(23\) kernel is one-dimensional. Its discriminant must be nonsquare,
because a square would give a degree-\(21\) landing tuple, now excluded.

See `RETRACTION_DEGREE_BOUND.md`.

## 4. Normalized-Rees carrier boundary

The later binding packet `EXCEPTIONAL_CARRIER_RIGIDITY/` remains in force.

The normalized graph of the restricted ideal is canonically the normalization
of the component dominating \(X\) inside the ambient normalized blowup. The
joint-residue theorem characterizes which higher divisors survive as Rees
divisors.

For an involution-fixed elliptic \(E_t\), the ordinary valuation has a
canonical residual-\(S_3\)-stable center on the normalized graph. Its accepted
first nonzero normal order is odd, so its actual integrated target is the fixed
line \(L_t\), not \(E_t\). Any elliptic-target carrier is therefore secondary:
a normalized point-fibre curve or an involution-fixed slice in a retained
surface-valued carrier.

At a type-II \(V_4\) point, in character coordinates \((b,c,d)\),

\[
I_P\subset(c,d)\cap(b,d)\cap(b,c)=(bc,bd,cd),
\]

and the quadratic initial tuple has

\[
P_B^{(2)}=\alpha cd,\qquad
P_C^{(2)}=\beta bd,\qquad
P_D^{(2)}=\gamma bc.
\]

The global landing identity forces

\[
\boxed{\alpha\beta\gamma=0.}
\]

Point-centered curve-valued divisors are contracted by the joint-residue
criterion; the remaining local objects are curve components of normalized
point fibres and fixed slices inside surface-valued Rees divisors.

## 5. Required checkpoint, updated

### Q1

The landing locus \(\{P:F(P)=0\}\) is a nonlinear cubic cone in the finitely
generated covariant module, not an additive syzygy module.

### Q2

The ordinary carrier over \(E_t\) is canonical and integrated, but line-valued.
It does not provide an elliptic selfcarrier.

### Q3

The simultaneous type-II relation is
\(\alpha\beta\gamma=0\), together with contraction of every point-centered
curve-valued divisor.

### Q4

The local constraints do not force a finite nonempty profile list.
Postcomposition makes such a list impossible if one ambient map exists.
They now do force the concrete coordinate bounds \(d\ge22\) for all landing
tuples and \(d\ge24\) for retractions.

## 6. Smallest remaining targets

The first unrestricted ambient coordinate degree is now \(22\).

The first retraction coordinate degree is \(24\), reduced to the finite
divisibility problem

\[
J_{23}\mid F(V),\qquad V\in K_{21}\setminus\{0\},
\]

with nonsquare quotient.

For the Rees route, the smallest local theorem is still to enumerate the
actual normalized type-I/type-II point-fibre curves and fixed slices inside
retained surface carriers, subject to the product-zero relation, and prove
that their synchronized occurrence over all \(55\) \(V_4\)-configurations is
impossible.

Current honest exits:

```text
AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22
DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24
FULL-G-AMBIENT-SELFMAP-CLASSIFICATION-UNDECIDED
KLEIN-PSL2(11)-NONUNIRATIONAL-NOT-PROVED
```
