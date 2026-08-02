P25-UNDECIDED

# Degree-25 landing support status

The complete projective degree-25 landing scheme is not yet decided.  No
characteristic-zero covariant has been constructed, and no exact certificate
empties the complete prime-89 special fibre.

The exact unresolved locus is now much smaller and has a finite certified
cover.  Put

```text
L8 = P<span(q4,...,q11)>,
H8 = (q0,...,q3,q12,...,q36).
```

Both Stage B and normalized Stage C are independently certified empty on
`L8`.  On `D(H8)`, Stage B is covered by 34 exact paired Reed--Solomon affine
opens, and Stage C by the 29 outside-q opens.  None of those remaining affine
opens has yet returned a unit ideal.

What is exact and independently replayed:

- P0: the rank-43 DVR model, landing-row rank `746`, `56` monic pivots, and
  all `690` residual seed relations;
- Stage A is empty;
- Stage B on `L8`: rank `10296/10296` with a nonzero selected determinant;
- normalized Stage C on `L8`: compatibility rank `6435/6435`;
- the r66 necessary contractions have augmented rank seven on every
  coordinate line, and the full Stage-B coefficient maps exclude
  `b1`-support one;
- the 34-open Stage-B complement cover and all theorem-scope guards.

The strongest remaining-chart attempt used the safe r66 contractions on
`q0=1,b1_0=1`.  Exact ordinary F4 completed degree five and entered degree
six, then was manually stopped at observed RSS `4,482,960 KiB` before any
basis or unit output.  Signature mode is unusable: it rejected the affine
input and reported a field different from `F_89`.  Both are strict
nonverdicts.

A byte-identical, independently regenerated pair-split retry is sealed under
`parallel/r66_pair_split/` with status `PREPARED_NOT_RUN`.  The runner no longer
requires `ps`: live RSS/census use libproc (+ sysctl argv).  The historical
4.5 GiB fence is retired as theater after the ~4.28 GiB incomplete stop; the
default fence is now **16 GiB** (flag range 8–32).  Launch remains **BLOCKED**
whenever a competing CAS is live (this session: COV/other heavy jobs) and was
not attempted.  See `LAUNCH_READINESS.md` and `ALTERNATE_ATTACK.md`.

Problem E therefore remains **OPEN**.  No degree-25 exclusion and no headline
theorem is claimed.
