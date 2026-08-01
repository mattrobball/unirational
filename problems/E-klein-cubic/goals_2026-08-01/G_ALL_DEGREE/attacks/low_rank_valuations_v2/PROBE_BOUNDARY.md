# Separate f5/f6 small-support probe

This file is deliberately separate from the `C1`-residue theorem.

The discovery script `probe_small_support_residue.py` uses the genuine five
Hilbert--90 columns `x,C,D,E,K` and the complete Hironaka coefficient basis
modulo `f5` or `f6`.  At prime 67 it tested:

- every one-atom and two-atom support in total degrees `16..40` at `f5`;
- every one-atom and two-atom support in total degrees `15..40` at `f6`;
- all three-atom supports at the first open degree, degree 16 for `f5` and
  degree 15 for `f6`;
- twenty exact source points on each divisor.

For a two-atom support, the script forms the binary landing cubic at every
sample point and computes their polynomial gcd over `F_67`.  Every gcd is a
unit; there are also no one-atom survivors.  At the first open degree the
three-atom search has no `F_67`-rational projective survivor.  In particular,
adding a single `E` or `K` atom to an `xCD` atom does not produce a lead in
this range.

The machine-readable output is `small_support_probe.json`.  Reproduce it by

```sh
/opt/homebrew/bin/python3 \
  G_ALL_DEGREE/attacks/low_rank_valuations_v2/probe_small_support_residue.py \
  --upper 40 --samples 20
```

## Strict boundary

This probe did **not** find a residue point.  It is not a full-frame support
decision:

- supports of size at least three above the first open degree are untested;
- the three-atom calculation is a rational-point screen over `F_67`, not a
  geometric Groebner certificate;
- arbitrary rational functions can involve many Hironaka atoms;
- no bounded degree range is an all-degree theorem.

Therefore the `f5` and `f6` divisorial completions remain open.  None of the
probe output is used in `THEOREM.md` or `certificate.json`.
