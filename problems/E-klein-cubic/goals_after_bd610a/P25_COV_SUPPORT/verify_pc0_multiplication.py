#!/usr/bin/env python3
"""Independent PC.0 replay; does not import the producer.

The verifier reconstructs the sealed cubic spaces, formal transition matrices,
the producer-selected multiplication restriction, and every full-map kernel
identity.  Its rank backend uses balanced double rather than the producer's
balanced float specialization.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import shlex
import struct
import subprocess

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FM = ROOT / "certificates" / "degree25_finite_module"
RELATION = FM / "relation_matrix.npz"
MULTIPLICATION = FM / "multiplication_matrices.npz"
CERTIFICATE = HERE / "pc0_rank_certificate.json"
SELECTION = HERE / "pc0_selected_degree4_rows.npz"
KERNEL = HERE / "pc0_multiplication_kernel.npz"
P = 89
NQ, NSEED, NW, NV = 37, 690, 56, 746
NK, NQUAD = 6, 21
DIM3, DIM4 = 9139, 91390
DOMAIN = NQ * NV


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 24):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, slots: int) -> list[tuple[int, ...]]:
    output: list[tuple[int, ...]] = []

    def rec(prefix: tuple[int, ...], remaining: int, left: int) -> None:
        if left == 1:
            output.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            rec(prefix + (exponent,), remaining - exponent, left - 1)

    rec((), total, slots)
    return output


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
    subprocess.run(
        [
            "clang++",
            "-O3",
            "-std=c++17",
            str(HERE / "verify_rank_u8_double.cpp"),
            "-o",
            str(binary),
            *flags,
            "-framework",
            "Accelerate",
        ],
        check=True,
    )


def write_matrix(path: Path, matrix: np.ndarray) -> None:
    matrix = np.ascontiguousarray(matrix, dtype=np.uint8)
    with path.open("wb") as handle:
        handle.write(struct.pack("<QQQ", matrix.shape[0], matrix.shape[1], P))
        handle.write(matrix.tobytes())


def rank_file(binary: Path, path: Path) -> int:
    completed = subprocess.run(
        [str(binary), str(path)], check=True, text=True, capture_output=True
    )
    fields = {}
    for line in completed.stdout.splitlines():
        if "=" in line:
            key, value = line.split("=", 1)
            fields[key.strip()] = int(value.strip())
    return fields["rank"]


def exact_rank(binary: Path, scratch: Path, name: str, matrix: np.ndarray) -> int:
    path = scratch / f"verify_{name}.bin"
    write_matrix(path, matrix)
    rank = rank_file(binary, path)
    print(f"  verify {name}: shape={matrix.shape} rank={rank}", flush=True)
    return rank


def build_selected_matrix(
    path: Path,
    cubics: np.ndarray,
    selected: np.ndarray,
    monomials3: list[tuple[int, ...]],
    monomials4: list[tuple[int, ...]],
) -> str:
    index3 = {monomial: index for index, monomial in enumerate(monomials3)}
    with path.open("wb") as handle:
        handle.write(struct.pack("<QQQ", len(selected), DOMAIN, P))
        handle.truncate(24 + len(selected) * DOMAIN)
    matrix = np.memmap(
        path, mode="r+", dtype=np.uint8, offset=24, shape=(len(selected), DOMAIN)
    )
    matrix[:] = 0
    for row, index4 in enumerate(selected):
        exponent = monomials4[int(index4)]
        for variable, power in enumerate(exponent):
            if power:
                predecessor = list(exponent)
                predecessor[variable] -= 1
                cubic_index = index3[tuple(predecessor)]
                matrix[row, variable * NV : (variable + 1) * NV] = cubics[:, cubic_index]
        if (row + 1) % 5000 == 0 or row + 1 == len(selected):
            matrix.flush()
            print(f"  verify selected rows {row + 1}/{len(selected)}", flush=True)
    matrix.flush()
    del matrix
    return sha256_file(path)


def full_kernel_residual(
    cubics: np.ndarray,
    kernel: np.ndarray,
    monomials3: list[tuple[int, ...]],
    monomials4: list[tuple[int, ...]],
) -> np.ndarray:
    index4 = {monomial: index for index, monomial in enumerate(monomials4)}
    maps = np.empty((NQ, DIM3), dtype=np.int32)
    for variable in range(NQ):
        for index, exponent in enumerate(monomials3):
            product = list(exponent)
            product[variable] += 1
            maps[variable, index] = index4[tuple(product)]
    residual = np.zeros((DIM4, kernel.shape[1]), dtype=np.int64)
    cubic_float = cubics.T.astype(np.float64)
    for variable in range(NQ):
        block = kernel[variable * NV : (variable + 1) * NV].astype(np.float64)
        coefficients = np.rint(cubic_float @ block).astype(np.int64) % P
        residual[maps[variable]] = (residual[maps[variable]] + coefficients) % P
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


def in_span_count(rows: np.ndarray, basis: np.ndarray) -> int:
    echelon, pivots = rref_basis(basis)
    result = 0
    for source in rows:
        vector = source.astype(np.int64).copy()
        for index, pivot in enumerate(pivots):
            coefficient = int(vector[pivot]) % P
            if coefficient:
                vector = (vector - coefficient * echelon[index].astype(np.int64)) % P
        result += int(not np.any(vector))
    return result


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    assert certificate["status"] == "PC0-INDEPENDENT-RANK-REPLICATION-PASS"
    assert certificate["prime"] == P
    assert sha256_file(RELATION) == certificate["inputs"][str(RELATION.relative_to(ROOT))]
    assert sha256_file(MULTIPLICATION) == certificate["inputs"][
        str(MULTIPLICATION.relative_to(ROOT))
    ]
    assert sha256_file(SELECTION) == certificate["multiplication_map"][
        "selection_file_sha256"
    ]
    assert sha256_file(KERNEL) == certificate["multiplication_map"][
        "kernel_basis_file_sha256"
    ]

    scratch = Path("/tmp/p25_cov_pc0_verify")
    scratch.mkdir(parents=True, exist_ok=True)
    binary = scratch / "verify_rank_u8_double"
    compile_ranker(binary)

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        assert int(frozen["prime"]) == P
    with np.load(MULTIPLICATION, allow_pickle=False) as frozen:
        tquad = frozen["T_quad_F3"].astype(np.uint8)
        assert int(frozen["prime"]) == P
    v0 = np.ascontiguousarray(seeds[:, offsets[0] : offsets[1]])
    tq0 = np.ascontiguousarray(
        tquad[:, :, offsets[0] : offsets[1]].reshape(NK * NQUAD, DIM3)
    )
    w = np.unique(tq0, axis=0)
    cubics = np.ascontiguousarray(np.vstack([v0, w]), dtype=np.uint8)
    ranks = {
        "V0": exact_rank(binary, scratch, "V0", v0),
        "W": exact_rank(binary, scratch, "W", w),
        "V0_plus_W": exact_rank(binary, scratch, "V0_plus_W", cubics),
    }
    assert ranks == {"V0": 690, "W": 56, "V0_plus_W": 746}
    assert sha256_array(cubics) == certificate["cubic_ledger"]["V0_plus_W_sha256"]

    w_lookup = {bytes(key): index for index, key in enumerate(row_keys(w))}
    tq_w = np.zeros((NK * NQUAD, NW), dtype=np.uint8)
    for row, key in enumerate(row_keys(tq0)):
        tq_w[row, w_lookup[bytes(key)]] = 1
    tq_w = tq_w.reshape(NK, NQUAD, NW)
    m2 = np.stack(
        [seeds[:, offsets[7 + b] : offsets[8 + b]] for b in range(NQUAD)], axis=1
    ).astype(np.uint8)
    transition_blocks = []
    for operator in range(NK):
        block = m2.transpose(0, 2, 1).astype(np.int64) @ tq_w[operator].astype(np.int64) % P
        transition_blocks.append(
            np.ascontiguousarray(block.reshape(NSEED, NQ * NW), dtype=np.uint8)
        )
    transitions = np.ascontiguousarray(np.vstack(transition_blocks), dtype=np.uint8)

    tquad_quadratic = np.empty((NK, NQUAD, NQUAD, NQ), dtype=np.uint8)
    for operator in range(NK):
        for source in range(NQUAD):
            for target in range(NQUAD):
                tquad_quadratic[operator, source, target] = tquad[
                    operator, source, offsets[7 + target] : offsets[8 + target]
                ]
    commutators = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source in range(NQUAD):
                first = tquad_quadratic[right, source].T.astype(np.int64) @ tq_w[left]
                second = tquad_quadratic[left, source].T.astype(np.int64) @ tq_w[right]
                commutators.append(np.ascontiguousarray((first - second) % P).reshape(-1))
    commutators = np.ascontiguousarray(np.vstack(commutators), dtype=np.uint8)
    formal_ranks = {
        "transitions": exact_rank(binary, scratch, "transitions", transitions),
        "commutators": exact_rank(binary, scratch, "commutators", commutators),
        "combined": exact_rank(
            binary, scratch, "combined", np.vstack([transitions, commutators])
        ),
    }
    assert formal_ranks == {"transitions": 2072, "commutators": 210, "combined": 2072}
    assert sha256_array(transitions) == certificate["transition_subspaces"][
        "transition_matrix_sha256"
    ]
    assert sha256_array(commutators) == certificate["transition_subspaces"][
        "commutator_matrix_sha256"
    ]

    with np.load(KERNEL, allow_pickle=False) as frozen:
        kernel = frozen["kernel"].astype(np.uint8)
        assert int(frozen["prime"]) == P
    assert kernel.shape == (DOMAIN, 19)
    assert sha256_array(kernel) == certificate["multiplication_map"]["kernel_basis_sha256"]
    kernel_rank = exact_rank(binary, scratch, "kernel_transpose", kernel.T)
    assert kernel_rank == 19

    monomials3 = weak_compositions(3, NQ)
    monomials4 = weak_compositions(4, NQ)
    residual = full_kernel_residual(cubics, kernel, monomials3, monomials4)
    assert not np.any(residual)
    del residual

    blocks = kernel.reshape(NQ, NV, 19)
    kernel_v0 = np.ascontiguousarray(blocks[:, :NSEED].reshape(-1, 19))
    kernel_w = np.ascontiguousarray(blocks[:, NSEED:].reshape(-1, 19))
    projection_ranks = {
        "V0": exact_rank(binary, scratch, "kernel_V0", kernel_v0),
        "W": exact_rank(binary, scratch, "kernel_W", kernel_w),
    }
    assert projection_ranks == {"V0": 19, "W": 19}
    kernel_w_rows = kernel_w.T
    quotient_ranks = {
        "transitions_plus_kernel": exact_rank(
            binary, scratch, "transitions_plus_kernel", np.vstack([kernel_w_rows, transitions])
        ),
        "commutators_plus_kernel": exact_rank(
            binary, scratch, "commutators_plus_kernel", np.vstack([kernel_w_rows, commutators])
        ),
    }
    assert quotient_ranks == {"transitions_plus_kernel": 2072, "commutators_plus_kernel": 229}
    individual = {
        "transitions_in_S1V0": in_span_count(transitions, kernel_w_rows),
        "commutators_in_S1V0": in_span_count(commutators, kernel_w_rows),
    }
    assert individual == {"transitions_in_S1V0": 0, "commutators_in_S1V0": 0}

    with np.load(SELECTION, allow_pickle=False) as frozen:
        selected = frozen["degree4_rows"].astype(np.int32)
        assert int(frozen["prime"]) == P
        assert int(frozen["domain_dimension"]) == DOMAIN
    selected_path = scratch / "verify_selected_multiplication.bin"
    selected_sha = build_selected_matrix(
        selected_path, cubics, selected, monomials3, monomials4
    )
    assert selected_sha == certificate["multiplication_map"]["selected_matrix_sha256"]
    selected_rank = rank_file(binary, selected_path)
    print(f"  verify selected multiplication rank={selected_rank}", flush=True)
    assert selected_rank == 27583

    result = {
        "status": "PASS_INDEPENDENT_PC0_REPLAY",
        "prime": P,
        "cubic_ranks": ranks,
        "selected_multiplication_rank": selected_rank,
        "full_kernel_rank": kernel_rank,
        "full_kernel_identity_nonzero_coefficients": 0,
        "full_multiplication_rank": DOMAIN - kernel_rank,
        "kernel_dimension": kernel_rank,
        "kernel_projection_ranks": projection_ranks,
        "quotient_image_dimension": NQ * NW - projection_ranks["W"],
        "formal_ranks": formal_ranks,
        "quotient_augmented_ranks": quotient_ranks,
        "individual_membership": individual,
        "backend": "independent balanced-double FFLAS rank plus all-row kernel substitution",
        "ok": True,
    }
    (HERE / "verify_pc0_result.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print("PASS_INDEPENDENT_PC0_REPLAY", flush=True)


if __name__ == "__main__":
    main()
