#!/usr/bin/env python3
"""Independent refutation of the withdrawn G7B induced-cycle materialization.

Rebuilds Stab([e0]), G·[e0], coset well-definedness, and equivariance of
p_i = rho(g_i) e0 for both H_A5 classes. Does not import produce.py.

Regression: STATUS/SEAL must not claim G7-INDUCED-DOUBLE-CYCLE-PASS unless a
correct (non-e0) materialization exists and passes verify_cycles.py.
Also fails if primary cycles.json reintroduces the e0 orbit as coordinates.
"""
from __future__ import annotations

import json
import sys
from collections import deque
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402

H_A5 = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
CANONICAL = H_A5 / "canonical_model_payload.json"
P, INF, NPTS = 11, 11, 12


def fail(msg: str) -> None:
    print(f"G7B_AUDIT_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def compose(L, R):
    return tuple(L[R[i]] for i in range(len(R)))


def mobius(m, pt):
    a, b, c, d = (x % P for x in m)
    if pt == INF:
        return INF if c == 0 else a * pow(c, -1, P) % P
    den = (c * pt + d) % P
    return INF if den == 0 else (a * pt + b) * pow(den, -1, P) % P


def permutation(matrix):
    return tuple(mobius(matrix, pt) for pt in range(NPTS))


def closure(gens):
    idt = tuple(range(NPTS))
    seen = {idt}
    q = deque([idt])
    while q:
        cur = q.popleft()
        for g in gens:
            pr = compose(g, cur)
            if pr not in seen:
                seen.add(pr)
                q.append(pr)
    return seen


def key_to_perm(key):
    a, b, c, d = key
    return permutation((a % 11, b % 11, c % 11, d % 11))


def mv(M, v):
    return [sum((M[i][k] * v[k] for k in range(5)), ew.C(0)) for i in range(5)]


def proj_eq(u, v):
    j0 = next((j for j in range(5) if v[j] != ew.C(0)), None)
    if j0 is None:
        return all(x == ew.C(0) for x in u)
    for k in range(5):
        if u[k] * v[j0] != v[k] * u[j0]:
            return False
    return True


def json_to_c(coords10):
    return ew.C(tuple(Q(n, d) for n, d in coords10))


def json_to_v(homog):
    return [json_to_c(c) for c in homog]


def main() -> None:
    require_no_produce = "produce" not in sys.modules
    if not require_no_produce:
        fail("must not import produce")

    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    G = list(closure([s, t]))
    if len(G) != 660:
        fail(f"|G|={len(G)}")
    perm_to_rho = {key_to_perm(k): m for k, m in ew.rho.items()}
    if not all(g in perm_to_rho for g in G):
        fail("rho coverage")

    e0 = [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)]
    stab = [g for g in G if proj_eq(mv(perm_to_rho[g], e0), e0)]
    orbit = []
    for g in G:
        ge = mv(perm_to_rho[g], e0)
        if not any(proj_eq(ge, r) for r in orbit):
            orbit.append(ge)

    print(f"Stab([e0]) = {len(stab)}")
    print(f"|G·[e0]| = {len(orbit)}")
    if len(stab) != 11 or len(orbit) != 60:
        fail(f"expected Stab=11 orbit=60; got {len(stab)}, {len(orbit)}")

    payload = json.loads(CANONICAL.read_text())
    total_fail = 0
    total_checks = 0
    for idx, cl in enumerate(payload["classes"], start=1):
        gens = cl["subgroup_generators"]
        a = key_to_perm(tuple(gens[0]))
        b = key_to_perm(tuple(gens[1]))
        H = set(closure([a, b]))
        if len(H) != 60:
            fail(f"H order class {idx}")
        stab_set = set(stab)
        inter = len(H & stab_set)
        print(f"class {idx}: |H ∩ Stab([e0])| = {inter}")
        if inter == 60:
            fail(f"H stabilizes [e0] unexpectedly (class {idx})")

        cosets = []
        used = set()
        for g in G:
            key = frozenset(compose(g, h) for h in H)
            if key not in used:
                used.add(key)
                cosets.append(g)
        if len(cosets) != 11:
            fail("cosets")

        pts = [mv(perm_to_rho[g], e0) for g in cosets]

        def act(g, rep, H=H, cosets=cosets):
            prod = compose(g, rep)
            key = frozenset(compose(prod, h) for h in H)
            for i, r in enumerate(cosets):
                if frozenset(compose(r, hh) for hh in H) == key:
                    return i
            fail("coset missing")

        ps = [act(s, c) for c in cosets]
        pt = [act(t, c) for c in cosets]
        fails_s = fails_t = 0
        for i in range(11):
            total_checks += 2
            if not proj_eq(mv(perm_to_rho[s], pts[i]), pts[ps[i]]):
                fails_s += 1
                total_fail += 1
            if not proj_eq(mv(perm_to_rho[t], pts[i]), pts[pt[i]]):
                fails_t += 1
                total_fail += 1
        print(f"class {idx}: equivar fails s={fails_s}/11 t={fails_t}/11")

        bad = 0
        g0 = cosets[0]
        for h in H:
            g2 = compose(g0, h)
            if not proj_eq(mv(perm_to_rho[g2], e0), pts[0]):
                bad += 1
        print(f"class {idx}: well-defined failures coset0 = {bad}/{len(H)}")
        if bad == 0:
            fail(f"coset map unexpectedly well-defined (class {idx})")

    print(f"TOTAL equivar failures {total_fail} of {total_checks}")
    if total_fail != 44:
        fail(f"expected 44 equivar failures, got {total_fail}")

    # Packet policy: no fake induced pass
    status = (HERE / "STATUS.md").read_text().splitlines()[0].strip()
    seal = (
        json.loads((HERE / "SEAL.json").read_text())
        if (HERE / "SEAL.json").is_file()
        else {}
    )
    cycles = (
        json.loads((HERE / "cycles.json").read_text())
        if (HERE / "cycles.json").is_file()
        else {}
    )

    # Detect e0 reintroduction in primary cycles.json
    if cycles.get("classes"):
        for cl in cycles["classes"]:
            conj_list = cl.get("conjugates") or []
            if not conj_list and "abstract_induction" in cl:
                continue
            if not conj_list:
                continue
            coset_reps = []
            pts_stored = []
            ok = True
            for conj in conj_list:
                g3 = conj.get("G3_frame_coordinates") or {}
                raw = g3.get("homogeneous_coordinates_raw")
                if raw is None:
                    ok = False
                    break
                coset_reps.append(tuple(conj["coset_representative_12perm"]))
                pts_stored.append(json_to_v(raw))
            if ok and len(pts_stored) == 11:
                matches = 0
                for g, p in zip(coset_reps, pts_stored):
                    if g in perm_to_rho and proj_eq(mv(perm_to_rho[g], e0), p):
                        matches += 1
                if matches == 11:
                    fail(
                        f"primary cycles.json reintroduces e0 orbit for {cl.get('label')}"
                    )

    if status == "G7-INDUCED-DOUBLE-CYCLE-PASS":
        # Only allowed if materialization is non-residual AND not e0
        if cycles.get("materialization_status") == "RESIDUAL":
            fail("STATUS claims induced pass but cycles are RESIDUAL")
        if cycles.get("schema") == "g7b-induced-double-cycles-residual-v2":
            fail("STATUS claims induced pass on residual schema")
        # If pass is claimed, equivariance must hold — run verify_cycles externally.
        # Here: refuse if schema is old v1 without proof of non-e0.
        if cycles.get("schema") == "g7b-induced-double-cycles-v1":
            fail(
                "STATUS still claims G7-INDUCED-DOUBLE-CYCLE-PASS on withdrawn v1 schema"
            )

    if seal.get("exit") == "G7-INDUCED-DOUBLE-CYCLE-PASS":
        if cycles.get("materialization_status") == "RESIDUAL":
            fail("SEAL claims induced pass but cycles are RESIDUAL")
        if cycles.get("schema") in (
            "g7b-induced-double-cycles-residual-v2",
            "g7b-induced-double-cycles-v1",
        ):
            # v1 is the withdrawn e0 packet; residual is honest non-pass
            if cycles.get("schema") == "g7b-induced-double-cycles-v1":
                fail("SEAL still claims G7-INDUCED-DOUBLE-CYCLE-PASS on v1 e0 schema")
            if cycles.get("materialization_status") == "RESIDUAL":
                fail("SEAL still claims G7-INDUCED-DOUBLE-CYCLE-PASS")

    print("G7B-INDUCED-CYCLE-REFUTED")
    print("G7B_AUDIT_OK")


if __name__ == "__main__":
    main()
