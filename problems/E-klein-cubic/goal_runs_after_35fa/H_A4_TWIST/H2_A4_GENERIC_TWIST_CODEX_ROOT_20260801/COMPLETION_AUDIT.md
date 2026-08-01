# Requirement-level completion audit

## Mission

**Pass.** `POINT_CERTIFICATE.json` gives a point on the exact `A4` record in
`H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json`.  The result is not an index or
bounded-search surrogate.

## H2.0: canonical affine/invariant presentation

**Pass.** `FIELD_MODEL.md` proves
\(K_{A_4}=\mathbf C(u,v)\), gives the inverse Fourier formulas, records the
exact matrix from canonical to installed source coordinates, and converts the
full equivalence open to `u,v`.  `TWIST_MODEL.md` gives the exact nine-term
`1' + 1'' + 3` norm form, the small adapted Hilbert--90 frame, and the fully
reduced 35-coefficient equation in `twist_over_Cuv.json`.  The invariant
transition to the installed frame proves equivalence with the original twist.

## H2.1: structural fibration or torsor

**Pass by a stronger object.** `FIBRATION_OR_VALUATION.md` records an exact
projective `A4`-equivariant rational map from `P2` to the Klein cubic.  Its
generic point descends to a degree-one section of the generic twist.

## H2.2: valuation obstruction

**Not applicable after the point branch succeeds.** No negative valuation or
specialization claim is made.

## H2.3: exact point certificate

**Pass.** The degree-zero coordinate vector

\[
Z_K(x)={M\over Sxyz}A_{\rm inst}(Px)^{-1}\Phi_p(x)
\]

is exact.  Homogeneity and character cancellation put every entry in
\(K_{A_4}\); direct substitution proves the genuine installed equation; and
every denominator is listed and proved nonzero.  `verify_exact_point.py` and
`verify.py` independently reconstruct the coefficient identities and rerun
the exact Groebner test.

## Optional finite gate

**Not used as a completion argument.** `transpose_audit.py` only diagnoses
why the installed degree-1--4 exclusion was invalid.  No degree-five result is
needed after the exact degree-three section.

## Exit and scope

**Pass.** The exact exit is `H-A4-RATIONAL-POINT`.  `STATUS.md` explicitly
states that this closes only the `A4` subgroup obstruction and gives no full
`G` verdict.

## Output contract

**Pass within the user-mandated isolated worker directory.** The packet
contains `FIELD_MODEL.md`, `TWIST_MODEL.md`,
`FIBRATION_OR_VALUATION.md`, exact point payloads, independent verifiers,
and `SEAL.json`.  A contract-path mirror is recorded separately when
available; this directory remains the authoritative concurrency-safe copy.
