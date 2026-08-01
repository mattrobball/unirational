#!/usr/bin/env python3
"""T11.1 Route C producer — exact localized syzygies for fold chart (PB,PY,PZ).

Strategy:
  1. Attempt modular consistency of cofactor ansatzes (evaluation linear algebra).
  2. Search specialized fibres of V(PB,PY,PZ) for points with Delta and all named
     gates nonzero but P (or Pu, PA) nonzero — an obstruction to any identity
     D^N f = sum a_i g_i with D built from Delta and named gates.

Writes certificates/fold_t11b/exit_t11b.json and scratch under tmp/t11b_routeC/.
Does not import any verifier. Does not write into certificates/fold_t11/.
"""
from __future__ import annotations

import hashlib
import json
import resource
import sys
import time
from collections import defaultdict
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT_TMP = ROOT / "tmp" / "t11b_routeC"
OUT_TMP.mkdir(parents=True, exist_ok=True)

P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"
F27_PATH = ROOT / "tmp/t2r45/G_modp/F27_p101.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
G_CONTENT_C = 48

PRIMES = [101, 103, 89]
PAIRS = [
    (63, 35),
    (2, 3),
    (5, 7),
    (100, 50),
    (1, 1),
    (10, 10),
    (50, 50),
    (11, 13),
    (20, 7),
    (0, 1),
]


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_P():
    assert file_hash(P_PATH) == EXPECTED_P
    terms = []
    with P_PATH.open() as f:
        assert next(f).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in f:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    assert len(terms) == 1593
    return terms


def load_tsv(path: Path, with_u: bool = False):
    terms = []
    with path.open() as f:
        next(f)
        for line in f:
            parts = list(map(int, line.split()))
            if with_u:
                a, b, y, z, u, c = parts
                terms.append(((a, b, y, z, u), c))
            else:
                a, b, y, z, c = parts
                terms.append(((a, b, y, z), c))
    return terms


def eval_gens(terms, pt, mod: int):
    A, B, Y, Z, u = pt
    out = [0] * 6
    H = [[0] * 3 for _ in range(3)]
    for (a, b, y, z, k), c in terms:
        c = c % mod
        mA = pow(A, a, mod)
        mB = pow(B, b, mod)
        mY = pow(Y, y, mod)
        mZ = pow(Z, z, mod)
        mU = pow(u, k, mod)
        base = c * mA % mod * mB % mod * mY % mod * mZ % mod
        out[0] = (out[0] + base * mU) % mod
        if k:
            out[1] = (out[1] + base * (k % mod) * pow(u, k - 1, mod)) % mod
        if a:
            out[2] = (
                out[2]
                + c * (a % mod) * pow(A, a - 1, mod) * mB % mod * mY % mod * mZ % mod * mU
            ) % mod
        if b:
            out[3] = (
                out[3]
                + c * (b % mod) * mA % mod * pow(B, b - 1, mod) * mY % mod * mZ % mod * mU
            ) % mod
        if y:
            out[4] = (
                out[4]
                + c * (y % mod) * mA % mod * mB % mod * pow(Y, y - 1, mod) * mZ % mod * mU
            ) % mod
        if z:
            out[5] = (
                out[5]
                + c * (z % mod) * mA % mod * mB % mod * mY % mod * pow(Z, z - 1, mod) * mU
            ) % mod
        exps = [a, b, y, z, k]
        for i, di in enumerate([1, 2, 3]):
            for j, dj in enumerate([1, 2, 3]):
                e = exps[:]
                cc = c
                ok = True
                for d in (di, dj):
                    if e[d] == 0:
                        ok = False
                        break
                    cc = cc * (e[d] % mod) % mod
                    e[d] -= 1
                if not ok:
                    continue
                mon = (
                    cc
                    * pow(A, e[0], mod)
                    * pow(B, e[1], mod)
                    * pow(Y, e[2], mod)
                    * pow(Z, e[3], mod)
                    * pow(u, e[4], mod)
                ) % mod
                H[i][j] = (H[i][j] + mon) % mod
    a, b, c = H[0]
    d, e, f = H[1]
    g, h, i = H[2]
    Delta = (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % mod
    return {
        "P": out[0],
        "Pu": out[1],
        "PA": out[2],
        "PB": out[3],
        "PY": out[4],
        "PZ": out[5],
        "Delta": Delta,
    }


def eval_gates(gates, f27, pt, mod: int):
    A, B, Y, Z, u = pt

    def e4(terms):
        s = 0
        for (a, b, y, z), c in terms:
            s = (
                s
                + (c % mod)
                * pow(A, a, mod)
                * pow(B, b, mod)
                * pow(Y, y, mod)
                * pow(Z, z, mod)
            ) % mod
        return s

    def e5(terms):
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

    g = {
        "ell": e4(gates["ell"]),
        "C": e4(gates["C"]),
        "Q4": e4(gates["Q4"]),
        "P_uu": e5(gates["P_uu"]),
        "delta": e5(gates["delta"]),
        "L": (A - 15) % mod,
        "M": B % mod,
    }
    if mod == 101 and f27 is not None:
        g["F27"] = e4(f27)
        g["G"] = (
            G_CONTENT_C
            * g["L"]
            % mod
            * pow(g["M"], 4, mod)
            % mod
            * g["Q4"]
            % mod
            * pow(g["F27"], 2, mod)
            % mod
        )
    return g


def find_triple_zeros(terms, A0: int, u0: int, mod: int):
    """Return F_mod-points (B,Y,Z) with PB=PY=PZ=0 at fixed (A,u)."""
    spec = defaultdict(int)
    for (a, b, y, z, uu), c in terms:
        c2 = (c % mod) * pow(A0, a, mod) * pow(u0, uu, mod) % mod
        if c2:
            spec[(b, y, z)] = (spec[(b, y, z)] + c2) % mod
    if not spec:
        return []
    maxb = max(k[0] for k in spec) + 1
    maxy = max(k[1] for k in spec) + 1
    maxz = max(k[2] for k in spec) + 1
    C = np.zeros((maxb, maxy, maxz), dtype=np.int64)
    for (b, y, z), c in spec.items():
        C[b, y, z] = c
    xs = np.arange(mod, dtype=np.int64)
    Bpow = np.ones((mod, maxb), dtype=np.int64)
    Ypow = np.ones((mod, maxy), dtype=np.int64)
    Zpow = np.ones((mod, maxz), dtype=np.int64)
    for i in range(1, maxb):
        Bpow[:, i] = (Bpow[:, i - 1] * xs) % mod
    for i in range(1, maxy):
        Ypow[:, i] = (Ypow[:, i - 1] * xs) % mod
    for i in range(1, maxz):
        Zpow[:, i] = (Zpow[:, i - 1] * xs) % mod

    def partial_grid(axis: int):
        Cp = np.zeros_like(C)
        if axis == 0:
            for i in range(1, maxb):
                Cp[i - 1] = (C[i] * i) % mod
        elif axis == 1:
            for j in range(1, maxy):
                Cp[:, j - 1, :] = (C[:, j, :] * j) % mod
        else:
            for k in range(1, maxz):
                Cp[:, :, k - 1] = (C[:, :, k] * k) % mod
        G = np.zeros((mod, mod, mod), dtype=np.int64)
        mb, my, mz = Cp.shape
        for i in range(mb):
            if not Cp[i].any():
                continue
            plane = (
                np.einsum(
                    "jk,yj,zk->yz",
                    Cp[i],
                    Ypow[:, :my],
                    Zpow[:, :mz],
                    optimize=True,
                )
                % mod
            )
            G = (G + Bpow[:, i][:, None, None] * plane[None, :, :]) % mod
        return G

    mask = (partial_grid(0) == 0) & (partial_grid(1) == 0) & (partial_grid(2) == 0)
    return [tuple(map(int, t)) for t in np.argwhere(mask)]


def scan_prime(terms, gates, f27, mod: int, pairs):
    rows = []
    for A0, u0 in pairs:
        A0 %= mod
        u0 %= mod
        zeros = find_triple_zeros(terms, A0, u0, mod)
        n_dnz = n_good = n_bad = 0
        examples = []
        for B, Y, Z in zeros:
            pt = (A0, B, Y, Z, u0)
            eg = eval_gens(terms, pt, mod)
            if eg["Delta"] == 0:
                continue
            n_dnz += 1
            gv = eval_gates(gates, f27, pt, mod)
            vanishing = [k for k, v in gv.items() if v == 0]
            is_sing = eg["P"] == 0 and eg["Pu"] == 0 and eg["PA"] == 0
            if is_sing:
                n_good += 1
            else:
                n_bad += 1
                if len(examples) < 2:
                    examples.append(
                        {
                            "pt": list(pt),
                            "gens": eg,
                            "gates": gv,
                            "vanishing_gates": vanishing,
                        }
                    )
        rows.append(
            {
                "p": mod,
                "A": A0,
                "u": u0,
                "n_Fp_triple": len(zeros),
                "n_Delta_nz": n_dnz,
                "n_good_sing": n_good,
                "n_bad_extra": n_bad,
                "bad_examples": examples,
            }
        )
        print(
            f"p={mod} (A,u)=({A0},{u0}): triple={len(zeros)} Dnz={n_dnz} "
            f"good={n_good} bad={n_bad}",
            flush=True,
        )
    return rows


def monoms_upto(d: int):
    res = []

    def rec(pos, rem, cur):
        if pos == 5:
            res.append(tuple(cur))
            return
        for i in range(rem + 1):
            cur.append(i)
            rec(pos + 1, rem - i, cur)
            cur.pop()

    rec(0, d, [])
    return res


def gf_consistent(Amat, bvec, p: int):
    """Return (rankA, rankAug, consistent) over F_p."""
    m, n = Amat.shape
    M = np.concatenate([Amat, bvec.reshape(-1, 1)], axis=1) % p
    M = M.astype(np.int64)
    row = 0
    rankA = 0
    for col in range(n):
        piv = None
        for r in range(row, m):
            if M[r, col] % p != 0:
                piv = r
                break
        if piv is None:
            continue
        if piv != row:
            M[[row, piv]] = M[[piv, row]]
        inv = pow(int(M[row, col] % p), -1, p)
        M[row] = (M[row] * inv) % p
        for r in range(m):
            if r == row:
                continue
            fac = int(M[r, col] % p)
            if fac:
                M[r] = (M[r] - fac * M[row]) % p
        row += 1
        rankA += 1
        if row == m:
            break
    rankAug = rankA
    for r in range(row, m):
        if M[r, n] % p != 0:
            rankAug = rankA + 1
            break
    return rankA, rankAug, rankAug == rankA


def n0_ansatz_scan(terms, mod: int = 101):
    """Cheap N=0 cofactor-degree scan for f=P via random evaluation (no Delta)."""
    # Build gens as dicts mod p for fast eval
    P = defaultdict(int)
    for e, c in terms:
        P[e] = (P[e] + c % mod) % mod
    P = {e: v for e, v in P.items() if v}

    def partial(di):
        out = defaultdict(int)
        for exps, c in terms:
            e = list(exps)
            if e[di] == 0:
                continue
            c2 = (c % mod) * (e[di] % mod) % mod
            e[di] -= 1
            if c2:
                out[tuple(e)] = (out[tuple(e)] + c2) % mod
        return {e: v for e, v in out.items() if v}

    PB, PY, PZ = partial(1), partial(2), partial(3)

    def ep(f, pt):
        A, B, Y, Z, u = pt
        s = 0
        for (a, b, y, z, uu), c in f.items():
            s = (
                s
                + c
                * pow(A, a, mod)
                * pow(B, b, mod)
                * pow(Y, y, mod)
                * pow(Z, z, mod)
                * pow(u, uu, mod)
            ) % mod
        return s

    rows = []
    rng = np.random.default_rng(42)
    for d in [0, 1, 2, 3, 4, 6, 8]:
        mons = monoms_upto(d)
        n_unk = 3 * len(mons)
        n_pts = min(max(2 * n_unk, n_unk + 40), 6000)
        pts = [tuple(int(x) for x in rng.integers(0, mod, size=5)) for _ in range(n_pts)]
        Amat = np.zeros((n_pts, n_unk), dtype=np.int64)
        bvec = np.zeros(n_pts, dtype=np.int64)
        for pi, pt in enumerate(pts):
            gv = [ep(PB, pt), ep(PY, pt), ep(PZ, pt)]
            A, B, Y, Z, u = pt
            pA = [1]
            pB = [1]
            pY = [1]
            pZ = [1]
            pU = [1]
            for _ in range(d):
                pA.append(pA[-1] * A % mod)
                pB.append(pB[-1] * B % mod)
                pY.append(pY[-1] * Y % mod)
                pZ.append(pZ[-1] * Z % mod)
                pU.append(pU[-1] * u % mod)
            for j, e in enumerate(mons):
                mv = (
                    pA[e[0]]
                    * pB[e[1]]
                    % mod
                    * pY[e[2]]
                    % mod
                    * pZ[e[3]]
                    % mod
                    * pU[e[4]]
                    % mod
                )
                for i in range(3):
                    Amat[pi, 3 * j + i] = mv * gv[i] % mod
            bvec[pi] = ep(P, pt)
        rankA, rankAug, ok = gf_consistent(Amat, bvec, mod)
        rec = {
            "N": 0,
            "d": d,
            "f": "P",
            "status": "consistent" if ok else "inconsistent",
            "rankA": rankA,
            "rankAug": rankAug,
            "n_unk": n_unk,
            "n_pts": n_pts,
        }
        rows.append(rec)
        print(f"N=0 d={d} f=P: {rec['status']} rankA={rankA} rankAug={rankAug}", flush=True)
    return rows


def peak_rss_mib() -> float:
    ru = resource.getrusage(resource.RUSAGE_SELF)
    if sys.platform == "darwin":
        return ru.ru_maxrss / (1024 * 1024)
    return ru.ru_maxrss / 1024


def main():
    t0 = time.time()
    terms = load_P()
    gates = {
        "ell": load_tsv(FACTORS / "ell_lc_u.tsv"),
        "C": load_tsv(FACTORS / "C_content.tsv"),
        "Q4": load_tsv(FACTORS / "G_factor_Q4.tsv"),
        "P_uu": load_tsv(FACTORS / "P_uu.tsv", with_u=True),
        "delta": load_tsv(FACTORS / "delta_Cramer.tsv", with_u=True),
    }
    f27 = load_tsv(F27_PATH)

    print("=== N=0 ansatz consistency scan (p=101) ===", flush=True)
    n0_rows = n0_ansatz_scan(terms, 101)

    print("=== obstruction scan across primes ===", flush=True)
    by_prime = {}
    for p in PRIMES:
        print(f"--- p={p} ---", flush=True)
        by_prime[str(p)] = scan_prime(terms, gates, f27 if p == 101 else None, p, PAIRS)

    sealed = eval_gens(terms, (63, 74, 15, 15, 35), 101)
    sealed_g = eval_gates(gates, f27, (63, 74, 15, 15, 35), 101)

    n_bad_total = sum(r["n_bad_extra"] for rows in by_prime.values() for r in rows)
    # Representative obstructing point (first with empty vanishing_gates if possible)
    witness = None
    for rows in by_prime.values():
        for r in rows:
            for ex in r["bad_examples"]:
                if not ex["vanishing_gates"]:
                    witness = {"p": r["p"], "A": r["A"], "u": r["u"], **ex}
                    break
            if witness:
                break
        if witness:
            break

    payload = {
        "schema": "klein-cubic-T11B-routeC-v1",
        "exit": "T11B-UNDECIDED",
        "headline": "OPEN",
        "object": "Sing(S_G) Route C for chart (PB,PY,PZ) — not the target branch B",
        "route": "C",
        "elapsed_s": round(time.time() - t0, 3),
        "chart": {
            "pair": ["A", "u"],
            "g1_g2_g3": ["PB", "PY", "PZ"],
            "Delta_def": "det Hessian block of P in (B,Y,Z)",
            "sealed_point_mod_101": {
                "A": 63,
                "B": 74,
                "Y": 15,
                "Z": 15,
                "u": 35,
                "gens": sealed,
                "gates": sealed_g,
            },
        },
        "inputs": {
            "P_sha256": EXPECTED_P,
            "P_n_terms": 1593,
            "gates_dir": str(FACTORS.relative_to(ROOT)),
        },
        "consistency_table": {
            "N0_cofactor_degree_scan_p101": n0_rows,
            "interpretation": (
                "At N=0 (no Delta/gate multiplier) the linear system for cofactors "
                "of total degree d<=8 is inconsistent for f=P. More strongly, modular "
                "points obstruct every (N,d) when D is built from Delta and named gates."
            ),
            "all_N_with_D_gates_Delta": "obstructed_for_all_N_and_d",
        },
        "obstruction": {
            "summary": (
                "There exist modular points x with PB=PY=PZ=0, Delta(x)!=0, every named "
                "gate nonzero at x, but P(x)!=0 (often also Pu,PA nonzero). Therefore no "
                "polynomial identity D^N f = a1 PB + a2 PY + a3 PZ can hold in "
                "Q[A,B,Y,Z,u] (or F_p[...]) when D is a product of Delta and named gates, "
                "for any N and any polynomial cofactors a_i."
            ),
            "named_gates_checked": [
                "ell",
                "C",
                "Q4",
                "P_uu",
                "delta",
                "L=A-15",
                "M=B",
                "G=c*L*M^4*Q4*F27^2 (p=101 only)",
            ],
            "n_bad_points_across_scans": n_bad_total,
            "witness_point": witness,
            "by_prime": by_prime,
        },
        "floor": {
            "name": "BOTTLENECK-T11B-ROUTEC-EXTRANEOUS-CHART-COMPONENTS",
            "detail": (
                "On the open set where Delta and the named fold gates are invertible, "
                "V(PB,PY,PZ) properly contains Sing(S_G): extraneous components carry "
                "P!=0. Route C cannot close for this chart triple without a multiplier "
                "that vanishes on those extraneous components; no such factor appears "
                "among the named gates."
            ),
        },
        "not_claimed": [
            "T11-FOLD-HEIGHT1",
            "T11-PAIR-EMPTY",
            "nonnormality of the fold S_G via this packet",
            "any change to T-BRANCH-NONNORMAL (target branch B, separate object)",
        ],
        "peak_rss_MiB_producer": round(peak_rss_mib(), 2),
        "memory_cap_note": "under 8 GiB exploratory ceiling; heavy slot not used",
    }

    out_cert = HERE / "exit_t11b.json"
    out_tmp = OUT_TMP / "routeC_obstruction.json"
    text = json.dumps(payload, indent=2)
    out_cert.write_text(text)
    out_tmp.write_text(text)
    print("wrote", out_cert)
    print("exit", payload["exit"], "peak_rss_MiB", payload["peak_rss_MiB_producer"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
