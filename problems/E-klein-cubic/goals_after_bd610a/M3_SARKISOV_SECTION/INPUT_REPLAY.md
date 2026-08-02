# Input replay audit

The binding M2 packet has exit `M2-EXPLICIT-LINK-PASS`, but its current
top-level `verify.py` stops before mathematical replay because one sealed
upstream status hash drifted:

```text
path:     goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/STATUS.md
sealed:   e4ad4f1d11079815ad4efaa77e3c2cc5b39dc3b3a0faac138067e27efd9e82a0
current:  d005425b73d058247a8b9759da4710701ec1bf23577130e4a79997bd84264225
marker:   C-UNDECIDED
```

This status is not load-bearing for the selected Sarkisov link.  The current
manifest pins the new hash.  Independently, the following replay successfully:

```text
goal_runs_after_35fa/M_SARKISOV/links/schur_plane_012_dp3/verify_link.py
goal_runs_after_35fa/M_SARKISOV/verify_census.py
goals_2026-08-01/Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D/verify_all.py
goals_2026-08-01/Q_SCHUR_DESCENT/verify_quartic_frontier.py
goals_2026-08-01/Q_SCHUR_DESCENT/parallel/quartic_descent/verify_field_certificate.py
goals_2026-08-01/Q_SCHUR_DESCENT/parallel/root_secant/verify_resolvent_geometry.py
```

The selected-link and centre-census verifiers cover the exact frame,
smooth centre, graph, Mori/Cox data, simultaneous 55-line avoidance, and
degree-three/degree-55 zero-cycles.  None computes a rational section or the
27 lines of the generic cubic surface.

Accordingly the hash drift is recorded as non-load-bearing and is not labeled
`M3-CANONICAL-INPUT-FAIL`.  The packet does not claim that the old top-level
seal replays literally.

