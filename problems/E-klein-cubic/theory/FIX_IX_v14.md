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
