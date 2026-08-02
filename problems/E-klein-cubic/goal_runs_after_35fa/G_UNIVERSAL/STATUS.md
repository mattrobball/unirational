G2-FINITE-GENERATION-PASS

# Goal G / G2 status — universal object and all-degree theorem

**Consumed commit:** `4378e3dfe2dcf0caeeeb6f73117d785f5aa9f794`  
**Date:** 2026-08-02  
**Headline problem:** **OPEN**

This packet closes the universal-object and all-degree-reduction portion of
Goals G and G2.  It does not claim a rational point or a pointlessness
certificate for the generic Klein twist.

## Exact result

Let

\[
S=\operatorname{Sym}(W^*),\qquad R=S^G,\qquad
M=(S\otimes W)^G,
\]

and let `q(p)=F(p)` be the cubic landing law.  The installed homogeneous
frame

\[
B=(x,C,D,E,K_7),\qquad \deg B=(1,4,5,6,7),
\]

is a basis after passage to `Frac(R)`.  With
`tau=f3^2/f5` of degree one and `K_proj=Frac(R)_0`, put

\[
\Phi(a_0,\ldots,a_4)=
F\!\left(\sum_{i=0}^4a_iB_i/\tau^{\deg B_i}\right).
\]

Then

\[
\boxed{
\exists d\;\exists 0\ne p\in M_d\text{ with }F(p)=0
\quad\Longleftrightarrow\quad
V(\Phi)(K_{\rm proj})\ne\varnothing .}
\]

The forward implication normalizes the unique frame coordinates of `p`.
The reverse implication clears homogeneous invariant denominators without
mixing source degrees.  The proof identifies all homogeneous polynomial
representatives on the same rational scalar-saturation line and proves that
homogeneous precomposition preserves the landing equation.

The symbolic plane-order filtration

\[
\mathcal F^mM=
\left(\left(\bigcap_tP_t^m\right)\otimes W\right)^G
\]

is retained as an exact stratification of this global object.  Plane jets,
`V4` equalizers, residual point kernels, minus-line and marked-elliptic data,
and irrelevant torsion are simultaneous restrictions of one global
coefficient vector; independently chosen local states are not added as
points.  The order `m` is evaluated on each polynomial representative and can
change under invariant multiplication; the projective `K_proj`-point records
the whole rational scalar-saturation class.

Consequently

\[
V(\Phi)(K_{\rm proj})\ne\varnothing
\quad\Longleftrightarrow\quad
\bigcup_{d,m}\mathcal L_{m,d}\ne\varnothing.
\]

## Finite presentation

Over `A=k[f3,f5,f6,f8,f11]`, the certified Hironaka data give

\[
\operatorname{rank}_A R=12,
\qquad
\operatorname{rank}_A M=60.
\]

Thus the global universal landing object is a finite-type noetherian scheme
given by twelve weighted cubic equations in sixty module coordinates over
`A`.  After generic frame localization and degree-zero normalization it is
the single cubic \(V(\Phi)\subset\mathbf P^4_{K_{\rm proj}}\), with all 35
coefficients stored in the existing `generic_cubic.json` packet.

This is the valid all-degree replacement for a degree ladder.  It does **not**
imply a finite upper bound for the first homogeneous representative; the
nonlinear zero locus is not a module, and high-degree cancellations are not
controlled by module-generator degrees.  No finite-generation claim is made
for the complete symbolic multi-Rees algebra, because that claim is neither
needed for nor implied by the theorem above.

## Remaining binary gate

- **Positive:** produce a \(K_{\rm proj}\)-point of \(V(\Phi)\), clear it to a global
  covariant, and verify projective Jacobian rank four (dominance).
- **Negative:** prove \(V(\Phi)(K_{\rm proj})=\varnothing\), then replay the accepted
  source-exhaustiveness bridge.

Until one branch is completed, neither a positive nor a negative headline
exit is authorized.

## Replay

From `problems/E-klein-cubic`:

```text
python3 goal_runs_after_35fa/G_UNIVERSAL/verify.py
```

Successful replay ends with

```text
G2_UNIVERSAL_VERIFIER_ACCEPT
```
