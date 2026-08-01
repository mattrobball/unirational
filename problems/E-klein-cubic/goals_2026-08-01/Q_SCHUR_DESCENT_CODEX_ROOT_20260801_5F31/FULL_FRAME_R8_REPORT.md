# Full five-coordinate (R_8) Schur-frame exclusion

## Exact scoped theorem

Let (q_0,\ldots,q_4) be the installed degree-eight Schur Reynolds frame and
let (R_8=\mathbf C[V_6]^{\widetilde G}_8), whose exact dimension is four.
There is no nonzero covariant

\[
  f=\sum_{i=0}^4 A_iq_i,\qquad A_i\in R_8,
\]

such that the original Klein cubic (F(f)) vanishes identically.  Thus the
complete 20-variable, five-frame-coordinate coefficient-degree-eight
ansatz is projectively empty in characteristic zero.

This is strictly broader than the previously installed ternary (R_8)
exclusions: all five frame coordinates vary simultaneously.  It is still a
bounded height-8 coefficient theorem, not a theorem about arbitrary
(K_{\rm Schur})-rational coefficients.

## Certificate

The calculation uses the split good fibre
((23,\zeta_{11}=2)).  Exact Reynolds averaging selects four scalar
invariants whose evaluation rank equals the characteristic-zero Molien
dimension of (R_8).  The five frame columns times these four invariants
give 20 coefficient variables.

For deterministic exact source evaluations, the polarized Klein equation
has a stabilized row rank of 700 among the 1,540 cubic coefficient
monomials.  The first row is independently compared with direct cubic
expansion.  Exact `msolve` completes and returns a 700-element leading
ideal containing

```text
a0^3, a1^3, ..., a19^3.
```

Hence the sampled homogeneous ideal is supported only at the affine origin,
so its projective zero locus is empty.  Every polynomial landing identity
must satisfy the sampled equations; therefore the complete special-fibre
landing locus is empty as well.  The coefficient locus is projective over
the good cyclotomic DVR and the selected (R_8) basis retains full rank, so
proper specialization excludes a characteristic-zero landing point in this
entire ansatz.

## Boundary

The theorem supplies no all-height cutoff.  A point of the full Schur twist
may use invariant coefficients of another degree or arbitrary rational
functions.  In particular this result does not choose between the rational
point and integral-quartic alternatives in `QUARTIC_FRONTIER.md`.

## Replay

From this directory:

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r8.py build --samples 2500 --stagnant 160
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r8.py solve --timeout 300 --threads 4
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  verify_full_frame_r8.py
```
