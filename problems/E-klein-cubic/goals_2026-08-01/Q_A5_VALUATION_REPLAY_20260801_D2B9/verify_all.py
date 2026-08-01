#!/usr/bin/env python3
"""Run every load-bearing verifier for the sealed Goal H3 packet."""

from __future__ import annotations

import json
import os
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent

# In this repository, directory-local environment selection can resolve
# ``python3`` to Apple's system interpreter, which has no SymPy.  Re-enter
# with the established Homebrew interpreter when necessary.
try:
    import sympy  # noqa: F401
except ModuleNotFoundError:
    homebrew_python = Path("/opt/homebrew/bin/python3")
    if Path(sys.executable).resolve() != homebrew_python.resolve() and homebrew_python.is_file():
        os.execv(str(homebrew_python), [str(homebrew_python), str(Path(__file__).resolve()), *sys.argv[1:]])
    raise


def run(relative: str, marker: str) -> None:
    result = subprocess.run(
        [sys.executable, str(HERE / relative)],
        cwd=HERE,
        check=True,
        capture_output=True,
        text=True,
    )
    print(result.stdout, end="")
    if result.stderr:
        print(result.stderr, end="", file=sys.stderr)
    assert marker in result.stdout, (relative, marker)


def verify_payload_boundaries() -> None:
    canonical = json.loads((HERE / "canonical_model_payload.json").read_text())
    assert [row["label"] for row in canonical["classes"]] == [
        "A5_class_1", "A5_class_2"
    ]
    assert [row["subgroup_generators"] for row in canonical["classes"]] == [
        [[0, 1, 10, 0], [0, 2, 5, 1]],
        [[0, 1, 10, 0], [0, 2, 5, 10]],
    ]
    minimal = json.loads((HERE / "minimal_model_payload.json").read_text())
    assert len(minimal["coefficient_reduction"]["coefficients"]) == 35
    assert [row["label"] for row in minimal["classes"]] == [
        "A5_class_1", "A5_class_2"
    ]
    for class_index in (1, 2):
        directory = HERE / f"A5_class_{class_index}"
        payload = json.loads(
            (directory / f"class_{class_index}_exact_rref.json").read_text()
        )
        assert payload["class"] == class_index
        assert payload["all_six_equations_reduce_to_zero"] is True
        assert len(payload["lex_basis"]) == 4
        assert (directory / "TWIST_MODEL.md").is_file()
        assert (directory / "POINT.md").is_file()
        field_model = json.loads((directory / "field_model.json").read_text())
        twist_equation = json.loads((directory / "twist_equation.json").read_text())
        assert field_model["label"] == f"A5_class_{class_index}"
        assert twist_equation["label"] == f"A5_class_{class_index}"
        assert (directory / "verify_point.py").is_file()
        direct = json.loads((directory / "point.json").read_text())
        assert direct["class"] == f"A5_class_{class_index}"
        assert direct["exit"] == f"H-A5-CLASS{class_index}-RATIONAL-POINT"
        assert direct["scope"]["induced_by_equivariant_map"] is True
        assert direct["scope"]["map_degree"] == 11
    status = (HERE / "STATUS.md").read_text()
    assert "H-A5-CLASS1-RATIONAL-POINT" in status
    assert "H-A5-CLASS2-RATIONAL-POINT" in status
    print("PASS payload and theorem boundaries")


def main() -> None:
    run("build_canonical_model.py", "H3_A5_CANONICAL_MODEL_OK")
    run("build_minimal_model.py", "H3_A5_MINIMAL_DEGREE10_OK")
    run(
        "independent/verify_canonical_reynolds.py",
        "CANONICAL_A5_PENCIL_REYNOLDS_VERIFY_OK",
    )
    run(
        "independent/verify_points.py",
        "H3_EXACT_DEGREE11_INDEPENDENT_VERIFY_OK",
    )
    run(
        "independent/verify_degree33_evaluation.py",
        "H3_DEGREE33_EXACT_EVALUATION_VERIFY_OK",
    )
    run(
        "common/verify_exact_points_direct.py",
        "H3_EXACT_BOTH_A5_POINTS_VERIFIED",
    )
    verify_payload_boundaries()
    result = subprocess.run(
        [sys.executable, str(HERE / "make_seal.py"), "--check"],
        cwd=HERE,
        check=True,
        capture_output=True,
        text=True,
    )
    print(result.stdout, end="")
    assert "H3_A5_TWISTS_SEAL_OK" in result.stdout
    print("H3_A5_TWISTS_VERIFY_ALL_OK")


if __name__ == "__main__":
    main()
