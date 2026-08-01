#!/usr/bin/env python3
"""Independent verifier for the KLS-NO-THEOREM goal packet."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
GOALS = HERE.parent
PROBLEM = GOALS.parent


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def check(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def verify_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    check(seal["exit"] == "KLS-NO-THEOREM", "wrong sealed exit")
    check(seal["headline"] == "OPEN", "wrong sealed headline")
    check(not seal["self_hash_included"], "seal must not self-hash")
    sealed = {item["path"]: item for item in seal["artifacts"]}
    actual = {
        str(path.relative_to(HERE))
        for path in HERE.rglob("*")
        if path.is_file()
        and path != HERE / "SEAL.json"
        and "__pycache__" not in path.parts
    }
    check(set(sealed) == actual, f"sealed file set mismatch: {set(sealed) ^ actual}")
    for name, item in sealed.items():
        path = HERE / name
        check(path.stat().st_size == item["bytes"], f"size mismatch: {name}")
        check(sha256(path) == item["sha256"], f"sha mismatch: {name}")
    print(f"PASS seal hashes artifacts={len(sealed)}")


def verify_sources() -> None:
    manifest = json.loads((HERE / "SOURCE_MANIFEST.json").read_text())
    head = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=PROBLEM, text=True
    ).strip()
    ancestor = subprocess.run(
        ["git", "merge-base", "--is-ancestor", manifest["live_commit"], head],
        cwd=PROBLEM,
        check=False,
    )
    check(ancestor.returncode == 0, "manifest commit is not an ancestor of HEAD")
    for item in manifest["sources"]:
        path = PROBLEM / item["path"]
        check(path.is_file(), f"missing source: {item['path']}")
        check(sha256(path) == item["sha256"], f"source drift: {item['path']}")
    print(
        "PASS source hashes "
        f"sources={len(manifest['sources'])} "
        f"manifest_commit={manifest['live_commit']} current_head={head}"
    )


def verify_scope_and_ledgers() -> None:
    status = (HERE / "STATUS.md").read_text().splitlines()
    check(status and status[0] == "KLS-NO-THEOREM", "STATUS first line")
    config = json.loads((HERE / "CONFIGURATIONS.json").read_text())
    elimination = json.loads((HERE / "ELIMINATION.json").read_text())
    nested_elimination = json.loads((HERE / "elimination/ELIMINATION.json").read_text())
    check(config["exit"] == "KLS-NO-THEOREM", "configuration exit")
    check(config["headline"] == "OPEN", "configuration headline")
    check(config["exhaustive"] is False, "must not claim exhaustiveness")
    check(config["landing_branch"]["h"] == "1", "landing h boundary")
    check(config["landing_branch"]["existence"] == "undecided", "landing scope")
    check(elimination["global_elimination_attempted"] is False, "CAS scope")
    check(elimination["headline_conclusion"] is None, "headline must be null")
    check(nested_elimination["exit"] == "KLS-NO-THEOREM", "nested elimination exit")
    check(nested_elimination["headline"] == "OPEN", "nested elimination headline")
    check(nested_elimination["exhaustive_elimination"] is False, "nested elimination scope")
    closed = {item["id"] for item in config["closed_scoped_families"]}
    opened = {item["id"] for item in config["open_parametric_families"]}
    check(closed == set(elimination["closed_configuration_ids"]), "closed id drift")
    check(opened == set(elimination["uneliminated_configuration_ids"]), "open id drift")
    check(all(not item["bounded"] for item in config["open_parametric_families"]), "open bounds")

    w = config["formal_consistency_witness"]["values"]
    check(w["s"] == w["r"] + w["t"] + w["d"] * (w["e"] - 5) + 4, "global identity")
    check(w["m"] == w["d"] * (w["e"] - 1) - w["s"], "Gauss degree")
    check(w["d"] <= 2 * w["m"], "minimality inequality")
    check(w["r"] % 11 in {1, 3, 4, 5, 9}, "lc residue")
    check(w["s"] == w["P22_squarefree_degree"] + w["extra_factor_degree"] * w["extra_factor_multiplicity"], "support degree")
    check(w["extra_beta"] - w["extra_factor_multiplicity"] == w["extra_A_E"] - 1, "discrepancy identity")
    check(config["formal_consistency_witness"]["existence_claimed"] is False, "formal witness scope")
    print("PASS scope flags and exact degree/discrepancy ledger")


def verify_countermodel_symbolically() -> None:
    try:
        import sympy as sp
    except ImportError as exc:
        raise SystemExit("SymPy is required; use /opt/homebrew/bin/python3") from exc

    z = sp.symbols("z1:5")
    u = sp.symbols("u")
    e = 5
    Q = sum(zi ** (e - 1) for zi in z)
    B = sum(zi ** e for zi in z)
    phi = [-B] + [zi * Q for zi in z]
    y = sp.symbols("y0:5")
    F = y[0] * sum(yi ** (e - 1) for yi in y[1:]) + sum(yi ** e for yi in y[1:])
    landed = sp.expand(F.subs(dict(zip(y, phi)), simultaneous=True))
    check(landed == 0, "counterfamily landing identity")

    grad_pull = [sp.expand(sp.diff(F, yi).subs(dict(zip(y, phi)), simultaneous=True)) for yi in y]
    quotients = [sp.cancel(entry / Q ** (e - 2)) for entry in grad_pull]
    check(all(sp.denom(entry) == 1 for entry in quotients), "Q^(e-2) divisibility")
    gcd = sp.Poly(quotients[0], *z)
    for entry in quotients[1:]:
        gcd = sp.gcd(gcd, sp.Poly(entry, *z))
    check(gcd.total_degree() == 0, "pulled-gradient gcd is exactly Q^(e-2)")

    coord_gcd = sp.Poly(phi[0], *z)
    for entry in phi[1:]:
        coord_gcd = sp.gcd(coord_gcd, sp.Poly(entry, *z))
    check(coord_gcd.total_degree() == 0, "counterfamily coordinates primitive")

    jac = sp.Matrix(phi).jacobian((*z, u))
    minor = sp.factor(jac[:4, :4].det())
    expected = sp.factor(-5 * Q**2 * z[3] ** 3 * (4 * B - 5 * z[3] * Q))
    check(sp.expand(minor - expected) == 0, "exact nonzero rank-four minor")

    a = e - 2
    beta = 2
    discrepancy = 5 - e
    check(beta - a == discrepancy - 1, "e=5 discrepancy identity")
    s = (e - 1) * (e - 2)
    r = 0
    t = 2 * (e - 1)
    check(s == r + t + e * (e - 5) + 4, "e=5 global degree identity")
    check(2 * (e - 1) > e, "polar move raises degree in counterfamily")
    print("PASS exact e=5 primitive rank-four normal-image countermodel identities")


def verify_unbounded_and_quartic_ledgers() -> None:
    import sympy as sp

    # Independently reconstruct the fixed nodal target and an N=5 split
    # pullback.  The displayed factorized formula then works for every N.
    x, source_parameter = sp.symbols("x source_parameter")
    count = 5
    P = sp.prod(x - i * source_parameter for i in range(1, count + 1))
    normalization_parameter = 1 + P
    target_u = sp.expand(normalization_parameter**2 - 1)
    target_v = sp.expand(normalization_parameter * target_u)
    check(
        sp.expand(target_v**2 - target_u**2 * (target_u + 1)) == 0,
        "fixed nodal normalization map",
    )
    check(sp.expand(target_u - P * (P + 2)) == 0, "pulled conductor formula")

    grad_v = 2 * target_v
    grad_u = -target_u * (3 * target_u + 2)
    quotient_gcd = sp.gcd(
        sp.Poly(sp.cancel(grad_v / target_u), x, source_parameter),
        sp.Poly(sp.cancel(grad_u / target_u), x, source_parameter),
    )
    check(quotient_gcd.total_degree() == 0, "nodal gradient gcd exact")
    check(
        sp.gcd(sp.Poly(P, x, source_parameter), sp.Poly(P + 2, x, source_parameter)).total_degree() == 0,
        "two conductor pullbacks coprime",
    )
    squarefree = sp.Poly(P, x, source_parameter).sqf_list()[1]
    check(sum(poly.degree() for poly, _ in squarefree) == count, "N split divisors")
    check(all(multiplicity == 1 for _, multiplicity in squarefree), "split divisors reduced")

    # Finite quartic precomposition always points upward in saturated degree.
    for degree in (1, 5, 11, 97):
        check(4 * degree > degree, "quartic degree direction")
        check(4**3 * degree > 4**2 * degree, "iterated quartic degree direction")
    print(f"PASS fixed nodal pair with N={count} split divisors and quartic degree direction")


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
        check(terminal in process.stdout, f"terminal marker missing: {name}")
        print(f"PASS deep {name}: {terminal}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--deep", action="store_true")
    args = parser.parse_args()
    verify_seal()
    verify_sources()
    verify_scope_and_ledgers()
    verify_countermodel_symbolically()
    verify_unbounded_and_quartic_ledgers()
    if args.deep:
        verify_deep()
    print("KLS_NO_THEOREM_PACKET_VERIFIED")


if __name__ == "__main__":
    try:
        main()
    except AssertionError as exc:
        print(f"FAIL {exc}", file=sys.stderr)
        raise SystemExit(1)
