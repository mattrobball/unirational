# The tropical/Newton flank is insufficient — statement, proof layer, replay

**Date:** 2026-08-11
**Status:** `F55-TROPICAL-INSUFFICIENCY-PROVED` — **already sealed in-repo**
(`theory/FIX_IX_v14.md` §8.28 *Correction IX-k*, §8.30 *Correction IX-n*).
This note **ports** that result into the current trace-model language of
`F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`, supplies the two blocking
lemmas and the convention reconciliation, and records an independent third
engine replay. It does **not** claim new strength.

---

## 0. Why this note exists

The result was proved in the language of the now-withdrawn Lemma-S /
value-form campaign ("Theorem Q", "twice-min", fans, cells, walls). The
authoritative F55 object is now the trace cubic and Proposition 3.3. Nothing
in the repository connected the two statements, and the min/max conventions of
the two formulations differ. Round 6 restates the result in a third language
and adds a universal quantifier that does not hold. This note fixes all three
problems.

## 1. The condition, in the current language

Let

```text
M = Z^5 / Z(1,1,1,1,1),   N = Hom(M,Z) = { w in Z^5 : sum w_i = 0 },
sigma(e_i) = e_{i+1},     Phi(a) = sum_{i in Z/5} sigma^i( chi^{-e_2} a^2 sigma(a) ).
```

For `0 != a` in `C[M]` with Newton polytope `P = Newt(a)`, write

```text
nu(w) = min_{s in P} <w,s>       (the order function of a at the weight w),
h(w) = max_{s in P} <w,s>        (the support function of P);   nu(w) = -h(-w).
```

**Condition (T).** For every `w` in `N_R`, the minimum over `i` in `Z/5` of

```text
F(sigma^i w) := 2 nu(sigma^i w) + nu(sigma^{i-1} w) - <sigma^i w, e_2>
```

is attained **at least twice**.

### Lemma 1 (convention reconciliation)

Condition (T) is *identical* to the condition of Proposition 3.3, which asks
that for every `omega`,

```text
q_i(omega) = -<omega, sigma^i e_2> + 2 h(sigma^{-i} omega) + h(sigma^{-(i+1)} omega)
```

attain its **maximum** at least twice.

**Proof.** Both are conditions on the same polytope. Substituting
`omega = -w` and using `h(-u) = -nu(u)`,

```text
q_i(-w) = <sigma^{-i}w, e_2> - 2 nu(sigma^{-i}w) - nu(sigma^{-i-1}w)
        = - [ -<sigma^{-i}w,e_2> + 2 nu(sigma^{-i}w) + nu(sigma^{-i-1}w) ],
```

so `max_i q_i(-w) = - min_i F(sigma^{-i} w)` and the two argument sets are
complementary index-for-index. Both statements quantify over all of `N_R`, so
they are the same statement. ∎

This resolves the apparent clash between §8.28's *twice-min* and Proposition
3.3's *twice-max*: they are the same condition read at opposite weights, on the
same Newton polytope. No `P |-> -P` is needed.

### Why (T) is necessary

Initial forms are multiplicative in a group algebra and
`in_omega(sigma^i f) = sigma^i(in_{sigma^{-i} omega} f)`. If one summand of
`Phi(a)` strictly dominated, its initial form would survive, and the initial
form of a product of nonzero elements is nonzero. (Proposition 3.3.)

## 2. The order-eleven class blocks the two cheap solutions — and only those

Set `G(x) = 16 - 8x + 4x^2 - 2x^3 + x^4`. In `Z[x]/(x^5-1)`,

```text
(x+2) G(x) = x^5 + 32 = 33.                                            (2.1)
```

Exactly verified, together with `det(2+sigma) = 33` on `Z^5` with Smith form
`(1,1,1,1,33)`, `det(2+sigma) = 11` on `M` with Smith form `(1,1,1,11)`, and
`lambda(e_2) = 4 != 0` for `lambda = (1,9,4,3,5) mod 11`, by
`verify_operator_identity.py`.

### Lemma 2 (a monomial fails)

If `P = {m}` is a point then `F(w) = <w, (2+sigma)m - e_2>` is linear, and (T)
forces `(2+sigma)m = e_2`, which has no solution in `M`.

**Proof.** Put `v = (2+sigma)m - e_2`. The five orbit values are
`<w, sigma^i v>`. If `sigma^i v != sigma^j v` for all `i != j`, the tie locus
is a finite union of proper hyperplanes and cannot be all of `N_R`. So
`sigma^d v = v` for some `d != 0`, hence `v` lies in `M^{sigma^d} = 0`
(Lemma 1.1 of the parent note), i.e. `(2+sigma)m = e_2`. But
`lambda((2+sigma)M) = 0` while `lambda(e_2) = 4`. ∎

This is the shadow-level echo of Lemma 2.3 ("no monomial is trace-zero"), and
it is the *third* guise of the order-eleven class: multiplicative class →
congruence functional → non-integrality on polytopes.

### Lemma 3 (an invariant target fails)

Since `nu` is `-h(-·)`, work with support functions: `F = h_Q` where
`Q = 2P + sigma P - e_2` is again a lattice polytope. If `Q` were
`sigma`-invariant, all five orbit values would coincide and (T) would hold
trivially. **No lattice polytope `P` makes `2P + sigma P - e_2`
`sigma`-invariant.**

**Proof.** `(2+sigma)h_P = h_Q + <·,e_2>` as functions on `N_R`. Apply
`G(sigma)` and use (2.1) together with `G(1) = 11` and the `sigma`-invariance
of `h_Q`:

```text
33 h_P = 11 h_Q + <·, G(sigma) e_2>.                                   (2.2)
```

At a generic direction the gradients are lattice points `p` of `P` and `q` of
`Q`, so `33p = 11q + G(sigma)e_2`, i.e. `G(sigma)e_2` lies in `11M`. But in
the basis `[e_0],[e_1],[e_2],[e_3]` of `M`,

```text
G(sigma) e_2 = (-6, -3, 12, -12),
```

which is not divisible by `11`. ∎ (verified: `verify_operator_identity.py`, G2)

Equivalently `(2+sigma)^{-1}e_2` has denominator exactly `11`; the exact
rational preimage is `(-2/11, -1/11, 4/11, -4/11)`.

### The gap the two lemmas leave

(T) asks only for a **tie**, not for equality of the five orbit values. Lemmas
2 and 3 kill equality-by-degeneracy and equality-by-symmetry. They say nothing
about a polytope whose five conjugates share faces in a cyclic chain. That is
exactly the room the construction below uses.

## 3. The theorem

> **Theorem (tropical/Newton insufficiency).** There is a lattice polytope
> `P` in `M_R` whose support function satisfies (T) at every `w` in `N_R`.
> Consequently no argument assembled from
>
> * divisorial valuations / tropicalization of `Phi`,
> * Newton polytopes and their support functions,
> * convexity and integrality of those support functions,
> * the order-eleven defect `coker(2+sigma) = Z/11`,
>
> can prove that `Phi` has no nonzero zero. Any negative proof must retain
> coefficient-level cancellation.

**Provenance.** PROVED in `theory/FIX_IX_v14.md` §8.28 (Correction IX-k) and
§8.30(A) (Correction IX-n), on two independent engines (Python; Julia/Nemo over
FLINT). The polytope has 1085 distinct slopes; convexity was certified at all
460 rays and `h(n) = max_C <U_h(C), n>` at 2421/2421 points.

**Construction (the three moves).**

1. **Solve over `Q` by (2.1).** `2+sigma` is injective, so `h` is *unique*:
   `h = (1/33) G(sigma) (d + m + e_2*)`, where `d` is a value witness and `m`
   is a free `sigma`-invariant term. Solvability is exactly
   `33 | G(sigma)(d + m + e_2*)` cellwise.
2. **Split by CRT.**
   * *mod 3.* `G(x) = 1 + x + x^2 + x^3 + x^4 (mod 3)`, so `(G*d)_i = m` for
     every `i`; the linear part contributes `sum_i w_i = 0` because `w` lies in
     `N`; and the invariant term contributes `11m`. The numerator is
     `m + 0 + 11m = 12m = 0 (mod 3)`. **Automatic**, once `m = sum_j d o sigma^j`
     is taken — the "mod-3 surprise" is satisfiable precisely because `m` is
     free.
   * *mod 11.* `G mod 11 = (5,3,4,9,1)` is not constant, so this layer is a
     **genuine congruence on `d`** — congruence (3) of the value-form system.
     It is the order-eleven class again, and it is a real filter: §8.27 records
     that 15 of 27 one-orbit variants die at this layer alone.
3. **Convexify without disturbing the ties.** This is the load-bearing trick.

### Lemma 4 (invariant shift preserves the tie set)

If `g` is `sigma`-invariant then replacing `h` by `h + T g` replaces
`F(sigma^i w)` by `F(sigma^i w) + 3T g(w)` — the **same** number for all five
`i`. Hence the argmin index set over each `sigma`-orbit is unchanged.

**Proof.** `(2+sigma)(Tg) = 3Tg` and `g(sigma^i w) = g(w)`. ∎

Taking `g` `sigma`-invariant, integral-sloped and strictly convex on the fan
(the repo uses `g = sum_t |<nu_t, ·>|` over the 20 `sigma`-stable defining
forms), `h + T g` is convex for `T` large; an integral-sloped convex PL
function is the support function of the lattice polytope
`conv{ U_{h+Tg}(C) }`. The repo's certified value is `T = 15,241,389`
(§8.30) — earlier, on the same fan with the other invariant, `T = 128` (§8.28).

**Why the theorem follows.** With `F = d + m`, `m` `sigma`-invariant, `d >= 0`
and `d` vanishing at at least two indices of each `sigma`-orbit,
`min_i F(sigma^i w) = m(w)` and the minimum is attained at those indices —
at **every** `w`, not merely at sampled ones.

## 4. Independent replay (this packet)

`verify_tropical_lift.py` rebuilds the lift from the repo's checked-in witness
slopes `U_d` (`director_probes_20260806/f55_qpre_data_P01.json`, `..._P34.json`)
using **no fan, no cell algebra and no wall list** — only lattice-point
evaluation `d(w) = <U_d(C(w)), w>` and the 33-identity. On both witness
families, at ~3,600 generic lattice points each with all five
`sigma`-translates:

```text
d >= 0                                       0 violations (17,970 / 17,870 evals)
twice-min: >= 2 of the five d(sigma^i w) = 0 0 violations; multiplicity exactly 2
2h(w) + h(sigma^-1 w) - <w,e_2> = d + m      0 violations
h is INTEGER valued (33 | numerator)         0 violations
twice-min read off h alone                   0 violations
mod-3 layer                                  0 violations
mod-11 layer (congruence (3))                0 violations
negative control: d[0] += 1 breaks 33 | .    365 / 365 samples now fail
```

The working convention was re-derived from 33-integrality alone rather than
assumed: `sigma = shift_{+1}` on `N` with `<w,e_2> = w_2`, integral at 183/183
calibration samples. Terminal marker `F55_TROPICAL_LIFT_REPLAY_OK`.

This is a third engine agreeing with the two of §8.30, and it is the first
replay that touches neither the fan nor the wall list.

## 5. What is NOT proved — the round-6 overclaim, rejected

Round 6 states that the 33-identity "lifts **every** tropical value witness".
At face value this is **false**, and the repository already contains the
counterexamples: the lifting criterion is `33 | G(sigma)(d + m + e_2*)`, whose
mod-11 half is a genuine congruence on `d`, and §8.27 records 15 of 27
one-orbit `(e)`-variants dying at that layer with no residue solving it.

Read charitably — "value witness" meaning a solution of the full value-form
system (0) `d >= 0`, (1) twice-min zeros, (2) integral slopes, (3) the
congruence — the statement becomes true and is exactly §8.28. That reading has
to be stated, not assumed.

More importantly, **the universal quantifier is not needed**. Insufficiency
requires exactly one lattice polytope satisfying (T). The repository has one.
Strengthening the claim to a universal lifting statement adds no force to the
method-exhaustion conclusion and does add an unproved assertion. It is
therefore rejected, and the theorem is recorded at the strength above.

## 6. Register

This belongs with the repository's other method-exhaustion results: it names a
whole class of arguments and shows the class cannot reach the target. It does
**not** bear on whether `X_gen(K_proj)` is empty.

```text
F55-TROPICAL-INSUFFICIENCY-PROVED
F55-ROUND6-UNIVERSAL-LIFTING-OVERCLAIM-REJECTED
F55-QUESTION-OPEN
```
