# Replay

This packet is theorem/literature based.  Its verifier checks the pinned
source hashes, load-bearing source excerpts, theorem markers, and the OPEN
scope boundary.

Run from `problems/E-klein-cubic`:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/verify.py
```

Expected final line:

```text
FULL-G-RESTRICTION-DOMINANCE-PACKET-OK
```

This replay does not computationally prove the essential-dimension or
superrigidity theorems; it pins and audits the exact primary-source text used
for those inputs.
