# Replay

From `/Users/worker/unirational` run:

```text
python3 problems/E-klein-cubic/goal_runs_20260808/SCHUR_V14/audit.py
```

Expected terminal marker:

```text
SCHUR_V14_FIXED_NORMALIZER_AND_FORCED_BASE_AUDIT_OK
```

The script has two logically separate parts.

1. At the split good primes 881 and 1321 it reconstructs `2.G`, `U`, the
   `10'` summand `M`, and `V14`; it verifies the `C5/D10`, `C11/F55`,
   `C2/D12`, and `A5` fixed profiles, exact line stabilizers, and the `K12`
   incidence graph.  Geometric emptiness is certified by coefficient rank,
   not by a rational-point count.
2. At good primes 23, 67, 89, and 199 it independently obtains the complete
   multiplicities through degree ten by character averaging and CRT.  At
   23 it builds complete Reynolds bases, imposes the forced-line restriction,
   and checks the full pulled-back Pluecker coefficient rank.

The first part certifies the all-degree normalizer inputs.  The second is a
strictly bounded auxiliary result and is not a negative headline bridge.

