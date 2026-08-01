H-SWEEP-UNDECIDED

# Goal H status

The proper-subgroup route does **not** currently prove the Klein cubic
non-(G)-unirational.  This is the work order's permitted undecided exit, not
a negative or positive headline for Problem E.

## Exact results

1. `BR-SUBGROUP-NEG` is proved in `BRIDGE.md` with its exact torsor and
   weak-versality hypotheses.
2. The two maximal (A_5) conjugacy classes are enumerated separately
   (eleven subgroups in each class).  For each one, `twists.json` gives a
   generically invertible Hilbert--90 frame over
   (K_H=\mathbf C(\mathbf P^2)^H) and the exact twisted Klein equation.
3. Exact generic equations are also supplied for (A_4) over
   (\mathbf C(\mathbf P^2)^{A_4}) and (11{:}5) over
   (\mathbf C(\mathbf P^4)^{11:5}).
4. Every selected generic twist has index one.  Therefore the proposed
   index obstruction cannot prove pointlessness; no rational point follows.
5. (D_{10}) and (D_{12}) are soluble for **every** torsor: each preserves
   an honest two-dimensional subrepresentation whose projective line lies on
   (X), and twisting gives an ordinary projective line over the base field.
6. For the smallest unresolved case \(A_4\), the complete projective landing
   schemes of all degree \(1,2,3,4\) polynomial covariants, including all
   three possible character multipliers, are geometrically empty in
   characteristic zero.  This is a bounded exclusion only.

## Smallest unresolved twist

The smallest unresolved object is the explicit (A_4)-twist in
`twists.json`.  The first untested polynomial landing space is degree five;
an arbitrary rational point is not bounded by that degree.  Its index is one,
so a new obstruction must distinguish index one from existence of a point.

## Repository state

- Pinned mathematical baseline consumed: `715faf441289e2589b9325311b6613ea0331bf88`.
- Live head first inspected: `2140419`.
- Concurrent waypoint head incorporated for path-state only: `80f2469`.
- Produced artifact commit: `2301a439261d3fe84b4c7a65ec8dcf4cc3309f21`.
  Only this isolated directory was staged; no sibling worker path was staged
  or modified by the commit.

Problem E headline: **OPEN**.
