## 2026-08-11 Stage-1 tightening: the saturation theorem (Θ = 6) and residue-indexed coherent counts; the odd-residue zero recorded, NOT claimed

Packet: `goal_runs_20260811/STAGE1_TIGHTEN/`. Problem E
remains **OPEN**; no degree is excluded by this packet.

**Theorem S (saturation).** The stratum-coherent boundary-pattern count is
degree-saturated at threshold Θ = 6: periodicity of child values mod 6
(Stage-1 Thm 15.1), propagation by Γ-invariant forms (the minimal invariant
degree divides 6 for all 27 slots of all 15 sweep rows), and a finite exact
up-set check give that 1 088 847 395 778 723 840 000 is the ALL-multidegree
count — discharging `STAGE1_COMPLEX_MAPS` §15.6(1).

**Residue-indexed σ-band.** The full-flag dichotomy (the character twist ψ is
forced to be trivial on exactly the two dimension-3 divisors, whose slots
exhaust `W`) makes the σ-band count a function of `d mod 6`:
K(0) = 10 752, K(2) = K(4) = 672, versus the degree-blind 43 008 — a further
4× to 64× tightening. Both sealed parities (H0-1; `ord_{L_σ} ≡ d+1 mod 2`)
fall out of the corrected model as validation. New: the D10 door row's 23
values split 13 (elliptic side) + 10 (line side) by a τ-weight parity in
`d` — the first constraint on the row Stage-1 §15.5 called untouchable at
order 0. K values are upper bounds pending the shared-μ enumeration.

**Recorded but NOT claimed:** the enumeration returns K = 0 at every odd
residue of `d mod 6`. At face value that would exclude all odd degrees at
order 0; the packet declines to claim it (§2.5 lists the audit targets), and
the adversarial `ODDZERO_AUDIT` (in flight at registration time) gates any
use.

Exit: `STAGE1-TIGHTEN-SATURATION-THEOREM`. Markers:
`STAGE1_TIGHTEN_VERIFY_OK` / `ALLGREEN` (39 checks, director-replayed).
