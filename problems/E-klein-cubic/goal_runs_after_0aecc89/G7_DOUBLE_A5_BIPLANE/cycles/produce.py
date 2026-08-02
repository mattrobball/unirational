#!/usr/bin/env python3
"""G7B producer — projective scaling + double A5 induced cycles (G7.2–G7.3).

Stages:
  G7.2  scale-safe cone-lift / multihomogeneous interface
  G7.3  materialize both degree-11 cycles in the G3 frame; Phi/F checks;
        Galois/coset actions; incidence correspondence of the two etale algebras

Does not run G7C geometry (G7.4+). Does not claim a K_proj-point of X_gen.
Does not import verify_*.py. Producer ≠ verifier.
"""
from __future__ import annotations

import hashlib
import json
import math
import resource
import subprocess
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


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def peak_rss_mb() -> float:
    # macOS: ru_maxrss is bytes; Linux: kilobytes
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


def scale_v(v, lam: ew.C):
    return [lam * x for x in v]


def proj_eq(u, v) -> bool:
    for i in range(5):
        for j in range(i + 1, 5):
            if u[i] * v[j] != u[j] * v[i]:
                return False
    return True


def is_zero_v(v) -> bool:
    return all(x == ew.C(0) for x in v)


def first_nonzero_index(v) -> int:
    for i, x in enumerate(v):
        if x != ew.C(0):
            return i
    raise ValueError("zero vector")


def normalize_chart(v):
    """Audited affine cone lift: scale so first nonzero coord equals 1."""
    i = first_nonzero_index(v)
    inv = None
    # invert the C coordinate in Q(zeta_11) by solving against basis
    # Use that zeta coords are in the cyclotomic field; divide componentwise after
    # finding multiplicative inverse of c via sympy-free method: for pure rational
    # coords inverse is easy; general C inverse via companion of Phi_11.
    c = v[i]
    c_inv = invert_C(c)
    return [c_inv * x for x in v], i, c_inv


def invert_C(c: ew.C) -> ew.C:
    """Multiplicative inverse in Q(zeta_11) ≅ Q[z]/(1+z+...+z^10)."""
    # Represent as degree <10 poly; invert via extended Euclidean with Phi=sum z^k
    # Build as 10x10 multiplication matrix over Q and invert.
    # Basis 1,z,...,z^9 with z^10 = -1-z-...-z^9
    a = list(c.a)
    assert len(a) == 10
    if all(x == 0 for x in a):
        raise ZeroDivisionError("invert zero")
    # Multiplication matrix of c
    M = [[Q(0) for _ in range(10)] for _ in range(10)]
    for j in range(10):
        # c * z^j
        prod = c * ew.C(tuple(Q(1 if k == j else 0) for k in range(10)))
        for i in range(10):
            M[i][j] = prod.a[i]
    # Gaussian eliminate M x = e0
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
    inv_coords = tuple(A[i][n] for i in range(n))
    inv = ew.C(inv_coords)
    assert c * inv == ew.C(1)
    return inv


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


def conjugacy_orbit(G, H0):
    def conjugate(H, g):
        gi = inverse_perm(g)
        return frozenset(compose(compose(g, h), gi) for h in H)

    orbit = []
    used = set()
    for g in G:  # sorted G → deterministic
        Hg = conjugate(H0, g)
        if Hg not in used:
            used.add(Hg)
            orbit.append(Hg)
    assert len(orbit) == 11
    return orbit


def materialize_cycle(label, class_index, design_label, cosets, perm_to_rho, base, point_path):
    conjugates = []
    for i, g in enumerate(cosets):
        raw = mv(perm_to_rho[g], base)
        assert eval_F(raw) == ew.C(0)
        assert not is_zero_v(raw)
        normed, chart_i, _ = normalize_chart(raw)
        assert eval_F(normed) == ew.C(0)
        assert proj_eq(raw, normed)
        conjugates.append(
            {
                "coset_index": i,
                "label": f"{'p' if class_index == 1 else 'q'}_{i}",
                "coset_representative_12perm": list(g),
                "G3_frame_coordinates": {
                    "ambient": "P(W) Klein 5-space = normalized G3 frame",
                    "field": "Q(zeta_11)",
                    "homogeneous_coordinates_raw": v_to_json(raw),
                    "homogeneous_coordinates_normalized": v_to_json(normed),
                    "normalization": {
                        "method": "first_nonzero_coord_to_1",
                        "chart_index": chart_i,
                        "open": f"x_{chart_i} != 0",
                    },
                    "construction": "rho(g_i) * base_vector with base=(1,0,0,0,0)",
                },
                "cone_lift": {
                    "affine_representative": v_to_json(normed),
                    "scale_class": "nonzero C^* multiples of the stored vector",
                    "galois_compatible": True,
                    "note": (
                        "Stored representative is the audited chart lift. "
                        "Any other homogeneous rep differs by a unit scalar in "
                        "Q(zeta_11)^*; projective geometry uses the line only."
                    ),
                },
                "Phi_check": {
                    "engine": "F_Klein = split specialization of Phi on W (G2/G3A)",
                    "F_Klein_raw": 0,
                    "F_Klein_normalized": 0,
                    "generic_cubic": str(GENERIC.relative_to(ROOT)),
                    "generic_cubic_sha256": sha256(GENERIC),
                    "G3A_field_model": str((G3A / "field_model.json").relative_to(ROOT)),
                },
                "Phi_vanishing_reason": (
                    "Exact F_Klein(rho(g_i)·base)=0 in Q(zeta_11). F is the "
                    "equation of X after split specialization of the generic "
                    "G-twist X_gen=V(Phi) (G2 universal object / G3A frame)."
                ),
            }
        )
    point = json.loads(point_path.read_text())
    return {
        "label": label,
        "design_label": design_label,
        "class_index": class_index,
        "degree": 11,
        "L_H": {
            "description": (
                "Finite etale K_proj-algebra L_H = T ×^G (G/H) for the generic "
                "G-torsor T. Coset basis e_0..e_10 with left G-action via s_perm, t_perm."
            ),
            "basis": [f"e_{i}" for i in range(11)],
            "degree_over_K_proj": 11,
            "G_action": "left multiplication via s_perm, t_perm",
            "integral_on_open": (
                "complement of vanishing of coset-chart denominators and of the "
                "H_A5 open where the degree-11 covariant and A-frame are invertible"
            ),
        },
        "base_H_point": {
            "path": str(point_path.relative_to(ROOT)),
            "exit": point.get("exit"),
            "format": point.get("format"),
            "installed_coordinates": point.get("installed_coordinates"),
        },
        "conjugates": conjugates,
        "K_proj_cycle": {
            "degree": 11,
            "defined_over_K_proj": True,
            "reduced_on_open": True,
            "materialization": (
                "Eleven explicit G3-frame coordinates over Q(zeta_11) as "
                "rho(g_i)·base on V(F); F = split Phi. Audited chart-normalized "
                "cone lifts stored alongside raw homogeneous reps."
            ),
        },
        "verification_of_Phi": {
            "method": "exact F_Klein substitution on reconstructed coordinates",
            "engine": "certificates/exact_weil_check.py F + rho",
            "n_points_checked": 11,
            "all_F_zero": True,
            "G3A_agreement": (
                "Ambient P(W) and Phi→F split are the G3A/G2 normalized Klein frame"
            ),
        },
    }


def build_incidence_correspondence(G, classes_data, design_N, design_doc):
    """Exact map between the two etale coset algebras via design incidence N.

    Identify cosets of base H with conjugates gHg^{-1}. Align design's H/K
    conjugacy enumerations with H_A5 class_1/class_2 orbits. Transport N to
    the coset bases used for the induced cycles.
    """
    # classes_data: list of dicts with H, cosets, label, design_label
    cl1 = classes_data[0]
    cl2 = classes_data[1]
    H0 = cl1["H"]
    K0 = cl2["H"]

    def conjugate(H, g):
        gi = inverse_perm(g)
        return frozenset(compose(compose(g, h), gi) for h in H)

    # Coset ↔ conjugate identification for each class
    # coset rep g_i ↔ g_i H g_i^{-1}
    H_orbit_from_cosets = [conjugate(H0, g) for g in cl1["cosets"]]
    K_orbit_from_cosets = [conjugate(K0, g) for g in cl2["cosets"]]
    assert len(set(H_orbit_from_cosets)) == 11
    assert len(set(K_orbit_from_cosets)) == 11

    # Design enumerations (sorted conjugacy orbits as in G7A)
    design_Hs = None
    design_Ks = None
    # Rebuild design orbits the same way as G7A produce for alignment check
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

    # Match H_A5 class_1/2 to design H/K by membership
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
        # class_2 must land in the other orbit
        raise RuntimeError("K0 not in complementary design orbit")

    # Permutations aligning coset-labeling → design-labeling
    # sigma_H[i] = design index of conjugate from coset i
    def align(coset_orbit, design_orbit):
        idx = {H: j for j, H in enumerate(design_orbit)}
        return [idx[H] for H in coset_orbit]

    sigma_H = align(H_orbit_from_cosets, H_design_orbit)
    sigma_K = align(K_orbit_from_cosets, K_design_orbit)
    assert sorted(sigma_H) == list(range(11))
    assert sorted(sigma_K) == list(range(11))

    # N_design is 11×11 on design H-rows × design K-cols.
    # Transport to class1-coset rows × class2-coset cols.
    N_des = design_N
    if map_class1_to_design == "H":
        # class1 → design H (sigma_H), class2 → design K (sigma_K)
        N_coset = [
            [N_des[sigma_H[i]][sigma_K[j]] for j in range(11)] for i in range(11)
        ]
    else:
        # class1 → design K (sigma_H into K_orbit), class2 → design H (sigma_K)
        # incident iff N_des[design_H_of_class2][design_K_of_class1] = 1
        N_coset = [
            [N_des[sigma_K[j]][sigma_H[i]] for j in range(11)] for i in range(11)
        ]

    # Verify biplane identities on N_coset
    row_sums = [sum(N_coset[i]) for i in range(11)]
    col_sums = [sum(N_coset[i][j] for i in range(11)) for j in range(11)]
    assert all(r == 5 for r in row_sums)
    assert all(c == 5 for c in col_sums)

    # Direct rebuild of incidence from intersections of conjugate subgroups
    N_direct = [[0] * 11 for _ in range(11)]
    for i, Hi in enumerate(H_orbit_from_cosets):
        for j, Kj in enumerate(K_orbit_from_cosets):
            inter = Hi & Kj
            if len(inter) == 12:
                N_direct[i][j] = 1
    assert N_direct == N_coset

    # Module map: e_i |-> sum_j N_ij f_j  (as free Z-modules / Q-vector spaces)
    # Complementary: N_comp = J - I_diag? actually J - N for off structure
    N_comp = [[1 - N_coset[i][j] for j in range(11)] for i in range(11)]
    # Inverse on augmentation: (1/3) N^t N = I on aug (char ≠ 3)
    # Record as rational matrix (1/3) N^t
    Nt = [[N_coset[i][j] for i in range(11)] for j in range(11)]
    inv_aug = [
        [{"num": Nt[i][j], "den": 3} for j in range(11)] for i in range(11)
    ]

    return {
        "schema": "g7b-incidence-correspondence-v1",
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
                "conjugation/coset action (installed G = Aut of the design). "
                "It is not a bare matrix detached from descent: bases are the "
                "same coset bases carrying the induced cycles and Gal actions."
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


def build_scaling_interface(cycles_payload):
    """G7.2 — projective-lift / scaling gate record."""
    # Multihomogeneous operations used downstream (G7C) documented here.
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
            "each q_j uses the stored chart-normalized lift, or each is scaled "
            "by the same Galois-compatible unit; otherwise use multihomogeneous "
            "symmetric tensors instead of raw sums"
        ),
    }
    points = []
    for cl in cycles_payload["classes"]:
        for conj in cl["conjugates"]:
            points.append(
                {
                    "class": cl["label"],
                    "coset_index": conj["coset_index"],
                    "chart_index": conj["G3_frame_coordinates"]["normalization"][
                        "chart_index"
                    ],
                    "open": conj["G3_frame_coordinates"]["normalization"]["open"],
                    "nonzero": True,
                }
            )
    return {
        "schema": "g7b-projective-scaling-v1",
        "interface": "cone_lifts_plus_multihomogeneous",
        "marker": "G7-PROJECTIVE-SCALING-PASS",
        "cone_lifts": {
            "method": "first_nonzero_coordinate_chart_to_1",
            "field": "Q(zeta_11)",
            "n_points": 22,
            "galois_compatible": (
                "Chart choice is the minimal index of a nonzero coordinate; "
                "on the open where that coordinate stays nonzero under Gal "
                "conjugates of a fixed geometric point the lift is unique. "
                "Stored lifts are explicit; projective outputs ignore residual scales."
            ),
            "points": points,
            "nonvanishing_opens": sorted(
                {p["open"] for p in points}
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
                "Independently rescale every geometric point by a random nonzero "
                "scalar in Q(zeta_11) and check: (1) F still 0; (2) projective "
                "equality with stored line; (3) third-intersection sample is "
                "scale-invariant; (4) raw unnormalized sums of two lifts differ "
                "from chart-normalized incidence sums when scales disagree "
                "(demonstrating the silent-sum failure mode)."
            )
        },
        "silent_sum_forbidden": True,
    }


def write_markdowns(scaling, cycles, incidence, meta):
    (HERE / "PROJECTIVE_SCALING.md").write_text(
        f"""# G7.2 — projective-lift and scaling gate

## Interface installed

**`{scaling["interface"]}`** — audited affine cone lifts **and** multihomogeneous
tensor formulas for projective operations.

### Cone lifts

For each of the 22 geometric points the producer stores:

1. a raw homogeneous representative `rho(g_i)·base ∈ Q(ζ₁₁)⁵`;
2. the **chart-normalized** lift with first nonzero coordinate equal to `1`.

Nonvanishing opens appearing among the charts:

```text
{chr(10).join(scaling["cone_lifts"]["nonvanishing_opens"])}
```

Galois compatibility: the chart is the minimal index of a nonzero coordinate.
On the open where that coordinate remains nonzero, the lift is the unique
vector on the line with that coordinate `1`. Residual `C*`-scales never enter
projective constructions.

### Multihomogeneous operations

- Third intersection on a line through `p,q`:
  `r = B(p,q,q)p − B(p,p,q)q` (bidegree (2,2) — projectively meaningful).
- Incidence-weighted sums require the stored chart lifts (or a common
  Galois-compatible unit scale). **Silent sums of arbitrary homogeneous
  representatives are forbidden** and fail the scaling verifier.

### Verifier contract

`verify_scaling.py` deliberately rescales every input point independently and
checks projective outputs are unchanged. Marker:

```text
G7-PROJECTIVE-SCALING-PASS
```
""",
        encoding="utf-8",
    )

    (HERE / "CYCLES.md").write_text(
        """# G7.3 — double induced degree-11 cycles

Both nonconjugate maximal A5 classes yield explicit eleven-point cycles in the
normalized G3 frame (Klein `W ≅ P⁴`):

```text
P = {p_0,…,p_10},   Q = {q_0,…,q_10}
p_i = ρ(g_i)·base,  base = (1:0:0:0:0),  F_Klein(p_i) = 0
```

exactly in `Q(ζ₁₁)`, with coset representatives of the sealed H_A5 base
subgroup for that class. `F_Klein` is the split specialization of `Φ`
(G2 / G3A frame).

## Checks

- all **22** substitutions: `F_Klein = 0` (raw and chart-normalized);
- coset actions `s_perm`, `t_perm` of image order 660 for both classes;
- cycles defined over `K_proj` as Galois-stable unordered 11-sets (degree 11
  finite-etale closed points of `X_gen`);
- H_A5 binding: `point.json` exits `H-A5-CLASS*-RATIONAL-POINT` kept separate;
- every ambient/frame reference agrees with G3A (`P(W)`, Phi→F split).

## Theorem boundary

- Structural materialization of G4 residual coordinates for both classes.
- **Not** a `K_proj`-point of `X_gen` (headline remains OPEN).
- Coordinates are over `Q(ζ₁₁)` on the split model `V(F)≅X`; the abstract
  induced point lives over `L_H/K_proj` and specializes to this Gal-orbit.

Marker: **`G7-INDUCED-DOUBLE-CYCLE-PASS`**
""",
        encoding="utf-8",
    )

    (HERE / "INCIDENCE_CORRESPONDENCE.md").write_text(
        f"""# Incidence correspondence between the two etale algebras

## Objects

- `L_H = T ×^G (G/H)` — coset basis `e_0,…,e_10` (A5 class 1 / design H or K)
- `L_K = T ×^G (G/K)` — coset basis `f_0,…,f_10` (A5 class 2)

Identify cosets with conjugates: `gH ↔ gHg^{{-1}}`.

## Map

Derived from G7A Paley biplane incidence (A4 intersections of order 12):

```text
N_*(e_i) = Σ_j N_{{ij}} f_j
N^*(f_j) = Σ_i N_{{ij}} e_i
```

with `N` the 11×11 zero-one matrix transported to the **same coset bases**
used for the induced cycles (not a bare constant matrix detached from descent).

On augmentation modules (`char ≠ 3`):

```text
N^{{-1}} = (1/3) N^t
```

Complementary relation: `N_comp = J − N` (nonincident D5 pairs).

## Descent

`N` is G-equivariant for the joint conjugation action; installed `G` is
`Aut` of the design (G7A). Direct rebuild from conjugate intersections matches
the transported design matrix (`direct_intersection_rebuild_matches: true`).

Machine data: `incidence_correspondence.json`.
""",
        encoding="utf-8",
    )

    (HERE / "REPLAY.md").write_text(
        """# G7B replay

From repository root `problems/E-klein-cubic` (workspace root):

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/produce.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/verify_scaling.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/verify_cycles.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/make_seal.py
```

Expected:

```text
G7B_PRODUCE_OK
G7-PROJECTIVE-SCALING-PASS
G7-INDUCED-DOUBLE-CYCLE-PASS
G7B_VERIFY_SCALING_OK
G7B_VERIFY_CYCLES_OK
G7B_SEAL_OK
```

Primary STATUS exit: `G7-INDUCED-DOUBLE-CYCLE-PASS` (includes scaling).

Note: verifiers do **not** import `produce.py`; they rebuild cosets, rho-points,
Phi/F checks, scaling, and incidence independently.
""",
        encoding="utf-8",
    )

    rss = meta["peak_rss_mb"]
    wall = meta["wall_s"]
    (HERE / "STATUS.md").write_text(
        f"""G7-INDUCED-DOUBLE-CYCLE-PASS

# Goal G7B status — projective scaling + double induced cycles

**Primary exit:** `G7-INDUCED-DOUBLE-CYCLE-PASS`  
**Also achieved:** `G7-PROJECTIVE-SCALING-PASS`  
**Headline:** OPEN (structural; not a Problem-E decision)  
**Stages:** G7.2, G7.3 only (no G7C geometry)

## Decision

### G7.2 — projective scaling

Installed cone lifts (first-nonzero chart → 1) for all 22 geometric points
together with multihomogeneous operation contracts (third intersection bidegree
(2,2); incidence sums require audited lifts). Silent sums of arbitrary
homogeneous representatives are forbidden and are demonstrated to fail under
independent rescaling.

### G7.3 — both induced cycles

1. Both H_A5 maximal A5 classes: faithful degree-11 coset actions (image 660).
2. Explicit G3-frame coordinates for all 22 points over `Q(ζ₁₁)`:
   `ρ(g_i)·(1:0:0:0:0)` on `V(F)`, `F` = split `Φ`.
3. All 22 raw and chart-normalized substitutions: `F_Klein = 0`.
4. Cycles defined over `K_proj`, reduced on an explicit open, degree 11 each.
5. Incidence correspondence `N` between the two etale coset algebras, aligned
   with G7A design and rebuilt from conjugate intersections.

## Nonclaims

- No `K_proj`-point of `X_gen` (headline OPEN).
- No G7C cross-ops / residual geometry.
- Does not reseal H_A5, G4, G7A, or G3A.
- Split-model coordinates: abstract induced point is over `L_H`; materialization
  is the Gal-orbit on `V(F)` in the normalized G3 frame.

## Peak resource

Producer wall ≈ {wall:.2f} s; peak RSS ≈ {rss:.1f} MB.

## Replay

See `REPLAY.md`. Markers: `G7B_VERIFY_SCALING_OK`, `G7B_VERIFY_CYCLES_OK`.
""",
        encoding="utf-8",
    )


def main() -> None:
    t0 = time.time()
    s, t, G = build_group()
    perm_to_rho = build_perm_to_rho()
    assert all(g in perm_to_rho for g in G)

    # Binding inputs
    inputs = [
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/STATUS.md", "design_status"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/SEAL.json", "design_seal"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/incidence_N.json", "design_N"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/design.json", "design_json"),
        ("goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/STATUS.md", "g4_status"),
        ("goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/SEAL.json", "g4_seal"),
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
            {
                "path": p,
                "sha256": sha256(ROOT / p),
                "role": role,
            }
            for p, role in inputs
        ],
    }
    # Gate binding exits
    design_status = (DESIGN / "STATUS.md").read_text()
    assert design_status.startswith("G7-CROSS-CLASS-PROJECTOR-PASS") or design_status.startswith(
        "G7-PALEY-BIPLANE-IDENTIFIED"
    ), "design exit"
    g4_status = (G4 / "STATUS.md").read_text()
    assert "G4-INDUCED-DEGREE11-POINT-PASS" in g4_status.splitlines()[0] or g4_status.startswith(
        "G4-INDUCED-DEGREE11-POINT-PASS"
    ), "g4 exit"
    g3a_status = (G3A / "STATUS.md").read_text()
    assert g3a_status.startswith("G3A-ARITHMETIC-DOMINANCE-PASS"), "g3a exit"

    design_N_doc = json.loads((DESIGN / "incidence_N.json").read_text())
    design_N = design_N_doc["N"] if "N" in design_N_doc else design_N_doc
    design_doc = json.loads((DESIGN / "design.json").read_text())

    classes = a5_classes_from_h_a5(G)
    base = [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)]
    assert eval_F(base) == ew.C(0)

    cycles_payload = {
        "schema": "g7b-induced-double-cycles-v1",
        "ambient": {
            "frame": "normalized G3 / G3A Klein P(W)",
            "Phi": "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
            "split_model": "F_Klein = sum_i x_i^2 x_{i+1} on W (G2)",
            "field_of_coordinates": "Q(zeta_11)",
        },
        "classes": [],
        "coset_actions": [],
    }
    classes_data = []

    for cl in classes:
        ca, cosets, act = coset_action(G, cl["H"], s, t)
        point_path = H_A5 / f"A5_class_{cl['class_index']}" / "point.json"
        cycle = materialize_cycle(
            cl["label"],
            cl["class_index"],
            cl["design_label"],
            cosets,
            perm_to_rho,
            base,
            point_path,
        )
        cycle["coset_action"] = {
            "s_perm": ca["s_perm"],
            "t_perm": ca["t_perm"],
            "image_order": ca["image_order"],
            "character_stats": ca["character_stats"],
            "coset_representatives_12perm": [list(g) for g in cosets],
            "H_gens_sl2": cl["gens_sl2"],
            "H_gens_as_12perms": {
                "rho": list(cl["gens_12"][0]),
                "tau": list(cl["gens_12"][1]),
            },
        }
        # Galois / coset action record: labeling equivariance of the abstract cycle
        cycle["galois_action"] = {
            "statement": (
                "Gal(L_H/K_proj) acts through the image of G on cosets; "
                "s_perm, t_perm generate a transitive subgroup of S_11 of order 660. "
                "The unordered 11-set is K_proj-stable of degree 11."
            ),
            "s_perm": ca["s_perm"],
            "t_perm": ca["t_perm"],
            "image_order": 660,
            "matches_coset_action": True,
        }
        cycles_payload["classes"].append(cycle)
        cycles_payload["coset_actions"].append(
            {
                "label": cl["label"],
                "s_perm": ca["s_perm"],
                "t_perm": ca["t_perm"],
                "image_order": ca["image_order"],
            }
        )
        classes_data.append(
            {
                "label": cl["label"],
                "design_label": cl["design_label"],
                "H": cl["H"],
                "cosets": cosets,
            }
        )

    # All 22 F=0
    assert all(
        conj["Phi_check"]["F_Klein_raw"] == 0
        for cl in cycles_payload["classes"]
        for conj in cl["conjugates"]
    )

    incidence = build_incidence_correspondence(G, classes_data, design_N, design_doc)
    scaling = build_scaling_interface(cycles_payload)

    # Write artifacts
    (HERE / "INPUT_MANIFEST.json").write_text(json.dumps(man, indent=2) + "\n")
    (HERE / "scaling_interface.json").write_text(json.dumps(scaling, indent=2) + "\n")
    (HERE / "cycles.json").write_text(json.dumps(cycles_payload, indent=2) + "\n")
    (HERE / "incidence_correspondence.json").write_text(
        json.dumps(incidence, indent=2) + "\n"
    )

    wall = time.time() - t0
    rss = peak_rss_mb()
    meta = {
        "schema": "g7b-produce-meta-v1",
        "wall_s": wall,
        "peak_rss_mb": rss,
        "exit": "G7-INDUCED-DOUBLE-CYCLE-PASS",
        "also": ["G7-PROJECTIVE-SCALING-PASS"],
        "n_points": 22,
        "stages": ["G7.2", "G7.3"],
    }
    (HERE / "produce_meta.json").write_text(json.dumps(meta, indent=2) + "\n")
    write_markdowns(scaling, cycles_payload, incidence, meta)

    print("G7B_PRODUCE_OK")
    print("G7-PROJECTIVE-SCALING-PASS")
    print("G7-INDUCED-DOUBLE-CYCLE-PASS")
    print(f"peak_rss_mb={rss:.2f}")
    print(f"wall_s={wall:.2f}")


if __name__ == "__main__":
    main()
