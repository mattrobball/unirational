# A5Q replay guide

All commands below are run from

```text
problems/E-klein-cubic/goal_runs_after_bd610a/A5Q_QUARTIC_RESCUE/
```

The durable verifier is read-only.  It uses only the Python standard library
and the content-addressed exact inputs listed in `INPUT_MANIFEST.json`.

## Complete independent replay

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_all.py
```

This reconstructs the primitive fields, both subgroup transports at the
primary and holdout primes, both rank obstructions, and the upstream exact
degree-eleven landing identities.  Its final marker is

```text
A5Q_INDEPENDENT_VERIFY_OK
```

The load-bearing intermediate lines include

```text
PASS input manifest hashes files=14
PASS primitive A5_class_1 p23 ... degree=11
PASS primitive A5_class_2 p23 ... degree=11
PASS transport p=89 A5_class_1 ... rank=5 product_rank=11
PASS transport p=89 A5_class_2 ... rank=5 product_rank=11
PASS transport p=199 A5_class_1 ... rank=5 product_rank=11
PASS transport p=199 A5_class_2 ... rank=5 product_rank=11
H3_EXACT_BOTH_A5_POINTS_VERIFIED
PASS scope: A5Q-DEGREE4-RESCUE-EMPTY-SCOPED only; no Problem E headline
```

For a fast replay after the separately sealed upstream exact packet has
already been checked, use

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_all.py --skip-upstream-exact
```

This deliberately ends with the partial marker

```text
A5Q_PARTIAL_FIELD_AND_TRANSPORT_VERIFY_OK
```

It does not emit the complete independent-verification marker because the
upstream exact landing identity was skipped.

The explicit Schur-frame exact replay is

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  ../../goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/exact_schur_frame/verify_all.py
```

and ends with

```text
Q_SCHUR_EXACT_FRAME_PACKET_VERIFY_ALL_OK
```

## Seal

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u make_seal.py --check
```

Expected marker:

```text
A5Q_SEAL_OK
```

## Audited resource use

The final complete replay on 2026-08-01 exited zero with

```text
runtime_seconds=65.12
maxrss_bytes=99647488
user_seconds=42.70
system_seconds=0.19
```

Resource measurements are operational metadata, not part of the
mathematical certificate.

## Producer replay

The producer commands intentionally rewrite their JSON outputs and are not
needed for ordinary verification:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u discover_modular_index11.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u produce_packet_artifacts.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u make_seal.py
```

Run them only when regenerating the packet.  The independent verifier never
imports producer code or accepts stored success booleans.
