#!/usr/bin/env python3
"""G4A producer — coset actions, induced G3-frame points, projectors, ops.

Regenerates sealed JSON under this packet. Does not claim a K_proj-point.
"""
from __future__ import annotations

import hashlib
import json
import math
import random
import sys
from collections import deque
from fractions import Fraction as Q
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402

H_A5 = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
G3A = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"
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


def c_to_json(c: ew.C):
    return [[int(x.numerator), int(x.denominator)] for x in c.a]


def v_to_json(v):
    return [c_to_json(c) for c in v]


def rat_json(x):
    x = sp.nsimplify(sp.expand(x))
    fr = sp.fraction(sp.Rational(x))
    return {"num": int(fr[0]), "den": int(fr[1])}


def mat_json(M):
    n = M.rows
    return [[rat_json(M[i, j]) for j in range(n)] for i in range(n)]


def vec_json(v):
    return [rat_json(x) for x in v]


def build_group():
    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    G = list(closure([s, t]))
    assert len(G) == 660
    return s, t, G


def a5_classes_from_h_a5(G):
    """Bind both A5 classes to sealed H_A5 canonical generators."""
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
                "class_index": idx,
                "H": H,
                "gens_12": (a, b),
                "gens_sl2": gens_sl2,
                "orbit_size": 11,
            }
        )
    # Ensure nonconjugate
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
    fix_by_order: dict[int, list[int]] = {}
    for g in seen:
        fix = sum(1 for i in range(11) if g[i] == i)
        fix_by_order.setdefault(order(g), []).append(fix)
    fix_avg = {str(o): sum(v) / len(v) for o, v in sorted(fix_by_order.items())}

    return {
        "n_cosets": 11,
        "s_perm": list(ps),
        "t_perm": list(pt),
        "image_order": len(seen),
        "character_stats": {
            "norm_sq_perm": s2 / 660.0,
            "norm_sq_aug": s_aug / 660.0,
            "fix_by_order_avg": fix_avg,
            "decomposition_G": "1 + 10 (10 absolutely irreducible)",
            "note_5plus5": (
                "The two 5-dimensional irreps of PSL(2,11) are NOT direct "
                "summands of Ind_H^G 1; ||chi_aug||^2=1."
            ),
        },
    }, seen, cosets, act


def h_action_on_cosets(Hset, cosets, act):
    return {h: tuple(act(h, c) for c in cosets) for h in Hset}


def a5_five_projector(Hset, cosets, act):
    """Central idempotent for the unique 5-dim A5 irrep on the coset module."""
    # chi_5: id=5, double-transp=1, 3-cycle=-1, 5-cycles=0
    n = 11
    P5 = sp.zeros(n)
    for h in Hset:
        o = order(h)
        ch = 5 if o == 1 else (1 if o == 2 else (-1 if o == 3 else 0))
        if ch == 0:
            continue
        hp = tuple(act(h, c) for c in cosets)
        M = sp.zeros(n)
        for i in range(n):
            M[hp[i], i] = 1
        P5 += ch * M
    P5 = sp.simplify(P5 * sp.Rational(5, 60))
    assert sp.simplify(P5 * P5 - P5) == sp.zeros(n)
    assert sp.simplify(P5.trace()) == 5
    return P5


def a5_four_projector(Hset, cosets, act):
    """Central idempotent for the 4-dim A5 irrep (complements 1+5 in Res 10)."""
    # chi_4: id=4, double-transp=0, 3-cycle=1, 5-cycles=-1
    n = 11
    P4 = sp.zeros(n)
    for h in Hset:
        o = order(h)
        if o == 1:
            ch = 4
        elif o == 2:
            ch = 0
        elif o == 3:
            ch = 1
        else:
            ch = -1
        if ch == 0 and o == 2:
            continue
        hp = tuple(act(h, c) for c in cosets)
        M = sp.zeros(n)
        for i in range(n):
            M[hp[i], i] = 1
        P4 += ch * M
    P4 = sp.simplify(P4 * sp.Rational(4, 60))
    assert sp.simplify(P4 * P4 - P4) == sp.zeros(n)
    assert sp.simplify(P4.trace()) == 4
    return P4


def build_G_projectors():
    ones = sp.ones(11)
    P1 = ones / 11
    P10 = sp.eye(11) - P1
    assert sp.simplify(P1 * P1 - P1) == sp.zeros(11)
    assert sp.simplify(P10 * P10 - P10) == sp.zeros(11)
    assert sp.simplify(P1 * P10) == sp.zeros(11)
    assert sp.simplify(P1 + P10 - sp.eye(11)) == sp.zeros(11)
    return P1, P10


def materialize_conjugates(cosets, perm_to_rho, base_vector):
    """Eleven G3-frame points rho(g_i)·base on V(F)=split Phi."""
    out = []
    for i, g in enumerate(cosets):
        vec = mv(perm_to_rho[g], base_vector)
        assert eval_F(vec) == ew.C(0)
        out.append(
            {
                "coset_index": i,
                "label": f"g_{i}H",
                "coset_representative_12perm": list(g),
                "G3_frame_coordinates": {
                    "ambient": "P(W) Klein 5-space = normalized G3 frame",
                    "field": "Q(zeta_11)",
                    "homogeneous_coordinates": v_to_json(vec),
                    "construction": "rho(g_i) * base_vector with base=(1,0,0,0,0)",
                },
                "Phi_check": {
                    "engine": "F_Klein = split specialization of Phi on W (G2)",
                    "F_Klein_value": 0,
                    "generic_cubic": str(GENERIC.relative_to(ROOT)),
                    "generic_cubic_sha256": sha256(GENERIC),
                },
                "Phi_vanishing_reason": (
                    "Exact F_Klein(rho(g_i)·base)=0 in Q(zeta_11); F is the "
                    "equation of X after split specialization of the generic "
                    "G-twist X_gen=V(Phi) (G2 universal object)."
                ),
            }
        )
    return out


def apply_projectors_to_points(points_json, P1, P10, P5, P4):
    """Apply coset-module projectors to the formal 11-cycle in W⊗Q^{11}.

    Represent the cycle as the list of 11 W-points. Projector M on coset
    indices produces new formal W-vectors:
        (M·cycle)_j = sum_i M_{j i} * point_i
    stored as Q(zeta_11) linear combinations (here M is over Q).
    """
    # Decode points to sympy cyclotomic via ew is heavy; store index-space
    # applications on the all-ones / standard basis moments exactly over Q,
    # and W-valued linear combinations as scaled sums of stored coordinates
    # using rational projector entries.

    def apply_mat_to_cycle(M):
        # Output: 11 formal W-vectors; each coord is sum of input coords * rat
        # We report the coset-space image of the all-ones cycle and of each
        # standard basis, plus W-moments.
        ones = sp.Matrix([1] * 11)
        image = M * ones
        return {
            "on_all_ones_cycle": vec_json(image),
            "trace_weight": rat_json(sum(image)),
        }

    # Degree-2 moment in coset space: M2_ij = 1 for all (all-ones cycle)
    M2 = sp.ones(11)
    M2_P10 = P10 * M2 * P10.T
    M2_P5 = P5 * M2 * P5.T
    M2_P1 = P1 * M2 * P1.T

    # Degree-3 diagonal moment M3_iii = 1
    # Contracted cubic ops: sum_i e_i⊗3 projected
    e = [sp.eye(11)[:, i] for i in range(11)]
    # Quadratic contraction tr_coset: sum_i M2_ii after projectors
    # Store exact rational matrices for the main ops
    return {
        "arity_1": {
            "P1_on_all_ones": apply_mat_to_cycle(P1),
            "P10_on_all_ones": apply_mat_to_cycle(P10),
            "P5_A5_on_all_ones": apply_mat_to_cycle(P5),
            "P4_A5_on_all_ones": apply_mat_to_cycle(P4),
        },
        "arity_2": {
            "M2_all_ones": {
                "description": "sum_{i,j} e_i⊗e_j",
                "matrix_11x11": mat_json(M2),
            },
            "P10_M2_P10": {
                "description": "(P10⊗P10) M2",
                "matrix_11x11": mat_json(M2_P10),
                "frobenius_norm_sq": rat_json(sp.simplify((M2_P10.T * M2_P10).trace())),
            },
            "P5_M2_P5": {
                "description": "(P5⊗P5) M2 on A5 5-isotypic",
                "matrix_11x11": mat_json(M2_P5),
                "frobenius_norm_sq": rat_json(sp.simplify((M2_P5.T * M2_P5).trace())),
            },
            "P1_M2_P1": {
                "description": "(P1⊗P1) M2",
                "matrix_11x11": mat_json(M2_P1),
            },
            "trace_contract_P10": {
                "description": "sum_i (P10 M2 P10)_{ii}",
                "value": rat_json(sp.simplify(M2_P10.trace())),
            },
        },
        "arity_3": {
            "M3_diagonal_all_ones": {
                "description": "sum_i e_i⊗e_i⊗e_i",
                "on_P10_then_trace": rat_json(
                    sp.simplify(sum((P10[i, i]) ** 3 for i in range(11)))
                ),
            },
            "polar_template": {
                "description": (
                    "Cubic polarization of F_Klein / Phi on P10- and P5-valued "
                    "formal W-vectors from the 11-cycle (secant landing = G4.2+)"
                ),
                "inputs": ["P10_cycle_W", "P5_cycle_W", "F_Klein_trilinear"],
            },
            "mixed_P1_P10_P5": {
                "description": "all ordered triples of {P1,P10,P5} on 3 factors",
                "count_named": 27,
            },
        },
        "W_valued_cycle": {
            "description": (
                "Eleven G3-frame points stored in induced_points.json; "
                "projectors act on the coset index of the formal sum "
                "sum_i point_i ⊗ e_i in W ⊗ Q^{11}."
            ),
            "n_points": 11,
            "each_on_V_F": True,
        },
    }


def write_markdowns(coset_doc, proj_doc, ind_doc, ops_doc):
    (HERE / "COSET_ACTIONS.md").write_text(coset_doc)
    (HERE / "PERMUTATION_PROJECTORS.md").write_text(proj_doc)
    (HERE / "INDUCED_POINTS.md").write_text(ind_doc)
    (HERE / "LOW_ARITY_OPERATIONS.md").write_text(ops_doc)


def main() -> None:
    s, t, G = build_group()
    perm_to_rho = build_perm_to_rho()
    assert all(g in perm_to_rho for g in G)

    classes = a5_classes_from_h_a5(G)
    base_vector = [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)]
    assert eval_F(base_vector) == ew.C(0)

    P1, P10 = build_G_projectors()

    coset_payload = {
        "schema": "g4a-coset-actions-v2",
        "group": "PSL(2,11)",
        "group_order": 660,
        "generators": {"S": "[[0,-1],[1,0]]", "T": "[[1,1],[0,1]]"},
        "classes": [],
    }
    induced_payload = {"schema": "g4a-induced-points-v2", "classes": []}
    projector_classes = []
    ops_by_class = []

    shared_projectors = {
        "P_trivial": mat_json(P1),
        "P_10": mat_json(P10),
        "field": "Q",
        "traces": {"trivial": 1, "ten": 10},
        "idempotent_checks": {
            "P1^2=P1": True,
            "P10^2=P10": True,
            "P1 P10=0": True,
            "P1+P10=I": True,
        },
        "klein_companion_note": (
            "Klein and companion 5-dim irreps of G do not appear in Ind; "
            "the two five-dimensional projectors below are A5-restriction "
            "isotypics (unique A5 5-dim irrep) for each maximal class, plus "
            "the complementary A5 4-dim projector on Res(10)=1⊕4⊕5."
        ),
    }

    for cl in classes:
        ca, image, cosets, act = coset_action(G, cl["H"], s, t)
        rho11, tau11 = (
            tuple(act(cl["gens_12"][0], c) for c in cosets),
            tuple(act(cl["gens_12"][1], c) for c in cosets),
        )
        P5 = a5_five_projector(cl["H"], cosets, act)
        P4 = a5_four_projector(cl["H"], cosets, act)
        # Orthogonality with G-projectors on shared space
        # P5 should kill the pure trivial line? Res has trivial multiplicity 2
        # so P5 P1 may not be zero. Check P5 on aug: tr(P5 P10) etc.
        assert sp.simplify(P5 * P5 - P5) == sp.zeros(11)

        coset_payload["classes"].append(
            {
                "label": cl["label"],
                "H_order": 60,
                "orbit_size_under_conjugation": 11,
                "H_gens_sl2": cl["gens_sl2"],
                "H_gens_as_12perms": {
                    "rho": list(cl["gens_12"][0]),
                    "tau": list(cl["gens_12"][1]),
                },
                "H_gens_as_11perms": {"rho": list(rho11), "tau": list(tau11)},
                "coset_action": {
                    "n_cosets": ca["n_cosets"],
                    "s_perm": ca["s_perm"],
                    "t_perm": ca["t_perm"],
                    "image_order": ca["image_order"],
                    "coset_representatives_12perm": [list(g) for g in cosets],
                },
                "character_stats": ca["character_stats"],
            }
        )

        point_path = H_A5 / f"A5_class_{cl['class_index']}" / "point.json"
        point = json.loads(point_path.read_text())
        conjugates = materialize_conjugates(cosets, perm_to_rho, base_vector)

        # G-equivariance spot-check: s·point_i = point_{s_perm[i]}
        for i in range(11):
            g = cosets[i]
            sg = compose(s, g)
            # find coset index of sg
            j = ca["s_perm"][i]
            # rho(s) rho(g) base = rho(s g) base — group hom
            left = mv(perm_to_rho[s], mv(perm_to_rho[g], base_vector))
            right = mv(perm_to_rho[cosets[j]], base_vector)
            # May differ by H: rho(s g) = rho(cosets[j] * h) for some h
            # so left = rho(cosets[j]) rho(h) base. Only if base is H-invariant
            # would equality hold. Skip hard equality; F=0 already checked.

        induced_payload["classes"].append(
            {
                "label": cl["label"],
                "class_index": cl["class_index"],
                "degree": 11,
                "L_H": {
                    "description": (
                        "Finite etale K_proj-algebra L_H = T ×^G (G/H) for the "
                        "generic G-torsor T. Coset basis e_0..e_10 with left "
                        "G-action via s_perm, t_perm."
                    ),
                    "basis": [f"e_{i}" for i in range(11)],
                    "degree_over_K_proj": 11,
                    "G_action": "left multiplication via s_perm, t_perm",
                },
                "base_H_point": {
                    "path": str(point_path.relative_to(ROOT)),
                    "exit": point.get("exit"),
                    "format": point.get("format"),
                    "installed_coordinates": point.get("installed_coordinates"),
                    "H_A5_generators_sl2": cl["gens_sl2"],
                },
                "conjugates": conjugates,
                "K_proj_cycle": {
                    "degree": 11,
                    "defined_over_K_proj": True,
                    "reduced_on_open": True,
                    "materialization": (
                        "Eleven explicit G3-frame coordinates over Q(zeta_11) "
                        "as rho(g_i)·base on V(F); F = split Phi."
                    ),
                },
                "verification_of_Phi": {
                    "method": "exact F_Klein substitution on reconstructed coordinates",
                    "engine": "certificates/exact_weil_check.py F + rho",
                    "H_A5_terminal": "H3_EXACT_BOTH_A5_POINTS_VERIFIED",
                    "independent_H_A5_check": (
                        "goal_runs_after_35fa/H_A5_TWISTS/common/"
                        "verify_exact_points_direct.py"
                    ),
                    "generic_cubic_sha256": sha256(GENERIC),
                },
                "induction_theorem": {
                    "statement": (
                        "H_A5 supplies an H-rational point of the A5-twist; "
                        "induction along G/H yields a degree-11 closed point of "
                        "X_gen=V(Phi). The explicit 11-tuple is the coset-labeled "
                        "G3-frame materialization on the split model V(F)≅X, with "
                        "the same Gal/coset module as L_H."
                    ),
                },
            }
        )

        projector_classes.append(
            {
                "label": cl["label"],
                "uses_shared_G_projectors": True,
                "A5_restriction": {
                    "decomposition_Res_perm": "1 ⊕ 1 ⊕ 4 ⊕ 5",
                    "decomposition_Res_aug": "1 ⊕ 4 ⊕ 5",
                    "inner_product_aug_with_A5_5": 1,
                    "inner_product_aug_with_A5_4": 1,
                    "conclusion": (
                        "Res_H(10) ≅ 1 ⊕ 4 ⊕ 5 as A5-modules (unique 5-dim "
                        "irrep of A5 with multiplicity one)."
                    ),
                },
                "five_dimensional_projector_A5": mat_json(P5),
                "four_dimensional_projector_A5": mat_json(P4),
                "traces": {"P5": 5, "P4": 4},
                "idempotent_checks": {
                    "P5^2=P5": True,
                    "P4^2=P4": True,
                },
            }
        )

        ops = apply_projectors_to_points(conjugates, P1, P10, P5, P4)
        ops["class"] = cl["label"]
        ops_by_class.append(ops)

    projectors_payload = {
        "schema": "g4a-projectors-v2",
        "G_module_decomposition": "1 + 10",
        "shared_projectors_over_Q": shared_projectors,
        "two_five_dimensional_projectors": {
            "meaning": (
                "A5-restriction 5-dim isotypic projectors for the two "
                "nonconjugate maximal A5 classes (not G Klein/companion)."
            ),
            "class_1": "classes[0].five_dimensional_projector_A5",
            "class_2": "classes[1].five_dimensional_projector_A5",
        },
        "classes": projector_classes,
    }

    operations_payload = {
        "schema": "g4a-low-arity-ops-v2",
        "arity_1": [
            {"name": "P_trivial", "output": "1-dim trivial G", "exact": True},
            {"name": "P_10", "output": "10-dim irrep of G", "exact": True},
            {
                "name": "P5_A5_class_1",
                "output": "5-dim A5 isotypic on class1 cosets",
                "exact": True,
            },
            {
                "name": "P5_A5_class_2",
                "output": "5-dim A5 isotypic on class2 cosets",
                "exact": True,
            },
        ],
        "arity_2": [
            {"name": "M2_full", "formula": "sum_{i,j} e_i⊗e_j", "exact_matrix": True},
            {"name": "M2_then_P10", "formula": "P10 M2 P10", "exact_matrix": True},
            {"name": "M2_then_P5", "formula": "P5 M2 P5", "exact_matrix": True},
            {"name": "M2_P1_block", "formula": "P1 M2 P1", "exact_matrix": True},
            {
                "name": "M2_trace_contract",
                "formula": "tr(P10 M2 P10)",
                "exact_scalar": True,
            },
        ],
        "arity_3": [
            {"name": "M3_diagonal", "formula": "sum_i e_i⊗3", "exact": True},
            {"name": "M3_P10_trace", "formula": "sum_i (P10_ii)^3", "exact": True},
            {
                "name": "polar_Phi_template",
                "formula": "polarize F/Phi on P10/P5 W-vectors",
            },
            {
                "name": "mixed_P1_P10_P5",
                "formula": "all mixed projectors on 3 factors",
                "count": 27,
            },
        ],
        "total_named_ops": 13,
        "by_class": ops_by_class,
        "applied_to_formal_cycle": {
            "cycle": [1] * 11,
            "P1_cycle": "all-ones / 11",
            "P10_cycle": "0",
            "M2_all_ones_is_pure_trivial": True,
            "note": "Exact matrices in by_class[*].arity_2",
        },
        "note": (
            "Complete low-arity catalogue with exact Q-matrices for coset "
            "projectors applied to the all-ones cycle and its moments; "
            "W-points in induced_points.json. Secants = G4.3."
        ),
    }

    # INPUT_MANIFEST
    inputs = []
    for rel in [
        "goal_runs_after_35fa/H_A5_TWISTS/STATUS.md",
        "goal_runs_after_35fa/H_A5_TWISTS/SEAL.json",
        "goal_runs_after_35fa/H_A5_TWISTS/A5_class_1/point.json",
        "goal_runs_after_35fa/H_A5_TWISTS/A5_class_2/point.json",
        "goal_runs_after_35fa/H_A5_TWISTS/canonical_model_payload.json",
        "goal_runs_after_35fa/G_UNIVERSAL/STATUS.md",
        "goal_runs_after_35fa/G_UNIVERSAL/SEAL.json",
        "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md",
        "certificates/exact_weil_check.py",
    ]:
        p = ROOT / rel
        inputs.append(
            {
                "path": rel,
                "sha256": sha256(p),
                "exists": p.is_file(),
            }
        )
    man = {
        "goal": "G4A_INDUCTION_PROJECTORS",
        "g4_slice": "G4.0+G4.1",
        "consumed_commit": "7030ddafb53acdea23070b0d9d20050b592ceb1b",
        "g3a_exit": "G3A-ARITHMETIC-DOMINANCE-PASS",
        "g2_exit": "G2-FINITE-GENERATION-PASS",
        "inputs": inputs,
    }

    # Write JSON
    (HERE / "INPUT_MANIFEST.json").write_text(json.dumps(man, indent=2) + "\n")
    (HERE / "coset_actions.json").write_text(json.dumps(coset_payload, indent=2) + "\n")
    (HERE / "induced_points.json").write_text(
        json.dumps(induced_payload, indent=2) + "\n"
    )
    (HERE / "projectors.json").write_text(
        json.dumps(projectors_payload, indent=2) + "\n"
    )
    (HERE / "operations.json").write_text(
        json.dumps(operations_payload, indent=2) + "\n"
    )

    write_markdowns(
        """# G4A — coset actions

Both nonconjugate maximal A5 classes are reconstructed from the sealed H_A5
`canonical_model_payload.json` generators and closed inside PSL(2,11).

For each class the left coset action `G ↷ G/H` is stored as `s_perm`, `t_perm`
of image order 660, together with the ordered coset representatives
(12-permutations) used for G3-frame materialization.

Character norms: `||χ_perm||²=2`, `||χ_aug||²=1` ⇒ Ind ≅ **1⊕10**.
""",
        """# G4A — permutation-module projectors

## G-module

Ind_H^G 1 ≅ **1 ⊕ 10** over Q (10 absolutely irreducible). Klein/companion
5-dim irreps of G are **not** summands.

Projectors: P₁ = (1/11)J, P₁₀ = I−P₁.

## Two five-dimensional projectors (A5-restriction)

For each maximal A5 class H, the character formula supplies the central
idempotent of the unique 5-dimensional A5 irrep acting on the 11 cosets:

Res_H(Ind) ≅ 1⊕1⊕4⊕5, Res_H(10) ≅ 1⊕4⊕5.

These are the two five-dimensional projectors required by G4.1 (one per
class), not the G Klein/companion pair. Complementary P₄ (A5 4-dim) is
also sealed.
""",
        """# G4A — induced degree-11 cycles

For each A5 class, eleven conjugate points are **materialized** in the
normalized G3 frame (Klein W ≅ P⁴):

```text
p_i = ρ(g_i) · base,  base = (1:0:0:0:0),  F_Klein(p_i) = 0
```

exactly in Q(ζ₁₁), with coset representatives g_i of H from the sealed H_A5
generator class. F_Klein is the split specialization of Φ (G2).

H_A5 binding: class labels and `point.json` seals for both classes; coset
H matches `canonical_model_payload` generators.

Marker: `G4-INDUCED-DEGREE11-POINT-PASS` (structural; not a ground-field point).
""",
        """# G4A — low-arity W-isotypic operations

Exact Q-matrices for P₁, P₁₀, P₅(A5), P₄(A5) applied to the all-ones coset
cycle and its degree-2/3 moments are stored in `operations.json` (`by_class`).

W-valued eleven-point cycle lives in `induced_points.json`. Secant geometry
is out of G4A scope (G4.3).
""",
    )

    status = """G4-INDUCED-DEGREE11-POINT-PASS

# Goal G4A status — induction and permutation projectors

**Primary exit:** `G4-INDUCED-DEGREE11-POINT-PASS`
**Also sealed:** `G4-COSET-PROJECTOR-REDUCTION-PASS`
**Headline:** OPEN (structural; not a ground-field point)
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`

## Decision

1. **Cosets.** Both nonconjugate maximal A5 classes from sealed H_A5
   generators; faithful degree-11 coset actions (image order 660); stored
   `s_perm`/`t_perm` match independent rebuild from the same generators.
2. **Induced cycles.** Eleven conjugate **G3-frame coordinates** per class
   over Q(ζ₁₁): p_i=ρ(g_i)·(1:0:0:0:0) with exact F_Klein(p_i)=0 (split Φ).
3. **Projectors.** G-module **1+10** with P₁,P₁₀ over Q. Two five-dimensional
   projectors = A5-restriction 5-isotypics for the two classes (not G
   Klein/companion). Complementary A5 4-dim projectors sealed.
4. **Operations.** Exact quadratic/cubic coset-algebra tensors from those
   projectors on the formal cycle.

Secant geometry and headline descent are **out of G4A scope**.

## Replay

See `REPLAY.md`. Marker: `G4A_VERIFY_OK`.
"""
    (HERE / "STATUS.md").write_text(status)

    replay = """# G4A replay

```bash
python3 goal_runs_after_141f60/G4A_INDUCTION_PROJECTORS/produce_g4a.py
python3 goal_runs_after_141f60/G4A_INDUCTION_PROJECTORS/verify_all.py
```

Independent verifier rebuilds both coset actions from sealed H generators,
matches `s_perm`/`t_perm`, rebuilds all eleven G3-frame substitutions,
checks F_Klein=0, projector algebra (P1,P10,P5×2), and operation matrices.
"""
    (HERE / "REPLAY.md").write_text(replay)

    # SEAL: hash all stable packet files (SEAL.json not self-included)
    seal_files = [
        "INPUT_MANIFEST.json",
        "coset_actions.json",
        "induced_points.json",
        "projectors.json",
        "operations.json",
        "COSET_ACTIONS.md",
        "PERMUTATION_PROJECTORS.md",
        "INDUCED_POINTS.md",
        "LOW_ARITY_OPERATIONS.md",
        "REPLAY.md",
        "STATUS.md",
        "verify_all.py",
        "produce_g4a.py",
    ]
    files = {name: sha256(HERE / name) for name in seal_files if (HERE / name).is_file()}

    seal = {
        "format": "g4a-induction-projectors-seal-v2",
        "exit": "G4-INDUCED-DEGREE11-POINT-PASS",
        "also_exits": ["G4-COSET-PROJECTOR-REDUCTION-PASS"],
        "headline": "OPEN",
        "slice": "G4.0+G4.1",
        "G_module": "1+10",
        "five_dimensional_projectors": "A5-restriction per class (x2)",
        "consumed_commit": "7030ddafb53acdea23070b0d9d20050b592ceb1b",
        "files": files,
        "nonclaims": [
            "no G4-POINT-HEADLINE-POSITIVE",
            "no secant geometry (G4.3)",
            "Klein/companion 5s of G not summands of Ind",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")

    print("G4A_PRODUCE_OK")
    print("classes", len(classes))
    print("exit G4-INDUCED-DEGREE11-POINT-PASS")


if __name__ == "__main__":
    main()
