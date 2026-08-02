G4-INDUCED-DEGREE11-POINT-PASS

# Goal G4A status — induction and permutation projectors

**Primary exit:** `G4-INDUCED-DEGREE11-POINT-PASS`  
**Also sealed:** `G4-COSET-PROJECTOR-REDUCTION-PASS`  
**Headline:** OPEN  
**Core:** `g4a_core.py` (shared produce/verify)  
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`

## Decision

1. Cosets from sealed H_A5 generators; s_perm/t_perm authentic.
2. Eleven distinct char-0 conjugates: `p_i=ρ(g_i)·Ψ` with `Ψ=J·Φ_params(y)` from sealed H_A5 formula (`base_psi_class_*.json`).
3. **Phi vanishing by lemmas (not free-R monoid):**
   - **Lemma H:** sealed H_A5 landing `F(J·Φ_params)=0` (modular smoke).
   - **Lemma G:** `F(ρ(g)v)=F(v)` on Klein rep (`exact_weil_check`).
   - **Composition:** `F(p_i)=F(Ψ)=0` in char 0 (`phi_lemmas.json`).
4. Projectors P1,P10 (G **1+10**) and two A5-restriction P5s.
5. Full W-ops + 27 F-polarizations; generic_cubic B on cycle fibers.

Secants out of scope. Marker: `G4A_VERIFY_OK`.
