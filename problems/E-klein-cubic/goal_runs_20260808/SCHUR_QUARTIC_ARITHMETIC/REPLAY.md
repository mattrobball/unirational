# Replay

Run from this directory:

```text
/opt/homebrew/bin/python3 verify_exact.py
/opt/homebrew/bin/python3 verify_good_primes.py
/opt/homebrew/bin/python3 verify_seal.py
/opt/homebrew/bin/python3 audit.py
```

Expected terminal markers:

```text
SCHUR-QUARTIC-KERNEL-COMPONENT-EXACT-OK
SCHUR-QUARTIC-RANK20-TWO-GOOD-PRIMES-OK
SCHUR-QUARTIC-ARITHMETIC-SEAL-OK
SCHUR-QUARTIC-ARITHMETIC-AUDIT PASS
```

`verify_exact.py` is an exact `Q(zeta_11)` audit.  It checks the cyclic Klein
Pfaffian, one forced `4 x 6` contraction matrix, its quartic maximal minors and
gcd, the `12 x 5` inverse, the localized rank-20/rank-4 conormal equality, and
the generic normal splitting at one exact point.

`verify_good_primes.py` repeats only the localized chart ranks at two good
primes.  Those reductions are regression checks; the theorem is the
characteristic-zero argument in `THEOREM.md` plus `verify_exact.py`.

No unbounded search or Groebner basis is run.

`SEAL.json` binds the theorem/status/replay documents, both exact scripts, the
audit, and the two sealed upstream Pfaffian inputs.  Run `verify_seal.py` before
using the packet from a copied location.
