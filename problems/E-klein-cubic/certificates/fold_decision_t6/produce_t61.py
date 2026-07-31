#!/usr/bin/env python3
"""T6.1 producer — factorwise saturation ledger seal."""
from __future__ import annotations

import json
import os
import resource
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
CEILING_MIB = 8192
CAP_ENV = "T61_PRODUCER_MIB"


def enforce_limit() -> None:
    ceiling = CEILING_MIB * 1024**2
    try:
        resource.setrlimit(resource.RLIMIT_AS, (ceiling, ceiling))
    except (OSError, ValueError):
        if sys.platform != "darwin":
            raise
        if os.environ.get(CAP_ENV) == str(CEILING_MIB):
            return
        env = dict(os.environ)
        env[CAP_ENV] = str(CEILING_MIB)
        os.execve(
            "/usr/sbin/taskpolicy",
            ["taskpolicy", "-m", str(CEILING_MIB), sys.executable, *sys.argv],
            env,
        )


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def msolve_has_basis(path: Path) -> bool:
    t = path.read_text()[:500]
    return "length of basis" in t or "Reduced Groebner" in t


def main() -> None:
    enforce_limit()
    assert (HERE / "FACTORWISE_SATURATION.md").is_file()
    assert (HERE / "saturation_ledger.json").is_file()
    md = (HERE / "FACTORWISE_SATURATION.md").read_text()
    assert "BOTTLENECK-T61-EXACT-FACTORWISE-SAT-DIM" in md
    assert "full-product" in md.lower() or "giant" in md.lower() or "NOT_RERUN" in md

    ledger = json.loads((HERE / "saturation_ledger.json").read_text())
    assert ledger["stages"][0]["exact_krull_dim"] is None

    msolve = HERE / "msolve"
    j0 = msolve / "J0_p101_g2.out"
    satM = msolve / "J0_sat_M_p101_g2.out"
    assert j0.is_file() and msolve_has_basis(j0)
    assert satM.is_file() and msolve_has_basis(satM)

    # dim extraction consistency with ledger
    def dim_lm(path: Path) -> int:
        import re
        from itertools import combinations

        text = path.read_text()
        vo = re.search(r"variable order:\s*(.*)", text).group(1).strip()
        varnames = [v.strip() for v in vo.split(",")]
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

        for d in range(len(varnames), -1, -1):
            if any(free_set(S) for S in combinations(varnames, d)):
                return d
        return -1

    d0 = dim_lm(j0)
    dM = dim_lm(satM)
    assert d0 == 3, d0
    assert dM == 3, dM
    assert ledger["stages"][0]["modular_discovery"]["dim_LM"] == 3
    assert ledger["stages"][1]["modular_discovery"]["dim_LM"] == 3

    payload = {
        "schema": "klein-cubic-T61-payload-v1",
        "gate": "T6.1",
        "exit": "T61-LEDGER-INCOMPLETE",
        "exact_J_open_sealed": False,
        "modular_J0_dim_p101": d0,
        "modular_sat_M_dim_p101": dM,
        "bottleneck": "BOTTLENECK-T61-EXACT-FACTORWISE-SAT-DIM",
        "msolve": {
            "J0_p101_g2.out": file_hash(j0),
            "J0_sat_M_p101_g2.out": file_hash(satM),
        },
        "ledger_sha256": file_hash(HERE / "saturation_ledger.json"),
        "md_sha256": file_hash(HERE / "FACTORWISE_SATURATION.md"),
    }
    out = HERE / "t61_payload.json"
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    payload["payload_sha256"] = file_hash(out)
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("T61_PRODUCER_SEALED", payload["exit"], "dimJ0", d0, "dimSatM", dM)


if __name__ == "__main__":
    main()
