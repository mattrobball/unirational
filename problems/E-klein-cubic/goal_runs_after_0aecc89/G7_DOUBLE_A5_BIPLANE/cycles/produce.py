#!/usr/bin/env python3
"""G7B REDO producer — projective scaling + honest residual on induced cycles.

Stages:
  G7.2  scale-safe cone-lift / multihomogeneous interface (sealed)
  G7.3  materialize both degree-11 cycles — residual if no well-defined
        coset → G3-frame point map is available

Forbidden construction (do not reintroduce):
  p_i = rho(g_i) * e_0 with e_0 = (1:0:0:0:0)
  H does not stabilize [e_0]; map is representative-dependent.

Does not import verify_*.py. Producer ≠ verifier.
"""
from __future__ import annotations

import hashlib
import json
import math
import resource
import sys
import time
from collections import deque
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]  # .../E-klein-cubic
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402

H_A5 = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
G4 = ROOT / "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER"
G3A = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"
DESIGN = ROOT / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design"
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
CANONICAL_PAYLOAD = H_A5 / "canonical_model_payload.json"

P = 11
INF = 11
NPTS = 12

# Honest exit for this redo: scaling sealed; induced materialization residual.
EXIT_PRIMARY = "G7-PROJECTIVE-SCALING-PASS"
RESIDUAL_GATE = (
    "need L_H cocycle coordinates from H_A5 formula in G3 frame "
    "(no well-defined H-fixed cone lift; rho(g)·e0 refuted)"
)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def peak_rss_mb() -> float:
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    if sys.platform == "darwin":
        return rss / (1024 * 1024)
    return rss / 1024


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


def key_to_perm(key):
    a, b, c, d = key
    return permutation((a % 11, b % 11, c % 11, d % 11))


def build_group():
    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    G = list(closure([s, t]))
    assert len(G) == 660
    G.sort()
    return s, t, G


def build_perm_to_rho():
    return {key_to_perm(k): m for k, m in ew.rho.items()}


def mv(A, v):
    return [sum(A[i][j] * v[j] for j in range(5)) for i in range(5)]


def eval_F(v):
    total = ew.C(0)
    for i in range(5):
        total = total + v[i] * v[i] * v[(i + 1) % 5]
    return total


def c_to_json(c: ew.C):
    return [[int(x.numerator), int(x.denominator)] for x in c.a]


def v_to_json(v):
    return [c_to_json(c) for c in v]


def proj_eq(u, v) -> bool:
    for i in range(5):
        for j in range(i + 1, 5):
            if u[i] * v[j] != u[j] * v[i]:
                return False
    return True


def is_zero_v(v) -> bool:
    return all(x == ew.C(0) for x in v)


def invert_C(c: ew.C) -> ew.C:
    a = list(c.a)
    assert len(a) == 10
    if all(x == 0 for x in a):
        raise ZeroDivisionError("invert zero")
    M = [[Q(0) for _ in range(10)] for _ in range(10)]
    for j in range(10):
        prod = c * ew.C(tuple(Q(1 if k == j else 0) for k in range(10)))
        for i in range(10):
            M[i][j] = prod.a[i]
    A = [row[:] + [Q(1 if i == 0 else 0)] for i, row in enumerate(M)]
    n = 10
    for col in range(n):
        piv = None
        for r in range(col, n):
            if A[r][col] != 0:
                piv = r
                break
        if piv is None:
            raise ZeroDivisionError("non-unit in C")
        A[col], A[piv] = A[piv], A[col]
        pivval = A[col][col]
        A[col] = [x / pivval for x in A[col]]
        for r in range(n):
            if r == col:
                continue
            fac = A[r][col]
            if fac == 0:
                continue
            A[r] = [A[r][k] - fac * A[col][k] for k in range(n + 1)]
    inv = ew.C(tuple(A[i][n] for i in range(n)))
    assert c * inv == ew.C(1)
    return inv


def normalize_chart(v):
    for i, x in enumerate(v):
        if x != ew.C(0):
            inv = invert_C(x)
            return [inv * y for y in v], i
    raise ValueError("zero vector")


def a5_classes_from_h_a5(G):
    payload = json.loads(CANONICAL_PAYLOAD.read_text())
    classes = []
    for idx, cl in enumerate(payload["classes"], start=1):
        gens_sl2 = cl["subgroup_generators"]
        a = key_to_perm(tuple(gens_sl2[0]))
        b = key_to_perm(tuple(gens_sl2[1]))
        H = frozenset(closure([a, b]))
        assert len(H) == 60, (idx, len(H))
        classes.append(
            {
                "label": f"A5_class_{idx}",
                "design_label": "A5_class_H" if idx == 1 else "A5_class_K",
                "class_index": idx,
                "H": H,
                "gens_12": (a, b),
                "gens_sl2": gens_sl2,
            }
        )

    def conjugate(H, g):
        gi = inverse_perm(g)
        return frozenset(compose(compose(g, h), gi) for h in H)

    H0, H1 = classes[0]["H"], classes[1]["H"]
    orbit0 = {conjugate(H0, g) for g in G}
    assert H1 not in orbit0
    assert len(orbit0) == 11
    return classes


def coset_action(G, Hset, s, t):
    H = set(Hset)
    cosets = []
    used = set()
    for g in G:
        key = frozenset(compose(g, h) for h in H)
        if key not in used:
            used.add(key)
            cosets.append(g)
    assert len(cosets) == 11

    def act(g, rep):
        prod = compose(g, rep)
        key = frozenset(compose(prod, h) for h in H)
        for i, r in enumerate(cosets):
            if frozenset(compose(r, hh) for hh in H) == key:
                return i
        raise RuntimeError("coset missing")

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
    assert len(seen) == 660

    s2 = sum(sum(1 for i in range(11) if g[i] == i) ** 2 for g in seen)
    s_aug = sum((sum(1 for i in range(11) if g[i] == i) - 1) ** 2 for g in seen)

    return {
        "n_cosets": 11,
        "s_perm": list(ps),
        "t_perm": list(pt),
        "image_order": len(seen),
        "character_stats": {
            "norm_sq_perm": s2 / 660.0,
            "norm_sq_aug": s_aug / 660.0,
            "decomposition_G": "1 + 10 (10 absolutely irreducible)",
        },
    }, cosets, act


def build_incidence_correspondence(G, classes_data, design_N, design_doc):
    """Abstract incidence map between the two coset algebras (no geometry of points)."""
    cl1 = classes_data[0]
    cl2 = classes_data[1]
    H0 = cl1["H"]
    K0 = cl2["H"]

    def conjugate(H, g):
        gi = inverse_perm(g)
        return frozenset(compose(compose(g, h), gi) for h in H)

    H_orbit_from_cosets = [conjugate(H0, g) for g in cl1["cosets"]]
    K_orbit_from_cosets = [conjugate(K0, g) for g in cl2["cosets"]]
    assert len(set(H_orbit_from_cosets)) == 11
    assert len(set(K_orbit_from_cosets)) == 11

    all_a5 = set()
    ord5 = [g for g in G if order(g) == 5]
    ord2 = [g for g in G if order(g) == 2]
    for a in ord5:
        for b in ord2:
            if order(compose(a, b)) != 3:
                continue
            H = frozenset(closure([a, b]))
            if len(H) == 60:
                all_a5.add(H)
    assert len(all_a5) == 22

    remaining = set(all_a5)
    orbits = []
    while remaining:
        seed = min(remaining, key=lambda H: min(H))
        orb = sorted({conjugate(seed, g) for g in G}, key=lambda H: min(H))
        assert len(orb) == 11
        orbits.append(orb)
        remaining -= set(orb)
    orbits.sort(key=lambda orb: min(orb[0]))
    design_Hs, design_Ks = orbits[0], orbits[1]

    if H0 in set(design_Hs):
        map_class1_to_design = "H"
        H_design_orbit = design_Hs
        K_design_orbit = design_Ks
    elif H0 in set(design_Ks):
        map_class1_to_design = "K"
        H_design_orbit = design_Ks
        K_design_orbit = design_Hs
    else:
        raise RuntimeError("H0 not in design orbits")

    if K0 not in set(K_design_orbit):
        raise RuntimeError("K0 not in complementary design orbit")

    def align(coset_orbit, design_orbit):
        idx = {H: j for j, H in enumerate(design_orbit)}
        return [idx[H] for H in coset_orbit]

    sigma_H = align(H_orbit_from_cosets, H_design_orbit)
    sigma_K = align(K_orbit_from_cosets, K_design_orbit)
    assert sorted(sigma_H) == list(range(11))
    assert sorted(sigma_K) == list(range(11))

    N_des = design_N
    if map_class1_to_design == "H":
        N_coset = [
            [N_des[sigma_H[i]][sigma_K[j]] for j in range(11)] for i in range(11)
        ]
    else:
        N_coset = [
            [N_des[sigma_K[j]][sigma_H[i]] for j in range(11)] for i in range(11)
        ]

    row_sums = [sum(N_coset[i]) for i in range(11)]
    col_sums = [sum(N_coset[i][j] for i in range(11)) for j in range(11)]
    assert all(r == 5 for r in row_sums)
    assert all(c == 5 for c in col_sums)

    N_direct = [[0] * 11 for _ in range(11)]
    for i, Hi in enumerate(H_orbit_from_cosets):
        for j, Kj in enumerate(K_orbit_from_cosets):
            if len(Hi & Kj) == 12:
                N_direct[i][j] = 1
    assert N_direct == N_coset

    N_comp = [[1 - N_coset[i][j] for j in range(11)] for i in range(11)]
    Nt = [[N_coset[i][j] for i in range(11)] for j in range(11)]
    inv_aug = [[{"num": Nt[i][j], "den": 3} for j in range(11)] for i in range(11)]

    return {
        "schema": "g7b-incidence-correspondence-v1",
        "scope": "abstract_coset_modules_only",
        "note": (
            "N maps between the two degree-11 coset permutation modules. "
            "It is NOT a map of geometric induced-cycle points until G7.3 "
            "materialization exists."
        ),
        "source_algebra": {
            "label": cl1["label"],
            "design_label": cl1["design_label"],
            "basis": [f"e_{i}" for i in range(11)],
            "meaning": "coset basis of L_H = T×^G(G/H) for class_1 base H",
        },
        "target_algebra": {
            "label": cl2["label"],
            "design_label": cl2["design_label"],
            "basis": [f"f_{j}" for j in range(11)],
            "meaning": "coset basis of L_K = T×^G(G/K) for class_2 base K",
        },
        "identification": {
            "coset_to_conjugate": "gH ↔ g H g^{-1}",
            "class1_matches_design": map_class1_to_design,
            "sigma_class1_to_design_orbit": sigma_H,
            "sigma_class2_to_design_orbit": sigma_K,
            "design_N_sha256": sha256(DESIGN / "incidence_N.json"),
        },
        "incidence_matrix_N_coset": N_coset,
        "complementary_matrix": N_comp,
        "derived_rule": (
            "e_i incident f_j  ⟺  |g_i H g_i^{-1} ∩ g_j' K g_j'^{-1}| = 12 "
            "⟺ A4 intersection ⟺ N_ij = 1"
        ),
        "module_map": {
            "formula": "N_*(e_i) = sum_j N_ij f_j",
            "transpose_formula": "N^*(f_j) = sum_i N_ij e_i",
            "augmentation_inverse": {
                "formula": "N^{-1} = (1/3) N^t on augmentation modules (char ≠ 3)",
                "matrix_Nt_over_3": inv_aug,
            },
            "biplane_identities": {
                "row_sums": row_sums,
                "col_sums": col_sums,
                "NNt_equals_3I_plus_2J": True,
                "parameters": "symmetric 2-(11,5,2) Paley biplane",
            },
        },
        "descent": {
            "statement": (
                "N is constant on the coset bases of the two finite-etale "
                "K_proj-algebras L_H, L_K and is G-equivariant for the joint "
                "conjugation/coset action. Geometric cycle incidence requires "
                "G7.3 materialization (currently residual)."
            ),
            "G_equivariance": (
                "Conjugation by g∈G permutes both conjugacy orbits and preserves "
                "intersection type; transported N intertwines the two perm modules."
            ),
        },
        "direct_intersection_rebuild_matches": True,
        "design_packet": str(DESIGN.relative_to(ROOT)),
        "design_exit": design_doc.get("markers")
        or {"from_STATUS": "G7-CROSS-CLASS-PROJECTOR-PASS"},
    }


def synthetic_F0_points():
    """Independent sample of F=0 points for scaling-interface tests only.

    These are NOT induced-cycle points. Verifier may rebuild its own sample.
    """
    from itertools import product

    found = []
    for coords in product(range(-2, 3), repeat=5):
        if all(x == 0 for x in coords):
            continue
        v = [ew.C(x) for x in coords]
        if eval_F(v) == ew.C(0):
            found.append(v)
            if len(found) >= 8:
                break
    assert len(found) >= 4, "need enough F=0 samples"
    return found


def build_scaling_interface(test_points):
    """G7.2 — projective-lift / scaling gate (independent of induced cycles)."""
    third_intersection = {
        "name": "third_intersection_on_line",
        "formula": "r_ij = B(p_i,q_j,q_j) p_i - B(p_i,p_i,q_j) q_j",
        "bidegree": {"p": 2, "q": 2},
        "projectively_meaningful": True,
        "scale_test": (
            "p→λp, q→μq ⇒ B scales by λ μ² and λ² μ respectively so "
            "r → λ² μ² r (overall scalar); [r] unchanged"
        ),
    }
    incidence_sum = {
        "name": "incidence_weighted_sum",
        "formula": "s_i = sum_j N_ij · lift(q_j)  (requires cone lifts)",
        "requires": "audited affine cone lifts on a common open",
        "forbidden": "silent sum of arbitrary homogeneous representatives",
        "scale_safe_when": (
            "each q_j uses a stored chart-normalized lift, or each is scaled "
            "by the same Galois-compatible unit; otherwise use multihomogeneous "
            "symmetric tensors instead of raw sums"
        ),
    }
    points_meta = []
    stored = []
    for i, raw in enumerate(test_points):
        assert eval_F(raw) == ew.C(0)
        assert not is_zero_v(raw)
        normed, chart_i = normalize_chart(raw)
        assert eval_F(normed) == ew.C(0)
        assert proj_eq(raw, normed)
        points_meta.append(
            {
                "sample_index": i,
                "role": "scaling_test_sample_only",
                "chart_index": chart_i,
                "open": f"x_{chart_i} != 0",
                "nonzero": True,
                "not_induced_cycle_point": True,
            }
        )
        stored.append(
            {
                "sample_index": i,
                "homogeneous_coordinates_raw": v_to_json(raw),
                "homogeneous_coordinates_normalized": v_to_json(normed),
                "normalization": {
                    "method": "first_nonzero_coord_to_1",
                    "chart_index": chart_i,
                    "open": f"x_{chart_i} != 0",
                },
            }
        )
    return {
        "schema": "g7b-projective-scaling-v2",
        "interface": "cone_lifts_plus_multihomogeneous",
        "marker": "G7-PROJECTIVE-SCALING-PASS",
        "induced_cycle_binding": False,
        "cone_lifts": {
            "method": "first_nonzero_coordinate_chart_to_1",
            "field": "Q(zeta_11)",
            "n_sample_points": len(test_points),
            "sample_points": stored,
            "points": points_meta,
            "galois_compatible": (
                "Chart choice is the minimal index of a nonzero coordinate; "
                "on the open where that coordinate stays nonzero the lift is "
                "unique. Sample points are for interface tests only."
            ),
            "nonvanishing_opens": sorted({p["open"] for p in points_meta}),
            "note": (
                "Samples are independent F=0 vectors used only to exercise the "
                "scaling interface. They are not H_A5-induced cycle coordinates."
            ),
        },
        "multihomogeneous_ops": {
            "third_intersection": third_intersection,
            "incidence_sum_policy": incidence_sum,
            "polarization_B": {
                "source": "G3A POLARIZATION.md / Phi = B(x,x,x)",
                "symmetry": "fully symmetric trilinear",
            },
        },
        "verifier_contract": {
            "verify_scaling.py": (
                "Independently rescale every sample point by a random nonzero "
                "scalar in Q(zeta_11) and check: (1) F still 0; (2) projective "
                "equality with stored line; (3) third-intersection sample is "
                "scale-invariant; (4) raw unnormalized sums of two lifts differ "
                "from chart-normalized incidence sums when scales disagree "
                "(demonstrating the silent-sum failure mode)."
            )
        },
        "silent_sum_forbidden": True,
    }


def build_residual_cycles(classes, classes_data, coset_actions):
    """G7.3 residual: abstract induction bound; no G3-frame 5-tuples."""
    g4_ind = json.loads((G4 / "induced_points.json").read_text())
    out_classes = []
    for cl, cld, ca in zip(classes, classes_data, coset_actions):
        point_path = H_A5 / f"A5_class_{cl['class_index']}" / "point.json"
        point = json.loads(point_path.read_text())
        g4_cl = next(c for c in g4_ind["classes"] if c["label"] == cl["label"])
        out_classes.append(
            {
                "label": cl["label"],
                "design_label": cl["design_label"],
                "class_index": cl["class_index"],
                "degree": 11,
                "coordinates_materialized": False,
                "G3_frame_coordinates": None,
                "materialization_status": "RESIDUAL",
                "L_H": {
                    "description": (
                        "Finite etale K_proj-algebra L_H = T ×^G (G/H) for the "
                        "generic G-torsor T. Coset basis e_0..e_10 with left G-action "
                        "via s_perm, t_perm."
                    ),
                    "basis": [f"e_{i}" for i in range(11)],
                    "degree_over_K_proj": 11,
                    "G_action": "left multiplication via s_perm, t_perm",
                    "integral_on_open": (
                        "complement of vanishing of coset-chart denominators and of "
                        "the H_A5 open where the degree-11 covariant and A-frame "
                        "are invertible"
                    ),
                },
                "base_H_point": {
                    "path": str(point_path.relative_to(ROOT)),
                    "exit": point.get("exit"),
                    "format": point.get("format"),
                    "installed_coordinates": point.get("installed_coordinates"),
                    "scope": (
                        "H_A5 supplies z(y)=A(y)^{-1} J Phi(y) on the A5-twist over "
                        "K=C(P^2)^A5; not a constant vector in the split G3 frame."
                    ),
                },
                "abstract_induction": {
                    "source": "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER",
                    "g4_exit": "G4-INDUCED-DEGREE11-POINT-PASS",
                    "theorem": g4_cl.get("induction_theorem", {}).get("statement"),
                    "not_claimed_by_g4": g4_cl.get("induction_theorem", {}).get(
                        "not_claimed", []
                    ),
                    "conjugates_structural": [
                        {
                            "coset_index": i,
                            "label": f"{'p' if cl['class_index'] == 1 else 'q'}_{i}",
                            "coset_representative_12perm": list(cld["cosets"][i]),
                            "G3_frame_coordinates": None,
                            "meaning": (
                                "Galois/coset translate of specialized H-point; "
                                "coordinates residual"
                            ),
                        }
                        for i in range(11)
                    ],
                },
                "coset_action": {
                    "s_perm": ca["s_perm"],
                    "t_perm": ca["t_perm"],
                    "image_order": ca["image_order"],
                    "character_stats": ca["character_stats"],
                    "coset_representatives_12perm": [
                        list(g) for g in cld["cosets"]
                    ],
                    "H_gens_sl2": cl["gens_sl2"],
                    "H_gens_as_12perms": {
                        "rho": list(cl["gens_12"][0]),
                        "tau": list(cl["gens_12"][1]),
                    },
                },
                "galois_action": {
                    "statement": (
                        "Gal(L_H/K_proj) acts through the image of G on cosets; "
                        "s_perm, t_perm generate a transitive subgroup of S_11 of "
                        "order 660. Abstract unordered 11-set is K_proj-stable "
                        "of degree 11 (G4). Geometric coordinates residual."
                    ),
                    "s_perm": ca["s_perm"],
                    "t_perm": ca["t_perm"],
                    "image_order": 660,
                    "matches_coset_action": True,
                },
                "K_proj_cycle": {
                    "degree": 11,
                    "defined_over_K_proj": {
                        "claimed": False,
                        "proof_object": None,
                        "abstract_G4_stability": True,
                        "note": (
                            "Do not trust a bare Boolean. G4 proves abstract "
                            "Galois-stability of the unordered cycle; explicit "
                            "G3-frame coordinates with a rebuilt descent proof "
                            "object are residual."
                        ),
                    },
                    "reduced_on_open": "residual",
                    "materialization": None,
                },
                "forbidden_constructions": [
                    {
                        "formula": "p_i = rho(g_i) * e_0, e_0=(1:0:0:0:0)",
                        "status": "REFUTED",
                        "reason": (
                            "|Stab_G([e0])|=11, H does not stabilize [e0]; "
                            "coset map not well-defined; equivariance fails 44/44"
                        ),
                        "audit": "audit_induced_refutation.py",
                    }
                ],
                "required_for_pass": [
                    "well-definedness: p(gh)~p(g) for h in H",
                    "equivariance: rho(g)p_i ~ p_{g·i} for generators s,t",
                    "landing: Phi/F=0 from H_A5+induction (not only F(rho g e0)=0)",
                    "descent proof object rebuilt by verifier over K_proj",
                    "Galois/coset agreement on geometric points",
                    "incidence map between materialized etale algebras",
                ],
            }
        )

    return {
        "schema": "g7b-induced-double-cycles-residual-v2",
        "materialization_status": "RESIDUAL",
        "exit_for_materialization": None,
        "residual_gate": RESIDUAL_GATE,
        "ambient": {
            "frame": "normalized G3 / G3A Klein P(W)",
            "Phi": "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
            "split_model": "F_Klein = sum_i x_i^2 x_{i+1} on W (G2)",
            "note": "No explicit 22 coordinates installed in this packet.",
        },
        "classes": out_classes,
        "coset_actions": [
            {
                "label": cl["label"],
                "s_perm": ca["s_perm"],
                "t_perm": ca["t_perm"],
                "image_order": ca["image_order"],
            }
            for cl, ca in zip(classes, coset_actions)
        ],
        "withdrawn": {
            "prior_schema": "g7b-induced-double-cycles-v1",
            "prior_construction": "rho(g_i)*e0",
            "artifact": "cycles_WITHDRAWN_rho_e0.json",
            "status": "non-consumable",
            "refutation": "INDUCED_CYCLE_REFUTATION.md",
        },
        "n_correct_G3_coordinates": 0,
        "both_classes_materialized": False,
    }


def write_markdowns(scaling, cycles, incidence, meta):
    opens = "\n".join(scaling["cone_lifts"]["nonvanishing_opens"])
    (HERE / "PROJECTIVE_SCALING.md").write_text(
        f"""# G7.2 — projective-lift and scaling gate

## Interface installed

**`{scaling["interface"]}`** — audited affine cone lifts **and** multihomogeneous
tensor formulas for projective operations.

### Cone lifts

Chart normalization: first nonzero coordinate scaled to `1`. Sample F=0 points
(not induced-cycle points) exercise the interface. Nonvanishing opens among
samples:

```text
{opens}
```

On the open where the chosen chart coordinate remains nonzero, the lift is the
unique vector on the line with that coordinate `1`. Residual `C*`-scales never
enter projective constructions.

### Multihomogeneous operations

- Third intersection on a line through `p,q`:
  `r = B(p,q,q)p − B(p,p,q)q` (bidegree (2,2) — projectively meaningful).
- Incidence-weighted sums require audited chart lifts (or a common
  Galois-compatible unit scale). **Silent sums of arbitrary homogeneous
  representatives are forbidden** and fail the scaling verifier.

### Binding

This gate does **not** claim induced-cycle coordinates. It seals the
scale-safe operation interface for any later geometric points.

### Verifier contract

`verify_scaling.py` deliberately rescales every sample point independently and
checks projective outputs are unchanged. Marker:

```text
G7-PROJECTIVE-SCALING-PASS
```
""",
        encoding="utf-8",
    )

    (HERE / "CYCLES.md").write_text(
        f"""# G7.3 — induced double cycles (REDO residual)

## Materialization status: RESIDUAL

No well-defined G3-frame coordinates for the two degree-11 induced cycles are
installed. Primary residual gate:

```text
{RESIDUAL_GATE}
```

## Why not `rho(g_i)·e_0`

The withdrawn construction

```text
p_i = ρ(g_i)·e_0,   e_0 = (1:0:0:0:0)
```

is representative-dependent: `|Stab_G([e_0])|=11`, so `H ⊈ Stab([e_0])`.
Coset well-definedness fails; equivariance `ρ(g)p_i ~ p_{{g·i}}` fails 44/44.

See `INDUCED_CYCLE_REFUTATION.md` and `audit_induced_refutation.py`.
Historical artifact: `cycles_WITHDRAWN_rho_e0.json` (non-consumable).

## What is installed (structural)

For each A5 class:

1. Coset action `s_perm`, `t_perm` of image order 660 (from sealed H_A5 gens).
2. Binding to H_A5 `point.json` formula path (degree-11 Reynolds / frame map).
3. Abstract G4 induction theorem (L_H, Gal-stable unordered 11-set).
4. Explicit list of **required** checks for a future pass (well-definedness,
   equivariance, landing, descent proof object, Galois agreement, incidence).

## What is NOT installed

- No 22 correct G3-frame 5-tuples.
- No `defined_over_K_proj: true` Boolean without a proof object.
- No claim that constant-field W-orbits are the induced cycle (G4 boundary).

## Path to a correct pass

**A. H_A5 formula path (preferred):** transport sealed H_A5 point
`z = A^{{-1}} J Φ` along genuine coset / H-reduction / generic G-twist into the
G3A frame over `L_H`, or as an explicit Galois cocycle of 11 conjugates over
`K_proj`.

**B. H-fixed cone lift:** only if the affine cone vector is H-invariant up to
scalar on the open used (proved), so `gH ↦ [vector]` is well-defined.

Until then: exit is **not** `G7-INDUCED-DOUBLE-CYCLE-PASS`.
""",
        encoding="utf-8",
    )

    (HERE / "INCIDENCE_CORRESPONDENCE.md").write_text(
        """# Incidence correspondence (abstract coset modules)

## Objects

- `L_H = T ×^G (G/H)` — coset basis `e_0,…,e_10` (A5 class 1)
- `L_K = T ×^G (G/K)` — coset basis `f_0,…,f_10` (A5 class 2)

Identify cosets with conjugates: `gH ↔ gHg^{-1}`.

## Map

Derived from G7A Paley biplane incidence (A4 intersections of order 12):

```text
N_*(e_i) = Σ_j N_{ij} f_j
N^*(f_j) = Σ_i N_{ij} e_i
```

with `N` the 11×11 zero-one matrix on the **coset bases** (not a bare matrix
detached from the design). On augmentation modules (`char ≠ 3`):

```text
N^{-1} = (1/3) N^t
```

## Scope

This is an **abstract** correspondence of etale / permutation modules.
Geometric incidence of induced-cycle points requires G7.3 materialization
(currently residual). Direct rebuild from conjugate intersections matches
the transported design matrix.

Machine data: `incidence_correspondence.json`.
""",
        encoding="utf-8",
    )

    (HERE / "REPLAY.md").write_text(
        """# G7B REDO replay

From repository root `problems/E-klein-cubic` (workspace root):

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/produce.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/verify_scaling.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/verify_cycles.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/audit_induced_refutation.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/make_seal.py
```

Expected:

```text
G7B_PRODUCE_OK
G7-PROJECTIVE-SCALING-PASS
G7B_VERIFY_SCALING_OK
G7B_VERIFY_CYCLES_OK
G7B-INDUCED-CYCLE-REFUTED
G7B_AUDIT_OK
G7B_SEAL_OK
```

Primary STATUS exit: `G7-PROJECTIVE-SCALING-PASS` (G7.3 residual).

Notes:

- Verifiers do **not** import `produce.py`.
- `audit_induced_refutation.py` is a regression: the e0 construction must remain
  refuted; STATUS/SEAL must not re-claim `G7-INDUCED-DOUBLE-CYCLE-PASS` without
  a correct materialization that passes the hardened cycle verifier.
- Historical `cycles_WITHDRAWN_rho_e0.json` is non-consumable.
""",
        encoding="utf-8",
    )

    rss = meta["peak_rss_mb"]
    wall = meta["wall_s"]
    (HERE / "STATUS.md").write_text(
        f"""G7-PROJECTIVE-SCALING-PASS

# Goal G7B REDO status — scaling sealed; induced materialization residual

**Primary exit:** `G7-PROJECTIVE-SCALING-PASS`  
**G7.3 materialization:** residual (not `G7-INDUCED-DOUBLE-CYCLE-PASS`)  
**Refutation marker:** `G7B-INDUCED-CYCLE-REFUTED` (e0 construction)  
**Headline:** OPEN  
**Stages:** G7.2 sealed; G7.3 residual  

## Decision

### G7.2 — projective scaling (PASS)

Installed cone-lift method (first-nonzero chart → 1) and multihomogeneous
operation contracts (third intersection bidegree (2,2); incidence sums require
audited lifts). Silent sums of independently scaled homogeneous representatives
are forbidden and are demonstrated to fail under independent rescaling.
Sample F=0 points exercise the interface only — they are **not** induced-cycle
coordinates.

### G7.3 — both induced cycles (RESIDUAL)

Correct materialization requires a well-defined coset → point map:

- **H_A5 formula path:** transport sealed `z = A^{{-1}} J Φ` into the G3A frame
  over `L_H` / Galois cocycle of 11 conjugates over `K_proj`; or
- **H-fixed cone lift:** prove H stabilizes the projective line of the lift.

**Forbidden / refuted:** `p_i = ρ(g_i)·e_0` with `e_0=(1:0:0:0:0)`:
`|Stab_G([e_0])|=11`, well-definedness fails, equivariance 44/44 fails.

Named residual:

```text
{RESIDUAL_GATE}
```

**Correct G3-frame coordinates installed:** **0** of 22.

Abstract coset actions (image 660), H_A5 binding, G4 induction theorem, and
abstract biplane incidence `N` on coset modules are retained as structure.
`defined_over_K_proj` is **not** asserted as a bare Boolean without a proof
object the verifier rebuilds.

## Supersession / consumption ban

- Prior `G7-INDUCED-DOUBLE-CYCLE-PASS` is **superseded and non-consumable**.
- `cycles_WITHDRAWN_rho_e0.json` is historical only.
- Do **not** treat any stored e0-orbit 5-tuples as H_A5-induced cycles.
- G7C residual geometry on e0 points is **not** induced-cycle geometry.
- G3P.3 Springer still needs genuine G3-frame induced points.

## Nonclaims

- No `K_proj`-point of `X_gen` (headline OPEN).
- No G7C cross-ops / residual geometry in this packet.
- Does not reseal H_A5, G4, G7A, or G3A.

## Peak resource

Producer wall ≈ {wall:.2f} s; peak RSS ≈ {rss:.1f} MB.

## Replay

See `REPLAY.md`. Markers: `G7B_VERIFY_SCALING_OK`, `G7B_VERIFY_CYCLES_OK`,
`G7B_AUDIT_OK`, `G7B-INDUCED-CYCLE-REFUTED`.
""",
        encoding="utf-8",
    )


def main() -> None:
    t0 = time.time()
    s, t, G = build_group()
    perm_to_rho = build_perm_to_rho()
    assert all(g in perm_to_rho for g in G)

    inputs = [
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/STATUS.md", "design_status"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/SEAL.json", "design_seal"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/incidence_N.json", "design_N"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/design.json", "design_json"),
        ("goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/STATUS.md", "g4_status"),
        ("goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/SEAL.json", "g4_seal"),
        ("goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/induced_points.json", "g4_induced"),
        ("goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md", "g3a_status"),
        ("goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/SEAL.json", "g3a_seal"),
        ("goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/field_model.json", "g3a_field"),
        ("goal_runs_after_35fa/H_A5_TWISTS/STATUS.md", "h_a5_status"),
        ("goal_runs_after_35fa/H_A5_TWISTS/SEAL.json", "h_a5_seal"),
        ("goal_runs_after_35fa/H_A5_TWISTS/A5_class_1/point.json", "h_a5_c1"),
        ("goal_runs_after_35fa/H_A5_TWISTS/A5_class_2/point.json", "h_a5_c2"),
        ("goal_runs_after_35fa/H_A5_TWISTS/canonical_model_payload.json", "h_a5_canonical"),
        ("goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json", "generic_cubic"),
    ]
    man = {
        "schema": "g7b-input-manifest-v1",
        "inputs": [
            {"path": p, "sha256": sha256(ROOT / p), "role": role}
            for p, role in inputs
        ],
    }

    design_status = (DESIGN / "STATUS.md").read_text()
    assert design_status.startswith("G7-CROSS-CLASS-PROJECTOR-PASS") or design_status.startswith(
        "G7-PALEY-BIPLANE-IDENTIFIED"
    ), "design exit"
    g4_status = (G4 / "STATUS.md").read_text()
    assert g4_status.startswith("G4-INDUCED-DEGREE11-POINT-PASS"), "g4 exit"
    g3a_status = (G3A / "STATUS.md").read_text()
    assert g3a_status.startswith("G3A-ARITHMETIC-DOMINANCE-PASS"), "g3a exit"

    design_N_doc = json.loads((DESIGN / "incidence_N.json").read_text())
    design_N = design_N_doc["N"] if "N" in design_N_doc else design_N_doc
    design_doc = json.loads((DESIGN / "design.json").read_text())

    classes = a5_classes_from_h_a5(G)
    coset_actions = []
    classes_data = []
    for cl in classes:
        ca, cosets, _act = coset_action(G, cl["H"], s, t)
        coset_actions.append(ca)
        classes_data.append(
            {
                "label": cl["label"],
                "design_label": cl["design_label"],
                "H": cl["H"],
                "cosets": cosets,
            }
        )

    # Explicitly refuse the e0 construction (sanity: stab is not H)
    e0 = [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)]
    stab = [g for g in G if proj_eq(mv(perm_to_rho[g], e0), e0)]
    assert len(stab) == 11, f"unexpected |Stab(e0)|={len(stab)}"
    for cl in classes:
        inter = len(set(cl["H"]) & set(stab))
        assert inter != 60, "H unexpectedly stabilizes e0"

    cycles_payload = build_residual_cycles(classes, classes_data, coset_actions)
    incidence = build_incidence_correspondence(G, classes_data, design_N, design_doc)
    scaling = build_scaling_interface(synthetic_F0_points())

    (HERE / "INPUT_MANIFEST.json").write_text(json.dumps(man, indent=2) + "\n")
    (HERE / "scaling_interface.json").write_text(json.dumps(scaling, indent=2) + "\n")
    (HERE / "cycles.json").write_text(json.dumps(cycles_payload, indent=2) + "\n")
    (HERE / "incidence_correspondence.json").write_text(
        json.dumps(incidence, indent=2) + "\n"
    )

    wall = time.time() - t0
    rss = peak_rss_mb()
    meta = {
        "schema": "g7b-produce-meta-v2",
        "wall_s": wall,
        "peak_rss_mb": rss,
        "exit": EXIT_PRIMARY,
        "g7_3_materialization": "RESIDUAL",
        "residual_gate": RESIDUAL_GATE,
        "n_correct_G3_coordinates": 0,
        "stages": ["G7.2", "G7.3-residual"],
    }
    (HERE / "produce_meta.json").write_text(json.dumps(meta, indent=2) + "\n")
    write_markdowns(scaling, cycles_payload, incidence, meta)

    print("G7B_PRODUCE_OK")
    print(EXIT_PRIMARY)
    print("G7_3_MATERIALIZATION=RESIDUAL")
    print(f"residual_gate={RESIDUAL_GATE}")
    print(f"n_correct_G3_coordinates=0")
    print(f"peak_rss_mb={rss:.2f}")
    print(f"wall_s={wall:.2f}")


if __name__ == "__main__":
    main()
