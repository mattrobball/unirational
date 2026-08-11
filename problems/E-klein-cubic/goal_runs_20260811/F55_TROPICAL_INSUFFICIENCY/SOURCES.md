# Sources

## 1. The adjudicated external round (verbatim)

External round 6, ChatGPT-derived, arrived UNAUDITED as
`round6_arithmetic.md`. Reproduced here in full so the adjudication can be
checked against what was actually claimed.

```text
# Verdict (external round 6): no valid proof of emptiness obtained

X_gen(K_proj) = empty NOT proved; stating it would be incorrect. The sealed equivalence: X_gen(K_proj) nonempty <=> G-equivariant map P(W5) --> X exists <=> some degree-d covariant T with F(T) = 0; emptiness would give ed_C(PSL2(F11)) = 4. Repo proves the equivalence, leaves the binary open; literature has ed in {3,4}.

Completed state correctly cited: d <= 34 excluded; d' = 2,3,4,5 excluded uniformly => nonidentity restricted maps have d' >= 6; 27 open cells at d = 35.

F55 trace cubic (most economical all-degree specialization): E = C(r_0..r_4)/(prod r_i - 1), sigma cyclic, K = E^sigma; the problem: Tr_{E/K}(r_2^{-1} a^2 sigma(a)) = 0 with 0 != a in E.  (1)
PROVED reductions: (2+sigma): Z^5/Z(1,..,1) -> Z^5/Z(1,..,1) injective with cokernel of order 11; rational solutions reduce to primitive finite Laurent solutions; for each fixed support S, exact-support existence decided by the saturation criterion I_S : (prod_{s in S} A_s)^infty != (1)   (2)
— an exact char-0 certificate per support; NOT a uniform classification of supports. Status PROVED-REDUCTIONS / OPEN-COVERAGE.

INSUFFICIENCY THEOREM (the new content): the valuation/tropical obstruction cannot be promoted to emptiness. Identity: (x+2)(x^4 - 2x^3 + 4x^2 - 8x + 16) = x^5 + 32, so mod x^5 = 1: (2+sigma)(sigma^4 - 2 sigma^3 + 4 sigma^2 - 8 sigma + 16) = 33.  (3)
This lifts tropical value witnesses to integral piecewise-linear functions, and after adding a large invariant convex function, to support functions of ACTUAL lattice polytopes satisfying the full twice-minimum condition. Hence no proof from valuations + Newton polytopes + convexity + coker(2+sigma) = Z/11 can prove emptiness; coefficient-level cancellation is indispensable.

EXACT MISSING THEOREM (4): for EVERY primitive finite support S in Z^5/Z(1,..,1), the coefficient ideal satisfies I_S : (prod A_s)^infty = (1). The polar-circuit argument proves (4) only for supports containing a classified clean polar diamond or a failed binomial cycle; it does not prove every primitive support contains such a cancellation core.

Unresolved alternatives: (a) f5 residue cubic pointless; (b) f6 residue cubic pointless; (c) complete the K_proj line/cube/Clifford obstruction and show a point of X_gen would annihilate it. Both residue cubics smooth full five-coordinate index-one cubics; neither pointlessness nor a point proved. Degree-11 trace-hyperplane torsor installed exactly; its K-point question is its smallest remaining theorem.

Ledger: F55-ORDER-ELEVEN-LATTICE-DEFECT PROVED; F55-RATIONAL-TO-LAURENT-REDUCTION PROVED; F55-EXACT-SUPPORT-SATURATION-CRITERION PROVED; F55-TROPICAL-OBSTRUCTION-INSUFFICIENT PROVED; F55-ALL-SUPPORT-COVERAGE UNDECIDED; F5-RESIDUE-CUBIC-POINTLESS UNDECIDED; F6-RESIDUE-CUBIC-POINTLESS UNDECIDED; GENERIC-EVEN-CLIFFORD-POINT-OBSTRUCTION UNDECIDED; X_GEN(K_PROJ)-EMPTY UNDECIDED; PROBLEM-E-NEGATIVE UNDECIDED.
```

## 2. Repository artifacts consumed (not re-proved)

All paths relative to `problems/E-klein-cubic/`.

| artifact | what was taken from it |
|---|---|
| `F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md` | Lemma 1.1 (`M^{sigma^d} = 0`), Lemma 1.2 (`coker(2+sigma) = Z/11`, the functional `lambda`), Lemma 1.3, Prop 2.1, Prop 2.2, Lemma 2.3, Prop 3.1 (the compiler), **Theorem 3.2 (the gate)**, Prop 3.3 (the tropical necessary condition), Thm 4.1, Lemma 4.2, Thm 5.1, Lemmas 6.1–6.2, Coverage Theorem C |
| `F55_COVERAGE_C_ADJUDICATION_20260808.md` | Theorem 1.1 (coverage ≡ headline), the support `S_16` (2.1), the four rows and identity (2.2), Lemmas 3.1 and 4.1, the corrected boundary, markers `F55-PC-CHEAP-COVERAGE-REFUTED`, `F55-PC-HIGHER-CIRCUITS-PASS`, `F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE` |
| `F55_AUDIT_20260808.md` | the audit's scope statements: what survives, what is withdrawn, what would count as a decision; §3's "a replacement obstruction must see information lost by Newton polytopes and divisorial valuations" |
| `theory/FIX_IX_v14.md` §8.16, §8.26–§8.30 | Theorem Q; the 33-identity and the lift formula `h = (1/33)G(sigma)(d+m+e_2*)`; the CRT split; the invariant-convex shift (`h_0 + 128 Phi`, then `t = 15,241,389`); "Theorem Q = YES, Lemma S = FALSE"; Corrections IX-k, IX-m, IX-n, IX-o; the terminal status of the arithmetic flank |
| `director_probes_20260806/f55_qpre_data_P01.json`, `..._P34.json` | the cellwise value-form witness slopes `U_d`, the 20 `sigma`-stable normals, the wall list — the input to this packet's fan-free lift replay |
| `director_probes_20260806/f55_qpreimage.py`, `f55_qpre_nemo.jl`, `f55_mixedpos.py`, `f55_witness.json` | the original two-engine lift computation (cited, not re-run) |
| `director_probes_20260808/f55_coverage_c_adjudicate.py` | the original Coverage-C verifier (cited; its filter results 1 and 2 are independently reproduced here) |
| `goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS/` | `f5`/`f6` status: `G5-F5-CUBIC-MODEL-PASS`, `G5-F6-CUBIC-MODEL-PASS`, `G5-RESIDUE-TORSOR-MODEL-PASS`; smoothness; index one; point UNDECIDED, pointless NOT PROVED |
| `goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/`, `H6A_PROJECTIVE_11_ISOGENY/` | `H6-TORSOR-CLASS-PASS`, `H6-PROJECTIVE-11-ISOGENY-PASS`; the torsor/`K`-point equivalence |
| `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/` | `V3-RESIDUE-NORMAL-FORM-PASS`, `V-F5-DEGREE16-SUPPORT-LE5-EMPTY`, exit `V-UNDECIDED`; the `f5`/`f6` residue sites and the maximal `11:5` residue model |
| `goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC/` | `G3D-UNDECIDED`; `G3D-POLAR-CLIFFORD-PARTIAL`, `G3D-SPINOR-DISCRIMINANT-PARTIAL`, `G3D-LINE-27-ALGEBRA-PARTIAL` (`SEAL.json` governs over the STATUS phase-ledger block) |
| `goal_runs_20260810/F55_LADDER_COMPLETION/` | `F55-LADDER-D6-EMPTY-ALL-TWISTS`, `F55-LADDER-D7-UNDECIDED`, `F55-LADDER-PARTIAL` |
| `goal_runs_20260811/RT_ACTUAL_LANDING/` | `EXCLUSION_DPRIME_2_3.md`; `D35_K30_K31_CELLS.md` Theorem 1.1 (`d' = 4,5` impossible in every degree); "Open cells at `d = 35`: 27"; the convention of recording the headline once as `PROBLEM-E-HEADLINE-OPEN` |
| `HANDOFF_2026-08-11.md` | `d <= 34` closed, first open window `d = 35` |
| `NOTEBOOK.md` | `ed_C(PSL(2,11)) in {3,4}`; `ed = 3 <=> the Klein cubic is G-unirational` |

## 3. Tools

`python3` (standard library only: `fractions`, `itertools`, `json`, `random`)
and Macaulay2 (`M2 --script`, cross-check only). No GAP, Sage, Magma or PARI.
No floating point anywhere in the decision paths.
