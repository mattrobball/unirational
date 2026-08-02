# Replay — Packet L1 full polar range

Run from the packet directory:

```bash
python3 produce.py
python3 verify.py
python3 -m py_compile produce.py verify.py
```

Expected terminal markers:

```text
L1-FULL-RANGE-PASS
L1_FULL_RANGE_VERIFY_OK
```

The producer rewrites `FULL_RANGE.json` deterministically.  A clean replay must
leave its `self_sha256` unchanged.  The verifier does not import the producer;
it reconstructs the polarization and full coefficient ledger independently.

No external CAS, network access, compiled extension, or nonstandard Python
package is needed.
