#!/usr/bin/env python3
"""Replay the bounded exact part of the Palatini structural audit."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
WORKSPACE = HERE.parents[2]
UPSTREAM = WORKSPACE / "Q_SCHUR_DESCENT/parallel/full_schur_palatinian_point_next"
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")


def run(command: list[str], cwd: Path = WORKSPACE) -> str:
    process = subprocess.run(
        command,
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if process.returncode:
        raise RuntimeError(f"command failed ({process.returncode}): {command}\n{process.stdout}")
    return process.stdout


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    generated = run(["/opt/homebrew/bin/python3", "-u", str(HERE / "palatini_geometry_mod23.py")])
    assert "I4_TERMS=126" in generated

    geometry = run(["/opt/homebrew/bin/Singular", "-q", str(HERE / "palatini_geometry_mod23.sing")])
    assert "SINGULAR_PROJECTIVE_DIM=1" in geometry
    assert "// degree (proj.)   = 25" in geometry
    assert "I4_FACTOR_COUNT_WITH_UNIT=2" in geometry
    assert "I4_FACTOR=2 MULT=1 DEG=4" in geometry
    prefix = "SINGULAR_HILBERT_SECOND="
    h_line = next(line for line in geometry.splitlines() if line.startswith(prefix))
    h_vector = [int(entry.strip()) for entry in h_line.removeprefix(prefix).split(",")][:-1]
    degree = sum(h_vector)
    derivative_at_one = sum(index * coefficient for index, coefficient in enumerate(h_vector))
    genus = 1 - degree + derivative_at_one
    assert (degree, genus) == (25, 26)

    smooth = run(
        ["/opt/homebrew/bin/Singular", "-q", str(HERE / "palatini_singular_curve_smooth_mod23.sing")]
    )
    assert "FOUR_BY_FOUR_MINORS=225" in smooth
    assert "CURVE_SINGULAR_CONE_DIM=0" in smooth

    polar = run(["/opt/homebrew/bin/python3", "-u", str(HERE / "palatini_polar_mod23.py")])
    assert "COMMUTING_ENDOMORPHISM_DIM=1" in polar
    assert "INVARIANT_BILINEAR_FORM_DIM=0" in polar
    assert "POLAR_LANDS_IN_DUAL_NOT_V6_MOD23_OK" in polar

    certificate = json.loads((UPSTREAM / "certificate.json").read_text())
    for relative, digest in certificate["external_source_sha256"].items():
        assert sha256(ROOT / relative) == digest
    q1_q3 = [record for record in certificate["records"] if record["name"] == "q1__q3"]
    assert [record["extension_degree"] for record in q1_q3] == [1, 2, 3, 4]
    for record in q1_q3:
        assert record["factor_count_with_unit"] == 2
        assert record["input_t_degree"] == 4
        assert record["factors"][-1][3] == 4

    print(f"PALATINI_SINGULAR_CURVE_DEGREE={degree}")
    print(f"PALATINI_SINGULAR_CURVE_ARITHMETIC_GENUS={genus}")
    print("PALATINI_Q1_Q3_CONSTANT_EXTENSION_CERTIFICATE_BOUND")
    print("PALATINI_STRUCTURAL_AUDIT_MOD23_OK")
    print("SCOPE: exact good-fibre geometry and source-bound pencil obstruction; no rational G-map")


if __name__ == "__main__":
    main()
