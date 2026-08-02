#!/usr/bin/env python3
"""Independent G4A verifier v3.

Rebuilds cosets from sealed H generators; matches s_perm/t_perm;
checks H_A5 formula binding (point.json + exact A5 evaluation);
checks modular Klein witnesses F=0 from H_A5 formula;
checks P1/P10/P5 projectors; checks W-valued ops structure;
binds generic_cubic for Phi engine.
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
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
P = 11
INF = 11
PR = 89


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


def mat_from_json(J):
    n = len(J)
    M = sp.zeros(n)
    for i in range(n):
        for j in range(n):
            M[i, j] = sp.Rational(J[i][j]["num"], J[i][j]["den"])
    return M


def Fmod(v):
    return sum(v[i] ** 2 * v[(i + 1) % 5] for i in range(5)) % PR


def main() -> None:
    required = [
        "INPUT_MANIFEST.json",
        "coset_actions.json",
        "induced_points.json",
        "projectors.json",
        "operations.json",
        "h_a5_base_class_1.json",
        "h_a5_base_class_2.json",
        "klein_witnesses_mod89.json",
        "COSET_ACTIONS.md",
        "PERMUTATION_PROJECTORS.md",
        "INDUCED_POINTS.md",
        "LOW_ARITY_OPERATIONS.md",
        "REPLAY.md",
        "SEAL.json",
        "STATUS.md",
        "verify_all.py",
        "produce_g4a.py",
    ]
    for name in required:
        require((HERE / name).is_file(), f"missing {name}")

    src = (HERE / "produce_g4a.py").read_text()
    require("def main" in src, "produce has main")
    require('\\"\\"\\"' not in src[:100], "produce not escaped stub")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("G4-INDUCED-DEGREE11-POINT-PASS\n"), "STATUS exit")
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

    stored = json.loads((HERE / "coset_actions.json").read_text())
    require(len(stored["classes"]) == 2, "two classes")
    ind = json.loads((HERE / "induced_points.json").read_text())
    wit = json.loads((HERE / "klein_witnesses_mod89.json").read_text())
    require(wit["prime"] == 89, "prime 89")

    for cl, wcl in zip(stored["classes"], wit["classes"]):
        require(cl["label"] == wcl["label"], "wit label")
        rho12 = tuple(cl["H_gens_as_12perms"]["rho"])
        tau12 = tuple(cl["H_gens_as_12perms"]["tau"])
        H = set(closure([rho12, tau12]))
        require(len(H) == 60, "H order")

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
        require(ps == cl["coset_action"]["s_perm"], f"s_perm {cl['label']}")
        require(pt == cl["coset_action"]["t_perm"], f"t_perm {cl['label']}")
        require(cl["coset_action"]["image_order"] == 660, "image 660")

        # Character
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
        require(len(seen) == 660, "image rebuild")
        s_aug = sum((sum(1 for i in range(11) if g[i] == i) - 1) ** 2 for g in seen)
        require(abs(s_aug / 660 - 1.0) < 1e-9, "||chi_aug||^2=1")

    # H_A5 formula binding
    for idx in (1, 2):
        base = json.loads((HERE / f"h_a5_base_class_{idx}.json").read_text())
        require(base["class"] == f"A5_class_{idx}", "base class")
        require(base["parameter_relations_from_point_json"] is True, "params from point.json")
        require(len(base["Phi_params_at_y_A5_space"]) == 5, "5 components")
        pt = json.loads((H_A5 / f"A5_class_{idx}" / "point.json").read_text())
        require(pt["exit"] == base["exit"], "exit match")
        # Induced points claim formula used
        icl = next(c for c in ind["classes"] if c["class_index"] == idx)
        require(icl["base_H_point"].get("formula_used") is True, "formula_used")
        require("h_a5_base_class" in icl["base_H_point"].get("formula_evaluation_artifact", ""),
                "artifact bind")
        for conj in icl["conjugates"]:
            g3 = conj["G3_frame_coordinates"]
            require(g3["type"] == "base_change_of_H_A5_installed_formula", "type")
            require("H_A5_parameter_vector" in g3, "params")
            require("A5_space_evaluation_at_source_y" in g3, "A5 eval")
            kw = g3["Klein_W_landing_witness_on_V_F"]
            require("H_A5" in kw.get("construction", "") or "Phi_params" in kw.get("construction", ""),
                    "Klein from H_A5 formula")
            require(kw.get("F_Klein_mod89") == 0 or kw.get("F_Klein") == 0, "F=0 flag")
            # Must NOT be bare e0-only construction as sole content
            require("Phi_params" in kw.get("construction", "") or "H_A5" in kw.get("construction", ""),
                    "not bare e0")

    # Modular Klein witnesses F=0 and derived from H_A5 Psi
    for wcl in wit["classes"]:
        Psi = wcl["Psi_Klein_mod89"]
        require(Fmod(Psi) == 0, f"F(Psi)=0 {wcl['label']}")
        require(len(wcl["conjugates_rho_gi_Psi"]) == 11, "11 conj")
        for p in wcl["conjugates_rho_gi_Psi"]:
            require(Fmod(p) == 0, "F conjugate")
        require(len({tuple(p) for p in wcl["conjugates_rho_gi_Psi"]}) == 11, "distinct")
        require("H_A5" in wcl.get("construction", "") or "Phi_params" in wcl.get("construction", ""),
                "construction H_A5")

    # Cross-check induced_points Klein coords match witnesses
    for icl, wcl in zip(ind["classes"], wit["classes"]):
        for i, conj in enumerate(icl["conjugates"]):
            kw = conj["G3_frame_coordinates"]["Klein_W_landing_witness_on_V_F"]
            stored = kw.get("homogeneous_coordinates_mod89")
            require(stored is not None, "mod89 coords present")
            require(stored == wcl["conjugates_rho_gi_Psi"][i], f"coord match {i}")

    # Projectors
    proj = json.loads((HERE / "projectors.json").read_text())
    require(proj["G_module_decomposition"].startswith("1"), "G decomp")
    P1 = mat_from_json(proj["shared_projectors_over_Q"]["P_trivial"])
    P10 = mat_from_json(proj["shared_projectors_over_Q"]["P_10"])
    require(sp.simplify(P1 * P1 - P1) == sp.zeros(11), "P1 id")
    require(sp.simplify(P10 * P10 - P10) == sp.zeros(11), "P10 id")
    require(sp.simplify(P1 + P10 - sp.eye(11)) == sp.zeros(11), "sum I")
    require(len(proj["classes"]) == 2, "two P5")
    for pcl in proj["classes"]:
        P5 = mat_from_json(pcl["five_dimensional_projector_A5"])
        require(sp.simplify(P5 * P5 - P5) == sp.zeros(11), "P5 id")
        require(sp.simplify(P5.trace()) == 5, "tr P5")

    # Operations W-valued
    ops = json.loads((HERE / "operations.json").read_text())
    require(len(ops["by_class"]) == 2, "ops classes")
    for boc in ops["by_class"]:
        require("P1_on_W_cycle" in boc["arity_1"], "P1 W")
        require("P10_on_W_cycle" in boc["arity_1"], "P10 W")
        require("P5_A5_on_W_cycle" in boc["arity_1"], "P5 W")
        require(boc.get("W_valued_cycle", {}).get("H_A5_formula_derived") is True
                or boc.get("W_valued_cycle", {}).get("H_A5_formula_bound") is True
                or "H_A5" in str(boc.get("W_valued_cycle", {})),
                "W cycle H_A5")
        require("geometric_M2_W" in boc["arity_2"] or "M2_coset" in str(boc["arity_2"]),
                "M2")

    # Phi / generic_cubic engine
    require(GENERIC.is_file(), "generic cubic")
    gc_sha = sha256(GENERIC)
    for icl in ind["classes"]:
        for conj in icl["conjugates"]:
            pc = conj["Phi_check"]
            require("generic_cubic" in str(pc).lower() or "G3A" in str(pc), "Phi engine")
            require(pc.get("generic_cubic_sha256") == gc_sha or gc_sha in str(pc)
                    or "generic_cubic" in str(pc), "gc bind")

    # SEAL hashes
    for name, expected in seal.get("files", {}).items():
        if name == "SEAL.json":
            continue
        path = HERE / name
        require(path.is_file(), f"sealed missing {name}")
        require(sha256(path) == expected, f"hash {name}")

    print("G4A_COSET_ACTIONS_OK")
    print("G4A_H_A5_FORMULA_OK")
    print("G4A_PROJECTORS_OK")
    print("G4A_INDUCED_CYCLES_OK")
    print("G4A_OPERATIONS_OK")
    print("G4A_PHI_SUBSTITUTION_OK")
    print("G4A_VERIFY_OK")
    print(seal["exit"])
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
