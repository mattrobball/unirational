## 2026-08-11 Stratified degeneracy repair lands: no zeros in the corrected residue table, coherent total unchanged, transport gate calibrated

Packet: `goal_runs_20260811/STAGE1_STRATIFIED/` (worker-built under
`WORKORDER_STAGE1_STRATIFIED_DEGENERACY.md`, director-adjudicated and
replayed). Problem E remains **OPEN**; no degree is excluded.

Queue item 1 is done. The degeneracy semantics located by `ODDZERO_AUDIT`
(whole-module rank versus per-section vanishing) are repaired by the
order-stratified contribution (`s3jet.py`: level-`kappa` values by the
character rule `psi^{-1} prod mu^a chi_arc^kappa`; attainable joint level
vectors; free only at genuinely infinite order), and the sigma-band
enumeration re-run at `p = 331, 661`:

- **Corrected `K` table, no zeros:** `K = 11068 / 1178 / 1512 / 6216 /
  1344 / 756` for `d = 0..5 mod 6`. The odd-residue artifact is gone (the
  level-1 escape on the six type-I-plus-plane V4 children restores usable
  classes); the even residues strictly dominate the old values, as ODDZERO
  predicted for lower bounds. With no zero, the transport note's
  single-class closure criterion is NOT triggered: the order-0 sigma-band
  excludes no residue class, and the campaign proceeds to the deeper
  layers.
- **Degree-blind coherent total unchanged:** `1.088 x 10^21` exactly -- the
  old free-choice at module-degenerate children already contained the
  escape values, so only the residue-indexed table moves. Still a lower
  bound with respect to stratification of the non-full-flag rows (Tier-3).
- **Theorem S-prime:** the old S(c) monotonicity direction REVERSES under
  stratified semantics (attainable sets are non-decreasing along
  `a -> a+6e_r`); contributions stabilize; observed threshold
  `Theta' = 9`; the table is read from the stable pattern only. S(a),(b),
  (d) survive.
- **Phi_F transport gate, calibrated by execution:** the raw pattern-level
  inclusion demanded by the workorder genuinely FAILS -- as it must, since
  `Phi_F` injects only REALIZED patterns and the tables are relaxations
  (already forced by `K(0) > K(3)`). The forced statements are per-class
  attainable-set transport, realized-pattern transport, and the pair-zero
  rule; the positivity shadow `K(rho)>0 => K(rho+3)>0` passes on the
  corrected table, fails on the old artifact table, and is an AUDIT
  TRIGGER when it fails -- never a constraint to be repaired into passing,
  since a genuine zero fails it legitimately and is a closure event. A
  same-day correction banner to this effect is on the transport note
  (section 5.2), and the packet carries the full calibration as its
  section 12.
- **ODDZERO reproduction:** old semantics reproduce the clash signature
  (0 agreements / 120 clashes at odd `d`; even-`d` values in-domain --
  the verifier's 84 vs the audit's 90 is a documented sampling-range
  difference, signature identical); new semantics show corank-2 joint
  vanishing and the level-1 escape exactly as Prop B demanded.
- **Verifier:** 47 checks, 0 failures at both primes
  (`STAGE1_STRATIFIED_VERIFY_OK` / `ALLGREEN`), director-replayed from a
  clean shell.

Repair banners placed under the existing ODDZERO correction banners:
`STAGE1_TIGHTEN` sections 2.2/2.4 (corrected `K`) and
`STAGE1_COMPLEX_MAPS` sections 15.2/15.3 (unchanged total, still a lower
bound). Director adjudication is section 12 of the packet: gate semantics,
the B3 sampling question, and the worker's mid-run coherent-count revision
(over-pinning of uncomputed strata, superseded) all reviewed and closed.

Next in queue (handoff section 4): the shared-mu enumeration across the
odd-order strata, now on exact sigma-band inputs; then incidence rows and
`Z+` coherence; then the pair attack at `d = 35`.

Exits: `STAGE1-STRATIFIED-DEGENERACY-REPAIR`,
`STAGE1-STRATIFIED-THEOREM-S-PRIME`, `STAGE1-STRATIFIED-RESIDUE-TABLE`,
`STAGE1-STRATIFIED-COHERENT-COUNT`, `STAGE1-STRATIFIED-PHI-F-GATE`,
`STAGE1-STRATIFIED-ODDZERO-ESCAPE`,
`STAGE1-STRATIFIED-NO-DEGREE-EXCLUSION`.
