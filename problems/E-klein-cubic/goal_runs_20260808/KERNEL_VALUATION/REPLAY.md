# Replay

From `/Users/worker/unirational` run

```bash
/opt/homebrew/bin/python3 problems/E-klein-cubic/goal_runs_20260808/KERNEL_VALUATION/verify.py
```

Expected output:

```text
KERNEL-VALUATION-COPRIME-AND-BRANCH-AUDIT-OK
character_multiplier=9 point_multiplier=5
descent_difference=(0, -44, -11, -11, -22) c_exponents=(0, -4, -1, -1, -2)
explicit_semilinear_descent_order=5
branch_support_augmentation_rank=4
special_component_permutation_group_order=55
```

The script performs only fixed finite arithmetic on five exponents and eleven
component labels.  It is not a degree, support, or coefficient search.
