# Replay

Run from this directory with Python 3:

```sh
python3 produce_exact_counts.py --check
python3 verify_representation_counts.py
```

Expected terminal markers:

```text
DEGREE25-EXACT-COUNTS-CURRENT
DEGREE25-REPRESENTATION-COUNTS-OK
DEGREE25-DOCUMENT-BOUNDARY-OK
DEGREE25-PACKET-SEAL-OK
```

The script uses only the Python standard library. It verifies:

- the complete-homogeneous character values in degree 25;
- the exact cyclotomic order-11 contribution;
- the full eight-isotypic decomposition of \(\operatorname{Sym}^{25}W^*\otimes W\), including invariant dimension \(189\);
- the residual \(S_3\) elliptic and line multiplicities;
- the type-I/type-II node corrections;
- the full eight-isotypic decomposition of \(H^0(D,\mathcal O_D(25))\otimes W\), including invariant dimension \(41\);
- the degree-24 invariant scalar multiplicity \(5\) on a residual binary line;
- all hashes listed in `SEAL.json`.

No Gröbner basis, finite-field sweep, or coefficient search is used. The
terminal obstruction itself is the theorem in `THEOREM.md`, not a numerical
inference from this verifier.
