# Proposed registration for `goal_runs_20260810/RECEIVER_LEDGER_X`

**Not applied.** This session was told not to edit `NOTEBOOK.md` or
`notebook_build/manifest.json` (concurrent sessions race on them). The text
below is ready to paste by whoever holds the notebook lock; it should ride the
same commit as the packet, and `scripts/check_manifest_parity.py` should be run
before that commit lands.

---

## 1. Text to append to the `### E56 — FIX — Equivariant fixed-locus b-complex program` **Status** paragraph

> **Receiver ledger landed 2026-08-10** (`goal_runs_20260810/RECEIVER_LEDGER_X`,
> `RECEIVER-LEDGER-X-PASS`; markers `PRODUCE_LEDGER_OK` 55 checks,
> `RECEIVER_LEDGER_X_VERIFY_OK` + `ALLGREEN` 101 checks,
> `LEDGER_IDEALS_M2_OK` 32/32): the **target-side** companion of FIX-A2 —
> one row per conjugacy class of subgroups for `X^H`, all 16 closed. New exact
> rows: **`X^{C3}` is six reduced points** (the isolated `C3`-fixed point of
> `P⁴` is the `D12`-point and is **off `X`**; each of the two eigenlines meets
> `X` in 3 distinct points = 1 `C6`-point + 2 with exact stabiliser `C3`;
> residual `D12/C3 ≅ V4` acts with orbits `2 + 4`); **`X^{C6}` = 2 points, both
> on the minus-line `L_t`** (the two `C6`-eigenpoints with involution eigenvalue
> `−1`), one free residual 2-orbit; **`X^{S3} = ∅` for both `S3` classes**
> (`P(W)^{S3}` is the single `D12`-point, off `X`); **`X^{C11}` = 5 points, all
> on `X`, one free `F55/C11` 5-cycle**. Sealed rows replayed by two further
> independent routes (`p = 331, 661` brute-force point counts, and a Macaulay2
> ideal route `X^H = V(F) + Σ minors₂(x | g·x)` that also certifies **every** row
> radical, closing the `C3`-reducedness remainder named in `STRATA_EXACT.md §6.1`
> and `NORMAL_CHARACTERS.md §5.1`). Consequences: **Corollary C3** — for every
> representation `V` and every `G`-equivariant `φ : P(V) ⇢ X`, the linear
> subspace `P(V^{C3})` lies in the indeterminacy locus (hypotheses: `X^{C3}`
> finite, `X^{D12} = ∅`, and `dim V^{C3} ≥ 1` for all eight irreducibles, with
> multiplicities `1,1,1,4,4,3,4,4` derived without a character table and checked
> against `Σ mᵢdᵢ = 220`); and the **receiver dichotomy** — `X^{N_G(H)} = ∅` for
> **every** `H`, and `X^H` is finite for every `H` except `H = 1` and `H = C2`,
> so exactly two rows are blocked: `1` (by `X` itself, RCC and `G`-stable) and
> `C2` (**by `L_σ ≅ P¹` only**; `E_σ` with `j = 8192/11` is non-CM elliptic and
> therefore not RCC). The 55-orbit of minus-lines is the **only**
> positive-dimensional rational target anywhere in the equivariant fixed-locus
> system of `X`. No contradiction with any sealed certificate; FIX-A2's 16-class
> layer, FIX-A0's `X^σ = E_σ ⊔ L_σ` with `j = 8192/11`, and FIX-A1's six reduced
> `V4`-points with `X^{A4} = ∅` are all re-derived independently and agree
> exactly (including FIX-A1's inert-prime finding: 0 `F_p`-rational type-II
> points at 331 **and** 661, 3 geometric).

## 2. Manifest record to append to `notebook_build/manifest.json` `records`

```json
{
 "path": "goal_runs_20260810/RECEIVER_LEDGER_X",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "RECEIVER-LEDGER-X-PASS",
 "superseded_by": null,
 "char0_scope": "Exact characteristic zero throughout for the geometry: producer works in K = Q(zeta_165) = Q(zeta_3) (x) Q(zeta_5) (x) Q(zeta_11), degree 80, exact Fraction arithmetic, no modular reduction; verifier Part A rebuilds the representation independently over Q(zeta_11) and establishes every 'lies on X' claim exactly (with purely combinatorial arguments for the C5 and C11 eigenpoints). Two split primes p = 331 and p = 661 (both = 1 mod 165, so every element of G is diagonalisable over F_p) are used only for (i) regression of the exact results by brute-force enumeration of P^1(F_p)/P^2(F_p), and (ii) non-vanishing certificates for every 'off X' point, which are themselves char-0 proofs. Macaulay2 ideal route over GF(331) and GF(661) confirms dimension, degree and radicality of all 16 rows.",
 "tracked": "main",
 "notes": "Target-side fixed-locus ledger: X^H for every one of the 16 conjugacy classes of subgroups of G = PSL(2,11) acting on the Klein cubic threefold. Receiver companion of FIX-A2's source-side P(W)^H. NEW rows: X^{C3} = 6 reduced points with the isolated C3-fixed point (= the D12-point) OFF X, residual D12/C3 = V4 acting with orbits 2+4; X^{C6} = 2 points, both on the involution minus-line L_t, one free residual 2-orbit; X^{S3} = empty for BOTH S3 classes (P(W)^{S3} is the single D12-point); X^{C11} = 5 points all on X, a single free F55/C11 5-cycle. Sealed rows replayed: X^{C2} = E_sigma (smooth, j = 8192/11 via the exact Hesse parameter t = -16/11, non-CM, plus a_p twist match at 331/661) disjoint union L_sigma = P^1 in X; X^{V4} = 3 type-I + 3 type-II reduced points, two free residual C3-orbits, X^{A4} = empty; X^{C5} = 4 points paired freely by the D10 reflection; X^{D10} = X^{D12} = X^{F55} = X^{A5} = X^G = empty. Consequences: Corollary C3 (P(V^{C3}) is in the indeterminacy locus of every equivariant P(V) --> X, non-vacuous because dim V^{C3} >= 1 for all eight irreducibles) and the receiver dichotomy (X^{N_G(H)} = empty for EVERY H; X^H finite for every H except 1 and C2; the only blockers are X itself and the rational curve L_sigma). Closes the C3-reducedness remainder named in STRATA_EXACT.md 6.1 and NORMAL_CHARACTERS.md 5.1. Markers PRODUCE_LEDGER_OK (55 checks), RECEIVER_LEDGER_X_VERIFY_OK + ALLGREEN (101 checks), LEDGER_IDEALS_M2_OK (32 row checks). No contradiction with any sealed certificate."
}
```

## 3. Remainder-closure note (optional, for the certificates lens)

`certificates/STRATA_EXACT.md §6` remainder 1 and
`certificates/NORMAL_CHARACTERS.md §5` remainder 1 ("C3 residual 220 points on
`X`: scheme-theoretic reducedness not sealed") can be marked **CLOSED by
`goal_runs_20260810/RECEIVER_LEDGER_X`**: the binary-cubic discriminant of
`F` restricted to a `C3`-eigenline is non-zero exactly in `K = Q(zeta_165)`, and
the `C3` row ideal is equal to its radical in Macaulay2 over `GF(331)` and
`GF(661)`, with projective dimension 0 and degree 6.
