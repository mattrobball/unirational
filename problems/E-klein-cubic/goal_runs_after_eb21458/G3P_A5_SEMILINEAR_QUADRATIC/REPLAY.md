# Replay

From this packet directory:

```bash
python3 -u produce.py
python3 -u verify.py
```

Expected markers:

```text
G3P_A5_SEMILINEAR_PRODUCE_OK
G3P-A5-SEMILINEAR-MATERIALIZATION-PASS
G3P-A5-CANONICAL-POLAR-MISS
G3P_A5_SEMILINEAR_VERIFY_OK
```

No external CAS or network access is required. The producer reconstructs the
finite-field Reynolds models; the verifier does not import the producer and
rebuilds the cubic classifying maps from generator-equivariance equations.
