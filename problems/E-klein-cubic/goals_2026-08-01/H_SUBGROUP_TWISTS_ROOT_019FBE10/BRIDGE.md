# Exact subgroup-twist bridge

Let (G=\operatorname{PSL}_2(\mathbf F_{11})), let (W) be the exact
five-dimensional Klein representation, and let

\[
X=\{F=0\}\subset\mathbf P(W),\qquad
F=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}.
\]

## `BR-SUBGROUP-NEG`

For every subgroup (H\leq G),

\[
X\text{ is }G\text{-unirational}
\Longrightarrow X\text{ is }H\text{-unirational}
\Longrightarrow {}^{T}X(K)\ne\varnothing
\]

for every field (K/\mathbf C) and every (H)-torsor (T/K).

The first implication is restriction of a dominant equivariant rational map
from a linear (G)-representation.  The second is the standard
very-versal/weakly-versal/twist equivalence (Duncan--Reichstein, Theorems
1.1, 10.3, and 10.5, in the convention already fixed by `../SPEC.md`).
Consequently, one genuine (H)-torsor whose twist is pointless disproves
(G)-unirationality.  A special fibre or auxiliary model is not enough.

## Generic projective torsors

For (H=A_5) or (A_4), let (V) be the faithful irreducible
three-dimensional icosahedral/tetrahedral representation.  Its projective
kernel is normal; faithfulness and the trivial centre give trivial kernel.
Since (H) is finite, the action on a dense open of (\mathbf P(V)) is
free.  Thus

\[
L=\mathbf C(\mathbf P(V)),\qquad K_H=L^H
\]

defines the required generic (H)-torsor `Spec L -> Spec K_H`.  For
(H=11{:}5), the irreducible faithful restriction (W|_H) has trivial
projective kernel, and the same construction uses (V=W|_H), hence
(K_H=\mathbf C(\mathbf P^4)^H).

## Exact Hilbert--90 frame and equation

Fix coordinates (y_0,\ldots,y_r) on (V), put

\[
\ell(y)=y_0+2y_1+\cdots +(r+1)y_r,qquad
c(y)=\frac{y_0}{\ell(y)}\in\mathbf C(\mathbf P(V)),
\]

and write (\sigma:H\to\operatorname{GL}(V)) and
(\rho:H\to\operatorname{GL}(W)).  Define

\[
A_H(y)=\sum_{h\in H}c(\sigma(h^{-1})y)\rho(h).
\]

Unlike the non-projective seed (1/\ell), the displayed (c) has degree
zero and really belongs to (L).  Reindexing (h=gk) gives

\[
A_H(\sigma(g)y)=\rho(g)A_H(y).
\]

The nonzero determinants in `twists.json`, independently rediscovered by
`verify.py`, prove that every displayed (A_H) is generically invertible in
characteristic zero.  Its columns are therefore a (K_H)-basis of the
descent of (W).  The genuine twisted Klein cubic is exactly

\[
F_H^T(z)=F(A_H(y)z)
=\sum_{i\in\mathbf Z/5}(A_H(y)z)_i^2(A_H(y)z)_{i+1}=0.
\]

The transformation law and (F(\rho(g)x)=F(x)) show that every coefficient
lies in (K_H).  `twists.json` records all concrete subgroup elements,
source identifications, frames, and a full 35-coefficient good-reduction
specialization for each twist.  This is the original twisted Klein equation,
not an auxiliary birational model.

## Characteristic-zero transfer

All matrices are defined over the number field
(\mathbf Q(\zeta_{11},\sqrt5)\).  At the good prime

\[
(p,\zeta_{11},\sqrt5)=(89,2,19)
\]

the group order is invertible, (2) has order eleven, and (19^2=5).
A nonzero specialized denominator product and frame determinant imply that
the corresponding rational determinant is nonzero in characteristic zero.
The bounded direct search instead uses \(p=331\), which splits
\(\zeta_{11}\), \(\sqrt5\), and all three \(A_4\)-characters.  Since
\(331\nmid |A_4|\), the Reynolds summands give the full characteristic-zero
covariant spaces after reduction.  The coefficient parameter spaces are
projective; unit ideals on every good-fibre affine chart imply empty special
fibre, and properness then implies empty characteristic-zero generic fibre.
No modular point count is used as an emptiness theorem.
