#!/usr/bin/env python3
"""Generate an exact affine-chart augmented-module test over F_89.

For a chosen coordinate q_axis, this dehomogenizes q_axis=1 in the verified
support-balanced r64 [P4|P3] packet.  If the resulting 64 rows generate the
free rank-seven module over the remaining 36-variable polynomial ring, then
the combined Stage-B/Stage-C contraction incidence is empty on D(q_axis).

The generated Singular input is intentionally local to this directory.  It
does not launch Singular.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import defaultdict
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "enlarged_closure" / "support_balanced_r64_stageBC.npz"
P = 89
NQ = 37
H8 = tuple(range(4)) + tuple(range(12, 37))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def dehom_polynomial(
    coefficients: np.ndarray,
    monomials: list[tuple[int, ...]],
    axis: int,
    variable_names: list[str],
) -> str:
    collapsed: dict[tuple[int, ...], int] = defaultdict(int)
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if coefficient:
            reduced = exponent[:axis] + exponent[axis + 1 :]
            collapsed[reduced] = (collapsed[reduced] + coefficient) % P

    terms: list[tuple[tuple[int, tuple[int, ...]], str]] = []
    for exponent, coefficient in collapsed.items():
        if not coefficient:
            continue
        factors: list[str] = []
        for variable, power in zip(variable_names, exponent):
            if power:
                factors.append(variable if power == 1 else f"{variable}^{power}")
        monomial = "*".join(factors) if factors else "1"
        text = monomial if coefficient == 1 else f"{coefficient}*{monomial}"
        # Highest total degree first, then reverse-lex-looking deterministic
        # exponent order.  Term order is set by Singular, not by print order.
        terms.append(((sum(exponent), exponent), text))
    terms.sort(key=lambda item: item[0], reverse=True)
    return "+".join(text for _, text in terms) if terms else "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--axis", type=int, default=0)
    args = parser.parse_args()
    axis = args.axis
    if axis not in H8:
        raise SystemExit(f"axis {axis} is not in H8={H8}")

    packet = np.load(PACKET, allow_pickle=False)
    p3 = packet["p3"]
    p4 = packet["p4"]
    if p3.shape != (64, 6, 9139) or p4.shape != (64, 91390):
        raise RuntimeError(f"unexpected packet shapes {p3.shape}, {p4.shape}")

    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    variable_names = [f"q{i}" for i in range(NQ) if i != axis]
    stem = f"affine_q{axis}_r64_augmented_module"
    script = HERE / f"{stem}.sing"
    result = HERE / f"{stem}.result.txt"

    with script.open("w") as handle:
        handle.write(
            f"ring R={P},({','.join(variable_names)}),(dp,C);\n"
            "option(prot);\n"
            "option(redSB);\n"
            "module N=\n"
        )
        for row in range(64):
            entries = [dehom_polynomial(p4[row], q4, axis, variable_names)]
            entries.extend(
                dehom_polynomial(p3[row, component], q3, axis, variable_names)
                for component in range(6)
            )
            handle.write("[" + ",".join(entries) + "]")
            handle.write(",\n" if row < 63 else ";\n")
        handle.write('print("chart=q%d input_gens="+string(size(N)));\n' % axis)
        handle.write("timer=1; module G=std(N); int elapsed=timer;\n")
        handle.write(
            "int decisive=1; int j; for (j=1;j<=7;j++)"
            "{ if (reduce(gen(j),G)!=0) { decisive=0; } }\n"
        )
        handle.write(
            'print("unit_module="+string(decisive)+" std_gens="'
            '+string(size(G))+" elapsed_ms="+string(elapsed));\n'
        )
        handle.write(
            f'write(":w {result}","decisive="+string(decisive)'
            '+",std_gens="+string(size(G))+",elapsed_ms="+string(elapsed));\n'
        )
        handle.write("quit;\n")

    metadata = {
        "axis": axis,
        "chart": f"q{axis}=1",
        "criterion": "all seven free generators reduce to zero modulo std(N)",
        "implication": (
            "If decisive=1, the verified r64 augmented contraction module is "
            "unit on D(q_axis), hence both Stage B and Stage C are empty there."
        ),
        "packet": {"path": str(PACKET), "sha256": sha256(PACKET)},
        "script": {
            "path": script.name,
            "bytes": script.stat().st_size,
            "sha256": sha256(script),
        },
        "result": result.name,
        "prime": P,
        "status": "PREPARED_NOT_RUN",
    }
    manifest = HERE / f"{stem}.json"
    manifest.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
