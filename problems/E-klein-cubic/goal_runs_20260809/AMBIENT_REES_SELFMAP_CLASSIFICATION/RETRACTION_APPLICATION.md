# Retraction application after the postcomposition correction

The accepted degree-one normal form remains valid for a hypothetical ambient
map whose restriction is the identity:

\[
T=Hx+FQ,
\qquad
F(x+tQ)=(Ht-F)(St^2-Rt-1),
\qquad
\Delta=R^2+4S.
\]

Postcomposition changes the logical role of this branch: a retraction, if it
exists, generates higher-degree ambient restrictions by composing with the
known intrinsic \(G\)-selfmaps. Excluding retractions is therefore a special
subproblem, not the final step after a nonempty ambient degree-one theorem.

## New exact transform

Define

\[
J=2H+FR,
\qquad
V=2Q-Rx.
\]

The polar identities give

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

Every landing tuple vanishes on every involution plus-plane. Restricting the
retraction normal form there gives

\[
H=Fu,\qquad Q=-ux,\qquad R=-2u,
\]

and hence

\[
J|_{W_+(t)}=V|_{W_+(t)}=0
\]

for all \(55\) involutions.

The exact invariant restriction map has zero kernel through degree \(22\).
Since \(\deg J=d-1\), a retraction of degree \(d\le23\) would have \(J=0\),
forcing \(F\mid H\), contrary to primitivity. Therefore

\[
\boxed{d\ge24.}
\]

At \(d=24\), \(J\) has degree \(23\), \(V\) has degree \(21\), and the problem
is the finite divisibility locus

\[
0\ne V\in K_{21},
\qquad
J_{23}\mid F(V).
\]

The good-reduction degree-\(21\) kernel has dimension \(16\), while the scalar
degree-\(23\) kernel is one-dimensional. The quotient \(\Delta\) must be
nonsquare, because a square would produce a degree-\(21\) landing tuple and
such tuples are now excluded.

The complete proof is in `RETRACTION_DEGREE_BOUND.md`.

## Current role

The new result closes all coordinate degrees through \(23\) in the retraction
branch, but it does not exclude the finite degree-\(24\) nonsquare divisibility
locus or higher-degree retractions.

The headline negative problem still requires

```text
NO-DOMINANT-G-AMBIENT-LANDING-MAP
```

rather than only exclusion of retractions.
