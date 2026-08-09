# Normalized Rees geometry

Let `P=(P_0,...,P_4)` be a primitive ambient landing tuple and
`I_P=(P_0,...,P_4)`. The canonical model is

\[
\mathcal B_P=\operatorname{Proj}\overline{\mathcal R(I_P)}
\to \mathbf P(W_5).
\]

Its exceptional prime divisors are exactly the divisorial data selected by the
normalized blowup; after a further equivariant resolution `Z -> B_P`, the
landing tuple gives a morphism `q:Z->X`.

## Canonical statement available without extra hypotheses

On every normalized-Rees exceptional prime `E`, the ratios of the pullbacks of
the five generators define the tautological rational map to `P(W_5)`. Since
`F(P)=0` identically, the induced map on every component where these ratios are
defined lands in `X`. Equivalently, if `v_E(I_P)=m` and

\[
\bar P_i=\operatorname{in}_{v_E}(P_i)/s^m
\]

are the degree-zero residue classes after choosing a local uniformizer for the
valuation, then

\[
F(\bar P_0,...,\bar P_4)=0
\]

in the residue field whenever the vector is nonzero.

This is the correct valuative consequence of the global landing equation. It
canonically produces maps from Rees divisors to `X`; it does **not** by itself
produce a canonical fixed curve inside each divisor.

## What is not determined

The data `F(P)=0` alone do not give a universal numerical relation between

\[
m_E=v_E(I_P),\qquad c_E=v_E(F),\qquad k_E,
\]

because `c_E` measures the source cubic equation while `m_E` measures the
coordinate ideal. The landing equation is an equation in the *target*
coordinates `P_i`; it constrains their initial ratios, not directly the source
order of `F`.

Thus no theorem of the form `c_E=lambda m_E` follows formally. In particular,
the exact fibre identities

\[
\sum m_Ee_E=da,
\qquad
\delta=3a-\sum c_Ee_E
\]

remain numerically underdetermined until one classifies the actual centers and
initial maps.

## Consequence of the postcomposition theorem

Even a complete Rees analysis of one ambient tuple cannot yield a finite list
for all ambient restrictions: postcomposition by intrinsic selfmaps creates
new landing ideals with unbounded restriction degree. Rees geometry is still
relevant only as a possible obstruction to the **existence of any first**
ambient landing tuple.
