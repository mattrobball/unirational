#!/usr/bin/env python3
"""Generate and run Singular factorizations of the T3 discriminant discovery."""

from __future__ import annotations

import argparse
import gzip
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
PAYLOAD = HERE / "t3_disc_delta_cub_qzeta11.json.gz"
SINGULAR = "/opt/homebrew/bin/Singular"


def rational_piece(numerator: int, denominator: int) -> str:
    if denominator == 1:
        return str(numerator)
    return f"({numerator}/{denominator})"


def qzeta_coefficient(data) -> str:
    pieces = []
    for exponent, (numerator, denominator) in enumerate(data):
        if not numerator:
            continue
        scalar = rational_piece(numerator, denominator)
        if exponent:
            pieces.append(f"({scalar})*z^{exponent}")
        else:
            pieces.append(scalar)
    assert pieces
    return "(" + "+".join(pieces) + ")"


def coefficient_mod(data, prime=67, zeta=9) -> int:
    answer = 0
    for exponent, (numerator, denominator) in enumerate(data):
        assert denominator % prime
        answer += numerator * pow(denominator, -1, prime) * pow(zeta, exponent, prime)
    return answer % prime


def monomial(exponents) -> str:
    factors = []
    for name, exponent in zip(("A", "B", "Y", "Z"), exponents):
        if exponent == 1:
            factors.append(name)
        elif exponent:
            factors.append(f"{name}^{exponent}")
    return "*".join(factors) if factors else "1"


def report_block() -> list[str]:
    return [
        "list L=factorize(D);",
        'print("T3_DISC_FACTOR_LIST_SIZE");',
        "print(size(L[1]));",
        "for (int i=1; i<=size(L[1]); i++)",
        "{",
        '  print("T3_DISC_FACTOR_RECORD");',
        "  print(i);",
        "  print(L[2][i]);",
        "  print(deg(L[1][i]));",
        "  print(size(L[1][i]));",
        "}",
        'print("T3_DISC_FACTOR_SINGULAR_DONE");',
        "exit;",
    ]


def write_exact(payload) -> Path:
    path = HERE / "t3_disc_factor_qzeta11.sing"
    lines = [
        "ring r=(0,z),(A,B,Y,Z),dp;",
        "minpoly=z^10+z^9+z^8+z^7+z^6+z^5+z^4+z^3+z^2+z+1;",
        "poly D=0;",
    ]
    for term in payload["delta_terms"]:
        coefficient = qzeta_coefficient(term["coefficient_qzeta11"])
        lines.append(f"D=D+({coefficient})*({monomial(term['exponents'])});")
    lines.extend(report_block())
    path.write_text("\n".join(lines) + "\n")
    return path


def write_mod67(payload) -> Path:
    path = HERE / "t3_disc_factor_mod67.sing"
    lines = ["ring r=67,(A,B,Y,Z),dp;", "poly D=0;"]
    for term in payload["delta_terms"]:
        coefficient = coefficient_mod(term["coefficient_qzeta11"])
        if coefficient:
            lines.append(f"D=D+({coefficient})*({monomial(term['exponents'])});")
    lines.extend(report_block())
    path.write_text("\n".join(lines) + "\n")
    return path


def run(path: Path, timeout: int) -> dict:
    log = path.with_suffix(".log")
    try:
        result = subprocess.run(
            [SINGULAR, "-q", str(path)],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            timeout=timeout,
            check=False,
        )
        log.write_text(result.stdout)
        lines = [line.strip() for line in result.stdout.splitlines() if line.strip()]
        records = []
        for index, line in enumerate(lines):
            if line == "T3_DISC_FACTOR_RECORD":
                records.append(
                    {
                        "index": int(lines[index + 1]),
                        "exponent": int(lines[index + 2]),
                        "total_degree": int(lines[index + 3]),
                        "terms": int(lines[index + 4]),
                    }
                )
        list_marker = lines.index("T3_DISC_FACTOR_LIST_SIZE")
        list_size = int(lines[list_marker + 1])
        nonconstant = [record for record in records if record["total_degree"] > 0]
        has_error = any(line.startswith("?") for line in lines)
        return {
            "script": path.name,
            "log": log.name,
            "status": "PASS" if result.returncode == 0 and not has_error else "ERROR",
            "returncode": result.returncode,
            "factor_list_size_including_unit": list_size,
            "records": records,
            "irreducible": (
                len(nonconstant) == 1
                and nonconstant[0]["exponent"] == 1
                and list_size == 2
            ),
        }
    except subprocess.TimeoutExpired as error:
        output = error.stdout or ""
        if isinstance(output, bytes):
            output = output.decode(errors="replace")
        log.write_text(output + f"\nT3_DISC_FACTOR_TIMEOUT={timeout}\n")
        return {"script": path.name, "log": log.name, "status": "TIMEOUT", "seconds": timeout}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--timeout", type=int, default=300)
    args = parser.parse_args()
    with gzip.open(PAYLOAD, "rt") as stream:
        payload = json.load(stream)
    exact = write_exact(payload)
    mod67 = write_mod67(payload)
    results = {"mod67_zeta9": run(mod67, args.timeout), "exact_qzeta11": run(exact, args.timeout)}
    result_path = HERE / "t3_disc_factor_singular_result.json"
    result_path.write_text(json.dumps(results, indent=2, sort_keys=True) + "\n")
    print(json.dumps(results, indent=2, sort_keys=True))
    print("T3_DISC_FACTOR_SINGULAR_DRIVER_DONE")


if __name__ == "__main__":
    main()
