# Goal H2 status

## Verdict

`H-A4-RATIONAL-POINT`  
`H-A4-STRUCTURAL-MODEL-PASS`

The exact generic `A4` twist installed in
`H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json` has a
`K_A4=C(P^2)^A4`-rational point.  The point is obtained from an exact
degree-three projectively `A4`-equivariant map from the canonical tetrahedral
plane to the Klein cubic.  It is not a bounded nonexistence inference.

The consequence is deliberately narrow: the `A4` subgroup obstruction is
closed positively.  This does not decide equivariant unirationality for the
full `PSL_2(F_11)` action on the Klein cubic.

## Exact evidence

- `canonical_model.json` gives `K_A4=C(u,v)`, the exact source change to the
  installed torsor, all 12 installed seed denominators, and the adapted frame.
- `twist_over_Cuv.json` is the 35-coefficient equation over `C(u,v)`; 22
  coefficients are nonzero.
- `exact_degree3_map.json` serializes four exact degree-three covariants over
  `Q(zeta_33)`, the `1' + 1'' + 3` target basis, and the landing equations.
- `degree3_character1_exact_chart0.sing` and its transcript prove that the
  exact `p0=1` landing ideal is proper.
- `verify_exact_point.py` reconstructs covariance, landing, the norm form,
  the invariant frame, and the source intertwiner without importing a producer.

## Corrected upstream boundary

The installed `a4_direct_search.py` used `C*M=R*C`, although its monomial
matrix convention requires `C*M^T=R*C`.  Therefore its claimed degree-1--4
landing emptiness is invalid.  `audit_upstream_transpose.py` directly finds
eight failed generator/basis covariance checks in the installed degree-3,
character-1 basis.  No result from that bounded ladder is used in this verdict.

