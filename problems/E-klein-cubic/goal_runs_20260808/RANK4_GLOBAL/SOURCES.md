# Sources and proof dependencies

The packet uses the following internal exact inputs:

- `TRACE_FULL_CYCLIC_REPLACEMENT/THEOREM.md`: a hypothetical point may be
  replaced by one whose projective trace map to the trace hyperplane is
  dominant;
- `TRACE_COBOUNDARY/RANK_FOUR_BOUNDARY.md`: full spark of the five Fourier
  hyperplanes, unit-twisted cyclic conjugacy, the prime-incidence ceiling,
  and the exact order-eleven prime-multiplicity congruence.

The Fine-interior step uses the following primary source:

- Victor V. Batyrev, *Canonical models of toric hypersurfaces*, Algebraic
  Geometry **10** (2023), 394--431,
  DOI `10.14231/AG-2023-013`, Definition 3.3 and Theorem 9.2.  For an
  integral nondegenerate hypersurface with a `d`-dimensional Newton
  polytope and nonempty Fine interior, the theorem gives
  `kappa=min(d-1, dim F(Delta))`.

`KUMMER_NEWTON_REDUCTION.md` proves directly that the three relevant Kummer
hypersurfaces are integral and nondegenerate, reduces the infinite
Fine-interior inequalities to a complete finite fundamental residue box,
and verifies a strict full-dimensional witness.  `FINE_INTERIOR_AUDIT.md`
is an independent derivation and replay of those hypotheses.

The remaining geometric facts are included explicitly in the notes:
Kummer independence from boundary divisors on `P^3`, adjunction for the
Fermat threefold, finiteness of the coordinatewise power map, restriction of
a dominant rational fourfold map to a transverse rational threefold, and
birational invariance and pullback of plurigenera.
