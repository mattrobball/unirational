#!/usr/bin/env python3
"""Produce an exact r64 augmented-module job on one affine q-chart.

The sealed r64 packet is a 64 by 7 polynomial matrix

    A(q) = [P4(q) | P3_0(q) | ... | P3_5(q)]

over F_89.  On D(q_i), substituting q_i=1 identifies the rank-defect locus
with the support of coker(A^T) over the 36-variable affine coordinate ring.
Thus a standard basis equal to the whole free module R^7 is a decisive exact
certificate that the chosen q-chart contains no Stage-B or Stage-C point.

This producer only writes the input.  It never launches Singular.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
UPSTREAM = HERE.parent / "enlarged_closure"
PACKET = UPSTREAM / "support_balanced_r64_stageBC.npz"
P = 89
NQ = 37


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


def dehom_polynomial_string(
    coefficients: np.ndarray,
    monomials: list[tuple[int, ...]],
    chart: int,
) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        factors: list[str] = []
        for variable, power in enumerate(exponent):
            if variable == chart or power == 0:
                continue
            name = f"q{variable}"
            factors.append(name if power == 1 else f"{name}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--chart", type=int, default=0)
    parser.add_argument("--algorithm", choices=("std", "slimgb"), default="std")
    args = parser.parse_args()
    chart = args.chart
    if chart < 0 or chart >= NQ:
        raise SystemExit("chart must lie in [0,36]")
    if not PACKET.is_file():
        raise FileNotFoundError(PACKET)

    with np.load(PACKET, allow_pickle=False) as frozen:
        p4 = frozen["p4"].astype(np.uint8)
        p3 = frozen["p3"].astype(np.uint8)
        prime = int(frozen["prime"])
    if prime != P or p4.shape != (64, 91390) or p3.shape != (64, 6, 9139):
        raise AssertionError("unexpected sealed r64 packet")

    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    variables = [f"q{i}" for i in range(NQ) if i != chart]
    stem = f"r64_combined_q{chart}_eq_1_{args.algorithm}"
    script = HERE / f"{stem}.sing"
    result = HERE / f"{stem}.result.txt"

    with script.open("w") as handle:
        handle.write(f"ring R={P},({','.join(variables)}),(dp,C);\n")
        handle.write("option(prot);\n")
        handle.write("module N=\n")
        for row in range(64):
            entries = [dehom_polynomial_string(p4[row], q4, chart)]
            entries.extend(
                dehom_polynomial_string(p3[row, component], q3, chart)
                for component in range(6)
            )
            handle.write("[" + ",".join(entries) + "]")
            handle.write(",\n" if row < 63 else ";\n")
        handle.write('print("AFFINE_INPUT chart=q%d rows="+string(size(N)));\n' % chart)
        handle.write("timer=1; module G=%s(N); int elapsed=timer;\n" % args.algorithm)
        handle.write("int d=dim(G); int decisive=(d==-1);\n")
        handle.write("module E=freemodule(7); module rem=reduce(E,G);\n")
        handle.write("int remainder_zero=(size(rem)==0);\n")
        handle.write(
            'print("AFFINE_RESULT dim="+string(d)+",decisive="+string(decisive)'
            '+",remainder_zero="+string(remainder_zero)+",std_gens="+string(size(G))'
            '+",elapsed_ms="+string(elapsed));\n'
        )
        handle.write(
            f'write(":w {result}","chart={chart},decisive="+string(decisive)'
            '+",dim="+string(d)+",remainder_zero="+string(remainder_zero)'
            '+",std_gens="+string(size(G))+",elapsed_ms="+string(elapsed));\n'
        )
        handle.write("quit;\n")

    payload = {
        "status": "PASS_AFFINE_R64_INPUT_PREPARED",
        "prime": P,
        "chart": chart,
        "substitution": f"q{chart}=1",
        "algorithm": args.algorithm,
        "rows": 64,
        "columns": 7,
        "remaining_variables": 36,
        "packet": str(PACKET),
        "packet_sha256": sha256_file(PACKET),
        "script": script.name,
        "script_sha256": sha256_file(script),
        "script_bytes": script.stat().st_size,
        "result": result.name,
        "decisive_criterion": "dim(std(N))=-1 and reduce(freemodule(7),std(N))=0",
        "scope_if_decisive": f"combined r64 rank seven everywhere on D(q{chart})",
        "not_run": True,
    }
    metadata = HERE / f"{stem}.input.json"
    metadata.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
