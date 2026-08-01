# Replay

From this directory run

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify.py
```

The standalone verifier uses only the Python standard library.  It should
finish with

```text
H_TRACE_FOURIER_TWO_BASIS_LAURENT_EXCLUSION_OK
```

