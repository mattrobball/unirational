# Replay the S19 literal-target closure

This packet proves exact emptiness of the goal-qualified loci in both live
Rao branches because the exact target simultaneously requires containment in
the cubic and proper finite intersection with the cubic.  It does not close
the corrected ambient-curve problem or the Klein-cubic headline.

No external packages or Magma are required.  From this directory run:

```text
python3 produce_certificate.py --check
python3 verify.py
```

The producer deterministically reconstructs the payload from pinned sources.
The verifier does not import it: it independently re-derives the ideal and
component contradictions, checks exact live-branch coverage, preserves the
upstream undecided boundary, and verifies the content seal.
