#!/usr/bin/env python3
"""Independent artifact/scope audit for the full-frame R10 exclusion."""

from __future__ import annotations

import hashlib
import json
import re
import sys
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "tmp" / "schur_ternary_planes"))
import core  # noqa: E402


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


metadata = json.loads((HERE / "full_frame_r10_metadata.json").read_text())
result = json.loads((HERE / "full_frame_r10_result.json").read_text())
rows_path = HERE / metadata["rows_file"]
leading_path = HERE / "full_frame_r10.leading.out"
input_path = HERE / "full_frame_r10.in"
log_path = HERE / "full_frame_r10.solve.log"

assert metadata["format"] == "Q-SCHUR-FULL-FRAME-R10-v1"
assert metadata["prime"] == 23
assert metadata["frame_degree"] == 8
assert metadata["coefficient_degree"] == 10
assert metadata["total_covariant_degree"] == 18
assert metadata["invariant_dimension"] == metadata["complete_invariant_dimension"] == 4
assert metadata["variable_count"] == 20
assert metadata["cubic_monomials"] == 1540
assert metadata["equation_rank"] == 700
assert len(metadata["invariant_seeds"]) == 4
assert digest(rows_path) == metadata["rows_sha256"]

rows = np.load(rows_path)["rows"]
r8_rows = np.load(HERE / "full_frame_r8_rows.npz")["rows"]
assert rows.shape == r8_rows.shape == (700, 1540)
assert core.rank(rows) == core.rank(r8_rows) == 700
assert core.rank(np.vstack([r8_rows, rows])) == 700
assert result["returncode"] == 0 and not result["timed_out"]
assert digest(input_path) == result["input_sha256"]
assert digest(leading_path) == result["leading_sha256"]
assert digest(log_path) == result["log_sha256"]

leading = leading_path.read_text()
bounds = {}
for index in range(20):
    matches = re.findall(
        rf"^[\s\[]*a{index}\^(\d+)(?:,|\]:?)\s*$",
        leading,
        flags=re.MULTILINE,
    )
    assert matches, index
    bounds[f"a{index}"] = min(int(value) for value in matches)
assert bounds == {f"a{index}": 3 for index in range(20)}
assert result["pure_power_bounds"] == bounds
assert result["artinian_at_origin"]
assert result["verdict"] == "SCOPED_R10_FULL_FRAME_EMPTY"

print("PASS exact R10 basis dimension and 20-variable coefficient space")
print("PASS R8 and R10 sampled landing systems have the same rank-700 row space")
print("PASS leading ideal contains a0^3,...,a19^3")
print("CERTIFIED full five-coordinate R10 Schur ansatz projectively empty")
print("BOUNDARY no all-height or full-twist point verdict")
