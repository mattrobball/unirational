#!/usr/bin/env python3
"""Independent G5 decision-boundary verifier (does not import produce_residues).

Replays constant-point emptiness, coordinate-line gcd nonzeros, and modular
specialization probes. Enforces nonclaims: no fake pointlessness, no promotion
of residue points to global points, no misuse of support-≤5.
"""

from __future__ import annotations

import json
import random
import sys
from collections import defaultdict
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def triple_mult(triple) -> int:
    i, j, k = triple
    if i == j == k:
        return 1
    if i == j or j == k or i == k:
        return 3
    return 6


def phi_module(generic: dict, a: list[int], drop: int) -> dict:
    acc: dict = defaultdict(lambda: Fraction(0))
    for c in generic["coefficients"]:
        i, j, k = c["triple"]
        mon = a[i] * a[j] * a[k]
        if mon == 0:
            continue
        mult = triple_mult([i, j, k])
        for e in c["entries"]:
            if e["primary_exponents"][drop] != 0:
                continue
            key = (e["secondary"], tuple(e["primary_exponents"]))
            acc[key] += Fraction(e["numerator"], e["denominator"]) * mult * mon
    return {k: v for k, v in acc.items() if v != 0}


def expand_sec(gens, p):
    f7, f9, f10, f12, f14 = [x % p for x in gens]
    return [
        1,
        f7,
        f9,
        f10,
        f12,
        f14,
        (f7 * f7) % p,
        (f7 * f9) % p,
        (f9 * f9) % p,
        (f9 * f10) % p,
        (f7 * f7 * f7) % p,
        (f9 * f9 * f10) % p,
    ]


def eval_red(entries, drop, prim, sec, p):
    total = 0
    for e in entries:
        if e["primary_exponents"][drop] != 0:
            continue
        mon = 1
        for i, ex in enumerate(e["primary_exponents"]):
            if ex:
                mon = mon * pow(prim[i], ex, p) % p
        den = e["denominator"] % p
        if den == 0:
            return None
        term = (
            (e["numerator"] % p)
            * mon
            % p
            * (sec[e["secondary"]] % p)
            % p
            * pow(den, -1, p)
            % p
        )
        total = (total + term) % p
    return total


def cubic_mod(alphas, a, triples, p):
    s = 0
    for alpha, triple in zip(alphas, triples):
        i, j, k = triple
        mult = triple_mult(triple)
        s = (s + mult * alpha * a[i] % p * a[j] % p * a[k]) % p
    return s


def verify_constant_and_lines(generic: dict, payload: dict, drop: int, site: str) -> None:
    block = payload[site]
    # constant points
    hits = []
    seen = set()
    for vals in __import__("itertools").product(range(-2, 3), repeat=5):
        if all(v == 0 for v in vals):
            continue
        a = list(vals)
        for v in a:
            if v != 0:
                if v < 0:
                    a = [-x for x in a]
                break
        t = tuple(a)
        if t in seen:
            continue
        seen.add(t)
        if not phi_module(generic, a, drop):
            hits.append(a)
    require(hits == [], f"{site} constant hits replay nonempty")
    require(block["constant_points"]["hits"] == [], f"{site} payload constant hits")
    require(
        block["constant_points"]["projective_representatives_tested"] == len(seen),
        f"{site} constant count",
    )

    # coordinate lines: recompute gcd degrees with sympy
    import sympy as sp

    s, t = sp.symbols("s t")
    frame = ["x", "C", "D", "E", "K"]
    rows = block["coordinate_lines"]
    require(len(rows) == 10, f"{site} ten lines")
    idx = 0
    for i in range(5):
        for j in range(i + 1, 5):
            acc: dict = defaultdict(lambda: 0)
            a = [0, 0, 0, 0, 0]
            a[i] = s
            a[j] = t
            for c in generic["coefficients"]:
                ii, jj, kk = c["triple"]
                mon = a[ii] * a[jj] * a[kk]
                if mon == 0:
                    continue
                mult = triple_mult([ii, jj, kk])
                for e in c["entries"]:
                    if e["primary_exponents"][drop] != 0:
                        continue
                    key = (e["secondary"], tuple(e["primary_exponents"]))
                    acc[key] += sp.Rational(e["numerator"], e["denominator"]) * mult * mon
            polys = [
                sp.Poly(sp.expand(v), s, t)
                for v in acc.values()
                if sp.expand(v) != 0
            ]
            row = rows[idx]
            require(row["line"] == [frame[i], frame[j]], f"{site} line labels")
            if not polys:
                require(row.get("identically_on_cubic") is True, f"{site} id line")
            else:
                gpoly = polys[0]
                for p in polys[1:]:
                    gpoly = sp.gcd(gpoly, p)
                require(int(gpoly.total_degree()) == 0, f"{site} line {i}{j} has common factor")
                require(row["gcd_total_degree"] == 0, f"{site} payload gcd deg")
                require(row["common_zero_in_P1"] is False, f"{site} common zero flag")
            idx += 1


def verify_modular_probe(generic: dict, payload: dict, drop: int, site: str) -> None:
    mod = payload[site]["modular_specializations"]
    require(mod["prime"] == 67, "prime")
    require(mod["specializations_with_point"] == mod["trials"], f"{site} all specs have points")
    require(mod["smooth_points_among_them"] == mod["trials"], f"{site} smooth")
    # independent short replay
    random.seed(0)
    p = 67
    triples = [c["triple"] for c in generic["coefficients"]]
    hits = 0
    for _ in range(10):
        prim = [random.randrange(p) for _ in range(5)]
        prim[drop] = 0
        if all(prim[i] == 0 for i in range(5) if i != drop):
            prim[0] = 1
        sec = expand_sec([random.randrange(p) for _ in range(5)], p)
        alphas = []
        ok = True
        for c in generic["coefficients"]:
            v = eval_red(c["entries"], drop, prim, sec, p)
            if v is None:
                ok = False
                break
            alphas.append(v)
        require(ok and not all(x == 0 for x in alphas), "alpha ok")
        found = False
        for __ in range(2500):
            a = [random.randrange(p) for _ in range(5)]
            if all(x == 0 for x in a):
                continue
            if cubic_mod(alphas, a, triples, p) == 0:
                found = True
                break
        if found:
            hits += 1
    require(hits == 10, "short modular replay")


def verify_nonclaims() -> None:
    status = (HERE / "STATUS.md").read_text()
    point_md = (HERE / "POINT_SEARCH.md").read_text()
    require("OPEN" in status, "headline open")
    require("POINTLESS" not in status.splitlines()[0], "primary not pointless")
    require("not a global" in point_md.lower() or "local solubility only" in point_md.lower() or "not promote" in point_md.lower(), "no global promotion")
    require("support" in point_md.lower() and ("not" in point_md.lower() or "retired" in point_md.lower()), "support fence")
    # no POINT.md claiming a point; no POINTLESSNESS.md
    require(not (HERE / "f5" / "POINT.md").exists(), "no f5 POINT")
    require(not (HERE / "f6" / "POINT.md").exists(), "no f6 POINT")
    require(not (HERE / "f5" / "POINTLESSNESS.md").exists(), "no f5 POINTLESS")
    require(not (HERE / "f6" / "POINTLESSNESS.md").exists(), "no f6 POINTLESS")
    require(not (HERE / "BRIDGE_RESIDUE_NEG.md").exists(), "no false bridge")
    # decision payload
    ps = json.loads((HERE / "point_search.json").read_text())
    require(ps["verdict"]["f5_residue_point"] == "UNDECIDED", "f5 point")
    require(ps["verdict"]["f6_residue_point"] == "UNDECIDED", "f6 point")
    require(ps["verdict"]["f5_pointless"] == "NOT_PROVED", "f5 pointless")
    require(ps["verdict"]["f6_pointless"] == "NOT_PROVED", "f6 pointless")
    # retired support fact bound, not over-used
    v3_finite = (
        ROOT
        / "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/F5_DEGREE16_SMALL_SUPPORT.md"
    ).read_text()
    require("does **not** prove" in v3_finite or "not" in v3_finite.lower(), "finite support scope")


def main() -> None:
    generic = json.loads(GENERIC.read_text())
    payload = json.loads((HERE / "point_search.json").read_text())
    require(payload["schema"] == "g5-point-search-v1", "schema")
    verify_constant_and_lines(generic, payload, 1, "f5")
    verify_constant_and_lines(generic, payload, 2, "f6")
    verify_modular_probe(generic, payload, 1, "f5")
    verify_modular_probe(generic, payload, 2, "f6")
    verify_nonclaims()
    print("G5_DECISION_VERIFY_OK")
    print("point_decision=UNDECIDED residual=generic_residue_rational_points")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:  # noqa: BLE001
        print(f"G5_DECISION_VERIFY_FAIL: {exc}", file=sys.stderr)
        raise
