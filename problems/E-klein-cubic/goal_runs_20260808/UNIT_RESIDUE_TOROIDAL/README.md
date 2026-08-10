# Unit residue versus free-prime residue: a toroidal local counterconfiguration

This packet studies the surviving coefficient distinction in
`SEMILINEAR_RANK3_DESCENT`:

```text
actual coefficient       c = r_2^-1              (Laurent unit),
soluble coefficient      c_d = N(d_0)/(d_0^3 d_1^2)
                         = (prod_i d_i)/(d_0^3 d_1^2),
                         d_i = r_i-r_(i+1).
```

The global distinction is real on the chosen affine torus: `c` has no
interior prime divisor, while `c_d` has the free prime orbit `(d_i)` with
valuation vector `(-2,-1,1,1,1)`.  The theorem below proves that this
distinction is not visible in a completed free-orbit birational invariant,
even after retaining all higher tame-symbol data.  On an equivariant toric
model, the actual unit coefficient has a boundary divisor orbit with exactly
the same vector.  The completed projective coefficient classes at the two
orbits are isomorphic, and both have a resolvent which is a uniformizer.

This is a counterconfiguration to a *local/toroidal* obstruction, not a
positive solution of the global trace equation.  A successful obstruction
must couple several divisor orbits globally.

See `THEOREM.md`.  Replay the finite arithmetic with

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/UNIT_RESIDUE_TOROIDAL/verify.py
```

Expected final marker:

```text
F55-FINITE-SPLIT-LOCAL-MATCHING-OK
```
