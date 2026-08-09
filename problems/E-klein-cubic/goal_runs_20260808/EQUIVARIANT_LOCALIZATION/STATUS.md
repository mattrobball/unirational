# Status

The `C_11` fixed-point route gives two unconditional all-degree restrictions:

1. all five coordinate vertices are base points of every hypothetical
   `F55`-equivariant rational map `P4 --> X_Klein`;
2. after blowing up those vertices, at least one `C_5`-orbit of infinitely
   near `C_11`-fixed points is still in the base locus.

For an arbitrary finite equivariant resolution, all exceptional fixed
components obey the exact five-term Fourier moment law (3.3) of `THEOREM.md`.
The Fourier matrix is invertible, so those components can formally absorb
arbitrary residues of the three nontrivial mixed projective degrees.  A
minimal two-channel counterconfiguration also satisfies the elementary
positivity, cubic-degree, and log-concavity tests.

Thus fixed-point localization alone does not prove `F55-NO`; a continuation
must constrain the infinitely-near base ideal or its normal cones.

```text
F55-C11-FIXED-VERTICES-ARE-FORCED-BASE-POINTS
F55-C11-FIRST-EXCEPTIONAL-LAYER-STILL-HAS-A-BASE-POINT
F55-C11-ARBITRARY-RESOLUTION-MOMENT-CONSERVATION
F55-C11-LOCALIZATION-MOMENTS-ARE-FORMALLY-SURJECTIVE
F55-GLOBAL-QUESTION-OPEN
```

Replay:

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/EQUIVARIANT_LOCALIZATION/verify.py
```
