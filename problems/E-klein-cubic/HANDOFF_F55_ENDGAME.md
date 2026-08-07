# Handoff: the F55 endgame (written 2026-08-07)

> **STATUS UPDATE (2026-08-07, wave 31; see §8.22 + NOTEBOOK).**
> T0 DONE (both certificates re-verified; Correction IX-g: the §8.19
> split is 8+18, not 9+17; sweep2's part (B) had never run).
> T1+T2 DONE-EXCEEDED: the level-2 system collapses exactly to 24
> pattern-independent rows ⟹ six twisted sums ⟹ unique nowhere-zero
> ξ* ⟹ transversal covering count 0/15,625 ⟹ **Theorem X: every
> pattern on every fan with walls among {H_a = H_b} dies** (hand
> certificates: 3-row / 2-row-proportional, ratio −5 = −9⁻¹).
> T4 DONE (subsumed by Theorem X; plus sweeps).
> NEW: **Theorem X′ — the sign-fan {H_a = 0} dies for every pattern**
> (corank-1-orbit pair kill), first aligned fan beyond the G₉ class.
> T3 PARTIAL: canonical (τ,Ψ)-frame + affine curvature transport
> Θ_{σW} = 5σΘ_W + 5γ′ derived; ≤1 flat wall per orbit; **Correction
> IX-h: IX-f overgeneralized — depth-t aligned fans exist for all t,
> their level-2 shadow is solvable, the aligned proof is an induction
> on (finite) alignment depth**. T5 NOT STARTED. Lemma S UNCLAIMED.
> ALSO (§8.23): **Theorem X″ — the A₄-fan dies for EVERY pattern**
> (three lines: (ii) at ray points + covering theorem; upgrades the
> 420-sample record), and the ORDER-FAN CRITERION (generic ℓ: six
> pairings ≢ 0; aligned ℓ: ξ*(ℓ) nowhere zero; zeros ⟹ descend).
> T6 chain links 2–5 re-audited clean (necessity directions).
> §8.24: **Theorem X‴ — the order-fan eigen-classification** by the
> active set A(ℓ): 5 ∉ A ⟹ Lemma U; A full ⟹ level-1 kill for every
> pattern (Fourier lemma, 816-sweep clean); A = {5} ⟹ ξ*(ℓ)
> criterion — **e_b-fan closed for all patterns**
> (ξ* = (1,10,5,3,2,6)), G₉+11e₁ = first depth-2 tower inhabitant;
> intermediate A ⟹ OPEN (rays collapse into the inactive span).
> WAVE 32 (delegated round; §§8.25–8.26, Corrections IX-i/j, seven
> probes f55_verify_all/midfan/alignedsweep/mixedfan/flagsign/
> mixedlevel2/mixedlevel3): regime (iv) swept dead (24,568 tests);
> ξ* PROJECTIVELY RIGID (455 fans, one projective class ⟹
> nowhere-vanishing reduces to one statement); tower verified to
> 11⁴ (G₉+11e₁ dies at 11³, depth-3 at 11⁴); flag-sign fan closed
> for every pattern (GLOBAL kill — no local template); link 1
> replayed green (both packets). **T5 SPLIT: the mixed A₄∨G₉ fan's
> non-aligned sector dies at level 1, but P={0,1},{3,4} carry
> EXPLICIT INTEGER witnesses of the relaxed (1)(2)(3)-system
> (saturated ker_Z rank 19 ⟹ the whole 11-adic tower is vacuous
> there). Correction IX-j: the (1)(2)(3) transcription of Lemma S
> DROPPED POSITIVITY (d ≥ 0, the min-normalization); all kills
> stand a fortiori, but Lemma S must be restated with (0) d ≥ 0 —
> the inequalities are the whole remaining content on mixed fans.**
> The positivity-restored question = bounded exact LP/ILP on the
> rank-19 lattice (f55_mixedpos.py). Remaining: that verdict;
> general ξ*-rigidity proof; the depth-tower induction; a GLOBAL
> depth-1 aligned argument; non-arrangement fans; then
> T6-assembly/T7 with the corrected statement.
> New probes: `f55_exact1.py`, `f55_exact2.py`, `f55_eweb.py`,
> `f55_xistar.py`, `f55_free_sweep.py`, `f55_signfan.py`,
> `f55_signfan_close.py`, `f55_a4exact.py`, `f55_ellfan.py`.

For human or fresh-session continuation. Everything referenced is
committed; theory in `theory/FIX_IX_v14.md` (§8 = the F55 campaign,
§§8.1–8.22), probes in `director_probes_20260806/f55_*.py`, sealed
packets under `goal_runs_after_*/`. The ledger is `NOTEBOOK.md`
(waves 28–31). Read §0 and §3 before doing anything.

## 0. The one question and what hangs on it

**Question.** Is the Klein cubic F55-equivariantly unirational,
where F55 = C11⋊C5 ≤ PSL(2,11)?

**Why it decides everything.** Sealed/proved this week:
- The V14 twin is NOT PSL(2,11)-unirational (Cor IX.1, sealed by
  packet `goal_runs_after_c53d89a/FIX_IX_SEAL`), so
  ed_C(PSL(2,11)) = 3 ⟺ the Klein cubic is G-unirational (Cor IX.2).
- F55-unirationality transfers freely between the Klein cubic and
  the V14 (odd order; Lemma IX.7), and any G-map restricts to an
  F55-map. Hence: **F55-NO ⟹ the Klein cubic is not G-unirational
  ⟹ ed_C(PSL(2,11)) = 4** — the headline resolved negatively,
  refuting the Cassels–Swinnerton-Dyer instance (D-R Prop 10.8(b))
  and completing Beauville's ed-3 classification.
- F55-YES would resolve a named open case of Cheltsov–Tschinkel–
  Zhang (arXiv:2502.19598, p.18) positively; the headline would
  remain open.

**Exact form of the question** (Theorem I + sealed packet
`goal_runs_after_35fa/H_11_5_TWIST`): F55-YES ⟺ the cyclic trace
cubic `Φ(a) = Tr_{E/K}(r₂⁻¹ a² σ(a))` has a nonzero K-zero, where
`E = C(r₀..r₄)/(Πrᵢ = 1)`, σ cyclic of order 5, `K = E^σ =
C(U₁..U₄)`.

## 1. The reduction chain (status of every link)

Each link below is needed for the F55-NO conclusion. Before any
public claim, re-audit each link in order.

1. F55-YES ⟺ K-zero of Φ. [Sealed model + D-R Thm 10.5 for cubic
   hypersurfaces + specialization lemma. Status: SOLID; the packet
   is sealed and was independently replayed earlier.]
2. K-zero of Φ ⟹ a trace-zero φ = ρ − σρ with φr₂ = ψ(a),
   ψ(a) = a²σ(a) (additive Hilbert 90). [Theorem I, §8.10. SOLID.]
3. φ trace-zero ⟹ the twice-min law at every σ-orbit of prime
   divisors on any equivariant model, poles included; boundary
   version = Newton-polytope support patterns. [Theorem J, §8.11;
   one-line proof. SOLID. Note v_w(single Laurent polynomial) =
   min over Newton polytope EXACTLY — no cancellation in initial
   forms.]
4. The boundary shadow of (2)+(3) ⟺ the crux polytope/PL system:
   integral-sloped PL h with F := 2h + h∘σ⁻¹ − e₂* having its
   σ-orbit min attained ≥ 2 everywhere. [Theorem Q, §8.16, with
   the VIRTUAL-polytope generality of §8.17 — h is a DIFFERENCE of
   support functions, i.e. any integral-sloped PL homogeneous
   function. SOLID.]
5. Equivalent slope form: the (1)(2)(3)-system of §8.20 —
   U: {max cones} → Λ integral, ≥2 zero-cells per σ-orbit,
   wall-jumps in Zν_W, orbit congruence
   Σ9ᵏσ⁻ᵏU(σᵏC) ≡ −c₉ (mod 11), c₉ = 4·G₉, G₉ = (1,5,3,4,9).
   [§8.20; the equivalence "integer values ⟺ integral slopes" is
   proved there (full-dim cones' lattice points generate N).
   SOLID.]
6. **LEMMA S (OPEN — the last mathematical gap): the
   (1)(2)(3)-system is infeasible for EVERY σ-invariant complete
   fan.** Lemma S ⟹ no φ ⟹ Φ pointless ⟹ F55-NO.

## 2. What is already proved toward Lemma S

- **Theorem R** (§8.17): h-free congruence — for any integer-valued
  h, `Σᵢ9ⁱF(σⁱn) ≡ −⟨n, c₉⟩ (mod 11)` at every lattice n (because
  2+9 = 11). At anchors (⟨n,c₉⟩ ≢ 0) the five orbit values are
  never all equal. The level-1 four-term Farkas certificate was
  unwound BY HAND into exactly this identity (§8.17).
- **Lemma T** (freezing, §8.19): if all wall-normals lie mod 11 in
  a subspace L, solutions have U mod 11 ∈ L.
- **Lemma U** (§8.19): if the wall-span misses the 9-eigenline
  projection (π₉(L) = 0), level-1 death: 0 ≡ −4 (mod 11). This
  settles every "9-inactive" fan.
- **Computational verdicts (all rigorous as infeasibility —
  sampling can only understate an obstruction):**
  * A4 Weyl fan: 20 uniform + 400 random equivariant patterns —
    infeasible mod 11 (`f55_cruxlp.py`).
  * Stellar refinement: 120 random non-equivariant patterns —
    infeasible mod 11.
  * G₉-aligned fan (all wall-normals ≡ multiples of G₉ mod 11):
    ALL 26 σ-coherent rank-patterns (complete enumeration) — 9
    have no free rays (anchors violated), 17 force v ≡ 0 (mod 11)
    and die at the level-2 (V-web) system (`f55_sweep2.py`).
  * e_b-aligned fan (second 11-cover direction): 4/4 patterns,
    same signature.
  * Isotropic margin designs: (ii)-solvable but covering-infeasible
    (complete support analysis, `f55_design.py`).
- **The level-2 structure, exactly** (§8.20–8.21, after
  Corrections IX-e/f): on aligned fans U = τG₉ + 11V; level 1
  fixes Στ ≡ 7 per orbit and m_W mod 11; the V-web (V vanishing
  across the zero-web, jumps V−V′ = m_Wρ_W − k_WG₉ with
  ν_W = λ_WG₉ + 11ρ_W) is what dies. Equivalent τ-form: with
  Θ_W := ρ_W/λ_W mod L₉, the system is `Στ ≡ 7` + `τ = 0 on
  zero-cells` + `τ ⊥ Θ-curvature web`; **Lemma S (aligned case) ⟺
  the orbit-sum functional lies in the span of the Θ-curvature
  relations.**
- **The level-2 Farkas certificate** is again four terms
  (coefficients 6,6,2,1 at four lattice points with anchors
  8,5,1,6 mod 11, spanning four different rank-chambers) —
  extracted, NOT yet unwound by hand.

## 3. THE REMAINING TASKS, in order

**T0 (before anything): re-verify the two certificates
independently.** Both four-term certificates are load-bearing.
Level-1: re-derive Theorem R's unwinding by hand (it is two lines;
§8.17 has it — check it). Level-2: recompute the certificate with
a different seed/sample and confirm the same four-row structure
(or an equivalent short one). Toolchain: `f55_sweep2.py` + the
inline extraction snippet (wave-30 ledger references the exact
runs).

**T1. Unwind the level-2 certificate into a hand identity.**
Expected shape (by analogy with level 1): an exact integer
identity in the values of V (equivalently in τ and the ρ-data)
along a small configuration connecting four rank-chambers through
the zero-web, whose h/V-coefficients cancel mod 11 and whose
inhomogeneity (driven by Στ ≡ 7) survives. Deliverable: the
identity + a §8.22 write-up at the rigor of §8.17.

**T2. Prove the span-statement for the G₉-fan class.** Statement:
on the fan of orderings of (H₀..H₄), Hₖ = ⟨σᵏ·, G₉⟩, with any
zero-pattern of coherent type, the orbit-sum functional is in the
span of the Θ-curvature relations. T1's identity should exhibit
the explicit combination; then check it covers all 17 surviving
patterns (the other 9 die with no free rays — already proved).

**T3. Generalize to all 9-active aligned fans.** The ρ-data is
canonical (ρ_W = (ν_W − λ_WG₉)/11 for any lift choice; changing
the lift shifts ρ by G₉-multiples, which die in Θ). Expected: the
span-statement is lift- and fan-independent for fans with all
walls 9-aligned. Watch for: fans with null walls (ν ≡ 0 mod 11) —
there τ cannot jump (proved in §8.20's frame); handle as
degenerate edges of the web.

**T4. Routine closure A — free (non-rank) patterns on aligned
fans.** Per-orbit-free zero-patterns that are not rank-coherent.
Expected route: Lemma T confinement + the same span-statement
(the Θ-curvature web only grows when the zero-web shrinks). Do
not skip: sweep a sample computationally first
(`f55_sweep2.py` accepts arbitrary `zero_region` callables).

**T5. Routine closure B — mixed fans.** Fans that are neither
fully generic nor fully aligned. Needed: the precise dichotomy.
Suggested statement: consider the mod-11 span L of ALL wall-
normal classes. If π₉(L) = 0: Lemma U kills. If L = L₉ (fully
aligned): T2/T3 kill. If L strictly contains L₉ or is
9-active-but-larger: expected that a sub-web of walls carries a
generic-type level-1 certificate OR the extra directions freeze
(Lemma T on the quotient); this is the least-explored case —
sweep computationally first (build two or three mixed fans:
common refinements of the A4 and G₉ fans), then prove.

**T6. Assemble Lemma S and re-audit the chain.** Write Lemma S =
U + T2/T3 + T4 + T5. Then re-walk §1's links 1–6 one at a time,
checking each cited proof (especially: Theorem I's sufficiency
AND necessity directions; Theorem J's boundary version; Theorem
Q's virtual-polytope generality; the §8.20 equivalences). Only
then state the theorem: **Φ is pointless; F55 is not unirational
on either twin; the Klein cubic is not PSL(2,11)-unirational;
ed_C(PSL(2,11)) = 4.**

**T7. Seal and publish-grade verification.** The f55 probes are
director-grade, not sealed packets. Build a packet
(FIX-IX-F55 or similar) with: independent verifier re-running
every finite verdict at fresh seeds/primes; the two unwound
certificates as machine-checked identities; the Lemma S proof
dependencies listed. Update NOTEBOOK (new E-entry or E56 wave),
HANDOFF banner, dashboard. Given the stakes (a named-conjecture
refutation), request an external review round before any claim
leaves the repo — the wave-28–30 record has SIX corrections
(IX-a..f); the discipline that caught them must run one more time
on the final assembly.

## 4. If a task FAILS (escape found)

If T2/T3/T5 turn up a feasible fan/pattern (a genuine solution of
(1)(2)(3)): Lemma S is FALSE at the shadow level. Consequences:
the arithmetic flank ends at the same shadow-feasible/lifting
wall as the geometric flank (§8.7); F55 stays open; the honest
next lanes are (a) the algebraic lifting problem for the found
shadow (a bounded exact solve at its profile), (b) the rigidity
sub-question (§8.4 item 2, untouched), (c) the YES-side ladder
past the d ≤ 7 gate (stop-rule requires a structural argument to
extend), (d) construction via Theorem I's interpolation problem.
Record the failure certificate in the ledger either way — a
feasible shadow is a real finding, not a disappointment.

## 5. Parallel open items (NOT on the critical path)

- **In-flight workers** (do not touch their directories;
  worker-return write-race discipline): FIX-IX-V14MODEL (stages
  3–4: conic census, index arithmetic, the 10′-ladder — the
  pre-registered blind test: Cor IX.1 predicts EMPTY landing cones
  at all degrees; a verified hit would contradict the sealed
  theorem and must be escalated, not absorbed) and FIX-VIII-
  A5LADDER (d = 8..12 branches, "cplus" candidate mid-
  verification; the F55 ladder result `f55_ladder.py` — empty
  through degree 5, d = 6 M2 runs possibly still queued — is a
  separate director probe).
- **Rigidity** (§8.4 item 2): untouched; only needed if the
  machine route is revived.
- **E18's role**: now redundant for F55-NO if Lemma S closes (the
  trace form IS the object being killed); its local-solubility
  protocol (§8.10 Theorem H made split places automatic) stands
  if arithmetic is ever needed again.
- **The spin flank** (Cor IX.5): killing V14's double-cover
  sources is a SECOND sufficient route to ed = 4, independent of
  F55; parked.
- **Positive face**: the A5 ladder attacks a different named CTZ
  case; unaffected by all of this.

## 6. Trust notes for the reader

- Sealed packets (with verifiers, replayed): trust. Note IX §§1–7
  and the FIX-IX-SEAL results are at that grade or cited-literature
  grade. §8 is DERIVATION-grade: every theorem labeled "proved" has
  its proof in the text (most are short — re-derive rather than
  trust); every computational verdict is finite and rerunnable from
  the named probe; every claim that died is recorded as a
  correction (IX-a through IX-f) — read them; the failure pattern
  is always the same (prose outrunning verification).
- The five-point count `|V14^{C11}| = 5` used in Lemma B is
  Lefschetz-derived + probe-verified but NOT in the sealed packet;
  T7 should add it.
- Conventions that bite: σ(rᵢ) = rᵢ₊₁; weights aᵢ = (−2)ⁱ =
  (1,9,4,3,5); λᵢ = 5ⁱ = (−2)^{-i} (Correction IX-c!); G₉ =
  (1,5,3,4,9); c₉ = Σ9ⁱσ^{-i}e₂ = (4,9,1,5,3) = 4·G₉ mod 11;
  det(2+σ) = 33 on Z⁵, 11 on Λ; Σ(−2)ⁱ = 11 = 2+9. The eleven is
  conserved — expect it to reappear in any new frame you build.

## 7. File map

- `theory/FIX_IX_v14.md` — §§1–8.21: the whole campaign.
- `director_probes_20260806/`: `f55_ladder.py` (YES-side ladder),
  `f55_cruxlp.py` (A4-fan LP + certificates), `f55_design.py`
  (isotropic designs), `f55_hfan.py` (G₉-fan 11-unknown system +
  tower), `f55_sweep2.py` (full pattern sweeps, parametrized fan
  vector), `v14_f55_weights.py`, `v14_f55_curves.py`,
  `v14_f55_sweep.py` (the V14-side fixed-point/curve data).
- Packets: `goal_runs_after_c53d89a/FIX_IX_SEAL` (the V14
  theorem), `goal_runs_after_35fa/H_11_5_TWIST` (the trace-form
  model), plus the wave-25–27 packets per the ledger.
- Ledger: `NOTEBOOK.md` E56 waves 25–30; corrections IX-a..f
  inline; supersession map rows for the week.
