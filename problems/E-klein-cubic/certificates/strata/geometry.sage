# geometry.sage — SageMath entry point for WP-1 / WP-3 geometry.
#
# STATUS (first dispatch, 2026-07-30): SageMath is NOT installed on this
# machine.  The director brief authorizes substitution by an equivalent exact
# computation, recorded in certificates/STRATA_MACHINE_INPUT_AUDIT.md.
#
# Substitutions used for Gate 1:
#   - Group/subgroup layer: GAP 4.15.1 via group_subgroups.g
#     (/opt/homebrew/Caskroom/miniforge/base/bin/gap)
#   - Exact Q(zeta_11) matrices and eigenspace/intersection closure:
#     certificates/strata/exact_strata.py (Python 3.14)
#   - Split-prime regression: same producer at p in {67,89,331}
#   - Number-field backup (available, not required for Gate 1):
#     Julia 1.12.6 with Oscar/Nemo/Hecke
#
# When SageMath becomes available, this file should:
#   1. Load the portable JSON packet strata_exact.json
#   2. Rebuild one representative of each stratum over CyclotomicField
#   3. Scheme-theoretically intersect with the Klein cubic
#   4. Cross-check orbit sizes and incidence with the JSON
#
# Do not invoke this file until `sage` is on PATH.  Bare name `gap`/`gp` are
# shell aliases for git commands in this environment — always use absolute paths.

print("geometry.sage: SageMath not required for Gate 1; see STRATA_MACHINE_INPUT_AUDIT.md")
