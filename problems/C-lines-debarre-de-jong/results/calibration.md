# Degree-9 Fano-line calibration run

Generated: `2026-07-22T16:32:32.448474+00:00`

Driver command: `python3 tools/run_calibrations.py`

Macaulay2 command invoked by the driver: `M2 --script calibration/calibrate.m2`

Harness wall time: `0.762655` seconds

Macaulay2: `1.26.06`

msolve: `0.10.1` (inventoried only; this local certificate run does not invoke it)

| candidate | field | smooth | active eqs | Jacobian rank | tangent dim | Krull lower bound | certified local dim | interpretation | global Fano dim |
|---|---:|:---:|---:|---:|---:|---:|---:|---|---|
| fermat | QQ | yes | 10 | 10 | 6 | 6 | 6 | fixture_component_has_expected_local_dimension_only | not_checked |
| klein_10_cycle | QQ | yes | 10 | 10 | 6 | 6 | 6 | fixture_component_has_expected_local_dimension_only | not_checked |
| five_2_cycles | QQ | yes | 10 | 10 | 6 | 6 | 6 | fixture_component_has_expected_local_dimension_only | not_checked |
| chain | QQ | yes | 10 | 10 | 6 | 6 | 6 | fixture_component_has_expected_local_dimension_only | not_checked |
| fermat | F2 | yes | 4 | 4 | 12 | 12 | 12 | certified_positive_characteristic_excess_no_QQ_implication | not_checked |
| klein_10_cycle | F2 | yes | 4 | 4 | 12 | 12 | 12 | certified_positive_characteristic_excess_no_QQ_implication | not_checked |
| five_2_cycles | F2 | yes | 4 | 4 | 12 | 12 | 12 | certified_positive_characteristic_excess_no_QQ_implication | not_checked |
| chain | F2 | no | 4 | 4 | 12 | 12 | 12 | ineligible_singular_hypersurface | not_checked |
| fermat | F7 | yes | 6 | 6 | 10 | 10 | 10 | certified_positive_characteristic_excess_no_QQ_implication | not_checked |
| klein_10_cycle | F7 | no | 6 | 6 | 10 | 10 | 10 | ineligible_singular_hypersurface | not_checked |
| five_2_cycles | F7 | no | 6 | 6 | 10 | 10 | 10 | ineligible_singular_hypersurface | not_checked |
| chain | F7 | yes | 6 | 6 | 10 | 10 | 10 | certified_positive_characteristic_excess_no_QQ_implication | not_checked |

## Scope of the certificates

`projectively_smooth=yes` is certified by saturating the homogeneous singular ideal `(F, partial F)` by the irrelevant ideal. Including `F` keeps the test correct even when the characteristic divides the degree.

A reported local dimension is exact because the explicitly supplied line lies on the hypersurface and the chart Jacobian rank equals the number of active chart equations. The tangent-space upper bound and Krull lower bound therefore coincide.

No row certifies a global upper bound for `dim F_1(X)`. The 45 standard pivot charts `U_ij` cover `G(1,9)`; all 45 (or an equivalent rank-two Stiefel saturation) must be checked to certify a global null result. One exact chart with local dimension at least 7 would suffice for a lower-bound/refutation certificate over `QQ`.

The smooth `F2` and `F7` excess rows are genuine positive-characteristic counterexamples to a field-free statement. They are not counterexamples over `QQ` and imply no characteristic-zero excess; their equation-count collapse is characteristic-induced.
