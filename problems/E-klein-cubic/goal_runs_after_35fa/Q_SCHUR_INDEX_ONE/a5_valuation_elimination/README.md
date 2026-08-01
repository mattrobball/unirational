# A5 valuation-elimination packet

This packet combines the independently verified exact points on both generic
maximal-`A5` twists with the low-rank valuation theorem.  The resulting
twisted-map argument eliminates both `A5` classes from the genuine Schur
nonpoint frontier.

Replay:

```sh
/opt/homebrew/bin/python3 verify.py
```

The verifier hash-checks the retained inputs, reruns the direct exact
substitution for both `A5` points, and reruns the valuation theorem.
