# Replay

From the packet directory run:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify.py
```

The exact replay enumerates all coefficient partitions, every cyclic shift
system, and every integral-lattice solution.  It should finish with

```text
H_TRACE_TWO_LAURENT_ALL_EXPONENT_EXCLUSION_OK
```

The verifier requires SymPy for Smith normal form.  It imports no producer
or code from another packet.

