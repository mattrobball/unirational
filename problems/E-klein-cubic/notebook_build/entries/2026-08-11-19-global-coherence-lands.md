## 2026-08-11 Global coherence lands: the product formula was a fixed-mu snapshot; exact counts, a director-corrected D10 lattice, no zeros

Packet: `goal_runs_20260811/GLOBAL_COHERENCE/` (worker-built under
`WORKORDER_GLOBAL_COHERENCE_SHARED_MU.md`, director-adjudicated, section 13).
Problem E remains **OPEN**; no degree is excluded. Handoff queue items 2+3
are done.

The main finding is a reinterpretation, not a tightening. The per-residue
formula `K x D10 x 3^8` treated the odd-order jet orders as fixed: STAGE2's
`3^8` is a per-mu snapshot. The honest object ranges over admissible shared
`mu` per center orbit (A4: `mu1 >= 2` with the sealed second-order
residuals, stabilizing at residual 3 for `mu1 >= 5`; D10: `mu0 >= 1`,
`5 ∤ mu0`; C11/C5: the congruence branches), with values pinned by the
master weight formula `w = d a_k + sum mu_l c_l` and mu SHARED across rows
over the same center. Result: `F_odd(d mod 330)` is in the millions
(`F_odd(35) = 36,252,160`), and the exact global count is `G = K x H` --
the incidence lattice binds nothing between the immune block and the
sigma-band (immune rows have only the free stratum as parent; machine
zero), while the `Z+` D10 C2-line couples through the shared `mu0`.

Director adjudication caught one real error and one semantics subtlety,
both closed by a new audit instrument in the packet
(`scripts/director_range_audit.py`): the worker truncated `mu0` at period
5, but `mu0` feeds the pt_D10 values mod 5 AND the C2-line branch parity
mod 2 -- the joint lattice is mod 10 with eight admissible classes, and
the worker's own phase-2 note ("both parities are attainable via
`mu0 -> mu0+5`") contradicted its parity-locked sum of 46; the correct
single-cover sum is 92, so every `G` in the worker's tables is exactly
half the corrected value, uniformly over all 330 residues. The audit
verifies cover-independence with two disjoint single covers, the exact
`2x` on a double cover (the worker's `H` sums menu sizes, so covers must
be single), invariance of `F_odd` and of `vectors_d35.json` (mod-5
collapse -- the pair-attack input is unaffected), and adequacy of the
A4/C5/C11 truncations.

Corrected headline numbers (Tier 2 via the sigma-band inputs; weight layer
prime-free): `G_corrected(35 mod 330) = 630,352,558,080`; min/max over
residues `3.94e10 / 1.50e13`; **no zeros at any residue**, so no exclusion
arises and nothing triggers the transport machinery (map-level throughout;
the pinning inputs assume a reduced lift). Verifier: 116 checks, 0
failures, director-replayed; plus the director audit ALLGREEN.

Consequence for the pair attack (in flight): the r-side tree at `d = 35`
has `756` sigma-band roots and an immune/D10 layer of `~8.3e8` per root at
the lazy level -- the hierarchical prune-as-you-go architecture in
`WORKORDER_PAIR_ATTACK_D35.md` is not optional, and the corrected `H`
matters only if the tree survives to layer 2.

Exits: `GLOBAL-COHERENCE-EXACT-COUNT`, `GLOBAL-COHERENCE-SHARED-MU`,
`GLOBAL-COHERENCE-D10-MU-COUPLING`,
`GLOBAL-COHERENCE-UNION-OVER-MU-REINTERPRETATION`,
`GLOBAL-COHERENCE-NO-DEGREE-EXCLUSION`.
