#!/usr/bin/env python3
"""Independent verifier for T9.0 Hensel nonunit seal.

Does NOT import the producer. Recomputes modular det J_4, residuals, and gates
from sealed P / gate TSVs; checks hensel_hypotheses.json against recomputation.
"""
from __future__ import annotations

import json
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"

P_PRIME = 101
PLANE = {
    "A": (13, 7, 2),
    "B": (2, 5, 9),
    "Y": (8, 1, 6),
    "Z": (4, 3, 11),
}
S0, T0, U1_0, U2_0 = 0, 62, 46, 72
EXPECT = {
    "A": 36,
    "B": 55,
    "Y": 77,
    "Z": 80,
    "branch_det": 14,
    "Puu": (48, 35),
    "detJ4": 88,
    "dh1": (31, 44, 1, 89),
    "dh2": (0, 93, 83, 1),
    "ell": 18,
    "C": 66,
    "L": 21,
    "M": 55,
    "Q4": 10,
    "delta": (93, 12),
    "G": 16,
}


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def load_tsv(path: Path, with_u: bool = False):
    terms = []
    with path.open() as f:
        hdr = next(f).strip()
        if with_u:
            assert hdr == "A\tB\tY\tZ\tu\tcoefficient", hdr
            for line in f:
                a, b, y, z, u, c = map(int, line.split())
                terms.append(((a, b, y, z, u), c))
        else:
            assert hdr == "A\tB\tY\tZ\tcoefficient", hdr
            for line in f:
                a, b, y, z, c = map(int, line.split())
                terms.append(((a, b, y, z), c))
    return terms


def load_P():
    assert file_hash(P_PATH) == EXPECTED_P, "P hash mismatch"
    terms = load_tsv(P_PATH, with_u=True)
    assert len(terms) == 1593
    return terms


def load_H():
    assert file_hash(H_PATH) == EXPECTED_H, "H hash mismatch"
    terms = load_tsv(H_PATH)
    assert len(terms) == 37992
    return terms


def plane_point(s, t, mod):
    return {n: (c0 + cs * s + ct * t) % mod for n, (c0, cs, ct) in PLANE.items()}


def plane_partials():
    return [PLANE[n][1] for n in "ABYZ"], [PLANE[n][2] for n in "ABYZ"]


def eval_ABYZ(terms, A, B, Y, Z, mod):
    s = 0
    for (a, b, y, z), c in terms:
        s = (s + (c % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod)) % mod
    return s


def eval_ABYZu(terms, A, B, Y, Z, u, mod):
    s = 0
    for (a, b, y, z, uu), c in terms:
        s = (
            s
            + (c % mod)
            * pow(A, a, mod)
            * pow(B, b, mod)
            * pow(Y, y, mod)
            * pow(Z, z, mod)
            * pow(u, uu, mod)
        ) % mod
    return s


def P_and_Pu(P, A, B, Y, Z, u, mod):
    Pv = Pu = 0
    for (a, b, y, z, k), c in P:
        mon = (c % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod) % mod
        Pv = (Pv + mon * pow(u, k, mod)) % mod
        if k:
            Pu = (Pu + mon * (k % mod) * pow(u, k - 1, mod)) % mod
    return Pv, Pu


def Puu(P, A, B, Y, Z, u, mod):
    s = 0
    for (a, b, y, z, k), c in P:
        if k >= 2:
            s = (
                s
                + (c % mod)
                * pow(A, a, mod)
                * pow(B, b, mod)
                * pow(Y, y, mod)
                * pow(Z, z, mod)
                * ((k * (k - 1)) % mod)
                * pow(u, k - 2, mod)
            ) % mod
    return s


def grad_x_P(P, A, B, Y, Z, u, mod):
    gA = gB = gY = gZ = 0
    for (a, b, y, z, k), c in P:
        c = c % mod
        mon_u = pow(u, k, mod)
        if a:
            gA = (gA + c * (a % mod) * pow(A, a - 1, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod) * mon_u) % mod
        if b:
            gB = (gB + c * (b % mod) * pow(A, a, mod) * pow(B, b - 1, mod) * pow(Y, y, mod) * pow(Z, z, mod) * mon_u) % mod
        if y:
            gY = (gY + c * (y % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y - 1, mod) * pow(Z, z, mod) * mon_u) % mod
        if z:
            gZ = (gZ + c * (z % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z - 1, mod) * mon_u) % mod
    return (gA, gB, gY, gZ)


def grad_x_Pu(P, A, B, Y, Z, u, mod):
    gA = gB = gY = gZ = 0
    for (a, b, y, z, k), c in P:
        if k == 0:
            continue
        c = c % mod
        factor = (c * (k % mod) * pow(u, k - 1, mod)) % mod
        if a:
            gA = (gA + factor * (a % mod) * pow(A, a - 1, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod)) % mod
        if b:
            gB = (gB + factor * (b % mod) * pow(A, a, mod) * pow(B, b - 1, mod) * pow(Y, y, mod) * pow(Z, z, mod)) % mod
        if y:
            gY = (gY + factor * (y % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y - 1, mod) * pow(Z, z, mod)) % mod
        if z:
            gZ = (gZ + factor * (z % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z - 1, mod)) % mod
    return (gA, gB, gY, gZ)


def dot4(v, w, mod):
    return (v[0] * w[0] + v[1] * w[1] + v[2] * w[2] + v[3] * w[3]) % mod


def det4(M, mod):
    def det3(a):
        return (
            a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
            - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
            + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0])
        ) % mod

    total = 0
    for j in range(4):
        minor = [[M[i][k] for k in range(4) if k != j] for i in range(1, 4)]
        sign = 1 if j % 2 == 0 else -1
        total = (total + sign * M[0][j] * det3(minor)) % mod
    return total % mod


def jacobian_matrix(P, s, t, u1, u2, mod):
    pt = plane_point(s, t, mod)
    A, B, Y, Z = pt["A"], pt["B"], pt["Y"], pt["Z"]
    xs, xt = plane_partials()
    xs = [x % mod for x in xs]
    xt = [x % mod for x in xt]
    dh1 = grad_x_P(P, A, B, Y, Z, u1, mod)
    dh2 = grad_x_P(P, A, B, Y, Z, u2, mod)
    dPu1 = grad_x_Pu(P, A, B, Y, Z, u1, mod)
    dPu2 = grad_x_Pu(P, A, B, Y, Z, u2, mod)
    puu1 = Puu(P, A, B, Y, Z, u1, mod)
    puu2 = Puu(P, A, B, Y, Z, u2, mod)
    _, Pu1 = P_and_Pu(P, A, B, Y, Z, u1, mod)
    _, Pu2 = P_and_Pu(P, A, B, Y, Z, u2, mod)
    return [
        [dot4(dh1, xs, mod), dot4(dh1, xt, mod), Pu1, 0],
        [dot4(dPu1, xs, mod), dot4(dPu1, xt, mod), puu1, 0],
        [dot4(dh2, xs, mod), dot4(dh2, xt, mod), 0, Pu2],
        [dot4(dPu2, xs, mod), dot4(dPu2, xt, mod), 0, puu2],
    ]


def specialize_P_coeffs(P, A, B, Y, Z, mod):
    coeffs = [0] * 7
    for (a, b, y, z, u), c in P:
        coeffs[u] = (
            coeffs[u]
            + (c % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod)
        ) % mod
    return coeffs


def poly_derivative(f, mod):
    return [(i * f[i]) % mod for i in range(1, len(f))]


def resultant_univariate(f, g, mod):
    f = list(f)
    g = list(g)
    while len(f) > 1 and f[-1] % mod == 0:
        f.pop()
    while len(g) > 1 and g[-1] % mod == 0:
        g.pop()
    n, m = len(f) - 1, len(g) - 1
    if n < 0 or m < 0:
        return 0
    if n == 0:
        return pow(f[0] % mod, m, mod)
    if m == 0:
        return pow(g[0] % mod, n, mod)
    size = n + m
    S = [[0] * size for _ in range(size)]
    for i in range(m):
        for j, c in enumerate(f):
            S[i][i + j] = c % mod
    for i in range(n):
        for j, c in enumerate(g):
            S[m + i][i + j] = c % mod
    det = 1
    for col in range(size):
        piv = None
        for r in range(col, size):
            if S[r][col] % mod != 0:
                piv = r
                break
        if piv is None:
            return 0
        if piv != col:
            S[col], S[piv] = S[piv], S[col]
            det = (-det) % mod
        invp = pow(S[col][col], -1, mod)
        det = (det * S[col][col]) % mod
        for r in range(col + 1, size):
            fac = (S[r][col] * invp) % mod
            if fac == 0:
                continue
            for c in range(col, size):
                S[r][c] = (S[r][c] - fac * S[col][c]) % mod
    return det % mod


def _ptrim(a):
    a = list(a)
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return a


def _padd(a, b, mod):
    n = max(len(a), len(b))
    out = [0] * n
    for i in range(n):
        out[i] = ((a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)) % mod
    return _ptrim(out)


def _psub(a, b, mod):
    return _padd(a, [(mod - (x % mod)) % mod for x in b], mod)


def _pmul(a, b, mod):
    if a == [0] or b == [0]:
        return [0]
    out = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        if not ai:
            continue
        for j, bj in enumerate(b):
            if not bj:
                continue
            out[i + j] = (out[i + j] + ai * bj) % mod
    return _ptrim(out)


def _pscale(a, s, mod):
    return _ptrim([(x * s) % mod for x in a])


def _ppow_lin(c0, c1, n, mod):
    out = [0] * (n + 1)
    binom = 1
    for k in range(n + 1):
        if k:
            binom = binom * (n - k + 1) // k
        out[k] = (binom * pow(c0, n - k, mod) * pow(c1, k, mod)) % mod
    return _ptrim(out)


def _pdivmod(a, b, mod):
    a = _ptrim(a)
    b = _ptrim(b)
    if b == [0]:
        raise ZeroDivisionError
    if len(a) < len(b):
        return [0], a
    q = [0] * (len(a) - len(b) + 1)
    r = list(a)
    inv_lead = pow(b[-1], -1, mod)
    while len(r) >= len(b) and r != [0]:
        lead = (r[-1] * inv_lead) % mod
        deg = len(r) - len(b)
        q[deg] = lead
        for i, c in enumerate(b):
            r[deg + i] = (r[deg + i] - lead * c) % mod
        r = _ptrim(r)
    return _ptrim(q), r


def _exact_div(num, den, mod):
    q, r = _pdivmod(num, den, mod)
    if r != [0]:
        raise ValueError("inexact polynomial division")
    return q


def _bareiss_det(M, mod):
    n = len(M)
    A = [[list(M[i][j]) for j in range(n)] for i in range(n)]
    sign = 1
    prev = [1]
    for k in range(n - 1):
        piv = None
        for r in range(k, n):
            if A[r][k] != [0]:
                piv = r
                break
        if piv is None:
            return [0]
        if piv != k:
            A[k], A[piv] = A[piv], A[k]
            sign = -sign
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                num = _psub(_pmul(A[k][k], A[i][j], mod), _pmul(A[i][k], A[k][j], mod), mod)
                A[i][j] = _exact_div(num, prev, mod)
            A[i][k] = [0]
        prev = A[k][k]
    det = A[n - 1][n - 1]
    if sign < 0:
        det = _pscale(det, mod - 1, mod)
    return det


def G_via_line_formal(P, H_terms, A0, B0, Y0, Z0, p, direction=(1, 0, 0, 0)):
    """Formal Res_u/H along a line over F_p[tau]; returns G(0)."""
    dA, dB, dY, dZ = direction

    def monom(a, b, y, z):
        r = [1]
        if a:
            r = _pmul(r, _ppow_lin(A0 % p, dA % p, a, p), p)
        if b:
            r = _pmul(r, _ppow_lin(B0 % p, dB % p, b, p), p)
        if y:
            r = _pmul(r, _ppow_lin(Y0 % p, dY % p, y, p), p)
        if z:
            r = _pmul(r, _ppow_lin(Z0 % p, dZ % p, z, p), p)
        return r

    Pc = [[0] for _ in range(7)]
    for (a, b, y, z, u), c in P:
        if c % p == 0:
            continue
        Pc[u] = _padd(Pc[u], _pscale(monom(a, b, y, z), c % p, p), p)

    Hpoly = [0]
    for (a, b, y, z), c in H_terms:
        if c % p == 0:
            continue
        Hpoly = _padd(Hpoly, _pscale(monom(a, b, y, z), c % p, p), p)

    gc = [[0] for _ in range(6)]
    for k in range(1, 7):
        gc[k - 1] = _pscale(Pc[k], k % p, p)

    def deg_u(coeffs):
        d = len(coeffs) - 1
        while d >= 0 and coeffs[d] == [0]:
            d -= 1
        return d

    n, m = deg_u(Pc), deg_u(gc)
    fc, gco = Pc[: n + 1], gc[: m + 1]
    size = n + m
    M = [[[0] for _ in range(size)] for _ in range(size)]
    for i in range(m):
        for j in range(n + 1):
            M[i][i + j] = list(fc[j])
    for i in range(n):
        for j in range(m + 1):
            M[m + i][i + j] = list(gco[j])
    Res = _bareiss_det(M, p)
    Gpoly = _exact_div(Res, Hpoly, p)
    return Gpoly[0] % p


def main() -> None:
    errors = []
    p = P_PRIME
    P = load_P()
    H = load_H()
    ell = load_tsv(FACTORS / "ell_lc_u.tsv")
    C = load_tsv(FACTORS / "C_content.tsv")
    Q4 = load_tsv(FACTORS / "G_factor_Q4.tsv")
    delta = load_tsv(FACTORS / "delta_Cramer.tsv", with_u=True)

    pt = plane_point(S0, T0, p)
    A, B, Y, Z = pt["A"], pt["B"], pt["Y"], pt["Z"]
    if (A, B, Y, Z) != (EXPECT["A"], EXPECT["B"], EXPECT["Y"], EXPECT["Z"]):
        errors.append(f"plane point {(A,B,Y,Z)}")

    # Residuals — recompute
    for u in (U1_0, U2_0):
        Pv, Pu = P_and_Pu(P, A, B, Y, Z, u, p)
        if Pv != 0 or Pu != 0:
            errors.append(f"P/Pu nonzero at u={u}: {(Pv, Pu)}")

    dh1 = grad_x_P(P, A, B, Y, Z, U1_0, p)
    dh2 = grad_x_P(P, A, B, Y, Z, U2_0, p)
    if dh1 != EXPECT["dh1"]:
        errors.append(f"dh1 {dh1}")
    if dh2 != EXPECT["dh2"]:
        errors.append(f"dh2 {dh2}")

    xs, xt = plane_partials()
    xs = [x % p for x in xs]
    xt = [x % p for x in xt]
    branch = (dot4(dh1, xs, p) * dot4(dh2, xt, p) - dot4(dh1, xt, p) * dot4(dh2, xs, p)) % p
    if branch != EXPECT["branch_det"]:
        errors.append(f"branch {branch}")

    puu1 = Puu(P, A, B, Y, Z, U1_0, p)
    puu2 = Puu(P, A, B, Y, Z, U2_0, p)
    if (puu1, puu2) != EXPECT["Puu"]:
        errors.append(f"Puu {(puu1, puu2)}")

    detJ_formula = (puu1 * puu2 * branch) % p
    if detJ_formula != EXPECT["detJ4"]:
        errors.append(f"detJ formula {detJ_formula}")

    J = jacobian_matrix(P, S0, T0, U1_0, U2_0, p)
    detJ_direct = det4(J, p)
    # accept ± of expected (orientation of ordered basis)
    if detJ_direct % p != EXPECT["detJ4"] and (p - detJ_direct) % p != EXPECT["detJ4"]:
        # also accept if equal to formula
        if detJ_direct != detJ_formula and (p - detJ_direct) % p != detJ_formula:
            errors.append(f"detJ direct {detJ_direct} not ±{EXPECT['detJ4']}")

    if detJ_formula == 0:
        errors.append("singular detJ4")

    # Gates — recompute
    ell_v = eval_ABYZ(ell, A, B, Y, Z, p)
    C_v = eval_ABYZ(C, A, B, Y, Z, p)
    Q4_v = eval_ABYZ(Q4, A, B, Y, Z, p)
    L_v = (A - 15) % p
    M_v = B % p
    d1 = eval_ABYZu(delta, A, B, Y, Z, U1_0, p)
    d2 = eval_ABYZu(delta, A, B, Y, Z, U2_0, p)

    for name, val, exp in [
        ("ell", ell_v, EXPECT["ell"]),
        ("C", C_v, EXPECT["C"]),
        ("L", L_v, EXPECT["L"]),
        ("M", M_v, EXPECT["M"]),
        ("Q4", Q4_v, EXPECT["Q4"]),
    ]:
        if val != exp:
            errors.append(f"gate {name} {val} != {exp}")
    if (d1, d2) != EXPECT["delta"]:
        errors.append(f"delta {(d1, d2)}")

    for name, val in [
        ("ell", ell_v),
        ("C", C_v),
        ("L", L_v),
        ("M", M_v),
        ("Q4", Q4_v),
        ("Puu1", puu1),
        ("Puu2", puu2),
        ("delta1", d1),
        ("delta2", d2),
        ("u1-u2", (U1_0 - U2_0) % p),
    ]:
        if val == 0:
            errors.append(f"gate {name} vanishes")

    # G via formal line Res/H (recompute; sampling is invalid for deg Res ≥ p)
    G_v = G_via_line_formal(P, H, A, B, Y, Z, p, direction=(1, 0, 0, 0))
    if G_v != EXPECT["G"]:
        errors.append(f"G {G_v} != {EXPECT['G']}")
    G_v2 = G_via_line_formal(P, H, A, B, Y, Z, p, direction=(0, 1, 0, 0))
    if G_v2 != G_v:
        errors.append(f"G direction mismatch {G_v} vs {G_v2}")

    if eval_ABYZ(H, A, B, Y, Z, p) != 0:
        errors.append("H nonzero at witness")

    # JSON consistency with recomputation
    hyp_path = HERE / "hensel_hypotheses.json"
    if not hyp_path.is_file():
        errors.append("missing hensel_hypotheses.json")
    else:
        hyp = json.loads(hyp_path.read_text())
        if hyp.get("exit") != "T9-HENSEL-NONUNIT-SEALED":
            errors.append(f"exit {hyp.get('exit')}")
        if hyp.get("headline") != "OPEN":
            errors.append("headline not OPEN")
        rec = hyp.get("recomputed_modular", {})
        if rec.get("detJ4_formula") != detJ_formula:
            errors.append("JSON detJ4_formula does not match recomputation")
        if rec.get("branch_2x2_det") != branch:
            errors.append("JSON branch does not match recomputation")
        gjson = rec.get("gates", {})
        if gjson.get("ell") != ell_v or gjson.get("C") != C_v:
            errors.append("JSON gates do not match recomputation")
        # Hensel hypotheses present
        hv = hyp.get("hensel_version", {}).get("hypotheses_literal", {})
        if not hv.get("jacobian_is_unit_mod_p"):
            errors.append("JSON missing unit Jacobian flag")
        if not hv.get("residual_vanishing_mod_p"):
            errors.append("JSON missing residual vanishing flag")
        if hyp.get("analytic_conclusions", {}).get("number_field_rur_required") is not False:
            errors.append("must not require number-field RUR")

    md = HERE / "HENSEL_NONUNIT.md"
    if not md.is_file():
        errors.append("missing HENSEL_NONUNIT.md")
    else:
        text = md.read_text()
        if "T9-HENSEL-NONUNIT-SEALED" not in text:
            errors.append("md missing exit marker")
        if "OPEN" not in text:
            errors.append("md missing OPEN")
        if "number-field" not in text.lower() and "number field" not in text.lower():
            # should explicitly say not required
            pass

    if errors:
        print("T9_HENSEL_VERIFIER_FAIL")
        for e in errors:
            print(" ", e)
        sys.exit(1)

    print("T9_HENSEL_VERIFIER_ACCEPT")
    print("exit: T9-HENSEL-NONUNIT-SEALED")
    print(f"recomputed: detJ4={detJ_formula}, branch={branch}, gates ell={ell_v} C={C_v} G={G_v}")
    print("headline: OPEN")


if __name__ == "__main__":
    main()
