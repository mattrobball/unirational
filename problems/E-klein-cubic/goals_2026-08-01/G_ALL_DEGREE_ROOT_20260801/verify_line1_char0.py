#!/usr/bin/env python3
"""Independent replay of the exact degree-one cyclotomic landing algebra."""

from __future__ import annotations

import hashlib
import json
import math
import re
import subprocess
import tempfile
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
BREW_PYTHON = Path("/opt/homebrew/bin/python3")
SINGULAR = Path("/opt/homebrew/bin/Singular")
INPUT_HASHES = {
    "certificates/exact_weil_check.py":
        "14c9bda195ccc39e3ae2cd6d6d42bbb8f45397e114b5137947fb41dd665cc2b2",
    "certificates/transitions/common.py":
        "72120146a8c25aeb8e246feb65cde17d93994a37afa9e28836a6e949764c2eed",
    "tmp/symbolic_compatibility_complex/line_landing_bigraded.py":
        "efaa3975152bf03a80e691a7521638cdeba01dc7ad80e46981ec1608780d4a62",
    "tmp/symbolic_compatibility_complex/m3_line1_chart_00.out":
        "4c79a13326152509d39074d0b1fbd0d1abfda92538dc7f41382ecaf78f8df3ab",
}
EXPECTED_OUTPUT = """CHAR0_DIM
0
CHAR0_VDIM_IF_ZERO
48
CHAR0_GB_SIZE
36
"""
EXPECTED_REDUCTION_OUTPUT = """SPECIAL_DIM
0
SPECIAL_VDIM_IF_ZERO
48
SPECIAL_GB_SIZE
36
"""
EXPECTED_BOUNDARY_OUTPUT = """BOUNDARY_CHART_1_UNIT
1
BOUNDARY_CHART_2_UNIT
1
BOUNDARY_CHART_3_UNIT
1
BOUNDARY_CHART_4_UNIT
1
BOUNDARY_CHART_5_UNIT
1
BOUNDARY_CHART_6_UNIT
1
BOUNDARY_CHART_7_UNIT
1
"""


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalized(text: str) -> str:
    return text.replace("\r\n", "\n").strip() + "\n"


def main() -> None:
    for relative, expected in INPUT_HASHES.items():
        actual = digest(PROBLEM / relative)
        assert actual == expected, (relative, expected, actual)
    assert BREW_PYTHON.is_file()
    assert SINGULAR.is_file()

    metadata = json.loads((HERE / "m3_line1_char0.json").read_text())
    assert metadata["field"] == "Q(zeta_11)"
    assert metadata["parameter_dimension"] == 8
    assert metadata["landing_row_rank"] == 14
    assert metadata["coefficient_interpolation_rows_checked"] == 760
    assert metadata["all_coefficient_rows_in_exact_span"] is True
    assert metadata["all_coefficient_rows_reduce_to_split_model"] is True
    assert metadata["modular_regression"] == {"prime": 67, "zeta_11": 64}
    assert metadata["singular_sha256"] == digest(HERE / "m3_line1_char0.sing")
    assert metadata["reduction_sha256"] == digest(HERE / "m3_line1_reduction.sing")
    assert metadata["reduction_boundary_sha256"] == digest(
        HERE / "m3_line1_reduction_boundary.sing"
    )
    change = metadata["change_from_installed_basis_mod67"]
    assert len(change) == 5 and all(len(row) == 5 for row in change)
    assert all(change[i][j] == 0 for i in range(2) for j in range(2, 5))
    transverse = [row[2:] for row in change[2:]]
    assert all(sum(value != 0 for value in row) == 1 for row in transverse)
    assert all(sum(transverse[i][j] != 0 for i in range(3)) == 1 for j in range(3))

    singular_text = (HERE / "m3_line1_char0.sing").read_text()
    assert "ring r=(0,z),(a_1,a_2,a_3,a_4,a_5,a_6,a_7),dp;" in singular_text
    assert "minpoly=z^10+z^9+z^8+z^7+z^6+z^5+z^4+z^3+z^2+z+1;" in singular_text
    assert "ideal G=slimgb(I);" in singular_text
    denominators = [int(value) for value in re.findall(r"/(\d+)", singular_text)]
    assert denominators and all(math.gcd(value, 67) == 1 for value in denominators)

    with tempfile.TemporaryDirectory(prefix="goal-g-line1-char0-") as directory:
        temporary = Path(directory)
        producer = subprocess.run(
            [str(BREW_PYTHON), str(HERE / "produce_line1_char0.py"),
             "--output-dir", str(temporary)],
            text=True,
            capture_output=True,
            check=True,
        )
        assert "LINE1_CHAR0_INPUT_OK" in producer.stdout
        for name in (
            "m3_line1_char0.sing",
            "m3_line1_reduction.sing",
            "m3_line1_reduction_boundary.sing",
            "m3_line1_char0.json",
        ):
            assert (temporary / name).read_bytes() == (HERE / name).read_bytes(), name
        replay = subprocess.run(
            [str(SINGULAR), "-q", str(temporary / "m3_line1_char0.sing")],
            text=True,
            capture_output=True,
            check=True,
        )
        assert normalized(replay.stdout) == EXPECTED_OUTPUT, replay.stdout
        reduction_replay = subprocess.run(
            [str(SINGULAR), "-q", str(temporary / "m3_line1_reduction.sing")],
            text=True,
            capture_output=True,
            check=True,
        )
        assert normalized(reduction_replay.stdout) == EXPECTED_REDUCTION_OUTPUT
        boundary_replay = subprocess.run(
            [str(SINGULAR), "-q", str(temporary / "m3_line1_reduction_boundary.sing")],
            text=True,
            capture_output=True,
            check=True,
        )
        assert normalized(boundary_replay.stdout) == EXPECTED_BOUNDARY_OUTPUT

    assert normalized((HERE / "m3_line1_char0_output.txt").read_text()) == EXPECTED_OUTPUT
    assert normalized((HERE / "m3_line1_reduction_output.txt").read_text()) == EXPECTED_REDUCTION_OUTPUT
    assert normalized(
        (HERE / "m3_line1_reduction_boundary_output.txt").read_text()
    ) == EXPECTED_BOUNDARY_OUTPUT
    print("PASS exact A4 branch-adapted reconstruction and split-67 regression")
    print("PASS all cyclotomic denominators are units at the prime above 67")
    print("PASS special and characteristic-zero landing algebras both have dimension 48")
    print("PASS all seven projective boundary charts are empty in the special fibre")
    print("LINE1_CHAR0_VERIFY_OK")


if __name__ == "__main__":
    main()
