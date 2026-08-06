# FIX IX — The V₁₄ twin under the machine

Opened 2026-08-06 on user direction ("subject V₁₄ to the cosheaf
machine"), after the user-demanded OPENNESS CONFIRMATION (§1).
DRAFT-FOR-DERIVATION.

## 1. Openness verdict (as of 2026-08-06; all sources archived)

- **The headline** (G-unirationality of the Klein cubic for
  `G = PSL₂(F₁₁)`, ⟺ `ed_C(G) ∈ {3,4}`): OPEN. CTZ
  (arXiv:2502.19598, Feb 2025) lists it as a remaining exception;
  Tschinkel–Zhang (arXiv:2409.08392, Sept 2024) works modulo it
  (their Burnside invariants do not distinguish the twin actions);
  nothing newer resolves it.
- **A₅ (irreducible) on the Klein–Segre pencil**: OPEN (CTZ p.20).
- **F55 on the Klein cubic**: OPEN (CTZ p.18).
- **The V₁₄ twin's G-unirationality**: OPEN, and NOT COVERED by
  CTZ at all — their scope is Fano threefolds of index ≥ 2; V₁₄
  has index 1.
- **Landscape change (July 2026): Scavia, arXiv:2607.25118**
  refutes Duncan's Sylow-detection conjecture (counterexample:
  `(C₇⋊C₃) × C₂` on a degree-2 del Pezzo surface), explicitly
  flagging that the refuted conjecture was one of the two routes
  to `ed_C(PSL₂(F₁₁)) = 3`. The D-R trichotomy is now a clean
  DICHOTOMY: **CSD ⟹ headline YES; Dolgachev ⟹ headline NO;
  still incompatible.** The Sylow-heuristic support for YES is
  gone; YES now rests on CSD alone.

## 2. The twins are twisted-stably equivalent — with a Brauer twist

Tschinkel–Zhang Theorem 1.1: for the Klein pair `(Y, X) = (cubic,
V₁₄)` with their `G`-actions,

    Y × P² × P(V)  ~_G  X × P² × P(V),

`P²` trivial, `V` the irreducible 6-dim representation of
`G̃ = SL₂(F₁₁)` (projectively linear `G`-action). Also [BCDP23,
Thm 4.3]: both actions are birationally rigid, so `Y ≁_G X`
(plain equivariant birationality FAILS — the stable factor is
essential).

**Caveat derived here (do not collapse the avenues):** the
`P(V)`-factor carries the NONSPLIT central extension's cocycle
(Schur multiplier `C₂`). Over `K_proj` the versal twist of `P(V)`
is a Severi–Brauer fivefold whose Brauer class is the image of
the nontrivial extension class — nonzero, period 2 — so the
twisted `P(V)` has no `K_proj`-point and plain G-unirationality
does NOT automatically transfer across Theorem 1.1. What
transfers is `(U_V)` (domination by `P(linear) × P(V)`). The
plain questions for `Y` and `X` are separately open, linked
modulo an order-2 Brauer class — which is itself a NEW invariant
handle: the `V₁₄`-side computations see the Schur class.

## 3. The equivariant model (probe-verified start)

`U` = the 6-dim ("even Weil") irreducible of `SL₂(F₁₁)`: built
explicitly mod 397 (`v14_model.py`): even-function model on
`F₁₁`, Fourier generator normalized by `S² = 11·I` and
`c² = 11⁻¹`; projective closure of `⟨T₆, S₆⟩` is EXACTLY 660 ✓.
Note `1 ⊕ W` FAILS (hand proof: the G-stable codim-5 section of
`Gr(2, 1⊕W)` degenerates to `Gr(2,W)`), so the central extension
is forced — consistent with T-Z's `G̃`.

Plan (packet FIX-IX-V14MODEL): decompose `Λ²U` (15-dim,
center-trivial ⟹ a `PSL₂(F₁₁)`-rep; expect `5 ⊕ 10`-type; the
10-dim summand `M` spans the `P⁹`); construct
`V₁₄ = Gr(2,U) ∩ P(M)` mod p (15 Plücker quadrics restricted to
`P(M)`); verify dim 3, degree 14, smoothness, G-invariance;
fixed-locus arrangement (`V₁₄^σ`, `V₁₄^{C₃}`, `V₁₄^{C₅}`,
`V₁₄^{C₁₁}`, `V₁₄^{V4}` — the Condition-(A)/RY layer and the
cosheaf-machine stage-A analogue); the M-valued covariant ladder
(`mult_M(S^dW*)`, Molien — note the LANDING conditions here are
QUADRATIC (Plücker), not cubic); first landing cones by the LAND
method; small-orbit census on `V₁₄` (lines/conics orbits → small
closed points of the twisted `V₁₄` → its INDEX over `K_proj`,
where hyperplane degree 14 ≡ 2 mod 3 changes the game).
