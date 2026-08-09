# Status

The generic-fibre and normalized-graph audit gives four exact conclusions.

* The restriction degree equals the degree of the induced selfmap on
  `X/G`; preservation of the generic `G`-torsor is automatic and gives no
  numerical restriction.
* The generic fibre satisfies three exact intersection/canonical identities,
  but their correction terms are precisely the unconstrained horizontal
  Rees valuations of the actual landing ideal.
* If the normalized Stein graph were a terminal Q-factorial `G`-Fano with
  invariant Picard rank one, full-`G` superrigidity and Beauville would force
  degree one.
* In the Galois subcase, canonical singularities already suffice: invariant
  branch starts in degree five, so Hurwitz would make the cover general type.
  Independently, every Galois degree from 2 through 11 is excluded without
  a canonicality hypothesis.  In degree two, the unique deck involution
  centralizes `G`; superrigidity puts it in the equivariant regular group
  `Aut^G(X)=Z(G)=1`.  The higher small Galois
  degrees are excluded by the minimal faithful permutation degree 11 of
  `PSL_2(11)`.  Normalized Stein graphs of rational maps from smooth
  varieties can still be noncanonical, so the Mori/canonical hypothesis
  remains a genuine issue in arbitrary deckless degree.

No theorem in the audited sources forces the normalized graph of an ambient
landing map into either the Mori or canonical class.  The headline remains
open, and a bounded coordinate-degree calculation cannot replace the missing
all-degree base-ideal/discrepancy theorem.

```text
FULL-G-STEIN-MORI-CONDITIONAL-DEGREE-ONE
FULL-G-GALOIS-CANONICAL-GRAPH-DEGREE-ONE
FULL-G-DEGREE-TWO-EXCLUDED-BY-DECK-INVOLUTION
FULL-G-GALOIS-DEGREES-TWO-THROUGH-ELEVEN-EXCLUDED
FULL-G-STEIN-MORI-HYPOTHESES-NOT-FORCED
HEADLINE-OPEN
```

Replay from `problems/E-klein-cubic`:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/GENERIC_FIBER_STEIN_MORI/verify.py
```
