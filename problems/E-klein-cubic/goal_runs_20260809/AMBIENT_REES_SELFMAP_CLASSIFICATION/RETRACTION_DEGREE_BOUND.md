# Retraction discriminant transform and coordinate-degree bound

**Date:** 2026-08-09  
**Exit:** `DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`

## Theorem

Let

\[
T:\mathbf P(W_5)\dashrightarrow X
\]

be a primitive homogeneous \(G\)-equivariant landing tuple of coordinate
degree \(d\) whose restriction to \(X\) is the identity. Then

\[
\boxed{d\ge24.}
\]

If \(d=24\), its residual discriminant is necessarily nonsquare, and the
retraction is reduced to a finite divisibility problem involving one scalar
plus-plane equation and at most sixteen covariant parameters.

## 1. Accepted polar normal form

Use the accepted retraction presentation

\[
T=Hx+FQ,
\qquad \gcd(H,F)=1,
\tag{1.1}
\]

with

\[
\deg H=d-1,\qquad \deg Q=d-3.
\]

Put

\[
A=\Phi(x,x,Q),\qquad B=\Phi(x,Q,Q),\qquad F(Q)=HS.
\]

The polar identities give invariants \(R,S\) satisfying

\[
H+3A=FR,
\tag{1.2}
\]

\[
HR+3B+FS=0,
\tag{1.3}
\]

and the residual discriminant is

\[
\Delta=R^2+4S.
\tag{1.4}
\]

## 2. A discriminant transform

Define

\[
\boxed{J=2H+FR},
\qquad
\boxed{V=2Q-Rx}.
\tag{2.1}
\]

Then

\[
\deg J=d-1,\qquad \deg V=d-3,
\]

\(J\) is invariant, \(V\) is a \(G\)-covariant, and one has the exact identity

\[
\boxed{F(V)=J\Delta.}
\tag{2.2}
\]

Indeed, cubic polarization gives

\[
F(2Q-Rx)
=
8F(Q)-12R\,B+6R^2A-R^3F.
\]

Substituting \(F(Q)=HS\), (1.2), and (1.3) yields

\[
F(2Q-Rx)
=(2H+FR)(R^2+4S).
\]

This packages the nonsquare branch as a divisibility condition for one
covariant.

There is also an identity written directly in terms of the landing tuple:

\[
\boxed{
F^4\Delta
=
9\Phi(x,x,T)^2-12F\,\Phi(x,T,T).
}
\tag{2.3}
\]

Thus the discriminant is controlled by the actual ambient tuple, not merely by
the abstract residual quadratic.

## 3. Vanishing on every involution plus-plane

Fix an involution and write \(Z=\mathbf P(W_+)\). Let

\[
f=F|_{W_+}.
\]

Every landing tuple vanishes on \(W_+\), so restriction of (1.1) gives

\[
Hx+fQ=0.
\tag{3.1}
\]

The smooth plane cubic \(f\) is not divisible by any coordinate of \(x\).
Equation (3.1) therefore forces

\[
H|_{W_+}=fu,\qquad Q|_{W_+}=-ux
\tag{3.2}
\]

for a scalar form \(u\). Restricting (1.2) gives

\[
R|_{W_+}=-2u.
\tag{3.3}
\]

Consequently

\[
\boxed{J|_{W_+}=0,\qquad V|_{W_+}=0.}
\tag{3.4}
\]

By conjugacy, both vanish on all \(55\) involution plus-planes.

## 4. The invariant restriction theorem

The good-reduction verifier computes the scalar restriction maps

\[
\mathbf C[W_5]^G_e
\longrightarrow
\mathbf C[W_+(t)]_e
\tag{4.1}
\]

for every \(0\le e\le23\). The result is

\[
\ker(4.1)=0\quad(0\le e\le22),
\tag{4.2}
\]

while the special-fibre kernel in degree \(23\) is one-dimensional.

Injectivity modulo the good prime \(67\), together with the exact
characteristic-zero invariant dimensions, proves characteristic-zero
injectivity through degree \(22\).

If a retraction had \(d\le23\), then \(\deg J=d-1\le22\), and (3.4) would imply

\[
J=0.
\]

But \(J=2H+FR=0\) gives

\[
H=-\frac12FR,
\]

contradicting \(\gcd(H,F)=1\) and primitivity. Therefore

\[
\boxed{d\ge24.}
\]

## 5. Exact degree-24 boundary

At \(d=24\),

\[
\deg J=23,\qquad \deg V=21.
\]

Any retraction must therefore satisfy:

1. \(0\ne J\) lies in the scalar degree-\(23\) kernel of plus-plane
   restriction; after reduction at \(67\), this kernel is one-dimensional;
2. \(0\ne V\) lies in the degree-\(21\) covariant plus-plane kernel, whose
   special-fibre dimension is \(16\);
3. \(F(V)\) is divisible by \(J\), with quotient \(\Delta\) of degree \(40\);
4. \(\Delta\) is nonsquare.

The last assertion follows from the square-discriminant descent. A square
\(\Delta\) would produce a nonzero landing tuple of degree

\[
d-3=21,
\]

but all landing tuples through degree \(21\) are excluded by
`LOW_DEGREE_DOMINANT_MAPS.md`.

Thus the first retraction degree is no longer an unbounded polar system. It is
the finite projective problem

\[
\boxed{
0\ne V\in K_{21},\qquad J_{23}\mid F(V),
}
\tag{5.1}
\]

where the good-reduction ambient parameter space has dimension at most
\(16\), and \(J_{23}\) is unique up to scale in the special fibre.

This finite degree-\(24\) divisibility locus has not yet been proved empty.

## 6. Scope

The theorem excludes all degree-\(\le23\) retractions. It does not exclude
higher-degree retractions and does not by itself exclude ambient maps whose
restriction has degree greater than one.

The smallest retraction target is now (5.1), not the unrestricted nonsquare
polar recursion.

## Replay

The scalar restriction computation and the degree-\(21\) landing exclusion are
both replayed by:

```text
python3 verify_low_degree_dominant_maps.py
```

Markers:

```text
INVARIANT_PLUS_PLANE_RESTRICTION_INJECTIVE_THROUGH_DEGREE_22
LANDING_COVARIANTS_DEGREES_15_THROUGH_21_EXCLUDED
DOMINANT_MAP_LOW_DEGREE_CERTIFICATE_OK
```
