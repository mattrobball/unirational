# Replay

From `/Users/worker/unirational`, run

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/CHAR5_PROGRESSION_CLOSE/N7_STATIC_CERTIFICATE/verify.py
```

The checker uses only the Python standard library.  It reconstructs all 16
root-degree-seven systems over `F_5`, checks every recorded propagation and
conflict against its named row, and exhausts both children of every Boolean
branch.  Observed wall times have ranged from about 20 seconds to about two
minutes on the available audit machines; runtime is not part of the theorem.

Every family must print `UNSAT`.  The final lines must be

```text
TOTAL_NODES 141092 TOTAL_CONFLICT_LEAVES 70554
OPCODE_COUNTS {1: 16, 2: 54912, 3: 987612, 4: 4, 5: 70550, 7: 70538}
F55-CHAR5-DEGREE45-SUPPORT-UNSAT-CERTIFICATE-OK
```

To regenerate the explanatory core annotation, run

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/CHAR5_PROGRESSION_CLOSE/N7_STATIC_CERTIFICATE/annotate_core_1_1.py
```

Its terminal line must be

```text
N7-CORE-1-1-ANNOTATION-OK
```

`search_n7.cpp` is the exact integer/bit-mask development generator for the
static proof.  It is retained for auditability, but its search status is not
used by the verdict: `verify.py` plus `proof.bin` is the certificate.
