# Literature audit

## Gross--Popescu

Primary source: M. Gross and S. Popescu, *The moduli space of
(1,11)-polarized abelian surfaces is unirational*, Compositio Math. 126
(2001), arXiv:math/9902017.

Facts already present there:

- a canonical level structure is an isomorphism of the theta group with the
  standard Heisenberg group, identity on the center, hence induces a
  symplectic marking of the polarization kernel;
- the normalizer sequence
  `1 -> H_11 -> N(H_11) -> SL2(F11) -> 1` splits;
- the Schrödinger module decomposes as `V=V_+ + V_-`, with dimensions six and
  five; the center acts nontrivially on `V_+` and trivially on `V_-`;
- `Phi: Lambda^2(V_+) -> Sym^2(V_-)` is an `SL2(F11)`-intertwiner;
- `Theta_11` sends a general level-polarized surface to the two-dimensional
  multiplicity space of the Heisenberg representation in its ideal of
  quadrics and is birational onto its image;
- the image is the smooth linear section `V14` cut by five displayed
  Pluecker relations, and `Lambda^2(V_+)` decomposes as `5+10`;
- the Pfaffian partner is the standard Klein cubic;
- the final Fano--Iskovskikh birational map depends on a generic hyperplane,
  and Remark 2.8 explicitly says that map is not `PSL2(F11)`-compatible.

Gross--Popescu do **not** state the stack/coarse kernel theorem in the form
needed here, do not prove functorial equivariance of `Theta_11` as a moduli
map, and do not compare their concrete `V14` to the repository's exact Weil
model.

## Modern equivariant geometry

Y. Tschinkel and Z. Zhang, *Stable equivariant birationalities of cubic and
degree 14 Fano threefolds*, arXiv:2409.08392, place the Pfaffian cubic and
Grassmannian `V14` in one equivariant vector-bundle construction.  They prove
that the two actions are not ordinarily `G`-birational but become twisted
stably birational after adjoining a projective factor from the six-dimensional
representation of the double cover.  Their fixed-stratum computation records
on the `V14` side a smooth degree-six genus-one involution-fixed curve.

I. Cheltsov, Y. Tschinkel, and Z. Zhang, *Equivariant unirationality of Fano
threefolds*, arXiv:2502.19598 (current version), list the standard
`PSL2(F11)` action on the Klein cubic among the remaining open cases.  This is
consistent with the scope boundary of the present packet.

The current rigidity literature, together with the earlier superrigidity
result cited there, places the standard Klein action in the
`G`-birationally superrigid class.  This is what excludes an equivariant
birational identification with the modular/`V14` action; comparing raw fixed
schemes alone would not be birationally valid.

## New deductions in this packet

The deductions not simply quoted from those papers are:

1. the exact `SL2` stack action, the ineffective central kernel, the effective
   coarse `PSL2` action, generic freeness, and the quotient function field;
2. a functorial proof that `Theta_11` intertwines the natural marking-change
   action with `rho_+`;
3. an exact basis conjugacy showing that Gross--Popescu's five equations cut
   the repository's sealed `10'` summand;
4. the theorem `A_11^lev ~_G V14` for the natural action;
5. transfer of the sealed all-degree centralizer obstruction to the natural
   modular action;
6. a precise transformation law for the hyperplane-dependent birational map
   and a proof that the universal construction is stable/projective rather
   than an equivariant birational bridge to the standard Klein action.

## Repository precedence

This audit is read subject to `REPAIR.md`, `RESOLUTION.md`, and the correction
layers in `NOTEBOOK.md`.  It uses the exact characteristic-zero sealing packet
`goal_runs_after_c53d89a/FIX_IX_SEAL/`; it does not revive superseded finite
field or low-degree claims.
