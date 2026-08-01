# Plane-cubic to degree-3 del Pezzo link

This directory is the exact payload for

\[
 X \xleftarrow{}\operatorname{Bl}_{X\cap\Pi}X
 \xrightarrow{}\mathbf P^1,
 \qquad \Pi=\{a_3=a_4=0\}.
\]

`intersection_payload.json` is the compact machine-readable ledger.
`produce.py` recomputes the specialization from the parent sparse covariant
formulas.  `verify.py` is independent of the producer: it contains a minimal
literal copy of the needed \(x,C,D\) formulas, rebuilds the plane equation,
checks smoothness in all projective charts, and recomputes the intersection
identities.

Run either the local check

```sh
/opt/homebrew/bin/python3 M_SARKISOV_CODEX_ROOT_20260801/links/plane_cubic_dp3/verify.py
```

or the sealed top-level replay

```sh
/opt/homebrew/bin/python3 M_SARKISOV_CODEX_ROOT_20260801/verify.py
```
