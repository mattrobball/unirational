# REFEREE REPORT — `goal_runs_20260812/STEIN_LERAY/`

Hostile referee, clean context, 2026-08-12. Object: the full packet
(`THEOREM.md`, scripts, results, verifier) against
`DATA_SPEC_PIPELINE_FLUSH_20260812.md` Lane 2 and
`theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.4.

**Headline discipline respected: Problem E remains OPEN. Nothing in this
report excludes any degree or cuts any cell.**

## Replay

Full pipeline replayed in order (`scripts/j1_molien.py`,
`scripts/pinned_points.py`, `scripts/menus.py`, `verifier.py`):
**92 checks, 0 failures, 0 skips; groups A 25/25 (gate), B 26/26, C 41/41;
`STEIN_LERAY_VERIFY_OK` / `ALLGREEN`.** All six results files are
**byte-identical** to the pre-replay snapshot (deterministic replay; nothing
existing was modified).

Independent spot-check scripts written for this review (packet root, new
files only):

| script | checks | result |
|---|---|---|
| `referee_group_character.py` | 16 | OK |
| `referee_molien_fp.py` | 18 | OK |
| `referee_quintic.py` | 18 | OK |
| `referee_dichotomy_menus.py` | 30 | OK |

All routes differ from the packet's: group rebuilt from SL(2,11) matrices mod
±I (packet: permutations of P¹(F₁₁)); all cyclotomic arithmetic done in F_p
with a primitive 330th root at two primes with integer recovery below an
explicit bound (packet: Z[x]/(x^N−1) reduced mod Φ_N); Hessian re-derived by
hand with the factor 2 kept (det Hess F = 32·Q_packet, confirmed).

## R1 — Proposition PIN and the quintic: **CONFIRMED**

*Character argument, re-derived independently.* Pic X = Z·H
(Grothendieck–Lefschetz on a smooth hypersurface of dim 3), the G-action is
linearized on O(1) via G ⊂ SL(W), and G perfect kills the character twist, so
an invariant effective divisor of degree k has a G-invariant equation
f ∈ (C[X]_k)^G; restriction C[x]_k → H⁰(X, O(k)) is onto (H¹(P⁴,O(k−3)) = 0)
and taking invariants is exact. At a fixed point [v] of C_m (m ∈ {11,5}
prime) with g·v = ζ^a v, a ≢ 0 (mod m): f(v) = f(g·v) = ζ^{ak} f(v), so
f(v) = 0 unless m | ak, i.e. unless m | k. The weight preconditions hold: the
C11 weights b = ((−2)^i) = (1,9,4,3,5) are the nonzero residues QR (2b_i +
b_{i+1} ≡ 0 re-checked), σv_j = ζ₅^{−j}v_j gives nonzero C5-weights for the
four on-X points, and F(v₀) = 5 ≠ 0 puts the weight-0 point off X (verified
at two primes, `Q9`). (a), (b), (c) follow; 55 is the least degree escaping
both (`M10–M12`).

*The quintic.* det Hess of a cubic transforms by det(A)² (chain rule:
Hess(F∘A) = Aᵀ (Hess F)(A·) A), hence is G-invariant for G ⊂ SL(W) —
classical and complete; no matrix generators needed. My independent Molien
gives i₅ = a₅ = 1 and i₂ = 0 (`M3`, `M6`), my independent expansion gives the
same 11 monomials (× 32, `Q7`), τ-weight 0, σ-invariant, F ∤ Q by exact
linear algebra (`Q13`), zero at all five coordinate points (symbolically —
the coefficient of x_c⁵ is absent, which PIN forces since 11 ∤ 5), and
**nonzero at all four C5-points** at two independent primes, matching the
packet's Z[ζ₅] canonical representatives under the mod-p homomorphism
(`Q10`, `Q11`). The incidence statement is exact as claimed.

*One wording note (non-blocking).* "Degrees carrying an invariant divisor are
exactly {k ≥ 5}" is machine-verified on the window k ≤ 46 (A14–A16). The
window closes for all k: a₅…a₉ ≥ 1 and C[X] is a domain, so the invariant
degrees form a semigroup containing ⟨5,6,7,8,9⟩ ⊇ {k ≥ 5} (`M9`). One
sentence in §2.2 would make the window-free claim self-contained.

## R2 — Lemma FL and the χ₀ ≡ 35 (mod 55) dichotomy: **CONFIRMED (in its stated scope — and the scope is stated)**

*Miracle flatness applies as used.* Everything runs on the resolved model q :
Z̃ → X (proper, surjective, equivariant), never on the rational map. U =
{x : dim q⁻¹(x) = 1} is open: {z : dim_z q⁻¹(q(z)) ≥ 2} is closed in Z̃
(Chevalley), its image is closed (q proper), U is the complement; U is
non-empty (generic fibre) and every fibre is non-empty of pure dim ≥ 1
(fibre-dimension theorem, §1). Over U: O_{X,x} regular, O_{Z̃,z} CM (Z̃
smooth), and dim O_{Z̃,z} = 4 = 3 + 1 at every closed point, so EGA IV 6.1.5
gives flatness at closed points; the flat locus is open, hence contains
q⁻¹(U). χ(O_fibre) is locally constant for a proper flat family, and U is
connected because X is irreducible. **Lemma FL is correct**: one integer χ₀
on the whole 1-dimensional-fibre locus, for either Stein branch.

*The congruences combine correctly.* With all nine pinned points in U and
their fibres smooth (D = 0, N = 0), χ_top = 2χ(O) for any smooth projective
curve (disjoint unions included), so 2χ₀ ≡ 4 (mod 11) and 2χ₀ ≡ 5 ≡ 0
(mod 5). CRT re-derived by hand and by machine: χ₀ ≡ 2 (mod 11) (2⁻¹ = 6)
and ≡ 0 (mod 5) give **χ₀ ≡ 35 (mod 55)**, and no such value lies in
(−20, 35), so the dichotomy is exhaustive with both boundary values attained
(`D1–D3`). Branch A: h¹ = h⁰ − χ₀ ≥ h⁰ + 20; connected h⁰ = 1 gives
h¹ = g ≡ 21 (mod 55), genus ≥ 21 (`D4`), agreeing with the independent RH
cross-check (11a+10 = 5b+6 first at 21, `D19`). Branch B: h⁰ = χ₀ + h¹ ≥ 35,
and in the smooth row h⁰ = #components = #ν⁻¹(x) ≤ s, so **s ≥ 35**;
impossible in the connected branch (χ₀ = 1 − h¹ ≤ 1). All verified.

*Scope hygiene — checked line by line.* The three hypotheses (all nine pinned
points carry 1-dimensional fibres; those fibres smooth; n_x read on the
terminus model Z) are stated at every occurrence of the sharp numbers
(§6.4, §7.1, §8, registration snippet), the statement is at map level for the
d = 35 class, and the cell-uniformity is a verified constancy (§4, re-verified
here `D23–D28`). The model caveat (§6.4 end) correctly notes that on a
further equivariant model the menus re-run with the new n_x; the equality of
the five C11 values survives refinement by residual-C5 transitivity.
**The central claim survives hostile review as stated.**

## R3 — the χ-bridge: **CONFIRMED**

Lemma BR's proof is correct (nilradical sequence + normalisation +
χ_top(F) = χ_top(F_red) = χ_top(F̃) − Σ(n_p − 1)); D = 2δ − Σ(n_p−1) ≥ 0
via δ_p ≥ n_p − 1 with equality iff F_red smooth. Re-verified on four worked
cases: double line (2 = 2·1 + 0 − 0), two lines (3 = 2 + 1), irreducible
nodal cubic (1 = 0 + 1), cuspidal cubic (2 = 0 + 2) (`D20–D21`). Every menu
row carries the defect: smooth row D = N = 0 explicit; reduced-nodal row
h¹ ≡ (2 + δ − n_x)·2⁻¹ (mod p) re-derived and matched entry-by-entry
(`D22`); general row parametric in D and χ(N); the dim-2 row refuses a
bridge, correctly. The flag against the spec is **fair**: Lane 2's
"χ = h⁰ − h¹" does conflate the topological Smith value with the coherent
characteristic, and the packet is right that the sharp numbers are false as
stated outside the zero-defect row.

## R4 — Riemann–Hurwitz prunings: **CONFIRMED**

2g − 2 = p(2h − 2) + r(p − 1) with full tame ramification at prime order
gives g = 11a + 10 (p = 11, r = 4) and g = 5b + 6 (p = 5, r = 5) (`D7–D8`);
faithfulness on each component is legitimate because the fixed locus on Z is
finite (census: Z^{C11}, Z^{C5} both 20 points, dim 0). Both families satisfy
the Smith congruence identically (`D9`) — a consistency reproduction, as
claimed. The r = 1 rule is the classical cyclic-cover existence constraint
(local rotation numbers sum to 0 mod p, each nonzero at a genuine fixed
point) and correctly prunes the splits to {[2,2],[4]} and {[2,3],[5]}
(`D13`); per-part genera 11h / 11h+10 / 5h / 5h+2 / 5h+6 and free-orbit
genera p(h−1)+1 all re-derived (`D11–D12`). My independent enumeration
reproduces exactly 1440 window types per class, every one Smith-consistent,
with cheapest disconnected (2,0) at C11 and (2,2) at C5 (`D14–D16`), and
confirms the honest window note (χ₀ = 35 has no C5 witness inside the
declared window; the packet says absence ≠ impossibility).

## R5 — from-scratch anchors: **CONFIRMED**

Independent rebuild: PSL(2,11) from SL(2,11)/{±I} — 660 elements, class
data (1,55,110,132,132,110,60,60) with orders (1,2,3,5,5,6,11,11), squaring
swaps the two order-11 and the two order-5 classes (`G1–G4`). The derived
eigenvalue table is exactly the classical 5-dimensional irreducible: traces
(5, 1, −1, 0, 0, 1, α, ᾱ) with α² + α + 3 = 0 verified in F_p at two primes
(`G7–G9`). Uniqueness of the completion re-established by an independent
search at two primes: mod-p solutions are a superset of exact solutions, the
count is 1 at both primes, and the Klein representation exists — hence
exactly one exact completion, and it is the packet's (`G10–G11`). Molien by
a different engine (F_p, primitive 330th root, integer recovery below the
bound 660·5·C(50,4), two primes agreeing): **M₁ = 1, M₁₁ = 12, M₁₂ = 16,
M₂₅ = 189, M₃₄ = 576, M₃₅ = 637 all reproduce**, with i₃ = 1, the a_k
profile (0 on 1–4, ≥ 1 on 5–46), a₅ = 1, a₁₁ = 2, and ambient degrees
{3} ∪ [5,40] (`M2–M8`).

## R6 — completeness of the flags: **CONFIRMED, with two minor additions**

The four named flags (χ conflation; dim-3 fibres not excluded; PIN converse
open; disconnected branch unbounded by sealed d = 35 data) plus §7.2's two
further bullets (no cohomology-and-base-change; χ₀ fixed only mod 55) cover
every material gap I could construct. Specifically checked and found sound:
the §3.1 spectral-sequence positions (no differential from or to the q = 3
row touches E^{0,1}, E^{1,1}, E^{0,2}, E^{2,1}, so the three J3 statements
genuinely survive R³q_*O); Lemma NP; Lemma FF's Mittag-Leffler step
(H²(F_x, I^n/I^{n+1}) = 0 in dim 1); the dim-2-at-a-pinned-point case (not a
missing flag — it is carried as the parametric `CONN_dim2` menu row and
excluded from the joint dichotomy by its stated hypothesis); the h² = 0
corollary's two named conditions, including that "isolated in supp R²"
rests on the sealed incidence consumed from the authority (B24), which this
packet is entitled to cite. Two additions, neither blocking:

1. **Placement:** the terminus-model caveat (n_x read on Z; the dichotomy is
   model-scoped) lives in §6.4 but is not repeated as a §7.2 bullet. Content
   is present; a reader skimming only §7 would miss it.
2. **Process:** `verifier.py` replays only `j1_molien.py` and
   `pinned_points.py`; the constancy checks C13–C19/C25–C33 re-read the
   stored `menus.json` (its asserts run only in the §9 manual replay — which
   I performed, byte-identical). And check C14's per-entry loop does not
   consult the entry labels: the C11-factor constancy is really carried by
   the transitivity argument (4 rows × 5 components, fixed-point-free
   residual 5-cycle ⇒ one component per receiver point per row), whose
   ingredients are checked at B3/B9 and re-verified here (`D24–D27`); the
   C5 factor is genuinely recomputed from labels (re-done independently,
   `D28`). §4's "recomputed, not quoted" is fully earned only on the C5 side.

## Corrections (exact, all non-blocking)

1. §2.2 / A16: add the semigroup closure sentence so "exactly {k ≥ 5}" is
   window-free: a₅,…,a₉ ≥ 1 and C[X] a domain ⇒ a_k ≥ 1 for all k ≥ 5.
2. C14: either compute the C11 deposits from the entry labels (as C16 does
   for C5) or rename the check to what it verifies (ingredients of the
   transitivity argument).
3. Cosmetic: §2.3 proof phrase "a character of order m/gcd" is garbled; the
   operative hypothesis is a ≢ 0 (mod m) with m prime, which is what is used.

## Verdict

| target | verdict |
|---|---|
| R1 PIN + quintic | **CONFIRMED** |
| R2 χ₀-dichotomy | **CONFIRMED** (scope stated and honored) |
| R3 bridge | **CONFIRMED** |
| R4 RH prunings | **CONFIRMED** |
| R5 anchors | **CONFIRMED** |
| R6 flags | **CONFIRMED** (two minor additions above) |

**The packet may seal.** The χ₀ ≡ 35 (mod 55) dichotomy survives: it is
correct as a necessary condition, at map level, for the d = 35 class, on the
terminus model, in the smooth-fibre zero-defect row, with all nine pinned
points on the 1-dimensional-fibre locus — and the packet nowhere claims more.
No degree is excluded; all 22 cells and both Stein branches remain live.
**Problem E remains OPEN.**

## Referee artifacts

`referee_group_character.py`, `referee_molien_fp.py`, `referee_quintic.py`,
`referee_dichotomy_menus.py` (packet root; python3 stdlib only; each prints
PASS/FAIL lines and a final OK marker; all pass). No existing file was
modified; the replay left `results/` byte-identical.
