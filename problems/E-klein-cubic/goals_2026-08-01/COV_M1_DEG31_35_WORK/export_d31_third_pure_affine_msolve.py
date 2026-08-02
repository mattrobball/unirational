#!/usr/bin/env python3
"""Eliminate the scalar-chart equations before exporting residual d31 charts.

For chart j=2,...,5 we impose scalar_0=...=scalar_{j-1}=0 and
scalar_j=1, solve those affine equations exactly, and substitute into a fixed
rank-1198 basis of the complete landing cubics.  This leaves 33,32,31,30
variables instead of asking msolve to eliminate the chart equations itself.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import struct

import numpy as np

import probe_c3_constant_gate as c3
from probe_cubic_scalar_cubes import cubic_coefficients


HERE = Path(__file__).resolve().parent
PRIME = 463


def affine_solution(matrix: np.ndarray, target: np.ndarray):
    rows, columns = matrix.shape
    augmented = np.column_stack([matrix % PRIME, target % PRIME]).astype(np.int64)
    pivot_row = 0
    pivots = []
    for column in range(columns):
        candidates = np.flatnonzero(augmented[pivot_row:, column])
        if not len(candidates):
            continue
        source = pivot_row + int(candidates[0])
        augmented[[pivot_row, source]] = augmented[[source, pivot_row]]
        augmented[pivot_row] = (
            augmented[pivot_row]
            * pow(int(augmented[pivot_row, column]), -1, PRIME)
        ) % PRIME
        for row in range(rows):
            if row == pivot_row or not augmented[row, column]:
                continue
            augmented[row] = (
                augmented[row]
                - augmented[row, column] * augmented[pivot_row]
            ) % PRIME
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    assert pivot_row == rows
    particular = np.zeros(columns, dtype=np.int64)
    for row, column in enumerate(pivots):
        particular[column] = augmented[row, -1]
    kernel = c3.nullspace_mod(matrix % PRIME, PRIME).T
    assert np.array_equal(matrix @ particular % PRIME, target % PRIME)
    assert not np.any(matrix @ kernel % PRIME)
    return particular, kernel


def monomial_text(monomial: np.ndarray) -> str:
    variables = [int(index) - 1 for index in monomial if int(index)]
    if not variables:
        return "1"
    pieces = []
    for variable in sorted(set(variables)):
        exponent = variables.count(variable)
        pieces.append(
            f"y{variable}" + (f"^{exponent}" if exponent != 1 else "")
        )
    return "*".join(pieces)


def polynomial_text(coefficients: np.ndarray, monomials: list[str]) -> str:
    terms = []
    for coefficient, monomial in zip(coefficients, monomials):
        coefficient = int(coefficient) % PRIME
        if not coefficient:
            continue
        if monomial == "1":
            terms.append(str(coefficient))
        elif coefficient == 1:
            terms.append(monomial)
        else:
            terms.append(f"{coefficient}*{monomial}")
    return "+".join(terms) or "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--chart", type=int, required=True, choices=range(2, 6))
    parser.add_argument(
        "--cover", choices=("original", "vandermonde"), default="original"
    )
    parser.add_argument(
        "--mode", choices=("coefficients", "input"), default="coefficients"
    )
    args = parser.parse_args()
    cover_stem = "" if args.cover == "original" else "vandermonde_"
    stem = HERE / (
        f"degree_31/d31_third_pure_affine_{cover_stem}"
        f"chart{args.chart}_p463"
    )
    payload = stem.with_suffix(".npz")
    binary = stem.with_suffix(".bin")
    profile_path = Path(str(binary) + ".rows")

    if args.mode == "coefficients":
        source = HERE / "degree_31/d31_third_pure_scalar_cubes_p463.npz"
        old_profile = (
            HERE / "degree_31/d31_third_pure_scalar_cubes_p463.bin.rows"
        )
        with np.load(source, allow_pickle=False) as frozen:
            values = frozen["reduced_basis_values"].astype(np.int64)
            scalars = frozen["independent_scalar_forms"].astype(np.int64)
        with old_profile.open("rb") as stream:
            count = struct.unpack("<Q", stream.read(8))[0]
            rows = np.frombuffer(stream.read(), dtype="<u8")
        assert len(rows) == count == 1198
        values = values[rows]
        if args.cover == "original":
            constraints = scalars[:args.chart + 1] % PRIME
        else:
            mix = np.asarray([
                [pow(point, exponent, PRIME) for exponent in range(4)]
                for point in range(1, 5)
            ], dtype=np.int64)
            assert c3.rank_mod(mix, PRIME) == 4
            residual = mix @ scalars[2:] % PRIME
            constraints = np.concatenate([
                scalars[:2], residual[:args.chart - 1]
            ]) % PRIME
        target = np.zeros(len(constraints), dtype=np.int64)
        target[-1] = 1
        particular, kernel = affine_solution(constraints, target)
        constant = np.einsum("pjn,n->pj", values, particular) % PRIME
        linear = np.einsum("pjn,nk->pjk", values, kernel) % PRIME
        affine_values = np.concatenate([constant[:, :, None], linear], axis=2)
        monomials, coefficients = cubic_coefficients(
            affine_values, PRIME, chunk=24
        )
        np.savez_compressed(
            payload,
            chart=np.asarray(args.chart, dtype=np.int64),
            scalar_constraints=constraints.astype(np.uint16),
            affine_particular=particular.astype(np.uint16),
            affine_kernel=kernel.astype(np.uint16),
            selected_landing_rows=rows.astype(np.uint64),
            affine_basis_values=affine_values.astype(np.uint16),
            cubic_monomials=monomials.astype(np.uint16),
            cubic_coefficients=coefficients.astype(np.uint16),
        )
        with binary.open("wb") as stream:
            stream.write(struct.pack(
                "<QQQ", len(coefficients), coefficients.shape[1], PRIME
            ))
            stream.write(coefficients.tobytes(order="C"))
            stream.write(struct.pack("<Q", 0))
        print(
            f"wrote {payload.name}, {binary.name}: variables={kernel.shape[1]} "
            f"matrix={coefficients.shape}", flush=True,
        )
        return

    assert payload.exists() and profile_path.exists()
    with np.load(payload, allow_pickle=False) as frozen:
        kernel = frozen["affine_kernel"]
        monomials = frozen["cubic_monomials"].astype(np.int64)
        coefficients = frozen["cubic_coefficients"].astype(np.int64)
    with profile_path.open("rb") as stream:
        count = struct.unpack("<Q", stream.read(8))[0]
        rows = np.frombuffer(stream.read(), dtype="<u8")
    assert len(rows) == count
    texts = [monomial_text(monomial) for monomial in monomials]
    output = stem.with_suffix(".in")
    with output.open("w") as stream:
        stream.write(",".join(f"y{index}" for index in range(kernel.shape[1])) + "\n")
        stream.write(f"{PRIME}\n")
        for position, row in enumerate(rows):
            stream.write(polynomial_text(coefficients[int(row)], texts))
            stream.write("\n" if position + 1 == len(rows) else ",\n")
            if (position + 1) % 100 == 0:
                print(f"wrote {position + 1}/{len(rows)} rows", flush=True)
    print(
        f"wrote {output.name}: variables={kernel.shape[1]} equations={len(rows)} "
        f"bytes={output.stat().st_size}", flush=True,
    )


if __name__ == "__main__":
    main()
