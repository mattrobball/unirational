#!/usr/bin/env python3
"""Contract exact M2 syzygies and build small affine incidence charts.

The 21 quadratic-basis kernel variables disappear from every contraction
C(q)M(q)b because C(q)M2(q)=0.  The remaining equations are

    P4(q) b0 + sum_j P3_j(q) b1_j = 0.

This producer selects the sparsest independently verified syzygies and writes
the two unresolved b-strata on one requested q-chart:

* b0=1;
* b0=0, b1_fix=1.

Any zero of the full lower-presentation incidence maps to a zero of these
necessary equations on one of the corresponding affine charts.  Thus exact
emptiness of every chart is a safe over-approximation certificate.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FM = ROOT / "certificates" / "degree25_finite_module"
P = 89


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    result: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            result.append((first,) + tail)
    return result


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: i for i, monomial in enumerate(target)}
    answer = np.empty((37, len(source)), dtype=np.int32)
    for variable in range(37):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, source_index] = target_index[tuple(exponent)]
    return answer


def contract(
    syzygy: np.ndarray,
    block: np.ndarray,
    product_map: np.ndarray,
    target_size: int,
) -> np.ndarray:
    output = np.zeros(target_size, dtype=np.int64)
    block64 = block.astype(np.int64)
    for variable in range(37):
        coefficients = (syzygy[:, variable].astype(np.int64) @ block64) % P
        np.add.at(output, product_map[variable], coefficients)
    return (output % P).astype(np.uint8)


def q_monomial_string(exponent: tuple[int, ...], fixed_q: int) -> str:
    factors: list[str] = []
    for variable, power in enumerate(exponent):
        if variable == fixed_q or power == 0:
            continue
        name = f"q{variable}"
        factors.append(name if power == 1 else f"{name}^{power}")
    return "*".join(factors) if factors else "1"


def append_terms(
    terms: list[str],
    coefficients: np.ndarray,
    monomials: list[tuple[int, ...]],
    fixed_q: int,
    b_name: str | None,
) -> None:
    for raw_coefficient, exponent in zip(coefficients, monomials):
        coefficient = int(raw_coefficient) % P
        if coefficient == 0:
            continue
        factors = []
        q_part = q_monomial_string(exponent, fixed_q)
        if q_part != "1":
            factors.append(q_part)
        if b_name is not None:
            factors.append(b_name)
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")


def write_system(path: Path, variables: list[str], polynomials: list[str]) -> None:
    path.write_text(
        ",".join(variables) + f"\n{P}\n" + ",\n".join(polynomials) + "\n"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=int, default=48)
    parser.add_argument("--q-chart", type=int, choices=range(37), default=0)
    parser.add_argument("--b1-chart", type=int, choices=range(6), default=0)
    args = parser.parse_args()
    with np.load(HERE / "linear_syzygies.npz") as frozen:
        all_syzygies = frozen["syzygies"].astype(np.uint8)
        assert int(frozen["prime"]) == P
    if not 43 <= args.rows <= len(all_syzygies):
        raise SystemExit(f"--rows must lie in [43,{len(all_syzygies)}]")
    nonzeros = np.count_nonzero(all_syzygies, axis=(1, 2))
    chosen = np.argsort(nonzeros, kind="stable")[: args.rows].astype(np.int32)
    syzygies = all_syzygies[chosen]

    with np.load(FM / "relation_matrix.npz") as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        assert int(frozen["prime"]) == P
    q2 = weak_compositions(2, 37)
    q3 = weak_compositions(3, 37)
    q4 = weak_compositions(4, 37)
    map_3_to_4 = multiplication_map(q3, q4)
    map_2_to_3 = multiplication_map(q2, q3)
    b0_block = seeds[:, int(offsets[0]) : int(offsets[1])]
    b1_blocks = [
        seeds[:, int(offsets[1 + j]) : int(offsets[2 + j])] for j in range(6)
    ]
    assert b0_block.shape == (690, 9139)
    assert all(block.shape == (690, 703) for block in b1_blocks)

    p4 = np.empty((args.rows, len(q4)), dtype=np.uint8)
    p3 = np.empty((args.rows, 6, len(q3)), dtype=np.uint8)
    for row, syzygy in enumerate(syzygies):
        p4[row] = contract(syzygy, b0_block, map_3_to_4, len(q4))
        for j, block in enumerate(b1_blocks):
            p3[row, j] = contract(syzygy, block, map_2_to_3, len(q3))
        if (row + 1) % 8 == 0:
            print(f"contracted {row + 1}/{args.rows}", flush=True)
    assert np.all(np.any(p4, axis=1))
    assert np.all(np.any(p3, axis=2))

    q_variables = [f"q{i}" for i in range(37) if i != args.q_chart]
    b0_variables = [f"b1_{j}" for j in range(6)]
    b0_polynomials: list[str] = []
    for row in range(args.rows):
        terms: list[str] = []
        append_terms(terms, p4[row], q4, args.q_chart, None)
        for j in range(6):
            append_terms(terms, p3[row, j], q3, args.q_chart, f"b1_{j}")
        b0_polynomials.append("+".join(terms) if terms else "0")

    boundary_variables = [
        f"b1_{j}" for j in range(6) if j != args.b1_chart
    ]
    boundary_polynomials: list[str] = []
    for row in range(args.rows):
        terms = []
        for j in range(6):
            append_terms(
                terms,
                p3[row, j],
                q3,
                args.q_chart,
                None if j == args.b1_chart else f"b1_{j}",
            )
        boundary_polynomials.append("+".join(terms) if terms else "0")

    stem = f"syzygy_r{args.rows}_q{args.q_chart}"
    b0_path = HERE / f"{stem}_b0_1.ms"
    boundary_path = HERE / f"{stem}_b0_0_b1_{args.b1_chart}_1.ms"
    # Put the eliminated/kernel variables first, matching the border-adapted runs.
    write_system(b0_path, b0_variables + q_variables, b0_polynomials)
    write_system(boundary_path, boundary_variables + q_variables, boundary_polynomials)

    contracted_path = HERE / f"{stem}_contracted.npz"
    np.savez_compressed(
        contracted_path,
        p4=p4,
        p3=p3,
        chosen_syzygies=chosen,
        nonzero_counts=nonzeros[chosen],
        q_chart=np.int32(args.q_chart),
        b1_chart=np.int32(args.b1_chart),
        prime=np.int32(P),
    )
    metadata = {
        "prime": P,
        "rows": args.rows,
        "q_chart": args.q_chart,
        "b1_chart": args.b1_chart,
        "chosen_syzygies": chosen.tolist(),
        "chosen_nonzero_counts": nonzeros[chosen].astype(int).tolist(),
        "source": {
            "linear_syzygies_sha256": sha256(HERE / "linear_syzygies.npz"),
            "relation_matrix_sha256": sha256(FM / "relation_matrix.npz"),
        },
        "contracted": contracted_path.name,
        "contracted_sha256": sha256(contracted_path),
        "systems": [
            {
                "stratum": "b0=1",
                "path": b0_path.name,
                "variables": len(b0_variables) + len(q_variables),
                "sha256": sha256(b0_path),
                "bytes": b0_path.stat().st_size,
            },
            {
                "stratum": f"b0=0,b1_{args.b1_chart}=1",
                "path": boundary_path.name,
                "variables": len(boundary_variables) + len(q_variables),
                "sha256": sha256(boundary_path),
                "bytes": boundary_path.stat().st_size,
            },
        ],
        "scope": (
            "These are necessary equations on two affine charts of the lower "
            "presentation kernel incidence. Empty exact charts are conclusive; "
            "nonempty or incomplete charts are inconclusive until checked against "
            "all 690 original equations."
        ),
    }
    metadata_path = HERE / f"{stem}.json"
    metadata_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
