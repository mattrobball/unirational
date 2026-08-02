#!/usr/bin/env python3
"""Build the exact compact degree-four Macaulay schedule for the dp profile.

No polynomial coefficients are expanded here.  For every normalized cubic
pivot row G_r and variable q_v, the script records the product leading term
q_v*LT(G_r).  In each product fiber it retains one canonical prolongation and
stores one star-tree difference for every other prolongation.  Fiberwise,

    (R_0,R_1,...,R_{k-1})
      -> (R_0,R_1-R_0,...,R_{k-1}-R_0)

is an invertible row operation over F_89.  The packet therefore describes the
complete degree-four Macaulay row space while using O(number of products)
integers rather than polynomial coefficient rows.

The packet is a schedule, not a completed coefficient reduction or a target
membership certificate.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np

import profile_degree3_closure as base
import profile_degree3_dprevlex as dp


HERE = Path(__file__).resolve().parent
PROFILE = HERE / "degree3_dp_pivot_profile.npz"
PACKET = HERE / "degree4_dp_schedule.npz"
MANIFEST = HERE / "degree4_dp_schedule.json"
UPSTREAM = HERE.parent / "stageb_global_basis"
FULL_BASIS_MANIFEST = UPSTREAM / "full_basis_manifest.json"
FULL_P3_MANIFEST = UPSTREAM / "full_p3_manifest.json"
UPSTREAM_SEAL = UPSTREAM / "SEAL.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def sealed_hashes() -> dict[str, str]:
    seal = json.loads(UPSTREAM_SEAL.read_text())
    return {record["path"]: record["sha256"] for record in seal["files"]}


def main() -> None:
    upstream_hashes = sealed_hashes()
    for path in (FULL_BASIS_MANIFEST, FULL_P3_MANIFEST):
        expected = upstream_hashes.get(path.name)
        if expected is None or sha256(path) != expected:
            raise AssertionError(f"upstream sealed hash mismatch: {path.name}")

    basis_manifest = json.loads(FULL_BASIS_MANIFEST.read_text())
    p3_manifest = json.loads(FULL_P3_MANIFEST.read_text())
    if basis_manifest["coefficient_matrix_shape"] != [14763, 25530]:
        raise AssertionError("upstream degree-two shape drift")
    if basis_manifest["coefficient_matrix_rank"] != 14763:
        raise AssertionError("upstream degree-two rank drift")
    if basis_manifest["nullity"] != base.RANK:
        raise AssertionError("upstream syzygy nullity drift")
    if p3_manifest["shape"] != [base.RANK, base.COMPONENTS, 9139]:
        raise AssertionError("upstream P3 shape drift")
    if p3_manifest["file_sha256"] != base.sha256(base.P3):
        raise AssertionError("upstream P3 data hash drift")

    with np.load(PROFILE, allow_pickle=False) as frozen:
        pivot_components = frozen["pivot_components"].astype(np.int8)
        pivot_exponents = frozen["pivot_exponents"].astype(np.int8)
        pivot_columns = frozen["pivot_columns"].astype(np.int32)
        if str(frozen["full_p3_sha256"]) != base.sha256(base.P3):
            raise AssertionError("profile P3 hash mismatch")
    if (
        len(pivot_components) != base.RANK
        or pivot_exponents.shape != (base.RANK, base.NQ)
        or len(pivot_columns) != base.RANK
    ):
        raise AssertionError("degree-three profile shape drift")

    q4 = base.weak_compositions(4, base.NQ)
    q4_index = {monomial: index for index, monomial in enumerate(q4)}
    degree4_order = dp.ordered_columns(q4)
    degree4_position = np.empty(len(degree4_order), dtype=np.int32)
    degree4_position[degree4_order] = np.arange(len(degree4_order), dtype=np.int32)

    # The dictionary holds only one two-integer representative per distinct
    # degree-four product.  All noncanonical representations become star-tree
    # differences against that representative.
    first: dict[tuple[int, tuple[int, ...]], tuple[int, int, int]] = {}
    duplicate_product: list[int] = []
    duplicate_row: list[int] = []
    duplicate_variable: list[int] = []
    canonical_row_for_duplicate: list[int] = []
    canonical_variable_for_duplicate: list[int] = []
    fiber_size: dict[int, int] = {}

    for row, (raw_component, raw_exponent) in enumerate(
        zip(pivot_components, pivot_exponents)
    ):
        component = int(raw_component)
        exponent = list(map(int, raw_exponent))
        if sum(exponent) != 3:
            raise AssertionError("noncubic pivot exponent")
        for variable in range(base.NQ):
            product = exponent.copy()
            product[variable] += 1
            product_tuple = tuple(product)
            ambient_column = component * len(q4) + q4_index[product_tuple]
            key = (component, product_tuple)
            canonical = first.get(key)
            if canonical is None:
                first[key] = (row, variable, ambient_column)
                fiber_size[ambient_column] = 1
            else:
                canonical_row, canonical_variable, canonical_column = canonical
                if canonical_column != ambient_column:
                    raise AssertionError("product-column collision")
                duplicate_product.append(ambient_column)
                duplicate_row.append(row)
                duplicate_variable.append(variable)
                canonical_row_for_duplicate.append(canonical_row)
                canonical_variable_for_duplicate.append(canonical_variable)
                fiber_size[ambient_column] += 1

    canonical_records = sorted(
        first.values(), key=lambda item: int(degree4_position[item[2]])
    )
    canonical_row = np.asarray([item[0] for item in canonical_records], dtype=np.int32)
    canonical_variable = np.asarray([item[1] for item in canonical_records], dtype=np.int8)
    canonical_product = np.asarray([item[2] for item in canonical_records], dtype=np.int32)
    canonical_product_position = degree4_position[canonical_product]
    canonical_fiber_size = np.asarray(
        [fiber_size[int(column)] for column in canonical_product], dtype=np.int16
    )

    duplicate_product_array = np.asarray(duplicate_product, dtype=np.int32)
    duplicate_row_array = np.asarray(duplicate_row, dtype=np.int32)
    duplicate_variable_array = np.asarray(duplicate_variable, dtype=np.int8)
    canonical_row_for_duplicate_array = np.asarray(
        canonical_row_for_duplicate, dtype=np.int32
    )
    canonical_variable_for_duplicate_array = np.asarray(
        canonical_variable_for_duplicate, dtype=np.int8
    )
    duplicate_product_position = degree4_position[duplicate_product_array]
    # Stable deterministic schedule: process larger dp module terms first,
    # preserving pivot-row/variable scan within each product fiber.
    duplicate_schedule_order = np.argsort(
        duplicate_product_position, kind="stable"
    ).astype(np.int32)

    prolongations = base.RANK * base.NQ
    canonical_count = len(canonical_product)
    duplicate_count = len(duplicate_product_array)
    if prolongations != 398379:
        raise AssertionError("degree-four prolongation count drift")
    if canonical_count != 232326 or duplicate_count != 166053:
        raise AssertionError(
            f"degree-four fiber count drift: {canonical_count}, {duplicate_count}"
        )
    if canonical_count + duplicate_count != prolongations:
        raise AssertionError("fiber partition is incomplete")
    if int(canonical_fiber_size.sum()) != prolongations:
        raise AssertionError("fiber cardinalities do not sum to all prolongations")
    if len(np.unique(canonical_product)) != canonical_count:
        raise AssertionError("canonical products are not unique")
    if not np.all(np.diff(canonical_product_position) > 0):
        raise AssertionError("canonical products are not in dp order")

    # Replay every descriptor from its two source representations.  This is
    # the exact certificate that the recorded leading terms cancel.
    for index in range(duplicate_count):
        product_column = int(duplicate_product_array[index])
        component = product_column // len(q4)
        monomial = q4[product_column % len(q4)]
        for row, variable in (
            (int(duplicate_row_array[index]), int(duplicate_variable_array[index])),
            (
                int(canonical_row_for_duplicate_array[index]),
                int(canonical_variable_for_duplicate_array[index]),
            ),
        ):
            if int(pivot_components[row]) != component:
                raise AssertionError("descriptor crosses a module component")
            reconstructed = list(map(int, pivot_exponents[row]))
            reconstructed[variable] += 1
            if tuple(reconstructed) != monomial:
                raise AssertionError("descriptor product mismatch")

    # First shifted-M2 Buchberger layer.  The 690 systematic leading terms
    # leave 5 free variables in three components and 4 in eighteen.
    initial_pairs = 3 * (32 * 31 // 2) + 18 * (33 * 32 // 2)
    m2_degree2_ambient = 21 * 703
    m2_degree2_standard = 3 * 15 + 18 * 10
    m2_degree2_shadow = m2_degree2_ambient - m2_degree2_standard
    if (initial_pairs, m2_degree2_ambient, m2_degree2_standard) != (
        10992,
        14763,
        225,
    ):
        raise AssertionError("first-layer count drift")
    # The sealed full degree-two rank plus the triangular systematic-shadow
    # block forces the 10992-by-225 residual block to have rank exactly 225.
    residual_rank = basis_manifest["coefficient_matrix_rank"] - m2_degree2_shadow
    pure_m1_rows = initial_pairs - residual_rank
    if residual_rank != 225 or pure_m1_rows != base.RANK:
        raise AssertionError("first-layer rank split drift")

    np.savez_compressed(
        PACKET,
        prime=np.int32(base.P),
        nq=np.int32(base.NQ),
        degree3_rank=np.int32(base.RANK),
        degree4_order=degree4_order,
        canonical_row=canonical_row,
        canonical_variable=canonical_variable,
        canonical_product_column=canonical_product,
        canonical_product_order_position=canonical_product_position,
        canonical_fiber_size=canonical_fiber_size,
        duplicate_row=duplicate_row_array,
        duplicate_variable=duplicate_variable_array,
        duplicate_canonical_row=canonical_row_for_duplicate_array,
        duplicate_canonical_variable=canonical_variable_for_duplicate_array,
        duplicate_product_column=duplicate_product_array,
        duplicate_product_order_position=duplicate_product_position,
        duplicate_schedule_order=duplicate_schedule_order,
        degree3_profile_sha256=np.asarray(sha256(PROFILE)),
        full_p3_sha256=np.asarray(base.sha256(base.P3)),
    )

    payload = {
        "status": "PASS_EXACT_COMPACT_DEGREE4_DP_SCHEDULE",
        "prime": base.P,
        "first_shifted_m2_layer": {
            "same_component_spairs": initial_pairs,
            "degree2_m2_ambient_terms": m2_degree2_ambient,
            "systematic_shadow_pivots": m2_degree2_shadow,
            "free_free_standard_terms": m2_degree2_standard,
            "residual_10992_by_225_rank": residual_rank,
            "pure_m1_cubic_kernel_rows": pure_m1_rows,
            "rank_argument": (
                "The sealed 14763-rank degree-two M2 coefficient map contains "
                "a triangular 14538-pivot systematic shadow block; hence its "
                "225-column standard quotient has rank 225. Eliminating it from "
                "the 10992 same-component pairs leaves 10767 kernel rows."
            ),
        },
        "degree4_schedule": {
            "all_one_variable_prolongations": prolongations,
            "distinct_product_fibers": canonical_count,
            "canonical_rows": canonical_count,
            "star_tree_difference_rows": duplicate_count,
            "standard_columns_before_new_pivots": 316014,
            "maximum_fiber_size": int(canonical_fiber_size.max()),
            "fiber_size_histogram": {
                str(size): int(np.count_nonzero(canonical_fiber_size == size))
                for size in np.unique(canonical_fiber_size)
            },
            "packet": {
                "file": PACKET.name,
                "bytes": PACKET.stat().st_size,
                "sha256": sha256(PACKET),
            },
            "array_hashes": {
                "canonical_product_column": sha256_array(canonical_product),
                "duplicate_product_column": sha256_array(duplicate_product_array),
                "duplicate_schedule_order": sha256_array(duplicate_schedule_order),
            },
        },
        "coverage_proof": {
            "same_product_fiber": (
                "Replacing k prolongations by one canonical row and k-1 "
                "differences against it is a determinant-one row transform. "
                "Every omitted pair difference is the difference of two stored "
                "star-tree rows, so the complete degree-four Macaulay row space "
                "is preserved."
            ),
            "different_components": (
                "Module terms in different components never coincide; their "
                "module S-polynomial is zero, so no cross-component pair row is "
                "missing."
            ),
            "higher_lcm_degree": (
                "Pairs whose lcm has degree above four are deferred to that "
                "homogeneous layer, not discarded."
            ),
        },
        "inputs": {
            "degree3_dp_profile": {
                "file": PROFILE.name,
                "sha256": sha256(PROFILE),
            },
            "full_p3": {
                "path": str(base.P3),
                "sha256": base.sha256(base.P3),
            },
            "sealed_full_basis_manifest": {
                "path": str(FULL_BASIS_MANIFEST),
                "sha256": sha256(FULL_BASIS_MANIFEST),
            },
            "sealed_full_p3_manifest": {
                "path": str(FULL_P3_MANIFEST),
                "sha256": sha256(FULL_P3_MANIFEST),
            },
            "upstream_seal": {
                "path": str(UPSTREAM_SEAL),
                "sha256": sha256(UPSTREAM_SEAL),
            },
        },
        "scope": (
            "Exact combinatorial row-space schedule and first-layer rank split. "
            "No degree-four coefficient elimination, new pivot rank, target "
            "membership, or Stage-B conclusion is asserted."
        ),
    }
    MANIFEST.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
