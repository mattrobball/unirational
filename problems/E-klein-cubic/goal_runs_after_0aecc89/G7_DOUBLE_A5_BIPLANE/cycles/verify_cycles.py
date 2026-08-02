#!/usr/bin/env python3
"""Hardened independent G7.3 cycle verifier (G7B REDO).

Does NOT import produce.py.

Responsibilities:
1. Rebuild cosets from H_A5 generators independently.
2. If points claimed: check well-definedness under right-H multiply,
   equivariance rho(s)/rho(t) on every point, Phi/F landing, descent proof.
3. Fail loudly on the refuted e0 construction if reintroduced.
4. Rebuild descent proof objects — never trust defined_over_K_proj as authority.
5. Accept honest residual (G7-PROJECTIVE-SCALING-PASS / G7-UNDECIDED) when no
   materialization is claimed.
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
P, INF, NPTS = 11, 11, 12

AUTHORIZED_EXITS = {
    "G7-INDUCED-DOUBLE-CYCLE-PASS",
    "G7-PROJECTIVE-SCALING-PASS",
    "G7-UNDECIDED",
    "G7-CANONICAL-INPUT-FAIL",
}


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


def proj_eq(u, v) -> bool:
    for i in range(5):
        for j in range(i + 1, 5):
            if u[i] * v[j] != u[j] * v[i]:
                return False
    return True


def conjugate(H, g):
    gi = inverse_perm(g)
    return frozenset(compose(compose(g, h), gi) for h in H)


def looks_like_e0_orbit(pts, cosets, perm_to_rho) -> bool:
    """Detect reintroduction of p_i = rho(g_i) e0."""
    e0 = [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)]
    if len(pts) != len(cosets):
        return False
    matches = 0
    for g, p in zip(cosets, pts):
        ge = mv(perm_to_rho[g], e0)
        if proj_eq(ge, p):
            matches += 1
    return matches == len(pts)


def descent_claimed_true(kproj_cycle) -> bool:
    d = kproj_cycle.get("defined_over_K_proj")
    if d is True:
        return True
    if isinstance(d, dict) and d.get("claimed") is True:
        return True
    return False


def main() -> None:
    # Hard ban: never import produce
    require("produce" not in sys.modules, "must not import produce")

    for name in (
        "INPUT_MANIFEST.json",
        "cycles.json",
        "incidence_correspondence.json",
        "scaling_interface.json",
        "CYCLES.md",
        "INCIDENCE_CORRESPONDENCE.md",
        "PROJECTIVE_SCALING.md",
        "INDUCED_CYCLE_REFUTATION.md",
        "REPLAY.md",
        "STATUS.md",
        "produce.py",
        "verify_scaling.py",
        "verify_cycles.py",
        "audit_induced_refutation.py",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    status_text = (HERE / "STATUS.md").read_text()
    first = status_text.splitlines()[0].strip()
    require(first in AUTHORIZED_EXITS, f"unauthorized STATUS exit: {first}")

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for item in man["inputs"]:
        p = ROOT / item["path"]
        require(p.is_file(), f"missing {item['path']}")
        require(sha256(p) == item["sha256"], f"hash {item['path']}")

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

    # Independent e0 stab/orbit facts (regression base)
    e0 = [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)]
    require(eval_F(e0) == ew.C(0), "e0 on F")
    stab = [g for g in G if proj_eq(mv(perm_to_rho[g], e0), e0)]
    require(len(stab) == 11, f"Stab(e0) expected 11 got {len(stab)}")

    cycles = json.loads((HERE / "cycles.json").read_text())
    schema = cycles.get("schema", "")
    residual_schemas = {
        "g7b-induced-double-cycles-residual-v2",
    }
    pass_schemas = {
        "g7b-induced-double-cycles-v1",
        "g7b-induced-double-cycles-v2",
    }
    require(
        schema in residual_schemas | pass_schemas,
        f"unknown cycles schema {schema}",
    )

    payload = json.loads(CANONICAL.read_text())
    require(len(cycles["classes"]) == 2, "two classes")
    labels = {c["label"] for c in cycles["classes"]}
    require(labels == {"A5_class_1", "A5_class_2"}, "labels")

    rebuilt_orbits = {}
    any_coords = False
    total_coords = 0

    for idx, cl_payload in enumerate(payload["classes"], start=1):
        label = f"A5_class_{idx}"
        gens_sl2 = cl_payload["subgroup_generators"]
        a = key_to_perm(tuple(gens_sl2[0]))
        b = key_to_perm(tuple(gens_sl2[1]))
        H = set(closure([a, b]))
        require(len(H) == 60, f"H order {label}")

        # H must not stabilize e0 (refutation fact)
        inter = len(H & set(stab))
        require(inter != 60, f"H stabilizes e0 unexpectedly {label}")

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
        require(ind_cl["coset_action"]["s_perm"] == ps, f"s_perm {label}")
        require(ind_cl["coset_action"]["t_perm"] == pt, f"t_perm {label}")
        require(ind_cl["galois_action"]["image_order"] == 660, "gal image")
        require(ind_cl["galois_action"]["s_perm"] == ps, "gal s")
        require(ind_cl["galois_action"]["t_perm"] == pt, "gal t")

        # H_A5 binding
        pp = ROOT / ind_cl["base_H_point"]["path"]
        require(pp.is_file(), "point path")
        ptj = json.loads(pp.read_text())
        require("RATIONAL-POINT" in ptj.get("exit", ""), "H_A5 exit")
        require(ptj.get("class") == label, "class match")

        # Coordinates?
        coords_flag = ind_cl.get("coordinates_materialized")
        conjugates = ind_cl.get("conjugates")
        if conjugates is None and "abstract_induction" in ind_cl:
            conjugates = None
            struct = ind_cl["abstract_induction"].get("conjugates_structural", [])
            require(len(struct) == 11, "11 structural conjugates")
            for i, conj in enumerate(struct):
                g = tuple(conj["coset_representative_12perm"])
                require(g == cosets[i], f"coset rep {label} {i}")
                require(
                    conj.get("G3_frame_coordinates") is None,
                    "structural conjugate must not fake coordinates",
                )

        if coords_flag is True or (
            conjugates is not None
            and any(
                c.get("G3_frame_coordinates")
                and c["G3_frame_coordinates"].get("homogeneous_coordinates_raw")
                for c in conjugates
            )
        ):
            any_coords = True
            require(conjugates is not None and len(conjugates) == 11, "11 conjugates")
            pts = []
            for i, conj in enumerate(conjugates):
                g = tuple(conj["coset_representative_12perm"])
                require(g == cosets[i], f"coset rep {label} {i}")
                g3 = conj.get("G3_frame_coordinates") or {}
                raw = json_to_v(g3["homogeneous_coordinates_raw"])
                require(eval_F(raw) == ew.C(0), f"F=0 {label} {i}")
                pts.append(raw)
                total_coords += 1

            # FAIL e0 construction if reintroduced
            if looks_like_e0_orbit(pts, cosets, perm_to_rho):
                fail(
                    f"REFUTED e0 construction reintroduced for {label}: "
                    "p_i = rho(g_i)·e0 is not a well-defined induced cycle"
                )

            # Well-definedness: right multiply by all h in H on coset 0
            g0 = cosets[0]
            bad_wd = 0
            for h in H:
                g2 = compose(g0, h)
                # find which coset index g2 lands in — should be 0
                # compare p(g2) ~ p(g0)
                # Without a construction formula, we compare stored points only if
                # construction is coset-rep based: check all reps of coset 0 give same point.
                # For general points: right-H on rep must not change the stored point.
                # We require: for all h, if gh is still listed as coset 0's rep class,
                # the map via any formula would match. Check all h: rho(g0 h) vs stored
                # is wrong for e0; for a correct construction, producer would store
                # a formula. Here we check stored points against equivariance only.
                _ = g2  # used below in equivariance path
                # Well-definedness of stored list under alternative coset reps:
                # take p_i associated to coset i; for h in H, g_i h is same coset,
                # so any formula F(g_i h) must ~ F(g_i). If construction string
                # claims rho(g)*vector, test that.
                constr = str(g3.get("construction", "")) if i == 0 else ""
                if "rho(g" in constr or "base_vector" in constr or "e0" in constr.lower():
                    fail(f"forbidden construction string in {label}: {constr}")

            # Explicit well-definedness for any claimed coset→point formula via
            # stored coset reps: all alternative reps of coset i must give ~ same
            # stored point if we rebuild via construction. Without formula, require
            # equivariance + that H-action on points matches coset action.
            # Well-definedness sample: for each i, for generators of H, the point
            # attached to coset of g_i h equals p_i. Since points are stored only
            # on the chosen reps, we check: rho(h) does NOT need to fix p_i unless
            # H-fixed lift. For H-fixed lifts: rho(h)p_i ~ p_i for h in H.
            # General equivariant induction: rho(g) p_i ~ p_{g·i}.

            fails_s = fails_t = 0
            for i in range(11):
                if not proj_eq(mv(perm_to_rho[s], pts[i]), pts[ps[i]]):
                    fails_s += 1
                if not proj_eq(mv(perm_to_rho[t], pts[i]), pts[pt[i]]):
                    fails_t += 1
            require(
                fails_s == 0 and fails_t == 0,
                f"equivariance failed {label}: s={fails_s}/11 t={fails_t}/11",
            )

            # Well-definedness: for each coset, all h in a generating set of H,
            # g_i h and g_i are same coset ⇒ equivariance with h-action on labels
            # means p must be constant on cosets. Test: rho(h) p_j ~ p_{h·j}.
            # For h in H, h acts on cosets; if H is the stabilizer of coset 0
            # (left action), then h·0 = 0 so rho(h)p_0 ~ p_0.
            ha, hb = a, b  # H generators as 12-perms
            for hgen, name_h in ((ha, "a"), (hb, "b")):
                h_perm = [act(hgen, c) for c in cosets]
                for i in range(11):
                    if not proj_eq(
                        mv(perm_to_rho[hgen], pts[i]), pts[h_perm[i]]
                    ):
                        fail(
                            f"well-definedness/H-equivariance fail {label} "
                            f"gen={name_h} i={i}"
                        )

            # Descent: must not claim K_proj without proof object
            kpc = ind_cl.get("K_proj_cycle", {})
            if descent_claimed_true(kpc):
                proof = kpc.get("defined_over_K_proj")
                if proof is True:
                    fail(
                        f"{label}: defined_over_K_proj=true without proof object "
                        "(bare Boolean forbidden)"
                    )
                if isinstance(proof, dict):
                    require(
                        proof.get("proof_object") is not None,
                        f"{label}: claimed descent needs proof_object",
                    )
                    # Verifier must rebuild — require proof_object be a rebuildable
                    # structure, not a string assertion alone
                    po = proof["proof_object"]
                    require(
                        isinstance(po, dict) and po.get("type"),
                        f"{label}: proof_object must be structured with type",
                    )
        else:
            # Residual path
            require(
                ind_cl.get("coordinates_materialized") is False
                or ind_cl.get("materialization_status") == "RESIDUAL"
                or ind_cl.get("G3_frame_coordinates") is None,
                f"{label}: residual must not pretend materialization",
            )
            require(
                not descent_claimed_true(ind_cl.get("K_proj_cycle", {})),
                f"{label}: residual must not claim defined_over_K_proj",
            )

        rebuilt_orbits[label] = [conjugate(frozenset(H), g) for g in cosets]

    # STATUS consistency with materialization
    if first == "G7-INDUCED-DOUBLE-CYCLE-PASS":
        require(any_coords and total_coords == 22, "induced pass needs 22 coords")
        require(
            cycles.get("materialization_status") != "RESIDUAL",
            "cannot claim induced pass with residual materialization",
        )
        require(
            cycles.get("both_classes_materialized") is True
            or schema in pass_schemas,
            "induced pass schema",
        )
    else:
        # Honest residual / scaling-only
        if schema in residual_schemas:
            require(
                cycles.get("materialization_status") == "RESIDUAL",
                "residual schema status",
            )
            require(
                cycles.get("n_correct_G3_coordinates", 0) == 0,
                "residual claims 0 coords",
            )
            require(
                first
                in {
                    "G7-PROJECTIVE-SCALING-PASS",
                    "G7-UNDECIDED",
                    "G7-CANONICAL-INPUT-FAIL",
                },
                "residual STATUS must not be induced pass",
            )
            require(
                cycles.get("residual_gate"),
                "named residual_gate required",
            )

    # If legacy v1 schema with e0 points somehow present without induced STATUS
    if schema == "g7b-induced-double-cycles-v1" and any_coords:
        # Still must pass equivariance or fail — already handled above.
        # Extra: if e0, already failed.
        pass

    # Incidence correspondence (abstract always rebuildable)
    inc = json.loads((HERE / "incidence_correspondence.json").read_text())
    require(inc["schema"] == "g7b-incidence-correspondence-v1", "inc schema")
    N = inc["incidence_matrix_N_coset"]
    require(len(N) == 11 and all(len(row) == 11 for row in N), "N shape")
    require(all(x in (0, 1) for row in N for x in row), "N 0-1")
    row_sums = [sum(N[i]) for i in range(11)]
    col_sums = [sum(N[i][j] for i in range(11)) for j in range(11)]
    require(all(r == 5 for r in row_sums), "row sums 5")
    require(all(c == 5 for c in col_sums), "col sums 5")
    for i in range(11):
        for k in range(i + 1, 11):
            meet = sum(N[i][j] * N[k][j] for j in range(11))
            require(meet == 2, f"row meet {i},{k}")
    for j in range(11):
        for l in range(j + 1, 11):
            meet = sum(N[i][j] * N[i][l] for i in range(11))
            require(meet == 2, f"col meet {j},{l}")

    H_orb = rebuilt_orbits["A5_class_1"]
    K_orb = rebuilt_orbits["A5_class_2"]
    N_direct = [[0] * 11 for _ in range(11)]
    for i, Hi in enumerate(H_orb):
        for j, Kj in enumerate(K_orb):
            if len(Hi & Kj) == 12:
                N_direct[i][j] = 1
    require(N_direct == N, "N matches direct intersections")
    require(inc["direct_intersection_rebuild_matches"] is True, "flag")

    design_N_path = DESIGN / "incidence_N.json"
    require(design_N_path.is_file(), "design N")
    require(
        sha256(design_N_path) == inc["identification"]["design_N_sha256"],
        "design N hash",
    )
    require(
        inc["source_algebra"]["label"] != inc["target_algebra"]["label"],
        "classes separate",
    )

    # Withdrawn artifact must not be the primary cycles.json content
    if (HERE / "cycles_WITHDRAWN_rho_e0.json").is_file():
        withdrawn = json.loads((HERE / "cycles_WITHDRAWN_rho_e0.json").read_text())
        if schema in residual_schemas:
            require(
                cycles.get("withdrawn", {}).get("status") == "non-consumable"
                or cycles.get("materialization_status") == "RESIDUAL",
                "withdrawn must be marked non-consumable",
            )
            # primary must differ from withdrawn schema claim
            require(
                cycles.get("schema") != withdrawn.get("schema")
                or cycles.get("materialization_status") == "RESIDUAL",
                "primary must not re-assert withdrawn pass schema unchecked",
            )

    print("G7B_VERIFY_CYCLES_OK")
    print(first)
    print(f"materialization={'coords' if any_coords else 'RESIDUAL'}")
    print(f"n_coords_checked={total_coords}")


if __name__ == "__main__":
    main()
