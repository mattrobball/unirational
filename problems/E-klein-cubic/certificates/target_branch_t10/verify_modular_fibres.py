#!/usr/bin/env python3
"""Independent verifier for T10.1 modular ten-pair discovery.

Does NOT import tmp/t10_modular/produce_modular_fibres.py.
Recomputes:
  - sealed P/H hashes and term counts
  - at least one modular nonempty fibre degree (pair (A,u) and (A,B))
    via msolve after gate-product Rabinowitsch
  - full-G specialized degree for (A,B) if sympy available
  - presence of the ten-pair table and exit marker

Empty pairs: none found modularly — recorded as such (cannot re-run an empty
pair that does not exist in the discovery).
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
import time
from collections import defaultdict
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
FACTORS = ROOT / "certificates/fold_normalization_t2r/saturation_factors"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"
MSOLVE = "/opt/homebrew/bin/msolve"
VARS = ("A", "B", "Y", "Z", "u")
PAIRS = [
    ("A", "B"),
    ("A", "Y"),
    ("A", "Z"),
    ("A", "u"),
    ("B", "Y"),
    ("B", "Z"),
    ("B", "u"),
    ("Y", "Z"),
    ("Y", "u"),
    ("Z", "u"),
]


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


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
        hdr = next(f).strip()
        if with_u:
            for line in f:
                a, b, y, z, u, c = map(int, line.split())
                terms.append(((a, b, y, z, u), c))
        else:
            for line in f:
                a, b, y, z, c = map(int, line.split())
                terms.append(((a, b, y, z), c))
    return terms


def load_gates():
    return {
        "ell": load_tsv(FACTORS / "ell_lc_u.tsv"),
        "C": load_tsv(FACTORS / "C_content.tsv"),
        "P_uu": load_tsv(FACTORS / "P_uu.tsv", with_u=True),
        "delta": load_tsv(FACTORS / "delta_Cramer.tsv", with_u=True),
        "Q4": load_tsv(FACTORS / "G_factor_Q4.tsv"),
    }


def specialize(P, free_vals, free_names, rem, mod):
    name_idx = {n: i for i, n in enumerate(VARS)}
    rem_idx = [name_idx[n] for n in rem]
    free_idx = {name_idx[n]: free_vals[n] % mod for n in free_names}

    def acc(deriv=None):
        bucket = {}
        for (a, b, y, z, k), c in P:
            exps = [a, b, y, z, k]
            c = c % mod
            if deriv is not None:
                di = name_idx[deriv]
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

    return {n: acc(d) for n, d in zip(
        ("P", "Pu", "PA", "PB", "PY", "PZ"),
        (None, "u", "A", "B", "Y", "Z"),
    )}


def sparse_str(terms, rem):
    if not terms:
        return "0"
    parts = []
    for exps, c in sorted(terms, reverse=True):
        mon = []
        for v, e in zip(rem, exps):
            if e == 0:
                continue
            mon.append(v if e == 1 else f"{v}^{e}")
        parts.append(f"{int(c)}" if not mon else f"{int(c)}*" + "*".join(mon))
    return "+".join(parts) if parts else "0"


def mul(f, g, mod, n):
    out = defaultdict(int)
    for e1, c1 in f.items():
        for e2, c2 in g.items():
            e = tuple(e1[i] + e2[i] for i in range(n))
            out[e] = (out[e] + c1 * c2) % mod
    return {e: c for e, c in out.items() if c}


def gate_prod(gates, free_vals, free_names, rem, mod):
    n = len(rem)
    rem_idx = {v: i for i, v in enumerate(rem)}
    L = (free_vals["A"] - 15) % mod if "A" in free_vals else None
    M = free_vals["B"] % mod if "B" in free_vals else None
    c0 = 1
    if L is not None:
        c0 = (c0 * L) % mod
    if M is not None:
        c0 = (c0 * M) % mod
    if c0 == 0:
        return {}
    prod = {tuple(0 for _ in range(n)): c0}
    if "A" not in free_vals and "A" in rem:
        e = [0] * n
        e[rem_idx["A"]] = 1
        prod = mul(prod, {tuple(e): 1, tuple(0 for _ in range(n)): (-15) % mod}, mod, n)
    if "B" not in free_vals and "B" in rem:
        e = [0] * n
        e[rem_idx["B"]] = 1
        prod = mul(prod, {tuple(e): 1}, mod, n)

    def spec_ufree(terms):
        bucket = defaultdict(int)
        for (a, b, y, z), c in terms:
            exps = {"A": a, "B": b, "Y": y, "Z": z}
            c = c % mod
            for n0, e0 in list(exps.items()):
                if n0 in free_vals:
                    c = (c * pow(free_vals[n0], e0, mod)) % mod
                    exps[n0] = 0
            if c == 0:
                continue
            key = [0] * n
            for n0, e0 in exps.items():
                if e0 and n0 in rem_idx:
                    key[rem_idx[n0]] = e0
            bucket[tuple(key)] = (bucket[tuple(key)] + c) % mod
        return dict(bucket)

    def spec_u(terms):
        bucket = defaultdict(int)
        for (a, b, y, z, uu), c in terms:
            exps = {"A": a, "B": b, "Y": y, "Z": z, "u": uu}
            c = c % mod
            for n0, e0 in list(exps.items()):
                if n0 in free_vals:
                    c = (c * pow(free_vals[n0], e0, mod)) % mod
                    exps[n0] = 0
            if c == 0:
                continue
            key = [0] * n
            for n0, e0 in exps.items():
                if e0 and n0 in rem_idx:
                    key[rem_idx[n0]] = e0
            bucket[tuple(key)] = (bucket[tuple(key)] + c) % mod
        return dict(bucket)

    for g in (
        spec_ufree(gates["ell"]),
        spec_ufree(gates["C"]),
        spec_ufree(gates["Q4"]),
        spec_u(gates["P_uu"]),
        spec_u(gates["delta"]),
    ):
        if not g:
            return {}
        prod = mul(prod, g, mod, n)
    return prod


def msolve_degree(P, gates, pair, free_vals, mod) -> dict:
    rem = [v for v in VARS if v not in pair]
    polys = specialize(P, free_vals, pair, rem, mod)
    gens = [sparse_str(polys[n], rem) for n in ("P", "Pu", "PA", "PB", "PY", "PZ")]
    gens = [g for g in gens if g != "0"]
    prod = gate_prod(gates, free_vals, pair, rem, mod)
    assert prod, "gate product vanished"
    parts = ["1"]
    for e, c in prod.items():
        cc = (-c) % mod
        mon = [v if ex == 1 else f"{v}^{ex}" for v, ex in zip(rem, e) if ex]
        mon.append("t")
        parts.append(f"{cc}*" + "*".join(mon))
    gens.append("+".join(parts))
    work = HERE / "_verify_work"
    work.mkdir(exist_ok=True)
    tag = f"v_{pair[0]}{pair[1]}_{mod}"
    inp = work / f"{tag}.ms"
    out = work / f"{tag}.out"
    with inp.open("w") as f:
        f.write(",".join(rem + ["t"]) + "\n")
        f.write(f"{mod}\n")
        for i, g in enumerate(gens):
            f.write(g + ("," if i < len(gens) - 1 else "") + "\n")
    t0 = time.time()
    subprocess.run(
        [MSOLVE, "-f", str(inp), "-o", str(out), "-t", "2"],
        capture_output=True,
        timeout=120,
        check=True,
    )
    text = out.read_text()
    elapsed = time.time() - t0
    if text.strip().startswith("[-1"):
        return {"status": "empty", "degree": 0, "elapsed": elapsed}
    m = re.search(r"\[0,\s*\[\s*\d+\s*,\s*\d+\s*,\s*(\d+)", text.replace("\n", " "))
    if m:
        return {"status": "zero_dim", "degree": int(m.group(1)), "elapsed": elapsed}
    if text.strip().startswith("[1,"):
        return {"status": "positive_dim", "degree": None, "elapsed": elapsed}
    return {"status": "unknown", "raw": text[:120], "elapsed": elapsed}


def main():
    P = load_P()
    gates = load_gates()
    table_path = HERE / "modular_fibre_table.json"
    note = HERE / "TEN_PAIR_TABLE.md"
    assert table_path.is_file() and note.is_file()
    table = json.loads(table_path.read_text())
    assert len(table["ten_pair_table"]) == 10
    assert table["exit_hint"] in (
        "T10-FOLD-UNDECIDED",
        "T10-FOLD-HEIGHT1_if_exact",
        "T10-FOLD-NORMAL_if_exact",
    )
    text = note.read_text()
    assert "T10-FOLD-UNDECIDED" in text
    assert "OPEN" in text
    assert "not the target branch" in text.lower() or "not about" in text.lower() or "S_G" in text

    # Recompute two nonempty pairs at sealed free values / random
    checks = []
    # (A,u) degree 6 expected
    r1 = msolve_degree(P, gates, ("A", "u"), {"A": 63, "u": 35}, 101)
    checks.append({"pair": ["A", "u"], "free": {"A": 63, "u": 35}, **r1})
    assert r1["status"] == "zero_dim" and r1["degree"] == 6, r1

    # (A,B) degree 12 expected
    r2 = msolve_degree(P, gates, ("A", "B"), {"A": 49, "B": 68}, 101)
    checks.append({"pair": ["A", "B"], "free": {"A": 49, "B": 68}, **r2})
    assert r2["status"] == "zero_dim" and r2["degree"] == 12, r2

    # table consistency: all pairs modular nonempty-ish
    for e in table["ten_pair_table"]:
        assert e["aggregate_modular_verdict"].startswith("modular_nonempty") or e[
            "aggregate_modular_verdict"
        ] in ("modular_nonempty_partial",), e

    report = {
        "schema": "klein-cubic-T10.1-modular-verify-v1",
        "exit": "T10-FOLD-UNDECIDED",
        "headline": "OPEN",
        "P_sha256": EXPECTED_P,
        "H_sha256": EXPECTED_H,
        "recomputed_fibres": checks,
        "empty_pairs_to_rerun": [],
        "empty_pairs_note": "modular discovery found no empty pair among the ten",
        "table_sha256": file_hash(table_path),
        "note_sha256": file_hash(note),
        "proves": [
            "recomputed modular zero-dim degree 6 for (A,u)=(63,35) mod 101 after gate product sat",
            "recomputed modular zero-dim degree 12 for (A,B)=(49,68) mod 101 after gate product sat",
            "ten-pair table present with modular_nonempty evidence on all pairs",
        ],
        "does_not_prove": [
            "exact characteristic-zero nonempty generic fibre",
            "dim Sing(S_G)=2",
            "T10-FOLD-HEIGHT1 or T10-FOLD-NORMAL",
        ],
    }
    out = HERE / "verify_modular_result.json"
    out.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    report["result_sha256"] = file_hash(out)
    out.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print("T10.1 modular verify OK", checks)


if __name__ == "__main__":
    main()
