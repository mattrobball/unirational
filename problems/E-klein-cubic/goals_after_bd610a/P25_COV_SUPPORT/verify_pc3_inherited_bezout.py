#!/usr/bin/env python3
"""Replay the sealed inherited degree-31/35 PC.3 evidence.

This verifier is deliberately narrow.  It pins the accepted 182-record
COV_M1_DEG31_35_WORK seal and rehashes the load-bearing local snapshot,
independently recomputes the two F_419[u] Bezout identities, and derives the
remaining characteristic-zero affine-chart counts from the snapshotted branch
records.

It does not construct a common-factor or composition incidence locus, perform
any of the open affine saturations, or decide the degree-31/35 landing schemes.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
COV_PACKET = HERE / "imports_pc3"
OUTPUT = HERE / "verify_pc3_inherited_bezout_result.json"

EXPECTED_SEAL_SHA256 = (
    "c4b254e1a980fd8af83f2e12d584f7d7748da65a1c480681fc9f102629580847"
)
EXPECTED_SEAL_RECORDS = 182
EXPECTED_PRIMITIVE_COUNTEREXAMPLE_SHA256 = (
    "8acef970d0ea95d964623bc9a44808da757f0c20214a77b7cf4714bbcec932a0"
)
EXPECTED_SUMMANDS = {"31": [0, 9], "35": [0, 18]}
PRIME = 419
REQUIRED_SEALED_PATHS = {
    "COMPLETION_AUDIT.md",
    "STATUS.md",
    "canonical_bases.json",
    "landing_ideals.json",
    "primitive_module.json",
    "primitive_quotient_counterexample.json",
    "c3_reduced_landing.json",
    "c3_second_normal_gate.json",
    "c3_deep_normal_gate.json",
    "d31_third_pure_msolve.json",
    "p25_dependency_localization.json",
    "p25_d31_pure_second_cubic_span.json",
    "p25_common_branch_b_msolve.json",
    "degree_31/fixed_invariant_multiple_basis.json",
    "degree_35/fixed_invariant_multiple_basis.json",
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 22):
            digest.update(block)
    return digest.hexdigest()


def load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def trim(polynomial: list[int]) -> list[int]:
    output = [coefficient % PRIME for coefficient in polynomial]
    while len(output) > 1 and output[-1] == 0:
        output.pop()
    return output


def multiply(left: list[int], right: list[int]) -> list[int]:
    product = [0] * (len(left) + len(right) - 1)
    for left_degree, left_coefficient in enumerate(left):
        for right_degree, right_coefficient in enumerate(right):
            degree = left_degree + right_degree
            product[degree] = (
                product[degree] + left_coefficient * right_coefficient
            ) % PRIME
    return product


def add(left: list[int], right: list[int]) -> list[int]:
    length = max(len(left), len(right))
    output = [0] * length
    for index in range(length):
        output[index] = (
            (left[index] if index < len(left) else 0)
            + (right[index] if index < len(right) else 0)
        ) % PRIME
    return trim(output)


def verify_seal() -> tuple[dict, dict[str, str]]:
    seal_path = COV_PACKET / "SEAL.json"
    assert sha256_file(seal_path) == EXPECTED_SEAL_SHA256
    seal = load_json(seal_path)
    assert seal["schema"] == "cov-m1-content-seal-v1"
    assert seal["exit"] == "COV-UNDECIDED"
    assert len(seal["files"]) == EXPECTED_SEAL_RECORDS
    assert "remaining affine chart saturations" in seal["theorem_boundary"]
    assert "51-dimensional P25 branch A remain open" in seal["theorem_boundary"]

    sealed_records: dict[str, str] = {}
    for record in seal["files"]:
        sealed_records[record["path"]] = record["sha256"]
    assert len(sealed_records) == EXPECTED_SEAL_RECORDS
    assert REQUIRED_SEALED_PATHS <= sealed_records.keys()

    packet_root = COV_PACKET.resolve()
    sealed_hashes: dict[str, str] = {}
    for relative_text in sorted(REQUIRED_SEALED_PATHS):
        relative = Path(relative_text)
        assert not relative.is_absolute() and ".." not in relative.parts
        artifact = (COV_PACKET / relative).resolve()
        assert artifact.is_relative_to(packet_root) and artifact.is_file()
        actual = sha256_file(artifact)
        assert actual == sealed_records[relative_text], (
            relative_text,
            actual,
            sealed_records[relative_text],
        )
        sealed_hashes[relative_text] = actual
    assert len(sealed_hashes) == len(REQUIRED_SEALED_PATHS)
    return seal, sealed_hashes


def verify_bezout(sealed_hashes: dict[str, str]) -> dict:
    relative = "primitive_quotient_counterexample.json"
    assert sealed_hashes[relative] == EXPECTED_PRIMITIVE_COUNTEREXAMPLE_SHA256
    certificate = load_json(COV_PACKET / relative)
    assert certificate["schema"] == "cov-m1-primitive-quotient-counterexample-v1"
    assert certificate["prime"] == PRIME
    assert certificate["zeta11"] == 13

    degree_results: dict[str, dict] = {}
    for degree in ("31", "35"):
        record = certificate["degrees"][degree]
        assert record["summand_indices"] == EXPECTED_SUMMANDS[degree]
        assert record["sum_membership"] == "p=p_i+p_j lies in N_d=(R_+ K1)_d"
        assert record["nonzero_at_infinity"] is True
        bezout = record["bezout_coefficients_ascending"]
        components = record["component_polynomials_coefficients_ascending"]
        assert len(bezout) == len(components) == 5

        identity = [0]
        for multiplier, component in zip(bezout, components, strict=True):
            identity = add(identity, multiply(multiplier, component))
        assert identity == [1]

        positive_basis = record["positive_basis"]
        assert sealed_hashes[positive_basis] == record["positive_basis_sha256"]
        degree_results[degree] = {
            "bezout_identity_coefficients_ascending_mod419": identity,
            "component_count": len(components),
            "nonzero_at_infinity": True,
            "positive_multiple_basis_sha256": record["positive_basis_sha256"],
            "summand_indices": record["summand_indices"],
        }
    return degree_results


def derive_open_chart_counts() -> dict:
    c3 = load_json(COV_PACKET / "c3_reduced_landing.json")
    second = load_json(COV_PACKET / "c3_second_normal_gate.json")
    deep = load_json(COV_PACKET / "c3_deep_normal_gate.json")
    d31_msolve = load_json(COV_PACKET / "d31_third_pure_msolve.json")

    prime_components: dict[int, dict[str, dict[str, int]]] = {}
    for prime_record in deep["prime_records"]:
        prime = prime_record["prime"]
        degrees = prime_record["degrees"]
        prime_components[prime] = {
            "31": {
                "c3_nonbased": c3["degrees"]["31"]["nonbased_chart_count"],
                "first_normal_tangent": degrees["31"]
                ["first_normal_nonbased_tangent"]["leading_scalar_rank"],
                "pure_second": second["degrees"]["31"]
                ["pure_nonbased_chart_count"],
                "mixed_second_tangent": degrees["31"]
                ["second_mixed_nonbased_tangent"]["leading_scalar_rank"],
                "pure_third": degrees["31"]["third_normal"]["pure_scalar_rank"],
                "mixed_third_tangent": 0,
            },
            "35": {
                "c3_nonbased": c3["degrees"]["35"]["nonbased_chart_count"],
                "first_normal_tangent": degrees["35"]
                ["first_normal_nonbased_tangent"]["leading_scalar_rank"],
                "pure_second": second["degrees"]["35"]
                ["pure_nonbased_chart_count"],
                "mixed_second_tangent": degrees["35"]
                ["second_mixed_nonbased_tangent"]["leading_scalar_rank"],
                "pure_third": degrees["35"]["third_normal"]["pure_scalar_rank"],
                "mixed_third_tangent": degrees["35"]
                ["third_mixed_nonbased_tangent"]["leading_scalar_rank"],
            },
        }

    assert sorted(prime_components) == [463, 727]
    assert prime_components[463] == prime_components[727]
    components = prime_components[463]
    assert components["31"] == {
        "c3_nonbased": 10,
        "first_normal_tangent": 15,
        "pure_second": 7,
        "mixed_second_tangent": 9,
        "pure_third": 6,
        "mixed_third_tangent": 0,
    }
    assert components["35"] == {
        "c3_nonbased": 12,
        "first_normal_tangent": 9,
        "pure_second": 24,
        "mixed_second_tangent": 16,
        "pure_third": 31,
        "mixed_third_tangent": 9,
    }

    # Two degree-31 pure-third charts close only in F_463.  They remain part of
    # the six-chart characteristic-zero cover and therefore are not subtracted.
    assert len(d31_msolve["closed_charts"]) == 2
    assert d31_msolve["remaining_cover"]["normalization_chart_count"] == 4
    assert d31_msolve["leading_scalar_rank"] == 6
    assert "all six" in d31_msolve["scope"]
    assert "remain open" in d31_msolve["scope"]

    totals = {degree: sum(values.values()) for degree, values in components.items()}
    assert totals == {"31": 47, "35": 101}
    return {
        degree: {
            "components": components[degree],
            "open_characteristic_zero_affine_charts": totals[degree],
        }
        for degree in ("31", "35")
    }


def build_result() -> dict:
    seal, sealed_hashes = verify_seal()
    bezout = verify_bezout(sealed_hashes)
    chart_counts = derive_open_chart_counts()

    primitive_module = load_json(COV_PACKET / "primitive_module.json")
    assert "actual factorable and composition incidence loci" in primitive_module[
        "required_landing_operation"
    ]
    completion_audit = (COV_PACKET / "COMPLETION_AUDIT.md").read_text(
        encoding="utf-8"
    )
    assert "actual factor/composition incidence saturation remains open" in completion_audit

    return {
        "bezout_replay": bezout,
        "inherited_open_chart_cover": chart_counts,
        "ok": True,
        "seal": {
            "exit": seal["exit"],
            "source_records": EXPECTED_SEAL_RECORDS,
            "snapshot_records_rehashed": len(sealed_hashes),
            "sha256": EXPECTED_SEAL_SHA256,
            "theorem_boundary": seal["theorem_boundary"],
        },
        "status": "PASS_INDEPENDENT_PC3_INHERITED_BEZOUT_REPLAY",
        "theorem_boundary": {
            "does_not_prove": (
                "No actual common-factor, invariant-multiple scheme-image, "
                "primitive-quartic/lower-map composition, or named-ansatz incidence "
                "locus is constructed here; no remaining affine chart is saturated "
                "away from their union; no degree-31 or degree-35 survivor or "
                "degree-wide emptiness statement follows; and the inherited fixed "
                "59-dimensional K1_25 multiplier analysis is not the authoritative "
                "current PC.2 scheme image. PC-FACTOR-INCIDENCE-PASS and all PC.3 "
                "positive/empty exits remain unauthorized."
            ),
            "proves": (
                "The pinned load-bearing snapshot from the 182-record inherited COV "
                "packet is hash-intact; its two "
                "F_419[u] Bezout identities equal 1, so the displayed positive-"
                "multiple sums have component gcd one and refute the false linear "
                "primitive quotient; its branch records leave 47 and 101 "
                "characteristic-zero affine charts in degrees 31 and 35."
            ),
            "required_goal_status": "PC-UNDECIDED",
        },
    }


def main() -> None:
    result = build_result()
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps(result, indent=2, sort_keys=True))
    print("PASS_INDEPENDENT_PC3_INHERITED_BEZOUT_REPLAY")


if __name__ == "__main__":
    main()
