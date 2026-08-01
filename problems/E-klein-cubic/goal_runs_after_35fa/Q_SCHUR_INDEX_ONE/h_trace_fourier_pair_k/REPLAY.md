# Replay

From this directory run

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify.py
```

The verifier uses only the Python standard library.  It reconstructs the
trace coefficient supports in exact cyclotomic arithmetic and checks all
ten primitive monomial valuations and lower Newton hulls.  The terminal
marker is

```text
H_TRACE_FOURIER_TWO_BASIS_FULL_K_NEWTON_EXCLUSION_OK
```

The earlier ordinary factorization over `Q(epsilon)` is not part of this
replay and is not used as an irreducibility claim over the larger constant
field `C`.

