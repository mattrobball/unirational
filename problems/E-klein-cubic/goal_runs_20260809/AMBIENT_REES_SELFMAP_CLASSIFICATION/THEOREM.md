# Ambient landing theorems

**Date:** 2026-08-09  
**Field:** \(\mathbf C\)  
**Group:** \(G=\operatorname{PSL}_2(\mathbf F_{11})\)  
**Threefold:** Klein cubic \(X=V(F)\subset\mathbf P(W_5)\)

## Theorem A — postcomposition closure

Let

\[
\mathscr A_G(X)=
\{A:\mathbf P(W_5)\dashrightarrow X:
A\text{ dominant and }G\text{-equivariant}\}.
\]

There is a right action

\[
\mathscr A_G(X)\times
\operatorname{End}^{\mathrm{rat,dom}}_G(X)
\longrightarrow\mathscr A_G(X),
\qquad
(A,\sigma)\longmapsto\sigma\circ A.
\]

If \(A|_X=\varphi\), then

\[
(\sigma\circ A)|_X=\sigma\circ\varphi
\]

and

\[
\deg((\sigma\circ A)|_X)
=
\deg(\sigma)\deg(\varphi).
\]

### Proof

Represent \(A\) by a primitive homogeneous tuple \(P\) with

\[
F(P)=0.
\]

Choose ambient lifts \(S\) of the coordinate sections of \(\sigma\). Since
\(\sigma(X)\subset X\) and the ideal of \(X\) is \((F)\),

\[
F(S)=FB
\]

for a homogeneous polynomial \(B\). Substitution gives

\[
F(S(P))=F(P)B(P)=0.
\]

Thus \(S(P)\) is an ambient landing tuple. Equivariance and dominance are
preserved. Removing a common factor preserves the landing identity by cubic
homogeneity. Degrees of dominant generically finite rational maps multiply.

## Corollary A.1 — empty or unbounded

The accepted tangent-residual theorem gives a nonidentity dominant
\(G\)-selfmap \(\sigma\) of degree \(q\ge3\). Therefore either

\[
\mathscr A_G(X)=\varnothing,
\]

or, for every \(A\in\mathscr A_G(X)\),

\[
\deg((\sigma^m\circ A)|_X)=q^m\deg(A|_X)
\]

is unbounded.

Consequently a nonempty ambient category cannot satisfy an identity theorem, a
degree-one theorem, or a uniform finite classification recording restriction
degree.

## Theorem B — low-degree ambient landing obstruction

Let

\[
P\in
(\operatorname{Sym}^dW_5^\vee\otimes W_5)^G
\]

be a nonzero homogeneous tuple with \(F(P)=0\). Then

\[
\boxed{d\ge22.}
\]

### Proof boundary

The accepted forced-base theorem gives \(P|_{W_+(t)}=0\) for every
involution. The exact good-reduction calculation at \(67\) computes the
restriction kernels in degrees \(15,\ldots,21\). They have dimensions

\[
0,0,2,3,7,11,16.
\]

For kernel dimensions \(2,3,7\), the coefficient equations of \(F(P)=0\) span
the full cubic coefficient spaces of dimensions \(4,10,84\). For kernel
dimensions \(11,16\), their degree-four Macaulay spans have full ranks

\[
1001=\dim\operatorname{Sym}^4(\mathbf F_{67}^{11})^\vee,
\]

\[
3876=\dim\operatorname{Sym}^4(\mathbf F_{67}^{16})^\vee.
\]

Hence every corresponding projective landing locus over
\(\overline{\mathbf F}_{67}\) is empty. Proper specialization excludes
characteristic-zero points. Combined with the sealed degree-\(\le14\)
calculation, this proves the theorem.

See `LOW_DEGREE_DOMINANT_MAPS.md` for the complete specialization argument and
`verify_low_degree_dominant_maps.py` for the exact calculation.

## Theorem C — retraction coordinate-degree bound

Let \(T\) be a primitive ambient landing tuple of degree \(d\) whose
restriction to \(X\) is the identity. Then

\[
\boxed{d\ge24.}
\]

### Proof

Use the accepted normal form and polar system

\[
T=Hx+FQ,\qquad
H+3\Phi(x,x,Q)=FR,
\]

\[
F(Q)=HS,\qquad
HR+3\Phi(x,Q,Q)+FS=0.
\]

Set

\[
J=2H+FR,\qquad V=2Q-Rx,\qquad\Delta=R^2+4S.
\]

Direct cubic polarization gives

\[
\boxed{F(V)=J\Delta.}
\]

On an involution plus-plane, \(T=0\) forces

\[
H=Fu,\qquad Q=-ux,\qquad R=-2u,
\]

so \(J\) and \(V\) vanish on every plus-plane.

The exact invariant restriction calculation proves that no nonzero invariant
of degree at most \(22\) vanishes on a plus-plane. If \(d\le23\), then
\(\deg J=d-1\le22\), so \(J=0\). Hence

\[
H=-\frac12FR,
\]

contradicting \(\gcd(H,F)=1\). Thus \(d\ge24\).

At \(d=24\), \(J\) has degree \(23\), \(V\) has degree \(21\), and the first
remaining retraction problem is

\[
0\ne V\in K_{21},\qquad J_{23}\mid F(V).
\]

Its discriminant must be nonsquare, because a square would produce a
degree-\(21\) landing tuple, excluded by Theorem B.

See `RETRACTION_DEGREE_BOUND.md`.

## Current theorem boundary

The following exits are proved:

```text
AMBIENT-POSTCOMPOSITION-CLOSURE
AMBIENT-LANDING-EMPTY-OR-UNBOUNDED
AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22
DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24
```

The headline emptiness theorem remains open:

```text
NO-DOMINANT-G-AMBIENT-LANDING-MAP          NOT PROVED
KLEIN-PSL2(11)-NONUNIRATIONAL              NOT PROVED
```

The first unrestricted ambient degree is \(22\). The first retraction degree
is \(24\), reduced to the finite nonsquare divisibility locus above.
