# Saturation of the residual multiplier boundary

## Statement and boundary

Work in the quartic special-seed setup of
[special_seed_stability_frontier.md](special_seed_stability_frontier.md)
and use the flat length-three frame for the divisor \(2p+r\). This note
computes, scheme-theoretically, the closure of the residual Lagrange
incidence through the multiplier hyperplane \(\lambda _2=0\).

Let

\[
V=H^0(\mathbf P^2_x\times\mathbf P^2_y,\mathcal O(2,4)),
\]

and let \(\mathcal A=\mathbf P^2_x\times\mathcal I\) be the six-dimensional
space of \((x,p,\ell,r)\). On a flat affine chart write the length-three
remainder as

\[
s=(s_0,s_1,s_2),
\]

and let
\([\lambda _0:\lambda _1:\lambda _2]\in\mathbf P^2\) be the Lagrange
multiplier for the four vertical variables \(z=(A,B,L,T)\). Denote by
\(\mathfrak C\) the universal first-order incidence

\[
s=0,\qquad \lambda D_zs=0.
\tag{0.1}
\]

The residual incidence is the open part \(\lambda _2\ne0\).

> **Saturation theorem.** Locally on \(\mathcal A\), after an invertible
> linear change of coefficient coordinates, the ideal of (0.1) is
>
> \[
> I=(S_0,S_1,S_2,A_\lambda,B_\lambda,
>       \lambda _1\eta _1+\lambda _2\eta _2,\lambda _2W),
> \tag{0.2}
> \]
>
> where
>
> \[
> A_\lambda=\lambda _0A_0+\lambda _1A_1+\lambda _2A_2,\qquad
> B_\lambda=\lambda _0B_0+\lambda _1B_1+\lambda _2B_2,
> \tag{0.3}
> \]
>
> and the twelve coefficient linear forms
>
> \[
> S_0,S_1,S_2,W,A_0,A_1,A_2,B_0,B_1,B_2,\eta _1,\eta _2
> \tag{0.4}
> \]
>
> are independent. Consequently
>
> \[
> \boxed{
> I:\lambda _2^\infty
> =(S_0,S_1,S_2,W,A_\lambda,B_\lambda,
>   \lambda _1\eta _1+\lambda _2\eta _2).}
> \tag{0.5}
> \]

This holds both for \(p\ne r\) and on the diagonal \(p=r\). The saturated
multiplier ranks are

\[
\begin{array}{c|c|c}
[\lambda]&\operatorname {rank}I&
 \operatorname {rank}(I:\lambda _2^\infty)\\ \hline
\lambda _2\ne0&7&7\\
\lambda _2=0,\ \lambda _1\ne0&6&7\\
[1:0:0]&5&6.
\end{array}
\tag{0.6}
\]

Thus the rank-six and rank-five rows in the unsaturated first-jet table are
not ranks of the residual closure. Saturation restores the missing
moving-\(r\) equation \(W=0\).

The saturated universal incidence is reduced and irreducible. Its only
intrinsic singular locus over \(\lambda _2=0\) is

\[
\boxed{
[\lambda]=[1:0:0],\qquad \eta _1=\eta _2=0.}
\tag{0.7}
\]

Transversely it is the ordinary rank-four quadric cone

\[
\lambda _1\eta _1+\lambda _2\eta _2=0.
\tag{0.8}
\]

At a fixed flag the locus (0.7) imposes eight independent conditions on
the quartic coefficients. Since \(\dim\mathcal A=6\), a general quartic
equation avoids it. The remaining saturated boundary has expected
dimension zero in a general-\(F\) fiber. In particular, saturation creates
no positive-dimensional tangent-base or conic-multiplier component.

This note itself supplies one uniform piece of the then-missing one-point
theorem.  The subsequent
[`special_seed_ramification_comparison.md`](special_seed_ramification_comparison.md)
identifies the finite-boundary closure with the smooth actual ramification
curve and settles generic two-point separation.  The further
[`special_seed_boundary_fold_theorem.md`](special_seed_boundary_fold_theorem.md)
proves the ordinary middle/bottom boundary fold and \(\gamma\ne0\).  Uniform
open-residual fold/cusp and higher-Morin models and isolated multiple-value
collisions remain open.

## 1. The flat coefficient-row splitting

Normalize

\[
x=[1:A:B],\qquad p=(u=v=0),\qquad
\ell=\{v=Lu\},\qquad r=(T,LT).
\tag{1.1}
\]

A coefficient monomial restricts as

\[
A^aB^bL^j u^{i+j},\qquad a+b\le2,\quad i+j\le4.
\tag{1.2}
\]

Modulo \(u^2(u-T)\), use the flat basis \(1,u,u^2\), so

\[
u^m\equiv T^{m-2}u^2\pmod {u^2(u-T)},\qquad m\ge2.
\tag{1.3}
\]

The three section rows are denoted \(S_0,S_1,S_2\). The \(A\)-derivative
of the three layers gives three independent rows \(A_0,A_1,A_2\), and the
\(B\)-derivative gives another independent triple \(B_0,B_1,B_2\). These
two triples live in the disjoint coefficient blocks \(a=1\) and \(b=1\).

Differentiation in \(L\) multiplies the binary restriction by \(u\). It
therefore has no \(s_0\)-component. Its remaining two layer rows are
independent; call them \(\eta _1,\eta _2\). Differentiation in \(T\)
affects only the last layer in (1.3). Its row is a single form \(W\),
independent of \(S_0,S_1,S_2\). Thus

\[
\lambda D_As=A_\lambda,\qquad
\lambda D_Bs=B_\lambda,\qquad
\lambda D_Ls=\lambda _1\eta _1+\lambda _2\eta _2,\qquad
\lambda D_Ts=\lambda _2W.
\tag{1.4}
\]

The monomial blocks just described prove the independence of all twelve
rows in (0.4). This is a row-space proof, not an inference from a sampled
rank. The two projective orbits of \((p,\ell,r)\) are \(p\ne r\) and
\(p=r\), represented by \(T=1\) and \(T=0\). Formula (1.3) proves the same
splitting on both orbits. Projective coordinate changes in the two plane
factors give the asserted local normal form at every flag.

## 2. Scheme saturation

Let \(J\) denote the right-hand ideal in (0.5). Plainly

\[
I[\lambda _2^{-1}]=J[\lambda _2^{-1}].
\tag{2.1}
\]

It remains to see that \(J\) is already \(\lambda _2\)-saturated. On the
chart \(\lambda _0=1\), eliminate \(S_0,S_1,S_2,W,A_0,B_0\). Up to free
polynomial variables, the quotient is

\[
k[\lambda _1,\lambda _2,\eta _1,\eta _2]\big/
(\lambda _1\eta _1+\lambda _2\eta _2).
\tag{2.2}
\]

The displayed quadratic has rank four. A reducible quadratic which is a
product of two linear forms has rank at most two, so (2.2) is a domain. On
the charts \(\lambda _1\ne0\) and \(\lambda _2\ne0\), one may instead
eliminate \(\eta _1\) or \(\eta _2\), and the quotient is a polynomial ring.
The charts meet the dense residual stratum, so \(J\) is prime and is the
scheme-theoretic closure of that stratum. In particular
\(\lambda _2\) is a nonzerodivisor modulo \(J\). Combining this with (2.1)
gives (0.5).

The same chart also identifies the singular locus. The gradient of the
only nonlinear equation is

\[
(\eta _1,\eta _2,\lambda _1,\lambda _2).
\tag{2.3}
\]

It vanishes exactly at (0.7), and the rank-four quadratic proves the
ordinary-cone statement (0.8).

## 3. Boundary dimensions for a general quartic

Let \(\mathbf P(V)=\mathbf P^{89}\). Over the middle multiplier stratum

\[
\lambda _2=0,\qquad\lambda _1\ne0,
\]

the saturated coefficient rank is seven. The flag and multiplier
dimensions are \(6+1\), so the corresponding universal boundary incidence
has dimension

\[
(89-7)+(6+1)=89.
\tag{3.1}
\]

At \([1:0:0]\), the saturated coefficient rank is six and the multiplier
has no parameter. The dimension is again

\[
(89-6)+6=89.
\tag{3.2}
\]

Thus a general coefficient fiber meets either boundary stratum in a finite
scheme or not at all. Neither stratum can be a curve component of the
general saturated residual incidence.

At the intrinsic node (0.7), the independent coefficient conditions are

\[
S_0=S_1=S_2=W=A_0=B_0=\eta _1=\eta _2=0.
\tag{3.3}
\]

They have rank eight. Its universal incidence therefore has dimension

\[
(89-8)+6=87<89.
\tag{3.4}
\]

Its image in \(\mathbf P(V)\) is proper, proving that a general \(F\) avoids
the singularity of the saturated universal compactification.

These dimension statements concern the universal incidence saturated
before specialization.  By themselves they do not say that saturation
commutes with every special coefficient fiber, nor that the finite boundary
scheme already has the desired ramification interpretation.  That comparison
is subsequently proved in
[`special_seed_ramification_comparison.md`](special_seed_ramification_comparison.md).
The boundary \(\gamma\)-condition is subsequently proved in
[`special_seed_boundary_fold_theorem.md`](special_seed_boundary_fold_theorem.md);
open-residual higher jets and isolated multiple coincidences remain separate
problems.

## 4. Mechanical replay

The checker
[special_seed_residual_saturation_checks.py](special_seed_residual_saturation_checks.py)
constructs the ninety integer coefficient columns and verifies at both
\(T=0\) and \(T=1\):

1. the \(3+1+3+3+2=12\) independent rows in (0.4);
2. every unsaturated and saturated multiplier rank over
   \(\mathbf F_5\) and \(\mathbf F_7\);
3. the rank-eight coefficient locus (3.3), over \(\mathbf Q\) and modulo
   \(101,103\); and
4. the rank-four transverse quadric in (0.8).

Its checked output is in
[special_seed_residual_saturation_checks.log](special_seed_residual_saturation_checks.log).
