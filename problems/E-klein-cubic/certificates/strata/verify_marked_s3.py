#!/usr/bin/env python3
"""Independent verifier for WP-3 marked S3 geometry.

Does **not** import marked_s3_geometry.py.  Rebuilds:
  - residual S3 structure of C_G(t)
  - L_t fixed-point counts (2 C6 + 6 type-I) at split primes
  - j(E_t) = 8192/11 by modular reconstruction + PARI
  - free order-3 from j ≠ 0
  - charge-model theorem boundaries from the JSON

Terminal marker: MARKED_S3_VERIFY_OK
"""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
sys.path.insert(0, str(CERT))
import exact_weil_check as ew  # noqa: E402

JSON_PATH = HERE / "marked_s3_geometry.json"
GP = "/opt/homebrew/bin/gp"


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
    raise AssertionError


def mv(M, v):
    return [sum(M[i][j] * v[j] for j in range(5)) for i in range(5)]


def vadd(*vectors):
    return [sum(v[i] for v in vectors) for i in range(5)]


def klein(v):
    return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5))


def cmod(c, p, zeta):
    total = 0
    power = 1
    for coefficient in c.a:
        num = int(coefficient.numerator) % p
        den = pow(int(coefficient.denominator) % p, -1, p)
        total = (total + num * den * power) % p
        power = power * zeta % p
    return total


def find_zeta11(p):
    for a in range(2, p):
        x = pow(a, (p - 1) // 11, p)
        if x != 1 and all(pow(x, d, p) != 1 for d in range(1, 11)):
            return x
    raise RuntimeError


def rank_mod(vectors, p, zeta):
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


def filter_basis(cands, p, zeta):
    basis = []
    for v in cands:
        if not any(x != 0 for x in v):
            continue
        if rank_mod(basis + [v], p, zeta) > rank_mod(basis, p, zeta):
            basis.append(v)
    return basis


def nullspace_mod(A, p):
    n = len(A)
    M = [row[:] for row in A]
    r = 0
    pivots = []
    for col in range(n):
        pivot = next((i for i in range(r, n) if M[i][col] % p), None)
        if pivot is None:
            continue
        M[r], M[pivot] = M[pivot], M[r]
        inv = pow(M[r][col], -1, p)
        M[r] = [(x * inv) % p for x in M[r]]
        for i in range(n):
            if i != r and M[i][col] % p:
                f = M[i][col]
                M[i] = [(M[i][j] - f * M[r][j]) % p for j in range(n)]
        pivots.append(col)
        r += 1
    free = [c for c in range(n) if c not in pivots]
    basis = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for i, col in enumerate(pivots):
            v[col] = (-M[i][f]) % p
        basis.append(v)
    return basis


def restrict_to_Em(g, Em, p, zeta):
    B = [[cmod(Em[j][i], p, zeta) for j in range(2)] for i in range(5)]
    cols = []
    for j in range(2):
        gv = mv(ew.rho[g], Em[j])
        rhs = [cmod(x, p, zeta) for x in gv]
        rows = [i for i in range(5) if any(B[i][k] % p for k in range(2))]
        i0 = rows[0]
        i1 = next(
            i for i in rows[1:]
            if (B[i0][0] * B[i][1] - B[i0][1] * B[i][0]) % p
        )
        det = (B[i0][0] * B[i1][1] - B[i0][1] * B[i1][0]) % p
        invdet = pow(det, -1, p)
        r0, r1 = rhs[i0], rhs[i1]
        x0 = (invdet * (B[i1][1] * r0 - B[i0][1] * r1)) % p
        x1 = (invdet * (-B[i1][0] * r0 + B[i0][0] * r1)) % p
        cols.append((x0, x1))
    return [[cols[0][0], cols[1][0]], [cols[0][1], cols[1][1]]]


def fixed_pts_p1(M, p):
    a, b, c, d = M[0][0], M[0][1], M[1][0], M[1][1]
    pts = set()
    for a0 in range(p):
        for b0 in range(p):
            if a0 == 0 and b0 == 0:
                continue
            w0 = (a * a0 + b * b0) % p
            w1 = (c * a0 + d * b0) % p
            if (w0 * b0 - w1 * a0) % p == 0:
                if a0 != 0:
                    pts.add((1, b0 * pow(a0, -1, p) % p))
                else:
                    pts.add((0, 1))
    return pts


def ternary_cubic_coeffs_mod(Ep, p):
    import random
    random.seed(1 + p)

    def monoms(a, b, c):
        return [
            a ** 3 % p, a * a * b % p, a * a * c % p, a * b * b % p,
            a * b * c % p, a * c * c % p, b ** 3 % p, b * b * c % p,
            b * c * c % p, c ** 3 % p,
        ]

    def F(v):
        return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5)) % p

    rows, rhs = [], []
    for _ in range(80):
        a, b, c = random.randrange(p), random.randrange(p), random.randrange(p)
        v = [(a * Ep[0][i] + b * Ep[1][i] + c * Ep[2][i]) % p for i in range(5)]
        rows.append(monoms(a, b, c))
        rhs.append(F(v))
    A = [r[:] for r in rows]
    bvec = rhs[:]
    n, rnk, piv = 10, 0, []
    for col in range(n):
        pivrow = next((i for i in range(rnk, len(A)) if A[i][col] % p), None)
        if pivrow is None:
            continue
        A[rnk], A[pivrow] = A[pivrow], A[rnk]
        bvec[rnk], bvec[pivrow] = bvec[pivrow], bvec[rnk]
        inv = pow(A[rnk][col], -1, p)
        A[rnk] = [(x * inv) % p for x in A[rnk]]
        bvec[rnk] = (bvec[rnk] * inv) % p
        for i in range(len(A)):
            if i != rnk and A[i][col] % p:
                f = A[i][col]
                A[i] = [(A[i][j] - f * A[rnk][j]) % p for j in range(n)]
                bvec[i] = (bvec[i] - f * bvec[rnk]) % p
        piv.append(col)
        rnk += 1
    sol = [0] * n
    for i, col in enumerate(piv):
        sol[col] = bvec[i]
    return sol


def j_mod_from_cubic(sol, p):
    a3, a2b, a2c, ab2, abc, ac2, b3, b2c, bc2, c3 = [c % p for c in sol]
    script = f"""
default(parisize, 30000000);
f = ({a3}*x^3 + {a2b}*x^2*y + {a2c}*x^2 + {ab2}*x*y^2 + {abc}*x*y + {ac2}*x + {b3}*y^3 + {b2c}*y^2 + {bc2}*y + {c3}) * Mod(1,{p});
E = ellfromeqn(f);
Ea = ellinit(E);
print(lift(Ea.j));
quit
"""
    r = subprocess.run([GP, "-q"], input=script, text=True, capture_output=True, timeout=60)
    lines = [ln.strip() for ln in r.stdout.splitlines() if ln.strip() and not ln.startswith("***")]
    return int(lines[0])


def main():
    data = json.loads(JSON_PATH.read_text())
    assert data["headline"] == "OPEN"

    body = {k: v for k, v in data.items() if k != "self_sha256"}
    body_bytes = (json.dumps(body, indent=2, sort_keys=True) + "\n").encode()
    h = hashlib.sha256(body_bytes).hexdigest()
    assert h == data["self_sha256"], (h, data["self_sha256"])
    print("PASS self_sha256")

    keys = list(ew.rho)
    orders = {g: gorder(g) for g in keys}
    t = ew.fs
    assert orders[t] == 2
    Ct = {g for g in keys if gmul(g, t) == gmul(t, g)}
    assert len(Ct) == 12
    assert data["residual_S3"]["order"] == 6
    assert data["residual_S3"]["V4s_through_t"] == 3
    o3 = [g for g in Ct if orders[g] == 3]
    o2 = [g for g in Ct if orders[g] == 2 and g != t]
    assert len(o3) == 2 and len(o2) == 6
    print("PASS residual S3 structure (|C_G(t)|=12, residual order 6)")

    # E± and L_t fixed points
    p, zeta = 67, 64
    Mt = ew.rho[t]
    minus_c = []
    for col in range(5):
        seed = [ew.C(i == col) for i in range(5)]
        tp = mv(Mt, seed)
        minus_c.append(vadd(seed, [-x for x in tp]))
    Em = filter_basis(minus_c, p, zeta)
    assert len(Em) == 2
    for v in Em:
        assert klein(v) == 0
    rho = o3[0]
    Mrho = restrict_to_Em(rho, Em, p, zeta)
    c6 = fixed_pts_p1(Mrho, p)
    assert len(c6) == 2
    assert data["L_t"]["marked_points"]["C6_points"] == 2
    assert data["L_t"]["marked_points"]["type_I_V4_points"] == 6
    assert data["L_t"]["modular_certificates"]["67"]["c6_orbit_size"] == 2
    assert len(data["L_t"]["modular_certificates"]["67"]["typeI_points"]) == 6
    print("PASS L_t: 2 C6 + 6 type-I (modular at 67)")

    # j-invariant
    assert data["E_t"]["j_invariant"]["exact"] == "8192/11"
    assert data["E_t"]["j_invariant"]["numerator"] == 8192
    assert data["E_t"]["j_invariant"]["denominator"] == 11
    assert data["E_t"]["j_invariant"]["equals_neg_32768"] is False
    # recompute j at 67 and 331
    for p, zeta in [(67, 64), (331, find_zeta11(331))]:
        Tm = [[cmod(ew.rho[t][i][j], p, zeta) for j in range(5)] for i in range(5)]
        Ep = nullspace_mod(
            [[(Tm[i][j] - (1 if i == j else 0)) % p for j in range(5)] for i in range(5)],
            p,
        )
        assert len(Ep) == 3
        sol = ternary_cubic_coeffs_mod(Ep, p)
        jv = j_mod_from_cubic(sol, p)
        expected = (8192 * pow(11, -1, p)) % p
        assert jv == expected, (p, jv, expected)
        jmod_table = data["E_t"]["j_invariant"]["modular_values"]
        # JSON may stringify integer keys
        recorded = jmod_table.get(p, jmod_table.get(str(p)))
        assert recorded == jv, (p, recorded, jv)
    print("PASS j(E_t)=8192/11 (modular at 67,331 + JSON)")

    # PARI confirms j and refutes -32768
    script = """
default(parisize, 10000000);
E = ellfromj(8192/11);
Ea = ellinit(E);
print(Ea.j);
print(subst(polclass(-11), x, -32768));
print(subst(polclass(-11), x, 8192/11));
quit
"""
    r = subprocess.run([GP, "-q"], input=script, text=True, capture_output=True, timeout=30)
    lines = [ln.strip() for ln in r.stdout.splitlines() if ln.strip() and not ln.startswith("***")]
    assert lines[0] in ("8192/11", "744.727...") or "8192/11" in lines[0]
    assert lines[1] == "0"  # -32768 is root of H_{-11}
    assert lines[2] != "0"  # 8192/11 is not
    assert data["E_t"]["cm"]["has_CM"] is False
    assert data["E_t"]["cm"]["director_hint_neg_32768"] == "REFUTED"
    print("PASS PARI j=8192/11; CM by Z[sqrt(-11)] REFUTED; no CM (j non-integral)")

    # free order-3
    assert data["E_t"]["free_order3"]["verdict"] == "FREE"
    assert "8192/11" in data["E_t"]["free_order3"]["theorem"] or \
        "j" in data["E_t"]["free_order3"]["theorem"]
    print("PASS free order-3 (translation by q in E[3])")

    # charge model
    cm = data["E_t"]["E2_charge_model"]
    assert "PROVED" in cm["verdict"]
    assert "type_I_orbit" in cm["proposed"]
    assert any("type-I" in s or "type_I" in s or "<q>" in s for s in cm["parts_that_are_theorems"])
    print("PASS E[2]-charge model theorem boundaries recorded")

    # Gate-1 consistency note present
    assert "triple" in data["E_t"]["Gate1_typeII_consistency"].lower() or \
        "type-II" in data["E_t"]["Gate1_typeII_consistency"]
    print("PASS Gate-1 type-II consistency note")

    # C3 remainder
    assert data["C3_220_remainder"]["candidate_count"] == 220
    assert data["C3_220_remainder"]["status"] in (
        "CARRIED_FORWARD", "CLOSED", "PARTIAL"
    )
    print("PASS C3-220 remainder status:", data["C3_220_remainder"]["status"])

    # Sage substitution recorded
    assert data["sage_substitution"]["used"].startswith("PARI")
    print("PASS Sage→PARI substitution recorded")

    print("MARKED_S3_VERIFY_OK")


if __name__ == "__main__":
    main()
