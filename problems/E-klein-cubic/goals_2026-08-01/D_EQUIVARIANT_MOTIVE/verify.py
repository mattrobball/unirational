#!/usr/bin/env python3
"""Independent verifier for the Goal D scoped exit.

The verifier recomputes the load-bearing arithmetic from fixed definitions;
it does not accept stored booleans as evidence.
"""

from __future__ import annotations

import hashlib
import json
from math import comb, gcd
from pathlib import Path


ROOT = Path(__file__).resolve().parent
FIELD_ORDER = 11


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def multiply(a: list[int], b: list[int], cap: int) -> list[int]:
    out = [0] * (cap + 1)
    for i in range(min(len(a), cap + 1)):
        for j in range(min(len(b), cap + 1 - i)):
            out[i + j] += a[i] * b[j]
    return out


def matrix_mul(
    x: tuple[int, int, int, int], y: tuple[int, int, int, int]
) -> tuple[int, int, int, int]:
    a, b, c, d = x
    e, f, g, h = y
    q = FIELD_ORDER
    return (
        (a * e + b * g) % q,
        (a * f + b * h) % q,
        (c * e + d * g) % q,
        (c * f + d * h) % q,
    )


def matrix_neg(x: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    return tuple((-a) % FIELD_ORDER for a in x)  # type: ignore[return-value]


def projective_class(x: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    """Canonical representative modulo the central pair {+I,-I}."""
    return min(x, matrix_neg(x))


def matrix_inv(x: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    a, b, c, d = x
    return projective_class(
        (d % FIELD_ORDER, -b % FIELD_ORDER, -c % FIELD_ORDER, a % FIELD_ORDER)
    )


def enumerate_psl2_11() -> list[tuple[int, int, int, int]]:
    q = FIELD_ORDER
    classes: set[tuple[int, int, int, int]] = set()
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 1:
                        classes.add(projective_class((a, b, c, d)))
    return sorted(classes)


def main() -> None:
    payload = json.loads((ROOT / "invariants.json").read_text(encoding="utf-8"))
    seal = json.loads((ROOT / "SEAL.json").read_text(encoding="utf-8"))

    # Seal audit: recompute every listed digest and reject a self-hash.
    required_sealed = {
        "STATUS.md",
        "THEOREM_AUDIT.md",
        "TARGET_INVARIANTS.md",
        "BLOWUP_CLOSURE.md",
        "COMPLETION_AUDIT.md",
        "produce.py",
        "seal.py",
        "verify.py",
        "invariants.json",
    }
    require(not seal["self_hash_included"], "seal must exclude its own hash")
    require("SEAL.json" not in seal["files"], "timing-dependent self-hash found")
    require(set(seal["files"]) == required_sealed, "sealed file set is incomplete")
    for name, expected in seal["files"].items():
        path = ROOT / name
        require(path.is_file(), f"sealed file missing: {name}")
        require(sha256(path) == expected, f"hash mismatch: {name}")

    # Chern class from adjunction, not from stored coefficients.
    numerator = [comb(5, i) for i in range(4)]
    inverse = [1, -3, 9, -27]
    chern = multiply(numerator, inverse, 3)
    require(chern == [1, 2, 4, -2], f"unexpected Chern class: {chern}")
    require(payload["target"]["chern_class_coefficients_in_H"] == chern, "payload Chern mismatch")

    degree = 3
    c1, c2, c3 = chern[1:]
    computed_numbers = {
        "c1^3": c1**3 * degree,
        "c1*c2": c1 * c2 * degree,
        "c3": c3 * degree,
        "p1*H": (c1**2 - 2 * c2) * degree,
    }
    computed_numbers["s3"] = (
        computed_numbers["c1^3"]
        - 3 * computed_numbers["c1*c2"]
        + 3 * computed_numbers["c3"]
    )
    computed_numbers["s3_tangent/2"] = computed_numbers["s3"] // 2
    computed_numbers["rost_half_number_minus_tangent"] = -computed_numbers["s3"] // 2
    computed_numbers["todd_genus"] = computed_numbers["c1*c2"] // 24
    require(computed_numbers == payload["target"]["chern_numbers"], "characteristic-number mismatch")
    require(
        computed_numbers["s3"] == -66
        and computed_numbers["s3_tangent/2"] == -33
        and computed_numbers["rost_half_number_minus_tangent"] == 33,
        "Newton/Rost sign ledger mismatch",
    )

    # Betti and Euler check. Four even Tate groups contribute +4.
    euler = computed_numbers["c3"]
    b3 = 4 - euler
    betti = [1, 0, 1, b3, 1, 0, 1]
    require(betti == [1, 0, 1, 10, 1, 0, 1], "Betti computation failed")
    require(payload["target"]["betti_numbers"] == betti, "payload Betti mismatch")

    # Index-one certificate.
    degrees = [60, 132, 165, 220]
    coeffs = [-13, 3, 1, 1]
    bezout = sum(a * b for a, b in zip(coeffs, degrees))
    index_gcd = 0
    for value in degrees:
        index_gcd = gcd(index_gcd, value)
    require(bezout == 1 and index_gcd == 1, "index-one certificate failed")
    require(payload["index_certificate"]["bezout_value"] == 1, "stored Bezout value mismatch")
    require(payload["index_certificate"]["gcd"] == 1, "stored index gcd mismatch")

    # Enumerate SL_2(F_11)/{+/-I}, rather than trusting an order formula.
    group = enumerate_psl2_11()
    psl_order = len(group)
    require(psl_order == 660, "PSL(2,11) order mismatch")
    require(payload["group"]["order"] == psl_order, "stored group order mismatch")
    require(set(payload["group"]["prime_divisors"]) == {2, 3, 5, 11}, "prime support mismatch")
    identity = projective_class((1, 0, 0, 1))
    group_set = set(group)
    require(identity in group_set, "identity class missing")
    for g in group:
        require(
            projective_class(matrix_mul(g, matrix_inv(g))) == identity,
            "inverse check failed",
        )

    # Verify for every pair the formal identity behind
    # Phi(hx)_g=(h.Phi(x))_g: g^{-1}h=(h^{-1}g)^{-1}.
    for h in group:
        h_inverse = matrix_inv(h)
        for g in group:
            left = projective_class(matrix_mul(matrix_inv(g), h))
            right = matrix_inv(projective_class(matrix_mul(h_inverse, g)))
            require(left == right, "regular-orbit equivariance identity failed")

    # Prym genus and regular-orbit capacity.
    quintic_genus = (5 - 1) * (5 - 2) // 2
    cover_genus = 2 * quintic_genus - 1
    h1_rank = 2 * cover_genus
    total_rank = psl_order * h1_rank
    require((quintic_genus, cover_genus, h1_rank) == (6, 11, 22), "Prym genus calculation failed")
    require(payload["closure_model"]["H1_total_rank"] == total_rank == 14520, "orbit rank mismatch")
    require(h1_rank >= 10, "not enough regular ZG copies for target lattice")
    require(payload["closure_model"]["regular_ZG_copies"] == 22, "regular-copy mismatch")
    require(payload["closure_model"]["motive_denominators"] == [2, 660], "denominator ledger mismatch")
    require(not payload["closure_model"]["integral_motive_split_claimed"], "forbidden integral overclaim")

    # Steenrod target degrees/reasons, independently checked.
    require(betti[5] == 0, "Sq2 target H5 should vanish")
    require(payload["steenrod_on_H3"]["2"] == {
        "Sq1": 0,
        "Sq2": 0,
        "Sq3": 0,
        "reason": "torsion_free_H5_zero_square_lifts",
    }, "mod-2 Steenrod profile mismatch")
    for prime in (3, 5, 11):
        first_target_degree = 3 + 2 * (prime - 1)
        require(first_target_degree > 6, f"P1 target not above dimension at p={prime}")
        require(payload["steenrod_on_H3"][str(prime)]["P1"] == 0, f"stored P1 mismatch at p={prime}")

    # The status boundary is part of the certificate.
    first_line = (ROOT / "STATUS.md").read_text(encoding="utf-8").splitlines()[0]
    require(first_line == "D-INVARIANT-REPRODUCIBLE", "wrong exit code")
    require(payload["headline_problem"] == "OPEN", "headline must remain open")
    require(payload["exit"] == first_line, "payload/status exit mismatch")

    print("D_EQUIVARIANT_MOTIVE_VERIFY_OK")


if __name__ == "__main__":
    main()
