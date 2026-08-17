"""Shared post-emit hook for the module-system migration.

Every emitter calls `reapply_module_annotations()` after writing its files,
so regenerated output always carries the visibility annotations recorded in
scripts/migration_stage*.json (see MODULE_MIGRATION.md). The applier is
idempotent; files not covered by any config are left untouched.
"""
import glob
import os
import subprocess
import sys

_SCRIPTS = os.path.dirname(os.path.abspath(__file__))


def reapply_module_annotations() -> None:
    for cfg in sorted(glob.glob(os.path.join(_SCRIPTS, "migration_stage*.json"))):
        subprocess.run(
            [sys.executable, os.path.join(_SCRIPTS, "module_migrate.py"), cfg],
            check=True,
            stdout=subprocess.DEVNULL,
        )
