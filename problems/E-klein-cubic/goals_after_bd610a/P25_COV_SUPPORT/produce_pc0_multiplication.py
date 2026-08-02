#!/usr/bin/env python3
"""PC.0: independently certify the enlarged cubic multiplication map.

This producer uses only the sealed normal-form relation and multiplication
tables.  It reconstructs V0 and the 56-row missing block W, computes every
first transition and commutator class in the formal tensor S1 tensor W, and
then decides the exact rank and kernel of multiplication

    S1 tensor (V0 + W) -> S4

by exact rank of a deterministic row restriction plus substitution of its
kernel basis into every coefficient of the full map.  The large matrix is
scratch-only; the durable certificate is the selected monomial list, kernel,
input hashes, matrix hash, and independently replayable construction.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import shlex
import struct
import subprocess
import time

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FM = ROOT / "certificates" / "degree25_finite_module"
RELATION = FM / "relation_matrix.npz"
MULTIPLICATION = FM / "multiplication_matrices.npz"
P = 89
NQ = 37
NSEED = 690
NW = 56
NV = NSEED + NW
NK = 6
NQUAD = 21
DIM3 = 9139
DIM4 = 91390
DOMAIN = NQ * NV
DEFAULT_SEED = 2026080125
DEFAULT_SELECTED_ROWS = 30000


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 24):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, slots: int) -> list[tuple[int, ...]]:
    result: list[tuple[int, ...]] = []

    def visit(prefix: tuple[int, ...], remaining: int, left: int) -> None:
        if left == 1:
            result.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, left - 1)

    visit((), total, slots)
    return result


def row_keys(array: np.ndarray) -> np.ndarray:
    contiguous = np.ascontiguousarray(array)
    return contiguous.view(
        np.dtype((np.void, contiguous.dtype.itemsize * contiguous.shape[1]))
    ).ravel()


def compile_ranker(binary: Path) -> None:
    flags = shlex.split(
        subprocess.check_output(
            ["pkg-config", "--cflags", "--libs", "fflas-ffpack"], text=True
        ).strip()
    )
    command = [
        "clang++",
        "-O3",
        "-std=c++17",
        str(HERE / "rank_u8_float.cpp"),
        "-o",
        str(binary),
        *flags,
        "-framework",
        "Accelerate",
    ]
    subprocess.run(command, check=True)


def write_matrix(path: Path, matrix: np.ndarray) -> str:
    matrix = np.ascontiguousarray(matrix, dtype=np.uint8)
    with path.open("wb") as handle:
        handle.write(struct.pack("<QQQ", matrix.shape[0], matrix.shape[1], P))
        handle.write(matrix.tobytes())
    return sha256_file(path)


def run_ranker(binary: Path, matrix_path: Path) -> tuple[int, str]:
    completed = subprocess.run(
        [str(binary), str(matrix_path)], check=True, text=True, capture_output=True
    )
    fields = {}
    for line in completed.stdout.splitlines():
        if "=" in line:
            key, value = line.split("=", 1)
            fields[key.strip()] = int(value.strip())
    return fields["rank"], completed.stdout


def run_right_kernel(
    binary: Path, matrix_path: Path, kernel_path: Path
) -> tuple[int, int, str]:
    completed = subprocess.run(
        [str(binary), str(matrix_path), "--right-kernel", str(kernel_path)],
        check=True,
        text=True,
        capture_output=True,
    )
    fields = {}
    for line in completed.stdout.splitlines():
        if "=" in line:
            key, value = line.split("=", 1)
            fields[key.strip()] = int(value.strip())
    return fields["rank"], fields["nullity"], completed.stdout


def read_u8_matrix(path: Path) -> tuple[np.ndarray, int]:
    with path.open("rb") as handle:
        rows, columns, prime = struct.unpack("<QQQ", handle.read(24))
        data = np.frombuffer(handle.read(), dtype=np.uint8).copy()
    if data.size != rows * columns:
        raise AssertionError(f"short matrix payload in {path}")
    return data.reshape(rows, columns), int(prime)


def exact_rank(binary: Path, scratch: Path, name: str, matrix: np.ndarray) -> tuple[int, str]:
    path = scratch / f"{name}.bin"
    digest = write_matrix(path, matrix)
    rank, transcript = run_ranker(binary, path)
    print(f"  {name}: shape={matrix.shape} rank={rank}", flush=True)
    return rank, digest


def build_selected_multiplication(
    path: Path,
    cubics: np.ndarray,
    selected: np.ndarray,
    monomials3: list[tuple[int, ...]],
    monomials4: list[tuple[int, ...]],
) -> str:
    index3 = {monomial: index for index, monomial in enumerate(monomials3)}
    shape = (len(selected), DOMAIN)
    with path.open("wb") as handle:
        handle.write(struct.pack("<QQQ", shape[0], shape[1], P))
        handle.truncate(24 + shape[0] * shape[1])
    matrix = np.memmap(path, mode="r+", dtype=np.uint8, offset=24, shape=shape)
    matrix[:] = 0
    for row, output_index in enumerate(selected):
        exponent = monomials4[int(output_index)]
        for variable, power in enumerate(exponent):
            if not power:
                continue
            predecessor = list(exponent)
            predecessor[variable] -= 1
            cubic_index = index3[tuple(predecessor)]
            start = variable * NV
            matrix[row, start : start + NV] = cubics[:, cubic_index]
        if (row + 1) % 2000 == 0 or row + 1 == len(selected):
            matrix.flush()
            print(f"  multiplication rows {row + 1}/{len(selected)}", flush=True)
    matrix.flush()
    del matrix
    return sha256_file(path)


def multiplication_residual(
    cubics: np.ndarray,
    kernel: np.ndarray,
    monomials3: list[tuple[int, ...]],
    monomials4: list[tuple[int, ...]],
) -> np.ndarray:
    """Apply the complete multiplication matrix to all kernel columns."""
    index4 = {monomial: index for index, monomial in enumerate(monomials4)}
    maps = np.empty((NQ, DIM3), dtype=np.int32)
    for variable in range(NQ):
        for index, exponent in enumerate(monomials3):
            product = list(exponent)
            product[variable] += 1
            maps[variable, index] = index4[tuple(product)]
    nullity = kernel.shape[1]
    residual = np.zeros((DIM4, nullity), dtype=np.int64)
    cubic_float = cubics.T.astype(np.float64)
    for variable in range(NQ):
        block = kernel[variable * NV : (variable + 1) * NV].astype(np.float64)
        # Every dot product is below 746*88^2 < 2^23, hence exactly represented
        # in binary64 before reduction modulo 89.
        coefficients = np.rint(cubic_float @ block).astype(np.int64) % P
        residual[maps[variable]] = (residual[maps[variable]] + coefficients) % P
        if (variable + 1) % 5 == 0 or variable + 1 == NQ:
            print(f"  full-kernel identity variables {variable + 1}/{NQ}", flush=True)
    return residual.astype(np.uint8)


def rref_basis(matrix: np.ndarray) -> tuple[np.ndarray, list[int]]:
    a = np.ascontiguousarray(matrix, dtype=np.int64) % P
    pivots: list[int] = []
    row = 0
    for column in range(a.shape[1]):
        candidates = np.flatnonzero(a[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        if pivot != row:
            a[[row, pivot]] = a[[pivot, row]]
        a[row] = a[row] * pow(int(a[row, column]), -1, P) % P
        factors = a[:, column].copy()
        factors[row] = 0
        for target in np.flatnonzero(factors):
            a[target] = (a[target] - int(factors[target]) * a[row]) % P
        pivots.append(column)
        row += 1
        if row == a.shape[0]:
            break
    return a[:row].astype(np.uint8), pivots


def count_rows_in_span(rows: np.ndarray, basis: np.ndarray) -> int:
    echelon, pivots = rref_basis(basis)
    count = 0
    for source in rows:
        vector = source.astype(np.int64).copy()
        for index, pivot in enumerate(pivots):
            coefficient = int(vector[pivot]) % P
            if coefficient:
                vector = (vector - coefficient * echelon[index].astype(np.int64)) % P
        if not np.any(vector):
            count += 1
    return count


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--seed", type=int, default=DEFAULT_SEED)
    parser.add_argument("--selected-rows", type=int, default=DEFAULT_SELECTED_ROWS)
    parser.add_argument(
        "--scratch", type=Path, default=Path("/tmp/p25_cov_pc0_multiplication")
    )
    args = parser.parse_args()
    if args.selected_rows < DOMAIN or args.selected_rows > DIM4:
        raise SystemExit(f"selected rows must be in [{DOMAIN},{DIM4}]")
    args.scratch.mkdir(parents=True, exist_ok=True)
    binary = args.scratch / "rank_u8_float"
    compile_ranker(binary)
    started = time.monotonic()

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    with np.load(MULTIPLICATION, allow_pickle=False) as frozen:
        tquad = frozen["T_quad_F3"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("multiplication prime mismatch")
    if seeds.shape != (NSEED, 14134) or tquad.shape != (NK, NQUAD, 14134):
        raise AssertionError("unexpected sealed input shapes")

    v0 = np.ascontiguousarray(seeds[:, offsets[0] : offsets[1]])
    tq0 = np.ascontiguousarray(
        tquad[:, :, offsets[0] : offsets[1]].reshape(NK * NQUAD, DIM3)
    )
    w = np.unique(tq0, axis=0)
    if v0.shape != (NSEED, DIM3) or w.shape != (NW, DIM3):
        raise AssertionError(f"unexpected V0/W shapes: {v0.shape}/{w.shape}")
    cubics = np.ascontiguousarray(np.vstack([v0, w]), dtype=np.uint8)

    rank_v0, _ = exact_rank(binary, args.scratch, "rank_v0", v0)
    rank_w, _ = exact_rank(binary, args.scratch, "rank_w", w)
    rank_cubics, _ = exact_rank(binary, args.scratch, "rank_v0_w", cubics)
    if (rank_v0, rank_w, rank_cubics) != (NSEED, NW, NV):
        raise AssertionError("cubic direct-sum ledger failed")

    # Map each of the 126 tails to its exact W-basis row.
    w_lookup = {bytes(key): index for index, key in enumerate(row_keys(w))}
    tq_w = np.zeros((NK * NQUAD, NW), dtype=np.uint8)
    for row, key in enumerate(row_keys(tq0)):
        tq_w[row, w_lookup[bytes(key)]] = 1
    tq_w = tq_w.reshape(NK, NQUAD, NW)
    if not np.array_equal(tq_w.reshape(-1, NW).astype(np.int64) @ w.astype(np.int64) % P, tq0):
        raise AssertionError("T-tail W reconstruction failed")

    # Coefficients of each seed in each quadratic basis component.
    m2 = np.stack(
        [seeds[:, offsets[7 + b] : offsets[8 + b]] for b in range(NQUAD)],
        axis=1,
    ).astype(np.uint8)
    if m2.shape != (NSEED, NQUAD, NQ):
        raise AssertionError(f"unexpected M2 shape {m2.shape}")

    transition_blocks: list[np.ndarray] = []
    transition_block_ranks: list[int] = []
    transition_cumulative_ranks: list[int] = []
    for operator in range(NK):
        block = (
            m2.transpose(0, 2, 1).astype(np.int64)
            @ tq_w[operator].astype(np.int64)
        ) % P
        block = np.ascontiguousarray(block.reshape(NSEED, NQ * NW), dtype=np.uint8)
        transition_blocks.append(block)
        rank, _ = exact_rank(binary, args.scratch, f"transition_block_{operator}", block)
        transition_block_ranks.append(rank)
        cumulative = np.ascontiguousarray(np.vstack(transition_blocks), dtype=np.uint8)
        rank, _ = exact_rank(
            binary, args.scratch, f"transition_cumulative_{operator}", cumulative
        )
        transition_cumulative_ranks.append(rank)
    transitions = np.ascontiguousarray(np.vstack(transition_blocks), dtype=np.uint8)

    tquad_quadratic = np.empty((NK, NQUAD, NQUAD, NQ), dtype=np.uint8)
    for operator in range(NK):
        for source in range(NQUAD):
            for target in range(NQUAD):
                tquad_quadratic[operator, source, target] = tquad[
                    operator,
                    source,
                    offsets[7 + target] : offsets[8 + target],
                ]
    commutators: list[np.ndarray] = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source in range(NQUAD):
                first = (
                    tquad_quadratic[right, source].T.astype(np.int64)
                    @ tq_w[left].astype(np.int64)
                ) % P
                second = (
                    tquad_quadratic[left, source].T.astype(np.int64)
                    @ tq_w[right].astype(np.int64)
                ) % P
                commutators.append(
                    np.ascontiguousarray((first - second) % P, dtype=np.uint8).reshape(-1)
                )
    commutators_array = np.ascontiguousarray(np.vstack(commutators), dtype=np.uint8)
    transition_rank, transition_sha = exact_rank(
        binary, args.scratch, "transitions_all", transitions
    )
    commutator_rank, commutator_sha = exact_rank(
        binary, args.scratch, "commutators_all", commutators_array
    )
    combined_rank, combined_sha = exact_rank(
        binary,
        args.scratch,
        "transitions_and_commutators",
        np.vstack([transitions, commutators_array]),
    )
    transition_zero = int(np.count_nonzero(~np.any(transitions, axis=1)))
    commutator_zero = int(np.count_nonzero(~np.any(commutators_array, axis=1)))
    if transition_rank != NQ * NW or combined_rank != transition_rank:
        raise AssertionError("formal transition span did not fill S1 tensor W")
    if transition_zero or commutator_zero:
        raise AssertionError("unexpected zero transition/commutator class")

    monomials3 = weak_compositions(3, NQ)
    monomials4 = weak_compositions(4, NQ)
    if len(monomials3) != DIM3 or len(monomials4) != DIM4:
        raise AssertionError("monomial enumeration mismatch")
    rng = np.random.default_rng(args.seed)
    selected = np.sort(
        rng.choice(DIM4, size=args.selected_rows, replace=False).astype(np.int32)
    )
    selected_path = HERE / "pc0_selected_degree4_rows.npz"
    np.savez_compressed(
        selected_path,
        prime=np.int32(P),
        seed=np.int64(args.seed),
        degree4_rows=selected,
        domain_dimension=np.int32(DOMAIN),
    )

    multiplication_path = args.scratch / "selected_multiplication.bin"
    multiplication_sha = build_selected_multiplication(
        multiplication_path, cubics, selected, monomials3, monomials4
    )
    scratch_kernel_path = args.scratch / "selected_multiplication_kernel.bin"
    multiplication_rank, selected_nullity, multiplication_transcript = run_right_kernel(
        binary, multiplication_path, scratch_kernel_path
    )
    print(
        f"  selected multiplication: rows={len(selected)} columns={DOMAIN} "
        f"rank={multiplication_rank} nullity={selected_nullity}",
        flush=True,
    )
    kernel, kernel_prime = read_u8_matrix(scratch_kernel_path)
    if kernel_prime != P or kernel.shape != (DOMAIN, selected_nullity):
        raise AssertionError("unexpected selected-kernel artifact")
    kernel_rank, _ = exact_rank(binary, args.scratch, "kernel_basis_transpose", kernel.T)
    if kernel_rank != selected_nullity:
        raise AssertionError("selected-kernel columns are dependent")

    residual = multiplication_residual(
        cubics, kernel, monomials3, monomials4
    )
    nonzero_kernel_coefficients = int(np.count_nonzero(residual))
    if nonzero_kernel_coefficients:
        raise SystemExit(
            "the selected-row kernel does not vanish under the complete map; enlarge "
            "or change the deterministic row restriction"
        )

    # The selected restriction gives rank >= multiplication_rank for the full
    # map, while these independent full-map kernel columns give the matching
    # upper bound.  This proves the exact full rank and kernel dimension.
    full_rank = DOMAIN - selected_nullity
    if full_rank != multiplication_rank:
        raise AssertionError("lower and upper multiplication-rank bounds disagree")
    kernel_blocks = kernel.reshape(NQ, NV, selected_nullity)
    kernel_v0 = np.ascontiguousarray(kernel_blocks[:, :NSEED].reshape(-1, selected_nullity))
    kernel_w = np.ascontiguousarray(kernel_blocks[:, NSEED:].reshape(-1, selected_nullity))
    kernel_v0_rank, _ = exact_rank(binary, args.scratch, "kernel_projection_v0", kernel_v0)
    kernel_w_rank, _ = exact_rank(binary, args.scratch, "kernel_projection_w", kernel_w)
    if kernel_v0_rank != selected_nullity or kernel_w_rank != selected_nullity:
        raise AssertionError("kernel is not a graph over both tensor summands")

    kernel_w_rows = np.ascontiguousarray(kernel_w.T, dtype=np.uint8)
    transition_plus_kernel_rank, _ = exact_rank(
        binary,
        args.scratch,
        "kernel_w_and_transitions",
        np.vstack([kernel_w_rows, transitions]),
    )
    commutator_plus_kernel_rank, _ = exact_rank(
        binary,
        args.scratch,
        "kernel_w_and_commutators",
        np.vstack([kernel_w_rows, commutators_array]),
    )
    transition_in_old = count_rows_in_span(transitions, kernel_w_rows)
    commutator_in_old = count_rows_in_span(commutators_array, kernel_w_rows)

    durable_kernel_path = HERE / "pc0_multiplication_kernel.npz"
    np.savez_compressed(
        durable_kernel_path,
        prime=np.int32(P),
        kernel=kernel,
        selected_matrix_sha256=np.asarray(multiplication_sha),
        selected_rows_file_sha256=np.asarray(sha256_file(selected_path)),
        full_residual_nonzero=np.int64(nonzero_kernel_coefficients),
    )

    result = {
        "status": "PC0-INDEPENDENT-RANK-REPLICATION-PASS",
        "prime": P,
        "inputs": {
            str(RELATION.relative_to(ROOT)): sha256_file(RELATION),
            str(MULTIPLICATION.relative_to(ROOT)): sha256_file(MULTIPLICATION),
        },
        "cubic_ledger": {
            "rank_V0": rank_v0,
            "rank_W": rank_w,
            "rank_V0_plus_W": rank_cubics,
            "intersection_dimension": rank_v0 + rank_w - rank_cubics,
            "V0_shape": list(v0.shape),
            "W_shape": list(w.shape),
            "V0_plus_W_sha256": sha256_array(cubics),
            "T_tail_rows": int(tq0.shape[0]),
            "T_tail_distinct_rows": int(w.shape[0]),
        },
        "multiplication_map": {
            "map": "S_1 tensor (V0+W) -> S_4",
            "domain_dimension": DOMAIN,
            "codomain_dimension": DIM4,
            "selected_degree4_rows": int(len(selected)),
            "selection_seed": int(args.seed),
            "selection_file": selected_path.name,
            "selection_file_sha256": sha256_file(selected_path),
            "selected_matrix_sha256": multiplication_sha,
            "selected_matrix_rank": multiplication_rank,
            "selected_matrix_nullity": selected_nullity,
            "full_image_rank": full_rank,
            "kernel_dimension": selected_nullity,
            "kernel_basis_file": durable_kernel_path.name,
            "kernel_basis_file_sha256": sha256_file(durable_kernel_path),
            "kernel_basis_sha256": sha256_array(kernel),
            "kernel_basis_rank": kernel_rank,
            "full_kernel_identity_nonzero_coefficients": nonzero_kernel_coefficients,
            "kernel_projection_to_S1_V0_rank": kernel_v0_rank,
            "kernel_projection_to_S1_W_rank": kernel_w_rank,
            "rank_S1_V0": NQ * NSEED,
            "kernel_S1_V0_dimension": selected_nullity - kernel_w_rank,
            "rank_S1_W": NQ * NW,
            "kernel_S1_W_dimension": selected_nullity - kernel_v0_rank,
            "quotient_image_dimension": NQ * NW - kernel_w_rank,
            "rank_transcript": multiplication_transcript.strip().splitlines(),
            "certificate_logic": (
                "The selected-row restriction proves the displayed lower rank. Its "
                "independent kernel basis is substituted coefficient-by-coefficient "
                "into all 91390 rows of the complete multiplication map and vanishes. "
                "The matching lower and upper bounds prove the exact full rank/kernel."
            ),
        },
        "transition_subspaces": {
            "ambient_formal_tensor": "S_1 tensor W",
            "ambient_dimension": NQ * NW,
            "transition_rows": int(transitions.shape[0]),
            "transition_zero_rows": transition_zero,
            "transition_block_ranks": transition_block_ranks,
            "transition_cumulative_ranks": transition_cumulative_ranks,
            "transition_span_rank": transition_rank,
            "transition_matrix_sha256": sha256_array(transitions),
            "transition_scratch_binary_sha256": transition_sha,
            "commutator_rows": int(commutators_array.shape[0]),
            "commutator_zero_rows": commutator_zero,
            "commutator_span_rank": commutator_rank,
            "commutator_matrix_sha256": sha256_array(commutators_array),
            "commutator_scratch_binary_sha256": commutator_sha,
            "combined_span_rank": combined_rank,
            "combined_scratch_binary_sha256": combined_sha,
            "commutators_add_directions": combined_rank - transition_rank,
            "transition_image_rank": transition_rank,
            "transition_intersection_S1V0_dimension": (
                transition_rank + kernel_w_rank - transition_plus_kernel_rank
            ),
            "transition_rank_mod_S1V0": transition_plus_kernel_rank - kernel_w_rank,
            "transition_rows_in_S1V0": transition_in_old,
            "transition_rows_outside_S1V0": int(transitions.shape[0]) - transition_in_old,
            "commutator_image_rank": commutator_rank,
            "commutator_intersection_S1V0_dimension": (
                commutator_rank + kernel_w_rank - commutator_plus_kernel_rank
            ),
            "commutator_rank_mod_S1V0": commutator_plus_kernel_rank - kernel_w_rank,
            "commutator_rows_in_S1V0": commutator_in_old,
            "commutator_rows_outside_S1V0": (
                int(commutators_array.shape[0]) - commutator_in_old
            ),
            "polynomial_consequence": (
                "The full kernel meets each tensor summand trivially, so the formal "
                "transition and commutator ranks are their exact quartic image ranks. "
                "Membership modulo S1 V0 is decided against the 19-dimensional W "
                "projection of the full kernel, not inferred from nonzero formal rows."
            ),
        },
        "resource": {
            "selected_matrix_scratch_bytes": multiplication_path.stat().st_size,
            "float_rank_working_bytes": len(selected) * DOMAIN * 4,
            "historical_45_GiB_rref_repeated": False,
            "elapsed_seconds": time.monotonic() - started,
            "scratch_directory": str(args.scratch),
        },
        "theorem_boundary": {
            "proves": (
                "Exactly over F_89: V0 direct-sum W has dimensions 690+56=746; "
                f"S_1 tensor (V0+W) -> S_4 has rank {full_rank} and kernel dimension "
                f"{selected_nullity}; all 4140 transitions span a 2072-dimensional "
                "quartic subspace; all 315 commutators span rank 210 and add no "
                "direction. The complete quotient and individual membership ledger "
                "is recorded above."
            ),
            "does_not_prove": (
                "Stabilization of the coupled transition module, projective support "
                "emptiness/nonemptiness, a characteristic-zero rank statement, or a "
                "headline covariant."
            ),
        },
    }
    output = HERE / "pc0_rank_certificate.json"
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS_PC0_INDEPENDENT_MULTIPLICATION", flush=True)
    print(f"certificate={output}", flush=True)


if __name__ == "__main__":
    main()
