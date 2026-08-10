# Notebook supplement — ambient Rees selfmap classification

**Date:** 2026-08-09  
**Packet:** `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/`  
**Headline:** OPEN

## Binding correction: empty or unbounded

If

\[
A:\mathbf P(W_5)\dashrightarrow X
\]

is an ambient \(G\)-landing map represented by \(P\) with \(F(P)=0\), and

\[
\sigma:X\dashrightarrow X
\]

is any dominant rational \(G\)-selfmap, choose ambient lifts \(S\) of the
coordinates of \(\sigma\). Since \(F(S)=FB\),

\[
F(S(P))=F(P)B(P)=0.
\]

Thus \(\sigma\circ A\) is again an ambient landing map.

The accepted tangent-residual theorem supplies a nonidentity \(G\)-selfmap of
degree at least \(3\) and iterates of unbounded degree. Hence:

```text
NO AMBIENT LANDING MAP EXISTS
or
AMBIENT-EXTENDABLE RESTRICTIONS HAVE UNBOUNDED DEGREE.
```

The former ambient identity, degree-one, and uniform finite-profile targets
are therefore false conditional on nonemptiness. The correct negative target
is

```text
NO-DOMINANT-G-AMBIENT-LANDING-MAP
```

## New closed theorem: ambient coordinate degree at least 22

Every landing tuple vanishes on every involution plus-plane. At the split good
prime \(67\), exact Reynolds averaging gives the following restriction kernels:

| degree | covariant dimension | plus-plane kernel |
|---:|---:|---:|
| 15 | 32 | 0 |
| 16 | 41 | 0 |
| 17 | 49 | 2 |
| 18 | 59 | 3 |
| 19 | 73 | 7 |
| 20 | 86 | 11 |
| 21 | 100 | 16 |

For degrees \(17,18,19\), the coefficients of the landing identity span the
entire cubic coefficient space. For degrees \(20,21\), the degree-four
Macaulay ranks are full:

\[
1001/1001,\qquad 3876/3876.
\]

Thus every special-fibre projective landing locus is empty. Proper
specialization gives the characteristic-zero exclusion in degrees
\(15,\ldots,21\). Combined with the sealed exclusion through degree \(14\),

\[
\boxed{\text{every nonzero ambient landing tuple has degree at least }22.}
\]

Files:

- `LOW_DEGREE_DOMINANT_MAPS.md`
- `verify_low_degree_dominant_maps.py`
- `verification_output_low_degree_dominant_maps.txt`

Exit:

```text
AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22
```

## New closed theorem: every retraction has degree at least 24

For a hypothetical retraction use

\[
T=Hx+FQ,
\qquad
\Delta=R^2+4S.
\]

Define

\[
J=2H+FR,
\qquad
V=2Q-Rx.
\]

The complete polar system gives

\[
\boxed{F(V)=J\Delta}
\]

and

\[
\boxed{
F^4\Delta=
9\Phi(x,x,T)^2-12F\Phi(x,T,T).
}
\]

On every involution plus-plane, \(T=0\) forces

\[
H=Fu,\qquad Q=-ux,\qquad R=-2u,
\]

so

\[
J|_{W_+(t)}=V|_{W_+(t)}=0.
\]

The exact invariant restriction map is injective through degree \(22\). Since
\(\deg J=d-1\), a retraction of degree \(d\le23\) would have \(J=0\), hence
\(F\mid H\), contradicting primitivity. Therefore

\[
\boxed{d\ge24.}
\]

At degree \(24\), the remaining retraction problem is finite:

\[
0\ne V\in K_{21},
\qquad
J_{23}\mid F(V).
\]

Modulo \(67\), \(K_{21}\) has dimension \(16\), and the scalar degree-\(23\)
plus-plane kernel is one-dimensional. The quotient discriminant must be
nonsquare, because a square would produce a degree-\(21\) landing tuple, now
excluded.

File:

- `RETRACTION_DEGREE_BOUND.md`

Exit:

```text
DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24
```

## Normalized-Rees carrier boundary

This supplement incorporates
`goal_runs_20260809/EXCEPTIONAL_CARRIER_RIGIDITY/`.

The normalized graph of the restricted ideal is canonically the normalized
dominant transform inside the ambient normalized blowup. Ordinary fixed-curve
valuations have canonical centers there, and the joint-residue field decides
whether a higher divisor survives as a Rees divisor.

For the fixed elliptic \(E_t\), the accepted first nonzero ordinary normal
order is odd. Therefore the canonical ordinary carrier is line-valued:

\[
q(K_{E,t})\subset L_t.
\]

Any elliptic-target carrier must be secondary: a normalized point-fibre curve
or an involution-fixed curve slice in a retained surface-valued divisor.

At a type-II \(V_4\) point, forced vanishing on the three plus-planes gives

\[
I_P\subset(c,d)\cap(b,d)\cap(b,c)=(bc,bd,cd).
\]

The quadratic initial tuple is

\[
P_B^{(2)}=\alpha cd,\quad
P_C^{(2)}=\beta bd,\quad
P_D^{(2)}=\gamma bc,
\]

and the global landing identity forces

\[
\boxed{\alpha\beta\gamma=0.}
\]

A point-centered divisor with only curve-valued target is contracted on the
normalized graph.

## Updated checkpoint

### Q1

The landing locus is a nonlinear cubic cone, not an additive syzygy module.

### Q2

The ordinary elliptic-source carrier is canonical and integrated, but maps to
the fixed line. Any elliptic-target carrier is secondary.

### Q3

The first simultaneous type-II relation is
\(\alpha\beta\gamma=0\), followed by the joint-residue contraction criterion.

### Q4

A nonempty uniform finite profile list is impossible by postcomposition.
Nevertheless, the actual landing identity plus the forced plus-plane ideal now
gives the concrete global bounds \(d\ge22\) for all landing tuples and
\(d\ge24\) for retractions.

## Exact remaining targets

The first unrestricted ambient coordinate degree is \(22\).

The first retraction coordinate degree is \(24\), with the finite nonsquare
divisibility target

\[
J_{23}\mid F(V),\qquad V\in K_{21}\setminus\{0\}.
\]

The smallest remaining Rees theorem is to enumerate actual normalized
type-I/type-II point-fibre curves and fixed slices inside retained surface
carriers, subject to the type-II product-zero relation, and prove that their
global synchronization over all \(55\) \(V_4\)-configurations is impossible.

Current exits:

```text
AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22
DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24
FULL-G-AMBIENT-SELFMAP-CLASSIFICATION-UNDECIDED
KLEIN-PSL2(11)-NONUNIRATIONAL-NOT-PROVED
```
