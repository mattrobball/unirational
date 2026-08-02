#!/usr/bin/env python3
"""Exact checks for the reconstructed T11.1 sextic and one full fibre.

This verifies two ingredients only:

* the reconstructed Z-eliminant is irreducible over Q(A,u), witnessed by
  its irreducible degree-six specialization at (A,u)=(17,1);
* the fully gate-saturated critical ideal at that specialization has affine
  dimension zero and degree six, and contains the specialized eliminant.

It deliberately does not infer an upper bound on the generic affine fibre
from the special fibre.  Such an inference additionally needs a finiteness
or relative-projective no-escape certificate.
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
import re
import subprocess
import tempfile
from collections import defaultdict
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
Q_TSV = HERE / "singular_Z_eliminant_reconstructed.tsv"
HOLDOUT = HERE / "test_relations.json"
OUTPUT = HERE / "verify_t111_q_and_special_fibre_result.json"
M2 = "/opt/homebrew/bin/M2"
A0, U0 = 17, 1
EXPECTED_Q_SHA256 = "23be9dbe72a9a4089924accde05fc9f8d43b13e644a2e2c8528fabdb3608ef9f"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_source", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def specialized_q():
    bucket = defaultdict(int)
    with Q_TSV.open() as stream:
        assert next(stream).strip() == "A\tu\tZ\tcoefficient"
        for line in stream:
            apow, upow, zpow, coefficient = map(int, line.split())
            bucket[zpow] += coefficient * A0**apow * U0**upow
    Z = sp.symbols("Z")
    return sp.Poly(sum(c * Z**e for e, c in bucket.items()), Z, domain=sp.QQ)


def m2_check(q_primitive: sp.Poly):
    src = load_source()
    primitive = src.load_P()
    factors = src.FACTORS
    gates = {
        "ell": src.load_tsv(factors / "ell_lc_u.tsv"),
        "Cgate": src.load_tsv(factors / "C_content.tsv"),
        "PuuGate": src.load_tsv(factors / "P_uu.tsv", with_u=True),
        "delta": src.load_tsv(factors / "delta_Cramer.tsv", with_u=True),
        "Q4": src.load_tsv(factors / "G_factor_Q4.tsv"),
    }
    lines = ["R=QQ[B,Y,Z,MonomialOrder=>GRevLex];"]
    for name, derivative in zip(
        ("P", "Pu", "PA", "PB", "PY", "PZ"),
        (None, "u", "A", "B", "Y", "Z"),
    ):
        terms = src.specialize_Z(primitive, A0, U0, derivative)
        lines.append(f"{name}={src.sstr(terms)};")
    for name, terms in gates.items():
        if name in {"PuuGate", "delta"}:
            specialized = src.prim_u(terms, A0, U0)
        else:
            specialized = src.prim_ufree(terms, A0)
        lines.append(f"{name}={src.sstr(specialized)};")
    q_terms = [((0, 0, e), int(q_primitive.nth(e))) for e in range(7)]
    lines.append(f"qZ={src.sstr(q_terms)};")
    lines.extend(
        [
            "I=ideal(P,Pu,PA,PB,PY,PZ);",
            "scan({B,ell,Q4,PuuGate,Cgate,delta},g->I=saturate(I,g));",
            "G=gb I;",
            "J=I+ideal(qZ);",
            '<< "FINAL DIM=" << dim I << " DEG=" << degree I',
            '   << " QREM=" << (qZ%G==0)',
            '   << " JDIM=" << dim J << " JDEG=" << degree J << endl;',
            "exit 0;",
        ]
    )
    with tempfile.TemporaryDirectory(prefix="t111_verify_") as directory:
        script = Path(directory) / "verify.m2"
        script.write_text("\n".join(lines) + "\n")
        result = subprocess.run(
            [M2, "--script", str(script)],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=180,
            check=False,
        )
    if result.returncode:
        raise RuntimeError(result.stdout[-4000:])
    match = re.search(
        r"FINAL DIM=(-?\d+) DEG=(\d+) QREM=(true|false) JDIM=(-?\d+) JDEG=(\d+)",
        result.stdout,
    )
    if not match:
        raise RuntimeError(f"cannot parse Macaulay2 output: {result.stdout[-4000:]}")
    dim, degree, qrem, jdim, jdegree = match.groups()
    answer = {
        "dimension": int(dim),
        "degree": int(degree),
        "q_remainder_zero": qrem == "true",
        "constrained_dimension": int(jdim),
        "constrained_degree": int(jdegree),
    }
    assert answer == {
        "dimension": 0,
        "degree": 6,
        "q_remainder_zero": True,
        "constrained_dimension": 0,
        "constrained_degree": 6,
    }, answer
    return answer


def main():
    assert sha256(Q_TSV) == EXPECTED_Q_SHA256
    q = specialized_q()
    q_content, q_primitive = q.primitive()
    factor_content, factors = sp.factor_list(q_primitive)
    assert q.degree() == 6 and q.LC() != 0
    assert factor_content == 1
    assert [(factor.degree(), exponent) for factor, exponent in factors] == [(6, 1)]
    assert sp.gcd(q_primitive, q_primitive.diff()).degree() == 0

    holdout = json.loads(HOLDOUT.read_text())
    assert holdout["A_values"] == [A0] and holdout["u_values"] == [U0]
    expected_coefficients = list(map(int, holdout["rows"][0]["coeffs"]))
    actual_coefficients = [int(q_primitive.nth(e)) for e in range(7)]
    assert actual_coefficients == expected_coefficients

    fibre = m2_check(q_primitive)
    report = {
        "schema": "klein-t111-q-irreducible-special-fibre-verify-v1",
        "q_tsv_sha256": EXPECTED_Q_SHA256,
        "specialization": {"A": A0, "u": U0},
        "q": {
            "degree": q.degree(),
            "raw_content": int(q_content),
            "raw_leading_coefficient": int(q.LC()),
            "primitive_coefficients_constant_first": actual_coefficients,
            "factor_degrees_and_multiplicities": [[6, 1]],
            "gcd_with_derivative_degree": 0,
        },
        "full_saturated_affine_fibre": fibre,
        "proves": [
            "the reconstructed q is irreducible and squarefree over Q(A,u)",
            "the full gate-saturated affine fibre at (17,1) has length six",
            "the specialized q belongs to that full saturated fibre ideal",
        ],
        "does_not_prove": [
            "generic full-fibre length at most six without a finiteness/no-escape certificate",
            "generic membership of q in the unconstrained saturated critical ideal",
        ],
    }
    OUTPUT.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print("T11.1 q irreducibility and special fibre verify OK")
    print(json.dumps(report, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
