# Goal V3 — valuation/residue close-out

This packet consolidates all installed valuation results for the genuine
`PSL_2(F_11)` Klein twist and adds the missing rank/decomposition normal form.
It also converts the first timed-out `f5` bounded case into an exact sparse
support certificate.

## Governing exits

```text
Goal V:       V-UNDECIDED
Scoped V3:    V3-RESIDUE-NORMAL-FORM-PASS
Finite f5:    V-F5-DEGREE16-SUPPORT-LE5-EMPTY
Headline:     OPEN
```

## Main contents

- `RESIDUE_NORMAL_FORM_THEOREM.md` proves that every possible negative
  valuation is an unramified rank-at-most-two residue problem with
  decomposition group `G` or `11:5`.
- `F5_DEGREE16_SMALL_SUPPORT.md` proves exact degree-16 support emptiness
  through five of the nineteen quotient-basis coefficients.
- `f5_degree16_support_payload.json` stores the fixed points, invariant seeds,
  ranks, deficient kernels, and direct `Q*C` witness.
- `reproduce_f5_degree16_support.py` independently reconstructs the finite
  certificate.
- `audit_payload.json`, `verify.py`, and `SEAL.json` bind the theorem to the
  installed inputs and enforce the nonclaim boundary.

The packet deliberately leaves the full `f5`, `f6`, and `11:5` residue
binaries open.  Those are now the mathematical content of any surviving
valuation obstruction; no separate ramification, tropical, high-rank, index,
or maximal-`A5` shortcut remains.
