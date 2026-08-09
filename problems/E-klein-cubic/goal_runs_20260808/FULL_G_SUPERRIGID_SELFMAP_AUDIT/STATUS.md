# Status

Full-\(G\) birational superrigidity does not, by itself, exclude all
dominant generically finite \(G\)-rational selfmaps.  Applied to the
pullback hyperplane system, its exact conclusion is canonicity of
\((X,(2/n)\mathcal M)\); the restriction degree remains in the unresolved
base-ideal intersection terms.

There is a new unconditional family of exclusions.  Degree two is
impossible: the
unique quadratic deck involution centralizes \(G\), while
\(G\)-superrigidity identifies the equivariant birational group
\(\operatorname {Bir}^G(X)\) with the equivariant regular group
\(\operatorname {Aut}^G(X)\).  Since \(\operatorname{Aut}(X)=G\) and
\(Z(G)=1\), this centralizer is trivial.  The same argument excludes every
cyclic Galois restriction extension.  More generally, the ATLAS maximal
subgroup list gives minimal faithful permutation degree \(11\) for \(G\),
so every Galois restriction degree from \(2\) through \(11\) is excluded.

For a non-Galois extension the deck group can be trivial, so this argument
does not exclude degrees three and higher.  A full degree-one theorem still
requires either the Mori hypotheses on the normalized graph or new control
of the actual ambient landing base ideal.

```text
FULL-G-MOBILE-SYSTEM-IS-CANONICAL
FULL-G-NOETHER-FANO-DOES-NOT-DETERMINE-DEGREE
FULL-G-STEIN-MORI-HYPOTHESES-GIVE-DEGREE-ONE
FULL-G-RESTRICTION-DEGREE-TWO-EXCLUDED
FULL-G-CYCLIC-GALOIS-RESTRICTION-EXCLUDED
FULL-G-GALOIS-DEGREES-TWO-THROUGH-ELEVEN-EXCLUDED
FULL-G-NONGALOIS-DECKLESS-BRANCH-OPEN
FULL-G-ARBITRARY-DEGREE-GREATER-ONE-GATE-OPEN
HEADLINE-OPEN
```

Replay from `problems/E-klein-cubic`:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/FULL_G_SUPERRIGID_SELFMAP_AUDIT/verify.py
```
