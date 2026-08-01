# Primary sources and exact use

The geometric inputs are inherited from the audited R packet and were
checked there against cached copies of the primary papers.

1. Xavier Roulleau, *The Fano surface of the Klein cubic threefold*,
   [arXiv:1001.4853](https://arxiv.org/abs/1001.4853). Used for the exact
   period lattice and the analytic order-11 and order-5 actions. The local
   fixed-Jacobian verifier recomputes the common fixed subgroup from these
   matrices.
2. Arnaud Beauville, *Vector bundles on the cubic threefold*,
   [arXiv:math/0005017](https://arxiv.org/abs/math/0005017). Used for the
   Serre description of elliptic normal quintics by stable rank-two bundles,
   the six-dimensional section space, the Abel--Jacobi open embedding of
   the bundle moduli, the twisted-cubic boundary, and residual lines for
   conics.
3. Arend Bayer, Sjoerd Viktor Beentjes, Soheyla Feyzbakhsh, Georg Hein,
   Diletta Martinelli, Fatemeh Rezaee, and Benjamin Schmidt,
   *The desingularization of the theta divisor of a cubic threefold as a
   moduli space*, [arXiv:2011.12240](https://arxiv.org/abs/2011.12240).
   Used only for the generalized-twisted-cubic ranking: the theta blowup and
   its exceptional divisor. It is not used in the obstruction theorem.
4. Atanas Iliev and Dimitri Markushevich, *The Abel-Jacobi map for a cubic
   threefold and periods of Fano threefolds of degree 14*,
   [arXiv:math/9910058](https://arxiv.org/abs/math/9910058). Used for the
   elliptic-quintic bundle/section geometry, the quartic-plus-chord
   degeneration, and the rational-quartic boundary. Statements assuming a
   generic cubic are not applied to the Klein cubic.
5. Joe Harris, Mike Roth, and Jason Starr, *Curves of small degree on cubic
   threefolds*, [arXiv:math/0202067](https://arxiv.org/abs/math/0202067).
   Used for irreducibility and dimensions of the rational quartic and
   quintic loci, the length-16 chord scheme, and the scroll/residuation
   constructions.
6. Joe Harris, Mike Roth, and Jason Starr, *Abel-Jacobi maps associated to
   smooth cubic threefolds*,
   [arXiv:math/0202080](https://arxiv.org/abs/math/0202080). Used for
   dominance and irreducible unirational **general** fibres of the
   rational-quartic and rational-quintic Abel--Jacobi maps. No general-fibre
   theorem is promoted to the distinguished fixed fibre.

## Exact repository inputs

`source_manifest.json` pins every executable dependency by SHA-256:

- the R2 work order at pinned state
  `35fa8f59b6a1423cc89300aeaceefe91552be5ba`;
- the characteristic-zero Pfaffian representation alignment and its hostile
  independent audit;
- the generic projective-torsor Schur-class certificate;
- the fixed-Jacobian and full group-cohomology certificates.

The producer imports the exact characteristic-zero alignment, not a modular
surrogate. The modular computation at \((23,\zeta_{11}=2)\) is used only as
a good-reduction witness for the split geometric component. The Brauer and
descent conclusions are characteristic-zero results.

## Field boundary

The obstruction lives over

\[
K_{\rm proj}=\mathbf C(\mathbf P(W))^G.
\]

It is not asserted over the distinct Schur-source field
\(K_{\rm Schur}=\mathbf C(\mathbf P(V_6))^G\). The packet never transfers a
point, zero-cycle, or Brauer class between these two invariant fields
without a proved bridge.
