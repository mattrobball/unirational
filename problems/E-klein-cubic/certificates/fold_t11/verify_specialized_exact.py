#!/usr/bin/env python3
"""Independent verifier for T11.1 specialized exact fibres (support for undecided).

Does NOT import the producer. Recomputes, over QQ via Macaulay2, that at the
sealed modular chart point (A,u)=(63,35) the gate-saturated I_sing is
zero-dimensional of degree 6. Also rechecks one holdout specialization.

This does NOT by itself prove T11-FOLD-HEIGHT1 (generic fibre over Q(A,u)).
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
from collections import defaultdict
from hashlib import sha256
from math import gcd
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"
M2 = "/opt/homebrew/bin/M2"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
WORK = HERE / "_verify_work"


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def fail(msg: str):
    print("FAIL:", msg)
    sys.exit(1)


def load_P():
    if file_hash(P_PATH) != EXPECTED_P:
        fail("P hash")
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


def specialize_Z(P, A0, U0, deriv=None):
    name_idx = {"A": 0, "B": 1, "Y": 2, "Z": 3, "u": 4}
    bucket = defaultdict(int)
    for (a, b, y, z, k), c in P:
        exps = [a, b, y, z, k]
        coef = c
        if deriv is not None:
            di = name_idx[deriv]
            if exps[di] == 0:
                continue
            coef *= exps[di]
            exps[di] -= 1
        coef *= (A0 ** exps[0]) * (U0 ** exps[4])
        if coef == 0:
            continue
        bucket[(exps[1], exps[2], exps[3])] += coef
    terms = [(e, c) for e, c in bucket.items() if c]
    g = 0
    for _, c in terms:
        g = gcd(g, abs(c)) if g else abs(c)
    if g > 1:
        terms = [(e, c // g) for e, c in terms]
    return terms


def sstr(terms):
    parts = []
    for exps, c in sorted(terms, reverse=True):
        mon = []
        for v, e in zip(("B", "Y", "Z"), exps):
            if e == 0:
                continue
            mon.append(v if e == 1 else f"{v}^{e}")
        if not mon:
            parts.append(f"({c}_QQ)")
        elif c == 1:
            parts.append("*".join(mon))
        elif c == -1:
            parts.append("-" + ("*".join(mon)))
        else:
            parts.append(f"({c}_QQ)*" + ("*".join(mon)))
    body = "+".join(parts) if parts else "0_QQ"
    return f"({body})+0*B"


def prim_ufree(terms, A0):
    bucket = defaultdict(int)
    for (a, b, y, z), c in terms:
        bucket[(b, y, z)] += c * (A0 ** a)
    terms = [(e, c) for e, c in bucket.items() if c]
    g = 0
    for _, c in terms:
        g = gcd(g, abs(c)) if g else abs(c)
    if g > 1:
        terms = [(e, c // g) for e, c in terms]
    return terms


def prim_u(terms, A0, U0):
    bucket = defaultdict(int)
    for (a, b, y, z, uu), c in terms:
        bucket[(b, y, z)] += c * (A0 ** a) * (U0 ** uu)
    terms = [(e, c) for e, c in bucket.items() if c]
    g = 0
    for _, c in terms:
        g = gcd(g, abs(c)) if g else abs(c)
    if g > 1:
        terms = [(e, c // g) for e, c in terms]
    return terms


def m2_fibre(P, gates, A0, U0):
    WORK.mkdir(exist_ok=True)
    m2 = WORK / f"v_spec_{A0}_{U0}.m2"
    out = WORK / f"v_spec_{A0}_{U0}.out"
    with m2.open("w") as f:
        f.write("R=QQ[B,Y,Z,MonomialOrder=>GRevLex];\n")
        for n, d in zip(("P", "Pu", "PA", "PB", "PY", "PZ"), (None, "u", "A", "B", "Y", "Z")):
            f.write(f"{n}={sstr(specialize_Z(P, A0, U0, d))};\n")
        f.write(f"ell={sstr(prim_ufree(gates['ell'], A0))};\n")
        f.write(f"Cgate={sstr(prim_ufree(gates['C'], A0))};\n")
        f.write(f"Q4={sstr(prim_ufree(gates['Q4'], A0))};\n")
        f.write(f"Puu={sstr(prim_u(gates['P_uu'], A0, U0))};\n")
        f.write(f"delta={sstr(prim_u(gates['delta'], A0, U0))};\n")
        f.write(
            """
I=ideal(P,Pu,PA,PB,PY,PZ);
I=saturate(I,B);
I=saturate(I,ell);
I=saturate(I,Q4);
I=saturate(I,Puu);
I=saturate(I,Cgate);
I=saturate(I,delta);
<< "sat_dim=" << dim I << ",sat_deg=" << degree I << endl;
"""
        )
    subprocess.run([M2, "--script", str(m2)], stdout=out.open("w"), stderr=subprocess.DEVNULL, timeout=120, check=True)
    text = out.read_text()
    m = re.search(r"sat_dim=(\d+),sat_deg=(\d+)", text)
    if not m:
        fail(f"parse failed: {text[:200]}")
    return int(m.group(1)), int(m.group(2))


def main():
    payload_path = HERE / "specialized_exact_fibres.json"
    if not payload_path.is_file():
        fail("missing specialized_exact_fibres.json")
    payload = json.loads(payload_path.read_text())
    P = load_P()
    gates = {
        "ell": load_tsv(FACTORS / "ell_lc_u.tsv"),
        "C": load_tsv(FACTORS / "C_content.tsv"),
        "P_uu": load_tsv(FACTORS / "P_uu.tsv", with_u=True),
        "delta": load_tsv(FACTORS / "delta_Cramer.tsv", with_u=True),
        "Q4": load_tsv(FACTORS / "G_factor_Q4.tsv"),
    }
    # sealed modular chart specialization
    d1, g1 = m2_fibre(P, gates, 63, 35)
    if d1 != 0 or g1 != 6:
        fail(f"(63,35) got dim={d1} deg={g1}")
    # holdout
    d2, g2 = m2_fibre(P, gates, 0, 1)
    if d2 != 0 or g2 != 6:
        fail(f"(0,1) got dim={d2} deg={g2}")

    report = {
        "schema": "klein-cubic-T11.1-specialized-verify-v1",
        "exit_support": "T11-FOLD-UNDECIDED",
        "headline": "OPEN",
        "checks": {
            "P_sha256": EXPECTED_P,
            "fibre_63_35": {"dim": d1, "deg": g1},
            "fibre_0_1_holdout": {"dim": d2, "deg": g2},
        },
        "proves": [
            "At (A,u)=(63,35) over Q, sequential gate sat of I_sing is 0-dim of degree 6",
            "Holdout (0,1) likewise degree 6 over Q",
        ],
        "does_not_prove": [
            "exact finite algebra over the function field Q(A,u)",
            "T11-FOLD-HEIGHT1 / nonnormality of S_G",
        ],
        "payload_sha256": file_hash(payload_path),
    }
    out = HERE / "verify_specialized_exact_result.json"
    out.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print("T11.1 specialized verify OK", report["checks"])


if __name__ == "__main__":
    main()
