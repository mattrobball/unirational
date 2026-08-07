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

## 5. The centralizer obstruction — the keystone, and the linear-source case (2026-08-06)

Proposed by the user in exactly this form: "the [σ-stable linear
stratum of the source] is stabilized by σ and has to map to this
locus, which admits no non-constant maps from a projective
space." Made precise below, it is Cor T3.1 with the CENTRALIZER
replacing the center (the variant the T-gate anticipated for
local stabilizers), and on the measured stage-2 data it kills
every LINEAR source at once. DRAFT-FOR-DERIVATION; hypotheses
carry sealing assignments.

**Corollary IX.1 (centralizer obstruction).** Let a finite `G`
act faithfully on a smooth projective `Y` (char 0), `σ ∈ G` an
involution such that no `ρ(σ) = ±id` degeneration occurs
(automatic for centerless `G` and faithful `ρ`), and set
`N = C_G(σ)`. Assume:

- (a) no positive-dimensional irreducible component of `Y^σ`
  contains a rational curve;
- (b) `Y^N = ∅`.

Then for EVERY faithful linear representation `V` of `G` there is
NO `G`-equivariant rational map `P(V) ⇢ Y` — dominant or not —
and none `V ⇢ Y` either (embed `V ⊂ P(V ⊕ triv)`, again linear
and faithful). In particular `Y` is NOT WEAKLY VERSAL: the
generic twist of `Y` has no rational point (D-R dictionary).

*Proof.* `ρ(σ) ≠ ±id` gives `V = V₊ ⊕ V₋` with both eigenspaces
nonzero; `P(V₊)` is nonempty, irreducible, rational, pointwise
σ-fixed, and `N`-STABLE — `N` commutes with `σ`, so preserves
each eigenspace; this is where linearity of the representation
enters. Let `φ : P(V) ⇢ Y` be equivariant; resolve equivariantly
(char-0 equivariant Hironaka; [I, Prop 3.3]): `π : X̃ → P(V)` a
tower of blowups along smooth `G`-invariant centers with
`φ̃ : X̃ → Y` a morphism. CLAIM: `X̃` carries an irreducible,
`N`-stable, pointwise-σ-fixed, RCC closed subvariety `F̃`.
Induction up the tower from `F₀ = P(V₊)`. At a stage with center
`Z`: if `F ⊄ Z`, take the strict transform `F′` (the blowup of
`F` along `F ∩ Z` — irreducible, birational to `F` hence RCC,
`N`-stable since `N` preserves `F` and `Z`, pointwise σ-fixed as
the closure of a fixed open set). If `F ⊆ Z`, then `σ` acts on
the normal bundle `N_Z|_F` over `id_F`; split `N_Z|_F = N₊ ⊕ N₋`
into σ-eigen-subbundles (ranks constant over irreducible `F`),
pick `λ` with `N_λ ≠ 0` (`+` if both), and set
`F′ = P(N_λ|_F) ⊂ E|_F`: a projective subbundle of the
exceptional — irreducible, RCC [I, Lem 4.3], pointwise σ-fixed
(fiber points are σ-eigendirections), `N`-stable (`N` stabilizes
`F` and `Z` and commutes with `σ`, hence preserves `N_λ`). At the
top, `φ̃(F̃)` is an irreducible RCC closed subvariety of `Y^σ`
(pointwise: `φ̃(x) = φ̃(σx) = σφ̃(x)`); by (a) and going-down
[I, Lem 4.2] it is a single point `y`; `N`-stability of `F̃` and
equivariance give `n·y = y` for all `n ∈ N`, so `y ∈ Y^N`,
contradicting (b). ∎

Note what is NOT used: dominance (nondominant and even the
would-be constant maps are excluded — a constant equivariant map
needs a `G`-fixed point, and `Y^G ⊆ Y^N = ∅`), and any covariant
or degree data. This is the all-degree, search-free shape the
program has hunted since E34.

**Instantiation on the V₁₄** (measured mod 397 by the in-flight
FIX-IX-V14MODEL worker; each hypothesis carries its seal):

- `N = C_G(σ) = D12`: sealed group fact (FIX-A0; independent of
  the variety).
- (a): `V₁₄^σ` = one irreducible degree-6 genus-1 curve ⊔ 2
  reduced points (pieces `C2[+1]: d1 e6 g1 ncomp1`,
  `C2[−1]: d0 e1 ×2`). SEAL NEEDED: exactness at BOTH primes and
  SMOOTHNESS of the sextic — the M2 `g1` is arithmetic genus, and
  a nodal-RATIONAL sextic would void (a); smoothness of the curve
  is the load-bearing check. Char-0 statement: the model lives
  over `Q(√−11)`; a char-0 run or a two-prime + Lefschetz-
  consistency seal with explicit smoothness certificate.
- (b): `V₁₄^{D12} = ∅` — all three character pieces empty; the
  invariant pencil in `M^{D12}` has rank `∈ {6,4}`, never 2, with
  the three rank-4 points at the Pfaffian-cubic roots (an
  invariant, char-0-able statement). SEAL: both primes + the
  pencil argument in char 0.
- `V₁₄` smooth projective of dim 3, degree 14: stage-1 seal in
  flight.

**Conclusion (pending the seals): the V₁₄ action of PSL₂(F₁₁) is
not weakly versal** — no equivariant rational map from any
faithful linear source exists, and the generic twist of `V₁₄` is
pointless. This is new-theorem territory: CTZ's scope is index
≥ 2; no literature covers the V₁₄ action.

**Corollary IX.2 (the Remark-10.10 disjunction collapses).**
Granting IX.1's seals: `ed_C(PSL₂(F₁₁)) = 3 ⟺ the Klein cubic
is G-unirational.` *Proof.* If `ed = 3`, a 3-dimensional versal
`G`-variety exists; the standard witness (a compression of a
faithful representation) is unirational, hence RC, hence by
Prokhorov `G`-birational to the Klein cubic or the V₁₄; versality
is a `G`-birational invariant; V₁₄ versal ⟹ weakly versal
contradicts IX.1; so the Klein cubic is versal, hence very versal
by D-R Thm 10.5 (smooth invariant cubic), i.e. `G`-unirational.
Converse: E37. ∎ The headline becomes SINGLE-TARGET: Dolgachev's
instance is exactly "Klein negative", CSD's instance exactly
"Klein positive"; the V₁₄ can no longer independently supply
`ed = 3`.

## 6. The spin flank — where the σ-argument provably stops (open)

Sources `P(V)` with `V` a faithful `SL₂(F₁₁)`-representation on
which `−1` acts as `−id` (the projectively-linear `G`-actions;
e.g. `P(U) = P⁵`, the Tschinkel–Zhang stable factor — note the
source dichotomy is clean: a projective `G`-source is `P(linear)`
or `P(pure spin)`, since a mixed `±` action of `−1` is non-scalar
and does not descend). Here the lift `σ̃` has order 4
(`C_{SL}(σ̃)` = the nonsplit torus `C12`),
`P(V)^σ = P(V_{+i}) ⊔ P(V_{−i})`, and the D12-reflections INVERT
`σ̃`, swapping the two eigenplanes: each is only `C6`-stable. The
IX.1 argument then forces only a D12-STABLE PAIR of `C6`-fixed
points in `V₁₄^σ` — and `V₁₄^σ` contains exactly that: its two
isolated points have stabilizer exactly `C6` (the 110-orbit) and
are swapped by D12 (forced: `V₁₄^{D12} = ∅`). The escape shape
and the measured geometry MATCH, so spin sources are genuinely
not obstructed at the σ-level. This flank is immaterial for weak
versality and for IX.2 (both quantify over linear sources only);
it is exactly the face where the T-Z twisted-stable equivalence
and its order-2 Schur–Brauer class live. Closing or exploiting it
is the V4/Q8-chain analysis (the D12-endpoint system on
`E ⊔ {2 pts}`); note `U|_{Q8}` is expected quaternionic (no
1-dim summands ⟹ `P(U)^{V4} = ∅`), so the chain combinatorics
differs from Problem F's — named next derivation after the
seals.
