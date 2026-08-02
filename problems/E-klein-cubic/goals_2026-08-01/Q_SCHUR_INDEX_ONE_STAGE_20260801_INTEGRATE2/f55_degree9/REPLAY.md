# Replay

The generated `degree9.instance` is intentionally not checked in.  Regenerate
it and its summary with:

```sh
python3 -u generate_instance.py
```

Expected final marker:

```text
F55_DEGREE9_INSTANCE_REGENERATED_OK
```

Compile and replay the exact deletion directly:

```sh
c++ -O3 -std=c++17 delete_supports.cpp -o /tmp/f55_degree9_delete
/tmp/f55_degree9_delete degree9.instance
```

The full independent verifier reconstructs every all-character landing
equation by a separate enumeration, checks the exact generated-instance
hash, compiles the deletion checker, and reruns all `26912397` deletion
states:

```sh
python3 -u verify.py
```

Expected final marker:

```text
F55_DEGREE9_SINGLETON_CERTIFICATE_INDEPENDENT_REPLAY_OK
```

The full replay is intentionally expensive.  Remove the generated binary
afterward if desired; it is reproducible and not part of the source packet.
