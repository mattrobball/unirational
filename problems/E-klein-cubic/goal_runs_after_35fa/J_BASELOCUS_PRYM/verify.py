#!/usr/bin/env python3
"""Independent verifier for Goal J2.

This verifier does not import produce.py.  It reconstructs the finite group,
orbit, curve, character, cohomology, source-integrity, and seal checks.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parent.parent
Q = 11


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def body_hash(data: dict) -> None:
    copy = dict(data)
    claimed = copy.pop("self_sha256")
    raw = json.dumps(copy, sort_keys=True, separators=(",", ":")).encode()
    require(hashlib.sha256(raw).hexdigest() == claimed, "payload self-hash mismatch")


def mul(x: tuple[int, int, int, int], y: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    a, b, c, d = x
    e, f, g, h = y
    return ((a * e + b * g) % Q, (a * f + b * h) % Q,
            (c * e + d * g) % Q, (c * f + d * h) % Q)


def neg(x: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    return tuple((-a) % Q for a in x)  # type: ignore[return-value]


def cls(x: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    return min(x, neg(x))


def inv(x: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    a, b, c, d = x
    return cls((d, -b % Q, -c % Q, a))


def psl2() -> list[tuple[int, int, int, int]]:
    out = set()
    for a in range(Q):
        for b in range(Q):
            for c in range(Q):
                for d in range(Q):
                    if (a * d - b * c) % Q == 1:
                        out.add(cls((a, b, c, d)))
    return sorted(out)


def s3_affine_check(payload: dict) -> None:
    # (reflection bit, rotation exponent), acting on Z/3 by the sign.
    group = tuple((e, i) for e in range(2) for i in range(3))

    def compose(g, h):
        e, i = g
        f, j = h
        return ((e + f) % 2, (i + (-1 if e else 1) * j) % 3)

    def action(g, a):
        return ((-1 if g[0] else 1) * a) % 3

    def is_cocycle(values):
        z = dict(zip(group, values))
        return z[(0, 0)] == 0 and all(
            z[compose(g, h)] == (z[g] + action(g, z[h])) % 3
            for g in group for h in group
        )

    z1 = [v for v in itertools.product(range(3), repeat=6) if is_cocycle(v)]
    b1 = {tuple((action(g, a) - a) % 3 for g in group) for a in range(3)}
    classes = {
        min(tuple((x + y) % 3 for x, y in zip(z, b)) for b in b1)
        for z in z1
    }
    require((len(z1), len(b1), len(classes)) == (9, 3, 3), "S3 H1 enumeration failed")
    require(payload["fixed_one_motive"]["affine_class_order"] == 3, "affine order mismatch")


def main() -> None:
    payload = json.loads((HERE / "payload.json").read_text())
    body_hash(payload)
    require(payload["exit"] == "J2-UNRESTRICTED-COUNTERMODEL-EXTENDS", "wrong exit")
    require(payload["overall_problem_headline"] == "OPEN", "Problem E overclaimed")

    # Recompute every upstream digest before interpreting its contents.
    for relative, expected in payload["source_sha256"].items():
        require(sha256(PROBLEM / relative) == expected, f"source hash mismatch: {relative}")

    local_text = (PROBLEM / "certificates/LOCAL_TRANSITION_MODULES.md").read_text()
    require("Every plus-plane is a base component" in local_text, "forced-plane theorem missing")
    require("common first\ntransverse order \\(m\\) is odd" in local_text, "odd-order theorem missing")

    normal = json.loads((PROBLEM / "certificates/strata/normal_characters.json").read_text())
    plane = normal["strata"]["C2_plane"]
    require(plane["orbit_size"] == 55, "plus-plane orbit mismatch")
    require(plane["generic_stabilizer_H"]["order"] == 2, "C2 stabilizer mismatch")
    require(plane["setwise_stabilizer_N"]["order"] == 12, "D12 normalizer mismatch")
    require(plane["residual_N_over_H"]["order"] == 6, "S3 residual mismatch")
    require(plane["normal_bundle_fiber_as_H_module"]["rank"] == 2, "plane normal rank mismatch")

    # Enumerate PSL_2(F_11), and verify the selected involution and centralizer.
    group = psl2()
    group_set = set(group)
    identity = cls((1, 0, 0, 1))
    require(len(group) == 660 and identity in group_set, "PSL(2,11) enumeration failed")
    t = cls(tuple(plane["generic_stabilizer_H"]["generator_key"]))
    require(t in group_set and t != identity and cls(mul(t, t)) == identity, "selected element is not an involution")
    centralizer = [g for g in group if cls(mul(g, t)) == cls(mul(t, g))]
    require(len(centralizer) == 12, "involution centralizer mismatch")
    conjugates = {cls(mul(mul(g, t), inv(g))) for g in group}
    require(len(conjugates) == 55, "involution class size mismatch")
    orbit_size = len(group) // 2
    fixed_components = len(centralizer) // 2
    require((orbit_size, fixed_components) == (330, 6), "curve orbit/fixed count mismatch")
    require(payload["orbit"]["orbit_components"] == orbit_size, "stored orbit mismatch")
    require(payload["orbit"]["components_fixed_by_selected_involution"] == fixed_components, "stored fixed count mismatch")

    # Curve on the product: adjunction and projection degrees.
    g_tilde, d_elliptic, d_prym = 11, 24, 3
    two_g_minus_two = 2 * d_elliptic * d_prym + (2 * g_tilde - 2) * d_prym
    curve_genus = 1 + two_g_minus_two // 2
    h1_rank = 2 * curve_genus
    plane_degree = 2 * curve_genus + 1
    require((curve_genus, h1_rank, plane_degree) == (103, 206, 207), "curve arithmetic mismatch")
    require(payload["centre_curve"]["genus"] == curve_genus, "stored genus mismatch")
    require(payload["centre_curve"]["degree_to_prym_cover"] == d_prym, "Prym projection mismatch")
    require(payload["centre_curve"]["degree_to_fixed_elliptic"] == d_elliptic, "elliptic projection mismatch")
    require(d_elliptic % 3 == 0, "elliptic norm degree is not three-divisible")

    # Exact target restriction and averaging scalar.
    screen = json.loads((PROBLEM / "certificates/hodge_centers/character_screen.json").read_text())
    rows = {row["H_label"]: row for row in screen["subgroup_screen"]}
    require(rows["C2"]["restriction_H21_multiplicities"] == [3, 2], "C2 restriction mismatch")
    target_rank = 10
    invariant_rank = 2 * rows["C2"]["restriction_H21_multiplicities"][0]
    scalar_numerator = orbit_size * invariant_rank
    require(scalar_numerator % target_rank == 0, "projector scalar is not integral")
    scalar = scalar_numerator // target_rank
    require(scalar == 198, "averaging scalar mismatch")
    require(payload["hodge_prym_split"]["averaging_scalar"] == scalar, "stored scalar mismatch")
    require(payload["hodge_prym_split"]["induced_centre_H1_rank"] == orbit_size * h1_rank == 67980, "H1 rank mismatch")
    require(payload["hodge_prym_split"]["safe_localization"] == "Z[1/198]", "localization mismatch")
    require(not payload["hodge_prym_split"]["primitive_integral_direct_factor_claimed"], "integral split overclaim")
    require(not payload["hodge_prym_split"]["integral_principal_polarization_claimed"], "polarization overclaim")

    # Regular S3 character decomposition, class sizes (1,3,2).
    regular = (6, 0, 0)
    irreps = {"trivial": (1, 1, 1), "sign": (1, -1, 1), "standard": (2, 0, -1)}

    def inner(a, b):
        return (a[0] * b[0] + 3 * a[1] * b[1] + 2 * a[2] * b[2]) // 6

    decomposition = {name: inner(regular, char) for name, char in irreps.items()}
    require(decomposition == {"trivial": 1, "sign": 1, "standard": 2}, "regular S3 decomposition failed")
    require(payload["orbit"]["fixed_component_decomposition"] == decomposition, "stored S3 decomposition mismatch")
    s3_affine_check(payload)

    require(payload["normal_slice"]["plus_eigenrank"] == 1, "plus normal rank mismatch")
    require(payload["normal_slice"]["minus_eigenrank"] == 2, "minus normal rank mismatch")
    require(payload["coefficient_coupling"]["new_F_of_p_equations"] == 0, "spurious coefficient equations")
    require(payload["forced_base"]["covariant_changed"] is False, "covariant changed")
    require(payload["route_audit"]["landing_covariant_constructed"] is False, "existence overclaim")
    require(payload["route_audit"]["landing_covariant_refuted"] is False, "nonexistence overclaim")

    # Seal and theorem-boundary text.
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal["self_hash"] == "omitted by design", "seal self-hash policy mismatch")
    require("SEAL.json" not in seal["files"], "timing-dependent self-hash found")
    for name, expected in seal["files"].items():
        require(sha256(HERE / name) == expected, f"sealed hash mismatch: {name}")

    status = (HERE / "STATUS.md").read_text().splitlines()
    require(status[0] == payload["exit"], "status/payload exit mismatch")
    require(any("Overall Problem E headline: **OPEN**" in line for line in status), "OPEN boundary missing")
    documents = [
        "STATUS.md", "D_COUNTERMODEL_AUDIT.md", "FIXED_CENTRE_1MOTIVE.md",
        "BASE_IDEAL_CONSTRAINTS.md", "POLARIZATION_ISOGENY.md", "COMPLETION_AUDIT.md",
    ]
    flattened = " ".join(" ".join((HERE / name).read_text().split()) for name in documents)
    for marker in [
        "I_p\\subset I_{P_t}^{(m)}",
        "the same five-form ideal",
        "not invariant under changing the resolution",
        "198\\,\\mathrm{id}",
        "No required J2 artifact remains open",
    ]:
        require(marker in flattened, f"document marker missing: {marker}")

    print("J_BASELOCUS_PRYM_VERIFY_OK")


if __name__ == "__main__":
    main()
