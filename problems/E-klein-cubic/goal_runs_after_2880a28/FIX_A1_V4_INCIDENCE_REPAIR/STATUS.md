# FIX-A1 — `V4` fixed-locus ground truth and the type-I/type-II incidence repair

**Primary exit: `FIX-A1-V4-REPAIR-PASS`**

**Problem E headline: OPEN.**

**Packet:** `goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR/`
**Program:** FIX ([E56]); foundation packet 2 of `theory/FIX_I_bcomplex.md` §7.
**Verification class:** ALGEBRAIC-RECOMPUTE — `verify_v4_ground_truth.py` rebuilds
the representation, the group, the `V4` layer and every geometric statement from
scratch with deliberately different methods (isotypic projectors instead of
iterated kernels; Lagrange interpolation instead of symbolic restriction;
5-point vanishing instead of coefficient expansion; a unit-ideal test in the
cubic residue algebra instead of binary-form gcd; a left-multiplication BFS
instead of right), and only then compares against the sealed JSON. It contains a
harness self-test (a deliberately false statement that must be recorded as a
failure). 60 checks, 0 failures, terminal marker `FIX_A1_V4_REPAIR_VERIFY_OK`.

**Toolchain:** `python3` exact arithmetic in `Q(ζ11)` and `Q(ζ33)` only, plus one
auxiliary Macaulay2 script. No GAP, no Sage, no Magma, no PARI/GP.

**Theorem boundary.** This packet certifies the `V4` fixed-locus ground truth in
`P⁴` and on the Klein cubic `X`, and the corrected type-I/type-II incidence
table. It asserts nothing about landing covariants, dominant equivariant maps,
or unirationality, and it does not re-derive FIX-A0's `X^σ = E_t ⊔ L_t`
statement (only the parts of it that it uses and independently checks).

---

## Part I — derived ground truth (per-claim verdicts)

| Claim | Statement | Verdict | Evidence |
|---|---|---|---|
| **A1-C1** | Sylow-2 of `PSL(2,11)` are Klein four-groups; **55** of them, one conjugacy class; each contains 3 involutions; each of the 55 involutions lies in exactly 3; `N_G(V4)` has order 12 with order profile `1+3·2+8·3`, i.e. `≅ A4` | **PASS** | exact 660-element closure; **no element of order 4** in the group, so the order-4 Sylow is `V4`; `v4_exact.json:group_layer` |
| **A1-C2** | `W|_{V4} = triv² ⊕ χ₁ ⊕ χ₂ ⊕ χ₃`, each nontrivial character once — **verified for all 55 `V4`s**, not 3 | **PASS** | all 165 involutions have trace 1 on `W`; joint eigenspace dims `(2,1,1,1)` by kernels (producer) and by isotypic projectors `¼Σχ(g)g` (verifier); and `a₀+a_i−a_j−a_k = 1`, `Σa = 5` has the unique nonneg-integer solution `(2,1,1,1)` |
| **A1-C3a** | `Fix(V4,P⁴) = ℓ_V ⊔ {p₁,p₂,p₃}` with `ℓ_V = P(triv²)` pointwise fixed and `p_i = [χ_i]` isolated | **PASS** | immediate from A1-C2 (a point is `V4`-fixed iff it is a joint eigenvector); `per_V4[*].joint_dims` |
| **A1-C3b** | `L_{σ_i} = P(χ_j ⊕ χ_k)` is the line through `p_j, p_k`; the three form a **triangle** (pairwise meeting, spanning `P³`, not concurrent); **all three lie in `X`** | **PASS** | independent of FIX-A0: the restricted binary cubic vanishes identically (producer: all 4 coefficients; verifier: vanishing at 5 distinct points of `P¹`), for all 165 minus-lines; `per_V4[*].minus_lines_in_X`, `.triangle` |
| **A1-C3c** | each involution plane `P(triv² ⊕ χ_i)` **contains** `ℓ_V` | **PASS** | exact rank test, all 165 planes; `per_V4[*].line_in_plus_planes` |
| **A1-C3d** | `X ∩ ℓ_V` is a **degree-3 reduced** subscheme (3 distinct points), disjoint from the triangle (vertices *and* edges) and from every deeper stratum of `ℓ_V`; **the vertices `p_i` do lie on `X`** | **PASS** | `disc(F|_{ℓ_V}) ≠ 0` for all 55 lines; `ℓ_V ∩ L_{σ_i} = ∅` by rank; `ℓ_V` carries exactly five deeper points (3 `D12` + a conjugate pair of `A4`) and all five are off `X`; `F(p_i) = 0` for all 165 vertices; `x_cap_v4line_scheme.json` |
| **A1-C3d′** | every type-II point has **exact stabiliser `V4`**; likewise every type-I vertex; two `G`-orbits of size 165 | **PASS** | producer: `gcd(F|_{ℓ_V}, all 2×2 minors of [g·a ǀ a]) = 1` for all 656 `g ∉ V4`, for **all 55** `V4`s; verifier: unit-ideal test in `Q(ζ11)[t]/(F|_{ℓ_V})`; vertices by brute force over all 660 elements |
| **A1-C3e** | `A4/V4 ≅ C3` permutes `{p₁,p₂,p₃}` and the three lines cyclically and acts on `ℓ_V` by a matrix of trace `−1`, det `1` (eigenvalues `ω, ω²`); **`F|_A = αU³ + βV³` with `α, β ≠ 0`**, so the two `C3`-fixed points of `ℓ_V` are off `X` and `R = X ∩ ℓ_V` is a **single free `C3`-orbit** | **PASS** | exact diagonalisation over `Q(ζ33) = Q(ζ11)[w]/(w²+w+1)`; all 55 |
| **A1-C4** | at a general point of `ℓ_V`, `T(P⁴)|_{V4} = triv ⊕ χ₁ ⊕ χ₂ ⊕ χ₃` and `N_{ℓ_V/P⁴} = χ₁ ⊕ χ₂ ⊕ χ₃` (no trivial summand, as Def. 1.1 requires); at **all six** points of `X^{V4}`, `T_pX = χ₁ ⊕ χ₂ ⊕ χ₃`, so all six are isolated | **PASS** | `dF` along `ℓ_V` annihilates `B, C, D` identically (an identity of binary quadratics), so `dF_y ∈ A^*` and transversality is exactly reducedness of `X ∩ ℓ_V`; `dF` at a vertex kills `B, C, D` and is nonzero on `A` |
| **A1-C4′** *(new)* | `[N_G(V4), N_G(V4)] = V4`, so `P⁴` has exactly two `A4`-fixed points, both on `ℓ_V`; both are off `X`, hence **`X^{A4} = ∅`** | **PASS** | commutator closure + `α, β ≠ 0`; certifies the standing hypothesis of `WORKORDER_STRATA_MACHINE.md` WP-4C item 1 |
| **AUX-M2** | the plus-plane cubic `X ∩ P(W^{σ,+})` is **smooth** for all 55 involutions | **PASS** | Macaulay2 over `toField(QQ[a]/Φ₁₁)`: `dim(ideal of partials) = 0`; marker `FIX_A1_PLUS_PLANE_SMOOTH_OK` |

## Part II — the repair (per-claim verdicts)

| Claim | Statement | Verdict |
|---|---|---|
| **A1-C5** | The flagged inconsistency is located and adjudicated: candidate claim 1 ("every type-II `V4` point lies on three fixed elliptic curves") is **TRUE**; candidate claim 2 ("two positive-dimensional fixed-locus closures can meet only at type-I points") is **FALSE** | **PASS** — `CLAIM_1_TRUE_CLAIM_2_FALSE` |
| **A1-C6** | Corrected statement: positive-dimensional fixed closures meet at **both** types, in two different patterns — type-I = (one plus-plane cubic) ∩ (two minus-lines, both in `X`); type-II = (three plus-plane cubics) ∩ (`ℓ_V`, which is *not* in `X`). Full flag table and double counts (165/165, 495, 330) | **PASS** — `incidence_corrected.json` |
| **A1-C7** | The prior verdict `CLAIM_1_SURVIVES_CLAIM_2_REFUTED` (`STRATA_EXACT.md` §4, `strata/incidence_exact.json`) is **CONFIRMED** independently, and its self-declared "single-representative plus symmetry" caveat is **retired**: every statement is now verified on all 55 `V4`s / 165 points | **PASS** |
| **A1-C8** | The residual inconsistency inside the WP-3 packet is characterised and corrected: `marked_s3_geometry.json` records `observed_typeII_at_67 = observed_typeII_at_331 = 0` against `typeII_count_per_Et = 9`, and asserts consistency it never observed. Cause: **the type-II points are irrational** — `F|_{ℓ_V}` is irreducible over `Q(ζ11)` and either totally split or irreducible mod any `p ≡ 1 (11)`; 67 and 331 are inert-type primes. Repaired regression primes: **`p = 397` or `p = 419`** (3 rational points per line) | **PASS** |
| **A1-C9** | "six type-I" (`WORKORDER` line 443, WP-3 tasks on `L_t`) versus "three type-I" (line 457, tasks on `E_t`) is **not** a contradiction: each of the 3 `V4`s through `t` puts one vertex on `E_t` and two on `L_t`. Exact per-involution table: `E_t` = 3 type-I + 9 type-II, `L_t` = 6 type-I + 0 type-II | **PASS** |

## FINDINGS

1. **The load-bearing inconsistency was already adjudicated in-repo but never
   propagated.** `certificates/STRATA_EXACT.md` §4 and
   `certificates/strata/incidence_exact.json` reached the right verdict on
   2026-07-30; `NOTEBOOK.md` [E34] still carries "flagged **unresolved**". The
   open item was a bookkeeping gap, not a mathematical one — but the verdict it
   would have propagated was verified on one representative only.
2. **`marked_s3_geometry.json` contains an unflagged 9-vs-0 mismatch, and its own
   verifier cannot see it.** `verify_marked_s3.py` checks the
   `Gate1_typeII_consistency` field only for the substrings `"triple"` /
   `"type-II"` (lines 345–346); it never compares the claimed count against the
   observation. The claim is nonetheless true — the explanation is the
   irrationality certified here — but the WP-3 evidence for it was vacuous.
3. **`verify_normal_characters.py` reads the type-II incidence rather than
   recomputing it** (line 299: `assert data[...]["V4_type_II_point"]["incidence"]["elliptics"] == 3`),
   while its `V4` geometry checks are mod-67 rank tests. The characteristic-zero
   recomputation of that incidence is supplied here for the first time.
4. **`certificates/strata/normal_characters.json` has a character-arithmetic slip
   that happens not to matter.** In `V4_type_I_point.tangent_data.T_yY_as_V4_module`
   the derivation reads `Hom(chi_z, A⊕C⊕D) = chi_z⊗A ⊕ chi_z⊗C ⊕ chi_z⊗D with
   A=triv^2, C=chi_s, D=chi_r`, i.e. it names the summands without multiplying
   characters: `χ_z⊗χ_s = χ_r`, not `χ_s`. The recorded multiset
   `{χ_z, χ_z, χ_s, χ_r}` is nevertheless correct, and the neighbouring
   `incidence_flags` entries do multiply correctly. Cosmetic; recorded so it is
   not mistaken for a second incidence error.
5. **PARI/GP is present on this machine** (`/opt/homebrew/bin/gp` →
   `Cellar/pari/2.17.4`, installed 2026-07-30 12:00), contradicting the
   `WORKORDER_STRATA_MACHINE.md` environment addendum table ("PARI/GP — **NOT
   INSTALLED**") of the same date. This packet did not use it (the FIX-A1 brief
   forbids it), and the alias trap still stands: the bare name `gp` is a git
   alias. The consequence for the ledger is only that
   `MARKED_S3_GEOMETRY.md`'s "Tooling substitution" note is not a phantom.
6. **New structural fact, usable downstream.** `F|_{ℓ_V} = αU³ + βV³` in the
   residual-`C3` eigenbasis with `α, β ≠ 0`. This single normal form
   simultaneously gives reducedness of `X ∩ ℓ_V`, freeness of the `C3`-action on
   it, and `X^{A4} = ∅`; and it explains every modular observation of the WP-3
   packet.

## Deliverables

| File | Role |
|---|---|
| `produce_v4_ground_truth.py` | producer (exact; 132 s) |
| `verify_v4_ground_truth.py` | independent verifier, ALGEBRAIC-RECOMPUTE (275 s) |
| `v4_exact.json` | group layer, the 55 `V4`s, character decompositions, per-`V4` exact certificates, stabiliser scan, deeper locus, per-involution counts |
| `x_cap_v4line_scheme.json` | the degree-3 scheme `X ∩ ℓ_V`: coefficients, discriminant, `αU³+βV³` normal form, deeper points on the line, tangent data, modular visibility, `A4` fixed points |
| `incidence_corrected.json` | **the repaired incidence table** with the superseded claims quoted verbatim |
| `cubic_smoothness.m2` | auxiliary Macaulay2 check: all 55 plus-plane cubics smooth |
| `CORRECTION.md` | old claims verbatim with sources, the corrected statement, exact evidence, supersession map |
| `REPLAY.md` | replay instructions, markers, hashes, independence note vs the sibling FIX-A0 packet |
| `run_metadata.json` | timestamp / wall time / python version — deliberately **outside** the seal so the three JSON payloads stay byte-reproducible |

No existing repository file was read into the computation, edited, or deleted;
nothing was committed. The sibling packet
`goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT/` was not touched.
