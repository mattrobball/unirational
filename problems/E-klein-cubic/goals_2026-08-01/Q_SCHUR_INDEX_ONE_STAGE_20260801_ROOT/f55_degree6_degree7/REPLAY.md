# Replay

From this directory, using the system Python:

```sh
python3 -u produce_certificate.py
python3 -u verify_certificate.py
```

Expected final markers:

```text
F55_DEGREE6_DEGREE7_SUPPORT_CERTIFICATE_OK
F55_DEGREE6_DEGREE7_CERTIFICATE_INDEPENDENT_REPLAY_OK
```

The producer enumerates all supports and writes `certificate.json`.  The
verifier independently reconstructs the complete covariant bases and landing
equations, uses a different deletion order at degree seven, and checks every
stored binomial incompatibility.
