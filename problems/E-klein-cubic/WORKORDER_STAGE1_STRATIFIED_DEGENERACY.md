# WORKORDER — Stage-1 stratified degeneracy repair (queued item 1)

Issued 2026-08-11 (director). Executor: one worker, full repo access, python3
only (no GAP/Sage/Magma/PARI; `gap` and `gp` are shell aliases that silently
do the wrong thing). Reference implementations to crib from:
`goal_runs_20260811/ODDZERO_AUDIT/scripts/` (independent σ-adapted
coordinates, explicit sections, arc evaluations, both primes).

**Do not edit any sealed text** (`STAGE1_TIGHTEN/THEOREM.md`,
`STAGE1_COMPLEX_MAPS/*`, banners). Deliver a new packet; registration and
banners are director work on return.

## A. Context — the bug being repaired

`ODDZERO_AUDIT` (verdict `ODD-ZERO-ARTIFACT`, sealed) located the error: the
degeneracy test in `STAGE1_TIGHTEN/scripts/s3sat.py:72-78` via
`s3sweep.py:271-276` (upstream: `STAGE1_COMPLEX_MAPS/scripts/
s1coherence.py:293-296`) declares a child degenerate when the **whole
module** `V(a,ψ)` evaluates to rank 0 at the child coordinate `q`. Theorem
15.1's second branch (`s(q) = 0`) is a property of the **individual
section**. Sections vanishing at `q` form a positive-codimension subspace
whose next-order term takes a *different*, character-forced value. All
downstream counts (`K` residue table, the coherent total
`1 088 847 395 778 723 840 000`) are bounds, not counts, until repaired.

## B. The corrected semantics (exact, vector-level)

Fix a sweep row `S` with module `V(a,ψ)` and children `q_1,…,q_N`, each with
its attaching arc (the transverse direction toward the parent stratum —
ODDZERO §5(iii)-(iv) gives the construction on the full-flag rows; derive
the analogue per row from the census frames).

1. For a section `s` and child `j`, let `k_j(s) = ord_{t}` of `s` along the
   arc at `q_j` (`k_j = 0` means `s(q_j) ≠ 0`; `k_j = ∞` means `s` vanishes
   identically along the arc — only then is the child genuinely free for
   that section).
2. **Level-vector strata.** The joint conditions `k_j(s) = κ_j` are linear
   (jet conditions); enumerate the attainable vectors
   `κ = (κ_1,…,κ_N) ∈ (ℕ ∪ {∞})^N` (nonempty strata), truncating each
   coordinate at the first level whose value repeats
   (values depend on the level only through the character — see 3 — so the
   attainable VALUE-vector set is finite and truncation is sound; record the
   truncation bound used).
3. **Value rule per level.** The value at child `j` of a section with
   `k_j = κ` is the `Λ_j`-eigenline of character
   `ψ^{-1} · ∏_r μ_{j,r}^{a_r} · χ_{arc,j}^{κ}`, where `χ_{arc,j}` is the
   `Λ_j`-character of the arc direction. This is Theorem 15.1 branch 1
   applied to the `κ`-th term (the ODDZERO refutation's Prop B(iii) is the
   full-flag instance, `χ_B^{a+k}·μ₁`). Derive `χ_{arc,j}` per row/child
   from the frames; verify against ODDZERO's explicit sections wherever the
   audit computed them (the E1/E2 clash tables and the F3 witnesses must
   reproduce, then turn consistent under the new semantics at odd `d`).
4. **Contribution of a class `(a,ψ)`** = the set of value assignments
   `{q_j ↦ value(κ_j)}` over attainable level vectors `κ` (free choice at
   `κ_j = ∞` children). A class survives arc-consistency if at least one
   attainable assignment lies inside every child's arc-consistent domain.
   The cross-child correlation matters: per-child independent domains are a
   RELAXATION — acceptable only as a sanity superset, not for the count.

## C. Saturation, restated (Theorem S′) — the direction changes

Old Theorem S(c) ("`contribution(a+6e_r) ⊆ contribution(a)`", exclusions
propagate up) is **no longer true as stated**: multiplication by the
`Γ`-invariant `h_r` (with `h_r(q_j) ≠ 0` for all `j`) preserves every
section's level vector, so attainable-vector sets are **non-decreasing**
along `a ↦ a + 6e_r`, while total-degeneracy (`κ_j = ∞` for the whole
module) remains non-increasing. Two bounded monotone processes ⟹ the
per-class contribution stabilizes on each residue class mod 6.

Required: verify stabilization computationally (up-set style, boxes as in
Theorem S(d), spot checks beyond), report the stabilization threshold `Θ′`,
and read the residue table off the **stable** pattern only. Below `Θ′`
neither SAT nor UNSAT propagates in a fixed direction — do not reuse the old
monotonicity anywhere. Stretch goal (optional): closed-form attainability of
level `κ` via the equivariant trace formula on jet modules, making `Θ′`
a-priori instead of observed.

## D. Scope of the re-run

1. Patch the degeneracy semantics (new module, e.g. `s3jet.py`; keep the old
   code path callable for diff purposes).
2. Re-run the σ-band residue table (`s3residue.py` consumers) at
   `p = 331` and `p = 661`.
3. Re-run the upstream coherent count (`s1coherence.py` semantics) — the
   corrected successor of `1.088 × 10²¹` and of the "38 of 48 components"
   statement (STAGE1 §15.2).
4. Anchors that must reproduce unchanged: `N(d,m)` (`d ≤ 12`), H0-1 parity,
   Prop 1.4(ii), the census row multiset, the `Θ = 6` module-nonvanishing
   saturation (S(a),(b),(d) survive; only (c) is restated per §C).

## E. Tuple-completeness (required property, one paragraph in THEOREM.md)

The enumeration must remain a relaxation valid for **arbitrary nonzero
landing tuples**, with no primitivity assumption: an imprimitive tuple
`c·T'` has leading data with shifted `(a, ψ, κ)`, and those shifted classes
must be inside the enumerated ranges. State this explicitly (it is what
makes zeros transportable — see
`theory/EXCLUSION_TRANSPORT_20260811.md` §6).

## F. The `Φ_F` transport gate (new deliverable)

Compute `F`'s row data on each of the 15 sweep rows: its leading multidegree
`a(F)` and character shift, and `ord` along the arc at every child
(`ord_{L_σ}F = 1` and the FIX_VII §7 arrangement facts are anchors). Define
`Φ_F : (a, ψ, κ) ↦ (a + a(F), ψ·ψ_F, κ + κ(F))` and machine-check the
inclusion

    Φ_F( coherent patterns at residue ρ ) ⊆ coherent patterns at ρ+3

for all six residues, both primes. A failure is a bug in the enumeration —
this test would have caught the odd-zero artifact immediately, and it is not
expressible in the old semantics (no slot for `κ`). Report it as its own
check group in the verifier.

## G. Stakes, and the required framing of any zeros

Per `theory/EXCLUSION_TRANSPORT_20260811.md` (Corollary 3.4, unconditional —
the invariant ring has a quintic invariant, director probe
`director_probes_20260811/molien_director.out`): a corrected tuple-level
`K(ρ̄) = 0` at ANY single residue closes EVERY degree, i.e. Problem E.
Therefore:

- any zero in the corrected table is **FLAGGED, NOT CLAIMED**, following the
  `STAGE1_TIGHTEN` §2.5 precedent exactly — state the pair consequence, do
  not assert it;
- the packet must state that an adversarial audit at ODDZERO standard
  (independent rebuild, explicit witnesses, both primes) is the promotion
  gate for any zero;
- headline is fixed: "Problem E remains OPEN; this packet excludes no
  degree."

## H. Packet protocol

Deliver `goal_runs_20260811/STAGE1_STRATIFIED/` with: `THEOREM.md` (main
document — the harness refuses the literal name `REPORT.md`), `scripts/`,
`results/`, `verifier.py` (replayable, both primes, check groups incl. §F),
`REGISTRATION_SNIPPET.md` (manifest YAML following the `ODDZERO_AUDIT`
snippet format; `entry: E56`, `kind: goal_run`, `tracked: true`), honesty
tiering (Tier 1 / Tier 2 two-prime / Tier 3 flagged), exit ledger, and an
explicit "Not claimed" section. Do not touch `notebook_build/`, `NOTEBOOK.md`,
or any sealed file; do not commit — leave the working tree for the director.
