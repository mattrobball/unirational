#!/usr/bin/env python3
"""Exact bounded PC.2 certificate on all three-coordinate q-planes.

Let C(q) run through selected rows of the complete degree-one left-syzygy
space C(q) M2(q) = 0.  The resulting necessary equations are

    P4(q) b0 + P3(q) b1 = 0,
    P4 = C M0,  P3 = C M1.

For every coordinate triple I, this producer proves that the restricted rows
span

    Sym^4(F_89^I) e0  direct_sum  Sym^3(F_89^I)^6,

a 75-dimensional coefficient space.  Hence [P4(q)|P3(q)] has rank seven at
every nonzero q supported on I.  This excludes the combined Stage-B/Stage-C
contraction incidence only for q-support at most three.  It does not decide
q-support at least four or global degree-25 support.
"""

from __future__ import annotations

import ctypes
import hashlib
from itertools import combinations
import json
from pathlib import Path
import resource
import time

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
GLOBAL_BASIS_DIR = (
    ROOT
    / "goals_2026-08-01"
    / "P25_LANDING_SUPPORT"
    / "parallel"
    / "stageb_global_basis"
)
FULL_BASIS = GLOBAL_BASIS_DIR / "full_linear_syzygy_basis.npy"
FULL_P3 = GLOBAL_BASIS_DIR / "full_p3_contractions.npy"
CERTIFICATE = HERE / "pc2_coordinate_plane_certificate.npz"
SUMMARY = HERE / "pc2_coordinate_plane_summary.json"

EXPECTED_RELATION_SHA256 = (
    "6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb"
)
EXPECTED_FULL_BASIS_SHA256 = (
    "3571e9879bf1af6d6a405d9761522d4253e76e40edd129afd4b9363287d60ca3"
)
EXPECTED_FULL_P3_SHA256 = (
    "93eb010020c7b808039243cd64aede54677c95f74c17efe8e3abb03c5dbf2019"
)
EXPECTED_SELECTED_ROWS_SHA256 = (
    "d6df5a14bbad060ed255a50bb149e83d7c0db4caee2055dbe849f921488edd66"
)
EXPECTED_SELECTED_SYZYGIES_SHA256 = (
    "058ee61e00d4463b8733829ae35b78b7b4c8485b83319a9874f0afba46224b6c"
)
EXPECTED_SELECTED_P3_SHA256 = (
    "deb3815b6a0998081dadd93fc4af9b5e2312c4df43c674f209e5052fe3c6bbf8"
)

P = 89
NQ = 37
NSEED = 690
NULLITY = 10767
NSELECT = 412
NB1 = 6
NB2 = 21
SELECTION_SEED = 2026080125
LOCAL_P3_DIM = 10
LOCAL_P4_DIM = 15
LOCAL_TARGET_DIM = LOCAL_P4_DIM + NB1 * LOCAL_P3_DIM


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 22):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    answer = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, source_index] = target_index[tuple(exponent)]
    return answer


def selected_rows() -> np.ndarray:
    # The explicit list is persisted in the certificate.  The hash assertion
    # prevents an RNG implementation change from silently changing the proof.
    permutation = np.random.default_rng(SELECTION_SEED).permutation(NULLITY)
    rows = np.sort(permutation[:NSELECT].astype(np.int32))
    if sha256_array(rows) != EXPECTED_SELECTED_ROWS_SHA256:
        raise AssertionError("deterministic 412-row selection changed")
    return rows


def relation_blocks(
    seeds: np.ndarray,
    offsets: np.ndarray,
    q1: list[tuple[int, ...]],
    q2: list[tuple[int, ...]],
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    b0 = np.ascontiguousarray(seeds[:, offsets[0] : offsets[1]], dtype=np.uint8)
    b1 = np.concatenate(
        [seeds[:, offsets[1 + j] : offsets[2 + j]] for j in range(NB1)],
        axis=1,
    ).astype(np.uint8)
    variable_of = [monomial.index(1) for monomial in q1]
    b2 = np.empty((NSEED, NB2, NQ), dtype=np.uint8)
    for component in range(NB2):
        block = seeds[:, offsets[7 + component] : offsets[8 + component]]
        for monomial_index, variable in enumerate(variable_of):
            b2[:, component, variable] = block[:, monomial_index]
    if b0.shape != (NSEED, 9139):
        raise AssertionError(f"unexpected M0 shape {b0.shape}")
    if b1.shape != (NSEED, NB1 * len(q2)):
        raise AssertionError(f"unexpected M1 shape {b1.shape}")
    if b2.shape != (NSEED, NB2, NQ):
        raise AssertionError(f"unexpected M2 shape {b2.shape}")
    return b0, b1, b2


def verify_cm2_zero(
    syzygies: np.ndarray,
    m2: np.ndarray,
    q2: list[tuple[int, ...]],
) -> tuple[int, str]:
    q2_index = {monomial: index for index, monomial in enumerate(q2)}
    pair_target = np.empty((NQ, NQ), dtype=np.int32)
    for left in range(NQ):
        for right in range(NQ):
            exponent = [0] * NQ
            exponent[left] += 1
            exponent[right] += 1
            pair_target[left, right] = q2_index[tuple(exponent)]

    residual_digest = hashlib.sha256()
    residual_nonzero = 0
    for component in range(NB2):
        residual = np.zeros((NSELECT, len(q2)), dtype=np.uint16)
        right = np.ascontiguousarray(m2[:, component, :], dtype=np.float64)
        for left_variable in range(NQ):
            product = (
                np.ascontiguousarray(
                    syzygies[:, :, left_variable], dtype=np.float64
                )
                @ right
            )
            np.remainder(product, float(P), out=product)
            residual[:, pair_target[left_variable]] += product.astype(np.uint16)
        np.remainder(residual, P, out=residual)
        reduced = residual.astype(np.uint8)
        residual_nonzero += int(np.count_nonzero(reduced))
        residual_digest.update(reduced.tobytes())
    if residual_nonzero:
        raise AssertionError(
            f"selected full-basis rows do not satisfy C*M2=0: {residual_nonzero} coefficients"
        )
    return residual_nonzero, residual_digest.hexdigest()


def contract_selected_p3(
    syzygies: np.ndarray,
    m1: np.ndarray,
    q2: list[tuple[int, ...]],
    q3: list[tuple[int, ...]],
) -> np.ndarray:
    product_targets = multiplication_map(q2, q3)
    right = np.asarray(m1, dtype=np.float64)
    output = np.zeros((NSELECT, NB1, len(q3)), dtype=np.uint8)
    for variable in range(NQ):
        product = (
            np.ascontiguousarray(syzygies[:, :, variable], dtype=np.float64)
            @ right
        )
        # Every unreduced dot product is at most 690*88^2 < 2^53.
        np.remainder(product, float(P), out=product)
        addition = product.astype(np.uint8).reshape(NSELECT, NB1, len(q2))
        targets = product_targets[variable]
        for component in range(NB1):
            updated = output[:, component, targets].astype(np.uint16)
            updated += addition[:, component]
            np.remainder(updated, P, out=updated)
            output[:, component, targets] = updated.astype(np.uint8)
    return output


def contract_selected_p4(
    syzygies: np.ndarray,
    m0: np.ndarray,
    q3: list[tuple[int, ...]],
    q4: list[tuple[int, ...]],
) -> np.ndarray:
    product_targets = multiplication_map(q3, q4)
    right = np.asarray(m0, dtype=np.float64)
    output = np.zeros((NSELECT, len(q4)), dtype=np.uint8)
    for variable in range(NQ):
        product = (
            np.ascontiguousarray(syzygies[:, :, variable], dtype=np.float64)
            @ right
        )
        np.remainder(product, float(P), out=product)
        targets = product_targets[variable]
        updated = output[:, targets].astype(np.uint16)
        updated += product.astype(np.uint8)
        np.remainder(updated, P, out=updated)
        output[:, targets] = updated.astype(np.uint8)
    return output


def local_to_global_indices(
    local_basis: list[tuple[int, ...]],
    global_index: dict[tuple[int, ...], int],
    triple: tuple[int, int, int],
) -> np.ndarray:
    answer = []
    for local in local_basis:
        exponent = [0] * NQ
        for local_variable, global_variable in enumerate(triple):
            exponent[global_variable] = local[local_variable]
        answer.append(global_index[tuple(exponent)])
    return np.asarray(answer, dtype=np.int32)


class ExactBackend:
    def __init__(self) -> None:
        self.library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
        self.profile = self.library.RowRankProfile_modular_double
        self.profile.argtypes = [
            ctypes.c_double,
            ctypes.c_size_t,
            ctypes.c_size_t,
            np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
            ctypes.c_size_t,
            ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)),
            ctypes.c_int,
            ctypes.c_bool,
        ]
        self.profile.restype = ctypes.c_size_t
        self.determinant = self.library.Det_modular_double
        self.determinant.argtypes = [
            ctypes.c_double,
            ctypes.c_size_t,
            np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
            ctypes.c_size_t,
            ctypes.c_bool,
        ]
        self.determinant.restype = ctypes.c_double

    def row_rank_profile(self, matrix: np.ndarray) -> tuple[int, np.ndarray]:
        dense = np.ascontiguousarray(matrix, dtype=np.float64)
        pointer = ctypes.POINTER(ctypes.c_size_t)()
        rows, columns = dense.shape
        rank = int(
            self.profile(
                float(P),
                rows,
                columns,
                dense,
                columns,
                ctypes.byref(pointer),
                2,  # FfpackTileRecursive / PLUQ rank profile.
                False,
            )
        )
        profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy()
        return rank, profile.astype(np.int32)

    def det(self, matrix: np.ndarray) -> int:
        dense = np.ascontiguousarray(matrix, dtype=np.float64)
        if dense.shape[0] != dense.shape[1]:
            raise ValueError("determinant matrix is not square")
        value = self.determinant(
            float(P), dense.shape[0], dense, dense.shape[1], False
        )
        return int(round(value)) % P


def main() -> None:
    started = time.monotonic()
    input_hashes = {
        "relation_matrix": sha256_file(RELATION),
        "full_linear_syzygy_basis": sha256_file(FULL_BASIS),
        "full_p3_contractions": sha256_file(FULL_P3),
    }
    expected_hashes = {
        "relation_matrix": EXPECTED_RELATION_SHA256,
        "full_linear_syzygy_basis": EXPECTED_FULL_BASIS_SHA256,
        "full_p3_contractions": EXPECTED_FULL_P3_SHA256,
    }
    if input_hashes != expected_hashes:
        raise AssertionError(
            f"sealed PC.2 input hash mismatch: {input_hashes} != {expected_hashes}"
        )

    rows = selected_rows()
    full_basis = np.load(FULL_BASIS, mmap_mode="r")
    full_p3 = np.load(FULL_P3, mmap_mode="r")
    if full_basis.shape != (NULLITY, NSEED, NQ) or full_basis.dtype != np.uint8:
        raise AssertionError(f"unexpected full basis {full_basis.shape} {full_basis.dtype}")
    if full_p3.shape != (NULLITY, NB1, 9139) or full_p3.dtype != np.uint8:
        raise AssertionError(f"unexpected full P3 {full_p3.shape} {full_p3.dtype}")
    syzygies = np.ascontiguousarray(full_basis[rows], dtype=np.uint8)
    stored_p3 = np.ascontiguousarray(full_p3[rows], dtype=np.uint8)
    if sha256_array(syzygies) != EXPECTED_SELECTED_SYZYGIES_SHA256:
        raise AssertionError("selected syzygy rows changed")
    if sha256_array(stored_p3) != EXPECTED_SELECTED_P3_SHA256:
        raise AssertionError("selected stored P3 rows changed")

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        bdeg = frozen["Bdeg"].astype(np.int8)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    if seeds.shape != (NSEED, 14134):
        raise AssertionError(f"unexpected relation shape {seeds.shape}")
    if bdeg.tolist() != [0] + [1] * NB1 + [2] * NB2:
        raise AssertionError("relation grading changed")

    q1 = weak_compositions(1, NQ)
    q2 = weak_compositions(2, NQ)
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    if (len(q1), len(q2), len(q3), len(q4)) != (37, 703, 9139, 91390):
        raise AssertionError("global monomial census changed")
    m0, m1, m2 = relation_blocks(seeds, offsets, q1, q2)

    identity_started = time.monotonic()
    cm2_nonzero, cm2_sha = verify_cm2_zero(syzygies, m2, q2)
    identity_seconds = time.monotonic() - identity_started
    print(
        f"verified C*M2=0 for {NSELECT} rows in {identity_seconds:.3f}s",
        flush=True,
    )

    p3_started = time.monotonic()
    rebuilt_p3 = contract_selected_p3(syzygies, m1, q2, q3)
    p3_seconds = time.monotonic() - p3_started
    if not np.array_equal(rebuilt_p3, stored_p3):
        difference = int(np.count_nonzero(rebuilt_p3 != stored_p3))
        raise AssertionError(f"independent selected P3 rebuild differs in {difference} entries")
    rebuilt_p3_sha = sha256_array(rebuilt_p3)
    print(f"rebuilt selected P3 in {p3_seconds:.3f}s", flush=True)

    p4_started = time.monotonic()
    rebuilt_p4 = contract_selected_p4(syzygies, m0, q3, q4)
    p4_seconds = time.monotonic() - p4_started
    rebuilt_p4_sha = sha256_array(rebuilt_p4)
    print(f"rebuilt selected P4 in {p4_seconds:.3f}s", flush=True)

    triples = np.asarray(list(combinations(range(NQ), 3)), dtype=np.uint8)
    if triples.shape != (7770, 3):
        raise AssertionError(f"coordinate-triple census changed: {triples.shape}")
    local_q3 = weak_compositions(3, 3)
    local_q4 = weak_compositions(4, 3)
    if len(local_q3) != LOCAL_P3_DIM or len(local_q4) != LOCAL_P4_DIM:
        raise AssertionError("local monomial census changed")
    q3_index = {monomial: index for index, monomial in enumerate(q3)}
    q4_index = {monomial: index for index, monomial in enumerate(q4)}

    profiles = np.empty((len(triples), LOCAL_TARGET_DIM), dtype=np.uint16)
    determinants = np.empty(len(triples), dtype=np.uint8)
    ranks = np.empty(len(triples), dtype=np.uint8)
    matrix_digest = hashlib.sha256()
    minor_digest = hashlib.sha256()
    backend = ExactBackend()
    plane_started = time.monotonic()
    for triple_index, raw_triple in enumerate(triples):
        triple = tuple(map(int, raw_triple))
        local3_indices = local_to_global_indices(local_q3, q3_index, triple)
        local4_indices = local_to_global_indices(local_q4, q4_index, triple)
        matrix = np.ascontiguousarray(
            np.column_stack(
                [
                    rebuilt_p4[:, local4_indices],
                    rebuilt_p3[:, :, local3_indices].reshape(
                        NSELECT, NB1 * LOCAL_P3_DIM
                    ),
                ]
            ),
            dtype=np.uint8,
        )
        if matrix.shape != (NSELECT, LOCAL_TARGET_DIM):
            raise AssertionError(f"bad local matrix shape {matrix.shape} for {triple}")
        matrix_digest.update(matrix.tobytes())
        rank, profile = backend.row_rank_profile(matrix)
        ranks[triple_index] = rank
        if rank != LOCAL_TARGET_DIM:
            raise AssertionError(
                f"coordinate plane {triple} has rank {rank} < {LOCAL_TARGET_DIM}"
            )
        if len(np.unique(profile)) != LOCAL_TARGET_DIM:
            raise AssertionError(f"repeated row in rank profile for {triple}")
        if np.any(profile < 0) or np.any(profile >= NSELECT):
            raise AssertionError(f"rank profile outside selected rows for {triple}")
        profiles[triple_index] = profile.astype(np.uint16)
        minor = np.ascontiguousarray(matrix[profile], dtype=np.uint8)
        minor_digest.update(minor.tobytes())
        determinant = backend.det(minor)
        if determinant == 0:
            raise AssertionError(f"selected profile minor is singular for {triple}")
        determinants[triple_index] = determinant
        if (triple_index + 1) % 1000 == 0 or triple_index + 1 == len(triples):
            print(
                f"coordinate planes {triple_index + 1}/{len(triples)} rank=75",
                flush=True,
            )
    plane_seconds = time.monotonic() - plane_started

    matrix_sha = matrix_digest.hexdigest()
    minor_sha = minor_digest.hexdigest()
    np.savez_compressed(
        CERTIFICATE,
        prime=np.int32(P),
        selection_seed=np.int64(SELECTION_SEED),
        selected_full_basis_rows=rows,
        coordinate_triples=triples,
        row_rank_profiles=profiles,
        ranks=ranks,
        determinants_mod89=determinants,
        selected_rows_sha256=np.asarray(sha256_array(rows)),
        selected_syzygies_sha256=np.asarray(sha256_array(syzygies)),
        selected_p3_sha256=np.asarray(rebuilt_p3_sha),
        selected_p4_sha256=np.asarray(rebuilt_p4_sha),
        cm2_residual_sha256=np.asarray(cm2_sha),
        restricted_matrices_sha256=np.asarray(matrix_sha),
        selected_minors_sha256=np.asarray(minor_sha),
        relation_matrix_sha256=np.asarray(input_hashes["relation_matrix"]),
        full_basis_sha256=np.asarray(input_hashes["full_linear_syzygy_basis"]),
        full_p3_sha256=np.asarray(input_hashes["full_p3_contractions"]),
    )

    rank_values, rank_counts = np.unique(ranks, return_counts=True)
    determinant_values, determinant_counts = np.unique(
        determinants, return_counts=True
    )
    total_seconds = time.monotonic() - started
    payload = {
        "status": "PC2-COORDINATE-PLANES-PASS",
        "prime": P,
        "inputs": {
            "relation_matrix": {
                "path": str(RELATION.relative_to(ROOT)),
                "sha256": input_hashes["relation_matrix"],
                "shape": [NSEED, 14134],
                "bytes": RELATION.stat().st_size,
            },
            "full_linear_syzygy_basis": {
                "path": str(FULL_BASIS.relative_to(ROOT)),
                "sha256": input_hashes["full_linear_syzygy_basis"],
                "shape": [NULLITY, NSEED, NQ],
                "bytes": FULL_BASIS.stat().st_size,
            },
            "full_p3_contractions": {
                "path": str(FULL_P3.relative_to(ROOT)),
                "sha256": input_hashes["full_p3_contractions"],
                "shape": [NULLITY, NB1, len(q3)],
                "bytes": FULL_P3.stat().st_size,
            },
        },
        "selection": {
            "rule": (
                "sort the first 412 entries of numpy PCG64 permutation(10767) "
                "with seed 2026080125; persist the explicit row list"
            ),
            "seed": SELECTION_SEED,
            "rows": NSELECT,
            "selected_rows_sha256": sha256_array(rows),
            "selected_syzygies_sha256": sha256_array(syzygies),
        },
        "identity_replay": {
            "identities": "C(q) M2(q) = 0",
            "rows_checked": NSELECT,
            "components": NB2,
            "quadratic_coefficients_per_component": len(q2),
            "residual_nonzero_coefficients": cm2_nonzero,
            "residual_sha256": cm2_sha,
        },
        "contractions": {
            "P3": {
                "identity": "P3 = C M1",
                "shape": list(rebuilt_p3.shape),
                "sha256": rebuilt_p3_sha,
                "byte_matches_complete_stored_P3": True,
            },
            "P4": {
                "identity": "P4 = C M0",
                "shape": list(rebuilt_p4.shape),
                "sha256": rebuilt_p4_sha,
            },
            "exact_modular_double_bound": "690*88*88=5343360 < 2^53",
        },
        "coordinate_plane_certificate": {
            "coordinate_triples": len(triples),
            "local_projective_space": "P^2 on each coordinate triple",
            "local_quartic_dimension": LOCAL_P4_DIM,
            "local_six_cubic_dimension": NB1 * LOCAL_P3_DIM,
            "target_dimension": LOCAL_TARGET_DIM,
            "matrix_shape_each": [NSELECT, LOCAL_TARGET_DIM],
            "rank_histogram": {
                str(int(value)): int(count)
                for value, count in zip(rank_values, rank_counts)
            },
            "nonzero_selected_minors": int(np.count_nonzero(determinants)),
            "determinant_histogram_mod89": {
                str(int(value)): int(count)
                for value, count in zip(determinant_values, determinant_counts)
            },
            "row_rank_profiles_shape": list(profiles.shape),
            "restricted_matrices_sha256": matrix_sha,
            "selected_minors_sha256": minor_sha,
        },
        "certificate": {
            "file": CERTIFICATE.name,
            "sha256": sha256_file(CERTIFICATE),
            "bytes": CERTIFICATE.stat().st_size,
        },
        "theorem": {
            "proved": (
                "Over F_89, the selected genuine contraction rows have augmented "
                "rank seven at every nonzero q with coordinate support at most three. "
                "Thus the combined Stage B (b0=0,b1!=0) and normalized Stage C "
                "(b0!=0) necessary-equation loci are empty on that bounded union."
            ),
            "implication": (
                "Every original 690-row incidence point satisfies the contraction "
                "equations, so the true special-fibre Stage-B/Stage-C loci also have "
                "no point with q-support at most three."
            ),
            "does_not_prove": (
                "Any statement for q-support at least four, global Stage B or Stage C, "
                "the complete projective degree-25 support, characteristic-zero "
                "emptiness, transition stabilization, or the Problem E headline."
            ),
            "status_guard": "PC-UNDECIDED remains required globally.",
        },
        "backend": {
            "rank": "FFLAS-FFPACK RowRankProfile_modular_double, PLUQ",
            "determinant": "FFLAS-FFPACK Det_modular_double",
        },
        "timing": {
            "cm2_identity_seconds": identity_seconds,
            "p3_rebuild_seconds": p3_seconds,
            "p4_rebuild_seconds": p4_seconds,
            "coordinate_plane_rank_and_minor_seconds": plane_seconds,
            "total_seconds": total_seconds,
        },
        "resource": {
            "max_rss_raw": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
            "max_rss_note": "On macOS ru_maxrss is bytes.",
        },
    }
    SUMMARY.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(
        "PASS_PC2_COORDINATE_PLANES_SUPPORT_LE3 "
        f"planes={len(triples)} rank_histogram={payload['coordinate_plane_certificate']['rank_histogram']} "
        f"certificate_sha256={payload['certificate']['sha256']} "
        f"summary_sha256={sha256_file(SUMMARY)} total_seconds={total_seconds:.3f}",
        flush=True,
    )


if __name__ == "__main__":
    main()
