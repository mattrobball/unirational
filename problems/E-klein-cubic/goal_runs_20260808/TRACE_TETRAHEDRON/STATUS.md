# Status

```text
F55-TRACE-FOUR-TERM-ALL-EXPONENT-EXCLUSION
F55-GLOBAL-QUESTION-OPEN
```

Every nonzero constant-coefficient Laurent polynomial with exactly four
distinct support exponents has nonzero trace cubic.  The exponents are
unrestricted.  Together with the sealed `TRACE_TRIANGLE` packet and the
earlier one- and two-term cases, supports of cardinality at most four are
excluded.

The proof is an analytic branch reduction, not an exponent-box search:

```text
fixed points             -> residue partition 4 or 2+2
2+2 residues             -> empty
affine rank 3            -> norm-fibre recurrence -> empty
affine rank 1            -> leading jets + Vandermonde -> empty
affine rank 2, moment !=0 -> mixed jets + Vandermonde -> empty
affine circuit 1+3       -> positivity -> empty
affine circuit 2+2       -> rational rank-two landing exclusion -> empty
```

The final rank-two landing theorem uses four exact evaluations in the cyclic
factor case.  In the neither-cyclic case, an absolute-Galois zero-pattern
lemma forces the factor supports to be `U_14` and `U_23`; four explicit
nonzero cyclotomic coefficients finish the contradiction.

The earlier deletion-bridge parallelogram remains only a counterexample to
closure of that bridge method.  It is not a trace zero: the two full bridge
classes total `-36` and `-24`, and a singleton full-trace class survives with
coefficient `18`.

This sparse theorem does not bound general support, exclude five or more
terms, handle invariant-field coefficients or arbitrary rational functions,
prove `F55-NO`, or decide the original `PSL(2,11)`-unirationality question.
The global verdict is still **OPEN**.
