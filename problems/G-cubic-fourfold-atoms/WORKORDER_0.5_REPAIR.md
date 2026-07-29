# Problem G — work order 0.5: repair the proof of Theorem 6.8

**Worker:** Codex.  **Authored:** 2026-07-29.  **Owner's assessment on
record:** the five printed defects are not serious; this order tasks their
repair, not their relitigation.  **Gate:** director review of the repaired
proof; on acceptance the original `WORKORDER.md` program (WP-1..5) resumes
on the repaired argument.

## Inputs

- `DEPENDENCY_MAP.md` (WP-0): the defect analysis, the exact use-sites,
  the independent numerical verifications, and §7's repair sketches.
- `RESOLUTION.md` 2026-07-29 gate entry: all five defects confirmed from
  the hash-pinned v2 text; exact quotes and page anchors there.
- The pinned artifacts in `tmp/pdfs/` (work from `2508.05105v2`; cite by
  statement number and printed page).

## Deliverables

1. **`certificates/REPAIRED_PROOF.md`** — the corrected, self-contained
   proof of Theorem 6.8 at house certificate standard.  Every repair
   labeled R1–R5 inline, each with a short before/after note quoting the
   printed text it replaces.  External inputs pinned with exact citations,
   as the eventual formalization interface.
2. **`certificates/GAP_REPORT.md`** — the referee-grade record of the
   five defects as printed (secondary deliverable; largely assembled from
   WP-0 §7 and the gate entry).  Kept factual and neutral; any use of it
   beyond this repository is the owner's decision.

## The five repairs, with the routes to execute

**R1 — base-point admissibility.**  Replace `q = 1` by
`q₀ = 𝐲^a`, `a ∈ ℚ_{>0}`, inside the ample-cone tube `B_{X,q}` as
defined.  Rerun the reduced-spectrum identification at the new point (the
Lemma 5.19 use-site).  The cluster data is `q`-independent:
`det(λI − K(q)) = λ²(λ³ − 3⁶q)` (already verified in
`DEPENDENCY_MAP.md` §6, including the independent recovery of the
`6, 15, 6` coefficients from Givental's equation) — cite it, restate the
eigenvalues `9q₀^{1/3}ζ^i`, and carry the choice through the two later
displays that mention `q = 1`.

**R2 — the equivariant-restriction lemma (the main item).**  The printed
proof applies Theorem 4.1 to `(H,∇)/B_X^{Hod}`, where maximality fails.
Prove the lemma that licenses the intended conclusion:

1. Apply Theorem 4.1 (HYZZ Theorem 1.2/3.42) to the FULL maximal
   F-bundle `(H,∇)/B_X` at an admissible `b ∈ B_X^{Hod}` — hypotheses
   genuinely hold there; record them being checked.
2. The theorem's uniqueness clause makes the four spectral factors
   canonical over the germ; canonicity transports the Hodge-group action:
   the factors are `Hod`-equivariant.
3. The generalized-eigenspace projectors are polynomials in the
   equivariant operator `κ_b`, hence `Hod`-equivariant; exactness of
   invariants for the proreductive `Hod_ℚ` (invariants is an exact functor
   on its representation category) then gives
   `(H_b^λ)^{Hod} = (H_b^{Hod})^λ` for each cluster `λ`.
4. Restrict the factors to `B_X^{Hod}`; conclude the decomposition of the
   restricted bundle compatible with the fiberwise cluster decomposition
   — the statement the printed proof used without proof.
5. Re-derive the atom-localization step (each connected component of
   `Ũ_X` meets the neighborhood and lies in one cluster) exactly as
   printed — that part was fine; only its input changes.

   If any numbered step genuinely resists after a real attempt, the
   precise obstruction is the deliverable for that step (house C3
   standard) — but the working expectation, per the owner, is that this
   lemma goes through.

**R3 — the cluster-specific bound.**  Replace the displayed
`min`-inequality by the bound for the specific cluster containing `α`:
`ρ_α ≤ dim_k h_{(b,0)}^{λ(α)} ≤ 2`, with the nonzero clusters
contributing 1 and the zero cluster 2.  Two sentences; follows from R2's
step 3.

**R4 — the very-general edge.**  Add the countable-union step: the
NL-genericity used holds outside a countable union of proper closed loci
— Hassett's special cubic fourfolds form a countable union of irreducible
divisors `C_d` (pin the exact theorem number in *Special cubic
fourfolds*), plus whatever additional loci the Torelli/irreducibility
input excludes (enumerate them explicitly).  State the final theorem with
that quantifier and note it implies the "very general" phrasing.

**R5 — delete the surface classification.**  Replace the false exhaustive
list with the two-line argument already identified at the gate:
`Coeff_{t²}(P_α) = 1` forces `p_g(S) > 0`, hence `κ(S) ≥ 0`, hence the
minimal model `S_min` has nef `K`; the blowup formula adds only point
atoms and `Coeff_{t²} = 1` excludes point atoms, so `α` is an atom of
`S_min`; Lemma 5.24 gives the single atom `η(S_min)` with
`ρ_{η} ≥ 3 > 2` (classes of `H⁰`, `H²`, `H⁴`).  The `E × C` family that
refutes the printed list should appear only in `GAP_REPORT.md`, not in
the repaired proof — the repair makes the classification unnecessary.

## Standards

House rules unchanged: never state a lemma you believe might be false;
exact citations with statement numbers; every repair's before/after
quoted; dated `RESOLUTION.md` entry on completion; no modification of any
other problem directory.  The repaired proof must be readable
stand-alone: a reader with the paper open should be able to verify each
R-step without consulting `DEPENDENCY_MAP.md`.

## Out of scope

No simplification beyond the five repairs (that is WP-1..5's job, and R5
already banks the one simplification the gate found).  No contact with
the authors or any external party.  No Lean.

---

## Addendum: WP-0.6 punch list (post-audit, 2026-07-29)

The repaired proof SURVIVED adversarial audit; gate accepted.  Before the
certificate is stamped final, incorporate N1–N8 from the 2026-07-29 audit
entry in `RESOLUTION.md` (fix routes recorded there): add the
Hochschild-additivity interface row and derive it from the cover-native
fiber decomposition (N1); add the `E^{η} ≅ H^•` clause to A6/R5 (N2) and
the disjoint-union reduction (N3); restate Lemma 3.2(4) with its actual
hypotheses including density (N4); supply the `G`-stable germ (N5); pin
Hassett with hash and correct anchors (N6); prove the three asserted
steps (N7); record the `U₀ = −κ` sign convention and its harmlessness
(N8).  No new mathematics; certificate-standard edits only.  Director
gate on the diff, then WP-1..5 resumes.
