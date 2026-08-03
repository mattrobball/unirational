# tmp/ disposition inventory (2026-08-03)

tmp/ is local-only (untracked; Binding rule 5). This file accounts for every top-level tmp directory so the parity checker can detect new unaccounted scratch. 245 dirs are cited in the document corpus (NOTEBOOK.md, top-level docs, notebook_build reports) via route provenance; 117 were cited nowhere and were triaged 2026-08-03: 92 WORKDIR (CAS working dirs for known packets), 6 AUDIT-COPY, 19 DISTINCT-UNRECORDED (now recorded in E16/E35), plus utility dirs.

Total top-level `tmp/` directories: 362 (238 listed below under Corpus-cited, 124 listed under Triaged 2026-08-03 — of which 117 [92 WORKDIR + 6 AUDIT-COPY + 19 DISTINCT-UNRECORDED] were cited nowhere in the document corpus before this triage, and 7 utility/non-content dirs were already corpus-cited but are broken out here for completeness; 238 + 7 = 245 corpus-cited, 117 triaged-as-uncited = 362).

## Corpus-cited (route provenance)

Every name below is a top-level `tmp/` directory already cited (by route provenance) somewhere in the document corpus — NOTEBOOK.md, a top-level doc, or a notebook_build report. Listed here (not re-derived) so the parity checker can confirm every `tmp/` directory is accounted for in this file or NOTEBOOK.md.

`a_empty`, `agent_high`, `all_degree_arrangement_attack`, `audit_a1`, `char0_lift_p19_d5`, `char0_lift_p20_d5`,
`common_line_initial_module`, `covariant_arrangement_module`, `covariant_module`, `d12_block_attack`, `d12_line_restriction`, `d12_solver_strategy`,
`d25_overlap_check`, `d5_degree_bound_invariant_salvage`, `degree10_jacobian`, `degree11_feasibility`, `degree11_jacobian`, `degree12_jacobian`,
`degree12_jacobian_structural`, `degree13_opt`, `degree13_step2`, `degree14_feasibility`, `degree14_structural`, `degree15_structural`,
`degree16_exceptional_search`, `degree16_landing_probe`, `degree22_compression`, `degree23_common_line_landing`, `degree23_common_line_landing_independent_audit`, `degree24_landing`,
`degree24_landing_independent_audit`, `degree25_structural_probe`, `degree25_structural_probe_independent_audit`, `ed_binary_attack`, `fable_constrained_cokernel`, `fable_d12_bulk_correction_rank`,
`fable_d12_char0_bridge`, `fable_d12_joint_rank`, `fable_d12_koszul_rank`, `fable_d12_module_adversary`, `fable_d12_rees_sigma_interface`, `fable_d12_simultaneous_successor`,
`fable_d12_triangular_bulk_closure`, `fable_finite_d12_constrained`, `fable_first_gate_koszul`, `fable_first_gate_koszul_audit`, `fable_fixed_plane_boundary_adversary`, `fable_nonfactorized_feasibility`,
`fable_nonfactorized_successor`, `fable_nonfactorized_syzygy_obstruction`, `fable_nonlinear_first_gate`, `fable_order12_qsection_correction`, `fable_positive_construction`, `fable_relative_divisor_trace_obstruction`,
`fable_relative_q_trace_obstruction`, `fable_resolved_descent`, `fable_trisection_attack`, `fable_trisection_compatibility`, `fano14_degree12`, `fano14_degree16`,
`fano14_twist`, `full_scaled_frame_branch_line_hostile_audit`, `full_scaled_frame_degree_attack`, `full_scaled_frame_degree_hostile_audit`, `graded_symbolic_architecture`, `groebnerjl_change_matrix_pilot`,
`higher_compatibility_regularity`, `higher_compatibility_regularity_independent_audit`, `involution_exceptional_divisor`, `kls_a5_conductor_surface_feasibility`, `kls_a5_linearized_pencil_obstruction`, `kls_a5_logarithmic_divisor`,
`kls_actual_conductor_geometry`, `kls_actual_conductor_geometry_audit`, `kls_degree28_stein_fixed_point`, `kls_discrepancy_next_gate`, `kls_discrepancy_next_gate_audit`, `kls_divisor_ansatz`,
`kls_f5_normality`, `kls_f5_normality_audit`, `kls_first_jet_three_fiber`, `kls_first_jet_two_fiber`, `kls_full_support_p9_msolve`, `kls_global_foliation_theorem`,
`kls_minimal_contraction_attack`, `kls_nonstable_vertical_orbits`, `kls_proper_multiple_structure`, `kls_proper_multiple_structure_audit`, `kls_residue_next`, `kls_structural_audit`,
`kls_structural_successor`, `kls_vertical_divisor_geometry`, `kls_vertical_divisor_geometry_audit`, `kls_wstar_first_integrals`, `kproj_arithmetic`, `kproj_connection`,
`local_symbolic_rees`, `local_symbolic_rees_independent_audit`, `m1_border_module_m2`, `m1_compact_degree25`, `m1_compact_degree25_filtration_independent_audit`, `m1_compact_degree25_independent_audit`,
`m1_compact_graded_pilot`, `m1_cubic_slice_macaulay`, `m1_determinantal_geometry`, `m1_full_plane_block_rank`, `m1_landing_chart_fitting`, `m1_landing_commalg_pilot`,
`m1_qslice_border_dimension`, `m1_rank6_circuit_support`, `m1_rank6_schur_compression`, `m1_relative_border_maxslice`, `m1_relative_border_p19_d5`, `m1_relative_border_p20_d5`,
`m1_relative_border_p21_d5`, `m1_relative_border_p21_d5_design`, `m1_relative_border_rank28`, `m1_t1_char0_d35_gate`, `m1_t1_f3_colon_attack`, `m1_t1_f3_colon_degree35_audit`,
`m1_t1_propagation_design`, `m1_t1_saturation`, `m3_line_point_boundary`, `m3_line_point_boundary_independent_audit`, `ordinary_defect_support`, `ordinary_defect_support_independent_audit`,
`p25r`, `p25yb`, `pfaffian_25plus11_descent`, `pfaffian_25plus11_descent_audit`, `pfaffian_alpha_local_kummer`, `pfaffian_alpha_local_kummer_audit`,
`pfaffian_binary_cubic_attack`, `pfaffian_binary_cubic_geometric_audit`, `pfaffian_d5_constant_point`, `pfaffian_d5_constant_point_hostile_audit`, `pfaffian_d5_constant_section_audit`, `pfaffian_d5_degree_projective_audit`,
`pfaffian_d5_residual_attack`, `pfaffian_d5_residual_attack_audit`, `pfaffian_depressed_alpha_r`, `pfaffian_depressed_alpha_r_audit`, `pfaffian_depressed_torsor_next`, `pfaffian_depressed_torsor_next_audit`,
`pfaffian_explicit_descent`, `pfaffian_generic_schur_audit`, `pfaffian_global_fixed_frame_hostile_audit`, `pfaffian_minimal_ternary_model`, `pfaffian_minimal_ternary_model_audit`, `pfaffian_rank2_hostile_audit`,
`pfaffian_rank2_idempotent_attack`, `pfaffian_representation_alignment`, `pfaffian_representation_alignment_audit`, `pfaffian_six_sheet_branch_obstruction`, `pfaffian_six_sheet_fixed_direction_audit`, `pfaffian_ternary_cubic_hostile_audit`,
`pfaffian_ternary_cubic_triage`, `pfaffian_torsor_valuation_attack`, `pfaffian_torsor_valuation_attack_audit`, `plane_arrangement_hilbert`, `plane_genus_one`, `projective_source`,
`projective_source_degree12`, `projective_source_degree12_chart_probe`, `projective_source_degree12_extension`, `projective_source_degree12_extension_independent`, `projective_source_degree12_primitive_chart`, `projective_source_degree12_structural`,
`projective_source_degree12_support`, `quadratic_grassmannian_covariant`, `recent_equivariant_tools_2026`, `recent_structural_tools_audit`, `relative_kls_chart`, `relative_kls_hyperplane`,
`schur_degree19_nonacm_attack`, `schur_degree19_nonacm_attack_audit`, `schur_degree19_structural_design`, `schur_degree19_structural_design_audit`, `schur_fibration_picard_obstruction`, `schur_structural_routes`,
`schur_ternary_planes`, `schur_unrestricted_point_attack`, `schur_unrestricted_point_attack_audit`, `six_sheet_next_attack_redesign`, `step4_degree12_solver_terminal`, `step4_essential_dimension`,
`structural_degree13`, `symbolic_compatibility_complex`, `symbolic_compatibility_complex_independent_audit`, `symbolic_global_exactness`, `symbolic_landing_design`, `t2r`,
`target_branch_cubic_smoothness_line_probe`, `target_branch_delta_saturated_singularity`, `theta11_test`, `v4_surface_slice_audit`, `xcd_actual_class_image`, `xcd_algebraic_null_polar`,
`xcd_arithmetic_next`, `xcd_ca_class_group`, `xcd_char0_candidate_support`, `xcd_char0_candidate_support_audit`, `xcd_class_globalization_next`, `xcd_class_image_attack`,
`xcd_control_next`, `xcd_descent_algebra`, `xcd_descent_math`, `xcd_discriminant_divisor`, `xcd_first_descent_next`, `xcd_formal_algebraization_audit`,
`xcd_formal_mf_all_order`, `xcd_gauge_divisors`, `xcd_general_slice_completion`, `xcd_generic_cech_next`, `xcd_genuine_descent`, `xcd_global_defect_bridge`,
`xcd_invariant_fibre_discriminants`, `xcd_invariant_fibre_discriminants_audit`, `xcd_invariant_field`, `xcd_invariant_module_multiprime`, `xcd_invariant_module_support`, `xcd_local_class_defect`,
`xcd_local_grv_comparison_audit`, `xcd_low_height`, `xcd_magma_rank_audit`, `xcd_nonzero_kummer`, `xcd_picard_restriction`, `xcd_polar_function_field_degree`,
`xcd_rank_invariant_reduction`, `xcd_repeated_factor_incidence`, `xcd_residue_class_gate`, `xcd_singular_curve_enumeration`, `xcd_singular_curve_enumeration_audit`, `xcd_singular_locus_bound`,
`xcd_total_normality`, `xcd_zariski_descent_gate`, `xcd_zariski_morse_chart`, `zero_cycle_descent`.

## Triaged 2026-08-03

117 directories were cited nowhere in the document corpus as of 2026-08-03 and were triaged into WORKDIR / AUDIT-COPY / DISTINCT-UNRECORDED below; 7 additional utility/non-content directories (already corpus-cited) are listed here too for completeness.

### WORKDIR (92 dirs) — CAS working dirs for known packets

Scratch/working directories for CAS computation supporting an already-recorded packet; no independent content beyond what the cited entry already documents.

- `a1_pfaffian_bridge` → E26/E05 (Attempt1)
- `a2_global_fold` → E32/E05
- `a3_schur19` → E30/E05
- `a5_global_image` → E16/E05 (empty)
- `c0_audit` `c1_preflight` `c21_probe` `c21_work` `c2_preflight` `c3_preflight` `c3_work` → E07 (fano_c0-c3)
- `cas_phase0` → E02
- `cas_T` → E32
- `cas_P25` → E25
- `cas_G` → E34
- `agent_covariant` → E38
- `agent_11_12` `degree13_probe` `degree22_common_line` `degree22_even_line` `degree_bound_audit` `pathG_decision` `pathG_forkB` `postelo_G` → E16
- `degree10_jacobian_solver` `degree12_opt` `kls_cyclic_foliation_residues` `kls_degree25_singularity_probe` → E22
- `d5_degree_bound_projective_salvage` `d5_residual_kummer_attack` `pfaffian_d5_discriminant_attack` `pfaffian_global_linear_system_attack` → E06 (d5_degree_bound_projective_salvage ABANDONED)
- `full_scaled_frame_global_branch_extract` `target_branch_chow_obstruction` `target_branch_modular_design` `target_branch_picard_theory` → E32 (contested E06)
- `generic_plane` `generic_twist` → E39
- `geometric_point` → E26
- `cohomology_attack` → E45
- `secant_orbit` → E42
- `sextic_conic_section_gate` `pathF_existence` `pathF_frame` `postelo_F` → E13
- `lifting_wp_l2_e1` `lifting_wp_r0_l1` `strata_machine_wp01` `strata_machine_wp23` `strata_machine_wp4` `strata_machine_wp5` `strata_machine_wp6` → E34
- `postelo_G3` → E17 (empty)
- `postelo_T` `postelo_T2` `t10_binodal` `t10_modular` `t11_exact` `t11_modular` `t11b_routeC` `t2r45` `t8_core` `t8_modp` `t8_plane_sections` `t8n1_work` `t9_component` `t9_hensel` `v2_T` `wp_t1_mod3` → E32
- `root_local_defect_probe` → empty (0 files)
- `char0_lift_p16` `m1_full_plane_solver_probe` `m1_t1_f3_colon_frontier` `p25v_closure` `p25v_incidence` `p25v_preflight` `p25w3_work` `p25w_build` `p25w_closure` `p25w_stageA` `p25y_work` `p25yf4_border` `p25yf4_f4` `p25ym` `p25z1_build` `p25z1_probe` `p25z3_work` `v2_P25` → E25
- `pathA_collapse` `pathA_krylov` → E01
- `wp_h1_hodge` → E19
- `step1_current_audit` → E51

### AUDIT-COPY (6 dirs)

Independent-audit re-verification copies of an already-recorded packet's computation.

- `degree10_jacobian_audit` → E22
- `degree22_compression_independent_audit` → E16
- `m1_full_plane_block_rank_independent_audit` `m1_full_plane_q2k_independent_audit` `m1_full_plane_q3_independent_audit` `p25v_closure_replay_a0` → E25

### DISTINCT-UNRECORDED (19 dirs) — now recorded 2026-08-03

Genuinely distinct research content that was uncited anywhere until this sweep; each is now recorded as a research-lead / documented-dead-branch bullet in NOTEBOOK.md (see job 2 and job 3 of the 2026-08-03 coverage-frontier integration).

- `alternative_covariants` → E16 (recorded 2026-08-03)
- `xcd_base_two_jet_certificate` `xcd_defect_formula_audit` `xcd_explicit_integral_slice` `xcd_ic_slice_reduction` `xcd_lower_cech_fill` `xcd_lower_cech_local_chain` `xcd_lower_cech_total_chain` `xcd_mf_first_order` `xcd_mf_order2_obstruction` `xcd_mf_order3_obstruction` `xcd_mf_order4_obstruction` `xcd_rank_local_multiplicity` `xcd_singular_curve_census_audit` `xcd_slice_defect_design` `xcd_slice_defect_jet_probe` `xcd_slice_jet_factor` `xcd_slice_local_wh_gate` `xcd_slice_pole_edge_audit` → E35 (recorded 2026-08-03)

### Utility (7 dirs) — non-content / infrastructure

Non-content utility directories (caches, dispatch/build plumbing, PDF output, audit/repair scratch); already corpus-cited but broken out here for clarity.

- `__pycache__` `pdfs` `main` `dispatch` `notebook_build` `current_paths` `repair_docs` → utility / non-content dirs
