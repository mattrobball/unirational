#!/usr/bin/env python3
"""Verify the scoped PC.1 representation-character ledger.

This verifier deliberately does not manufacture an action on the six named
K-coordinates.  It checks the canonical trivial action on the coefficient
multiplicity space, recomputes the genuinely installed D12 source/jet
characters, and exhausts all 6! pure-K coordinate permutations against the
sealed rewrite tensor.
"""

from __future__ import annotations

import hashlib
import json
from fractions import Fraction
from itertools import permutations
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
LEDGER = HERE / "REPRESENTATION_CHARACTERS.json"
RESULT = HERE / "verify_representation_characters_result.json"
P = 89


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % prime
    row = 0
    for column in range(work.shape[1]):
        pivots = np.flatnonzero(work[row:, column])
        if not len(pivots):
            continue
        pivot = row + int(pivots[0])
        if pivot != row:
            work[[row, pivot]] = work[[pivot, row]]
        work[row] = work[row] * pow(int(work[row, column]), -1, prime) % prime
        for other in range(work.shape[0]):
            if other != row and work[other, column]:
                work[other] = (
                    work[other] - int(work[other, column]) * work[row]
                ) % prime
        row += 1
        if row == work.shape[0]:
            break
    return row


def d12_character(label: str, element: tuple[int, int]) -> int:
    reflection, exponent = element
    if label.startswith("chi"):
        rotation_sign = int(label[3])
        reflection_sign = int(label[4])
        return (-1) ** (
            rotation_sign * exponent + reflection_sign * reflection
        )
    if reflection:
        return 0
    if label == "rho1":
        return (2, 1, -1, -2, -1, 1)[exponent]
    if label == "rho2":
        return (2, -1, -1, 2, -1, -1)[exponent]
    raise KeyError(label)


def d12_product(
    left: tuple[int, int], right: tuple[int, int]
) -> tuple[int, int]:
    e, i = left
    f, j = right
    return ((e + f) % 2, ((-1) ** f * i + j) % 6)


def d12_power(element: tuple[int, int], exponent: int) -> tuple[int, int]:
    result = (0, 0)
    for _ in range(exponent):
        result = d12_product(result, element)
    return result


def representation_character(label: str, element: tuple[int, int]) -> int:
    if label == "W":
        return sum(d12_character(part, element) for part in ("chi00", "rho2", "rho1"))
    if label == "E_plus":
        return d12_character("chi00", element) + d12_character("rho2", element)
    if label == "E_minus":
        return d12_character("rho1", element)
    return d12_character(label, element)


def symmetric_character(label: str, degree: int, element: tuple[int, int]) -> int:
    complete = [Fraction(1)]
    for n in range(1, degree + 1):
        numerator = sum(
            Fraction(representation_character(label, d12_power(element, k)))
            * complete[n - k]
            for k in range(1, n + 1)
        )
        complete.append(numerator / n)
    assert complete[-1].denominator == 1
    return complete[-1].numerator


def d12_block_dimensions(degree: int, normal_order: int) -> dict[str, int]:
    elements = [(reflection, exponent) for reflection in range(2) for exponent in range(6)]
    result: dict[str, int] = {}
    for target in ("chi00", "rho2", "rho1"):
        total = Fraction(0)
        for element in elements:
            # Hom_H(Sym^(d-j)(E+) tensor Sym^j(E-), target).
            total += Fraction(
                symmetric_character("E_plus", degree - normal_order, element)
                * symmetric_character("E_minus", normal_order, element)
                * d12_character(target, element),
                12,
            )
        assert total.denominator == 1
        result[target] = total.numerator
    return result


def permute_exponents(exponents: tuple[int, ...], permutation: tuple[int, ...]) -> tuple[int, ...]:
    output = [0] * len(exponents)
    for old, value in enumerate(exponents):
        output[permutation[old]] = value
    return tuple(output)


def main() -> None:
    ledger = json.loads(LEDGER.read_text())
    inputs = ledger["inputs"]
    for relative, expected in inputs.items():
        path = HERE / relative if not relative.startswith("../") else (HERE / relative).resolve()
        assert path.is_file(), path
        assert sha256_file(path) == expected, path

    molien = json.loads((ROOT / "certificates/degree25_molien/molien_values.json").read_text())
    assert molien["group_order"] == 660
    assert molien["self_covariants"]["c_25"] == 189
    v25 = molien["v25_invariants_vs_covariants"]
    assert v25["project_V_25"] == 43
    assert v25["same_object"] is False
    assert "subspace of self-covariants" in v25["argument"]

    change = np.load(ROOT / "certificates/degree25_exact/change_of_basis/matrices_multiprime.npz")
    assert change["Q_rows_p89"].shape == (37, 43)
    assert change["K_rows_p89"].shape == (6, 43)
    assert rank_mod(change["frame_QK_p89"], P) == 43

    class_count = ledger["coefficient_side_PSL2_11"]["class_count"]
    assert class_count == 8
    for record in ledger["coefficient_side_PSL2_11"]["trivial_character_ledger"]:
        dimension = record["dimension"]
        assert record["character"] == [dimension] * class_count

    finite = ROOT / "certificates/degree25_finite_module"
    basis_payload = json.loads((finite / "basis_B.json").read_text())
    basis = [tuple(item) for item in basis_payload["B"]]
    assert len(basis) == 28
    assert [sum(item) for item in basis] == basis_payload["Bdeg"]
    assert max(basis_payload["Bdeg"]) == 2
    assert all(3 - degree >= 1 for degree in basis_payload["Bdeg"])

    rewrite = np.load(finite / "rewrite_rules.npz")
    relation = np.load(finite / "relation_matrix.npz")
    multiplication = np.load(finite / "multiplication_matrices.npz")
    assert rewrite["k_exp"].shape == (56, 6)
    assert np.all(np.sum(rewrite["k_exp"], axis=1) == 3)
    assert relation["seed_F3"].shape == (690, 14134)
    assert multiplication["low_target"].shape == (6, 28)
    assert multiplication["T_quad_F3"].shape == (6, 21, 14134)
    for archive in (change, rewrite, relation, multiplication):
        assert not any(
            token in key.lower()
            for key in archive.files
            for token in ("group_action", "action_matrix", "character_table")
        )

    coupled = json.loads((HERE / "pc1_coupled_degree4.json").read_text())
    assert coupled["candidate_ledger"]["transition_rows"] == 4140
    assert coupled["candidate_ledger"]["quadratic_commutator_rows_raw"] == 315
    assert coupled["candidate_ledger"]["quadratic_commutator_rank"] == 210
    assert coupled["candidate_ledger"]["quadratic_commutator_cycle_syzygies"] == 105
    assert coupled["full_degree4"]["new_generators_total"] == 4350
    assert coupled["full_degree4"]["rank"] == 29880

    # Exhaust the tempting but false pure-K S6 symmetry, keeping Q fixed.
    k_exponents = rewrite["k_exp"].astype(int)
    tails = rewrite["tail_F3"]
    offsets = rewrite["off3"].astype(int)
    basis_index = {item: index for index, item in enumerate(basis)}
    rule_index = {tuple(item): index for index, item in enumerate(k_exponents)}
    keepers: list[tuple[int, ...]] = []
    for permutation in permutations(range(6)):
        rule_map = [
            rule_index[permute_exponents(tuple(item), permutation)]
            for item in k_exponents
        ]
        basis_map = [basis_index[permute_exponents(item, permutation)] for item in basis]
        preserves = True
        for source_rule, target_rule in enumerate(rule_map):
            for source_basis, target_basis in enumerate(basis_map):
                if not np.array_equal(
                    tails[source_rule, offsets[source_basis] : offsets[source_basis + 1]],
                    tails[target_rule, offsets[target_basis] : offsets[target_basis + 1]],
                ):
                    preserves = False
                    break
            if not preserves:
                break
        if preserves:
            keepers.append(permutation)
    assert keepers == [tuple(range(6))]
    assert ledger["K_coordinate_permutation_audit"]["preserving_permutations"] == [
        list(range(6))
    ]

    # Recompute the actual nontrivial D12 source/jet character data.
    class_representatives = [(0, 0), (0, 3), (0, 1), (0, 2), (1, 0), (1, 1)]
    for label in ("chi00", "chi01", "chi10", "chi11", "rho1", "rho2"):
        values = [d12_character(label, element) for element in class_representatives]
        assert values == ledger["D12_source_jet_only"]["irreducible_characters"][label]
    for label in ("W", "E_plus", "E_minus"):
        values = [representation_character(label, element) for element in class_representatives]
        assert values == ledger["D12_source_jet_only"]["installed_characters"][label]
    assert d12_block_dimensions(25, 0) == {"chi00": 65, "rho2": 117, "rho1": 0}
    assert d12_block_dimensions(25, 1) == {"chi00": 0, "rho2": 0, "rho1": 217}

    local = json.loads((HERE / "imports_pc1/results_d25.json").read_text())
    computation = local["degree_computation"]
    assert computation["ordinary_target_blocks"] == {"chi00": 65, "rho1": 0, "rho2": 117}
    assert computation["restriction_block_ranks"] == {"chi00": 56, "rho1": 0, "rho2": 102}
    assert computation["first_jet_target_blocks"] == {"chi00": 0, "rho1": 217, "rho2": 0}
    assert computation["full_first_jet_block_ranks_on_kernel"] == {
        "chi00": 0,
        "rho1": 56,
        "rho2": 0,
    }

    minimality = ledger["minimality_boundary"]
    assert minimality["B_is_minimal_S_generating_carrier"] is True
    assert minimality["transition_stable_relation_presentation_is_minimal"] is False
    assert minimality["stabilization_proved_by_this_representation_packet"] is False
    assert minimality["finite_nonminimal_stabilization_proved_elsewhere"] is True

    result = {
        "ok": True,
        "status": "PASS_PC1_REPRESENTATION_CHARACTERS_SCOPED",
        "prime": P,
        "coefficient_side_group": "PSL_2(F_11)",
        "coefficient_side_class_count": class_count,
        "coefficient_side_action": "trivial",
        "pure_K_permutations_tested": 720,
        "pure_K_permutations_preserving_rewrite_tensor": [list(item) for item in keepers],
        "minimal_state_carrier_dimension": 28,
        "transition_stabilization_replayed_by_this_verifier": False,
        "finite_nonminimal_stabilization_proved_by_separate_border_packet": True,
        "theorem_boundary": ledger["theorem_boundary"],
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")

    print("PASS_PC1_REPRESENTATION_CHARACTERS_SCOPED")
    print("PASS_ONLY_IDENTITY_PURE_K_PERMUTATION")
    print("PASS_MINIMAL_28_STATE_CARRIER_SCOPED")


if __name__ == "__main__":
    main()
