#!/usr/bin/env python3
"""Bind the Goal-G xCD coefficients to the sealed upstream xCD theorem."""

from __future__ import annotations

from fractions import Fraction
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
GOALS = HERE.parents[2]
PROBLEM = HERE.parents[3]
GENERIC = GOALS / "G_ALL_DEGREE/generic_cubic.json"
GENERIC_VERIFY = GOALS / "G_ALL_DEGREE/verify_generic_cubic.py"
TABLE = PROBLEM / "tmp/kproj_arithmetic/normalized_kproj_table.json"
XCD_DIR = PROBLEM / "tmp/xcd_genuine_descent"
XCD_PRESENTATION = XCD_DIR / "kproj_e3_presentation.json"
XCD_GENERIC = PROBLEM / "tmp/xcd_descent_algebra/generic_xcd_model.json"
XCD_VERIFY = XCD_DIR / "verify.py"
THEOREM_DIR = PROBLEM / "tmp/xcd_general_slice_completion"
THEOREM_CERTIFICATE = THEOREM_DIR / "certificate.json"
THEOREM_REPORT = THEOREM_DIR / "REPORT.md"
THEOREM_AUDIT = THEOREM_DIR / "PROOF_AUDIT.md"
THEOREM_VERIFY = THEOREM_DIR / "verify.py"
OUTPUT = HERE / "xcd_binding.json"

NAME_TO_TRIPLE = {
    "A": (0, 0, 0),
    "A2": (0, 0, 1),
    "A3": (0, 0, 2),
    "B": (1, 1, 1),
    "B1": (0, 1, 1),
    "B3": (1, 1, 2),
    "C": (2, 2, 2),
    "C1": (0, 2, 2),
    "C2": (1, 2, 2),
    "M": (0, 1, 2),
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def decode_generic(row):
    value = [dict() for _ in range(12)]
    for term in row["normalized_entries"]:
        value[term["secondary"]][tuple(term["projective_exponents"])] = Fraction(
            term["numerator"], term["denominator"]
        )
    return value


def decode_xcd(value):
    return [
        {
            tuple(term["exponents"]): Fraction(term["numerator"], term["denominator"])
            for term in coordinate
        }
        for coordinate in value
    ]


def main():
    generic = json.loads(GENERIC.read_text())
    xcd = json.loads(XCD_PRESENTATION.read_text())
    rows = {tuple(row["triple"]): row for row in generic["coefficients"]}
    matches = {}
    for name, triple in NAME_TO_TRIPLE.items():
        match = decode_generic(rows[triple]) == decode_xcd(
            xcd["normalized_plane_coefficients"][name]
        )
        if not match:
            raise AssertionError(f"normalized xCD coefficient mismatch: {name}/{triple}")
        matches[name] = {
            "generic_triple": list(triple),
            "generic_label": rows[triple]["label"],
            "equal_as_12_component_QQ_t_vectors": True,
        }

    actual_table_hash = sha256(TABLE)
    if xcd["inputs"]["normalized_kproj_table_sha256"] != actual_table_hash:
        raise AssertionError("xCD presentation does not bind the current normalized K_proj table")
    if xcd["base"]["normalization"] != (
        "tau=f3^2/f5; each degree-d invariant is divided by tau^d"
    ):
        raise AssertionError("xCD normalization drifted")

    paths = (
        GENERIC,
        GENERIC_VERIFY,
        TABLE,
        XCD_PRESENTATION,
        XCD_GENERIC,
        XCD_VERIFY,
        THEOREM_CERTIFICATE,
        THEOREM_REPORT,
        THEOREM_AUDIT,
        THEOREM_VERIFY,
    )
    hashes = {str(path.relative_to(PROBLEM)): sha256(path) for path in paths}
    payload = {
        "schema": "G_XCD_BINDING_V1",
        "goal_g_plane": ["x", "C", "D"],
        "coordinate_change": (
            "Goal G and the upstream xCD packet use the same normalized frame "
            "x/tau, C/tau^4, D/tau^5 and the same K_proj,C; all ten ternary "
            "coefficients agree literally in the normalized 12-element basis."
        ),
        "field": "K_proj,C = K_proj,QQ tensor_QQ C",
        "normalization": xcd["base"]["normalization"],
        "normalized_kproj_table_sha256": actual_table_hash,
        "coefficient_matches": matches,
        "coefficient_match_count": len(matches),
        "source_hashes": hashes,
        "upstream_theorem": (
            "the proper xCD plane curve has no K_proj,C-point by specialization "
            "at Q6=f6=0"
        ),
        "consequence": (
            "the coordinate plane V(Phi) intersect {a3=a4=0}, with coordinates "
            "x,C,D, has no K_proj,C-rational point"
        ),
        "strict_scope": (
            "This excludes exactly the x,C,D ternary plane. It says nothing by "
            "itself about the other nine ternary planes or a point with four or "
            "five nonzero frame coordinates."
        ),
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("G_XCD_BINDING_PRODUCED coefficients=10 same_field=K_proj,C")


if __name__ == "__main__":
    main()
