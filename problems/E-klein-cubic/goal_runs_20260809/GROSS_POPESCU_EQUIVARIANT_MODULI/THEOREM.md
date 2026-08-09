# Gross--Popescu modular-equivariance theorem

Let `G=PSL2(F11)`, let `M=A_11^lev` be the coarse moduli variety of
`(1,11)`-polarized abelian surfaces with canonical level structure, and let
`X` be the degree-14 Fano threefold in the repository's even-Weil model.

## Theorem

1. The marking-change action is naturally an `SL2(F11)` action on the moduli
   stack.  Its ineffective kernel is exactly `{+I,-I}`.  The effective action
   on the rigidified stack and coarse variety is `G`.
2. The coarse `G`-action is faithful and generically free, and

   ```text
   C(M)^G = C(A_11).
   ```

   The generic coarse forgetful degree is `|SL2(F11)|/2=660`.
3. Gross--Popescu's rational map

   ```text
   Theta_11 : M -->> Gr(2,V_+)
   ```

   is equivariant for the natural action and the projective even-Weil action.
4. Under the exact diagonal basis change
   `diag(1,2,2,2,2,2)`, Gross--Popescu's five Pluecker equations cut the same
   ten-dimensional summand of `Lambda^2(V_+)` as the repository model.
   Consequently

   ```text
   M ~_G X.
   ```
5. The natural modular action is not `G`-unirational and is not weakly
   versal.
6. Gross--Popescu's birational map `X -->> K` to the Klein cubic is not
   equivariant.  Its transformation law is

   ```text
   g chi_Pi = chi_{gPi} g,
   ```

   and no invariant hyperplane `Pi` exists.  The universal construction gives
   the known twisted stable birationality, not a `G`-birational map.
7. The natural modular/`X` action is not `G`-birationally conjugate to the
   standard regular Klein action, even after an automorphism of `G`.
8. No conclusion on `G`-unirationality of the standard Klein action follows
   from the abstract Gross--Popescu birational equivalence.  That headline
   remains open.

## Proof dependency graph

- (1)--(2): intrinsic marking stack and generic automorphism calculation;
- (3): normalizer-equivariant transport of `H^0(I_A(2))` and its
  multiplicity plane;
- (4): Gross--Popescu Theorems 2.2/2.6, the exact verifier in this packet, and
  `FIX_IX_SEAL`'s multiplicity-free `5+10'` decomposition;
- (5): (4) plus the sealed `V14` involution/centralizer theorem;
- (6): Palatini incidence transformation law and irreducibility of `V_+`;
- (7): equivariant birational superrigidity/nonbirationality;
- (8): the correspondence-versus-map and b-complex scope checks.
