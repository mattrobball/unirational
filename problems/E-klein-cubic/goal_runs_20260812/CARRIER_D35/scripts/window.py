"""Hessian window: G-character of H^0(C, O(d)) vs Molien of S^d.

Replay of director_probes_20260806/hess_window.py (Atiyah–Bott / Chevalley–Weil
fixed-point data from theory/FIX_VII_carrier.md §6.1).  W-bar column is the
map-type multiplicity.
"""
from __future__ import annotations

import mpmath as mp

mp.mp.dps = 60
I = mp.mpc(0, 1)
pi = mp.pi


def _z(n, k):
    return mp.e ** (2 * pi * I * mp.mpf(k) / n)


def character_table():
    w = _z(3, 1)
    zeta = lambda k: _z(11, k % 11)
    lam = (-1 + I * mp.sqrt(11)) / 2
    lamb = (-1 - I * mp.sqrt(11)) / 2
    mu_p, mu_m = (-1 + mp.sqrt(5)) / 2, (-1 - mp.sqrt(5)) / 2
    CL = ["1", "2", "3", "5A", "5B", "6", "11A", "11B"]
    SZ = dict(zip(CL, [1, 55, 110, 132, 132, 110, 60, 60]))
    CT = {
        "triv": dict(zip(CL, [1, 1, 1, 1, 1, 1, 1, 1])),
        "W": dict(zip(CL, [5, 1, -1, 0, 0, 1, lam, lamb])),
        "Wb": dict(zip(CL, [5, 1, -1, 0, 0, 1, lamb, lam])),
        "X10": dict(zip(CL, [10, -2, 1, 0, 0, 1, -1, -1])),
        "X10p": dict(zip(CL, [10, 2, 1, 0, 0, -1, -1, -1])),
        "X11": dict(zip(CL, [11, -1, -1, 1, 1, -1, 0, 0])),
        "X12": dict(zip(CL, [12, 0, 0, mu_p, mu_m, 0, 1, 1])),
        "X12p": dict(zip(CL, [12, 0, 0, mu_m, mu_p, 0, 1, 1])),
    }
    QR = [1, 3, 4, 5, 9]
    QNR = [2, 6, 7, 8, 10]
    EIG = {
        "1": [1] * 5,
        "2": [1, 1, 1, -1, -1],
        "3": [1, w, w, w ** 2, w ** 2],
        "5A": [_z(5, k) for k in range(5)],
        "5B": [_z(5, 2 * k) for k in range(5)],
        "6": [1, w, w ** 2, -w, -w ** 2],
        "11A": [zeta(k) for k in QR],
        "11B": [zeta(k) for k in QNR],
    }
    return CL, SZ, CT, EIG, w, zeta


def molien_traces(EIG, CL, dmax):
    out = {}
    for c in CL:
        ev = [mp.conj(e) for e in EIG[c]]
        p = [None] + [sum(e ** k for e in ev) for k in range(1, dmax + 1)]
        h = [mp.mpf(1)]
        for d in range(1, dmax + 1):
            h.append(sum(p[k] * h[d - k] for k in range(1, d + 1)) / d)
        out[c] = h
    return out


def chiL(d, c, w, zeta):
    if c == "1":
        return mp.mpf(20 * d - 25)
    if c == "2":
        return mp.mpf(3)
    if c == "3":
        return 2 * w ** (2 * d) / (1 - w ** 2) + 2 * w ** d / (1 - w)
    if c in ("5A", "5B", "6"):
        return mp.mpf(0)
    t = 1 if c == "11A" else 2
    a11 = [1, 9, 4, 3, 5]
    s = mp.mpf(0)
    for i in range(5):
        ai, an = a11[i], a11[(i + 1) % 5]
        s += zeta(-d * ai * t) / (1 - zeta((ai - an) * t))
    return s


def mult(V, vals, SZ, CT, CL):
    s = sum(SZ[c] * vals[c] * mp.conj(CT[V][c]) for c in CL) / 660
    r = int(mp.nint(mp.re(s)))
    if abs(s - r) >= 1e-35:
        raise AssertionError("non-integral multiplicity %s %s" % (V, s))
    return r


def window_rows(degrees):
    CL, SZ, CT, EIG, w, zeta = character_table()
    dmax = max(degrees)
    mol = molien_traces(EIG, CL, dmax)
    rows = []
    for d in degrees:
        valsL = {c: chiL(d, c, w, zeta) for c in CL}
        tot = 0
        for V in CT:
            m = mult(V, valsL, SZ, CT, CL)
            if m < 0:
                raise AssertionError("negative mult %s at d=%d" % (V, d))
            tot += m * int(mp.re(CT[V]["1"]))
        if tot != 20 * d - 25:
            raise AssertionError("HF mismatch d=%d tot=%d" % (d, tot))
        mS = mult("Wb", {c: mol[c][d] for c in CL}, SZ, CT, CL)
        mL = mult("Wb", valsL, SZ, CT, CL)
        mSW = mult("W", {c: mol[c][d] for c in CL}, SZ, CT, CL)
        mLW = mult("W", valsL, SZ, CT, CL)
        rows.append({
            "d": d,
            "molien_Wb": mS,
            "oncurve_Wb": mL,
            "ideal_Wb": mS - mL,
            "molien_W": mSW,
            "oncurve_W": mLW,
            "HF": 20 * d - 25,
        })
    return rows
