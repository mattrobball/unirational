# The scheme-map consequence ledger: everything the constrained scheme map of complexes of groups implies

Opened 2026-08-12 (worker, clean-context derivation commissioned against the
sealed record). **Problem E remains OPEN. This note excludes no degree.**

**Object of study.** A landing tuple `T ∈ M_d = (Sym^d W* ⊗ W)^G`,
`F(T) ≡ 0`, inducing a dominant `G`-equivariant `φ_T : P(W) ⇢ X`
(`G = PSL(2,11)`, `X` the Klein cubic). On any equivariant resolution
`π : Z̃ → P(W)` of `φ_T` (WLOG factoring through the wonderful terminus `Z`
of `TERMINUS_STRATA_PW`), the morphism `q = φ_T ∘ π : Z̃ → X` restricts,
stratum by stratum of the two orbit-type stratifications, to a morphism of
schemes — a **constrained scheme map of decorated complexes of groups**
(`theory/FIX_I_bcomplex.md` Def 1.1 + Thm 4.1; `STAGE1_COMPLEX_MAPS` §0).
This note derives, from first principles, the complete list of constraints
that the existence of such a morphism imposes, organized by the functor that
extracts each constraint, and records for every item: statement,
proof/sketch, the data constrained, tuple-level scope, computability, and
exploitation status in the sealed record.

**Trust legend** (per repository honesty norms):
- `[T1]` complete proof here or in the cited sealed packet, prime-free;
- `[T2]` machine-verified (cited script/packet, exact or two split primes);
- `[T3]` stated with an explicitly flagged gap;
- `[EXT]` external-classical import (standard literature theorem, named);
- Status: **SPENT** (imposed and audited, cite), **PARTIAL**,
  **DISPATCHED/IN-FLIGHT**, **RECORDED** (in a constraint ledger, not yet
  machine-spent), **NEW** (absent from the record).

Corrections to this note go in as dated banners, never silent rewrites.

---

## 0. The object and its data inventory

Fix `T` and a resolution as above. Throughout, `T = c · T°` with
`c ∈ (Sym^e W*)^G` the gcd of the coordinates and `T°` the **reduced
representative** (no common factor); the gcd is automatically a `G`-invariant
form because `G` is perfect (`EXCLUSION_TRANSPORT_20260811.md` Lemma 0,
`[T1]`). The map `φ_T = φ_{T°}` sees only `T°`. Every consequence below is
tagged:

- **(tuple)** — holds for arbitrary landing tuples `T` (transportable in the
  sense of `EXCLUSION_TRANSPORT` §5–6), or
- **(reduced)** — a statement about `T°`/the map; it transports only through
  the explicit dictionary `d = d° + e`, `ord_V(T) = ord_V(T°) + ord_V(c)`,
  with `ord_V(c)` the orbit-constant order of an invariant divisor.

The morphism `q` carries the following data, which the consequence groups
constrain (referenced as D1–D8):

| # | datum |
|---|---|
| D1 | the value assignment `τ`: source stratum ↦ receiver stratum, plus image varieties (the Stage-1 morphism) |
| D2 | the per-stratum scheme maps `q\|_{cl(F)}` with their `Stab_G(F)`-equivariance and residual `W(H,F)`-action |
| D3 | closure/restriction compatibilities across the 145-relation poset, and their transversal/2-chain bookkeeping |
| D4 | conormal/jet response: induced maps of normal cones and jets along every stratum, `H_F`-equivariant at every order |
| D5 | the divisorial order ledger `m_E = ord_E(q*H_X)` over all exceptional divisors (census orbits + unknown further centers), and the base scheme `Bs(T°)` |
| D6 | the group-side morphism: stabilizer inclusions `G_z ⊆ G_{q(z)}` with conjugation twists across component transversals (the Haefliger-type datum) |
| D7 | the global cycle/cohomology data: `q*`, `q_*`, `Rq_*` on Chow, cohomology, coherent sheaves, equivariantly |
| D8 | the arithmetic shadow: `K_X = C(X)^G ↪ K_P = C(P⁴)^G`, torsor twists, Brauer residues |

**Model caveat, load-bearing.** Theorems quantified over the census hold on
`Z` and its *admissible* refinements; an actual resolution of `T` is NOT
admissible (Group G below proves this is forced, not merely possible —
`AMBIENT_HODGE_REES_BRIDGE` Theorem B is the sealed sharp form). Only the
two divisorial rows of `STAGE1_COMPLEX_MAPS` Theorem 3 bind on *every*
model; everything else binds on the strata the actual model shares with `Z`
plus whatever the extra centers add (Correction I-C,
`theory/FIX_I_bcomplex.md`).

---

## 1. The consequence groups

### Group A — the value layer (functor: points/topology of the poset map) — ledger L1

**A1. Stabilizer growth and band injectivity** `[T1]` (reduced; the map).
For every `z ∈ Z̃`: `G_z ⊆ G_{q(z)}`; hence `q(Z̃^H) ⊆ X^H` and
`im(F) ⊆ X^{H_F}` for each stratum `F`; `Stab_G(F)` stabilizes `im(F)`.
*Proof:* equivariance of a morphism. Constrains D1, D6. Enumerable as
`S`-fixed points of `G/S_t` in the 660-element group.
**SPENT** — `STAGE1_COMPLEX_MAPS` (A1)(A2) and the whole Layer-1 census.

**A2. Closure monotonicity** `[T1]` (reduced). `F ⊆ cl(F′) ⟹
im(F) ⊆ cl(im(F′))` — continuity of `q`; imposed at component level over
all 145 relations. Constrains D1, D3. **SPENT** — `STAGE1` (A4).

**A3. Properness/surjectivity and receiver coverage** `[T1]` (reduced).
`q` proper dominant ⟹ surjective; every receiver cell has nonempty
`G`-stable preimage; the free stratum dominates `X`.
Constrains D1. **SPENT** — `STAGE1` (A5); the *fiberwise* refinement is
Group F (F2, NEW).

**A4. Kodaira-type monotonicity** `[T1]` (reduced; admissible-model scope).
A rational stratum cannot dominate the genus-1 curves `E_σ`; on admissible
models every stratum is rational. Constrains D1.
**SPENT** — `STAGE1` Thm 1, (A3); scope-corrected by I-C.

**A5. Receiver finiteness dichotomy** `[T2]` (reduced). `X^H` finite for
`H ∉ {1, C2}` forces point values; `H = C2` forces `L_σ`-or-point
(`E_σ` excluded by A4). **SPENT** — `STAGE1` Thm 2 on
`RECEIVER_LEDGER_X` §5.2.

**A6. Forced sweeps** `[T1]` on every model (the only such rows).
`X^{D12} = ∅` + rationality force the three `D12`-stabilized rows onto
`L_σ`, surjectively, uniquely; coherence forces five more (eight total).
**SPENT** — `STAGE1` Thm 3, 3′.

**A7. Vertex exclusions** `[T2]` (reduced). All 18 `V4`-rows land on type-I
vertices; the `v_σ` kill rule; 12 of 18 rigid. **SPENT** — `STAGE1`
Thm 4, 5, 5′.

**A8. Fixed-point-existence bookkeeping** `[T2]` (reduced). A value cell for
a `Γ`-stable stratum must contain a `Γ`-fixed point; this is the arithmetic
that produced every admissible-value count (e.g. `|N_G(C5)/C5| = 2`
matching the `D10` pairing). **SPENT** — `STAGE1` §0.

### Group B — the tangential-moduli layer (functor: Hom-schemes of sweeps) — ledger L2

**B1. Sweep moduli are covariant eigenspaces** `[T2]` (reduced).
`q|_F : F → L_σ ≅ P¹` for a sweeping row is a nonzero element of
`S(a)^{Γ,ψ}` modulo scalars; dimensions tabulated for all 15 sweep rows.
Constrains D2. **SPENT** — `STAGE1` §3.

**B2. Evaluation rigidity and stratified degeneracy** `[T1]`+`[T2]`
(reduced). Child values are evaluations, constant per moduli component,
pinned to the unique `Λ`-eigenline of prescribed character; the `s(q) = 0`
branch is per-section (order-stratified semantics).
**SPENT + REPAIRED** — `STAGE1` §15 (Thm 15.1), `ODDZERO_AUDIT`,
`STAGE1_STRATIFIED`.

**B3. The multidegree dictionary and parity** `[T1]` (tuple).
The `σ`-bigraded leading datum `T_m` is `D12`-invariant; `N(d,m) = 0` for
`m` even (H0-1); `N(d,m) ≥ 1` for all odd `m ≤ d` (closed form).
Constrains D4, D5 vs `d`. **SPENT** — `STAGE1` §4 Thm 9, §14.

### Group C — the local scheme-map layer: jets, weights, valuations (functor: local rings/normal cones) — ledger L3, L4, L8, L9

**C1. First-order and all-order weight pinning (master weight formula)**
`[T1]` (reduced — explicitly map-level; tuple upgrade is the open
`Φ_J`-closure obligation, `EXCLUSION_TRANSPORT` §8 item 4).
At a `g`-fixed stratum `R` reached by a blowup chain with weights `c_l` and
multiplicities `μ_l`: the value lies in the eigenspace of weight
`w(R) = d·a_k + Σ_l μ_l c_l (mod n)`, or `R ⊆` indeterminacy. Base-locus
corollaries B(C11), B(C5), B(D10), B(D12), B(C3); minus-line parity
`ord_{L_σ}(T) ≡ d+1 (mod 2)`; jet constraints J1–J6; no degree excluded
(consistency at every residue mod 330). Constrains D4, D5.
**SPENT at map level** — `STAGE2_ODD_ORDER_PINNING` (Thm 1.2, §1.3–§3.5,
Thm 4.1); sharpened by `STAGE2_SECOND_ORDER` (`μ = 1` impossible at
A4-points; C6-point excluded at `μ = 3`; C11-line geometry).

**C2. Depth structure: level vectors and value cycles** `[T2]` (tuple).
The per-child depth menus depend on the multidegree class only mod 6;
period histograms 36/6/12 (plus row) and 12/6 (line row).
**SPENT** — `DEPTH_TABLE_GENERAL`, audited by `ARCJET_AUDIT` (62 kills
promoted), consumed by `D35_EXTENDED_SIEVE` (1264 = 634+546+62+22).

**C3. Chain-level jet transitivity** `[T3]` (reduced). Along
`S ⊇ S′ ⊇ S″` the two-step value/level rule must equal the direct rule;
pairwise arc-consistency does not imply it. Constrains D3, D4.
**DISPATCHED** — `WORKORDER_CHAIN_JET_TRANSITIVITY` (L9, hold-for-dispatch).
(The transversal side is settled: 2-chain cocycle coherence is implied by
the pairwise layer — `COCYCLE_COHERENCE`, `COCYCLE-ALREADY-IMPLIED`.)

**C4. The equivariant ramification complex** `[T2]` (tuple, as joined).
Per stratum, each conormal character maps to a normal character at the
image by `χ′ = ψ_S · χ^{k_χ} · (slot factors)`; receiver tangent-cone
condition at special values (at `e_j`: tangent hyperplane `x_{j+1} = 0`,
conormal weight `≡ −3a_j`). **SPENT, no cut** — `RAMIFICATION_COMPLEX`
(J unchanged `11594/1408/2018/10752/1596/1264`; the 22 intact); receiver
condition fed by `CONE_ORDER_AUDIT` (`ord_{ℓ_V}(T) ≥ 6` at every degree,
tuple-level).

**C5. The valuation/initial-form recursion** `[T1]` statement; instances
`[T2]` (tuple). For every divisorial valuation `E`, `f ↦ ord_E(q*f)` is a
valuation, and `F(T) ≡ 0` graded-piece-wise along every center: the leading
datum of `T` along any census flag satisfies the initial-form landing
equation of that flag (at the plus-planes the first nontrivial layer is the
equalizer identity coupling `T⁺`-lead to `T⁻`, because
`F|_{W⁻_σ} ≡ 0` makes the naive leading equation automatic).
Constrains D4, D5. **SPENT in instances** — this is the mathematical engine
behind H0-1/H0-2, the D35 multidegree layer (`PAIR_ATTACK_D35`), and the
depth tables; the uniform statement over all 14 divisor orbits is recorded
here for completeness.

**C6. Landing-scheme tangent/obstruction spaces and the polar tower**
`[T1]` (tuple). `∇F(T)·J_T ≡ 0` and the finite Hessian tower; first/second
order deformation conditions at any candidate. Constrains the landing
scheme itself. **RECORDED** — `CONSTRAINT_ADDITIONS_20260811` C4, C6
(ordered into the d = 35 jet compiler).

### Group D — single-morphism coherence (functor: descent/gluing) — ledger L5, L6, L7, L11

**D1. Pairwise child coherence via transversals** — **SPENT** (Stage-1
coherence layer; the `2⁶` cut).
**D2. Cross-band gluing on shared positive-dimensional loci** — **SPENT,
automatic on the sealed cells**: the only positive-dimensional cross-band
locus orbit is the 55 lines `ℓ_V`; the `(34,1)` leading form vanishes
identically along `ℓ_V`, gluing rank 0 at d = 35 and 36
(`CROSSBAND_GLUING`).
**D3. Triangle/2-chain cocycle coherence** — **SPENT, already implied** by
the pairwise layer (`COCYCLE_COHERENCE`, Lemmas A–C, 66 triangles).
**D4. Full functorial coherence (one morphism)** — **THEORY TARGET** (L11):
the umbrella cut of `STAGE1` §15.4; order-0 has no surrogate; its computable
shadows are exactly C3, D2, D3, F1–F3 below.

### Group E — the global cycle ledger (functor: intersection theory of `q*`, `q_*`) — ledger L10, UNSPENT; worked out in §3.1

**E1. Ring-homomorphism identities** `[T1]` (reduced). On `Z̃`:
`q*H_X = d°H − Σ_E m_E E` and, since `H_X^4 = 0` and `H_X^3 = 3 [pt]`:

```
(d°H − Σ m_E E)^4 = 0                     (the top identity)
(d°H − Σ m_E E)^3 = 3 [C]                 (the cohomological fiber class)
(d°H − Σ m_E E)^3 · H = 3ν,   (…)^3 · E = 3 e_E ≥ 0 (E-side fiber degrees)
d°·ν = Σ_E m_E e_E                        (pairing the two)
```

plus the genus package `2g(C) − 2 = (2d°−5)ν + Σ (a_E − 2m_E) e_E`.
Constrains D5, D7 jointly with `d`. **RECORDED** (C1/C2 of
`CONSTRAINT_ADDITIONS`), machine-UNSPENT (this is the L10 lane).

**E2. Base-orbit congruences** `[T1]`, **NEW** (reduced; transports through
the gcd dictionary). Pushing the top identity to `P⁴` and grouping the
corrections by `G`-orbits of connected components of `Bs(T°)`:
`d°⁴ = Σ_j n_j s_j` with `n_j = 660/|Stab|` and `s_j ∈ Z`. Reducing mod
11, 5, 3 kills every orbit whose stabilizer order is prime to `p` and gives,
for `p ∤ d°` (Fermat: `d°⁴ ≡ 1 mod 5` and `mod 3`; `d°⁴ ∈ {1,3,4,5,9}
mod 11`):

- mod 11: `5·Σ_{C11-stab comps} s + Σ_{F55-stab comps} s ≡ d°⁴` —
  **every landing tuple of degree prime to 11 has a base component orbit
  with stabilizer order divisible by 11**, even at residues where the
  pinning does not force the C11-points into `Bs`;
- mod 5: `2Σ_{C5} + Σ_{D10} + 2Σ_{F55} + Σ_{A5} ≡ 1`;
- mod 3: `Σ_{C3} + 2Σ_{S3} + 2Σ_{C6} + Σ_{A4} + Σ_{D12} + 2Σ_{A5} ≡ 1`.

Worked instance and executability: §3.1. **NEW** (the congruence structure;
the ingredients are C2's Segre objects).

**E3. Movable-curve nef inequalities (the multiplicity ladder)** `[T1]`
(tuple — invariant-multiple shifts preserve it verbatim). `q*H_X` is nef on
`Z̃`; for every covering family of curves `c` on `Z` avoiding no assigned
data: `d(H·c) ≥ Σ m_E (E·c)`. Instances: lines through a point center
(`d ≥ m_pt`), lines meeting a plus-plane (`d ≥ m_{P_σ}`), the sealed cone
bound `r ≥ ⌈3m/2⌉` and line-degree bound `n = d − r ≥ 2e`.
**PARTIAL** — instances sealed (`FIX_H1` §8 constants, `CONE_ORDER_AUDIT`);
the systematic ledger over the full movable cone of `Z` is UNSPENT (§3.1).

**E4. The projection-formula linear system across the census** `[T3]`
(reduced). All per-stratum mapping degrees (sweep bidegrees, `ν`, `e_E`,
`m_E`) satisfy one linear/quadratic system over the closure poset — "one
linear system over the census" (ledger L10's phrasing). Shape derived in
§3.1; UNSPENT.

### Group F — equivariant-topological consequences (functor: localization/Smith theory) — ledger L12 + NEW mod-p shadow; worked out in §3.2

**F1. The Atiyah–Bott/Leray identity family** `[T3→T2 pending]` (reduced,
at `d_min`). For every `g` and twist `k`:
`χ_g(Z̃, q*O_X(k)) = χ_g(X, O_X(k) ⊗ Rq_*O_Z̃)`; source side = pattern
data, receiver side = fiber traces; `k = 0` localized gives the sum rule
`Σ_j (tr_j − 1)/D_j = 0` at the five `C11`-points. The first GLOBAL
constraint family. **DERIVED + REFEREED** —
`theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md` §8 (R1–R6 adopted),
machine phase = `L12_ORDER11` (in flight, only the `Q(ζ₁₁)` scaffold
exists).

**F2. Fiberwise Smith congruences** `[T1]`, **NEW** (reduced). For `g` of
prime order `p` and any `x ∈ X^g`:
`χ_top(q^{-1}(x)) ≡ χ_top((q|_{Z̃^g})^{-1}(x)) (mod p)`.
Consequences: any fixed point of the receiver NOT covered by the `g`-fixed
value assignment of the actual model has `χ(q^{-1}(x)) ≡ 0 (mod p)`; over
all but finitely many points of each `E_σ` the full fiber has even Euler
characteristic unless the tower carries a σ-fixed irrational stratum
dominating `E_σ`. The mod-p shadow of F1, twist-free and holomorphy-free.
Details §3.2. **NEW** (absent from the localization ledger, which is exact
cyclotomic, not mod p).

**F3. Global both-ways Euler-characteristic ledger** `[T1]` skeleton
(reduced). `χ_c` additivity over the receiver stratification:
`χ(Z̃^g) = Σ_{strata Y ⊆ X^g} ∫_Y χ(fiber^g)`, with `χ(Z̃^g)` census-known
on `Z` (e.g. 20 points for `C11`; receiver side `χ(X^g) = −6, 2, 6, 4, 2,
5` for orders 1,2,3,5,6,11 — `RECEIVER_LEDGER_X` §6.1) plus a tracked
refinement delta. **NEW** in this stratified form; the exact-holomorphic
refinement is F1. Executable per pattern at the realization layer.

**F4. χ_y-genus extension** `[T3]`, **NEW** (reduced). The same AB/Leray
comparison with `Λ^p Ω`-twists (Hirzebruch χ_y per conjugacy class) gives a
y-parameter family strictly extending F1's `O(k)` family. Cheap once F1's
machine layer exists; recorded as the natural L12 extension.

### Group G — Hodge-theoretic and cycle-class consequences (functor: `q*` on `H³`, correspondences) — worked out in §3.3

**G1. Cohomological injectivity forces irrational centers** `[T1]`+`[EXT]`
(reduced). `q*: H³(X,Q) ↪ H³(Z̃,Q)` (surjectivity + projection formula);
`H³(X,Q)` is the 10-dimensional rational irreducible with complexification
`W ⊕ W′` (Griffiths residue: `H^{2,1} ≅ R₁ = W*`); every smooth-blowup
tower has `H³(Z̃) = ⊕_orbits Ind_{S_i}^G H¹(C_i)`. Hence **some center
orbit satisfies `⟨H¹(C_i), Res_{S_i} W⟩ ≥ 1`** — no admissible refinement
(all centers rational) ever resolves a dominant `T`.
**SPENT in sealed sharp form** — `AMBIENT_HODGE_REES_BRIDGE` Theorem A/B
(support of dim ≤ 2 inside `Bs(I_A)` carrying an `E_{−11}`-isotypic
abelian factor; restricted transfer (RT) open). The **Frobenius-reciprocity
arithmetic is NEW**: per-stabilizer minimal-genus table in §3.3
(translation-elliptic centers are invisible to `C11` but visible to
`1, C2, C3, C5, C6`; a `C11`-stabilized carrying center needs genus ≥ 5; a
`G`-invariant irreducible one needs genus ≥ 9 by Hurwitz).

**G2. Integral/polarized refinement and orbit-summed Abel–Jacobi** —
**RECORDED** (`CONSTRAINT_ADDITIONS` C9, C10): the carrier must realize the
`O_{−11}`-lattice with Rosati/polarization data; componentwise vanishing
proves nothing, the orbit sum is the object.

**G3. Trace coupling for self-maps and detection** — **SPENT/PARTIAL** —
`SELFMAP_DETECTION` (bimodule structure; `δ(φ₈) = 208 = 2⁴·13` not a norm
of `Z[(1+√−11)/2]` ⟹ `φ₈` not CLEAN; carrier half open), C8 recorded.
*Remark (not an item):* the categorical strengthening — a `G`-equivariant
semiorthogonal transport of `Ku(X)` along the correspondence — would refine
G1/G2 but is not stated as a consequence here because the functoriality it
needs is not established at theorem grade.

### Group H — arithmetic/descent consequences (functor: torsors, Brauer) — RECORDED lanes

**H1. Twist functoriality** — the defining equivalences (SPEC §"Exact
equivalent formulations"); **SPENT** as the framing of the whole campaign
(F55/Schur lanes).
**H2. Spin/central-character route filters** `[T2]` (tuple) — linear→spin
impossible at all degrees; spin→linear even only; spin→spin odd only.
**SPENT** — `RT_SPLIT_AND_DICHOTOMY` / `SPIN_SOURCE_NETWORK` (route
filters, HANDOFF_2026-08-11 §2).
**H3. Brauer residue matching with zero unramified target** `[T3]`
(reduced). Every 2-torsion class the correspondence transports (above all
the spin Schur class `β_X`) pulls back along `K_X ↪ K_P` with matching
residues at every divisorial valuation; **sharpener (NEW, one line):**
`Br_nr(K_P) = B₀(PSL(2,11)) = 0` `[EXT: Bogomolov's formula; B₀ of finite
simple groups vanishes]`, so the pulled-back class has zero unramified
part — its residues must fully cancel along the census/Rees valuations, a
finite executable ledger. **RECORDED** (C11) + NEW sharpener.
**H4. Index reduction by the fiber curve** — **RECORDED** (C11 second
half); interacts with C14's trichotomy.

### Group I — consequences on the moduli side of `T` (functor: GIT/semigroup structure) 

**I1. Exclusion transport** `[T1]`+`[T2]` (tuple, by construction).
`D = E + D_min`; `D + E ⊆ D`; `4·D ⊆ D` (double polar); mod-6 pairing
`{0,3}/{1,4}/{2,5}`; single-class-zero-at-large-degree closes every degree
(Cor 3.4). **SPENT as strategy** — `EXCLUSION_TRANSPORT_20260811`,
first executed by `TUPLE_JOINT_RESIDUE` (no zero; J =
`11594/1408/2018/10752/1596/1264`).

**I2. Postcomposition semigroup discipline** — **RECORDED** (C12) and made
precise by `SELFMAP_DETECTION` Part 1 (left-ideal structure of `Im(res)`).

**I3. SL(W)-semistability of every nonzero covariant** `[T1]`, **NEW**
(tuple). Every nonzero `T ∈ M_d` is semistable for the `SL(W)`-action on
`P(Sym^d W* ⊗ W)`. *Proof:* if unstable, Kempf's optimal destabilizing
parabolic `P(T) ⊂ SL(W)` is unique, hence normalized by the stabilizer of
the vector; `G` fixes `T`, so `G ⊆ N(P(T)) = P(T)`, so `G` preserves a
proper flag of `W`, contradicting irreducibility. ∎ Consequence: for every
integer weight vector `a` with `Σa_i = 0` (every 1-PS in every basis), the
support of `T` has both a non-positive and a non-negative weight monomial:
`min_{x^α⊗e_j ∈ supp T} (a_j − ⟨a, α⟩) ≤ 0 ≤ max`. An unconditional support
prefilter strictly beyond orbit-completeness; sibling of the tropical
prefilter (C13). Executable in the standard eigenbasis at zero cost.

**I4. Landing-scheme structure** — closedness + `G`-action + tangent
spaces: **SPENT/IN-FLIGHT** (`D35_LANDING`, `LANDING_SWEEP`,
`LANDING_INVARIANT_SIDE`: `P3(35) = 1380`, `HF4 ∈ [40330, 85390]`, linear
algebra alone cannot close d = 35).

### Group J — Stein factorization and coherent pushforward (functor: `q_*O`, `R^iq_*O`) — NEW block; worked out in §3.4

**J1. Stein dichotomy with branch-degree bound ≥ 5** `[T1]`+`[T2]`,
**NEW** (reduced). Either the generic fiber of `q` is connected, or the
Stein factor `Y → X` is a nontrivial finite `G`-cover branched along a
`G`-invariant divisor `B ⊂ X` with `deg B ≥ 5`; the degrees carrying
`G`-invariant divisors on `X` are exactly `{k ≥ 5}` (machine:
`a_k = i_k − i_{k−3} > 0 ⟺ k ≥ 5`; script §4).

**J2. Fiber connectedness transfers** `[T1]`, **NEW** (reduced). In the
connected case all fibers are connected (Zariski/Stein), so the
2-dimensional sweep fibers over `L_σ`-points and the degenerating generic
fibers must meet — an incidence constraint on any realization of the 22
live d = 35 cells.

**J3. The Leray vanishing package** `[T1]`, **NEW** (reduced; connected
case). `H⁰(X, R¹q_*O) = H¹(X, R¹q_*O) = 0` and
`H⁰(X, R²q_*O) ≅ H²(X, R¹q_*O)`; whenever `R¹q_*O` is supported in
dimension ≤ 1 (in particular in the genus-0 branch of C14 with no
`h⁰`-jump divisor — any such jump divisor is `G`-invariant, hence of
degree ≥ 5 by J1's table) this gives `H⁰(X, R²q_*O) = 0`: no punctual
`R²`, so **the fibers over the pinned odd-order points can carry no
`h²(O)`** and the `R²`-restriction to each swept line is `h⁰`- and
`h¹`-less (`O(−1)`-type). Obstructs contracted surfaces with `h²(O) ≠ 0`
over pinned points and isotrivial-with-sections Hodge bundles of the fiber
family. Details §3.4.

**J4. Fixed-fiber realizability** — **RECORDED** (C7: equivariant
Riemann–Hurwitz + Burnside marks per fixed fiber); F2/F3 above are its
Euler-characteristic shadows and are cheaper to impose first.

### Group K — quotient-side consequences (functor: descent to `[Z̃/G] → [X/G]`)

**K1. Quotient-pair discrepancy/Noether–Fano ledger** `[T3]` (reduced).
`q/G : Z̃/G → X/G` with standard boundaries; maximal-singularity
inequalities against multiplicity profiles. **RECORDED** (secondary
§47–48 of `CONSTRAINT_ADDITIONS`); the motivic/arc-space shadow is the
ARCJET lane (audited).
**K2. Orbifold-fundamental-group/cocycle data** — the Haefliger morphism
datum; its 2-chain layer is **SPENT** (`COCYCLE_COHERENCE`: already
implied); `π₁^{orb}` itself gives nothing new (both orbifolds have
`π₁^{orb} = G` by simple connectedness of `Z̃` and `X`).
**K3. Unramified-invariant comparison** — subsumed in H3's sharpener
(`B₀(G) = 0` kills the target).

---

## 2. Compressed index

| item | content | scope | status |
|---|---|---|---|
| A1–A8 | value layer | reduced | SPENT (STAGE1) |
| B1–B3 | sweep moduli, rigidity, parity | reduced/tuple | SPENT (+repair) |
| C1 | master weight pinning, J1–J6 | reduced (map) | SPENT; tuple-Φ_J upgrade OPEN |
| C2 | depth tables | tuple | SPENT (audited) |
| C3 | chain jet transitivity | reduced | DISPATCHED (L9) |
| C4 | ramification complex + receiver cone | tuple | SPENT, no cut |
| C5 | initial-form recursion | tuple | SPENT in instances |
| C6 | polar tower, tangent spaces | tuple | RECORDED (C4/C6) |
| D1–D3 | pairwise, crossband, cocycle coherence | reduced | SPENT (no new cut) |
| D4 | single-morphism umbrella | — | THEORY TARGET (L11) |
| E1 | intersection identities + genus | reduced | RECORDED, machine-UNSPENT (L10) |
| E2 | base-orbit congruences mod 11/5/3 | reduced | **NEW** (§3.1) |
| E3 | movable-cone ladder | tuple | PARTIAL (§3.1) |
| E4 | census-wide projection system | reduced | UNSPENT (L10) |
| F1 | AB/Leray identity family | reduced | DERIVED, machine in flight (L12) |
| F2 | fiberwise Smith congruences | reduced | **NEW** (§3.2) |
| F3 | both-ways χ ledger | reduced | **NEW** (skeleton, §3.2) |
| F4 | χ_y extension | reduced | **NEW** (recorded) |
| G1 | H³ forces irrational centers + reciprocity table | reduced | SPENT (AHS) + **NEW arithmetic** (§3.3) |
| G2 | integral AJ/polarization | reduced | RECORDED (C9/C10) |
| G3 | self-map trace coupling | — | SPENT/PARTIAL |
| H1–H4 | twists, spin filters, Brauer residues | mixed | SPENT/RECORDED + **NEW sharpener** (B₀ = 0) |
| I1 | exclusion transport | tuple | SPENT |
| I2 | postcomposition discipline | — | RECORDED |
| I3 | SL(5)-semistability prefilter | tuple | **NEW** |
| I4 | landing-scheme layers | tuple | IN-FLIGHT |
| J1 | Stein/branch ≥ 5 | reduced | **NEW** (machine-backed) |
| J2 | fiber connectedness incidence | reduced | **NEW** |
| J3 | Leray vanishing package | reduced | **NEW** |
| J4 | fixed-fiber RH/Burnside | reduced | RECORDED (C7) |
| K1–K3 | quotient side | reduced | RECORDED/SPENT |

Completeness discipline: the groups exhaust the standard functors
applicable to an equivariant morphism of smooth projective varieties
(points/poset; Hom-moduli; local rings/jets/valuations; gluing; cycles;
equivariant topology; Hodge/correspondences; torsors/Brauer; the moduli of
`T` itself; coherent pushforward; quotient stacks). Any consequence outside
these functors would need a genuinely new functor of the situation; none is
claimed to exist, and this table should be amended, not rewritten, if one
is found.

---

## 3. The strongest unexploited items, worked to executability

### 3.1 E2/E3/E4 — the intersection ledger (the concrete L10)

Setup: `q*H_X = d°H − Σ_E m_E E` on any resolution `Z̃` of the reduced
representative; `ℰ` = the census exceptional orbits (14 divisor orbits over
940 points / 220 lines / 55 planes, `m` constant per orbit by equivariance)
plus the unknown extra orbits (Group G proves at least one has irrational
centers). All identities of E1 hold verbatim with the mixed unknowns.

**Derivation of E2.** `(q*H_X)⁴ = q*(H_X⁴) = 0` since `q*` is a ring
homomorphism and `dim X = 3`. Expand and push forward by `π`: the `d°⁴H⁴`
term survives; every other term is supported over `π(⋃E) = Bs(T°)`.
`G`-equivariance of the (choosable-equivariant) tower makes contributions
constant along each `G`-orbit of connected components of `Bs(T°)`. Hence
`d°⁴ = Σ_j n_j s_j`, `n_j = 660/|S_j|` the orbit size, `s_j ∈ Z` the
per-component total. Reduce mod p ∈ {3, 5, 11}: `p | n_j` unless
`p | |S_j|`. The subgroup classes with order divisible by p, and their
orbit sizes mod p:

- p = 11: `C11` (60 ≡ 5), `F55` (12 ≡ 1), `G` (excluded: proper components);
- p = 5: `C5` (132 ≡ 2), `D10` (66 ≡ 1), `F55` (12 ≡ 2), `A5` (11 ≡ 1);
- p = 3: `C3` (220 ≡ 1), `S3` (110 ≡ 2), `C6` (110 ≡ 2), `A4` (55 ≡ 1),
  `D12` (55 ≡ 1), `A5` (11 ≡ 2).

This yields the three displayed congruences of E2. Two structural
corollaries, both unconditional for reduced representatives:

1. `Bs(T°) ≠ ∅` always (else `q*H_X` free with `(q*H_X)⁴ = d°⁴ > 0`),
   and for `11 ∤ d°` some base-component orbit is `C11`- or `F55`-stable.
2. At `d° = 35` (`≡ 2 mod 11`, `2 ∉ QR` so B(C11) already forces the 60
   C11-points into `Bs`): `d°⁴ ≡ 5 (mod 11)`, so
   `5·s(C11-orbits) + s(F55-orbits) ≡ 5`, i.e. `s(C11) ≡ 1 − 9·s(F55)
   (mod 11)`. If the only 11-heavy base components are the 60 points and
   the local contribution at each is the nondegenerate value `μ⁴`
   (`μ = mult`), then `μ⁴ ≡ 1 (mod 11)`, i.e. **`μ ≡ ±1 (mod 11)`** —
   a congruence on data that C1's pinning already tracks. The
   nondegeneracy hypothesis is exactly what the realization layer on the
   22 cells computes, so this row belongs in that layer's checklist.

The analogous level-3 row `3ν = d°³ − Σ(level-3 orbit terms)` pins
`ν mod p` the same way. **How to enumerate:** per candidate/pattern, the
`s_j` are Segre numbers of explicitly known base components — computable by
the repository's standard exact linear algebra at two primes; the
congruence skeleton needs only the stabilizer classes (this table).

**E3 systematically.** For every covering family of curves `c` on `Z`:
`d°(H·c) ≥ Σ_orbit m_i (D_i·c)` (proof: nefness of `q*H_X` plus
effectivity of the residual exceptional multiplicities on a further
resolution; generic members of a covering family avoid the codim-≥2
centers). The instances used so far (cone bound, line-degree bound) pair
against: lines through one point-center; lines meeting one line/plane
center; conics through two centers. The unexploited executable step:
enumerate the extremal covering families of `Z` (the wonderful model of a
linear arrangement has a combinatorially presented movable cone — chains in
the building set) and emit ALL inequalities `d° ≥ Σ (chain coefficients)
m_i` as one linear program against the 14 orbit multiplicities per residue
class. This is finite, degree-uniform, and belongs in the L10 packet next
to E2.

**E4 shape.** Unknowns per pattern: `d°`, the 14 census `m_i`, the unknown
extra orbits' `(n_j, m_j, s_j)`, `ν`, the `e_E`, sweep bidegrees `(a,b)`
per swept row, `g(C)`. Equations: E1's four identities + E2's congruences +
E3's LP + B3's parities + C1's J1–J6. One mixed integer system per residue
class mod 330 — the "one linear system over the census". UNSPENT; this
subsection is its specification.

### 3.2 F2/F3 — the Smith-theory shadow (mod-p, twist-free)

**Lemma (Smith).** `[EXT]` A `C_p`-action (p prime) on a complex
quasi-projective variety `Y` has `χ_c(Y) ≡ χ_c(Y^{C_p}) (mod p)` (the free
part fibers in `p`-orbits; `χ_c` is additive/multiplicative).

Apply to a fiber `Y = q^{-1}(x)`, `x ∈ X^g`, `g` of prime order `p`
(projective, so `χ_c = χ`): `(q^{-1}x)^g = (q|_{Z̃^g})^{-1}(x)`, giving
F2's congruence. Feeding it the record:

- **Order 11.** Per fixed `C11`: `Z^{C11}` = 20 points (census); every
  `C11`-fixed point of every further model lies over one of the 5
  eigenpoints (equivariance of the tower), so the g-fixed fiber over
  `x ∈ X^{C11}` is a finite set the pattern + refinement data counts.
  Congruence: `χ(q^{-1}(x)) ≡ #{model C11-points over x} (mod 11)` — five
  equations per `C11`, coupling the L1 value assignment (the `5⁴`-freedom
  rows, already collapsed to 1 by C1) to the realization layer's fibers.
- **Order 2.** For `x ∈ E_σ` off the finite landed set of σ-fixed strata:
  `χ(q^{-1}(x)) ≡ 0 (mod 2)` — UNLESS the actual tower carries a σ-fixed
  irrational stratum dominating `E_σ` (only non-admissible centers can:
  A4/I-C), in which case that stratum is Group-G material and its own
  ledger row. Either way a dichotomy with executable halves.
- **Order 3/5.** Same skeleton at the C3-eigenline images and the
  `C5`-points, with `χ(X^g) = 6, 4` bookkeeping.

**F3 (global form).** `χ(Z̃^g) = Σ_{Y ⊆ X^g strata} ∫_Y χ(fiber^g)` with
`χ(Z̃^g)` = census value + tracked blowup deltas
(`χ` of a blowup adds `χ(center^g)·(χ(fiber of P(N)^g) − 1)` per center).
Executable per pattern once the realization layer fixes the tower on the
22 cells; the receiver-side constants are sealed
(`RECEIVER_LEDGER_X` §6.1). Relation to F1: F1 refines F3 from `Z`-valued
`χ` to `Q(ζ)`-valued `χ_g` with twists; F2/F3 need no holomorphic-fixed-
point formula, no lift bookkeeping (L12 Flag 4/R5), and no connectedness
flag — they are the right first machine target after L12's `k = 0` sum
rule.

### 3.3 G1 — the reciprocity arithmetic of Hodge-carrying centers

Sealed core (`AMBIENT_HODGE_REES_BRIDGE`): `α_A : H³(X,Q) ↪ IH³(Y,Q)`,
and some `G`-orbit of strict supports `S ⊆ Bs(I_A)`, `dim S ≤ 2`, carries
an abelian-variety factor with nonzero `E_{−11}`-isotypy. The elementary
smooth-tower form: `H³(Z̃,Q) = ⊕_orbits Ind_{S_i}^G H¹(C_i,Q)` (blowup
formula, iterated; `H¹` of the actual smooth centers), and `q*` injects
`H³(X,Q)`, whose complexification is `W ⊕ W′`
(`[EXT]` Griffiths: `H^{2,1} ≅ (Sym W*/Jac F)₁ = W*`, trivial twist since
`G ⊂ SL(W)`). Frobenius reciprocity turns the containment into per-orbit
arithmetic: `Σ_i ⟨H¹(C_i), Res_{S_i} W⟩ ≥ 1` (W′ automatic by rationality).
Executable table (restrictions from the sealed eigenvalue data;
`tmp/scheme_map_20260812/hodge_center_table.py`):

| `S` | `Res_S W` | cheapest carrying center |
|---|---|---|
| `1` | `5·triv` | any free orbit of curves with `g ≥ 1` |
| `C2` | `3(+1) ⊕ 2(−1)` | `g ≥ 1` with either sign in `H¹` |
| `C3` | `1 ⊕ 2ω ⊕ 2ω²` | `g ≥ 1` (translation elliptics count via triv) |
| `C5` | `1 ⊕ ζ₅ ⊕ ζ₅² ⊕ ζ₅³ ⊕ ζ₅⁴` | `g ≥ 1` |
| `C6` | `1 ⊕ (−ω) ⊕ (−ω²) ⊕ ω ⊕ ω²` | `g ≥ 1` |
| `C11` | `ζ^r, r ∈ {1,3,4,5,9}` — **no trivial character** | translation elliptics invisible; fixed-point action forces `g ≥ 5` (RH: `2g−2 = 11(2h−2)+10k`), unramified quotient forces `g ≥ 12` |
| `G` (irreducible invariant curve) | — | faithful (simplicity + no fixed points on `P(W)`), so Hurwitz `660 ≤ 84(g−1)`: `g ≥ 9` |

Use: any claimed resolution tower / any realization of a surviving cell
must exhibit its Hodge-carrying orbit, and this table prices each option;
combined with E2 it couples to the congruence ledger (an 11-heavy carrying
orbit is simultaneously an 11-heavy Segre orbit). The integral refinement
(polarization type, `O_{−11}`-lattice) is G2/RECORDED.

### 3.4 J1–J3 — Stein factorization and the Leray package

**J1 proof.** Stein-factor `q = ν ∘ q̃`, `q̃ : Z̃ → Y` connected fibers,
`ν : Y → X` finite of degree `s`, `Y` normal, everything `G`-equivariant
(uniqueness of the factorization). If `s ≥ 2`: `X` smooth and simply
connected (`[EXT]` Lefschetz), so `ν` cannot be étale; Zariski–Nagata
purity (`[EXT]`, `Y` normal, `X` smooth) makes the branch locus a nonempty
divisor `B`; `B` is `G`-invariant, and `G` perfect makes its equation a
`G`-invariant form on `X`. Machine input: the invariant degrees of the
coordinate ring of `X` are `a_k > 0 ⟺ k ≥ 5`
(`tmp/scheme_map_20260812/molien_branch.py`, exact `Q(√−11)` Molien with
four sealed-record cross-checks `M₁ = 1, M₁₁ = 12, M₁₂ = 16, M₂₅ = 189`,
`ALLGREEN`; independently consistent with the director probe
`E∩[1,40] = {3}∪[5,40]` of `EXCLUSION_TRANSPORT` §7 — two independent
implementations). So `deg B ≥ 5`. ∎

Reading: a disconnected-fiber landing map buys a normal unirational
`G`-threefold `Y` finite over `X` branched in degree ≥ 5 — an expensive
object the realization layer can hunt directly; the cheap default is
connectedness, in which case J2 and J3 bind.

**J3 proof (connected case, `q_*O_Z̃ = O_X`).** Leray for `O_Z̃` against
`H^i(Z̃, O) = 0 (i > 0)` (rationality of `Z̃`) and
`H^i(X, O_X) = 0 (i > 0)`:
`E₂^{0,1} = H⁰(R¹q_*O)` injects via `d₂` into `E₂^{2,0} = H²(X,O) = 0`;
`E₂^{1,1} = H¹(R¹q_*O)` has zero targets/sources and dies in
`gr H²(Z̃,O) = 0`; `E₂^{0,2} = H⁰(R²q_*O)` must be killed exactly by
`d₂` into `E₂^{2,1} = H²(R¹q_*O)`, which in turn must be exactly killed
(`gr H³(Z̃,O) = 0`, `d₂`-target `H³(X,O) = 0`): hence the three displayed
statements. Corollaries: (i) the Hodge-bundle-type sheaf `R¹q_*O` of the
fiber family has no sections and no `H¹` — e.g. no isotrivial family with
constant nonzero `H¹`-part survives; (ii) whenever
`dim supp R¹q_*O ≤ 1`, `H²(R¹) = 0` forces `H⁰(R²q_*O) = 0`: `R²q_*O` has
no punctual part — **fibers over the pinned odd-order points (which lie on
no line and no `E_σ`, sealed incidence) have `H²(O_fiber) = 0`**,
excluding contracted surface packets with `h²(O) ≠ 0` there; over a swept
`L_σ` the `R²`-sheaf restricts with `h⁰ = h¹ = 0`.

*Support caveat, honest.* In the genus-0 branch `R¹q_*O` vanishes
generically, but its support can a priori contain a divisor `D_J` (the
locus of connected fibers with `h⁰(O_fib) ≥ 2`, i.e. multiple-fiber-type
behavior — over the open `U ⊆ X` with `codim(X∖U) ≥ 2` where miracle
flatness applies, `χ(O_fib)` is constant, so `h¹` jumps exactly with
`h⁰`). `D_J` is canonically attached to `q`, hence `G`-invariant, hence of
degree ≥ 5 (J1's Molien table) — so the corollary (ii) either binds, or a
degree-≥5 invariant jump divisor exists and becomes its own ledger row.
All statements are per-pattern checkable on any realization of the 22
cells (their C4/C6-jet and dominance layers already build the fiber models
these conditions test).

---

## 4. Machine work performed for this note

Scratch (intentionally untracked, per repository convention):
`problems/E-klein-cubic/tmp/scheme_map_20260812/`.

1. `molien_branch.py` — exact Molien in `Q(√−11)` (sympy, power-sum
   recurrence; the conjugation bug mode of naive `subs` on `√−11` is noted
   in-file and avoided). Outputs `i_k` (ambient invariants),
   `a_k = i_k − i_{k−3}` (invariants of `C[X]`), `M_k = dim M_k`,
   `k ≤ 46`. Validation against the sealed record: `M₁ = 1`, `M₁₁ = 12`,
   `M₁₂ = 16`, `M₂₅ = 189` all pass (`ALLGREEN`); additionally
   `M₃₄ = 576` and `M₃₅ = 637` reproduce the sealed D34 cascade head and
   the pre-cut d = 35 ambient count. Result used: `a₁ = a₂ = a₃ = a₄ = 0`
   and `a_k ≥ 1` for all `5 ≤ k ≤ 46` (J1's branch bound; the `k ≥ 47`
   tail is not needed — any branch divisor has some degree, and the
   statement used is only the vanishing below 5).
2. `hodge_center_table.py` — the reciprocity/minimal-genus table of §3.3
   (Riemann–Hurwitz arithmetic; prints the `(h,k)` scan for `C11`).

Not machine-verified here (stated with proofs): I3 (Kempf), F2 (Smith),
J3 (Leray), E2 (blowup expansion) — each is a short complete argument from
named classical inputs, labeled `[T1]`/`[EXT]` above; their first machine
instantiations belong to the L10/L12-adjacent packets proposed below.

## 5. What this note relied on (dependencies)

Sealed packets read and consumed as sealed: `SPEC.md`;
`TERMINUS_STRATA_PW`, `RECEIVER_LEDGER_X`, `STAGE1_COMPLEX_MAPS` (+
`ODDZERO_AUDIT`, `STAGE1_STRATIFIED` banners), `STAGE2_ODD_ORDER_PINNING`,
`STAGE2_SECOND_ORDER`, `GLOBAL_COHERENCE` (with its ×2 correction banner),
`AMBIENT_HODGE_REES_BRIDGE`, `PAIR_ATTACK_D35`/`D35_AUDIT`/`D35_LANDING`/
`D35_EXTENDED_SIEVE`/`ARCJET_AUDIT`, `DEPTH_TABLE_GENERAL`,
`CONE_ORDER_AUDIT`, `RAMIFICATION_COMPLEX`, `COCYCLE_COHERENCE`,
`CROSSBAND_GLUING`, `TUPLE_JOINT_RESIDUE`, `L12_REFEREE`,
`LANDING_SWEEP`, `LANDING_INVARIANT_SIDE`, `SELFMAP_DETECTION`;
theory notes `MORPHISM_LEDGER_20260812.md`,
`GLOBAL_LOCALIZATION_LEDGER_20260812.md` (§8 corrected form),
`EXCLUSION_TRANSPORT_20260811.md`, `CONSTRAINT_ADDITIONS_20260811.md`,
`FIX_I_bcomplex.md` (Def 1.1, Thm 4.1, Lem 4.5, Correction I-C),
`FIX_III_cosheaf.md` (Thm 5.1, H0-1/H0-2). External-classical imports are
marked `[EXT]` at point of use: Kempf instability, Smith theory, Leray,
Zariski–Nagata purity, Lefschetz hyperplane, Griffiths residues, blowup
cohomology, Hurwitz bound, Bogomolov's `B₀` formula with vanishing for
simple groups. No unverified external mathematics enters any `[T1]`/`[T2]`
claim except where `[EXT]` is displayed.

## 6. Suggested ledger updates (for the director; no files edited here)

- L10 row: point it at §3.1 (E2 congruences + E3 LP + E4 system) as the
  executable specification.
- New rows: L13 Stein/branch (J1–J2); L14 coherent-pushforward vanishing
  (J3); L15 Smith mod-p shadow of L12 (F2/F3, cheaper than the cyclotomic
  family and free of its Flags 1/4/5); L16 semistability/support prefilter
  (I3, compiler-level); G1's reciprocity table as an appendix to the
  AHS packet's (RT) program.
- Priority by cost/bite: I3 (free, compiler), F2/F3 (per-pattern integers,
  no new theory), E2/E3 (one packet, degree-uniform congruences + LP),
  J1/J3 (theory done; bind at the realization layer on the 22 cells),
  then F1's machine phase as already ordered (`L12_ORDER11`).

## 7. Not claimed

- No headline: Problem E remains OPEN; nothing here excludes any degree.
- No claim that the NEW items cut the 22 live d = 35 cells — they are
  additional necessary conditions whose machine instantiation is specified
  but not run.
- No claim of completeness beyond the functor-generator discipline stated
  at the end of §2.
- The E2 positivity of individual `s_j` is NOT claimed (integers only);
  the `μ ≡ ±1 (mod 11)` instance is conditional on the stated
  nondegeneracy and on no other 11-heavy base orbits.
