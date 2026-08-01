#!/usr/bin/env python3
"""Dimension and monomial-order audit for a compact Stage-B certificate.

This performs no large rank computation.  It records exact dimensions for
the full linear-syzygy contraction module and the smallest natural
irrelevant-radical certificate: one pure-power leading term (or actual
membership) for each of 37 variables and 6 module components.
"""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
P = 89
NQ = 37
NB = 6
NSEED = 690
K1 = 10767


def monomials(degree: int) -> int:
    return math.comb(NQ - 1 + degree, degree)


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    degree3 = weak_compositions(3, NQ)
    degree3_index = {exponent: i for i, exponent in enumerate(degree3)}
    # Under term-over-position with the repository weak-composition order, a
    # dense generic K1-row image would pivot on 1794 complete monomial blocks
    # (six components each), plus three positions in the next block.
    complete_blocks = K1 // NB
    cubes_in_prefix = []
    cube_indices = []
    for variable in range(NQ):
        cube = tuple(3 if i == variable else 0 for i in range(NQ))
        position = degree3_index[cube]
        cube_indices.append(position)
        if position < complete_blocks:
            cubes_in_prefix.append(variable)

    relation = P25.parents[1] / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
    with np.load(relation, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"]
        offsets = frozen["off3"]
        if int(frozen["prime"]) != P or seeds.shape != (NSEED, 14134):
            raise AssertionError("unexpected sealed relation tensor")
        m1_nonzeros = sum(
            int(np.count_nonzero(seeds[:, int(offsets[1 + j]) : int(offsets[2 + j])]))
            for j in range(NB)
        )
        m2_nonzeros = sum(
            int(np.count_nonzero(seeds[:, int(offsets[7 + j]) : int(offsets[8 + j])]))
            for j in range(21)
        )
    m1_entries = NSEED * NB * monomials(2)
    m2_entries = NSEED * 21 * monomials(1)
    degree5_source = K1 * monomials(2)
    degree5_target = NB * monomials(5)
    direct_unknowns = NSEED * monomials(3)
    pure_power_targets = NQ * NB
    payload = {
        "prime": P,
        "variables": NQ,
        "module_components": NB,
        "full_linear_syzygy_dimension": K1,
        "graded_dimensions": {
            str(degree): {
                "source_K1_times_S": K1 * monomials(degree - 3),
                "target_Sd_times_6": NB * monomials(degree),
            }
            for degree in (3, 4, 5)
        },
        "compact_radical_certificate": {
            "pure_power_targets": pure_power_targets,
            "criterion": (
                "For one fixed global module order, LT(N) must contain a pure "
                "power of every q_i in every component; alternatively certify "
                "the 222 actual memberships q_i^n e_j in N."
            ),
            "natural_lower_bound": (
                "Each component of an irrelevant-primary monomial module needs "
                "a pure power of each of 37 variables, hence at least 37 leading "
                "generators per component and 222 total."
            ),
        },
        "direct_degree3_left_syzygy_operator": {
            "unknown_D_in_S3_times_690": direct_unknowns,
            "constraint_D_M2_in_S4_times_21": 21 * monomials(4),
            "output_D_M1_in_S5_times_6": degree5_target,
            "combined_output": 21 * monomials(4) + degree5_target,
            "M1_seed_entries": m1_entries,
            "M1_seed_nonzeros": m1_nonzeros,
            "M1_seed_density": m1_nonzeros / m1_entries,
            "M2_seed_entries": m2_entries,
            "M2_seed_nonzeros": m2_nonzeros,
            "M2_seed_density": m2_nonzeros / m2_entries,
            "exact_shifted_operator_nonzeros": monomials(3)
            * (m1_nonzeros + m2_nonzeros),
            "note": (
                "Solving D M2=0 and D M1=q_i^5 e_j permits all degree-3 left "
                "syzygies, so it is safe and potentially stronger than products "
                "of the degree-1 syzygies."
            ),
        },
        "storage_floors": {
            "full_syzygy_basis_uint8_bytes": K1 * NSEED * NQ,
            "full_contractions_uint8_bytes": K1 * NB * monomials(3),
            "dense_degree5_macaulay_uint8_entries": degree5_source * degree5_target,
            "one_dense_K1_times_S2_lift_uint8_bytes": degree5_source,
            "222_dense_K1_times_S2_lifts_uint8_bytes": pure_power_targets
            * degree5_source,
            "one_dense_direct_D_lift_uint8_bytes": direct_unknowns,
            "222_dense_direct_D_lifts_uint8_bytes": pure_power_targets
            * direct_unknowns,
            "warning": (
                "These are value-byte floors only. Sparse formats also need indices; "
                "a useful certificate must exploit sparsity, shared row-operation DAGs, "
                "or an exact representation block decomposition."
            ),
        },
        "term_over_position_prefix_probe": {
            "complete_cubic_monomial_blocks": complete_blocks,
            "pure_cube_indices_in_repository_order": cube_indices,
            "pure_cubes_in_first_complete_blocks": cubes_in_prefix,
            "missing_pure_cubes": [i for i in range(NQ) if i not in cubes_in_prefix],
            "consequence": (
                "The degree-3 generic-prefix leading shadow cannot be irrelevant-"
                "primary; degree-4/5 completion or actual memberships are required."
            ),
        },
        "source": {
            "relation_matrix": str(relation),
            "relation_matrix_sha256": sha256(relation),
        },
    }
    target = HERE / "compact_degree5_plan.json"
    target.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
