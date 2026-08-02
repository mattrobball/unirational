#!/usr/bin/env python3
"""G3A producer: refresh compact ledgers (field_model, phi_exact via verify_phi)."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    # Re-bind generic cubic hash into phi_exact by running verify_phi
    r = subprocess.run(
        [sys.executable, "-u", str(HERE / "verify_phi.py")],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    sys.stdout.write(r.stdout)
    sys.stderr.write(r.stderr)
    if r.returncode != 0:
        raise SystemExit(r.returncode)

    # Refresh field_model binding hash
    table = ROOT / "tmp/kproj_arithmetic/normalized_kproj_table.json"
    fm = json.loads((HERE / "field_model.json").read_text())
    fm["structure_constants_sha256"] = sha256(table)
    (HERE / "field_model.json").write_text(json.dumps(fm, indent=2) + "\n")
    print("G3A_PRODUCE_OK")


if __name__ == "__main__":
    main()
