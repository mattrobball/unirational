#!/usr/bin/env python3
"""Seal the C6 packet after verifiers are green."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    files = [
        "INPUT_MANIFEST.json",
        "five_form_matrix.json",
        "quartic.json",
        "rank_strata.json",
        "point_search.json",
        "produce_meta.json",
        "residual_search.json",
        "exact_points.json",
        "produce_residual_meta.json",
        "FIVE_FORM_MATRIX.md",
        "DETERMINANTAL_MODEL.md",
        "RANK_STRATA.md",
        "POINT_SEARCH.md",
        "POINT.md",
        "STATUS.md",
        "REPLAY.md",
        "produce.py",
        "produce_residual.py",
        "verify_matrix.py",
        "verify_model.py",
        "verify_point.py",
        "verify_residual.py",
        "c6_core.py",
        "c6_exact.py",
        "phase_morita_descent/produce_descent.py",
        "phase_morita_descent/verify_descent.py",
        "phase_morita_descent/descent.json",
        "phase_morita_descent/produce_meta.json",
        "phase_morita_descent/DESCENT.md",
        "phase_positive_degree/produce_positive.py",
        "phase_positive_degree/verify_positive.py",
        "phase_positive_degree/positive_degree.json",
        "phase_positive_degree/produce_meta.json",
        "phase_positive_degree/POSITIVE_DEGREE.md",
    ]
    also = [
        "C6-FIVE-FORM-MATRIX-PASS",
        "C6-RANK-STRATUM-REDUCTION-PASS",
    ]
    if (HERE / "exact_points.json").exists():
        also.append("C6-EXACT-SPLIT-POINTS-PASS")
    if (HERE / "phase_morita_descent" / "descent.json").exists():
        also.append("C6-MORITA-DESCENT-OBSTRUCTION")
    if (HERE / "phase_positive_degree" / "positive_degree.json").exists():
        also.append("C6-POSITIVE-DEGREE-RESIDUAL")
    payload = {
        "format": "c6-seal-v3",
        "primary_exit": "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS",
        "also_achieved": also,
        "not_achieved": ["C6-POINT-HEADLINE-POSITIVE"],
        "headline": "OPEN",
        "files": {
            name: {
                "sha256": sha256_file(HERE / name),
                "bytes": (HERE / name).stat().st_size,
            }
            for name in files
            if (HERE / name).exists()
        },
        "marker": "C6_SEAL_OK",
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2) + "\n")
    # SHA256SUMS companion
    lines = []
    for name, meta in payload["files"].items():
        lines.append(f"{meta['sha256']}  {name}")
    (HERE / "SHA256SUMS").write_text("\n".join(lines) + "\n")
    print("C6_SEAL_OK")


if __name__ == "__main__":
    main()
