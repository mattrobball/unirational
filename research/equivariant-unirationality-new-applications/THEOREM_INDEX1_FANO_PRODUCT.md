# Theorem: a rational index-one Fano threefold not weakly `G`-versal

## Statement

Let

\[
S_F=\{w^2=x^4+y^4+z^4\}\subset\mathbf P(1,1,1,2)
\]

and let

\[
G=C2_{\rm Geiser}\times S3
\]

act as in `THEOREM_FERMAT_DP2_S3.md`.  Set

\[
Y=S_F\times\mathbf P^1
\]

and let `G` act trivially on the second factor.

Then `Y` is a smooth rational Fano threefold of index one, satisfies Condition (A), has fixed points for every Sylow subgroup, but is not weakly `G`-versal and hence is not `G`-unirational.

## Proof

Both factors are smooth Fano varieties, so `Y` is smooth and Fano.  It is rational because `S_F` is rational.  Its anticanonical class is

\[
-K_Y=p_1^*(-K_{S_F})+2p_2^*O(1).
\]

The class `-K_{S_F}` is primitive in `Pic(S_F)`, so the displayed class is not divisible by an integer greater than one.  Thus `Y` has index one.

Let `tau` be the central Geiser involution.  Then

\[
Y^\tau=B_F\times\mathbf P^1,
\]

where `B_F` is the genus-three Fermat quartic.  The projection

\[
B_F\times\mathbf P^1\longrightarrow B_F
\]

is `S3`-equivariant, every RCC subvariety lies in a fiber, and `B_F^{S3}=empty`.  Hence the ruled-fixed-surface corollary applies.  Also

\[
Y^G=B_F^{S3}\times\mathbf P^1=empty.
\]

Therefore `Y` is not weakly `G`-versal.

Alternatively, a dominant equivariant rational map from a linear source to `Y` would compose with `Y -> S_F` to give a dominant equivariant rational map to `S_F`, contradicting `THEOREM_FERMAT_DP2_S3.md`.

Condition (A) and the Sylow fixed-point audit pass by taking the fixed points on `S_F` from that theorem and any point of `P1`.  QED.

## Limitation

This is a literal new index-one Fano pair, but not an independent prime-Fano application.  The obstruction is inherited from a surface factor.  It should not be advertised as a second `V_14`-type centralizer theorem.
