# Status

```text
F55-GLOBAL-QUESTION-OPEN
```

The unrestricted dominant full-cyclic-rank-four branch now has an exact
global residue theorem:

\[
 A=S^\perp=\langle(1,5,3,4,9)\rangle,
 \qquad S=\ker(1,5,3,4,9),
 \qquad \dim_{\mathbf F_{11}}S=3.
\]

The earlier pairwise-coprime branch is impossible in every degree and
support: after the fixed `[11]` source isogeny it would dominate the smooth
degree-eleven Fermat threefold from a rational variety.

`KUMMER_NEWTON_REDUCTION.md` now excludes every incidence rank below three.
Cyclic semisimplicity reduces any larger annihilator to one of three fixed
two-planes.  For each, a complete finite dual-normal check places the
barycenter strictly inside the Fine interior of its Newton simplex.  The
Fine interior has dimension four, so Batyrev's theorem makes the associated
threefold Kummer cover general type.  The source lift, including every unit
and base divisor, would give a forbidden rational domination.  An independent
audit is in `FINE_INTERIOR_AUDIT.md`.

The two planes that escaped the weaker level-one interior-point test are
therefore excluded.  They nonetheless pass the full primewise integral
`2+sigma` lift, cyclic conjugacy, and norm-cube identity; the explicit
divisor counterconfigurations are retained to show why those local tests did
not see the Fine-interior obstruction.

`RANK3_KLEIN_COVER_BOUNDARY.md` identifies the unique surviving Kummer cover
`Y_<mu>` with the dense-torus open of the Klein cubic itself.  Its special
multiplicative lift is tautological.  Consequently canonical/Fine-interior
geometry cannot exclude it: the remaining issue is precisely the original
rank-three additive equation coupled to its prescribed semilinear descent
class.  This packet therefore does **not** prove `F55-NO` or
non-`PSL(2,11)`-unirationality.

```text
RANK4-GLOBAL-PAIRWISE-COPRIME-EXCLUSION
RANK4-GLOBAL-CONTRACTED-FREE-PRIME-ORBIT-FORCED
RANK4-GLOBAL-INCIDENCE-RESIDUE-RANK-EXACTLY-THREE
RANK4-GLOBAL-KUMMER-ANNIHILATOR-EXACTLY-MU
RANK4-RANK2-EXCEPTIONAL-COVERS-GENERAL-TYPE
RANK4-GLOBAL-EXCEPTIONAL-PLANES-PASS-INTEGRAL-NORM-LIFT
RANK4-RANK3-KUMMER-COVER-IS-KLEIN-TORUS
RANK4-RESIDUE-RANK3-ADDITIVE-GLUING-OPEN
F55-GLOBAL-QUESTION-OPEN
```
