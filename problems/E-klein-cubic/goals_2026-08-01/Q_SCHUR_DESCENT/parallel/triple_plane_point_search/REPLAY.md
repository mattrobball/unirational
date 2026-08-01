# Replay

From this directory run:

```bash
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 verify.py
```

The terminal marker is

```text
H_TRACE_THREE_KUMMER_LAURENT_MONOMIAL_ALL_EXPONENT_EXCLUSION_OK
```

The replay uses exact integer support arithmetic and exact cyclotomic
coefficients.  It hash-checks the canonical 32,505-byte serialization of all
700 upstream contributions, so harmless installed-layout edits do not affect
the binding.  It performs no
random search and has no exponent cutoff.  On the reference machine it takes
about one minute.
