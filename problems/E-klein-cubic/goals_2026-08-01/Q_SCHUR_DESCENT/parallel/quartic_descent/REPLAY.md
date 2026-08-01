# Replay

Run from `goals_2026-08-01`:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 Q_SCHUR_DESCENT/parallel/quartic_descent/produce_field_certificate.py
PYTHONDONTWRITEBYTECODE=1 python3 Q_SCHUR_DESCENT/parallel/quartic_descent/verify_field_certificate.py

PYTHONDONTWRITEBYTECODE=1 python3 Q_SCHUR_DESCENT/parallel/quartic_descent/produce_linked_quintic_certificate.py
PYTHONDONTWRITEBYTECODE=1 python3 Q_SCHUR_DESCENT/parallel/quartic_descent/verify_linked_quintic_certificate.py

PYTHONDONTWRITEBYTECODE=1 python3 Q_SCHUR_DESCENT/parallel/quartic_descent/produce_geometry_certificate.py
PYTHONDONTWRITEBYTECODE=1 python3 Q_SCHUR_DESCENT/parallel/quartic_descent/verify_geometry_certificate.py
```

Expected terminal markers:

```text
Q_SCHUR_QUARTIC_FIELD_INDEPENDENCE_EXACT
Q_SCHUR_LINKED_QUINTIC_FIELD_LATTICE_EXACT
Q_SCHUR_QUARTIC_GEOMETRY_GATES_EXACT
```

Each verifier also prints an explicit `BOUNDARY` line.  The scripts use only
the Python standard library and do not use Magma or a group database.

