# SMITH_I3 — the semistability prefilter (I3) and the Smith mod-p congruences (F2/F3)

**Packet:** `goal_runs_20260812/SMITH_I3/` · opened 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

Executed against `DATA_SPEC_SMITH_I3_20260812.md` (director-pinned semantics),
with `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.2 (F2/F3), its Group I
item I3, and its §6 as the mathematical authority. Where the spec and the
files diverge the divergence is FLAGGED in §7 and the branch is stopped, not
patched by judgement.

*(Filename note: main document is `THEOREM.md`; the harness refuses
`REPORT.md`.)*

## Exit ledger

```text
SMITH-I3-ANCHORS-PASS
SMITH-I3-SEMISTABILITY-THEOREM
SMITH-I3-SUPPORT-TEST-EXACT
SMITH-I3-EIGENBASIS-COROLLARY
SMITH-I3-PIPELINE-VERDICT-SUBSUMED
SMITH-I3-ORDER11-CONGRUENCE
SMITH-I3-ORDER5-CONGRUENCE
SMITH-I3-ORDER2-DICHOTOMY
SMITH-I3-ORDER3-PARAMETRIC
SMITH-I3-MENU-UNCOLLAPSED
SMITH-I3-SPEC-DIVERGENCE-FLAGS
SMITH-I3-NO-DEGREE-EXCLUSION
```

Machine markers: `SMITH_I3_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **95 checks, 0 failures, 0 skips**; groups
A = 10, B = 50, C = 35). Exact integer / rational arithmetic throughout;
`python3` standard library only, plus `numpy` solely to read two sealed
`.npy` arrays.

---

## 0. What is and is not claimed

**Claimed.** (i) The Kempf argument for I3, written out. (ii) An exact
Hilbert–Mumford support test in the pinned convention, with both calibration
anchors passing. (iii) The verdict on where I3 bites: **SUBSUMED**, with the
exact locations. (iv) Two closed Smith congruences at d = 35 — order 11 and
order 5 — and one closed order-2 branch, all constant across the full F_odd
menu. (v) A parametric order-2 second branch and a parametric order-3 result,
with the blockers named.

**Not claimed.** See §8. In particular: nothing here cuts any of the 22 live
d = 35 cells, and no degree is excluded.

---

## 1. Conventions, pinned

Following `DATA_SPEC_SMITH_I3_20260812.md` §1 verbatim.

A tuple `T ∈ Sym^d W* ⊗ W`, `W = C^5`, has monomial support the set of pairs
`(α, c)` with `α ∈ Z^5_{≥0}`, `|α| = d`, `c ∈ {0,…,4}`: the seed
`s = X^α e_c`. This is exactly the compiler's encoding
(`goal_runs_20260811/D34_GUIDED_SWEEP/slicelib.py:302-314`, `jet_rows`
docstring: *"For each seed s = X^alpha e_{c0} …"*; `layer0_A_p331.npy` rows
are the `α`, `layer0_C_p331.npy` entries the `c`).

A 1-parameter subgroup is an integer weight vector `r ∈ Z^5` with `Σ r_i = 0`
acting by `x_i ↦ t^{-r_i} x_i` (so `e_i ↦ t^{r_i} e_i`). The **weight** of a
support element is

```
        wt(α, c)  =  ⟨r, α⟩ − r_c .
```

`T` is **UNSTABLE** iff some `r` makes `wt` strictly positive on *every*
support element; **SEMISTABLE** otherwise.

**Disambiguation, load-bearing.** The record overloads `E_σ`. Throughout this
packet:

| symbol | meaning | χ |
|---|---|---|
| `E^X_σ` | receiver: the smooth plane cubic `X ∩ P(W^+)`, genus 1, `j = 8192/11`, non-CM | 0 |
| `L^X_σ` | receiver: the line `P(W^-) ⊂ X` | 2 |
| `P_σ` | source: the plus-plane `P(W^+) ≅ P²` | 3 |
| `L'_σ` | source: the minus-line `P(W^-) ≅ P¹` | 2 |
| `D_{P_σ}`, `D_{L'_σ}` | source: their exceptional divisors on the terminus `Z` | — |

This packet never writes a bare `E_σ`.

---

## 2. The exact support test

**Reformulation (Gordan).** Put `w(α,c) := α − e_c ∈ Z^5`, so
`wt = ⟨r, w⟩`, and note `Σ_i w_i = d − 1` for every support element. By
Gordan's theorem, a system `⟨r, w⟩ > 0` (all `w ∈ S`) with `r` in the
hyperplane `{Σ = 0}` is solvable iff `0 ∉ conv(π S)` for `π` the orthogonal
projection to that hyperplane. Equivalently:

> **`T` is SEMISTABLE ⟺ the barycentric target `t := ((d−1)/5)·(1,1,1,1,1)`
> lies in `conv{ α − e_c : (α,c) ∈ supp T }`.**

That membership is decided by an exact Phase-I simplex over `Fraction`
(Bland's rule, so no cycling): minimise `Σ` artificials subject to
`Σ_j λ_j w_j = t`, `Σ_j λ_j = 1`, `λ ≥ 0`. Optimum `0` ⟹ semistable, with
the convex combination printed as certificate. Optimum `> 0` ⟹ unstable, and
the Phase-I dual `y = (r, s) ∈ Q^6` obeys `⟨r,w_j⟩ + s ≤ 0` for all `j` and
`⟨r,t⟩ + s > 0`; replacing `r` by `r' := r − (Σ_i r_i / 5)·(1,…,1)` and
taking `−r'` scaled to primitive integers yields an explicit integer
destabilising 1-PS with all weights strictly positive. Implementation:
`scripts/i3_semistability.py`. **No floating point is used anywhere.**

### 2.1 The two calibration anchors — BOTH PASS (check group A)

Per the spec, nothing may use the test until both anchors pass.

**Anchor (i): `F·x` must be SEMISTABLE.** `F = Σ_i x_i² x_{i+1}` (indices mod
5); the tuple `F·x` has `c`-th coordinate `F·x_c`, so its support is
`{(α_F + e_c, c)}` over the five monomials of `F` and the five `c`, `d = 4`,
`|supp| = 25`. **Verdict: SEMISTABLE.** The convex certificate is exact and
maximally clean — `λ = 1/5` on the five diagonal elements `(α_F + e_c, c)`
with `c` the leading index of `α_F`:

```
 (1/5) Σ_{i∈Z/5} (2e_i + e_{i+1})  =  (3/5)·(1,1,1,1,1)  =  t   at d = 4.
```

**Anchor (ii): `x_0^d e_0` must be UNSTABLE, destabilised by
`r = (4,−1,−1,−1,−1)`.** The support is the single vector `w = (d−1)e_0`,
whose hull is one point, never the barycentre. **Verdict: UNSTABLE.** The
test *finds* `r = (4,−1,−1,−1,−1)` — exactly the pinned destabiliser — with
minimum weight `4(d−1) = 136` at `d = 35`. The anchor also runs at `d = 4`
(still UNSTABLE), so the verdict is not an artefact of the degree.

Group A additionally checks that `r` is traceless, that the coded weight
equals `⟨r,α⟩ − r_c` on the anchor, and that the `F`-monomials are the five
`x_i²x_{i+1}`. **A1–A10 all PASS.** The sign convention is therefore the
pinned one and everything below is licensed.

---

## 3. The theorem (I3), packet-grade

> **Theorem I3.** Let `G = PSL(2,11)` act on `W = C^5` through one of its two
> 5-dimensional irreducible representations. Every nonzero `G`-covariant
> `T ∈ M_d = (Sym^d W* ⊗ W)^G` is a semistable point of
> `P(Sym^d W* ⊗ W)` for the `SL(W)`-action.

*Proof.* Suppose `T` is unstable. By Kempf's instability theory `[EXT: Kempf,
*Instability in invariant theory*, Ann. of Math. 108 (1978)]`, the set of
1-PS maximising the normalised Hilbert–Mumford function at `T` is nonempty
and determines a **canonical** parabolic subgroup `P(T) ⊆ SL(W)`, the
*optimal destabilising parabolic*, together with an optimal class of 1-PS
inside it, unique up to conjugacy by `P(T)`. Canonicity means functoriality
in the point: for every `g ∈ SL(W)`, `P(g·T) = g P(T) g^{-1}`.

`G` fixes `T` (it is a covariant, so `g·T = T` for all `g ∈ G ⊂ SL(W)`;
`G ⊂ SL(W)` because `G` is perfect and hence has no nontrivial characters,
so its 5-dimensional representation lands in `SL`). Hence
`g P(T) g^{-1} = P(T)` for all `g ∈ G`, i.e. `G ⊆ N_{SL(W)}(P(T)) = P(T)`,
the last equality because a parabolic is its own normaliser. A parabolic
subgroup of `SL(W)` is by definition the stabiliser of a proper flag
`0 ⊊ W_1 ⊊ … ⊊ W`, so `G` preserves a proper nonzero subspace `W_1 ⊂ W`.
That contradicts the irreducibility of `W` as a `G`-module. Therefore no
optimal destabilising parabolic exists, i.e. `T` is semistable. ∎

*Trust tag:* `[T1]` + `[EXT]` (Kempf). Every input is named: Kempf's
uniqueness/canonicity, self-normalisation of parabolics, and irreducibility
of `W`.

**Corollary I3′ (the support form).** For every integer weight vector `a`
with `Σ a_i = 0`,

```
   min_{(α,c) ∈ supp T} ( ⟨a, α⟩ − a_c )  ≤  0  ≤  max_{(α,c) ∈ supp T} ( ⟨a, α⟩ − a_c ),
```

equivalently `((d−1)/5)·(1,1,1,1,1) ∈ conv{α − e_c}`. (Apply the theorem to
`a` and to `−a`.)

### 3.1 The eigenbasis instance, evaluated (`SMITH-I3-EIGENBASIS-COROLLARY`)

I3′ becomes a two-sided *level* condition in a `C11`-eigenbasis, which is the
form in which it costs nothing on any residue-enumerated support.

Let `v ∈ Z^5` be integer representatives of the `C11`-characters of `W`.
`C11`-equivariance of `T` forces every support element to satisfy
`⟨v, α⟩ − v_c ≡ 0 (mod 11)`; write that quantity as `11k` and call `k` the
**level** of the support element. Take the traceless integer 1-PS
`r := 5v − (Σ v)·(1,…,1)`. Then

```
   wt(α,c)  =  5·(11k) − (Σ v)·(d − 1) ,
```

so I3′ says the support must contain a level with `55k ≤ (Σ v)(d−1)` and one
with `55k ≥ (Σ v)(d−1)`. Evaluated (`results/i3_scan.json`):

| frame `v` | `r` | `d` | needs a level `k ≤` | and a level `k ≥` | attainable `k` range | vacuous? |
|---|---|---:|---:|---:|---|---|
| `(1,3,4,5,9)` (the QR frame; `Res W` characters `ζ^r`, `r ∈ {1,3,4,5,9}`) | `(−17,−7,−2,3,23)` | 34 | 13 | 14 | `[3, 27]` | **no** |
| `(1,3,4,5,9)` | `(−17,−7,−2,3,23)` | 35 | 13 | 14 | `[3, 28]` | **no** |
| `(2,6,7,8,10)` (the other generator) | `(−23,−3,2,7,17)` | 34 | 19 | 20 | `[6, 30]` | **no** |
| `(2,6,7,8,10)` | `(−23,−3,2,7,17)` | 35 | 20 | 21 | `[6, 31]` | **no** |

Both frames give genuine (non-vacuous) two-sided conditions, and they are
independent linear functionals, so a residue-enumerated support must straddle
*both* thresholds. The `C11` weight set is read machine-readably from
`RECEIVER_LEDGER_X/results/ledger_exact.json` and is exactly the quadratic
residues mod 11 (check `B4`, `B39`).

---

## 4. Where I3 bites — verdict **SUBSUMED**, with locations

The spec pins the places to check and pins the verdict shape. All readings
below are first-hand at the cited line.

| stage | file:line | what it emits | class |
|---|---|---|---|
| seed generation | `goal_runs_20260811/D34_GUIDED_SWEEP/slicelib.py:276-299` (`seed_exponents`) | raw single monomials `(α, c0)`, deterministic pseudo-random compositions | **b** raw |
| basis construction | `goal_runs_20260811/D34_GUIDED_SWEEP/produce_d34.py:90-109` (`basis_seeds`) | the kept `(α, c0)` pairs `kA, kC` | **b** raw |
| symmetrisation | `goal_runs_20260811/D34_GUIDED_SWEEP/slicelib.py:302-314` (`jet_rows`) | `R(s)(v) = Σ_g ρ(g)^{-1} s(ρ(g) v)` | **a** covariant |
| stored d = 35 seeds | `goal_runs_20260811/PAIR_ATTACK_D35/results/layer0_A_p331.npy`, `layer0_C_p331.npy` | 637 raw `(α, c)` of degree 35 | **b** raw |
| audit / landing re-implementations | `D35_AUDIT/scripts/reynolds.py:18`, `D35_LANDING/scripts/landlib.py:64` | same pattern: raw seed in, Reynolds sum at evaluation | **b → a** |
| RT lane | `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/`, `AMBIENT_HODGE_REES_BRIDGE/RESTRICTED_TRANSFER.md` | *nothing monomial*: "restricted" there means restriction of a Hodge module from ambient `P⁴` to `X` | n/a |
| ansatz searches | `REMAINING_GOALS_NOTE.md:71` (COV structured, terminal); `SPEC.md:588` | invariant-**coefficient** ansätze — already equivariant | **a** |
| the sibling prefilter C13 | `goal_runs_20260811/PAIR_ATTACK_D35/scripts/layer0_base.py:11,201` | records `"C13": "automatic (Reynolds G-orbit support on seeds)"` | **a** |

**Verdict.** Every stage that *tests* an object tests a Reynolds image
`R(s)`, a `G`-covariant by construction; by Theorem I3 every nonzero
`G`-covariant is semistable, so **the I3 prefilter is vacuous on every object
the pipeline handles.** It is subsumed in exactly the slot C13 already
occupies at `layer0_base.py:201`. **No pipeline stage admits a non-semistable
candidate tuple.**

**Where unstable supports do appear, and why that is correct.** The seed
enumerators do emit unstable supports, and at `d = 34` and `d = 35` they emit
*nothing else*:

> **Fact (checked, `C27`/`C28`).** A single-monomial tuple `x^α ⊗ e_c` is
> semistable iff `α − e_c = ((d−1)/5)(1,1,1,1,1)`, which requires `5 | d−1`.
> So at `d = 34` and `d = 35` **every** single-monomial seed is unstable; the
> first nearby degree with semistable single monomials is `d = 36`, where
> exactly five exist: `x^{(7,7,7,7,7)} x_c ⊗ e_c`, `c = 0,…,4`.

Run on the actual stored arrays: **637 / 637 of the sealed `d = 35` layer-0
seeds are UNSTABLE, 0 semistable** (`C31`). This is not a leak — a seed is an
argument of the Reynolds operator, never a candidate tuple. The correct
reading is the spec's: I3 is a *necessary and currently vacuous* condition,
registered as such.

**The one live consumer, and it is empty today.** I3 acquires content only
where a support is enumerated by a *residue* condition rather than produced
by the Reynolds operator — the eigenbasis corollary of §3.1. No current stage
runs such an enumeration at `d = 35`, so the corollary has no consumer today.
It is recorded as the L16 executable specification.

---

## 5. F2/F3 — the Smith congruences at d = 35

**Lemma (Smith).** `[EXT]` For `g` of prime order `p` acting on a complex
quasi-projective `Y`, `χ_c(Y) ≡ χ_c(Y^g) (mod p)` (the free part fibres in
`p`-orbits; `χ_c` is additive). Applied to a fibre with `Y` projective, and
using `(q^{-1}x)^g = (q|_{Z̃^g})^{-1}(x)`:

```
   F2 :  χ(q^{-1}(x))  ≡  χ( (q|_{Z̃^g})^{-1}(x) )   (mod p),   x ∈ X^g.
   F3 :  χ(Z̃^g)  =  Σ_{strata Y ⊆ X^g}  ∫_Y χ(fibre^g).
```

Receiver constants and census values are consumed **by citation**
(`scripts/constants.py` carries provenance for each; check group B re-reads
every machine-readable one and cross-checks the rest):

| constant | value | source |
|---|---|---|
| `χ_top(X^g)`, orders 1,2,3,5,6,11 | `−6, 2, 6, 4, 2, 5` | `RECEIVER_LEDGER_X/THEOREM.md` §6.1 (topological Lefschetz table) |
| `X^σ` split | `E^X_σ (χ 0) ⊔ L^X_σ (χ 2)` | same, §6.1 |
| `X^g` for orders 3,5,6,11 | `6, 4, 2, 5` isolated points | `ledger_exact.json` rows, `X_points` |
| components of `Z^H`, one fixed `H` | `C2 239, C3 80, V4 54, C5 20, C6 38, C11 20` | `TERMINUS_STRATA_PW/THEOREM.md` §2 |
| the same, by dimension | `C2 {0:146,1:80,2:11,3:2}`, `C3 {0:62,1:16,2:2}`, `C5 {0:20}`, `C6 {0:38}`, `C11 {0:20}` | `TERMINUS_STRATA_PW/results/t2_strata.txt`, DICTIONARY block |
| every stratum of `Z` is rational | — | `TERMINUS_STRATA_PW/THEOREM.md` §1 |
| three rows surject onto `L_σ`, no other row forced non-constant | — | `STAGE1_COMPLEX_MAPS/THEOREM.md` Thm 3 |
| residual `C5` on `X^{C11}` | `[2,0,3,4,1]`, a 5-cycle | `ledger_exact.json` `detail.C11` |
| residual `C2` on `X^{C5}` | `[0,4,3,2,1]`: orbits `{1,4}`, `{2,3}` | `ledger_exact.json` `detail.C5` |

**Blowup delta, pinned form (used only where a refinement is discussed).**
Blowing up a `g`-stable centre `Y` with normal bundle `N` changes `χ(Z^g)` by
`χ(Y^g)·(χ(P(N)^g_fibre) − 1)`; for an isolated centre `χ(P(N)^g_fibre)` is
the number of eigen-directions of `N`. The wonderful centre inventory
(`t3_localmodels.txt` §1: 10 point orbits summing to 940, 3 line orbits
summing to 220, 1 plane orbit of 55; 1215 divisors in 14 orbits) is recorded
in `constants.py` for the refinement bookkeeping.

### 5.1 Two structural lemmas

> **Lemma U (order-11 uniformity).** Let `Z̃` be any smooth `G`-equivariant
> model dominating `P(W)` on which `q` is a morphism. (a) `Z̃^{C11}` is
> **finite**. (b) `n_x := #(q|_{Z̃^{C11}})^{-1}(x)` is **constant** over
> `x ∈ X^{C11}`. Consequently `5 | #Z̃^{C11}` and `n_x = #Z̃^{C11}/5`.

*Proof.* (a) `W` carries five **distinct** `C11`-characters, so at each of
the five `C11`-fixed points of `P(W)` the four tangent weights are distinct.
Blowing up a `C11`-stable smooth centre through such a point produces an
exceptional projectivised normal space whose `C11`-fixed locus is the set of
projectivised weight eigenlines — again isolated, again with pairwise
distinct weights. The property is inherited at every stage, and
`Z̃^{C11} → P(W)^{C11}` (five points) has image in those five points.
(b) `N_G(C11) = C11{:}C5` acts on both sides and `q` is equivariant; the
residual `C5` acts on the 5-point set `X^{C11}` as the 5-cycle
`[2,0,3,4,1]` (sealed, check `B7`/`B9`), hence transitively. All fibres of an
equivariant map onto a transitive set have equal cardinality. ∎

> **Lemma R (no rational source dominates `E^X_σ`).** No component of `Z^σ`
> dominates `E^X_σ`.

*Proof.* Every stratum of `Z` is rational (sealed, per row). If an
irreducible `V ⊆ Z^σ` dominated `E^X_σ`, compose a dominant rational map
`P^n ⇢ V` with `q` and restrict to a general line: `E^X_σ` would be the
image of a dominant rational map from `P^1`, hence rational by Lüroth —
contradicting genus 1 (`j = 8192/11`, non-CM, sealed). ∎

### 5.2 Order 11 — CLOSED

`Z^{C11}` = 20 points (census; four `G`-orbits of 60, `#/fixedK = 5` each,
all dim 0, in `E_{C11}`). By Lemma U, `n_x = 20/5 = 4` at every one of the
five `C11`-fixed points of `X`. Hence

> **`χ(q^{-1}(x)) ≡ 4 (mod 11)` at each of the five `C11`-fixed points of
> `X`** — and, model-independently, **the five fibre Euler characteristics
> are congruent to one another mod 11**, since `n_x` cannot depend on `x`.

F3 closes exactly: `Σ_{x} n_x = 5·4 = 20 = χ(Z^{C11})`.

On a further equivariant model, `#Z̃^{C11} = 20 + Δ` with `5 | Δ` and
`n_x = 4 + Δ/5` — the *equality among the five* congruences survives every
refinement; only the common residue moves.

**Menu behaviour.** The `C11` menu has 10 entries. Reconstructed here from
the sealed master formula `w(R) = d·a_k + Σ μ_l c_l (mod n)` with
`base = 9`, `chain ∈ {3,5,6,7}`, `d = 35`, and matched **exactly** against
`vectors_d35.json` (check `B25`), recovering the `μ`-label of each entry:

| `μ` | `c=3` | `c=5` | `c=6` | `c=7` | # defined |
|---:|---|---|---|---|---:|
| 1 | UNDEF | `eigpt(1)` | UNDEF | `eigpt(3)` | 2 |
| 2 | UNDEF | UNDEF | UNDEF | UNDEF | 0 |
| 3 | `eigpt(5)` | UNDEF | `eigpt(3)` | UNDEF | 2 |
| 4 | UNDEF | `eigpt(5)` | `eigpt(9)` | UNDEF | 2 |
| 5 | UNDEF | UNDEF | `eigpt(4)` | `eigpt(9)` | 2 |
| 6 | `eigpt(3)` | `eigpt(4)` | UNDEF | `eigpt(5)` | 3 |
| 7 | UNDEF | `eigpt(9)` | `eigpt(5)` | `eigpt(1)` | 3 |
| 8 | `eigpt(9)` | `eigpt(3)` | UNDEF | UNDEF | 2 |
| 9 | `eigpt(1)` | UNDEF | UNDEF | `eigpt(4)` | 2 |
| 10 | `eigpt(4)` | UNDEF | `eigpt(1)` | UNDEF | 2 |

(`35 ≡ 2 (mod 11)` and 2 is a non-residue, so `μ ≥ 1` and the menu has
exactly 10 entries — the sealed count.) The menu entry decides **which** row
lands on which receiver point; it never changes `n_x`. Two consequences worth
recording:

* **the congruence is constant across all 10 entries** (check `C6`), so it
  holds for all `22 × 36 252 160` (cell, menu-entry) pairs at once;
* **the maximum number of defined `C11` rows over the whole menu is 3, never
  4** (check `C7`) — an independent reproduction of
  `STAGE2_ODD_ORDER_PINNING` Thm 2.1 ("if `d` is a non-residue, at most three
  of the four can carry a value"). At `d = 35` the order-`μ` value assignment
  is therefore never total on the `C11` block.

### 5.3 Order 5 — CLOSED

`X^{C5}` = 4 points (weights 1,2,3,4; the weight-0 `D10`-point is **off** `X`).
The residual `C2 = D10/C5` acts by `w ↦ −w`, giving **two** orbits `{1,4}`
and `{2,3}` — so Lemma U is unavailable and the count is done row by row.

`Z^{C5}` = 20 points. The ten immune `C5` rows each have `ncomp = 132`; `G`
has 66 conjugate `C5`-subgroups, so each row contributes `132/66 = 2`
components for one fixed `C5`, and `10 × 2 = 20` reproduces the census.
Because `5 | 35`, the base term `d·a_k` vanishes mod 5 for every row and the
receiver weight is simply `w = μ·c (mod 5)`; the sealed constraint `5 ∤ μ`
gives `μ ∈ {1,2,3,4}` — the sealed menu sizes `C5a 4`, `C5b 4`, `D10 4`,
reproduced exactly here (check `B26`).

Each row deposits one point over `x_w` and one over `x_{−w}`. As `c` runs
`1..4` with `μ` fixed and coprime to 5, `w = μc` runs over all of `1,2,3,4`,
so each of the `(a)` and `(b)` blocks deposits **2** points over every
receiver point; the two `D10` rows deposit `{μ₀, −μ₀, 2μ₀, −2μ₀} = {1,2,3,4}`,
i.e. **1** each. Hence, for **all 64** `(μ_a, μ_b, μ_0)` menu entries:

> **`n_x = 5` at every one of the four `C5`-fixed points of `X`, so
> `χ(q^{-1}(x)) ≡ 0 (mod 5)` there.**

F3 closes exactly: `4 × 5 = 20 = χ(Z^{C5})`.

*Free cross-check, order 6 (not prime, so F2 does not apply).* `X^{C6}` = 2
points exchanged by the residual `C2` of `D12/C6`, so `n_x = 38/2 = 19` and
F3 closes: `2 × 19 = 38 = χ(Z^{C6})`. Recorded as an F3 consistency row only;
no mod-p claim is made at order 6.

### 5.4 Order 2 — one branch CLOSED, one PARAMETRIC

`X^σ = E^X_σ ⊔ L^X_σ` with `χ = 0 + 2 = 2`.

**Over `E^X_σ` — CLOSED.** By Lemma R no component of `Z^σ` dominates
`E^X_σ`, so `(q|_{Z^σ})^{-1}(x) = ∅` for all but finitely many `x ∈ E^X_σ`,
and Smith at `p = 2` gives

> **`χ(q^{-1}(x)) ≡ 0 (mod 2)` for all but finitely many `x ∈ E^X_σ`.**

This is unconditional on `Z` and on every **admissible** refinement (all
admissible centres are rational, so Lemma R still applies).

**The escape, stated honestly and coupled.** On the actual (non-admissible)
model the escape is a σ-fixed **irrational** stratum dominating `E^X_σ`.
Group G forces some irrational centre to exist, so this branch is live, not
hypothetical. If it is the escape, that centre is exactly a G1 Hodge-carrier
at the `C2` row, where `Res_{C2} W = 3(+1) ⊕ 2(−1)` and the cheapest carrying
centre has `g ≥ 1` (`SCHEME_MAP_CONSEQUENCES` §3.3 table). Both branches are
carried; neither is claimed shut.

**Over `L^X_σ` — PARAMETRIC.** `L^X_σ ≅ P^1` is rational, so Lemma R is
silent. `STAGE1_COMPLEX_MAPS` Thm 3 pins exactly three rows as surjecting
onto `L_σ` — `D_{P_σ}`, `D_{L'_σ}`, and the central-involution line in
`E_{pt_{D12}}` — and states no other row is forced non-constant. Hence for
generic `x ∈ L^X_σ`

```
   χ(q^{-1}(x))  ≡  χ(F_1) + χ(F_2) + n_3   (mod 2),
```

with `F_1, F_2` the generic fibres of the two divisorial rows over `L^X_σ`
and `n_3` the degree of the third (1-dimensional) row over it. **No sealed
bound at `d = 35` pins any of the three** — `C1` of
`theory/CONSTRAINT_ADDITIONS_20260811.md` is a genus **identity** package
(`2g − 2 = 65ν + Σ(a_E − 2m_E)e_E`, `d·ν = Σ m_E e_E`) in unpinned
`a_E, m_E, e_E, ν`, not a numeric `g_max` (check `B38`). Per
`DATA_SPEC` §2 the menu is therefore reported **parametrically in χ**; no
bound is invented.

**Cell data.** All 22 live cells carry the *same* σ-band pattern:
`min_m = max_m = 1`, `m_options_L = [35]`, `m_options_P = [1]`,
`a35_L_options = [[35, 0]]`, `a35_P_options = [[34, 1]]` — i.e.
`ord_{L'_σ}(T) = 0` (the minus-line is **not** in the base locus) and
`ord_{P_σ}(T) = 1`. So the order-2 reading is identical across the 22.
(See the FLAG in §7.1: the spec expected these patterns to be *unique* per
cell.)

**F3 at order 2 — NOT closable here.** `χ(Z̃^σ)` needs the Euler
characteristics of the 11 surface and 2 threefold components of `Z^σ`; the
census fixes only their **counts by dimension** (`146/80/11/2`). Named
remainder, §7.3.

### 5.5 Order 3 — PARAMETRIC

`X^{C3}` = 6 points (each of the two `C3`-eigenlines cuts `X` in
`1` `C6`-point `+ 2` exact-`C3` points; the isolated weight-0 `D12`-point is
off `X`); `χ = 6`. `Z^{C3}` has 80 components for one fixed `C3`, of
dimensions `0 (62), 1 (16), 2 (2)`.

Because `X^{C3}` is finite, every component of `Z^{C3}` is contracted to a
single receiver point and

```
   χ((q|_{Z^{C3}})^{-1}(x))  =  Σ  χ(components sent to x).
```

Each component is smooth (fixed locus of a finite group on a smooth variety)
and rational, so each of the 16 curve components is `P^1` with `χ = 2`; the
two surface components have `χ = 2 + b_2` with `b_2` **not** pinned by the
census. Hence

```
   χ(Z^{C3})  =  62 + 32 + χ(S_1) + χ(S_2)  =  94 + χ(S_1) + χ(S_2),   χ(S_i) ≥ 3,
```

and the six mod-3 congruences are reported parametrically in that split. The
computed part: the `A4a × A4b` menu (`238 × 238 = 56 644` entries) is
classified by the multiset of receiver labels its 8 immune `C3` rows name,
with the UNDEF profile of each 238-entry list recorded in
`results/f2f3_congruences.json`. **Blocker named; nothing claimed.**

### 5.6 The 22 cells × the menu — nothing collapsed

There is **no** cell → menu-subset linkage anywhere in the record (searched;
see §7.2), so per `DATA_SPEC` §2 the **full** menu is admissible for **every**
cell: `22 × 36 252 160 = 797 547 520` (cell, menu-entry) pairs.

The menu is a Cartesian product of six independent centres
(`C11 10 × C5a 4 × C5b 4 × D10 4 × A4a 238 × A4b 238 = 36 252 160`, matching
the sealed `F_odd(35)`), and each order's result depends only on its own
factors. The report is therefore **factored, not collapsed**: for each order
we state the value on every entry of the relevant factor together with the
exact free multiplicity of the remaining factors, and
`covered × free-multiplicity = F_odd(35)` is checked for every reported
factor (check `C25`). Every one of the 797 547 520 pairs is covered and its
value stated:

| order | relevant factors | entries covered | free multiplicity | result on every pair |
|---|---|---:|---:|---|
| 11 | `C11` | 10 | 3 625 216 | `n_x = 4`, `χ(q^{-1}x) ≡ 4 (mod 11)`, all 5 points |
| 5 | `C5a·C5b·D10` | 64 | 566 440 | `n_x = 5`, `χ(q^{-1}x) ≡ 0 (mod 5)`, all 4 points |
| 2 | none (σ-band identical on all 22) | — | — | `E^X_σ` branch `≡ 0 (mod 2)`; `L^X_σ` branch parametric |
| 3 | `A4a·A4b` | 56 644 | 640 | parametric (blocker §5.5) |

The 22 cells are listed by `id` and `content_hash` at `p = 331` in
`results/f2f3_congruences.json`; ids
`5,7,13,15,21,23,29,31,37,39,45,47,53,55,61,63,69,71,697,699,701,703`,
matching the sealed `survivors22` block exactly (check `B31`/`B32`).

---

## 6. Verification

`python3 verifier.py` — **95 checks, 0 failures, 0 skips**;
`SMITH_I3_VERIFY_OK`, `ALLGREEN`.

| group | n | covers |
|---|---:|---|
| **A** | 10 | the two calibration anchors of `DATA_SPEC` §1, their certificates, the traceless/weight-formula conventions, the `F`-monomials, and the gate `all_pass` (if group A fails the verifier refuses to run B and C) |
| **B** | 50 | every receiver and census constant consumed: the sealed `ledger_exact.json` re-read (point counts, on-X weight sets, `C11` characters, both residual permutations and their transitivity/non-transitivity, the Sylow subgroup counts 12 and 66 and the row arithmetic 4x5 = 10x2 = 20), the `χ(X^g)` table line verbatim, the census file's `C11` rows and every `Z^H` dimension breakdown, `Every stratum is rational`, Thm 3, the F_odd menu file with its factorisation and product, the **rebuild of the C11 / C5a / C5b / D10 menus from the sealed master formula matching the sealed vectors exactly**, STAGE2 Thm 2.1's "at most three", the 756/22 split and the 22 hashes, the σ-band pattern, and `C1` carrying no genus bound |
| **C** | 35 | every congruence evaluation: order 11 (finiteness, `5 |` divisibility, `n_x = 4`, F3 exact closure, menu-constancy, the per-`μ` defined-row vector), order 5 (uniformity over 64 entries, `n_x = 5`, F3 exact closure), order 6 (F3 cross-check, no mod-p claim), order 2 (split, rationality input, both branches, the three dominating rows, the cell band reading), order 3 (parametric status + blocker), the per-cell × menu bookkeeping including `covered × free = F_odd`, and the I3 evaluations (single-monomial criterion at `d = 34,35,36`, both eigenbasis frames, the 637 stored seeds, the SUBSUMED verdict) |

Replay:

```sh
python3 scripts/constants.py            # constant cross-checks
python3 scripts/i3_semistability.py     # the two calibration anchors
python3 scripts/i3_pipeline_scan.py     # writes results/i3_scan.json
python3 scripts/f2f3_congruences.py     # writes results/f2f3_congruences.json
python3 verifier.py                     # writes results/verifier_output.json
```

Artifacts: `results/i3_scan.json`, `results/f2f3_congruences.json`,
`results/verifier_output.json`, `results/verifier_stdout.txt`.

---

## 7. Flags

### 7.1 Spec ↔ files divergence: the σ-band patterns are shared, not unique

`DATA_SPEC` §2 pins: *"each cell's σ-band pattern is UNIQUE (content-addressed
files …, the canonical 756/22; key by `sol_hash`)"*. The files say otherwise
on two counts, both machine-checked:

1. **The pattern is shared.** All 22 live cells carry the *identical*
   σ-band pattern and the *same* `group_key` `0bbfc90a9b60`
   (`m_options_L = [35]`, `m_options_P = [1]`,
   `a35_L_options = [[35,0]]`, `a35_P_options = [[34,1]]`,
   `min_m = max_m = 1`). What is unique per cell is the `content_hash`
   of the embedded finite-field data, not the σ-band pattern (check `B34`).
2. **There is no field named `sol_hash`.** `D35_AUDIT`'s per-cell identity
   fields are `content_hash` and `sealed_hash` (check `B36`). `sol_hash`
   appears only in the later `ARCJET_AUDIT` / `D35_EXTENDED_SIEVE` scripts,
   where it keys an unrelated depth menu.

**Action taken:** the cells are keyed by `(id, content_hash@p331)`, and the
σ-band datum is consumed as the shared pattern it demonstrably is. No branch
depended on per-cell σ-band variation, so nothing is stopped by this flag —
but the director should adjudicate the spec text before any packet *does*
depend on it. `content_hash` differs between `p = 331` and `p = 661` (the
hashes encode mod-p reduced embedding data); the *id* sets agree.

### 7.2 No cell → menu linkage exists

Searched: nothing in the problem directory maps a cell hash to a subset of the
`per_center` vectors. Per `DATA_SPEC` §2's instruction, the **full** menu is
treated as admissible for every cell, and this packet says so explicitly
(check `B37`). Every result above is stated per (cell, menu-entry) pair.

### 7.3 Named remainders (blockers, not failures)

* **`χ(Z^σ)` and `χ(Z^{C3})` are not determined by the census.** The census
  fixes component counts by dimension (`C2 {0:146,1:80,2:11,3:2}`,
  `C3 {0:62,1:16,2:2}`), not the Euler characteristics of the 11 surface /
  2 threefold components of `Z^σ` or the 2 surface components of `Z^{C3}`.
  So F3's global form is closed here only at orders 5, 6, 11 (where every
  component is a point). Closing orders 2 and 3 needs either the per-component
  models from `t2_strata.txt` promoted to closures, or the wonderful blowup
  delta run over the full 14-orbit centre inventory with its incidences.
* **No sealed genus bound binds at `d = 35`.** `C1` is an identity package.
  Every fibre unknown is therefore carried parametrically, per spec.
* **J1's disconnectedness branch is not assumed away.** This packet never
  needs `q`'s fibres to be connected: F2/F3 are holomorphy-free and
  connectedness-free. The `J1` hypotheses were therefore not checked and
  neither branch is assumed — nothing here is conditional on them.
* **Order 6 carries no mod-p claim** (6 is not prime); it is an F3 row only.

### 7.4 Zero / all-dead audit

Nothing in this packet returns a zero or an all-dead outcome (check `C33`):
`n_x = 4` and `n_x = 5` are positive at every receiver point, 22 cells remain
live, and every menu factor is non-empty. Had any been zero, the
ODDZERO-standard audit would have been mandatory before any claim; the check
is wired in so that a future replay cannot silently produce one.

---

## 8. Not claimed

* **No headline.** Problem E remains **OPEN**. This packet **excludes no
  degree** and cuts none of the 22 live `d = 35` cells.
* I3 is registered as a **necessary and currently vacuous** condition. No
  claim that it removes any candidate, any cell, or any degree. The
  eigenbasis corollary of §3.1 is non-vacuous as a condition but has **no
  live consumer** in the present pipeline.
* No claim that the 637 stored seeds being unstable is a defect. It is the
  expected and correct state (they are Reynolds arguments, not tuples).
* The order-11 and order-5 congruences are **necessary conditions on any
  realisation**, computed on the terminus `Z`; they are *not* shown to be
  violated by anything, and no realisation is exhibited or excluded.
* The order-2 result is claimed only in the stated branch structure. The
  `E^X_σ` half is claimed on `Z` and on admissible refinements only; the
  irrational-stratum escape is left open and is *expected* to be live given
  Group G.
* Order 3 is **parametric**; no numeric congruence is claimed there.
* `χ(Z̃^g)` for the *actual* model is not claimed at any order; only the
  census value on `Z` plus the pinned refinement delta shape.
* No transport-pairing claim, no `F_odd`/`G` recount, no correction to any
  sealed number. `GLOBAL_COHERENCE`'s ×2 correction affects `G`, not `F_odd`;
  this packet consumes only `F_odd` and the per-centre vectors, which that
  banner states are unaffected.
* No git operation was performed and nothing outside this packet directory
  was written.

---

## 9. Dependencies consumed as sealed

`DATA_SPEC_SMITH_I3_20260812.md`; `theory/SCHEME_MAP_CONSEQUENCES_20260812.md`
(§3.2, Group I / I3, §6); `RECEIVER_LEDGER_X` (§2, §6.1, `ledger_exact.json`);
`TERMINUS_STRATA_PW` (§1 rationality, §2 census, `t2_strata.txt`,
`t3_localmodels.txt`); `STAGE1_COMPLEX_MAPS` (Theorem 3);
`STAGE2_ODD_ORDER_PINNING` (`s2pin.py` `IMMUNE_ROWS`, master formula,
Thm 2.1); `STAGE2_SECOND_ORDER` (A4 residual table via GLOBAL_COHERENCE);
`GLOBAL_COHERENCE` (§1.1–1.2, `vectors_d35.json`, `F_odd_counts.json`, the ×2
banner); `D35_AUDIT` (`patterns_r5_content_p331.json`, the 756/22 split);
`PAIR_ATTACK_D35` (`layer0_A/C_p331.npy`, `layer0_base.py` C13 status);
`D34_GUIDED_SWEEP` (`slicelib.py`, `produce_d34.py`);
`theory/CONSTRAINT_ADDITIONS_20260811.md` (C1, C13);
`ODDZERO_AUDIT/REGISTRATION_SNIPPET.md` (registration format).

External-classical imports, marked at point of use: **Kempf** instability
(optimal destabilising parabolic, canonical), **Smith** theory
(`χ_c ≡ χ_c(fixed) mod p`), **Lüroth**, **Gordan**'s theorem of the
alternative. No unverified external mathematics enters any `[T1]`/`[T2]`
claim.

## Director corrections and adjudication (2026-08-12, appended at sealing)

Referee: `REFEREE_REPORT.md` (Fable, hostile, clean context; its
spot-checks green; packet verifier replayed 95/95 by referee and
director). Verdicts: S1/S2/S5/S6 CONFIRMED; S3 and S4 CORRECTED as
follows, ADOPTED — no numeric conclusion changes anywhere.

1. **Lemma U(a) restated (S3).** The original finiteness claim for "any
   model" is false: at the first wonderful blowup the eigenpoint weights
   `{2,3,4,8}` produce stage-1 fixed points with repeated weights
   (`{1,2,2,6}`, `{4,4,9,10}`), and one further orbit blowup yields a
   fixed `P¹`. Corrected form (all downstream numbers unchanged):
   `q` maps `Z̃^{C11}` into the five points; residual `C5`-transitivity
   makes the five fixed-fiber pieces isomorphic, so
   `χ(Z̃^{C11}) = 5·χ(F_x)`; finiteness and `n_x = 4` are read on `Z`
   from the census, not asserted model-independently. The same
   restatement applies to item (d) of the registration snippet
   (corrected there).
2. **Order-2 branch L widened (S4).** `STAGE1` Thm 3 forces three rows
   to surject; it does not forbid further unforced σ-fixed dominating
   rows. The mod-2 display gains the term
   `+ Σ χ(F_j)` over such rows — the branch stays parametric; nothing
   else changes.
3. **Spec errata adjudicated against the DIRECTOR'S spec** (executor's
   flags correct, confirmed first-hand and by the referee): the 22 share
   ONE σ-band group per prime (prime-dependent labels: `0bbfc90a9b60`
   at 331, `5912f413854e` at 661) with 22 unique content hashes; the
   hash fields are `content_hash`/`sealed_hash`, not `sol_hash`.
   Recorded as errata on `DATA_SPEC_SMITH_I3_20260812.md`.
4. **Sealed content after correction:** orders 11 and 5 congruences
   CLOSED (`χ(q^{-1}x) ≡ 4 (mod 11)` at the five C11-points with
   outright equality of the five fiber χ's; `≡ 0 (mod 5)`; F3 closures
   20/20); order 2 a dichotomy with the E-branch closed and the named
   escape; order 3 parametric; I3 SUBSUMED with its non-vacuous residual
   recorded for future consumers of L16.
