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

## 4. Can the dP/Fermat toolbox close V₁₄? NO — with proofs (2026-08-06)

The tools that closed the del Pezzos (Duncan) and most cubic-
threefold actions (CTZ): (i) projection from a G-fixed point;
(ii) chords through the fixed pair of an index-2 subgroup; (iii)
induction from a G-invariant hyperplane section whose induced
action is G-unirational (CTZ Prop 3.5). [Correction IX-a,
2026-08-06, user-caught: the first committed version called (iii)
"the Fermat-closer" — WRONG. The Fermat cubic is NOT closed: the
Clebsch-section induction closed C₃×S₅, C₃×A₅, C₃×F₅ on the
Fermat (section = the Clebsch cubic surface, residual
S₅/A₅/F₅-actions G-unirational by Duncan-type surface results),
while C₉⋊C₃ on the Fermat REMAINS OPEN — in the same Theorem-5.1
exception list as the Klein cases. Note the asymmetry: C₉⋊C₃ is
a 3-GROUP, so it is the one open cubic-threefold case that the
CSD conjecture does NOT resolve via D-R's 3-Sylow reduction —
the Klein cases would follow from CSD, the Fermat one would
not.] On V₁₄:

- Full G: (i) dies (M = 10′ irreducible ⟹ no ambient fixed
  points), (ii) dies (G simple), (iii) dies (no invariant
  hyperplane). Same three deaths as on the cubic.
- Subgroup fixed-point tools — CLOSED BY COMPUTATION TODAY
  (`v14_lambda2.py`, `v14_a5fix.py`, `v14_d12fix2.py`, mod 397):
  * `Λ²U = 5 ⊕ 10′` (isotypic projector rank 10 ✓; the correct
    Weil normalization is `S² = −I`, linear closure 1320 — the
    `+1`-sign gives a wrong central structure);
  * `dim M^{A5} = 1`, but the invariant bivector is the
    SYMPLECTIC form of the quaternionic `U|_{2.A5}` — rank 6,
    not decomposable: the unique A5-fixed ambient point is OFF
    the Grassmannian: **`V₁₄^{A5} = ∅`** (mirroring
    `X^{A5} = ∅` on the cubic — the twins agree here);
  * `dim M^{D12} = 2`, and the invariant pencil's rank
    distribution over `P¹(F₃₉₇)` is `{6: 395, 4: 3}` — minimum
    rank 4 at the three Pfaffian-cubic roots, never 2:
    **`V₁₄^{D12} = ∅`.**
- The induction tool (iii) dies STRUCTURALLY for EVERY subgroup:
  V₁₄ has Fano index 1, so hyperplane sections are K3 surfaces —
  never unirational. (This is also exactly why CTZ's paper stops
  at index ≥ 2.)

**Verdict: the same tools cannot close any V₁₄ case.** What the
machine runs instead (packet FIX-IX-V14MODEL): the σ-fixed
arrangement (`M^σ` = the `U₊∧U₋`-part, `V₁₄^σ` = a linear section
of `P(U₊)×P(U₋)` — the V₁₄-analogue of `E_σ ⊔ L_σ`); `V₁₄^{V4}`
(4-dim pencil space, rank-2 locus expected FINITE — Condition (A)
hinges on it); the curve-orbit census (Iliev–Markushevich: conics
on V₁₄ ↔ lines on the cubic — the 55-line orbit should transfer
to a 55-CONIC orbit on V₁₄, and the projection-move/index-1
story with it); the `10′`-valued ladder with QUADRATIC landing
conditions.
