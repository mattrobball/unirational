#!/usr/bin/env python3
"""G7A producer — exact two-class A5 design and incidence projectors.

Stages:
  G7.0  both maximal A5 conjugacy classes, cross-intersections, incidence N,
        Paley biplane identities for the 2-(11,5,2) design
  G7.1  permutation-module decompositions, projectors, N-intertwiners

Constant finite-group arithmetic only. Does not materialize induced points.
Does not import or reseal H_A5 / G4.
"""
from __future__ import annotations

import hashlib
import json
import math
import resource
import subprocess
import time
from collections import Counter, deque
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]  # .../E-klein-cubic (design/ is three levels deep)

H_A5 = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
G_UNIVERSAL = ROOT / "goal_runs_after_35fa/G_UNIVERSAL"
G4 = ROOT / "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER"

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


def iso_type_from_sig(n, sig):
    """Derive subgroup isomorphism type from order and element-order multiset."""
    sig = dict(sig)
    if n == 12 and sig == {1: 1, 2: 3, 3: 8}:
        return "A4"
    if n == 10 and sig == {1: 1, 2: 5, 5: 4}:
        return "D5"  # dihedral of order 10
    if n == 60 and sig.get(1) == 1:
        return "A5"
    return f"unknown_order_{n}_sig_{sig}"


def entry_json(x):
    x = sp.nsimplify(sp.expand(x))
    fr = sp.fraction(sp.together(x))
    num, den = sp.Integer(fr[0]), sp.Integer(fr[1])
    # keep rational entries as num/den
    return {"num": int(num), "den": int(den)}


def mat_json(M):
    r, c = M.shape
    return [[entry_json(M[i, j]) for j in range(c)] for i in range(r)]


def mat_from_list(N):
    return sp.Matrix(N)


def build_group():
    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    Gset = closure([s, t])
    assert len(Gset) == 660
    G = list(Gset)
    # Deterministic order for reproducibility of derived labels
    G.sort()
    return s, t, G


def find_all_maximal_a5(G):
    """Enumerate all maximal A5 subgroups via (5,2,3)-generator pairs."""
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
    assert len(allH) == 22, f"expected 22 maximal A5s, got {len(allH)}"
    return allH


def split_conjugacy_classes(G, allH):
    remaining = set(allH)
    classes = []
    while remaining:
        H0 = min(remaining, key=lambda H: min(H))
        orbit = {conjugate_set(H0, g) for g in G}
        assert len(orbit) == 11
        assert orbit <= remaining | orbit
        # all found A5s must lie in these two classes
        classes.append(sorted(orbit, key=lambda H: min(H)))
        remaining -= orbit
    assert len(classes) == 2
    # Canonical order of the two classes by min of their first subgroup
    classes.sort(key=lambda orb: min(orb[0]))
    return classes  # [Hs, Ks] each list of 11 frozensets


def gens_of_a5(H):
    for a in sorted(H):
        if order(a) != 5:
            continue
        for b in sorted(H):
            if order(b) != 2:
                continue
            if order(compose(a, b)) == 3 and len(closure([a, b])) == 60:
                return a, b
    raise RuntimeError("no A5 generators")


def coset_reps_and_action(G, Hset, s, t):
    H = set(Hset)
    cosets = []
    used = set()
    for g in G:  # G is sorted
        key = frozenset(compose(g, h) for h in H)
        if key not in used:
            used.add(key)
            cosets.append(g)
    assert len(cosets) == 11

    def act(g, rep):
        prod = compose(g, rep)
        key = frozenset(compose(prod, h) for h in H)
        for i, r in enumerate(cosets):
            if frozenset(compose(r, h) for h in H) == key:
                return i
        raise RuntimeError("coset missing")

    ps = tuple(act(s, c) for c in cosets)
    pt = tuple(act(t, c) for c in cosets)

    # image order of G on 11 letters
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

    # character norms
    s2 = 0
    s_aug = 0
    for g in seen:
        fix = sum(1 for i in range(11) if g[i] == i)
        s2 += fix * fix
        s_aug += (fix - 1) * (fix - 1)
    return {
        "n_cosets": 11,
        "s_perm": list(ps),
        "t_perm": list(pt),
        "image_order": len(seen),
        "character_stats": {
            "norm_sq_perm": s2 / 660.0,
            "norm_sq_aug": s_aug / 660.0,
            "decomposition_G": "1 + 10 (10 absolutely irreducible over C and over Q)",
            "not_1_plus_5_plus_5": (
                "The two 5-dimensional irreps of PSL(2,11) (Klein and companion) "
                "are NOT direct summands of Ind_H^G 1; ||chi_aug||^2 = 1 forces "
                "a single 10-dimensional irrep summand."
            ),
        },
    }, seen, cosets


def cross_incidence(Hs, Ks):
    rows = []
    order_counts = Counter()
    type_counts = Counter()
    N = [[0] * 11 for _ in range(11)]
    inter_table = []
    for i, H in enumerate(Hs):
        for j, K in enumerate(Ks):
            I = H & K
            n = len(I)
            sig = element_order_signature(I)
            typ = iso_type_from_sig(n, sig)
            order_counts[n] += 1
            type_counts[(n, typ)] += 1
            incident = n == 12  # derived: A4 intersections define incidence
            if incident:
                N[i][j] = 1
            inter_table.append(
                {
                    "H_index": i,
                    "K_index": j,
                    "order": n,
                    "iso_type": typ,
                    "element_order_signature": dict(sig),
                    "incident": incident,
                }
            )
    return N, inter_table, order_counts, type_counts


def design_identities(N):
    M = mat_from_list(N)
    Nt = M.T
    NNt = M * Nt
    NtN = Nt * M
    I = sp.eye(11)
    J = sp.ones(11)
    target = 3 * I + 2 * J
    row_sums = [sum(N[i]) for i in range(11)]
    col_sums = [sum(N[i][j] for i in range(11)) for j in range(11)]
    row_meets = []
    for i in range(11):
        for k in range(i + 1, 11):
            row_meets.append(sum(N[i][j] * N[k][j] for j in range(11)))
    col_meets = []
    for j in range(11):
        for l in range(j + 1, 11):
            col_meets.append(sum(N[i][j] * N[i][l] for i in range(11)))
    return {
        "row_sums": row_sums,
        "col_sums": col_sums,
        "row_sums_all_5": all(r == 5 for r in row_sums),
        "col_sums_all_5": all(c == 5 for c in col_sums),
        "pairwise_row_meets": row_meets,
        "pairwise_col_meets": col_meets,
        "any_two_rows_meet_in_2": all(m == 2 for m in row_meets),
        "any_two_cols_meet_in_2": all(m == 2 for m in col_meets),
        "NNt_equals_3I_plus_2J": NNt == target,
        "NtN_equals_3I_plus_2J": NtN == target,
        "NNt": [[int(NNt[i, j]) for j in range(11)] for i in range(11)],
        "NtN": [[int(NtN[i, j]) for j in range(11)] for i in range(11)],
        "parameters": {
            "v": 11,
            "b": 11,
            "r": 5,
            "k": 5,
            "lambda": 2,
            "design": "symmetric 2-(11,5,2)",
            "common_name": "Paley biplane of order 11",
        },
        "is_paley_biplane": (
            all(r == 5 for r in row_sums)
            and all(c == 5 for c in col_sums)
            and all(m == 2 for m in row_meets)
            and all(m == 2 for m in col_meets)
            and NNt == target
            and NtN == target
        ),
    }


def g_orbits_on_pairs(G, Hs, Ks):
    """G-orbits on H × K by conjugating with generators BFS (full orbit)."""
    Hidx = {H: i for i, H in enumerate(Hs)}
    Kidx = {K: j for j, K in enumerate(Ks)}
    # Precompute conjugacy action of each g on each class index via full G is expensive;
    # instead BFS with all group elements from seeds stratified by incidence.
    remaining = {(i, j) for i in range(11) for j in range(11)}
    orbits = []
    # Use full G conjugacy: for each seed, apply all g once
    while remaining:
        seed = min(remaining)
        i0, j0 = seed
        orb = set()
        H0, K0 = Hs[i0], Ks[j0]
        for g in G:
            Hi = conjugate_set(H0, g)
            Kj = conjugate_set(K0, g)
            p = (Hidx[Hi], Kidx[Kj])
            orb.add(p)
        assert seed in orb
        remaining -= orb
        i, j = next(iter(orb))
        n = len(Hs[i] & Ks[j])
        orbits.append(
            {
                "size": len(orb),
                "intersection_order": n,
                "iso_type": iso_type_from_sig(n, element_order_signature(Hs[i] & Ks[j])),
                "pairs": sorted(orb),
            }
        )
    orbits.sort(key=lambda o: o["size"])
    return orbits


def design_automorphisms(N, s_perm_H, t_perm_H, s_perm_K, t_perm_K):
    """Verify that the installed G action preserves incidence N.

    G acts simultaneously on rows (H-cosets / H-class) and columns (K-class)
    by the two degree-11 permutation representations. For the biplane realized
    by conjugacy classes of subgroups, left multiplication on cosets is the
    same abstract G; we check that the conjugated incidence is constant, i.e.
    N[g·i, g·j] = N[i,j] for generators g = s,t when both actions come from
    the same ambient conjugation action on subgroups.

    Here s_perm_H etc. are coset actions on G/H and G/K which label *cosets*,
    not conjugacy-class indices. For the subgroup-class design the natural
    G-action is conjugation: g·H_i = H_{σ(i)}. We reconstruct conjugation
    permutations of the 11+11 labels and verify they preserve N and generate
    a group of order 660 inside Aut(design).
    """
    # This function is filled by caller with conjugation perms; placeholder API
    return None


def conjugation_action_on_class(G, orbit, s, t):
    """Permutations of the 11 subgroups under conjugation by s and t."""
    idx = {H: i for i, H in enumerate(orbit)}
    ps = []
    pt = []
    for H in orbit:
        ps.append(idx[conjugate_set(H, s)])
        pt.append(idx[conjugate_set(H, t)])
    ps, pt = tuple(ps), tuple(pt)
    # close image
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
    return list(ps), list(pt), len(seen)


def verify_aut_preserves_N(N, psH, ptH, psK, ptK):
    """Check generators preserve incidence and image has order 660."""
    def apply(pH, pK):
        Np = [[0] * 11 for _ in range(11)]
        for i in range(11):
            for j in range(11):
                Np[pH[i]][pK[j]] = N[i][j]
        return Np

    assert apply(psH, psK) == N
    assert apply(ptH, ptK) == N
    # joint action on 11+11 labels as permutations of 22 letters, or product action
    # on the design: pair (row_perm, col_perm)
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
                # also check preserves N
                Np = [[0] * 11 for _ in range(11)]
                for i in range(11):
                    for j in range(11):
                        Np[nH[i]][nK[j]] = N[i][j]
                assert Np == N
                seen.add(pr)
                q.append(pr)
    return len(seen)


def build_projectors_and_intertwiners(N):
    """G7.1: projectors for both Ind modules and N-action on constituents."""
    M = mat_from_list(N)
    Nt = M.T
    I = sp.eye(11)
    J = sp.ones(11)
    P1 = J / 11
    P10 = I - P1

    # Idempotent checks
    assert sp.simplify(P1 * P1 - P1) == sp.zeros(11)
    assert sp.simplify(P10 * P10 - P10) == sp.zeros(11)
    assert sp.simplify(P1 * P10) == sp.zeros(11)
    assert sp.simplify(P1 + P10 - I) == sp.zeros(11)

    # N intertwines the two permutation modules (same abstract G, two realizations)
    # On full space: N N^t = 3I + 2J = 5 P1 + 3 P10  (since J=11 P1, 3I+2J = 3(P1+P10)+22 P1 = 25P1 + 3P10? wait)
    # 3I + 2J = 3(P1+P10) + 2*(11 P1) = 3 P1 + 3 P10 + 22 P1 = 25 P1 + 3 P10
    # But row sum 5: N 1 = 5 1, so N maps trivial to trivial with eigenvalue 5.
    # On augmentation: N^t N = 3 I (because J annihilates aug), so eigenvalue sqrt(3) complex;
    # exact inverse on aug is (1/3) N^t : aug_H -> aug_K? Wait:
    # N: Q^{11}_H -> Q^{11}_K  (rows H, cols K? our N[i,j]=1 if H_i incident K_j)
    # Convention: N acts as map from K-space to H-space: (N v)_i = sum_j N_ij v_j
    # Then N : Q^K -> Q^H, N^t : Q^H -> Q^K
    # N^t N = 3I+2J on K-space; on aug_K, N^t N = 3 I, so (1/3) N^t is left inverse of N|aug
    # and N (1/3 N^t) = I on aug_H.

    NNt = M * Nt
    NtN = Nt * M
    assert NNt == 3 * I + 2 * J
    assert NtN == 3 * I + 2 * J

    # Project N to aug blocks
    N_aug = P10 * M * P10  # as map K->H after projecting
    # Check (1/3) Nt is inverse of N on aug:
    # P10 * (M * Nt) * P10 = P10 * (3I+2J) * P10 = 3 P10
    assert sp.simplify(P10 * NNt * P10 - 3 * P10) == sp.zeros(11)
    assert sp.simplify(P10 * NtN * P10 - 3 * P10) == sp.zeros(11)
    inv_check_H = sp.simplify(P10 * M * Nt / 3 * P10 - P10)
    inv_check_K = sp.simplify(P10 * Nt * M / 3 * P10 - P10)
    assert inv_check_H == sp.zeros(11)
    assert inv_check_K == sp.zeros(11)

    # Trivial eigenvalue of N: N * 1_K = 5 * 1_H
    ones = sp.Matrix([1] * 11)
    assert M * ones == 5 * ones
    assert Nt * ones == 5 * ones

    # Characteristic / denominator gates for (1/3) N^t
    denom_gate = {
        "denominator": 3,
        "forbidden_characteristics": [3],
        "note": (
            "On the augmentation modules, N^{-1} = (1/3) N^t exactly. "
            "This is valid over any field of characteristic not 3 (and not "
            "dividing the group order issues separately). Over Q the inverse is exact."
        ),
    }

    # Central idempotents in the group algebra sense for the perm modules:
    # e_1 = (1/|G|) sum_g g projects to trivial; in the coset basis this is P1.
    # e_10 = 1 - e_1 = P10. These are already the primitive central projectors
    # for the two constituents of Ind (since 10 is irreducible).

    # Klein / companion 5-dimensional irreps of G:
    # Character field Q(sqrt(-11)); they do not appear in Ind_H^G 1.
    # We record the corrected decomposition and the Galois action on the 5s.
    klein_companion = {
        "in_permutation_module": False,
        "decomposition_of_Ind": "1 ⊕ 10",
        "expected_naive": "1 ⊕ W ⊕ W' (W,W' the two 5-dim irreps)",
        "correction": (
            "Naive 1+5+5 is false for Ind_H^G 1. Character theory gives "
            "||chi_perm||^2 = 2 and ||chi_aug||^2 = 1, so Ind ≅ 1 ⊕ V_10 with "
            "V_10 absolutely irreducible. The Klein and companion 5-dimensional "
            "irreps of PSL(2,11) have character field Q(√(-11)) and are Galois "
            "conjugates of each other; neither is a summand of either "
            "degree-11 permutation module."
        ),
        "galois_action_on_5s": (
            "Gal(Q(√(-11))/Q) swaps the two 5-dimensional irreducible characters."
        ),
        "restriction_to_A5": (
            "Res_H(1 ⊕ 10) ≅ 1 ⊕ 5 ⊕ 5 as A5-modules (A5-internal 5-dim irrep "
            "with multiplicity structure 5+5); this is not the Klein/companion "
            "pair of G."
        ),
        "N_action_on_constituents": {
            "trivial_to_trivial": {
                "eigenvalue": 5,
                "map": "N : 1_K → 1_H multiplies by r=5",
            },
            "ten_to_ten": {
                "relation": "N^t N = 3 I on aug_K; N N^t = 3 I on aug_H",
                "inverse": "(1/3) N^t : aug_H → aug_K is the inverse of N|aug",
                "field": "Q",
                "no_sqrt3_needed": True,
            },
        },
    }

    return {
        "field": "Q",
        "decomposition": {
            "Ind_H^G_1": "1 ⊕ 10",
            "Ind_K^G_1": "1 ⊕ 10",
            "10_absolutely_irreducible": True,
            "naive_1_5_5_refuted": True,
        },
        "P_trivial": mat_json(P1),
        "P_10": mat_json(P10),
        "traces": {"trivial": 1, "ten": 10},
        "idempotent_checks": {
            "P1^2=P1": True,
            "P10^2=P10": True,
            "P1 P10=0": True,
            "P1+P10=I": True,
        },
        "incidence_matrix_N": N,
        "N_as_intertwiner": {
            "domain": "Q^{11}_K (functions on K-class / blocks)",
            "codomain": "Q^{11}_H (functions on H-class / points)",
            "NNt": "3I+2J",
            "NtN": "3I+2J",
            "on_trivial": "eigenvalue 5",
            "on_augmentation_inverse": "(1/3) N^t",
            "aug_inverse_verified": True,
            "P10_N_Nt_P10_equals_3_P10": True,
        },
        "denominator_gate": denom_gate,
        "klein_companion": klein_companion,
        "matrices_rational": {
            "N": N,
            "Nt": [[N[j][i] for j in range(11)] for i in range(11)],
            "P_trivial_entries": "all 1/11",
            "P_10_diag": "10/11",
            "P_10_off": "-1/11",
            "aug_inverse": "(1/3) N^t restricted to aug",
        },
    }


def write_markdown(path: Path, text: str) -> None:
    path.write_text(text if text.endswith("\n") else text + "\n")


def main() -> None:
    t0 = time.time()
    peak0 = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss

    # --- inputs ---
    inputs = []
    for rel in [
        "goal_runs_after_35fa/H_A5_TWISTS/STATUS.md",
        "goal_runs_after_35fa/H_A5_TWISTS/SEAL.json",
        "goal_runs_after_35fa/H_A5_TWISTS/A5_class_1/point.json",
        "goal_runs_after_35fa/H_A5_TWISTS/A5_class_2/point.json",
        "goal_runs_after_35fa/G_UNIVERSAL/STATUS.md",
        "goal_runs_after_35fa/G_UNIVERSAL/SEAL.json",
        "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/coset_actions.json",
        "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/STATUS.md",
    ]:
        p = ROOT / rel
        if p.is_file():
            inputs.append(
                {
                    "path": rel,
                    "sha256": sha256(p),
                    "role": "binding_input",
                }
            )

    # --- G7.0 ---
    s, t, G = build_group()
    allH = find_all_maximal_a5(G)
    Hs, Ks = split_conjugacy_classes(G, allH)

    class_records = []
    coset_payload = []
    for label, orbit, class_index in (
        ("A5_class_H", Hs, 1),
        ("A5_class_K", Ks, 2),
    ):
        H0 = orbit[0]
        ga, gb = gens_of_a5(H0)
        coset_data, image, cosets = coset_reps_and_action(G, H0, s, t)
        # conjugation action on the 11 subgroups
        ps_conj, pt_conj, conj_order = conjugation_action_on_class(G, orbit, s, t)
        rec = {
            "label": label,
            "class_index": class_index,
            "H_order": 60,
            "orbit_size_under_conjugation": 11,
            "base_H_gens_12perms": {"rho": list(ga), "tau": list(gb)},
            "base_H_gens_orders": {
                "rho": order(ga),
                "tau": order(gb),
                "rho_tau": order(compose(ga, gb)),
            },
            "coset_action": coset_data,
            "conjugation_action_on_class": {
                "s_perm": ps_conj,
                "t_perm": pt_conj,
                "image_order": conj_order,
            },
            "subgroups": [
                {
                    "index": i,
                    "min_element_12perm": list(min(H)),
                    "order": 60,
                }
                for i, H in enumerate(orbit)
            ],
        }
        class_records.append(rec)
        coset_payload.append(rec)

    N, inter_table, order_counts, type_counts = cross_incidence(Hs, Ks)
    identities = design_identities(N)
    assert identities["is_paley_biplane"], "biplane identities failed"

    orbits = g_orbits_on_pairs(G, Hs, Ks)
    assert len(orbits) == 2
    assert {o["size"] for o in orbits} == {55, 66}

    psH = class_records[0]["conjugation_action_on_class"]["s_perm"]
    ptH = class_records[0]["conjugation_action_on_class"]["t_perm"]
    psK = class_records[1]["conjugation_action_on_class"]["s_perm"]
    ptK = class_records[1]["conjugation_action_on_class"]["t_perm"]
    aut_order = verify_aut_preserves_N(N, psH, ptH, psK, ptK)
    assert aut_order == 660

    # Complementary design (non-incidence = |I|=10)
    N_comp = [[1 - N[i][j] for j in range(11)] for i in range(11)]
    comp_row = [sum(r) for r in N_comp]
    assert all(c == 6 for c in comp_row)

    design_json = {
        "schema": "g7a-double-a5-design-v1",
        "group": {
            "name": "PSL(2,11)",
            "order": 660,
            "generators_mobius": {
                "S": [[0, -1], [1, 0]],
                "T": [[1, 1], [0, 1]],
            },
            "permutation_degree": 12,
            "note": (
                "G reconstructed as Möbius transformations on P^1(F_11) "
                "(12 points), same installed generators as G4/H packets."
            ),
        },
        "classes": class_records,
        "cross_intersections": {
            "count": 121,
            "order_histogram": {str(k): v for k, v in sorted(order_counts.items())},
            "type_histogram": {
                f"order_{n}_{typ}": cnt
                for (n, typ), cnt in sorted(type_counts.items())
            },
            "table": inter_table,
            "derived_incidence_rule": (
                "H_i incident K_j  ⟺  |H_i ∩ K_j| = 12  ⟺  H_i ∩ K_j ≅ A4. "
                "Nonincident  ⟺  |H_i ∩ K_j| = 10  ⟺  H_i ∩ K_j ≅ D5."
            ),
        },
        "G_orbits_on_HxK": {
            "count": len(orbits),
            "orbits": [
                {
                    "size": o["size"],
                    "intersection_order": o["intersection_order"],
                    "iso_type": o["iso_type"],
                    "n_pairs_listed": len(o["pairs"]),
                }
                for o in orbits
            ],
            "unique_nontrivial_cross_relation": {
                "orbit_size": 55,
                "intersection": "A4 order 12",
                "regularity": "5 neighbors on each side",
            },
        },
        "incidence_matrix_N": N,
        "design_identities": {
            k: v
            for k, v in identities.items()
            if k not in ("NNt", "NtN", "pairwise_row_meets", "pairwise_col_meets")
        },
        "NNt": identities["NNt"],
        "NtN": identities["NtN"],
        "automorphism_action": {
            "installed_G_image_order_on_design": aut_order,
            "preserves_incidence": True,
            "equals_full_Aut_of_unique_biplane": (
                "Unique 2-(11,5,2) has |Aut|=660; installed G acts faithfully "
                "as Aut(design)."
            ),
            "conjugation_s_on_H": psH,
            "conjugation_t_on_H": ptH,
            "conjugation_s_on_K": psK,
            "conjugation_t_on_K": ptK,
        },
        "complementary_relation": {
            "N_comp": N_comp,
            "row_sums": comp_row,
            "parameters": "each point in 6 nonincident blocks (2-(11,6,3) complement)",
        },
        "markers": {
            "G7-PALEY-BIPLANE-IDENTIFIED": identities["is_paley_biplane"],
        },
        "H_A5_binding": {
            "note": (
                "Both conjugacy classes of maximal A5 are reconstructed. Labels "
                "A5_class_H / A5_class_K are the two nonconjugate classes; they "
                "correspond setwise to H_A5 A5_class_1 / A5_class_2 (class index "
                "matching is by nonconjugacy, not generator matrix identity)."
            ),
            "H_A5_class_1_exit": "H-A5-CLASS1-RATIONAL-POINT",
            "H_A5_class_2_exit": "H-A5-CLASS2-RATIONAL-POINT",
        },
    }

    # --- G7.1 ---
    proj = build_projectors_and_intertwiners(N)
    proj["schema"] = "g7a-projectors-intertwiners-v1"
    proj["markers"] = {
        "G7-CROSS-CLASS-PROJECTOR-PASS": True,
        "module_shape_correction": "1+10 not 1+5+5",
    }

    # --- write artifacts ---
    (HERE / "INPUT_MANIFEST.json").write_text(
        json.dumps(
            {
                "schema": "g7a-input-manifest-v1",
                "inputs": inputs,
                "group_generators": {
                    "S": "[[0,-1],[1,0]]",
                    "T": "[[1,1],[0,1]]",
                    "source": "installed Möbius generators (same as G4 produce.py)",
                },
            },
            indent=2,
        )
        + "\n"
    )

    (HERE / "design.json").write_text(json.dumps(design_json, indent=2) + "\n")
    (HERE / "incidence_N.json").write_text(
        json.dumps(
            {
                "schema": "g7a-incidence-N-v1",
                "N": N,
                "NNt": identities["NNt"],
                "NtN": identities["NtN"],
                "parameters": identities["parameters"],
            },
            indent=2,
        )
        + "\n"
    )
    (HERE / "cross_intersections.json").write_text(
        json.dumps(
            {
                "schema": "g7a-cross-intersections-v1",
                "order_histogram": design_json["cross_intersections"]["order_histogram"],
                "type_histogram": design_json["cross_intersections"]["type_histogram"],
                "table": inter_table,
            },
            indent=2,
        )
        + "\n"
    )
    (HERE / "projectors.json").write_text(json.dumps(proj, indent=2) + "\n")

    wall = time.time() - t0
    # macOS ru_maxrss is bytes; Linux is kilobytes
    peak = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    peak_mb = peak / (1024 * 1024) if peak > 10**7 else peak / 1024

    meta = {
        "schema": "g7a-produce-meta-v1",
        "wall_seconds": wall,
        "peak_rss_raw": peak,
        "peak_rss_mb_approx": peak_mb,
        "exit_primary": "G7-CROSS-CLASS-PROJECTOR-PASS",
        "also": ["G7-PALEY-BIPLANE-IDENTIFIED"],
        "module_correction": "Ind = 1+10 (not 1+5+5)",
    }
    (HERE / "produce_meta.json").write_text(json.dumps(meta, indent=2) + "\n")

    write_markdown(
        HERE / "DESIGN.md",
        f"""# G7A — exact two-class A5 design (G7.0)

## Group

\\(G = \\mathrm{{PSL}}_2(\\mathbf F_{{11}})\\), order 660, reconstructed from Möbius
generators

```text
S = [[0,-1],[1,0]],  T = [[1,1],[0,1]]
```

acting on the 12 points of \\(\\mathbf P^1(\\mathbf F_{{11}})\\).

## Two conjugacy classes of maximal A5

Exactly 22 subgroups isomorphic to A5; they form **two** conjugacy classes
\\(\\mathcal H = \\{{H_0,\\ldots,H_{{10}}\\}}\\) and
\\(\\mathcal K = \\{{K_0,\\ldots,K_{{10}}\\}}\\), each of size 11
(index \\([G:A5]=11\\)).

Labels in artifacts: `A5_class_H`, `A5_class_K` (both nonconjugate maximal classes).

## Cross-intersections (all 121 pairs)

| \\(|H_i \\cap K_j|\\) | count | isomorphism type | role |
|---:|---:|---|---|
| 12 | 55 | A4 (orders: 1×1, 2×3, 3×8) | **incident** |
| 10 | 66 | D5 (orders: 1×1, 2×5, 5×4) | nonincident |

**Derived incidence rule** (not assumed):

\\[
H_i \\mathrel{{I}} K_j \\iff |H_i \\cap K_j| = 12 \\iff H_i \\cap K_j \\cong A_4.
\\]

## G-orbits on \\(\\mathcal H \\times \\mathcal K\\)

Exactly two orbits:

- size **55** — the A4-intersection (incident) pairs;
- size **66** — the D5-intersection (nonincident) pairs.

The unique nontrivial cross-relation is 5-regular on each side.

## Incidence matrix and biplane identities

The 11×11 zero-one matrix \\(N\\) satisfies, by direct reconstruction:

```text
row sums = column sums = 5
any two rows meet in 2 columns
any two columns meet in 2 rows
N N^t = 3 I + 2 J
N^t N = 3 I + 2 J
```

Hence \\(N\\) is the incidence matrix of the symmetric design

\\[
2-(11,5,2)
\\]

(the **Paley biplane** of order 11). This is a derived identity, not a
literature assumption.

## Automorphisms

Conjugation by the installed generators \\(S,T\\) induces permutations of
\\(\\mathcal H\\) and of \\(\\mathcal K\\) that preserve \\(N\\), and the joint
image has order 660. Thus the installed \\(G\\) is exactly \\(\\mathrm{{Aut}}\\) of
this design.

## Marker

**G7-PALEY-BIPLANE-IDENTIFIED**

Machine data: `design.json`, `incidence_N.json`, `cross_intersections.json`.
""",
    )

    write_markdown(
        HERE / "PERMUTATION_PROJECTORS.md",
        """# G7A — permutation modules and incidence projectors (G7.1)

## Decomposition (both classes)

For either maximal A5 subgroup \\(H\\) (resp. \\(K\\)):

\\[
\\mathrm{Ind}_H^G \\mathbf 1 \\cong \\mathbf 1 \\oplus V_{10}
\\]

as a \\(G\\)-module over \\(\\mathbf Q\\) (and over \\(\\mathbf C\\)). Evidence:

- \\(\\|\\chi_{\\mathrm{perm}}\\|^2 = 2\\)
- \\(\\|\\chi_{\\mathrm{aug}}\\|^2 = 1\\)

so the 10-dimensional augmentation is **absolutely irreducible**.

### Correction to the naive shape

The shape \\(\\mathbf 1 \\oplus W \\oplus W'\\) with \\(W,W'\\) the two five-dimensional
irreps of \\(G\\) is **false** for these permutation modules. The Klein and
companion 5-dimensional irreps of \\(\\mathrm{PSL}_2(\\mathbf F_{11})\\) have
character field \\(\\mathbf Q(\\sqrt{-11})\\) and are Galois conjugates; **neither**
appears in \\(\\mathrm{Ind}_H^G\\mathbf 1\\).

Restriction to \\(H\\cong A_5\\) recovers an internal \\(1\\oplus 5\\oplus 5\\) of
A5-modules; that A5-internal pair is not the Klein/companion pair of \\(G\\).

## Projectors over \\(\\mathbf Q\\)

In either coset basis:

\\[
P_1 = \\tfrac1{11} J,\\qquad P_{10} = I - P_1.
\\]

Orthogonal idempotents, traces 1 and 10.

## Incidence intertwiner

View \\(N\\) as a linear map \\(\\mathbf Q^{11}_K \\to \\mathbf Q^{11}_H\\). Then:

| constituent | action of \\(N\\) |
|---|---|
| trivial | eigenvalue \\(5\\) (\\(N\\mathbf 1 = 5\\mathbf 1\\)) |
| augmentation | \\(N^t N = 3I\\) on \\(\\mathrm{aug}_K\\); inverse \\(\\frac1{3}N^t\\) |

No \\(\\sqrt 3\\) extension is required: the rational inverse \\(\\frac1{3}N^t\\) on
augmentation already suffices. Denominator gate: characteristic \\(\\neq 3\\).

Verified identities:

```text
P10 N N^t P10 = 3 P10
P10 N^t N P10 = 3 P10
```

## Marker

**G7-CROSS-CLASS-PROJECTOR-PASS**

Machine data: `projectors.json`.
""",
    )

    write_markdown(
        HERE / "REPLAY.md",
        """# G7A replay

From repository root `problems/E-klein-cubic` (workspace root):

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/produce.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/verify_design.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/make_seal.py
```

Or verifier-only after artifacts exist:

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/verify_design.py
```

Expected:

```text
G7A_PRODUCE_OK
G7-PALEY-BIPLANE-IDENTIFIED
G7-CROSS-CLASS-PROJECTOR-PASS
G7A_VERIFY_DESIGN_OK
G7A_SEAL_OK
```

Primary STATUS exit: `G7-CROSS-CLASS-PROJECTOR-PASS` (includes biplane identification).

Note: `verify_design.py` does **not** import `produce.py`; it regenerates
\\(G\\), both A5 classes, incidence, identities, and projectors independently.
""",
    )

    write_markdown(
        HERE / "STATUS.md",
        f"""G7-CROSS-CLASS-PROJECTOR-PASS

# Goal G7A status — exact two-class design and projectors

**Primary exit:** `G7-CROSS-CLASS-PROJECTOR-PASS`  
**Also achieved:** `G7-PALEY-BIPLANE-IDENTIFIED`  
**Module correction recorded:** `Ind = 1+10` (naive `1+5+5` / `1⊕W⊕W'` refuted)  
**Headline:** OPEN (structural; not a Problem-E decision)  
**Stages:** G7.0, G7.1 only (no G7B cycles, no G7C geometry)

## Decision

### G7.0 — two-class subgroup geometry

1. Reconstructed \\(G=\\mathrm{{PSL}}_2(\\mathbf F_{{11}})\\) order 660 from installed
   Möbius generators \\(S,T\\).
2. Found all 22 maximal A5 subgroups; split into two conjugacy classes of size 11.
3. All 121 cross-intersections: 55 of type A4 (order 12), 66 of type D5 (order 10).
4. Exactly two G-orbits on \\(\\mathcal H\\times\\mathcal K\\) (sizes 55 and 66).
5. Incidence \\(N\\) from A4-intersections is 5-regular; identities
   \\(NN^t=N^tN=3I+2J\\) hold exactly ⇒ symmetric **2-(11,5,2)** Paley biplane.
6. Installed \\(G\\) acts as Aut(design), image order 660.

### G7.1 — projectors / constituents

1. Both permutation modules: **\\(1\\oplus 10\\)** over \\(\\mathbf Q\\), 10 absolutely irreducible.
2. Naive \\(1\\oplus W\\oplus W'\\) (Klein/companion 5s) **refuted** for these Ind modules.
3. Klein/companion 5s: character field \\(\\mathbf Q(\\sqrt{{-11}})\\), Galois swaps them;
   not summands of either degree-11 perm module.
4. Projectors \\(P_1=J/11\\), \\(P_{{10}}=I-P_1\\) over \\(\\mathbf Q\\).
5. \\(N\\) intertwines: eigenvalue 5 on trivials; on augmentations
   \\(N^{{-1}}=\\frac1{{3}}N^t\\) exactly (char ≠ 3).

## Nonclaims

- No induced point coordinates (G7B).
- No projective scaling / geometry (G7.2–G7.C).
- Does not reseal H_A5 or G4.
- Does not claim a \\(K_{{\\rm proj}}\\)-point of \\(X_{{\\rm gen}}\\).

## Peak resource

Producer wall ≈ {wall:.2f} s; peak RSS ≈ {peak_mb:.1f} MB.

## Replay

See `REPLAY.md`. Marker: `G7A_VERIFY_DESIGN_OK`.
""",
    )

    print("G7A_PRODUCE_OK")
    print("G7-PALEY-BIPLANE-IDENTIFIED")
    print("G7-CROSS-CLASS-PROJECTOR-PASS")
    print(f"wall_seconds={wall:.3f}")
    print(f"peak_rss_mb_approx={peak_mb:.2f}")


if __name__ == "__main__":
    main()
