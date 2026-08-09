# Independent audit of the Fine-interior upgrade

**Date:** 2026-08-08  
**Verdict:** sound, with one terminology correction: the 500 residue
constraints form a complete finite test, but they are not asserted to be all
primitive normals.  The five facet normals `11 e_i` are primitive.

This audit concerns either cyclic exceptional plane

\[
 B=A_+=\langle\mu,(0,1,8,5,8)\rangle
 \quad\hbox{or}\quad
 B=A_-=\langle\mu,(0,1,9,6,6)\rangle,
 \qquad \mu=(1,5,3,4,9),
\]

inside `V*={lambda in F_11^5: sum lambda_i=0}`.

## 1. Lattices and the complete finite Fine test

Put

\[
 \Lambda=\{m\in\mathbf Z^5:\sum m_i=0\},\qquad
 \Lambda_B=\Lambda+\sum_{\lambda\in B}
                     \mathbf Z\,{\widetilde\lambda\over11},
\]

where the tildes are integral sum-zero lifts.  This is the character lattice
of the Kummer cover.  Its dual lattice is

\[
 N_B=\{[g]\in\mathbf Z^5/\mathbf Z\mathbf1:
          g\cdot\lambda=0\pmod {11}\ \hbox{for all }\lambda\in B\}. \tag{1.1}
\]

Let `Delta` be the simplex with vertices `0,e_i-e_0` and write a point in
barycentric coordinates `alpha_i`, with `sum alpha_i=1`.  Normalize the unique
representative of `[g]` by `min g_i=0`.  Then

\[
 \langle\alpha,g\rangle-\min_\Delta(g)
       =\sum_i\alpha_i g_i,
\]

so the Fine inequality is `sum alpha_i g_i >= 1`.

Every normalized `g` has a unique decomposition

\[
 g=q+11k,\qquad 0\le q_i\le10,\quad \min q_i=0,\quad k_i\ge0, \tag{1.2}
\]

and `q mod 11` is orthogonal to `B`.  If `q` is nonzero, its own inequality
implies that of `g`.  If `q=0`, the five inequalities

\[
 11\alpha_i\ge1 \qquad(0\le i\le4)                         \tag{1.3}
\]

imply the inequality for every nonzero `11k`.  Conversely, every vector in
the finite residue list and every `11e_i` belongs to `N_B`.  Thus (1.2)--(1.3)
give an if-and-only-if test for the Fine interior, not a truncation.

Each `11e_i` is primitive in `N_B`: any nontrivial divisibility in
`Z^5/Z1` would force divisibility by 11 and hence would require `e_i in N_B`,
which is impossible because every coordinate `mu_i` is nonzero modulo 11.
The other 500 tested vectors need not all be primitive; including
nonprimitive vectors is harmless because the definition quantifies over all
nonzero dual-lattice vectors.

The exact finite replay finds 500 nonzero normalized residue vectors for
each plane and verifies the proposed witnesses

\[
 \alpha_+=(4,1,4,1,1)/11,
 \qquad
 \alpha_-=(28,97,16,19,16)/176.                              \tag{1.4}
\]

The minimum left sides, after clearing denominators, are respectively 11
and 176.  In fact there is a stronger symmetric certificate: the minimum of
`sum q_i` over either residue list is 8.  Hence the barycenter
`alpha=(1/5,...,1/5)` satisfies every defining inequality strictly:
`11/5>1` for (1.3) and `sum q_i/5 >= 8/5>1`.  Therefore

\[
 \dim F(\Delta)=4                                             \tag{1.5}
\]

for both exceptional planes.

## 2. Connectedness and nondegeneracy

Let `Hbar={sum y_i=0} subset P^4`, so `Hbar` is `P^3`, and let
`D_i=Hbar intersect {y_i=0}`.  The `D_i` are five distinct prime divisors.
For any integral sum-zero lift `lambda`,

\[
 \operatorname{div}_{Hbar}\!\left(\prod_i y_i^{\lambda_i}\right)
       =\sum_i\lambda_iD_i.                                  \tag{2.1}
\]

If this rational function were an eleventh power, all `lambda_i` would be
divisible by 11.  Thus the two independent residues spanning `B` give two
independent classes in `C(Hbar)^*/C(Hbar)^{*11}`.  Kummer theory therefore
gives degree `11^2` for the restricted cover.  Its inverse image `Y_B` is
connected and integral (indeed smooth, since the torus cover is etale).

The equation on the cover is still the pullback of
`y_0+...+y_4`.  Every face polynomial is a sum of a subset of five affinely
independent monomials with nonzero coefficients.  The equations consisting
of that face polynomial and all its logarithmic derivatives would give a
linear dependence among the corresponding augmented exponent vectors.
There is none.  Hence the Laurent polynomial is nondegenerate with respect
to every face of its full-dimensional Newton simplex.

## 3. Batyrev's theorem and rational domination

Batyrev's Definition 3.3 uses exactly all nonzero vectors of the dual
lattice in the Fine inequalities above.  The hypotheses of Theorem 9.2 in
*Canonical models of toric hypersurfaces*, Algebraic Geometry 10 (2023),
394--431, DOI `10.14231/AG-2023-013`, now hold: `Y_B` is an integral
nondegenerate hypersurface in a four-dimensional torus, its Newton polytope
is full-dimensional, and (1.5) says its Fine interior has dimension four.
The theorem gives

\[
 \kappa(Y_B)=\min\{4,3\}=3.                                  \tag{3.1}
\]

Thus no rational fourfold can dominate `Y_B`.  Indeed, after compactifying,
choose a general `P^3` in a rational `P^4` source transverse to the
one-dimensional generic differential kernel.  Its restriction is
generically finite and dominant.  After resolving source and target, a
nonzero pluricanonical form on the general-type target pulls back to a
nonzero pluricanonical form on a smooth projective rational threefold, a
contradiction.

Consequently both cyclic rank-two Kummer planes are excluded.  This audit
does not address the remaining incidence-rank-three branch and therefore
does not prove `F55-NO`.

```text
RANK4-FINE-INTERIOR-UPGRADE-AUDITED
RANK4-RANK2-KUMMER-PLANES-EXCLUDED
RANK4-INCIDENCE-RANK-THREE-ONLY
F55-GLOBAL-QUESTION-OPEN
```

