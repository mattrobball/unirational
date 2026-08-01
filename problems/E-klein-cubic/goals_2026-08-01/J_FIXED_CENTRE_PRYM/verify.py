#!/usr/bin/env python3
"""Independent verifier for the finite and integrity claims in Goal J.

This file does not import produce.py.  It rebuilds S3, enumerates all
1-cocycles, recomputes the generalized-Jacobian character decompositions,
and rechecks the target restriction rows against the upstream certificate.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parent.parent


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def body_hash(data: dict) -> str:
    copy = dict(data)
    claimed = copy.pop("self_sha256")
    raw = json.dumps(copy, sort_keys=True, separators=(",", ":")).encode()
    assert hashlib.sha256(raw).hexdigest() == claimed
    return claimed


def main() -> None:
    payload = json.loads((HERE / "payload.json").read_text())
    body_hash(payload)
    assert payload["exit"] == "J-INVARIANT-TOO-WEAK"
    assert payload["overall_problem_headline"] == "OPEN"

    # Independent convention: (reflection_bit, rotation_power) acts as
    # x |-> (-1)^reflection_bit x + rotation_power on Z/3.
    group = tuple((e, i) for e in range(2) for i in range(3))

    def compose(g, h):
        e, i = g
        f, j = h
        return ((e + f) % 2, (i + (-1 if e else 1) * j) % 3)

    def lin(g, a):
        return ((-1 if g[0] else 1) * a) % 3

    def cocycle(vals):
        c = dict(zip(group, vals, strict=True))
        return c[(0, 0)] == 0 and all(
            c[compose(g, h)] == (c[g] + lin(g, c[h])) % 3 for g in group for h in group
        )

    z1 = [v for v in itertools.product(range(3), repeat=6) if cocycle(v)]
    b1 = {
        tuple((lin(g, a) - a) % 3 for g in group)
        for a in range(3)
    }
    quotient = set()
    for z in z1:
        quotient.add(min(tuple((x + y) % 3 for x, y in zip(z, b, strict=True)) for b in b1))
    assert (len(z1), len(b1), len(quotient)) == (9, 3, 3)
    assert payload["affine_S3_class"]["number_of_1_cocycles"] == 9
    assert payload["affine_S3_class"]["number_of_1_coboundaries"] == 3
    assert payload["affine_S3_class"]["number_of_H1_classes"] == 3

    # Character inner products on S3, class order (1, transposition, 3-cycle).
    def ip(a, b):
        return (a[0] * b[0] + 3 * a[1] * b[1] + 2 * a[2] * b[2]) // 6

    irreps = {"trivial": (1, 1, 1), "sign": (1, -1, 1), "standard": (2, 0, -1)}
    e_div0 = (11, 3, -1)
    l_div0 = (7, 1, 1)
    assert {k: ip(e_div0, v) for k, v in irreps.items()} == {"trivial": 3, "sign": 0, "standard": 4}
    assert {k: ip(l_div0, v) for k, v in irreps.items()} == {"trivial": 2, "sign": 1, "standard": 2}
    assert payload["marked_generalized_jacobians"]["E_Div0_decomposition"] == {"trivial": 3, "sign": 0, "standard": 4}
    assert payload["marked_generalized_jacobians"]["L_Div0_decomposition"] == {"trivial": 2, "sign": 1, "standard": 2}

    # Upstream source integrity and independent extraction.
    for relative, expected in payload["source_sha256"].items():
        assert sha256(PROBLEM / relative) == expected
    screen = json.loads((PROBLEM / "certificates/hodge_centers/character_screen.json").read_text())
    rows = {r["H_label"]: r for r in screen["subgroup_screen"]}
    assert len(rows) == 14
    assert rows["C2"]["restriction_H21_multiplicities"] == [3, 2]
    assert rows["S3_class_1"]["restriction_H21_multiplicities"] == [1, 0, 2]
    assert rows["S3_class_2"]["restriction_H21_multiplicities"] == [1, 0, 2]
    assert rows["D12"]["restriction_H21_multiplicities"] == [1, 0, 0, 0, 1, 1]
    assert payload["target_hodge"]["fixed_elliptic_channel_multiplicity"] == 0

    # The seal excludes itself, so there is no timing-dependent self-hash.
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["self_hash"] == "omitted by design"
    for name, expected in seal["files"].items():
        assert sha256(HERE / name) == expected

    status = (HERE / "STATUS.md").read_text().splitlines()
    assert status[0] == "J-INVARIANT-TOO-WEAK"
    assert any("Overall Problem E headline: **OPEN**" in line for line in status)
    print("J_FIXED_CENTRE_PRYM_VERIFY_OK")


if __name__ == "__main__":
    main()
