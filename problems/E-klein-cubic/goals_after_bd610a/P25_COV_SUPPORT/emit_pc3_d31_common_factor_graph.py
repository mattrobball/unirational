#!/usr/bin/env python3
"""Emit a Singular graph ideal for one modular degree-31 factor component.

The emitted ideal retains all Segre variables.  With --include-elimination it
also appends the mathematically correct target-only elimination command, but
does not run it; these eliminations may be expensive.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
METADATA = HERE / "pc3_d31_common_factor_union.json"
ARTIFACT = HERE / "pc3_d31_common_factor_union.npz"
PRIMES = (419, 463)


def polynomial(terms: list[tuple[int, str]], prime: int) -> str:
    pieces = []
    for coefficient, monomial in terms:
        coefficient %= prime
        if not coefficient:
            continue
        if coefficient == 1:
            pieces.append(monomial)
        else:
            pieces.append(f"{coefficient}*{monomial}")
    return "+".join(pieces) or "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--factor-degree", type=int, required=True)
    parser.add_argument("--prime", type=int, choices=PRIMES, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--include-elimination", action="store_true")
    args = parser.parse_args()

    metadata = json.loads(METADATA.read_text())
    component = metadata["components"].get(str(args.factor_degree))
    if component is None:
        raise SystemExit(f"factor degree {args.factor_degree} is not installed")
    factor_dimension = int(component["factor_dimension"])
    lower_dimension = int(component["lower_dimension"])
    z_count = factor_dimension * lower_dimension
    with np.load(ARTIFACT, allow_pickle=False) as frozen:
        tensor = frozen[
            f"tensor_e{args.factor_degree}_p{args.prime}"
        ].astype(np.int64)
    assert tensor.shape == (198, factor_dimension, lower_dimension)
    flattened = tensor.reshape(198, z_count)

    z_names = [f"z{index}" for index in range(z_count)]
    y_names = [f"y{index}" for index in range(198)]
    variables = ",".join(z_names + y_names)
    segre = []
    for first_factor in range(factor_dimension):
        for second_factor in range(first_factor + 1, factor_dimension):
            for first_lower in range(lower_dimension):
                for second_lower in range(first_lower + 1, lower_dimension):
                    left = first_factor * lower_dimension + first_lower
                    right = second_factor * lower_dimension + second_lower
                    cross_left = first_factor * lower_dimension + second_lower
                    cross_right = second_factor * lower_dimension + first_lower
                    segre.append(
                        f"z{left}*z{right}-z{cross_left}*z{cross_right}"
                    )
    graph = []
    for target in range(198):
        terms = [
            (int(flattened[target, source]), f"z{source}")
            for source in range(z_count)
            if flattened[target, source] % args.prime
        ]
        image = polynomial(terms, args.prime)
        graph.append(f"y{target}-({image})")

    equations = segre + graph
    lines = [
        f"// degree-31 factor degree {args.factor_degree}, p={args.prime}",
        "// Auxiliary graph only: no target-only equations are claimed here.",
        f"ring R={args.prime},({variables}),dp;",
        "ideal Graph=",
        ",\n".join(equations) + ";",
        f"// Segre quadrics: {len(segre)}; graph linear equations: {len(graph)}",
        "option(redSB);",
    ]
    if args.include_elimination:
        eliminator = "*".join(z_names)
        lines.extend([
            "// This command may be expensive; it has not been run by the producer.",
            f"ideal Target=eliminate(Graph,{eliminator});",
            "size(Target);",
        ])
    args.output.write_text("\n".join(lines) + "\n")
    print(
        f"WROTE {args.output} z={z_count} segre={len(segre)} graph={len(graph)}",
        flush=True,
    )


if __name__ == "__main__":
    main()
