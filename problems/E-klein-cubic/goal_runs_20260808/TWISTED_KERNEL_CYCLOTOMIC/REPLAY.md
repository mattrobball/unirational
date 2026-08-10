# Replay

From `/Users/worker/unirational`, run

```bash
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/TWISTED_KERNEL_CYCLOTOMIC/verify.py
```

Expected output:

```text
TWISTED-C11-CYCLOTOMIC-SELF-ISOGENY-OK
alpha=zeta^3-zeta^2-zeta-1 norm=11 smith=(1,1,1,11)
chow_invariants_codim_1_to_4=0 first_nonzero_codim=5
```

This is a fixed calculation on one analytically determined rank-four lattice
and one forced five-weight orbit.  It performs no search.

