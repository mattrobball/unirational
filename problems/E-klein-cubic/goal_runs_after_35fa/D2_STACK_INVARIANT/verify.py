#!/usr/bin/env python3
"""Independent verifier for the Goal D2 no-valid-bridge exit."""

from __future__ import annotations

import hashlib
import json
from math import gcd
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def crt_idempotents(moduli: list[int]) -> list[int]:
    total = 1
    for modulus in moduli:
        total *= modulus
    values = []
    for modulus in moduli:
        quotient = total // modulus
        values.append((quotient * pow(quotient, -1, modulus)) % total)
    return values


def main() -> None:
    payload = json.loads((ROOT / "invariant_payload.json").read_text(encoding="utf-8"))
    seal = json.loads((ROOT / "SEAL.json").read_text(encoding="utf-8"))

    required_files = {
        "STATUS.md",
        "INVARIANT_DEFINITION.md",
        "SYLOW_DETECTION.md",
        "THEOREM_AUDIT.md",
        "COUNTERMODELS.md",
        "ADMISSIBLE_CENTRE_CLOSURE.md",
        "COMPLETION_AUDIT.md",
        "invariant_payload.json",
        "produce.py",
        "seal.py",
        "verify.py",
    }
    require(not seal["self_hash_included"], "seal self-hash flag is wrong")
    require("SEAL.json" not in seal["files"], "seal includes timing-dependent self-hash")
    require(set(seal["files"]) == required_files, "sealed file set mismatch")
    for name, expected in seal["files"].items():
        path = ROOT / name
        require(path.is_file(), f"missing sealed file: {name}")
        require(digest(path) == expected, f"hash mismatch: {name}")

    # Recompute |PSL(2,11)| and the full primary decomposition.
    group_order = 11 * (11**2 - 1) // gcd(2, 11 - 1)
    require(group_order == 660 == payload["group"]["order"], "group order mismatch")

    moduli = [4, 3, 5, 11]
    idempotents = crt_idempotents(moduli)
    require(idempotents == [165, 220, 396, 540], "CRT idempotents mismatch")
    require(payload["crt"]["idempotents_mod_660"] == idempotents, "stored CRT mismatch")
    require(sum(idempotents) % group_order == 1, "CRT idempotents do not sum to one")
    for i, e_i in enumerate(idempotents):
        require((e_i * e_i - e_i) % group_order == 0, f"non-idempotent component {i}")
        for j, e_j in enumerate(idempotents):
            if i != j:
                require((e_i * e_j) % group_order == 0, f"nonorthogonal components {i},{j}")

    # Recompute Sylow indices and the units used in restriction-corestriction.
    sylow_orders = [4, 3, 5, 11]
    indices = [group_order // order for order in sylow_orders]
    inverses = [pow(index, -1, modulus) for index, modulus in zip(indices, moduli)]
    require(indices == [165, 220, 132, 60], "Sylow indices mismatch")
    require(inverses == [1, 1, 3, 9], "Sylow transfer inverses mismatch")
    require(payload["sylow_detection"]["indices"] == indices, "stored index mismatch")
    require(payload["sylow_detection"]["inverse_mod_primary_part"] == inverses, "stored inverse mismatch")

    # Index-one certificate from the installed fixed-point orbit degrees.
    degrees = [60, 132, 165, 220]
    coefficients = [-13, 3, 1, 1]
    bezout = sum(a * b for a, b in zip(coefficients, degrees))
    degree_gcd = 0
    for degree in degrees:
        degree_gcd = gcd(degree_gcd, degree)
    require(bezout == 1 and degree_gcd == 1, "index-one arithmetic failed")
    require(payload["index_one"]["bezout_value"] == 1, "stored Bezout mismatch")
    require(payload["index_one"]["gcd"] == 1, "stored gcd mismatch")

    # Every bad prime is realized by the formal relative-dimension-one model.
    multipliers = set(payload["multisection_countermodel"]["realized_multipliers"])
    require({2, 3, 5, 11, 660}.issubset(multipliers), "bad-prime multiplier missing")
    require(payload["multisection_countermodel"]["polarization_discriminant_scaling_exponent"] == 10, "polarization rank mismatch")

    # Candidate audit: no entry may silently claim to pass all D2 requirements.
    candidates = payload["candidates"]
    require(len(candidates) == 7, "candidate ledger incomplete")
    require(
        all(
            candidate["d2_requirements_failed"]
            or candidate.get("precondition_failed") == "genuinely_new_invariant"
            for candidate in candidates
        ),
        "candidate falsely passes all requirements and preconditions",
    )
    require(not payload["valid_new_bridge_found"], "payload overclaims a bridge")

    first_line = (ROOT / "STATUS.md").read_text(encoding="utf-8").splitlines()[0]
    require(first_line == "D2-NO-VALID-BRIDGE", "wrong exit code")
    require(payload["exit"] == first_line, "payload/status exit mismatch")
    require(payload["headline_problem"] == "OPEN", "headline boundary changed")
    require(not payload["free_orbit_test"]["declared_admissible_base_locus"], "free orbit falsely declared admissible")

    print("D2_STACK_INVARIANT_VERIFY_OK")


if __name__ == "__main__":
    main()
