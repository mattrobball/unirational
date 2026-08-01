# Status

```text
exit: COV-STRUCTURED-DEGREES-EMPTY-SCOPED
headline: OPEN
positive mission: NOT ACHIEVED
```

The bounded structured search is exactly resolved at its selected scope.
The first unresolved representatives of the `e>=7`, `e=1`, and `e=5`
normal-cone families have zero characteristic-zero global coefficient
module:

| degree | plane order | residual `e` | exact global dimension |
|---:|---:|---:|---:|
| 25 | 3 | 7 | 0 |
| 31 | 5 | 1 | 0 |
| 35 | 5 | 5 | 0 |

The proof uses complete exact Reynolds bases of dimensions 189, 410, and
637.  The stacked value/first/second-normal Taylor maps have full column
rank in the good holdout fibre `p=89`; hence a maximal minor is nonzero in
characteristic zero.  Split `p=67` independently gives the identical
filtrations.  Independent Molien reconstruction at `p=199` and `p=353`
checks the full basis dimensions.

Since each selected global module is already zero, all triple-line,
point-link, `C3`, marked-elliptic, scalar-multiple, composition, primitivity,
and landing constraints are vacuous on that module.  No candidate survives
to COV3 and `BR-COV-POS` is not applicable.

The separate primary-frame ansatz is also exactly empty in degrees 25, 31,
and 35 after 2,988, 16,013, and 32,340 primitive triples respectively, with
matching decisions at `p=89` and `p=199` and an independent polar verifier.

## Theorem boundary

This packet does **not** exclude degrees 25, 31, or 35.  The normal Taylor
calculation excludes every odd plane order `m>=3` there, but `m=1` remains
live.  In particular, the installed degree-25 strict 43-space and its full
landing scheme remain open.  The `m=1` degree-31 and degree-35 landing
modules are not decided here.  Empty selected families are not evidence for
an all-degree negative theorem, and the Klein-cubic unirationality headline
remains OPEN.

## Replay

From this directory:

```bash
/opt/homebrew/bin/python3 -u produce_ranking.py
/opt/homebrew/bin/python3 -u verify_ranking.py
/opt/homebrew/bin/python3 -u produce_sparse_frame.py
/opt/homebrew/bin/python3 -u verify_sparse_frame.py
/opt/homebrew/bin/python3 -u produce_global_jets_p67.py 25
/opt/homebrew/bin/python3 -u produce_global_jets_p67.py 31
/opt/homebrew/bin/python3 -u produce_global_jets_p67.py 35
/opt/homebrew/bin/python3 -u verify_global_jets_holdout.py 25
/opt/homebrew/bin/python3 -u verify_global_jets_holdout.py 31
/opt/homebrew/bin/python3 -u verify_global_jets_holdout.py 35
/opt/homebrew/bin/python3 -u produce_manifests.py
/opt/homebrew/bin/python3 -u verify_manifests.py
```

The aggregate verifier and seal replay are listed in `README.md` after the
seal is generated.
