# Full five-coordinate (R_10) Schur-frame exclusion

## Exact scoped theorem

Let `(q_0,...,q_4)` be the installed degree-eight Schur Reynolds frame and
let `R_10` be the complete four-dimensional degree-ten scalar invariant
space.  There is no nonzero covariant

`f = sum_i A_i q_i`, with every `A_i in R_10`,

on which the original Klein cubic vanishes identically.  This is the complete
20-variable coefficient-degree-ten ansatz, not a support slice.

## Certificate

Over the good fibre `(23,zeta_11=2)`, deterministic exact evaluation gives a
stabilized 700-dimensional space of landing equations in the 1,540 cubic
coefficient monomials.  Stacking these rows with the independently generated
`R_8` rows still has rank 700, so the two systems have the same row space in
the displayed basis coordinates.  Exact `msolve` completes and its leading
ideal contains `a0^3,...,a19^3`, proving projective emptiness.  Full rank of
the Reynolds basis modulo 23 and projective proper specialization exclude a
characteristic-zero point in this ansatz.

## Boundary and replay

This supplies no all-height cutoff and does not decide the full twist.

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r10.py build --samples 2500 --stagnant 160
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r10.py solve --timeout 300 --threads 4
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  verify_full_frame_r10.py
```
