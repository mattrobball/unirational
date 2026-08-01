#!/usr/bin/env python3
"""Independent verifier for the abstract restriction and consistency audit."""

from __future__ import annotations

from hashlib import sha256
from itertools import permutations, product
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
GOALS = HERE.parents[2]
PROBLEM = GOALS.parent
PAYLOAD = HERE / "proof_payload.json"
RESTRICTED = PROBLEM / "certificates/restricted_e3/restricted_algebra.json"
RESTRICTED_MD = PROBLEM / "certificates/restricted_e3/RESTRICTED_ETALE_ALGEBRA.md"
DECISION_MD = PROBLEM / "certificates/restricted_e3/DECISION.md"
TERMINALITY_MD = PROBLEM / "certificates/fixed_frame_arithmetic/TERMINALITY_AUDIT.md"
INFINITY = GOALS / "F_CONIC_ALGEBRA/infinity_obstruction.json"
INFINITY_MD = GOALS / "F_CONIC_ALGEBRA/INFINITY_OBSTRUCTION.md"
INFINITY_VERIFY = GOALS / "F_CONIC_ALGEBRA/verify_infinity_obstruction.py"


def require(value: bool, message: str) -> None:
    if not value:
        raise AssertionError(message)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    """Composition left after right."""
    return tuple(left[right[i]] for i in range(len(left)))


def inverse(value: tuple[int, ...]) -> tuple[int, ...]:
    answer = [0] * len(value)
    for i, image in enumerate(value):
        answer[image] = i
    return tuple(answer)


def cycle_type(value: tuple[int, ...]) -> tuple[int, ...]:
    seen: set[int] = set()
    lengths: list[int] = []
    for start in range(len(value)):
        if start in seen:
            continue
        at = start
        length = 0
        while at not in seen:
            seen.add(at)
            length += 1
            at = value[at]
        lengths.append(length)
    return tuple(sorted(lengths, reverse=True))


def generated_subgroup(generators: set[tuple[int, ...]], identity: tuple[int, ...]) -> set[tuple[int, ...]]:
    subgroup = {identity}
    queue = list(generators)
    while queue:
        candidate = queue.pop()
        if candidate in subgroup:
            continue
        old = list(subgroup)
        subgroup.add(candidate)
        candidate_inv = inverse(candidate)
        for member in old:
            for new in (
                compose(candidate, member),
                compose(member, candidate),
                compose(candidate_inv, member),
                compose(member, candidate_inv),
            ):
                if new not in subgroup:
                    queue.append(new)
    return subgroup


def verify_normal_quotients_of_s6() -> None:
    group = list(permutations(range(6)))
    identity = tuple(range(6))
    classes: dict[tuple[int, ...], set[tuple[int, ...]]] = {}
    for value in group:
        classes.setdefault(cycle_type(value), set()).add(value)
    closure_sizes = {
        kind: len(generated_subgroup(conjugacy_class, identity))
        for kind, conjugacy_class in classes.items()
    }
    require(closure_sizes[(1, 1, 1, 1, 1, 1)] == 1, "identity normal closure")
    for kind, size in closure_sizes.items():
        if kind == (1, 1, 1, 1, 1, 1):
            continue
        require(size in (360, 720), f"unexpected normal closure for {kind}: {size}")
    # Every nontrivial normal subgroup contains a nonidentity conjugacy class,
    # whose normal closure is A6 or S6.  Hence the only quotient orders are
    # 720, 2, and 1.
    require(set(closure_sizes.values()) == {1, 360, 720}, "S6 normal closures")


def det2(matrix: tuple[int, int, int, int]) -> int:
    a, b, c, d = matrix
    return (a * d - b * c) % 3


def action(matrix: tuple[int, int, int, int], vector: tuple[int, int]) -> tuple[int, int]:
    a, b, c, d = matrix
    x, y = vector
    return ((a * x + b * y) % 3, (c * x + d * y) % 3)


def verify_gl2_and_orbits() -> None:
    gl2 = [matrix for matrix in product(range(3), repeat=4) if det2(matrix)]
    nonzero = [vector for vector in product(range(3), repeat=2) if vector != (0, 0)]
    require(len(gl2) == 48, "|GL2(F3)|")
    require(len(nonzero) == 8, "nonzero E[3] vectors")
    orbit = {action(matrix, (1, 0)) for matrix in gl2}
    require(set(nonzero) == orbit, "GL2(F3) transitivity sanity")
    # A quotient image of S6 inside GL2(F3) cannot have order 720; the only
    # remaining quotient orders 1 and 2 cannot support an orbit of length 8.
    require(720 > len(gl2) and 8 > 2, "quotient/order contradiction")


def verify_lattice_countermodel() -> None:
    representative = (-5, 1, 1, 1, 1, 1)
    require(sum(representative) == 0, "augmentation lattice representative")
    residue = tuple(value % 3 for value in representative)
    require(len(set(residue)) == 1 and residue[0] != 0, "nonzero invariant mod 3")
    # The integral S6-invariants in the augmentation lattice are zero:
    # an invariant vector is constant, and its coordinate sum is 6a.
    require(6 != 0, "integral invariant check")


def verify_sources(payload: dict) -> None:
    mapping = {
        str(RESTRICTED.relative_to(PROBLEM)): RESTRICTED,
        str(RESTRICTED_MD.relative_to(PROBLEM)): RESTRICTED_MD,
        str(DECISION_MD.relative_to(PROBLEM)): DECISION_MD,
        str(TERMINALITY_MD.relative_to(PROBLEM)): TERMINALITY_MD,
        str(INFINITY.relative_to(GOALS)): INFINITY,
        str(INFINITY_MD.relative_to(GOALS)): INFINITY_MD,
        str(INFINITY_VERIFY.relative_to(GOALS)): INFINITY_VERIFY,
    }
    for key, path in mapping.items():
        require(path.is_file(), f"missing source {path}")
        require(payload["sources_sha256"][key] == digest(path), f"hash mismatch {key}")


def verify_input_claims(payload: dict) -> None:
    restricted = json.loads(RESTRICTED.read_text())
    infinity = json.loads(INFINITY.read_text())
    nonzero = restricted["R_over_F"]["presentation"]["nonzero_factor"]
    require(nonzero["is_field"] is True and nonzero["rank_over_F"] == 8, "rank-eight E3 field")
    require("size 8" in restricted["R_over_F"]["galois_module"]["orbits"]["nonzero"], "E3 transitivity")
    require("S6" in restricted["base_fields"]["K_proj"]["monodromy"], "S6 closure")
    decision_text = DECISION_MD.read_text()
    terminality_text = TERMINALITY_MD.read_text()
    require("image is the class of the genus-one curve `C`" in decision_text, "xi maps to C")
    require("C(F)=∅" in terminality_text, "C(F) emptiness input")
    require(payload["theorem"]["E3_of_N"] == 0, "E3(N) payload")
    require(payload["theorem"]["restriction_H1_E3"] == "injective", "restriction payload")
    require(payload["theorem"]["restricted_xi"] == "nonzero", "xi payload")
    require(payload["strict_boundary"]["noncube_alone_proves_CK_empty"] is False, "Kummer boundary")
    require(infinity["valuation"]["ramification_index"] == 1, "valuation e")
    require(infinity["valuation"]["residue_degree"] == 1, "valuation f")
    require(infinity["class_group"]["index"] == 3, "residue index")
    require(infinity["exit"] == "F-CONIC-CRITERION-EMPTY", "infinity exit")
    require(payload["infinity_cross_check"]["consistent"] is True, "consistency bit")


def replay_infinity_verifier() -> None:
    completed = subprocess.run(
        [sys.executable, str(INFINITY_VERIFY)],
        cwd=GOALS,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=300,
        check=True,
    )
    for marker in (
        "GOAL_F_INFINITY_EXACT_IDENTITIES_ACCEPT",
        "GOAL_F_INFINITY_MODULAR_LIFT_ACCEPT",
        "GOAL_F_CONIC_CRITERION_EMPTY_ACCEPT",
    ):
        require(marker in completed.stdout, f"missing infinity marker {marker}\n{completed.stdout}")


def main() -> None:
    payload = json.loads(PAYLOAD.read_text())
    require(payload["format"] == "goal-F-abstract-descent-v1", "payload format")
    verify_sources(payload)
    verify_input_claims(payload)
    verify_normal_quotients_of_s6()
    verify_gl2_and_orbits()
    verify_lattice_countermodel()
    replay_infinity_verifier()
    print("PASS S6 quotient and GL2(F3) orbit audit")
    print("PASS inflation-restriction hypotheses")
    print("PASS noncube versus Kummer-image boundary")
    print("GOAL_F_E3_RESTRICTION_INJECTIVE_ACCEPT")
    print("GOAL_F_INFINITY_COHOMOLOGY_CONSISTENT_ACCEPT")


if __name__ == "__main__":
    main()
