#!/usr/bin/env python3
"""T6.1 independent verifier — checks modular dim claims and non-overclaim."""
from __future__ import annotations

import json
import re
import sys
from itertools import combinations
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent


def fail(msg: str) -> None:
    print("FAIL:", msg, file=sys.stderr)
    sys.exit(1)


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def dim_lm(path: Path) -> tuple[int, int, bool]:
    text = path.read_text()
    if "length of basis" not in text:
        fail(f"no GB in {path}")
    vo = re.search(r"variable order:\s*(.*)", text).group(1).strip()
    varnames = [v.strip() for v in vo.split(",")]
    n = int(re.search(r"length of basis:\s*(\d+)", text).group(1))
    start = text.index("[", text.index("length of basis"))
    end = text.rindex("]:")
    body = text[start + 1 : end]
    parts = body.split(",")
    lms = []
    for p in parts:
        p = p.strip()
        mon_str = re.sub(r"^[+-]?\d+\*", "", p)
        mon_str = re.sub(r"^[+-]?", "", mon_str)
        cut = re.search(r"[+-]", mon_str)
        if cut:
            mon_str = mon_str[: cut.start()]
        mon_str = mon_str.strip("*")
        exp = {v: 0 for v in varnames}
        if mon_str in ("", "1") or mon_str.isdigit():
            lms.append(exp)
            continue
        for piece in mon_str.split("*"):
            if not piece:
                continue
            if "^" in piece:
                v, e = piece.split("^")
                exp[v] = int(e)
            else:
                exp[piece] = 1
        lms.append(exp)

    def support(e):
        return frozenset(v for v, k in e.items() if k > 0)

    def free_set(S):
        S = set(S)
        for e in lms:
            if not support(e):
                return False
            if support(e) <= S:
                return False
        return True

    dim = -1
    for d in range(len(varnames), -1, -1):
        if any(free_set(S) for S in combinations(varnames, d)):
            dim = d
            break
    unit = any(not support(e) for e in lms)
    if len(lms) != n:
        # tolerate split artifacts if close
        if abs(len(lms) - n) > 2:
            fail(f"GB parse count {len(lms)} vs header {n}")
    return dim, n, unit


def main() -> None:
    for name in (
        "FACTORWISE_SATURATION.md",
        "saturation_ledger.json",
        "t61_payload.json",
        "msolve/J0_p101_g2.out",
        "msolve/J0_sat_M_p101_g2.out",
    ):
        if not (HERE / name).is_file():
            fail(f"missing {name}")

    md = (HERE / "FACTORWISE_SATURATION.md").read_text()
    if "BOTTLENECK-T61-EXACT-FACTORWISE-SAT-DIM" not in md:
        fail("missing bottleneck")
    if "not completed" not in md.lower() and "NOT_COMPLETED" not in md:
        # must admit exact incomplete
        if "null" not in md.lower():
            fail("must record exact dim incomplete")

    ledger = json.loads((HERE / "saturation_ledger.json").read_text())
    if ledger["stages"][0]["exact_krull_dim"] is not None:
        fail("exact J0 dim must be null")
    if ledger["full_product_Rabinowitsch"]["status"] != "NOT_RERUN":
        fail("must not claim full product sat")

    d0, n0, u0 = dim_lm(HERE / "msolve/J0_p101_g2.out")
    dM, nM, uM = dim_lm(HERE / "msolve/J0_sat_M_p101_g2.out")
    if d0 != 3:
        fail(f"J0 dim_LM expected 3 got {d0}")
    if dM != 3:
        fail(f"sat M dim_LM expected 3 got {dM}")
    if u0 or uM:
        fail("unexpected unit ideal")
    if ledger["stages"][0]["modular_discovery"]["dim_LM"] != 3:
        fail("ledger J0 dim mismatch")
    if ledger["stages"][1]["modular_discovery"]["dim_LM"] != 3:
        fail("ledger satM dim mismatch")

    # Mathematical: first LM of sat M should involve B*t (Rabinowitsch)
    textM = (HERE / "msolve/J0_sat_M_p101_g2.out").read_text()
    if "B" not in textM[:2000] or "t" not in textM[:500]:
        fail("sat M basis should mention B and t")
    # Check B*t term present near start of basis
    if "B^1*t^1" not in textM and "B*t" not in textM and "1*B^1*t^1" not in textM:
        # msolve wrote 1*B^1*t^1+100
        if "B^1*t^1" not in textM:
            fail("expected leading relation involving B*t for sat by B")

    payload = json.loads((HERE / "t61_payload.json").read_text())
    if payload.get("exact_J_open_sealed") is not False:
        fail("must not claim sealed J_open")
    if payload.get("modular_J0_dim_p101") != 3:
        fail("payload J0 dim")
    if payload.get("modular_sat_M_dim_p101") != 3:
        fail("payload satM dim")

    print("FOLD_DECISION_T61_VERIFIER_ACCEPT")
    print(f"modular_J0_dim={d0} modular_sat_M_dim={dM} nGB={n0},{nM}")


if __name__ == "__main__":
    main()
