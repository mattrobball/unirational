# Replay

Run from `problems/E-klein-cubic` with the Homebrew Python used by the
repository's exact certificates:

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_35fa/H_11_5_TWIST/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_35fa/H_11_5_TWIST/seal.py
/opt/homebrew/bin/python3 -u goal_runs_after_35fa/H_11_5_TWIST/verify.py
git diff --check -- goal_runs_after_35fa/H_11_5_TWIST
```

Expected markers, in order:

```text
H_11_5_PRODUCE_OK
H_11_5_SEAL_OK
H_11_5_INDEPENDENT_VERIFY_OK
```

`produce.py` verifies all pinned external hashes before writing payloads.
`seal.py` hashes every durable local file other than `SEAL.json` itself.
`verify.py` does not import the producer.  It independently reconstructs:

1. the order-55 monomial subgroup and its semidirect relation;
2. the authoritative canonical frame, determinant, and 35 coefficients;
3. the index-eleven invariant lattice;
4. the degree-five Fourier quotient and inverse map;
5. the degree-eleven Kummer relation and inverse projective map;
6. the Vandermonde trace frame and cyclic trace equation;
7. the invariant canonical transition in both generator directions;
8. the degree-33 coefficient isogeny and order-eleven witness;
9. exact seal coverage.
