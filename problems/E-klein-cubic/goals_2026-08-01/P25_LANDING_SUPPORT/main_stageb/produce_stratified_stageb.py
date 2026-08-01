#!/usr/bin/env python3
"""Generate exact Singular Stage-B systems for coordinate strata.

The source equations are verified necessary contractions P3(q)b1=0.  A unit
ideal after the stated saturations is therefore an exact emptiness certificate
for that stratum.  A nonunit result is only a contraction-system survivor.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parent
P = 89


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def parse_indices(spec: str) -> list[int]:
    out: set[int] = set()
    for piece in spec.split(","):
        piece = piece.strip()
        if not piece:
            continue
        if "-" in piece:
            start, stop = map(int, piece.split("-", 1))
            out.update(range(start, stop + 1))
        else:
            out.add(int(piece))
    if not out or min(out) < 0 or max(out) > 36:
        raise ValueError(f"invalid q-index specification: {spec}")
    return sorted(out)


def polynomial_string(
    coefficients: np.ndarray,
    monomials: list[tuple[int, ...]],
    retained: set[int],
) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if coefficient == 0:
            continue
        if any(power and variable not in retained for variable, power in enumerate(exponent)):
            continue
        factors = []
        for variable, power in enumerate(exponent):
            if power:
                name = f"q_{variable}"
                factors.append(name if power == 1 else f"{name}^{power}")
        terms.append(
            "*".join(factors)
            if coefficient == 1
            else f"{coefficient}*{'*'.join(factors)}"
        )
    return "+".join(terms) if terms else "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--name", required=True)
    parser.add_argument("--source-rows", type=int, choices=(48, 96, 256), required=True)
    parser.add_argument("--take", type=int, default=0, help="use the first N source rows; 0 means all")
    parser.add_argument(
        "--retain",
        default="0-36",
        help="q coordinates retained in the ring; omitted coordinates are set to zero",
    )
    parser.add_argument(
        "--open-ideal",
        default="",
        help="coordinate ideal whose nonvanishing open is tested; defaults to all retained q's",
    )
    args = parser.parse_args()

    retained = parse_indices(args.retain)
    retained_set = set(retained)
    open_indices = parse_indices(args.open_ideal) if args.open_ideal else retained
    if not set(open_indices).issubset(retained_set):
        raise ValueError("open-ideal coordinates must be retained")

    contracted = P25 / f"syzygy_r{args.source_rows}_q0_contracted.npz"
    with np.load(contracted) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        chosen = frozen["chosen_syzygies"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise RuntimeError("prime mismatch")
    take = args.take or args.source_rows
    if not 1 <= take <= args.source_rows:
        raise ValueError("--take outside source row range")
    p3 = p3[:take]
    chosen = chosen[:take]
    q3 = weak_compositions(3, 37)

    variables = [f"b1_{j}" for j in range(6)] + [f"q_{j}" for j in retained]
    target = HERE / f"{args.name}.sing"
    result = HERE / f"{args.name}_result.txt"
    with target.open("w") as handle:
        handle.write('LIB "elim.lib";\n')
        handle.write(f"ring R={P},({','.join(variables)}),dp;\n")
        handle.write("option(prot);\n")
        handle.write("ideal bideal=" + ",".join(f"b1_{j}" for j in range(6)) + ";\n")
        handle.write("ideal openideal=" + ",".join(f"q_{j}" for j in open_indices) + ";\n")
        handle.write("ideal I=\n")
        zero_rows = 0
        for row in range(take):
            terms = []
            for column in range(6):
                polynomial = polynomial_string(p3[row, column], q3, retained_set)
                if polynomial != "0":
                    terms.append(f"({polynomial})*b1_{column}")
            equation = "+".join(terms) if terms else "0"
            zero_rows += int(equation == "0")
            handle.write(equation)
            handle.write(",\n" if row + 1 < take else ";\n")
        handle.write('print("input gens="+string(size(I)));\n')
        handle.write("ideal Jb=sat(I,bideal);\n")
        handle.write('print("b-saturated gens="+string(size(Jb)));\n')
        handle.write("ideal J=sat(Jb,openideal);\n")
        handle.write("int is_unit=(reduce(1,J)==0);\n")
        handle.write('print("open-saturated unit="+string(is_unit)+" ngens="+string(size(J)));\n')
        handle.write(
            f'write(":w {result}","unit="+string(is_unit)'
            '+",saturated_generators="+string(size(J)));\n'
        )
        handle.write("quit;\n")

    payload = {
        "prime": P,
        "name": args.name,
        "source": str(contracted),
        "source_sha256": sha256(contracted),
        "source_rows": args.source_rows,
        "rows_used": take,
        "source_syzygy_indices": chosen.astype(int).tolist(),
        "retained_q_coordinates": retained,
        "open_ideal_q_coordinates": open_indices,
        "zero_equations_after_restriction": zero_rows,
        "script": target.name,
        "script_sha256": sha256(target),
        "script_bytes": target.stat().st_size,
        "result": result.name,
        "criterion": (
            "unit after exact saturation by b1 irrelevant ideal and the stated "
            "q-coordinate open ideal proves this contraction-system stratum empty"
        ),
        "logical_scope": (
            "The contractions are necessary for every lower-presentation point. "
            "Unit is conclusive for emptiness; nonunit is inconclusive."
        ),
    }
    metadata = HERE / f"{args.name}.json"
    metadata.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
