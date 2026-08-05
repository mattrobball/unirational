# FIX-T34 — central-obstruction hypotheses for the OD16/dP2 and C9⋊C3/Fermat actions

**Packet:** `goal_runs_after_691986b/FIX_T34_CENTRAL_OBSTRUCTION/`
**Program:** FIX ([E56]), acceptance gate items **T3** and **T4**
(`theory/FIX_T_gate.md`, Corollary T3.1).
**Date:** 2026-08-04. **Toolchain:** python3 (exact cyclotomic and finite-field
arithmetic, no external CAS dependency), sympy (ambient-group covariant check),
Macaulay2 (one confirmatory Gröbner degree computation).

## PRIMARY EXIT: `FIX-T34-CENTRAL-HYPOTHESES-PASS`

Both instantiations are verified — with corrections to the pinned candidate
descriptions (see FINDINGS). All numbers below are produced by an exact
producer and re-derived by a method-disjoint verifier.

**Cor T3.1 hypotheses (a), (b) are verified for:**

* **T3.** `S : w² = x₁⁴+x₂⁴+x₃⁴ ⊂ P(1,1,1,2)`, for **13 of the 17 conjugacy
  classes** of order-16 subgroups `G ⊂ Aut(S)` (52 of the 67 order-16
  subgroups), each with an explicit central `z ≠ 1`. Star witness (class
  `T3-C05`, type `D₈ × C₂`, class size 3):
  `G = ⟨ deck, diag(1,1,−1), diag(1,−1,i), (x₁ x₂) ⟩`,
  `z = diag(1,1,−1)` (with `ν = +1`) `∈ Z(G)`,
  `S^z = {w² = x₁⁴+x₂⁴} ⊔ {[0:0:1:±1]}` = **smooth genus-1 curve ⊔ 2 points**,
  and `S^G = ∅`.
* **T4.** `X : x₁³+⋯+x₅³ = 0 ⊂ P⁴`, for **2 of the 3 conjugacy classes** of
  `C₉⋊C₃` subgroups of `Aut(X)` (160 of the 180 such subgroups). Star witness
  (class `T4-C01`): `G = ⟨a,b⟩` with
  `a : e₁↦e₂, e₂↦e₃, e₃↦ζ₃e₁, e₄↦e₄, e₅↦ζ₃e₅` (order 9),
  `b = diag(1, ζ₃, ζ₃², 1, 1)` (order 3), `b a b⁻¹ = a⁴`,
  `z = a³ = diag(ζ₃,ζ₃,ζ₃,1,1) ∈ Z(G)` (order 3, `Z(G) = ⟨a³⟩`),
  `X^z = {x₁³+x₂³+x₃³ = 0} ⊂ P²₍₁₂₃₎ ⊔ {x₄³+x₅³=0} ⊂ P¹₍₄₅₎`
  = **smooth genus-1 plane cubic ⊔ 3 points**, and `X^G = ∅`
  (`Fix(G,P⁴) = {[0:0:0:1:0], [0:0:0:0:1]}`, both off `X`).

**Consequence (per Cor T3.1, which is proved in `theory/FIX_T_gate.md` from
Note [I]; this packet supplies only the finite verification of its
hypotheses):** for each listed `(G, z)` there is no `G`-equivariant dominant
rational map `P(V) ⇢ Y` from any faithful linear `G`-representation — the
action is not `G`-unirational from linear sources, hence not weakly versal.
This retires the standing verification-debt item *"OD16/Fermat session
theorems never machine-checked"*: the fixed-scheme and group-theoretic facts
the sessions asserted are now exact-computed and independently replayed.

**Problem E headline: OPEN.** These are companion examples (Problem-F-adjacent
del Pezzo and a Fermat cubic threefold), *not* Klein-cubic results, and nothing
here bears on `ed_C(PSL(2,11))`.

---

## Case T3 — order-16 subgroups of Aut(S), S the Fermat-quartic dP2

### Ambient group (verified, not cited)

`verify_ambient_groups.py` proves `|Aut(S)| = 192` from the Hessian covariant
`Hess(C∘A) = det(A)²·(Hess C)∘A`: for `C = x₁⁴+x₂⁴+x₃⁴` sympy gives
`Hess(C) = 1728·x₁²x₂²x₃²`, so any `A` with `C∘A = C` permutes the three
coordinate lines, i.e. is monomial with `μ₄` entries; enumeration gives
`|Lin(C)| = 4³·6 = 384`, hence `|Aut(P²,B)| = 384/4 = 96` and
`|Aut(S)| = 2·96 = 192` (the anticanonical morphism of a degree-2 del Pezzo is
the double cover, so `Aut(S) → Aut(P²,B)` is onto with kernel the deck
involution). Confirmed independently by Macaulay2
(`aut_fermat_quartic.m2`: the saturated scheme `{A : C(Ax)=C(x)}` is
0-dimensional of degree **384**).

`Z(Aut(S)) = {1, deck}` (computed). Note `deck = [(I,−1)] = [(iI,+1)]`: `ν` is
**not** a class invariant, so `Aut(S)` is presented as
`{(A,ν) : A monomial/μ₄, ν ∈ μ₂}/⟨(iI,−1)⟩`.

### Fixed-locus dictionary (exact, over `Q(ζ₂₄)`)

For `g = (A,ν)` and `x ≠ 0` on `S`, `g` fixes `[x:w]` iff `Ax = λx` and
`νw = λ²w`. Hence `S^g = ⋃_λ` of: the **full preimage** `π⁻¹(P(E_λ))` when
`ν = λ²`, and `{[x:0] : x ∈ P(E_λ) ∩ B}` otherwise. (`F(Ax) = F(x)` forces
`(λ⁴−1)F(x) = 0`, so eigenvalues outside `μ₄` only carry branch points.)

Exact outcome over all 191 non-identity automorphisms:

| positive-dimensional component | occurs for | genus |
|---|---|---|
| the branch quartic `B = {w=0}` | the deck involution only (1 element) | **3** |
| `π⁻¹(L)`, `L = P(E_λ)` a line, `dim E_λ = 2`, `ν = λ²` | 21 elements | **1** |

(the remaining 170 non-identity automorphisms have finite fixed locus)

**No automorphism of `S` has a rational curve in its fixed locus** (every
restricted binary quartic `F|_L` was certified to have 4 distinct roots — by
`gcd(q,∂q)` over `Q(ζ₂₄)` in the producer and by the `SL₂`-invariant
discriminant `4I³−J² ≠ 0` mod 73 and 97 in the verifier). Therefore
**hypothesis (a) holds for every `z ≠ 1` in every order-16 subgroup**; the
whole discriminating content of T3 is hypothesis (b).

### Classification

67 subgroups of order 16, in **17 conjugacy classes**. Types occurring:
`C4×C2×C2`, `C4×C4`, `C8×C2`, `D8∘C4` (central product), `D8×C2`, `Q8×C2`,
`M16` (modular group of order 16). Identification is rigorous: all 14 groups of
order 16 are constructed explicitly, checked pairwise non-isomorphic, and
matched by a generator-mapping isomorphism test.

**(a)+(b) hold — Cor T3.1 applies (13 classes, 52 subgroups):**

| class | type | class size | contains deck | ord Z(G) | a central `z` with `S^z` = genus-1 curve ⊔ 2 pts |
|---|---|---|---|---|---|
| T3-C01 | C4×C2×C2 | 3 | yes | 16 | yes |
| T3-C02 | C4×C2×C2 | 6 | yes | 16 | yes |
| T3-C04 | D8×C2 | 6 | yes | 4 | yes |
| T3-C05 | D8×C2 | 3 | yes | 4 | yes  ← star witness |
| T3-C06 | Q8×C2 | 3 | yes | 4 | yes |
| T3-C08 | D8∘C4 | 6 | no | 4 | yes |
| T3-C09 | D8∘C4 | 3 | no | 4 | yes |
| T3-C10 | D8∘C4 | 3 | no | 4 | yes |
| T3-C11 | C4×C4 | 1 | no | 16 | yes |
| T3-C13 | D8∘C4 | 3 | no | 4 | yes |
| T3-C15 | M16 | 3 | no | 4 | yes |
| T3-C16 | D8∘C4 | 6 | no | 4 | yes |
| T3-C17 | M16 | 6 | no | 4 | yes |

**(b) fails (4 classes, 15 subgroups):** `T3-C03` (C8×C2, size 6; two `G`-fixed
points on the branch quartic), `T3-C07` (C4×C4, 3), `T3-C12` (D8∘C4, 3),
`T3-C14` (M16, 3) — each has a `G`-fixed point of `P²` off `B` whose two
preimages are individually fixed. Cor T3.1 does **not** apply to these; the
corresponding actions are not obstructed by this argument.

`S^G = ∅` criterion used (exact): `S^G ≠ ∅` iff some joint eigenspace `W` of
`G` in `C³` either meets `B` or satisfies `ν_g = λ_g²` for all `g ∈ G`. If
`deck ∈ G` the second alternative is automatically excluded.

---

## Case T4 — C9⋊C3 on the Fermat cubic threefold

### Ambient group (verified, not cited)

Same Hessian argument: `Hess(x₁³+⋯+x₅³) = 7776·x₁x₂x₃x₄x₅`, so `Lin(C)` is
monomial with `μ₃` entries, `|Lin(C)| = 3⁵·120 = 29160`, and (using
Matsumura–Monsky: automorphisms of a smooth hypersurface of dimension ≥ 2 and
degree ≥ 3 are linear) `|Aut(X)| = 29160/3 = **9720**`.

### Classification

`Aut(X)` has **1080 elements of order 9** in 4 conjugacy classes, and exactly
**180 subgroups isomorphic to `C₉⋊C₃`** (order 27, exponent 9, `|Z| = 3` — the
modular group `M₂₇`, *not* Heisenberg), falling into **3 conjugacy classes** of
sizes 40, 120, 20.

For **every** such subgroup: the order-9 elements have a 3-cycle permutation
part, `z = a³` is diagonal of type `(c,c,c,1,1)` up to coordinate permutation,
`Z(G) = ⟨a³⟩`, and

`Fix(z,P⁴) = P² ⊔ P¹`, `X^z =` (smooth Fermat plane cubic, **genus 1**) `⊔`
(3 distinct points of `{x_l³+x_m³=0}` on the line) — so **hypothesis (a) holds
for all three classes**.

| class | class size | (a) | `Fix(G,P⁴)` | `X^G` | (b) | Cor T3.1 |
|---|---|---|---|---|---|---|
| T4-C01 | 40 | yes | 2 points | ∅ | yes | **applies** |
| T4-C02 | 120 | yes | 2 points | ∅ | yes | **applies** |
| T4-C03 | 20 | yes | a line `P¹` | 3 points | **no** | does not apply |

---

## FINDINGS (divergences from the pinned descriptions)

1. **T4, pinned candidate is wrong as written.** The work order's candidate
   `a = diag(ζ,1,1,1,1)∘(x₁x₂x₃)`, `b = diag(1,ζ,ζ²,1,1)` *does* generate
   `C₉⋊C₃` with `z = a³` central of order 3 — but it lands in class **T4-C03**,
   where `G` fixes the line `⟨e₄,e₅⟩ ⊂ P⁴` **pointwise**, so
   `X^G = {[1:−1:0:0:0], [1:−ζ₃:0:0:0], [1:−ζ₃²:0:0:0]}` (recorded in the
   payload) and **hypothesis (b) fails**. The repair is to separate the two
   spectator coordinates, e.g. `a = diag(ζ,1,1,1,ζ)∘(x₁x₂x₃)`: this lands in
   T4-C01 and satisfies (a)+(b). The T4 theorem is therefore true, but *not*
   for the displayed action in the work order's pinned form.
2. **T4, the eigenstructure of `z` was mis-stated.** `Fix(z,P⁴)` is
   `P² ⊔ P¹`, never `P² ⊔ pt ⊔ pt`; correspondingly `X^z` is the genus-1 plane
   cubic **plus 3 points on the fixed line**, not "two isolated eigenpoints off
   `X`". The sessions' summary phrase "genus-one curve plus finitely many
   reduced points" is correct; the work order's refinement of it is not.
3. **T3, the deck involution gives genus 3, not genus 1.** `S^deck = B`, the
   branch quartic, genus 3 — which satisfies (a) but is not the sessions'
   "genus-one curve plus finitely many points". That description is realised by
   a *different* central element: in every one of the 17 classes there is a
   central `z` with `S^z =` genus-1 curve ⊔ (2 or 0) points. So the sessions'
   Type-II fixed-scheme description is **true and realisable**, but it does not
   by itself single out a class: it holds for all 17, while (b) selects 13.
4. **T3, hypothesis (a) is not restrictive at all here.** No automorphism of
   this `S` has any rational curve in its fixed locus (all fixed curves are the
   genus-3 branch quartic or smooth genus-1 double covers of eigen-lines). The
   real content of the OD16 example is `S^G = ∅`.
5. **Neither example is generic in its group.** 4 of 17 order-16 classes and
   1 of 3 `C₉⋊C₃` classes fail (b). "OD16" and "`C₉⋊C₃`" name abstract groups;
   the obstruction is a property of the *conjugacy class of the action*. Any
   downstream citation must name the class, not just the group.
6. **`ν` is not a class invariant of `Aut(S)`** (`(A,ν) ~ (iA,−ν)`), so the
   `μ₂ × (μ₄²⋊S₃)` product decomposition cannot be read off representatives;
   the deck involution is also the class of the scalar `iI`. Verified: a
   complement of order 96 does exist (2 of the 3 index-2 subgroups miss the
   deck), so `Aut(S) ≅ C₂ × (μ₄²⋊S₃)` as stated in the gate document.

---

## Verification protocol

Producer and verifier share **no code**; the verifier reads only the producer's
JSON.

| item | producer | verifier |
|---|---|---|
| arithmetic | exact `Q(ζ₂₄)` / `Q(ζ₉)` (hand-rolled, `Fraction`) | `F₇₃`, `F₉₇` (T3), `F₁₉` (T4), all `≡ 1 mod 24` resp. `mod 9` |
| eigenspaces | monomial-cycle theory, exact eigenvectors | exhaustive scan of `P²(F_p)` / `P⁴(F_p)`, components recovered by grouping fixed points by eigenvalue |
| subgroups | bottom-up (cyclic extension / normalisers of `⟨a⟩`) | top-down (Sylow subgroup + Frattini index-2/index-3 chains, then conjugate sweep) |
| genus | `gcd(q,∂q)` over `Q(ζ₂₄)` (T3); coordinate Fermat form (T4) | `SL₂`-invariant discriminant `4I³−J²` (T3); binary-cubic discriminant + smoothness scan + plane-curve genus formula (T4) |
| group encoding | `(perm, μ₄-exponents, ν)` triples | monomial matrices over `F_p` mod `(M,ν) ~ (λM, λ²ν)`, faithfulness re-checked on the point set |

Rigour of the finite-field reduction: for `p ≡ 1 (mod 24)` (resp. `mod 9`),
`μ₂₄` (resp. `μ₉`) injects into `F_p^*`, all eigenvalues and eigenspaces are
`F_p`-rational, `S` and `X` are smooth mod `p`, and a nonvanishing discriminant
mod `p` certifies nonvanishing in characteristic 0. A `G`-fixed locus in `P²`
or `P⁴` is a union of `F_p`-rational linear subspaces, so the scan sees all of
it (a positive-dimensional one is detected by the point count).

### Replay

```
python3 produce_T3.py            # writes T3_payload.json
python3 verify_T3.py             # -> VERIFY_T3: PASS      (~11 s)
python3 produce_T4.py            # writes T4_payload.json
python3 verify_T4.py             # -> VERIFY_T4: PASS      (~5 s)
python3 verify_ambient_groups.py # -> VERIFY_AMBIENT: PASS (~2 s)
python3 spotcheck_star_witnesses.py  # -> SPOTCHECK: PASS  (~10 s)
M2 --script aut_fermat_quartic.m2 # dim 0, degree 384      (optional)
```

`spotcheck_star_witnesses.py` is a third, self-contained sympy recomputation of
exactly the two star witnesses quoted above (group orders 16 and 27, centrality
of `z`, `b a b⁻¹ = a⁴`, the two fixed-locus decompositions, and both
emptiness statements).

Verifier output (T3): `192` / `67` subgroups / `17` classes / class-data
multiset match / `13` classes with `S^G = ∅` / (a) holds for every element /
fingerprint↔iso-type bijective. Verifier output (T4): `9720` / `180`
subgroups / `3` classes / class-data multiset match / `2` classes with
(a)+(b) / every central `z` gives one genus-1 curve + 3 points.

## Scope and dependencies

* Corollary T3.1 itself is **not** re-derived here; it is taken as proved in
  `theory/FIX_T_gate.md` (from Note [I]). This packet is exactly the finite
  verification of its hypotheses (a), (b) that the gate document dispatched.
* Cited (not machine-checked) inputs: Matsumura–Monsky linearity of
  automorphisms of smooth hypersurfaces (T4), and the fact that the
  anticanonical morphism of a degree-2 del Pezzo is the double cover of `P²`
  branched over a smooth quartic, so `Aut(S) → Aut(P²,B)` is surjective with
  kernel of order 2 (T3). Everything else — including both ambient group
  orders — is computed.
* No claim is made about Problem E. **Problem E headline: OPEN.**

## Files

* `produce_T3.py`, `verify_T3.py`, `T3_payload.json`
* `produce_T4.py`, `verify_T4.py`, `T4_payload.json`
* `verify_ambient_groups.py`, `spotcheck_star_witnesses.py`
* `aut_fermat_quartic.m2`, `aut_fermat_quartic.log`
* `run_T3.log`, `run_T4.log` (producer console output)
