# Ambient Hodge--Rees bridge: status

**Date:** 2026-08-10  
**Problem:** Klein cubic / \(G=\operatorname{PSL}_2(\mathbf F_{11})\)  
**Headline:** Problem E remains **OPEN**.

## Exact exit

```text
AMBIENT-HODGE-SUPPORT-PROVED
RESTRICTED-TRANSFER-UNDECIDED
```

The ambient normalized graph carries a canonical, resolution-independent copy of
the actual landing Hodge structure in intersection cohomology.  The perverse
Leray filtration for its birational morphism to \(\mathbf P^4\) forces that copy
into at least one proper strict-support block over the ambient base locus.  This is the
missing resolution-independent replacement for the phrase “some blowup center
has the right \(H^1\).”

The support is not, in general, an ordinary positive-irregularity subvariety or
a Rees divisor.  Its exact canonical form is the maximal strict-support block

\[
\mathcal M_{S,j}
\subset
{}^pH^j\!\left(Rp_*IC_{\widehat P}^{H}\right),
\]

and the necessary condition is

\[
\operatorname{Hom}_{\mathrm{HS},H}
\!\left(
\operatorname{Res}_H V,\,
H^{-1-j}(\mathbf P^4,\mathcal M_{S,j})(1)
\right)\ne0.
\tag{AHS}
\]

Here \(S\) lies in the ambient base locus, \(H=\operatorname{Stab}_G(S)\),
and \(V=H^3(X,\mathbf Q)(1)\).  For a simple constituent and the stabilizer
of the pair \((S,\mathcal L)\), this refines to the corresponding
intersection-cohomology expression.  When \(\mathcal L\) is a Tate twist of
a finite-monodromy local system in the degree-one cases, (AHS) reduces after a
finite cover to the repository's ordinary \(H^1\)-carrier condition.  Without
that extra hypothesis, demanding ordinary geometric \(H^1\) is too strong.

## What has been proved

1. If
   \[
   p:\widehat P\to\mathbf P^4,\qquad q:\widehat P\to X
   \]
   are the two projections of the ambient normalized graph, then
   \(q^*:H^3(X)\to H^3(\widehat P)\) is injective.

2. The pure weight-three image has a canonical injection
   \[
   \alpha_A:
   H^3(X,\mathbf Q)
   \hookrightarrow
   IH^3(\widehat P,\mathbf Q).
   \]
   For every resolution \(r:Z\to\widehat P\), the actual subspace
   \(g^*H^3(X)=r^*q^*H^3(X)\) is the pullback of the intrinsic ordinary class
   \(q^*H^3(X)\); \(\alpha_A\) is its canonical pure intersection-cohomology
   shadow.  It is not an abstract isomorphic summand inserted by later blowups.

3. Because the primitive ambient tuple has no divisorial common factor, every
   proper strict support of \(Rp_*IC_{\widehat P}^{H}\) lies in a subset of
   dimension at most two.  The only full-support term is
   \(\mathbf Q_{\mathbf P^4}^{H}[4]\), and its contribution to degree three is
   \(H^3(\mathbf P^4)=0\).  Thus the actual image \(\alpha_A(V)\) has a nonzero
   projection to at least one proper strict-support orbit.

4. The perverse degree and the set of support orbits receiving the image are
   canonical.  A decomposition-theorem splitting and a Chow-correspondence
   projector are not asserted to be canonical.

5. Artificial free-orbit refinements do not change this object: the actual
   pullback remains in the old pullback summand and has zero projection to the
   newly created blowup summands.

## What has not been proved

The ambient support has not been shown to survive on the normalized dominant
transform

\[
\Gamma
=
\operatorname{Proj}_X\overline{\mathcal R(J)}.
\]

The actual restricted pullback
\(q_\Gamma^*V\subset H^3(\Gamma)(1)\) is injective, but the decomposition theorem
for \(\Gamma\to X\) has a full-support \(IC_X\) term whose degree-three
cohomology is already \(V\).  Consequently the restricted class can be absorbed
by full support and need not be forced into an exceptional carrier by the
argument used over \(\mathbf P^4\).

The smallest missing implication is:

\[
\boxed{
\begin{minipage}{0.86\textwidth}
A nonzero \(V\)-projection to a proper ambient strict-support block remains
nonzero after derived restriction to \(X\), selection of the dominant
component, and normalization to \(\Gamma\).
\end{minipage}}
\tag{RT}
\]

Equivalently, one must prove a clean/non-characteristic base-change statement
with no \(V\)-isotypic vanishing-cycle kernel.  Neither the joint-residue field
theorem nor the existing fixed-carrier packet proves (RT).

## Strategic consequence

The ambient resolution-dependence gap is closed in the Hodge-module category.
The current route now stops one step later:

```text
ambient strict support
        |
        |  missing clean nonzero restriction (RT)
        v
restricted intrinsic carrier
```

No further type-I/type-II enumeration is justified until (RT), or a substitute
arrangement-localization theorem, is proved.

## Computation

No CAS computation was used.  The packet is theorem-theoretic and depends only
on the accepted repository inputs plus standard decomposition-theorem,
intersection-cohomology, and Hodge-module results.
