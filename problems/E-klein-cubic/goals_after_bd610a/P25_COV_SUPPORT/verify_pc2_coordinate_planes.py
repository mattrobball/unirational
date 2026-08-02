#!/usr/bin/env python3
"""Independent replay of the PC.2 q-coordinate-plane certificate over F_89.

The selected 412 syzygies, C*M2 identities, P3/P4 contractions, and all 7,770
three-coordinate restrictions are rebuilt before the producer artifact is
opened.  Rank profiles and 75-by-75 determinants are computed by a small
standalone modular C++ eliminator embedded here, rather than the producer's
FFLAS-FFPACK PLUQ/determinant calls.

Scope: this excludes the necessary Stage-B/Stage-C incidence only for
q-support at most three.  It is not a global support or stabilization result.
"""

from __future__ import annotations

import ctypes
import hashlib
from itertools import combinations
import json
from pathlib import Path
import subprocess

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
GLOBAL_BASIS = (
    ROOT
    / "goals_2026-08-01"
    / "P25_LANDING_SUPPORT"
    / "parallel"
    / "stageb_global_basis"
)
FULL_BASIS = GLOBAL_BASIS / "full_linear_syzygy_basis.npy"
FULL_P3 = GLOBAL_BASIS / "full_p3_contractions.npy"
PRODUCER_CERTIFICATE = HERE / "pc2_coordinate_plane_certificate.npz"
PRODUCER_SUMMARY = HERE / "pc2_coordinate_plane_summary.json"
OUTPUT = HERE / "verify_pc2_coordinate_planes_result.json"

EXPECTED_INPUT_HASHES = {
    "relation_matrix": "6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb",
    "full_linear_syzygy_basis": "3571e9879bf1af6d6a405d9761522d4253e76e40edd129afd4b9363287d60ca3",
    "full_p3_contractions": "93eb010020c7b808039243cd64aede54677c95f74c17efe8e3abb03c5dbf2019",
}
EXPECTED_SELECTED_ROWS = "d6df5a14bbad060ed255a50bb149e83d7c0db4caee2055dbe849f921488edd66"
EXPECTED_SELECTED_SYZYGIES = "058ee61e00d4463b8733829ae35b78b7b4c8485b83319a9874f0afba46224b6c"
EXPECTED_SELECTED_P3 = "deb3815b6a0998081dadd93fc4af9b5e2312c4df43c674f209e5052fe3c6bbf8"

P = 89
NQ = 37
NSEED = 690
FULL_NULLITY = 10767
NSELECT = 412
NB1 = 6
NB2 = 21
SELECTION_SEED = 2026080125
NTRIPLES = 7770
LOCAL_P3 = 10
LOCAL_P4 = 15
LOCAL_TARGET = LOCAL_P4 + NB1 * LOCAL_P3


CUSTOM_ELIMINATOR_SOURCE = r"""
#include <cstddef>
#include <cstdint>
#include <vector>

namespace {
constexpr int prime = 89;

inline int mod(int value) {
    value %= prime;
    return value < 0 ? value + prime : value;
}

int power(int base, int exponent) {
    int result = 1;
    while (exponent) {
        if (exponent & 1) result = mod(result * base);
        base = mod(base * base);
        exponent >>= 1;
    }
    return result;
}
}  // namespace

extern "C" int profile_and_determinant(
    const std::uint8_t* matrix,
    std::size_t rows,
    std::size_t columns,
    std::uint16_t* profile,
    std::uint8_t* determinant
) {
    std::vector<int> basis(columns * columns, 0);
    std::vector<unsigned char> present(columns, 0);
    std::vector<int> vector(columns, 0);
    std::vector<int> pivot_order;
    pivot_order.reserve(columns);
    int determinant_product = 1;
    std::size_t rank = 0;

    for (std::size_t source_row = 0; source_row < rows && rank < columns; ++source_row) {
        for (std::size_t column = 0; column < columns; ++column)
            vector[column] = matrix[source_row * columns + column];

        for (std::size_t pivot = 0; pivot < columns; ++pivot) {
            if (!present[pivot] || vector[pivot] == 0) continue;
            const int coefficient = vector[pivot];
            const int* reducer = &basis[pivot * columns];
            for (std::size_t column = 0; column < columns; ++column)
                vector[column] = mod(vector[column] - coefficient * reducer[column]);
        }

        std::size_t pivot = 0;
        while (pivot < columns && vector[pivot] == 0) ++pivot;
        if (pivot == columns) continue;

        profile[rank] = static_cast<std::uint16_t>(source_row);
        pivot_order.push_back(static_cast<int>(pivot));
        const int pivot_value = vector[pivot];
        determinant_product = mod(determinant_product * pivot_value);
        const int inverse = power(pivot_value, prime - 2);
        int* destination = &basis[pivot * columns];
        for (std::size_t column = 0; column < columns; ++column)
            destination[column] = mod(vector[column] * inverse);
        present[pivot] = 1;
        ++rank;
    }

    if (rank == columns) {
        int parity = 0;
        for (std::size_t left = 0; left < pivot_order.size(); ++left)
            for (std::size_t right = left + 1; right < pivot_order.size(); ++right)
                parity ^= (pivot_order[left] > pivot_order[right]);
        if (parity) determinant_product = mod(-determinant_product);
        *determinant = static_cast<std::uint8_t>(determinant_product);
    } else {
        *determinant = 0;
    }
    return static_cast<int>(rank);
}
"""


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
    output: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            output.append((first,) + tail)
    return output


def multiply_monomial_indices(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_lookup = {monomial: index for index, monomial in enumerate(target)}
    result = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            result[variable, source_index] = target_lookup[tuple(exponent)]
    return result


def deterministic_rows() -> np.ndarray:
    permutation = np.random.default_rng(SELECTION_SEED).permutation(FULL_NULLITY)
    rows = np.sort(permutation[:NSELECT].astype(np.int32))
    assert sha256_array(rows) == EXPECTED_SELECTED_ROWS
    return rows


def relation_blocks(
    seeds: np.ndarray,
    offsets: np.ndarray,
    linear_monomials: list[tuple[int, ...]],
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    m0 = np.ascontiguousarray(seeds[:, offsets[0] : offsets[1]], dtype=np.uint8)
    m1 = np.ascontiguousarray(
        np.concatenate(
            [seeds[:, offsets[1 + component] : offsets[2 + component]] for component in range(NB1)],
            axis=1,
        ),
        dtype=np.uint8,
    )
    variable_order = [monomial.index(1) for monomial in linear_monomials]
    m2 = np.empty((NSEED, NB2, NQ), dtype=np.uint8)
    for component in range(NB2):
        source = seeds[:, offsets[7 + component] : offsets[8 + component]]
        for stored_column, variable in enumerate(variable_order):
            m2[:, component, variable] = source[:, stored_column]
    assert m0.shape == (NSEED, 9139)
    assert m1.shape == (NSEED, NB1 * 703)
    assert m2.shape == (NSEED, NB2, NQ)
    return m0, m1, m2


def verify_syzygy_identity(
    syzygies: np.ndarray,
    m2: np.ndarray,
    quadratics: list[tuple[int, ...]],
) -> tuple[int, str]:
    quadratic_lookup = {monomial: index for index, monomial in enumerate(quadratics)}
    product_column = np.empty((NQ, NQ), dtype=np.int32)
    for left in range(NQ):
        for right in range(NQ):
            exponent = [0] * NQ
            exponent[left] += 1
            exponent[right] += 1
            product_column[left, right] = quadratic_lookup[tuple(exponent)]

    digest = hashlib.sha256()
    nonzero = 0
    for component in range(NB2):
        residual = np.zeros((NSELECT, len(quadratics)), dtype=np.uint16)
        right = np.ascontiguousarray(m2[:, component], dtype=np.float64)
        for left in range(NQ):
            product = np.rint(
                np.ascontiguousarray(syzygies[:, :, left], dtype=np.float64)
                @ right
            ).astype(np.int64) % P
            residual[:, product_column[left]] += product.astype(np.uint16)
        residual %= P
        reduced = residual.astype(np.uint8)
        nonzero += int(np.count_nonzero(reduced))
        digest.update(reduced.tobytes())
    assert nonzero == 0
    return nonzero, digest.hexdigest()


def rebuild_p3(
    syzygies: np.ndarray,
    m1: np.ndarray,
    quadratics: list[tuple[int, ...]],
    cubics: list[tuple[int, ...]],
) -> np.ndarray:
    targets = multiply_monomial_indices(quadratics, cubics)
    output = np.zeros((NSELECT, NB1, len(cubics)), dtype=np.uint8)
    right = m1.astype(np.float64)
    for variable in range(NQ):
        product = np.rint(
            np.ascontiguousarray(syzygies[:, :, variable], dtype=np.float64)
            @ right
        ).astype(np.int64) % P
        addition = product.astype(np.uint8).reshape(NSELECT, NB1, len(quadratics))
        for component in range(NB1):
            updated = output[:, component, targets[variable]].astype(np.uint16)
            updated += addition[:, component]
            output[:, component, targets[variable]] = (updated % P).astype(np.uint8)
    return output


def rebuild_p4(
    syzygies: np.ndarray,
    m0: np.ndarray,
    cubics: list[tuple[int, ...]],
    quartics: list[tuple[int, ...]],
) -> np.ndarray:
    targets = multiply_monomial_indices(cubics, quartics)
    output = np.zeros((NSELECT, len(quartics)), dtype=np.uint8)
    right = m0.astype(np.float64)
    for variable in range(NQ):
        product = np.rint(
            np.ascontiguousarray(syzygies[:, :, variable], dtype=np.float64)
            @ right
        ).astype(np.int64) % P
        updated = output[:, targets[variable]].astype(np.uint16)
        updated += product.astype(np.uint8)
        output[:, targets[variable]] = (updated % P).astype(np.uint8)
    return output


def local_global_columns(
    local_monomials: list[tuple[int, ...]],
    global_lookup: dict[tuple[int, ...], int],
    triple: tuple[int, int, int],
) -> np.ndarray:
    columns = []
    for local in local_monomials:
        exponent = [0] * NQ
        for local_variable, global_variable in enumerate(triple):
            exponent[global_variable] = local[local_variable]
        columns.append(global_lookup[tuple(exponent)])
    return np.asarray(columns, dtype=np.int32)


class IndependentEliminator:
    def __init__(self, scratch: Path) -> None:
        scratch.mkdir(parents=True, exist_ok=True)
        library_path = scratch / "coordinate_plane_eliminator.dylib"
        subprocess.run(
            [
                "clang++",
                "-O3",
                "-std=c++17",
                "-dynamiclib",
                "-x",
                "c++",
                "-",
                "-o",
                str(library_path),
            ],
            input=CUSTOM_ELIMINATOR_SOURCE,
            text=True,
            check=True,
        )
        library = ctypes.CDLL(str(library_path))
        self.function = library.profile_and_determinant
        self.function.argtypes = [
            np.ctypeslib.ndpointer(np.uint8, flags="C_CONTIGUOUS"),
            ctypes.c_size_t,
            ctypes.c_size_t,
            np.ctypeslib.ndpointer(np.uint16, flags="C_CONTIGUOUS"),
            np.ctypeslib.ndpointer(np.uint8, flags="C_CONTIGUOUS"),
        ]
        self.function.restype = ctypes.c_int

    def profile_and_determinant(self, matrix: np.ndarray) -> tuple[int, np.ndarray, int]:
        matrix = np.ascontiguousarray(matrix, dtype=np.uint8)
        profile = np.empty(matrix.shape[1], dtype=np.uint16)
        determinant = np.zeros(1, dtype=np.uint8)
        rank = int(
            self.function(
                matrix,
                matrix.shape[0],
                matrix.shape[1],
                profile,
                determinant,
            )
        )
        return rank, profile[:rank].copy(), int(determinant[0])


def histogram(array: np.ndarray) -> dict[str, int]:
    values, counts = np.unique(array, return_counts=True)
    return {str(int(value)): int(count) for value, count in zip(values, counts)}


def assert_summary(
    summary: dict[str, object],
    input_hashes: dict[str, str],
    rows: np.ndarray,
    syzygies: np.ndarray,
    cm2_sha: str,
    p3: np.ndarray,
    p4: np.ndarray,
    profiles: np.ndarray,
    ranks: np.ndarray,
    determinants: np.ndarray,
    matrix_sha: str,
    minor_sha: str,
) -> None:
    assert summary["status"] == "PC2-COORDINATE-PLANES-PASS"
    assert summary["prime"] == P
    for key, digest in input_hashes.items():
        assert summary["inputs"][key]["sha256"] == digest
    assert summary["selection"]["seed"] == SELECTION_SEED
    assert summary["selection"]["rows"] == NSELECT
    assert summary["selection"]["selected_rows_sha256"] == sha256_array(rows)
    assert summary["selection"]["selected_syzygies_sha256"] == sha256_array(syzygies)
    identity = summary["identity_replay"]
    assert identity["rows_checked"] == NSELECT
    assert identity["components"] == NB2
    assert identity["quadratic_coefficients_per_component"] == 703
    assert identity["residual_nonzero_coefficients"] == 0
    assert identity["residual_sha256"] == cm2_sha
    assert summary["contractions"]["P3"]["shape"] == list(p3.shape)
    assert summary["contractions"]["P3"]["sha256"] == sha256_array(p3)
    assert summary["contractions"]["P3"]["byte_matches_complete_stored_P3"] is True
    assert summary["contractions"]["P4"]["shape"] == list(p4.shape)
    assert summary["contractions"]["P4"]["sha256"] == sha256_array(p4)
    planes = summary["coordinate_plane_certificate"]
    assert planes["coordinate_triples"] == NTRIPLES
    assert planes["target_dimension"] == LOCAL_TARGET
    assert planes["matrix_shape_each"] == [NSELECT, LOCAL_TARGET]
    assert planes["rank_histogram"] == histogram(ranks)
    assert planes["nonzero_selected_minors"] == NTRIPLES
    assert planes["determinant_histogram_mod89"] == histogram(determinants)
    assert planes["row_rank_profiles_shape"] == list(profiles.shape)
    assert planes["restricted_matrices_sha256"] == matrix_sha
    assert planes["selected_minors_sha256"] == minor_sha
    assert summary["certificate"]["sha256"] == sha256_file(PRODUCER_CERTIFICATE)


def main() -> None:
    input_hashes = {
        "relation_matrix": sha256_file(RELATION),
        "full_linear_syzygy_basis": sha256_file(FULL_BASIS),
        "full_p3_contractions": sha256_file(FULL_P3),
    }
    assert input_hashes == EXPECTED_INPUT_HASHES

    rows = deterministic_rows()
    full_basis = np.load(FULL_BASIS, mmap_mode="r")
    full_p3 = np.load(FULL_P3, mmap_mode="r")
    assert full_basis.shape == (FULL_NULLITY, NSEED, NQ)
    assert full_basis.dtype == np.uint8
    assert full_p3.shape == (FULL_NULLITY, NB1, 9139)
    assert full_p3.dtype == np.uint8
    syzygies = np.ascontiguousarray(full_basis[rows], dtype=np.uint8)
    stored_selected_p3 = np.ascontiguousarray(full_p3[rows], dtype=np.uint8)
    assert sha256_array(syzygies) == EXPECTED_SELECTED_SYZYGIES
    assert sha256_array(stored_selected_p3) == EXPECTED_SELECTED_P3

    with np.load(RELATION, allow_pickle=False) as frozen:
        assert int(frozen["prime"]) == P
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        degrees = frozen["Bdeg"].astype(np.int8)
    assert seeds.shape == (NSEED, 14134)
    assert degrees.tolist() == [0] + [1] * NB1 + [2] * NB2

    q1 = weak_compositions(1, NQ)
    q2 = weak_compositions(2, NQ)
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    assert tuple(map(len, (q1, q2, q3, q4))) == (37, 703, 9139, 91390)
    m0, m1, m2 = relation_blocks(seeds, offsets, q1)

    cm2_nonzero, cm2_sha = verify_syzygy_identity(syzygies, m2, q2)
    print("verified all selected C*M2 identities", flush=True)
    rebuilt_p3 = rebuild_p3(syzygies, m1, q2, q3)
    assert np.array_equal(rebuilt_p3, stored_selected_p3)
    print("rebuilt P3 from C*M1", flush=True)
    rebuilt_p4 = rebuild_p4(syzygies, m0, q3, q4)
    print("rebuilt P4 from C*M0", flush=True)

    triples = np.asarray(list(combinations(range(NQ), 3)), dtype=np.uint8)
    assert triples.shape == (NTRIPLES, 3)
    local_q3 = weak_compositions(3, 3)
    local_q4 = weak_compositions(4, 3)
    assert (len(local_q3), len(local_q4)) == (LOCAL_P3, LOCAL_P4)
    q3_lookup = {monomial: index for index, monomial in enumerate(q3)}
    q4_lookup = {monomial: index for index, monomial in enumerate(q4)}

    profiles = np.empty((NTRIPLES, LOCAL_TARGET), dtype=np.uint16)
    ranks = np.empty(NTRIPLES, dtype=np.uint8)
    determinants = np.empty(NTRIPLES, dtype=np.uint8)
    matrix_digest = hashlib.sha256()
    minor_digest = hashlib.sha256()
    backend = IndependentEliminator(Path("/tmp/p25_cov_pc2_coordinate_verify"))

    for triple_index, raw_triple in enumerate(triples):
        triple = tuple(map(int, raw_triple))
        cubic_columns = local_global_columns(local_q3, q3_lookup, triple)
        quartic_columns = local_global_columns(local_q4, q4_lookup, triple)
        matrix = np.ascontiguousarray(
            np.column_stack(
                [
                    rebuilt_p4[:, quartic_columns],
                    rebuilt_p3[:, :, cubic_columns].reshape(
                        NSELECT, NB1 * LOCAL_P3
                    ),
                ]
            ),
            dtype=np.uint8,
        )
        assert matrix.shape == (NSELECT, LOCAL_TARGET)
        matrix_digest.update(matrix.tobytes())
        rank, profile, determinant = backend.profile_and_determinant(matrix)
        assert rank == LOCAL_TARGET
        assert len(np.unique(profile)) == LOCAL_TARGET
        assert np.all(profile < NSELECT)
        assert determinant != 0
        profiles[triple_index] = profile
        ranks[triple_index] = rank
        determinants[triple_index] = determinant
        minor = np.ascontiguousarray(matrix[profile], dtype=np.uint8)
        minor_digest.update(minor.tobytes())
        if (triple_index + 1) % 1000 == 0 or triple_index + 1 == NTRIPLES:
            print(f"independent coordinate triples {triple_index + 1}/{NTRIPLES}", flush=True)

    matrix_sha = matrix_digest.hexdigest()
    minor_sha = minor_digest.hexdigest()
    summary = json.loads(PRODUCER_SUMMARY.read_text())
    assert_summary(
        summary,
        input_hashes,
        rows,
        syzygies,
        cm2_sha,
        rebuilt_p3,
        rebuilt_p4,
        profiles,
        ranks,
        determinants,
        matrix_sha,
        minor_sha,
    )

    expected_artifact = {
        "prime": np.asarray(P, dtype=np.int32),
        "selection_seed": np.asarray(SELECTION_SEED, dtype=np.int64),
        "selected_full_basis_rows": rows,
        "coordinate_triples": triples,
        "row_rank_profiles": profiles,
        "ranks": ranks,
        "determinants_mod89": determinants,
        "selected_rows_sha256": np.asarray(sha256_array(rows)),
        "selected_syzygies_sha256": np.asarray(sha256_array(syzygies)),
        "selected_p3_sha256": np.asarray(sha256_array(rebuilt_p3)),
        "selected_p4_sha256": np.asarray(sha256_array(rebuilt_p4)),
        "cm2_residual_sha256": np.asarray(cm2_sha),
        "restricted_matrices_sha256": np.asarray(matrix_sha),
        "selected_minors_sha256": np.asarray(minor_sha),
        "relation_matrix_sha256": np.asarray(input_hashes["relation_matrix"]),
        "full_basis_sha256": np.asarray(input_hashes["full_linear_syzygy_basis"]),
        "full_p3_sha256": np.asarray(input_hashes["full_p3_contractions"]),
    }
    with np.load(PRODUCER_CERTIFICATE, allow_pickle=False) as certificate:
        assert set(certificate.files) == set(expected_artifact)
        for name, rebuilt in expected_artifact.items():
            assert np.array_equal(certificate[name], rebuilt), name

    result = {
        "status": "PASS_INDEPENDENT_PC2_COORDINATE_PLANES_REPLAY",
        "ok": True,
        "prime": P,
        "inputs": input_hashes,
        "selection": {
            "seed": SELECTION_SEED,
            "rows": NSELECT,
            "rows_sha256": sha256_array(rows),
            "syzygies_sha256": sha256_array(syzygies),
        },
        "identity_replay": {
            "C_times_M2_nonzero_coefficients": cm2_nonzero,
            "residual_sha256": cm2_sha,
        },
        "contractions": {
            "P3_shape": list(rebuilt_p3.shape),
            "P3_sha256": sha256_array(rebuilt_p3),
            "P3_matches_immutable_complete_table": True,
            "P4_shape": list(rebuilt_p4.shape),
            "P4_sha256": sha256_array(rebuilt_p4),
        },
        "coordinate_planes": {
            "triples": NTRIPLES,
            "matrix_shape_each": [NSELECT, LOCAL_TARGET],
            "rank_histogram": histogram(ranks),
            "nonzero_determinants": int(np.count_nonzero(determinants)),
            "determinant_histogram_mod89": histogram(determinants),
            "profiles_sha256": sha256_array(profiles),
            "determinants_sha256": sha256_array(determinants),
            "restricted_matrices_sha256": matrix_sha,
            "selected_minors_sha256": minor_sha,
        },
        "producer_certificate_sha256": sha256_file(PRODUCER_CERTIFICATE),
        "all_producer_arrays_match": True,
        "all_producer_summary_fields_match": True,
        "rank_and_determinant_backend": (
            "independent standalone C++ Gaussian elimination over F_89; no "
            "FFLAS-FFPACK rank-profile or determinant call"
        ),
        "theorem_boundary": {
            "proves": (
                "Over F_89, the selected genuine contraction equations have "
                "rank 75 on every three-coordinate q-plane, excluding the "
                "Stage-B/Stage-C necessary incidence for q-support at most three."
            ),
            "does_not_prove": (
                "Any case with q-support at least four, global Stage B or C, "
                "complete degree-25 support, stabilization, characteristic-zero "
                "emptiness, or the Problem E headline. PC-UNDECIDED remains required."
            ),
        },
    }
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS_INDEPENDENT_PC2_COORDINATE_PLANES_SUPPORT_LE3", flush=True)


if __name__ == "__main__":
    main()
