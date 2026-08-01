#!/usr/bin/env python3
"""Write (but do not run) the exact Stage-B saturation for support-cover r43.

The generated job uses the same safe necessary equations as the sealed
contraction route, but its 43 syzygies have no forced coordinate component and
have rank six at every q-coordinate point.  A returned unit ideal would be an
exact Stage-B emptiness certificate.  A nonunit result, crash, or timeout would
not be a positive candidate certificate.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "support_cover_r43_stageB.npz"
TARGET = HERE / "support_cover_r43_boundary.sing"
RESULT = HERE / "support_cover_r43_boundary_result.txt"
METADATA = HERE / "support_cover_r43_boundary_job.json"
P = 89


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            h.update(chunk)
    return h.hexdigest()


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
        if not coefficient:
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
    with np.load(SOURCE, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("prime mismatch")
    if p3.shape != (43, 6, 9139):
        raise AssertionError(f"unexpected P3 shape {p3.shape}")
    q3 = weak_compositions(3, 37)
    variables = [f"b1_{j}" for j in range(6)] + [f"q_{j}" for j in range(37)]
    with TARGET.open("w") as handle:
        handle.write('LIB "elim.lib";\n')
        handle.write(f"ring R={P},({','.join(variables)}),dp;\n")
        handle.write("option(prot);\n")
        handle.write("ideal qideal=" + ",".join(f"q_{j}" for j in range(37)) + ";\n")
        handle.write("ideal bideal=" + ",".join(f"b1_{j}" for j in range(6)) + ";\n")
        handle.write("ideal I=\n")
        for row in range(43):
            summands = [
                f"({polynomial_string(p3[row, j], q3)})*b1_{j}"
                for j in range(6)
            ]
            handle.write("+".join(summands))
            handle.write(",\n" if row < 42 else ";\n")
        handle.write('print("input gens="+string(size(I)));\n')
        handle.write("ideal Jb=sat(I,bideal);\n")
        handle.write('print("b-saturated gens="+string(size(Jb)));\n')
        handle.write("ideal J=sat(Jb,qideal);\n")
        handle.write("int is_unit=(reduce(1,J)==0);\n")
        handle.write('print("sat unit="+string(is_unit)+" ngens="+string(size(J)));\n')
        handle.write(
            f'if (is_unit) {{ write(":w {RESULT}",'
            '"unit=true,saturated_generators="+string(size(J))); }\n'
        )
        handle.write(
            f'else {{ write(":w {RESULT}",'
            '"unit=false,saturated_generators="+string(size(J))); }\n'
        )
        handle.write("quit;\n")
    metadata = {
        "prime": P,
        "rows": 43,
        "stratum": "b0=0,b1!=0",
        "source": SOURCE.name,
        "source_sha256": sha256(SOURCE),
        "script": TARGET.name,
        "script_sha256": sha256(TARGET),
        "script_bytes": TARGET.stat().st_size,
        "expanded_p3_terms": int(np.count_nonzero(p3)),
        "result": RESULT.name,
        "saturation_order": ["b1 irrelevant ideal", "q irrelevant ideal"],
        "not_run_by_producer": True,
        "criterion": (
            "Only an exact returned unit ideal proves this necessary-equation "
            "Stage-B scheme empty. Nonunit, timeout, or missing output is not a "
            "verdict on the original incidence."
        ),
    }
    METADATA.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, sort_keys=True))


if __name__ == "__main__":
    main()
