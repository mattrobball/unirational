# Sources and consumed exact inputs

## Primary literature

1. Alexander Duncan and Zinovy Reichstein, *Versality of algebraic group
   actions and rational points on twisted varieties*, Journal of Algebraic
   Geometry 24 (2015), 499-530,
   [arXiv:1109.6093](https://arxiv.org/abs/1109.6093),
   [DOI](https://doi.org/10.1090/S1056-3911-2015-00644-0).

   Used precisely for the definitions in the introduction, Theorem 1.1,
   torsor twisting/untwisting in Proposition 3.2 and Corollary 3.4, and the
   smooth-cubic statements Lemma 10.1 and Theorem 10.5.  The paper's
   definition of very versal quantifies over some representation; it does not
   prescribe the original five-space.

2. János Kollár, *Unirationality of cubic hypersurfaces*, Journal of the
   Institute of Mathematics of Jussieu 1 (2002), 467-476,
   [arXiv:math/0005146](https://arxiv.org/abs/math/0005146),
   [DOI](https://doi.org/10.1017/S1474748002000117).

   Theorem 1 says that over any field a smooth cubic hypersurface of
   dimension at least two is unirational if and only if it has a rational
   point.  Only the point-implies-unirational direction is used here, over a
   characteristic-zero function field.

## Repository inputs

The following sealed or audited inputs are consumed without changing their
scope:

* `F55_AUDIT_20260808.md`, Section 1: the generic `F55` twist is the trace
  equation over `E/K`, and a point is equivalent to a nonzero trace solution.
* `goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/TRACE_HYPERPLANE_TORSOR.md`:
  the trace-hyperplane model and its point/trace equivalence.
* `goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/ISOGENY.md`: the
  projective monomial map has augmentation-lattice Smith form
  `(1,1,1,11)` and degree eleven.
* `goal_runs_20260808/TRACE_COBOUNDARY/THEOREM.md`: notation for the additive
  Fourier cyclic span and the existing uniform rank-at-least-three theorem.

The new ingredient in this packet is Lemma 2.1, the prescribed-source
first-jet graph specialization.  It is proved in full and is not attributed
to Duncan--Reichstein or Kollár.
