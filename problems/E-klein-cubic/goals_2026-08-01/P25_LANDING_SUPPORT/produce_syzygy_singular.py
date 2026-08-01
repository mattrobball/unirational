#!/usr/bin/env python3
"""Write Singular exact saturations for contracted syzygy incidence."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P = 89


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    output: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            output.append((first,) + tail)
    return output


def polynomial_string(coefficients: np.ndarray, monomials) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if coefficient == 0:
            continue
        factors: list[str] = []
        for variable, power in enumerate(exponent):
            if power:
                name = f"q_{variable}"
                factors.append(name if power == 1 else f"{name}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=int, choices=(48, 96, 256), default=48)
    parser.add_argument("--stratum", choices=("b0", "boundary"), default="boundary")
    args = parser.parse_args()

    contracted = HERE / f"syzygy_r{args.rows}_q0_contracted.npz"
    with np.load(contracted) as frozen:
        p4 = frozen["p4"].astype(np.uint8)
        p3 = frozen["p3"].astype(np.uint8)
        assert int(frozen["prime"]) == P
    q3 = weak_compositions(3, 37)
    q4 = weak_compositions(4, 37)
    variables = [f"b1_{j}" for j in range(6)] + [f"q_{j}" for j in range(37)]
    target = HERE / f"syzygy_r{args.rows}_{args.stratum}_saturate.sing"
    result = HERE / f"syzygy_r{args.rows}_{args.stratum}_singular_result.txt"
    with target.open("w") as handle:
        handle.write('LIB "elim.lib";\n')
        handle.write(f"ring R={P},({','.join(variables)}),dp;\n")
        handle.write("option(redSB);\n")
        handle.write("ideal qideal=" + ",".join(f"q_{j}" for j in range(37)) + ";\n")
        handle.write("ideal bideal=" + ",".join(f"b1_{j}" for j in range(6)) + ";\n")
        handle.write("ideal I=\n")
        for row in range(args.rows):
            terms: list[str] = []
            if args.stratum == "b0":
                terms.append(polynomial_string(p4[row], q4))
            for j in range(6):
                terms.append(f"({polynomial_string(p3[row, j], q3)})*b1_{j}")
            handle.write("+".join(terms))
            handle.write(",\n" if row + 1 < args.rows else ";\n")
        handle.write('print("input gens="+string(size(I)));\n')
        if args.stratum == "b0":
            handle.write("ideal J=sat(I,qideal);\n")
        else:
            handle.write("ideal product_ideal=qideal*bideal;\n")
            handle.write("ideal J=sat(I,product_ideal);\n")
        handle.write("int is_unit=(reduce(1,J)==0);\n")
        handle.write('print("sat unit="+string(is_unit)+" ngens="+string(size(J)));\n')
        handle.write(
            f'if (is_unit) {{ write(":w {result}",'
            '"unit=true,saturated_generators="+string(size(J))); }\n'
        )
        handle.write(
            f'else {{ write(":w {result}",'
            '"unit=false,saturated_generators="+string(size(J))); }\n'
        )
        handle.write("quit;\n")

    metadata = {
        "prime": P,
        "rows": args.rows,
        "stratum": args.stratum,
        "contracted": contracted.name,
        "contracted_sha256": sha256(contracted),
        "script": target.name,
        "script_sha256": sha256(target),
        "script_bytes": target.stat().st_size,
        "result": result.name,
        "criterion": (
            "Singular elim.lib sat computes the exact ideal saturation. A reduced "
            "unit ideal is conclusive; timeout, crash, or nonunit is not emptiness."
        ),
    }
    metadata_path = HERE / f"syzygy_r{args.rows}_{args.stratum}_singular.json"
    metadata_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
