# Complete degree-six `11:5` landing-scheme exclusion

This packet proves the following exact bounded theorem.

For the maximal subgroup `H=11:5` in the Klein five-dimensional
representation, every complete homogeneous degree-six covariant landing
scheme in the Klein cubic is empty, for all five projective-character
multipliers from `H_ab=C5`.

The proof has three exact parts:

1. reconstruct the 19-dimensional coefficient space and all 640 cubic
   coefficient equations;
2. prove that the five character systems are diagonally isomorphic in degree
   six by `c_e -> zeta^(-k*s(e))*c_e`;
3. reduce character zero modulo 23 and cover its projectivization by the 19
   affine charts `c_i=1`; every chart has stored unit-ideal output from
   `msolve`.

Because the coefficient scheme is projective, the empty special fibre at 23
forces the characteristic-zero character-zero generic fibre to be empty.
The diagonal isomorphism then covers all five characters.  Combined with the
sealed predecessor packet, this gives the complete all-character exclusion in
degrees one through six.

Run the static independent replay with:

```text
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_all.py
```

To recompute the expensive Gröbner artifacts, run the 19 charts with a long
per-chart limit, then consolidate and verify:

```text
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u run_degree6_charts.py --workers 1 --timeout 3600
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u consolidate_degree6_results.py
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_all.py
```

## Strict boundary

This is a degree-six theorem only.  It is not an all-degree exclusion, does
not prove pointlessness of the generic `11:5` twist, and does not decide
whether the genuine generic Schur twist has a rational point.  The governing
binary status therefore remains `Q-UNDECIDED`.
