# Replay instructions

## Requirements

- `/opt/homebrew/bin/python3`;
- `Singular` on `PATH`;
- `M2` (Macaulay2) on `PATH`.

No Magma installation or network access is required. All external inputs
are pinned repository files checked by `source_manifest.json`.

## Fast replay

From this directory:

```text
/opt/homebrew/bin/python3 verify_all.py
```

This regenerates the exact universal equations and descended-component
payload, independently verifies the Pfaffian identity and good-reduction
geometry, and checks the output contract. It ends with:

```text
R2_PACKET_VERIFY_OK
```

## Full dependency replay

```text
/opt/homebrew/bin/python3 verify_all.py --full
```

This additionally replays the exact period-lattice fixed subgroup, the
660-element group-cohomology calculation, the generic Schur-class
certificate, and the hostile representation-alignment audit. It ends with:

```text
R2_DESCENDED_COMPONENT_INDEPENDENT_VERIFY_OK
R2_PACKET_FULL_VERIFY_OK
```

## Seal

After the full replay:

```text
/opt/homebrew/bin/python3 make_seal.py
/opt/homebrew/bin/python3 verify_seal.py
```

The last command recomputes the file set, byte sizes, and SHA-256 digests
without importing the producer. Its terminal marker is:

```text
R2_SEAL_VERIFY_OK
```

The first line of `STATUS.md` is the machine-readable exit:
`R2-DESCENT-OBSTRUCTED`. This is a scoped route obstruction; it is not a
negative or positive solution of the Problem E headline.
