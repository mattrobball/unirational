# NOTEBOOK registration snippet — `L12_REFEREE`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/L12_REFEREE/
  entry: E56
  kind: goal_run
  verification_class: adversarial mathematical referee of the director
    derivation theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md; python3-only
    replayable spot-checks for AB denominator calibration (classical P1)
    and R2 tangent geometry of F = sum x_i^2 x_{i+1} over Z and at p=331,661;
    no pattern enumeration; no gap/gp/sage/magma
  primary_exit: L12-REFEREE-MACHINE-PHASE-MAY-PROCEED
  superseded_by: null
  char0_scope: |
    Char-0 analytic: holomorphic Atiyah-Bott isolated contribution is
    tr(g|E_x)/det(1-dg|T_x) (Kondyrev-Prikhodko Thm 3.1.2; P1 calibration);
    projection formula χ_g(Z,q*L)=χ_g(X,L⊗Rq_*O_Z); QR eigenframe tangent
    weights on T_{e_j}X; Vandermonde independence of twist rows k=1,2,3 on
    X^{C11}; odd-order cyclic lifts unique up to scalar.
    Computational spot-checks: F(e_j)=0 and single-nonzero gradient over Z;
    same plus det(1-dg)≠det(1-(dg)^{-1}) at p=331,661; P1 complex calibration
    n=0..5; 3x3 minor witness for twist-row independence mod 331.
    NOT claimed: any degree exclusion; any pattern kill; any completed
    machine enumeration of the identity family.
  tracked: true
  notes: |
    Hostile referee of theory/GLOBAL_LOCALIZATION_LEDGER_20260812.md
    (morphism ledger L12 / global localization ledger), director-commissioned.

    VERDICTS:
      R1 CORRECTED — AB denominator is det(1-dg), not det(1-(dg)^{-1});
        order-11 display denominators flip to Π(1-ζ^{a_k'-a_j}).
      R2 CONFIRMED — five e_j on X; ∇F; T_{e_j}X; (terminology: note's
        "conormal" weight is the normal weight).
      R3 CORRECTED — Leray sound; flags 1-4 necessary but add flag 5
        derived-fiber/base-change for local traces.
      R4 CORRECTED — localized k=0 is Σ(tr_j-1)/D_j=0, not vacuous;
        k=1,2,3 independent.
      R5 CONFIRMED — odd orders safe; 2/6 need sealed lift.
      R6 CONFIRMED — AB-Leray is strictly global vs product-local layers.

    Headline: Problem E remains OPEN; this packet excludes no degree.

    Machine phase may proceed on order 11 after the R1 patch (genus-0
    branch first, then fiber-trace menus).

    Exits: L12-REFEREE-R1-AB-DENOMINATOR-CORRECTED,
    L12-REFEREE-R2-TANGENT-CONFIRMED,
    L12-REFEREE-R3-LERAY-FLAGS-CORRECTED,
    L12-REFEREE-R4-TWIST-K-CORRECTED,
    L12-REFEREE-R5-LIFT-CONFIRMED,
    L12-REFEREE-R6-GLOBAL-CONFIRMED,
    L12-REFEREE-MACHINE-PHASE-MAY-PROCEED,
    L12-REFEREE-NO-DEGREE-EXCLUSION.
    Machine markers: L12_REFEREE_VERIFY_OK, ALLGREEN.
```
