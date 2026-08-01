# Replay

Run from this directory with the repository dependencies already installed.

## Fast independent verification

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_all.py
```

## Regenerate the scoped systems

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r8.py all --samples 2500 --stagnant 160 \
  --timeout 300 --threads 4
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r10.py all --samples 2500 --stagnant 160 \
  --timeout 300 --threads 4
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_full_frame_r12d5.py all --samples 3000 --stagnant 200 \
  --timeout 300 --threads 4
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  probe_quartic_tangent_twisted_cubics.py --seeds 3
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  verify_quartic_tangent_probe.py
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  verify_primitive_quartic_tangent.py
```

These commands overwrite only generated artifacts in this isolated folder.
They do not write into the shared `Q_SCHUR_DESCENT/` directory.

## Parent exact inputs

The installed degree-55 line-orbit and full-twist arithmetic can be replayed
independently from the parent problem directory with:

```sh
/opt/homebrew/bin/python3 -u \
  tmp/schur_unrestricted_point_attack_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/schur_structural_routes/verify.py
/opt/homebrew/bin/python3 -u \
  tmp/schur_fibration_picard_obstruction/verify.py
/opt/homebrew/bin/python3 -u certificates/subgroup_orbit_check.py
```

Their exact scope is recorded in `WORKLOG.md`; none prints a full-twist
rational-point or pointlessness verdict.
