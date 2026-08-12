#!/usr/bin/env python3
"""Equivariant jet rigidity at the special fixed points: WHY the landing
orders boost beyond the imposed conditions.

For a projective point z0 with stabilizer H <= G and scaling character
lambda (rho(h) z0 = lambda(h) z0), any T in M_d = (Sym^d W* (x) W)^G has
k-jet at z0 living in

    J_k(d) = ( Sym^k (W/<z0>)* (x) W (x) lambda^{d-k} )^H .

If T(z0) = 0 is imposed (or automatic), then ord_{z0}(T) >= k0 where k0 =
min{ k >= 1 : dim J_k(d) > 0 }; the first nonzero jet lies in J_{k0}(d).
Landing cubics then vanish to order >= 3 k0 at z0 (often more, from the
weight structure of F~ on the jet values).

Also computes dim J_0(d) = allowed value space (W (x) lambda^d)^H, deciding
whether T(z0) = 0 is AUTOMATIC at degree d.

Everything is an exact character computation in F_P, P = 400291 = 1 mod 330
(all element orders in {1,2,3,5,6,11} have roots of unity; all dims are
integers << P).  The group matrices are built from the defining Weil frame
at P (slicelib.build_frame self-tests).

Usage: python3 jet_rigidity.py
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

import common as CM
import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_ladder as PL
import instruments as INS

P = 400291
KMAX = 9
DEGS = [35, 36, 37, 38]


def stab_and_scalars(fr, z0):
    """indices h with rho(h) z0 = lam*z0, and the scalars lam."""
    p = fr["p"]
    RHO = fr["RHO"]
    out = []
    z0 = np.asarray(z0, dtype=np.int64) % p
    j0 = int(np.nonzero(z0)[0][0])
    for g in range(660):
        w = (RHO[g] @ z0) % p
        lam = w[j0] * pow(int(z0[j0]), p - 2, p) % p
        if np.array_equal((lam * z0) % p, w):
            out.append((g, int(lam)))
    return out


def group_pow(fr, g, k):
    """index-free matrix power rho(g)^k mod p."""
    p = fr["p"]
    M = np.eye(5, dtype=np.int64)
    A = fr["RHO"][g] % p
    kk = k
    while kk:
        if kk & 1:
            M = (M @ A) % p
        A = (A @ A) % p
        kk >>= 1
    return M


def jet_dims(fr, z0, dlist, kmax=KMAX):
    """dim J_k(d) for k = 0..kmax, each d in dlist. Exact ints via F_P."""
    p = fr["p"]
    stab = stab_and_scalars(fr, z0)
    Hn = len(stab)
    z0 = np.asarray(z0, dtype=np.int64) % p
    j0 = int(np.nonzero(z0)[0][0])
    # per element: power sums of V* = (W/<z0>)* : p_j(h) = chi_{V}(h^{-j})
    # chi_V(x) = tr(x) - lam(x).  h-series via Newton.
    data = []
    for (g, lam) in stab:
        hs = [1] + [0] * kmax
        # Newton: k*h_k = sum_{j=1..k} p_j h_{k-j},  p_j = chi_{V*}(h^j) = chi_V(h^{-j})
        pj = []
        for j in range(1, kmax + 1):
            M = group_pow(fr, g, (660 - j) % 660 or 660)  # h^{-j} = h^{660-j} (order | 660)
            w = (M @ z0) % p
            lamj = w[j0] * pow(int(z0[j0]), p - 2, p) % p
            pj.append((int(np.trace(M)) - lamj) % p)
        for k in range(1, kmax + 1):
            acc = 0
            for j in range(1, k + 1):
                acc = (acc + pj[j - 1] * hs[k - j]) % p
            hs[k] = acc * pow(k, p - 2, p) % p
        chiW = int(np.trace(fr["RHO"][g])) % p
        data.append((g, lam, hs, chiW))
    out = {}
    inv = pow(Hn, p - 2, p)
    for d in dlist:
        dims = []
        for k in range(kmax + 1):
            acc = 0
            for (g, lam, hs, chiW) in data:
                # J_k = Hom_H(Sym^k V (x) lam^{d-k}, W):
                # mult = (1/|H|) sum_h chi_{Sym^k V*}(h) lam(h)^{k-d} chi_W(h)
                lampow = pow(lam, (k - d) % 660, p)
                acc = (acc + hs[k] * chiW % p * lampow) % p
            val = acc * inv % p
            if val > P // 2:
                val -= P  # should not happen; dims nonnegative
            dims.append(int(val))
        out[d] = dims
    return Hn, out


def main():
    # use the big-prime frame so dims are unambiguous integers
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(P, verbose=False), verbose=False), verbose=False)
    P11, P5on, P5off = PL.eig_points(fr, P)
    z, Z, Wplus, Wminus, kids6 = INS.build_v4_children(fr, P)
    pts = [
        ("D12pt c_sigma", np.asarray(fr["w0"])),
        ("D10pt", np.asarray(fr["D10pt"])),
        ("V4-child w", np.asarray(kids6[0]["w"])),
        ("X^C6 w=1", np.asarray(fr["C6_eig"][1][0])),
        ("X^C6 w=5", np.asarray(fr["C6_eig"][5][0])),
        ("C11 pt", np.asarray(P11[0])),
        ("C5 pt (on X)", np.asarray(P5on[0]) if P5on else None),
    ]
    results = {}
    for name, z0 in pts:
        if z0 is None:
            continue
        Hn, dims = jet_dims(fr, z0, DEGS)
        results[name] = {"stab_order": Hn, "jet_dims": {str(d): v for d, v in dims.items()}}
        print("%-15s |H|=%2d" % (name, Hn))
        for d in DEGS:
            v = dims[d]
            k0 = next((k for k in range(1, KMAX + 1) if v[k] > 0), None)
            print("   d=%d  dimJ_k k=0..%d: %s   J0=%d  first k>=1 nonzero: %s"
                  % (d, KMAX, v, v[0], k0))
    json.dump(results, open(os.path.join(CM.RES, "jet_rigidity.json"), "w"), indent=1)
    print("[write] jet_rigidity.json")


if __name__ == "__main__":
    main()
