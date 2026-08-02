#!/usr/bin/env python3
"""Independent G7A verifier: regenerate G, A5 classes, incidence, projectors.

Does NOT import produce.py. Reconstructs the group and design from generators
and checks sealed artifacts for consistency.
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
from collections import Counter, deque
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]  # .../E-klein-cubic
P = 11
INF = 11
NPTS = 12


def fail(msg: str) -> None:
    print(f"G7A_VERIFY_FAIL: {msg}", file=sys.stderr)
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


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(right)))


def inverse_perm(perm):
    r = [0] * len(perm)
    for s, t in enumerate(perm):
        r[t] = s
    return tuple(r)


def mobius(matrix, point):
    a, b, c, d = (x % P for x in matrix)
    if point == INF:
        return INF if c == 0 else a * pow(c, -1, P) % P
    den = (c * point + d) % P
    if den == 0:
        return INF
    return (a * point + b) * pow(den, -1, P) % P


def permutation(matrix):
    return tuple(mobius(matrix, pt) for pt in range(NPTS))


def closure(gens, n=NPTS):
    idt = tuple(range(n))
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


def conjugate_set(H, g):
    gi = inverse_perm(g)
    return frozenset(compose(compose(g, h), gi) for h in H)


def element_order_signature(S):
    return tuple(sorted(Counter(order(g) for g in S).items()))


def main() -> None:
    for name in (
        "INPUT_MANIFEST.json",
        "design.json",
        "incidence_N.json",
        "cross_intersections.json",
        "projectors.json",
        "DESIGN.md",
        "PERMUTATION_PROJECTORS.md",
        "STATUS.md",
        "REPLAY.md",
        "produce_meta.json",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for item in man["inputs"]:
        p = ROOT / item["path"]
        require(p.is_file(), f"missing input {item['path']}")
        require(sha256(p) == item["sha256"], f"hash mismatch {item['path']}")

    design = json.loads((HERE / "design.json").read_text())
    inc = json.loads((HERE / "incidence_N.json").read_text())
    cross = json.loads((HERE / "cross_intersections.json").read_text())
    proj = json.loads((HERE / "projectors.json").read_text())
    status = (HERE / "STATUS.md").read_text()
    require(status.splitlines()[0].strip() in {
        "G7-CROSS-CLASS-PROJECTOR-PASS",
        "G7-PALEY-BIPLANE-IDENTIFIED",
        "G7-DESIGN-CORRECTION",
    }, "STATUS first line not an authorized exit")

    # --- regenerate G ---
    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    Gset = closure([s, t])
    require(len(Gset) == 660, "G order")
    G = sorted(Gset)

    # --- all maximal A5 ---
    ord5 = [g for g in G if order(g) == 5]
    ord2 = [g for g in G if order(g) == 2]
    allH = set()
    for a in ord5:
        for b in ord2:
            if order(compose(a, b)) != 3:
                continue
            H = frozenset(closure([a, b]))
            if len(H) == 60:
                allH.add(H)
    require(len(allH) == 22, f"expected 22 A5s, got {len(allH)}")

    remaining = set(allH)
    classes = []
    while remaining:
        H0 = min(remaining, key=lambda H: min(H))
        orbit = {conjugate_set(H0, g) for g in G}
        require(len(orbit) == 11, "class size")
        classes.append(sorted(orbit, key=lambda H: min(H)))
        remaining -= orbit
    require(len(classes) == 2, "two classes")
    classes.sort(key=lambda orb: min(orb[0]))
    Hs, Ks = classes

    # --- cross intersections & N ---
    N = [[0] * 11 for _ in range(11)]
    hist = Counter()
    type_hist = Counter()
    for i, H in enumerate(Hs):
        for j, K in enumerate(Ks):
            I = H & K
            n = len(I)
            hist[n] += 1
            sig = dict(element_order_signature(I))
            if n == 12 and sig == {1: 1, 2: 3, 3: 8}:
                typ = "A4"
                N[i][j] = 1
            elif n == 10 and sig == {1: 1, 2: 5, 5: 4}:
                typ = "D5"
            else:
                fail(f"unexpected intersection order={n} sig={sig}")
            type_hist[f"order_{n}_{typ}"] += 1

    require(hist[12] == 55 and hist[10] == 66, f"hist {hist}")
    require(N == design["incidence_matrix_N"], "N mismatch vs design.json")
    require(N == inc["N"], "N mismatch vs incidence_N.json")

    # biplane identities
    M = sp.Matrix(N)
    I11 = sp.eye(11)
    J = sp.ones(11)
    target = 3 * I11 + 2 * J
    require(M * M.T == target, "NN^t != 3I+2J")
    require(M.T * M == target, "N^t N != 3I+2J")
    row_sums = [sum(N[i]) for i in range(11)]
    col_sums = [sum(N[i][j] for i in range(11)) for j in range(11)]
    require(all(r == 5 for r in row_sums), "row sums")
    require(all(c == 5 for c in col_sums), "col sums")
    for i in range(11):
        for k in range(i + 1, 11):
            meet = sum(N[i][j] * N[k][j] for j in range(11))
            require(meet == 2, f"row meet {i},{k}={meet}")
    for j in range(11):
        for l in range(j + 1, 11):
            meet = sum(N[i][j] * N[i][l] for i in range(11))
            require(meet == 2, f"col meet {j},{l}={meet}")

    require(design["design_identities"]["is_paley_biplane"] is True, "flag")
    require(design["markers"]["G7-PALEY-BIPLANE-IDENTIFIED"] is True, "marker")

    # orbits: two by intersection type
    # quick check: conjugate of incident is incident
    Hidx = {H: i for i, H in enumerate(Hs)}
    Kidx = {K: j for j, K in enumerate(Ks)}
    orbit_inc = set()
    orbit_non = set()
    # seed one of each
    seed_inc = next((i, j) for i in range(11) for j in range(11) if N[i][j] == 1)
    seed_non = next((i, j) for i in range(11) for j in range(11) if N[i][j] == 0)
    for seed, bucket in ((seed_inc, orbit_inc), (seed_non, orbit_non)):
        i0, j0 = seed
        H0, K0 = Hs[i0], Ks[j0]
        for g in G:
            bucket.add((Hidx[conjugate_set(H0, g)], Kidx[conjugate_set(K0, g)]))
    require(len(orbit_inc) == 55, f"inc orbit {len(orbit_inc)}")
    require(len(orbit_non) == 66, f"non orbit {len(orbit_non)}")
    require(orbit_inc.isdisjoint(orbit_non), "orbit overlap")
    require(len(orbit_inc | orbit_non) == 121, "orbit cover")

    # automorphism: conjugation by s,t preserves N
    def conj_perm(orbit, g):
        idx = {H: i for i, H in enumerate(orbit)}
        return [idx[conjugate_set(H, g)] for H in orbit]

    psH, ptH = conj_perm(Hs, s), conj_perm(Hs, t)
    psK, ptK = conj_perm(Ks, s), conj_perm(Ks, t)

    def apply(pH, pK):
        return [[N[i][j] for j in range(11)] for i in range(11)]  # placeholder

    for pH, pK in ((psH, psK), (ptH, ptK)):
        Np = [[0] * 11 for _ in range(11)]
        for i in range(11):
            for j in range(11):
                Np[pH[i]][pK[j]] = N[i][j]
        require(Np == N, "generator does not preserve N")

    idt = (tuple(range(11)), tuple(range(11)))
    seen = {idt}
    q = deque([idt])
    gens = ((tuple(psH), tuple(psK)), (tuple(ptH), tuple(ptK)))
    while q:
        curH, curK = q.popleft()
        for gH, gK in gens:
            nH = tuple(gH[curH[i]] for i in range(11))
            nK = tuple(gK[curK[i]] for i in range(11))
            pr = (nH, nK)
            if pr not in seen:
                seen.add(pr)
                q.append(pr)
    require(len(seen) == 660, f"Aut image order {len(seen)}")

    # character norms on coset action of base H
    H0 = Hs[0]
    cosets = []
    used = set()
    for g in G:
        key = frozenset(compose(g, h) for h in H0)
        if key not in used:
            used.add(key)
            cosets.append(g)
    require(len(cosets) == 11, "cosets")

    def act(g, rep):
        prod = compose(g, rep)
        key = frozenset(compose(prod, h) for h in H0)
        for i, r in enumerate(cosets):
            if frozenset(compose(r, h) for h in H0) == key:
                return i
        fail("coset miss")

    ps = tuple(act(s, c) for c in cosets)
    pt = tuple(act(t, c) for c in cosets)
    idt11 = tuple(range(11))
    im = {idt11}
    qq = deque([idt11])
    while qq:
        cur = qq.popleft()
        for gen in (ps, pt):
            pr = tuple(gen[cur[i]] for i in range(11))
            if pr not in im:
                im.add(pr)
                qq.append(pr)
    require(len(im) == 660, "coset image order")
    s2 = sum(sum(1 for i in range(11) if g[i] == i) ** 2 for g in im)
    s_aug = sum((sum(1 for i in range(11) if g[i] == i) - 1) ** 2 for g in im)
    require(abs(s2 / 660.0 - 2.0) < 1e-12, f"norm_sq_perm {s2/660}")
    require(abs(s_aug / 660.0 - 1.0) < 1e-12, f"norm_sq_aug {s_aug/660}")

    # projectors
    P1 = sp.ones(11) / 11
    P10 = sp.eye(11) - P1
    require(sp.simplify(P1 * P1 - P1) == sp.zeros(11), "P1 idem")
    require(sp.simplify(P10 * P10 - P10) == sp.zeros(11), "P10 idem")
    require(sp.simplify(P1 * P10) == sp.zeros(11), "orthogonal")
    require(proj["decomposition"]["naive_1_5_5_refuted"] is True, "correction flag")
    require(proj["decomposition"]["Ind_H^G_1"] == "1 ⊕ 10", "decomp string")
    require(
        sp.simplify(P10 * M * M.T * P10 - 3 * P10) == sp.zeros(11),
        "aug inverse H",
    )
    require(
        sp.simplify(P10 * M.T * M * P10 - 3 * P10) == sp.zeros(11),
        "aug inverse K",
    )
    ones = sp.Matrix([1] * 11)
    require(M * ones == 5 * ones, "N on trivial")
    require(proj["markers"]["G7-CROSS-CLASS-PROJECTOR-PASS"] is True, "proj marker")

    # cross artifact histogram
    require(cross["order_histogram"]["12"] == 55, "cross hist 12")
    require(cross["order_histogram"]["10"] == 66, "cross hist 10")
    require(len(cross["table"]) == 121, "cross table len")

    # H_A5 points still present (binding)
    for ci in (1, 2):
        pp = ROOT / f"goal_runs_after_35fa/H_A5_TWISTS/A5_class_{ci}/point.json"
        require(pp.is_file(), f"H_A5 class {ci}")
        ptj = json.loads(pp.read_text())
        require("exit" in ptj, "point exit")

    print("G7A_VERIFY_DESIGN_OK")
    print("G7-PALEY-BIPLANE-IDENTIFIED")
    print("G7-CROSS-CLASS-PROJECTOR-PASS")


if __name__ == "__main__":
    main()
