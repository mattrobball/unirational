# Proposed registration for `goal_runs_20260810/STAGE2_ODD_ORDER_PINNING`

**Not applied.** This session was told not to edit `NOTEBOOK.md` or
`notebook_build/manifest.json` (concurrent sessions race on them). The text
below is ready to paste by whoever holds the notebook lock; it should ride the
same commit as the packet, and `scripts/check_manifest_parity.py` should be run
before that commit lands.

---

## 1. Text to append to the `### E56 — FIX — Equivariant fixed-locus b-complex program` **Status** paragraph

> **Stage-2 odd-order pinning landed 2026-08-11**
> (`goal_runs_20260810/STAGE2_ODD_ORDER_PINNING`,
> `STAGE2-ODD-ORDER-PINNING-SEALED`; marker
> `STAGE2_ODD_ORDER_PINNING_VERIFY_OK` + `ALLGREEN`, 95 checks at `p = 331` and
> `p = 661`). The first Stage-2 computation. It takes the `1.1 × 10¹⁵`
> coherence-immune factor `STAGE1_COMPLEX_MAPS` §15.5 isolated — the 22 rows of
> the terminus whose exact stabiliser has odd order — and **pins it by exact
> character arithmetic**. Master statement: for a landing covariant
> `T ∈ (Sym^d W* ⊗ W)^G` (no character twist: `G` is perfect) and any `g` of
> order `n`, the value at a `g`-fixed stratum reached by a chain of exceptional
> directions of relative weights `c_l` over a `g`-eigenpoint of weight `a_k`
> lies in the eigenspace of weight `d·a_k + Σ μ_l c_l (mod n)`, `μ_l` the
> successive jet orders — **or is zero, i.e. the row is a base point**.
> Consequences: the four `C11`-rows and all ten `C5`-rows collapse to **exactly
> one** value each (`5⁴ · 4¹⁰ = 655 360 000 → 1`); the eight `C3`-rows over the
> `A4`-points collapse from six values to **three** (`6⁸ → 3⁸`), the residual
> factor 3 being exactly the `C6/C3` involution that an odd-order source row
> cannot see. Immune factor `1 100 753 141 760 000 → 3⁸ = 6 561`, reduction
> `2²⁸·5⁴ = 167 772 160 000`; the stratum-coherent order-0 count drops from
> `1 088 847 395 778 723 840 000` to `43 008 · 23 · 3⁸ = 6 490 036 224` (the
> `σ`-band factor 43 008 and the `D10` factor 23 are carried unchanged from
> Stage 1, not recounted).
> Five base-locus congruences are **proved and sealed**: `X^{C11} ⊆ Bs(T)` iff
> `d` is not a quadratic residue mod 11; `X^{C5} ⊆ Bs(T)` iff `5 ∣ d`; both
> `C3`-eigenlines in `Bs(T)` iff `3 ∣ d`; and the `D10`- and `D12`-points in
> `Bs(T)` for **every** `d` — the last two re-deriving the sealed
> indeterminacy corollaries by pure character arithmetic. New: **all 55
> minus-lines `L_σ` lie in `Bs(T)` whenever `d` is even**, and
> `ord_{L_σ}(T) ≡ d+1 (mod 2)` — the exact mirror of the sealed plus-plane
> parity `H0-1`, which the sealed profile did not record; `X^{C6} ⊆ Bs(T)`
> unless `d ≡ ±1 (mod 6)`, with `T` fixing the `ρ`-fixed pair when `d ≡ 1` and
> swapping it when `d ≡ 5`; the **`C11` quadruple obstruction** (all four
> `C11`-rows carry a value simultaneously iff `d` is a QR mod 11 and
> `μ ≡ 0` or `d`; at most three if `d` is a non-residue, at most two if
> `11 ∣ d`); and the `C6`-band coupling **`m ≡ d ≢ 0 (mod 3)`** for the six
> `C6`-children of `D_{P_σ}` to be non-degenerate. The three equivariance
> commutations the brief demanded are **proved, not refuted**: the `F55`
> 5-cycle at `C11`, the `D10` inversion at `C5` and the `D12/C3` eigenline swap
> all commute with `a ↦ d·a` (they are multiplications in an abelian group);
> the only non-commuting residual generator is the invisible `C6/C3`. First
> order: `dT` preserves the relative weight and `ker(dF)` kills the block
> `−3a_i`, whence `dT ≡ 0` at every `C11`-point when `d ≡ 3 (mod 11)`, rank
> `≤ 1` when `d ≡ 4,5,9`, and rank `≤ 2` at `X^{C6}` when `d ≡ 5 (mod 6)`.
> **NO DEGREE IS EXCLUDED** (`STAGE2-NO-DEGREE-EXCLUSION`): all 165 residues
> `mod 165` (and all 330 `mod 330`) are consistent — independently confirming
> the repository's own adjudication of the unsealed external mod-330 sieve
> (`COMBINED_DEGREE_SIEVE/CONSTRAINT_LEDGER.md` B1/B2, EXCLUDED), whose
> base-locus content is now proved rather than proposed. The sealed windows are
> therefore unchanged: `d ≤ 30` empty, `d = 25` dead, **`d = 34` still the first
> open window** — but `d = 34` now carries two conditions the `FIX-P2` slice
> sweep did not impose: all 55 minus-lines in the base locus with odd order,
> and both `X^{C6}` points in the base locus. Its own profile `m = 1` does
> satisfy the new `C6`-band condition `m ≡ d ≡ 1 (mod 3)`.

## 2. Manifest record to append to `notebook_build/manifest.json` `records`

```json
{
 "path": "goal_runs_20260810/STAGE2_ODD_ORDER_PINNING",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "STAGE2-ODD-ORDER-PINNING-SEALED",
 "superseded_by": null,
 "char0_scope": "The pinning theorem and every congruence consequence are pure integer arithmetic in Z/n (n = 3,5,6,11) and Z/165, computed by two independent code paths (closed form vs global-monomial enumeration; 47736 cases, 0 mismatches) - characteristic-free, no primes involved, no floating point anywhere. The geometric inputs it consumes are the exact characteristic-zero rows of RECEIVER_LEDGER_X: all five C11-eigenpoints on X (combinatorial: no monomial of F is a cube), the four non-trivial C5-eigenpoints on X (exact identity sum_i w^(3i+1) = 0), the two X^{C6} points on L_t (F|_{W^-} = 0 exactly over Q(zeta_11)), and the D10-, D12- and A4-points off X (non-vanishing of F, itself a char-0 certificate). The two split primes p = 331 and p = 661 (both with 330 | p-1, so every element order in {1,2,3,5,6,11} is diagonalisable over F_p and p does not divide |G| = 660) are used ONLY as an independent regression of those sealed rows and for the brute-force covariant module: dim_{F_p}(Sym^d W* (x) W)^G equals the characteristic-zero dimension because p does not divide |G|, and the computed values 1,0,0,2,1,2,4 for d = 1..7 reproduce the sealed exact Molien row of certificates/exact_covariants_check.py:53 at both primes. The A4-point normal characters are derived in char 0 from W|_{A4} = omega + omega^2 + Theta and independently matched against the sealed TERMINUS_STRATA_PW table and against the F_p eigenbases at both primes.",
 "tracked": "main",
 "notes": "First Stage-2 computation for Problem E. Pins the coherence-immune odd-order rows of the terminus Z by degree congruences. Master formula: for T in (Sym^d W* (x) W)^G (no character twist, G perfect) and g of order n, the value at a g-fixed stratum over the weight-a_k eigenpoint reached by exceptional directions of relative weights c_l lies in the eigenspace of weight d*a_k + sum mu_l c_l mod n, or is zero. Collapses the 22 immune rows: 4 C11-rows and 10 C5-rows to ONE value each, 8 C3-rows from six values to three; immune factor 1100753141760000 -> 3^8 = 6561, reduction 2^28 * 5^4. Seals five base-locus congruences (X^{C11} in Bs iff d is not a QR mod 11; X^{C5} in Bs iff 5|d; the 110 C3-eigenlines in Bs iff 3|d; the 66 D10-points and 55 D12-points in Bs for every d - the latter two re-deriving the sealed indeterminacy corollaries by character arithmetic alone). NEW: all 55 minus-lines in Bs(T) when d is even, with ord_{L_sigma}(T) = d+1 mod 2 (mirror of the sealed plus-plane parity H0-1); X^{C6} in Bs unless d = +-1 mod 6; the C11 quadruple obstruction; the C6-band coupling m = d != 0 mod 3; mult >= 1 at the ell_V direction over an A4-point. The F55, D10 and D12/C3 residual equivariances are PROVED to commute with a -> d*a. First-order character table of admissible differential blocks (dT vanishes at all 60 C11-points when d = 3 mod 11; rank <= 2 at X^{C6} when d = 5 mod 6). NO DEGREE IS EXCLUDED: all 165 residues consistent, confirming the earlier adjudication of the unsealed mod-330 sieve (COMBINED_DEGREE_SIEVE/CONSTRAINT_LEDGER.md B1/B2). Sealed windows unchanged (d <= 30 empty, d = 25 dead, d = 34 first open) but d = 34 gains two base-locus conditions not imposed by the FIX-P2 slice sweep. Marker STAGE2_ODD_ORDER_PINNING_VERIFY_OK + ALLGREEN, 95 checks. No contradiction with any sealed certificate."
}
```

## 3. Secondary exits (for the exit ledger lens)

```text
STAGE2-IMMUNE-FACTOR-COLLAPSED        6^8 * 4^10 * 5^4 -> 3^8
STAGE2-BASE-LOCUS-CONGRUENCES-SEALED  the five corollaries of THEOREM.md 1.3
STAGE2-C11-QUADRUPLE-OBSTRUCTION      Theorem 2.1
STAGE2-MINUS-LINE-PARITY              ord_{L_sigma}(T) = d + 1 (mod 2)
STAGE2-FIRST-ORDER-CHARACTER-TABLE    Proposition 6.1
STAGE2-NO-DEGREE-EXCLUSION            Theorem 4.1  (NEGATIVE exit)
```

`STAGE2-NO-DEGREE-EXCLUSION` is deliberately a **negative** exit: the brief asked
whether the congruence system produces a degree-exclusion theorem, and the
answer, proved and machine-verified, is **no**. No congruence-exclusion exit is
named because no exclusion occurs.

## 4. Remainder note (optional, for the certificates lens)

Nothing is closed by this packet, and nothing sealed is contradicted. Two
remainders are **created**:

* the residual factor `3⁸` on the eight `C3`-rows over the `A4`-points, which
  needs a second-order datum (or a global one) to remove;
* the `d = 34` minus-line base-locus condition (`THEOREM.md` §5), which is
  stated but not imposed on the `(1,6)`, `n = 28` covariant slice.
