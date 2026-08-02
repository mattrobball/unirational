# Replay

From the root of the containing `Q_SCHUR_INDEX_ONE` packet, run:

```bash
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  h_trace_three_kummer_laurent/verify.py
```

The terminal marker is

```text
H_TRACE_THREE_KUMMER_LAURENT_MONOMIAL_ALL_EXPONENT_EXCLUSION_OK
```

The replay uses exact integer support arithmetic and exact cyclotomic
coefficients reconstructed by the hash-bound upstream packet.  It performs no
random search and has no exponent cutoff.  On the reference machine it takes
about one minute.
