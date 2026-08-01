# Plane-cubic to degree-3 del Pezzo link

This directory is the exact payload for

\[
 X \xleftarrow{}\operatorname{Bl}_{X\cap\Pi}X
 \xrightarrow{}\mathbf P^1,
 \qquad \Pi=\{a_3=a_4=0\}.
\]

`intersection_payload.json` is the compact machine-readable ledger.
`produce.py` recomputes the specialization from the parent sparse covariant
formulas.  `verify.py` is independent of that producer: it contains a minimal
literal copy of the needed \(x,C,D\) formulas, rebuilds the plane equation,
checks smoothness in all projective charts, and recomputes the intersection
identities.

`section_payload.json` and `verify_section_frontier.py` separately check the
degree-55 orbit arithmetic and enforce the section-or-quartic-multisection
boundary.

Run the local checks:

```sh
/opt/homebrew/bin/python3 M_SARKISOV/links/plane_cubic_dp3/verify.py
/opt/homebrew/bin/python3 M_SARKISOV/links/plane_cubic_dp3/verify_section_frontier.py
```

or the sealed top-level replay:

```sh
/opt/homebrew/bin/python3 M_SARKISOV/verify.py
```
