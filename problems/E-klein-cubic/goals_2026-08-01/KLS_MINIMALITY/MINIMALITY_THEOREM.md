# Minimality theorem audit and non-theorem certificate

## Verdict

There is no proved representation-specific minimality-to-discrepancy or
minimality-to-conductor-support theorem strong enough to make the
configuration space finite.  This file records the maximal theorem that is
actually justified and the exact obstructions to strengthening it using the
goal packet's proposed ingredients.

## Maximal justified minimality theorem

Let `q:W -> W` be a primitive homogeneous `G`-self-covariant of minimal
degree `d` among self-covariants of generic rank four.  Let its invariant
hypersurface image be `H=V(F)`, and use `(r,t,s,e,m)` as in
`INTERFACE_AUDIT.md`.  Then:

1. `h` is invariant and `f3` does not divide `h`;
2. a stable component of `V(h)` has invariant degree at least five, while a
   non-stable component orbit has at least eleven members;
3. the dual Gauss covariant `p:W -> W*` is primitive of rank four and degree
   `m=4d-4-r-t`;
4. composition with the quadratic dual Klein polar is a primitive
   self-covariant of degree `2m`; hence
   `d <= 2m` and `r+t <= floor((7d-8)/2)`; and
5. each component of `V(h)` is a Darboux-invariant divisor for the primitive
   kernel foliation.

This theorem contains no discrepancy term and no upper bound for the number,
degree, or multiplicity of conductor-dominating source primes.

## Why quartic precomposition cannot supply minimality

Let `C` be the finite primitive quartic endomorphism.  If `q` is primitive,
then `q o C` is primitive of saturated degree `4d`; if `q` is KLS, the chain
rule shows `q o C` is KLS.  Thus conditional on one solution there are
solutions of degrees

\[
 d,4d,4^2d,\ldots.
\]

Every term after the first is larger than `d`.  Minimality prohibits a
solution of degree strictly less than `d`; it says nothing against this
sequence.  Hence the goal's requested use of precomposition “to contradict
minimality” has the wrong degree direction unless a separate, unproved
descent operation extracts a smaller KLS coefficient from the mixed
quartic-adic expansion.

## Exact generic countermodels

These countermodels do not refute a theorem that uses the full Klein
representation and minimality.  They do prove that the generic geometric
hypotheses named in K1 cannot establish that theorem.

### Normal image and lc foliation with bad discrepancy

For `e >= 3`, in variables `(z1,z2,z3,z4,u)` put

\[
 Q=\sum z_i^{e-1},\quad B=\sum z_i^e,
\quad \Phi_e=(-B,z_1Q,z_2Q,z_3Q,z_4Q).
\]

Its primitive coordinates have degree `e`, generic rank four, and normal
hypersurface image

\[
 F_e=y_0\sum y_i^{e-1}+\sum y_i^e=0.
\]

The kernel foliation is lc, but for the exceptional divisor over the unique
image singular point,

\[
 A_E=5-e,\qquad h=Q^{e-2},\qquad a=e-2,\qquad \beta=2.
\]

At `e=5`, both the target pair and foliation are lc while `A_E=0`, so one
reduced copy survives.  For `e >= 6`, the negative discrepancy and
multiplicity defect are unbounded.

### Fixed plt conductor pair with unbounded pullback support

The fixed nodal hypersurface

\[
 H_0=\{v^2=u^2(u+1)\}\times\mathbb A^3
\]

has smooth normalization with a plt pair of two disjoint conductor divisors.
For every `N`, the substitution

\[
 t=1+\prod_{i=1}^N(x-\lambda_i s)
\]

gives a rank-four polynomial map for which `N` distinct source divisors
dominate the same conductor branch.  Thus plt of the fixed target pair does
not bound reduced conductor pullback support.

### Current Klein ledger is consistent with an open case

The exact formal values

```text
e=7, d=11, r=4, t=8, s=38, m=28
```

with the eleven squarefree `P22` quadrics and one stable degree-eight factor
of multiplicity two satisfy every currently proved numerical restriction:

\[
 38=4+8+11(7-5)+4,\qquad 11\le2\cdot28,
\qquad 4\bmod11\in\{1,3,4,5,9\}.
\]

This is a consistency witness, not an existence claim.  It proves that the
installed degree identities, character slots, and minimality inequality do
not eliminate the first open repeated-factor pattern.

## Precise missing theorem

A viable K1 theorem must use special information not present in the generic
models.  One sufficient form is:

> For a minimal `PSL_2(F_11)` KLS self-covariant, every gcd valuation whose
> center on `(H^nu,C)` has codimension at least two has positive log
> discrepancy, and the weighted reduced source support dominating conductor
> primes is bounded by an explicit constant.

Cartier integrality would turn positive discrepancy into `A_E >= 1`, making
repeated exceptional factors cancel.  A conductor-support bound would then
turn the discrepancy ledger into a degree bound.  Neither assertion follows
from normality, lc, plt, foliation integrability, quartic precomposition, or
the current dual-Gauss minimality inequality.

An alternative sufficient theorem is that the image of one minimal KLS
solution is canonical, or directly that a minimal solution contracts no
divisor.  Both remain open.

## Consequence

Because K1 is absent, K2 cannot honestly output a finite exhaustive list and
K3 cannot perform an exhaustive elimination.  The only valid goal exit is
`KLS-NO-THEOREM`; `KLS-FINITE-CLASSIFICATION-UNDECIDED` would overstate the
result because no finite classification has been proved.
