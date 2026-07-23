# unirational

Computational attacks on open questions from Joe Harris's Seattle lecture
notes *Rationality, Unirationality and Rational Connectivity*, organized as
four problems with machine-verified certificates.

- **[Problem A](problems/A-expected-dimension-curves/)** — expected dimension
  of spaces of degree-e rational curves on general hypersurfaces at the
  boundary degrees d = n, n+1.  **Closed**: all proposed target instances
  turn out to be theorems (Coskun–Starr plus new degree-2/3 arguments); the
  resolution also documents why fiberwise-saturation finite-field
  certificates are invalid without a base-change check.
- **[Problem B](problems/B-conic-bundle-multisections/)** — unirationality of
  smooth bidegree-(2,3) hypersurfaces in P^2 x P^2 (conic bundles of
  discriminant degree 9, the first case beyond the published degree-≤8
  boundary).  **Affirmatively resolved here for every smooth member** by the
  tangent-residual construction: a Tsen-rational vertical surface
  X ∩ (P^2 x L) maps birationally, via fiberwise tangent residuals in the
  plane-cubic fibration X → P^2_x, to a horizontal rational surface of class
  aH_x + H_y with 1 ≤ a ≤ 10, giving a parametrization of even degree at
  most 20.  For a general equation, a = 10 and the degree is exactly 20.
  Includes
  symbolic and finite-field certificates, a complete class-(1,1)
  nonexistence theorem, a corrected rehabilitation of the Del Centina–Verdi
  1980 special example, and an external end-to-end check on
  /dev/urandom-drawn coefficients (`external_check/`).
- **[Problem C](problems/C-lines-debarre-de-jong/)** — the Debarre–de Jong
  conjecture at the open frontier d = 9.  The field-free statement is
  **refuted** (the degree-9 Fermat over F_2 is smooth with 12-dimensional
  Fano scheme of lines against expected dimension 6); the characteristic-zero
  conjecture remains open and is reduced to singular line-rich sixfolds and
  an explicit Landsberg–Tommasi remainder.
- **[Problem D](problems/D-2d-conic-bundles/)** — unirationality of general
  bidegree-(2,d) hypersurfaces for d ≥ 4.  The headline remains open, but the
  primary tangent-residual program is settled negatively: after resolving its
  tangent-map base points, the correspondence has ample canonical class for
  every d ≥ 4; the same holds degree by degree for a general equation/seed
  pair, while one general equation gives an lci residual scheme with ample
  dualizing sheaf for every immersed rational seed.  The residual multiplier
  closure now equals the smooth actual ramification curve, with unique
  multipliers, reduced boundary, and generic two-point separation.  Uniform
  fold/cusp and higher-Morin local models remain; every residual
  discriminant component nevertheless has positive-genus normalization.
  For d = 4 the residual
  double cover has (K^2, chi, p_g, q, P_2) =
  (608, 127, 126, 0, 735).  The first low-class
  exclusion is also complete: every class-(1,0) divisor has only Du Val
  singularities and a resolution with p_g = 3.  The class-(1,1)
  double-decic frontier is also complete: after the square-factor and
  low-component exclusions, a uniform complete-cluster conic incidence
  excludes every six-center root partition.  For class (1,2), an exact
  double-dodecic ledger leaves four arithmetic profiles, while resolved-line
  incidences remove two on every primitive stratum; the actual primitive
  squarefree frontier is [3^2,2^4] and [3,2^7].  The primitive e = 2 row
  is absent, and all primitive isolated base schemes are classified.
  Base-point-free survivors of the two
  squarefree profiles require infinitely-near low/essential centers; in
  their singleton subrows at least two lows must be nonproper.  In the
  proper-high seven-distinct-singleton [3,2^7] subrow, exactly two or three
  lows are nonproper.  The two-nonproper row is excluded after the
  common-support rank-zero and reducible-residual boundaries are closed.
  In the three-nonproper row, a fixed-fiber simultaneous-jet argument
  excludes all integral deleted cubics, and the remaining nonintegral-block
  analysis excludes every factorization; hence this entire scoped subrow is
  absent.  Separately, a nonproper high center is uniquely a free
  first-near successor with local strict multiplicities (5,5).
  The two transformed-bundle first-neighborhood strata are excluded, so
  every base-point-free square-factor row e = 1,...,5 is absent.  Isolated
  integral-quintic square roots are excluded across every base-cluster
  type; the degree-zero quotient boundary is only a disconnected pure
  square.  For isolated squared lines, the off-base high-diagonal row now
  survives only for a rank-three net with two distinct base points; the
  through-base boundary is an explicit six-position cluster table.
  The conductor-safe component theorem also closes isolated square-factor
  degrees 3 and 4, so the only isolated square-factor degree left is e = 1.
  Retained strata of the two squarefree profiles with nonproper high centers,
  repeated essential trees, isolated bases, or other cluster types, together
  with that squared-line row and combined branch/base clusters, keep this
  case open.  The
  non-tangent bitangent incidence is also general
  type, with K^2 = 1728, and the direct
  flex/Hessian incidence has ample canonical class in every d ≥ 4.  Other
  covariants, special-seed normalization/singularity control, classes
  (1,k) for k ≥ 2, and the headline remain open.

`problems/README.md` records the shared conventions and the three
semicontinuity/properness certificates that turn single finite-field
computations into characteristic-zero theorems.

Status: research artifacts under active verification — see each problem's
`RESOLUTION.md` for precise claims, caveats, and literature context.
