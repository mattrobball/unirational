#!/usr/bin/env python3
"""Independent verifier for WP-2 normal_characters.json.

Does **not** import normal_characters.py.  Rebuilds the four regression
targets from certificates/exact_weil_check.py and checks that the JSON
records matching data for every mandatory orbit type.

Terminal marker: NORMAL_CHARACTERS_VERIFY_OK
"""

from __future__ import annotations

import hashlib
import json
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
sys.path.insert(0, str(CERT))
import exact_weil_check as ew  # noqa: E402

JSON_PATH = HERE / "normal_characters.json"


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


def conjugate(g, h):
    return gmul(gmul(g, h), ginv(g))


def normalizer(H, keys):
    H = set(H)
    return {g for g in keys if {conjugate(g, h) for h in H} == H}


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


def cmod(c, p=67, zeta=64):
    total = 0
    power = 1
    for coefficient in c.a:
        num = int(coefficient.numerator) % p
        den = pow(int(coefficient.denominator) % p, -1, p)
        total = (total + num * den * power) % p
        power = power * zeta % p
    return total


def rank_mod(vectors, p=67, zeta=64):
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


def filter_basis(cands):
    basis = []
    for v in cands:
        if not any(x != 0 for x in v):
            continue
        trial = basis + [v]
        if rank_mod(trial) > rank_mod(basis):
            basis.append(v)
    return basis


def joint_space(z, s, eps, eta):
    cands = []
    for col in range(5):
        seed = [ew.C(i == col) for i in range(5)]
        first = vadd(seed, [eta * x for x in mv(ew.rho[s], seed)])
        proj = vadd(first, [eps * x for x in mv(ew.rho[z], first)])
        if any(x != 0 for x in proj):
            cands.append(proj)
    return filter_basis(cands)


def main():
    data = json.loads(JSON_PATH.read_text())
    assert data["headline"] == "OPEN"

    # self-hash of body
    body = {k: v for k, v in data.items() if k != "self_sha256"}
    body_bytes = (json.dumps(body, indent=2, sort_keys=True) + "\n").encode()
    h = hashlib.sha256(body_bytes).hexdigest()
    assert h == data["self_sha256"], (h, data["self_sha256"])

    keys = list(ew.rho)
    orders = {g: gorder(g) for g in keys}
    involutions = [g for g in keys if orders[g] == 2]

    # ---- Regression 1: involution (3,2) ----
    t = ew.fs
    assert orders[t] == 2
    assert trace(ew.rho[t]) == ew.C(1)
    Mt = ew.rho[t]
    plus_c, minus_c = [], []
    for col in range(5):
        seed = [ew.C(i == col) for i in range(5)]
        tp = mv(Mt, seed)
        plus_c.append(vadd(seed, tp))
        minus_c.append(vadd(seed, [-x for x in tp]))
    Ep = filter_basis(plus_c)
    Em = filter_basis(minus_c)
    assert len(Ep) == 3 and len(Em) == 2
    for v in Em:
        assert klein(v) == 0
    assert data["regressions"]["involution_dims_Eplus_Eminus"]["status"] == "PASS"
    assert data["regressions"]["involution_dims_Eplus_Eminus"]["computed"] == [3, 2]

    # ---- Regression 2: V4 joint dims (2,1,1,1) ----
    z = t
    s = next(g for g in involutions if g != z and gmul(g, z) == gmul(z, g))
    r = gmul(z, s)
    V4 = {ew.fone, z, s, r}
    A4 = normalizer(V4, keys)
    assert len(A4) == 12
    A = joint_space(z, s, 1, 1)
    B = joint_space(z, s, 1, -1)
    C = joint_space(z, s, -1, 1)
    D = joint_space(z, s, -1, -1)
    assert (len(A), len(B), len(C), len(D)) == (2, 1, 1, 1)
    assert data["regressions"]["V4_joint_character_dims"]["status"] == "PASS"
    dims = data["regressions"]["V4_joint_character_dims"]["computed"]
    assert dims["A_triv"] == 2 and dims["B_chi_z"] == 1
    assert dims["C_chi_s"] == 1 and dims["D_chi_r"] == 1

    # ---- Regression 3: triangle ----
    Lz = filter_basis(C + D)
    Ls = filter_basis(B + D)
    Lr = filter_basis(B + C)
    assert len(Lz) == 2 and len(Ls) == 2 and len(Lr) == 2
    assert rank_mod(filter_basis(Ls + Lr)) == 3  # meet dim 1
    assert rank_mod(filter_basis(Lz + Lr)) == 3
    assert rank_mod(filter_basis(Lz + Ls)) == 3
    assert rank_mod(filter_basis(Ls + B)) == 2 and rank_mod(filter_basis(Lr + B)) == 2
    assert klein(B[0]) == 0 and klein(C[0]) == 0 and klein(D[0]) == 0
    assert data["regressions"]["V4_minus_lines_triangle"]["status"] == "PASS"

    # Tangent character at type-I: O(1)=chi_z, T_X = three nontrivial chars
    # Verify scalar action of V4 on B
    def scalar_pm1(v, h):
        Mv = mv(ew.rho[h], v)
        if Mv == v:
            return 1
        if Mv == [-x for x in v]:
            return -1
        raise AssertionError

    assert scalar_pm1(B[0], z) == 1
    assert scalar_pm1(B[0], s) == -1
    assert scalar_pm1(B[0], r) == -1
    # JSON records T_yX = chi_z ⊕ chi_s ⊕ chi_r
    tdata = data["strata"]["V4_type_I_point"]["tangent_data"]["T_yX_as_V4_module"]
    assert "chi_z" in tdata["decomposition"] and "chi_s" in tdata["decomposition"]
    assert "chi_r" in tdata["decomposition"]
    assert tdata["dimension"] == 3

    # ---- Regression 4: D10, D12, A4 off X ----
    pkey = next(k for k, M in ew.rho.items() if M == ew.P)
    C5 = {gpow(pkey, i) for i in range(5)}
    D10 = normalizer(C5, keys)
    v_d10 = [ew.C(1) for _ in range(5)]
    assert all(proportional(mv(ew.rho[h], v_d10), v_d10) for h in D10)
    assert klein(v_d10) == ew.C(5)

    c3gen = gmul(ew.fs, ew.ft)
    C3 = {gpow(c3gen, i) for i in range(3)}
    D12 = normalizer(C3, keys)
    e0 = [ew.C(i == 0) for i in range(5)]
    v_d12 = vadd(*(mv(ew.rho[h], e0) for h in C3))
    assert all(proportional(mv(ew.rho[h], v_d12), v_d12) for h in D12)
    assert klein(v_d12) != 0

    # A4 lines via w^2+w+1
    r3 = next(g for g in A4 if orders[g] == 3)
    u = vadd(*(mv(ew.rho[h], e0) for h in V4))
    if not any(x != 0 for x in u):
        e1 = [ew.C(i == 1) for i in range(5)]
        u = vadd(*(mv(ew.rho[h], e1) for h in V4))
    ru = mv(ew.rho[r3], u)
    r2u = mv(ew.rho[r3], ru)

    class Cyc3:
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

        def __mul__(self, other):
            other = Cyc3(other)
            return Cyc3(self.a * other.a - self.b * other.b,
                        self.a * other.b + self.b * other.a - self.b * other.b)

        __rmul__ = __mul__

        def is_zero(self):
            return self.a == ew.C(0) and self.b == ew.C(0)

    v_w = [Cyc3(u[i]) + Cyc3(-ru[i], -ru[i]) + Cyc3(0, r2u[i]) for i in range(5)]
    v_w2 = [Cyc3(u[i]) + Cyc3(0, ru[i]) + Cyc3(-r2u[i], -r2u[i]) for i in range(5)]
    f_w = sum(v_w[i] * v_w[i] * v_w[(i + 1) % 5] for i in range(5))
    f_w2 = sum(v_w2[i] * v_w2[i] * v_w2[(i + 1) % 5] for i in range(5))
    assert not f_w.is_zero() and not f_w2.is_zero()
    assert data["regressions"]["D10_D12_A4_off_X"]["status"] == "PASS"
    assert data["strata"]["D10_point"]["on_X"] is False
    assert data["strata"]["D12_point"]["on_X"] is False
    assert data["strata"]["A4_a_point"]["on_X"] is False
    assert data["strata"]["A4_b_point"]["on_X"] is False

    # ---- Mandatory orbit types present ----
    mandatory = [
        "C2_plane", "C2_line", "V4_line", "C3_line",
        "D10_point", "D12_point",
        "C6_line_point", "C6_plane_point",
        "V4_type_I_point", "V4_type_II_point",
        "A4_a_point", "A4_b_point",
        "C5_a_point", "C5_b_point", "C11_point",
    ]
    for lab in mandatory:
        assert lab in data["strata"], lab
        entry = data["strata"][lab]
        assert "splitting_field" in entry or "O_Y1_character" in entry

    # residual structures
    assert data["strata"]["C2_plane"]["residual_N_over_H"]["abstract"] == "S3"
    assert data["strata"]["C2_line"]["residual_N_over_H"]["abstract"] == "S3"
    assert data["strata"]["V4_line"]["residual_N_over_H"]["abstract"] == "C3"
    assert data["strata"]["C2_line"]["on_X"]["identical_containment"] is True
    assert data["strata"]["V4_type_II_point"]["incidence"]["elliptics"] == 3

    # C5 on X
    assert data["strata"]["C5_a_point"]["on_X"] is True
    assert data["strata"]["C5_b_point"]["on_X"] is True
    assert data["strata"]["C11_point"]["on_X"] is True

    print("PASS self_sha256")
    print("PASS involution (3,2)")
    print("PASS V4 joint (2,1,1,1)")
    print("PASS V4 minus-line triangle")
    print("PASS type-I T_X = three nontrivial V4 characters")
    print("PASS D10, D12, both A4 off X")
    print("PASS all mandatory orbit types present")
    print("NORMAL_CHARACTERS_VERIFY_OK")


if __name__ == "__main__":
    main()
