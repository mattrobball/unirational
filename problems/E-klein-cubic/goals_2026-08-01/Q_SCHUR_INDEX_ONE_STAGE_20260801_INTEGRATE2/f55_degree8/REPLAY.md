# Replay

```sh
python3 -u produce_instance.py
python3 -u verify.py
```

Expected final markers:

```text
F55_DEGREE8_INSTANCE_OK
F55_DEGREE8_SINGLETON_CERTIFICATE_INDEPENDENT_REPLAY_OK
```

The verifier reconstructs the complete equations independently, compares
the exact binary instance byte-for-byte, compiles the deletion checker, and
runs both deletion orders.
