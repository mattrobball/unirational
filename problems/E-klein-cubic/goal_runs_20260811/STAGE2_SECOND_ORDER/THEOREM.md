# Stage 2, second computation: the A4 second-order jet, and what bounds the C11 multiplicity

**Packet:** `goal_runs_20260811/STAGE2_SECOND_ORDER/` · opened 2026-08-11.
**Headline: Problem E remains OPEN.** No degree is excluded here either.

This packet executes the two levers named as remainders 1 and 2 of the sealed
`goal_runs_20260810/STAGE2_ODD_ORDER_PINNING` (PR #37, exit
`STAGE2-ODD-ORDER-PINNING-SEALED`; materialised read-only from
`origin/agent/stage2-odd-order-pinning-20260810` and **not modified**).

Two results, one per lever.

> **Lever 1.** The A4-equivariant jet at an A4-point is **not** blind — but it
> is blind in a different way than expected. Let `μ = mult_q(T)` at an
> A4-point. Then `μ = 1` is **impossible**; for `μ = 2` and `μ = 4` the two
> immune `C3`-rows over `q` carry **no value at all** (they lie in the
> indeterminacy locus); for `μ = 3` the value is one of the **two exact-`C3`
> points** and the `X^{C6}` point is **excluded** — the residual `3` per row
> drops to `2`; for `μ = 5` all three are realisable and the jet is blind
> again. So `3⁸ = 6 561` collapses to `2⁸ = 256` exactly when `μ = 3`, to `1`
> when `μ ∈ {2,4}`, and not at all from `μ = 5` on.

> **Lever 2.** At a `C11`-point, `μ = mult_p(T)` obeys `μ ≤ d` always,
> `2μ ≤ d` as soon as one of the ten `C11`-coordinate lines is not in `Bs(T)`,
> and `d² ≥ 3μ² + 55e²` under a no-fixed-component hypothesis on a
> `C11`-coordinate plane. The covariance congruence, on the other side, never
> forces more than `μ ≥ 1`. The two never meet: **no exclusion**. What the
> computation does buy is a sharpening of the sealed `C11` quadruple
> obstruction at `μ = 1`, and a new piece of geometry: **60 of the lines
> joining two `C11`-fixed points lie on `X`.**

## Exit ledger

```text
STAGE2-SECOND-ORDER-A4-JET-SEALED
STAGE2-A4-MULT-AT-LEAST-3          (mu = 1 impossible, mu = 2 valueless)
STAGE2-C6-POINT-EXCLUDED-AT-MU-3
STAGE2-C11-LINE-GEOMETRY
STAGE2-C11-MULT-BOUNDS-PARTIAL
STAGE2-NO-DEGREE-EXCLUSION-II      (NEGATIVE exit)
```

Machine markers: `STAGE2_SECOND_ORDER_VERIFY_OK` / `ALLGREEN`
(`python3 verifier.py` — **96 checks, 0 failures**, `p = 331` and `p = 661`).

---

## 1. Set-up at an A4-point

Notation of the sealed packet. `G = PSL(2,11)`, `W` the Klein representation,
`X = {F = 0} ⊂ P(W)`, `F = Σ_{i∈Z/5} x_i² x_{i+1}`, `T ∈ (Sym^d W* ⊗ W)^G` a
landing covariant, `F ∘ T ≡ 0`.

Let `q` be an A4-point: `Stab_G(q) = A4`, and `q` spans a character `ω` of `A4`.
Verified here from the matrices (`verifier.py` B1–B9, both primes, both
`G`-orbits of A4-points):

```
   W|_{A4} = ω ⊕ ω² ⊕ Θ ,        Θ = the 3-dimensional irreducible
   Θ = the sum of the three NON-trivial V4-eigenspaces of W
   W^{V4} = ⟨q, q'⟩ = the span of ℓ_V ,     W^{A4} = 0
   U = the A4-stable complement of ⟨q⟩ = ⟨q'⟩ ⊕ Θ
   N = the projective normal space at q = ω^{-1} ⊗ U = ω ⊕ Θ
```

with `C3`-weights on `N` equal to `{0,1,1,2}` at the `ω`-point and `{0,1,2,2}`
at the `ω²`-point — the sealed `TERMINUS_STRATA_PW` normal characters.

**The jet.** For `v = q + w`, `w ∈ U`, and `h ∈ A4` one has
`h·v = ω(h)(q + ψ_h w)` with `ψ_h w = ω(h)^{-1} h w`. Writing
`T(q + w) = Σ_k Φ_k(w)` and letting `Φ := Φ_μ` be the first non-zero term
(`μ = mult_q(T)`), equivariance and landing give

```
   (*)    Φ(ψ_h w) = ω(h)^{-d} · h·Φ(w)      for all h ∈ A4 ,
   (**)   F(Φ(w)) ≡ 0                        (lowest order of F ∘ T ≡ 0).
```

So `[Φ] : P(N) ⇢ X` is an A4-equivariant rational map of degree `μ`.

**The weight dictionary** (proved; `verifier.py` B7 is the load-bearing one).
For `θ_b ∈ Θ` the `C3`-eigenvector of weight `b`, (*) gives

```
   h·Φ(θ_b^μ) = ω(h)^{ d·a_q + μ·(b − a_q) } Φ(θ_b^μ) ,
```

so `θ_b` sits in `N` with relative weight `b − a_q`, and the three `C3`-fixed
loci of `P(N)` are

| `b − a_q` | locus in `P(N)` | what it is |
|---|---|---|
| `0` | a point | **the direction of the `C3`-eigenline through `q`** |
| `1` | a `P¹` | the immune row `pt_A4 dim1` |
| `2` | a point | the immune row `pt_A4 dim0` |

The `P¹` contains `θ_{a_q+1}`, so **the dim-1 row's value is `[Φ(θ_{a_q+1}^μ)]`**
and the dim-0 row's is `[Φ(θ_{a_q+2}^μ)]`: the entire question lives inside
`Sym^μ Θ`.

**Reduction to `Θ`.** `Sym^μ N = ⊕_a ω^a ⊗ Sym^{μ−a} Θ` is a direct sum of
A4-summands, so restriction `Hom_{A4}(Sym^μ N, ·) → Hom_{A4}(Sym^μ Θ, ·)` is
surjective and split by extension by zero; and `F(Φ)|_Θ ≡ 0` is exactly `(**)`
for the extended-by-zero jet. Hence

> a value `c` is realised by an A4-equivariant landing jet of order `μ` **iff**
> there is `Φ ∈ Hom_{A4}(Sym^μ Θ, W ⊗ ω^{-d})` with `F(Φ) ≡ 0` on `Θ` and
> `ev(Φ) ∈ ⟨c⟩ ∖ {0}`.

**The eigenline constraint (new coupling).** The sealed Prop. 1.6 says that for
`3 ∤ d` the whole `C3`-eigenline through `q` is contracted to the `X^{C6}` point
`f` of weight `d·a_q`; for `3 | d` the eigenline lies in `Bs(T)`. Approaching `q`
along the eigenline, the relative-weight-0 direction therefore carries the value
`f` (or `0`). So the jet must satisfy

```
   Φ(θ_{a_q}^μ) ∈ ⟨f⟩         (3 ∤ d) ,        Φ(θ_{a_q}^μ) = 0   (3 | d) .
```

This is the *global* Stage-2 datum feeding the *local* A4-jet, and it is what
makes the computation bite.

---

## 2. Lever 1: the verdict on the residual `3⁸`

### 2.1 `μ = 1` is impossible

> **Proposition 2.1.** `mult_q(T) ≥ 2` at every A4-point, for every `d`.
>
> *Proof.* `Sym^1 N = ω ⊕ Θ`. On the `ω`-summand, (*) gives
> `h·Φ(n_ω) = ω(h)^{d+1} Φ(n_ω)`, so `Φ(n_ω)` lies in an `ω`-isotypic component
> of `W|_{A4}`; those are `⟨q⟩` and `⟨q'⟩` (and `W^{A4} = 0`), and both
> A4-points are **off** `X`, so landing forces `Φ(n_ω) = 0`. On `Θ`,
> `dim Hom_{A4}(Θ, W ⊗ ω^{-d}) = 1` (the target is two characters plus one copy
> of `Θ`), and the generator is injective because `Θ` is irreducible; its image
> is a 3-dimensional linear subspace of `W`, whose projectivisation would be a
> **plane contained in `X`** — impossible for a smooth cubic threefold. So
> `Φ|_Θ = 0` as well, i.e. `Φ = 0`, contradicting `Φ = Φ_μ ≠ 0`. ∎
>
> Machine confirmation, both primes, both orbits, all `d mod 3`: `dim = 1`,
> `F(Φ) ≢ 0` for the generator, and the eigenline constraint independently
> annihilates the space (`verifier.py` C1, C2, C3).

This strictly sharpens the sealed Prop. 2.3, which gave only `μ ≥ 1`.

### 2.2 The order-by-order table

For every `μ`, every `d mod 3`, both A4-orbits and both primes we computed the
jet space, imposed the eigenline constraint, and decided realisability of each
target point. Two independent decision routes are used and agree:

* a **univariate gcd** when `dim ker(ev) = 1` — exact over `F_p`, since a common
  root in the algebraic closure exists iff the gcd over `F_p` has positive
  degree (`scripts/s3lever1c.py`);
* a **Macaulay2 `dim`** call otherwise — the target is realised iff the cubic
  ideal `F(Σ a_i P_i + s Q_1 + t Q_2) = 0` is not the unit ideal, i.e. iff
  `dim ≥ 0` (`scripts/s3m2.py`, `results/m2_lever1.txt`).

> **Theorem 2.2 (the A4-jet table).** Let `μ = mult_q(T)`, and consider either
> of the two immune `C3`-rows over `q` whose target weight is non-zero.
>
> | `μ` | `X^{C6}` point | the two exact-`C3` points | value count per row |
> |---:|---|---|---:|
> | 1 | — | — | **impossible** (Prop. 2.1) |
> | 2 | not realisable | not realisable | **0** (row is a base point) |
> | 3 | **NOT realisable** | realisable | **2** |
> | 4 | not realisable | not realisable | **0** (row is a base point) |
> | 5 | realisable | realisable | **3** |
>
> (Rows whose target weight is `0` are base points for every `μ`, as already
> sealed.) Verified at `p = 331` and `p = 661`, for both A4-orbits and all
> three residues `d mod 3`; 72 Macaulay2 decisions, 0 disagreements with the
> gcd route (`verifier.py` D1–D6).

**Reading it.** Order 2 is not "blind": it is *fatal* — an order-2 A4-jet
carries no value on either row. The first order at which the rows can carry a
value is `μ = 3`, and there the separation is real and points the *opposite* way
to the naive guess: it is the `X^{C6}` point that is excluded, not the exact-`C3`
points. From `μ = 5` on the jet is blind and all three survive.

Structurally the exclusion at `μ = 3` is easy to believe: the relative-weight-0
direction already has to go to the `X^{C6}` point (the eigenline constraint), and
the landing condition obstructs a second `C3`-direction landing on the same
point.

### 2.3 The collapsed count

Per A4-orbit the pair `(μ)` is an invariant of the map, so the residual factor
of the sealed packet stratifies:

```
   mu = 2 or 4      the 8 immune C3-rows carry NO value        factor 1
   mu = 3           each row has 2 values                      2^8 = 256
   mu >= 5          each row has 3 values                      3^8 = 6 561
```

Carried into the sealed count `43 008 · 23 · (immune)`:

```
   sealed Stage-2 order-0 count           43 008 · 23 · 3⁸ = 6 490 036 224
   with mu = 3 at both A4-orbits          43 008 · 23 · 2⁸ =   253 231 104
   with mu in {2,4} at both orbits        43 008 · 23      =       989 184
```

> **Honest verdict on the brief's question.** The residual `3⁸` does **not**
> collapse unconditionally: `μ = 5` realises all three values, so the supremum
> over admissible `μ` is still `3⁸`. It collapses to `2⁸` exactly when `μ = 3`
> and to `1` when `μ ∈ {2,4}`. **Order 2 is not blind — it is empty.** The
> order at which the `C6`/exact-`C3` distinction first becomes visible is
> `μ = 3`; the order at which it stops being visible is `μ = 5`.

### 2.4 What is *not* claimed

`μ` is not pinned by anything in this packet, so no unconditional collapse
follows. Nothing here says an actual landing covariant exists at any `d`, and
the jets exhibited at `μ = 3, 5` are **jets**, not germs and not maps (the T5
algebraisation gate is untouched). `μ = 6` was submitted to Macaulay2 and did
not return within the packet's compute budget; the entry is left open in §6.

---

## 3. Lever 2: what bounds the multiplicity at a `C11`-point

### 3.1 New geometry: 60 lines of `X` through pairs of `C11`-points

In the `C11`-eigenbasis the five eigenpoints are the coordinate points with
weights `Q = {1,3,4,5,9}` (the quadratic residues), and
`F = Σ_{a ∈ Q} x_a² x_{9a}` — the `F`-successor of the weight-`a` point is the
weight-`9a` point (`9 ≡ −2`). Hence for the line `L_{jk} = ⟨e_j, e_k⟩`, which is
`C11`-stable, `F|_{L_{jk}}` is non-zero exactly when `k = 9j` or `j = 9k`.

> **Proposition 3.1.** The ten `C11`-coordinate lines split into two
> `F55`-orbits of five, indexed by the ratio class `{r, r^{-1}}` of `r = k/j`:
>
> * `r ∈ {5,9}` (`F`-adjacent): `L ∩ X` = the two endpoints only;
> * `r ∈ {3,4}`: `F|_L ≡ 0`, so **`L ⊂ X`**.
>
> Each line has `Stab_G(L) = C11` and `G`-orbit `60`. So `X` carries a
> `G`-orbit of **60 lines each joining two `C11`-fixed points**; they are *not*
> minus-lines (`Stab(L_σ) = D12` has no element of order 11). Verified at both
> primes (`verifier.py` E1–E3).

### 3.2 The bounds

> **Proposition 3.2.** Let `μ = mult_p(T)` at a `C11`-point (the same for all
> 60 by `F55`-transitivity), and `e = ord_{P_σ}(T) ≥ 1`.
>
> (a) `μ ≤ d`.
> (b) If some `C11`-coordinate line `ℓ` is **not** contained in `Bs(T)`, then
> `2μ ≤ d`. *(A general member of the 5-dimensional system `⟨T_0,…,T_4⟩`
> contains `ℓ` iff every `T_i` does; if it does not, its restriction to `ℓ` is a
> non-zero binary form of degree `d` vanishing to order `≥ μ` at both
> endpoints.)*
> (c) If for some `C11`-coordinate 2-plane `Π = ⟨e_j,e_k,e_l⟩` the restricted
> system `⟨T_i|_Π⟩` is non-zero without a fixed component, then Bezout on `Π`
> gives `d² ≥ 3μ² + 55e²`, since `Π` meets each of the 55 plus-planes and the
> three coordinate points have multiplicity `≥ μ`.
> (d) If `μ = 1` the leading form is **linear**, so its image is a linear
> subspace of `W` whose projectivisation lies in `X`; a smooth cubic threefold
> contains no plane, so `rank Φ ≤ 2`. The four exceptional directions map into
> four *distinct* eigenspaces, so at most **two** of the four `C11`-rows over
> each point carry a value, and when two do, their target weights `w, w'` must
> satisfy `w'/w ∈ {3,4}` — i.e. the two targets span one of the 60 lines of
> Prop. 3.1.

Part (d) is a genuine sharpening of the sealed `C11` quadruple obstruction. The
sealed congruence count allowed **four** simultaneous values at `d ≡ 1 (mod 11)`,
`μ = 1`; the rank cut brings that to **two**, and for **seven** of the eleven
residues (`d ≡ 0,3,4,5,7,8,9`) to **one** (`verifier.py` E6–E8;
`results/lever2.txt`).

### 3.3 The gap, precisely

The congruence pushes `μ` from below; the geometry pushes it from above.

```
   mu_min(d)  =  0  if d is a quadratic residue mod 11 ,  else  1
              (computed exactly; verifier.py E4, E5)
   upper      =  floor(d/2)     under (b)
              =  sqrt((d^2 - 55 e^2)/3)   under (c)
```

> **Theorem 3.3 (no exclusion, again).** `mu_min(d) ≤ 1 < ⌊d/2⌋` for every
> `d ≥ 4`, so the lower and upper bounds never cross. The `C11` multiplicity
> yields **no degree exclusion**, at any `d` in or beyond the sealed window.

**The precise gap.** An exclusion would need one of:
1. a lower bound on `μ` that grows with `d` — nothing here or in the sealed
   packet produces one; the congruence saturates at `μ ≥ 1`;
2. an upper bound below `μ_min` — impossible since `μ_min ≤ 1` and `μ ≤ 1` is
   consistent with (d) for every residue;
3. an exclusion of `μ = 1` at the `C11`-points, in the style of Prop. 2.1 at the
   A4-points. This is the live one: (d) already shows `μ = 1` is very tight
   there. **Deciding whether a `μ = 1` `C11`-jet exists at all** — i.e. whether
   the rank-`≤2` linear `Φ` with image one of the 60 lines can be
   `C11`-equivariant *and* extend — is the natural next computation. It is not
   done here.

---

## 4. Consequences for the windows

Nothing in this packet excludes a degree, so the sealed gate is unchanged:
`d ≤ 30` empty, `d = 25` dead, **`d = 34` still the first open window**.

What the two levers add to a `d = 34` search, on top of the sealed packet's
minus-line and `X^{C6}` base-locus conditions:

* at each of the 110 A4-points, `mult(T) ≥ 2`, and if `mult = 2` or `4` the
  eight immune `C3`-rows carry no value at all; if `mult = 3` their values are
  exact-`C3` points, never `X^{C6}` points;
* at each of the 60 `C11`-points, `34 ≡ 1 (mod 11)` is a residue, so `μ = 0` is
  open and `T` fixes `X^{C11}` pointwise; should `μ = 1` occur instead, at most
  two of the four `C11`-rows carry a value and their targets must span one of
  the 60 lines of Prop. 3.1.

---

## 5. Verification

```sh
python3 scripts/s3lever1.py     # jet spaces, dimensions, equivariance-only cut
python3 scripts/s3lever1b.py    # mu = 2, exact pencil test
python3 scripts/s3lever1c.py    # per-target univariate-gcd test
python3 scripts/s3m2.py         # Macaulay2 landing decisions  (writes the .m2)
python3 scripts/s3lever2.py     # C11 line geometry and the bounds
python3 verifier.py             # 96 checks, ALLGREEN
```

Routes, each conclusion produced by at least two:

| route | what it does |
|---|---|
| exact `F_p` model of `G` on `W` | the repo's `S`, `T` from `certificates/exact_weil_check.py` reduced at `p = 331, 661` (`330 ∣ p−1`); A4, `Θ`, the A4-points, the `C3`-eigenlines, the `X^{C6}` points, the `C11` lines — all by exact linear algebra and exact evaluation of `F` |
| representation theory | `dim Hom_{A4}(Sym^μ Θ, W ⊗ ω^{-d})` predicted by character multiplicities and matched against the computed nullspace |
| univariate gcd over `F_p` | exact realisability decision when `dim ker(ev) = 1` — field-independent, so no rationality assumption on the auxiliary parameter |
| Macaulay2 | `dim` of the cubic landing ideal; `dim = −1` iff the unit ideal iff no solution over the algebraic closure |

Check groups: **A** model (4), **B** the A4 set-up and the weight dictionary
(36), **C** the `μ = 1` exclusion (36), **D** the landing verdicts (6),
**E** `C11` lines, `μ_min`, the `μ = 1` rank cut and the no-exclusion statement
(15), **F** cross-prime (2). Total **96**, 0 failures.

Artifacts: `results/lever1_jets.{txt,json}`, `results/lever1_landing.json`,
`results/lever1_targets.json`, `results/lever1_m2.json`,
`results/m2_lever1.txt`, `results/lever2.{txt,json}`,
`results/verifier_output.json`, `results/verifier_stdout.txt`,
`scripts/lever1_landing.m2` (generated).

---

## 6. Honesty tiering

**Tier 1 — exact, prime-free.** Prop. 2.1 (`μ ≥ 2`); the reduction to
`Sym^μ Θ`; the weight dictionary of §1; the eigenline constraint as a
consequence of the sealed Prop. 1.6; Prop. 3.1 (the line geometry is a
two-line computation with `F = Σ x_a² x_{9a}`); Prop. 3.2(a),(b),(d);
Theorem 3.3.

**Tier 2 — finite exact computation over two split primes, two decision
routes.** Theorem 2.2's table; the jet-space dimensions; the `μ_min` table; the
`μ = 1` rank table; the `C11` line stabilisers and orbit sizes.

**Tier 3 — flagged.**

1. **`μ = 6` is not decided.** The Macaulay2 ideals have ten variables and did
   not return inside the packet's budget. The table of Theorem 2.2 is therefore
   complete only for `μ ≤ 5`; the statement "from `μ = 5` on the jet is blind"
   is verified at `μ = 5` and *conjectured* beyond.
2. **The exact-`C3` realisations at `μ = 3, 5` are decided at `p = 331`**, where
   all three points of `X` on a `C3`-eigenline are `F_p`-rational; at `p = 661`
   only the `X^{C6}` point is rational (`RECEIVER_LEDGER_X` §3.1), so the
   `p = 661` run confirms the `C6`-**exclusion** at `μ = 3, 4` and the `C6`
   realisation at `μ = 5`, but not the exact-`C3` side. The exclusion — the
   load-bearing half — is confirmed at both primes.
3. **Prop. 3.2(b),(c) are conditional** on hypotheses that this packet does not
   verify for a hypothetical `T`: that some `C11`-coordinate line is not in the
   base locus, resp. that a coordinate-plane restriction has no fixed
   component. Only (a) and (d) are unconditional.
4. **Realisability is at the jet level.** "`c` is realised" means an
   A4-equivariant landing jet with that value exists, not that a global
   covariant does.
5. The comparison run with the eigenline constraint switched **off** was
   collected but not decided (its kernels need Macaulay2); so we do not report
   which of the two inputs — equivariance or the eigenline constraint — carries
   the `μ = 3` exclusion.

## 7. Not claimed

* No headline; Problem E remains OPEN.
* **No degree is excluded**, by either lever.
* No unconditional collapse of the residual `3⁸`.
* No bound on `μ` at the A4-points from above, and none at the `C11`-points that
  bites.
* No claim that any of the exhibited jets algebraises.

## 8. Dependencies

| import | used for | grade |
|---|---|---|
| `goal_runs_20260810/STAGE2_ODD_ORDER_PINNING` (PR #37, branch `agent/stage2-odd-order-pinning-20260810`) | the pinning theorem, the immune-row identification, Prop. 1.6 (the eigenline contraction), the `C11` quadruple obstruction, Prop. 2.3 | consumed; Prop. 2.3 **sharpened** (`μ ≥ 2`), Thm 2.1 **sharpened** at `μ = 1` |
| `RECEIVER_LEDGER_X` | `X^{C3}`, `X^{C6}`, `X^{A4} = ∅`, the `F_p`-rationality pattern on a `C3`-eigenline | re-verified here from the matrices |
| `TERMINUS_STRATA_PW` | the A4-point normal characters `{0,1,1,2}` / `{0,1,2,2}` | re-derived and matched |
| `STAGE1_COMPLEX_MAPS` §15.5 | the 22 coherence-immune rows and the count `43 008 · 23 · (immune)` | consumed |
| `certificates/exact_weil_check.py` | the exact `S`, `T` | reduced mod 331, 661 |

## 9. Named remainders

1. **`μ = 6` and beyond** at the A4-points (Tier 3.1).
2. **Does a `μ = 1` jet exist at a `C11`-point?** Prop. 3.2(d) makes it very
   tight; excluding it would be the `C11` analogue of Prop. 2.1 and is the only
   visible route from lever 2 to an exclusion.
3. **What pins `μ` at the A4-points?** Theorem 2.2 makes the whole residual
   factor a function of `μ`; any bound `μ ≤ 4` would force the eight immune rows
   to be valueless, and `μ = 3` would give `2⁸`.
4. The 60 lines of Prop. 3.1 are new to the repo's inventory of `X`'s Fano
   surface; their relation to the 55 minus-lines and to the type-I vertices is
   not worked out here.
