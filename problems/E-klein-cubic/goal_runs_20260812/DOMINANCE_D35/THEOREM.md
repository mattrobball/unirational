# Dominance route at d = 35

**Packet:** `goal_runs_20260812/DOMINANCE_D35/` · 2026-08-12.
**Headline: Problem E remains OPEN; this packet excludes no degree.**

*(Filename note: the main document is `THEOREM.md`; the harness refuses the
literal name `REPORT.md`.)*

Independent of emptiness: a landing solution is a dominant map onto the
Klein 3-fold only if the 5×5 Jacobian of `T` has rank 4 at a general
point. This packet tests whether the 4×4 minors of `J_T` already lie in
the landing ideal in `c`-degree 4 (then 5). That would exclude every
dominant map at `d = 35` without deciding whether the landing cone is
`{0}`.

Machine markers: `DOMINANCE_D35_VERIFY_OK` / `ALLGREEN` (`python3 verifier.py`).

## Exit ledger

```text
DOM35-CELL37-P3-1380
DOM35-JAC-RANK-5-EULER
DOM35-MINOR-SPAN
DOM35-I4-LEAD-SPAN-17905
DOM35-I4-REWRITE-NONZERO
DOM35-I5-LEAD-REWRITE-NONZERO
DOM35-NO-DEGREE-EXCLUSION
```

---

## 0. Object

- **Cell.** Sealed 37-dimensional slice of `M_35` after the six flip
  cuts (`PAIR_ATTACK_D35` nullspace 39×637 and `universal_matrix_6x39`).
- **Landing cubics.** The sealed `I3` echelon basis
  (`D35_LANDING/results/I3_echelon_p{p}.npy`), shape `(1380, 9139)`.
  `I4` is the span of the `37 × 1380 = 51060` products of a linear form
  with an `I3` generator. Ambient `N4 = binom(40,4) = 91390`.
- **Jacobian.** `J_T` is 5×5, entries linear in the 37 cell parameters
  (because `T_c` is linear in `c`). Each 4×4 minor is a quartic in `c`.
- **Primes.** `p ∈ {331, 661}` for anchors; rewrite confirmed at both.
- **Tools.** python3 + FLINT `nmod_mat` for modular rank (same engine
  M2 uses). No gap / gp / sage / magma. No msolve (Lane 1/2 already
  hold the 4-thread slot; director holds 16).

---

## 1. Anchors

| item | p=331 | p=661 |
|---|---:|---:|
| cell dim | **37** | **37** |
| rank of the six-flip matrix | 2 | 2 |
| `P3 = dim I3` | **1380** | **1380** |
| generic `rank J` on the cell (5 trials) | **5** | **5** |
| Euler `J(w)·w = 35·T(w)` | exact, 5/5 | exact, 5/5 |
| generic ambient rank | 5 | 5 |

Matches the director probe (`jacobian_rank_probe.py`). Rank 5 on the
cell means `det J = 0` is a nontrivial closed condition, and the 4×4
minors are not identically zero.

---

## 2. The 4×4-minor quartics

Sample random `x ∈ F_p^5`, evaluate all 25 four-by-four minors of
`J(c;x)` at many random `c`, take rank of the value matrix.

At `p = 331`, `nc = 2200` evaluation points: the rank tracks `25 ×`
(number of `x`) exactly through 80 + 16 extra points and then hits the
`nc` ceiling at **2200**. The span is **not saturated**; each generic
`x` contributes 25 new independent quartics (evaluation-injective at
this scale). Lower bound: `dim M ≥ 2200`.

So the rank-≤3 locus is a proper closed subset of the cell, cut by a
large space of independent quartics.

---

## 3. Membership in `I4`

The 51060 products `c_i · f_j` are **not** independent as leading
terms. Writing `S` for the set of quartic monomials of the form
`c_i · (I3-pivot)`, one has

```text
|S| = 17905
```

at **both** primes (combinatorics of the 1380 pivot monomials). The
17905 products assigned to those distinct leads have coefficient 1 at
distinct columns, so they are linearly independent:

```text
P4 ≥ 17905,     HF4 ≤ 91390 − 17905 = 73485,
HF4 ≥ 91390 − 51060 = 40330   (domain, characteristic-free).
```

The remaining `51060 − 17905 = 33155` products are collisions (same
lead already in `S`). Samples of those extras, reduced against the
17905, **all have nonzero remainder** (12/12 at `p=331`, 6/6 at
`p=661`; weights cluster near 14850 or 73250). So the extras are not
in the lead span: `P4 > 17905`.

**Rewrite test (sufficient for membership).** Reduce each of the 25
minors at one generic `x` against the 17905 lead products.

| prime | minors tested | rewrite to 0 | remainder rank | typical rem. weight |
|------:|--------------:|-------------:|---------------:|--------------------:|
| 331   | 25            | **0**        | **25**         | ~73260 / 73485      |
| 661   | 5             | **0**        | 5              | same pattern        |

No tested 4×4-minor quartic lies in the 17905-dimensional lead piece of
`I4`. The 25 remainders at `p = 331` are independent and fill almost
the whole 73485-dimensional complement of `S`.

**Exact obstruction at degree 4.** For a 4×4-minor quartic `Q` to lie
in `I4`, its remainder after the lead rewrite must lie in the span of
the 33155 collision products (a space of unknown dimension in
`[1, 33155]`). That residual membership is a `33155 × 73485` linear
algebra problem (~19 GB dense) and was not run. The packet therefore
does **not** place `Q` in `I4` and does **not** exclude `d = 35`.

A k×k sketch of `I4` (random products on random monomials, FLINT rank)
at `k = 8000` was full rank on two seeds (`P4 ≥ 8000`), consistent
with the exact lead bound 17905. A larger sketch is optional.

---

## 4. Degree 5

`I5` is the span of quadratic × `I3` (`703 × 1380 = 970140` products)
inside `N5 = binom(41,5) = 749398`. Unique leads of the form
`(quadratic monomial) × (I3-pivot)`:

```text
|S5| = 178811.
```

Four linear multiples `c_0 Q, …, c_3 Q` of one 4×4-minor quartic were
reduced against that lead span. **All four remainders are nonzero**,
with weight ~569000 against the complement size `749398 − 178811 =
570587`. So those quintics are not in the 178811-dimensional lead
piece of `I5`.

Same leftover: they would have to lie in the span of the collision
products in degree 5. The full Macaulay matrix at degree 5
(970140 × 749398) is far outside the 15 GB budget.

---

## 5. Flags

No exclusion. Generic Jacobian rank on the cell is 5, so the cell
itself is not a rank-≤3 locus. The 4×4-minor quartics fail the
sufficient lead-span membership test at degrees 4 and 5. The residual
collision-span test was not closed. ODDZERO gate idle.

---

## 6. Honesty tiering

| claim | tier |
|---|---|
| cell dim 37, `P3 = 1380`, `|S| = 17905`, `P4 ≥ 17905`, `HF4 ≥ 40330` | exact linear algebra (lead independence is characteristic-free) |
| generic `rank J = 5`, Euler identity | modular, both primes, 5/5 trials |
| rewrite remainders nonzero | modular, p=331 (25 minors) and p=661 (5 minors) |
| extra collision products not in the lead span | modular sample of 12 at p=331 |
| `I5` lead remainders nonzero | modular, 4 linears, p=331 |
| minor-span `dim M ≥ 2200` | modular lower bound, unsaturated |
| no degree excluded | mandatory framing |

---

## 7. Not claimed

- That `d = 35` is excluded, or that every landing solution has
  Jacobian rank ≤ 3.
- That the 4×4-minor quartics lie in `I4` or in `I5`, or that they do
  not (the residual collision span is open).
- Characteristic-zero emptiness of the landing cone.
- A value of `P4` sharper than the exact lower bound 17905, or a
  saturated `dim M`.
- Any Nullstellensatz / ODDZERO promotion.

**Problem E remains OPEN; this packet excludes no degree.**

---

## 8. Replay

```bash
cd goal_runs_20260812/DOMINANCE_D35
python3 verifier.py
# optional regeneration:
#   python3 scripts/produce_anchors.py          # both primes
#   python3 scripts/produce_minors.py 331
#   python3 scripts/produce_membership.py 331   # rewrite + optional P4 sketch
#   python3 scripts/produce_extras.py 331 12
#   python3 scripts/produce_degree5.py 331 --no-sketch
```

Primary artefacts under `results/`: `anchors_p{331,661}.json`,
`minors_span_p331.json`, `i4_rewrite_p{331,661}.json`,
`i4_extras_p331.json`, `i5_rewrite_p331.json`,
`verifier_output.json`.
