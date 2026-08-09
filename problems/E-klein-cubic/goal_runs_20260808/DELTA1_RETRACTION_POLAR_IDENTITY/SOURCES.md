# Sources and audited inputs

## Internal theorem inputs

* `../FULL_G_RESTRICTION_DOMINANCE/THEOREM.md` proves that a hypothetical
  full-group ambient landing map restricts dominantly to the Klein cubic and
  that restriction degree one normalizes to a rational `G`-retraction.
* `../../goal_runs_after_063da5a/FIX_P1_DEGREE25_GUIDED/STATUS.md` records the
  exact characteristic-zero exclusion through degree 35 and hence the
  current lower bound `d >= 36` for a dominant landing covariant.
* `../../goal_runs_after_35fa/G_UNIVERSAL/UNIVERSAL_OBJECT.md` records the
  algebraically independent primary invariants of degrees `3,5,6,8,11` and
  the full-group all-degree landing-covariant equivalence.
* `../../certificates/exact_covariants_check.py` records the exact Klein form
  and the installed low-degree covariant frame.

## Self-contained geometric inputs

The two Fano-surface facts used in the theorem are derived directly:

1. lines through a general point of a smooth cubic threefold are the
   transverse `(2,3)` complete intersection in the tangent `P2`, hence there
   are six;
2. the Fano surface is the zero locus of a section of `Sym^3(S*)` on
   `Gr(2,5)`, so adjunction gives
   `K_Fano = O_Gr(-5) tensor det(Sym^3(S*)) = O_Fano(1)`.

No literature claim is used to promote the incidence boundary to a
headline obstruction.
