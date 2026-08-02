#!/usr/bin/env python3
"""Independent verifier for the G/G2 universal all-degree packet.

The verifier checks the new theorem ledger and replays the upstream exact
35-coefficient reconstruction.  It does not read a stored verdict as evidence
for a rational point or pointlessness.
"""

from __future__ import annotations

import hashlib
from itertools import combinations_with_replacement
import json
from pathlib import Path
import subprocess
import sys
from typing import Iterable, Sequence


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
UPSTREAM = PROBLEM / "goals_2026-08-01" / "G_ALL_DEGREE"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def add(*vectors: Sequence[int]) -> tuple[int, ...]:
    require(bool(vectors), "add requires at least one vector")
    width = len(vectors[0])
    require(all(len(vector) == width for vector in vectors), "degree-vector width mismatch")
    return tuple(sum(vector[index] for vector in vectors) for index in range(width))


def scale(vector: Sequence[int], scalar: int) -> tuple[int, ...]:
    return tuple(scalar * value for value in vector)


def check_status_and_machine_ledger() -> None:
    status = (HERE / "STATUS.md").read_text()
    require(status.splitlines()[0] == "G2-FINITE-GENERATION-PASS", "wrong exit marker")
    for phrase in (
        "V(\\Phi)(K_{\\rm proj})",
        "**Headline problem:** **OPEN**",
        "symbolic multi-Rees",
        "projective Jacobian rank four",
    ):
        require(phrase in status, f"STATUS.md is missing {phrase!r}")

    theorem = json.loads((HERE / "theorem.json").read_text())
    require(theorem["schema"] == "G2_UNIVERSAL_ALL_DEGREE_V1", "wrong theorem schema")
    require(theorem["exit"] == "G2-FINITE-GENERATION-PASS", "machine exit mismatch")
    require(theorem["headline"] == "OPEN", "headline overclaim")
    require(theorem["theorem"]["equivalence"] is True, "equivalence not recorded")
    require(theorem["theorem"]["primitive_is_lattice_condition_not_linear_quotient"] is True,
            "primitive quotient boundary missing")
    require(theorem["theorem"]["symbolic_order_is_representative_dependent"] is True,
            "symbolic-order boundary missing")
    require(theorem["scope"]["symbolic_multi_rees_finite_generation_claimed"] is False,
            "symbolic multi-Rees overclaim")
    require(theorem["scope"]["finite_degree_cutoff_claimed"] is False,
            "finite degree cutoff overclaim")
    require(theorem["scope"]["generic_point_decided"] is False,
            "generic point overclaim")


def check_generic_cubic_payload() -> dict:
    payload = json.loads((UPSTREAM / "generic_cubic.json").read_text())
    require(payload["schema"] == "G_GENERIC_KLEIN_CUBIC_V1", "wrong upstream schema")
    require(payload["frame_names"] == ["x", "C", "D", "E", "K"], "wrong frame")
    require(payload["frame_degrees"] == [1, 4, 5, 6, 7], "wrong frame degrees")
    require(payload["primary_names"] == ["f3", "f5", "f6", "f8", "f11"],
            "wrong primary invariants")
    require(payload["primary_degrees"] == [3, 5, 6, 8, 11], "wrong primary degrees")
    require(payload["projective_base"] == ["t3", "t6", "t8", "t11"],
            "wrong projective base")
    require(payload["secondary_degrees"] == [0, 7, 9, 10, 12, 14, 14, 16, 18, 19, 21, 28],
            "wrong secondary degrees")

    coefficients = payload["coefficients"]
    require(payload["coefficient_count"] == 35 == len(coefficients),
            "the generic cubic must have 35 coefficients")
    expected = set(combinations_with_replacement(range(5), 3))
    seen: set[tuple[int, int, int]] = set()
    frame_degrees = payload["frame_degrees"]
    primary_degrees = payload["primary_degrees"]
    secondary_degrees = payload["secondary_degrees"]

    for coefficient in coefficients:
        triple = tuple(coefficient["triple"])
        require(triple in expected and triple not in seen, "bad or repeated cubic triple")
        seen.add(triple)
        coefficient_degree = sum(frame_degrees[index] for index in triple)
        require(coefficient["degree"] == coefficient_degree, "wrong polar coefficient degree")
        require(len(coefficient["entries"]) == len(coefficient["normalized_entries"]),
                "affine/projective term-count mismatch")

        for affine, normalized in zip(coefficient["entries"], coefficient["normalized_entries"]):
            require(affine["secondary"] == normalized["secondary"],
                    "secondary changed under normalization")
            require((affine["numerator"], affine["denominator"])
                    == (normalized["numerator"], normalized["denominator"]),
                    "scalar changed under normalization")
            a3, a5, a6, a8, a11 = affine["primary_exponents"]
            require(normalized["projective_exponents"] == [a3 + 2 * a5, a6, a8, a11],
                    "f5/tau^5=t3^2 normalization failed")
            term_degree = sum(
                exponent * degree
                for exponent, degree in zip(affine["primary_exponents"], primary_degrees)
            ) + secondary_degrees[affine["secondary"]]
            require(term_degree == coefficient_degree, "basis term has wrong source degree")

    require(seen == expected, "incomplete symmetric cubic triple ledger")
    return payload


def check_abstract_degree_clearing(frame_degrees: Iterable[int], law_degree: int) -> None:
    degrees = tuple(frame_degrees)
    count = len(degrees)
    # Coordinates: constant, delta_0,...,delta_(s-1), d.
    width = count + 2

    def constant(value: int) -> tuple[int, ...]:
        return (value,) + (0,) * (width - 1)

    def variable(index: int) -> tuple[int, ...]:
        result = [0] * width
        result[index] = 1
        return tuple(result)

    zero = constant(0)
    denominator_degrees = [variable(index + 1) for index in range(count)]
    landing_degree = variable(width - 1)
    common_degree = add(*denominator_degrees)

    # Forward direction: deg(n_i)=delta_i-e_i and h=prod d_i.
    cleared_coefficient_degrees: list[tuple[int, ...]] = []
    for index, frame_degree in enumerate(degrees):
        numerator_degree = add(denominator_degrees[index], constant(-frame_degree))
        cleared = add(numerator_degree, common_degree, scale(denominator_degrees[index], -1))
        require(cleared == add(common_degree, constant(-frame_degree)),
                "forward coefficient degree failed")
        require(add(cleared, constant(frame_degree)) == common_degree,
                "forward summands do not have one degree")
        cleared_coefficient_degrees.append(cleared)

    for triple in combinations_with_replacement(range(count), law_degree):
        coefficient_degree = sum(degrees[index] for index in triple)
        term_degree = add(
            *(cleared_coefficient_degrees[index] for index in triple),
            constant(coefficient_degree),
        )
        require(term_degree == scale(common_degree, law_degree),
                "forward polynomial-law degree failed")

    # Reverse direction: deg(c_i)=d-e_i and a_i=c_i*tau^(e_i-d) has degree zero.
    reverse_coefficient_degrees: list[tuple[int, ...]] = []
    for frame_degree in degrees:
        coefficient_degree = add(landing_degree, constant(-frame_degree))
        normalized_degree = add(
            coefficient_degree,
            constant(frame_degree),
            scale(landing_degree, -1),
        )
        require(normalized_degree == zero, "reverse normalized coefficient is not degree zero")
        reverse_coefficient_degrees.append(coefficient_degree)

    for triple in combinations_with_replacement(range(count), law_degree):
        coefficient_degree = sum(degrees[index] for index in triple)
        affine_degree = add(
            *(reverse_coefficient_degrees[index] for index in triple),
            constant(coefficient_degree),
        )
        require(affine_degree == scale(landing_degree, law_degree),
                "reverse polynomial-law degree failed")


def check_document_scope() -> None:
    all_degree = " ".join((HERE / "ALL_DEGREE_THEOREM.md").read_text().split())
    noetherianity = " ".join((HERE / "NOETHERIANITY.md").read_text().split())
    universal = " ".join((HERE / "UNIVERSAL_OBJECT.md").read_text().split())
    decision = " ".join((HERE / "DECISION.md").read_text().split())

    for phrase in (
        "No highest-component extraction is used",
        "Scalar saturation and primitive representatives",
        "Multiplication and precomposition",
        "does not algebraize an arbitrary compatible-looking local inverse-limit state",
        "M\\cap \\ell",
    ):
        require(phrase in all_degree, f"all-degree proof missing {phrase!r}")

    for phrase in (
        "What is not claimed",
        "Exact counterexample to the degree-cutoff inference",
        "symbolic multi-Rees finite-generation statement",
    ):
        require(phrase in noetherianity, f"noetherianity scope missing {phrase!r}")

    require("not a collection of independently chosen fixed-locus restrictions" in universal,
            "global-image boundary missing")
    require("is not an invariant of the projective generic point" in universal,
            "representative-wise symbolic order missing")
    require("map must have Jacobian rank four" in decision, "positive dominance gate missing")
    require("source-exhaustiveness" in decision, "negative bridge gate missing")


def check_upstream_replay() -> None:
    verifier = UPSTREAM / "verify_universal_object.py"
    require(verifier.is_file(), "upstream universal-object verifier missing")
    completed = subprocess.run(
        [sys.executable, str(verifier)],
        cwd=PROBLEM,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if completed.returncode != 0:
        sys.stdout.write(completed.stdout)
        raise AssertionError("upstream exact generic-cubic replay failed")


def check_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal["schema"] == "G2_UNIVERSAL_SEAL_V1", "wrong seal schema")
    require(seal["exit"] == "G2-FINITE-GENERATION-PASS", "seal exit mismatch")
    for relative, expected in seal["artifacts"].items():
        path = HERE / relative
        require(path.is_file(), f"sealed artifact missing: {relative}")
        require(sha256(path) == expected, f"sealed hash mismatch: {relative}")


def main() -> None:
    check_status_and_machine_ledger()
    payload = check_generic_cubic_payload()
    check_abstract_degree_clearing(payload["frame_degrees"], 3)
    check_document_scope()
    check_upstream_replay()
    check_seal()
    print("G2_UNIVERSAL_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
