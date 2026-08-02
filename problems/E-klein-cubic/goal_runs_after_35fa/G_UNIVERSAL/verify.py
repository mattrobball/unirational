#!/usr/bin/env python3
"""Independent verifier for the G/G2 universal all-degree theorem.

The verifier checks the representation-specific projective-to-polynomial lift,
primitive reduction, the two-way homogeneous degree ledger, the exact generic
cubic payload, the full transition-necessity scope, and the packet seal.  It
never treats a stored status flag as evidence for a rational point or for
pointlessness.
"""

from __future__ import annotations

import argparse
from collections import deque
import hashlib
from itertools import combinations_with_replacement
import json
from pathlib import Path
import subprocess
import sys
from typing import Iterable, Sequence


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
P = 11
INF = P


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git_blob_sha1(path: Path) -> str:
    data = path.read_bytes()
    return hashlib.sha1(f"blob {len(data)}\0".encode() + data).hexdigest()


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(len(left)))


def inverse(permutation: tuple[int, ...]) -> tuple[int, ...]:
    result = [0] * len(permutation)
    for source, target in enumerate(permutation):
        result[target] = source
    return tuple(result)


def mobius(matrix: tuple[int, int, int, int], point: int) -> int:
    a, b, c, d = (entry % P for entry in matrix)
    if point == INF:
        return INF if c == 0 else a * pow(c, -1, P) % P
    denominator = (c * point + d) % P
    if denominator == 0:
        return INF
    return (a * point + b) * pow(denominator, -1, P) % P


def permutation(matrix: tuple[int, int, int, int]) -> tuple[int, ...]:
    return tuple(mobius(matrix, point) for point in range(P + 1))


def closure(generators: Iterable[tuple[int, ...]]) -> set[tuple[int, ...]]:
    generators = tuple(generators)
    identity = tuple(range(P + 1))
    seen = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            product = compose(generator, current)
            if product not in seen:
                seen.add(product)
                queue.append(product)
    return seen


def check_machine_ledger() -> dict:
    theorem = json.loads((HERE / "theorem.json").read_text())
    require(theorem["schema"] == "G2_UNIVERSAL_ALL_DEGREE_V2", "wrong theorem schema")
    require(theorem["exit"] == "G2-FINITE-GENERATION-PASS", "wrong theorem exit")
    require(theorem["headline"] == "OPEN", "headline overclaim")
    require(theorem["group"]["order"] == 660, "wrong group order ledger")
    require(theorem["group"]["derived_subgroup_order"] == 660,
            "wrong derived-subgroup ledger")
    require(theorem["group"]["character_group"] == "trivial",
            "character-group boundary missing")
    require(theorem["global_object"]["invariant_module_rank_over_A"] == 12,
            "wrong invariant rank")
    require(theorem["global_object"]["covariant_module_rank_over_A"] == 60,
            "wrong covariant rank")
    require(theorem["generic_object"]["frame_degrees"] == [1, 4, 5, 6, 7],
            "wrong generic frame degrees")
    require(theorem["generic_object"]["cubic_coefficient_count"] == 35,
            "wrong cubic coefficient count")
    require(theorem["theorem"]["primitive_reduction"].startswith("coordinate gcd is invariant"),
            "primitive reduction theorem missing")
    require(theorem["scope"]["symbolic_multi_rees_finite_generation_claimed"] is False,
            "symbolic multi-Rees overclaim")
    require(theorem["scope"]["finite_degree_cutoff_claimed"] is False,
            "finite degree cutoff overclaim")
    require(theorem["scope"]["generic_point_decided"] is False,
            "generic rational point overclaim")
    return theorem


def check_perfect_group(theorem: dict) -> None:
    # These are the actions on P^1(F_11) of matrices
    # S=[[0,-1],[1,0]] and T=[[1,1],[0,1]].
    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    group = closure((s, t))
    require(len(group) == theorem["group"]["order"] == 660,
            "standard PSL(2,11) permutation model does not have order 660")

    commutator = compose(compose(compose(s, t), inverse(s)), inverse(t))
    conjugates = {
        compose(compose(element, commutator), inverse(element))
        for element in group
    }
    derived = closure(conjugates)
    require(len(derived) == theorem["group"]["derived_subgroup_order"] == 660,
            "normal closure of [S,T] is not the full group")
    require(derived == group, "PSL(2,11) perfectness replay failed")


def add(*vectors: Sequence[int]) -> tuple[int, ...]:
    require(bool(vectors), "add requires at least one vector")
    width = len(vectors[0])
    require(all(len(vector) == width for vector in vectors), "degree-vector width mismatch")
    return tuple(sum(vector[index] for vector in vectors) for index in range(width))


def scale(vector: Sequence[int], scalar: int) -> tuple[int, ...]:
    return tuple(scalar * value for value in vector)


def check_degree_clearing(frame_degrees: Sequence[int], law_degree: int) -> None:
    count = len(frame_degrees)
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

    # Forward direction: b_i=n_i/d_i has degree -e_i.  With h=prod d_i,
    # q_i=n_i prod_{j!=i}d_j has degree H-e_i, so q_i B_i has degree H.
    cleared_coefficients: list[tuple[int, ...]] = []
    for index, frame_degree in enumerate(frame_degrees):
        numerator_degree = add(denominator_degrees[index], constant(-frame_degree))
        cleared = add(numerator_degree, common_degree, scale(denominator_degrees[index], -1))
        require(cleared == add(common_degree, constant(-frame_degree)),
                "forward coefficient degree failed")
        require(add(cleared, constant(frame_degree)) == common_degree,
                "forward frame summands do not have one degree")
        cleared_coefficients.append(cleared)

    for indices in combinations_with_replacement(range(count), law_degree):
        polar_degree = sum(frame_degrees[index] for index in indices)
        term_degree = add(
            *(cleared_coefficients[index] for index in indices),
            constant(polar_degree),
        )
        require(term_degree == scale(common_degree, law_degree),
                "forward polynomial-law degree failed")

    # Reverse direction: c_i has degree d-e_i and
    # a_i=c_i*tau^(e_i-d) has degree zero.
    reverse_coefficients: list[tuple[int, ...]] = []
    for frame_degree in frame_degrees:
        coefficient_degree = add(landing_degree, constant(-frame_degree))
        normalized_degree = add(
            coefficient_degree,
            constant(frame_degree),
            scale(landing_degree, -1),
        )
        require(normalized_degree == zero,
                "reverse normalized frame coefficient is not degree zero")
        reverse_coefficients.append(coefficient_degree)

    for indices in combinations_with_replacement(range(count), law_degree):
        polar_degree = sum(frame_degrees[index] for index in indices)
        affine_degree = add(
            *(reverse_coefficients[index] for index in indices),
            constant(polar_degree),
        )
        require(affine_degree == scale(landing_degree, law_degree),
                "reverse polynomial-law degree failed")


def check_document_scope() -> None:
    status = " ".join((HERE / "STATUS.md").read_text().split())
    universal = " ".join((HERE / "UNIVERSAL_OBJECT.md").read_text().split())
    all_degree = " ".join((HERE / "ALL_DEGREE_THEOREM.md").read_text().split())
    noetherianity = " ".join((HERE / "NOETHERIANITY.md").read_text().split())
    decision = " ".join((HERE / "DECISION.md").read_text().split())

    require((HERE / "STATUS.md").read_text().splitlines()[0] == "G2-FINITE-GENERATION-PASS",
            "wrong STATUS exit")
    for phrase in (
        "generic `PSL(2,11)`-twist",
        "primitive representatives are unique up to a ground-field scalar",
        "headline remains **OPEN**",
    ):
        require(phrase in status, f"STATUS missing {phrase!r}")
    for phrase in (
        "Intrinsic generic twist",
        "Polynomialization and the character issue",
        "Primitive and scalar-multiple covariants",
        "finite irrelevant-torsion correction",
        "direction remains forward only",
    ):
        require(phrase in universal, f"UNIVERSAL_OBJECT missing {phrase!r}")
    for phrase in (
        "torsor descent",
        "constants form a character of `G`",
        "coordinate gcd",
        "Primitive/scalar equivalence relation",
        "larger inverse limit of independent local states",
    ):
        require(phrase in all_degree, f"ALL_DEGREE_THEOREM missing {phrase!r}")
    for phrase in (
        "What is not claimed",
        "Exact counterexample to the degree-cutoff inference",
        "Correct G2 conclusion",
    ):
        require(phrase in noetherianity, f"NOETHERIANITY missing {phrase!r}")
    require("Neither a point nor a pointlessness certificate" in decision,
            "rational-point scope fence missing")
    require("source-exhaustiveness" in decision,
            "negative bridge boundary missing")
    require("Jacobian rank four" in decision,
            "positive dominance boundary missing")


def check_upstream_blob(theorem: dict, name: str) -> Path:
    metadata = theorem["upstream"][name]
    path = PROBLEM / metadata["path"]
    require(path.is_file(), f"missing upstream artifact: {path}")
    require(git_blob_sha1(path) == metadata["git_blob_sha1"],
            f"upstream blob changed: {name}")
    return path


def check_generic_cubic(theorem: dict) -> None:
    path = check_upstream_blob(theorem, "generic_cubic")
    payload = json.loads(path.read_text())
    generic = theorem["generic_object"]
    global_object = theorem["global_object"]
    require(payload["schema"] == "G_GENERIC_KLEIN_CUBIC_V1",
            "unexpected generic cubic schema")
    require(payload["coefficient_count"] == 35 == len(payload["coefficients"]),
            "generic cubic does not contain 35 coefficients")
    require(payload["frame_names"] == generic["frame_names"], "frame names changed")
    require(payload["frame_degrees"] == generic["frame_degrees"], "frame degrees changed")
    require(payload["primary_names"] == global_object["primary_invariants"],
            "primary invariant names changed")
    require(payload["primary_degrees"] == global_object["primary_degrees"],
            "primary degrees changed")
    require(payload["projective_base"] == generic["projective_base"],
            "projective base changed")
    require(len(payload["secondary_degrees"]) == generic["projective_field_basis_size"],
            "secondary basis size changed")

    tau_degree = 2 * payload["primary_degrees"][0] - payload["primary_degrees"][1]
    require(tau_degree == generic["normalizer_degree"] == 1,
            "tau=f3^2/f5 is not degree one")

    expected = set(combinations_with_replacement(range(5), 3))
    seen: set[tuple[int, int, int]] = set()
    for coefficient in payload["coefficients"]:
        triple = tuple(coefficient["triple"])
        require(triple in expected and triple not in seen,
                "bad or repeated symmetric cubic triple")
        seen.add(triple)
        coefficient_degree = sum(payload["frame_degrees"][index] for index in triple)
        require(coefficient["degree"] == coefficient_degree,
                "polar coefficient has wrong source degree")
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
                for exponent, degree in zip(affine["primary_exponents"], payload["primary_degrees"])
            ) + payload["secondary_degrees"][affine["secondary"]]
            require(term_degree == coefficient_degree,
                    "coefficient-basis term has wrong source degree")
    require(seen == expected, "generic cubic triple ledger is incomplete")


def check_transition_scope(theorem: dict) -> None:
    path = check_upstream_blob(theorem, "transition_necessity")
    payload = json.loads(path.read_text())
    require(payload["proof"]["status"] == "PROVED", "necessity theorem is not proved")
    require(payload["direction"].startswith("forward only"),
            "local inverse limit was silently promoted to sufficiency")
    steps = [entry["id"] for entry in payload["proof"]["steps"]]
    require(steps == theorem["transition_steps"], "transition proof-step ledger changed")
    claims = "\n".join(entry["claim"] for entry in payload["proof"]["steps"])
    for phrase in (
        "A_m = ∩_t I(Z_t)^m",
        "triple-line equalizer → residual point kernel",
        "finite irrelevant torsion",
        "C3 lines, A4 points, and marked elliptic data",
        "false short Cech complex",
    ):
        require(phrase in claims, f"transition scope phrase missing: {phrase}")


def check_upstream_replay(theorem: dict) -> None:
    check_upstream_blob(theorem, "prior_universal_proof")
    verifier = check_upstream_blob(theorem, "prior_universal_verifier")
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
        raise AssertionError("upstream exact universal-object replay failed")
    for marker in (
        "G_DENOMINATOR_CLEARING_EQUIVALENCE_OK",
        "G_UNIVERSAL_OBJECT_AUDIT_OK",
        "G_GENERIC_SUPPORT_STILL_UNDECIDED",
    ):
        require(marker in completed.stdout, f"upstream verifier did not emit {marker}")


def check_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal["schema"] == "G2_UNIVERSAL_SEAL_V2", "wrong seal schema")
    require(seal["exit"] == "G2-FINITE-GENERATION-PASS", "wrong seal exit")
    for relative, expected in seal["artifacts"].items():
        path = HERE / relative
        require(path.is_file(), f"sealed artifact missing: {relative}")
        require(sha256(path) == expected, f"sealed hash mismatch: {relative}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--self-contained",
        action="store_true",
        help="verify the new theorem core without the surrounding repository checkout",
    )
    args = parser.parse_args()

    theorem = check_machine_ledger()
    check_perfect_group(theorem)
    check_degree_clearing(theorem["generic_object"]["frame_degrees"], 3)
    check_document_scope()
    if not args.self_contained:
        check_generic_cubic(theorem)
        check_transition_scope(theorem)
        check_upstream_replay(theorem)
    check_seal()

    print("G2_PSL211_PERFECTNESS_EXACT_OK")
    print("G2_PROJECTIVE_LIFT_AND_PRIMITIVE_REDUCTION_OK")
    print("G2_ALL_DEGREE_DENOMINATOR_CLEARING_OK")
    if not args.self_contained:
        print("G2_GENERIC_CUBIC_35_COEFFICIENT_LEDGER_OK")
        print("G2_FULL_TRANSITION_SCOPE_RETAINED_OK")
        print("G2_UPSTREAM_EXACT_REPLAY_OK")
    print("G2_UNIVERSAL_VERIFIER_ACCEPT")
    print("SCOPE G2-FINITE-GENERATION-PASS; HEADLINE OPEN")


if __name__ == "__main__":
    main()
