# Exact r66 Singular retry packet

## Outcome

```text
PREPARED_NOT_RUN
P25-UNDECIDED
```

No Singular, msolve, or other CAS process was launched.  The packet prepares
an exact retry after the shared memory load is gone; a timeout, resource stop,
crash, missing result, scalar nonunit, or non-full selected module remains a
strict nonverdict.

## Exact affine chart

The sealed upstream tensor has shape `66 x 6 x 9139` over `F_89` and SHA-256

```text
b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84
```

Independent specialization at `q0=1, b1_0=1` produced 66 equations in 41
variables with 2,363,052 printed terms.  Re-encoding them in the canonical
msolve format gives

```text
9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b
```

exactly the existing immutable chart hash.  Thus the Singular include is a
regeneration of the same chart, not a sampled or modified system.  The ring
declarations `ring R=89,...` implement the exact prime field `F_89`.

## Strongest lower-memory retry

For Stage B, the 66 rows of `P3(q)` generate a module `N` in
`R^6`, where `R=F_89[q1,...,q36]` on `q0=1`.  At a geometric point, a
nonzero projective `b1` lies in the kernel exactly when the specialized rows
fail to span the six-dimensional fibre.  Hence

```text
N = R^6
```

proves the entire Stage-B fibre over `q0=1` empty, and is stronger than the
single affine chart `b1_0=1`.

The strongest prepared job first applies an independently verified invertible
constant `66 x 66` row transformation.  In the exact `(dp,C)` input-term
order its 66 leading pivot columns form the identity.  This preserves `N`
exactly while removing the original 66-fold common leading-term collision.
The job then runs `std` with `option(notBuckets)` and without `redSB` or a
degree bound:

```text
r66_stageB_q0_1_all_b_module_preconditioned_std_notBuckets.sing
SHA256 09e393aec8b996b55b601c08a098c420d0ebac9c6079ca1e2e55ab4d92c28917
```

`(dp,C)` is a global degree-reverse-lexicographic term-over-position order,
so a completed standard basis is exact over the polynomial ring.  The order
does not change the row module or the equality criterion.  Singular's
installed manual states that `notBuckets` usually decreases memory at the
cost of time; that makes it the justified memory-critical setting.  No
regularity/Nullstellensatz degree bound is known, so none is asserted.

Literal scalar `std` jobs in both q-first and b-first variable orders are also
sealed.  Both use one global `dp` block, so variable order changes only the
tie-break and not the unit-ideal criterion.  A `slimgb` input is retained only
as a fallback: the earlier r64 module trace crossed 8 GiB, so it is not the
recommended low-memory route.  Elimination block orders were not promoted;
they would force determinantal/elimination expansion without evidence of a
memory benefit.

## Prior failures respected

The ordinary r66 msolve run completed degrees four and five, then its
all-pairs degree-six round exceeded 4 GiB before completion.  Signature mode
rejected the dehomogenized input and reported the wrong characteristic.  The
new packet neither repeats signature mode nor treats either stop as evidence.

## Future command (not run)

Only after the shared PID is gone and sufficient memory is available:

```bash
/opt/homebrew/bin/python3 -u \
  P25_LANDING_SUPPORT/parallel/r66_singular/run_bounded_singular.py \
  P25_LANDING_SUPPORT/parallel/r66_singular/r66_stageB_q0_1_all_b_module_preconditioned_std_notBuckets.sing \
  --timeout 7200 --rss-gib 4 --shared-pid 13036
```

The runner refuses a live or uncheckable shared PID, verifies the immutable
job hash, polls RSS through `libproc`, and fails closed if RSS polling is
unavailable.  Even a clean exit requires independent result auditing; only
`full=1`, `remainder_zero=1`, and `quotient_dim=-1` is decisive.

## CAS-free replay

```bash
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/r66_singular/verify_prepared_jobs.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/r66_singular/verify_preconditioned_module.py
/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/r66_singular/verify_seal.py
```

Expected markers:

```text
PASS_R66_SINGULAR_PREPARED_NOT_RUN_AUDIT
PASS_PRECONDITIONED_R66_MODULE_PREPARED_NOT_RUN
PASS_R66_SINGULAR_PREPARED_NOT_RUN_SEAL
```

