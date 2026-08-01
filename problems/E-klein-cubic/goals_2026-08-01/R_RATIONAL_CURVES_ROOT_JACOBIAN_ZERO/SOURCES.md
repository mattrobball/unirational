# Primary sources and exact use

All external geometric inputs below were checked against the primary paper,
not only a secondary summary.

1. Xavier Roulleau, *The Fano surface of the Klein cubic threefold*,
   arXiv:1001.4853, <https://arxiv.org/abs/1001.4853>.
   Used for the exact period lattice and the analytic actions of the
   order-11 and order-5 automorphisms.  The lattice is recomputed, not copied
   as a stored Boolean.
2. Arnaud Beauville, *Vector bundles on the cubic threefold*,
   arXiv:math/0005017, <https://arxiv.org/abs/math/0005017>.
   Proposition 5.2 is used for the twisted-cubic Abel--Jacobi image
   \(\Theta\) and generic fibre \(\mathbf P^2\).  The residual-line
   description of conics is also recorded there.
3. Arend Bayer, Sjoerd Viktor Beentjes, Soheyla Feyzbakhsh, Georg Hein,
   Diletta Martinelli, Fatemeh Rezaee, Benjamin Schmidt,
   *The desingularization of the theta divisor of a cubic threefold as a
   moduli space*, Geometry & Topology 28 (2024), 127--160,
   <https://arxiv.org/abs/2011.12240>, DOI
   <https://doi.org/10.2140/gt.2024.28.127>.
   Theorem 7.1 and Proposition 7.2 are used for the moduli fourfold, the
   blowup of theta at zero, the exceptional divisor \(X\), and the
   surjective map from generalized twisted cubics.
4. Atanas Iliev and Dimitri Markushevich, *The Abel-Jacobi map for a cubic
   threefold and periods of Fano threefolds of degree 14*,
   arXiv:math/9910058, <https://arxiv.org/abs/math/9910058>.
   Theorem 5.2 is used only to document the rational-quartic boundary: its
   fibre-birational-to-\(X\) statement assumes a generic cubic and is not
   applied to the Klein cubic.
5. Joe Harris, Mike Roth, and Jason Starr, *Curves of small degree on cubic
   threefolds*, arXiv:math/0202067,
   <https://arxiv.org/abs/math/0202067>.  Used for the all-smooth-cubic
   irreducibility and dimensions of the rational quartic and quintic loci,
   the length-16 bisecant scheme for a general quartic, and the
   trisecant/cubic-scroll description of quintics.  Proposition 5.1 and
   Corollary 5.2 give the quartic-elliptic residual-line morphism; Theorem
   10.1 gives the degree-five genus-two residual line and normalized
   component.
6. Joe Harris, Mike Roth, and Jason Starr, *Abel-Jacobi maps associated to
   smooth cubic threefolds*, arXiv:math/0202080,
   <https://arxiv.org/abs/math/0202080>.  Used for dominance and the
   irreducible unirational general fibres of the rational-quartic and
   rational-quintic Abel--Jacobi maps.  The source says "general fibre";
   this packet does not promote it to the distinguished canonical zero
   fibre after twisting.

Repository inputs:

- `../GOAL_R_RATIONAL_CURVES_ON_TWIST.md` for the assignment and exit codes;
- `../../RESOLUTION.md`, “Other audited boundaries,” for the genuine
  generic-twist no-line theorem;
- `../../SPEC.md` for the distinction between \(K_{\rm proj}\) and
  \(K_{\rm Schur}\) and for the generic-twist bridge.
- at live commit `9f58d6cbe889997fbd8af2fc23bf9ef0e28a55e2`,
  `../R_RATIONAL_CURVES_CODEX/probe_jacobian_fixed.py` gives an independent
  common-fixed-space computation modulo 5 and 11.  It was replayed and
  returned full rank 10 at both primes.

The downloaded PDFs, rendered pages, extracted text, and HRS TeX sources
used for inspection are under `tmp/`.  The large files are not directly in
the content seal; `source_manifest.json` records their URLs, exact SHA-256
digests, claim locations, and rendered pages, and the top-level verifier
checks every cached primary source.
