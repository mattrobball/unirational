# Problem G — work order 0.6: punch list on the accepted repaired proof

**Worker:** Codex.  **Authored:** 2026-07-29.  **Standing:** the repaired
proof (`certificates/REPAIRED_PROOF.md`) passed the director's direct read
AND an independent adversarial audit; the gate is ACCEPTED.  This order
finalizes the certificate by incorporating the audit's eight findings —
**all interface-hygiene or elision grade, none mathematical**.  No new
mathematics; certificate-standard edits only.  Director gate on the diff;
on acceptance the certificate is stamped final and the `WORKORDER.md`
program WP-1..5 resumes on it.

## Ground rules

Edit `certificates/REPAIRED_PROOF.md` (and its interface table §2) in
place; do not weaken any statement; every edit either adds a missing
interface row, proves an asserted step, pins a source, or records a
convention.  House rules as always: never state a lemma you believe might
be false; exact citations with statement numbers; dated `RESOLUTION.md`
entry on completion.  Do not touch `GAP_REPORT.md`, `DEPENDENCY_MAP.md`,
or any other problem directory.

## The eight items

**N1 — add and derive the Hochschild-additivity interface (most
substantive; a formalization stalls here first).**
The repaired §4 uses, at the transcendental-atom step and again at the
point/curve and surface steps, the additivity
`Σ_α mult_α · P_α(t) = folded Hodge polynomial of H^•(X)`
without listing it in the §2 interface table or deriving it.  Fix: add
the interface row, then derive the statement from the certificate's own
cover-native fiber decomposition `⊕_{x ∈ Ũ_{X,b}} 𝒜_x = H_{(b,0)}`
(the disjoint local cluster factors partition the fiber; invariant ranks
and Hodge gradings add).  Keep the derivation inside the certificate so
the interface is discharged, not merely named.

**N2 — the `E^{η(S_min)} ≅ H^•(S_min, ℚ̄)` clause in R5.**
Interface row A6 states only "nef canonical class ⟹ one Hodge atom";
the `ρ ≥ 3` count needs the atom's representation to BE the full
cohomology.  KKPY's printed text states the missing clause.  Fix: extend
A6 (or add A6′) and justify in one clause: the proof of the single-atom
lemma shows `κ` has a single eigenvalue, so the unique generalized
eigenspace is all of `H^•`.

**N3 — reduction to connected `S` in R5.**
The repaired §4 jumps to "a connected smooth projective surface `S`",
while the quantified statement ranges over all smooth projective
varieties of dimension ≤ 2 including disjoint unions.  Fix: one
sentence invoking disjoint-union additivity of the atomic composition
(KKPY Prop. 5.22(1)); add the interface row if the table lacks it.

**N4 — restate Lemma 3.2(4) with its actual hypotheses.**
Item (4) imports `U_X`, the atom-component cover `C_α`, interface A5,
and the DENSITY of `U_X` in `B^G` (used at "Since `U_X` is dense,
`W ∩ U_X ≠ ∅`"), none of which appear in the lemma's hypothesis block.
Fix: either move (4) out as a standalone proposition with full
hypotheses, or extend the lemma's hypothesis block; state the density
assumption explicitly and point to where it is verified for the cubic.

**N5 — the `G`-stable germ in Lemma 3.2 step (2).**
"A group element sends the lifted splitting to another splitting"
presupposes the neighborhood is `G`-stable (or a germ-level
formulation).  Fix: one paragraph — the base spaces are norm-defined,
the Hodge group's image is bounded, so `G`-invariant admissible
neighborhoods of the fixed point `b` are cofinal among neighborhoods;
work in the germ.

**N6 — pin Hassett.**
The R4 input (Hassett, *Special cubic fourfolds*, Theorem 3.1.2) has no
local copy, no hash, and page anchors that do not match the linked
artifact.  Fix: download the artifact, store it under `tmp/pdfs/`,
record its SHA-256 in the §2 manifest — the audit's fetched copy hashed
`ecc2e31a63f56d443aaa3534f0218b25a5b6ab6e1a84c82db5c7bac1789a1d21` and
places the statements on pp. 7, 9, 14 of that version; cite by the
artifact's own pagination and quote Theorem 3.1.2 verbatim, including
the definition line `A(X) = H^{2,2}(X) ∩ H⁴(X, ℤ)` (integral Hodge
classes — this is what makes R4 independent of any Hodge conjecture;
say so where it is used).

**N7 — prove the three asserted steps inside Lemma 3.2.**
(a) "The cluster subbundles are the images of the unique primary
idempotents of `κ`": prove that a `κ`-commuting idempotent over the
germ's local ring is block-diagonal with locally constant rank, forcing
`e|_{u=0} = p_λ(κ)` — this is what makes `m ≥ 1` in the uniqueness
computation.  (b) Disjointness of the block spectra over the SHRUNKEN
germ, used at points `π(x) ≠ b`: the pairwise resultants are units
after shrinking; say it.  (c) The subbundle property of
`𝒜_α = ker((π*κ − ℓ_α)^N)` over `U_X`: on `U_X` the number of distinct
eigenvalues is constant and eigenvalue branches never collide, so
algebraic multiplicities are locally constant (upper-semicontinuous
with constant sum), hence the kernel has locally constant rank and is a
subbundle.

**N8 — record the sign convention.**
KKPY's own displays give `∇_{∂u} = ∂_u − u⁻²(Eu⋆(−)) + …` while their
Definition 3.12 sets `κ = ∇_{u²∂u}|_{u=0} = +Eu⋆(−)`; under the
certificate's normalization `∇_{∂u} = ∂_u + u⁻²U(u)` this means
`U₀ = −κ`.  Fix: one remark recording the discrepancy and its
harmlessness — the commutant and the primary decomposition are
unchanged, the spectrum is negated, the cluster multiplicities
`(2,1,1,1)` are unaffected — and normalize the certificate's one
spectrum display (`Λ = {0, 9q₀^{1/3}ζ^i}`) to whichever sign it adopts,
consistently.

## Acceptance

1. Every item N1–N8 addressed in `REPAIRED_PROOF.md` with the edit
   visible and self-contained.
2. The §2 interface table is complete: every external statement used
   anywhere in §§3–5 has a row, a source, and a hash where the source is
   a pinned artifact.
3. `RESOLUTION.md` gains a dated completion entry listing, per item, the
   location of the fix.
4. No statement weakened; no new interface consumed without a row;
   `git diff` confined to `certificates/REPAIRED_PROOF.md`,
   `RESOLUTION.md`, and the new pinned artifact under `tmp/pdfs/`.
