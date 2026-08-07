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
[Superseded normalization — see §4: the CORRECT Weil
normalization is `S² = −I`, `c² = −1/11` (SL-closure 1320); this
§3 first pass gave only the projective closure.]
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

**Instantiation on the V₁₄ — SEALED 2026-08-06** (packet
`goal_runs_after_c53d89a/FIX_IX_SEAL`, director-run: two engines,
primes 397/199, verifier at fresh prime 353, exact char 0 over
`Q(ζ₁₁)`; the sealing assignments below are DISCHARGED — the
sextic is SMOOTH irreducible genus 1, both hypotheses hold in
char 0, the ambient is smooth pure-dim-3 degree-14 via the dual
Pfaffian-adjoint system, and the Pfaffian-partner identification
with the Klein cubic is machine-verified):

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

**Conclusion (SEALED, modulo only the [I]-lemma layer it cites):
the V₁₄ action of PSL₂(F₁₁) is not weakly versal** — no
equivariant rational map from any faithful linear source exists,
and the generic twist of `V₁₄` is pointless. This is
new-theorem territory: CTZ's scope is index ≥ 2; no literature
covers the V₁₄ action.

**Corollary IX.2 (the Remark-10.10 disjunction collapses).**
`ed_C(PSL₂(F₁₁)) = 3 ⟺ the Klein cubic is G-unirational.`
(Literature inputs: Prokhorov's two-class theorem, D-R Thm 10.5;
machine inputs: FIX-IX-SEAL.) *Proof.* If `ed = 3`, a 3-dimensional versal
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

## 7. Consistency with the T-Z stable equivalence, and the transport lattice (2026-08-06, user-prompted)

The user's check: "aren't the twins G-stably birational?" They
are (§2, T-Z Thm 1.1) — and IX.1 coexists with that for exactly
the reason §2 recorded before IX.1 existed: the stable factor is
not an innocent projective space; it is the SPIN `P(V)` carrying
the order-2 Schur–Brauer class. Mechanically, at both levels:

**(i) Why weak versality does not cross the equivalence.** Twist
Thm 1.1 by a `G`-torsor `T` over `K`:
`Y_T × P² × SB_T ~_bir X_T × P² × SB_T`, where `SB_T` (the
twisted `P(V)`) is a Severi–Brauer fivefold with class
`β_T ∈ Br(K)[2]` = the image of the nonsplit extension class
under `T`'s classifying map. For the generic (versal) torsor
`β_T ≠ 0` (§2), so `SB_T(K) = ∅` and BOTH products are pointless
regardless of `Y_T`, `X_T`: Lang–Nishimura transfers nothing.
"V₁₄'s generic twist is pointless" (IX.1) and "the Klein's
generic twist has a point" (= headline YES, what CSD would give)
can coexist. Sharp complement, for the record: on the liftable
locus `β_T = 0` (torsors lifting to `SL₂(F₁₁)`), `SB_T ≅ P⁵` and
points DO cross both ways (Lang–Nishimura + projection):
`Y_T(K) ≠ ∅ ⟺ X_T(K) ≠ ∅` for every liftable `T`. IX.1 says
nothing about liftable twists — only the generic one, which is
not liftable.

**(ii) Lemma IX.3 (folding; hand, elementary).** (1) Same
central character: `P(C ⊕ C′) ⇢ P(C) × P(C′)`, `[c : c′] ↦
([c], [c′])`, is dominant equivariant. (2) Character flip: for
`B` linear and `D` spin, `(B ⊗ D*) ⊕ D` is SPIN and
`P((B ⊗ D*) ⊕ D) ⇢ P(B) × P(D)`, `[f : v] ↦ ([f(v)], [v])`
(`f ∈ Hom(D, B)`), is dominant equivariant. (3) Hence any product
of linear factors, trivial `P²`s, and at least one spin factor is
equivariantly dominated by a single SPIN source; and on a fixed
variety any linear source is dominated by a spin one
(`P((A ⊗ V*) ⊕ V) ⇢ P(A)`, `[f : v] ↦ [f(v)]`), so
lin-unirational ⟹ spin-unirational always.

**(iii) Proposition IX.4 (transport lattice).** Composing a
dominant equivariant map with Thm 1.1 over `C` (no twisting — the
Brauer class is invisible here) and folding by IX.3:

- `Y` lin-unirational ⟹ `X` SPIN-unirational (and `X` lin ⟹ `Y`
  spin) — absorbing the `P(V)`-factor flips the central
  character;
- `Y` spin-unirational ⟺ `X` spin-unirational (spin ⊕ spin stays
  spin);
- on each twin, lin ⟹ spin (IX.3(3)).

The four plain questions collapse to: one shared SPIN question on
top, the two lin-questions feeding it. IX.1 = "`X`-lin FALSE";
the headline = "`Y`-lin". No arrow runs from "`X`-lin FALSE" to
any other node: the theorem sits exactly at the boundary the
stable equivalence enforces. It HAD to leave spin open — a
spin-kill by the same σ-argument would transport to a refutation
of the CSD instance, which no fixed-locus computation alone
should be able to deliver.

**Corollary IX.5 (new sufficient negative target).** Headline
YES ⟹ `V₁₄` is spin-unirational. Contrapositive: KILLING SPIN
SOURCES ON THE V₁₄ (the §6 flank) proves the headline NEGATIVE —
`ed_C(PSL₂(F₁₁)) = 4`, refuting the CSD instance (D-R Prop
10.8(b)) and confirming Dolgachev's. The §6 flank is therefore
not a loose end: it is the HEADLINE, transported to the twin
where the σ-geometry is machine-friendly (no rational curves in
`V₁₄^σ`). Sufficient, not necessary: `V₁₄`-spin could survive
even if the headline is NO.

**Corollary IX.6 (the D12-shadow: the spin escape is REALIZED).**
The Klein cubic is D12-lin-unirational (Note VIII §6, dominant
map from `P(W)`). Restricting Thm 1.1 to `D12` and folding
(everything restricts): the `V₁₄` IS D12-SPIN-unirational. Yet
every faithful linear D12-source dies on the `V₁₄`: for
`ρ(σ)` non-scalar this is the IX.1 argument with `G := D12`
(σ is the center of D12, so this is literally Cor T3.1; (a) and
`V₁₄^{D12} = ∅` are the measured hypotheses); for the
`ρ(σ) = −id` reps, σ acts trivially on `P(V)`, so the image
lies in `V₁₄^σ` — 1-dimensional, never dominant. So on the
`V₁₄` at D12 level: spin TRUE, lin FALSE — the twins DIVERGE at
D12 (on the Klein both are true), the §6 C6-pair escape is not
hypothetical but REALIZED by an existing dominant D12-map, and
the full-`G` spin flank is structurally confirmed hard.

**Pre-registration (falsification test; recorded while the
worker is in flight and blind to IX.1).** Stage 4 of
FIX-IX-V14MODEL hunts `10′`-valued landing covariants in
`S^d W*` = `G`-maps `P(W) ⇢ V₁₄` — a LINEAR source. IX.1
predicts EVERY landing cone is EMPTY, at all degrees. A verified
stage-4 hit would refute the mod-397 loci data or the IX.1
derivation (one of the two must then be wrong); conversely the
ladder's emptiness, when it lands, is independent blind
corroboration of the obstruction.

## 8. Subgroup transfer across the T-Z equivalence: odd order is the criterion (2026-08-06, user question)

Question: for which `H ≤ G` does the twin equivalence transfer
(non-)unirationality? Answer: EXACTLY the odd-order subgroups —
and one of them is F55, where the transfer has teeth.

**Lemma IX.7 (odd-order collapse).** The central extension
`2.G → G` splits over `H ≤ G` iff `|H|` is odd. (Only involution
in `SL₂(F₁₁)` is `−I`, so an involution of `H` cannot lift to an
involution — even order obstructs; odd order splits by
Schur–Zassenhaus.) For odd `H` the preimage is `H × ⟨−1⟩`, so
every spin source is, as an `H`-variety, `P(linear H-rep)`: the
linear/spin distinction COLLAPSES over `H`. Restricting T-Z
Thm 1.1 to `H` and folding (all factors now linear), we get:
**`Y` is H-unirational ⟺ `X` is H-unirational** — both
directions, positives and negatives alike. For even-order `H`
the restricted extension is nonsplit, its Brauer class survives
(the §2 caveat verbatim), and NOTHING transfers — witnessed
sharply at `H = D12` by Cor IX.6 (Klein D12-unirational, V₁₄
not D12-lin-unirational: the twins diverge, consistent only
because D12 has even order).

The odd-order subgroups of `PSL₂(F₁₁)` up to conjugacy:
`1, C₃, C₅, C₁₁, F55 = C₁₁⋊C₅`. New situations:

- **F55 (the money case).** `F55` on the Klein cubic is a NAMED
  CTZ open case, and `X^{F55} = ∅` on both twins (the C₅ cycles
  the five C₁₁-fixed points). By Lemma IX.7: **Klein-F55 ⟺
  V₁₄-F55**, one question with two geometric models. And since a
  G-map restricts to an F55-map: **NOT-F55 on EITHER twin ⟹ the
  headline is NEGATIVE (`ed = 4`)** — a second sufficient
  negative target alongside Cor IX.5's spin-kill, and this one
  transfers freely between the twins. The involution machine
  cannot touch it (F55 has no involutions); the natural attack
  is the odd-element analogue of IX.1 on the V₁₄'s C₁₁/C₅ data.
  Fixed-point inputs (worker-grade, mod 397, to be sealed with
  its packet): `V₁₄^{C₁₁}` = 5 points with stabilizer EXACTLY
  C₁₁ (they sit in a 60-orbit), so the C₅ cycles them freely
  and `V₁₄^{F55} = ∅` — mirroring the Klein side, where
  `W|_{F55}` is irreducible so `P(W)^{F55} = ∅`. Consequently a
  faithful F55-rep `V` with `V^{C₁₁} ≠ 0` yields an F55-stable
  connected rational stratum (`P(V^{C₁₁})`) whose image would be
  an F55-fixed point — empty — so only sources with
  `V^{C₁₁} = 0` (the induced 5-dims) survive the first cut; the
  residual analysis is the named next derivation.
- **C₃ (first unconditional positive on the V₁₄).** The Klein
  cubic is D12-unirational, hence C₃-unirational (restrict);
  C₃ is odd; so **the V₁₄ IS C₃-unirational** — its first
  unconditional positive equivariant-unirationality statement,
  by pure transfer.
- **C₅, C₁₁.** Open on both twins, equivalent across them by
  IX.7; each is implied by headline-YES and implies nothing
  back; a Klein-side proof (fixed points + equivariant Kollár
  tangent-construction, CTZ Prop-3.1-style) would transfer to
  the V₁₄ for free. Low stakes but cheap.

Scoreboard on the V₁₄ after today: G: NOT unirational (IX.1,
sealed). D12 (even): lin NO / spin YES. C₃: YES. C₅, C₁₁, F55
(odd): open ⟺ their Klein twins. Spin-G: open, = the
transported headline (IX.5).

### 8.1 The machine on F55 — first derivation pass (2026-08-06)

**(i) Full scope — no spin flank.** `M(F55) = 1` (Frobenius
`C_p⋊C_q`, faithful action, trivial Schur multiplier) and the
`2.G`-preimage splits (odd order), so EVERY projective F55-source
is `P(linear F55-rep)`: the machine's source class is everything.
If the machine closes F55, F55 is closed OUTRIGHT — and by IX.7 +
restriction, the headline is NEGATIVE. No escape hatch of the
spin or C6-pair kind exists at the level of source types.

**(ii) First cut (recorded above).** Faithful sources with
`V^{C₁₁} ≠ 0` die on `V^{F55}₁₄ = ∅`. Survivors: pure induced
`V = a·ρ₅ ⊕ b·ρ₅′`.

**(iii) Bijectivity rigidity (new).** For a surviving source,
the five `C₁₁`-eigenspace strata `P(V_χ)` (one C₅-orbit; each
only `C₁₁`-stable) push, through any equivariant resolution
(IX.1 template with `N = C₁₁`), to single `C₁₁`-fixed points of
`V₁₄`. If two strata in one C₅-orbit shared an image point `y`,
the `c ∈ C₅` carrying one stratum to the other would fix `y`,
making `y` fixed by `⟨C₁₁, c⟩ = F55` — but `V₁₄^{F55} = ∅`. So
the five strata map BIJECTIVELY and C₅-equivariantly onto the
five points of `V₁₄^{C₁₁}` (worker-grade datum: exactly 5, stab
exactly `C₁₁`). No contradiction — a rigidity: the incidence
level CANNOT kill F55; the obstruction, if any, lives in the
weight calculus.

**(iv) The weight data — closed-form on the Klein, measured on
the V₁₄** (probe `v14_f55_weights.py`, mod 397). By IX.7 the
analysis may run on either twin.

- Klein: the five `C₁₁`-points are the coordinate points with
  weights `a_i = (−2)^i = (1, 9, 4, 3, 5) mod 11`; at weight
  `a`: tangent `{2a, 3a, 4a}`, normal (in `P(W)`) `{8a}`;
  C₅-linkage `a ↦ −2a`.
- V₁₄: `M|_{C₁₁}` = all ten nontrivial characters once; of the
  ten eigenpoints of `P(M)`, EXACTLY ONE C₅-orbit of five lies
  on the V₁₄ (= `V₁₄^{C₁₁}`, confirming the worker datum
  independently); at the point of character `a`: tangent
  `{4a, 8a, 9a}`, normal (in `P⁹`) `{a, 2a, 3a, 5a, 6a, 7a}`;
  C₅-linkage `a ↦ 5a`. All weights nonzero (isolated fixed
  points, consistent with smoothness). Patterns uniform over
  the orbit; the multiset `{tangent}/a` is presentation-
  independent.

So the residual F55 question is a FINITE weight-matching
problem: which C₅-linked assignments of source-tower data to
`{2,3,4 | 8}·a` (Klein) / `{4,8,9 | 1,2,3,5,6,7}·a` (V₁₄) are
consistent under the [I, Thm 2.1] blowup calculus. MISSING
PIECE: the chain lemma for ODD Frobenius linkage (T2.2 is
V4/dihedral-specific; nothing in the T-gate covers `C₅⋉C₁₁`) —
deriving it is the named next step. The arithmetic shortcut
remains E18 (the sealed `11:5` trace-cubic model: a pointless
verdict there = F55-NO directly).

**Verdict tonight: the machine neither kills nor clears F55.**
It reduces F55 — with total source scope — to (a) the odd-chain
weight lemma against the explicit `{2,3,4|−3}`-pattern, or (b)
the E18 twist decision. Either resolves a named CTZ case; a
negative resolves the headline (`ed = 4`).

### 8.2 The odd-Frobenius chain derivation (opened 2026-08-06; director lane)

Goal: run the machine's DEEP layer (the [I, Thm 2.1] blowup
calculus with chain bookkeeping) on F55, to a decision: either an
obstruction, or a proved "closes rather than obstructs" no-go
(each redirects: a no-go leaves E18/arithmetic as the only F55
route). First derived facts:

**(1) One discrete modulus.** `⟨5⟩ = {1,3,4,5,9}` = the quadratic
residues mod 11. The source characters at the five eigenpoints of
a pure induced source form one coset `c·QR`; the target characters
at the five `C₁₁`-points form one coset `a·QR`. The C₅-equivariant
bijection (§8.1(iii)) intertwines the two `×5`-scalings, so the
entire configuration carries exactly ONE discrete invariant:
`t = a/c ∈ (Z/11)*/QR` — "t is a residue or not". Any obstruction
must kill both values of `t`; any construction must choose one.

**(2) The first-order local layer is EMPTY.** At a source
eigenpoint of character `c`, the local (normal) weights are
`c·{2, 3, 4, 8}` (computed: `(5^i − 1)c`); the target tangent
weights are `tc·{4, 8, 9}`. Since `{2,3}` already generate `Z/11`
as an additive semigroup, every required weight is realizable by
equivariant jets at every order-1 level, for BOTH values of `t`:
no per-point germ obstruction exists. Consequence: an F55
obstruction, if real, lives in GLOBAL divisor/degree bookkeeping
(profiles along strata, base-locus orders — the altitude of the
Klein-side H0/H1 theory), not in local weight arithmetic.

**(3) The structural risk, stated up front.** Everything
`C₁₁`-fixed — on the source, the target, and every blowup level —
carries a FREE C₅-action (`V₁₄^{F55} = ∅`, `P(V)^{F55} = ∅`, and
centers stabilized by both groups have their fixed data spread in
free 5-orbits). This is precisely the freedom by which the Klein
cubic escaped the original Problem-F transfer (E14: "closes
rather than obstructs"). A no-go outcome is therefore live; the
derivation must either find a global invariant that the five
conjugate towers cannot satisfy simultaneously, or prove
consistency at every level and record the no-go.

Status: DECIDED same day — NO-GO, §8.3. The machine at its
current altitude cannot close F55; proof below.

### 8.3 The F55 no-go (lane decision, 2026-08-06)

**Correction IX-b (2026-08-06, user-caught, same day): Theorem
IX.8 as first stated is WITHDRAWN.** Its layer-4 "solvable"
verdict silently ASSUMED the target supplies every weight-
admissible linking curve; the machine's full form requires the
target-side curve INVENTORY to be measured, exactly as the
Klein-transfer verdict (E14) was decided by measuring `X^σ ⊃
L_σ`. The measurement (below, §8.4) shows the inventory is
STRICTLY SMALLER than the weight test allows, so the solvability
proof collapses. Status of the F55 machine question: back to
OPEN-DERIVATION. What survives of §8.3 unconditionally: layers
1–3 (incidence matching, germ realizability, harmless contraction
of pointwise-fixed strata) are correct as stated; the error was
treating layer 4's necessary weight test as sufficient.

**Theorem IX.8 (original statement, for the record — WITHDRAWN;
see Correction IX-b).** Every
constraint system produced by the [I]-calculus layers — incidence
(going-down on strata), local germ weights, scalar-birth /
pointwise-fixed-curve forcing, and endpoint weight-negation links
— for an F55-equivariant map from a surviving source to either
twin is SOLVABLE. The machine as built cannot close F55.

*Proof (the four layers, each checked on the V₁₄; the Klein is
conjugate by IX.7 and was checked independently — the agreement
is itself a consistency test of the framework).*

1. *Incidence.* §8.1(iii): the five eigenstrata land bijectively
   and C₅-equivariantly on the five `C₁₁`-points; a matching
   assignment exists (5 conjugate choices). Solvable.
2. *Local germs.* §8.2(2): source local weights `c·{2,3,4,8}`
   generate `Z/11` additively, so every target tangent weight
   `tc·{4,8,9}` is realizable by equivariant jets at every level,
   for both values of the modulus `t`. Solvable.
3. *Scalar-birth.* Towers can force pointwise-`C₁₁`-fixed
   positive-dimensional strata (weight collisions at deep
   levels). On Problem F these were lethal because the TARGET
   fixed loci contained genus-≥1 CURVES and nonconstancy could be
   forced. Here `V₁₄^{C₁₁}` (and `X^{C₁₁}`) is FINITE, so every
   pointwise-fixed source stratum maps CONSTANTLY — always
   satisfiable by contraction. The very hypothesis that made the
   σ-machine sharp (0-dimensional fixed data) makes the
   `C₁₁`-machine toothless. Solvable.
4. *Links.* A `C₁₁`-stable rational curve linking fixed points
   carries tangent weights `w` and `−w` at its two ends
   (normalize to `P¹`). Allowed edges between points `a, b` (all
   in one QR-coset, `b/a ∈ {3,4,5,9}`): need `−s/t` with
   `s, t ∈ {4,8,9}` (V₁₄); the ratio set is
   `−{1,2,5,6,7,8,9} = {2,3,4,5,6,9,10}`, which CONTAINS
   `{3,4,5,9}`: EVERY pair of the five points is weight-
   admissible — the link graph is the complete `K₅`, no self-
   links (`{4,8,9} ∩ −{4,8,9} = ∅`). Klein check: tangent
   `{2,3,4}` gives ratio set `−{1,2,5,6,7,8,9}` again — the SAME
   `K₅`, as IX.7 demands. No linking constraint; no constraint
   on `t` (both source and target link-graphs complete). Solvable.

Finally, the C₅ acts freely on every piece of `C₁₁`-fixed data at
every level on both sides (§8.2(3)), so the global system
decomposes into five conjugate independent subsystems with no
F55-fixed gluing loci; layers 1–4 solve each subsystem, and
C₅-conjugation glues the solutions. ∎

**Scope.** This is a no-go for the machine's current layers, not
an unprovability theorem: a genuinely global invariant (degree /
divisor-class bookkeeping across the five towers at once — the
altitude where the Klein's own negative program also stalled, cf.
the FIX-D2 terminal verdict) remains logically possible but has
no candidate. And no map is constructed: F55 remains OPEN.

**Consequence for the program.** [Paragraph withdrawn with IX.8
by Correction IX-b; see §8.4 for the live state. E18 remains a
parallel route with the same protocol regardless.]

### 8.4 Layer 5: the target curve inventory — THE PENTAGON (measured 2026-08-06)

Probe `v14_f55_curves.py`, mod 397, on the exact model.

- **Degree 1.** Of the ten pairs of `C₁₁`-points, the joining
  line lies ON the V₁₄ exactly for the five pairs of ratio
  `∈ {5, 9}` — the graph is the 5-CYCLE
  `2 — 7 — 8 — 6 — 10 — 2` (a pentagon). The five ratio-`{3,4}`
  pairs (the pentagram diagonals) have NO line. Equivalently:
  at each point, exactly 2 of its 3 tangent eigendirections
  integrate to contained lines.
- **Degree 2.** NO equivariant progression-conic exists for any
  pair: every candidate already fails the tangency wedge
  (`y ∧ v_middle ≠ 0` on at least one side).
- So pentagram pairs are joined by NO stable rational curve of
  degree ≤ 2; whether ANY degree joins them is the finite
  eigen-support/wedge-table classification (each degree gives an
  overdetermined bilinear system in the `λ_i` over the ten
  eigen-lines; the full 45-pair wedge table is the input).

**Span classification (same day, probes `v14_f55_sweep.py` +
follow-ups, mod 397).** Any `C₁₁`-stable curve spans a
`C₁₁`-stable subspace = a sum of eigen-lines; sweeping ALL 256
subsets containing the pentagram pair `(2,6)` (one C₅-orbit
covers all five diagonal pairs) and decomposing `V₁₄ ∩ P(S)`:

- Through-components exist only at span ≥ 8. At span 8, exactly
  two subsets hit (`{1..7,9}` and `{1..6,8,9}`, both missing
  char 10); each section is (one pentagon line) ∪ (an
  irreducible `C₁₁`-stable curve of DEGREE 13, `p_a = 6`,
  through both diagonal points).
- **Lemma IX.9 (equivariant fixed-point count).** An irreducible
  curve with nontrivial `C₁₁`-action and ≥ 3 fixed points, each
  of multiplicity < 11, is NOT rational (the normalization would
  be a `P¹` with ≥ 3 fixed points; it has exactly 2).
- Both degree-13 curves have exactly THREE fixed points on them
  (A: `y₂` mult-2 singular, `y₆`, `y₇` smooth; B: `y₂`, `y₆`
  smooth, `y₈` singular) ⟹ both NON-RATIONAL by IX.9.
- **Conclusion at span ≤ 8: the inventory of stable rational
  curves through the five points is EXACTLY the pentagon — five
  lines, nothing else; no rational curve joins any diagonal
  pair.**

Remaining for the complete inventory: (i) span-9 and span-10
no-reuse parametrizations (degrees 8 and 9 — two FINITE bilinear
systems, named next); (ii) character-reusing curves of degree
≥ 11 spanning 9–10 eigenlines (needs a structural lemma; open);
(iii) the rigidity sub-question (§8.4 item 2) is untouched by
all of this and remains the other half of any F55 kill.
[Superseded same day by §8.5, which replaces (i)+(ii) by proofs
plus one reduced finite system.]

### 8.5 The inventory by analysis (2026-08-06; proofs first, computation reduced)

Setup. Lift `C₁₁ = ⟨ĥ⟩` to SL₂(F₁₁); on the Weil 6-space,
`U = ⊕ u_a`, `a ∈ {0} ∪ QR = {0,1,3,4,5,9}`, each weight once
(classical). Then in `Λ²U` the weight of `u_a∧u_b` is `a+b`; the
non-residue weights occur ONCE (pure decomposables), the residue
weights `q` TWICE (`u_0∧u_q` and `u_{c_q}∧u_{d_q}`,
`c_q+d_q ≡ q`); `Λ²U = W₅ ⊕ M` puts one weight-q line in each.

**Theorem A (the pentagon, now a theorem).** The five C₁₁-points
of the V₁₄ are exactly the five pure decomposables:
`y ↔` the edges `{4,9}, {1,5}, {3,4}, {3,5}, {1,9}` — the pairs
in `{1,3,4,5,9}` with NON-residue sum (`u_0` unused). Two points
span a contained line iff their edges SHARE a vertex; the
"shared-vertex" graph of these five edges is 2-regular on five
vertices, i.e. a 5-cycle. The pentagon and the absence of
diagonal lines follow with no computation.

**Lemma B (nondegeneracy).** For `q ∈ QR` the M-eigenvector
`v_q` is a mix of `u_0∧u_q` and `u_{c_q}∧u_{d_q}` with BOTH
coefficients nonzero. Proof: a pure `v_q` would be decomposable,
i.e. a SIXTH C₁₁-fixed point of the V₁₄. But `|V₁₄^{C₁₁}| = 5`:
topological Lefschetz gives `χ(V₁₄^{ĥ}) = 4 − tr(ĥ|H³)`, and
`H³(V₁₄) ≅ H³(Klein cubic)` (Pfaffian partners) carries ALL ten
nontrivial characters (Griffiths residues: `H^{2,1}` has the
five coordinate weights, `H^{1,2}` the conjugates), so
`tr = −1`, `χ = 5`; the fixed locus is finite reduced (nonzero
tangent weights), hence exactly five points. ∎ Consequently the
V₁₄-membership condition for a family of planes is, per residue
weight `q`, ONE bilinear identity
`E_q : κ_q D_{0q} + μ_q D_{c_qd_q} ≡ 0` with `κ_q, μ_q ≠ 0`,
where `D_{ab}` are the Plücker coordinates in the `u`-basis.

**Theorem C (the u₀-free kill; all degrees, all genera,
equivariance not needed).** No irreducible curve on the V₁₄
whose planes lie in `U₅ = ⟨u_1,u_3,u_4,u_5,u_9⟩` passes through
two diagonal points. Proof: planes in `U₅` means `D_{0q} ≡ 0`
along the curve, so by `E_q` (Lemma B) ALL five diagonal minors
`D_{39}, D_{59}, D_{13}, D_{14}, D_{45}` vanish along the curve.
The Plücker relation on `{1,4,5,9}` reads
`D_{14}D_{59} − D_{15}D_{49} + D_{19}D_{45} = 0`, whose first
and last terms are zero, so `D_{15}·D_{49} ≡ 0`; the coordinate
ring of an irreducible curve is a domain, so `D_{15} ≡ 0` or
`D_{49} ≡ 0` — i.e. the curve misses `y_{{1,5}}` or `y_{{4,9}}`
(and the same for every diagonal pair by symmetry). ∎
(Both degree-13 curves use `u_0` — consistent.)

**Reduction D (what is left, exactly).** Any remaining candidate
through a diagonal pair uses `u_0`: some `D_{0q} ≢ 0`. Writing
the normalization's equivariant parametrization with binary
forms `F_a, G_b` per `u`-weight, every Plücker coordinate is
LACUNARY: `D_{ab}` is supported on exponents
`k ≡ (a+b−c₀)/w (mod 11)`. Substituting `ζ = z^{11}` (the
C₁₁-quotient coordinate) turns the fifteen Plücker relations
plus the five `E_q` into a SHIFTED-PLÜCKER SYSTEM: ten
one-variable polynomials `P_X(ζ)` satisfying the Grassmann
relations with `ζ^{0/1}`-shifts determined by the carry
arithmetic of `σ = 1/w`, endpoint units `P_{49}(0) ≠ 0` and
top-coefficient of `P_{15} ≠ 0`. Character reuse is now just
ζ-degree: the FULL remaining inventory question — spans 9/10,
all degrees — is this ONE system, finite per ζ-degree, with
ζ-degree 0 the old "no-reuse" case. Per the program doctrine the
residual computation is now legitimate: it has been reduced
analytically to a stratified finite solve (ζ-degree 0, 1, 2, …)
with the uniform-in-degree closure the one remaining analytic
gap (a valuation-descent argument on relations #4/#14 of the
shifted system is the named candidate).

Status: pentagon = theorem; diagonal kill proved on the
`u_0`-free locus; survivors confined to the shifted-Plücker
system. Rigidity (§8.4 item 2) untouched and still required for
any F55 kill.

### 8.6 Closing the uniformity gap: the squares kill and the tropical reduction (2026-08-06)

Work over the ten possibly-nonzero Plücker forms of a candidate
curve: `D₀₁, D₀₃, D₀₄, D₀₅, D₀₉` (the `u₀`-minors) and the
pentagon forms `D₁₅, D₁₉, D₃₄, D₃₅, D₄₉`, with the five
diagonals eliminated by `E_q`: `D₃₉ = a₁D₀₁`, `D₅₉ = a₃D₀₃`,
`D₁₃ = a₄D₀₄`, `D₁₄ = a₅D₀₅`, `D₄₅ = a₉D₀₉` (all `a_q ≠ 0`,
Lemma B). Let `Z := {q : D₀q ≢ 0}`.

**Theorem E (the squares kill: `|Z| ≤ 3` is impossible; contains
Theorem C as the case `Z = ∅`).** After eliminating diagonals,
each `D₀q²` appears in exactly one Grassmann–Plücker relation
whose other two terms are `D₀q′·(pentagon)` or `D₀q′·D₀q″`:

    R{0,1,3,9}: a₁D₀₁² = D₀₃·D₁₉ − a₄D₀₉·D₀₄
    R{0,3,5,9}: a₃D₀₃² = a₁D₀₅·D₀₁ − D₀₉·D₃₅
    R{0,1,3,4}: a₄D₀₄² = a₅D₀₃·D₀₅ − D₀₁·D₃₄
    R{0,1,4,5}: a₅D₀₅² = D₀₄·D₁₅ − a₉D₀₁·D₀₉
    R{0,4,5,9}: a₉D₀₉² = D₀₅·D₄₉ − a₃D₀₄·D₀₃

Reading these as support conditions (`q ∈ Z` needs a nonzero
right side), a case sweep of all subsets kills every `Z` with
`1 ≤ |Z| ≤ 3` (each singleton dies on its own square; every pair
and triple fails some member's support), and `Z = ∅` is Theorem
C. **Every surviving candidate has `|Z| ≥ 4`** — the plane
family must use `u₀` in at least four of the five residue
weights; the five surviving patterns also force specific
pentagon forms nonzero (`|Z∖{9}|`-type cases force `D₁₉`, etc.).

**The tropical layer.** For a nonzero lacunary form,
`ord₀ ≡ t̂ (mod 11)` and `ord_∞ ≡ ê (mod 11)`; proportional
pairs have EQUAL valuations, so the diagonal identifications
above are exact equalities of valuations. In every three-term
Plücker relation the minimum valuation is attained at least
twice, at both `z = 0` and `z = ∞`: the two valuation vectors
are TROPICAL Plücker vectors (tree vectors on the six leaves
`{0,1,3,4,5,9}`) with (i) mod-11 congruence rigidity per
coordinate, (ii) the five proportionality equalities, (iii)
corner normalizations `w₄₉ = 0` (at 0) and `w′₁₅ = 0` (at ∞),
all other coordinates ≥ 1, and (iv) the budget
`w_{ab} + w′_{ab} ≤ e ≡ 4σ (mod 11)`.

**Lemma F (exposure).** At the `z = 0` corner, in each of the
six quadruples containing the pair `{4,9}` the `w₄₉`-term
degenerates and exposes a single coordinate; the four-point
condition then shows an exposed coordinate can never attain the
global minimum of the nine (its two companions are sums of two
positives, hence strictly larger, so the minimum would be
attained once). Consequently the minimal valuation at `z = 0` is
attained only among `{w₀₉ (= w₄₅), w₁₉, w₃₄}` — exactly the
pairs meeting the corner plane `{4,9}` once — and symmetrically
at `∞` only among `{w′₀₅ (= w′₁₄), w′₁₉, w′₃₅}`. In the `|Z| = 4`
strata the vanished coordinate turns its quadruples into EXACT
two-term equalities (e.g. `Z ∌ 9` forces `w₀₅ = w₀₃ + w₀₄` on
the nose), further rigidifying the system.

**Honest status of the gap.** What remains open is precisely:
*is the doubly-constrained tree system — four-point conditions
at both corners, congruence rigidity, proportionality
equalities, exposure, budget — feasible for some
`σ ∈ (Z/11)^*` and some `|Z| ≥ 4` stratum?* This is now a FINITE
combinatorial feasibility problem (finitely many tree topologies
on six leaves; heights in fixed mod-11 classes; per-topology
linear systems), no longer a question about curves of unbounded
degree: tropical infeasibility for all cases would prove the
pentagram inventory EMPTY at all degrees; a feasible tree is not
yet a curve (tropical necessity only) and would send us back to
the corresponding bounded stratum with an exact solve. The
uniformity-in-degree gap is thereby closed AS A REDUCTION —
unbounded degree has been eliminated from the problem — but the
final feasibility verdict is not yet derived; it is the next
piece of hand analysis, and only if trees survive does bounded
computation legitimately re-enter.
[Decided same day — §8.7: FEASIBLE. The tropical route cannot
kill the inventory.]

### 8.7 Lemma G: the tree system is feasible — the tropical route ends without a kill (2026-08-06)

Corner coordinates: normalize the two rows at `z = 0` against
the corner plane (`f`-row `= u₄ + Σ z^{p_x}·(…)u_x`, `g`-row
`= u₉ + Σ z^{q_x}·(…)u_x`, no `u₉`/`u₄` cross-terms). Then
`w_{4x} = q_x`, `w_{9x} = p_x`, and the four-point conditions on
`{4,9,x,y}` say each remaining `w_{xy}` twice-min-matches
`(q_x+p_y, q_y+p_x)`. The five proportionality equalities become

    q₅ = p₀,   p₃ ⋈ (q₀+p₁, q₁+p₀),   p₅ ⋈ (q₀+p₃, q₃+p₀),
    q₁ ⋈ (q₀+p₅, 2p₀),   q₀ ⋈ (q₁+p₃, q₃+p₁),

all congruence-consistent in every branch (a nontrivial check
that passes identically — the classes satisfy `3 ≡ 2·7`,
`10 ≡ 3·7`, `2 ≡ 5·7`, `9 ≡ 4·7` … mod 11 times σ).

**Lemma G (feasibility certificate).** In the `|Z| = 5` stratum
the full 15-relation system is feasible. For `σ = 7` (classes
`/σ`: `p₀≡5, p₁≡1, p₃≡4, p₅≡7, q₀≡3, q₁≡10, q₃≡2, A′≡6, E″≡9`)
take `m = p₀ = 5` and the cascade
`q₁ = 2m = 10, p₃ = 3m = 15, q₀ = 5m = 25, E″ = 4m = 20,
q₃ = 13, p₁ = 12, p₅ = q₃+m = 18, A′ = m+p₁ = 17`; derived
`a = 15, b = 18, c = 25, d = 10, f = 5, B′ = 12, C′ = 13`. All
fifteen four-point conditions hold (hand-checked: e.g.
`Q10 = (43,10,10)`, `Q12 = (25,25,25)`, `Q14 = (28,17,17)`,
`Q3 = (30,30,30)`, `Q11 = (30,30,30)`, `Q2 = (35,35,35)`), and
all congruences match. The cascade multiples (`2m, 3m, 5m, 4m`)
are congruence-automatic for EVERY `σ`, and the two free choices
(`q₃`, `p₁`) live in intervals of length growing with `m`, so
certificates exist for all `σ` at large `m`; the `∞`-corner is
the C₅-translate of the same system (corner pair
`{1,5} = 3·{4,9}`, parameter `3σ`), hence feasible with the same
`σ`, and the budget is absorbed by large `e`. ∎

### 8.8 The decision drive: the F55 ladder and the exact decisive object (2026-08-06/07)

**The F55 landing ladder (positive side; monomial reduction).**
In the Klein normalization (`F = Σ x_i²x_{i+1}`, `h` diagonal
with weights `a = (1,9,4,3,5)`, `c` the coordinate 5-cycle) every
character of F55 is trivial on `C₁₁`, so an equivariant
`T : P(W) ⇢ X` has `T_i` of `h`-weight EXACTLY `a_i` and
`T_i = ω^{si}·shift^i(T₀)` for a twist `s ∈ Z/5`: the ladder at
degree `d` is `dim ≈ C(d+4,4)/11` coefficients cut by the cubic
identity `F(T) ≡ 0`. Results (`f55_ladder.py`, p = 661 ≡ 1 mod
55, all five twists, geometric emptiness by saturation):

- `d = 2`: the unique family is `T_i = ε_i x_{i+1}x_{i+3}`; the
  five landing terms are DISTINCT monomials — EMPTY, by hand.
- `d = 3` (3 coefficients): EMPTY (all of `P²(F₆₆₁)` scanned AND
  saturation); `d = 4, 5`: EMPTY (saturation, dims 0);
  `d = 6`: running. Gate per the stop-rule: extension past
  `d = 7` requires a structural argument.

**The exact decisive object (the two sides meet).** By the
specialization lemma + D-R Thm 10.5 (cubic hypersurface, any
finite group): F55-YES ⟺ the GENERIC F55-twist of the Klein
cubic has a K-point. That twist is ALREADY SEALED in-repo (E18,
packet `goal_runs_after_35fa/H_11_5_TWIST`,
`H-11_5-NORM-MODEL-PASS`): over
`E = C(r₀,…,r₄)/(Πr_i = 1)`, `σ(r_i) = r_{i+1}`, `K = E^σ =
C(U₁,…,U₄)`, the twist is the five-variable cyclic trace cubic

    Φ(a) = Tr_{E/K}(r₂⁻¹·a²σ(a)) = 0,

whose coefficient class `[r₂] ∈ E*/ψ(E*)`, `ψ(d) = d²σ(d)`, has
EXACT ORDER 11 (sealed; the packet also proves this class alone
is not a pointlessness certificate). So the F55 question — on
both twins at once, by IX.7 — IS: does `Φ` have a nontrivial
K-zero? YES ⟺ F55-unirational (both twins) ⟺ a new positive
CTZ case; NO ⟺ F55-NO ⟺ the headline is NEGATIVE and
`ed_C(PSL₂(F₁₁)) = 4`. The ladder is the covariant-side
height-search of the same binary; the machine campaign (§§8.1–
8.7) was the geometric-side attack, now exhausted-to-no-go-
trending. Next derivation: the divisorial/local analysis of `Φ`
over the supports where the order-11 class ramifies — the
trace-form-specific obstruction the sealed packet stopped short
of.

### 8.9 The valuation campaign on Φ (opened 2026-08-07; DRAFT-FOR-DERIVATION)

For a monomial valuation `v_w` on `E` (`v(r_i) = w_i`,
`Σw_i = 0`), the five terms `T_i = r_{2+i}^{-1}·a_i²a_{i+1}` of
`Φ` have orders `μ_i = 2s_i + s_{i+1} − w_{2+i}` where
`s_i = v_{σ^{-i}w}(a)`. The lattice operator `2I + σ` has
determinant `33 = 3·11`, giving two INVARIANT congruences for
monomial `a`: `Σ_i μ_i ≡ −Σw ≡ 0 (mod 3)` and — the transpose
kernel being spanned by the KLEIN WEIGHTS `a_i = (−2)^i` —
`Σ_i a_iμ_i ≡ −W (mod 11)`, `W := Σ_i a_i w_{2+i}`. First
structural yields: (i) if `W ≢ 0 (mod 11)`, a FIVE-WAY tie of
the term orders is impossible (`Σa_i = 22 ≡ 0` forces `W ≡ 0`);
(ii) a unique-minimum configuration forces `Φ(a) ≠ 0` in the
valued field outright, so any pointlessness proof reduces to
killing the residual cancellation equations at 2-, 3-, 4-term
ties — each a smaller trace-type equation over a trdeg-3 residue
field, where the sealed order-11 class of `r₂` is the candidate
engine. A single valuation `w` whose full tie-cascade closes
would prove `Φ` pointless ⟹ F55-NO ⟹ headline NEGATIVE,
`ed = 4`. Conversely this route can never prove F55-YES (local
solubility everywhere decides nothing) — the YES-side remains
the ladder/height search. STATUS: opened; the tie-cascade
analysis is the active derivation.

**Correction IX-c (2026-08-07, caught on full derivation).** The
mod-11 functional is `λ_i = 5^i = (−2)^{−i}` — the CONJUGATE
Weil weight vector — not `(−2)^i` as first written (the
transpose-kernel recursion is `λ_{i−1} = −2λ_i`). The
consequences stand unchanged (`Σλ_i = 22 ≡ 0`, so `W ≢ 0 mod 11`
still forbids five-way ties, now with `W = Σ 5^i w_{2+i}`).

**8.9.1 The derivation, continued: what the campaign actually
proves (2026-08-07).**

- **Proposition (ψ-structure).** `Φ(a) = Tr_{E/K}(r₂^{-1}·ψ(a))`
  with `ψ(a) = a²σ(a)` — the twist is the ψ-image cone paired
  against the class of `r₂`. If `r₂ ∈ ψ(E^*)·C^*`, then `Φ` HAS
  zeros: untwisting by `d` with `ψ(d) = r₂·(const)` turns `Φ`
  into the untwisted Klein trace form, which vanishes at the
  constant points `X(C) ⊂ X(K)`. Hence ANY pointlessness proof
  must essentially use the sealed fact `[r₂] ≠ 0` in
  `E^*/ψ(E^*)` (order 11); no genericity or dimension-count
  argument can possibly work. The entire difficulty is the
  "sums slack": `a` ranges over `E`, not `E^*`-units, and the
  class obstruction sees only the multiplicative layer.
- **Tempering theorem (the cascade hope withdrawn).** Working
  with initial forms along the full normal fan (the associated
  graded of a monomial valuation is the Laurent ring itself, so
  leading terms are FACE RESTRICTIONS of the Newton polytope of
  `a`, coupled in a chain: the vertex `p^{(i+1)}` feeds both the
  linear slot of `T_i` and the squared slot of `T_{i+1}`): at
  any 2-term tie of leading exponents, the leading-coefficient
  cancellation equation involves free coefficients of `a` and is
  ALWAYS solvable locally. The leading layer never obstructs at
  any single cone; a pointlessness proof must be a GLOBAL
  LIFTING obstruction — the same coefficient of `a` appears in
  the equations of many cones simultaneously — which is the same
  difficulty class as the tropical-to-exact gap of §8.7. The
  §8.9 hope of a quick finite tie-cascade kill is hereby
  WITHDRAWN as too optimistic; recorded per the correction
  discipline.

### 8.10 The class-to-form bridge (2026-08-07; derivation session)

**Theorem H (local solubility at split places).** At every place
`v` of `K` split in `E/K` (in particular every generic monomial
valuation), `Φ` has `K_v`-zeros. Proof: over `E ⊗ K_v ≅ K_v^5`
the form splits as `Σ c_i x_i² x_{i+1}` with independent
variables; the order-pattern lattice is `(2+σ̃)Z⁵` of index
`33`, cut out exactly by the two congruences `Σμ_i ≡ 0 (3)` and
`Σ5^iμ_i ≡ −W (11)`; the coordinate-difference functional is
SURJECTIVE on that sublattice (adjust three free coordinates by
CRT), so an exact two-term tie `{i, j}` with `{i,i+1} ∩ {j,j+1}
= ∅` and all other terms strictly larger is always realizable;
the residue equation `c̄_iA_i²A_{i+1} + c̄_jA_j²A_{j+1} = 0` has
solutions with all entries nonzero (four independent residue
unknowns), and the point is smooth (`∂/∂A_{i+1}` is a unit), so
Hensel lifts. ∎ At σ-invariant (inert/ramified) places the
five coefficient orders coincide (the `r_i` are one σ-orbit),
forcing a five-way tie whose leading ω-average vanishes for
`s ≢ 0 (mod 5)` and whose order-by-order corrections are
linearly solvable — solubility there too (PARTIAL: sketch, not
sealed). CONSEQUENCE: no one-bad-place proof exists; any
pointlessness proof is irreducibly global. This sharpens §8.9.1.

**Theorem I (the bridge, exact form).** By additive Hilbert 90
for `E/K` (trace-zero = `(1−σ)`-image) and the toric
factorization of ψ-classes:

    F55-YES ⟺ there exists φ ∈ E* with
      (i)   φ = ρ − σ(ρ) for some ρ ∈ E   (trace zero),
      (ii)  div_T(φ) ∈ Im(2+σ) on divisors of the torus,
      (iii) the unit (monomial) part of φ has λ-class
            ≡ −λ(e₂) ≡ 8 (mod 11),  λ(m) = Σ 5^i m_i.

(Sufficiency: solve `div(φ) = (2+σ)div(a₀)`; then `φr₂/ψ(a₀)`
is a unit `c·r^m` with `λ(m) ≡ 0` and `Σm ≡ 0 (3)`, hence a
ψ-value — scalars are cubes in `C*`.) The per-orbit invariants
of (ii): for a full σ-orbit of primes, TWO congruences — sum
≡ 0 (mod 3) and `5^i`-weighted sum ≡ 0 (mod 11); for
σ-invariant primes, multiplicity ≡ 0 (mod 3).

**The mod-3 surprise.** The naive trace-zero families fail (ii)
at THREE, not eleven: `φ = (r^m − r^{σm})·k³` (`k ∈ K`) has
binomial divisor pattern `(1,0,0,0,0)` per orbit — the mod-11
defect `λ = 5^{i₀}` COULD be corrected by cube-multiples
(`3λ(x) ≡ −5^{i₀}` is solvable), but the mod-3 orbit-sum
(`≡ 1`) can NEVER be (cube corrections are `≡ 0`). First
genuine tooth of the bridge: the obstruction layer that bites
first is the 3-part of `coker(2+σ)`, i.e. the CUBIC-ness, not
the 11-part the class narrative emphasized.

**The alignment observation.** The Kummer generator of the
11-layer, `b = r₀²r₁r₃⁴r₂⁻⁴`, satisfies `λ(e_b) = 2+5−12+16 =
11 ≡ 0 (mod 11)` AND `Σe_b = 3 ≡ 0 (mod 3)`: `e_b ∈ Im(2+σ)`
on the monomial lattice, so `b = c·ψ(r^x)` — the degree-11
cover and the ψ-structure are ALIGNED, not independent. Any
Weil-reciprocity pairing of φ against `b` (the candidate global
NO-argument) must be built modulo this alignment; conversely
the alignment is exactly what a YES-construction can exploit.

Named next steps: (NO-side) the reciprocity pairing of
trace-zero elements against the `b`-cover, on the
compactification where `b` acquires zeros/poles; (YES-side) the
interpolation problem for φ satisfying (i)–(iii) — now a
bounded, legitimate search space per the doctrine.

### 8.11 The reciprocity layer: the trace-zero twice-min law and the anchored pairing (2026-08-07)

**Theorem J (trace-zero twice-min law).** Let `φ ∈ E*` be
trace-zero and let `{σ^iP}` be any σ-orbit of prime divisors on
any σ-equivariant model (interior or boundary, zeros or poles).
Then the multiplicity pattern `v_i = ord_{σ^iP}(φ)` attains its
minimum AT LEAST TWICE. At a σ-INVARIANT prime `Q`, all five
transported orders coincide and the leading normal jets satisfy
the transported-sum-zero — the trace-zero condition RECURS on
the jet along `Q`. *Proof.* `Σ_i φ∘σ^{-i} = 0`; the order of
`φ∘σ^{-i}` along `P` is `v_{-i}`; a sum of functions vanishing
identically has no unique term of minimal order along any prime
(its leading jet would survive). ∎

This is the arithmetic twin of the tropical Plücker twice-min of
§8.6 — the two flanks of F55 obey the SAME shadow law, which is
strong evidence they are one lifting problem in two costumes.

**Corollary J.1 (the constraint web tightens).** The Theorem-I
condition (ii) and Theorem J genuinely interact: image patterns
of `(2+σ̃)` with a unique minimum — e.g. `(2+σ̃)(2,1,0,0,1) =
(5,2,0,1,4)` — are FORBIDDEN for trace-zero φ, while e.g.
`(2+σ̃)e₁ = (1,2,0,0,0)` (min thrice) survives both laws. The
Theorem-I feasible set is a proper, explicitly computable
refinement; neither law alone nor their single-orbit
conjunction kills it.

**The anchored pairing (the object asked for).** The naive
per-orbit invariant `λ_O(φ) = Σ 5^i v_i (mod 11)` is defined
only up to the base-point rotation, which scales it by
`5 = (−2)^{-1}`. But the Kummer generator satisfies the SEALED
recursion `σ(b) = r₂^{-11} b^{-2}`, so along an orbit of points
the 11-th-power-residue data of `b` transforms by `×(−2)` —
and `5·(−2) ≡ 1 (mod 11)`: anchoring λ by the residue character
of `b` at the chosen base-point makes

    ⟨φ, b⟩_O := λ_O(φ) anchored by χ₁₁(b)

WELL-DEFINED in `Z/11` at every orbit where `b` is a unit with
nonvanishing residue character. The 11-cover's `(−2)`-cocycle is
exactly the compensator of the weight ambiguity — the same
`(−2)` that runs the Klein cubic itself. What remains to derive:
the GLOBAL formula `Σ_O ⟨φ, b⟩_O ≡ (explicit boundary/invariant
term)` for trace-zero φ — a Parshin-style reciprocity along the
μ₁₁-cover `y^{11} = b` with its σ-twist; if the global term is
provably `≢ 8 − (interior contributions forced ≡ 0 by (ii))`,
Theorem I is violated and F55-NO follows. Status: pairing
constructed; reciprocity formula = the active derivation.

### 8.12 The sum, derived faithfully (2026-08-07)

**Correction IX-d.** §8.11 said `⟨φ, b⟩_O` is "well-defined in
`Z/11`". Overclaimed: over `C` the residue data of `b` along a
divisor is a function, not a number, and `C^*`-divisibility
kills every bottom-level character — NO numerical per-orbit
pairing exists. The compensation `5·(−2) ≡ 1` is real, but the
pairing's true home is the RESIDUE CLASS GROUP: `⟨φ, b⟩_O ∈
κ(P)^*/(κ(P)^*)^{11}`, and the "sum formula" that exists is the
Gersten reciprocity for `Br(E)[11]`, not a scalar identity.

**What is actually derived (all exact, hand-checkable):**

1. **The cover is a torus, and its symmetry is F55.** `b` is a
   unit monomial, so `y^{11} = b` is the isogeny `T′ → T` with
   `Λ′ = Λ + Z·(e_b/11)`, deck group `μ₁₁ = Λ′/Λ`. Since
   `σ(e_b/11) = −e₂ − 2(e_b/11) ∈ Λ′`, σ lifts, acts on the
   deck by `−2`, and `⟨deck, σ⟩ ≅ C₁₁⋊C₅ = F55`: the b-cover's
   symmetry group is F55 itself.
2. **Norm triviality.** `σ^i(b) = (11th power)·b^{(−2)^i}` and
   `Σ_{i=0}^{4}(−2)^i = 11`, so `N_{E/K}(b) ∈ (E^*)^{11}` — the
   eleven that makes `[b]` a σ-eigenclass of eigenvalue `−2` in
   `E^*/11` is the same eleven as the cover degree.
3. **The exact eigen-identity.** `e₁ + e_b = (2,2,−4,4,0)` is
   even, so with the honest monomial `n := r^{(1,1,−2,2,0)}`:
   `σ^{-1}(b) = b^5·n^{-11}` EXACTLY (the sign dies: `−1` is an
   11th power in `C`). Hence `[σ^{-1}b] = [b]^5` on the nose.
4. **The corestriction identity.** For φ satisfying Theorem-I
   (ii) (`φ·r₂ = ψ(a)`), in `Br(K)[11]`:

       A_K := cores_{E/K}(φ, b)₁₁
            = 7·cores(a, b) + cores(r₂^{-1}, b),

   using `(ψ(a), b) = (a,b)²(σa, b)`, `cores∘σ = cores`, and
   item 3 (`(a, σ^{-1}b) = 5·(a,b) − 11·(a,n) ≡ 5·(a,b)`;
   `2 + 5 = 7`).
5. **Theorem K (interior unramifiedness).** The transported
   residue of `A_K` at a K-prime under a split interior orbit
   `O` is `[b|_P]^{λ_O(φ)} ∈ κ(P)^*/11`; Theorem-I (ii) forces
   `λ_O ≡ 0`, so `A_K` is UNRAMIFIED at every such prime. Its
   only possible ramification: σ-invariant interior primes
   (where Theorem J's jet-recursion governs) and the boundary
   (where `v(b) = ⟨w, e_b⟩ ≠ 0` and condition (iii) lives).

**The honest shape of the endgame.** The sum formula is the
exactness of the Gersten complex for `Br[11]`: residues of
`A_K` satisfy codim-2 cancellation; there is no scalar shortcut.
The remaining computation is forced and specific: evaluate the
BOUNDARY residues of `A_K` on a smooth σ-stable toric
compactification (input: `e_b`-pairings with the rays, φ's
boundary patterns constrained by Theorem J and principality) and
the σ-invariant-prime residues (input: the jet recursion), and
test whether the class-8 requirement (iii) is consistent with
`A_K = 7·cores(a,b) + cores(r₂^{-1},b)` having exactly those
residues. Inconsistency ⟹ F55-NO ⟹ `ed = 4`. Consistency ⟹
the reciprocity route exhausts with no obstruction, and F55
rides on construction alone. This is a bounded computation over
an explicit fan — analysis-first has taken it as far as
identities go.
[Superseded same day by §8.13: analysis was NOT done — three
further derivations sharpen the endgame materially.]

### 8.13 Analysis continued: full interior unramifiedness, the second-order congruence, and the cover loop (2026-08-07)

**Theorem K′ (A_K is unramified on the ENTIRE interior).** Two
new inputs. (a) σ acts on `T` with exactly FIVE fixed points
(`r = (t,…,t)`, `t⁵ = 1`) — fixed locus of codimension 4 — so
`T → T/σ` is étale in codimension 1 and NO interior K-prime
ramifies in `E/K`: interior places are split or inert only.
(b) At an inert place (a σ-invariant prime `Q`, common
multiplicity `v` by Theorem J), the residue of `A_K` is the
NORM `[N_{κ(Q)/κ(q)}(b|_Q)]^v`; by identity 2
(`N_{E/K}(b) ∈ (E^*)^{11}`) this norm is an 11th power:
RESIDUE TRIVIAL, automatically. Together with Theorem K: `A_K`
is unramified at every interior prime. Since `K = C(U₁,…,U₄)` is
RATIONAL and the unramified Brauer group of a rational field is
zero, **`A_K` is faithfully determined by its boundary residues
alone** — the endgame ledger is purely at infinity.

**Constraint (iv) — the second-order congruence (new).**
Matching interior residues of the two expressions for `A_K`:
the left side is residue-free (Theorem K′); the right side's
`7·cores(a,b)` has residue `[b|_P]^{7λ_O(div a)}` at the orbit
`O`. Hence at EVERY interior orbit where `b|_P` is not an 11th
power: `λ_O(div a) ≡ 0 (mod 11)`. Since
`div(φ) = (2+σ̃)div(a)`, this is a SECOND-ORDER condition on φ:

    λ₂(pattern_O(φ)) := λ((2+σ̃)^{-1} pattern_O(φ)) ≡ 0 (mod 11),

cutting the per-orbit pattern lattice from index 33 to index
363. The only escape: orbits whose primes are `b`-SPLIT
(`b|_P ∈ κ(P)^{*11}`), i.e. primes that split completely in the
cover `T′ → T`.

**The cover loop (structural).** The `b`-split escape localizes
the residual freedom on `T′` — whose symmetry group is F55
itself (§8.12.1): the obstruction analysis of the F55-twist
closes onto an F55-symmetric 4-torus, with the deck `μ₁₁` acting
by translations and σ by lattice automorphisms. The remaining
analysis is therefore: (α) the boundary residue ledger of
`A_K = 7·cores(a,b) + cores(r₂^{-1},b)` on a smooth σ-stable
fan — with `cores(r₂^{-1},b)` a FULLY EXPLICIT monomial algebra
whose ledger is derivable by hand; (β) the `b`-split orbit
analysis up on `T′` with its F55-action. Both are analysis;
neither is exhausted; the computation threshold has NOT yet
been reached.

### 8.14 The boundary ledger of B, the λ-twisted norm, and the forced boundary pattern (2026-08-07)

Notation: `c := Σ_i 5^i e_{2−i} = (3,5,1,9,4) ≡ 3·((−2)^i)_i
(mod 11)` — the Klein weight vector, now in its THIRD role.
There are no σ-invariant rays (`N^σ = 0` in the cocharacter
lattice), so every boundary orbit has size 5.

**Theorem L (the ledger of `B = cores(r₂^{-1}, b)`; `B ≠ 0`).**
Transporting the five conjugate residues along a boundary orbit
and using `[σ^{-i}b] = [b]^{5^i}`:

    ∂_q(B) = ∂_w(r^{-c}, b)
           = [ r^{ ⟨w,c⟩·e_b − ⟨w,e_b⟩·c } ]  ∈ κ(D_w)^*/11,

a boundary-torus character class; it vanishes iff
`⟨w,c⟩ ≡ ⟨w,e_b⟩ ≡ 0 (mod 11)` (since `e_b ≡ (2,1,7,4,0)` and
`c ≡ (3,5,1,9,4)` are independent mod 11). Rays with
`⟨w,c⟩ ≢ 0` exist, so **`B` is ramified and nonzero in
`Br(K)[11]`** — the first proof that the corestricted
obstruction algebra genuinely lives.

**Theorem M (the λ-twisted norm; coherence of the 7 and the
c).** Define `N_λ(x) := Π_i σ^{-i}(x)^{5^i}` (mod 11th powers).
Then `N_λ(ψ(a)) = N_λ(a)^{2+5} = N_λ(a)^7` and
`N_λ(r₂) = r^c`. Hence Theorem-I(ii) forces
`N_λ(φ) = N_λ(a)^7·r^{-c}` — the SAME `7` and the SAME `c` as
the corestriction identity of §8.12: two independent
computations agree, a strong coherence check of the whole
apparatus.

**Theorem N (the forced boundary pattern).** Applying λ to
`pattern(φ) + pattern(r₂) = (2+σ̃)pattern(a)` at a boundary
orbit: `Σ_i 5^i⟨σ^i w, e₂⟩ = ⟨w, c⟩`, so

    λ_w(φ) ≡ −⟨w, c⟩  (mod 11)   at EVERY boundary ray-orbit:

φ's boundary λ-invariants carry NO freedom — they are pinned to
the covector `c`. In particular at every ray with `⟨w,c⟩ ≢ 0`
the boundary pattern of φ lies OUTSIDE `Im(2+σ̃)`, while
Theorem J's twice-min law still binds it; the two coexist
per-orbit but jointly rigidify the compactified divisor of any
Theorem-I solution.

**Remaining analysis (not yet computation).** (α) The clean
per-ray assembly of the full consistency equation (unit-part
bookkeeping of the three residue contributions — `A_K` from
φ-data, `7·cores(a,b)`, and Theorem L's ledger) and its
solvability test in `(w^⊥∩Λ)/11` per ray; (β) the b-split
orbits on the cover `T′` (the Constraint-(iv) escape) under the
F55-symmetry; (γ) the codim-2 Gersten compatibilities linking
neighboring rays. Only if all three close consistently does the
route exhaust; a single unmatchable ray proves F55-NO and
`ed = 4`.

### 8.15 The per-ray equation collapses: the uniform law, the transpose identity, and the final combinatorial system (2026-08-07)

**Theorem O (per-ray solvability ⟺ the uniform second-order
law).** With leading units `ℓ_w(·)` along `D_w`, the per-orbit
residue of a corestricted symbol is
`∂_q(cores(x,b)) = [ℓ(N_λ(x))^{⟨w,e_b⟩}·ℓ(b)^{−λ_w(x)}]`.
Substituting Theorem M (`N_λ(φ) = N_λ(a)^7 r^{-c}·(11th
power)`) and Theorem N (`λ_w(φ) ≡ −⟨w,c⟩`), the ENTIRE per-ray
consistency equation between the two expressions for `A_K`
cancels except for one factor:

    [ℓ_w(b)]^{7·λ_w(a)} ≡ 1  in κ(D_w)^*/11.

So no ray is ever unmatchable outright: the Brauer-residue layer
yields NO direct contradiction; it yields the UNIFORM LAW

    (iv′)  λ_O(div a) ≡ 0 (mod 11) at EVERY orbit — interior
           and boundary alike — except where ℓ(b) is an 11th
           power on the divisor (the b-split locus).

The exact cancellation (the `N_λ`- and `r^c`-terms meeting their
twins from Theorem M) is itself a further coherence check.

**Theorem P (the transpose identity; the tower deepens).** By
the §8.10 alignment `b = (const)·ψ(r^x)` and the symbol
adjunction `cores(z, σy) = cores(σ^{-1}z, y)`:

    cores(a, b) = cores(a²·σ^{-1}(a), r^x) = cores(ψ^*(a), r^x),

with `ψ^* = 2 + σ^{-1}` — the TRANSPOSE of ψ. This gives a
second, independent residue computation of `cores(a,b)` with
monomial second slot and `⟨σ^iw, x⟩`-weightings in place of
`5^i`-weightings; equating it with the first yields third-layer
relations MIXING the two weight systems. The reciprocity tower
deepens rather than closes.

**The consolidated final system.** All Brauer theory is now
discharged; what remains is a self-contained combinatorial
feasibility question about ONE divisor datum `D := div(a)` on
the compactified torus:

  (F1) `(2+σ̃)D − div(r₂)` obeys the trace-zero laws: Theorem J
       twice-min at every orbit, jet-recursion at σ-invariant
       primes (none interior; boundary rays have none either —
       all orbits size 5);
  (F2) `λ_O(D) ≡ 0 (mod 11)` at every non-b-split orbit [iv′],
       with the b-split escape available only on the locus
       splitting in `T′`;
  (F3) the transpose-layer relations [P] between the
       `5^i`-weighted and `⟨σ^iw,x⟩`-weighted invariants of `D`;
  (F4) principality/polytope closure on a smooth σ-stable fan,
       with the boundary λ-pattern of `(2+σ̃)D − div(r₂)` pinned
       to `−⟨w,c⟩` [N].

F55-YES requires (F1)–(F4) satisfiable plus the algebraic
lifting (the §8.7-type gap); F55-NO follows if (F1)–(F4) are
INFEASIBLE — and this, at last, is a pure lattice-combinatorics
question, the arithmetic twin of §8.7's tropical system. Honest
prior: every prior layer ended feasible, so feasibility is the
likely outcome; but the interlock here (four laws on one datum)
is the tightest yet and must be genuinely decided. This is the
next — and plausibly last — analysis block of the arithmetic
flank.

### 8.16 The crux polytope question (2026-08-07)

Working (F1) at the boundary through Newton polytopes: with
`Q := Newton(a)` and `g_i(w) := h_Q(σ^i w)` (support function),
the boundary pattern of `φ = ψ(a)r₂^{-1}` at the ray `w` is
`(2g_i + g_{i-1} − ⟨σ^i w, e₂⟩)_i` — the `(2+σ̃)`-structure yet
again, now with the LINEAR defect `t_i = ⟨σ^i w, e₂⟩`.

**Theorem Q (the crux).** The boundary half of the final system
is equivalent to: *does there exist a lattice polytope `Q` such
that for EVERY `w`, the minimum of
`(2h_Q(σ^iw) + h_Q(σ^{i-1}w) − ⟨σ^iw, e₂⟩)_i` is attained at
least twice?* Established tonight:

- 0-dimensional `Q` (monomial `a`) FAILS at generic rays — the
  shadow-level echo of "no monomial is trace-zero".
- σ-INVARIANT `Q` fails identically: the pattern becomes
  `3g(w)·(1,…,1) − t_i`, whose twice-min needs the unique-max of
  `t` to degenerate — impossible. Removing the defect exactly
  would need `(2+σ)t-solvability`, i.e. `λ(e₂) ≡ 0 (mod 11)`:
  FALSE (`λ(e₂) = 3`). Equivalently the exact solution is the
  NON-LATTICE point `(2+σ)^{-1}e₂` with denominator exactly 11:
  **the order-11 class reappears as a non-integrality
  obstruction on polytopes** — its third guise (multiplicative
  class → congruence functional → denominator).
- Honest trace-zero functions satisfy Theorem J through the
  CHAIN mechanism (consecutive conjugates share Newton faces —
  e.g. `r₀ − r₁`, whose conjugate segments form the cyclic
  pentagon chain); a feasible `Q` must orchestrate this chain
  sharing against the `e₂`-defect. First structured candidates
  (single segments; the invariant zonotope) fail; asymmetric
  zonotopes built on the cyclic chain are the next family.

**Two distinct 11-covers.** The refinement `Λ + Z·(2+σ)^{-1}e₂`
(the crux's denominator) and `Λ′ = Λ + Z·(e_b/11)` (the b-cover,
the (iv′) escape locus) are DIFFERENT 11-isogeny directions
(`adj(2+σ)e₂ ≢ unit·e_b mod 11`): the final system's two escape
hatches live on two independent covers.

**Interior bits are free.** Interior orbits obstruct nothing:
patterns like `11·e₀` satisfy (F1) (`(2+σ̃)(11e₀) = 11(2,0,0,0,1)`,
min thrice) and (F2) (`λ = 11 ≡ 0`) simultaneously.

STATUS: the F55-NO question is now Theorem Q's polytope
existence (+ the still-implicit (F3) transpose layer and b-split
bookkeeping). A proof that NO such `Q` exists finishes F55
negatively and sets `ed = 4`; an explicit `Q` closes the shadow
system feasible and the arithmetic flank ends at the same
lifting wall as the geometric one. Active: the structured-`Q`
hunt and, in parallel, a hoped-for invariant proof that the
`e₂`-defect's unique exposure cannot be doubly covered.

### 8.17 The endgame state: the 9-invariant, the hand-verified certificate, and the one remaining lemma (2026-08-07)

**Theorem R (the h-free congruence).** For any function `h` with
integer values on lattice points, `F := 2h + h∘σ^{-1} − e₂^*`
satisfies, at EVERY lattice point `n`:

    Σ_i 9^i·F(σ^i n) ≡ −⟨n, c₉⟩  (mod 11),
    c₉ := Σ 9^i σ^{-i}e₂,  σ(c₉) ≡ 9·c₉,

because `2 + 9 = 11`. All h-dependence cancels. Consequently the
five orbit-values of `F` can never be all equal at any anchor
(`⟨n, c₉⟩ ≢ 0`), e.g. at the special orbit
`n_j = (1,1,1,1,1) − 5e_j` where `⟨n₀, c₉⟩ ≡ 2`.

**The certificate, hand-verified.** The computed mod-11 Farkas
certificate for the crux LP has FOUR terms — coefficients
`(1, 10, 3, 6)` on the tie-equations at the four rays
`n₁,…,n₄` — and unwinding it (all five h-value coefficients
cancel: `1−1, 1+10, 10+3−2, 3+6−20, 6−6 ≡ 0 mod 11`; the
`e₂`-part survives `≡ ±1`) shows it IS Theorem R at the special
orbit, rewritten through consecutive differences. Verified by
hand line by line.

**The computational sweep (evidence, not proof).** On the A₄
Weyl fan (30 rays, 120 chambers, unimodular): the equality
system of EVERY uniform tie-pattern (20) and 400 random mixed
patterns is solvable over Q, mod 2, 3, 5 — and INFEASIBLE mod
11, every single time. On a stellar refinement (135 cells, 35
unknowns): 120 random per-cell (not even equivariant) patterns —
all infeasible mod 11. The invariant rational solution has
denominator exactly 33.

**The structural web.** Every A₄-chamber contains exactly one of
the five special rays; the special orbit carries ONE value-vector
`V` (up to shift), and every chamber's tie equates two shifted
entries of `V`: a 120-edge web on `Z/5`. Two horns: if the
induced partition of `Z/5` is trivial (all singletons), twice-min
fails; if total (one class), Theorem R is violated at the
anchors. A globally CONSTANT tie-partition is killed by the
shift-monodromy (`d | 5` forces singleton-or-total). What
remains open is exactly:

**Lemma S (remaining; finite, combinatorial).** For every
σ-invariant complete fan and every cell-wise tie-assignment
consistent with twice-min, the accumulated web of tie-equalities
at the anchor orbits is mod-11 inconsistent (i.e. the varying-
partition escape — coarsening across walls with shift-monodromy
— cannot dodge all anchors).

**Consequences, conditional on Lemma S.** Theorem Q = NO ⟹
(F1)-infeasible ⟹ by Theorem I and Theorem J, NO trace-zero φ
exists ⟹ Φ is pointless ⟹ **F55-NO on both twins ⟹ the
headline is NEGATIVE: the Klein cubic is not PSL₂(F₁₁)-
unirational and `ed_C(PSL₂(F₁₁)) = 4`**, refuting the CSD
instance (D-R Prop 10.8(b)) and completing Beauville's
classification negatively. If instead Lemma S FAILS, its failure
certificate is a feasible shadow and the arithmetic flank ends
at the lifting wall with F55 open. The verdict is NOT claimed:
per the IX-8 discipline, the four-times-repeated escape pattern
of this problem demands Lemma S be proved or refuted explicitly,
not extrapolated — but for the first time in the program, a
single named finite lemma stands between the current state and a
resolution of the headline.

### 8.18 The conserved eleven: both poles of the escape space die (2026-08-07)

The one candidate escape from the mod-11 obstruction was
identified and constructed: work on the `G₉`-FAN — the fan of
orderings of `(H₀,…,H₄)`, `H_k(w) = ⟨σᵏw, G₉⟩`, `G₉ = (1,5,3,4,9)`
the mod-11 eigenvector with `c₉ = 4·G₉` — where EVERY wall-normal
is `≡ (multiple of) G₉ (mod 11)`, so the level-1 obstruction
dissolves into the trivially-satisfiable `Στ ≡ 7 (mod 11)`.
The canonical construction there: zero-set = "H₀ ranks 4th or
5th" (a perfect 2-cover), leaving exactly ELEVEN free ray-values
`v_S` (`S ∋ 0`, `|S| ≤ 3`); isotropic margin designs solve the
(ii)-congruence linearly (particular solution `7·P₂ + P₃`) but
provably fail the covering (support analysis); the free design
is the 11-unknown system. Its fate, computed exactly (15,892
sampled integrality + congruence conditions):

- mod 5: consistent, unique solution `v ≡ 0`;
- mod 11: consistent, unique solution `v ≡ 0` — because the
  ray-gaps of the `G₉`-fan are divisible by 55: the wall
  degeneracy that dissolves the level-1 obstruction IMPORTS
  11-divisibility into the lattice geometry and forces
  `v ≡ 0 (mod 11)` through integrality;
- substituting `v = 11w`, the level-121 system for `w` is
  **INCONSISTENT** (3,614 rows, rank 5, infeasible): the anchor
  inhomogeneity, invisible mod 11 on this fan, reappears intact
  one level up.

**The conserved-eleven mechanism.** On generic fans the anchor
obstruction (Theorem R) kills at level 1 — hand-verified
four-term certificate. On 11-degenerate fans the same eleven
that clears level 1 re-enters through the ray-gap divisibility
and kills at level 11². Dodge the class and it returns as the
congruence; dodge the congruence and it returns as the
denominator; dodge the denominator and it returns as the gap;
dodge the gap and it returns one 11-adic level up.

**Proof plan for Lemma S (now concrete).** (α) Dichotomy lemma:
every σ-invariant complete fan either has an anchor-obstructed
wall-structure (level-1 Farkas as on A₄) or is `G₉`-aligned with
55-divisible gaps (level-(k+1) regress). (β) The regress
induction. Status: both poles verified computationally; mixed
fans, other H-fan zero-patterns, and the second 11-cover
direction (`adj(2+σ)e₂`) remain to sweep; then the write-up.
The needle points hard at S-TRUE — i.e. at F55-NO and
`ed = 4` — but the theorem is not yet claimed.

### 8.19 Corner closure and the two lemmas; the last gap is one renormalization statement (2026-08-07)

**The complete sweep table (every verdict rigorous: infeasibility
conclusions use only finitely many derived-valid constraints, so
sampling can only UNDERSTATE the obstruction; pipeline validated
by the exact rational invariant-point self-tests).**

- A₄ fan (generic walls): 20 uniform + 400 random equivariant
  patterns — ALL infeasible at level 11.
- Stellar refinement: 120 random per-cell (non-equivariant)
  patterns — ALL infeasible at level 11.
- `G₉`-aligned fan: ALL 26 σ-coherent rank-patterns (complete
  enumeration) — 9 have no free rays (d ≡ 0 forced, anchors
  violated); 17 force `v ≡ 0 (mod 11)` and die at level 121.
- `e_b`-aligned fan (the second 11-cover direction): 4/4 tested
  patterns — same signature: forced `v ≡ 0`, level-121 death.
- Isotropic margin designs (12 generators): the (ii)-linear
  system is solvable (`7P₂ + P₃` + 7-dim kernel) but NO
  coefficient support satisfies the covering (support analysis +
  200k samples).

**Lemma T (freezing; proved).** If all wall-normals of Σ lie,
mod 11, in a subspace `L ⊆ Λ/11`, then every solution has
`ū := U mod 11` valued in `L` (jumps confined to `L`; zero-cells
anchor the constant). ∎

**Lemma U (the ker-π₉ case; proved).** If `π₉(L) = 0` (the
wall-span misses the 9-eigenline projection), the system dies at
level 1: the 9-eigencomponent of the orbit congruence reads
`0 ≡ −4 (mod 11)`. ∎ (With Lemma T this settles every fan whose
wall-classes avoid the 9-direction.)

**The renormalization picture (the last gap, stated exactly).**
For 9-active aligned fans the level-1 system dissolves
(`Στ ≡ 7`), but integrality forces the observed regress: the
aligned geometry has 55-divisible ray-gaps, `v ≡ 0 (mod 11)` is
forced, and the substituted level-2 system reproduces THE SAME
system on the 11-refined lattice — computationally verified on
two independent aligned fans, both dying at level 121. The
remaining statement to prove:

**Lemma V (self-similarity; OPEN).** For any σ-invariant fan
whose mod-11 wall-span is 9-active, the level-(t+1) reduction of
the (1)(2)(3)-system is isomorphic to a level-t system of the
same form on the 11-isogenous lattice (the `T′`-cover — whose
deck symmetry is F55), with the SAME anchor inhomogeneity `c₉`
(a σ-eigenvector, preserved by the isogeny; anchors never die
under refinement). Lemma V + Lemmas T/U + König-style descent ⟹
no level ever clears ⟹ Lemma S ⟹ **F55-NO ⟹ headline
NEGATIVE, `ed_C(PSL₂(F₁₁)) = 4`.**

Also to close for full generality: non-rank (per-orbit free)
patterns on aligned fans (expected to reduce to the rank case by
Lemma T's confinement; not yet swept), and genuinely mixed fans
(expected: a 9-inactive wall-orbit triggers Lemma U locally or
the generic-part certificate; not yet formalized). The theorem
is one renormalization lemma and two routine closures away, with
its mechanism verified at both poles and its every tested
instance dead.

### 8.20 The U-frame: the level-2 system identified exactly (2026-08-07)

**The clean frame (all proved).** Parametrize by per-cone slopes
`U(C) ∈ Λ` (equivalent to integer values on `N`: every full-dim
cone's lattice points generate `N`, via `n = (n + tc) − tc`).
Then: (1) zero-pattern `U = 0` on ≥ 2 cells per σ-orbit;
(2) wall-jumps `U − U′ = m_W·ν_W`, `m_W ∈ Z`; (3) the orbit
congruence `Σ9ᵏσ⁻ᵏU(σᵏC) ≡ −c₉ (mod 11Λ)` — and (3) is
EXACTLY equivalent to (ii); it carries NO content beyond mod 11.

**Correction IX-e (precision).** Earlier prose ("the anchor
reappears at level 121", "(ii) at mod 121") was imprecise: (ii)
has no mod-121 content. The computations were nonetheless sound
— they tested derived-valid consequences — and what they
actually detected is the following exactly-identified level-2
system. On a fully aligned fan write `U = τ·G₉ + 11V` (Lemma T;
zero-cells force `τ = 0 ∧ V = 0` since `G₉` is primitive). Then:
level 1 fixes `Στ ≡ 7 (mod 11)` per orbit and `m_W ≡
Δτ/λ_W (mod 11)`; the residual integer freedom `m_W ↦ m_W + 11`
changes the `V`-jump by exactly `ν_W` — the recursion in
miniature. The V-field satisfies

    V − V′ = m_W·ρ_W − k_W·G₉   (ν_W = λ_W G₉ + 11ρ_W),

with `k_W` determined, and the binding constraints are the
**V-WEB SYSTEM**: `V` must VANISH on every zero-cell, i.e. all
`V`-path-sums between zero-cells — inhomogeneous terms driven by
the τ-field and the lift data `ρ_W` — must die modulo the
`ν`-lattice of path-freedoms. Since `Στ ≡ 7 ≠ 0` forces `τ ≢ 0`,
the inhomogeneity of the V-web is NONZERO: the τ-field is the
RENORMALIZED ANCHOR. This is the precise content of Lemma V:

**Lemma V (final form).** On a 9-active aligned fan, the V-web
system is again a system of type (1)(2)(3) — same fan, same
zero-web, jump data `ρ_W`, anchor = the τ-class — and its anchor
is nontrivial whenever the level above it was. Granting this and
iterating: `U ≡ 0 (mod 11^t)` for all `t`, so `U = 0`,
contradicting the level-1 anchor. With Lemmas T and U (which
settle all 9-inactive spans) and the generic-case certificates,
Lemma S follows.

**Status.** The V-web infeasibility is COMPUTED on both aligned
fans for every σ-coherent pattern (that is what "level-121
death" was); what remains for the theorem is the self-similarity
statement in its final form above — now a precise claim about an
explicitly constructed system — plus the two routine closures
(free patterns; mixed fans). The proof of Lemma V (final form)
is the single task left.

### 8.21 The level-2 certificate and the corrected endgame shape (2026-08-07)

**Correction IX-f (the induction was wrong-shaped — and the
truth is simpler).** §8.20's Lemma V ended "granting this and
iterating". Wrong shape: there is no infinite descent. The
computed structure is: level 1 is SOLVABLE (the τ-layer exists,
`Στ ≡ 7`), and it is LEVEL 2 — the V-web — that is infeasible
OUTRIGHT, for every pattern on both aligned fans. So the
remaining task is smaller than stated: prove the V-web's direct
infeasibility for all 9-active aligned fans; no renormalization
tower is needed.

**The τ/Θ-curvature reformulation (derived).** With
`ν_W = λ_W G₉ + 11ρ_W` and `Θ_W := ρ_W/λ_W mod L₉` (a class in
the 3-dim quotient `(Λ/11)/L₉`), the V-web reduces mod 11 to:
for every path `P` between zero-cells,
`Σ_{W∈P} Δτ_W·Θ_W ≡ 0`; by summation by parts (τ vanishes at
both ends) this pairs the τ-field against the CURVATURE of Θ
(its wall-to-wall variation across cells). The full aligned
system is therefore: `Στ ≡ 7` per orbit, `τ = 0` on the
zero-web, and τ ⊥ the Θ-curvature web — and Lemma S (aligned
case) is EQUIVALENT to: *the orbit-sum functional lies in the
span of the Θ-curvature relations* (then `7 ≡ 0`, absurd).
Seed data: on the `G₉`-fan the lift vectors are integral and
clean, e.g. `ν₀₁ = G₀ − G₁` gives `ρ₀₁ = −(1,3,2,3,5)` exactly.

**The level-2 certificate (extracted).** The V-web's Farkas
certificate is again FOUR terms — coefficients `(6,6,2,1)` on
congruence rows at four lattice points with anchors
`(8,5,1,6) mod 11` — but unlike the level-1 certificate (one
σ-orbit, hand-unwound as Theorem R) it spans four DIFFERENT
rank-chambers: a genuine web identity through the zero-set, as
the curvature picture predicts. Unwinding it by hand into the
span-statement is the opening move of the proof.

**The remaining list, final.** (1) Unwind the level-2
certificate ⟹ prove the span-statement for the `G₉`-fan class;
(2) generalize to all 9-active aligned fans (the ρ-data is
canonical); (3) the two routine closures (free patterns — expected
to follow from Lemma T confinement; mixed fans — expected from
Lemma U + the generic certificate). Nothing else stands between
the program and Lemma S ⟹ F55-NO ⟹ **ed_C(PSL₂(F₁₁)) = 4**.

**Honest position after the full derivation.** Both flanks of
F55 are genuinely deep, in matching ways: the geometric machine
ends at a tropical-to-exact lifting gap (§8.7), and the
arithmetic twist ends at a multiplicative-class-to-form lifting
gap (§8.9.1) — two faces of one difficulty, which is presumably
WHY this case is a named open problem of the literature. The
decisive assets that remain live: a ladder hit (mechanical,
d = 6 in flight, gate at 7); a genuinely new idea bridging
class-to-form (the E18 packet's own stopping point since
2026-08-01); or the machine's inventory/rigidity pair closing
against the trend. No elementary closure exists on either side —
that is the analytic conclusion of the campaign.

**Verdict of the analytic campaign on the inventory.** The
necessary-conditions tower (incidence → germ weights →
endpoint links → span sweep → squares kill → tropical trees)
terminates: everything provable at these altitudes is proved
(pentagon; u₀-free kill; `|Z| ≥ 4`; exposure), and the last
necessary layer is SATISFIABLE, so no further kill can come from
valuations alone. The inventory decision now legitimately drops
to bounded exact solves: the feasible trees pin the candidate
degeneration profiles (contact orders, strata, `σ`), each giving
a finite-dimensional algebraic system over the field; the
minimal profiles are the place to start. Strategically this
RAISES the likelihood that the pentagram inventory is nonempty
(a consistent degeneration profile exists at every σ) — i.e.
that the machine's F55 run ends in an honest no-go — in which
case F55 rides entirely on E18/arithmetic, as the twice-burned
suspicion (E14, IX.8) always suggested. Rigidity (§8.4.2)
remains the other open half and is unaffected by all of §8.5–8.7.

**What is now genuinely at stake in layer 5.** The source
complex forces images for coordinate lines of ALL four ratios.
For pentagon ratios the target supplies lines; for pentagram
ratios it supplies (so far) nothing. Two open sub-questions
decide the machine's F55 fate:

1. *Inventory:* does the V₁₄ carry ANY equivariant stable
   rational curve through a pentagram pair (any degree)? If the
   classification comes back EMPTY, the target chain-graph is
   the pentagon.
2. *Forcing:* is some source stratum forced to map
   NON-constantly with pentagram-linked endpoint values? The
   currently proved forcings do not pin this: a tower's several
   fixed components are not yet proved to share one value, so a
   pentagram source line may a priori contract (its endpoint
   values connected through pentagon chains — connectivity of
   the pentagon is what keeps the escape open). A proof that
   tower values are rigid (all fixed components of one tower ↦
   one point) would turn an empty pentagram inventory into
   F55-NO = `ed = 4`; conversely a flexible-value construction
   plus a nonempty inventory would re-establish the no-go
   honestly.

Both sub-questions are finite and concrete; neither is decided.
The E18 arithmetic route runs in parallel, unaffected.

### 8.22 The aligned kill, exact: every pattern on the G₉-fan class and on the sign-fan dies; the (τ,Ψ)-frame and the depth tower (2026-08-07)

**Correction IX-g (bookkeeping, two items).** (i) §8.19's sweep table
said "9 with no free rays, 17 dead at level 121". The rerun and the
exact derivation below give the split 8 + 18 (the no-free-ray patterns
are exactly the P ⊇ {0,4} together with {0,1,4}, {0,2,4}, {0,3,4},
{0,1,2,4}, {0,1,3,4}, {0,2,3,4}, {0,1,2,3,4}); all 26 die either way.
(ii) `f55_sweep2.py`'s advertised part (B) — random per-orbit
patterns — never executed; that gap is closed below for EVERY per-orbit
pattern at once (Theorem X), not by sampling.

**Correction IX-h (IX-f overgeneralized; the tower is real).**
Correction IX-f inferred "level 2 dies outright; no renormalization
tower is needed" from the two tested fans. That is a feature of
DEPTH-1 aligned combinatorics, not of the aligned case: for every
t ≥ 2 there exist σ-invariant complete fans all of whose wall normals
are ≡ λ·G₉⁽ᵗ⁾ (mod 11ᵗ), where G₉⁽ᵗ⁾ is the mod-11ᵗ Hensel lift of
the 9-eigenvector (take the arrangement fan of the σ-orbit of a
hyperplane with such a normal; the orbit stays deep because G₉⁽ᵗ⁾ is
σ-eigen mod 11ᵗ). On such fans the level-2 shadow below is SOLVABLE
(all curvatures Θ_W equal the fixed point Θ*; the pair field
(τ,Ψ) = f·(1,Θ*) with per-orbit sums 7 exists), so the kill must come
one level deeper: the corrected proof shape for Lemma S (aligned) is
an induction on alignment depth. Each individual fan has FINITE depth:
the 11-adic eigenvector has irrational coordinate ratios (its
eigenvalue is the 5th root of unity 9̂ ∈ Z₁₁ ∖ Q), so no integer
normal is aligned to all orders. Both depth-1 base types are now
closed completely (Theorems X and X′).

**Setup.** N = {n ∈ Z⁵ : Σnᵢ = 0}, H_a(n) = ⟨σᵃn, G₉⟩,
V₀ := H₀(n) = ⟨n, G₉⟩. Everything below kills the value-form system:
integral-sloped PL d on a σ-invariant complete fan, d = 0 on ≥ 2
cells per σ-orbit of maximal cones, and (ii):
Σ_k 9ᵏ d(σᵏn) + ⟨n,c₉⟩ ≡ 0 (mod 11) at every n ∈ N. (The min-
normalization that produces this from Theorem Q's twice-min is sound
because m(w) = min_i F(σⁱw) is σ-invariant with integral slopes and
Σ_k 9ᵏ m(σᵏn) = 22·m(n) ≡ 0 — the eleven again. Positivity d ≥ 0 is
discarded; the kill is a fortiori.)

**Lemma Y (profile).** σ⁻¹G₉ ≡ 5·G₉ (mod 11), hence
H_a(n) ≡ 5ᵃ·V₀ (mod 11) and G₉ = (5⁰,…,5⁴) mod 11. At a lattice
point with H-ranking π (descending) and sorted gaps g_j the gaps obey
g_j ≡ (G₉[π[j−1]] − G₉[π[j]])·V₀ =: ΔG₉_j(π)·V₀ (mod 11), and
⟨n,c₉⟩ ≡ 4V₀. ∎ (One line: σ⁻¹G₉ = (5,3,4,9,1) = 5·G₉ − 11·(0,2,1,1,4).)

**Lemma Z (G₉-fan geometry).** On the G₉-fan (orderings of H₀…H₄;
this is the arrangement fan of the ten hyperplanes {H_a = H_b}, so it
refines every complete fan whose walls lie in those hyperplanes):
every ray r_S (S the top-block) has H-profile (11(5−|S|) on S,
−11|S| off S); in particular every ray gap is 55 and ⟨G₉, r_S⟩ ≡ 0
(mod 11). For lattice n in the chamber of π,
n = Σ_j (g_j/55)·r_{π[:j]}, so a PL function with ray values v has
d(n) = Σ_j g_j·v_{π[:j]}/55. ∎ (H is injective; both sides have equal
H-profiles.)

**Theorem W (level-1 death on the G₉-fan; hand grade).** Any solution
has v ≡ 0 (mod 11) at every ray. Proof: all wall normals of the fan
are ≡ (5ᵃ−5ᵇ)·G₉ (mod 11), so Lemma T confines U(C) mod 11 to
F₁₁·G₉: U(C) ≡ τ_C·G₉; then v_S = ⟨U(C), r_S⟩ ≡ τ_C·⟨G₉,r_S⟩ ≡ 0 by
Lemma Z. ∎ (Machine cross-check `f55_exact1.py`: the exact 144–192-row
level-1 system has full rank = #free rays for all 18 surviving rank
patterns.)

**Theorem X (the G₉-fan class dies for EVERY pattern).** Let the
zero-pattern be ANY assignment of ≥ 2 zero chambers per σ-orbit of
the 120 chambers (rank patterns are the special case). Then the
system is infeasible. Proof in five steps, each finite:

(a) *E-collapse.* Write w = v/11 ∈ Z^{rays} (Theorem W), w_S = 0 for
every ray bordering a zero chamber. For n interior to the chamber of
π with V₀ ≢ 0, the congruence (ii), divided by V₀, becomes
Σ_{q ∈ O, q ∉ 𝒵} D(q)·w ≡ −4·5 ≡ 2 (mod 11), where O is the
chamber-orbit of n, D(q)·w := Σ_j ΔG₉_j(q)·w_{prefix_j(q)}, using
d(σᵏn) = (Σ_j g_j w_{π[:j]−k})/5, Lemma Y, ΔG₉_j(π) = 5ᵏΔG₉_j(π−k),
and 9ᵏ5ᵏ = 45ᵏ ≡ 1. A zero chamber's four prefixes are all bordered,
so D(q)·w = 0 for q ∈ 𝒵 and the row is pattern-independent:
**E(O)·w ≡ 2 for each of the 24 orbits**, E(O) := Σ_{q∈O} D(q).
(Verified against the sampled `f55_sweep2.py` pipeline at 3,636
interior lattice points per pattern, fresh seed; `f55_exact2.py`.)

(b) *Closed form.* E(O)_S = 5ᵗ·ΔG₉_j(π) for S = π[:j] + t
(j = |S|), else 0: the unique chamber of O with j-prefix S is π + t,
and G₉[a+t] ≡ 5ᵗG₉[a]. 

(c) *Twisted-sum collapse.* With ξ(T) := Σ_t 5ᵗ w_{T+t} one has
ξ(T+1) = 9·ξ(T) (5⁵ ≡ 1), so E(O)·w = Σ_j ΔG₉_j(π)·9^{s_j}·ξ_{c_j}
where π[:j] = T_{c_j} + s_j and c ranges over the SIX translation
classes of proper nonempty subsets of Z/5 (sizes 1,2,2,3,3,4). The
24×6 matrix A has rank 6 (`f55_xistar.py`), so A·ξ = 2·(1,…,1) has
the UNIQUE solution ξ* = (7,4,2,10,3,9) on the classes
({0},{0,1},{0,2},{0,1,2},{0,1,3},{0,1,2,3}) — nowhere zero.

(d) *Feasibility criterion.* w free on non-bordered rays makes the
coordinates ξ_c independent except that ξ_c = 0 whenever ALL five
rays of class c are bordered. Hence the pattern is feasible iff ξ*
vanishes on every fully-bordered class — i.e., since ξ* is nowhere
zero, iff every class keeps at least one free ray.

(e) *Covering theorem.* No admissible pattern keeps a free ray in
every class: for each of the 5⁶ = 15,625 transversals (one target
ray per class) some σ-orbit has ≤ 1 chamber avoiding all six targets
among its prefixes (exhaustive count: 0 of 15,625 succeed;
`f55_xistar.py`). So some class is fully bordered and the system is
infeasible. ∎

Sharpness: with only ≥ 1 zero per orbit ALL 15,625 transversals
succeed — the twice-min "2" is exactly load-bearing; and dropping any
one of the six classes reopens 350–3,125 transversals — all six are
load-bearing. By refinement the theorem kills every complete fan
whose walls lie in the ten hyperplanes {H_a = H_b} (solutions
transfer to the G₉-fan with ≥ 2 zeros surviving per orbit).

**Hand certificates (rank patterns).** In the R-normalization
(R(π) := 9·E(π)-rows restricted to free rays; R·w ≡ −4): for the
canonical P = {3,4}, 4·R(0,1,4,2,3) + 5·R(0,1,4,3,2) + 1·R(0,4,3,1,2)
has free-ray column sums 77, 77, 55, 55, 55, 55 ≡ 0 while the
right side sums to 10·(−4) ≡ 4 ≢ 0. For sixteen of the eighteen
surviving rank patterns two rows suffice: the bottom-swap chamber
pairs have PROPORTIONAL rows with ratio −5, e.g.
(G₉₂−G₉₄)/(G₉₂−G₉₃) = (1−5²)/(1−5) = 6 ≡ −5 ≡ −9⁻¹ — both
instances of 54 + 1 = 55: the conserved eleven. All minimal
certificates enumerated in `f55_exact2.py`.

**Theorem X′ (the sign-fan dies for EVERY pattern).** The arrangement
fan of the five hyperplanes {H_k = 0} (30 sign cells, 6 orbits, 70
walls; wall normals μ_k = (σᵀ)ᵏG₉ ≡ 5ᵏG₉ — an aligned fan NOT
refined by the G₉-fan). Level 1 is solvable (aligned signature). The
level-2 shadow is the pair field (τ,Ψ): cells → F₁₁ × Q,
Q := (Λ/11)/⟨G₉⟩ ≅ F₁₁³, with wall jumps in the lines F₁₁·(1,Θ_k),
Θ_k = ((μ_k − 5ᵏG₉)/11)/5ᵏ ∈ Q, vanishing on zero cells, and
Στ ≡ 7 per orbit. Computed exactly (`f55_signfan.py`,
`f55_signfan_close.py`): Θ = (0, (0,0,10), (0,2,10), (7,2,10),
(3,7,5)); the jump+sum system has a 7-dimensional solution space; ANY
two zero cells on the corank-1 orbit (rep (+,+,+,+,−); dually
(+,−,−,−,−)) are already inconsistent — all 10 pairs on each of
those two orbits, 5 of 10 on the middle orbits, single cells always
consistent. Since every admissible pattern must place two zeros on
the corank-1 orbit, every pattern is infeasible. ∎ (DFS over all 10⁶
minimal patterns confirms; it prunes at the first orbit.)

**The (τ,Ψ)-frame for general aligned fans (the T3 core, derived).**
On any aligned fan, Lemma T gives the canonical decomposition
U = τ̃G₉ + 11V; the pair (τ, Ψ) := (τ̃ mod 11, V mod (11,G₉)) is
lift-independent; wall jumps obey Δ(τ,Ψ) ∈ F₁₁·(1, Θ_W) with
Θ_W = ρ_W/λ̃_W mod (11,G₉) canonical in the wall (ν_W = λ̃G₉ + 11ρ);
zero cells force (τ,Ψ) = 0; and (3) is exactly Στ ≡ 7 per orbit.
Null walls cannot occur (a primitive ν with ν ≡ 0 in Λ/11 would have
content 11). The curvature transport law is AFFINE:
**Θ_{σW} = 5·σΘ_W + 5γ′**, γ′ = (σ_*G₉ − 9G₉)/11 = (0,−4,−2,−3,−7),
and γ′ ∉ ⟨G₉, diag⟩ mod 11; consequently at most one wall per
σ-orbit is flat (Θ = 0), the five partial sums s₁…s₄ are the sign-fan
Θ-list (all nonzero), and the unique transport-fixed curvature Θ* is
exactly the mod-121 Hensel direction of Correction IX-h. σ-invariance
itself generates curvature: this is the structural reason the aligned
escape keeps dying.

**Status after §8.22.** Closed completely, every pattern, exact and
sample-free: (α) all complete fans with walls among {H_a = H_b} (the
G₉-fan class, Theorem X); (β) the sign-fan {H_a = 0} (Theorem X′).
Still open for Lemma S: general aligned fans (the depth-t tower of
IX-h plus general depth-1 combinatorics — the (τ,Ψ)-frame is the
tool; the two closed types are its base instances) and mixed fans
(T5, untouched). The A₄-side level-1 kill (§8.17) stands. Lemma S,
F55-NO, and the headline remain UNCLAIMED.

### 8.23 The A₄-fan dies for every pattern — the ray-point argument; the order-fan criterion (2026-08-07)

**Theorem X″ (the A₄-fan class dies for EVERY pattern; level 1,
three lines).** On the A₄ Weyl fan (orderings of the coordinates)
with ANY zero-pattern (≥ 2 zero chambers per σ-orbit), the
(1)(2)(3)-system is infeasible. *Proof.* (a) For each proper
nonempty S ⊂ Z/5 the ray generator r_S = 5χ_S − |S|·(1,…,1) is a
lattice point with r_{S+k} = σᵏr_S, so the congruence (ii) AT the
point r_S reads Σ_k 9ᵏ d(σᵏr_S) ≡ −⟨r_S, c₉⟩ ≡ −5·c₉(S) (mod 11),
and the six class values 5·c₉(T_c) = (9,10,3,4,2,7) on
T_c = ({0},{0,1},{0,2},{0,1,2},{0,1,3},{0,1,2,3}) are all nonzero.
**SIGN (added 2026-08-08 after the PARI cross-check — a labelling
hazard, not an error):** the tuple (9,10,3,4,2,7) is `+⟨r_S,c₉⟩`.
The TARGETS appearing on the right of the congruence, and used by
the order-fan criterion below and everywhere downstream, are the
NEGATIVES: `η(T_c) = −⟨ray(T_c),c₉⟩ = (2,1,8,7,9,4)`. Both are
nowhere zero so the kill is unaffected, but quote (2,1,8,7,9,4)
— not (9,10,3,4,2,7) — in any later note or formalization.
(b) d vanishes on every closed zero chamber, hence at every bordered
ray point. (c) By the covering theorem (§8.22(e) — the identical
count, 0 of 15,625 transversals), some class has all five translates
bordered; its congruence reads 0 ≡ nonzero. ∎

This upgrades the A₄ record from 420 sampled patterns (§8.17, §8.19)
to all patterns, and by refinement covers every complete fan whose
walls lie among the ten hyperplanes {n_a = n_b}. (Completeness of the
ray-point rows as the full mod-11 level-1 content also holds — the
coordinate gaps are free mod 11 since the A₄ ray gap is 5 — but only
necessity is needed for the kill. Verified: `f55_a4exact.py`,
identity at 200 patterns × 20 points, 20,000 random + all uniform
patterns infeasible.)

**The order-fan criterion (general σ-orbit order fans).** For a
primitive linear form ℓ on N with σ-orbit (ℓ∘σᵏ)_k (the five forms
sum to zero on N automatically), the order fan of the orbit behaves
by the mod-11 type of ℓ:
- ℓ generic (ℓ-gaps free mod 11): the level-1 rows collapse to the
  six class-rows η(T_c) ≡ −⟨ray_ℓ(T_c), c₉⟩; the fan dies for every
  pattern iff all six pairings are ≢ 0, by the covering theorem
  (A₄ = the case ℓ = e₀*). If some pairing ≡ 0, patterns dodging the
  dead classes exist (the drop-one-class counts of §8.22 are
  positive) and the kill must descend a level.
- ℓ aligned (ℓ ≡ λ·⟨·,G₉⟩ mod 11): block-equality of the five
  translated values forces every ray value ≡ 0 (two equal units
  5ᵏλV₀ would need k = k′), so level 1 forces v ≡ 0 (mod 11) as in
  Theorem W, and the level-2 E-collapse produces an ℓ-specific
  ξ*(ℓ) ∈ F₁₁⁶; the fan dies for every pattern iff ξ*(ℓ) is
  nowhere zero (the G₉-fan: ξ* = (7,4,2,10,3,9)); zeros of ξ*(ℓ)
  push the kill one 11-adic level deeper — the depth tower of
  Correction IX-h, now visible inside one fan family.

**Status after §8.23.** Closed for every pattern, exact: the A₄-fan
class {n_a = n_b} (level 1), the G₉-fan class {H_a = H_b} (level 2),
the sign-fan {H_a = 0} (level 2, pair-field). The recurring final
step is one covering statement against one finite nonvanishing
vector. Remaining for Lemma S: arbitrary fans outside these classes
(general order fans via the criterion above; general aligned fans
via the (τ,Ψ)-frame and the depth induction; mixed fans). Lemma S
remains UNCLAIMED.

### 8.24 The order-fan eigen-classification (2026-08-07)

Eigenframe mod 11: M-side eigencovectors G_ε = (1,ε,ε²,ε³,ε⁴),
N-side eigenvectors v_ε = (ε^{-j})_j, ε ∈ {3,9,5,4} (G₅ = G₉ is the
aligned direction); components a_ε(ℓ) with ⟨ℓ, v_ε⟩ = 5·a_ε.
Two facts, both finite-checked (`f55_ellfan.py` + inline):
(α) the block-Fourier coefficients 1̂_S(ε) = Σ_{k∈S} εᵏ are nonzero
for all six subset classes and all four ε (24 checks — sums of ≤ 4
distinct fifth roots of unity in F₁₁ do not vanish on these
supports); (β) ⟨v_ε, c₉⟩ = 0 for ε ≠ 5 and ⟨v₅, c₉⟩ ≡ 9.

**Theorem X‴ (classification of order fans of σ-orbits of a
primitive covector ℓ, by the active set A(ℓ) = {ε : a_ε ≢ 0}).**

(i) 5 ∉ A: the wall-span misses the G₉-line; Lemma U kills every
pattern at level 1. [Proved, §8.19.]

(ii) A = {3,9,5,4} (fully active): along any ray, the five
transported values V_k = Σ_ε p_ε εᵏ have p_ε = scale·1̂_S(ε), so by
(α) every ray keeps a nonzero v₅-component and by (β) all six class
targets −⟨ray_ℓ(T_c), c₉⟩ are ≢ 0; the ray-point argument + the
covering theorem (§8.23) kill every pattern at level 1. [The A₄ fan
is the instance ℓ = e₀*, all components ≡ 1. Sweep: 816 fully-active
ℓ, zero violations.]

(iii) A = {5} (aligned): every ray value ≡ 0 (mod 11) (a
degenerate-profile forces scale ≡ 0), v ≡ 0 (mod 11) is forced, and
the level-2 class system has the unique ξ*(ℓ); the fan dies for
every pattern iff ξ*(ℓ) is nowhere zero. Instances (all
nowhere-zero, hence dead for every pattern): the G₉-fan
(ξ* = 9·(7,4,2,10,3,9) in the −4-normalization), **the e_b-fan
(ξ*(e_b) = (1,10,5,3,2,6) — upgrading the 4/4-sampled record of
§8.19 to ALL patterns; e_b ≡ 8·G₉ + 5·diag)**, and
G₉ + 11μ for μ = e₀, e₀−e₁, e₂+e₃. The member ℓ = G₉ + 11e₁ has
121-divisible ray gaps — the first concrete depth-2 inhabitant of
the IX-h tower; its analysis needs level 3.

(iv) 5 ∈ A, {5} ⊊ A ⊊ {3,9,5,4}: some non-5 component dead. Then
every ray value ≡ 0 (mod 11) and rays collapse mod 11 into the
inactive eigenspan (verified on samples), all six targets vanish,
and the chamber profile carries |A| parameters — the single-V₀
collapse fails, so neither the level-1 class kill nor the aligned
ξ*-machinery applies as-is. OPEN: the intermediate regimes. [The
"bad generic" sweep — 86 of 400 small ℓ — is exactly the union of
the events a₃ = 0, a₉ = 0, a₄ = 0, matching this classification;
a₅ = 0 alone stays dead via (i).]

**Status after §8.24.** Within the order-fan universe the open
territory is exactly: (iv)'s intermediate active sets, the general
nonvanishing of ξ*(ℓ) over aligned ℓ (all computed instances
nonzero), and the depth tower for deeper-aligned ℓ. Outside it:
non-order fans (the sign-fan is closed; the (τ,Ψ)-frame is the
general tool) and genuinely mixed wall-systems (T5). Lemma S
remains UNCLAIMED.

### 8.25 The delegated verification round: regime (iv) swept dead, ξ* projectively rigid, the tower verified to 11⁴, the mixed dichotomy split, the flag-sign fan closed globally, link 1 replayed (2026-08-07)

Provenance: six worker runs (Opus-grade, briefs with calibration
gates), every headline re-adjudicated by the director by re-running
the committed deterministic probes. New probes: `f55_verify_all.py`,
`f55_midfan.py`, `f55_alignedsweep.py`, `f55_mixedfan.py`,
`f55_flagsign.py` (§8.26 adds `f55_mixedlevel2.py`,
`f55_mixedlevel3.py`).

**Correction IX-i (probe precision; conclusions unaffected).**
`f55_sweep2.py`'s level-11 else-branch reduces an integrality row
`row·v ≡ 0 (mod L)` with 11 ∤ L to a mod-11 row — not implied as
written. On the G₉-fan the unreduced modulus (55-scaled) does carry
the eleven, so every recorded G₉ verdict stands (and Theorems W/X
are independent of the probe); the generalized level tools
(`f55_alignedsweep.py`, `f55_midfan.py`) drop such rows and derive
the level reduction cleanly: substituting v = 11ˢy into
`row·v + rhs ≡ 0 (mod M)` yields mod-11 content only when
v₁₁(M) > s.

**(a) Master verifier and chain link 1.** `f55_verify_all.py`
re-asserts all wave-31 verdicts (9 items, 40 sub-checks) at fresh
seeds — ALL PASS, re-run clean at five independent base seeds. Both
sealed packets of link 1 replay green: FIX-IX-SEAL end-to-end at the
fresh prime 353 (four M2 recomputes, independent trace-sum 10′
identification; ALLGREEN) and H_11_5_TWIST read-only
(H_11_5_INDEPENDENT_VERIFY_OK). Coherence: that packet's ψ-matrix
block (det 33; the solve of ψ(v) = e₂ with denominator exactly 11)
is the same conserved-eleven operator as Theorem R, and its pinned
combine_r((2,1,−4,4,0)) = 11β is the e_b direction of §8.24(iii).

**(b) Regime (iv) is computationally dead (`f55_midfan.py`).**
Eight fans covering all six intermediate active sets (including two
with ray gaps 3355 and 3905): per fan, all 26 rank + 26 uniform +
2000 random + 1019 protected-ray patterns — 24,568 tests, ZERO
feasible. Methodological gains: (i) the level-1 forcing v ≡ 0
(mod 11) is per-pattern (without a pattern the residual is exactly
the linear family v_S = ⟨U, r_S⟩ of dimension 4 − |A|: the zero
cells are what pin U — a precision on Theorem W's hypotheses); it
was gated and held on every test. (ii) The per-orbit level-2 row
spaces have dimension exactly |A| with σ scaling augmented rows by
5, so attaining |A| at the empty pattern PROVES the sampled
collection exhaustive for every pattern. (iii) Depth census: 92 of
896 regime-(iv) covectors are deeper (v₁₁(gap) ≥ 2) — the IX-h
tower lives inside regime (iv) too; unswept.

**(c) ξ* is projectively rigid; the tower verified to 11⁴
(`f55_alignedsweep.py`).** Over 608 aligned fans (grid + random +
λ-variants): 455 admit the level-2 collapse, and every single
ξ*(ℓ) equals c·(7,4,2,10,3,9) for some c ∈ F₁₁* — ten projective
representatives, one projective class. Since rank 6 with
inhomogeneous RHS forces ξ* ≠ 0, RIGIDITY ⟹ NOWHERE-VANISHING: the
§8.24 open item reduces to one statement (the collapse matrix A(ℓ)
is a scalar multiple of A(G₉)). The (λ, μ mod 11)-dependence
conjecture is REFUTED, but every mismatch is a pure scalar change —
the kill criterion is untouched. The 153 deeper fans stratify as
depth 2 (135), 3 (17), 4 (one: gap 5·11⁴). Level machinery
(IX-i-clean): the depth-2 fan G₉ + 11e₁ — all 26 rank patterns DEAD
at level 11³ with v ≡ 0 forced (full rank, unique zero) at levels 1
and 2; a depth-3 member dead at 11⁴; the killing row count is
invariantly 2286 at the final level. Lemma V's self-similarity now
has three verified rungs: death at level 11^(depth+1), the anchor
riding up unchanged.

**(d) The mixed fan splits exactly (`f55_mixedfan.py`; T5).** The
common refinement of the A₄ and G₉ fans: 1090 cells (provably
complete — the exact Zaslavsky count from the intersection lattice
{0:1, 1:20, 2:125, 3:230, 4:1}), 2570 walls each certified by an
exact rational facet point (1400 generic, 1170 aligned; wall count
also provably complete, §8.26). Level-1 mod-11 verdicts over 1052
patterns: all 26 A₄-induced rank patterns, all 500 random per-orbit
patterns, and every saturating pattern DIE; but 25 of 26 G₉-induced
rank patterns and all aligned pullbacks SURVIVE, with solution space
exactly U ∈ F₁₁·G₉ and τ constant across every generic wall — the
Lemma-T confinement here is forced BY THE ZERO WEB THROUGH THE
GENERIC WALLS (their span is everything; the web forces every
generic jump to vanish), not by the wall span. Exact survival
criterion, verified on all 1052: a pattern survives level 1 ⟺ every
σ-orbit of G₉-chambers keeps a chamber free of zero cells. So the
§8.19 mixed expectation was half right: the generic sub-web kills
the non-aligned sector at level 1 and adds no level-1 freedom; the
aligned sector rides through to level 2 (§8.26).

**(e) The flag-sign fan is closed — and the kill is GLOBAL
(`f55_flagsign.py`).** The refinement of the G₉-order fan by the
sign hyperplanes: 480 cells (all realizable), 1080 exactly-certified
walls, all aligned; new curvature data for the ten order-wall
classes (e.g. Θ(H₀=H₁) = (0,0,7)). The (τ,Ψ) system has solution
dimension 47, and — unlike every previously closed fan — NO local
kill exists: all 96 orbits have all 10 zero-pairs individually
consistent. A solution-space DFS (state = affine subspace,
canonical-rref dedup, fail-first branching) closes ALL minimal
patterns: infeasible, 83,386 nodes, deepest partial commitment 26 of
96 orbits, every branch death by pair-exhaustion. Controls: the
anchor 7 → 0 flips the fan to feasible — Στ ≡ 7 is the sole
obstruction source. Consequences: (i) a fourth fan class is closed
for every pattern; (ii) the general depth-1 aligned argument CANNOT
be local (the Theorem X′ template does not transfer); the proof
shape must be global, as the ξ*/covering arguments are. By-product:
the G₉-order fan's own (τ,Ψ) shadow dies for every pattern
independently of the value-frame route.

**Status.** Adjudicated dead for every pattern, exact: the A₄ class,
the G₉ class, the e_b-fan, the sign-fan, the flag-sign fan, eight
regime-(iv) fans (sampled patterns beyond the exhaustive families),
455 rigidity-backed aligned fans, and tower fans to depth 3. Chain
links 1–5 all re-audited (link 1 by packet replay). The mixed fan's
aligned sector is the live front — continued in §8.26.

### 8.26 The mixed fan defeats the relaxation: positivity is load-bearing (Correction IX-j) (2026-08-07/08)

**Correction IX-j (MAJOR — the last-gap lemma was transcribed
lossily).** The (1)(2)(3)-frame of §8.20, and the handoff's link-6
statement of Lemma S, dropped POSITIVITY: the honest necessary
system from Theorem Q's min-normalization is on d(w) =
F(w) − min_i F(σⁱw), which satisfies d ≥ 0 EVERYWHERE in addition
to (1) zeros, (2) integral jumps, (3) the congruence. Every
recorded kill is unaffected — each killed the relaxation, a
fortiori the true system — but the relaxation is now proved
STRICTLY LOSSY: on the mixed fan it is integrally satisfiable
(below). Lemma S must be restated with (0) d ≥ 0 included; no
argument using (1)(2)(3) alone can be complete over all fans.

**The mixed level-2 pair field (`f55_mixedlevel2.py`).** On the
mixed fan the survivors' shadow system ((τ,Ψ) with the derived
generic-wall law Δτ ≡ 0, ΔΨ ∈ F₁₁·ν̄ — verified, 8000 integer
simulations) has dimension 62 = 24 (the pure-G₉ system) + 38
Ψ-slides along generic walls. Exhaustively over the 25 level-1
surviving G₉-rank patterns: 23 infeasible, TWO FEASIBLE —
P = {0,1} and P = {3,4} — plus 95 of 216 one-orbit variants and a
non-pullback DFS witness; every witness re-certified by an
independent plain-integer checker (0 violations across 2570 walls,
218 sums, all zeros) and its τ-layer re-verified as a genuine
level-1 U-frame solution. Mechanism: the A₄-class walls let Ψ
slide inside a G₉-chamber — d need not be linear on G₉-chambers —
exactly the freedom the Theorem-X refinement/transfer argument
lacks. Ψ is non-constant on 35 G₉-chambers in the P = {3,4}
witness, as it must be.

**Integral feasibility — the tower is vacuous on the mixed fan
(`f55_mixedlevel3.py`).** With a validated Z/11ˢ solver (1000
planted systems, brute-force cross-checks, Farkas certificates
demanded and verified for every infeasibility): gates reproduce
the known kills entirely inside the slope frame — the A₄ fan dies
at 11¹ (all 26 rank patterns; certificate y·b = 4), the G₉-order
fan at 11² (histogram {1:1, 2:25}; certificates y·b = 88, 55).
On the mixed fan, 23 of the 25 surviving rank patterns die at 11²;
the two pair-field survivors P = {0,1}, {3,4} are feasible through
11⁸ — and INTEGRALLY: ker_Z of the full homogeneous system has
rank exactly 19 (rational rank pinned by three large primes;
CRT-reconstructed integer kernel basis, max entry 22) and is
11-SATURATED, so mod-11ˢ feasibility for all s is equivalent to
integral feasibility; the mod-11 congruence layer cuts an 11⁸-class
family, and an explicit integer U-field (max |U| = 336) satisfies
every wall jump over Z, every zero cell, and the congruence (ii) at
every lattice point — ground-truthed directly at 10,000 random
points of N and all their σ-translates (0 failures). At least 14
patterns carry such integral witnesses. The witness takes 81
negative cell-values: it is NOT a min-normalized field.

**What this settles and what it opens.** (i) T5 cannot be closed by
zeros + integral jumps + the congruence at any 11-adic depth: the
conserved-eleven tower, sufficient on every arrangement fan tested,
is VACUOUS on the mixed fan. (ii) The discarded ingredients are now
the whole question: positivity d ≥ 0 (equivalently the twice-MIN
structure — the zero cells must be minimizers, not just zeros) or a
value-frame argument on refined cells. The positivity-restored
question on the mixed witnesses is a bounded exact program: rays of
the mixed fan + the rank-19 solution lattice + d ≥ 0 at rays — an
exact LP/ILP (`f55_mixedpos.py`). If positivity kills, T5's true
mechanism is identified and the corrected Lemma S survives with a
new constraint class (inequalities, not congruences — note the
§8.17 crux LP always HAD the inequalities; the (1)(2)(3)-shortcut
was the lossy step). If a nonnegative integral witness exists, the
§4 failure branch of the handoff triggers for the corrected lemma.
Lemma S (corrected) remains UNCLAIMED in both directions.

### 8.27 Positivity does not restore the kill: the value-form lemma is FALSE on the mixed fan (2026-08-08)

**The test (`f55_mixedpos.py`; director-adjudicated).** Rays of the
mixed fan enumerated exactly: 460, with an INDEPENDENT completeness
proof — the arrangement is essential, so chambers are pointed and
every extreme ray has active-set rank 3, i.e. lies among the 1-dim
kernels of rank-3 normal triples; their count must be
2 × #(rank-3 flats) = 2 × 230 = 460, which it is. Hence d ≥ 0
everywhere ⟺ d ≥ 0 at the 460 rays (cross-checked: 1500 random
interior points of 550 cells are exact nonnegative rational
combinations of their cell's rays).

**Verdict: positivity does NOT kill.** For the witness patterns the
cone K⁺ = {x ∈ ker_Q(H) : d_x ≥ 0 at every ray} is FULL-DIMENSIONAL
(dim K⁺ = 19 = dim ker_Q H), so no Farkas certificate exists, and
explicit NONNEGATIVE INTEGRAL witnesses were constructed and
verified for P = {0,1} (max |U| = 432) and P = {3,4}
(max |U| = 845), plus 12 more of the (e)-family — 14 in all. Each
is certified over Z independently of the encoding: 0 of 2570 wall
jumps fail integrality, 0 of 436 zero cells are nonzero (≥ 2 per
σ-orbit), 0 of 460 rays are negative, and at 15,986 random lattice
points with all σ-translates: d ≥ 0 everywhere (0 failures), the
**TWICE-MIN law holds (0 failures)**, and the congruence (ii) holds
(0 failures). Of the 27 one-orbit (e)-variants, 15 die at the
mod-11 congruence layer alone (no residue solves it) and all 12
congruence-feasible ones carry nonnegative integral witnesses.

**Consequence — Lemma S as stated is FALSE.** The honest necessary
system of Correction IX-j — (0) d ≥ 0, (1) twice-min zeros,
(2) integral slopes, (3) the congruence — is SATISFIABLE on a
σ-invariant complete fan. Restoring the dropped inequalities does
not recover the kill; T5 cannot be closed at the value-form level
at all, and no 11-adic depth helps (§8.26: the kernel is
saturated). Every earlier verdict stands as stated (each fan class
listed in §§8.22–8.25 really is infeasible); what is refuted is the
UNIVERSAL quantifier — the value-form system is not infeasible for
every σ-invariant complete fan, because the mixed fan satisfies it.

**What is NOT settled.** This does not refute F55-NO. The value
form is a SHADOW of Theorem Q: the honest object is
F = 2h + h∘σ⁻¹ − e₂* for an integral-sloped PL h, and the witness d
is its min-normalization, d = F − m with m σ-invariant. A witness
counts against Theorem Q only if it LIFTS: ∃ integral-sloped PL h
and σ-invariant integral-sloped PL m with 2h + h∘σ⁻¹ − e₂* = d + m,
i.e. per cone 2U_h(C) + σ_*U_h(σ⁻¹C) − e₂ = U_d(C) + U_m(C) with
wall conditions on both. Since det(2+σ) = 11 on Λ, the preimage
carries an 11-torsion condition — which is where the congruence (3)
came from, and possibly MORE than it (the σ-twist couples cones, so
solvability is a global lattice question, not the pointwise
cokernel condition). Two outcomes: the witnesses lift ⟹ Theorem Q
is satisfied on the mixed fan ⟹ Lemma S is false at the honest
level and the arithmetic flank ends at the shadow-feasible/lifting
wall (the §4 failure branch of the handoff; F55 stays OPEN); or
they do not lift ⟹ the value-form transcription lost content
beyond positivity, the preimage condition is a NEW constraint class
(inequalities plus a global (2+σ)-solvability), and the campaign
resumes against the corrected system. This is a finite exact
computation on the same 19-dim lattice (`f55_qpreimage.py`, in
flight). Until it returns, neither Lemma S nor F55-NO nor the
headline is claimed — and the §8.22–8.25 fan kills remain valid
theorems about the objects they name.

### 8.28 The witness lifts: Theorem Q is SATISFIED, Lemma S is FALSE (Correction IX-k) (2026-08-08)

**Correction IX-k (terminal for this route).** §8.27 left one gap:
does a value-form witness lift to Theorem Q proper? It does —
explicitly, for all 14 witnesses, with an honest lattice polytope.
Lemma S is FALSE, and the conserved-eleven/value-form programme
CANNOT prove F55-NO.

**The lift is an identity, not a search.** In `Z[x]/(x⁵−1)` with
`x = σ̃`: `(x+2)·G(x) = x⁵ + 32 ≡ 33`, `G = 16 − 8x + 4x² − 2x³ +
x⁴` (verified independently). So `2 + σ̃` is INJECTIVE and h is
UNIQUE: `h = (1/33)·G(σ̃)(d + m + e₂*)`. Hence (*) is solvable ⟺
`33 | G(σ̃)(d + m + e₂*)` cellwise. Since `G(1) = 11`, a
σ-invariant m contributes exactly `11·U_m`, and CRT splits the
criterion:
- **mod 11**: m drops out and the condition is EXACTLY congruence
  (3) — verified as an operator identity,
  `G(U) + G(e₂) ≡ 5(Σ_k 9ᵏ σ_*^{−k}U(σᵏC) + c₉)`;
- **mod 3**: the condition is `U_m ≡ U_D (mod 3)` with
  `D := Σ_j d∘σʲ`, satisfied by taking `m = D` (itself σ-invariant,
  integral-sloped, PL).

The mod-3 layer is load-bearing, not vacuous: with `m = 0` only
5 of 1090 cells are 3-divisible; with `m = D`, all 1090. This is
§8.10's "mod-3 surprise" (the 3-part of coker(2+σ)) reappearing —
and here it is SATISFIABLE, because m is free. **Consequence: on
the mixed fan the value form and Theorem Q are EQUIVALENT, not
strictly weaker.** The hoped-for extra content in the preimage
does not exist; §8.17's virtual-polytope generality was right.

**An actual lattice polytope (Theorem Q proper).** `h₀` is not
convex, but `Φ(n) := Σ|⟨l, n⟩|` over the 20 σ-stable defining
forms is σ-invariant, integral-sloped and strictly wall-convex on
exactly this fan, and `2Φ + Φ∘σ⁻¹ = 3Φ`, so replacing
`h₀ ↦ h₀ + T·Φ` shifts F by the ORBIT-CONSTANT `3T·Φ` and cannot
disturb the twice-min structure. `h_T = h₀ + 128Φ` is convex
(exact ray criterion, 0 failures at all 460 rays), so
`Q := conv{U_{h_T}(C)}` is a LATTICE POLYTOPE with `h_Q = h_T`.

**Fan-free confirmation.** Evaluating `h_Q` by brute-force
maximization over Q's lattice points — using no fan, no cell
indexing, no wall list — at 40,000 random `w ∈ N` (14,249 of them
non-generic, i.e. on walls or rays): the σ-orbit minimum of
`(2h_Q(σⁱw) + h_Q(σ^{i−1}w) − ⟨σⁱw, e₂⟩)_i` is attained AT LEAST
TWICE at 40,000 of 40,000, and Theorem R holds at 40,000 of
40,000. Non-degenerate: multiplicity exactly 2 at 39,712. And it
holds at EVERY w, not merely samples: (**) gives `F = d + m` with
m σ-invariant, so `min_i F(σⁱw) = m(w)`, attained at the ≥ 2
indices where `d(σⁱw) = 0`.

**Status.** Theorem Q = YES. Lemma S = FALSE. All fan-kill
theorems of §§8.22–8.25 remain true about the fans they name; what
is refuted is the universal quantifier, and no 11-adic depth or
positivity restoration can repair it. This is the §4 failure
branch of `HANDOFF_F55_ENDGAME.md`: **the arithmetic flank ends at
the same shadow-feasible/lifting wall as the geometric flank
(§8.7)** — the two faces of one difficulty, as §8.21 suspected.

**NOT settled: F55 itself.** A feasible Q is NECESSARY, not
sufficient: it closes only the boundary half (F1) of §8.15's
system. Still open: the (F3) transpose layer, the b-split
bookkeeping (F2/iv′), and above all the actual existence of a
trace-zero φ realizing the shadow — the class-to-form lifting gap
of §8.9.1, untouched by this run. **F55 is OPEN; the headline
(ed_C(PSL₂(F₁₁)) = 3 vs 4) is UNDECIDED.** Second-engine
confirmation (Nemo/PARI) was in flight at write-up time; the
verdict above rests on one engine plus the director's independent
check of the 33-identity.

### 8.29 (F2)/(F3) tested — and Correction IX-m: the Brauer layer's index flip makes (F2) circular (2026-08-08)

Probe `f55_f2f3.py` (director-adjudicated by rerun). Two results,
and the second undercuts the first.

**Result 1 — (F2), IF VALID, kills every witness.** Testing the
5-weighted law `λ_w(div a) ≡ 0 (mod 11)` at the 92 boundary
ray-orbits of the mixed fan: 77–78 failures per witness; off the
Theorem-L exempt orbits the pass rate is 10 of 1092. Family-wide
it is a mod-11 linear system on the same rank-15–19 lattice and is
**INFEASIBLE for all 14 witness families** under all three
readings of the b-split exemption, every infeasibility carrying a
verified Farkas certificate (44 one-row certificates per family).
Mechanism: at 405 of 460 rays `d(w) ≡ 0 (mod 11)` for every family
member, and at 52 of 92 orbits this holds at all five conjugates,
so both λ's vanish and each law collapses to its covector — `c₉`
is orthogonal to those rays (which is exactly why the witnesses
satisfy congruence (3)) while `c` is not. Hand-checkable
certificate: `w = (−27,−12,13,13,13)`, `d = [9900,2310,4070,0,0]`,
`⟨w,c₉⟩ ≡ 0` but `⟨w,c⟩ ≡ 8`, so (F2) reads `0 ≡ 3`.

**Result 2 — (F3) kills nothing: it is an identity.** With
`e_b = (2+σ⁻¹)x`, `x = (0,2,−3,2,0)`, the two corestriction
computations agree term by term for EVERY integer order pattern
(0 failures over 14 × 92); 6 of 6 perturbations of x break them,
so the test is live, not vacuous.

**Correction IX-m (the index flip; blast radius across §§8.9–8.16).**
- **F-1.** §8.9 works in the COMPONENT index (`μ_i = 2s_i +
  s_{i+1}`, transpose kernel `5ⁱ`; Correction IX-c is right there),
  while §§8.14–8.16 and all code work in the RAY index
  (`2g_i + g_{i−1}`, transpose kernel `9ⁱ`). In the pinned
  convention (σ_M = shift₋₁, verified two independent ways) these
  give DIFFERENT functionals: `λ∘ψ = 7λ` but `L9∘ψ = 0`. Every
  statement of the form "pattern ∈ Im(2+σ̃) forces λ ≡ 0" — Theorem
  I(ii) read per-orbit, Theorem K, §8.13's index 33 → 363, and
  Theorem N — invokes a property λ has only in the OTHER index.
- **F-2 (critical).** Hence **Theorem N is not independent of (F2):
  it IS (F2) at the boundary**, so deriving (F2) from it is
  circular; substituting the true `λ_w(φ)` collapses Theorem O's
  per-ray equation to `0 = 0`; and the interior constraint (iv)/(iv′)
  rests on the same step. **As written, the Brauer layer supplies
  no (F2).**
- **F-3.** §8.10's alignment is transposed: `L9(e_b) = 7 ≠ 0`, so
  `(2+σ̃)x = e_b` has NO solution; what holds is `λ(e_b) = 0` and
  `e_b = (2+σ⁻¹)x`. Theorem P survives with ψ and ψ* interchanged
  (`cores(a,b) = cores(ψ(a), r^x)`) — which is the form tested.
- **F-4.** Theorem O's factor `[ℓ_w(b)]^{…}` is
  uniformizer-dependent unless `⟨w,e_b⟩ ≡ 0 (mod 11)`; elsewhere
  the residue involves leading forms of `a`, which `div(a)` does
  not determine. The strict b-split criterion is EMPTY at the
  boundary, so (iv′)'s exemption as written never fires there.
- Also corrected: the gate proposed in the work order (Theorem N ⟺
  congruence (3)) is FALSE — (3) is the 9-weighted law, N the
  5-weighted one. Both were run through one code path; the
  9-weighted is clean 92/92 on 14/14 and serves as the positive
  control (the same feasibility code returns FEASIBLE 14/14 with
  9-weights, so Result 1's infeasibility is not a solver artifact).

**STATUS — the programme's fate is now genuinely undetermined.**
§8.28 stands as a fact about the VALUE-FORM system: Theorem Q is
satisfied there and Lemma S (as transcribed) is false. But whether
that defeats the programme depends on (F2), and (F2)'s derivation
is broken, not disproved. Two branches: **(F2) repairable ⟹ the 14
witnesses and their whole families die at the boundary, and
§8.28's "Theorem Q = YES" does NOT by itself defeat F55-NO**;
**(F2) unrepairable ⟹ the witnesses stand and the value-form route
is genuinely dead.** Deciding needs an independent reason for the
residue of `A_K = cores(φ,b)` to vanish at split orbits — a
derivation, not a computation (in flight:
`theory/DRAFT_f2_repair_20260808.md`). Scope of Result 1: boundary
only (Q fixes `v_w(a)` at the 460 rays; the interior of `div(a)`
is free), the mixed fan only, the 14 recorded patterns only.
Nothing here moves F55 or the headline.

### 8.30 TERMINAL: the repair provably fails, the lift is two-engine confirmed and convex — the arithmetic flank ends (Correction IX-n) (2026-08-08)

Two results close the campaign, both director-adjudicated by rerun.

**(A) The lift is confirmed by a second, independent engine — and
can be taken CONVEX.** Julia/Nemo (FLINT), rebuilding the fan from
convention-free sign-vector data alone: 1090 chambers, 2570 walls
(equal to the independently computed one-form-differs adjacency,
2570/2570), 218 free σ-orbits — no discrepancy. It derived
`σ_* = shift₋₁` itself, verified the slope-frame reduction (**)
before use (and reports it failed loudly first on an inverted
orientation — the check works), then solved the full 19780 × 5232
integer system: soluble mod every prime tested, rank dropping only
at 11 (5173 vs 5217), rational denominator exactly 11, kernel rank
15, saturation PROVED by an explicit integer left inverse.
Certificate: substitution into ALL 19780 rows, 0 violations; wall
conditions 0/2570 for both h and m; σ-invariance of m 0/1090;
pointwise `F = d + m` at 20,374 lattice points × 5 translates, 0
failures. **And the lift can be made convex:** adding
`t·Σ_k g∘σᵏ` (g = Σ_t|⟨ν_t,·⟩|, strictly convex, wall multiplier
exactly 10) at `t = 15,241,389` gives 0/2570 convexity violations
and `h(n) = max_C ⟨U_h(C), n⟩` at 2421/2421 points — **h IS the
support function of an honest lattice polytope Q** (1085 distinct
slopes). Both negative controls behave (a continuity-breaking
perturbation is insoluble mod every prime; a synthetic liftable d″
lifts and correctly fails twice-min). Engine lesson, measured: 80 s
per pattern versus an estimated 10–30 min per prime in Python —
two to three orders of magnitude, from a streaming modular echelon
with no modulus in the inner loop.

**(B) Correction IX-n — the (F2) repair FAILS, with a proof.**

**Theorem D (eigen-exhaustion; proved).** `E*/(E*)ⁿ` is semisimple
over `F_n[C₅]`. For β in the ε-eigencomponent,
`cores(φ,β) = (2+ε⁻¹)·cores(a,β) − cores(r₂,β)`. If `2+ε⁻¹` is a
unit the identity merely DEFINES `cores(a,β)` and yields no
constraint — precisely why Theorems K and (iv) fail. If
`2+ε⁻¹ ≡ 0` the a-term is annihilated, so the comparison is
genuine but says nothing about `a`. And `2+ε⁻¹ ≡ 0` holds for
EXACTLY ONE ε: mod 11 it is ε = 5, whose eigencomponent is spanned
by `c` — **not** by `e_b`, which has ε = 9 and factor 7 — and mod 3
the trivial component. Its output is exactly Theorem I(ii) in the
interior and **Theorem R = congruence (3)** at the boundary. ∎
**So the Brauer/corestriction layer's ENTIRE output is what
§§8.17–8.28 already used: `b` was the wrong element to pair
against.** Routes checked and rejected in the draft: other Kummer
elements, non-eigen/non-monomial β, "unramified ⟹ zero" (the ε = 5
class is itself boundary-ramified: `∂(cores(r₂⁻¹,r^c)) = −6·∂(B)`),
Gersten reciprocity, and the mod-3 layer. One route left open but
unpromising: a multiplicative shadow of trace-zero — symbols cannot
see it, since 11th powers preserve the symbol and destroy
trace-zero.

**Blast radius, settled.** FAIL: Theorem K, Theorem K′ as a whole,
Constraint (iv), the cover loop, Theorem N, Theorem O's conclusion,
(iv′)/(F2). CORRECTED: Theorem I(ii) per-orbit (`L9 ≡ 0`, not
`λ ≡ 0`), I(iii) (`L9(m) ≡ 7`, not `λ(m) ≡ 8`), §8.10's alignment
(ψ ↔ ψ*), Theorem P (an identity — hence (F3) is vacuous, as
measured), §8.16's σ-invariant-Q obstruction (`L9(e₂) = 4`;
conclusion unchanged). SURVIVE UNTOUCHED: Theorems H, I(i), J,
J.1, L, M, K′(a), K′(b), Q, and the entire 9-weighted line — §8.9's
`W` is literally `⟨w,c₉⟩`, so §8.9's congruence already IS
Theorem R. **New — Correction IX-o (F-5):** §8.16's "two distinct
11-covers" is FALSE; `adj(2+σ)e₂ ≡ 8·e_b (mod 11)`, so the crux
denominator and the b-cover are ONE isogeny.

**Witness re-test.** The repaired (i.e. actually derivable)
condition holds at 1288/1288 witness × boundary-orbit pairs, as
does `λ_w(φ) = 7λ_w(div a) − ⟨w,c⟩`; (F2) as printed holds at only
206/1288 — independently reproducing `f55_f2f3.py`. **The 14
witnesses SURVIVE.**

**TERMINAL STATUS OF THE ARITHMETIC FLANK.** The corrected system
collapses from (F1)–(F4) to (F1)+(F4) = Theorem Q alone; Theorem Q
is SATISFIED on the mixed fan by an explicit lattice polytope,
confirmed on two independent engines. **Lemma S is FALSE, and the
value-form / conserved-eleven route to F55-NO is genuinely dead —
not stalled, structurally exhausted.** The arithmetic flank ends at
the same shadow-feasible/lifting wall as the geometric flank
(§8.7), which is what §8.21 suspected and what the §4 failure
branch of the handoff prescribed. **F55 remains OPEN and
`ed_C(PSL₂(F₁₁))` remains UNDECIDED.** The live lanes are those of
handoff §4: the bounded exact solves at the pinned degeneration
profiles, the rigidity sub-question (§8.4 item 2), the YES-side
ladder past the d ≤ 7 gate, and construction via Theorem I's
interpolation problem. The V₁₄ theorem (Cor IX.1/IX.2) and every
fan-kill theorem of §§8.22–8.25 are untouched by all of this.
