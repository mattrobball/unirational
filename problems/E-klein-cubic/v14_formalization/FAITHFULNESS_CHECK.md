# Faithfulness check: Lean statements vs writeup

Source: `../writeups/v14_not_weakly_versal.tex` §2–3 (Thm 3.1) and §6 (Cor 6.1).

## Axiom / sorry census

**Zero** project `axiom` / `sorry` / `admit` / `sorryAx` on the shipped path
and on all green geometric lemmas in `GeometricV14Carrier`.
`#print axioms` → only `propext`, `Classical.choice`, `Quot.sound`.

## Theorem 3.1 — complete (classical)

## Cor 6.1 group inputs — complete (classical)

## Geometric status vs skeptic gaps

| Gap | Status |
|---|---|
| Y is writeup V₁₄ = Gr∩ℙ(M), not coset | **OPEN**: Application still uses coset `GeometricCarrier`; M-cut `V14MPoint`/`actV14M`/`embedV14M` scaffolded; needs residual ∉ M + `SmoothProjectiveGVariety` + rewire. **Uniqueness sealed**: any R-stable 2-plane = `residualKer`. **F₂₃ pure-M/mixed cert GREEN** (`ResidualNotInM.pureMWitness_ne_zero` / `minor01_ne_zero` / `residual_mixed_F23`; lake build OK, axioms propext+Quot.sound+native_decide only). **K-lift open**: pure-M_K ⇒ tDiff=0 ⇒ reduce(tDiff)=pureMWitness=0 along ℤ[ζ₁₁,1/11]→F₂₃ (ζ↦2), contradicted by cert; needs evalEven conjugation + ring hom model match |
| hyp (a) writeup shape (genus-1 + 2 pts) | **Partial**: operational linear-RCC hyp A **proved** on pure Gr; writeup shape not constructed |
| Gr2/M10/SigmaFixedLocusShape unused | Still scaffolding; M-cut uses `chi10'`/`projectorM`/`Msub`/`IsV14MPoint` instead |
| Dirac embedding | Pure-Gr `V14Variety` is infinite Grassmannian points, not Dirac; Application still coset Dirac |
| FAITHFULNESS admits non-Fano Y | Honest: Cor 6.1 Application Y is still coset, not writeup V₁₄ |
| **`finrank Msub = 10`** | **GREEN** (`Ord11CharacterSum.finrank_Msub_eq_ten`): ∑χ χ_Λ²=660 sealed |

## Green geometric lemmas (classical)

| Lemma | Notes |
|---|---|
| **`Jlin_trace`** | tr(J)=0 via L=k[J] module + power-basis smulTower (block-diag of 2×2 rotations) |
| **`algebra_trace_iRoot`** | Algebra.trace of root of X²+1 is 0 |
| **`LtoEnd_root` / `finrank_Ladj_U`** | L→End sending i↦J; finrank_L U=3 |
| **`trace_exterior_newton`** | tr(Λ² f)=((tr f)²−tr(f²))/2 (matrix exterior identity) |
| **`chiLambda2_sigma`** | χ_Λ²(σ)=3 via Newton + tr(J)=0 + tr(J²)=-6 |
| **`chiLambda2_eq_three_of_order_two`** | every involution has χ_Λ²=3 (conj + sigma) |
| **`sum_chi_chiLambda2_order_two`** | order-2 class contrib 55·2·3=330 |
| **`sum_chi_chiLambda2_order_one`** | id contrib 10·15=150 |
| **`sum_chi_chiLambda2_order_five`** | order-5 contrib 0 (χ=0) |
| **`sum_chi_chiLambda2_orders_one_two`** | id+ord2 = 480 |
| **`sum_chi_chiLambda2_order_six`** | order-6 class contrib 0 (χ_Λ²=0 via \|C\|=6, class 110) |
| **`sum_chi_chiLambda2_order_three`** | order-3 class contrib 0 (χ_Λ²=0 via \|C(r²)\|=6, Sylow n₃=55) |
| **`card_centralizer_rotGen` / `_pow_two`** | \|C_G(rotGen)\|=6, \|C_G(rotGen²)\|=6 |
| **`isConj_rotGen_of_order_six` / `_pow_two_of_order_three`** | single conjugacy class per order 6 and 3 |
| **`chiLambda2_eq_zero_of_order_six` / `_three`** | χ_Λ²=0 on all ord-6 and ord-3 |
| sealed ledger | id+ord2+ord5+ord3+ord6 = 480; remaining ord11 need 180 |
| **ord11 full sum (green)** | `V14Formalization/Ord11CharacterSum.lean`: Newton + Sylow conjugacy + partition; `sum_chi_chiLambda2_order_eleven = 180`; **`sum_chi_chiLambda2_eq_sixsixty = 660`**; **`finrank_Msub_eq_ten`**. No `sorryAx` (classical + native_decide only). |
| sealed ledger total | id 150 + ord2 330 + ord5 0 + ord3 0 + ord6 0 + ord11 180 = **660** ⇒ rank M = 10 |
| **`aeval_Rlin_X6_add_one` / `isCoprime_X2p1_X4`** | R⁶+id=0; X²+1 coprime to X⁴−X²+1 (Bezout /3) |
| **`isCompl_residualKer_Wker`** | U = residualKer ⊕ Wker primary decomp |
| **`not_dvd_X2p1_X4` / `no_root_X4` / `not_exists_monic_quad_dvd_X4`** | X⁴−X²+1 has no root/X²+1 factor; monic quads of X⁶+1 are X²+1 only |
| **`irreducible_X4_sub_X2_add_one`** | X⁴−X²+1 irreducible over k |
| **`Rlin_mem_Wker` / `Wker_ne_bot`** | R preserves Wker; Wker ≠ ⊥ |
| **`residualKer_ne_bot`** | residualKer ≠ ⊥ (else U is k[X]/(X⁴−X²+1)-mod ⇒ 4∣6) |
| **`chiLambda2_eq_of_order_two`** | χ_Λ² constant on involutions (= value at σ) |
| **`finrank_Msub_eq_ten_of_sum_chi_chiLambda2`** | sum=660 ⇒ rank M=10 (gate: 480 from 1+2+5; ord3/6 sealed at 0; need ord11 = 180) |
| `V14_hypothesisA` | pure Gr, polar→meet→odd J→√−1 |
| `Rlin`, `Rlin³=J`, `Rlin⁶=-id`, injective | rotation engine |
| `chi10'_conj` | class function by order |
| **`projectorM_equivariant`** | G-intertwining of isotypic sum |
| `Msub_smul_mem`, `IsV14MPoint_actPM` | M-cut points G-stable |
| `actionKernelM_normal` | kernel of M-cut set action |
| `residualKer`, `residualKer_R_stable` | ker(R²+id) |
| **`not_isSquare_three`** | √3 ∉ K=ℚ(ζ₁₁); unique quad subfield ℚ(√−11) |
| **`no_sixth_root_neg_one`** | no z with z⁶=-1 (order 4 or 12 out) |
| `Rrestrict`, `Rrestrict_pow_six_add_id` | R\|L has (R\|L)⁶+id=0 |
| **`monic_quad_dvd_X6_eq_X2_add_one`** | monic deg-2 \| X⁶+1 over K is exactly X²+1 |
| **`R_stable_plane_residual`** | R-stable 2-plane ⇒ R²=-id (conjEnd Fin-2 minpoly) |
| **`R_stable_plane_mem_residualKer`** | R-stable 2-plane ⊆ residualKer |
| **`R_character_plane_residual`** | R-character pure wedge ⇒ residual support |
| **`N_fixed_pure_residual`** | rotGen-fixed pure Gr point ⇒ R²=-id on support |
| **`chi10'_N_sign_inner_zero`** | ⟨χ₁₀′, sgn⟩_N = 0 on D₁₂ generators (mult-0 residual char) |
| **`residual_no_eigenvalue`** | residual R has no K-eigenvalue (√−1) |
| **`residual_pair_independent`** | `{u,Ru}` independent on residual line |
| **`residual_plucker_rotGen_det_one`** | Ru∧R²u = u∧Ru (det R|_P = +1) |
| **`Slin` / `Slin_sq`** | reflection Weil operator, S²=-id |
| **`ambientAct_reflGen_pure`** | reflGen acts by Slin on pure wedges |
| **`Slin_Rlin_Slin_eq_R5`** | S R S = R⁵ (SL conjugacy) |
| **`Slin_comp_Rlin_eq`** | S R = -R⁵ S |
| **`Slin_mem_residualKer`** | S preserves residualKer |
| **`Slin_Rlin_anticomm`** | on residual: S(Ru) = -R(Su) |
| **`residual_plucker_reflGen_of_S_stable`** | `ambientAct(s)(u∧Ru)=u∧Ru` under S-stable plane (trivial N-char) |
| **`residual_plucker_N_fixed_of_S_stable`** | both rotGen and reflGen fix residual Plücker (projective) |
| **`residual_plucker_N_vec_fixed`** | vector (not just projective) N-fixation by rot+refl |
| **`residual_plucker_rot_pow_fixed`** | all rotGen powers fix residual pure wedge as vector |
| **`chi10'_N_trivial_inner_two`** | ⟨χ₁₀′, 1⟩_N generator sum = 24 ⇒ mult 2 (writeup dim M^N trivial) |
| **`projector_N_weight_ne_one`** | (10/660)·24 = 4/11 ≠ 1 (N-Fourier weight ≠ Fix(π) eigenvalue) |
| **`residualKer_ne_top`** | residualKer ≠ U (else ambientAct(rotGen²)=id, contradicts faithfulness) |
| **`ambientAct_rotGen_pow_two_ne_id`** | order-3 element acts nontrivially on Λ²U |
| **`residual_plucker_N_all_fixed`** | **all of N** fixes residual pure wedge as vector (via dihedralToN) |
| **`chi10'_sum_centralizer`** | ∑_{n∈N} χ₁₀'(n) = 24 (full Finset sum over centralizer) |
| **`dual_sum_N_contribution`** | under N-fixation: ∑_{n∈N} χ(n)φ(n·ω) = 24·φ(ω) |
| **`projectorM_ne_of_dual_sum_eq_twentyfour`** | φ(ω)=1 + ∑_g χφ=24 ⇒ πω≠ω (via 4/11≠1) |
| **`residual_plucker_not_mem_Mfix_of_dual`** | dual-sum bridge ⇒ residual ∉ Mfix |
| **`pureWedge_residual_ne_zero`** | residual pure wedge ≠ 0 |
| **`projectorM_N_partial_apply_N_fixed`** | N-partial projector = (4/11)·id on N-fixed vectors |
| **`projectorM_N_partial_residual_ne_id`** | residual not fixed by N-partial (4/11 ≠ 1) |
| **`chiCrossTerm` / `sum_chi_eq_N_plus_cross`** | full χ-sum = 24·ω + cross under N-fixation |
| **`chiCrossTerm_of_mem_MFix`** | `πω = ω` ⇒ `cross = 42 · ω` (pure-M eigenline) |
| **`mem_MFix_of_chiCrossTerm_eq_forty_two`** | converse: `cross = 42 · ω` ⇒ `πω = ω` |
| **`dual_sum_eq_N_plus_cross`** | `∑ χ φ(g·ω) = 24 φ(ω) + φ(cross)` |
| **`not_mem_MFix_of_cross_parallel_ne_forty_two`** | parallel `cross = c·ω` with `c ≠ 42` ⇒ `πω ≠ ω` |
| **`not_mem_MFix_of_cross_eq_zero`** | `cross = 0` ⇒ dual-sum 24 ⇒ `πω ≠ ω` |
| **`residual_plucker_projectorM_ne_of_cross_smul_ne_forty_two`** | residual bridge under parallel `c ≠ 42` |
| **`residual_plucker_projectorM_ne_of_cross_eq_zero`** | residual bridge under vanishing cross |
| **`exists_dual_sum_twentyfour_of_cross_not_parallel`** | non-parallel dual via `exists_extend_of_notMem` |
| **`not_mem_MFix_of_cross_ne_forty_two`** | full case split ⇒ `πω≠ω` when `cross≠42ω` |
| **`residual_plucker_projectorM_ne_of_cross_ne_forty_two`** | residual bridge under `cross≠42ω` |
| **`residual_cross_ne_forty_two_of_mul_ne_zero`** | exterior: `cross*ω≠0` ⇒ `cross≠42ω` |
| **`exists_dual_one_kill_cross` / `exists_dual_sum_twentyfour_of_cross_not_parallel`** | non-parallel dual via `exists_extend_of_notMem` |
| **`not_mem_MFix_of_cross_not_parallel` / `_ne_forty_two`** | full case split: parallel c≠42 or non-parallel dual |

## Open for hyp B / M-cut seal

1. ~~`not_isSquare_three`~~ **DONE** (classical)
2. ~~N-fixed 2-plane ⇒ residualKer~~ **DONE** (`N_fixed_pure_residual` / `R_stable_plane_residual`)
3. ~~residual Plücker reflGen fixed under S-stable plane~~ **DONE** (`residual_plucker_reflGen_of_S_stable`)
4. residual Plücker ∉ `Mfix` — **partial**:
   - `Mfix := ker(π - id)` so `v∈Mfix ↔ πv=v` (classical)
   - N-weight `(10/660)·24 = 4/11 ≠ 1` sealed (`projector_N_weight_ne_one`)
   - ~~residual N-vector fixation~~ **DONE** (`residual_plucker_N_all_fixed`)
   - ~~∑_N χ = 24~~ **DONE** (`chi10'_sum_centralizer`)
   - ~~dual bridge πω≠ω from ∑χφ=24~~ **DONE** (`projectorM_ne_of_dual_sum_eq_twentyfour`)
   - ~~N-partial weight 4/11 on residual~~ **DONE** (`projectorM_N_partial_*`)
   - ~~dual sum bridge~~ **DONE** (`projectorM_ne_of_dual_sum_eq_twentyfour`, `dual_sum_N_contribution`)
   - ~~non-parallel dual + full `cross≠42` case split~~ **DONE** (`not_mem_MFix_of_cross_ne_forty_two`)
   - ~~exterior pure-M gate~~ **DONE** (`residual_cross_ne_forty_two_of_mul_ne_zero`)
   - **open**: residual-specific pure-M exclusion `cross ≠ 42·ω` / `cross*ω≠0` (modular: mixed G-span 15; pure W5 already gives ∉MFix via parallel c=-24)
   - ~~`chi10'_convolution` / `π²=π` so `Mfix = range(π) = 10′`~~ **DONE**
     - `PSLCard.convAt_eq` / `chi10Int_convolution` (raw M4 native fail-count 0 + SLG bridge)
     - `chi10'_convolution` over `k`
     - `chiSumOp_sq_apply` (`T² = 66 T` pointwise) and `projectorM_sq_apply` (`π(πv)=πv`)
     - `Mfix_eq_Msub` (`ker(π-id) = range(π)`)
   - **DONE** pure-M rank infrastructure (classical):
     - `chiSumOp_eq_smul_projectorM` (`T = 66·π`)
     - `mem_Msub_of_mem_Mfix`, `ambientAct_mem_Msub_of_pureM`
     - `residual_plucker_mem_Msub_of_pureM` (pure-M residual ∈ Msub)
     - `projectorM_isProj` : `IsProj Msub π` (pointwise, no `LinearMap.ext`)
     - `projectorM_trace_eq_finrank` : **`tr(π) = finrank Msub`**
     - `chiLambda2` / `chiLambda2_one` : ambient character, tr(id)=15
     - `chiSumOp_trace` : `tr(T) = ∑ χ χ_Λ²`
     - `sum_chi_chiLambda2` : `∑ χ χ_Λ² = 66 · finrank Msub`
     - `projectorM_trace_eq_scaled_sum` : **`tr(π) = (10/660) ∑ χ χ_Λ²`**
     - `finrank_Msub_eq_ten_of_sum_chi_chiLambda2` : sum=660 ⇒ finrank=10
     - **DONE** involution conjugacy (classical + native order-2 card):
       - `card_carrier_sigma` : class size of σ is 55
       - `isConj_sigma_of_order_two` : every order-2 element ≃ σ
       - `chiLambda2_isConj` / `chiLambda2_eq_of_order_two` : χ_Λ² constant on order 2
     - Open for rank 10: evaluate `∑ χ χ_Λ² = 660` via order expansion:
       10·15 + 2·55·χ_Λ²(σ) + 1·S₃ − S₆ − S₁₁
       - order 2 constant on class: **DONE** (`chiLambda2_eq_of_order_two`)
       - need **`χ_Λ²(σ)=3`**: `tr(J)=0` (J=weilU(S), J²=-id, no eigenlines; plane-trace+semisimple induction or L=k[J]-module trace) + exterior identity `((tr)²-tr(J²))/2=3`
       - need χ_Λ²=0 on orders 3,6 and S₁₁=-180
   - **DONE**: `chi10'_sum_sq` = 660 via `PSLCard.slChiSumSq_eq` (1320) + `sum_comp_mk` (2-to-1) + `orderOf_mk_eq_pslOrd`; SL order profile native
5. `V14MVariety` faithful + nonempty
6. `V14_hypothesisB` on M-cut
7. Rewire `V14Application` off coset (still `GeometricCarrier.V14Variety` = G/C₁₁)

**PSLCard (classical):** `|PSL₂(F₁₁)| = 660` via `|GL|=13200` → `|SL|=1320` → `|center|=2` → `|PSL|=660`.
Also: computable `pslOrd`, native order multiset, `orderOf(mk A)=pslOrd A`, `∑_A χ(pslOrd A)²=1320`.

## Math notes (verified modular/exact)

- pure Gr hyp B is **false**: residual plane dim-2, N-stable
- residual Plücker has **trivial** N-character (det R|_P = +1, and S-stable ⇒ reflGen +1), not sign
- `rank(projectorM)=10` modular; residual Plücker not fixed by π
- χ₁₀′ convolution ∑ χ(g)χ(g⁻¹k) = 66 χ(k) modular (all orders)
- N-fixed plane over K must have tr(R)² ∈ {0,3}; only 0 possible in K
- modular: `dim residualKer = 2` at primes 23,67,199,397; residual pure wedge N-eigenvalue +1 for R and S
