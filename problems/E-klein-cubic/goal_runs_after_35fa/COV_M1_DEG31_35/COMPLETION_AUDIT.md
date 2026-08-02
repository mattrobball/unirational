# Completion audit

| Work package | Status | Evidence |
|---|---|---|
| COV2.0 fixed characteristic-zero bases | PASS | `canonical_bases.json`, dual Hironaka circuits, two unused-prime fixed minors |
| COV2.1 ordered global equalizer | PASS for the literal global polynomial image | `ordered_equalizers.json`; one coefficient vector; compact-only torsion excluded |
| COV2.2 primitive analysis | SPECIFICATION REFUTED / geometric saturation OPEN | `primitive_quotient_counterexample.json` gives exact primitive elements killed by the linear quotient in both degrees; actual factor/composition incidence saturation remains open |
| COV2.3 complete landing ideal | PASS for construction and recursive C3/C6 pre-elimination, OPEN for affine saturation | `landing_ideals.json`, `c3_first_normal_gate.json`, `c3_second_normal_gate.json`, `c3_deep_normal_gate.json`, `d31_third_pure_msolve.json`, `p25_dependency_localization.json`; tangent gates reduce the mixed-second nonbased covers, the recursion closes both five-dimensional deepest tails by full `35/35` cubic-span minors, exact unit bases exclude two prime-specific degree-31 charts only over `F_463`, and fixed minors localize the P25 images; all characteristic-zero affine chart covers stay open |
| COV2.4 candidate certification | not applicable | no candidate found |
| Positive or full-degree-empty verdict | NOT REACHED | P25.2 dependency and the remaining affine chart saturations are open |

The packet therefore uses the honest authorized exit `COV-UNDECIDED`.  It
must not be cited as `COV31-FULL-DEGREE-EMPTY-SCOPED`,
`COV35-FULL-DEGREE-EMPTY-SCOPED`, or a headline-positive result.
