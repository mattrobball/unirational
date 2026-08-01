# Structural branch

The valuation/pointlessness branch is not applicable: the generic twist has
the exact rational point certified in `POINT_CERTIFICATE.md`.

The useful structural object is instead the adapted `1' + 1'' + 3` frame.
Projection to its two character coordinates exposes the conjugate Fourier
quadratic forms and the norm-style equation

\[
aU^3+bV^3+cU M_2(r)+dV L_2(r)+e r_1r_2r_3=0.
\]

After descent, its coefficients are rational functions of `u,v`; the complete
equation and its equivalence open are in `twist_over_Cuv.json`.  This provides
the requested structural model without asserting an unverified conic bundle,
genus-one fibration, or Brauer obstruction.

As an external consistency check, Duncan's Lemma 7.3 proves that smooth cubic
surfaces with group contained in `S5`, including `A4`, are equivariantly
unirational and identifies the same rational tetrahedral generators and cubic
semi-invariants: <https://arxiv.org/pdf/1410.8434#page=18>.  The present packet
does not use that theorem in place of the exact installed-twist substitution.

