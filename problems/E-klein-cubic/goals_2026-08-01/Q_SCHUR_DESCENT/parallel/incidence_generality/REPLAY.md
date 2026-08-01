# Replay

From `goals_2026-08-01` run:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/incidence_generality/probe_dominance.py
```

Expected output:

```text
section_smooth=True
differential_ranks=resolvent:9 joint:10 fixed_section:6
Q_SCHUR_RESOLVENT_DOMINANCE_EXACT
BOUNDARY generic quartets are good; Voisin does not select a generic quartic
```
