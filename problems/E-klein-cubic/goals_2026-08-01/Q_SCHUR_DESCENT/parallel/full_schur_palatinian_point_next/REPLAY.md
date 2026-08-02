# Replay

Run the ten-pencil replay from this directory:

```sh
/opt/homebrew/bin/python3 -u verify.py
```

The verifier checks the immutable external-source hashes, exact
`Q(zeta_11)` generator reduction, group orders, nonzero/independent Reynolds
maps, the installed characteristic-zero Palatini identification, and then
regenerates every factorization in `certificate.json`.

Expected terminal marker:

```text
FULL_SCHUR_TEN_PENCIL_IRREDUCIBILITY_REPLAY_OK
```

The replay intentionally ends with the scope line

```text
SCOPE: one full-constant-field pencil exclusion and nine Q(zeta_11)(x)-pencil exclusions; no K_Schur point and no binary verdict
```

Requirements: `/opt/homebrew/bin/python3` with NumPy and SymPy, and
`Singular` on `PATH`.  The three dense degree-five pair factorizations make
the replay take roughly two minutes on the reference machine.

Run the independent complete degree-nine replay with:

```sh
/opt/homebrew/bin/python3 -u verify_degree9_projective_emptiness.py
```

It independently checks the exact action reduction, characteristic-zero
multiplicity 19, Reynolds basis, and Palatini lift; regenerates all eigenline
and binary-factor clauses; then replays every branch of the exact linear SAT
certificate.  Expected terminal markers:

```text
FULL_DEGREE9_PROJECTIVE_EMPTINESS_FAST_LINEAR_SAT_OK
FULL_DEGREE9_CHAR0_PALATINI_LANDING_EXCLUSION_REPLAY_OK
```

The geometric logic is over the algebraic closure: every used nonzero binary
quartic is replayed as a product of four stored linear forms, all factor
choices are branched, and every terminal branch has coefficient rank 19.
The degree-nine replay took about three minutes under the reference load.
