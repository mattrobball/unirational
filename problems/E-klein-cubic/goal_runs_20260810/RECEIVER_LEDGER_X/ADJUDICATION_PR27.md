# Adjudication of PR #27 — `agent/receiver-ledger-x-20260810`

**Date:** 2026-08-11. **Adjudicator:** independent session, working on the PR
branch only (no merge to `main`).
**Verdict: READY-WITH-TRIMS → now READY.** One arithmetic slip fixed in place,
one scope disclaimer added where the packet summarises, one independent
cross-check added. **No claim refuted.**

Problem E headline: **OPEN**, unchanged by this PR and by this adjudication.

---

## 0. What was replayed

The whole pipeline was re-run from a clean copy of the packet with all
`results/` and the generated `scripts/ledger_ideals.m2` deleted first:

```sh
python3 scripts/produce_ledger.py     # PRODUCE_LEDGER_OK, 55 checks, 0 failures
python3 scripts/emit_m2.py
M2 --script scripts/ledger_ideals.m2  # LEDGER_IDEALS_M2_OK, 32/32
python3 verifier.py                   # RECEIVER_LEDGER_X_VERIFY_OK + ALLGREEN
```

`results/ledger_exact.json`, `results/verifier_output.json`,
`results/m2_ledger_ideals.txt` and the generated `scripts/ledger_ideals.m2`
came back **byte-identical** to the committed artifacts (`diff` empty on all
four). Only wall-clock timings differ in the stdout logs. Exit codes 0
throughout. The checks are substantive, not vacuous: Part B counts points by
brute-force enumeration of `P^1(F_p)`/`P^2(F_p)`, Part E ingests a Macaulay2
run whose ideals are built independently, and every "off `X`" claim rests on a
non-vanishing mod `p` (a characteristic-zero proof).

## 1. Per-claim verdicts

### The 16 rows

| claim | verdict | how checked |
|---|---|---|
| 16 conjugacy classes, 620 subgroups, class sizes `1,55,55,55,66,55,55,55,66,12,55,55,12,11,11,1` | **CONFIRMED** | re-added by hand (= 620); each class size independently equals `\|G\|/\|N_G(H)\|` and matches the element-order profile (110 order-3 elements ⇒ 55 `C3`s, 264 order-5 ⇒ 66 `C5`s, 120 order-11 ⇒ 12 `C11`s, …) |
| every `C_G(H)`, `N_G(H)` in the table | **CONFIRMED** | `\|G\|/\|N_G(H)\|` reproduces `#conj` in all 16 rows |
| row 0 — `X^1 = X`, RCC, `G`-stable, not rational | **CONFIRMED** | classical (Clemens–Griffiths) |
| row 1 — `X^{C2} = E_sigma ⊔ L_sigma`, `L_sigma ⊂ X` rational, `E_sigma` smooth genus 1 with `j = 8192/11`, non-CM, residual `S3` acting as `std` on `W^-` and `triv ⊕ std` on `W^+` | **CONFIRMED** | matches the sealed `FIX-A0-ARRANGEMENT-PASS` line by line (`goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT/STATUS.md` claims 1–5); replayed here by a third and fourth route (`t = -16/11` exactly; `a_p` twist match at 331 and 661) |
| row 2 — `X^{C3}` = 6 reduced points; isolated `C3`-point = the `D12`-point and **off `X`**; each eigenline meets `X` in 3 distinct points = 1 `C6`-point + 2 with exact stabiliser `C3`; residual `V4` orbits `2 + 4` | **CONFIRMED** | three routes in-packet, plus two independent arguments added here (§2 below): the `C6`-character bookkeeping and a topological Lefschetz count |
| row 3 — `X^{V4}` = 6 reduced points (3 type-I + 3 type-II), two free residual `C3`-orbits | **CONFIRMED** | matches sealed `FIX-A1-V4-REPAIR-PASS` and `FIX-A0` §6(b),(c) (165 vertices; each `V4`-line meets `X` in 3 distinct points) |
| row 4 — `X^{C5}` = 4 points, `[1:1:1:1:1]` off `X` (`F = 5`) | **CONFIRMED** | one-line exact argument re-derived independently: `F(v(w)) = w·Σ_i w^{3i} = 0` since `3` is invertible mod 5; Lefschetz gives 4 |
| rows 5,6 — `X^{S3} = ∅` for **both** classes | **CONFIRMED** | `W_triv ⊕ W_sgn ⊆ W^{C3}`, and `dim W^{C3} = 1` follows from `chi_W(3A) = -1` alone; the surviving point is the `D12`-point, off `X`. The "exactly two classes, not fused" argument (both are index-2 in `D12 ≅ C2 × S3`, sharing its `C3`) is correct |
| row 7 — `X^{C6}` = 2 points, both on `L_t` | **CONFIRMED** | `W\|_{C6} = chi^0 ⊕ chi^1 ⊕ chi^2 ⊕ chi^4 ⊕ chi^5` reproduces `chi_W(2A) = 1`, `chi_W(3A) = -1`, `chi_W(6A) = 1`; the `t`-eigenvalue `-1` characters are exactly `chi^1, chi^5`, which span `W^-`, and `L_t = P(W^-) ⊂ X`. Lefschetz gives 2 |
| row 9 — `X^{C11}` = 5 points, all on `X`, one free 5-cycle | **CONFIRMED** | `F` has no `x_i^3` monomial, so every coordinate point is on `X`; the normalising `C5` acts on the eigen-exponents by multiplication by a quadratic residue, a 5-cycle. Lefschetz gives 5 |
| rows 8,10,11,12,13,14,15 — `X^H = ∅` | **CONFIRMED** | each reduces to a single non-vanishing (`D12`, `D10`, `A4` points) or to irreducibility of `W\|_H` (`F55`, `A5`, `G`); M2 returns the unit ideal after saturation at both primes |
| every row's ideal equals its own radical (all point counts are counts of **reduced** points) | **CONFIRMED** | M2 at `GF(331)` and `GF(661)`, 32/32; independently, non-zero binary-cubic discriminants exactly in `K` |
| closes the `C3`-reducedness remainder of `STRATA_EXACT.md §6.1` / `NORMAL_CHARACTERS.md §5.1` | **CONFIRMED** | the remainder is exactly "scheme-theoretic reducedness not sealed"; both the exact discriminant and the M2 radicality settle it |

### The global point-count table (§2)

**CONFIRMED.** Every line is consistent with orbit-stabiliser: type-I `165 =
660/4`, type-II `165`, `C6`-points `110 = 660/6`, exact-`C3` points `220 =
660/3` (and `220 = 110 eigenlines × 2`, matching the sealed
`certificates/orbit_hilbert_check.py` orbit of 220), `C5`-points `132 + 132 =
660/5 twice`, `C11`-points `60 = 660/11`. The incidence identity `X^{C3}`:
`55 × 6 = 330 = 110 + 220` holds.

### Corollary C3 (§5.1)

| claim | verdict |
|---|---|
| proof structure (irreducible `P(V^{C3})` → finite `X^{C3}` → constant → `N`-fixed → `X^{D12} = ∅`) | **CONFIRMED**. The indeterminacy locus of a `G`-equivariant rational map is `G`-stable, so `phi(n·q) = n·phi(q)` is legitimate on a dense open; the two dense opens `U` and `n^{-1}U` meet because `P(V^{C3})` is irreducible |
| `dim V^{C3} = 1,1,1,4,4,3,4,4` for the eight irreducibles, `Σ m_i d_i = 220 = [G:C3]` | **CONFIRMED** independently from the character table of `PSL(2,11)`: `dim V^{C3} = (chi(1) + 2·chi(3A))/3` with `chi(3A) = 1, -1, -1, 1, 1, -1, 0, 0` on degrees `1, 5, 5, 10, 10, 11, 12, 12`, giving `1,1,1,4,4,3,4,4` and `1+5+5+40+40+33+48+48 = 220` |
| non-vacuity for **every** non-zero `V` | **CONFIRMED** (immediate from the above) |

### The receiver dichotomy (§5.2, §5.3)

| claim | verdict |
|---|---|
| hypotheses (a)∧(b) hold for **fourteen of the sixteen** rows | **CONFIRMED** |
| `X^{N_G(H)} = ∅` for **every** `H` without exception, including `H = 1` | **CONFIRMED** (row by row: `D12`, `A4`, `D10`, `F55`, `A5`, `G` are all empty rows) |
| the two exceptions are exactly `H = 1` and `H = C2` | **CONFIRMED** |
| "(empty for **ten of the twelve** such classes)" | **FIXED-IN-PLACE** → "nine of the fourteen". There are `16 − 2 = 14` such classes, of which `S3(a), S3(b), D10, A4, D12, F55, A5(a), A5(b), G` = **9** are empty and `C3, V4, C5, C6, C11` = 5 are non-empty. §5.3's own tally ("nine rows", five non-empty rows) was already right; only the §5.2 parenthetical was wrong. Arithmetic slip, no mathematical content affected |
| `L_sigma` is the **only** positive-dimensional rational target in the whole equivariant fixed-locus system | **CONFIRMED**. Only rows 0 and 1 are positive-dimensional; `X` is RCC but irrational (Clemens–Griffiths), `E_sigma` has genus 1, `L_sigma ≅ P^1`. Note the packet correctly uses *RCC* (not *rational*) in hypothesis (a), which is what makes row 0 fail |

### Scope

| claim | verdict |
|---|---|
| the packet does **not** claim nonexistence of equivariant maps | **CONFIRMED** in `THEOREM.md` §0 ("Not proved here … anything about existence of equivariant maps into `X`") and §8 remainder 4 |
| the disclaimer is stated **where the packet summarises** | **FIXED-IN-PLACE**. It was absent from the `NOTEBOOK.md` entry and from the `manifest.json` `notes`, both of which state Corollary C3 and the dichotomy without qualification. An explicit scope sentence was added to both |

## 2. Independent cross-check added (verifier Part F)

The packet's three routes share one input: the `S, T` generators and hence the
660 matrices. A fourth route was added that uses **only traces**, so it is
insensitive to every eigenspace, discriminant, saturation and enumeration in
the packet.

`X` is a smooth cubic threefold, `G` is perfect (so it acts trivially on the
1-dimensional `H^0, H^2, H^4, H^6`), and Griffiths' residue calculus gives
`H^{2,1}(X) = (Sym(W^*)/Jac F)_1 = W^*`. Hence

```
L(g) = 4 − ( tr(g|W) + tr(g^{-1}|W) ) = chi_top(X^g),
```

the last equality because `X^g` is smooth for a finite-order automorphism.
Computed over `F_331` and `F_661` from the group matrices alone, `L` depends
only on the element order and equals

| order | 1 | 2 | 3 | 5 | 6 | 11 |
|---|---:|---:|---:|---:|---:|---:|
| `L(g)` | −6 | 2 | 6 | 4 | 2 | 5 |

`−6 = chi_top` of a smooth cubic threefold; `2 = chi(E_sigma) + chi(L_sigma) =
0 + 2`; and `6, 4, 2, 5` are exactly the `C3`, `C5`, `C6`, `C11` counts of §2.
The `C3` row therefore has a second, independent proof of its decisive point:
`#X^{C3} = 6`, each eigenline contributes a length-3 scheme, `3 + 3 = 6` leaves
no room, so the isolated `D12`-point is **off `X`** regardless of the exact
`F`-evaluation of §3.1.

Verifier count goes 101 → **107 checks, 0 failures**. Marker unchanged
(`RECEIVER_LEDGER_X_VERIFY_OK`, `ALLGREEN`).

## 3. Everything changed by this adjudication

1. `THEOREM.md` §5.2 — "ten of the twelve" → "nine of the fourteen".
2. `THEOREM.md` §6.1 — new subsection stating the Lefschetz cross-check and its
   standard inputs; §6 route table and marker line updated to 107 checks.
3. `verifier.py` — new Part F (6 checks at two primes).
4. `NOTEBOOK.md` — the registration blockquote was a dangling quote sitting
   *after* the `E56` entry's closing rule; it is now inside the `E56` **Status**
   paragraph, where `REGISTRATION_SNIPPET.md` §1 said it belonged. Scope
   disclaimer and adjudication pointer appended; check count updated.
5. `notebook_build/manifest.json` — merge with `origin/main` resolved (the
   `SPIN_SOURCE_NETWORK` record takes `main`'s newer `notes`; the
   `RECEIVER_LEDGER_X` record is preserved); `known_branches` union refreshed;
   `RECEIVER_LEDGER_X` `notes` gain the scope sentence and the adjudication
   record.
6. `REGISTRATION_SNIPPET.md` — the "Not applied" banner was stale (the branch
   *does* carry the notebook and manifest edits); replaced with an "APPLIED"
   banner that also records the original wording.
7. `REPLAY.md` — expected marker line updated to 107 checks.

Nothing in §§1–4 of `THEOREM.md` (the ledger itself), and no number in any
`results/` artifact, was altered.

## 4. Named remainders, unchanged

The four remainders of `THEOREM.md` §8 stand as written and are correctly
scoped. In particular remainder 4 — "Corollary C3 and the dichotomy of §5.2 are
statements about indeterminacy loci; they are **not** by themselves an
obstruction to equivariant unirationality, and no such claim is made" — is the
governing scope statement, and it is now echoed in the notebook and the
manifest.

## 5. Merge readiness

**READY.** `scripts/check_manifest_parity.py` passes at the final commit of
this branch.
