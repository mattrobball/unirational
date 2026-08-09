# Status

    SCHUR-QUARTIC-KERNEL-COMPONENT-IS-KLEIN
    SCHUR-QUARTIC-RANK20-CHART-EXACT
    SCHUR-QUARTIC-NORMAL-O1-O1-GENERIC
    HEADLINE-OPEN

The good `(1,3)` quartic locus on the orthogonal `V14` is equivariantly
isomorphic to the complement of the jumping-line ruled surface in the Klein
cubic.  For the special Klein net, the regular-net small resolution and the
trivial normal bundle of a good kernel line prove globally that the closure is
the irreducible component `h(Y)`, isomorphic to the Klein cubic itself.  The
Flamini--Sernesi five-component theorem is used only to inventory the four
lower-degree components for a general Palatini quartic, not as a specialization
argument.

The theorem-forced finite parameter calculation uses eight line-chart
variables, a gauge-fixed `25 x 21` matrix, and a `12 x 5` inverse contraction.
On a nonzero rank-20 pivot it reduces the maximal-minor locus to five Schur
complement equations.  Exact arithmetic over `Q(zeta_11)` proves equality of
the smooth local germ with the kernel-line locus at one point, recovers the
cubic point uniquely, and gives generic normal bundle `O(1)+O(1)`.  Good
reductions at 23 and 67 repeat the chart ranks.  This is a local exact CAS
certificate; the preceding geometric argument supplies the global component
identification.

The naive rank-at-most-20 locus is not the quartic component: it contains the
degree `0,1,2,3,4` Palatini-line strata, with ranks `16,17,18,19,20`.  The
correct target is rank exactly 20 plus the basepoint-free open condition.

After the genuine generic twist,

```text
H_(1,3),T^good(X_T)(K) is nonempty  <=>  Y_T(K) is nonempty.
```

Thus the bounded CAS and the global moduli theorem close the canonical-quartic
route by exact circularity.  They produce no new arithmetic obstruction and do
not prove the negative headline.
