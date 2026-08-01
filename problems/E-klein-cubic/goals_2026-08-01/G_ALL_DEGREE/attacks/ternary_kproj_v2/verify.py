#!/usr/bin/env python3
"""Independent replay for the scoped ternary K_proj attack."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path
import subprocess
import tempfile

from build_common_pencils import MSOLVE, PRIME, parse_leading, sha256
from build_common_planes import SUPPORTS
from common_pencil import (
    FRAME_NAMES,
    GENERIC_PATH,
    GOALS,
    PROBLEM,
    TABLE_PATH,
    TRIPLES,
    msolve_input,
    msolve_input_support,
)
from make_xcd_binding import (
    NAME_TO_TRIPLE,
    THEOREM_VERIFY,
    XCD_PRESENTATION,
    XCD_VERIFY,
    decode_generic,
    decode_xcd,
)


HERE = Path(__file__).resolve().parent
PENCIL_CERTIFICATE = HERE / "common_pencil_certificate.json"
PLANE_CERTIFICATE = HERE / "common_plane_certificate.json"
XCD_BINDING = HERE / "xcd_binding.json"
RESULT = HERE / "RESULT.md"
SEAL = HERE / "SEAL.json"
GENERIC_VERIFY = GOALS / "G_ALL_DEGREE/verify_generic_cubic.py"
KPROJ_VERIFY = PROBLEM / "tmp/kproj_arithmetic/model.py"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def load(path):
    return json.loads(path.read_text())


def check_hashes(certificate):
    for relative, expected in certificate["source_hashes"].items():
        candidates = (GOALS / relative, PROBLEM / relative)
        path = next((candidate for candidate in candidates if candidate.is_file()), None)
        require(path is not None, f"missing source {relative}")
        require(sha256(path) == expected, f"source hash mismatch: {relative}")


def verify_seal():
    seal = load(SEAL)
    require(seal["schema"] == "G_TERNARY_KPROJ_V2_SEAL_V1", "seal schema")
    require(seal["pencil_inputs"] == seal["pencil_leading_outputs"] == 110, "seal pencil count")
    require(seal["plane_inputs"] == seal["plane_leading_outputs"] == 10, "seal plane count")
    expected = {
        str(path.relative_to(HERE))
        for path in HERE.rglob("*")
        if path.is_file()
        and path != SEAL
        and "__pycache__" not in path.parts
        and path.suffix != ".pyc"
    }
    require(set(seal["files"]) == expected, "seal file set mismatch")
    require(seal["artifact_count"] == len(expected), "seal artifact count")
    for relative, record in seal["files"].items():
        path = HERE / relative
        require(path.stat().st_size == record["bytes"], f"sealed size mismatch {relative}")
        require(sha256(path) == record["sha256"], f"sealed hash mismatch {relative}")
    print(f"PASS local seal ({len(expected)} artifacts)")


def rerun_solver(text, expected_pure, variable_count):
    with tempfile.TemporaryDirectory(prefix="g_ternary_") as directory:
        source = Path(directory) / "system.in"
        leading = Path(directory) / "leading.out"
        source.write_text(text)
        completed = subprocess.run(
            [str(MSOLVE), "-f", str(source), "-g", "1", "-o", str(leading)],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
        require(completed.returncode == 0, f"fresh msolve failed: {completed.stdout[-2000:]}")
        _, pure = parse_leading(leading)
        require(set(pure) == set(range(variable_count)), "fresh leading ideal is not Artinian")
        require(
            {f"a{i}": pure[i] for i in range(variable_count)} == expected_pure,
            "fresh pure powers differ from certificate",
        )


def verify_pencils(deep, rerun):
    certificate = load(PENCIL_CERTIFICATE)
    require(certificate["schema"] == "G_TERNARY_COMMON_PENCIL_V1", "pencil schema")
    require(certificate["prime"] == PRIME == 101, "pencil good prime")
    require(certificate["system_count"] == 110, "pencil certificate is incomplete")
    require(certificate["all_projective_special_fibres_empty"], "pencil aggregate not empty")
    check_hashes(certificate)
    expected = {(triple, secondary) for triple in TRIPLES for secondary in range(1, 12)}
    seen = set()
    for index, row in enumerate(certificate["systems"]):
        triple = tuple(row["frame_indices"])
        secondary = row["secondary"]
        seen.add((triple, secondary))
        source = HERE / row["input"]
        leading = HERE / row["leading"]
        require(sha256(source) == row["input_sha256"], f"pencil input hash {row['stem']}")
        require(sha256(leading) == row["leading_sha256"], f"pencil leading hash {row['stem']}")
        _, pure = parse_leading(leading)
        expected_pure = {f"a{i}": pure.get(i) for i in range(6)}
        require(expected_pure == row["pure_powers"], f"pencil pure powers {row['stem']}")
        require(set(pure) == set(range(6)), f"pencil non-Artinian {row['stem']}")
        reconstruct = deep or secondary in (1, 11)
        if reconstruct:
            text, equations, rows = msolve_input(triple, secondary, PRIME)
            require(text == source.read_text(), f"pencil equation reconstruction {row['stem']}")
            require(len(equations) == row["exact_coefficient_equations"], "exact equation count")
            require(len(rows) == row["modular_equation_rank"], "modular equation rank")
            if rerun:
                rerun_solver(text, row["pure_powers"], 6)
    require(seen == expected, "pencil job set mismatch")
    print("PASS 110 common-secondary P5 ansatze: all special fibres projectively empty")


def verify_planes(deep, rerun):
    certificate = load(PLANE_CERTIFICATE)
    require(certificate["schema"] == "G_TERNARY_COMMON_PLANE_V1", "plane schema")
    require(certificate["prime"] == PRIME == 101, "plane good prime")
    require(certificate["system_count"] == 10, "plane certificate is incomplete")
    require(certificate["all_projective_special_fibres_empty"], "plane aggregate not empty")
    check_hashes(certificate)
    expected = {(triple, support) for triple in TRIPLES for support in SUPPORTS}
    seen = set()
    sentinel_supports = {SUPPORTS[0], SUPPORTS[-1]}
    for row in certificate["systems"]:
        triple = tuple(row["frame_indices"])
        support = tuple(row["support"])
        seen.add((triple, support))
        source = HERE / row["input"]
        leading = HERE / row["leading"]
        require(sha256(source) == row["input_sha256"], f"plane input hash {row['stem']}")
        require(sha256(leading) == row["leading_sha256"], f"plane leading hash {row['stem']}")
        _, pure = parse_leading(leading)
        expected_pure = {f"a{i}": pure.get(i) for i in range(9)}
        require(expected_pure == row["pure_powers"], f"plane pure powers {row['stem']}")
        require(set(pure) == set(range(9)), f"plane non-Artinian {row['stem']}")
        reconstruct = deep or support in sentinel_supports
        if reconstruct:
            text, equations, rows = msolve_input_support(triple, support, PRIME)
            require(text == source.read_text(), f"plane equation reconstruction {row['stem']}")
            require(len(equations) == row["exact_coefficient_equations"], "exact equation count")
            require(len(rows) == row["modular_equation_rank"], "modular equation rank")
            if rerun:
                rerun_solver(text, row["pure_powers"], 9)
    require(seen == expected, "plane job set mismatch")
    print("PASS 10 common-secondary P8 ansatze: all special fibres projectively empty")


def verify_xcd_binding(run_upstream):
    binding = load(XCD_BINDING)
    require(binding["schema"] == "G_XCD_BINDING_V1", "xCD binding schema")
    for relative, expected in binding["source_hashes"].items():
        path = PROBLEM / relative
        require(path.is_file(), f"missing xCD binding source {relative}")
        require(sha256(path) == expected, f"xCD binding hash mismatch {relative}")
    generic = load(GENERIC_PATH)
    xcd = load(XCD_PRESENTATION)
    generic_rows = {tuple(row["triple"]): row for row in generic["coefficients"]}
    require(xcd["inputs"]["normalized_kproj_table_sha256"] == sha256(TABLE_PATH), "xCD table bind")
    for name, triple in NAME_TO_TRIPLE.items():
        require(
            decode_generic(generic_rows[triple])
            == decode_xcd(xcd["normalized_plane_coefficients"][name]),
            f"xCD normalized coefficient mismatch {name}",
        )
    require(binding["coefficient_match_count"] == 10, "xCD coefficient match count")
    require("exactly the x,C,D ternary plane" in binding["strict_scope"], "xCD strict scope")

    if run_upstream:
        commands = (
            (GENERIC_VERIFY, "G_GENERIC_CUBIC_35_COEFFICIENT_IDENTITIES_OK"),
            (KPROJ_VERIFY, "PASS normalized K_proj arithmetic API identity"),
            (XCD_VERIFY, "PASS exact K_proj Hironaka bind"),
            (THEOREM_VERIFY, "THEOREM the proper xCD plane curve has no K_proj,C-point"),
        )
        for script, marker in commands:
            completed = subprocess.run(
                ["/opt/homebrew/bin/python3", "-u", str(script)],
                cwd=PROBLEM,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                check=False,
            )
            require(completed.returncode == 0, f"upstream replay failed {script}:\n{completed.stdout}")
            require(marker in completed.stdout, f"upstream marker absent {script}: {marker}")
    print("THEOREM Goal-G x,C,D plane has no K_proj,C-point (literal 10-coefficient bind)")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--fast",
        action="store_true",
        help="audit every hash/pure power but reconstruct only selected sentinels",
    )
    parser.add_argument("--rerun-solvers", action="store_true")
    parser.add_argument("--skip-upstream", action="store_true")
    args = parser.parse_args()
    if args.rerun_solvers and args.fast:
        raise SystemExit("--rerun-solvers is incompatible with --fast")

    verify_xcd_binding(not args.skip_upstream)
    verify_pencils(not args.fast, args.rerun_solvers)
    verify_planes(not args.fast, args.rerun_solvers)
    result = RESULT.read_text()
    for marker in (
        "All `10*11=110` systems are empty",
        "All ten fixed-support `P8` systems are empty",
        "over `Z_(101)`",
        "unrestricted `K_proj` search.",
        "Nothing here proves\n`V(Phi)(K_proj,C)=empty`.",
    ):
        require(marker in result, f"RESULT scope/transfer marker missing: {marker}")
    verify_seal()
    print("CHAR0_TRANSFER projective special-fibre emptiness at p=101 => geometric QQ/C emptiness")
    print("STRICT_SCOPE xCD plane theorem plus 120 finite common-secondary ansatze; full cubic remains open")
    print("G_TERNARY_KPROJ_V2_VERIFY_OK")


if __name__ == "__main__":
    main()
