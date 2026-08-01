# Five-coordinate degree-12 scalar slice

## Exact scoped theorem

The complete scalar invariant space `R_12` has dimension 14.  Select the
displayed five independent Reynolds invariants in
`full_frame_r12d5_metadata.json`.  There is no nonzero covariant

`f = sum_i A_i q_i`

with all five Schur frame columns present and every `A_i` in that selected
five-dimensional coefficient space for which the Klein cubic vanishes
identically.

This is a 25-variable theorem about one explicit slice.  It is not the full
70-variable scalar `R_12` system, and it contains none of the genuinely new
degree-12 primitive covariants outside the scalar-frame module.

## Certificate

Over `(23,zeta_11=2)`, exact deterministic evaluation stabilizes at rank
1,225 among the 2,925 cubic monomials in the 25 coefficient variables.  The
first row is cross-checked by direct expansion.  Exact `msolve` completes and
its leading ideal contains `a0^3,...,a24^3`; hence its projective zero locus
is empty.  Independence of the selected Reynolds invariants modulo 23 and
proper specialization exclude this displayed slice in characteristic zero.

## Replay and boundary

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r12d5.py build --samples 3000 --stagnant 200
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r12d5.py solve --timeout 300 --threads 4
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  verify_full_frame_r12d5.py
```

The remaining nine scalar directions, non-scalar primitive covariants, and
all higher coefficient degrees remain open.  No full-twist verdict follows.
