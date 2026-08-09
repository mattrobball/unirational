# Rees valuations of a landing ideal

Let `v=v_E` be a Rees valuation of `I_P` and put `m=v(I_P)`. Choose a valuation
uniformizer `s` after passing to the valuation ring and write

\[
P_i=s^m\widetilde P_i
\]

with at least one `widetilde P_i` a unit. Homogeneity gives

\[
0=F(P)=s^{3m}F(\widetilde P).
\]

Reduction to the residue field yields

\[
F(\overline{\widetilde P})=0.
\]

Thus each Rees divisor carries a canonical rational map to `X` wherever the
residue vector is nonzero. This is the exact associated-graded form of the
landing identity.

What it does not give is a relation between `m=v(I_P)` and `c=v(F_source)`.
These belong to different equations: `m` is the order of the five target
coordinate forms, whereas `c` is the order of the source cubic along the same
valuation. The equality `F(P)=0` has no source-side factor from which a fixed
linear relation `c=lambda m` can be read.

Therefore the desired universal inequality tying `(m,c,k)` more strongly than
plt/Noether-Fano is not obtained formally. Any such inequality must use the
center, character structure, or geometry of the residue map.
