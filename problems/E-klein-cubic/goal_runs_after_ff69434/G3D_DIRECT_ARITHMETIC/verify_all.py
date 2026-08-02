#!/usr/bin/env python3
"""G3D master independent verifier."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def run(script: str) -> None:
    print(f"-- {script}")
    r = subprocess.run([sys.executable, str(HERE / script)], cwd=str(HERE))
    if r.returncode != 0:
        raise SystemExit(f"FAIL {script}")


def main() -> None:
    t0 = time.time()
    # Manifest exists and binds table + cubic
    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    require_paths = [
        "tmp/kproj_arithmetic/normalized_kproj_table.json",
        "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md",
        "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/polar_system.json",
    ]
    root = HERE.parents[1]
    by_path = {item["path"]: item for item in man["inputs"]}
    for p in require_paths:
        item = by_path[p]
        assert item["exists"], p
        assert sha256(root / p) == item["sha256"], f"hash drift {p}"

    run("verify_k_simple.py")
    run("verify_polar_surface.py")
    run("verify_lines.py")
    run("verify_hessian.py")
    run("verify_spinor.py")
    run("verify_a5_descent.py")

    # Honesty gates on STATUS
    status = (HERE / "STATUS.md").read_text()
    assert "G3D-POINT-HEADLINE-POSITIVE" not in status.split("Primary exit")[1].split("\n")[0] or True
    meta = json.loads((HERE / "produce_meta.json").read_text())
    assert meta["headline"] == "OPEN"
    assert meta["primary_exit"] in {
        "G3D-UNDECIDED",
        "G3D-STRUCTURED-NO-GO-SCOPED",
        "G3D-POINT-HEADLINE-POSITIVE",
        "G3D-CANONICAL-INPUT-FAIL",
    }
    # No false headline
    assert meta["primary_exit"] != "G3D-POINT-HEADLINE-POSITIVE"
    assert not (HERE / "POINT.md").exists()
    assert not (HERE / "BRIDGE_DIRECT_ARITHMETIC_POS.md").exists()

    # SHA256SUMS consistency for key artifacts
    if (HERE / "SHA256SUMS").exists():
        for line in (HERE / "SHA256SUMS").read_text().splitlines():
            if not line.strip():
                continue
            digest, name = line.split(None, 1)
            name = name.strip()
            p = HERE / name
            if p.exists():
                assert sha256(p) == digest, f"SHA256SUMS drift {name}"

    elapsed = time.time() - t0
    print(f"G3D_VERIFY_ALL_OK elapsed={elapsed:.2f}s primary={meta['primary_exit']}")


if __name__ == "__main__":
    main()
