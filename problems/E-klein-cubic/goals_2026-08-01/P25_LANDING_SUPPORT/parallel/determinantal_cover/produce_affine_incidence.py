#!/usr/bin/env python3
"""Build exact r66 affine incidence charts over GF(89).

This is a bounded alternative to expanding 7x7 determinants.  On a q flag
chart and a projective b flag chart, the 66 contracted rows are ordinary
polynomial equations.  A completed unit-ideal Groebner basis is exactly a
chartwise Nullstellensatz certificate for the selected r66 matrix and hence
for the true lower incidence.  Anything else is a nonverdict.

The q flags use the ordered complement coordinates
q0,q1,q2,q3,q12,...,q36.  Earlier flag coordinates are set to zero and the
current one to one.  Stage B similarly flags b1_0,...,b1_5.  Stage C uses
b0=1 and leaves all six b1 coordinates affine.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "global_compatibility" / "support_augmented_r66_stageBC.npz"
P = 89
NQ = 37
H8 = (0, 1, 2, 3) + tuple(range(12, 37))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def specialize_monomial(
    exponent: tuple[int, ...], zero_coordinates: frozenset[int], unit_coordinate: int
) -> str | None:
    if any(exponent[index] for index in zero_coordinates):
        return None
    factors: list[str] = []
    for index, power in enumerate(exponent):
        if not power or index == unit_coordinate:
            continue
        factors.append(f"q{index}" if power == 1 else f"q{index}^{power}")
    return "*".join(factors) if factors else "1"


def polynomial_terms(
    coefficients: np.ndarray,
    monomials: list[tuple[int, ...]],
    zero_coordinates: frozenset[int],
    unit_coordinate: int,
    b_variable: str | None,
) -> list[str]:
    answer: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        qpart = specialize_monomial(exponent, zero_coordinates, unit_coordinate)
        if qpart is None:
            continue
        factors: list[str] = []
        if qpart != "1":
            factors.append(qpart)
        if b_variable is not None:
            factors.append(b_variable)
        monomial = "*".join(factors) if factors else "1"
        answer.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return answer


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--stage", choices=("B", "C"), required=True)
    parser.add_argument("--q-flag", type=int, choices=range(len(H8)), required=True)
    parser.add_argument("--b-flag", type=int, choices=range(6))
    args = parser.parse_args()
    if args.stage == "B" and args.b_flag is None:
        parser.error("Stage B requires --b-flag")
    if args.stage == "C" and args.b_flag is not None:
        parser.error("Stage C has fixed b0=1 and takes no --b-flag")

    with np.load(PACKET, allow_pickle=False) as frozen:
        p4 = frozen["p4"].astype(np.uint8)
        p3 = frozen["p3"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("r66 prime mismatch")
    if p4.shape != (66, 91390) or p3.shape != (66, 6, 9139):
        raise AssertionError("r66 tensor shape mismatch")

    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    qflag = args.q_flag
    unit_q = H8[qflag]
    zero_q = frozenset(H8[:qflag])
    q_variables = [
        f"q{i}" for i in range(NQ) if i != unit_q and i not in zero_q
    ]

    if args.stage == "B":
        assert args.b_flag is not None
        unit_b = args.b_flag
        zero_b = frozenset(range(unit_b))
        b_variables = [f"b1_{j}" for j in range(6) if j > unit_b]
        stem = f"r66_stageB_qflag{qflag:02d}_bflag{unit_b}"
    else:
        unit_b = -1
        zero_b = frozenset()
        b_variables = [f"b1_{j}" for j in range(6)]
        stem = f"r66_stageC_qflag{qflag:02d}_b0_1"

    equations: list[str] = []
    printed_terms = 0
    for row in range(66):
        terms: list[str] = []
        if args.stage == "C":
            terms.extend(
                polynomial_terms(p4[row], q4, zero_q, unit_q, None)
            )
        for component in range(6):
            if args.stage == "B" and component in zero_b:
                continue
            if args.stage == "B" and component == unit_b:
                b_variable = None
            else:
                b_variable = f"b1_{component}"
            terms.extend(
                polynomial_terms(
                    p3[row, component], q3, zero_q, unit_q, b_variable
                )
            )
        printed_terms += len(terms)
        equations.append("+".join(terms) if terms else "0")

    output = HERE / f"{stem}.ms"
    variables = b_variables + q_variables
    content = ",".join(variables) + f"\n{P}\n" + ",\n".join(equations) + "\n"
    if output.exists() and output.read_text() != content:
        raise SystemExit(f"refusing to overwrite mismatching immutable input {output}")
    output.write_text(content)
    manifest = {
        "status": "PASS_R66_AFFINE_INCIDENCE_PREPARED",
        "prime": P,
        "stage": args.stage,
        "q_flag_index": qflag,
        "q_unit_coordinate": unit_q,
        "q_zero_coordinates": sorted(zero_q),
        "b_flag_index": args.b_flag,
        "b_zero_coordinates": sorted(zero_b),
        "equations": 66,
        "variables": len(variables),
        "printed_terms": printed_terms,
        "input": output.name,
        "input_bytes": output.stat().st_size,
        "input_sha256": sha256(output),
        "r66_packet": str(PACKET.relative_to(P25)),
        "r66_packet_sha256": sha256(PACKET),
        "criterion": (
            "A completed exact Groebner basis equal to [1] proves this affine "
            "q/b flag chart empty over the algebraic closure of F_89. Any "
            "timeout, resource stop, nonunit basis, or incomplete output is a nonverdict."
        ),
    }
    manifest_path = HERE / f"{stem}.json"
    payload = json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    if manifest_path.exists() and manifest_path.read_text() != payload:
        raise SystemExit(f"refusing to overwrite mismatching manifest {manifest_path}")
    manifest_path.write_text(payload)
    print(json.dumps(manifest, sort_keys=True))


if __name__ == "__main__":
    main()
