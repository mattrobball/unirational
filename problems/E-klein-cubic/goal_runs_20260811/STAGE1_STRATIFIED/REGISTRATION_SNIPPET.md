# NOTEBOOK registration snippet — `STAGE1_STRATIFIED`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260811/STAGE1_STRATIFIED/
  entry: E56
  kind: goal_run
  verification_class: stratified-degeneracy repair of STAGE1_TIGHTEN /
    STAGE1_COMPLEX_MAPS; order-stratified contribution (s3jet.py) at two split
    primes 331, 661; old contribution path kept callable for diffs; Phi_F
    transport gate; ODDZERO clash/escape reproduced
  primary_exit: STAGE1-STRATIFIED-DEGENERACY-REPAIR
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: the character-rule value at level kappa (Theorem 15.1
    plus arc character); non-decreasing attainable sets under a |-> a+6 e_r;
    full-flag dichotomy; psi_F = 1.
    Two-prime finite exact: anchors N(d,m), H0-1, Prop 1.4(ii), g_r|6; six
    special V4 kids and corank-2 joint vanishing; old clash table (0/120 odd,
    domain-consistent even); corrected K(rho) for all six residues (all
    positive); Theta' = 9; stratified coherent count (union of old STAGE1
    tables with stratified full-flag contributions); Phi_F row data
    (ord_L F = 1, bihom (3,0)+(1,2)) and positivity transport.
    NOT claimed: any degree exclusion; any existence of a landing covariant;
    finality of the coherent count once non-full-flag rows are also stratified.
  tracked: true
  notes: |
    Repair of the degeneracy-semantics bug located by ODDZERO_AUDIT
    (ODD-ZERO-ARTIFACT).  s3sweep.py:271-276 / s3sat.py:72-78 (upstream
    s1coherence.py:293-296) treated whole-module rank 0 as degeneracy; the
    correct test is order-stratified per section.

    Headline: Problem E remains OPEN; this packet excludes no degree.  The
    corrected K table has no zeros.  The odd-residue artifact is removed
    (level-1 escape on the six type-I-plus-plane V4 children).

    Exits: STAGE1-STRATIFIED-DEGENERACY-REPAIR,
    STAGE1-STRATIFIED-THEOREM-S-PRIME, STAGE1-STRATIFIED-RESIDUE-TABLE,
    STAGE1-STRATIFIED-COHERENT-COUNT, STAGE1-STRATIFIED-PHI-F-GATE,
    STAGE1-STRATIFIED-ODDZERO-ESCAPE, STAGE1-STRATIFIED-NO-DEGREE-EXCLUSION.
    Machine markers: STAGE1_STRATIFIED_VERIFY_OK, ALLGREEN.
```
