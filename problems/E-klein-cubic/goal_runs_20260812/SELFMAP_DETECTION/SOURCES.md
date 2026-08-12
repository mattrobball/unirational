# Sources

Every input this packet consumes, what it is used for, and its status. Nothing
outside this list is used.

## A. Sealed repository results consumed as inputs

| # | statement used | file | exit | conditionality |
|---|---|---|---|---|
| A1 | postcomposition closure: `(A,psi) |-> psi o A` maps `Land` to `Land`, `(psi o A)\|_X = psi o A\|_X`, and topological degrees multiply | `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md` Theorem A | — | none; its tuple-level proof is **re-supplied in full** as Prop 3.2 of `THEOREM_DETECTION_PRINCIPLE.md`, because §1(c) consumes exactly that proof |
| A2 | a landing covariant is the same datum as a `G`-equivariant rational map `P(W) --> X` | `goal_runs_after_35fa/G_UNIVERSAL/ALL_DEGREE_THEOREM.md`, `UNIVERSAL_OBJECT.md` Prop 2.1 | `G2-FINITE-GENERATION-PASS` | none |
| A3 | restricted dominance: `phi_A = A\|_X` is dominant | `goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/THEOREM.md` Thm 1.1 | — | **accepted input** `ed_C(PSL_2(F_11)) >= 3` (Beauville / Duncan–Reichstein); citation audit in `THEOREM_SOURCE_TANGENCY.md` §5 |
| A4 | forced foliation: `adj(J_T) = P_T Q_T^t`, `deg P_T = 2d-4`, `J_T P_T = 0`, `div P_T = 0`; the leaf factorisation `P^4 --> Y_T --> X` | `goal_runs_20260811/RT_ACTUAL_LANDING/THEOREM_FORCED_FOLIATION.md` Thm 2.4; `FOLIATION_REFORMULATION.md` §6 (32) | `GLOBAL-JACOBIAN-ADJUGATE-FACTORIZATION-PROVED` etc. | inherits A3 |
| A5 | postcomposition invariance of the saturated foliation, `P_{Psi o T} = a P_T`, `deg a = 2d(deg Psi - 1)` | `FOLIATION_REFORMULATION.md` Prop 6.1 | adjudicated `R5-9` | none |
| A6 | source tangency: `Delta_T\|_X = (d/d')H^w j_phi`, `w = n-e = 2`; `div_X(Delta_T) = 2D_X + R_phi` | `THEOREM_SOURCE_TANGENCY.md` Thm 4.1, Cor 4.2 | `SOURCE-TANGENCY-RAMIFICATION-FACTORIZATION-PROVED` | needs `phi` dominant, i.e. A3 |
| A7 | the tangency map `P |-> grad F·P (mod F)` is **surjective** onto `H^0(X,O_X(m+2))^G` for `m >= 4` | `FOLIATION_REFORMULATION.md` Prop 5.1 | — | none. Used for the closed form (3.1); **independently re-derived** by direct linear algebra for `m <= 10` (test A5) |
| A8 | `d' = 2,3` and `d' = 4,5` impossible, **for all `G`-equivariant selfmaps of `X`, dominant or not** | `EXCLUSION_DPRIME_2_3.md` §8; `D35_K30_K31_CELLS.md` Cor 3.3 | `RESTRICTED-COORDINATE-DEGREE-FOUR-AND-FIVE-EXCLUDED-ALL-DEGREES`, `RESTRICTED-DEGREE-EXCLUSIONS-UNCONDITIONAL-ON-DOMINANCE` | **none** — this is the input that makes §1(d) work |
| A9 | invariant-degree lemma `k in {0} ∪ {5,6,7,...}` | `goal_runs_20260810/COMBINED_DEGREE_SIEVE/THEOREM_COMBINED_SIEVE.md` Lemma 2.3 | `COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED` | none |
| A10 | ambient floor: `d <= 34` empty, `d = 35` first open | `goal_runs_20260811/D34_GUIDED_SWEEP/THEOREM.md` | `LADDER-EMPTY-THROUGH-34`, `D35-FIRST-OPEN-WINDOW` | Tier-3 flag in that packet: (M),(E) consumed from `STAGE2_ODD_ORDER_PINNING` |
| A11 | `d = 35` branch table, open cells `k = 0, 5..29, 34` | `D35_BRANCH_TABLE.md` §2 as corrected by `D35_K30_K31_CELLS.md` §6 | `D35-BRANCH-TABLE-EXACT` | — |
| A12 | CLEAN/CARRIER dichotomy; CLEAN norm `delta = x^2+xy+3y^2`; `D_X = 0 => CARRIER` | `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md` Thm 3.1, (4.4); `THEOREM_ACTUAL_TRANSFER.md` Thm 4.1 | `RESTRICTED-DICHOTOMY-PROVED`, `RESTRICTED-CLEAN-CM-NORM-PROVED`, `RT-DX0-PROVED` | Thm 4.1 rests on Thm 2.1's honest-flag weight-formalism import |
| A13 | retraction facts: `D_X != 0`, `k = d-1 >= 5`, normal form `T = Hx + FQ`, `d >= 24` | `THEOREM_ACTUAL_TRANSFER.md` §5; `DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md` Thm 1.1; `AMBIENT_REES_SELFMAP_CLASSIFICATION/RETRACTION_DEGREE_BOUND.md` | `DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24` | as recorded there |
| A14 | degree-one `G`-selfmap is `id_X` | `goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION/DEGREE_ONE_RETRACTION.md` §1 | — | **accepted input**: "full-`G` birational superrigidity". Isolated to Cor 3.4; Thm 3.3 does not use it (test A12) |
| A15 | tangent-residual construction: `rho(x,[v]) = [F(v)x - Q(x,v)v]`, the cubic identity (1.4), representative independence (1.5), `G`-equivariance | `FULL_G_SELFMAP_CLASSIFICATION/THEOREM.md` §1, `TANGENT_RESIDUAL_CONSTRUCTION.md`, `verify_tangent_residual.py` | `FULL-G-NONTRIVIAL-RATIONAL-SELFMAPS-EXIST` | none for §1; §3's descent is not used by this packet |
| A16 | `delta >= 3` for a nonidentity `G`-selfmap; `delta <= d'^3` | `FULL_G_SELFMAP_CLASSIFICATION/THEOREM.md` (4.1); `THEOREM_COMBINED_SIEVE.md` Cor 3.5 | — | (4.1) uses the accepted deck-involution argument |
| A17 | the flag this packet answers: "that packet produces nonidentity dominant `G`-selfmaps with `delta >= 3` and **does not compute their degree**" | `THEOREM_COMBINED_SIEVE.md` §6 | — | — |
| A18 | dimension tables `I(k)`, `C(k)` for `k <= 24`; `S(n)` for `n <= 12`; the boxed covariant `D_5` | `FOLIATION_REFORMULATION.md` §2; `THEOREM_COMBINED_SIEVE.md` Lemma 2.3; `D35_K30_K31_CELLS.md` §2 | `DEGREE-FIVE-COVARIANT-EXPLICIT` | none |
| A19 | the group model: `F = x_0^2x_1+...+x_4^2x_0`, `sigma`, `tau = diag(z^{1,9,4,3,5})`, `iota` from the Gauss-sum formula | `verify_d35_cells.py` §§B–C; `verify_d4_covariant.py` | — | reimplemented here over `F_p`; pinned by recovering `D_5` |

## B. Classical mathematics used, not re-proved

| # | fact | where used |
|---|---|---|
| B1 | Hilbert 90: `H^1(G, L^*) = 1` for `L/L^G` Galois with group `G` | Prop 2.1 of `SELFMAP_AUDIT.md` (existence of an equivariant lift of the tangent line) |
| B2 | normal basis theorem: `H^1(G, L^+) = 0` | same |
| B3 | `Cl(X) = Z·H_X` for a smooth hypersurface `X ⊂ P^4` (Grothendieck–Lefschetz), hence the cone ring `S/(F)` is a UFD | Prop 2.1 (clearing denominators), Thm 4.1 (gcd is well defined) |
| B4 | projective dimension theorem: two subvarieties of `P^4` of dimensions `2` and `2` meet | Thm 4.1 (the plane-section certificate) |
| B5 | exactness of `(-)^G` in characteristic zero for a finite group | Lemma 3.1, Thm 3.1 |
| B6 | rank of an integral matrix can only drop under reduction mod `p` | `ADVERSARIAL_TESTS.md` A6 |
| B7 | a smooth cubic threefold contains no 2-plane | `ADVERSARIAL_TESTS.md` A7 |

## C. What this packet does **not** use

* the dominant-section lemma and the free-quotient descent of
  `FULL_G_SELFMAP_CLASSIFICATION/THEOREM.md` §§2–3 — the canonical section of
  §3 of `SELFMAP_AUDIT.md` replaces them;
* the intermediate-Jacobian, Noether–Fano, MMP-rigidity and literature files of
  that packet;
* any unsealed item of `theory/CONSTRAINT_ADDITIONS_20260811.md` other than the
  postcomposition caveat C12, which is quoted only to say that Prop 2.1 of
  `THEOREM_DETECTION_PRINCIPLE.md` resolves it in one lane;
* Macaulay2 / msolve. Everything is Python with exact integer, `Fraction` and
  `F_p` arithmetic.
