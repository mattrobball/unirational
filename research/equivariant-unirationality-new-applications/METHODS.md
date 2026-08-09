# Methods and repository theorem boundary

## 1. Repository inputs treated as authoritative

The following files were read before the literature search:

- `problems/E-klein-cubic/theory/FIX_I_bcomplex.md`
- `problems/E-klein-cubic/theory/FIX_T_gate.md`
- `problems/E-klein-cubic/goal_runs_after_691986b/FIX_T34_CENTRAL_OBSTRUCTION/`
- `problems/E-klein-cubic/theory/FIX_IX_v14.md`
- `problems/F-dp2-psl27/RESOLUTION.md`
- `problems/F-dp2-psl27/certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md`

Later carrier corrections on `main` were also inspected. The binding
boundary is:

1. fixed strata and their normal characters can be followed through
   controlled equivariant blowups;
2. the central/centralizer eigenspace-survivor induction is valid;
3. the surface exceptional-tree/path theorem is valid;
4. one must **not** assert that every arbitrary higher-dimensional fixed
   network remains RCC or that a formal normal-cone component is an actual
   horizontal carrier.

All proofs in this packet stay on the valid side of that boundary.

## 2. The controlled survivor lemma

Let `sigma` act on a smooth variety and let `N=C_G(sigma)`. Suppose an
irreducible `N`-stable, pointwise-`sigma`-fixed RCC subvariety `F` has been
constructed on one model. Under an equivariant blowup with smooth invariant
center `Z`:

- if `F` is not contained in `Z`, take its strict transform;
- if `F` is contained in `Z`, split the normal bundle into
  `sigma`-eigenbundles and take the projectivization of a nonzero
  eigenbundle over `F`.

The new subvariety remains irreducible, `N`-stable, pointwise fixed by
`sigma`, and RCC. Iteration gives a survivor on an equivariant resolution
of any rational map.

This is the proof pattern used in the sealed `V_14` centralizer theorem.
It is stronger and cleaner than choosing a component of a possibly
reducible fixed total transform.

## 3. Search test applied to every candidate

Each action was tested in this order:

1. **ordinary geometry:** rationality or unirationality of the underlying
   variety;
2. **exact action:** equation, intrinsic construction, or matrices;
3. **Condition (A):** every abelian subgroup has a fixed point;
4. **cohomology:** ordinary and higher Amitsur, universal torsor,
   Bogomolov multiplier where relevant;
5. **fixed funnel:** an element and its centralizer, fixed components,
   residual action, and deeper fixed locus;
6. **resolved geometry:** whether the repository's central, centralizer,
   path, or residual-RCC theorem actually applies;
7. **literature boundary:** unirationality versus weak versality versus
   (stable) linearizability were kept separate.

## 4. Why Sylow fixed points make the new examples cohomologically silent

For a smooth projective rational variety `X`, let

\[
\beta_X\in H^2(G,T_{NS(X)})
\]

be the obstruction to a `G`-equivariant universal torsor. A `P`-fixed
point implies that the restriction of `beta_X` to `P` vanishes. If every
Sylow subgroup `P_p` has a fixed point, then restriction-corestriction
implies

\[
[G:P_p]\,\beta_X=0
\]

for every prime `p` dividing `|G|`. The gcd of the Sylow indices is one,
so `beta_X=0`.

The same argument applies to every subgroup `H<=G`: each Sylow subgroup of
`H` is contained in a Sylow subgroup of `G` and therefore fixes a point.
Hence the universal-torsor obstruction vanishes after restriction to every
subgroup.

Scavia--Tschinkel--Zhang prove that for smooth projective varieties with
free finitely generated Picard group, vanishing of this obstruction forces
`Am^n(X,H)=0` in every degree `n>=2` (with `n=2` the usual Amitsur
obstruction). Thus the two new theorem families are not disguised Amitsur
examples.

## 5. Literature search clusters

The search followed the current versions and citation graphs of:

- Duncan and Duncan--Reichstein on versality and del Pezzo surfaces;
- Cheltsov--Tschinkel--Zhang on equivariant unirationality of Fano
  threefolds;
- Tschinkel--Zhang and Scavia--Tschinkel--Zhang on cohomological and higher
  Amitsur obstructions;
- Hassett--Tschinkel and Kresch--Tschinkel on universal torsors;
- Dolgachev--Iskovskikh, Blanc, Trepalin, and related Cremona/conic-bundle
  classifications;
- Abe on rational Fano conic-bundle threefolds;
- Cheltsov and collaborators on Kummer quartic double solids;
- Cheltsov--Tschinkel--Zhang on the Burkhardt quartic.

Searches were run through 2026-08-09, including current arXiv revisions.
