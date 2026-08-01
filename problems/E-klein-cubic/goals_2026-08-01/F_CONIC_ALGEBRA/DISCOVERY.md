# Discovery calculations and their strict scope

None of the calculations in this file is used as an existence or emptiness
proof.

## Replayed exact layer

`verify_field_presentation.py` reconstructs the accepted sparse matrix,
checks the determinant/content/primitive presentation on exact symbolic
slices, proves the primitive has degree six, and checks the selected Cramer
embedding in an irreducible exact specialization.  Its terminal marker is

```text
GOAL_F_FIELD_PRESENTATION_ACCEPT
```

This closes F0 only.

## Bounded point screens

- A 512,000-case sparse monomial-coordinate screen over four irreducible
  `GF(67)` fibres found no hit.  Its scope is only the recorded monomial box.
- The ansatz

  ```text
  X=a0+a1*t+a2*u+a3*v,
  y=b0+b1*t+b2*u+b3*v,
  w=1
  ```

  is empty over three simultaneous `GF(67)` fibres; `linear_ansatz_p67.out`
  is `[-1]:`.  This excludes only that eight-parameter formula box.
- The full sextic-basis ansatz with coefficients constant on the line
  `(A,B,Y,Z)=(1,2,3,s)` timed out after 600 seconds.  It gives no conclusion.

## Nontrivial-direction audit

A concurrent discovery screen selected

```text
y/w = (1+u*v)/(t^2*u).
```

The apparent survivor was tested past interpolation rank in
`root_019fbe10/survivor_extended_p67.json`.  In the 735-feature box (base
degree at most one and Laurent degree-difference at most three), 870 scalar
equations have full rank 735 and are inconsistent.  The earlier survivor was
therefore not a formula in that box; conditioning on finite-field cubics that
happen to have a root cannot be promoted to a generic point.

## Valuation/Lefschetz audit

Residue-degree-one divisors obtained from `u=g` were explored as a possible
index-survival obstruction.  Their norm hypersurfaces have a structural
codimension-one singular/self-intersection locus: for example the corrected
Singular convention (`NF(1)=0` means the unit ideal) gives singular-locus
dimension two for constant roots at primes 67 and 89, and for the tested
linear root `u=A` at prime 67.  Thus the smooth-projective Lefschetz premise
fails.  No normalization/Picard theorem was supplied, so these probes do not
prove pointlessness.

The initially tempting opposite interpretation of Singular's normal-form
marker was caught and rejected before any theorem or status file used it.

