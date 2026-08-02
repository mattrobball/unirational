#!/usr/bin/env python3
"""Independent G4A verifier.

Rebuilds coset actions from sealed H generators; matches stored s_perm/t_perm;
rebuilds all eleven G3-frame point substitutions; checks F_Klein=0 (split Phi);
checks P1,P10,P5×2 projector algebra; checks operation matrices.
Does not import produce_g4a.py.
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
from collections import deque
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402

H_A5 = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
P = 11
INF = 11


def fail(msg: str) -> None:
    print(f"G4A_VERIFY_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            h.update(c)
    return h.hexdigest()


def compose(L, R):
    return tuple(L[R[i]] for i in range(len(R)))


def inverse_perm(p):
    r = [0] * len(p)
    for i, t in enumerate(p):
        r[t] = i
    return tuple(r)


def mobius(m, pt):
    a, b, c, d = (x % P for x in m)
    if pt == INF:
        return INF if c == 0 else a * pow(c, -1, P) % P
    den = (c * pt + d) % P
    if den == 0:
        return INF
    return (a * pt + b) * pow(den, -1, P) % P


def permutation(matrix):
    return tuple(mobius(matrix, pt) for pt in range(12))


def closure(gens):
    idt = tuple(range(12))
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


def order(g):
    n = len(g)
    vis = [False] * n
    lcm = 1
    for i in range(n):
        if vis[i]:
            continue
        j = i
        cyc = 0
        while not vis[j]:
            vis[j] = True
            j = g[j]
            cyc += 1
        lcm = lcm * cyc // math.gcd(lcm, cyc)
    return lcm


def key_to_perm(key):
    a, b, c, d = key
    return permutation((a % 11, b % 11, c % 11, d % 11))


def build_perm_to_rho():
    return {key_to_perm(k): m for k, m in ew.rho.items()}


def mv(A, v):
    return [sum(A[i][j] * v[j] for j in range(5)) for i in range(5)]


def eval_F(v):
    total = ew.C(0)
    for i in range(5):
        total = total + v[i] * v[i] * v[(i + 1) % 5]
    return total


def json_to_c(coords10):
    """coords10: list of [num,den] length 10 → ew.C"""
    from fractions import Fraction as Q

    return ew.C(tuple(Q(n, d) for n, d in coords10))


def json_to_v(homog):
    return [json_to_c(c) for c in homog]


def mat_from_json(J):
    n = len(J)
    M = sp.zeros(n)
    for i in range(n):
        for j in range(n):
            M[i, j] = sp.Rational(J[i][j]["num"], J[i][j]["den"])
    return M


def main() -> None:
    for name in (
        "INPUT_MANIFEST.json",
        "coset_actions.json",
        "induced_points.json",
        "projectors.json",
        "operations.json",
        "COSET_ACTIONS.md",
        "PERMUTATION_PROJECTORS.md",
        "LOW_ARITY_OPERATIONS.md",
        "INDUCED_POINTS.md",
        "REPLAY.md",
        "SEAL.json",
        "STATUS.md",
        "verify_all.py",
        "produce_g4a.py",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    # produce_g4a must parse (not SyntaxError stub)
    src = (HERE / "produce_g4a.py").read_text()
    require('"""' in src[:200] or "'''" in src[:80], "produce docstring")
    require("def main" in src, "produce has main")
    require('\\"\\"\\"' not in src[:80], "produce not escaped-stub")

    status = (HERE / "STATUS.md").read_text()
    require(
        status.startswith("G4-INDUCED-DEGREE11-POINT-PASS\n")
        or status.startswith("G4-COSET-PROJECTOR-REDUCTION-PASS\n"),
        "STATUS exit",
    )
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("headline") == "OPEN", "headline OPEN")
    require(seal.get("exit") != "G4-POINT-HEADLINE-POSITIVE", "no false point")

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for item in man["inputs"]:
        p = ROOT / item["path"]
        require(p.is_file(), f"missing {item['path']}")
        require(sha256(p) == item["sha256"], f"hash {item['path']}")

    # Rebuild G
    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    G = list(closure([s, t]))
    require(len(G) == 660, "G order")
    perm_to_rho = build_perm_to_rho()
    require(all(g in perm_to_rho for g in G), "rho covers G")

    stored = json.loads((HERE / "coset_actions.json").read_text())
    require(len(stored["classes"]) == 2, "two classes stored")
    labels = {c["label"] for c in stored["classes"]}
    require(labels == {"A5_class_1", "A5_class_2"}, "labels")

    ind = json.loads((HERE / "induced_points.json").read_text())
    require(len(ind["classes"]) == 2, "two induced")

    base = [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)]
    require(eval_F(base) == ew.C(0), "base on F")

    for cl in stored["classes"]:
        # Rebuild H from sealed 12-perm generators
        rho12 = tuple(cl["H_gens_as_12perms"]["rho"])
        tau12 = tuple(cl["H_gens_as_12perms"]["tau"])
        H = set(closure([rho12, tau12]))
        require(len(H) == 60, f"H order {cl['label']}")

        # Rebuild cosets in same G-order as producer
        cosets = []
        used = set()
        for g in G:
            key = frozenset(compose(g, h) for h in H)
            if key not in used:
                used.add(key)
                cosets.append(g)
        require(len(cosets) == 11, "11 cosets")

        def act(g, rep):
            prod = compose(g, rep)
            key = frozenset(compose(prod, h) for h in H)
            for i, r in enumerate(cosets):
                if frozenset(compose(r, hh) for hh in H) == key:
                    return i
            fail("coset missing")

        ps = [act(s, c) for c in cosets]
        pt = [act(t, c) for c in cosets]

        # Match stored s_perm/t_perm exactly (same enumeration)
        require(ps == cl["coset_action"]["s_perm"], f"s_perm match {cl['label']}")
        require(pt == cl["coset_action"]["t_perm"], f"t_perm match {cl['label']}")
        require(cl["coset_action"]["image_order"] == 660, "image order")

        # Image order rebuild
        idt = tuple(range(11))
        seen = {idt}
        q = deque([idt])
        while q:
            cur = q.popleft()
            for gen in (tuple(ps), tuple(pt)):
                pr = tuple(gen[cur[i]] for i in range(11))
                if pr not in seen:
                    seen.add(pr)
                    q.append(pr)
        require(len(seen) == 660, "image 660 rebuild")

        s2 = sum(sum(1 for i in range(11) if g[i] == i) ** 2 for g in seen)
        s_aug = sum((sum(1 for i in range(11) if g[i] == i) - 1) ** 2 for g in seen)
        require(abs(s2 / 660 - 2.0) < 1e-9, "||chi||^2=2")
        require(abs(s_aug / 660 - 1.0) < 1e-9, "||chi_aug||^2=1")
        require("1 + 10" in cl["character_stats"]["decomposition_G"], "decomp")

        # Induced conjugates: rebuild coordinates and Phi/F=0
        ind_cl = next(c for c in ind["classes"] if c["label"] == cl["label"])
        require(ind_cl["degree"] == 11, "deg 11")
        require(len(ind_cl["conjugates"]) == 11, "11 conjugates")
        require(ind_cl["K_proj_cycle"]["defined_over_K_proj"] is True, "K_proj")

        for i, conj in enumerate(ind_cl["conjugates"]):
            require("G3_frame_coordinates" in conj, f"coords missing {i}")
            coords = conj["G3_frame_coordinates"]["homogeneous_coordinates"]
            require(len(coords) == 5, "5 homog")
            # Rebuild from coset rep + rho
            g = tuple(conj["coset_representative_12perm"])
            require(g == cosets[i], f"coset rep match {i}")
            rebuilt = mv(perm_to_rho[g], base)
            stored_v = json_to_v(coords)
            require(
                all(rebuilt[j] == stored_v[j] for j in range(5)),
                f"coord rebuild {cl['label']} {i}",
            )
            require(eval_F(stored_v) == ew.C(0), f"F=0 {cl['label']} {i}")
            require(eval_F(rebuilt) == ew.C(0), f"F=0 rebuilt {i}")
            require(conj["Phi_check"]["F_Klein_value"] == 0, "Phi_check flag")

        # H_A5 binding
        pp = ROOT / ind_cl["base_H_point"]["path"]
        require(pp.is_file(), "point path")
        ptj = json.loads(pp.read_text())
        require("RATIONAL-POINT" in ptj.get("exit", ""), "H_A5 exit")
        require(ptj.get("class") == cl["label"], "class match")

    # Projectors
    proj = json.loads((HERE / "projectors.json").read_text())
    require(proj["G_module_decomposition"].startswith("1"), "G decomp")
    P1 = mat_from_json(proj["shared_projectors_over_Q"]["P_trivial"])
    P10 = mat_from_json(proj["shared_projectors_over_Q"]["P_10"])
    require(sp.simplify(P1 * P1 - P1) == sp.zeros(11), "P1 idempotent")
    require(sp.simplify(P10 * P10 - P10) == sp.zeros(11), "P10 idempotent")
    require(sp.simplify(P1 * P10) == sp.zeros(11), "orthogonal")
    require(sp.simplify(P1 + P10 - sp.eye(11)) == sp.zeros(11), "sum I")
    require(sp.simplify(P1.trace()) == 1, "tr P1")
    require(sp.simplify(P10.trace()) == 10, "tr P10")

    # Two five-dimensional projectors (one per A5 class)
    require(len(proj["classes"]) == 2, "two proj classes")
    for pcl in proj["classes"]:
        require("five_dimensional_projector_A5" in pcl, "P5 missing")
        P5 = mat_from_json(pcl["five_dimensional_projector_A5"])
        require(sp.simplify(P5 * P5 - P5) == sp.zeros(11), f"P5 id {pcl['label']}")
        require(sp.simplify(P5.trace()) == 5, f"tr P5 {pcl['label']}")
        require(P5.rank() == 5, f"rank P5 {pcl['label']}")
        # Rebuild P5 from H generators
        scl = next(c for c in stored["classes"] if c["label"] == pcl["label"])
        rho12 = tuple(scl["H_gens_as_12perms"]["rho"])
        tau12 = tuple(scl["H_gens_as_12perms"]["tau"])
        H = set(closure([rho12, tau12]))
        cosets = []
        used = set()
        for g in G:
            key = frozenset(compose(g, h) for h in H)
            if key not in used:
                used.add(key)
                cosets.append(g)

        def act(g, rep, H=H, cosets=cosets):
            prod = compose(g, rep)
            key = frozenset(compose(prod, h) for h in H)
            for i, r in enumerate(cosets):
                if frozenset(compose(r, hh) for hh in H) == key:
                    return i
            fail("coset miss P5")

        P5b = sp.zeros(11)
        for h in H:
            o = order(h)
            ch = 5 if o == 1 else (1 if o == 2 else (-1 if o == 3 else 0))
            if ch == 0:
                continue
            hp = tuple(act(h, c) for c in cosets)
            M = sp.zeros(11)
            for i in range(11):
                M[hp[i], i] = 1
            P5b += ch * M
        P5b = sp.simplify(P5b * sp.Rational(5, 60))
        require(sp.simplify(P5b - P5) == sp.zeros(11), f"P5 rebuild {pcl['label']}")

    # Operations: exact matrices present and consistent
    ops = json.loads((HERE / "operations.json").read_text())
    require(ops["total_named_ops"] >= 8, "enough ops")
    require(len(ops["arity_1"]) >= 4, "arity1 with P5s")
    require(len(ops["arity_2"]) >= 3 and len(ops["arity_3"]) >= 3, "arity coverage")
    require(ops["applied_to_formal_cycle"]["P10_cycle"] == "0", "cycle pure trivial")
    require(len(ops["by_class"]) == 2, "ops by class")
    for boc in ops["by_class"]:
        a1 = boc["arity_1"]
        require("P5_A5_on_all_ones" in a1, "P5 applied")
        require("P10_on_all_ones" in a1, "P10 applied")
        # P10 on all-ones is zero
        p10_img = a1["P10_on_all_ones"]["on_all_ones_cycle"]
        require(all(x["num"] == 0 for x in p10_img), "P10(ones)=0")
        a2 = boc["arity_2"]
        M2 = mat_from_json(a2["M2_all_ones"]["matrix_11x11"])
        require(M2 == sp.ones(11), "M2 ones")
        M2p10 = mat_from_json(a2["P10_M2_P10"]["matrix_11x11"])
        require(sp.simplify(P10 * M2 * P10.T - M2p10) == sp.zeros(11), "M2 P10 rebuild")

    # H_A5 both classes
    require((H_A5 / "A5_class_1" / "point.json").is_file(), "class1")
    require((H_A5 / "A5_class_2" / "point.json").is_file(), "class2")
    p1 = json.loads((H_A5 / "A5_class_1" / "point.json").read_text())
    p2 = json.loads((H_A5 / "A5_class_2" / "point.json").read_text())
    require(p1["class"] != p2["class"], "classes distinct")

    # SEAL hashes for all listed packet files (SEAL.json itself not self-hashed)
    for name, expected in seal.get("files", {}).items():
        if name == "SEAL.json":
            continue
        path = HERE / name
        require(path.is_file(), f"sealed missing {name}")
        require(sha256(path) == expected, f"hash {name}")

    print("G4A_COSET_ACTIONS_OK")
    print("G4A_PROJECTORS_OK")
    print("G4A_INDUCED_CYCLES_OK")
    print("G4A_OPERATIONS_OK")
    print("G4A_PHI_SUBSTITUTION_OK")
    print("G4A_VERIFY_OK")
    print(seal["exit"])
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
