#!/usr/bin/env python3
"""Independent replay verifier for the exact degree-11 A5 points."""

from __future__ import annotations

import argparse
import importlib.util
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
COMMON = ROOT / "common"
SINGULAR = os.environ.get("SINGULAR") or shutil.which("Singular") or "/opt/homebrew/bin/Singular"


def import_file(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


solver = import_file("h3_exact_six_verify_solver", COMMON / "produce_exact_points.py")
exact = solver.exact
canonical = exact.canonical


def verify_original_class_pencil():
    ratios = []
    for a, b, _subgroup in canonical.base.two_a5_classes():
        matrix = canonical.intertwiner(a, b)
        first, second = canonical.pencil_coordinates(canonical.klein_pullback(matrix))
        ratio = second / first
        assert 9 * ratio * ratio - 13 * ratio + 5 == canonical.K.zero
        ratios.append(ratio)
    assert ratios[0] != ratios[1]
    assert ratios[0] + ratios[1] == canonical.K.convert(13) / canonical.K.convert(9)
    assert ratios[0] * ratios[1] == canonical.K.convert(5) / canonical.K.convert(9)
    print("verified exact transported Klein pencil roots", flush=True)


def lex_input(equations):
    expressions = [
        solver.chart_expression(solver.remove_content(equation))
        for equation in equations
    ]
    return (
        "ring r=(0,u),(a1,a2,a3,a4),lp;\n"
        "minpoly=u^4+12*u^2+256;\n"
        f"ideal I={','.join(expressions)};\n"
        "ideal J=stdfglm(I,\"std\");\n"
        'if (reduce(1,J)==0) { print("UNIT"); } else { print("NONUNIT"); J; }\n'
        "ideal R=reduce(I,J);\n"
        "int reductions_ok=1; int reduction_index;\n"
        "for (reduction_index=1; reduction_index<=size(R); reduction_index++) "
        "{ if (R[reduction_index]!=0) { reductions_ok=0; } }\n"
        'if (reductions_ok==1) { print("ALL_SIX_REDUCE_ZERO"); } '
        'else { print("REDUCTION_FAILURE"); R; }\n'
        'print("VDIM"); vdim(J);\n'
        "quit;\n"
    )


def verify_class(covariants, class_index):
    equations = [
        solver.evaluation_equation(covariants, point, class_index)
        for point in solver.POINTS
    ]
    assert len(equations) == 6 and all(equations)
    content = lex_input(equations)
    class_dir = ROOT / f"A5_class_{class_index}"
    checked_in = (class_dir / f"class_{class_index}_exact_rref_lex.sing").read_text()
    assert content == checked_in
    result = subprocess.run(
        [SINGULAR, "-q"],
        input=content,
        check=True,
        capture_output=True,
        text=True,
    )
    lines = result.stdout.splitlines()
    assert lines[0].strip() == "NONUNIT"
    assert "ALL_SIX_REDUCE_ZERO" in lines
    assert "REDUCTION_FAILURE" not in lines
    assert lines[-2:] == ["VDIM", "3"]
    lex_basis = [line for line in lines if line.startswith("J[")]
    assert len(lex_basis) == 4
    assert lex_basis[0].startswith("J[1]=a4^3+")
    assert lex_basis[1].startswith("J[2]=a3+")
    assert lex_basis[2].startswith("J[3]=a2+")
    assert lex_basis[3].startswith("J[4]=a1+")
    payload = json.loads((class_dir / f"class_{class_index}_exact_rref.json").read_text())
    assert payload["class"] == class_index
    expected_parameter = (
        "(13-sqrt(-11))/18" if class_index == 1
        else "(13+sqrt(-11))/18"
    )
    assert payload["coefficient_field"]["pencil_parameter"] == expected_parameter
    for input_key, hash_key in (
        ("singular_input", "singular_input_sha256"),
        ("singular_transcript", "singular_transcript_sha256"),
        ("lex_input", "lex_input_sha256"),
        ("lex_transcript", "lex_transcript_sha256"),
    ):
        path = class_dir / payload[input_key]
        assert hashlib.sha256(path.read_bytes()).hexdigest() == payload[hash_key]
    assert result.stdout == (class_dir / payload["lex_transcript"]).read_text()
    assert payload["lex_basis"] == lex_basis
    assert payload["all_six_equations_reduce_to_zero"] is True
    print(f"verified class {class_index}: exact NONUNIT, VDIM 3, triangular point", flush=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--class", dest="class_index", type=int, choices=(1, 2))
    args = parser.parse_args()
    # Recompute the covariants from the Reynolds formula, not from JSON.
    raw, _seeds, actions = exact.reynolds_basis()
    covariants = exact.rref_covariants(raw)
    exact.verify_covariance(covariants, actions)
    witnesses = solver.evaluation_injectivity_mod89()
    assert len(witnesses) == 6
    print("verified exact covariance and six-evaluation injectivity", flush=True)
    verify_original_class_pencil()
    classes = (args.class_index,) if args.class_index else (1, 2)
    for class_index in classes:
        verify_class(covariants, class_index)
    if args.class_index:
        print(f"H3_A5_CLASS{args.class_index}_POINT_VERIFY_OK")
    else:
        print("H3_EXACT_DEGREE11_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
