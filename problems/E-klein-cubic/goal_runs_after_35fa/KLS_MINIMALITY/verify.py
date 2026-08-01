#!/usr/bin/env python3
"""Independent verifier for the KLS2 no-finite-reduction packet."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def check(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def verify_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    check(seal["exit"] == "KLS2-NO-FINITE-REDUCTION", "sealed exit")
    check(seal["headline"] == "OPEN", "sealed headline")
    check(seal["self_hash_included"] is False, "seal self-hash")
    sealed = {item["path"]: item for item in seal["artifacts"]}
    actual = {
        str(path.relative_to(HERE))
        for path in HERE.rglob("*")
        if path.is_file()
        and path != HERE / "SEAL.json"
        and "__pycache__" not in path.parts
    }
    check(set(sealed) == actual, f"sealed set mismatch: {set(sealed) ^ actual}")
    for name, item in sealed.items():
        path = HERE / name
        check(path.stat().st_size == item["bytes"], f"size mismatch: {name}")
        check(sha256(path) == item["sha256"], f"hash mismatch: {name}")
    print(f"PASS seal artifacts={len(sealed)}")


def verify_sources() -> None:
    manifest = json.loads((HERE / "SOURCE_MANIFEST.json").read_text())
    check(manifest["pinned_state"] == "35fa8f59b6a1423cc89300aeaceefe91552be5ba", "pinned state")
    for item in manifest["sources"]:
        path = PROBLEM / item["path"]
        check(path.is_file(), f"missing source: {item['path']}")
        check(path.stat().st_size == item["bytes"], f"source size drift: {item['path']}")
        check(sha256(path) == item["sha256"], f"source hash drift: {item['path']}")
    current_head = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=PROBLEM, text=True
    ).strip()
    print(
        f"PASS source hashes={len(manifest['sources'])} "
        f"manifest_commit={manifest['live_commit']} current_head={current_head}"
    )


def verify_scope() -> None:
    status = (HERE / "STATUS.md").read_text().splitlines()
    check(status and status[0] == "KLS2-NO-FINITE-REDUCTION", "STATUS first line")
    minimality = json.loads((HERE / "MINIMALITY_MODEL.json").read_text())
    configs = json.loads((HERE / "CONFIGURATIONS.json").read_text())
    eliminations = json.loads((HERE / "ELIMINATIONS.json").read_text())
    check(minimality["exit"] == status[0], "minimality exit")
    check(minimality["categories"]["klein_landing"]["h"] == "1", "landing h")
    check(minimality["categories"]["klein_landing"]["conductor"] == [], "landing conductor")
    check(minimality["categories"]["klein_landing"]["quartic_precomposition_is_equivalence"] is False, "quartic equivalence")
    check(configs["literal_landing_ledger"]["exhaustive"] is True, "literal exhaustiveness")
    check(len(configs["literal_landing_ledger"]["configurations"]) == 1, "literal singleton")
    landing = configs["literal_landing_ledger"]["configurations"][0]
    check(landing["id"] == "LANDING_SMOOTH_H1", "landing id")
    check(landing["eliminated"] is False, "landing nonelimination")
    check("separate landing/base-locus constraint" in landing["fifty_five_plane_arrangement"], "55-plane boundary")
    check("primitive saturation" in landing["scalar_invariant_multiplication"], "scalar saturation")
    check(configs["literal_landing_ledger"]["finite_reduction_of_existence_problem"] is False, "vacuous reduction")
    check(configs["broad_kls_ledger"]["exhaustive"] is False, "broad scope")
    check(len(configs["broad_kls_ledger"]["missing_theorems"]) == 2, "missing theorem count")
    check(eliminations["headline_conclusion"] is None, "headline null")
    check(eliminations["new_global_elimination_started"] is False, "CAS theorem gate")
    check(eliminations["literal_landing"]["eliminated"] is False, "literal elimination")
    print("PASS category split, singleton landing ledger, and strict open scope")


def verify_klein_smoothness() -> None:
    try:
        import sympy as sp
    except ImportError as exc:
        raise SystemExit("SymPy is required; use /opt/homebrew/bin/python3") from exc

    x = sp.symbols("x0:5")
    f3 = sum(x[i] ** 2 * x[(i + 1) % 5] for i in range(5))
    gradient = [sp.diff(f3, variable) for variable in x]
    for index, variable in enumerate(x):
        basis = sp.groebner(gradient + [variable - 1], *x, order="grevlex", domain=sp.QQ)
        check(any(poly.as_expr() == 1 for poly in basis.polys), f"singular point on chart {index}")
    euler = sp.expand(sum(x[i] * gradient[i] for i in range(5)) - 3 * f3)
    check(euler == 0, "Euler identity")
    print("PASS exact smoothness of Klein cubic on five projective charts")


def verify_generic_countermodels() -> None:
    import sympy as sp

    z = sp.symbols("z1:5")
    source_u = sp.symbols("source_u")
    e = 5
    Q = sum(variable ** (e - 1) for variable in z)
    B = sum(variable ** e for variable in z)
    phi = [-B] + [variable * Q for variable in z]
    y = sp.symbols("y0:5")
    F = y[0] * sum(variable ** (e - 1) for variable in y[1:]) + sum(variable ** e for variable in y[1:])
    substitution = dict(zip(y, phi))
    check(sp.expand(F.subs(substitution, simultaneous=True)) == 0, "Phi_e image")
    coordinate_gcd = sp.Poly(phi[0], *z)
    for entry in phi[1:]:
        coordinate_gcd = sp.gcd(coordinate_gcd, sp.Poly(entry, *z))
    check(coordinate_gcd.total_degree() == 0, "Phi_e primitive")
    gradient_pull = [sp.expand(sp.diff(F, variable).subs(substitution, simultaneous=True)) for variable in y]
    quotients = [sp.cancel(entry / Q ** (e - 2)) for entry in gradient_pull]
    quotient_gcd = sp.Poly(quotients[0], *z)
    for entry in quotients[1:]:
        quotient_gcd = sp.gcd(quotient_gcd, sp.Poly(entry, *z))
    check(quotient_gcd.total_degree() == 0, "exact Q^(e-2) gradient gcd")
    jacobian = sp.Matrix(phi).jacobian((*z, source_u))
    expected_minor = sp.factor(-5 * Q**2 * z[3] ** 3 * (4 * B - 5 * z[3] * Q))
    check(sp.expand(jacobian[:4, :4].det() - expected_minor) == 0, "rank-four minor")
    check(2 - (e - 2) == (5 - e) - 1, "discrepancy identity")

    x, s = sp.symbols("x s")
    count = 5
    P = sp.prod(x - i * s for i in range(1, count + 1))
    t_normal = 1 + P
    target_u = sp.expand(t_normal**2 - 1)
    target_v = sp.expand(t_normal * target_u)
    check(sp.expand(target_v**2 - target_u**2 * (target_u + 1)) == 0, "nodal normalization")
    check(sp.expand(target_u - P * (P + 2)) == 0, "nodal conductor pullback")
    check(sp.gcd(sp.Poly(P, x, s), sp.Poly(P + 2, x, s)).total_degree() == 0, "nodal coprime branches")
    print("PASS exact homogeneous discrepancy and split-conductor countermodels")


DEEP = [
    ("structural_successor", "tmp/kls_structural_successor/verify.py", "STRICT NONVERDICT no KLS solution or universal nonvanishing is proved"),
    ("global_foliation", "tmp/kls_global_foliation_theorem/verify.py", "STRICT NONVERDICT singular/noncanonical KLS image branch remains open"),
    ("minimal_contraction", "tmp/kls_minimal_contraction_attack/verify.py", "STRICT NONVERDICT minimal contraction and Klein unirationality remain open"),
    ("actual_conductor", "tmp/kls_actual_conductor_geometry/verify.py", "KLS_ACTUAL_CONDUCTOR_GEOMETRY_EXACT"),
    ("actual_conductor_audit", "tmp/kls_actual_conductor_geometry_audit/verify.py", "KLS_ACTUAL_CONDUCTOR_GEOMETRY_AUDIT_ACCEPTED"),
    ("proper_multiple", "tmp/kls_proper_multiple_structure/verify.py", "KLS_SQUAREFREE_PROPER_P22_BRANCH_EXCLUDED"),
    ("proper_multiple_audit", "tmp/kls_proper_multiple_structure_audit/verify.py", "KLS_PROPER_MULTIPLE_STRUCTURE_AUDIT_ACCEPT"),
    ("discrepancy", "tmp/kls_discrepancy_next_gate/verify.py", "KLS_DISCREPANCY_NEXT_GATE_EXACT"),
    ("discrepancy_audit", "tmp/kls_discrepancy_next_gate_audit/verify.py", "KLS_DISCREPANCY_NEXT_GATE_HOSTILE_AUDIT_ACCEPT"),
]


def verify_deep() -> None:
    for name, relative, terminal in DEEP:
        process = subprocess.run(
            ["/opt/homebrew/bin/python3", "-u", str(PROBLEM / relative)],
            cwd=PROBLEM,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
            timeout=900,
        )
        check(process.returncode == 0, f"deep verifier failed: {name}\n{process.stdout}")
        check(terminal in process.stdout, f"deep terminal missing: {name}")
        print(f"PASS deep {name}: {terminal}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--deep", action="store_true")
    args = parser.parse_args()
    verify_seal()
    verify_sources()
    verify_scope()
    verify_klein_smoothness()
    verify_generic_countermodels()
    if args.deep:
        verify_deep()
    print("KLS2_NO_FINITE_REDUCTION_PACKET_VERIFIED")


if __name__ == "__main__":
    try:
        main()
    except AssertionError as exc:
        print(f"FAIL {exc}", file=sys.stderr)
        raise SystemExit(1)
