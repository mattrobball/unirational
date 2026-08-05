# FIX-A3 — the elliptic landing-site inventory

**Primary exit: `FIX-A3-SITES-PASS`**

**Problem E headline: OPEN.**

**Packet:** `goal_runs_after_fa02f05/FIX_A3_ELLIPTIC_SITES/`
**Program:** FIX ([E56]); dispatched from `theory/FIX_III_cosheaf.md` §1/§5 item 2
(the last unresolved piece of the landing-site inventory `𝒜`), after
FIX-A0/A1/A2 (`goal_runs_after_2880a28/`, `goal_runs_after_bc93561/`).
**Mission:** for a representative involution `σ` (all 55 are `G`-conjugate,
FIX-A0 claim 1), compute exactly `Fix(H, P(W⁺_σ)) ∩ E_σ` for every nontrivial
subgroup `H` of the residual `S3 = C_G(σ)/⟨σ⟩`, identify the resulting points
against the already-known type-I / type-II / deep-point catalogue, and settle
whether the elliptic site inventory of `𝒜` has any member beyond those.
**Verification class:** ALGEBRAIC-RECOMPUTE. `verify_fix_a3.py` recomputes
every eigenspace as the image of an averaging (Reynolds) **projector**
instead of a nullspace, organizes the computation around the three `V4 ≤
C_G(σ)` subgroups directly instead of a chosen `S3`-complement, recomputes
discriminants via the Sylvester resultant instead of the explicit `a,b,c,d`
formula, diagonalizes `ρ` in the **ambient** 5-dim `W` instead of the
3-dim `W⁺`-restricted matrix, independently certifies the rebuilt group is
`PSL(2,11)` via a Cayley-graph-vs-`F₁₁` check (which the producer does not
perform at all), and re-runs the modular irreducibility spot-check at a
different prime (`p=67` vs. the producer's `p=23`) on all 6 lines of both
representatives instead of 1. 0 failures.
**Toolchain:** `python3` exact arithmetic in `Q(ζ₁₁)` and `Q(ζ₁₁,ω)=Q(ζ₃₃)`
(a local copy of `klein_exact.py`, self-contained — no runtime dependency on
sibling packets). No GAP, no Sage, no Magma, no PARI/GP, no M2 — the whole
computation is one plane cubic and a handful of group elements, well within
reach of exact linear algebra alone. Runtime: producer ≈1 s, verifier ≈1.6 s.

---

## Answer, in one paragraph

The elliptic landing-site inventory is **closed with no new members**. For a
representative `σ`, the residual `S3` acts on `P² = P(W⁺_σ)` through
`triv ⊕ std`: one fixed point `[triv]` (the `D12`-point of `σ`) and an
invariant line `P(std)`. Of the five nontrivial subgroups of `S3` (three
conjugate `C2`'s, one `C3`, `S3` itself), only the three `C2`'s meet `E_σ` at
all: each `Fix(C2ᵢ, P²)` is `ℓ_{V4(σ,τᵢ)} ∪ {pᵢ}` (a line union an isolated
point), and `Fix(C2ᵢ,P²) ∩ E_σ` is **exactly** 3 reduced type-II points (on
`ℓ_{V4(σ,τᵢ)}`) plus the 1 reduced type-I point `pᵢ` — objects FIX-A0/FIX-A1
already inventoried. `Fix(C3,P²)` (3 isolated points: `[triv]` + the two
`std`-eigenpoints) and `Fix(S3,P²) = {[triv]}` are **entirely disjoint from
`X`** — the sanity check of mission item 5 holds on the nose. Summed over the
three `C2`'s: `3×(3+1) = 12 = 3 + 9` sites per `E_σ`, matching FIX-A1's
`type_I_on_E_t=3, type_II_on_E_t=9` exactly. Over all 55 `E_σ`'s this is the
same set of `165 + 165 = 330` points FIX-A1 already certified as two size-165
`G`-orbits with full stabilizer exactly `V4` — **not** 55×12 = 660 distinct
points; each type-I point sits on exactly 1 `E_σ` and each type-II point on
exactly 3. **`H⁰(𝒜, 𝒯^land)`'s elliptic-point stalks therefore have no
undiscovered support**: the site complex `𝒜` of Note III §1 is complete as
drafted, modulo nothing this packet can add.

## Per-item verdicts

| Item | Mission ask | Verdict | Evidence |
|---|---|---|---|
| **1** | `S3`-action on `P(W⁺)=P²` explicitly: `triv⊕std`, one fixed point, invariant line `P(std)` | **PASS** | 3×3 matrices of `H`'s 6 elements on `W⁺` computed directly (`act_matrix`); `[triv]` = `Fix(H)` = the `D12`-point, cross-checked against `fixed_space(C_G(σ))`; `P(std)` computed two independent ways (`ker(M_ρ²+M_ρ+I)` in the producer; `ker(Π_{C_G(σ)}) ∩ W⁺` via the averaging projector in the verifier) and shown `H`-invariant; **new structural fact**: all 3 type-I points lie exactly on `P(std)` (forced — a `−1`-eigenvector of `τᵢ` on `triv⊕std` cannot have a `triv` component, since `triv` always has `τᵢ`-eigenvalue `+1`) |
| **2** | `Fix(H,P²)` and `Fix(H,P²)∩E_σ` exactly, for all 5 nontrivial `H≤S3` | **PASS** | full table below; all reduced (multiplicity 1 everywhere it's nonempty); type-I points and the `D12`/`[triv]` point are `Q(ζ₁₁)`-rational (no extension needed); the `C3`-eigenpoints (`ω,ω²` directions) need `Q(ζ₁₁,ω)`; the type-II triples need a further cubic extension (irreducible binary cubic — re-derived independently below, item **not** requiring explicit radicals since the identification argument works purely from subspace containments) |
| **3** | Identify against known sites: the 3 `L_τ∩P_σ` points, the type-II points (from FIX-A1), the deep points (verify none appear) | **PASS** | the 3 type-I points **are** `W⁺_σ∩W⁻_τᵢ` (FIX-A0 finding 6a), cross-checked two ways (`act_matrix`-then-lift vs. direct 5-dim `subspace_intersection`); the 9 type-II points **are** `X∩ℓ_{V4(σ,τᵢ)}` for the 3 `V4`'s through `σ` (FIX-A0 claim 6c / FIX-A1 A1-C3d), `V4`-tuples matched exactly against `payload_arrangement.json`'s `V4_subgroups` list; the only deep point reachable from the residual-`S3` fixed loci is the `D12` point (`=Fix(S3,P²)`), confirmed off `X`; `D10`/`A4` deep points do not arise as `Fix` of any subgroup of `S3` at all (orders 10, 12 don't embed as such) so there is nothing further to exclude |
| **4** | Complete site list, stabilizer, field of definition, known/new; counts + `G`-orbit structure over 55 | **PASS** | table below; **0 new sites**; `G`-orbit structure: 165 type-I (stabilizer `V4`, 1 plane each) + 165 type-II (stabilizer `V4`, 3 planes each) = 330 distinct points, `165+495=660=55×12` incidences |
| **5** | `Fix(C3,P²)∩E_σ` sanity; reconcile `3+9` with FIX-A1 | **PASS** | `Fix(C3,P²)` = 3 isolated points, **all off `X`** (both representatives, both eigenspace methods); `3 (type-I) + 9 (type-II) = 12`, matching FIX-A1's `v4_exact.json: per_involution_counts = {type_I_on_E_t: 3, type_II_on_E_t: 9}` exactly, cross-loaded and compared by the producer |

## The `Fix(H, P²)` table (representative `σ`, index 1 in the BFS order shared with FIX-A0)

| `H ≤ S3` | `Fix(H,P²)` | `Fix(H,P²) ∩ E_σ` | field / reducedness |
|---|---|---|---|
| `⟨τ₁⟩` (`C2`) | line `ℓ_{V4(σ,τ₁)}` ⊔ point `p₁` | 3 pts (type-II) + `p₁` (type-I) = **4** | type-II: cubic ext. of `Q(ζ₁₁)` (irreducible, reduced — disc ≠ 0, re-derived by resultant + modular spot-check); `p₁`: `Q(ζ₁₁)`-rational, reduced |
| `⟨τ₂⟩` (`C2`) | line `ℓ_{V4(σ,τ₂)}` ⊔ point `p₂` | 3 + 1 = **4** | same shape |
| `⟨τ₃⟩` (`C2`) | line `ℓ_{V4(σ,τ₃)}` ⊔ point `p₃` | 3 + 1 = **4** | same shape |
| `⟨ρ⟩` (`C3`) | `{[triv], [ω\text{-eigenpt}], [ω²\text{-eigenpt}]}` (3 isolated pts) | **∅** | `[triv] ∈ Q(ζ₁₁)`; the two `std`-eigenpoints ∈ `Q(ζ₁₁,ω)`; none on `X` |
| `S3` (`=H`) | `{[triv]}` (1 pt, `=` the `D12`-point of `σ`) | **∅** | `Q(ζ₁₁)`-rational; off `X` |

Union over the 3 `C2`'s: **12 points on `E_σ`**, all already known (3 type-I +
9 type-II); `C3` and `S3` contribute **0**. No point is double-counted: the
9 type-II points come from 3 *different* lines through the common `[triv]`
point (concurrency: `ℓ_{V4(σ,τᵢ)} ∩ ℓ_{V4(σ,τⱼ)} = {[triv]}` for `i≠j`, since
`V4(σ,τᵢ) ⊂ C_G(σ)` forces `W^{C_G(σ)} ⊆ W^{V4(σ,τᵢ)}` — verified directly,
both representatives, all 3 pairs), and `[triv]` itself is off `X`.

## The residual-stabilizer argument (no explicit type-II coordinates needed)

The clean fact that pins every stabilizer exactly: for `i≠j`,
`⟨τᵢ,τⱼ⟩ = H` (any two distinct transpositions generate `S3`, checked
directly), so `Fix(τᵢ) ∩ Fix(τⱼ) = Fix(H) = {[triv]}` — **verified directly**
in the full 5-dimensional `W` (not via the `W⁺`-restricted matrices), for
all `3` pairs, both representatives. Since `[triv]` is off `X` while every
one of our 12 candidate sites is **on** `X`, no site can be fixed by any
`τⱼ` (`j` other than its own) or by `ρ` (whose fixed locus is off `X`
entirely). Hence:

* each type-I point `pᵢ` has **residual stabilizer exactly `⟨τᵢ⟩` (`C2`)** —
  also confirmed by direct brute force over all 6 elements of `H` (we have
  exact coordinates for these);
* each of the 3 type-II points on `ℓ_{V4(σ,τᵢ)}` has **residual stabilizer
  exactly `⟨τᵢ⟩`** too — by the same argument, which never needs the type-II
  points' coordinates (they live in a cubic extension of `Q(ζ₁₁)`, never
  constructed explicitly, since the containment/exclusion argument is purely
  about fixed *loci*, not fixed *points*).

This matches FIX-A1's independently-certified fact that the **full** `G`
stabilizer of every type-I and type-II point is exactly `V4` (order 4,
A1-C3d′) — the residual-`S3` stabilizer `⟨τᵢ⟩` (order 2) is exactly
`V4(σ,τᵢ) ∩ H`, consistent with `V4 = ⟨σ,τᵢ⟩` and `σ ∉ H`.

## Field of definition, precisely

* `D12`/`[triv]` point and the 3 type-I points: **`Q(ζ₁₁)`**, no extension.
* The `C3`-eigenpoints (`ω`, `ω²` directions): **`Q(ζ₁₁,ω) = Q(ζ₃₃)`**
  (degree 2 over `Q(ζ₁₁)`) — irrelevant to `E_σ` since they're off `X`.
* The type-II points: each individually generates a **degree-3** extension
  of `Q(ζ₁₁)` (the defining binary cubic `F|_{ℓ_{V4}}` is irreducible over
  `Q(ζ₁₁)` — re-confirmed here by an independent modular spot-check, p=23 in
  the producer and p=67 in the verifier, all 10 Galois conjugates of the
  reduction map, on all 6 lines of both representatives: zero roots in every
  case, matching FIX-A1's A1-C8 exhaustive 7-prime/55-line survey). Whether
  the Galois closure needed to name all 3 conjugate points **simultaneously**
  is degree 3 (cyclic) or degree 6 (`S3`) is **not resolved by this packet**
  and is **not needed** for the identification task: the residual-stabilizer
  and on/off-`X` arguments above work entirely at the level of fixed
  *subspaces*, never requiring an explicit type-II point coordinate. (FIX-A1
  observed only "totally split" or "totally inert" reduction types across 7
  primes, never the mixed pattern a non-Galois cubic would eventually show —
  suggestive of the cyclic case, but this is prime-sampling evidence, not a
  proof, and settling it would need an exact "is `disc` a square in
  `Q(ζ₁₁)`" computation that this packet did not undertake as out of scope
  for a "small" packet whose job is site identification, not Galois theory.)

## `G`-orbit structure over all 55 `E_σ`'s

Both orbits were already exactly established by FIX-A1 (A1-C3d′: stabilizer
`V4` for both types, "two `G`-orbits of size 165"); this packet reconfirms
the count from the `E_σ`-local side and the orbit-counting arithmetic:

| type | orbit size | stabilizer | planes `E_σ` through each | total incidences |
|---|---|---|---|---|
| type-I vertex | 165 (`=|G|/|V4|=660/4`) | `V4` | 1 | 165 |
| type-II point | 165 (`=|G|/|V4|=660/4`) | `V4` | 3 | 495 |

`165+495 = 660 = 55 × 12` — consistent both ways (55 planes × 12 sites each,
and 165+165 points × their per-point incidence counts). **330 distinct
points total**, forming exactly these 2 orbits; the residual-`S3` computation
here reproduces them stratum-by-stratum on a single `E_σ` and adds **zero**.

## Representative + conjugacy: the transport check

Computed in full for `σ₀` (BFS index 1, matching FIX-A0's indexing) and,
independently, for a second, unrelated involution `σ₁` (BFS index 419) —
identical structure, different explicit numbers. An explicit conjugator
`g` (index 129) with `g σ₀ g⁻¹ = σ₁` was found and used to transport
`P(W⁺_{σ₀})` and the `D12`-point of `σ₀`; both land exactly on the
corresponding objects for `σ₁`. Since FIX-A0 established the 55 involutions
form a **single** `G`-conjugacy class, this confirms "representative + `G`
by conjugacy" legitimately covers all 55 without further per-`σ` computation.

## FINDINGS

1. **No new elliptic landing sites exist.** The residual-stability inventory
   of `theory/FIX_III_cosheaf.md` §1 is now complete: the elliptic
   point-sites are exactly the 165 type-I + 165 type-II points FIX-A0/FIX-A1
   already found, with nothing left over from `C3` or `S3`. Note III's site
   complex `𝒜` needs no further members on the elliptic side.
2. **New structural fact** (not previously recorded, item 1 of the mission):
   the invariant line `P(std) ⊂ P(W⁺_σ)` — complementary to the `D12`-fixed
   point `[triv]` — contains **all 3 type-I points** of `E_σ`. This is a
   direct consequence of `triv` always carrying `τᵢ`-eigenvalue `+1` (so a
   `−1`-eigenvector can have no `triv` component), verified exactly by two
   independent constructions of `P(std)` (a `Cyc`-only minimal-polynomial
   kernel `ker(M_ρ²+M_ρ+I)` in the producer; a projector-kernel
   `ker(Π_{C_G(σ)}) ∩ W⁺` in the verifier). `P(std)` carries the *same*
   standard-faithful `S3`-on-`P¹` action as `L_σ = P(W⁻_σ)` itself, and the
   type-I points are exactly one of the two canonical 3-point reflection
   orbits on it (the complementary orbit is the 3 "outer" endpoints of the
   `V4`-lines through `[triv]`) — the same "two orbits of size 3" pattern
   FIX-A0 §6 already recorded for the 6 `V4`-vertices on `L_σ`.
3. **The `9=3+…` reconciliation (mission item 5) holds with no residue.**
   All `12 = 3+9` sites per `E_σ` are accounted for by the three `C2`'s
   alone; `Fix(C3)` and `Fix(S3)` are both **entirely** off `X`, so there is
   no "extra" contribution anywhere to reconcile — the `9` and the `3` are
   not just numerically equal to FIX-A1's counts, they are **the same
   points**, identified via matching `V4`-tuples exactly against
   `payload_arrangement.json`.
4. **The field-of-definition question for type-II points has an honest gap**
   (recorded, not hidden): each type-II point individually needs a degree-3
   extension of `Q(ζ₁₁)` (fully settled), but whether the Galois closure
   naming all 3 conjugates together is degree 3 or 6 is open — irrelevant to
   every claim made here (the residual-stabilizer and identification
   arguments are subspace-level, not coordinate-level), but flagged in case
   a later packet needs the finer arithmetic (e.g. an explicit uniformizing
   parameter for the type-II locus).
5. **No discrepancy anywhere.** Cross-referenced against
   `goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT/payload_arrangement.json`
   (same involution BFS indexing confirmed byte-for-byte; all 3 `V4`
   subgroups of `σ₀` found verbatim in FIX-A0's 55-`V4` list) and
   `goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR/v4_exact.json`
   (`per_involution_counts` matches exactly). Nothing in FIX-A0/FIX-A1/FIX-A2
   is contradicted, amended, or extended beyond confirmation.

## Deliverables

| File | Role |
|---|---|
| `klein_exact.py` | local copy of the FIX-A0 exact-arithmetic library (`Q(ζ₁₁)`, `Q(ζ₁₁,ω)`, linear algebra, the group, the Klein cubic, sparse polynomials) — self-contained, no cross-packet runtime dependency |
| `produce_fix_a3.py` | producer (exact; ≈1 s): builds the group, computes `Fix(H,P²)` for all 5 nontrivial `H≤S3` on 2 representatives, the residual-stabilizer argument, the `P(std)` structural fact, cross-references FIX-A0/FIX-A1 payloads (read-only), a modular spot-check |
| `verify_fix_a3.py` | independent verifier, ALGEBRAIC-RECOMPUTE (exact; ≈1.6 s): projector/Reynolds-operator eigenspaces throughout, `V4`-organized instead of complement-organized, resultant discriminants, ambient-`W` diagonalization of `ρ`, independent `PSL(2,11)` certification, `p=67` modular check on all 6 lines. 0 failures |
| `sites.json` | the exact inventory: `Fix(H,P²)` data for both representatives, per-`V4` lines/points (ambient 5-dim coordinates), discriminants, on/off-`X` flags, residual stabilizers, the `C3`/`S3` off-`X` certificates, the `P(std)` basis, cross-reference and modular-check records, summary |
| `STATUS.md` | this file |
| `REPLAY.md` | replay instructions |

No git commits made; nothing written outside this packet. The sibling
packets under `goal_runs_after_2880a28/` were read-only (two small JSON
loads for cross-referencing) and not modified.

## Consequence for Note III

`theory/FIX_III_cosheaf.md` §1's elliptic-site line — "point-sites on the
elliptics `E_σ`: … inventory to be computed exactly (packet FIX-A3,
small)" — is now settled: the inventory is **exactly** the type-I/type-II
points already listed there, nothing more. §5 item 2 ("FIX-A3 … completing
the site") is complete. This does not change the honest logical strength of
`H⁰` recorded in §3 (existence of a nonempty `H⁰` still concludes nothing by
itself), and bears on the Problem E headline only insofar as it removes one
item from the dependency list of the full Note III write-up (§5 item 3).

Nothing in this packet bears on the Problem E headline, which remains OPEN.
