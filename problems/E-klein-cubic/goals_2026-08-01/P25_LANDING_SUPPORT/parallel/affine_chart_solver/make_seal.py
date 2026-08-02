#!/usr/bin/env python3
"""Hash the affine-chart worker packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = [
    "REPORT.md",
    "produce_affine_module.py",
    "run_bounded.py",
    "audit_affine_runs.py",
    "affine_chart_plan.json",
    "r64_combined_q0_eq_1_std.input.json",
    "r64_combined_q0_eq_1_std.run.json",
    "r64_combined_q0_eq_1_std.log",
    "r64_combined_q0_eq_1_std.sing",
    "r64_combined_q0_eq_1_slimgb.input.json",
    "r64_combined_q0_eq_1_slimgb.run.json",
    "r64_combined_q0_eq_1_slimgb.log",
    "r64_combined_q0_eq_1_slimgb.sing",
    "make_seal.py",
]


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    entries = []
    for name in FILES:
        path = HERE / name
        if not path.is_file():
            raise FileNotFoundError(path)
        entries.append({"path": name, "bytes": path.stat().st_size, "sha256": sha256_file(path)})
    payload = {
        "status": "SEALED_AFFINE_CHART_STRATEGY_NONVERDICT",
        "scope": (
            "Exact r64 combined-module formulation and two bounded q0=1 "
            "preflights; no chart emptiness or global support verdict."
        ),
        "theorem_status": "P25-UNDECIDED",
        "files": entries,
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("SEALED_AFFINE_CHART_STRATEGY_NONVERDICT")


if __name__ == "__main__":
    main()
