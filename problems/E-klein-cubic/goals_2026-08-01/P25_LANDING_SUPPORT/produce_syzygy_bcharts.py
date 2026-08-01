#!/usr/bin/env python3
"""Write one exact affine b1-chart of the contracted Stage-B incidence.

The boundary has b0=0 and b1 != 0.  Its six standard affine charts are
b1_chart=1.  On each chart the 48 contracted equations remain homogeneous of
q-degree three, so saturation by (q_0,...,q_36) removes exactly the forbidden
q=0 locus.  Unit saturation on all six charts is an exact finite-cover
certificate for Stage-B emptiness.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P = 89
NQ = 37
NB1 = 6


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    output: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            output.append((first,) + tail)
    return output


def polynomial_string(
    coefficients: np.ndarray, monomials: list[tuple[int, ...]]
) -> str:
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
    parser.add_argument("--chart", type=int, choices=range(NB1), required=True)
    args = parser.parse_args()

    contracted = HERE / "syzygy_r48_q0_contracted.npz"
    with np.load(contracted) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise RuntimeError("contracted packet has the wrong prime")
    if p3.shape != (48, NB1, 9139):
        raise RuntimeError(f"unexpected P3 shape {p3.shape}")

    chart = args.chart
    b_variables = [f"b1_{j}" for j in range(NB1) if j != chart]
    q_variables = [f"q_{j}" for j in range(NQ)]
    variables = b_variables + q_variables
    q3 = weak_compositions(3, NQ)
    script = HERE / f"syzygy_r48_boundary_chart{chart}_saturate.sing"
    result = HERE / f"syzygy_r48_boundary_chart{chart}_result.txt"

    with script.open("w") as handle:
        handle.write('LIB "elim.lib";\n')
        handle.write(f"ring R={P},({','.join(variables)}),dp;\n")
        handle.write("option(redSB);\n")
        handle.write("ideal qideal=" + ",".join(q_variables) + ";\n")
        handle.write("ideal I=\n")
        for row in range(48):
            terms: list[str] = []
            for j in range(NB1):
                polynomial = polynomial_string(p3[row, j], q3)
                terms.append(polynomial if j == chart else f"({polynomial})*b1_{j}")
            handle.write("+".join(terms))
            handle.write(",\n" if row < 47 else ";\n")
        handle.write('print("input gens="+string(size(I)));\n')
        handle.write("ideal J=sat(I,qideal);\n")
        handle.write("int is_unit=(reduce(1,J)==0);\n")
        handle.write('print("sat unit="+string(is_unit)+" ngens="+string(size(J)));\n')
        handle.write(
            f'write(":w {result}","unit="+string(is_unit)'
            '+",saturated_generators="+string(size(J)));\n'
        )
        handle.write("quit;\n")

    metadata = {
        "prime": P,
        "rows": 48,
        "stratum": f"b0=0,b1_{chart}=1",
        "contracted": contracted.name,
        "contracted_sha256": sha256(contracted),
        "script": script.name,
        "script_sha256": sha256(script),
        "script_bytes": script.stat().st_size,
        "result": result.name,
        "criterion": (
            "The chart ideal is saturated by the q-irrelevant ideal. A unit ideal "
            "is an exact emptiness certificate for this chart; all six charts "
            "cover b1 != 0."
        ),
    }
    metadata_path = HERE / f"syzygy_r48_boundary_chart{chart}.json"
    metadata_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
