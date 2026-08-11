# Exclusion transport along the invariant ladder

Opened 2026-08-11 (director). Trust class: the lemmas are elementary and
proved inline (Tier-1 hand-work); the one machine input (the invariant-degree
table) is a director probe named in §7. This mechanism is in neither the
sealed record nor `theory/CONSTRAINT_ADDITIONS_20260811.md`; it changes the
*shape* of the negative campaign's target, so it is recorded before the
queued Stage-1 repair whose priorities it re-orders.

**Headline: Problem E remains OPEN. This note excludes no degree.** It shows
how exclusions, once established in the right form, spread to other degrees.

Throughout: `G = PSL(2,11)`, `W` the Weil 5-dim representation,
`M_d = (Sym^d W* ⊗ W)^G`, `F ∈ Sym³W*` the Klein cubic, `X = {F = 0}`. A
**landing tuple** is `0 ≠ T ∈ M_d` with `F(T) ≡ 0`; it is **dominant** if the
induced rational map `P(W) ⇢ X` is dominant.

## 1. Two levels, and the content decomposition

A statement about degree `d` can live at two levels:

- **tuple level** — it applies to every landing tuple in `M_d`, including
  tuples whose five coordinates share a common factor;
- **map level** — it applies to the rational map, equivalently to the unique
  minimal presentation (coordinates with no common factor).

**Lemma 0 (content).** Every dominant landing tuple factors as `T = c · T°`,
where `c ∈ (Sym^e W*)^G` is an invariant (the gcd of the coordinates) and
`T° ∈ M_{d−e}` is a dominant landing tuple with coprime coordinates
presenting the same map.

*Proof.* The divisorial part of the base scheme of `(T_0,…,T_4)` is
`G`-stable, so its equation `c` is a semi-invariant; `G` is perfect, so `c`
is invariant. Then `T° = T/c` transforms as `T` does, `F(T) = c³F(T°)` forces
`F(T°) ≡ 0`, and away from `{c = 0}` both tuples give the same projective
map. ∎

Write `D = {d : a dominant landing tuple exists in M_d}`,
`D_min = {d : a dominant landing map has minimal presentation degree d}`,
`E = {e ≥ 0 : (Sym^e W*)^G ≠ 0}`. `E` is a monoid under addition and
`3 ∈ E` (the cubic `F` itself). Lemma 0 says `D = E + D_min`, and Problem E's
negative side is exactly `D = ∅` (equivalently `D_min = ∅`).

## 2. The transport lemmas

**Lemma 1 (invariant multiplication).** If `T ∈ M_d` is a dominant landing
tuple and `J` a nonzero invariant of degree `e`, then `J·T ∈ M_{d+e}` is a
dominant landing tuple — the same rational map. In particular `D + 3 ⊆ D`,
and more generally `D + E ⊆ D`.

*Proof.* `F(J·T) = J³·F(T) ≡ 0`; on the dense open `{J ≠ 0} ∖ Bs(T)` the
projective maps agree. ∎

Note the direction: Lemma 1 moves *presentations*, it cannot create a map.
(`F·id` is not a landing tuple — `F(F·x) = F⁴ ≢ 0` — so nothing enters the
ladder from below.)

**Lemma 2 (precomposition).** If `S ∈ (Sym^s W* ⊗ W)^G` defines a dominant
self-map of `P(W)`, then `T∘S ∈ M_{sd}` is a dominant landing tuple, so
`s·D ⊆ D`. Such `S` exist at `s = 4`: `S₀ = ∇F̌ ∘ ∇F`, the polar map of `X`
followed by the polar map of the conjugate cubic `X̌ ⊂ P(W*)`
(`W* ≅ W̄`; `X̌` is the Klein cubic in the conjugate labeling, smooth). Each
polar is a finite morphism — `∇F(x) = 0` forces `x ∈ Sing X = ∅` by Euler,
and a positive-dimensional polar fiber would give a hyperplane section of `X`
singular along a curve — so `S₀` is finite surjective. (`T∘(F·id) = F^d·T`
recovers iterated Lemma 1; whether `S₀` is a multiple of `F·id` inside the
2-dimensional space of quartic self-covariants is a machine curiosity with no
bearing here.)

## 3. The pairing corollary

**Proposition 3.1.** `d ∈ D` implies `d + 3ℕ ⊆ D`. Consequently, for each
residue `ρ` mod 3, `D ∩ (ρ mod 3)` is either empty or contains every
sufficiently large degree in **both** mod-6 halves `ρ`, `ρ+3` of that class.

**Corollary 3.2 (pairing).** The mod-6 classes pair as `{0,3}`, `{1,4}`,
`{2,5}`. If for a single residue `ρ̄` mod 6 no dominant landing tuple exists
at any sufficiently large `d ≡ ρ̄ (mod 6)`, then no dominant landing tuple
exists at ANY `d ≡ ρ̄ (mod 3)` — the whole pair, at every degree.

**Corollary 3.3 (closure criterion).** Problem E closes negatively as soon
as, for each of the three pairs, ONE half is tuple-excluded at all large
degrees. "All sufficiently large even degrees" is such a target — and even
`d` is the side where all 55 minus-lines already lie in `Bs(T)`.

**Corollary 3.4 (single-class criterion — unconditional).** The invariant
ring has a quintic invariant: the probe of §7 gives
`E ∩ [1,40] = {3} ∪ [5,40]`, so `E` contains members of every residue class
mod 6 at arbitrarily large degrees. Hence for any `d`, the set `d + E` meets
any prescribed class `ρ̄` mod 6 at large height, and Lemma 1 forces a tuple
there. **A tuple-level exclusion of a SINGLE residue class mod 6, at all
sufficiently large degrees, closes every degree.** Corollary 3.3's
one-half-per-pair criterion remains as the fallback formulation when an
exclusion is only available in restricted form.

## 4. What this makes of the residue-table program

`STAGE1_TIGHTEN` Theorem S makes the σ-band verdicts degree-saturated: a
residue-class verdict holds for **all** `d` in the class, not just large `d`.
Combined with Corollary 3.4, a corrected tuple-level `K(ρ̄) = 0` at ANY one
residue would close every degree — the σ-band factor is the tuple-level
piece of the table (§6), so this is exactly the stakes of the queued repair.
(Under the weaker pairing form 3.2: zeros meeting all three pairs — for
instance the flagged-and-refuted pattern `K(1)=K(3)=K(5)=0` itself, since
`{1,3,5}` meets `{1,4}`, `{0,3}`, `{2,5}` — already close Problem E.)

Two readings of the ODDZERO episode follow, one backward, one forward:

- Backward: had the odd zero been real (tuple level), the correct
  announcement would have been "Problem E closed", not "the window moves to
  `d = 36`". Nothing in the sealed record performed this step; transport was
  absent from the program's reasoning. (The verdict ARTIFACT stands on its
  own evidence; this note changes only what the claim would have meant.)
- Forward: the queued stratified-degeneracy repair is no longer bookkeeping
  ahead of the `d = 35` window — any zero that survives it closes a pair of
  residue classes at all degrees. It must therefore be held to the
  adversarial standard of `ODDZERO_AUDIT` (independent rebuild, witnesses,
  both primes), and any zero it produces is FLAGGED, not claimed, until so
  audited. The workorder
  (`WORKORDER_STAGE1_STRATIFIED_DEGENERACY.md`) carries both requirements.

## 5. The gate

Operational rules, effective immediately:

1. **Pair-crossing consistency.** A claimed tuple-level exclusion of class
   `ρ̄` (mod 6, at all large degrees) asserts emptiness of the whole pair
   `{ρ̄, ρ̄+3}`. Any witness or existence claim anywhere in the pair
   contradicts it. Every future residue-table packet must state this check.
   (Counts of coherent *profiles* do not transport — profiles are a
   relaxation and can stay nonzero in a class with no tuples. Only zeros
   carry information across the pair.)
2. **The `Φ_F`-shift test.** Multiplication by `F` acts on leading data:
   along each of the 15 sweep rows it shifts the class `(a, ψ)` by `F`'s row
   data and shifts the vanishing level at each child by `ord_q(F)`. The
   corrected enumeration must satisfy the inclusion
   `Φ_F(coherent patterns at ρ) ⊆ coherent patterns at ρ+3` for every
   residue. Under the old module-level degeneracy semantics this test is not
   even expressible — there is no slot for level shifts — which is one more
   reason the repair must carry it. Deriving `F`'s row data
   (`ord_{L_σ}F = 1`, the behavior at the type-I vertices, etc.) is a
   deliverable of the workorder, §F.
3. **The general principle.** A constraint layer participates in transport
   iff it is tuple-level, or is explicitly closed under the shift action
   `Φ_J` of the invariants (`J` running over generators of the invariant
   ring: the content of an imprimitive tuple shifts every local weight and
   level by `J`'s leading data). A layer stated only for reduced lifts is
   map-level: sound, but its `d` is `d_min` and its verdicts do not spread.

## 6. Level audit of the sealed layers

What each layer's exclusions mean under transport. "Tuple" = applies to
every landing tuple at its degree (transports); "map" = applies to the
minimal presentation (its `d` is `d_min`; does not transport by itself).

| layer | level | evidence / caveat |
|---|---|---|
| central-character / spin ledger | tuple | representation content of `M_d` itself |
| H0-1 parity; `STAGE2` Prop 1.4(ii) | tuple | module vanishing (`dim V((d−m,m),1) = 0`, `m` even); `F`-consistency checked: `ord_{L_σ}(F) = 1` flips the parity exactly in step with `d ↦ d+3` |
| Prop 0.1 (full-flag `ψ = 1`, `Σa_r = d`) | tuple | `G`-invariance argument; no primitivity used |
| Stage-1 census / coherence / residue table | tuple-complete | the model constrains the leading data of an arbitrary nonzero tuple; every realized `(a,ψ)` is enumerated. OBLIGATION: the stratified repair must preserve this (imprimitive tuples remain inside the relaxation) — written into the workorder |
| Stage-2 odd-order pinning (`3⁸`); D10 split (Prop 2.1) | map | AUDITED: the packet's §0 set-up normalizes to "a reduced homogeneous lift (no common factor)", and the master weight formula's `d` is that lift's degree. Apply at `d_min`. Upgrade route: close under `Φ_J` (the invariant content shifts each center weight by `J`'s leading jet weight). NOTE the split inside `STAGE1_TIGHTEN`: its §2.2 σ-band factor `K` is pure Stage-1, hence tuple-level — the odd-zero lived there, so §4's backward reading stands — while its §2.3–2.4 assembled tables consume Stage-2 factors and are map-level as a whole |
| `μ` lower bounds (A4, C6) | map | multiplicities on the resolved map; apply at `d_min` |
| window closures `d ≤ 34` | mostly tuple | transport-irrelevant downward (nothing open below); `D34` spot-audited: its two closing conditions are module/congruence statements (tuple) |
| `C1`/`C2` graph ledgers (constraint additions) | map | their `d` is `d_min`; flag when citing |
| `C4`/`C6`/`C13` linear compiler constraints | tuple | linear conditions on `M_d` |
| `C12` postcomposition caveat | — | complementary: `C12` quotients classifications by postcomposition on the target side; this note transports exclusions by multiplication/precomposition on the source side |

## 7. Machine input: the invariant-degree table

Probe: `director_probes_20260811/molien_director.py` /
`molien_director.out` (exact arithmetic in `Q(√−11)` by the power-sum
recurrence; no dependencies). **All anchors pass**: `I(3) = 1`
(`F` unique), `A(4) = 2`, `A(5) = 1`, `A(25) = 189`, `A(34) = 576` (the
sealed `dim M_d` anchors), `J(2) = J(4) = 1` (the polar covariants).

Results (`I(d)` = invariant multiplicity in `Sym^d W`):

- `E ∩ [1,40] = {3} ∪ [5,40]` — a quintic invariant exists, and every
  degree `≥ 5` carries invariants; smallest element coprime to 3 is **5**.
- Corollary 3.4 is therefore unconditional (single-class criterion).
- Incidental anchors: `A(35) = 637 = dim M_35` before the sealed cuts;
  `A(34) = 576` matches the `D34_GUIDED_SWEEP` cascade start.

A second, independently-written probe (subagent, same anchors) is expected
to land as `molien_probe.py` in the same directory; on arrival it
cross-checks this one.

## 8. Obligations

1. ~~Stage-2 pinning level audit~~ DONE (map-level; §6 row updated with the
   packet's own normalization sentence as evidence).
2. `Φ_F` row-data derivation and the inclusion test — workorder §F.
3. ~~Fill §7 from the probe~~ DONE (quintic invariant exists; Corollary 3.4
   stated unconditionally; anchors all pass).
4. Optional upgrade: restate the Stage-2 weight congruences tuple-level by
   closing them under the `Φ_J` shifts (§5.3) — this would make the full
   mod-330 assembled table transportable, not only the σ-band factor.

## 9. Not claimed

- No headline. Problem E remains OPEN. No degree is excluded by this note.
- The lemmas are unconditional; what they transport is only what is
  established at tuple level, per the audit table of §6.
- No claim that any dominant landing tuple exists at any degree.
