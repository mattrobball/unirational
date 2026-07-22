# unirational

Computational attacks on open questions from Joe Harris's Seattle lecture
notes *Rationality, Unirationality and Rational Connectivity*, organized as
three problems with machine-verified certificates.

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

`problems/README.md` records the shared conventions and the three
semicontinuity/properness certificates that turn single finite-field
computations into characteristic-zero theorems.

Status: research artifacts under active verification — see each problem's
`RESOLUTION.md` for precise claims, caveats, and literature context.
