# Proposed registration for `goal_runs_20260811/D34_GUIDED_SWEEP`

**Not applied.** This session was told not to edit `NOTEBOOK.md` or
`notebook_build/manifest.json` (concurrent sessions race on them). The text
below is ready to paste by whoever holds the notebook lock; it should ride the
same commit as the packet, and `scripts/check_manifest_parity.py` should be run
before that commit lands.

**Adjudication note for the notebook holder.** This packet consumes
`STAGE2_ODD_ORDER_PINNING`, which at the time of writing lives only on the
branch `agent/stage2-odd-order-pinning-20260810` (only its `scripts/` are on
`main`). Registering this packet's headline before that branch lands would put
a `d ≤ 34` closure on `main` whose two load-bearing inputs are not on `main`.
Either land both together, or register this one with the dependency flagged.

---

## 1. Text to append to the `### E56 — FIX — Equivariant fixed-locus b-complex program` **Status** paragraph

> **The `d = 34` window is closed, 2026-08-11**
> (`goal_runs_20260811/D34_GUIDED_SWEEP`, `D34-WINDOW-EMPTY`; marker
> `D34_GUIDED_SWEEP_VERIFY_OK` + `ALLGREEN`, 72 checks, 0 failures). The first
> open window of the landing-covariant ladder — `d = 34`, `(m,r) = (1,6)`,
> `n = 28`, where the `FIX-P2` profile sweep measured slice dimension **16** —
> is **empty**. The cut is made by the two `STAGE2_ODD_ORDER_PINNING`
> base-locus rows that `FIX-P2` never imposed, both of which are
> profile-independent and hold for every landing covariant of degree 34:
> `T|_{L_σ} = 0` on all **55 minus-lines** (Prop. 1.4(i), `34` even) takes the
> slice `16 → 2`, and the contraction of each of the **110 `C3`-eigenlines**
> to the single `X^{C6}`-point lying on it (Prop. 1.6, `34 ≡ 1 mod 3`) takes it
> `2 → 0`. Full cascade, identical at `p = 67, 199, 331, 661`:
> `dim M_34 = 576 → 316` (plus-planes; `ord_{P_σ}(T⁺) ≥ 2` vacuous, the `H0-1`
> parity identity) `→ 16` (`ord_{ℓ_V} ≥ 6`) `→ 2` (minus-lines) `→ 0`
> (eigenlines); the `D10`-, `D12`- and `X^{C6}`-point blocks add nothing, as
> their containments predict. **All 30 admissible profiles at `d = 34` die at
> once**: every one has `m ≥ 1` and `r ≥ 6`, so its slice is contained in the
> `(1,6)` slice — one rank computation decides the degree. The ladder engine
> also re-runs `d = 31, 32, 33` here (all zero, reproducing `FIX-P2`), so the
> unconditional cutoff moves from **`d ≤ 30`** to **`d ≤ 34`**. The **new first
> open window is `d = 35`, `(m,r) = (1,6)`, `n = 29`, of dimension `≤ 39`**
> (`FIX-P2`'s 46 cut by 7). The `STAGE2` rows are much weaker there for a
> structural reason worth recording: `35` is odd, so the minus-lines are free,
> and `35 ≡ 5 (mod 6)`, so the `X^{C6}` pair is swapped rather than based —
> what `d = 35` gains instead (all 60 `X^{C11}` and all 264 `X^{C5}` points in
> `Bs(T)`, since `35 ≡ 2 mod 11` is a non-residue and `5 ∣ 35`) is only
> point-sized. **`d = 34` closed because it is the degree in the window that is
> even and `≡ 1 (mod 3)` — the two congruences whose conditions carry
> line-sized equivariant budgets.** Upper bounds through `d = 42` are tabulated
> (`35:39, 36:63, 37:121, 38:151, 39:218, 40:261, 41:343, 42:397`); nothing
> above 34 is excluded. Also sealed here, exactly and by two independent code
> paths (abstract character theory vs. brute force on the modular Weil frame,
> both in `F_P` with `P = 400291 ≡ 1 mod 330` and `P > 369075` so every
> dimension is read off uniquely): `dim M_34 = 576` and the equivariant
> condition budgets `N_plane = 324`, `N_minus = 18`, `N_line(6) = 732`,
> `N_c3 = 18`, `N_D10 = N_C6pt = N_D12pt = 1`. `STAGE1_COMPLEX_MAPS`'
> leading-datum count `N(34,1) = 397` and its published sample row are
> reproduced by the same machinery, and its prediction — *"the sieve's bite at
> `d = 34` must come from higher order or from the line-degree bookkeeping, not
> from the sweep datum"* — is **confirmed**: the plus-plane layer alone leaves
> 316 of 576. The landing system `F(T) ≡ 0` was never assembled; at `d = 34` it
> is vacuous, because the linear space it would have to live in is already zero.

## 2. Manifest record to append to `notebook_build/manifest.json` `records`

```json
{
 "path": "goal_runs_20260811/D34_GUIDED_SWEEP",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "D34-WINDOW-EMPTY",
 "superseded_by": null,
 "char0_scope": "The dimension ledger is characteristic-free: all characters are evaluated exactly in F_P for P = 400291, which satisfies P = 1 mod 330 (every root of unity of every element order in {1,2,3,5,6,11} is present, 1/660 is a unit) and P > 5*C(38,4) = 369075, so every dimension - an integer in [0, 369075] - is determined uniquely by its residue; no floating point and no cyclotomic-field arithmetic anywhere, and two independent code paths (abstract character theory of PSL(2,11), D12 = C2 x S3, A4, C6, D10 vs. brute force on the 660 explicit Weil matrices with symmetric-power characters read off char polys) agree on every entry. The slice computations are exact modular linear algebra over F_p for p = 67, 199, 331, 661 (all = 1 mod 33, none dividing 660); the characteristic-zero bridge is the FIX-P1/FIX-P2 one, rank mod p <= rank over K, so a computed dimension of 0 is a genuine char-0 emptiness statement while a nonzero computed dimension is an upper bound only, and sampling a subset of the functionals of a vanishing condition only enlarges the computed kernel. Every EMPTY verdict here (d = 31, 32, 33, 34) is therefore characteristic zero; every ALIVE dimension (d = 35..42) is an upper bound. The geometric inputs consumed are the Tier-1 propositions of STAGE2_ODD_ORDER_PINNING (Props 1.3, 1.4(i), 1.6, Cor 1.5, B(D10), B(D12), Lemma 1.1), whose frame-level hypotheses are re-verified here at four primes (X^{C6} = the weight-{1,5} pair with F vanishing exactly, |Stab_G(ell_w)| = 6, dim W^{D12} = 1 with the fixed point off X, the D10-point off X) and one of whose consequences is exercised as a live control (the functionals annihilating W_w have rank 0 on all of M_34, as Lemma 1.1 predicts).",
 "tracked": "main",
 "notes": "Closes the first open window of the landing-covariant ladder. FIX-P2 left d = 34, (m,r) = (1,6), n = 28 at slice dimension 16; imposing the two STAGE2 base-locus rows FIX-P2 never imposed - T|_{L_sigma} = 0 on the 55 minus-lines (Prop 1.4(i), 34 even) and the contraction of the 110 C3-eigenlines to their own X^{C6}-point (Prop 1.6, 34 = 1 mod 3) - takes 16 -> 2 -> 0. Cascade dim M_34 = 576 -> 316 -> 316 (vacuous, H0-1 parity) -> 16 -> 2 -> 0, identical at p = 67, 199, 331, 661, with saturation and two unit controls. All 30 admissible profiles at d = 34 have m >= 1 and r >= 6, so all are contained in the (1,6) slice: DEGREE 34 IS EMPTY. d = 31, 32, 33 re-run here and zero, so the unconditional cutoff moves from d <= 30 to d <= 34. New first open window: d = 35, (1,6), n = 29, dim <= 39. Upper bounds through d = 42 tabulated. Exact dimension ledger sealed by two independent paths: dim M_34 = 576, N_plane = 324, N_minus = 18, N_line(6) = 732, N_c3 = 18, N_D10 = N_C6pt = N_D12pt = 1; STAGE1's N(34,1) = 397 and sample row reproduced and its d = 34 prediction confirmed. The landing system F(T) = 0 was never assembled - at d = 34 it is vacuous, not skipped. DEPENDENCY FLAG: the two load-bearing propositions live in STAGE2_ODD_ORDER_PINNING, currently on branch agent/stage2-odd-order-pinning-20260810 and not on main. Marker D34_GUIDED_SWEEP_VERIFY_OK + ALLGREEN, 72 checks, 0 failures. No headline; Problem E remains OPEN; no degree above 34 is excluded."
}
```

## 3. Secondary exits (for the exit ledger lens)

```text
D34-ONESIX-EMPTY               the (1,6), n = 28 slice is zero (THEOREM.md sec.3)
D34-MINUS-LINE-CUT             Prop 1.4(i) takes the slice 16 -> 2
D34-EIGENLINE-CUT              Prop 1.6 takes it 2 -> 0
LADDER-EMPTY-THROUGH-34        d <= 34 empty (31-33 re-run, 25-30 consumed)
D35-FIRST-OPEN-WINDOW          d = 35, (1,6), n = 29, dim <= 39
D34-DIMENSION-LEDGER-SEALED    exact equivariant bookkeeping, two independent paths
STAGE2-ROWS-ARE-EFFECTIVE      the new base-locus rows are not vacuous on the slice
STAGE1-N34-PREDICTION-CONFIRMED  N(34,1) = 397 reproduced; the bite is at the line layer
```

No positive exit is named because nothing is constructed, and no exclusion
exit is named for any degree above 34 because none occurs.

## 4. Remainder note (for the certificates lens)

Closed: `STAGE2_ODD_ORDER_PINNING` §11 remainder 3 ("the `d = 34` minus-line
condition is stated but not imposed on the covariant slice") — it is imposed
here, and it is what closes the window.

Created:

* **`d = 35`, `(1,6)`, `n = 29`, `dim ≤ 39`** — the new first open window.
* **`d = 36`, `dim ≤ 63`** — where `3 ∣ d` puts all 110 `C3`-eigenlines and `d`
  even puts all 55 minus-lines in `Bs(T)`, yet the slice only drops `83 → 63`.
* **The corank-2 gap in the minus-line block**: the restriction
  `M_34 → (Sym^34(W⁻)* ⊗ W)^{D12}` has rank 16 against a budget of 18; which
  two `D12`-isotypic pieces are missed is not determined here.
* **Degrees `> 42`** untouched.
