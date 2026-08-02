#!/usr/bin/env python3
"""Produce the exact ten-pencil good-fibre factorization certificate."""
from __future__ import annotations

import concurrent.futures
import hashlib
import json
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
PYTHON = "/opt/homebrew/bin/python3"

EXTERNAL_SOURCES = (
    ROOT / "tmp/pfaffian_representation_alignment/core.py",
    ROOT / "tmp/fano14_twist/fano_covariant_scan.py",
)

# (name, seed degree, seed output, base degree or None, base output or None)
PENCILS = (
    ("q1__q3", 3, 0, None, None),
    ("q1__q5_0", 5, 0, None, None),
    ("q1__q5_1", 5, 1, None, None),
    ("q1__q5_5", 5, 5, None, None),
    ("q3__q5_0", 5, 0, 3, 0),
    ("q3__q5_1", 5, 1, 3, 0),
    ("q3__q5_5", 5, 5, 3, 0),
    ("q5_0__q5_1", 5, 1, 5, 0),
    ("q5_0__q5_5", 5, 5, 5, 0),
    ("q5_1__q5_5", 5, 5, 5, 1),
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_one(specification, extension_degree: int = 1) -> dict:
    name, degree, output, base_degree, base_output = specification
    command = [
        PYTHON,
        "-u",
        str(HERE / "factor_natural_pencil_mod23.py"),
        str(degree),
        str(output),
        "--factor",
        "--extension-degree",
        str(extension_degree),
    ]
    if base_output is not None:
        command.extend(["--base-output", str(base_output)])
        if base_degree is not None:
            command.extend(["--base-degree", str(base_degree)])
    process = subprocess.run(
        command,
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    output_text = process.stdout
    def integer(pattern: str) -> int:
        match = re.search(pattern, output_text)
        assert match, (name, pattern, output_text)
        return int(match.group(1))

    hash_match = re.search(r"SINGULAR_SOURCE_SHA256=([0-9a-f]{64})", output_text)
    assert hash_match, output_text
    factor_lines = re.findall(
        r"FACTOR=(\d+) MULT=(\d+) TOTAL_DEG=(\d+) T_DEG=(\d+)",
        output_text,
    )
    record = {
        "name": name,
        "extension_degree": extension_degree,
        "singular_source_sha256": hash_match.group(1),
        "expanded_terms": integer(r"EXPANDED_TERMS=(\d+)"),
        "factor_count_with_unit": integer(r"FACTOR_COUNT_WITH_UNIT=(\d+)"),
        "input_total_degree": integer(r"INPUT_TOTAL_DEG=(\d+)"),
        "input_t_degree": integer(r"INPUT_T_DEG=(\d+)"),
        "factors": [list(map(int, line)) for line in factor_lines],
        "return_code": process.returncode,
    }
    assert record["extension_degree"] == integer(r"CONSTANT_FIELD_DEGREE=(\d+)")
    assert record["return_code"] == 0
    assert record["factor_count_with_unit"] == 2
    assert record["input_t_degree"] == 4
    assert record["factors"] == [
        [1, 1, 0, 0],
        [2, 1, record["input_total_degree"], 4],
    ]
    return record


def produce() -> dict:
    jobs = [(specification, 1) for specification in PENCILS]
    # For q1--q3, extensions of degrees 2, 3, and 4 rule out a hidden
    # algebraic-constant linear factor: an orbit of a t-linear factor of an
    # F_23-irreducible t-quartic has at most four members.
    jobs.extend([(PENCILS[0], extension) for extension in (2, 3, 4)])
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
        records = list(executor.map(lambda job: run_one(*job), jobs))
    records.sort(key=lambda record: (record["name"], record["extension_degree"]))
    return {
        "schema": "full-schur-palatinian-ten-pencil-v1",
        "prime": 23,
        "zeta11_reduction": 2,
        "maps": {
            "q1": "identity",
            "q3": "Reynolds(output=0, seed=x5^3)",
            "q5_0": "Reynolds(output=0, seed=x5^5)",
            "q5_1": "Reynolds(output=1, seed=x5^5)",
            "q5_5": "Reynolds(output=5, seed=x5^5)",
        },
        "external_source_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in EXTERNAL_SOURCES
        },
        "records": records,
        "scope": {
            "all_ten": "irreducible over F_23[x0,...,x5,t], hence no F_23(x)-rational root and no Q(zeta_11)(x)-rational root by the Gauss-valuation argument",
            "q1_q3": "no t-linear factor after constant extensions F_(23^m), m=1,2,3,4; hence no algebraic-constant rational root in this pencil",
            "nonclaim": "no point or pointlessness statement for the full six-coordinate K_Schur quartic",
        },
    }


def main() -> None:
    payload = produce()
    path = HERE / "certificate.json"
    path.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"WROTE={path}")
    print("FULL_SCHUR_TEN_PENCIL_CERTIFICATE_PRODUCED")


if __name__ == "__main__":
    main()
