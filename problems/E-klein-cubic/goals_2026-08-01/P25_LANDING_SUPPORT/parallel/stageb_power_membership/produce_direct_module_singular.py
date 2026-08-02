#!/usr/bin/env python3
"""Write a bounded weighted-module membership job for the direct 690 map.

The 690 generators are vectors in

    S^6 (+) S(1)^21

with quadratic M1 entries and linear M2 entries.  Thus component weights
0^6,1^21 make every input generator homogeneous of weighted degree two.
Computing a standard basis only through polynomial degree five is sufficient
to reduce q_axis^5 e_component exactly.  The producer only writes the script;
the sibling bounded runner enforces wall/RSS limits.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np


P = 89
NQ = 37
HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def polynomial(coefficients: np.ndarray, monomials: list[tuple[int, ...]]) -> str:
    terms: list[str] = []
    for raw, exp in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        factors = []
        for variable, power in enumerate(exp):
            if power:
                factors.append(f"q{variable}" if power == 1 else f"q{variable}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--axis", type=int, default=0)
    parser.add_argument("--component", type=int, default=0)
    args = parser.parse_args()
    if args.axis < 0 or args.axis >= NQ or args.component < 0 or args.component >= 6:
        raise SystemExit("axis/component out of range")
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    q2 = weak_compositions(2, NQ)
    q1 = weak_compositions(1, NQ)
    m1 = [
        seeds[:, int(offsets[1 + j]):int(offsets[2 + j])]
        for j in range(6)
    ]
    m2 = [
        seeds[:, int(offsets[7 + j]):int(offsets[8 + j])]
        for j in range(21)
    ]
    stem = f"direct_axis{args.axis}_component{args.component}_degree5"
    script = HERE / f"{stem}.sing"
    result = HERE / f"{stem}.result"
    log = HERE / f"{stem}.log"
    variables = ",".join(f"q{i}" for i in range(NQ))
    weights = ",".join(["0"] * 6 + ["1"] * 21)
    with script.open("w") as handle:
        handle.write(f"ring R={P},({variables}),(dp,C);\n")
        handle.write("option(prot); option(redSB);\n")
        handle.write("module N=\n")
        for row in range(690):
            entries = [polynomial(block[row], q2) for block in m1]
            entries.extend(polynomial(block[row], q1) for block in m2)
            handle.write("[" + ",".join(entries) + "]")
            handle.write(",\n" if row < 689 else ";\n")
        handle.write(f"attrib(N,\"isHomog\",intvec({weights}));\n")
        handle.write('print("INPUT_GENS="+string(size(N)));\n')
        handle.write("degBound=5; timer=1; module G=std(N); int elapsed=timer;\n")
        handle.write(
            f"vector target=q{args.axis}^5*gen({args.component + 1});\n"
            "vector rem=reduce(target,G);\n"
        )
        handle.write("int member=(rem==0);\n")
        handle.write(
            'print("STD_GENS="+string(size(G))+" MEMBER="+string(member)'
            '+" ELAPSED_MS="+string(elapsed));\n'
        )
        handle.write(
            f'write(\":w {result}\",\"member=\"+string(member)'
            '+",std_gens="+string(size(G))+",elapsed_ms="+string(elapsed)'
            '+",remainder="+string(rem));\n'
        )
        handle.write("quit;\n")
    payload = {
        "status": "PREPARED_NOT_RUN",
        "prime": P,
        "axis": args.axis,
        "component": args.component,
        "script": {"file": script.name, "sha256": sha256(script), "bytes": script.stat().st_size},
        "result": result.name,
        "log": log.name,
        "relation_matrix": {"path": str(RELATION), "sha256": sha256(RELATION)},
        "module_components": 27,
        "module_component_weights": [0] * 6 + [1] * 21,
        "generators": 690,
        "degree_bound": 5,
        "criterion": f"reduce(q{args.axis}^5*gen({args.component + 1}),std(N)) == 0",
        "scope": (
            "A completed zero remainder is an exact membership certificate. A "
            "completed nonzero remainder is exact only because the global dp order "
            "and degree bound include every reducer of a degree-five target. Timeout, "
            "RSS kill, or missing result is a nonverdict."
        ),
    }
    manifest = HERE / f"{stem}.json"
    manifest.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
