# Finite all-degree decision object

## 1. Executable object

The universal all-degree existence question is the rational-point problem

\[
X_{\rm gen}=V(\Phi)\subset\mathbf P^4_{K_{\rm proj}},
\]

where

\[
\Phi(a)=F\!\left(
 a_0x/\tau+a_1C/\tau^4+a_2D/\tau^5+
 a_3E/\tau^6+a_4K_7/\tau^7
\right),
\qquad \tau=f_3^2/f_5.
\]

The field `K_proj` is the degree-zero invariant fraction field and is a
degree-12 extension of `k(t3,t6,t8,t11)` in the certified secondary
basis.  The 35 coefficients of `Phi` are recorded exactly in

```text
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
```

with frame degrees `[1,4,5,6,7]`, primary degrees `[3,5,6,8,11]`, and
secondary degrees

```text
[0,7,9,10,12,14,14,16,18,19,21,28].
```

The verifier in this packet checks the complete symmetric triple ledger,
every coefficient weight, the `f5/tau^5=t3^2` normalization, both directions
of homogeneous denominator clearing, and the upstream exact coefficient
reconstruction.

## 2. Positive branch

A point

\[
[a_0:\cdots:a_4]\in X_{\rm gen}(K_{\rm proj})
\]

clears to one nonzero homogeneous global `G`-equivariant polynomial map
`p:W->W` satisfying the original identity `F(p)=0`.  Different clearings lie
on the same rational scalar-saturation line; primitivity must be checked as an
actual divisibility/incidence condition, not by quotienting by `R_+M`.  To promote this to
`G2-COVARIANT-HEADLINE-POSITIVE`, the cleared vector must then be checked in
the original coordinates and group generators, and the induced projective
map must have Jacobian rank four at some point.  The all-degree theorem proves
existence of a landing covariant, not dominance automatically.

## 3. Negative branch

A proof that

\[
X_{\rm gen}(K_{\rm proj})=\varnothing
\]

is exactly a proof that no nonzero homogeneous landing self-covariant exists
in any degree.  To promote this to
`G2-ALL-DEGREE-EMPTY-HEADLINE-NEGATIVE`, the accepted source-exhaustiveness
theorem must be replayed to exclude every rational equivariant source map,
including scalar multiplication and composition representatives.

## 4. Current verdict

Neither a point nor a pointlessness certificate is supplied by the present
packet.  Finite-degree exclusions, local formal states, modular ranks, and
specialized empty fibres do not decide the displayed `K_proj`-rational-point
alternative.  The completed result is the universal object and exact
all-degree theorem; the headline remains open at one finite arithmetic gate.
