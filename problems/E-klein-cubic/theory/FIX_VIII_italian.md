# FIX VIII — The Italian program: the 55-cycle descent

Opened 2026-08-06 on user direction: hunt a CONCATENATION OF
CLASSICAL GEOMETRIC MOVES (projections, blowups, linear sections,
chord constructions, residual intersections) realizing the
G-unirationality, with the intermediate-Jacobian geometry (Note VI)
as the hint for where to start. DRAFT-FOR-DERIVATION; every claim
below is tagged hand/machine.

## 1. The projection move, and what it immediately gives

**Proposition 1 (machine-verified, `cycle55.py`, 55/55).** For each
involution `σ`, the linear projector `π_σ = (I − σ)/2 : P(W) ⇢
P(V₋(σ)) = L_σ` lands in `X` (the V4-lines lie on `X`), and
commutes with `C_G(σ) = D12`.

Consequences (hand, all elementary given Prop 1):

- **(a) Index 1.** `π_σ` is a `D12`-equivariant rational map
  `P(W) ⇢ X`, i.e. an `L`-point of the twisted cubic `X_tw` for
  `L = C(P(W))^{D12}`, `[L : K_proj] = [G : D12] = 55`. With the
  degree-3 points from line sections, `gcd(55, 3) = 1`:
  **`X_tw` has index 1 over `K_proj`.** (New; never recorded.)
- **(b) L-unirationality.** `X_tw ⊗ L` has an `L`-point, so by
  Kollár it is `L`-UNIRATIONAL. The headline is exactly the
  descent of this across the degree-55 extension `L/K_proj` —
  55 ≡ 1 mod 3, so this is a STRUCTURED instance of the
  prime-to-3 descent problem for cubic hypersurfaces (the open
  Coray/CSD circle), with far more geometry than the general case:
  the 55 conjugate parameterizations are the 55 projections, and
  the descent obstructions live in the CM abelian fivefold of
  Note VI (computable arithmetic).
- **(c) The 55-cycle.** `Z(v) = {π_σ(v)}_{55}` is a G-equivariant
  degree-55 cycle-valued map, degree ≡ 1 mod 3. The Italian
  program in one sentence: FIND A CANONICAL (G-equivariant,
  rational-in-v) REDUCTION OF `Z(v)` TO A SINGLE POINT OF `X`.
  Any such reduction closes the headline positively.

## 2. The triangle calculus (first move layer)

Machine-verified structure (`cycle55.py` at p = 67, on GATE's
explicit group):

- 165 commuting pairs of involutions, arranged in 55 V4-triples;
  the three lines of a V4 pairwise meet (vertex orbit of size 165,
  stabilizer V4 — these are the χ-vertices of C5-era) and span a
  PLANE `Π_{V4}` with **`X ∩ Π_{V4} = L₁ ∪ L₂ ∪ L₃`** — in the
  normal frame this is the identity `F|_{a=b=0} = xyz`: the 55
  V4-triangles are PLANE SECTIONS of `X` (hand, one line).
- **The Menelaus axis.** For `p_i = π_i(v)` on the triangle, the
  chord-triple `c_i = chord(p_j, p_k)` (third intersection; for a
  triangle this is `line(p_j, p_k) ∩ L_i`) is COLLINEAR — the
  side-ratio computation gives `∏ r(c_i) = −1`, which is exactly
  Menelaus; equivalently the `c_i` lie on the trilinear polar of
  the configuration. Verified 6/6 at random `v`: `c_i ∈ X`, rank
  2. So each V4 yields a canonical LINE `ℓ_{V4}(v) ⊂ Π_{V4}`
  (G-equivariantly in the orbit): a canonical 55-line-valued map.
- **The in-plane 3-adic wall.** In side coordinates the chord
  dynamics is `T: r_i ↦ −r_j/r_k`, and `T³: r_i ↦ −(r_k/r_j)³` —
  heights CUBE; no finite in-plane chord word collapses the triple
  to a canonical point. Structural reason: on the triangle (a
  degenerate cubic curve) every chord-reachable canonical class
  has degree `3k + 3m ≠ 1`. This is the familiar mod-3 wall of
  cubic point-descent, localized. THE ESCAPE MUST BE CROSS-V4.

## 3. The move catalog to explore (cross-V4 layer) — experiment and assess

Every item is a canonical construction; each gets machine-tested
for collapses/degeneracies (a degeneracy = a canonically smaller
cycle = progress). Cycle degrees mod 3 are tracked; target: a
canonical cycle of degree ≡ 1 mod 3 descending toward 1.

1. Cross-V4 chord cycles: G-uniform chords over the noncommuting
   pair-orbits (sizes 110 — products of order 3 — and larger); the
   110-orbit has degree ≡ 2 mod 3. Compositions `55 → 110 → …`
   change residues; enumerate reachable degrees.
2. The 55 Menelaus axes: full Plücker rank 10 at random `v`
   (machine — no linear coincidence), but their incidence/secant
   geometry is unexplored: transversal lines, common quadrics at
   SPECIAL `v` (v on X, v on the Hessian quintic, v on plus-planes
   — the loci where the program's other geometry sits).
3. Axis-triangle recursion: `ℓ_{V4}(v)` meets OTHER triangles'
   planes in canonical points (55 × 54 point-schemes); ranks and
   coincidences to be measured.
4. Canonical curves through structured subcycles: through 7 points
   of P⁴ passes a UNIQUE rational normal quartic (n+3 rule) — no
   7-suborbits exist, but vertex/point mixtures reach 7 (e.g.
   vertex + its two lines' points + …): enumerate the G-orbits of
   such 7-configurations inside the canonical cycles.
5. The conic-bundle overlay (the IJ hint, Note VI): over each `Π_σ⁺`
   the discriminant splits as `E_σ ∪ K_c`; the six sextet points on
   `K_c` are canonical; combine with the triangle calculus (the
   plus-planes meet the triangles in vertex/line data) — the CM
   structure prices any descent obstruction.
6. Tangent-line construction over canonical curve families (the
   classical unirationality engine): needs an IRREDUCIBLE G-stable
   base family of lines; the Fano-surface G-invariant curves (the
   invariant quadric section of S, if irreducible) are candidates —
   unexplored.

## 4. Status

- Facts (a)-(c) and the triangle calculus: recorded, machine-anchored.
- The wall: in-plane moves cannot finish (mod-3, §2); everything
  now aims at the cross-V4 layer where 55 ≡ 1 mod 3 gives
  combinatorial room the classical single-cubic theory never had.
- Relation to the parallel threads: GATE's 13-dim candidate space
  at d = 34 is the LINEAR-SYSTEM face of the same hunt (its
  landing cone is a cubic cone in P¹² — computation FIX-VII-LAND,
  queued); the Italian face works with nonlinear geometric moves
  where degrees stay tiny. Either face closing = the headline.

## 5. First sweep results and Correction VIII-a (FIX-VIII-MOVES, 2026-08-06)

**Correction VIII-a.** §3 item 1 claimed a 110-element pair-orbit;
FALSE (worker-caught): the order-3-product pairs number 330 in two
165-orbits, and ALL six pair-orbits have size ≡ 0 mod 3
((2,165),(3,165),(3,165),(5,330),(5,330),(6,330), director-
replayed). No first-layer cross-V4 chord cycle moves the residue.

**The census (the sweep's structural yield).** The G-action on the
55 involutions is PRIMITIVE — no equivariant merging rule exists;
the 55-cycle is combinatorially irreducible. Reachable canonical
degrees from the full chord/axis catalog: {11, 55, 66, 110, 165,
330}, of which only 55 is ≡ 1 mod 3. Transitive G-sets of size
≡ 1 mod 3 are exactly 1, 55, 220; the composite 22 = 11 + 11
(both A5-classes) is the unique sub-55 target, and it requires a
canonical point per A5 — constant versions are dead (`W^{A5} = 0`,
and the 55 D12-fixed points miss X). Axes: full Plücker rank at
every special source; the Hessian curve is the unique
DEGENERATION-FREE source locus found (F4). The naive move layer
is CLOSED BY MEASUREMENT.

**The two doors, sharpened.**
1. **A5-equivariant constructions** (subsumes the 11-block door):
   ANY A5-equivariant rational map `P(W) ⇢ X` — any degree, any
   image — is a point of `X_tw` over the degree-11 field
   `L₁₁ = C(P(W))^{A5}`, making `X_tw` L₁₁-unirational (Kollár)
   and collapsing the descent gap from 55 to 11. The sealed
   G-ladder emptiness (≤ 24) says NOTHING about A5-covariants,
   whose map-type supply starts at degree 2 (dim 2 at d = 2, 3 at
   d = 3, …). The A5 landing ladder is a small LAND-type
   computation per degree: packet FIX-VIII-A5LADDER.
2. **C-sourced constructions**: the Hessian curve as source locus
   (degeneration-free, and where Note VI's CM geometry sits).
