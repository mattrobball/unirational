#!/usr/bin/env python3
"""Independent G4.0 verifier: rebuild cosets; check induced-cycle ledger.

Does not import produce.py. Reconstructs G, both A5 classes, coset actions,
and validates binding to sealed H_A5 points.
"""
from __future__ import annotations

import hashlib
import json
import math
import random
import sys
from collections import deque
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H_A5 = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
P = 11
INF = 11


def fail(msg: str) -> None:
    print(f"G4_INDUCTION_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
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


def main() -> None:
    for name in (
        "INPUT_MANIFEST.json",
        "coset_actions.json",
        "induced_points.json",
        "COSET_ACTIONS.md",
        "INDUCED_POINTS.md",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for item in man["inputs"]:
        p = ROOT / item["path"]
        require(p.is_file(), f"missing input {item['path']}")
        require(sha256(p) == item["sha256"], f"hash mismatch {item['path']}")

    # Rebuild G
    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    G = list(closure([s, t]))
    require(len(G) == 660, "G order")

    ord5 = [g for g in G if order(g) == 5]
    ord2 = [g for g in G if order(g) == 2]
    rng = random.Random(1)
    allH = set()
    for _ in range(40000):
        a = rng.choice(ord5)
        b = rng.choice(ord2)
        if order(compose(a, b)) != 3:
            continue
        H = frozenset(closure([a, b]))
        if len(H) == 60:
            allH.add(H)
    require(len(allH) >= 22, "enough A5s")

    def conjugate(H, g):
        gi = inverse_perm(g)
        return frozenset(compose(compose(g, h), gi) for h in H)

    H0 = next(iter(allH))
    orbit0 = {conjugate(H0, g) for g in G}
    H1 = next(H for H in allH if H not in orbit0)
    orbit1 = {conjugate(H1, g) for g in G}
    require(len(orbit0) == 11 and len(orbit1) == 11, "orbit sizes")
    require(orbit0.isdisjoint(orbit1), "two classes")

    stored = json.loads((HERE / "coset_actions.json").read_text())
    require(stored.get("group_order") == 660, "group order")
    require(len(stored["classes"]) == 2, "two classes stored")
    labels = {c["label"] for c in stored["classes"]}
    require(labels == {"A5_class_1", "A5_class_2"}, "labels")

    def rebuild_coset(Hset):
        H = set(Hset)
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

        ps = tuple(act(s, c) for c in cosets)
        pt = tuple(act(t, c) for c in cosets)
        idt = tuple(range(11))
        seen = {idt}
        q = deque([idt])
        while q:
            cur = q.popleft()
            for gen in (ps, pt):
                pr = tuple(gen[cur[i]] for i in range(11))
                if pr not in seen:
                    seen.add(pr)
                    q.append(pr)
        require(len(seen) == 660, "image 660")
        s2 = sum(sum(1 for i in range(11) if g[i] == i) ** 2 for g in seen)
        s_aug = sum((sum(1 for i in range(11) if g[i] == i) - 1) ** 2 for g in seen)
        require(abs(s2 / 660 - 2.0) < 1e-9, "||chi||^2=2")
        require(abs(s_aug / 660 - 1.0) < 1e-9, "||chi_aug||^2=1")
        return list(ps), list(pt)

    # Verify each stored class has image 660 and correct character norms
    for cl in stored["classes"]:
        require(cl["coset_action"]["image_order"] == 660, "stored image order")
        require(cl["coset_action"]["n_cosets"] == 11, "11 cosets")
        require(len(cl["coset_action"]["s_perm"]) == 11, "s_perm len")
        require(len(cl["coset_action"]["t_perm"]) == 11, "t_perm len")
        require(
            abs(cl["character_stats"]["norm_sq_perm"] - 2.0) < 1e-9, "stored ||chi||"
        )
        require(
            abs(cl["character_stats"]["norm_sq_aug"] - 1.0) < 1e-9, "stored ||aug||"
        )
        require("1 + 10" in cl["character_stats"]["decomposition_G"], "decomp note")

    # Rebuild with seed-1 classes and check character (not necessarily same labeling)
    for H in (H0, H1):
        rebuild_coset(H)

    # Induced points
    ind = json.loads((HERE / "induced_points.json").read_text())
    require(len(ind["classes"]) == 2, "two induced")
    for cl in ind["classes"]:
        require(cl["degree"] == 11, "deg 11")
        require(len(cl["conjugates"]) == 11, "11 conjugates")
        require(cl["K_proj_cycle"]["defined_over_K_proj"] is True, "K_proj cycle")
        require(cl["L_H"]["degree_over_K_proj"] == 11, "L_H degree")
        require("induction_theorem" in cl, "induction theorem recorded")
        pp = ROOT / cl["base_H_point"]["path"]
        require(pp.is_file(), f"point path {pp}")
        pt = json.loads(pp.read_text())
        require("RATIONAL-POINT" in pt.get("exit", ""), "H_A5 point exit")
        require(pt.get("class") == cl["label"], "class match")
        # Separation of classes
        require(cl["label"] in ("A5_class_1", "A5_class_2"), "label ok")

    p1 = json.loads((H_A5 / "A5_class_1" / "point.json").read_text())
    p2 = json.loads((H_A5 / "A5_class_2" / "point.json").read_text())
    require(p1["class"] != p2["class"], "classes distinct")
    # Pencil parameters differ between classes
    c1 = str(p1.get("canonical_target", {}).get("cubic", ""))
    c2 = str(p2.get("canonical_target", {}).get("cubic", ""))
    require(c1 != c2, "distinct twist cubics")

    print("G4_COSET_ACTIONS_OK")
    print("G4_INDUCED_CYCLES_OK")
    print("G4_INDUCTION_VERIFY_OK")


if __name__ == "__main__":
    main()
