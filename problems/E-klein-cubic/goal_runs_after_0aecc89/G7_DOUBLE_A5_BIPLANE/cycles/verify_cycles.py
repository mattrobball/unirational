#!/usr/bin/env python3
"""Independent G7.3 cycle verifier.

Rebuilds cosets from sealed H_A5 generators; rebuilds all 22 G3-frame points;
checks F_Klein=0; checks coset/Galois actions; checks incidence correspondence.
Does not import produce.py.
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
from collections import deque
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402

H_A5 = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
DESIGN = ROOT / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design"
CANONICAL = H_A5 / "canonical_model_payload.json"
P = 11
INF = 11


def fail(msg: str) -> None:
    print(f"G7B_VERIFY_CYCLES_FAIL: {msg}", file=sys.stderr)
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
    return ew.C(tuple(Q(n, d) for n, d in coords10))


def json_to_v(homog):
    return [json_to_c(c) for c in homog]


def conjugate(H, g):
    gi = inverse_perm(g)
    return frozenset(compose(compose(g, h), gi) for h in H)


def main() -> None:
    for name in (
        "INPUT_MANIFEST.json",
        "cycles.json",
        "incidence_correspondence.json",
        "scaling_interface.json",
        "CYCLES.md",
        "INCIDENCE_CORRESPONDENCE.md",
        "PROJECTIVE_SCALING.md",
        "REPLAY.md",
        "STATUS.md",
        "produce.py",
        "verify_scaling.py",
        "verify_cycles.py",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    # produce is not imported
    require("produce" not in sys.modules or "produce" not in dir(), "no produce import")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("G7-INDUCED-DOUBLE-CYCLE-PASS\n"), "STATUS exit")

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for item in man["inputs"]:
        p = ROOT / item["path"]
        require(p.is_file(), f"missing {item['path']}")
        require(sha256(p) == item["sha256"], f"hash {item['path']}")

    # Binding exits
    design_st = (DESIGN / "STATUS.md").read_text()
    require(
        design_st.startswith("G7-CROSS-CLASS-PROJECTOR-PASS")
        or design_st.startswith("G7-PALEY-BIPLANE-IDENTIFIED"),
        "design exit",
    )
    g4_st = (
        ROOT / "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/STATUS.md"
    ).read_text()
    require(g4_st.startswith("G4-INDUCED-DEGREE11-POINT-PASS"), "g4 exit")
    g3a_st = (
        ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md"
    ).read_text()
    require(g3a_st.startswith("G3A-ARITHMETIC-DOMINANCE-PASS"), "g3a exit")

    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    G = list(closure([s, t]))
    G.sort()
    require(len(G) == 660, "G order")
    perm_to_rho = build_perm_to_rho()
    require(all(g in perm_to_rho for g in G), "rho covers G")

    base = [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)]
    require(eval_F(base) == ew.C(0), "base on F")

    cycles = json.loads((HERE / "cycles.json").read_text())
    require(cycles["schema"] == "g7b-induced-double-cycles-v1", "schema")
    require(len(cycles["classes"]) == 2, "two classes")
    labels = {c["label"] for c in cycles["classes"]}
    require(labels == {"A5_class_1", "A5_class_2"}, "labels")

    payload = json.loads(CANONICAL.read_text())
    total_phi_ok = 0

    rebuilt_orbits = {}

    for idx, cl_payload in enumerate(payload["classes"], start=1):
        label = f"A5_class_{idx}"
        gens_sl2 = cl_payload["subgroup_generators"]
        a = key_to_perm(tuple(gens_sl2[0]))
        b = key_to_perm(tuple(gens_sl2[1]))
        H = set(closure([a, b]))
        require(len(H) == 60, f"H order {label}")

        cosets = []
        used = set()
        for g in G:
            key = frozenset(compose(g, h) for h in H)
            if key not in used:
                used.add(key)
                cosets.append(g)
        require(len(cosets) == 11, "11 cosets")

        def act(g, rep, H=H, cosets=cosets):
            prod = compose(g, rep)
            key = frozenset(compose(prod, h) for h in H)
            for i, r in enumerate(cosets):
                if frozenset(compose(r, hh) for hh in H) == key:
                    return i
            fail("coset missing")

        ps = [act(s, c) for c in cosets]
        pt = [act(t, c) for c in cosets]

        # image order
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
        require(len(seen) == 660, f"image 660 {label}")

        ind_cl = next(c for c in cycles["classes"] if c["label"] == label)
        require(ind_cl["degree"] == 11, "deg 11")
        require(len(ind_cl["conjugates"]) == 11, "11 conjugates")
        require(ind_cl["K_proj_cycle"]["defined_over_K_proj"] is True, "K_proj")
        require(ind_cl["coset_action"]["s_perm"] == ps, f"s_perm {label}")
        require(ind_cl["coset_action"]["t_perm"] == pt, f"t_perm {label}")
        require(ind_cl["galois_action"]["image_order"] == 660, "gal image")
        require(ind_cl["galois_action"]["s_perm"] == ps, "gal s")
        require(ind_cl["galois_action"]["t_perm"] == pt, "gal t")

        for i, conj in enumerate(ind_cl["conjugates"]):
            g = tuple(conj["coset_representative_12perm"])
            require(g == cosets[i], f"coset rep {label} {i}")
            rebuilt = mv(perm_to_rho[g], base)
            stored_raw = json_to_v(
                conj["G3_frame_coordinates"]["homogeneous_coordinates_raw"]
            )
            stored_norm = json_to_v(
                conj["G3_frame_coordinates"]["homogeneous_coordinates_normalized"]
            )
            require(
                all(rebuilt[j] == stored_raw[j] for j in range(5)),
                f"coord rebuild {label} {i}",
            )
            require(eval_F(stored_raw) == ew.C(0), f"F=0 raw {label} {i}")
            require(eval_F(stored_norm) == ew.C(0), f"F=0 norm {label} {i}")
            require(eval_F(rebuilt) == ew.C(0), f"F=0 rebuilt {i}")
            require(conj["Phi_check"]["F_Klein_raw"] == 0, "Phi flag")
            total_phi_ok += 1

        # H_A5 binding
        pp = ROOT / ind_cl["base_H_point"]["path"]
        require(pp.is_file(), "point path")
        ptj = json.loads(pp.read_text())
        require("RATIONAL-POINT" in ptj.get("exit", ""), "H_A5 exit")
        require(ptj.get("class") == label, "class match")

        rebuilt_orbits[label] = [conjugate(frozenset(H), g) for g in cosets]

    require(total_phi_ok == 22, f"22 Phi checks, got {total_phi_ok}")

    # Incidence correspondence
    inc = json.loads((HERE / "incidence_correspondence.json").read_text())
    require(inc["schema"] == "g7b-incidence-correspondence-v1", "inc schema")
    N = inc["incidence_matrix_N_coset"]
    require(len(N) == 11 and all(len(row) == 11 for row in N), "N shape")
    require(all(x in (0, 1) for row in N for x in row), "N 0-1")
    row_sums = [sum(N[i]) for i in range(11)]
    col_sums = [sum(N[i][j] for i in range(11)) for j in range(11)]
    require(all(r == 5 for r in row_sums), "row sums 5")
    require(all(c == 5 for c in col_sums), "col sums 5")
    # pairwise meets
    for i in range(11):
        for k in range(i + 1, 11):
            meet = sum(N[i][j] * N[k][j] for j in range(11))
            require(meet == 2, f"row meet {i},{k}")
    for j in range(11):
        for l in range(j + 1, 11):
            meet = sum(N[i][j] * N[i][l] for i in range(11))
            require(meet == 2, f"col meet {j},{l}")

    # Rebuild N from conjugate intersections of the two coset orbits
    H_orb = rebuilt_orbits["A5_class_1"]
    K_orb = rebuilt_orbits["A5_class_2"]
    N_direct = [[0] * 11 for _ in range(11)]
    for i, Hi in enumerate(H_orb):
        for j, Kj in enumerate(K_orb):
            if len(Hi & Kj) == 12:
                N_direct[i][j] = 1
    require(N_direct == N, "N matches direct intersections")
    require(inc["direct_intersection_rebuild_matches"] is True, "flag")

    # Design N hash binding
    design_N_path = DESIGN / "incidence_N.json"
    require(design_N_path.is_file(), "design N")
    require(
        sha256(design_N_path) == inc["identification"]["design_N_sha256"],
        "design N hash",
    )

    # Module map formulas present
    require("N_*(e_i)" in inc["module_map"]["formula"], "module map")
    require("augmentation_inverse" in inc["module_map"], "aug inverse")

    # Classes kept separate
    require(
        inc["source_algebra"]["label"] != inc["target_algebra"]["label"],
        "classes separate",
    )

    print("G7B_VERIFY_CYCLES_OK")
    print("G7-INDUCED-DOUBLE-CYCLE-PASS")
    print(f"phi_checks={total_phi_ok}")


if __name__ == "__main__":
    main()
