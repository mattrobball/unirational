G4-INDUCED-DEGREE11-POINT-PASS

# Goal G4A status — induction and permutation projectors

**Primary exit:** `G4-INDUCED-DEGREE11-POINT-PASS`
**Also sealed:** `G4-COSET-PROJECTOR-REDUCTION-PASS`
**Headline:** OPEN
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`

## Decision

1. **Cosets.** Both A5 classes from sealed H_A5 generators; `s_perm`/`t_perm` match independent rebuild.
2. **H_A5 formula base-change.** `point.json` parameters used exactly: Phi_params(y) in A5 space
   (`h_a5_base_class_*.json`) and Klein landing Psi=J*Phi_params(y) reconstructed mod 89
   (`klein_witnesses_mod89.json`). Conjugates: rho(g_i)*Psi with F=0 mod 89 for all 11×2.
3. **G3 frame.** Coefficient-frame content = sealed H_A5 parameter vector + exact A5 evaluation;
   Klein W witnesses from the same formula (not a bare e0 orbit).
4. **Phi.** H_A5 char-0 form identity F(J*Phi_params)=0; modular F=0 on all witnesses;
   G3A identity Phi=F(Frame); generic_cubic.json bound by SHA-256.
5. **Projectors.** G-module 1+10 (P1,P10); two five-dimensional A5-restriction P5s.
6. **Operations.** W-valued (M·cycle)_j=sum_i M_ji W_i on H_A5-derived W-cycle; coset M2/M3.

## Equivariance boundary

H_A5 map equivariance Psi(h·y)=rho(h)Psi(y) is sealed and makes the twist point well-defined.
Ordered constant-field tuples p_i=rho(g_i)Psi(y0) are **not** G-equivariant as maps G/H→X
(no H-line in the Klein 5). The induced L_H-point uses formula base-change / semi-linear
Gal action of the torsor, not an H-fixed vector in W. Coset labeling of the degree-11
module Ind is exact.

## Replay

See REPLAY.md. Markers: G4A_VERIFY_OK, G4A_PHI_SUBSTITUTION_OK.
