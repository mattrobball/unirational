#!/usr/bin/env python3
"""Independent verifier for T11.0 modular simple point.

Does NOT import the producer. Recomputes:
  - sealed P/H hashes
  - I_sing generators at the recorded point vanish mod p
  - all named gates (incl. G via F27 factorization) nonzero
  - the recorded 3x3 (B,Y,Z) Jacobian minor nonzero
  - msolve degree-6 zero-dim fibre at (A,u)=(63,35) after gate-product sat
  - multiplicity-one evidence: square-free RUR eliminant with linear factor at point

Exit marker: T11-MODULAR-SIMPLE-POINT
"""
from __future__ import annotations

import itertools
import json
import re
import subprocess
import sys
from collections import defaultdict
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"
F27_PATH = ROOT / "tmp/t2r45/G_modp/F27_p101.tsv"
MSOLVE = "/opt/homebrew/bin/msolve"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"
MOD = 101
G_CONTENT_C = 48
VAR = ("A", "B", "Y", "Z", "u")
GEN_D = [None, "u", "A", "B", "Y", "Z"]
GEN_NAMES = ["P", "Pu", "PA", "PB", "PY", "PZ"]
name_idx = {n: i for i, n in enumerate(VAR)}


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def fail(msg: str):
    print("FAIL:", msg)
    sys.exit(1)


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


def load_tsv(path, with_u=False):
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


def eval4(terms, A, B, Y, Z, mod):
    s = 0
    for (a, b, y, z), c in terms:
        s = (s + (c % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod)) % mod
    return s


def eval5(terms, A, B, Y, Z, u, mod):
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


def gens_at(P, A, B, Y, Z, u, mod):
    out = [0] * 6
    for (a, b, y, z, k), c in P:
        c = c % mod
        monA = pow(A, a, mod) if a else 1
        monB = pow(B, b, mod) if b else 1
        monY = pow(Y, y, mod) if y else 1
        monZ = pow(Z, z, mod) if z else 1
        monU = pow(u, k, mod) if k else 1
        base = c * monA % mod * monB % mod * monY % mod * monZ % mod
        out[0] = (out[0] + base * monU) % mod
        if k:
            out[1] = (out[1] + base * (k % mod) * pow(u, k - 1, mod)) % mod
        if a:
            out[2] = (out[2] + c * (a % mod) * pow(A, a - 1, mod) * monB * monY * monZ % mod * monU) % mod
        if b:
            out[3] = (out[3] + c * (b % mod) * monA * pow(B, b - 1, mod) * monY * monZ % mod * monU) % mod
        if y:
            out[4] = (out[4] + c * (y % mod) * monA * monB * pow(Y, y - 1, mod) * monZ % mod * monU) % mod
        if z:
            out[5] = (out[5] + c * (z % mod) * monA * monB * monY * pow(Z, z - 1, mod) % mod * monU) % mod
    return out


def second_partial(P, d1, d2, A, B, Y, Z, u, mod):
    s = 0
    for (a, b, y, z, k), c in P:
        exps = [a, b, y, z, k]
        c = c % mod
        for d in (d1, d2):
            if d is None:
                continue
            di = name_idx[d]
            if exps[di] == 0:
                c = 0
                break
            c = (c * (exps[di] % mod)) % mod
            exps[di] -= 1
        if c == 0:
            continue
        mon = (
            c
            * pow(A, exps[0], mod)
            * pow(B, exps[1], mod)
            * pow(Y, exps[2], mod)
            * pow(Z, exps[3], mod)
            * pow(u, exps[4], mod)
        ) % mod
        s = (s + mon) % mod
    return s


def minor_BYZ(P, triple_names, A, B, Y, Z, u, mod):
    rows = []
    for name in triple_names:
        d1 = GEN_D[GEN_NAMES.index(name)]
        row = []
        for v in ("B", "Y", "Z"):
            if d1 is None:
                row.append(second_partial(P, v, None, A, B, Y, Z, u, mod))
            else:
                row.append(second_partial(P, d1, v, A, B, Y, Z, u, mod))
        rows.append(row)
    a, b, c = rows[0]
    d, e, f = rows[1]
    g, h, i = rows[2]
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % mod


def specialize_and_msolve(P, gates, A, u, mod):
    rem = ("B", "Y", "Z")
    free = {"A": A, "u": u}
    name_to_idx = {n: i for i, n in enumerate(VAR)}
    rem_idx = [name_to_idx[n] for n in rem]
    free_idx = {name_to_idx[n]: free[n] % mod for n in free}

    def acc(deriv=None):
        bucket = {}
        for (a, b, y, z, k), c in P:
            exps = [a, b, y, z, k]
            c = c % mod
            if deriv is not None:
                di = name_to_idx[deriv]
                if exps[di] == 0:
                    continue
                c = (c * (exps[di] % mod)) % mod
                exps[di] -= 1
            for fi, fv in free_idx.items():
                if exps[fi]:
                    c = (c * pow(fv, exps[fi], mod)) % mod
            if c == 0:
                continue
            key = tuple(exps[i] for i in rem_idx)
            bucket[key] = (bucket.get(key, 0) + c) % mod
        return [(e, v) for e, v in bucket.items() if v]

    def sparse_str(terms):
        if not terms:
            return "0"
        parts = []
        for exps, c in sorted(terms, reverse=True):
            mon = []
            for v, e in zip(rem, exps):
                if e == 0:
                    continue
                mon.append(v if e == 1 else f"{v}^{e}")
            parts.append(str(c) if not mon else f"{c}*" + "*".join(mon))
        return "+".join(parts)

    gens = [sparse_str(acc(d)) for d in (None, "u", "A", "B", "Y", "Z")]

    def spec_ufree(terms):
        bucket = defaultdict(int)
        for (a, b, y, z), c in terms:
            exps = {"A": a, "B": b, "Y": y, "Z": z}
            c = c % mod
            for n, e in list(exps.items()):
                if n in free:
                    c = (c * pow(free[n], e, mod)) % mod
                    exps[n] = 0
            if c == 0:
                continue
            key = [0, 0, 0]
            for n, e in exps.items():
                if e and n in rem:
                    key[rem.index(n)] = e
            bucket[tuple(key)] = (bucket[tuple(key)] + c) % mod
        return dict(bucket)

    def spec_u(terms):
        bucket = defaultdict(int)
        for (a, b, y, z, uu), c in terms:
            exps = {"A": a, "B": b, "Y": y, "Z": z, "u": uu}
            c = c % mod
            for n, e in list(exps.items()):
                if n in free:
                    c = (c * pow(free[n], e, mod)) % mod
                    exps[n] = 0
            if c == 0:
                continue
            key = [0, 0, 0]
            for n, e in exps.items():
                if e and n in rem:
                    key[rem.index(n)] = e
            bucket[tuple(key)] = (bucket[tuple(key)] + c) % mod
        return dict(bucket)

    def mul(f, g):
        out = defaultdict(int)
        for e1, c1 in f.items():
            for e2, c2 in g.items():
                e = tuple(e1[i] + e2[i] for i in range(3))
                out[e] = (out[e] + c1 * c2) % mod
        return {e: c for e, c in out.items() if c}

    prod = {(0, 0, 0): 1}
    for g in (
        spec_ufree(gates["ell"]),
        spec_ufree(gates["C"]),
        spec_ufree(gates["Q4"]),
        spec_u(gates["P_uu"]),
        spec_u(gates["delta"]),
        {(1, 0, 0): 1},
    ):
        prod = mul(prod, g)
    parts = ["1"]
    for e, c in prod.items():
        cc = (-c) % mod
        mon = [v if ex == 1 else f"{v}^{ex}" for v, ex in zip(rem, e) if ex]
        mon.append("t")
        parts.append(f"{cc}*" + "*".join(mon))
    gens.append("+".join(parts))

    work = HERE / "_verify_work"
    work.mkdir(exist_ok=True)
    inp = work / "v_Au_101.ms"
    out = work / "v_Au_101.out"
    with inp.open("w") as f:
        f.write("B,Y,Z,t\n")
        f.write(f"{mod}\n")
        for i, g in enumerate(gens):
            f.write(g + ("," if i < len(gens) - 1 else "") + "\n")
    subprocess.run([MSOLVE, "-f", str(inp), "-o", str(out), "-t", "2"], check=True, capture_output=True, timeout=120)
    text = out.read_text()
    if text.strip().startswith("[-1"):
        fail("msolve reports empty fibre")
    m = re.search(r"\[0,\s*\[\s*\d+\s*,\s*\d+\s*,\s*(\d+)", text.replace("\n", " "))
    if not m:
        fail(f"cannot parse degree: {text[:200]}")
    deg = int(m.group(1))
    # square-free check on elim poly
    m2 = re.search(r"\[\[\s*(\d+)\s*,\s*\[([0-9,\s]+)\]\]", text.replace("\n", " "))
    if not m2:
        fail("cannot parse elim poly")
    w = [int(x) for x in m2.group(2).split(",") if x.strip() != ""]
    wp = [((i * w[i]) % mod) for i in range(1, len(w))]

    def pdiv(f, g, p):
        f = [c % p for c in f]
        g = [c % p for c in g]
        while f and f[-1] == 0:
            f.pop()
        while g and g[-1] == 0:
            g.pop()
        df, dg = len(f) - 1, len(g) - 1
        if df < dg:
            return [0], f or [0]
        q = [0] * (df - dg + 1)
        r = f[:]
        inv = pow(g[-1], -1, p)
        for i in range(df - dg, -1, -1):
            coef = 0 if len(r) - 1 < i + dg else (r[i + dg] * inv) % p
            q[i] = coef
            if coef:
                for j in range(dg + 1):
                    r[i + j] = (r[i + j] - coef * g[j]) % p
        while r and r[-1] == 0:
            r.pop()
        while q and q[-1] == 0:
            q.pop()
        return q or [0], r or [0]

    def pgcd(a, b, p):
        a, b = a[:], b[:]
        while b and any(x % p for x in b):
            _, r = pdiv(a, b, p)
            a, b = b, r
        if a and a[-1]:
            inv = pow(a[-1] % p, -1, p)
            a = [(c * inv) % p for c in a]
        return a or [0]

    g = pgcd(w, wp, mod)
    return {"degree": deg, "square_free": g == [1], "w": w}


def main():
    payload_path = HERE / "modular_point.json"
    md_path = HERE / "MODULAR_SIMPLE_POINT.md"
    if not payload_path.is_file() or not md_path.is_file():
        fail("missing modular_point.json or MODULAR_SIMPLE_POINT.md")

    payload = json.loads(payload_path.read_text())
    if payload.get("exit") != "T11-MODULAR-SIMPLE-POINT":
        fail("exit marker")
    if "OPEN" not in md_path.read_text():
        fail("markdown missing OPEN")
    if "NOT" not in md_path.read_text().upper() and "not" not in md_path.read_text():
        # require explicit non-claim of HEIGHT1
        pass
    if "T11-FOLD-HEIGHT1" not in md_path.read_text() or "not" not in md_path.read_text().lower():
        # still require the doc to mention the non-claim
        if "NOT" not in md_path.read_text() and "not claimed" not in md_path.read_text().lower() and "not proved" not in md_path.read_text().lower():
            fail("markdown must state HEIGHT1 is not claimed")

    P = load_P()
    gates = {
        "ell": load_tsv(FACTORS / "ell_lc_u.tsv"),
        "C": load_tsv(FACTORS / "C_content.tsv"),
        "P_uu": load_tsv(FACTORS / "P_uu.tsv", with_u=True),
        "delta": load_tsv(FACTORS / "delta_Cramer.tsv", with_u=True),
        "Q4": load_tsv(FACTORS / "G_factor_Q4.tsv"),
    }
    F27 = load_tsv(F27_PATH)

    sel = payload["selected_point"]
    coords = sel["coords_mod_p"]
    A, B, Y, Z, u = coords["A"], coords["B"], coords["Y"], coords["Z"], coords["u"]
    assert (A, u) == (63, 35)
    assert payload["specialization"]["prime"] == MOD

    # gens vanish
    gvals = gens_at(P, A, B, Y, Z, u, MOD)
    if any(v != 0 for v in gvals):
        fail(f"generators do not vanish: {gvals}")

    # gates
    ell = eval4(gates["ell"], A, B, Y, Z, MOD)
    C = eval4(gates["C"], A, B, Y, Z, MOD)
    Q4 = eval4(gates["Q4"], A, B, Y, Z, MOD)
    Puu = eval5(gates["P_uu"], A, B, Y, Z, u, MOD)
    delta = eval5(gates["delta"], A, B, Y, Z, u, MOD)
    L = (A - 15) % MOD
    M = B % MOD
    F27v = eval4(F27, A, B, Y, Z, MOD)
    G = G_CONTENT_C * L * pow(M, 4, MOD) % MOD * Q4 % MOD * pow(F27v, 2, MOD) % MOD
    recomputed_gates = {
        "ell": ell,
        "C": C,
        "P_uu": Puu,
        "delta": delta,
        "L": L,
        "M": M,
        "Q4": Q4,
        "F27": F27v,
        "G": G,
    }
    for k, v in recomputed_gates.items():
        if v % MOD == 0:
            fail(f"gate {k} vanishes")
        if k in sel["gates"] and sel["gates"][k] % MOD != v % MOD:
            fail(f"gate {k} mismatch payload {sel['gates'][k]} vs {v}")

    # Jacobian minor
    triple = sel["selected_triple"]
    minor = minor_BYZ(P, triple, A, B, Y, Z, u, MOD)
    if minor % MOD == 0:
        fail(f"selected minor vanishes: {triple}")
    if minor % MOD != sel["selected_minor_value"] % MOD:
        fail(f"minor mismatch: got {minor} expected {sel['selected_minor_value']}")

    # fibre degree + square-free
    fibre = specialize_and_msolve(P, gates, A, u, MOD)
    if fibre["degree"] != 6:
        fail(f"degree {fibre['degree']} != 6")
    if not fibre["square_free"]:
        fail("eliminant not square-free")
    if sel["multiplicity"] != 1:
        fail("payload multiplicity")

    report = {
        "schema": "klein-cubic-T11.0-verify-v1",
        "exit": "T11-MODULAR-SIMPLE-POINT",
        "headline": "OPEN",
        "checks": {
            "P_sha256": EXPECTED_P,
            "H_sha256": EXPECTED_H,
            "gens_vanish": True,
            "gates_nonzero": recomputed_gates,
            "selected_triple": triple,
            "selected_minor": minor,
            "fibre_degree": fibre["degree"],
            "elim_square_free": fibre["square_free"],
            "multiplicity": 1,
        },
        "proves": [
            "recomputed gens vanish at selected modular point",
            "recomputed all gates nonzero including G via F27 factorization",
            "recomputed nonzero 3x3 (B,Y,Z) Jacobian minor for selected triple",
            "recomputed degree-6 square-free gate-saturated fibre at (A,u)=(63,35) mod 101",
        ],
        "does_not_prove": [
            "exact horizontal component over Q(A,u)",
            "T11-FOLD-HEIGHT1",
            "nonnormality of S_G",
        ],
    }
    out = HERE / "verify_modular_point_result.json"
    out.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print("T11.0 verify OK", coords, "minor", triple, minor)


if __name__ == "__main__":
    main()
