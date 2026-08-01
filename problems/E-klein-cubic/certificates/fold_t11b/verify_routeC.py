#!/usr/bin/env python3
"""Independent verifier for T11.1 Route C packet (T11B-UNDECIDED).

Does NOT import the producer. Recomputes:
  - sealed P hash
  - sealed modular simple point: gens vanish, Delta=5, gates nonzero
  - the recorded obstruction witness (or a freshly found bad point): PB=PY=PZ=0,
    Delta!=0, named gates nonzero, P!=0
  - that this implies no D^N f identity for D built from Delta and named gates

Decisive invariant: modular evaluation of the six singular generators, Delta,
and named gates at an explicit F_p-point.
"""
from __future__ import annotations

import json
import sys
from collections import defaultdict
from hashlib import sha256
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"
F27_PATH = ROOT / "tmp/t2r45/G_modp/F27_p101.tsv"
EXIT_PATH = HERE / "exit_t11b.json"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
G_CONTENT_C = 48
MOD = 101


def fail(msg: str):
    print("FAIL:", msg)
    sys.exit(1)


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def load_P():
    if file_hash(P_PATH) != EXPECTED_P:
        fail(f"P hash mismatch: {file_hash(P_PATH)}")
    terms = []
    with P_PATH.open() as f:
        next(f)
        for line in f:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    if len(terms) != 1593:
        fail(f"P term count {len(terms)}")
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


def eval_gens(terms, pt, mod: int = MOD):
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


def eval_gates(gates, f27, pt, mod: int = MOD):
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
        "F27": e4(f27),
    }
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


def find_one_bad(terms, gates, f27, A0=2, u0=3, mod=MOD):
    """Independent discovery of a bad point at fixed (A,u)."""
    spec = defaultdict(int)
    for (a, b, y, z, uu), c in terms:
        c2 = (c % mod) * pow(A0, a, mod) * pow(u0, uu, mod) % mod
        if c2:
            spec[(b, y, z)] = (spec[(b, y, z)] + c2) % mod
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

    def partial_grid(axis):
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
    for B, Y, Z in np.argwhere(mask):
        pt = (A0, int(B), int(Y), int(Z), u0)
        eg = eval_gens(terms, pt, mod)
        if eg["Delta"] == 0:
            continue
        if eg["PB"] != 0 or eg["PY"] != 0 or eg["PZ"] != 0:
            fail("grid zero not a true triple zero")
        if eg["P"] == 0 and eg["Pu"] == 0 and eg["PA"] == 0:
            continue
        gv = eval_gates(gates, f27, pt, mod)
        if any(v == 0 for v in gv.values()):
            continue
        return pt, eg, gv
    return None


def main():
    if not EXIT_PATH.exists():
        fail(f"missing {EXIT_PATH}")
    payload = json.loads(EXIT_PATH.read_text())
    if payload.get("exit") != "T11B-UNDECIDED":
        fail(f"unexpected exit {payload.get('exit')}")
    if payload.get("headline") != "OPEN":
        fail("headline must remain OPEN")

    terms = load_P()
    gates = {
        "ell": load_tsv(FACTORS / "ell_lc_u.tsv"),
        "C": load_tsv(FACTORS / "C_content.tsv"),
        "Q4": load_tsv(FACTORS / "G_factor_Q4.tsv"),
        "P_uu": load_tsv(FACTORS / "P_uu.tsv", with_u=True),
        "delta": load_tsv(FACTORS / "delta_Cramer.tsv", with_u=True),
    }
    f27 = load_tsv(F27_PATH)

    # 1. Sealed simple point
    sealed_pt = (63, 74, 15, 15, 35)
    eg = eval_gens(terms, sealed_pt)
    gv = eval_gates(gates, f27, sealed_pt)
    for k in ("P", "Pu", "PA", "PB", "PY", "PZ"):
        if eg[k] != 0:
            fail(f"sealed point: {k}={eg[k]} != 0")
    if eg["Delta"] != 5:
        fail(f"sealed Delta={eg['Delta']} expected 5")
    for k, v in gv.items():
        if v == 0:
            fail(f"sealed gate {k}=0")
    print("OK sealed point: gens=0, Delta=5, gates nonzero")

    # 2. Verify recorded witness if present
    wit = payload.get("obstruction", {}).get("witness_point")
    if wit is not None:
        pt = tuple(wit["pt"])
        mod = int(wit.get("p", MOD))
        if mod != MOD:
            # re-evaluate only when p=101 (gates F27 available); still check gens
            egw = eval_gens(terms, pt, mod)
        else:
            egw = eval_gens(terms, pt, mod)
            gvw = eval_gates(gates, f27, pt, mod)
            if any(v == 0 for v in gvw.values()):
                fail(f"witness has vanishing gate: {gvw}")
            print("OK witness gates all nonzero:", {k: gvw[k] for k in gvw})
        if egw["PB"] != 0 or egw["PY"] != 0 or egw["PZ"] != 0:
            fail(f"witness not on triple: {egw}")
        if egw["Delta"] == 0:
            fail("witness Delta=0")
        if egw["P"] == 0 and egw["Pu"] == 0 and egw["PA"] == 0:
            fail("witness is full singular — not an obstruction")
        print("OK witness obstruction:", pt, "gens", egw)

    # 3. Independently rediscover a bad point at (A,u)=(2,3) mod 101
    found = find_one_bad(terms, gates, f27, 2, 3, MOD)
    if found is None:
        fail("could not independently find a bad point at (2,3) mod 101")
    pt, egb, gvb = found
    print("OK independent bad point", pt)
    print("   gens", egb)
    print("   gates", gvb)
    if egb["P"] == 0:
        fail("independent bad point has P=0 (need P!=0 for strongest obstruction)")
    if any(v == 0 for v in gvb.values()):
        fail("independent bad point has a vanishing gate")

    # 4. Logical consequence recorded
    print(
        "OK logical: no identity D^N P = a1 PB+a2 PY+a3 PZ with "
        "D| (Delta * named gates)^∞ can hold (evaluate at bad point)"
    )

    # 5. Sanity: exit claims no T11-FOLD-HEIGHT1
    if "T11-FOLD-HEIGHT1" in payload.get("not_claimed", []):
        print("OK not_claimed includes T11-FOLD-HEIGHT1")
    else:
        fail("packet must list T11-FOLD-HEIGHT1 as not claimed")

    result = {
        "exit": "T11B-UNDECIDED",
        "verified": True,
        "sealed_point_ok": True,
        "independent_bad_point": {
            "pt": list(pt),
            "gens": egb,
            "gates": gvb,
        },
        "headline": "OPEN",
    }
    out = HERE / "verify_routeC_result.json"
    out.write_text(json.dumps(result, indent=2))
    print("PASS T11B-UNDECIDED")
    print("wrote", out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
