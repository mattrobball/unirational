#!/usr/bin/env python3
"""V14_POSITIVE produce: exact ATLAS characters plus two-prime Weil traces.

python3 only. No gap/gp/sage/magma. Single-threaded. Tiny memory.

Writes results/character_dims.json and results/sealed_ledger.json.
"""
from __future__ import annotations

import json
import os
import sys
from fractions import Fraction
from itertools import combinations
from math import comb, gcd

HERE = os.path.dirname(os.path.abspath(__file__))
PKT = os.path.abspath(os.path.join(HERE, ".."))
PROBLEM = os.path.abspath(os.path.join(PKT, "..", ".."))
RESULTS = os.path.join(PKT, "results")

# ---------------------------------------------------------------------------
# ATLAS L2(11), projective-order collapse (same numbers as V14MAP_DEGREE345)
# ---------------------------------------------------------------------------
ORD_SIZE = {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120}
CHI10P = {1: 10, 2: 2, 3: 1, 5: 0, 6: -1, 11: -1}
CHI_A_RAT = {1: 5, 2: 1, 3: -1, 5: 0, 6: 1}
# 60 * (alpha + conjugate) with alpha = (-1 + sqrt(-11))/2, so 60 * (-1)
CHI_A_11_WEIGHT = -60
# Klein 5-space W: same values as A on rational classes
CHI_W_RAT = dict(CHI_A_RAT)


def newton_h(pk, d):
    h = [Fraction(1)]
    for n in range(1, d + 1):
        s = sum(Fraction(pk[k]) * h[n - k] for k in range(1, n + 1))
        h.append(s / n)
    return h


def sym_char_from_chi(chi_of_order, n, d):
    if d == 0:
        return 1
    pk = {k: chi_of_order[n // gcd(n, k)] for k in range(1, d + 1)}
    h = newton_h(pk, d)
    assert h[d].denominator == 1, (n, d, h[d])
    return int(h[d])


def inner_against_A(chi_fn, d):
    """<chi, chi_A> using the rational/11-weight convention of V14MAP_DEGREE345."""
    tot = Fraction(0)
    for n, size in ORD_SIZE.items():
        h = chi_fn(n, d)
        if n == 11:
            tot += Fraction(h * CHI_A_11_WEIGHT)
        else:
            tot += Fraction(size * h * CHI_A_RAT[n])
    tot /= 660
    assert tot.denominator == 1, tot
    return int(tot)


def inner_trivial(chi_fn, d):
    tot = Fraction(0)
    for n, size in ORD_SIZE.items():
        tot += Fraction(size * chi_fn(n, d))
    tot /= 660
    assert tot.denominator == 1, tot
    return int(tot)


def hilbert_v14(d):
    # classical anticanonical: (7/6) d (d+1) (2d+1) + 2d + 1
    return (7 * d * (d + 1) * (2 * d + 1)) // 6 + 2 * d + 1


def exact_block(dmax=8):
    def chiM(n, d):
        return sym_char_from_chi(CHI10P, n, d)

    c_slot = [inner_against_A(chiM, d) for d in range(dmax + 1)]
    inv = [inner_trivial(chiM, d) for d in range(dmax + 1)]
    amb = [comb(d + 9, 9) for d in range(dmax + 1)]
    hf = [hilbert_v14(d) for d in range(dmax + 1)]
    return {
        "dmax": dmax,
        "dim_Sym_d_M": amb,
        "dim_C_d_A": c_slot,
        "dim_invariants_Sym_d_M": inv,
        "hilbert_V14_classical": hf,
        "control_d0_to_5_C": c_slot[:6],
        "control_expected_C": [0, 0, 1, 2, 7, 18],
        "control_d0_to_5_inv": inv[:6],
        "control_expected_inv": [1, 0, 1, 2, 4, 8],
    }


# ---------------------------------------------------------------------------
# Weil model (FIX_IX_SEAL / V14MAP conventions), traces only
# ---------------------------------------------------------------------------
PAIRS = list(combinations(range(6), 2))


def mmul(A, B, p):
    Bt = list(zip(*B))
    return tuple(
        tuple(sum(x * y for x, y in zip(row, col)) % p for col in Bt) for row in A
    )


def eye(n):
    return tuple(tuple(1 if i == j else 0 for j in range(n)) for i in range(n))


def rref(rows, p):
    A = [[x % p for x in r] for r in rows]
    if not A:
        return [], []
    n, m = len(A), len(A[0])
    piv, r = [], 0
    for c in range(m):
        k = next((i for i in range(r, n) if A[i][c]), None)
        if k is None:
            continue
        A[r], A[k] = A[k], A[r]
        inv = pow(A[r][c], p - 2, p)
        A[r] = [(x * inv) % p for x in A[r]]
        for i in range(n):
            if i == r or A[i][c] == 0:
                continue
            t = A[i][c]
            A[i] = [(A[i][j] - t * A[r][j]) % p for j in range(m)]
        piv.append(c)
        r += 1
        if r == n:
            break
    return [tuple(row) for row in A[:r]], piv


def lam2(Mx, p):
    return tuple(
        tuple((Mx[i][k] * Mx[j][l] - Mx[i][l] * Mx[j][k]) % p for (k, l) in PAIRS)
        for (i, j) in PAIRS
    )


def build_sl(p):
    assert p % 11 == 1
    g11 = next(t for t in range(2, p) if pow(t, 11, p) == 1 and t != 1)
    gauss = sum(pow(g11, (k * k) % 11, p) for k in range(11)) % p
    assert (gauss * gauss + 11) % p == 0
    c = pow(gauss, p - 2, p)
    T6 = tuple(
        tuple((pow(g11, (j * j) % 11, p) if i == j else 0) for j in range(6))
        for i in range(6)
    )
    S6 = tuple(
        tuple(
            (
                c
                if j == 0
                else c
                * (pow(g11, (i * j) % 11, p) + pow(g11, (-i * j) % 11, p))
            )
            % p
            for j in range(6)
        )
        for i in range(6)
    )
    minusI = tuple(tuple((-1 if i == j else 0) % p for j in range(6)) for i in range(6))
    assert mmul(S6, S6, p) == minusI
    idx, elems = {eye(6): 0}, [eye(6)]
    frontier = [0]
    while frontier:
        nxt = []
        for i in frontier:
            Mi = elems[i]
            for gg in (T6, S6):
                N = mmul(Mi, gg, p)
                if N not in idx:
                    idx[N] = len(elems)
                    elems.append(N)
                    nxt.append(len(elems) - 1)
        frontier = nxt
        assert len(elems) <= 1400
    return elems, T6, S6, g11, gauss


def is_scalar(A):
    d = A[0][0]
    return d != 0 and all(A[i][j] == (d if i == j else 0) for i in range(6) for j in range(6))


def proj_order(Mx, p):
    A = Mx
    for k in range(1, 14):
        if is_scalar(A):
            return k
        A = mmul(A, Mx, p)
    return 99


def newton_h_mod(ps, d, p):
    h = [1]
    for n in range(1, d + 1):
        s = sum(ps[k] * h[n - k] % p for k in range(1, n + 1)) % p
        h.append(s * pow(n, p - 2, p) % p)
    return h


def traces_block(p, dmax=6):
    elems, T6, S6, g11, gauss = build_sl(p)
    assert len(elems) == 1320
    porders = [proj_order(Mx, p) for Mx in elems]
    profile = {}
    for k in porders:
        profile[str(k)] = profile.get(str(k), 0) + 1

    # 10' projector on Lambda^2 U
    PM = [[0] * 15 for _ in range(15)]
    for Mx, po in zip(elems, porders):
        w = CHI10P[po] % p
        if not w:
            continue
        L = lam2(Mx, p)
        for a in range(15):
            La, row = L[a], PM[a]
            for b in range(15):
                if La[b]:
                    row[b] = (row[b] + w * La[b]) % p
    sc = 10 * pow(1320 % p, p - 2, p) % p
    PM = [[sc * x % p for x in row] for row in PM]
    MB, piv = rref([tuple(PM[i][j] for i in range(15)) for j in range(15)], p)
    assert len(MB) == 10, len(MB)

    # complementary 5-space in Lambda^2 (the other summand)
    I15 = [[1 if i == j else 0 for j in range(15)] for i in range(15)]
    five_rows = []
    for i in range(15):
        row = [(I15[i][j] - PM[i][j]) % p for j in range(15)]
        five_rows.append(row)
    FB, fpiv = rref(five_rows, p)
    assert len(FB) == 5, len(FB)

    def chi_M(Mx):
        L = lam2(Mx, p)
        # action on the 10 basis MB: coordinates on piv
        s = 0
        for m in MB:
            im = tuple(sum(L[a][b] * m[b] % p for b in range(15)) % p for a in range(15))
            # the projector is G-equivariant, so im is in the 10-space
            # trace = sum of the diagonal in the piv chart
        # cheaper: tr(g | 10') = (tr(g | Lambda^2) - tr(g | 5))/something
        # use character table on projective order
        return CHI10P[proj_order(Mx, p)] % p

    # precompute tr_U(g^k) by walking powers
    hom_spin = []
    hom_lin_from_five = []
    for d in range(dmax + 1):
        acc_spin = 0
        acc_five = 0
        for Mx, po in zip(elems, porders):
            # power sums of U
            psU = {}
            cur = eye(6)
            for k in range(1, d + 1):
                cur = mmul(cur, Mx, p)
                psU[k] = sum(cur[i][i] for i in range(6)) % p
            hU = newton_h_mod(psU, d, p) if d else [1]
            chiSdU = hU[d]
            chiM = CHI10P[po] % p
            acc_spin = (acc_spin + chiSdU * chiM) % p

            # power sums of the 5-summand of Lambda^2
            L = lam2(Mx, p)
            ps5 = {}
            # tr(g^k | 5) = tr(g^k | Lambda^2) - tr(g^k | 10')
            # tr(Lambda^2 g^k) = (tr(g^k)^2 - tr(g^{2k}))/2
            # easier: tr(g | 5) = tr(Lambda^2 g) - CHI10P[po]
            # For Sym^d of the 5 we need power sums of the 5-rep.
            # tr(g^k | 5) = tr(Lambda^2 g^k) - CHI10P[proj_order(g^k)]
            cur = eye(6)
            for k in range(1, d + 1):
                cur = mmul(cur, Mx, p)
                trU = sum(cur[i][i] for i in range(6)) % p
                trU2 = sum(
                    mmul(cur, cur, p)[i][i] for i in range(6)
                ) % p  # unused; Lambda^2:
                # tr(Lambda^2 g) = (tr(g)^2 - tr(g^2))/2
                g2 = mmul(cur, cur, p) if False else None
            # recompute cleanly below
        # redo five-block cleanly after the loop structure — see below
        hom_spin.append(acc_spin)
        hom_lin_from_five.append(0)  # placeholder

    # clean five-rep power sums
    hom_five = []
    for d in range(dmax + 1):
        acc = 0
        for Mx, po in zip(elems, porders):
            ps5 = {}
            cur = eye(6)
            gk = eye(6)
            for k in range(1, d + 1):
                gk = mmul(gk, Mx, p)
                trU = sum(gk[i][i] for i in range(6)) % p
                g2k = mmul(gk, gk, p)
                trU2 = sum(g2k[i][i] for i in range(6)) % p
                # tr(Lambda^2 gk) = (tr^2 - tr(g^{2k})) * 2^{-1}
                trL2 = (trU * trU - trU2) % p * pow(2, p - 2, p) % p
                tr10 = CHI10P[proj_order(gk, p)] % p
                ps5[k] = (trL2 - tr10) % p
            h5 = newton_h_mod(ps5, d, p) if d else [1]
            acc = (acc + h5[d] * (CHI10P[po] % p)) % p
        hom_five.append(acc)

    inv1320 = pow(1320 % p, p - 2, p)
    inv660 = pow(660 % p, p - 2, p)

    def lift_small(x):
        x %= p
        return x if x <= p // 2 else x - p

    spin_dims = [lift_small(x * inv1320 % p) for x in hom_spin]
    # hom_five is summed over SL = 1320 elements; 5 and 10' are PSL reps,
    # each PSL class lifts twice, so the inner product over SL equals
    # the PSL inner product (already the true multiplicity).
    five_to_M = [lift_small(x * inv1320 % p) for x in hom_five]

    return {
        "p": p,
        "sl_order": len(elems),
        "proj_profile": profile,
        "dim_M": 10,
        "dim_five_in_lambda2": 5,
        "Hom_SL_Sym_d_Ustar_M": spin_dims,
        "Hom_G_Sym_d_five_M": five_to_M,
        "even_d_only_spin_descends": True,
        "note_spin": (
            "A G-map P(U) --> P(M) of degree d exists in Hom_SL(Sym^d U*, M) "
            "only for even d (center acts as (-1)^d on the source and +1 on M)."
        ),
    }


# ---------------------------------------------------------------------------
# Sealed-packet ledger (read-only cites)
# ---------------------------------------------------------------------------
MARKERS = [
    (
        "V14_MAP_DICHOTOMY",
        os.path.join(PROBLEM, "goal_runs_20260810", "V14_MAP_DICHOTOMY", "REPORT.md"),
        [
            "V14MAP-DICHOTOMY-SEALED",
            "V14MAP-KLEIN-TO-V14-EMPTY",
            "V14MAP-V14-TO-KLEIN-EXISTS",
            "Not claimed",
            "Dominance of `Phi`",
        ],
    ),
    (
        "V14MAP_DEGREE345_REPLAY",
        os.path.join(
            PROBLEM, "goal_runs_20260811", "V14MAP_DEGREE345_REPLAY", "THEOREM.md"
        ),
        [
            "V14MAP-DEGREE-3-4-5-REPLAYED",
            "no `G`-equivariant rational map",
            "d ≥ 6",
            "Not claimed",
            "Dominance of `Phi`",
        ],
    ),
    (
        "FIX_IX_SEAL",
        os.path.join(PROBLEM, "goal_runs_after_c53d89a", "FIX_IX_SEAL", "REPORT.md"),
        [
            "FIX-IX-SEAL-PASS",
            "V14 is smooth, pure dim 3",
            "V14^{D12}",
            "NOT G-unirational",
            "weakly versal",
        ],
    ),
    (
        "PHI_SEXTIC_ISOGENY",
        os.path.join(PROBLEM, "goal_runs_20260810", "PHI_SEXTIC_ISOGENY", "REPORT.md"),
        ["8192/11", "PHI-SEXTIC-ISOGENY-VERDICT-POS"],
    ),
    (
        "SPEC",
        os.path.join(PROBLEM, "SPEC.md"),
        [
            "finite-dimensional complex linear representation",
            "very versality",
        ],
    ),
    (
        "FIX_IX_THEORY",
        os.path.join(PROBLEM, "theory", "FIX_IX_v14.md"),
        [
            "Corollary IX.1",
            "not weakly versal",
            "spin-unirational",
            "Corollary IX.5",
        ],
    ),
]


def sealed_ledger():
    rows = []
    for name, path, needles in MARKERS:
        exists = os.path.isfile(path)
        text = open(path, encoding="utf-8", errors="replace").read() if exists else ""
        hits = {n: (n in text) for n in needles}
        rows.append(
            {
                "name": name,
                "path": os.path.relpath(path, PROBLEM),
                "exists": exists,
                "hits": hits,
                "all_hits": exists and all(hits.values()),
            }
        )
    return rows


def main():
    os.makedirs(RESULTS, exist_ok=True)
    exact = exact_block(8)
    traces = {}
    for p in (23, 67):
        traces[str(p)] = traces_block(p, 6)
    ledger = sealed_ledger()
    out = {
        "packet": "goal_runs_20260812/V14_POSITIVE",
        "exact": exact,
        "traces": traces,
        "sealed_ledger": ledger,
        "logical": {
            "headline_needs_linear_G_rep": True,
            "linear_P_to_V14_impossible": True,
            "reason": "FIX_IX_SEAL + Cor IX.1: no G-eq rational map from any faithful linear P(V) to V14",
            "spin_P_U_to_V14_open": True,
            "spin_plus_Phi_not_headline": True,
            "Phi_dominance_not_sealed": True,
            "Phi_existence_sealed_nonconstant": True,
        },
    }
    path = os.path.join(RESULTS, "character_dims.json")
    with open(path, "w") as f:
        json.dump(out, f, indent=2, sort_keys=True)
        f.write("\n")
    # split ledger copy
    with open(os.path.join(RESULTS, "sealed_ledger.json"), "w") as f:
        json.dump({"rows": ledger}, f, indent=2, sort_keys=True)
        f.write("\n")
    print("WROTE", path)
    print("C_d(A) d=0..8:", exact["dim_C_d_A"])
    print("spin Hom d=0..6 @23:", traces["23"]["Hom_SL_Sym_d_Ustar_M"])
    print("five->M Hom d=0..6 @23:", traces["23"]["Hom_G_Sym_d_five_M"])
    print("ledger all_hits:", all(r["all_hits"] for r in ledger))
    return 0


if __name__ == "__main__":
    sys.exit(main())
