# Primary sources and pinned dependencies

## Primary literature

1. Xavier Roulleau, *The Fano surface of the Klein cubic threefold*,
   arXiv:1001.4853, <https://arxiv.org/abs/1001.4853>.
   Used for the exact period lattice and the order-11/order-5 analytic
   actions.  Local source hash:
   `82ff1544b9afe57735ac27bd2eaa4e370c18167a43bcc56496c127b21e9c280a`.
2. Arnaud Beauville, *Vector bundles on the cubic threefold*,
   <https://math.univ-cotedazur.fr/~beauvill/pubs/cubic.pdf>.
   Proposition 5.2 supplies the twisted-cubic Abel--Jacobi geometry;
   Proposition 5.4 supplies the fixed-line quartic family; Sections 6--7
   supply the elliptic-quintic projective bundle and bundle-moduli open
   embedding/blowup.  Local PDF hash:
   `699c0f2182a39c1e16bf5a50cecb931bb82999d0464b29e2c26220555250ce0b`.
3. Atanas Iliev and Dimitri Markushevich, *The Abel--Jacobi map for a cubic
   threefold and periods of Fano threefolds of degree 14*,
   arXiv:math/9910058, <https://arxiv.org/abs/math/9910058>.
   Theorem `KKK` identifies the six-dimensional section space of the
   Pfaffian kernel bundle.  Theorem `fiberquart` is used only with its stated
   generic-cubic/generic-value boundary.  Local source hash:
   `1c7f15221bab7adc3dd998c4a99e6bf81ce0760e90477659aa8edcb44d94d48f`.
4. Arend Bayer, Sjoerd Viktor Beentjes, Soheyla Feyzbakhsh, Georg Hein,
   Diletta Martinelli, Fatemeh Rezaee, and Benjamin Schmidt,
   *The desingularization of the theta divisor of a cubic threefold as a
   moduli space*, Geometry & Topology 28 (2024), 127--160,
   <https://arxiv.org/abs/2011.12240>,
   <https://doi.org/10.2140/gt.2024.28.127>.
   Used for the all-smooth-cubic generalized twisted-cubic map, theta
   blowup, and exceptional divisor \(X\).

No secondary source is used to enlarge the hypotheses of these theorems.

## Repository dependencies

The packet consumes the following theorem-level repository inputs.

- `../../RESOLUTION.md`: genuine generic-twist no-line theorem and the exact
  nonzero Schur class of index two over \(K_{\rm proj}\).
- `../../SPEC.md`: field conventions, generic-twist bridge, and the strict
  distinction between \(K_{\rm proj}\) and \(K_{\rm Schur}\).
- `../../tmp/pfaffian_generic_schur_audit/`: independent exact certificate
  that the generic Schur class is nonzero of index two.
- `../../tmp/pfaffian_representation_alignment_audit/`: independent exact
  alignment \(B_5\subset\bigwedge^2V_6^*\) for the actual Klein module.

The exact consumed hashes are serialized in `structural_payload.json` and
checked by `verify_all.py --with-repository-dependencies`.

## Locally produced exact certificates

- `fixed_jacobian_payload.json`, produced by
  `produce_fixed_jacobian.py` and independently reconstructed by
  `verify_fixed_jacobian.py`;
- `group_cohomology_payload.json`, produced by
  `probe_full_group_h1_mod3.py` and independently verified by
  `verify_group_cohomology.py`;
- `component_inventory.json` and `structural_payload.json`, checked against
  the theorem/status boundary by `verify_all.py`;
- `SEAL.json`, produced by `produce_seal.py` and checked by
  `verify_seal.py`.

