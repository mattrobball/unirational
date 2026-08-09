# Adversarial audit

1. **SL versus PSL.**  `SL2(F11)` acts on markings and linearly on `V_+`;
   `{+I,-I}` is 2-trivial on the stack and trivial on the Grassmannian.  The
   effective coarse group is `PSL2(F11)`.
2. **Natural versus representation action.**  The action on theta coordinates
   is induced by the normalizer lift of the same marking change, not imposed
   afterward.  Auxiliary theta choices alter only Heisenberg coordinates.
3. **Equivariance of `Theta_11`.**  The proof transports the ideal of quadrics
   and its multiplicity plane.  Invariance of the image is not used as a
   substitute.
4. **Same `V14`.**  The diagonal basis conversion and exact generator test
   identify the actual ten-dimensional summand.  Abstract Fano isomorphism is
   insufficient.
5. **Birational invariance.**  Raw fixed loci are used only as diagnostics.
   Non-unirationality is transferred through resolved maps; separation uses
   rigidity/Burnside theory.
6. **Compactification.**  The centralizer theorem is applied on the smooth
   projective `V14`, not directly to the open moduli variety.  No boundary
   fixed-stratum assumption is hidden.
7. **Final Gross--Popescu map.**  The parameter transformation law explicitly
   prevents standard-Klein equivariance for a fixed hyperplane.
8. **Outer automorphism.**  Relabeling `G` leaves the full image subgroup and
   superrigidity unchanged and cannot turn the `V14` Mori fiber space into
   the Klein cubic.
9. **Correspondence versus map.**  The universal incidence is a projective
   bundle/stable construction.  No finite degree, rational section, or
   single-valued dominant map is inferred.
10. **Headline scope.**  `GP-MODULI-NON-G-UNIRATIONAL` is a theorem about the
    natural modular action.  The packet explicitly does not claim
    `KLEIN-PSL2(11)-NONUNIRATIONAL` or a positive standard-Klein map.

Additional break test: the exact verifier checks that the Gross--Popescu
relations copied without the factor-two basis conversion are *not* stable
under the repository Fourier generator.  This catches the most likely false
positive in the representation comparison.
