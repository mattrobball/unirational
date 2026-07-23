# Certificate environment

Run the certificates from the repository root.

`quartic_tangent_residual_checks.py` requires SymPy.  The recorded log was
generated with Python 3.14.6 and SymPy 1.14.0:

```bash
python3 -c 'import sys, sympy; print(sys.version.split()[0], sympy.__version__)'
python3 problems/D-2d-conic-bundles/certificates/quartic_tangent_residual_checks.py
```

On the machine used for the committed run, the SymPy-enabled interpreter is
`/opt/homebrew/bin/python3`; Apple's `/usr/bin/python3` does not include
SymPy.  A different Python 3 installation is fine once `import sympy`
succeeds.

The remaining forty-eight checkers use only the Python standard library:

```bash
python3 problems/D-2d-conic-bundles/certificates/quartic_residual_cover_invariants.py
python3 problems/D-2d-conic-bundles/certificates/bitangent_incidence_invariants.py
python3 problems/D-2d-conic-bundles/certificates/flex_incidence_invariants.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_uniform_dualizing_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_stability_frontier_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_multijet_reduction_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_residual_saturation_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_ramification_comparison_checks.py
python3 problems/D-2d-conic-bundles/certificates/special_seed_boundary_fold_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_double_decic_frontier_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_six_proper_centers_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_singleton_root_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_repeated_root_frontier_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_quintic_factor_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_two_essential_tree_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_two_essential_partition_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_two_repeated_trees_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_three_essential_tree_checks.py
python3 problems/D-2d-conic-bundles/certificates/k1_uniform_six_center_conic_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_double_dodecic_frontier_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile5_three_line_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_primitive_base_scheme_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile432_proximity_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_combined_proper_cluster_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_degree2_square_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile3332_properness_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_higher_square_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_quintic_component_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_line_square_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_basepointfree_line_square_transformed_bundle_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_quintic_offbase_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_line_square_offbase_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_line_square_base_aligned_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_quintic_transverse_base_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_quintic_base_cluster_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_cubic_quartic_component_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_base_retained_profile_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_isolated_degree2_square_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_remaining_all_proper_adjoint_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile3324_one_nonproper_singleton_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_one_nonproper_singleton_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_multiple_nonproper_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_n2_common_support_jet_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_n2_residual_boundary_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_n3_simultaneous_jet_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_n3_nonintegral_block_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_one_nonproper_singleton_offbase_checks.py
python3 problems/D-2d-conic-bundles/certificates/k2_profile327_nonproper_high_checks.py
```

The forty-nine `.log` files beside the scripts are the exact captured
outputs.  The scripts certify symbolic and numerical arithmetic.  The
geometric arguments are proved in the adjacent theorem notes:
`tangent_residual_limits_theorem.md`,
`bitangent_incidence_general_type.md`, `flex_incidence_general_type.md`,
`special_seed_uniform_dualizing_theorem.md`,
`special_seed_stability_frontier.md`,
`special_seed_multijet_reduction.md`,
`special_seed_residual_saturation.md`,
`special_seed_ramification_comparison.md`,
`special_seed_boundary_fold_theorem.md`,
`k0_du_val_exclusion_theorem.md`, and
`k1_double_decic_frontier.md`, with the final nested subrow handled in
`k1_nested_profile_exclusion.md` and the all-proper six-center subrow handled
in `k1_six_proper_centers_exclusion.md`.  The full six-singleton root
partition is handled in `k1_singleton_root_exclusion.md`.  The exact
shortcut obstruction is recorded in `k1_repeated_root_frontier.md`.
Integral quintic components are excluded in
`k1_quintic_factor_exclusion.md`; the first repeated tree is classified in
`k1_two_essential_tree_classification.md`, and its complete five-root
partition is excluded in `k1_two_essential_partition_exclusion.md`.  The
first four-root packages are `k1_two_repeated_trees_exclusion.md` and
`k1_three_essential_tree_pruning.md`; the uniform closure is
`k1_uniform_six_center_conic_exclusion.md`.  The class-\((1,2)\) arithmetic
ledger and current frontier are `k2_double_dodecic_frontier.md`,
`k2_profile5_three_line_exclusion.md`,
`k2_primitive_base_scheme_reduction.md`,
`k2_profile432_proximity_exclusion.md`,
`k2_combined_proper_cluster_exclusion.md`,
`k2_basepointfree_degree2_square_exclusion.md`,
`k2_profile3332_properness_exclusion.md`,
`k2_basepointfree_higher_square_reduction.md`,
`k2_basepointfree_quintic_component_exclusion.md`,
`k2_basepointfree_line_square_reduction.md`,
`k2_basepointfree_line_square_transformed_bundle_exclusion.md`,
`k2_isolated_quintic_offbase_exclusion.md`,
`k2_isolated_line_square_offbase_reduction.md`,
`k2_isolated_line_square_base_aligned_frontier.md`,
`k2_isolated_quintic_transverse_base_exclusion.md`,
`k2_isolated_quintic_base_cluster_exclusion.md`,
`k2_isolated_cubic_quartic_component_exclusion.md`,
`k2_isolated_base_retained_profile_exclusion.md`,
`k2_isolated_degree2_square_exclusion.md`,
`k2_remaining_all_proper_adjoint_reduction.md`,
`k2_profile3324_one_nonproper_singleton_exclusion.md`,
`k2_profile327_one_nonproper_singleton_exclusion.md`,
`k2_profile327_multiple_nonproper_frontier.md`,
`k2_profile327_n2_common_support_jet_reduction.md`,
`k2_profile327_n2_residual_boundary_exclusion.md`,
`k2_profile327_n3_simultaneous_jet_frontier.md`,
`k2_profile327_n3_nonintegral_block_exclusion.md`,
`k2_one_nonproper_singleton_offbase_exclusion.md`, and
`k2_profile327_nonproper_high_reduction.md`.
The isolated-line base-aligned note is a strict frontier theorem: it removes
the one-point off-base high-diagonal row and all positive-margin through-base
positions, but it does not claim that its retained rows are absent.
