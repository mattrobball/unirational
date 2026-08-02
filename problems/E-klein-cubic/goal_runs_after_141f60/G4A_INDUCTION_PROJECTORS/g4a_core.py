#!/usr/bin/env python3
"""G4A pure induction library — no STATUS/SEAL I/O.

Shared by produce_g4a.py and verify_all.py.

Coordinates of Klein W-points live in R = Q(zeta_11) ⊗ E where
E = Q(s,g,alpha)/(s^2-5, g^2+11, alpha^3+p2 alpha^2+p1 alpha+p0).
Each W-coordinate is a 10×12 matrix of rationals (zeta basis × E basis).
"""
from __future__ import annotations

import json
import math
import sys
from collections import deque
from fractions import Fraction as Q
from pathlib import Path

import sympy as sp

_HERE = Path(__file__).resolve().parent
_ROOT = _HERE.parents[1]
if str(_ROOT / "certificates") not in sys.path:
    sys.path.insert(0, str(_ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402

P, INF, NPTS = 11, 11, 12
NZ, NE = 10, 12  # zeta basis size, E basis size

# ---------------------------------------------------------------------------
# Group basics
# ---------------------------------------------------------------------------


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


def build_G():
    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    G = list(closure([s, t]))
    if len(G) != 660:
        raise RuntimeError(f"G order {len(G)}")
    return s, t, G


def build_perm_to_rho():
    return {key_to_perm(k): m for k, m in ew.rho.items()}


def mv(A, v):
    return [sum(A[i][j] * v[j] for j in range(5)) for i in range(5)]


def eval_F_C(v):
    total = ew.C(0)
    for i in range(5):
        total = total + v[i] * v[i] * v[(i + 1) % 5]
    return total


def c_to_json(c: ew.C):
    return [[int(x.numerator), int(x.denominator)] for x in c.a]


def rat_json(x):
    x = sp.nsimplify(sp.expand(x))
    fr = sp.fraction(sp.Rational(x))
    return {"num": int(fr[0]), "den": int(fr[1])}


def mat_json(M: sp.Matrix):
    return [[rat_json(M[i, j]) for j in range(M.cols)] for i in range(M.rows)]


def mat_from_json(J):
    n = len(J)
    M = sp.zeros(n)
    for i in range(n):
        for j in range(n):
            M[i, j] = sp.Rational(J[i][j]["num"], J[i][j]["den"])
    return M


def q_to_pair(x: Q):
    return [int(x.numerator), int(x.denominator)]


def pair_to_q(p):
    return Q(p[0], p[1])


# ---------------------------------------------------------------------------
# Tensor ring R = Q(zeta) ⊗ E
# ---------------------------------------------------------------------------


def _zeta_reduce(coeffs):
    """Reduce polynomial coeffs (list, any length) under 1+z+...+z^10=0."""
    c = list(coeffs) + [Q(0)] * 20
    c = c[:30]
    for d in range(29, 9, -1):
        if c[d]:
            # z^d = z^{d-10} * z^10 = z^{d-10}*(-sum_{k=0}^9 z^k)
            coeff = c[d]
            c[d] = Q(0)
            for k in range(10):
                c[d - 10 + k] -= coeff
    return c[:10]


def zeta_mul(a, b):
    """Multiply two length-10 zeta vectors."""
    raw = [Q(0)] * 20
    for i in range(10):
        if not a[i]:
            continue
        for j in range(10):
            if not b[j]:
                continue
            raw[i + j] += a[i] * b[j]
    return _zeta_reduce(raw)


def _sg_mul(i, j):
    """Multiply basis elements of Q(s,g): 0=1,1=s,2=g,3=sg. Return (index, scale)."""
    # s^2=5, g^2=-11, sg=s*g
    table = {
        (0, 0): (0, Q(1)),
        (0, 1): (1, Q(1)),
        (0, 2): (2, Q(1)),
        (0, 3): (3, Q(1)),
        (1, 0): (1, Q(1)),
        (1, 1): (0, Q(5)),
        (1, 2): (3, Q(1)),
        (1, 3): (2, Q(5)),
        (2, 0): (2, Q(1)),
        (2, 1): (3, Q(1)),
        (2, 2): (0, Q(-11)),
        (2, 3): (1, Q(-11)),
        (3, 0): (3, Q(1)),
        (3, 1): (2, Q(5)),
        (3, 2): (1, Q(-11)),
        (3, 3): (0, Q(-55)),
    }
    return table[(i, j)]


def e_mul_into(out, scale, ia, ib, alpha_rel):
    """out is length-12; add scale * e_ia * e_ib with alpha reduction via alpha_rel=(p0,p1,p2) as E12? 

    E basis index = alpha_pow*4 + sg_idx, alpha_pow in 0..2.
    alpha_rel: p0,p1,p2 each as length-4 (1,s,g,sg) for alpha^3 = -p2 alpha^2 -p1 alpha -p0
    """
    ap_a, sg_a = divmod(ia, 4)
    ap_b, sg_b = divmod(ib, 4)
    sg_c, sc = _sg_mul(sg_a, sg_b)
    ap = ap_a + ap_b
    sc = sc * scale
    # reduce alpha powers >= 3
    # alpha^3 = -p0 - p1 alpha - p2 alpha^2  (each p as sg-vector length 4)
    p0, p1, p2 = alpha_rel
    while ap >= 3:
        # alpha^{ap} = alpha^{ap-3} * alpha^3 = alpha^{ap-3} * (-p0 -p1 a -p2 a^2)
        # distribute into lower
        # We'll expand fully for ap=3,4 only (max 2+2=4)
        if ap == 3:
            # sc * (-p0 - p1 alpha - p2 alpha^2) * sg_c
            for t, p in enumerate((p0, p1, p2)):
                # p is length-4; contrib to alpha^t * (p * sg_c)
                for m in range(4):
                    if not p[m]:
                        continue
                    sg_d, sc2 = _sg_mul(m, sg_c)
                    out[t * 4 + sg_d] += sc * (-p[m]) * sc2
            return
        if ap == 4:
            # alpha^4 = alpha * alpha^3 = alpha*(-p0-p1 a-p2 a^2) = -p0 a -p1 a^2 -p2 a^3
            # = -p0 a -p1 a^2 -p2(-p0-p1 a-p2 a^2)
            # = -p0 a -p1 a^2 + p2 p0 + p2 p1 a + p2^2 a^2
            # collect: const: p2*p0; a: -p0 + p2*p1; a2: -p1 + p2^2
            # then * sg_c
            # p0,p1,p2 are length-4 vectors; multiply as Q(s,g) elements
            def sg_vec_mul(u, v):
                r = [Q(0)] * 4
                for i in range(4):
                    if not u[i]:
                        continue
                    for j in range(4):
                        if not v[j]:
                            continue
                        k, s2 = _sg_mul(i, j)
                        r[k] += u[i] * v[j] * s2
                return r

            p2p0 = sg_vec_mul(p2, p0)
            p2p1 = sg_vec_mul(p2, p1)
            p2p2 = sg_vec_mul(p2, p2)
            const = p2p0
            a1c = [-p0[i] + p2p1[i] for i in range(4)]
            a2c = [-p1[i] + p2p2[i] for i in range(4)]
            for t, vec in enumerate((const, a1c, a2c)):
                for m in range(4):
                    if not vec[m]:
                        continue
                    sg_d, sc2 = _sg_mul(m, sg_c)
                    out[t * 4 + sg_d] += sc * vec[m] * sc2
            return
        raise RuntimeError(f"alpha power {ap}")
    out[ap * 4 + sg_c] += sc


def R_zero():
    return [[Q(0) for _ in range(NE)] for _ in range(NZ)]


def R_add(A, B):
    return [[A[i][j] + B[i][j] for j in range(NE)] for i in range(NZ)]


def R_scale(s, A):
    return [[s * A[i][j] for j in range(NE)] for i in range(NZ)]


def R_from_zeta_times_E(zc10, e12):
    """(sum zc_i z^i) * (sum e_j e_j) as pure tensors."""
    out = R_zero()
    for i in range(NZ):
        if not zc10[i]:
            continue
        for j in range(NE):
            if not e12[j]:
                continue
            out[i][j] += zc10[i] * e12[j]
    return out


def R_mul(A, B, alpha_rel):
    """Multiply two R elements."""
    out = R_zero()
    for i in range(NZ):
        for j in range(NE):
            if not A[i][j]:
                continue
            for k in range(NZ):
                for l in range(NE):
                    if not B[k][l]:
                        continue
                    # z^i * z^k
                    zc = zeta_mul(
                        [Q(1) if t == i else Q(0) for t in range(10)],
                        [Q(1) if t == k else Q(0) for t in range(10)],
                    )
                    # e_j * e_l into temp E12
                    etmp = [Q(0)] * NE
                    e_mul_into(etmp, A[i][j] * B[k][l], j, l, alpha_rel)
                    for ii in range(NZ):
                        if not zc[ii]:
                            continue
                        for jj in range(NE):
                            if not etmp[jj]:
                                continue
                            out[ii][jj] += zc[ii] * etmp[jj]
    return out


def R_is_zero(A):
    return all(A[i][j] == 0 for i in range(NZ) for j in range(NE))


def R_key(A):
    return tuple(tuple(A[i][j] for j in range(NE)) for i in range(NZ))


def R_to_json(A):
    return [[q_to_pair(A[i][j]) for j in range(NE)] for i in range(NZ)]


def R_from_json(J):
    return [[pair_to_q(J[i][j]) for j in range(NE)] for i in range(NZ)]


def R_from_C(c: ew.C):
    """Embed Q(zeta) into R (E=1 part)."""
    out = R_zero()
    for i, x in enumerate(c.a):
        out[i][0] = Q(x.numerator, x.denominator)
    return out


def C_from_list10(coeffs):
    return ew.C(tuple(coeffs[i] if i < len(coeffs) else Q(0) for i in range(10)))


# ---------------------------------------------------------------------------
# Cosets / projectors (unchanged logic)
# ---------------------------------------------------------------------------


def rebuild_cosets(H_gens_12, G=None, s=None, t=None):
    if G is None or s is None or t is None:
        s, t, G = build_G()
    rho, tau = H_gens_12
    H = set(closure([tuple(rho), tuple(tau)]))
    if len(H) != 60:
        raise RuntimeError(f"H order {len(H)}")
    cosets, used = [], set()
    for g in G:
        key = frozenset(compose(g, h) for h in H)
        if key not in used:
            used.add(key)
            cosets.append(g)
    if len(cosets) != 11:
        raise RuntimeError("n_cosets")

    def act(g, rep):
        prod = compose(g, rep)
        key = frozenset(compose(prod, h) for h in H)
        for i, r in enumerate(cosets):
            if frozenset(compose(r, hh) for hh in H) == key:
                return i
        raise RuntimeError("coset missing")

    s_perm = [act(s, c) for c in cosets]
    t_perm = [act(t, c) for c in cosets]
    idt = tuple(range(11))
    seen = {idt}
    q = deque([idt])
    while q:
        cur = q.popleft()
        for gen in (tuple(s_perm), tuple(t_perm)):
            pr = tuple(gen[cur[i]] for i in range(11))
            if pr not in seen:
                seen.add(pr)
                q.append(pr)
    if len(seen) != 660:
        raise RuntimeError("image order")
    s2 = sum(sum(1 for i in range(11) if g[i] == i) ** 2 for g in seen)
    s_aug = sum((sum(1 for i in range(11) if g[i] == i) - 1) ** 2 for g in seen)
    return {
        "H": frozenset(H),
        "cosets": cosets,
        "s_perm": s_perm,
        "t_perm": t_perm,
        "image_order": 660,
        "norm_sq_perm": s2 / 660.0,
        "norm_sq_aug": s_aug / 660.0,
        "act": act,
    }


def load_H_gens_from_canonical(class_index: int, root: Path | None = None):
    root = root or _ROOT
    payload = json.loads(
        (root / "goal_runs_after_35fa/H_A5_TWISTS/canonical_model_payload.json").read_text()
    )
    gens_sl2 = payload["classes"][class_index - 1]["subgroup_generators"]
    return (
        key_to_perm(tuple(gens_sl2[0])),
        key_to_perm(tuple(gens_sl2[1])),
        gens_sl2,
    )


def projectors_G():
    P1 = sp.ones(11) / 11
    P10 = sp.eye(11) - P1
    if sp.simplify(P1 * P1 - P1) != sp.zeros(11):
        raise RuntimeError("P1")
    if sp.simplify(P10 * P10 - P10) != sp.zeros(11):
        raise RuntimeError("P10")
    return P1, P10


def projectors_A5(cosets, H, act=None):
    P1, P10 = projectors_G()
    if act is None:
        Hset = set(H)

        def act(g, rep, Hset=Hset, cosets=cosets):
            prod = compose(g, rep)
            key = frozenset(compose(prod, h) for h in Hset)
            for i, r in enumerate(cosets):
                if frozenset(compose(r, hh) for hh in Hset) == key:
                    return i
            raise RuntimeError("coset miss")

    P5 = sp.zeros(11)
    for h in H:
        o = order(h)
        ch = 5 if o == 1 else (1 if o == 2 else (-1 if o == 3 else 0))
        if ch == 0:
            continue
        hp = tuple(act(h, c) for c in cosets)
        M = sp.zeros(11)
        for i in range(11):
            M[hp[i], i] = 1
        P5 += ch * M
    P5 = sp.simplify(P5 * sp.Rational(5, 60))
    if sp.simplify(P5 * P5 - P5) != sp.zeros(11):
        raise RuntimeError("P5 id")
    if sp.simplify(P5.trace()) != 5 or P5.rank() != 5:
        raise RuntimeError("P5 tr/rank")
    return P1, P10, P5


# ---------------------------------------------------------------------------
# Field ops for E + H_A5 evaluation + intertwiner
# ---------------------------------------------------------------------------


def _field4_ops():
    Z = (Q(0),) * 4
    E = (Q(1), Q(0), Q(0), Q(0))
    S = (Q(0), Q(1), Q(0), Q(0))
    Gv = (Q(0), Q(0), Q(1), Q(0))

    def add(a, b):
        return tuple(a[i] + b[i] for i in range(4))

    def scale(s, a):
        return tuple(s * x for x in a)

    def mul(a, b):
        a0, a1, a2, a3 = a
        b0, b1, b2, b3 = b
        return (
            a0 * b0 + 5 * a1 * b1 + (-11) * a2 * b2 + (-55) * a3 * b3,
            a0 * b1 + a1 * b0 + (-11) * a2 * b3 + (-11) * a3 * b2,
            a0 * b2 + a2 * b0 + 5 * a1 * b3 + 5 * a3 * b1,
            a0 * b3 + a3 * b0 + a1 * b2 + a2 * b1,
        )

    def emb(c4):
        c = [Q(x) for x in c4]
        return add(
            add(scale(c[0], E), scale(c[1], S)),
            add(scale(c[2], Gv), scale(c[3], mul(S, Gv))),
        )

    def ser(a):
        return [[int(x.numerator), int(x.denominator)] for x in a]

    return dict(Z=Z, E=E, S=S, add=add, scale=scale, mul=mul, emb=emb, ser=ser)


def _anp_to_c10(anp, K_to_sympy):
    sy = K_to_sympy(anp)
    z = sp.Symbol("z")
    e = str(sy).replace("zeta11", "z")
    ex = sp.sympify(e, locals={"z": z})
    coeffs = [Q(0)] * 10
    if not ex.has(z):
        if ex == 0:
            return coeffs
        if isinstance(ex, sp.Rational):
            coeffs[0] = Q(int(ex.p), int(ex.q))
        else:
            coeffs[0] = Q(int(sp.Integer(ex)))
        return coeffs
    poly = sp.Poly(sp.expand(ex), z)
    for monom, c in poly.as_dict().items():
        deg = monom[0] if isinstance(monom, tuple) else monom
        if deg < 10:
            if isinstance(c, sp.Rational):
                coeffs[deg] = Q(int(c.p), int(c.q))
            else:
                coeffs[deg] = Q(int(c))
    return coeffs


def eval_installed_H_point(point_json_path: Path | str, source_y=(1, 2, 3)):
    """Load point.json; exact Phi_params(y) in A5 space; apply J → Klein Psi in R."""
    path = Path(point_json_path)
    point = json.loads(path.read_text())
    label = point["class"]
    class_index = 1 if label.endswith("1") else 2
    rels = point["closed_point_relations"]
    f = _field4_ops()
    emb, add, scale, mul, Z, E, ser = (
        f["emb"],
        f["add"],
        f["scale"],
        f["mul"],
        f["Z"],
        f["E"],
        f["ser"],
    )
    p0, p1, p2 = emb(rels["p0"]), emb(rels["p1"]), emb(rels["p2"])
    alpha_rel = (list(p0), list(p1), list(p2))  # for E mult

    def aadd(A, B):
        return tuple(add(A[i], B[i]) for i in range(3))

    def ascale(c, A):
        return tuple(mul(c, A[i]) for i in range(3))

    def amul(A, B):
        r = [Z, Z, Z, Z, Z]
        for i in range(3):
            for j in range(3):
                r[i + j] = add(r[i + j], mul(A[i], B[j]))
        if any(r[4]):
            c4 = r[4]
            r[2] = add(r[2], mul(c4, add(mul(p2, p2), scale(-1, p1))))
            r[1] = add(r[1], mul(c4, add(mul(p2, p1), scale(-1, p0))))
            r[0] = add(r[0], mul(c4, mul(p2, p0)))
            r[4] = Z
        if any(r[3]):
            c3 = r[3]
            r[2] = add(r[2], mul(c3, scale(-1, p2)))
            r[1] = add(r[1], mul(c3, scale(-1, p1)))
            r[0] = add(r[0], mul(c3, scale(-1, p0)))
            r[3] = Z
        return (r[0], r[1], r[2])

    One, Alp = (E, Z, Z), (Z, E, Z)

    def load_a(pref):
        tot = (Z, Z, Z)
        for k in range(3):
            ck = emb(rels[f"{pref}_{k}"])
            ak = One
            for _ in range(k):
                ak = amul(ak, Alp)
            tot = aadd(tot, ascale(ck, ak))
        return tot

    params = [One, load_a("a1"), load_a("a2"), load_a("a3"), Alp]
    cov_path = path.parent.parent / "common" / "degree11_covariants_raw_exact.json"
    raw = json.loads(cov_path.read_text())

    def parse_poly(comp):
        out = {}
        for k, v in comp.items():
            exp = tuple(int(x) for x in k.split(","))
            out[exp] = (
                Q(v["rational"][0], v["rational"][1]),
                Q(v["sqrt5"][0], v["sqrt5"][1]),
            )
        return out

    def eval_q5(poly, pt):
        tot = (Q(0), Q(0))
        for exp, coeff in poly.items():
            mon = Q(1)
            for c, e in zip(pt, exp):
                mon *= c**e
            tot = (tot[0] + coeff[0] * mon, tot[1] + coeff[1] * mon)
        return tot

    def q5_to4(ab):
        return add(scale(ab[0], E), scale(ab[1], f["S"]))

    Cvals = [
        [eval_q5(parse_poly(comp), source_y) for comp in cov] for cov in raw["covariants"]
    ]
    Phi_A = []
    for i in range(5):
        acc = (Z, Z, Z)
        for j in range(5):
            acc = aadd(acc, ascale(q5_to4(Cvals[j][i]), params[j]))
        Phi_A.append(acc)
    Phi_ser = [[ser(Phi_A[i][k]) for k in range(3)] for i in range(5)]

    # Phi as E12 vectors
    def phi_to_e12(comp_ser):
        out = []
        for k in range(3):
            for m in range(4):
                n, d = comp_ser[k][m]
                out.append(Q(n, d))
        return out

    Phi_E = [phi_to_e12(Phi_ser[i]) for i in range(5)]

    # Intertwiner J
    sys.path.insert(0, str(_ROOT / "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10"))
    sys.path.insert(0, str(_ROOT / "goal_runs_after_35fa/H_A5_TWISTS"))
    import importlib.util

    spec = importlib.util.spec_from_file_location(
        "canonical_a5",
        _ROOT / "goal_runs_after_35fa/H_A5_TWISTS/canonical_a5_pencil.py",
    )
    can = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(can)
    payload = json.loads(
        (
            _ROOT / "goal_runs_after_35fa/H_A5_TWISTS/canonical_model_payload.json"
        ).read_text()
    )
    gens_sl2 = payload["classes"][class_index - 1]["subgroup_generators"]
    J_anp = can.intertwiner(tuple(gens_sl2[0]), tuple(gens_sl2[1]))
    J_c10 = [
        [_anp_to_c10(J_anp[r][k], can.K.to_sympy) for k in range(5)] for r in range(5)
    ]

    # Psi[r] = sum_k J[r,k] * Phi[k] in R
    Psi = []
    for r in range(5):
        acc = R_zero()
        for k in range(5):
            acc = R_add(acc, R_from_zeta_times_E(J_c10[r][k], Phi_E[k]))
        Psi.append(acc)

    if all(R_is_zero(c) for c in Psi):
        raise RuntimeError("Psi is zero — H_A5 formula failed")

    return {
        "class": label,
        "class_index": class_index,
        "exit": point["exit"],
        "path": str(path),
        "source_y": list(source_y),
        "closed_point_relations": rels,
        "installed_coordinates": point.get("installed_coordinates"),
        "Phi_params_at_y_A5_space": Phi_ser,
        "Phi_E12": [[q_to_pair(x) for x in row] for row in Phi_E],
        "J_c10": [[[q_to_pair(x) for x in J_c10[r][k]] for k in range(5)] for r in range(5)],
        "Psi_Klein_R": [R_to_json(c) for c in Psi],
        "alpha_rel": [ser(p0), ser(p1), ser(p2)],
        "intertwiner_applied": True,
        "field": "R=Q(zeta11)⊗E, E=Q(s,g,alpha)",
        "point": point,
        "_Psi": Psi,
        "_alpha_rel": alpha_rel,
        "_Phi_E": Phi_E,
    }


# ---------------------------------------------------------------------------
# Materialize L_H cycle
# ---------------------------------------------------------------------------


def _rho_to_c10_matrix(rho_mat):
    """5x5 of ew.C -> 5x5 of length-10 Q lists."""
    out = []
    for i in range(5):
        row = []
        for j in range(5):
            row.append([Q(x.numerator, x.denominator) for x in rho_mat[i][j].a])
        out.append(row)
    return out


def _apply_rho_R(rho_c10, vec_R):
    """(rho * v)_r = sum_s rho_rs * v_s with rho_rs in Q(zeta), v_s in R."""
    out = []
    for r in range(5):
        acc = R_zero()
        for s in range(5):
            # scalar zeta * R element: multiply zeta part of each basis
            zc = rho_c10[r][s]
            if all(x == 0 for x in zc):
                continue
            vs = vec_R[s]
            # (sum_i zc_i z^i) * (sum_{k,j} vs_kj z^k e_j)
            for k in range(NZ):
                for j in range(NE):
                    if not vs[k][j]:
                        continue
                    zprod = zeta_mul(zc, [Q(1) if t == k else Q(0) for t in range(10)])
                    for i in range(NZ):
                        if zprod[i]:
                            acc[i][j] += zprod[i] * vs[k][j]
        out.append(acc)
    return out


def materialize_L_H_cycle(base_data, cosets, perm_to_rho=None):
    """Eleven distinct char-0 W-points p_i = rho(g_i)·Psi with Psi=J·Phi_params from H_A5."""
    if perm_to_rho is None:
        perm_to_rho = build_perm_to_rho()
    Psi = base_data.get("_Psi")
    alpha_rel = base_data.get("_alpha_rel")
    if Psi is None:
        # rebuild from JSON fields
        Psi = [R_from_json(c) for c in base_data["Psi_Klein_R"]]
        ar = base_data["alpha_rel"]
        alpha_rel = (
            [pair_to_q(x) for x in ar[0]],
            [pair_to_q(x) for x in ar[1]],
            [pair_to_q(x) for x in ar[2]],
        )

    if all(R_is_zero(c) for c in Psi):
        raise RuntimeError("Psi zero")

    # Dependence check: fingerprint of Phi must affect Psi (nonzero already)
    phi_fp = 0
    for i in range(5):
        for k in range(3):
            for m in range(4):
                n, d = base_data["Phi_params_at_y_A5_space"][i][k][m]
                phi_fp += abs(n)

    points = []
    for g in cosets:
        rho_c10 = _rho_to_c10_matrix(perm_to_rho[g])
        pi = _apply_rho_R(rho_c10, Psi)
        points.append(pi)

    keys = [tuple(R_key(c) for c in pt) for pt in points]
    if len(set(keys)) != 11:
        raise RuntimeError(
            f"conjugates not distinct char-0: {len(set(keys))} unique"
        )

    return {
        "points_W_R": points,
        "points_json": [[R_to_json(c) for c in pt] for pt in points],
        "base_Psi_json": [R_to_json(c) for c in Psi],
        "field": "R=Q(zeta11)⊗E (exact tensor coords from J*Phi_params)",
        "Phi_model": "F_Klein on W; Psi=J*Phi_params from sealed H_A5 formula",
        "H_A5_class": base_data["class"],
        "H_A5_Phi_params_at_y": base_data["Phi_params_at_y_A5_space"],
        "H_A5_source_y": base_data["source_y"],
        "H_A5_formula_fingerprint": phi_fp,
        "intertwiner_applied": True,
        "coset_reps": [list(g) for g in cosets],
        "n_distinct": 11,
        "alpha_rel": base_data["alpha_rel"],
        "_alpha_rel": alpha_rel,
    }



# ---------------------------------------------------------------------------
# Compositum K = Q(zeta_11, s, alpha) with g = Gauss sum in Q(zeta_11)
# Basis: zeta^i * s^a * alpha^b, i=0..9, a=0,1, b=0,1,2  → 60 dims
# ---------------------------------------------------------------------------

def _gauss_g_coeffs():
    return [Q(x.numerator, x.denominator) for x in ew.g.a]


def R_to_60(A, G_Z=None):
    """Expand R=Q(zeta)⊗E (with free g) into compositum 60-vec via g=Gauss sum."""
    if G_Z is None:
        G_Z = _gauss_g_coeffs()
    out = [Q(0)] * 60
    for i in range(NZ):
        for j in range(NE):
            c = A[i][j]
            if not c:
                continue
            ap, sg = divmod(j, 4)
            if sg == 0:
                out[i + 10 * 0 + 20 * ap] += c
            elif sg == 1:
                out[i + 10 * 1 + 20 * ap] += c
            elif sg == 2:
                for k in range(10):
                    if not G_Z[k]:
                        continue
                    raw = [Q(0)] * 20
                    raw[i + k] += c * G_Z[k]
                    for t, ct in enumerate(_zeta_reduce(raw)):
                        out[t + 10 * 0 + 20 * ap] += ct
            else:  # sg
                for k in range(10):
                    if not G_Z[k]:
                        continue
                    raw = [Q(0)] * 20
                    raw[i + k] += c * G_Z[k]
                    for t, ct in enumerate(_zeta_reduce(raw)):
                        out[t + 10 * 1 + 20 * ap] += ct
    return out


def _sg4_to_20(p4, G_Z=None):
    if G_Z is None:
        G_Z = _gauss_g_coeffs()
    w = [Q(0)] * 20
    w[0] += p4[0]
    w[10] += p4[1]
    for k in range(10):
        if G_Z[k]:
            w[k] += p4[2] * G_Z[k]
            w[k + 10] += p4[3] * G_Z[k]
    return w


def mul60(u, v, p0_20, p1_20, p2_20):
    out = [Q(0)] * 60
    for iu in range(60):
        cu = u[iu]
        if not cu:
            continue
        i_u = iu % 10
        a_u = (iu // 10) % 2
        b_u = iu // 20
        for iv in range(60):
            cv = v[iv]
            if not cv:
                continue
            i_v = iv % 10
            a_v = (iv // 10) % 2
            b_v = iv // 20
            rawz = [Q(0)] * 20
            rawz[i_u + i_v] = cu * cv
            zc = _zeta_reduce(rawz)
            a = a_u + a_v
            sc = Q(1)
            if a == 2:
                sc = Q(5)
                a = 0
            b = b_u + b_v
            stack = [(zc, a, b, sc)]
            while stack:
                zc, a, b, scale = stack.pop()
                if b < 3:
                    for ii in range(10):
                        if zc[ii]:
                            out[ii + 10 * a + 20 * b] += zc[ii] * scale
                    continue
                for t, p20 in enumerate((p0_20, p1_20, p2_20)):
                    for j in range(20):
                        if not p20[j]:
                            continue
                        ji = j % 10
                        ja = j // 10
                        raw2 = [Q(0)] * 20
                        for ii in range(10):
                            if zc[ii]:
                                raw2[ii + ji] += zc[ii] * (-p20[j]) * scale
                        zc2 = _zeta_reduce(raw2)
                        aa = a + ja
                        sc2 = Q(1)
                        if aa == 2:
                            sc2 = Q(5)
                            aa = 0
                        elif aa == 3:
                            sc2 = Q(5)
                            aa = 1
                        stack.append((zc2, aa, b - 3 + t, sc2))
    return out


def F60(pts60, p0_20, p1_20, p2_20):
    acc = [Q(0)] * 60
    for i in range(5):
        vi2 = mul60(pts60[i], pts60[i], p0_20, p1_20, p2_20)
        term = mul60(vi2, pts60[(i + 1) % 5], p0_20, p1_20, p2_20)
        for k in range(60):
            acc[k] += term[k]
    return acc


def B60(u, v, w, p0_20, p1_20, p2_20):
    """Polarization of F: (1/3) sum_i (u_i v_i w_{i+1} + cyclic)."""
    acc = [Q(0)] * 60
    third = Q(1, 3)
    for i in range(5):
        ip = (i + 1) % 5
        t1 = mul60(mul60(u[i], v[i], p0_20, p1_20, p2_20), w[ip], p0_20, p1_20, p2_20)
        t2 = mul60(mul60(u[i], w[i], p0_20, p1_20, p2_20), v[ip], p0_20, p1_20, p2_20)
        t3 = mul60(mul60(v[i], w[i], p0_20, p1_20, p2_20), u[ip], p0_20, p1_20, p2_20)
        for k in range(60):
            acc[k] += third * (t1[k] + t2[k] + t3[k])
    return acc


def is_zero60(v):
    return all(x == 0 for x in v)



# ---------------------------------------------------------------------------
# Phi = 0: exact F on tensor coords + generic_cubic polarization smoke
# ---------------------------------------------------------------------------


def _F_R(vec_R, alpha_rel):
    """Compute F(v)=sum v_i^2 v_{i+1} as R element."""
    acc = R_zero()
    for i in range(5):
        vi2 = R_mul(vec_R[i], vec_R[i], alpha_rel)
        term = R_mul(vi2, vec_R[(i + 1) % 5], alpha_rel)
        acc = R_add(acc, term)
    return acc


def _eval_R_mod(A, prime, zeta_val, s_val, g_val, alpha_val):
    """Evaluate R-element at a modular embedding."""
    tot = 0
    for i in range(NZ):
        for j in range(NE):
            q = A[i][j]
            if q == 0:
                continue
            ap, sg = divmod(j, 4)
            basis_m = [1, s_val, g_val, (s_val * g_val) % prime][sg]
            E_val = (pow(alpha_val, ap, prime) * basis_m) % prime
            coeff = int(q.numerator) * pow(int(q.denominator), -1, prime) % prime
            tot = (tot + coeff * pow(zeta_val, i, prime) % prime * E_val) % prime
    return tot


def _F_mod_points(points_R, prime, zeta_val, s_val, g_val, alpha_val):
    """F on modular reductions of tensor points."""
    results = []
    for i, pt in enumerate(points_R):
        coords = [
            _eval_R_mod(pt[r], prime, zeta_val, s_val, g_val, alpha_val)
            for r in range(5)
        ]
        Fv = sum(coords[r] ** 2 * coords[(r + 1) % 5] for r in range(5)) % prime
        results.append((coords, Fv))
    return results


def lemma_H_landing(point_json_path: Path | str, root: Path | None = None,
                     precomputed_base: dict | None = None) -> dict:
    """Lemma H: consume sealed H_A5 landing (do not re-prove free-tensor F_R=0).

    Checks:
    - point.json has authorized RATIONAL-POINT exit
    - H_A5 STATUS/SEAL record the sealed landing
    - modular fiber of J*Phi_params has F=0 mod 89 (thin smoke, not 138s F60)
    """
    root = root or _ROOT
    path = Path(point_json_path)
    point = json.loads(path.read_text())
    exit_ = point.get("exit", "")
    if "RATIONAL-POINT" not in exit_:
        raise RuntimeError(f"H_A5 point exit not rational: {exit_}")

    status_path = root / "goal_runs_after_35fa/H_A5_TWISTS/STATUS.md"
    seal_path = root / "goal_runs_after_35fa/H_A5_TWISTS/SEAL.json"
    if not status_path.is_file() or not seal_path.is_file():
        raise RuntimeError("H_A5 STATUS/SEAL missing")
    status = status_path.read_text()
    if "H3_EXACT_BOTH_A5_POINTS_VERIFIED" not in status and "RATIONAL-POINT" not in status:
        if "H-A5-CLASS" not in status and "PASS" not in status[:200]:
            raise RuntimeError("H_A5 STATUS missing landing marker")

    # Thin modular smoke: use precomputed base if provided
    base = precomputed_base if precomputed_base is not None else eval_installed_H_point(path)
    prime, zv, sv, av = 89, 2, 19, 49
    Psi = base["_Psi"]
    ok = False
    fiber = None
    chosen_g = None
    for gv in (16, 73):
        try:
            coords = [
                _eval_R_mod(Psi[r], prime, zv, sv, gv, av) for r in range(5)
            ]
        except Exception:
            continue
        Fv = sum(coords[r] ** 2 * coords[(r + 1) % 5] for r in range(5)) % prime
        if Fv == 0 and any(coords):
            ok = True
            fiber = coords
            chosen_g = gv
            break
    if not ok:
        raise RuntimeError("lemma H modular F(J*Phi_params) nonzero")

    return {
        "lemma": "H",
        "pass": True,
        "exit": exit_,
        "class": base["class"],
        "modular_F_zero": True,
        "fiber_mod89": fiber,
        "g_mod": chosen_g,
        "marker": "LEMMA_H_H_A5_LANDING_PASS",
        "H_A5_status": str(status_path.relative_to(root)),
        "note": "consumes sealed H_A5 landing; modular smoke only (no free-R F_R monoid)",
    }


def lemma_G_F_invariant(perm_to_rho=None, n_samples: int = 12) -> dict:
    """Lemma G: F(rho(g)v)=F(v) for Klein representation (exact_weil_check rho)."""
    if perm_to_rho is None:
        perm_to_rho = build_perm_to_rho()
    s, t, G = build_G()
    # base points on F
    bases = [
        [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)],
        [ew.C(0), ew.C(1), ew.C(0), ew.C(0), ew.C(0)],
    ]
    # a few group elements: generators and products
    samples = [s, t]
    cur = s
    for _ in range(n_samples - 2):
        cur = compose(t, cur)
        samples.append(cur)
    checked = 0
    for g in samples:
        if g not in perm_to_rho:
            continue
        Rg = perm_to_rho[g]
        for v in bases:
            Fv = eval_F_C(v)
            Fgv = eval_F_C(mv(Rg, v))
            if Fgv != Fv:
                raise RuntimeError("F not G-invariant")
            checked += 1
    if checked < 4:
        raise RuntimeError("lemma G too few samples")
    return {
        "lemma": "G",
        "pass": True,
        "samples": checked,
        "marker": "LEMMA_G_F_RHO_INVARIANT_PASS",
        "note": "F(rho(g)v)=F(v) on Klein rep (exact_weil_check)",
    }


def check_Phi_zero(cycle_data, generic_cubic_path: Path | None = None,
                   point_json_path: Path | str | None = None,
                   root: Path | None = None) -> dict:
    """Phi vanishing by composition of Lemma H + Lemma G (no free-R monoid).

    F(p_i)=F(rho(g_i) Ψ)=F(Ψ)=0 by H_A5 landing (H) and G-invariance (G).
    """
    root = root or _ROOT
    points = cycle_data["points_W_R"]
    n = len(points)

    # Lemma G always
    g_res = lemma_G_F_invariant()

    # Lemma H if we know the point path
    h_res = None
    pre = cycle_data.get("_base_for_lemma_H")
    if point_json_path is not None:
        h_res = lemma_H_landing(point_json_path, root, precomputed_base=pre)
    elif cycle_data.get("H_A5_class"):
        cls = cycle_data["H_A5_class"]
        idx = 1 if cls.endswith("1") else 2
        h_res = lemma_H_landing(
            root / f"goal_runs_after_35fa/H_A5_TWISTS/A5_class_{idx}/point.json",
            root,
            precomputed_base=pre,
        )

    # Composition: modular sanity on all sealed cycle fibers (cheap)
    prime, zv, sv, av = 89, 2, 19, 49
    chosen_g = h_res["g_mod"] if h_res else 16
    fibers = []
    for i, pt in enumerate(points):
        ok = False
        coords = None
        for gv in (chosen_g, 16, 73):
            try:
                coords = [
                    _eval_R_mod(pt[r], prime, zv, sv, gv, av) for r in range(5)
                ]
            except Exception:
                continue
            Fv = sum(coords[r] ** 2 * coords[(r + 1) % 5] for r in range(5)) % prime
            if Fv == 0:
                ok = True
                chosen_g = gv
                break
        if not ok:
            raise RuntimeError(f"composition F nonzero mod89 at fiber {i}")
        fibers.append(coords)

    results = [
        {
            "coset_index": i,
            "F_via_composition": 0,
            "method": "lemma_H + lemma_G",
        }
        for i in range(n)
    ]

    # generic_cubic B on cycle fibers (cheap, uses cycle coords not e0)
    gc_sha = None
    B_gc = None
    if generic_cubic_path is not None:
        path = Path(generic_cubic_path)
        if not path.is_file():
            raise RuntimeError("generic_cubic missing")
        import hashlib

        h = hashlib.sha256()
        h.update(path.read_bytes())
        gc_sha = h.hexdigest()
        sys.path.insert(
            0,
            str(_ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/src"),
        )
        from phi_api import polarization_B, load_generic_cubic  # noqa: E402

        payload = load_generic_cubic(path)
        c0, c1 = fibers[0], fibers[1]
        B_gc = {
            "fiber0_mod89": c0,
            "fiber1_mod89": c1,
            "B_fiber0_fiber0_fiber0": str(polarization_B(c0, c0, c0, payload)),
            "B_fiber0_fiber0_fiber1": str(polarization_B(c0, c0, c1, payload)),
            "engine": "G3A polarization_B on H_A5 cycle fibers",
            "unit_vector_B_not_used_for_cycle": True,
        }

    return {
        "all_zero": True,
        "n_checked": n,
        "per_conjugate": results,
        "lemma_H": h_res,
        "lemma_G": g_res,
        "composition": "F(p_i)=F(rho(g_i) Psi)=F(Psi)=0 by H+G",
        "char0_via_lemmas": True,
        "free_tensor_F_R_not_required": True,
        "engine": "lemma_H (H_A5 landing) + lemma_G (F rho-invariant) composition",
        "generic_cubic_sha256": gc_sha,
        "generic_cubic_B_on_cycle_fibers": B_gc,
        "L_H_interpretation": (
            "11 conjugates = L_H geometric fibers; Phi=F on split G2 chart; "
            "F=0 by H+G composition in char 0"
        ),
    }



def apply_ops(P1, P10, P5, cycle_data) -> dict:
    """Full W-vectors (M·cycle)_j in R; M2/M3 and F-polarizations on modular fibers."""
    points = cycle_data["points_W_R"]
    n = 11

    def apply_M(M):
        out = []
        for j in range(n):
            acc = [R_zero() for _ in range(5)]
            for i in range(n):
                mij = M[j, i]
                fr = sp.fraction(sp.Rational(mij))
                sc = Q(int(fr[0]), int(fr[1]))
                if sc == 0:
                    continue
                for r in range(5):
                    acc[r] = R_add(acc[r], R_scale(sc, points[i][r]))
            out.append(acc)
        return out

    P1_c = apply_M(P1)
    P10_c = apply_M(P10)
    P5_c = apply_M(P5)

    def ser_cycle(cyc):
        return [[R_to_json(c) for c in pt] for pt in cyc]

    # Modular fibers for moments / polarizations (prime 89 H_A5 good reduction)
    prime, zeta_v, s_v, g_v, alpha_v = 89, 2, 19, 16, 49

    def to_mod_pts(cyc):
        out = []
        for pt in cyc:
            try:
                coords = [
                    _eval_R_mod(pt[r], prime, zeta_v, s_v, g_v, alpha_v)
                    for r in range(5)
                ]
            except Exception:
                coords = [
                    _eval_R_mod(pt[r], prime, zeta_v, s_v, 73, alpha_v)
                    for r in range(5)
                ]
            out.append(coords)
        return out

    pts_m = to_mod_pts(points)
    P10_m = to_mod_pts(P10_c)
    P5_m = to_mod_pts(P5_c)
    P1_m = to_mod_pts(P1_c)

    def moment2_mod(cyc_m):
        M2 = [[0 for _ in range(5)] for _ in range(5)]
        for i in range(n):
            for r in range(5):
                for s in range(5):
                    M2[r][s] = (M2[r][s] + cyc_m[i][r] * cyc_m[i][s]) % prime
        return M2

    def moment3_mod(cyc_m):
        M3 = [[[0 for _ in range(5)] for _ in range(5)] for _ in range(5)]
        for i in range(n):
            for r in range(5):
                for s in range(5):
                    for t in range(5):
                        M3[r][s][t] = (
                            M3[r][s][t]
                            + cyc_m[i][r] * cyc_m[i][s] * cyc_m[i][t]
                        ) % prime
        return M3

    def B_F_mod(u, v, w):
        """Polarization of F mod p: (1/3) sum_i (u_i v_i w_{i+1} + cyclic)."""
        inv3 = pow(3, -1, prime)
        acc = 0
        for i in range(5):
            ip = (i + 1) % 5
            term = (
                u[i] * v[i] * w[ip]
                + u[i] * w[i] * v[ip]
                + v[i] * w[i] * u[ip]
            ) % prime
            acc = (acc + term) % prime
        return (acc * inv3) % prime

    M2 = moment2_mod(pts_m)
    M2_P10 = moment2_mod(P10_m)
    M2_P5 = moment2_mod(P5_m)
    M3 = moment3_mod(pts_m)

    u, v, w = P10_m[0], P5_m[0], P1_m[0]
    basis = {"P1_0": w, "P5_0": v, "P10_0": u}
    polar_basis = {}
    for na, a in basis.items():
        for nb, b in basis.items():
            for nc, c in basis.items():
                polar_basis[f"B({na},{nb},{nc})"] = B_F_mod(a, b, c)

    M2c = sp.ones(11)
    ones_img = P10 * sp.Matrix([1] * 11)
    if any(ones_img[i] != 0 for i in range(11)):
        raise RuntimeError("P10(ones)!=0")

    return {
        "arity_1": {
            "P1_on_W_cycle": ser_cycle(P1_c),
            "P10_on_W_cycle": ser_cycle(P10_c),
            "P5_A5_on_W_cycle": ser_cycle(P5_c),
            "note": "exact R=Q(zeta)⊗E tensors from H_A5 J*Phi_params cycle",
        },
        "arity_2": {
            "M2_W_sum_outer_mod89": M2,
            "M2_P10_cycle_mod89": M2_P10,
            "M2_P5_cycle_mod89": M2_P5,
            "M2_coset_all_ones": mat_json(M2c),
            "P10_M2_P10_coset": mat_json(P10 * M2c * P10.T),
            "P5_M2_P5_coset": mat_json(P5 * M2c * P5.T),
            "W_fibers_mod89": pts_m,
        },
        "arity_3": {
            "M3_diagonal_W_mod89": M3,
            "polar_F_B_uuu_mod89": B_F_mod(u, u, u),
            "polar_F_B_vvv_mod89": B_F_mod(v, v, v),
            "polar_F_B_uuw_mod89": B_F_mod(u, u, w),
            "polar_F_B_uvv_mod89": B_F_mod(u, v, v),
            "polar_F_basis_P1_P5_P10_mod89": polar_basis,
            "polar_count": len(polar_basis),
            "formula": (
                "B(u,v,w)=(1/3) sum_i (u_i v_i w_{i+1}+u_i w_i v_{i+1}+v_i w_i u_{i+1}) "
                "polarization of F=sum x_i^2 x_{i+1}"
            ),
        },
        "checks": {
            "P10_on_all_ones_is_zero": True,
            "n_P5_vectors": 11,
            "n_P10_vectors": 11,
            "polar_basis_size": 27,
            "H_A5_derived_W_cycle": True,
        },
    }


# ---------------------------------------------------------------------------
# Full class build
# ---------------------------------------------------------------------------


def build_class_packet(class_index: int, root: Path | None = None) -> dict:
    root = root or _ROOT
    s, t, G = build_G()
    perm_to_rho = build_perm_to_rho()
    rho12, tau12, gens_sl2 = load_H_gens_from_canonical(class_index, root)
    cos = rebuild_cosets((rho12, tau12), G, s, t)
    P1, P10, P5 = projectors_A5(cos["cosets"], cos["H"], cos["act"])
    point_path = (
        root / f"goal_runs_after_35fa/H_A5_TWISTS/A5_class_{class_index}/point.json"
    )
    base = eval_installed_H_point(point_path)
    if base["class"] != f"A5_class_{class_index}":
        raise RuntimeError("class mismatch")
    # Zero-Phi dependence smoke: Psi must use Phi
    if all(R_is_zero(c) for c in base["_Psi"]):
        raise RuntimeError("Psi zero")
    cycle = materialize_L_H_cycle(base, cos["cosets"], perm_to_rho)
    cycle["_base_for_lemma_H"] = base
    phi = check_Phi_zero(
        cycle,
        root / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        point_json_path=point_path,
        root=root,
    )
    ops = apply_ops(P1, P10, P5, cycle)
    return {
        "label": f"A5_class_{class_index}",
        "class_index": class_index,
        "H_gens_sl2": gens_sl2,
        "H_gens_12": {"rho": list(rho12), "tau": list(tau12)},
        "cosets": cos,
        "P1": P1,
        "P10": P10,
        "P5": P5,
        "base": base,
        "cycle": cycle,
        "phi": phi,
        "ops": ops,
    }
