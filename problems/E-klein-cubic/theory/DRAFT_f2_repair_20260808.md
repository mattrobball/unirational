# DRAFT — the (F2) repair question, adjudicated (2026-08-08)

Scope: adjudicate findings F-1 and F-2 of `director_probes_20260806/f55_f2f3.py`
against Note IX §§8.9–8.16; give the blast radius; attempt to re-derive (F2) from
the Brauer/Gersten layer; re-test the 14 mixed-fan witnesses under whatever the
layer actually outputs.

Every claim below is labelled **PROVED-HERE** (full proof written out),
**CITED** (source + statement), **COMPUTED** (probe + output) or **OPEN**.

New probe: `director_probes_20260806/f55_f2repair_adjudicate.py`
(deterministic, seed 20260808, 27 s with the witness re-test, `--fast` for the
pure-lattice part in 0.5 s). It rebuilds every functional and constant from the
source text — it does **not** import `f55_f2f3.py`'s derivations — and ends
`checks failed: 0`. Output archived in this session's scratchpad as
`f2repair.out`.

---

## 0. BOTTOM LINE

**The Brauer/corestriction layer of §§8.11–8.15 cannot supply (F2), and the
reason is structural, not a fixable slip. (F2) is dead as a derived condition;
the 14 mixed-fan witnesses survive.**

- F-1 (index flip): **CONFIRMED, real.** PROVED-HERE, §2.
- F-2 (Theorem N ≡ (F2); Theorem O collapses to 0 = 0): **CONFIRMED.**
  PROVED-HERE, §3. Theorem N is refuted *by the source's own Theorem M*.
- Repair: **FAILS, with a proof of why** — Theorem D, §5. Exhausting the
  σ-eigen-decomposition of the second slot shows the corestricted-symbol layer's
  *entire* output is Theorem I(ii) (interior) and Theorem R = congruence (3)
  (boundary). λ never appears in a condition. There is no second slot that
  produces `λ_O(div a) ≡ 0`.
- Witness re-test (COMPUTED, §6): the repaired condition holds at **1288/1288**
  witness×boundary-orbit pairs. **The witnesses stand.**
- Consequence for the programme: §8.28's "Theorem Q = YES / Lemma S = FALSE"
  is **not** rescued by (F2). The value-form/conserved-eleven route is
  genuinely dead as a route to F55-NO. F55 and the headline remain **OPEN** —
  §8.28's own scope statement is unchanged; nothing here proves F55-YES either.
- Bonus finding **F-5** (PROVED-HERE + COMPUTED, §4, the §8.16 row): §8.16's "Two distinct
  11-covers" is FALSE. `adj(2+σ)e₂ ≡ 8·e_b (mod 11)`; the crux's denominator
  direction and the b-cover are the **same** 11-isogeny.

---

## 1. CONVENTIONS, PINNED FROM THE SOURCE TEXT

**Notation.** `E/K` cyclic of degree 5, `Gal(E/K) = ⟨σ⟩`. `T` the 4-dimensional
torus, character lattice `Λ = Z⁵/Z·1` (monomial exponents, `r^m`), cocharacter
lattice `N = {n ∈ Z⁵ : Σn = 0}` (rays `w`), pairing `⟨n,m⟩ = Σ n_j m_j`.
`ψ(a) = a²σ(a)`, `Φ(a) = Tr_{E/K}(r₂⁻¹ψ(a))`, and throughout
`φ := ψ(a)/r₂`. `b = r^{e_b}`, `e_b = (2,1,−4,4,0)` [CITED §8.10].
`σ_M` is the action on `Λ`: `σ(r^m) = r^{σ_M m}`. `shift_k(v)_i := v_{(i+k) mod 5}`.

**Lemma 0 (σ is pinned twice, from the source, without reference to any code).**
`σ(r_j) = r_{j+1}`, i.e. `σ_M = shift_{−1}`, i.e. `(σ_M m)_i = m_{i−1}`.
**PROVED-HERE.**
*Proof.* (a) §8.9 writes the five split components of `Φ` as
`T_i = r_{2+i}^{-1} a_i² a_{i+1}` [CITED]. The `i`-th component of `x ∈ E` under
`E ⊗ K̄ ≅ K̄⁵` is `σ^i(x)`, so the `i`-th component of `r₂⁻¹ a²σ(a)` is
`σ^i(r₂)^{-1}·σ^i(a)²·σ^{i+1}(a)`. Matching against `r_{2+i}^{-1}a_i²a_{i+1}`
forces `σ^i(r₂) = r_{2+i}`, i.e. `σ(r_j) = r_{j+1}`. (b) §8.11/§8.12's sealed
relation `σ(b) = r₂^{-11}b^{-2}` [CITED] gives `σ_M(e_b) = −11e₂ − 2e_b` in `Λ`;
`shift_{−1}(e_b) − (−11e₂−2e_b) = (4,4,4,4,4) = 4·diag = 0` in `Λ`, while
`shift_{+1}` fails. ∎
**COMPUTED** (probe §A1–A2): both pins pass for `shift_{−1}`, both fail for
`shift_{+1}`.

*Robustness.* The two pins are logically independent inputs written at different
times (§8.9's expansion of `Φ`; §8.10's `b = r₀²r₁r₃⁴r₂⁻⁴`), and the sealed
relation is their **consequence**, not a third convention: with `σ(r_j) = r_{j+1}`
one computes `σ(b) = r₁²r₂r₄⁴r₃⁻⁴ = r₂^{-11}b^{-2}·(r₀r₁r₂r₃r₄)⁴`, i.e. equality
in `Λ`. So there is no residual freedom to relabel: the ray/component index
question is settled by the source's own two independent data, and everything in
§§2–5 follows.

**Lemma 0′ (the source's own constants confirm the pin).** With
`c := Σ 5^i σ_M^{-i} e₂` and `c₉ := Σ 9^i σ_M^{-i} e₂`: in the pinned convention
`c = (3,5,1,9,4)` and `c₉ = (4,9,1,5,3)`, exactly as §8.14 and §8.17 record. In
the other convention the two swap. **COMPUTED** (probe §A3). So the source's own
recorded numbers are a third, independent pin.

**Two functionals on order patterns along a σ-orbit of primes `{σ^i P}`
(equivalently boundary rays `{σ^i w}`):**

    λ_w(y)  := Σ_i 5^i · ord_{σ^i w}(y)      (mod 11)
    L9_w(y) := Σ_i 9^i · ord_{σ^i w}(y)      (mod 11)

Both are well defined on σ-invariant data (`Σ5^i = 781 = 11·71 ≡ 0`,
`Σ9^i = 7381 = 11·671 ≡ 0`), and both rotate by a unit under a change of
base point (`λ_{σw} ≡ 9λ_w`, `L9_{σw} ≡ 5·L9_w`), so their **vanishing** is an
orbit invariant even though their value is not (Correction IX-d stands).

---

## 2. F-1: THE INDEX FLIP IS REAL

**Lemma 1 (transport).** For `f ∈ E*` and any prime/ray `P`,
`ord_P(σf) = ord_{σ^{-1}P}(f)`. **PROVED-HERE** (definition of the induced
valuation). Hence with `g_i := ord_{σ^i w}(a)`:

    ord_{σ^i w}(ψa) = 2g_i + g_{i−1}         [the RAY index, §8.16]

and with `s_i := ord_w(σ^i a) = g_{−i}`:

    ord_w(σ^i(ψa)) = 2s_i + s_{i+1}          [the COMPONENT index, §8.9]

The two tuples are the same tuple read backwards (`μ_i = G_{−i}`). **COMPUTED**
(probe §B asserts this on 4000 random patterns).

**Theorem A (the flip, convention-free).** Let `Λ_ν(y) := Σ_i ν_i ord_{σ^i P}(y)`.
Then `Λ_ν ∘ ψ = 2Λ_ν + Λ_{ν'}` with `ν'_j = ν_{j+1}`; consequently

    Λ_ν ∘ ψ = 0  ⟺  ν_{i+1} = −2ν_i  ⟺  ν_i = (−2)^i = 9^i  (up to scale),

so in the ray index the transpose kernel of ψ is `L9`, and

    λ ∘ ψ = (2 + 5)·λ = 7·λ   ≠ 0.

In the component index the same two functionals are written `9^i` and `5^i`
respectively; the labels swap, the functionals do not. **PROVED-HERE**;
**COMPUTED** (probe §B, 4000/4000 in each of the four cells of the 2×2 table).

**Theorem A′ (which functional the b-cover forces: the RAY index with `5^i`).**
Let `q` be a `K`-prime split in `E/K` with primes `P_i = σ^i P₀` above it, and
let `b` be a unit at all `P_i`. Then

    ∂_q(cores_{E/K}(y,b))_{11} = [ b|_{P₀} ]^{ ± Σ_i 5^i ord_{P_i}(y) }
                               = [ b|_{P₀} ]^{ ± λ(y) }.

**PROVED-HERE.** *Proof.* `∂_q ∘ cores = Σ_i cores_{κ(P_i)/κ(q)} ∘ ∂_{P_i}`.
Split ⟹ `κ(P_i) = κ(q)` for every `i`, and since `σ` fixes `K` pointwise the
induced isomorphism `σ̄ : κ(P_{i−1}) → κ(P_i)` is the **identity map of `κ(q)`**.
Hence for every `f ∈ E`, the reduction of `f` at `P_i` equals the reduction of
`σ^{-i}f` at `P₀`, as elements of `κ(q)`. The tame symbol at `P_i` (with `b` a
unit there) is `[red_{P_i}(b)]^{∓ord_{P_i}(y)}`, so
`∂_q = Π_i [red_{P₀}(σ^{-i}b)]^{∓ord_{P_i}(y)}`. Finally `σ(b) = r₂^{-11}b^{-2}`
gives `[σb] = [b]^{−2} = [b]^9`, hence `[σ^{-1}b] = [b]^{9^{-1}} = [b]^5` and
`[σ^{-i}b] = [b]^{5^i}` in `E*/(E*)^{11}` [this is §8.12 item 3, CITED, and
re-verified: `shift_{+1}(e_b) = 5e_b − 11·(1,1,−2,2,0)` exactly]. ∎

**Verdict on F-1: CONFIRMED.** The b-cover's residue functional (`λ`, `5^i` in
the ray index) and the ψ-transpose kernel (`L9`, `9^i` in the ray index) are
different functionals in *every* index. There is **no relabelling that rescues
the disputed statements**: `λ∘ψ = 7λ` is a coordinate-free identity, and the
`7` is `2 + ε⁻¹` where `ε = 9` is the σ-eigenvalue of `[b]` in `E*/(E*)^{11}`;
it is a unit mod 11, so `λ∘ψ` never vanishes.

**What is NOT wrong.** §8.9 and §8.10 are internally correct: in the *component*
index the transpose kernel really is `5^i` (Correction IX-c is right where it
stands), and §8.9's covector `W = Σ 5^i w_{2+i}` is, coordinate-for-coordinate,
`⟨w, c₉⟩` — i.e. §8.9's mod-11 congruence already **is** Theorem R.
**COMPUTED** (probe §E1: `Σ_i 5^i e_{2+i} = (4,9,1,5,3) = c₉`). The 9-weighted
line of the argument is coherent from §8.9 through §8.28. The break is the
**splice** at §8.12(5)/§8.13/§8.14, where the transpose-kernel property of the
*component-index* `5^i` was transferred to the *ray-index* `5^i` — a different
functional that happens to wear the same name.

---

## 3. F-2: THEOREM N IS (F2); THEOREM O COLLAPSES

**Theorem B (Theorem N as printed is exactly (F2) at the boundary).**
At a boundary ray-orbit,

    λ_w(φ) ≡ 7·λ_w(div a) − ⟨w, c⟩   (mod 11).                     (★)

Hence "Theorem N: `λ_w(φ) ≡ −⟨w,c⟩`" holds **iff** `λ_w(div a) ≡ 0 (mod 11)`,
which is (F2) = (iv′) at the boundary. **PROVED-HERE.**
*Proof.* `ord_{σ^i w}(φ) = 2g_i + g_{i−1} − ⟨σ^i w, e₂⟩` (Lemma 1). Apply `λ`:
the first part gives `7λ_w(div a)` (Theorem A); the second gives
`Σ_i 5^i⟨σ^i w, e₂⟩ = ⟨w, Σ_i 5^i σ_M^{-i}e₂⟩ = ⟨w,c⟩`. ∎
**COMPUTED** (probe §C1: 4000/4000).

**Theorem B′ (Theorem N is refuted by the source's own Theorem M).**
Theorem M [CITED §8.14] states `N_λ(x) := Π_i σ^{-i}(x)^{5^i}` satisfies
`N_λ(ψa) = N_λ(a)^7`. But `ord_{D_w}(N_λ(x)) = Σ_i 5^i ord_{σ^i w}(x) = λ_w(x)`
**identically**. Taking `ord_{D_w}` of Theorem M therefore gives
`λ_w(ψa) = 7λ_w(a)` — the very statement Theorem N contradicts. The "7" that
§8.14 celebrates as a coherence check between Theorem M and the corestriction
identity is the same 7 that Theorem N drops. **PROVED-HERE**; **COMPUTED**
(probe §C2, 2000/2000).

**Theorem C (Theorem O's per-ray equation is `0 = 0`).**
The residue formula of Theorem O,
`∂_q(cores(x,b)) = [ ℓ_w(N_λ(x))^{⟨w,e_b⟩} · ℓ_w(b)^{−λ_w(x)} ]`, is correct
[re-derived here from the tame symbol; **COMPUTED** calibration: it reproduces
Theorem L at 2000/2000 random rays, probe §C4]. Substituting
`N_λ(φ) = N_λ(a)^7·r^{−c}` and the **true** `λ_w(φ)` of (★) into the left-hand
side of the consistency equation gives, term for term, the right-hand side
`7·∂_q(cores(a,b)) + ∂_q(cores(r₂^{-1},b))`:

    LHS = ℓ(N_λ(a))^{7⟨w,e_b⟩} · ℓ(r^{−c})^{⟨w,e_b⟩} · ℓ(b)^{−7λ_w(a)} · ℓ(b)^{⟨w,c⟩}
    RHS = ℓ(N_λ(a))^{7⟨w,e_b⟩} · ℓ(b)^{−7λ_w(a)} · ℓ(r^{−c})^{⟨w,e_b⟩} · ℓ(b)^{⟨w,c⟩}

so the equation is vacuous. Imposing Theorem N instead (i.e. deleting the
`7λ_w(a)` from the exponent of `ℓ(b)`) leaves precisely §8.15's residual
`[ℓ_w(b)]^{7λ_w(a)} ≡ 1` — the leftover is an artifact of assuming (F2).
**PROVED-HERE**; **COMPUTED** (probe §C3: for monomial `a = r^u` the two
residues agree in `Λ/11` at 3000/3000 random rays, and the Theorem-N variant
differs by exactly `7λ_w(a)·e_b` at the 270 well-posed rays sampled, nonzero
exactly when (F2) fails).

**Structural reason (the deepest form of F-2).** `A_K = cores(φ,b)` and
`7cores(a,b) + cores(r₂^{-1},b)` are the **same class** — §8.12 item 4 is a
tautology given `φ·r₂ = ψ(a)`. Comparing their residues can never produce a
condition. A condition requires an *independent evaluation* of `A_K`. §5 shows
there is exactly one, and it is not about λ.

**Verdict on F-2: CONFIRMED, both halves.**

---

## 4. BLAST RADIUS — every claim in §§8.9–8.16

Legend: **(a)** survives unchanged · **(b)** survives with a corrected statement
· **(c)** fails.

### §8.9 — the valuation campaign
| item | verdict |
|---|---|
| `μ_i = 2s_i + s_{i+1} − w_{2+i}`, index 33, the two congruences | **(a)** — component index, internally correct |
| Correction IX-c (`λ_i = 5^i`, not `(−2)^i`) | **(a)** — correct *in the component index*, where it is stated |
| `W = Σ 5^i w_{2+i}`; five-way tie impossible when `W ≢ 0` | **(a)**, and now identified: `W = ⟨w,c₉⟩`, so this is Theorem R's ancestor (COMPUTED, probe §E1) |
| Prop (ψ-structure): pointlessness needs `[r₂] ≠ 0` in `E*/ψ(E*)` | **(a)** — no λ used |
| Tempering theorem (cascade hope withdrawn) | **(a)** |

### §8.10 — the class-to-form bridge
| item | verdict |
|---|---|
| **Theorem H** (local solubility at split places) | **(a)** — component index throughout; the "cut out exactly by" pair is right there |
| **Theorem I (i)** trace-zero | **(a)** |
| **Theorem I (ii)** `div_T(φ) ∈ Im(2+σ)` | **(a)** as a statement; **(b)** for its per-orbit invariants: the mod-11 invariant of a size-5 orbit pattern is `L9 ≡ 0`, **not** `λ ≡ 0`. Corrected: *per full σ-orbit, `Σ v_i ≡ 0 (3)` and `Σ 9^i v_i ≡ 0 (11)`* |
| **Theorem I (iii)** unit-part class `λ(m) ≡ −λ(e₂) ≡ 8` | **(b)** — the *functional* is wrong; corrected in the source's own formulation: `L9(m) ≡ −L9(e₂) ≡ 7 (mod 11)`. Reason: the condition is `r^{m} ∈ ψ(E*)·C*`, i.e. `m ∈ Im(2+σ_M) ⊂ Λ`; on `Λ`, `det(2+σ_M) = 33/3 = 11` (the diagonal is the eigenvalue-3 eigenvector), so that image has index 11 and is cut out by `L9` **alone** — the mod-3 half is absorbed by the diagonal. COMPUTED, probe §E2 |
| "the mod-3 surprise" (binomial families die at 3, per-orbit) | **(a)** — a divisor-level statement on `Z⁵`, untouched |
| "the alignment observation": `λ(e_b) = 11 ≡ 0` ⟹ `e_b ∈ Im(2+σ)`, `b = c·ψ(r^x)` | **(c)** as stated → **(b)**: `L9(e_b) = 7 ≠ 0`, so `(2+σ_M)x = e_b` has **no** solution. What is true is `λ(e_b) ≡ 0` and `e_b = (2+σ_M^{-1})x` **exactly**, `x = (0,2,−3,2,0)`, i.e. `b = const·ψ*(r^x)`, `ψ* = 2+σ^{-1}` (this is the probe's F-3, confirmed) |

### §8.11 — reciprocity layer
| item | verdict |
|---|---|
| **Theorem J** (trace-zero twice-min law) | **(a)** — purely additive, no λ |
| **Corollary J.1** | **(a)** |
| the "anchored pairing" `⟨φ,b⟩_O` | already withdrawn by Correction IX-d [CITED]; the compensation `5·(−2) ≡ 1` is real and is exactly the base-point rotation `λ_{σw} ≡ 9λ_w` |

### §8.12 — the sum, derived faithfully
| item | verdict |
|---|---|
| item 1 (the cover is the isogeny `Λ′ = Λ + Z e_b/11`, deck symmetry `F55`) | **(a)** |
| item 2 (`N_{E/K}(b) ∈ (E*)^{11}`, because `Σ(−2)^i = 11`) | **(a)** |
| item 3 (`σ^{-1}(b) = b⁵n^{-11}` exactly, `[σ^{-1}b] = [b]^5`) | **(a)** — re-verified |
| item 4 (`A_K = 7cores(a,b) + cores(r₂^{-1},b)`) | **(a)** — correct, and *tautological*: it is `φ·r₂ = ψ(a)` rewritten. It cannot be a source of constraints |
| item 5 = **Theorem K** (interior unramifiedness at split orbits) | **(c) FAILS.** The residue at a split interior orbit is `[b|_P]^{−λ_O(φ)} = [b|_P]^{−7λ_O(div a)}`, generically nonzero. The step "Theorem-I(ii) forces `λ_O ≡ 0`" invokes the transpose-kernel property for λ, which λ does not have (Theorem A). Theorem-I(ii) forces `L9_O ≡ 0`, which says nothing about λ |

### §8.13 — full interior unramifiedness, second-order congruence, cover loop
| item | verdict |
|---|---|
| **Theorem K′(a)** (σ has 5 fixed points on `T`, codim 4 ⟹ `T → T/σ` étale in codim 1 ⟹ no interior `K`-prime ramifies) | **(a)** — independent of λ, correct |
| **Theorem K′(b)** (inert primes: residue is a norm, an 11th power by item 2 ⟹ trivial) | **(a)** — correct. Detail supplied: `N_{κ(Q)/κ(q)}(red_Q b) = red_Q(N_{E/K}(b))` is an 11th power in `κ(Q)`; it is then an 11th power in `κ(q)` too, because `[κ(Q):κ(q)] = 5` is prime to 11 (if `x ∈ κ(q)` and `x = y^{11}` with `y ∈ κ(Q)`, pick `5u + 11v = 1`; then `x = (N(y)^u x^v)^{11}`) |
| **Theorem K′** as a whole ("`A_K` unramified on the ENTIRE interior") | **(c) FAILS** — it needs Theorem K for the split orbits |
| "`A_K` determined by boundary residues; `K` rational ⟹ `Br_nr = 0`" | **(b)** — §8.13's own wording ("faithfully determined by its boundary residues") is the correct consequence, but it is conditional on the (failed) interior unramifiedness. Worth flagging because the statement is often paraphrased as "the boundary residues must cancel": that is **not** implied — `Br_nr(K) = 0` gives injectivity of the residue map, and the residues of any existing class satisfy the Gersten codim-2 relations automatically |
| **Constraint (iv)** (`λ_O(div a) ≡ 0` at interior orbits; index 33 → 363) | **(c) FAILS.** Doubly: (α) the "left side is residue-free" input is Theorem K, which fails; (β) even granting it, the two sides are the *same class*, so matching residues is `0 = 0`. The `33 → 363` refinement is a perfectly well-defined condition on the (unique, since `det(2+σ̃) = 33 ≠ 0`) preimage — it is just **underived**. With (iv) gone the per-orbit pattern lattice for `div φ` stays at index 33 |
| "the cover loop" / b-split escape analysis on `T′` | **(c)** — it exists only to escape (iv). With (iv) gone it has no job. (Separately: the *strict* b-split criterion is EMPTY at the boundary; F-4, below) |

### §8.14 — boundary ledger
| item | verdict |
|---|---|
| notation `c = Σ 5^i e_{2−i} = (3,5,1,9,4)`; no σ-invariant rays | **(a)** |
| **Theorem L** (`∂_q(B) = [r^{⟨w,c⟩e_b − ⟨w,e_b⟩c}]`, `B ≠ 0`) | **(a)** — re-derived here from the tame symbol and reproduced at 2000/2000 random rays and (in `f55_f2f3.py`) at all 460 mixed-fan rays |
| **Theorem M** (`N_λ(ψa) = N_λ(a)^7`, `N_λ(r₂) = r^c`) | **(a)** — and it is the *refutation* of Theorem N (Theorem B′) |
| **Theorem N** (`λ_w(φ) ≡ −⟨w,c⟩` at every boundary orbit, "no freedom") | **(c) FAILS as an independent fact.** Corrected statement: `λ_w(φ) ≡ 7λ_w(div a) − ⟨w,c⟩` (★) — which contains no information, since it merely computes `λ_w(φ)` from `λ_w(div a)`. The *true* h-free boundary law is its 9-weighted twin, `L9_w(φ) ≡ −⟨w,c₉⟩` = **Theorem R** = congruence (3) |
| "φ's boundary λ-invariants carry NO freedom; the pattern lies outside `Im(2+σ̃)` where `⟨w,c⟩ ≢ 0`" | **(b)** — the correct version: `pattern_w(φ) + pattern_w(r₂) ∈ Im(2+σ̃)` always, and the boundary pattern of `φ` lies outside `Im(2+σ̃)` exactly where `⟨w,c₉⟩ ≢ 0` |

### §8.15 — the per-ray collapse
| item | verdict |
|---|---|
| **Theorem O**, residue formula `∂_q(cores(x,b)) = [ℓ(N_λ(x))^{⟨w,e_b⟩}ℓ(b)^{−λ_w(x)}]` | **(a)** — correct |
| **Theorem O**, "the per-ray equation cancels except for `[ℓ_w(b)]^{7λ_w(a)} ≡ 1`" | **(c) FAILS** — it cancels *completely* (Theorem C). The leftover exists only because Theorem N was substituted |
| **(iv′)** the uniform law `λ_O(div a) ≡ 0` at every orbit | **(c) FAILS** — no derivation survives |
| **Theorem P** (`cores(a,b) = cores(ψ*(a), r^x)`) | **(b)** — ψ and ψ* interchanged: correct form is `e_b = (2+σ^{-1})x`, `x = (0,2,−3,2,0)`, `cores(a,b) = cores(ψ(a), r^x)`. In this corrected form it is an **identity** (`f55_f2f3.py` §7: 0/1288 failures, 6/6 perturbation controls break it), so **(F3) constrains nothing** — as it must, since `cores(a,b)` computed two ways is one class computed twice |
| the consolidated system **(F1)–(F4)** | **(b)** — (F1), (F4) stand; **(F2) is struck**; (F3) is struck as vacuous. What remains from the Brauer layer is *already inside* (F1)/(F4) as congruence (3) |

### §8.16 — the crux polytope question
| item | verdict |
|---|---|
| **Theorem Q** and the boundary pattern `(2g_i + g_{i−1} − ⟨σ^i w,e₂⟩)` | **(a)** — the ray index, consistent with all later code |
| 0-dimensional `Q` fails; σ-invariant `Q` fails identically | **(b)** — the reason given, "`(2+σ)t`-solvability i.e. `λ(e₂) ≡ 0`: FALSE (λ(e₂)=3)", uses the wrong functional. Corrected: the obstruction is `L9(e₂) = 4 ≢ 0`; the conclusion is unchanged |
| "the exact solution is the non-lattice point `(2+σ)^{-1}e₂` with denominator exactly 11" | **(a)** — `(2+σ_M)` acts on the ε-eigenline of `Λ⊗F₁₁` by `2+ε`, zero only at `ε = 9`, and `e₂` has a nonzero `ε=9` component |
| "**Two distinct 11-covers**" (`adj(2+σ)e₂ ≢ unit·e_b mod 11`) | **(c) FAILS — new finding F-5.** `adj(2+σ_M)e₂ = G(σ_M)e₂ = (−2,1,16,−8,4) ≡ 8·e_b (mod 11, diag)`, and `11·(2+σ_M)^{-1}e₂ = (−1,0,5,−3,1) ≡ 10·e_b`. Both escape hatches live on **one** cover `Λ′ = Λ + Z(e_b/11)`. Consistent with §8.19/§8.24, where the `G₉`-fan and the `e_b`-fan behave identically (`e_b ≡ 8G₉ + 5·diag`, `c₉ = 4G₉` — both COMPUTED, probe §E3) |
| "interior bits are free" (`11e₀` satisfies (F1) and (F2)) | **(a)** — true for both functionals |

### also confirmed from the probe
- **F-4** (well-posedness): Theorem O's factor `[ℓ_w(b)]^{…}` is
  uniformizer-dependent unless `⟨w,e_b⟩ ≡ 0 (mod 11)`; the *strict* b-split
  criterion ("`b|_{D_w}` an 11th power") requires `e_b ∈ 11Λ`, which is false
  (`e_b ≡ (2,1,7,4,0)`), so **(iv′)'s exemption never fires at the boundary**.
  **CITED** from `f55_f2f3.py` §3, re-checked here. Now moot, since (iv′) is gone.

---

## 5. THE DECISIVE QUESTION: CAN (F2) BE RE-DERIVED?

The question is whether there is an **independent reason** for the residue of
`A_K = cores(φ,b)` to vanish at split orbits. Answer: **no, and the obstruction
is a one-line eigenvalue computation.**

**Theorem D (the eigen-exhaustion no-go).** Let `n ∈ {3,11}` and let
`β ∈ E*/(E*)^n`. Since `gcd(5,n) = 1`, `E*/(E*)^n` is a **semisimple**
`F_n[⟨σ⟩]`-module; decompose `β` into σ-eigencomponents, `[σβ_ε] = [β_ε]^ε` with
`ε^5 = 1`. Using `cores_{E/K} ∘ σ_* = cores_{E/K}` and bilinearity:

    cores(σa, β_ε) = cores(a, σ^{-1}β_ε) = ε^{-1}·cores(a, β_ε),
    cores(ψa, β_ε) = (2 + ε^{-1})·cores(a, β_ε),
    cores(φ,  β_ε) = (2 + ε^{-1})·cores(a, β_ε) − cores(r₂, β_ε).       (†)

Consequently:

Write `Λ_ε(y) := Σ_i ε^{-i} ord_{σ^i P}(y)` for the residue functional of `β_ε`
at a split orbit (Theorem A′ with `b` replaced by `β_ε`; note `Λ_ε ∘ ψ =
(2+ε^{-1})Λ_ε`, the same factor — the two computations agree). Then:

1. If `2 + ε^{-1} ≢ 0 (mod n)`, (†) **defines** `cores(a,β_ε)` in terms of `φ`
   and constrains nothing. The would-be constraint at a split interior orbit is
   "`cores(φ,β_ε)` is unramified there", i.e. `(2+ε^{-1})Λ_ε(div a) ≡ 0`, i.e.
   `Λ_ε(div a) ≡ 0`. But the only route to that hypothesis is the right side of
   (†), whose first term `(2+ε^{-1})cores(a,β_ε)` is exactly as unknown as the
   left side. **This is the whole of the failure of Theorem K/(iv).**
2. If `2 + ε^{-1} ≡ 0 (mod n)`, the `a`-term is annihilated and
   `cores(φ, β_ε) = −cores(r₂, β_ε)` — an explicit class independent of `a`.
   Now the comparison is genuine, and gives, at every orbit where `β_ε` has
   nontrivial residue class: `Λ_ε(div φ) ≡ −Λ_ε(div r₂)`. In the interior
   `div r₂ = 0`, so `Λ_ε(div φ) ≡ 0`; at a boundary ray-orbit it reads
   `Λ_ε(div φ) ≡ −⟨w, Σ_i ε^{-i}σ_M^{-i}e₂⟩`. Both are precisely the statement
   `div φ + div r₂ ∈ Im(2+σ̃)` mod `n` at that orbit — i.e. **Theorem I(ii)** in
   the interior and **Theorem R / congruence (3)** at the boundary.

Finally, `2 + ε^{-1} ≡ 0` happens for exactly one `ε` in each case:
`n = 11`: `ε^{-1} = 9`, i.e. `ε = 5` (the eigenline spanned by `c`, **not** by
`e_b`, which has `ε = 9` and factor `2 + 5 = 7`);
`n = 3`: `ε^{-1} = 1`, the trivial component (`β ∈ K*`, giving
`N(φ)N(r₂) = N(a)³` — the mod-3 shadow, again an identity).
**PROVED-HERE**; **COMPUTED** (probe §D: the full 5-row table, and §D1, which
verifies `cores(φ, r^c) = −cores(r₂, r^c)` at 3000/3000 random rays for random
monomial `a`).

**Corollary D.1 (why the campaign paired against the wrong element).** `b` is
the Kummer generator of the 11-cover, but it lies in the `ε = 9` eigencomponent,
where the factor is the **unit** 7. Pairing `φ` against `b` therefore carries no
information about `φ`. The element that *does* carry information is
`b′ := r^c` (`ε = 5`, and `σ(r^c) = (r^c)^5·r^{−11(1,2,0,4,1)}` **exactly**,
COMPUTED probe §A5) — and what it yields is Theorem R, which the campaign
already had since §8.9.

**Corollary D.2 (the complete output of the Brauer layer).** For the object
`φ = ψ(a)/r₂`, the corestricted-symbol layer outputs exactly:
- interior split orbits: `Σ_i 9^i ord_{σ^i P}(φ) ≡ 0 (11)` and
  `Σ_i ord_{σ^i P}(φ) ≡ 0 (3)` — i.e. Theorem I(ii), automatic;
- interior inert primes: nothing (residue is a norm, an 11th power);
- interior ramified primes: none (Theorem K′(a));
- boundary ray-orbits: `L9_w(φ) ≡ −⟨w,c₉⟩` and its mod-3 twin — i.e.
  **Theorem R = congruence (3)**, which §§8.17–8.28 have been using all along.

No congruence on `λ_O(div a)` is among them. **(F2) is not obtainable from the
Brauer/Gersten layer.**

### 5.1 Routes considered and rejected (record of the attempt)

| route | status |
|---|---|
| choose a different σ-eigen Kummer element | dead by Theorem D — exhaustive over all `ε` |
| non-eigen `β` | dead — `cores` is bilinear and the module is semisimple, so it is a sum of the above |
| non-monomial `β` (a function with a divisor) | dead for the same reason: the *only* leverage is the factor `2+ε^{-1}`, which depends on `ε` alone, not on whether `β` is a monomial |
| "`A_K` unramified everywhere ⟹ `A_K = 0` (K rational)" | dead: the only class with unconditional interior unramifiedness is the `ε=5` one, and it *is* ramified at the boundary — `∂_q(cores(r₂^{-1},r^c)) = −6·∂_q(B)` exactly (because `c₉ = 6e_b`), nonzero at 2974 of 3000 sampled rays [COMPUTED, probe §D2] — so there is no vanishing conclusion; and even if there were, the `a`-term has already dropped out |
| Gersten/Faddeev codim-2 reciprocity as an extra equation | dead: those relations hold automatically for the residue system of any existing class; `A_K` exists |
| use trace-zero (Theorem I(i)) multiplicatively | **OPEN but unpromising.** `cores(φ,β)` depends only on `[φ] ∈ E*/(E*)^{11}`, while trace-zero is an additive, non-`(E*)^{11}`-invariant condition; multiplying `φ` by an 11th power preserves the symbol and destroys trace-zero. Theorem J is the order-level shadow of trace-zero and is already in (F1); its unit-level shadow (leading-coefficient cancellation at a twice-min) constrains `ℓ`, but there is still no independent evaluation of the class to compare against |
| mod-3 layer | dead: same computation, trivial component, gives `N(φ)N(r₂) = N(a)³`, an identity |

### 5.2 What is NOT claimed
- **(F2) is not disproved.** `λ_O(div a) ≡ 0` might still hold for some other
  reason; what is established is that the Brauer/corestriction layer does not
  imply it, and that the arguments in §§8.12–8.15 that appeared to imply it are
  each broken or vacuous. Status of (F2) as a *statement*: **OPEN**; status as a
  *derived constraint*: **DEAD**.
- Nothing here excludes a different arithmetic obstruction for `Φ`'s
  pointlessness (unramified cohomology of degree > 2, a specialization argument
  at rational points, the lifting gap of §8.9.1, …). Those are untouched.

---

## 6. WITNESS RE-TEST

**COMPUTED** (probe §F; the 14 recorded mixed-fan witnesses rebuilt through
`f55_qpreimage.py` sections 0–5, values read at all 460 rays):

| test | result |
|---|---|
| identity (★): `λ_w(φ) = 7λ_w(div a) − ⟨w,c⟩` | **1288/1288** witness×orbit pairs |
| **repaired Brauer condition** `L9_w(φ) ≡ −⟨w,c₉⟩` (= congruence (3)) | **1288/1288** — holds everywhere |
| Theorem N as printed / (F2) | 206/1288 (it fails, but nothing derives it) |

This independently reproduces `f55_f2f3.py`'s numbers (206/1288 = its
"206/1288 orbit-passes"; 92/92 on 14/14 for the 9-weighted law).

**Verdict: the 14 witnesses SURVIVE.** The condition the layer actually imposes
is the one they were built to satisfy. The `f55_f2f3.py` kill — which is
numerically sound, with verified Farkas certificates including the
hand-checkable `w = (−27,−12,13,13,13)`, `d = [9900,2310,4070,0,0]`,
`⟨w,c₉⟩ ≡ 0`, `⟨w,c⟩ ≡ 8`, so `(F2)` reads `0 ≡ 3` [CITED, and the arithmetic
re-checked here by hand] — is a kill by a **hypothesis that has no derivation**.

---

## 7. THE CORRECTED CONSOLIDATED SYSTEM (replaces §8.15's (F1)–(F4))

For a divisor datum `D = div(a)` on a smooth σ-stable toric compactification,
with `φ = ψ(a)/r₂`:

- **(F1)** trace-zero laws on `(2+σ̃)D − div(r₂)`: Theorem J twice-min at every
  orbit; jet recursion at σ-invariant primes (none, interior or boundary).
  *Unchanged.*
- **(F2′)** — replaces (F2): at every orbit, `L9_O(div φ) ≡ 0 (mod 11)` and
  `Σ_O ord ≡ 0 (mod 3)` in the interior; `L9_w(φ) ≡ −⟨w,c₉⟩` at the boundary.
  **These are automatic given `div φ + div r₂ ∈ Im(2+σ̃)`** — i.e. (F2′) is not
  an independent layer at all; it is Theorem I(ii) and Theorem R.
- **(F3)** — **struck.** Theorem P (corrected) is an identity.
- **(F4)** principality/polytope closure with the boundary `L9`-pattern of
  `(2+σ̃)D − div(r₂)` pinned to `−⟨w,c₉⟩`. *Unchanged (this is Theorem Q).*

So the four-part system collapses to **two** parts: (F1) + (F4), which is exactly
Theorem Q — and §8.28 established Theorem Q = YES on the mixed fan with an
explicit lattice polytope. **The arithmetic flank of the F55-NO programme is
therefore exhausted at the shadow-feasible/lifting wall, as §8.28 stated, and
the (F2) branch does not reopen it.**

Still open and untouched by all of this [CITED §8.28, §8.9.1]: the actual
existence of a trace-zero `φ` realising the shadow (the class-to-form lifting
gap), and hence **F55 itself and the headline `ed_C(PSL₂(F₁₁)) ∈ {3,4}`**.

---

## 8. REPRODUCE

```
python3 problems/E-klein-cubic/director_probes_20260806/f55_f2repair_adjudicate.py         # 27 s, 0 failures
python3 problems/E-klein-cubic/director_probes_20260806/f55_f2repair_adjudicate.py --fast  # 0.5 s, no witness re-test
python3 problems/E-klein-cubic/director_probes_20260806/f55_f2f3.py                        # ~2 min, the source probe
```

## 9. LABEL INDEX

- **PROVED-HERE**: Lemma 0, Lemma 0′ (with COMPUTED support), Lemma 1,
  Theorem A, Theorem A′, Theorem B, Theorem B′, Theorem C, Theorem D,
  Corollaries D.1/D.2, finding F-5.
- **CITED**: §8.9 (`T_i`, `μ_i`, IX-c), §8.10 (`e_b`, Theorem H, Theorem I),
  §8.11 (Theorem J, IX-d), §8.12 (items 1–5), §8.13 (K′), §8.14 (L, M, N, `c`),
  §8.15 (O, P, (F1)–(F4)), §8.16 (Q), §8.17 (R, `c₉`), §§8.26–8.28 (IX-j, IX-k,
  the 14 witnesses), §8.29/IX-m (the finding under adjudication).
- **COMPUTED**: `f55_f2repair_adjudicate.py` (this session, 0 failures);
  `f55_f2f3.py` (source probe, rerun this session, output archived).
- **OPEN**: whether `λ_O(div a) ≡ 0` is *true* for some other reason (§5.2);
  whether the trace-zero condition has any multiplicative shadow (§5.1, last
  row); F55 and the headline.

## 10. GAPS IN THE RESULT, STATED IN THE RESULT

- Theorem D is a no-go **for pairings of the shape `cores_{E/K}(φ, β)_n`,
  `n ∈ {3,11}`** — the shape §§8.11–8.15 use. It does not prove that no
  arithmetic obstruction to `Φ`'s solubility exists.
- Theorem A′'s sign conventions for the tame symbol are not tracked (they are
  irrelevant to every vanishing statement made, and the calibration against
  Theorem L fixes the normalisation empirically at 460/460 rays).
- The witness re-test is scoped exactly as `f55_f2f3.py`'s was: **boundary only**
  (the polytope `Q` fixes `v_w(a)` at the 460 rays and says nothing about the
  interior of `div(a)`), **the mixed fan only**, **the 14 recorded patterns
  only**. This scope limitation does not affect §5, which is a derivation.
