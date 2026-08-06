# FIX VII — The W-carrier condition

Opened 2026-08-06 (director). Status: DRAFT-FOR-DERIVATION, same
trust class as Note IV/VI hand-work — machine/literature checks
named inline. This note records a new GLOBAL necessary condition on
any equivariant parameterization, independent of the D12-localized
machinery that FIX-D2 proved insufficient.

Throughout: `G = PSL(2,11)`, `W` the 5-dim Weil representation,
`W_Q` the 10-dim Q-irreducible with `W_Q ⊗ C = W ⊕ W̄`,
`F := Q(√−11) = End_{Q[G]}(W_Q)` (character field; Schur index 1 —
witnessed concretely by Roulleau's `Z[ν]`-period lattice, Note VI
§2.6), `E = E_{−11}` the CM(−11) elliptic curve (`j = −32768`).

## 1. The auto-CM lemma

**Lemma 1.** Let `H` be a rational polarizable Hodge structure of
weight 1 with `G`-action such that `H ≅ W_Q` as a `G`-module. Then
the associated abelian fivefold `A` satisfies `A ~ E⁵` (isogeny),
automatically.

*Proof.* `H ⊗ C = W ⊕ W̄` and `W ≇ W̄`, so the only 5-dimensional
`G`-submodules are `W` and `W̄`; since `H^{1,0}` is `G`-stable of
dimension 5, `H^{1,0} = W` (or `W̄`; wlog). `F` acts on `H`
commuting with `G` (Schur), and acts on the isotypic components
`W`, `W̄` by scalars (the two embeddings), hence preserves
`H^{1,0}`: so `F ⊂ End_{HS}(A)` with signature `(5,0)`. Then
`H₁(A,Q)` is a 5-dimensional `F`-vector space; choosing an
`F`-basis splits it into five `F`-lines rational over `Q`, each
giving an elliptic isogeny factor with CM by `F`; class number
`h(−11) = 1` makes every factor isogenous to `E`. ∎

Consequences: (i) Adler's `J(X) ≅ E⁵` is demystified — it is pure
representation theory (any `G`-abelian fivefold of type `W_Q` is
`~ E⁵`), not a special property of the Klein cubic. (ii) In Note
VI, the CM condition adds NO constraint beyond the representation
condition; everything below is therefore stated at the level of
`W_Q`-multiplicity.

## 2. The carrier theorem

**Theorem 2 (W-carrier condition).** Suppose a `G`-equivariant
dominant rational map `f : P(W) ⇢ X` exists. Let `Z → P(W)` be ANY
`G`-equivariant resolution of indeterminacy (composition of blowups
in smooth `G`-stable centers; exists functorially in char 0), with
induced morphism `g : Z → X`. Then some center `Y` (a `G`-orbit of
curves or surfaces, possibly lying over earlier exceptional loci)
satisfies

    mult_{W_Q}( H¹(Y, Q) ) ≥ 1 ,

and the corresponding sub-Hodge structure is `G`-isogenous to `E⁵`
(Lemma 1). Equivalently: the Weil fivefold appears in the Albanese
of the fundamental locus of every equivariant resolution.

*Proof.* `g` is a proper surjection of smooth projectives, so
`g* : H³(X,Q) → H³(Z,Q)` is injective (split by
`α ↦ g_*(α ∪ η)/c` for `η` a `G`-invariant multisection class,
e.g. a power of a hyperplane class with `g_*η = c·1`, `c > 0`).
`H³(X) ⊗ C = W ⊕ W̄`. The blowup formula gives
`H³(Z) = H³(P⁴) ⊕ ⊕_i H¹(Y_i)(−1) ⊕ ⊕_j H³(S_j)` over curve
centers `Y_i` and surface centers `S_j`, `H³(P⁴) = 0`, and for a
surface `H³(S) ≅ H¹(S)(−1)` (Lefschetz); iterating stages only
adds more terms of the same shape. So `W_Q` embeds `G`-equivariantly
into `⊕ H¹(centers)(−1)`, hence into some `H¹(Y,Q)` (isotypic
projection). ∎

Remarks. (a) The condition is invisible to the profile theory: the
sealed forced base locus (55 lines, 55 plus-planes, sweeps) is
entirely `H¹ = 0`. Any parameterization needs MORE base structure
than anything the FIX program ever forced — a new layer.
(b) For a disconnected center `Y = G ×_H Y₀` (orbit with stabilizer
`H`), Frobenius reciprocity: `mult_{W_Q}(Ind_H^G H¹(Y₀)) =
mult_{Res_H W_Q}(H¹(Y₀))`. This drives the ledger below.
(c) Centers of later blowup stages can map to POINTS of `P(W)`
("tower carriers"): they carry no projective degree downstairs and
must be treated by stabilizer bookkeeping, not degree counting.

## 3. The carrier ledger (Chevalley–Weil)

For a `Γ`-cover `C → P¹` branched with local monodromies `c_i` and
`V` a nontrivial irreducible: `mult_V(H¹(C,C)) = −2 dim V +
Σ_i (dim V − dim V^{c_i})`, gated by existence of a generating
tuple with `∏ c_i = 1`. Fixed-space dimensions on `W` (from the
character `χ_W = (5, 1, −1, 0, 0, 1, λ, λ̄)` on classes
`(1,2,3,5A,5B,6,11A,11B)`, `λ = (−1+√−11)/2`):

| order of c | 2 | 3 | 5 | 6 | 11 |
|---|---|---|---|---|---|
| dim W^c | 3 | 1 | 1 | 1 | 0 |
| contribution 5 − dim W^c | 2 | 4 | 4 | 4 | 5 |

Need `Σ contributions ≥ 11` (so that `mult_W ≥ 1`).

**Irreducible G-carriers.** Minimal branch data `(2,3,11)`:
`mult_W = 1`, genus `2g−2 = 660·5/66 = 50`, `g = 26` — the
Hurwitz-class of `X(11)`, the level-11 modular curve (`PSL(2,Z) =
C2 * C3 ↠ G` with `xy` of order 11). Next: `(2,5,11)` g = 70,
`(2,6,11)` g = 81, `(3,3,5)` g = 45, `(2,2,3,11)` g = 136(+).
So an irreducible carrier has genus ≥ 26 among 3-point covers
(4-point data only grows; positive-genus base only grows).
VERIFIED (machine + literature): `Sing(Hess F)` is a curve of
degree 20 with Hilbert polynomial `20i − 25`, hence `p_a = 26`
(direct M2 computation mod 32003, `director_probes_20260806/
hess_probe.m2`), and its identification with the modular curve
`X(11)` is Klein's classical construction, treated rigorously by
Adler–Ramanan (LNM 1644) — modern account in arXiv:2409.02589. So
`P(W)` CONTAINS a canonical minimal carrier: the Hessian curve.
Generating-tuple existence for the ledger entries is
machine-checked (`triples_probe.py`: (2,3,11) in G, (3,3,5) in A5,
(5,5,5) and (5,5,11) in F55 — all TRUE).

**Induced carriers** (orbit of `[G:H]` curves, stabilizer `H`,
condition `Res_H W ⊂ H¹(C₀)`):

- `H = A5` (index 11, two classes): `Res_{A5} W = V₅` (characters
  match: `(5,1,−1,0,0)`). Minimal: `(3,3,5)`-covers, `mult = 2`,
  `g(C₀) = 5` (generating triple exists: e.g. `(123),(245)`,
  product of order 5, generates). Ledger: 11 curves of genus 5.
- `H = F55 = C11⋊C5` (index 12): `Res W = Ind_{C11}^{F55}(ψ_QR)`,
  irreducible 5-dim. `(5,5,5)`-covers: `mult = 2`, `2g−2 =
  55·2/5 = 22`, `g = 12` (triples exist; two distinct Sylow-5s
  generate). Ledger: 12 curves of genus 12.
- `H = C11` (index 60): need the QR character quintet in
  `H¹(C₀)`; minimal `C11`-curves `(11,11,11)`, `g = 5`
  (Lefschetz curves `y¹¹ = x^a(x−1)^b`; which character sets occur
  is classical — TO-CHECK which `(a,b)` give the QR set). Ledger:
  60 curves of genus 5.
- `H = D12` (index 55, over the involution/D12 geometry):
  `Res_{D12} W = W₊ ⊕ W₋` (3+2, σ-eigen). dim 5 forces
  `g(C₀) ≥ 3`. Ledger: 55 curves of genus ≥ 3.
- Irregular `G`-surfaces: reduce to curves via Albanese; same
  ledger through `Alb`.
- Tower carriers over a point orbit with stabilizer `H`: the same
  `H`-ledger, with the added constraint that `C₀` must embed in
  the exceptional geometry over the point (starts in `P³ = P(T_p)`
  with the `H`-representation structure) — finite list, unexplored.

**Lemma 3 (free orbits are representation-theoretically free).**
For a center orbit with TRIVIAL stabilizer (e.g. over a 660-point
orbit), `mult_{W_Q}(Ind_1^G H¹(C₀)) = 10·g(C₀)`, so ANY center of
genus ≥ 1 carries `W_Q`. On free orbits the carrier condition has
no representation-theoretic content; its content there is purely
Hodge-local — the singularity of the map at such a point must be
bad enough to force an irregular center in its resolution tower
(elliptic-cone-type or worse). The representation theory bites
exactly on the SMALL orbits (the arrangement), where stabilizers
are large: over D12-points a carrier needs a genus ≥ 3 cover with
`W₊ ⊕ W₋`, over the arrangement lines/planes similar induced
conditions. This inversion — rigid where the profile theory
already lives, soft on free orbits — is structural, not an
artifact.

## 4. What this changes

**Positive program.** Any ansatz must include a carrier in its base
locus. The canonical candidate is the Hessian curve
(`X(11)`-model, deg 20, g 26 — pending the TO-VERIFY above);
cheaper alternatives are the induced configurations (11 × genus-5
A5-curves, etc.). This is the sharpest structural guide the
construction program has: the (3,6)-dictionary windows should be
re-run relative to a system containing a carrier.

**Negative program — honest assessment (superseding the first
draft's "race" framing, which was overstated).** A dimension-count
"cost of containing a carrier" argument only makes sense for
carriers at SPECIFIED loci: for those, vanishing on the carrier is
a condition system whose codimension one can try to lower-bound
within a profile slice. But the condition is existential — the
solution's base locus, wherever it happens to fall, must contain a
W-tower — and by Lemma 3 free-orbit towers satisfy the
representation condition with any irregular center. So there is no
cheap uniform dimension race. What the condition honestly gives
the negative side is a per-window trichotomy: at a fixed window
(e.g. `d = 34`, `(1,6)`, slice ≤ 16) every hypothetical solution
must have (a) an arrangement-supported carrier — where the induced
representation conditions are strong and the FIX-D2 jet towers
already measure the local freedom, or (b) a new positive-degree
carrier orbit — bounded degree bookkeeping within the window, or
(c) an irregularity-forcing isolated singularity on a big orbit —
a local mixed-Hodge condition on the germ, not excluded by any
current machinery. Branch (c) is why this note does NOT claim a
route to the effective degree bound; it is the same class of
"local freedom outruns local constraints" wall as FIX-D2, now with
a Hodge-theoretic name.

**Where the condition has unconditional teeth: minimal-degree
windows of the covariant ladder.** For the SMALL sealed regime
(the ≤ 24 ladder cutoff of E25 and the ≤ 30 slice cutoff), all
candidate systems are explicitly enumerable; a solution at such
degrees would need its base locus to hide a genus ≥ 3-per-orbit
tower inside slices of dimension ≤ 16 with the arrangement already
consuming the multiplicity budget — the condition can be checked
mechanically against any explicit candidate, and gives a fast
disqualification test for any future claimed construction.

## 5. Verification obligations

1. Character/fixed-dim table against a machine character table of
   `PSL(2,11)` (quick CAS check — fold into the next packet).
2. ~~Generating-tuple existence~~ DONE (probe `triples_probe.py`,
   2026-08-06: all four TRUE).
3. ~~`Sing(Hess F)` degree/genus~~ DONE (probe `hess_probe.m2`:
   dim 1, deg 20, Hilbert poly `20i − 25`, `p_a = 26`);
   identification with `X(11)` is literature-anchored (Klein;
   Adler–Ramanan LNM 1644; arXiv:2409.02589). Smoothness of the
   modular-prime model not checked (irrelevant for the anchor).
4. Lemma 1's Schur-index-1 input — literature-anchored (Roulleau's
   lattice) — no further check needed.
5. Blowup-formula bookkeeping (Thm 2) is classical; no check.

## 6. Next derivation: the Hessian window

The positive-side ansatz is now concrete: covariant systems whose
base locus contains the Hessian curve `C₂₀ = Sing(Hess F)`. The
right first computation is EQUIVARIANT: the `G`-character of
`H⁰(P⁴, I_{C₂₀}(d))` equals `char H⁰(O(d)) − char H⁰(C₂₀,
O(d)|)` for `d` beyond regularity, and the character of
`H⁰(X(11), O(1)|^{⊗d})` is computable in closed form by
equivariant Riemann–Roch / the Chevalley–Weil-type formula for the
`(2,3,11)`-cover with the local rotation data of the line bundle.
Then `mult` of the landing-covariant type in the `I_{C₂₀}`-graded
piece, degree by degree, gives THE HESSIAN WINDOW: the first `d`
at which a map-type covariant vanishing on the Hessian curve can
exist. Compare against the sealed cutoffs (≤ 30 empty; first
window 34 via `(1,6)`).

### 6.1 EXECUTED (director probes, 2026-08-06; full consistency battery green)

Fixed-point data of `C₂₀ = Sing(Hess F)`, machine-extracted mod 397
(`hess_fix*.m2`), all counts matching Chevalley–Weil (6 / 4 / 5)
and topological Lefschetz:

- **Order 11** (cyclic frame, `g = diag(ζ^a)`, `a = (1,9,4,3,5)`,
  the QR set): fixed points = the five coordinate points, ALL on
  `C₂₀`, smooth (radical ideal; tangent-cone mult 1; the 2-dim
  jacobian kernel is Euler + tangent). Tangent at `e_i` is the
  `e_{i+1}`-direction: tangent weights `ζ^{a_{i+1}−a_i}` =
  `ζ^{8,6,10,2,7}` — exactly the quadratic NON-residues. L-weights
  `ζ^{−a_i}` (SL-lift canonical).
- **Order 2** (normal-form frame): all SIX fixed points lie in the
  plane `P(V₊)` (`C ∩ P(V₋) = ∅`); tangent weights forced `= −1`
  by finite-order rigidity. Hence `χ_d(σ) = 3` for ALL `d`.
- **Order 3**: fixed locus is two lines and a point; `C` misses the
  point and meets each line in 2 points (split quadratics mod p);
  tangent weights `(ω, ω, ω², ω²)`, L-weights `(ω², ω², ω, ω)`.
  Hence `χ_d(ρ)` cycles `(2, −2, 0)` for `d ≡ (0,1,2) mod 3`.
- **Orders 5, 6**: empty fixed sets (stabilizers on `X(11)` have
  orders 2, 3, 11 only) — `χ_d = 0` identically.

Atiyah–Bott then gives the FULL `G`-character of `H⁰(C, O(d)|)`
for every `d ≥ 3` (`H¹ = 0`), i.e. the complete `G`-module
structure of the coordinate ring of `X(11) ⊂ P(W)` — banked in
`hess_window.py`. Verification battery, all green: character-table
orthogonality (table itself machine-verified against OSCAR/GAP
`character_table("L2(11)")`, `chartab.out`, including the power
map `11a² ∈ 11b`); eigenvalue-multiset traces per class; every
`mult_V(H⁰(L^d))` a NON-NEGATIVE INTEGER for `d = 3..64` with
`Σ mult·dim = 20d − 25`; `H¹(C)` mults (CW: `W ⊕ W̄ ⊕ 10^{⊕2} ⊕
11^{⊕2}`, dim 52 = 2·26) reproduce all three Lefschetz numbers.
(Note `J(X(11)) ⊃ E_{−11}⁵` via Lemma 1 — the canonical carrier
indeed carries the Weil fivefold, as Theorem 2 requires.)

**The table** (`mult_{W̄}` = W-valued covariant tuples; ideal-part
is the LEFT-EXACTNESS LOWER BOUND `mult(S^d) − mult(H⁰(L^d))`):

| d | S^d supply | on-curve | ideal ≥ |
|---|---|---|---|
| 3–5 | 0,2,1 | 0,2,1 | 0 |
| 6 | 2 | 0 | **2** |
| 10 | 10 | 2 | 8 |
| 25 | 189 | 4 | 185 |
| 34 | 576 | 6 | **570** |
| 36 | 706 | 5 | 701 |
| 43 | 1375 | 7 | 1368 |

Two structural readouts:

1. **Containing the Hessian curve is representation-cheap.** The
   on-curve column stays in single digits through `d = 64` (3–10).
   At the `d = 34` gateway the carrier costs ≤ 6 of the ≤ 16 slice
   dimensions: THE CARRIER CONDITION DOES NOT OBSTRUCT THE
   GATEWAY. The positive ansatz "profile `(1,6)` at `d = 34` +
   Hessian curve in the base locus" is dimensionally viable, and
   supply exists from `d = 6` onward.
2. **The bound has slack at special small degrees**: at `d = 4`
   the gradient tuple `∇(Hess F)` vanishes on `C₂₀` by definition
   yet the bound reads 0 — restriction to `H⁰(L⁴)` is not
   surjective there. Ideal-parts are lower bounds, never counts.

CAVEAT (scope): the table counts SUPPLY of carrier-compatible
covariant tuples. It does not produce maps: landing in `X`,
dominance, and the full profile constraints still apply on top.
The statement with teeth is negative-space: the carrier condition
had the potential to kill the gateway window and DID NOT.
