## 2026-08-11 THE d = 34 WINDOW CLOSES: the ladder cutoff moves to d <= 34; new first open window d = 35

Packet: `goal_runs_20260811/D34_GUIDED_SWEEP/`. Problem E remains **OPEN**.

**The `d = 34` window is closed, 2026-08-11**
(`goal_runs_20260811/D34_GUIDED_SWEEP`, `D34-WINDOW-EMPTY`; marker
`D34_GUIDED_SWEEP_VERIFY_OK` + `ALLGREEN`, 72 checks, 0 failures). The first
open window of the landing-covariant ladder — `d = 34`, `(m,r) = (1,6)`,
`n = 28`, where the `FIX-P2` profile sweep measured slice dimension **16** —
is **empty**. The cut is made by the two `STAGE2_ODD_ORDER_PINNING`
base-locus rows that `FIX-P2` never imposed, both of which are
profile-independent and hold for every landing covariant of degree 34:
`T|_{L_σ} = 0` on all **55 minus-lines** (Prop. 1.4(i), `34` even) takes the
slice `16 → 2`, and the contraction of each of the **110 `C3`-eigenlines**
to the single `X^{C6}`-point lying on it (Prop. 1.6, `34 ≡ 1 mod 3`) takes it
`2 → 0`. Full cascade, identical at `p = 67, 199, 331, 661`:
`dim M_34 = 576 → 316` (plus-planes; `ord_{P_σ}(T⁺) ≥ 2` vacuous, the `H0-1`
parity identity) `→ 16` (`ord_{ℓ_V} ≥ 6`) `→ 2` (minus-lines) `→ 0`
(eigenlines); the `D10`-, `D12`- and `X^{C6}`-point blocks add nothing, as
their containments predict. **All 30 admissible profiles at `d = 34` die at
once**: every one has `m ≥ 1` and `r ≥ 6`, so its slice is contained in the
`(1,6)` slice — one rank computation decides the degree. The ladder engine
also re-runs `d = 31, 32, 33` here (all zero, reproducing `FIX-P2`), so the
unconditional cutoff moves from **`d ≤ 30`** to **`d ≤ 34`**. The **new first
open window is `d = 35`, `(m,r) = (1,6)`, `n = 29`, of dimension `≤ 39`**
(`FIX-P2`'s 46 cut by 7). The `STAGE2` rows are much weaker there for a
structural reason worth recording: `35` is odd, so the minus-lines are free,
and `35 ≡ 5 (mod 6)`, so the `X^{C6}` pair is swapped rather than based —
what `d = 35` gains instead (all 60 `X^{C11}` and all 264 `X^{C5}` points in
`Bs(T)`, since `35 ≡ 2 mod 11` is a non-residue and `5 ∣ 35`) is only
point-sized. **`d = 34` closed because it is the degree in the window that is
even and `≡ 1 (mod 3)` — the two congruences whose conditions carry
line-sized equivariant budgets.** Upper bounds through `d = 42` are tabulated
(`35:39, 36:63, 37:121, 38:151, 39:218, 40:261, 41:343, 42:397`); nothing
above 34 is excluded. Also sealed here, exactly and by two independent code
paths (abstract character theory vs. brute force on the modular Weil frame,
both in `F_P` with `P = 400291 ≡ 1 mod 330` and `P > 369075` so every
dimension is read off uniquely): `dim M_34 = 576` and the equivariant
condition budgets `N_plane = 324`, `N_minus = 18`, `N_line(6) = 732`,
`N_c3 = 18`, `N_D10 = N_C6pt = N_D12pt = 1`. `STAGE1_COMPLEX_MAPS`'
leading-datum count `N(34,1) = 397` and its published sample row are
reproduced by the same machinery, and its prediction — *"the sieve's bite at
`d = 34` must come from higher order or from the line-degree bookkeeping, not
from the sweep datum"* — is **confirmed**: the plus-plane layer alone leaves
316 of 576. The landing system `F(T) ≡ 0` was never assembled; at `d = 34` it
is vacuous, because the linear space it would have to live in is already zero.

Exits: `D34-WINDOW-EMPTY`.
