#!/usr/bin/env python3
"""Independent artifact/scope audit for the displayed R12 dimension-5 gate."""

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


metadata = json.loads((HERE / "full_frame_r12d5_metadata.json").read_text())
result = json.loads((HERE / "full_frame_r12d5_result.json").read_text())
rows_path = HERE / metadata["rows_file"]
leading_path = HERE / "full_frame_r12d5.leading.out"
input_path = HERE / "full_frame_r12d5.in"
log_path = HERE / "full_frame_r12d5.solve.log"

assert metadata["format"] == "Q-SCHUR-FULL-FRAME-R12D5-v1"
assert metadata["scope"] == (
    "all five degree-eight frame columns with one displayed "
    "5-dimensional slice inside R12"
)
assert metadata["prime"] == 23
assert metadata["frame_degree"] == 8
assert metadata["coefficient_degree"] == 12
assert metadata["total_covariant_degree"] == 20
assert metadata["invariant_dimension"] == 5
assert metadata["complete_invariant_dimension"] == 14
assert metadata["variable_count"] == 25
assert metadata["cubic_monomials"] == 2925
assert metadata["equation_rank"] == 1225 == 35 * 35
assert len(metadata["invariant_seeds"]) == 5
assert digest(rows_path) == metadata["rows_sha256"]

rows = np.load(rows_path)["rows"]
assert rows.shape == (1225, 2925)
assert core.rank(rows) == 1225
assert result["returncode"] == 0 and not result["timed_out"]
assert digest(input_path) == result["input_sha256"]
assert digest(leading_path) == result["leading_sha256"]
assert digest(log_path) == result["log_sha256"]

leading = leading_path.read_text()
bounds = {}
for index in range(25):
    matches = re.findall(
        rf"^[\s\[]*a{index}\^(\d+)(?:,|\]:?)\s*$",
        leading,
        flags=re.MULTILINE,
    )
    assert matches, index
    bounds[f"a{index}"] = min(int(value) for value in matches)
assert bounds == {f"a{index}": 3 for index in range(25)}
assert result["pure_power_bounds"] == bounds
assert result["artinian_at_origin"]
assert result["verdict"] == "SCOPED_R12D5_FULL_FRAME_EMPTY"

print("PASS exact five-dimensional Reynolds slice inside dim(R12)=14")
print("PASS 1225 x 2925 sampled landing system artifacts and hashes")
print("PASS leading ideal contains a0^3,...,a24^3")
print("CERTIFIED displayed five-coordinate R12 dimension-5 slice empty")
print("BOUNDARY remaining nine scalar directions, primitive covariants, and all heights open")
