# S19 marked degree-19 continuation

This packet gives the corrected exact S19 frontier.  Its binding exit is
`S19-UNDECIDED`: it constructs the canonical universal marked 55-point
family and the finite incidence presentations of both surviving Rao loci,
but it does not produce a point of either locus.

The machine payloads are:

- `universal_marked_family.json`: the exact 55-line/hyperplane construction,
  universal point ideals, good-open gates, and generic-freeness certificate;
- `marked_component_presentation.json`: a normalized finite presentation of
  the epsilon-zero and epsilon-one marked-map loci, their universal image
  ideal, rank conditions, deformation calculation, and carrier boundary;
- `marked_incidence_presentation.json`: the complementary unnormalized
  220-by-135 linearized incidence matrix and compressed 96-by-11 Rao gate;
- `exact_curve_residual_verification.json`: an explicit null-result ledger;
  there is no curve or residual cycle to verify.

Read `STATUS.md` first.  `PREFLIGHT.md` identifies the smallest remaining
finite elimination problem and records why no over-budget elimination was
started.  Every positive arithmetic statement is replayed by a producer and
an independent verifier; `replay.py` is the single entry point.

No file in the historical certificate packets was modified.
