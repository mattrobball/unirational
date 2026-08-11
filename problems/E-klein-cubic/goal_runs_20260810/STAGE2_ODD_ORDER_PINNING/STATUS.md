# STAGE2_ODD_ORDER_PINNING — status

**Problem E headline: OPEN.** This packet contains no headline claim and
**excludes no degree**.

| | |
|---|---|
| opened | 2026-08-11 |
| main document | `THEOREM.md` |
| machine markers | `STAGE2_ODD_ORDER_PINNING_VERIFY_OK` / `ALLGREEN` — **95 checks, 0 failures** |
| replay | `python3 verifier.py` (both primes) |
| state | complete; adjudicated 2026-08-11 (`ADJUDICATION_PR37.md`) |

## What it is

The first Stage-2 computation. It takes the coherence-immune factor that
`STAGE1_COMPLEX_MAPS` §15.5 isolated — the 22 rows of the terminus `Z` whose
exact stabiliser has odd order, on which order-0 theory has nothing to say — and
pins it by exact character arithmetic on the landing covariant
`T ∈ (Sym^d W* ⊗ W)^G`.

## Headline numbers

```
Stage-1 coherence-immune factor   6⁸ · 4¹⁰ · 5⁴ = 1 100 753 141 760 000
after odd-order pinning                     3⁸ =             6 561
reduction                             2²⁸ · 5⁴ =   167 772 160 000

carried into STAGE1 Theorem A's fibered product (43 008 and 23 inherited,
NOT recounted):
  1 088 847 395 778 723 840 000  ->  43 008 · 23 · 3⁸ = 6 490 036 224
```

**This is not a bound on maps.** For a *fixed* `d` and a *fixed* map, fourteen
of the 22 rows have exactly one possible value and eight have exactly three; the
`μ`'s are invariants of the map, not choices (§2.4 "Honest scope").

## Exits

```
STAGE2-ODD-ORDER-PINNING-SEALED
STAGE2-IMMUNE-FACTOR-COLLAPSED
STAGE2-BASE-LOCUS-CONGRUENCES-SEALED
STAGE2-C11-QUADRUPLE-OBSTRUCTION
STAGE2-MINUS-LINE-PARITY
STAGE2-NO-DEGREE-EXCLUSION
STAGE2-FIRST-ORDER-CHARACTER-TABLE
```

`STAGE2-NO-DEGREE-EXCLUSION` is a **negative** exit: the congruence system is
consistent for every one of the 165 residues `mod 165` (and 330 `mod 330`).
No window closes.

## Timeline

| date | event |
|---|---|
| 2026-08-11 | packet produced: pinning theorem, the 22 rows, the consistency system, the residue table, the first-order layer |
| 2026-08-11 | landed on `agent/stage2-odd-order-pinning-20260810` (PR #37) |
| 2026-08-11 | adjudication: verifier replayed byte-identical, collapse independently re-derived, Stage-1 dependency adjudicated — `ADJUDICATION_PR37.md` |

## What is settled

* Theorem 1.2 (pinning): the value of `T` at a `g`-fixed stratum reached by a
  chain of relative weights `c_l` over a `g`-eigenpoint of weight `a_k` lies in
  the eigenspace of weight `d·a_k + Σ μ_l c_l (mod n)`, or is `0` (the row is a
  base point).
* Five base-locus congruences, all `d`, no hypotheses (§1.3).
* The `C11` quadruple obstruction (Thm 2.1); the `L_σ` parity `ord_{L_σ}(T) ≡
  d+1 (mod 2)`; the `C6`-band coupling `m ≡ d ≢ 0 (mod 3)` (Prop. 3.1).
* All three residual-group equivariance commutations proved, not refuted; the
  only non-commuting generator is the invisible `C6/C3` involution — which is
  exactly the surviving factor 3 per `C3`-row.

## What is open / handed on

* **The factor `3⁸`** — removing it needs a datum separating the `X^{C6}` point
  of a `C3`-eigenline from the two exact-`C3` points. Not attempted (§11.1).
* **No `μ` bounds.** Nothing here bounds `mult(T)` at a `C11`- or `A4`-point in
  terms of `d`; such a bound would turn Theorem 2.1 into a possible exclusion
  (§11.2).
* **The `d = 34` minus-line condition** is stated but not imposed on the
  covariant slice (§11.3).
* **`43 008` and `23` are inherited from Stage 1**, not recounted here; the
  collapsed total is only as good as those Stage-1 factors (§2.4).
