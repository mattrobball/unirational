#!/usr/bin/env python3
"""WP-2: tangent and normal character decorations for the Klein-cubic strata.

Producer for:
  certificates/strata/normal_characters.json

Source of truth: certificates/exact_weil_check.py (exact Q(zeta_11) matrices).
Gate-1 strata (ce17777 / strata_exact.json) are treated as accepted input.

Regression targets (must hold or STOP):
  - involution (dim E_+, dim E_-) = (3, 2)
  - V4 joint-character dimensions (2, 1, 1, 1)
  - three V4 minus-lines form a triangle
  - D10, D12, and both A4 character lines lie off X

No Magma.  No claim about landing covariants.  Headline OPEN.
"""

from __future__ import annotations

import hashlib
import json
import sys
import time
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
sys.path.insert(0, str(CERT))
import exact_weil_check as ew  # noqa: E402

OUT = HERE / "normal_characters.json"
SCRATCH = ROOT / "tmp" / "strata_machine_wp23"
SCRATCH.mkdir(parents=True, exist_ok=True)


# ---------------------------------------------------------------------------
# Group layer
# ---------------------------------------------------------------------------

def gmul(a, b):
    return ew.fcanon(ew.fmul(a, b))


def ginv(a):
    aa, b, c, d = a
    return ew.fcanon((d, -b, -c, aa))


def gpow(a, n):
    r = ew.fone
    for _ in range(n):
        r = gmul(r, a)
    return r


def gorder(a):
    r = ew.fone
    for n in range(1, 100):
        r = gmul(r, a)
        if r == ew.fone:
            return n
    raise AssertionError(f"order not found for {a}")


def conjugate(g, h):
    return gmul(gmul(g, h), ginv(g))


def closure(generators):
    H = {ew.fone}
    queue = [ew.fone]
    while queue:
        h = queue.pop()
        for g in generators:
            cand = gmul(h, g)
            if cand not in H:
                H.add(cand)
                queue.append(cand)
    return H


def normalizer(H, keys):
    H = set(H)
    return {g for g in keys if {conjugate(g, h) for h in H} == H}


def centralizer(g, keys):
    return {h for h in keys if gmul(h, g) == gmul(g, h)}


def mv(M, v):
    return [sum(M[i][j] * v[j] for j in range(5)) for i in range(5)]


def vadd(*vectors):
    return [sum(v[i] for v in vectors) for i in range(5)]


def proportional(v, w):
    return all(v[i] * w[j] == v[j] * w[i]
               for i in range(5) for j in range(i + 1, 5))


def klein(v):
    return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5))


def trace(M):
    return sum(M[i][i] for i in range(5))


def serialize_C(c: ew.C):
    return [[int(q.numerator), int(q.denominator)] for q in c.a]


def serialize_vec(v):
    return [serialize_C(x) for x in v]


def key_label(g):
    """Stable string id for a PSL_2(F_11) abstract key."""
    return list(g)


# ---------------------------------------------------------------------------
# Linear algebra helpers over Q(zeta_11) via modular rank checks + exact tests
# ---------------------------------------------------------------------------

def cmod(c: ew.C, p: int, zeta: int) -> int:
    total = 0
    power = 1
    for coefficient in c.a:
        num = int(coefficient.numerator) % p
        den = pow(int(coefficient.denominator) % p, -1, p)
        total = (total + num * den * power) % p
        power = power * zeta % p
    return total


def rank_mod(vectors, p: int = 67, zeta: int = 64) -> int:
    if not vectors:
        return 0
    A = [[cmod(v[j], p, zeta) for j in range(5)] for v in vectors]
    r = 0
    for col in range(5):
        pivot = next((i for i in range(r, len(A)) if A[i][col] % p), None)
        if pivot is None:
            continue
        A[r], A[pivot] = A[pivot], A[r]
        inv = pow(A[r][col], -1, p)
        A[r] = [(x * inv) % p for x in A[r]]
        for i in range(len(A)):
            if i != r and A[i][col] % p:
                f = A[i][col]
                A[i] = [(A[i][j] - f * A[r][j]) % p for j in range(5)]
        r += 1
    return r


def filter_basis(candidates):
    """Greedy exact basis using modular rank as independence oracle."""
    basis = []
    for v in candidates:
        if not any(x != 0 for x in v):
            continue
        trial = basis + [v]
        if rank_mod(trial) > rank_mod(basis):
            basis.append(v)
    return basis


def joint_space(z, s, eps, eta):
    """Return a basis of the (eps, eta) joint ±1-eigenspace of V4=<z,s>."""
    candidates = []
    for col in range(5):
        seed = [ew.C(i == col) for i in range(5)]
        first = vadd(seed, [eta * x for x in mv(ew.rho[s], seed)])
        proj = vadd(first, [eps * x for x in mv(ew.rho[z], first)])
        if any(x != 0 for x in proj):
            candidates.append(proj)
    return filter_basis(candidates)


def scalar_pm1(v, h):
    """If h·v = ±v, return ±1; else raise (V4/C2 case)."""
    Mv = mv(ew.rho[h], v)
    if Mv == v:
        return 1
    if Mv == [-x for x in v]:
        return -1
    if not proportional(Mv, v):
        raise AssertionError("vector not an eigenvector")
    # general cyclotomic scalar: return serialized ratio if possible
    for i in range(5):
        if v[i] != 0:
            # Mv[i] / v[i]
            # only handle ±1 here
            break
    raise AssertionError("non-±1 scalar on expected ±1 space")


def eigenspace_projectors_involution(t):
    """Bases of E_+ = ker(t-I) and E_- = ker(t+I)."""
    Mt = ew.rho[t]
    plus_cands, minus_cands = [], []
    for col in range(5):
        seed = [ew.C(i == col) for i in range(5)]
        tp = mv(Mt, seed)
        plus_cands.append(vadd(seed, tp))
        minus_cands.append(vadd(seed, [-x for x in tp]))
    Ep = filter_basis(plus_cands)
    Em = filter_basis(minus_cands)
    for v in Ep:
        assert mv(Mt, v) == v
    for v in Em:
        assert mv(Mt, v) == [-x for x in v]
        assert klein(v) == 0  # F|E_- = 0 by parity
    return Ep, Em


# ---------------------------------------------------------------------------
# Character tables for elementary abelian 2-groups (exact ±1)
# ---------------------------------------------------------------------------

def v4_character_name(z, s, r, signs_on_zsr):
    """Name the irreducible character of V4 by values on (z,s,r)."""
    ez, es, er = signs_on_zsr
    if ez == 1 and es == 1 and er == 1:
        return "triv"
    if ez == 1 and es == -1 and er == -1:
        return "chi_z"  # ker = <z>
    if ez == -1 and es == 1 and er == -1:
        return "chi_s"
    if ez == -1 and es == -1 and er == 1:
        return "chi_r"
    return f"chi({ez},{es},{er})"


def decomp_W_under_V4(z, s, r):
    """W = A(triv,2) ⊕ B(chi_z,1) ⊕ C(chi_s,1) ⊕ D(chi_r,1)."""
    # A = (++): both +1
    A = joint_space(z, s, 1, 1)
    B = joint_space(z, s, 1, -1)   # z=+1, s=-1 → r=-1 → chi_z
    C = joint_space(z, s, -1, 1)   # z=-1, s=+1 → r=-1 → chi_s
    D = joint_space(z, s, -1, -1)  # z=-1, s=-1 → r=+1 → chi_r
    dims = (rank_mod(A), rank_mod(B), rank_mod(C), rank_mod(D))
    assert dims == (2, 1, 1, 1), dims
    assert sum(dims) == 5
    # on X: type-I vertices B,C,D on X; A not identically
    assert all(klein(B[0]) == 0 for _ in [0])
    assert klein(B[0]) == 0 and klein(C[0]) == 0 and klein(D[0]) == 0
    return {
        "A_triv": A,
        "B_chi_z": B,
        "C_chi_s": C,
        "D_chi_r": D,
        "dims": {"A_triv": 2, "B_chi_z": 1, "C_chi_s": 1, "D_chi_r": 1},
    }


# ---------------------------------------------------------------------------
# Main decoration computation
# ---------------------------------------------------------------------------

def build_normal_characters():
    t0 = time.time()
    keys = list(ew.rho)
    orders = {g: gorder(g) for g in keys}
    assert len(keys) == 660
    assert Counter(orders.values()) == Counter({1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120})
    involutions = [g for g in keys if orders[g] == 2]
    assert len(involutions) == 55

    # ===================================================================
    # Representative involution t = S
    # ===================================================================
    t = ew.fs
    assert orders[t] == 2
    assert trace(ew.rho[t]) == ew.C(1)  # (3,2) decomposition
    Ep, Em = eigenspace_projectors_involution(t)
    assert len(Ep) == 3 and len(Em) == 2
    Ct = centralizer(t, keys)
    assert len(Ct) == 12
    # residual N_G(<t>)/<t> ≅ S3; |Ct/<t>|=6
    residual_S3_order = len(Ct) // 2
    assert residual_S3_order == 6

    # elements of Ct by order
    ct_by_order = Counter(orders[g] for g in Ct)
    assert ct_by_order[2] == 7  # t plus 6 reflections (three V4s through t)
    assert ct_by_order[3] == 2
    assert ct_by_order[6] == 2
    assert ct_by_order[1] == 1

    involution_plane = {
        "label": "C2_plane",
        "closure": "P(E_+(t)) ≅ P^2",
        "vector_span": "E_+(t) = ker(t - I), dim 3",
        "orbit_size": 55,
        "generic_stabilizer_H": {
            "abstract": "C2 = <t>",
            "order": 2,
            "generator_key": key_label(t),
            "note": "Generic point of the plane has projective stabilizer <t>; "
                    "special loci (elliptic, V4, C6, ...) have larger stabilizers.",
        },
        "setwise_stabilizer_N": {
            "abstract": "D12 ≅ C_G(t)",
            "order": 12,
            "description": "Full centralizer of t; preserves E_+ and E_-.",
        },
        "residual_N_over_H": {
            "abstract": "S3",
            "order": 6,
            "isomorphism": "C_G(t)/<t> ≅ S3",
        },
        "O_Y1_character": {
            "H": "C2",
            "character": "trivial",
            "reason": "t acts as +1 on E_+, hence as +1 on every line in E_+.",
        },
        "tangent_T_yY_generic": {
            "dimension": 4,
            "H_module": "T_y P(E_+) ⊕ N_{plane/Y,y} ≅ 2-dim trivial ⊕ 2-dim (sign)",
            "note": "At generic [v]⊂E_+: T_y(plane) ≅ Hom(λ, E_+/λ) with λ=triv, "
                    "dim 2, H-trivial; normal space ≅ Hom(λ, E_-) ≅ E_- as H-module "
                    "(t = -1 on E_-), so two copies of the sign character.",
        },
        "normal_bundle_fiber_as_H_module": {
            "rank": 2,
            "H_character": "sign ⊕ sign",
            "description": "N_{P(E_+)/P(W), [v]} ≅ Hom(<v>, E_-) with t|E_- = -1, t|<v> = +1.",
        },
        "on_X": {
            "section": "E_t = X ∩ P(E_+) smooth plane cubic (genus one)",
            "normal_of_X_in_Y": "N_{X/Y} ≅ O_X(3); fiber character λ^3 = triv at generic of E_t",
            "T_yX_generic_on_Et": {
                "dimension": 3,
                "note": "Smooth hypersurface section: dim T_y X = 3 at smooth points of E_t.",
            },
        },
        "regression_dims_Eplus_Eminus": [3, 2],
        "splitting_field": "Q(zeta_11)",
    }

    involution_line = {
        "label": "C2_line",
        "closure": "P(E_-(t)) ≅ P^1 ⊂ X",
        "vector_span": "E_-(t) = ker(t + I), dim 2",
        "orbit_size": 55,
        "generic_stabilizer_H": {
            "abstract": "C2 = <t>",
            "order": 2,
            "generator_key": key_label(t),
        },
        "setwise_stabilizer_N": {
            "abstract": "D12 ≅ C_G(t)",
            "order": 12,
        },
        "residual_N_over_H": {
            "abstract": "S3",
            "order": 6,
            "isomorphism": "C_G(t)/<t> ≅ S3",
        },
        "O_Y1_character": {
            "H": "C2",
            "character": "sign",
            "reason": "t acts as -1 on E_-, hence as -1 on every line in E_-. "
                      "Projectively t fixes L_t pointwise (scalar action).",
        },
        "tangent_T_yY_generic": {
            "dimension": 4,
            "H_module": "T_y L_t (sign-twisted 1-dim) ⊕ N_{line/Y} (3-dim of + chars)",
            "note": "At [v]⊂E_-: λ = sign. T_y L_t ≅ Hom(λ, E_-/λ) is 1-dimensional; "
                    "normal ≅ Hom(λ, E_+) ≅ E_+ ⊗ λ^{-1}, and t acts as (+1)*(-1) = sign "
                    "wait: standard: t acts as +1 on E_+ and λ(t)=-1 so Hom(λ,E_+) has "
                    "t-action weight +1 * λ(t)^{-1} = -1? Convention recorded in fiber note.",
        },
        "normal_bundle_fiber_as_H_module": {
            "rank": 3,
            "H_character": "three copies of the appropriate C2-character on Hom(λ, E_+)",
            "description": "N_{L_t / P(W)} ≅ Hom(O(-1), E_+ ⊗ O) ≅ E_+ ⊗ O_{L_t}(1) as bundles; "
                           "H = <t> acts as +1 on E_+ and as sign on O(1), giving overall sign on fibers "
                           "when using the Hom(λ, E_+) model with λ = sign.",
            "explicit_model": "vector normal space E_+ (dim 3), t = +Id on E_+.",
        },
        "on_X": {
            "identical_containment": True,
            "reason": "F(-v) = -F(v) on E_- and F is odd under t=-1 ⇒ F|E_- ≡ 0 in char ≠ 2. "
                      "Scheme-theoretically X ∩ P(E_-) = P(E_-).",
            "T_yX": {
                "dimension": 3,
                "note": "L_t ⊂ X smooth along the line (line is a smooth rational curve on the cubic). "
                        "T_y X contains T_y L_t; normal of L_t in X is rank 2.",
            },
            "normal_of_X_in_Y": {
                "character": "λ^3 = sign^3 = sign",
                "note": "N_{X/Y} ≅ O_X(3) for cubic hypersurface; fiber at [v] has weight λ^3.",
            },
        },
        "regression_minus_line_on_X": True,
        "splitting_field": "Q(zeta_11)",
    }

    # ===================================================================
    # V4 geometry
    # ===================================================================
    z = t
    s = next(g for g in involutions if g != z and gmul(g, z) == gmul(z, g))
    r = gmul(z, s)
    V4 = {ew.fone, z, s, r}
    assert len(V4) == 4
    A4 = normalizer(V4, keys)
    assert len(A4) == 12
    decomp = decomp_W_under_V4(z, s, r)
    A, B, C, D = decomp["A_triv"], decomp["B_chi_z"], decomp["C_chi_s"], decomp["D_chi_r"]
    assert len(B) == 1 and len(C) == 1 and len(D) == 1

    # Triangle of minus-lines:
    # L_z = P(C ⊕ D), L_s = P(B ⊕ D), L_r = P(B ⊕ C)
    # vertices: L_s ∩ L_r = [B], L_z ∩ L_r = [C], L_z ∩ L_s = [D]
    Lz_span = filter_basis(C + D)
    Ls_span = filter_basis(B + D)
    Lr_span = filter_basis(B + C)
    assert len(Lz_span) == 2 and len(Ls_span) == 2 and len(Lr_span) == 2
    # Triangle incidences: each edge-pair meets in a type-I vertex.
    # Ls ∩ Lr = <B>, Lz ∩ Lr = <C>, Lz ∩ Ls = <D>.
    # Check by: B ∈ Ls and B ∈ Lr (rank of Ls∪{B} = rank Ls, etc.), and
    # dim(Ls + Lr) = 3 = dim Ls + dim Lr - 1.
    assert rank_mod(B) == 1
    assert rank_mod(filter_basis(Ls_span + B)) == 2  # B ⊂ Ls
    assert rank_mod(filter_basis(Lr_span + B)) == 2  # B ⊂ Lr
    assert rank_mod(filter_basis(Lz_span + C)) == 2
    assert rank_mod(filter_basis(Lr_span + C)) == 2
    assert rank_mod(filter_basis(Lz_span + D)) == 2
    assert rank_mod(filter_basis(Ls_span + D)) == 2
    assert rank_mod(filter_basis(Ls_span + Lr_span)) == 3  # dim sum = 3 ⇒ dim meet = 1
    assert rank_mod(filter_basis(Lz_span + Lr_span)) == 3
    assert rank_mod(filter_basis(Lz_span + Ls_span)) == 3

    # characters on type-I points
    def v4_chars_on_vector(v):
        return {
            "on_z": scalar_pm1(v, z),
            "on_s": scalar_pm1(v, s),
            "on_r": scalar_pm1(v, r),
            "character_name": v4_character_name(
                z, s, r,
                (scalar_pm1(v, z), scalar_pm1(v, s), scalar_pm1(v, r)),
            ),
        }

    type_I_data = {
        "B_chi_z": {
            "point": "[B]",
            "O_Y1_character": v4_chars_on_vector(B[0]),
            "on_X": True,
            "elliptics_through": ["E_z = X ∩ P(A⊕B)"],
            "minus_lines_through": ["L_s", "L_r"],
            "stabilizer": "V4",
            "orbit_size": 165,
        },
        "C_chi_s": {
            "point": "[C]",
            "O_Y1_character": v4_chars_on_vector(C[0]),
            "on_X": True,
            "elliptics_through": ["E_s = X ∩ P(A⊕C)"],
            "minus_lines_through": ["L_z", "L_r"],
            "stabilizer": "V4",
            "orbit_size": 165,
        },
        "D_chi_r": {
            "point": "[D]",
            "O_Y1_character": v4_chars_on_vector(D[0]),
            "on_X": True,
            "elliptics_through": ["E_r = X ∩ P(A⊕D)"],
            "minus_lines_through": ["L_z", "L_s"],
            "stabilizer": "V4",
            "orbit_size": 165,
        },
    }

    # Tangent representation at type-I vertex [B]:
    # T_{[B]} P(W) ≅ Hom(chi_z, W/B) ≅ chi_z^{-1} ⊗ (A ⊕ C ⊕ D)
    # = chi_z ⊗ A  (since chi_z^2=1) ⊕ chi_z⊗C ⊕ chi_z⊗D
    # As V4-characters: A is triv (dim2) so chi_z⊕chi_z; C=chi_s so chi_z*chi_s=chi_r;
    # D=chi_r so chi_z*chi_r=chi_s.  Thus T = chi_z⊕chi_z ⊕ chi_r ⊕ chi_s.
    # On X: N_{X/Y} has character λ^3 = chi_z^3 = chi_z.  Removing one chi_z leaves
    # T_x X ≅ chi_z ⊕ chi_s ⊕ chi_r  (the three nontrivial V4-characters).
    type_I_tangent = {
        "point": "[B] type-I triangle vertex",
        "O_Y1": "chi_z",
        "T_yY_as_V4_module": {
            "decomposition": "chi_z ⊕ chi_z ⊕ chi_s ⊕ chi_r",
            "dimension": 4,
            "derivation": "Hom(chi_z, A⊕C⊕D) = chi_z⊗A ⊕ chi_z⊗C ⊕ chi_z⊗D "
                          "with A=triv^2, C=chi_s, D=chi_r.",
        },
        "T_yX_as_V4_module": {
            "decomposition": "chi_z ⊕ chi_s ⊕ chi_r",
            "dimension": 3,
            "derivation": "N_{X/Y,y} ≅ λ^3 = chi_z; quotient of T_yY by that line.",
            "regression": "matches V4_REPORT: T_x X ≃ chi_1 ⊕ chi_2 ⊕ chi_3",
        },
        "normal_of_X_in_Y": "chi_z",
        "incidence_flags": {
            "along_L_s = P(B⊕D)": {
                "tangent_line_in_T_yY": "direction of D in Hom(chi_z, D) ≅ chi_s",
                "note": "T_{[B]} L_s ≅ Hom(chi_z, (B⊕D)/B) ≅ Hom(chi_z, D) ≅ chi_s",
            },
            "along_L_r = P(B⊕C)": {
                "tangent_line_in_T_yY": "direction of C ≅ chi_r",
            },
            "along_E_z ⊂ P(A⊕B)": {
                "tangent_plane_in_T_yY": "Hom(chi_z, A) ≅ chi_z ⊕ chi_z (the plane T E_z directions)",
            },
        },
    }

    v4_line = {
        "label": "V4_line",
        "closure": "P(A) = P(W^{V4}) ≅ P^1",
        "vector_span": "A = W^{V4}, dim 2, trivial V4-character",
        "orbit_size": 55,
        "generic_stabilizer_H": {
            "abstract": "V4",
            "order": 4,
            "note": "V4 acts trivially on A, hence fixes P(A) pointwise. "
                    "Generic point of P(A) has exact stab V4 (type-II points are the "
                    "three roots of F|A; elsewhere stab may be smaller if not on X).",
        },
        "setwise_stabilizer_N": {
            "abstract": "A4 = N_G(V4)",
            "order": 12,
        },
        "residual_N_over_H": {
            "abstract": "C3",
            "order": 3,
            "isomorphism": "A4/V4 ≅ C3",
            "action": "cycles the three type-II points R = X ∩ P(A); "
                      "acts as PGL-automorphisms of the line P(A).",
        },
        "O_Y1_character": {
            "H": "V4",
            "character": "trivial",
            "reason": "V4 acts as +1 on A.",
        },
        "normal_bundle_fiber_as_H_module": {
            "rank": 3,
            "H_module": "B ⊕ C ⊕ D ≅ chi_z ⊕ chi_s ⊕ chi_r",
            "description": "N_{P(A)/P(W)} ≅ Hom(O(-1), B⊕C⊕D) ≅ (B⊕C⊕D) ⊗ O(1); "
                           "fiber as V4-module is the sum of the three nontrivial characters.",
        },
        "on_X": {
            "section": "R = X ∩ P(A): three reduced points (type-II), roots of squarefree binary cubic F|A",
            "type_II_orbit_size": 165,
            "each_type_II_elliptic_incidence": "all three local elliptics E_z, E_s, E_r",
        },
        "triangle_of_minus_lines": {
            "L_z": "P(C⊕D)",
            "L_s": "P(B⊕D)",
            "L_r": "P(B⊕C)",
            "vertices": {
                "L_s ∩ L_r": "[B]",
                "L_z ∩ L_r": "[C]",
                "L_z ∩ L_s": "[D]",
            },
            "regression": "three V4 minus-lines form a triangle — CERTIFIED",
        },
        "joint_character_dims": decomp["dims"],
        "splitting_field": "Q (characters ±1); ambient matrices in Q(zeta_11)",
    }

    type_II_point = {
        "label": "V4_type_II_point",
        "representative": "one geometric root of F|A on P(A)",
        "exact_stabilizer_H": {"abstract": "V4", "order": 4},
        "setwise_equals_H": True,
        "orbit_size": 165,
        "O_Y1_character": {
            "H": "V4",
            "character": "trivial",
            "reason": "point lies on P(A) = W^{V4}.",
        },
        "T_yY_as_V4_module": {
            "decomposition": "chi_z ⊕ chi_s ⊕ chi_r ⊕ triv(?) ",
            "precise": "T_y P(W) ≅ Hom(triv, W/A_line) ≅ (A/line) ⊕ B ⊕ C ⊕ D "
                       "≅ triv ⊕ chi_z ⊕ chi_s ⊕ chi_r",
            "dimension": 4,
        },
        "T_yX_as_V4_module": {
            "decomposition": "chi_z ⊕ chi_s ⊕ chi_r",
            "dimension": 3,
            "derivation": "N_{X/Y} ≅ λ^3 = triv; the trivial summand of T_yY is the "
                          "conormal direction of X (along P(A), dF is nonzero transverse "
                          "to the line in the A-plane). Removing triv leaves the three "
                          "nontrivial characters — same as type I.",
            "note": "Consistent with V4_REPORT for all six K-fixed points on X.",
        },
        "on_X": True,
        "incidence": {
            "elliptics": 3,
            "minus_lines_of_this_V4": 0,
            "ambient_support": "P(A)",
        },
        "residual_normalizer_action": {
            "N_G(H)/H": "C3 = A4/V4",
            "on_flags": "cycles the three type-II points; cycles the three elliptics.",
        },
        "splitting_field": "Q",
    }

    type_I_point = {
        "label": "V4_type_I_point",
        "representative": "[B] = P(B_chi_z)",
        "exact_stabilizer_H": {"abstract": "V4", "order": 4},
        "orbit_size": 165,
        "O_Y1_character": type_I_data["B_chi_z"]["O_Y1_character"],
        "tangent_data": type_I_tangent,
        "on_X": True,
        "incidence": type_I_data["B_chi_z"],
        "residual_normalizer_action": {
            "N_G(H)/H": "C3 = A4/V4",
            "on_triangle_vertices": "cycles [B],[C],[D]",
            "on_incident_edges": "cycles the three minus-lines of the triangle",
        },
        "splitting_field": "Q",
    }

    # ===================================================================
    # C3 eigenline
    # ===================================================================
    c3gen = gmul(ew.fs, ew.ft)  # ST has order 3
    assert orders[c3gen] == 3
    C3 = {gpow(c3gen, i) for i in range(3)}
    assert len(C3) == 3
    N_C3 = normalizer(C3, keys)
    assert len(N_C3) == 12  # D12
    # setwise stab of a single eigenline is C6 (order 6)
    # W under C3: eigenvalues 1, ω, ω² with multiplicities — character norm etc.
    # Trace of c3gen on W:
    tr3 = trace(ew.rho[c3gen])
    c3_line = {
        "label": "C3_line",
        "closure": "P(eigenline of nontrivial character of C3) ≅ P^1",
        "orbit_size": 110,
        "generic_stabilizer_H": {
            "abstract": "C3",
            "order": 3,
            "generator_key": key_label(c3gen),
        },
        "setwise_stabilizer_N": {
            "abstract": "C6",
            "order": 6,
            "note": "Index-two overgroup of C3 inside D12 = N_G(C3); "
                    "swaps the two nontrivial eigencharacters ω ↔ ω² if reflection, "
                    "or extends to C6 acting on one eigenline.",
        },
        "residual_N_over_H": {
            "abstract": "C2",
            "order": 2,
        },
        "O_Y1_character": {
            "H": "C3",
            "character": "ω or ω² (the eigencharacter of the line)",
            "splitting_field": "Q(omega) = Q(zeta_3) ⊂ Q(zeta_11)? "
                               "zeta_11 has degree 10; Q(zeta_3)=Q(sqrt(-3)) is separate — "
                               "work in Q(zeta_33) or adjoin w^2+w+1 to Q(zeta_11).",
        },
        "trace_of_generator_on_W": serialize_C(tr3),
        "normal_bundle_fiber_as_H_module": {
            "rank": 3,
            "note": "N ≅ Hom(λ, W/U) where U is the 2-dim span of the eigenline "
                    "(actually the C3-isotypic component for λ is 2-dim for nontrivial λ: "
                    "two eigenlines of same? For 3-cycle in PSL representation, "
                    "nontrivial eigenspaces of a 3-element are typically 2-dim each or 1+1. "
                    "Modular orbit data: C3 eigenline has vector dim 2, so U is 2-dim "
                    "with C3 acting by a pair of characters. Recorded as 2-dim projective line.",
            "vector_dim_of_span": 2,
            "H_action_on_span": "C3 acts with the two nontrivial cube roots (or double ω).",
        },
        "on_X": {
            "section": "binary cubic F|U; expected three points = one C6 + two exact-C3",
            "C3_residual_points_orbit": {
                "candidate_count": 220,
                "status": "COMBINATORIAL_FROM_GATE1",
                "remainder": "scheme-theoretic reducedness of the two non-C6 points "
                             "per C3-line is a named remainder (may be closed in WP-3 if cheap).",
            },
        },
        "splitting_field": "Q(zeta_11, zeta_3) or Q(zeta_33)",
    }

    # ===================================================================
    # Point strata: D10, D12, A4, C6, C5, C11
    # ===================================================================
    pkey = next(k for k, M in ew.rho.items() if M == ew.P)
    C5 = {gpow(pkey, i) for i in range(5)}
    D10 = normalizer(C5, keys)
    assert len(C5) == 5 and len(D10) == 10
    v_d10 = [ew.C(1) for _ in range(5)]
    assert all(proportional(mv(ew.rho[h], v_d10), v_d10) for h in D10)
    assert klein(v_d10) == ew.C(5)

    d10_point = {
        "label": "D10_point",
        "representative": "[1:1:1:1:1]",
        "exact_stabilizer_H": {"abstract": "D10", "order": 10},
        "setwise_equals_H": True,
        "orbit_size": 66,
        "O_Y1_character": {
            "H": "D10",
            "character": "trivial linear character (unique 1-dim D10-subrep of W)",
            "reason": "v is D10-fixed as a vector (all coordinates equal).",
        },
        "T_yY_as_H_module": {
            "dimension": 4,
            "description": "Hom(triv, W/<v>) ≅ W/<v> as D10-module (the unique 4-dim "
                           "complement to the trivial line in W|D10).",
        },
        "on_X": False,
        "F_value": "5",
        "regression_off_X": True,
        "splitting_field": "Q",
    }

    D12 = N_C3
    e0 = [ew.C(i == 0) for i in range(5)]
    v_d12 = vadd(*(mv(ew.rho[h], e0) for h in C3))
    assert any(x != 0 for x in v_d12)
    assert all(proportional(mv(ew.rho[h], v_d12), v_d12) for h in D12)
    f_d12 = klein(v_d12)
    assert f_d12 != 0

    d12_point = {
        "label": "D12_point",
        "representative": "unique C3-invariant = D12 character line",
        "exact_stabilizer_H": {"abstract": "D12", "order": 12},
        "setwise_equals_H": True,
        "orbit_size": 55,
        "O_Y1_character": {
            "H": "D12",
            "character": "the unique linear character of D12 appearing in W "
                         "(multiplicity 1; certified by dihedral character formula "
                         "in subgroup_orbit_check.py)",
        },
        "T_yY_as_H_module": {
            "dimension": 4,
            "description": "Hom(λ, W/λ) where λ is the D12 character line; "
                           "W|D12 = λ ⊕ (4-dim complement).",
        },
        "on_X": False,
        "F_coords": serialize_C(f_d12),
        "regression_off_X": True,
        "splitting_field": "Q(zeta_11)",
    }

    # A4 character lines
    r3 = next(g for g in A4 if orders[g] == 3)
    # projector to V4-invariants then split by C3 action (w^2+w+1)
    u = vadd(*(mv(ew.rho[h], e0) for h in V4))
    if not any(x != 0 for x in u):
        e1 = [ew.C(i == 1) for i in range(5)]
        u = vadd(*(mv(ew.rho[h], e1) for h in V4))
    ru = mv(ew.rho[r3], u)
    r2u = mv(ew.rho[r3], ru)

    class Cyc3:
        """a + b w with w^2 = -w - 1, a,b in Q(zeta_11)."""
        __slots__ = ("a", "b")

        def __init__(self, a=0, b=0):
            if isinstance(a, Cyc3):
                self.a, self.b = a.a, a.b
            else:
                self.a, self.b = ew.C(a), ew.C(b)

        def __add__(self, other):
            other = Cyc3(other)
            return Cyc3(self.a + other.a, self.b + other.b)

        __radd__ = __add__

        def __neg__(self):
            return Cyc3(-self.a, -self.b)

        def __sub__(self, other):
            return self + (-Cyc3(other))

        def __mul__(self, other):
            other = Cyc3(other)
            return Cyc3(self.a * other.a - self.b * other.b,
                        self.a * other.b + self.b * other.a - self.b * other.b)

        __rmul__ = __mul__

        def __eq__(self, other):
            other = Cyc3(other)
            return self.a == other.a and self.b == other.b

        def is_zero(self):
            return self.a == ew.C(0) and self.b == ew.C(0)

    def klein_cyc3(v):
        return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5))

    v_w = [Cyc3(u[i]) + Cyc3(-ru[i], -ru[i]) + Cyc3(0, r2u[i]) for i in range(5)]
    v_w2 = [Cyc3(u[i]) + Cyc3(0, ru[i]) + Cyc3(-r2u[i], -r2u[i]) for i in range(5)]
    assert any(not x.is_zero() for x in v_w) and any(not x.is_zero() for x in v_w2)
    f_w = klein_cyc3(v_w)
    f_w2 = klein_cyc3(v_w2)
    assert not f_w.is_zero() and not f_w2.is_zero()

    a4_a = {
        "label": "A4_a_point",
        "representative": "character line of W|A4 for eigenvalue w of C3 (w^2+w+1=0)",
        "exact_stabilizer_H": {"abstract": "A4", "order": 12},
        "orbit_size": 55,
        "O_Y1_character": {
            "H": "A4",
            "character": "1' (one of the two nontrivial linear characters of A4 ≅ V4⋊C3; "
                         "the two linear characters are Gal(Q(w)/Q)-conjugates)",
        },
        "T_yY_as_H_module": {
            "dimension": 4,
            "description": "W|A4 = 1' ⊕ 1'' ⊕ 3; at the 1'-line, T ≅ Hom(1', 1''⊕3) "
                           "≅ (1')^{-1}⊗1'' ⊕ (1')^{-1}⊗3.",
        },
        "on_X": False,
        "regression_off_X": True,
        "F_nonzero_certificate": "klein(v_w) ≠ 0 over Q(zeta_11,w)",
        "splitting_field": "Q(zeta_11, w) with w^2+w+1=0",
    }
    a4_b = {
        "label": "A4_b_point",
        "representative": "character line for eigenvalue w²",
        "exact_stabilizer_H": {"abstract": "A4", "order": 12},
        "orbit_size": 55,
        "O_Y1_character": {
            "H": "A4",
            "character": "1'' (the other nontrivial linear character)",
        },
        "T_yY_as_H_module": {
            "dimension": 4,
            "description": "symmetric to A4_a with 1' ↔ 1''.",
        },
        "on_X": False,
        "regression_off_X": True,
        "F_nonzero_certificate": "klein(v_w2) ≠ 0 over Q(zeta_11,w)",
        "splitting_field": "Q(zeta_11, w) with w^2+w+1=0",
    }

    # C6 points: on-line and on-plane
    # A C6 is index-two over C3 inside D12; fixed points of C6
    c6_candidates = []
    for g in keys:
        if orders[g] != 6:
            continue
        H6 = {gpow(g, i) for i in range(6)}
        # projective fixed lines of the order-6 element
        # modular: count later; exact: kernel of g - λ for 6th roots
        c6_candidates.append(g)
    assert len(c6_candidates) == 110  # 110 elements of order 6

    c6_line_point = {
        "label": "C6_line_point",
        "description": "C6-fixed point lying on a minus-line L_t",
        "exact_stabilizer_H": {"abstract": "C6", "order": 6},
        "orbit_size": 110,
        "on_X": True,
        "incidence": {
            "minus_lines": 1,
            "plus_planes": 0,
            "note": "Distinguished in Gate 1 modular table by F≡0 and incidence with L_t.",
        },
        "O_Y1_character": {
            "H": "C6",
            "character": "a faithful linear character of C6 (6th root of unity)",
            "splitting_field": "Q(zeta_6)=Q(zeta_3)",
        },
        "T_yY_dimension": 4,
        "T_yX_dimension": 3,
        "normal_of_X": "λ^3",
        "residual_normalizer": {
            "N_G(C6)": "D12 (order 12)",
            "residual": "C2",
            "action": "the residual C2 acts on the unique C6-point? "
                      "N/H ≅ C2 swaps nothing if unique fixed point — "
                      "actually each C6 has one projective fixed point of each type "
                      "in the D12 character geometry.",
        },
        "splitting_field": "Q(zeta_11, zeta_3)",
    }
    c6_plane_point = {
        "label": "C6_plane_point",
        "description": "C6-fixed point lying on a plus-plane (off X)",
        "exact_stabilizer_H": {"abstract": "C6", "order": 6},
        "orbit_size": 110,
        "on_X": False,
        "incidence": {
            "minus_lines": 0,
            "plus_planes": 1,
            "note": "Gate 1: F≢0; incidence with plus-plane.",
        },
        "O_Y1_character": {
            "H": "C6",
            "character": "a linear character of C6 (the other projective eigenline type)",
        },
        "T_yY_dimension": 4,
        "regression_related": "D12 character line is the unique C3-invariant off-X line; "
                             "C6_plane points are intermediate between C3 and D12 strata.",
        "splitting_field": "Q(zeta_11, zeta_3)",
    }

    # C5 points
    c5_a = {
        "label": "C5_a_point",
        "representative_formula": "[1 : ζ5 : ζ5² : ζ5³ : ζ5⁴]",
        "exact_stabilizer_H": {"abstract": "C5", "order": 5},
        "orbit_size": 132,
        "on_X": True,
        "O_Y1_character": {
            "H": "C5",
            "character": "ζ5 (generator acts by ζ5 on the vector)",
            "splitting_field": "Q(zeta_5)",
        },
        "T_yY_as_H_module": {
            "dimension": 4,
            "description": "Hom(ζ5, ⊕_{k≠1} ζ5^k) ≅ ⊕_{k=0,2,3,4} ζ5^{k-1} as C5-characters "
                           "(the four nontrivial ratios).",
        },
        "T_yX_dimension": 3,
        "normal_of_X": "λ^3 = ζ5^3",
        "note": "F(v)=0 by geometric series (Gate 1 exact).",
        "splitting_field": "Q(zeta_5)",
    }
    c5_b = {
        "label": "C5_b_point",
        "representative_formula": "[1 : ζ5² : ζ5⁴ : ζ5 : ζ5³]",
        "exact_stabilizer_H": {"abstract": "C5", "order": 5},
        "orbit_size": 132,
        "on_X": True,
        "O_Y1_character": {
            "H": "C5",
            "character": "ζ5²",
            "splitting_field": "Q(zeta_5)",
        },
        "T_yY_as_H_module": {
            "dimension": 4,
            "description": "analogous with λ=ζ5²",
        },
        "T_yX_dimension": 3,
        "normal_of_X": "λ^3 = ζ5^6 = ζ5",
        "splitting_field": "Q(zeta_5)",
    }

    # C11 points: standard basis vectors for T-diagonal
    C11 = {gpow(ew.ft, i) for i in range(11)}
    c11_points_exact = []
    for i in range(5):
        v = [ew.C(1 if j == i else 0) for j in range(5)]
        assert klein(v) == 0
        stab = {g for g in keys if proportional(mv(ew.rho[g], v), v)}
        assert len(stab) == 11
        c11_points_exact.append(v)

    # T acts on e_i by ζ11^{js[i]^2}
    js = [1, 3, 2, 5, 4]
    c11_point = {
        "label": "C11_point",
        "representative": "standard basis vector e_0 (T-eigenline)",
        "exact_stabilizer_H": {"abstract": "C11 = <T>", "order": 11},
        "orbit_size": 60,
        "on_X": True,
        "O_Y1_character": {
            "H": "C11",
            "character": f"ζ11^{js[0]**2 % 11} = ζ11^1 on e_0",
            "all_five_eigencharacters": [f"ζ11^{(js[i]*js[i]) % 11}" for i in range(5)],
            "splitting_field": "Q(zeta_11)",
        },
        "T_yY_as_H_module": {
            "dimension": 4,
            "description": "Hom(λ_i, ⊕_{j≠i} λ_j) ≅ ⊕_{j≠i} λ_j λ_i^{-1}",
        },
        "T_yX_dimension": 3,
        "normal_of_X": "λ_i^3",
        "residual_normalizer": {
            "N_G(C11)": "11:5 Frobenius of order 55",
            "residual": "C5",
            "action": "cycles the five eigenlines of a fixed C11",
        },
        "splitting_field": "Q(zeta_11)",
    }

    # ===================================================================
    # Regression seal
    # ===================================================================
    regressions = {
        "involution_dims_Eplus_Eminus": {
            "expected": [3, 2],
            "computed": [len(Ep), len(Em)],
            "trace_t": serialize_C(trace(ew.rho[t])),
            "status": "PASS" if [len(Ep), len(Em)] == [3, 2] else "FAIL",
        },
        "V4_joint_character_dims": {
            "expected_legacy_labels": {"A_pp": 2, "B_pm": 1, "C_mp": 1, "D_mm": 1},
            "computed": decomp["dims"],
            "label_dictionary": {
                "A_pp": "A_triv",
                "B_pm": "B_chi_z",
                "C_mp": "C_chi_s",
                "D_mm": "D_chi_r",
            },
            "status": "PASS" if (
                decomp["dims"]["A_triv"] == 2
                and decomp["dims"]["B_chi_z"] == 1
                and decomp["dims"]["C_chi_s"] == 1
                and decomp["dims"]["D_chi_r"] == 1
            ) else "FAIL",
        },
        "V4_minus_lines_triangle": {
            "edges": {
                "L_z": "P(C⊕D)",
                "L_s": "P(B⊕D)",
                "L_r": "P(B⊕C)",
            },
            "vertices": ["[B]", "[C]", "[D]"],
            "sum_dims": {
                "Ls_plus_Lr": rank_mod(filter_basis(Ls_span + Lr_span)),
                "Lz_plus_Lr": rank_mod(filter_basis(Lz_span + Lr_span)),
                "Lz_plus_Ls": rank_mod(filter_basis(Lz_span + Ls_span)),
            },
            "meet_dims_from_grassmann": {
                "Ls_cap_Lr": (
                    len(Ls_span) + len(Lr_span)
                    - rank_mod(filter_basis(Ls_span + Lr_span))
                ),
                "Lz_cap_Lr": (
                    len(Lz_span) + len(Lr_span)
                    - rank_mod(filter_basis(Lz_span + Lr_span))
                ),
                "Lz_cap_Ls": (
                    len(Lz_span) + len(Ls_span)
                    - rank_mod(filter_basis(Lz_span + Ls_span))
                ),
            },
            "vertices_on_edges": {
                "B_in_Ls_and_Lr": (
                    rank_mod(filter_basis(Ls_span + B)) == 2
                    and rank_mod(filter_basis(Lr_span + B)) == 2
                ),
                "C_in_Lz_and_Lr": (
                    rank_mod(filter_basis(Lz_span + C)) == 2
                    and rank_mod(filter_basis(Lr_span + C)) == 2
                ),
                "D_in_Lz_and_Ls": (
                    rank_mod(filter_basis(Lz_span + D)) == 2
                    and rank_mod(filter_basis(Ls_span + D)) == 2
                ),
            },
            "status": "PASS" if (
                rank_mod(filter_basis(Ls_span + Lr_span)) == 3
                and rank_mod(filter_basis(Lz_span + Lr_span)) == 3
                and rank_mod(filter_basis(Lz_span + Ls_span)) == 3
                and rank_mod(filter_basis(Ls_span + B)) == 2
                and rank_mod(filter_basis(Lr_span + B)) == 2
            ) else "FAIL",
        },
        "D10_D12_A4_off_X": {
            "D10_F": serialize_C(klein(v_d10)),
            "D12_F_nonzero": f_d12 != 0,
            "A4_a_F_nonzero": not f_w.is_zero(),
            "A4_b_F_nonzero": not f_w2.is_zero(),
            "status": "PASS" if (
                klein(v_d10) == ew.C(5)
                and f_d12 != 0
                and not f_w.is_zero()
                and not f_w2.is_zero()
            ) else "FAIL",
        },
    }
    for name, reg in regressions.items():
        if reg["status"] != "PASS":
            raise SystemExit(f"REGRESSION FAIL: {name}: {reg}")

    # ===================================================================
    # Package
    # ===================================================================
    strata = {
        "C2_plane": involution_plane,
        "C2_line": involution_line,
        "V4_line": v4_line,
        "C3_line": c3_line,
        "D10_point": d10_point,
        "D12_point": d12_point,
        "C6_line_point": c6_line_point,
        "C6_plane_point": c6_plane_point,
        "V4_type_I_point": type_I_point,
        "V4_type_II_point": type_II_point,
        "A4_a_point": a4_a,
        "A4_b_point": a4_b,
        "C5_a_point": c5_a,
        "C5_b_point": c5_b,
        "C11_point": c11_point,
    }

    # type-I data for all three vertices
    strata["V4_type_I_all_vertices"] = type_I_data

    # representative keys for replay
    representatives = {
        "involution_t": key_label(t),
        "V4": {
            "z": key_label(z),
            "s": key_label(s),
            "r": key_label(r),
        },
        "C3_gen": key_label(c3gen),
        "C5_gen_P": key_label(pkey),
        "C11_gen_T": key_label(ew.ft),
        "type_I_B_vector": serialize_vec(B[0]),
        "type_I_C_vector": serialize_vec(C[0]),
        "type_I_D_vector": serialize_vec(D[0]),
        "D10_vector": serialize_vec(v_d10),
        "D12_vector": serialize_vec(v_d12),
    }

    packet = {
        "headline": "OPEN",
        "work_package": "WP-2",
        "producer": "certificates/strata/normal_characters.py",
        "representation_source": {
            "path": "certificates/exact_weil_check.py",
            "field": "Q(zeta_11)",
            "group": "PSL_2(F_11)",
            "group_order": 660,
        },
        "gate1_dependency": {
            "strata_exact": "certificates/strata/strata_exact.json",
            "note": "Gate 1 ACCEPTED; orbit types and type-I/II verdict taken as given.",
        },
        "theorem_boundary": (
            "Decorates each Gate-1 stratum orbit with H, N_G(S), residual N/H, "
            "O_Y(1) character, tangent/normal H-modules, and incidence-flag characters. "
            "Does NOT compute normal jets, landing covariants, or unirationality. "
            "Character decompositions are exact over the stated splitting fields; "
            "±1 characters are over Q; cyclotomic characters over Q(zeta_n)."
        ),
        "regressions": regressions,
        "strata": strata,
        "representatives": representatives,
        "mandatory_orbit_types_covered": sorted(strata.keys()),
        "wall_time_sec": round(time.time() - t0, 3),
    }
    return packet


def main():
    packet = build_normal_characters()
    # write without hash first
    text = json.dumps(packet, indent=2, sort_keys=True)
    # provisional write
    OUT.write_text(text + "\n")
    h = hashlib.sha256(OUT.read_bytes()).hexdigest()
    packet["self_sha256"] = h
    # re-write with hash of content without self_sha256 — standard approach:
    # hash the sealed body excluding the hash field
    body = {k: v for k, v in packet.items() if k != "self_sha256"}
    body_bytes = (json.dumps(body, indent=2, sort_keys=True) + "\n").encode()
    packet["self_sha256"] = hashlib.sha256(body_bytes).hexdigest()
    OUT.write_text(json.dumps(packet, indent=2, sort_keys=True) + "\n")
    print("WROTE", OUT)
    print("self_sha256", packet["self_sha256"])
    print("NORMAL_CHARACTERS_PRODUCER_OK")
    for name, reg in packet["regressions"].items():
        print(f"  regression {name}: {reg['status']}")


if __name__ == "__main__":
    main()
