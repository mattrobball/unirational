#!/usr/bin/env python3
"""Emit and run the full generic fold-singular ideal over F_p(A,u).

This is a route-selection probe, not a characteristic-zero certificate.  It
uses all six generators (P,P_u,P_A,P_B,P_Y,P_Z), so it does not reuse the
prohibited (P_B,P_Y,P_Z) chart as a theorem.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
SINGULAR = "/opt/homebrew/bin/Singular"


def load_terms() -> list[tuple[tuple[int, ...], int]]:
    if hashlib.sha256(P_PATH.read_bytes()).hexdigest() != EXPECTED_P:
        raise RuntimeError("primitive P hash mismatch")
    terms = []
    with P_PATH.open() as stream:
        if next(stream).strip() != "A\tB\tY\tZ\tu\tcoefficient":
            raise RuntimeError("unexpected TSV header")
        for line in stream:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    if len(terms) != 1593:
        raise RuntimeError(f"unexpected term count {len(terms)}")
    return terms


def derivative(terms, index: int | None):
    out: dict[tuple[int, ...], int] = defaultdict(int)
    for exponents, coefficient in terms:
        e = list(exponents)
        c = coefficient
        if index is not None:
            if e[index] == 0:
                continue
            c *= e[index]
            e[index] -= 1
        out[tuple(e)] += c
    return [(e, c) for e, c in sorted(out.items()) if c]


def singular_expression(terms, prime: int) -> str:
    pieces = []
    variables = ("A", "B", "Y", "Z", "u")
    for exponents, coefficient in terms:
        c = coefficient % prime
        if c == 0:
            continue
        factors = [str(c)]
        for variable, exponent in zip(variables, exponents):
            if exponent == 1:
                factors.append(variable)
            elif exponent > 1:
                factors.append(f"{variable}^{exponent}")
        pieces.append("*".join(factors))
    return "+".join(pieces) if pieces else "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=101)
    parser.add_argument("--timeout", type=int, default=900)
    args = parser.parse_args()

    terms = load_terms()
    names_and_derivatives = (
        ("P", None),
        ("Pu", 4),
        ("PA", 0),
        ("PB", 1),
        ("PY", 2),
        ("PZ", 3),
    )
    script_path = HERE / f"generic_full_sing_p{args.prime}.sing"
    log_path = HERE / f"generic_full_sing_p{args.prime}.log"
    lines = [
        f"ring r=({args.prime},A,u),(B,Y,Z),dp;",
        "option(redSB);",
    ]
    term_counts = {}
    for name, derivation in names_and_derivatives:
        polynomial = derivative(terms, derivation)
        term_counts[name] = len(polynomial)
        lines.append(f"poly {name}={singular_expression(polynomial, args.prime)};")
    lines.extend(
        [
            'print("INPUT_READY");',
            "ideal I=P,Pu,PA,PB,PY,PZ;",
            "ideal G=std(I);",
            'print("STD_READY");',
            'print("GB_SIZE="+string(size(G)));',
            'print("DIM="+string(dim(G)));',
            'print("VDIM="+string(vdim(G)));',
            "print(G);",
            "quit;",
        ]
    )
    script_path.write_text("\n".join(lines) + "\n")
    result = {
        "schema": "klein-fold-full-generic-probe-v1",
        "prime": args.prime,
        "coefficient_field": f"F_{args.prime}(A,u)",
        "variables": ["B", "Y", "Z"],
        "generators": [name for name, _ in names_and_derivatives],
        "term_counts_before_modular_cancellation": term_counts,
        "primitive_sha256": EXPECTED_P,
        "status": "started",
    }
    try:
        completed = subprocess.run(
            [SINGULAR, "-q", str(script_path)],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=args.timeout,
            check=False,
        )
        log_path.write_text(completed.stdout)
        result["returncode"] = completed.returncode
        result["status"] = "completed"
        result["markers"] = [
            line for line in completed.stdout.splitlines()
            if line.startswith(("INPUT_READY", "STD_READY", "GB_SIZE=", "DIM=", "VDIM="))
        ]
    except subprocess.TimeoutExpired as error:
        text = error.stdout or ""
        if isinstance(text, bytes):
            text = text.decode(errors="replace")
        log_path.write_text(text + "\nTIMEOUT\n")
        result["status"] = "timeout"
        result["markers"] = [line for line in text.splitlines() if line.endswith("READY")]
    payload_path = HERE / f"generic_full_sing_p{args.prime}.json"
    payload_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
