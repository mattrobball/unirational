# The per-support saturation gate, made replayable

**Date:** 2026-08-11
**Status of the criterion itself:** **ALREADY SEALED** —
`F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`, Theorem 3.2. Round 6 restates
it; it is not new and is not re-sealed here.
**What is new:** an exact, self-contained, two-engine replay with six worked
supports, run in **both** directions.

---

## 1. The gate

With `M = Z^5/Z(1,1,1,1,1)`, `a = sum_{s in S} A_s chi^s`, and

```text
F_gamma = sum_{i, p<=q, r in S, T_i(p,q;r)=gamma} mu(p,q) A_p A_q A_r,
T_i(p,q;r) = sigma^i(p + q + sigma r - e_2),   mu(p,q) = 1 if p=q else 2,
I_S = (F_gamma),   m_S = prod_{s in S} A_s,
```

Theorem 3.2 says: a trace-cubic zero with support **exactly** `S` exists over
`C` if and only if `I_S : m_S^inf != (1)`; nonexistence is certified by one
identity `m_S^N = sum H_gamma F_gamma`.

Two facts about the gate worth keeping in view:

* it is an **exact characteristic-zero decision procedure per support** — a
  Gröbner basis, primary decomposition or numerical solution set need not be
  retained, only the monomial identity;
* it is **not** a classification of supports. The universally quantified
  statement is the headline itself (`COVERAGE_RELATION.md`).

## 2. Implementation

`verify_saturation_supports.py` (pure `python3`, exact `Fraction` arithmetic,
no external CAS):

* **C0 — compiler regression.** Every row is built twice: once by the
  Proposition 3.1 formula, once by literal Laurent expansion of
  `chi^{-e_2} a^2 sigma(a)` in the group algebra followed by the five
  `sigma`-shifts. The two must agree row for row.
* **C2 — the gate.** `I_S : m_S^inf = (1)` is decided by the Rabinowitsch test
  `1 in I_S + (1 - t m_S)` over `Q`, using a self-contained Buchberger engine
  (degrevlex, coprime-lead-term criterion).
* **Both directions.** For each support the script extracts a
  deletion-minimal subset of rows that is already unit after saturation, then
  deletes one row of that subset and produces an **explicit exact torus point**
  of the remainder (over `Q` or `Q(i)`), re-substituting it into every retained
  row and into the deleted row.

Cross-engine: `crosscheck.m2` runs `saturate(I_S, m_S)` in Macaulay2 for
`S2, S3, S4, S5` and prints agreement.

## 3. Worked supports — authoritative twist `e_2`

| support | rows | gate | minimal unit core |
|---|---|---|---|
| `S1 = {0}` | 5 | `(1)` | one row, `A0^3` |
| `S2 = {0, e_0}` | 30 | `(1)` | one row, `A1^3` |
| `S3 = {0, e_0-e_1}` | 30 | `(1)` | one row, `A1^3` |
| `S4 = {e_0, e_1}` (the `r_0-r_1` chain segment) | 25 | `(1)` | one row, `A0 A1^2` |
| `S5 = {0, e_0, e_1}` | 61 | `(1)` | two rows, `2A0A1A2 + A0A2^2` and `A1^2A2 + A2^3` |
| `S16` (Coverage-C, 16 points) | 1115 | `(1)` | four rows, by identity (2.2) |

`S1` is Lemma 2.3 made mechanical: the five output exponents are the
`sigma`-orbit of `-e_2`, of size exactly five because `M^sigma = 0`, and every
compiled coefficient is a positive integer — so a monomial is never a zero.

`S2`–`S4` fall to alternative (i) of the polar-circuit list: a **singleton
row** appears. `S5` needs two rows. These are the cheap cases, and they are
included precisely to show what the cheap cases look like.

## 4. The substantive support: Coverage-C's 16-point core

`S16` is (2.1) of `F55_COVERAGE_C_ADJUDICATION_20260808.md`, the
deletion-minimal degree-four core on which alternatives (i)–(iii) all fail.
This packet's compiler rebuilds it **from scratch** and independently
reproduces:

```text
the 16 listed points stay distinct in M                                  OK
C0 regression on all 1115 rows                                           OK
Coverage-C (1): no nonzero row of S16 is a singleton      0 singleton rows
Coverage-C (2): deleting any one point creates a singleton row           OK
```

and the four rows of identity (2.2), each occurring five times (once per
`sigma`-orbit):

```text
f1 = A0^2 A8  + A6^2 A15
f2 = A0^2 A11 + 2 A3 A6 A15
f3 = 2 A0 A2 A8  + A6^2 A9
h  = 2 A0 A2 A11 + 2 A0 A4 A8 + 2 A3 A6 A9
```

and the identity itself, by exact expansion:

```text
A0 A6 h - 2 A2 A6 f2 - 2 A0 A3 f3 + 4 A2 A3 f1 = 2 A0^2 A4 A6 A8.
```

The right-hand side is a monomial, a unit on the coefficient torus, so this is
a certificate of shape (3.1) with `N` small — the gate returns `(1)` **without
any Gröbner basis**, on a 16-variable support that no Buchberger run of this
size would reach.

## 5. The gate running the other way

The mission asked for a support on which the gate returns a proper ideal. For
the authoritative twist `e_2` no such support is known, and this is not an
accident: **one would be a `K`-point of the F55 trace cubic and would settle
Problem E positively.** Recording a fake one would be dishonest. A search over
all two-point supports `{0,m}` with `m` and the twist exponent both ranging
over the 81-element box `{-1,0,1}^4` in `M` (6,480 exact saturations, 296 s)
found **no** non-unit case.

What is exhibited instead is the gate flipping on **real F55 rows**, which is
what makes it a decision procedure rather than a one-way filter:

* On `S16`, drop the row `h` from the four-row circuit. The remaining system
  `{f1, f2, f3}` has the exact torus point

  ```text
  A0=A2=A3=A4=A6=A15=1,  A8=-1,  A9=2,  A11=-2,  all other A_k = 1,
  ```

  every coordinate a unit; all three retained rows vanish there, so
  `(f1,f2,f3) : m^inf != (1)`. The deleted row evaluates to `h = -2 != 0`.
  `h` is the load-bearing row of the circuit.
* The same flip is produced automatically for `S1`–`S5`: delete one row of the
  minimal core and the script returns a proper ideal together with an explicit
  torus point (for `S5` the point is `(1, 1, i)` over `Q(i)`, since the reduced
  system is `A2(A1^2 + A2^2) = 0`), and confirms the deleted row is nonzero
  there.

So the procedure is verified live in both directions, on the real compiler,
without inventing a positive instance that does not exist.

## 6. Replay

```bash
cd problems/E-klein-cubic/goal_runs_20260811/F55_TROPICAL_INSUFFICIENCY
python3 verify_saturation_supports.py     # ~2 min   -> F55_SATURATION_SUPPORTS_OK
M2 --script crosscheck.m2                 # ~10 s
```

Logs: `logs/saturation_supports.txt`, `logs/crosscheck_m2.txt`.
