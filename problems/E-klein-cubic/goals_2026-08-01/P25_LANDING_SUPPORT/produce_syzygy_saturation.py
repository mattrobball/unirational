#!/usr/bin/env python3
"""Write exact Macaulay2 saturations for contracted syzygy incidence.

The b0=1 stratum is homogeneous in q_0,...,q_36,b1_0,...,b1_5 and is
saturated by the q-irrelevant ideal.  The b0=0 boundary is bihomogeneous and
is saturated by the product of the q- and b1-irrelevant ideals.  These two
global saturations replace affine coordinate-chart enumeration.
"""

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
    parser.add_argument("--rows", type=int, choices=(48, 96, 256), default=96)
    parser.add_argument("--stratum", choices=("b0", "boundary"), default="boundary")
    args = parser.parse_args()

    contracted = HERE / f"syzygy_r{args.rows}_q0_contracted.npz"
    with np.load(contracted) as frozen:
        p4 = frozen["p4"].astype(np.uint8)
        p3 = frozen["p3"].astype(np.uint8)
        assert int(frozen["prime"]) == P
    assert p4.shape == (args.rows, 91390)
    assert p3.shape == (args.rows, 6, 9139)
    q3 = weak_compositions(3, 37)
    q4 = weak_compositions(4, 37)

    target = HERE / f"syzygy_r{args.rows}_{args.stratum}_saturate.m2"
    result = HERE / f"syzygy_r{args.rows}_{args.stratum}_saturation_result.json"
    with target.open("w") as handle:
        handle.write(f"p={P};\n")
        if args.stratum == "boundary":
            handle.write(
                "R=(ZZ/p)[b1_0..b1_5,q_0..q_36,"
                "Degrees=>toList(6:{0,1})|toList(37:{1,0}),"
                "MonomialOrder=>GRevLex];\n"
            )
        else:
            handle.write(
                "R=(ZZ/p)[b1_0..b1_5,q_0..q_36,MonomialOrder=>GRevLex];\n"
            )
        handle.write("qideal=ideal(q_0..q_36);\n")
        handle.write("bideal=ideal(b1_0..b1_5);\n")
        handle.write("I=ideal(\n")
        for row in range(args.rows):
            terms: list[str] = []
            if args.stratum == "b0":
                terms.append(polynomial_string(p4[row], q4))
            for j in range(6):
                polynomial = polynomial_string(p3[row, j], q3)
                terms.append(f"({polynomial})*b1_{j}")
            handle.write("+".join(terms))
            handle.write(",\n" if row + 1 < args.rows else "\n")
        handle.write(");\n")
        handle.write('<<"input gens="<<numgens I<<endl;\n')
        handle.write("t0=cpuTime();\n")
        saturation = "qideal" if args.stratum == "b0" else "qideal*bideal"
        handle.write(f"J=saturate(I,{saturation});\n")
        handle.write("unit=(J==ideal(1_R));\n")
        handle.write('<<"sat unit="<<unit<<" ngens="<<numgens J')
        handle.write('<<" cpu="<<(cpuTime()-t0)<<endl;\n')
        handle.write(f'f=openOut "{result}";\n')
        handle.write(
            'f<<"{\\\"prime\\\":89,\\\"rows\\\":"<<numgens I'
            '<<",\\\"stratum\\\":\\\"' + args.stratum + '\\\",\\\"unit\\\":"'
            '<<(if unit then "true" else "false")'
            '<<",\\\"saturated_generators\\\":"<<numgens J'
            '<<",\\\"cpu_seconds\\\":"<<(cpuTime()-t0)<<"}"<<endl;\n'
        )
        handle.write("close f;\n")

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
        "saturation": saturation,
        "criterion": (
            "A saturated unit ideal is an exact global emptiness certificate for "
            "this stratum. Timeout, crash, or a nonunit result is not emptiness."
        ),
    }
    metadata_path = HERE / f"syzygy_r{args.rows}_{args.stratum}_saturation.json"
    metadata_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
