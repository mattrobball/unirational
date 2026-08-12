# V14_POSITIVE — Φ does not settle the headline; the linear ingredient is already dead

**Packet:** `goal_runs_20260812/V14_POSITIVE/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

This is a positive-side reconstruction, not a morphism squeeze. It records
what is sealed about `Φ: V14 ⇢ X` and about `V14` itself, then answers the
only question that would turn those facts into a headline YES.

---

## Exit ledger

```text
V14-POSITIVE-PHI-SEALED-RECONSTRUCTED
V14-POSITIVE-V14-STATUS-RECONSTRUCTED
V14-POSITIVE-LINEAR-SOURCE-IMPOSSIBLE
V14-POSITIVE-COMPOSITION-DOES-NOT-SETTLE-HEADLINE
V14-POSITIVE-SPIN-OPEN-NOT-SUFFICIENT
V14-POSITIVE-D6-AMBIENT-43
V14-POSITIVE-SPIN-D2-EMPTY-D4-DIM3
V14-POSITIVE-NO-DEGREE-EXCLUSION
```

Machine markers: `V14_POSITIVE_VERIFY_OK` / `ALLGREEN`.

---

## 0. Honesty tiers

| Tier | What | Status here |
|---|---|---|
| L | Literature (Prokhorov, Mukai, Cheltsov–Shramov, Clemens–Griffiths, Kollár, Tschinkel–Zhang, Duncan–Reichstein). Cited, not recomputed. | used as labelled |
| S | Sealed in-repo packets, exit strings checked by the verifier | used as labelled |
| M | Recomputed in this packet: exact ATLAS characters; Weil traces at `p = 23, 67` | new numbers below |
| J | Logical composition (SPEC definition + S + M) | the verdict |

Nothing in M is an exclusion. Any future emptiness of a landing ideal would
be **FLAGGED** until an ODDZERO-standard audit; this packet does not run
those landings.

---

## 1. What is sealed about `V14` and about `Φ`

**Model (S: `FIX_IX_SEAL`, exit `FIX-IX-SEAL-PASS`).**
`G = PSL(2,11)`. `U` is the 6-dimensional even Weil representation of
`SL(2,11)` (`S² = −I`, closure 1320). `Λ²U = 5 ⊕ 10'`. `M` is the `10'`
summand. `A = Ann(M) ⊂ Λ⁴U` is 5-dimensional. `X = {Pf = 0} ⊂ P(A)` is the
Klein cubic (Pfaffian-partner identification). `V14 = Gr(2,U) ∩ P(M) ⊂ P⁹`
is smooth, pure dimension 3, degree 14. This is Mukai’s genus-8 prime Fano
as a linear section of `Gr(2,6) ⊂ P¹⁴`; the special member with a
`PSL(2,11)` action is Prokhorov’s Example 2.9.

**Involution geometry (S: same packet).**
`V14^σ` is a smooth genus-1 sextic plus two reduced points — no rational
curve. `V14^{D12} = ∅`. Isolated `σ`-points have stabilizer exactly `C6`.

**No map `X ⇢ V14` (S: `V14_MAP_DICHOTOMY` Theorem A, `V14MAP-KLEIN-TO-V14-EMPTY`).**
For every `α ∈ Aut(G)` there is no `α`-twisted `G`-equivariant rational map
`X ⇢ V14`, dominant or not. The line `L_σ` on `X` is an RCC `D12`-stable
`σ`-carrier; after equivariant resolution its image would be a point of the
empty `V14^{D12}`.

**A map `Φ: V14 ⇢ X` exists (S: same packet, Theorem B, `V14MAP-V14-TO-KLEIN-EXISTS`).**
There is a **nonconstant** `G`-equivariant rational map `Φ: V14 ⇢ X`. The
argument is non-constructive: generic torsor of `V14`; the associated
degree-6 Brauer class has index dividing 2; split over `L/F` of degree
`≤ 2`; classical Pfaffian–Palatini birationality `χ_Π` (Tschinkel–Zhang
arXiv:2409.08392) plus Nishimura plus cubic-secant residual; Duncan–Reichstein
twisting adjunction. **Dominance of `Φ` is not claimed.** The session sketch
“generically dominant via Palatini flop” is recorded as an unverified lead.

**Any explicit `Φ` has degree `≥ 6` (S: `V14MAP_DEGREE345_REPLAY`,
`V14MAP-DEGREE-3-4-5-REPLAYED`).**
No `G`-equivariant rational map `V14 ⇢ X` (nor into the `α`-twisted cubic)
is given by forms of degree `≤ 5`, on either 5-slot. Control multiplicities
reproduced here (M):

```text
dim Hom_G(Sym^d M*, A) = dim Hom_G(Sym^d M*, A∨)
    = 0, 0, 1, 2, 7, 18     for d = 0..5
```

**Restriction of any such `Φ` (S: `PHI_SEXTIC_ISOGENY`).**
The genus-1 sextic `C_σ ⊂ V14` is isomorphic to the Klein plane cubic
`E_σ`, with `j = 8192/11`, and the isomorphism can be chosen `S3`-equivariant.
Isolated `σ`-points of `V14` go to the two `ρ`-fixed points of `L_σ`.

**`V14` is not linearly `G`-unirational (S: `FIX_IX_SEAL` + theory
`FIX_IX_v14.md` Corollary IX.1).**
No `G`-equivariant rational map `P(V) ⇢ V14` or `V ⇢ V14` exists for any
faithful linear `G`-representation `V`. The action is not weakly versal; the
generic twist of `V14` is pointless. `G` is simple and `V14^G = ∅`, so
non-faithful linear sources die as well (they would be constant, hence a
`G`-fixed point).

The Lean tree `v14_formalization/` has a kernel-clean operational theorem
with those names, but its carrier is the coset space `G/C11`, not
`Gr(2,6) ∩ P(M)`. It is **not** cited as a geometric seal.

---

## 2. Literature on the same objects

- **S. Mukai**, *Curves and symmetric spaces*, Proc. Japan Acad. Ser. A 68
  (1992). Prime Fano threefolds of genus 8 are linear sections of
  `Gr(2,6) ⊂ P¹⁴`.
- **V. Iskovskikh–Yu. Prokhorov**, *Fano varieties*, Encyclopaedia Math.
  Sci. 47 (1999). `ρ = 1`, index 1, `H³ = 14`.
- **Yu. Prokhorov**, *Simple finite subgroups of the Cremona group of rank 3*,
  J. Algebraic Geom. 21 (2012), arXiv:0908.0678. Theorem 1.5: a rationally
  connected `PSL(2,11)`-threefold is `G`-birational to the Klein cubic or to
  this `V14` (Example 2.9). Remark 2.10: the two are birational as varieties.
- **I. Cheltsov–C. Shramov**, *Five embeddings of one simple group*, Trans.
  Amer. Math. Soc. 366 (2014), arXiv:0910.1783, Appendix A. Example A.2 is
  the same `V14`. Theorem A.5: both `V3` and `V14` are `G`-birationally
  **superrigid**. Corollary A.7: there is **no** `G`-equivariant *birational*
  map `V14 ⇢ V3`. (Compatible with Theorem B: `Φ` is not birational; an
  explicit linear system would have degree `≥ 6`.) Corollary A.8: `Bir(V3) ≅
  Bir(V14)` contains exactly two subgroups isomorphic to `PSL(2,11)`.
- **C. Clemens–P. Griffiths**, *The intermediate Jacobian of the cubic
  threefold*, Ann. of Math. 95 (1972). The Klein cubic is irrational, hence
  so is `V14`.
- **J. Kollár**, *Unirationality of cubic hypersurfaces*, J. Inst. Math.
  Jussieu 1 (2002). Smooth cubics of dimension `≥ 2` with a point are
  unirational; transport across the classical birationality gives ordinary
  unirationality of `V14`.
- **Yu. Tschinkel–Zh. Zhang**, arXiv:2409.08392. Stable `G`-equivalence
  `X × P² × P(U) ~_G V14 × P² × P(U)`; the `P(U)` factor carries the
  order-2 Schur class, so linear unirationality does not cross.
- **A. Duncan–Z. Reichstein**, arXiv:1109.6093, Theorems 1.1 and 10.5.
  `G`-unirationality = very versality = a dominant equivariant map from a
  **linear** `G`-representation.
- **I. Cheltsov–Yu. Tschinkel–Zh. Zhang**, arXiv:2502.19598. Scoped to Fano
  index `≥ 2`. `V14` has index 1; CTZ does not cover it
  (`theory/FIX_IX_v14.md` §1).

**Scoreboard for `V14` itself.**

| Question | Verdict | Tier |
|---|---|---|
| Rational as a complex variety | No (birational to the Klein cubic) | L |
| Unirational as a complex variety | Yes (same birationality + Kollár) | L |
| `G`-birational to `X` or to `P³` | No (Cheltsov–Shramov A.5 / A.7) | L |
| Linearly `G`-unirational / weakly versal | No | S |
| Spin-`G`-unirational (`P(U) ⇢ V14`) | Open | S |
| `C3`-unirational | Yes (odd-order transfer) | S |
| `D12`-lin / `D12`-spin | No / Yes | S |

---

## 3. What would settle the headline positively

`SPEC.md`: `X` is `G`-unirational iff there is a finite-dimensional **complex
linear representation** `W'` of `G = PSL(2,11)` and a dominant `G`-equivariant
rational map `W' ⇢ X` (equivalently `P(W') ⇢ X`). That is very versality.
A map out of `P(U)`, with `U` a spin representation of `SL(2,11)`, is a
different property.

So `Φ` settles the headline only if it can be composed with a dominant
`G`-equivariant map of the **right type**

```text
P(W') ⇢ V14 ⇢ X,
```

where `W'` is a linear `G`-representation and both arrows are dominant
and `G`-equivariant.

- The second arrow exists and is nonconstant (S). Dominance is open (S).
- The first arrow, for linear `W'`, **does not exist** (S: IX.1). This is
  not an open computational question.
- A classical (non-equivariant) parameterization of `V14` exists, because
  `V14` is unirational as a variety. Composing it with `Φ` loses
  `G`-equivariance and reproduces ordinary unirationality of `X`, which
  was never the problem.
- A spin parameterization `P(U) ⇢ V14`, if dominant, would with a
  dominant `Φ` prove that `X` is spin-unirational. By `FIX_IX_v14.md`
  Corollary IX.4 that is equivalent to spin-unirationality of `V14`, and
  by Corollary IX.5 it is **necessary** for headline YES, not sufficient.
  `SPEC.md` still requires a linear `G`-source.

**Verdict (J).** The existence of `Φ` plus every parameterization of `V14`
that is actually known — classical unirationality, the Palatini
birationality with `X`, the Gross–Popescu modular model — does **not**
produce a `G`-equivariant dominant map from a projective space of a linear
`G`-representation to `X`. The missing ingredient is known to be
impossible, not open. This route cannot settle Problem E positively.

---

## 4. What is still open, and the smallest computation that would decide each piece

The headline remains open for other reasons (`ed ∈ {3,4}`). On this flank
the open pieces are narrower.

### 4.1 Explicit / dominant `Φ` (does not settle the headline)

Ambient dimensions, exact (M; `d ≤ 5` matches the sealed table):

```text
d                     0  1  2  3  4   5   6    7     8
dim Sym^d M           1 10 55 220 715 2002 5005 11440 24310
dim C_d(A)            0  0  1   2   7   18   43    94    198
h^0(V14, O(d))        1 10 40 105 219  396  650   995   1445
```

**Smallest deciding computation for an explicit `Φ`:** the degree-6 landing
already specified by `V14MAP_DEGREE345_REPLAY`. Build a basis of the
43-dimensional space `C_6(A)` by Reynolds averaging of `<T>`-invariant
seeds (60 cosets). Pin `{F : F|_{V14} = 0}` from both sides, as in that
packet (evaluation rank versus explicit Plücker-seed covariants). The
surviving `n'` coordinates have cubic landing conditions `Pf(F_c(y)) = 0`.
A nonzero common zero is an explicit `Φ` of degree 6; emptiness over the
algebraic closure, at three primes with the char-0 transfer of that
packet, would push the constructive bound to `d ≥ 7` and must be
**FLAGGED**, not claimed, until an ODDZERO-standard audit. Dominance is
then the generic rank of `dΦ` on `V14`, or a comparison of
`Φ^*O_X(1) ~ dH`.

This packet does not run that landing.

### 4.2 Spin parameterization `P(U) ⇢ V14` (open, not sufficient)

A `G`-map `P(U) ⇢ P(M)` of degree `d` lives in `Hom_{SL}(Sym^d U*, M)`,
and the centre forces `d` even. Two-prime traces (M; `p = 23, 67`,
identical):

```text
d                              0  1  2  3  4  5  6
dim Hom_SL(Sym^d U*, M)        0  0  0  0  3  0  6
```

There is **no** quadratic spin map `P(U) ⇢ P(M)` at all. The first
possible spin map is degree 4, a 3-dimensional space.

**Smallest deciding computation for spin:** land that 3-space on `V14`.
Each covariant is a 10-tuple of degree-4 forms on `U = C^6`. The 15
restricted Plücker quadrics pull back to degree-8 forms on `U`; vanishing
identically is a linear condition on the 3 coefficients, or, if the
family is used projectively, a cubic landing in `P²` of coefficients.
Add the sealed 66 forced base lines of `SCHUR_V14` (Theorem 1) as linear
vanishing conditions on `U_0`. A surviving nonzero map is a spin
parameterization of a subvariety of `V14`; dominance is then a rank
check. Emptiness is again **FLAGGED**, not a claim.

Even a dominant answer here, composed with `Φ`, is spin-unirationality of
`X`, not the headline.

### 4.3 Linear source `P(W) ⇢ V14` (predicted empty; a hit would break IX.1)

For comparison, the 5-summand of `Λ²U` (one linear 5-space) has

```text
d                              0  1  2  3  4  5  6
dim Hom_G(Sym^d five*, M)      0  0  1  1  2  3  5
```

Covariants exist from degree 2. IX.1 says none of them land on `V14`.
This is the stage-4 ladder of the still-unsealed `FIX_IX_V14MODEL`
packet, useful only as a blind check of IX.1.

---

## 5. Replay

```
python3 verifier.py
```

Re-runs `scripts/produce.py` (exact characters; Weil traces at 23 and 67;
marker ledger on the cited packets) and checks the control table, the new
dimensions, agreement of the two primes, the required headline sentence,
and the absence of `REPORT.md`. Writes `results/verifier_output.json`.

---

## 6. Not claimed

- Any headline value, any `ed` value, any degree exclusion.
- Dominance of `Φ`; any explicit `Φ`; emptiness of the degree-6 landing.
- Emptiness or non-emptiness of the degree-4 spin landing.
- Faithfulness of the Lean `v14_formalization` headline.
- Anything about `F55` / `C5` / `C11` unirationality.
- That a spin map `P(U) ⇢ X` would prove Problem E.

This packet excludes no degree.
