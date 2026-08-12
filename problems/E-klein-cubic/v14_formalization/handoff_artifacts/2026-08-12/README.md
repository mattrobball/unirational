# Archived exploratory plus packet

These files preserve the exact exploratory sigma-plus inputs used for the
2026-08-12 handoff.  They are **not** accepted Lean certificates and are not
imported by the project.

Contents:

- `export_sigma_plus_segre.py`: exact exploratory generator;
- `sigma_plus_smooth_mod89.m2`: exact mod-89 chart replay;
- `sigma_plus_segre_REPORT.md`: scope and interpretation report.

The one-line JSON packet is not duplicated here.  Run the archived generator
from the repository path recorded in `HANDOFF_BASELINE_2026-08-12.md`; it
recreates `/tmp/sigma_plus_segre_Ki.json` with expected SHA-256
`52c1280a0a5e84128432db79e4d95753efe52a73d49a0fa450e69798a64965dc`.

The first completion task, WO-00 in `WORK_ORDERS_2026-08-12.md`, must refactor
the generator to remove its absolute path and `/tmp` writes, add `--out-dir`,
and install a reproducible packet under `scripts/` and `results/`.  Do not
import or cite this archive as a kernel theorem.
