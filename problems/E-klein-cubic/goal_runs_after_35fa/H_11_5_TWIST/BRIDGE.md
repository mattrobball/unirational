# Exact subgroup and canonical-twist bridge

Let `G=PSL_2(F_11)`, let `H=11:5=N_G(C11)`, and let `X` be the Klein cubic.
Restriction of any dominant `G`-equivariant rational map from a linear
representation gives a dominant `H`-equivariant map.  The accepted
very-versal/twist equivalence therefore gives

\[
 X\text{ is }G\text{-unirational}
 \Longrightarrow
 {}^T X(K')\ne\varnothing
\]

for every `H`-torsor `T/K'`.  In particular, pointlessness of the genuine
generic `H`-twist would trigger `BR-SUBGROUP-NEG` and disprove
`G`-unirationality.

Here the torsor is exactly

\[
 \operatorname{Spec}L\longrightarrow\operatorname{Spec}K,
 \qquad L=\mathbf C(\mathbf P(W)),\quad K=L^H.
\]

The canonical frame `A(y)` and equation `F(A(y)u)=0` are those hash-bound in
`SOURCE_BINDING.md`.  `TWIST_MODEL.md` proves that the trace equation in this
packet is related to that equation by a matrix in `GL5(K)`, with an explicit
inverse on the same open.  Thus any future point or obstruction for the
trace equation applies to the genuine twist, not merely to an auxiliary
model.

No bridge fires in this packet:

- no pointlessness theorem is proved, so there is no negative headline;
- no `K`-point is proved;
- even a future point on this one generic `H`-twist would close this subgroup
  obstruction only.  Without dominance or an all-torsors theorem it would
  not prove `G`-unirationality.
