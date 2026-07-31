#!/usr/bin/env python3
"""Independent verifier for Path T / Gate T1 (fold finite birationality).

Does NOT import the producer.  Reloads P, H, line witness, M2/Singular logs,
payload, and SEAL.  Re-checks line specialization, rank witnesses, hashes,
and claim consistency.  Does not re-eliminate u globally.  No timing fields.
"""

from __future__ import annotations

import json
import os
import resource
import sys
from collections import defaultdict
from functools import reduce
from hashlib import sha256
from math import gcd
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PRIMITIVE = (
    ROOT
    / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
)
H_PRIM = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
CEILING_MIB = 8192
CAP_ENV = "POSTELO_T_VERIFY_MIB"


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


def fail(msg: str) -> None:
    print(f"VERIFY_FAIL: {msg}", file=sys.stderr)
    sys.exit(1)


def load_P_terms():
    terms = []
    with PRIMITIVE.open() as stream:
        if next(stream).strip() != "A\tB\tY\tZ\tu\tcoefficient":
            fail("bad P TSV header")
        for line in stream:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    if len(terms) != 1593:
        fail(f"expected 1593 P terms, got {len(terms)}")
    return terms


def load_H_prim():
    rows = []
    with H_PRIM.open() as f:
        if next(f).strip() != "A\tB\tY\tZ\tcoefficient":
            fail("bad H TSV header")
        for line in f:
            a, b, y, z, c = map(int, line.split())
            rows.append(((a, b, y, z), c))
    return rows


def specialize_H_line123(rows):
    line = defaultdict(int)
    for (a, b, y, z), c in rows:
        line[z] += c * (2**b) * (3**y)
    deg = max(line) if line else 0
    return [line.get(i, 0) for i in range(deg + 1)]


def proportional(aa, bb) -> bool:
    n = max(len(aa), len(bb))
    aa = list(aa) + [0] * (n - len(aa))
    bb = list(bb) + [0] * (n - len(bb))
    for i in range(n):
        if aa[i] or bb[i]:
            if aa[i] == 0 or bb[i] == 0:
                return False
            ln, ld = aa[i], bb[i]
            return all(aa[j] * ld == bb[j] * ln for j in range(n))
    return True


def parse_m2_log(text: str) -> dict:
    out = {}
    for line in text.splitlines():
        line = line.strip()
        if line.startswith("DIM="):
            out["dim"] = int(line.split("=", 1)[1])
        elif line.startswith("DEG="):
            out["deg"] = int(line.split("=", 1)[1])
        elif line.startswith("GCD_Q11_H21_DEG="):
            out["gcd_q11_h21"] = int(line.split("=", 1)[1])
        elif line.startswith("GCD_LC_H21_DEG="):
            out["gcd_lc_h21"] = int(line.split("=", 1)[1])
        elif line.startswith("DIM_PUU="):
            out["dim_puu"] = int(line.split("=", 1)[1])
        elif line.startswith("DIM_LC="):
            out["dim_lc"] = int(line.split("=", 1)[1])
    return out


def parse_sing_log(text: str) -> dict:
    out = {}
    for line in text.splitlines():
        line = line.strip()
        if line.startswith("SING_DIM="):
            out["dim"] = int(line.split("=", 1)[1])
        elif line.startswith("SING_MULT="):
            out["mult"] = int(line.split("=", 1)[1])
        elif line.startswith("SING_DIM_PUU="):
            out["dim_puu"] = int(line.split("=", 1)[1])
        elif line.startswith("SING_DIM_LC="):
            out["dim_lc"] = int(line.split("=", 1)[1])
    return out


def main() -> None:
    enforce_limit()
    payload_path = HERE / "payload.json"
    seal_path = HERE / "SEAL.json"
    finite_md = HERE / "FINITE_BIRATIONAL.md"
    serre_md = HERE / "SERRE_NORMALITY.md"
    witness_path = HERE / "line_fiber_rank_witness.json"
    m2_log = HERE / "line_fiber_rank.m2.certificate"
    sing_log = HERE / "line_fiber_rank.sing.certificate"

    for p in (
        payload_path,
        seal_path,
        finite_md,
        serre_md,
        witness_path,
        m2_log,
        sing_log,
        PRIMITIVE,
        H_PRIM,
    ):
        if not p.is_file():
            fail(f"missing {p}")

    payload = json.loads(payload_path.read_text())
    seal = json.loads(seal_path.read_text())
    witness = json.loads(witness_path.read_text())

    if payload.get("headline") != "OPEN":
        fail("headline must remain OPEN")
    if payload.get("gate_T1") != "T-BIRATIONAL":
        fail(f"expected gate_T1=T-BIRATIONAL, got {payload.get('gate_T1')}")
    if seal.get("gate_T1") != "T-BIRATIONAL":
        fail("seal gate mismatch")
    if payload.get("T2_status") != "PLAN_ONLY":
        fail("T2 must be PLAN_ONLY under this dispatch")
    if payload.get("T3_status") != "NOT_STARTED" or payload.get("T4_status") != "NOT_STARTED":
        fail("T3/T4 must not be started")

    claims = payload.get("claims", {})
    for key in (
        "S_finite_over_B",
        "Frac_S_equals_Frac_B",
        "selected_component_is_mult1_simple_fold",
    ):
        if claims.get(key) is not True:
            fail(f"claim {key} not True")
    if claims.get("generic_rank") != 1:
        fail("generic_rank must be 1")

    # hashes
    if file_hash(payload_path) != seal.get("payload_sha256"):
        fail("payload sha mismatch")
    if file_hash(finite_md) != seal.get("FINITE_BIRATIONAL_sha256"):
        fail("FINITE_BIRATIONAL sha mismatch")
    if file_hash(serre_md) != seal.get("SERRE_NORMALITY_sha256"):
        fail("SERRE_NORMALITY sha mismatch")
    if file_hash(witness_path) != seal.get("line_fiber_rank_witness_sha256"):
        fail("witness sha mismatch")
    if file_hash(m2_log) != seal.get("line_fiber_rank_m2_certificate_sha256"):
        fail("m2 certificate sha mismatch")
    if file_hash(sing_log) != seal.get("line_fiber_rank_sing_certificate_sha256"):
        fail("sing certificate sha mismatch")

    core = {k: v for k, v in seal.items() if k != "seal_sha256"}
    core_bytes = (json.dumps(core, indent=2, sort_keys=True) + "\n").encode()
    if sha256(core_bytes).hexdigest() != seal.get("seal_sha256"):
        fail("seal self-hash mismatch")

    # P
    terms = load_P_terms()
    content = reduce(gcd, (abs(c) for _, c in terms))
    if content != 1:
        fail(f"P content {content} != 1")
    if max(e[4] for e, _ in terms) != 6:
        fail("P not degree 6 in u")
    lc_terms = [((a, b, y, z), c) for (a, b, y, z, u), c in terms if u == 6]
    max_lc = max(a + b + y + z for (a, b, y, z), _ in lc_terms)

    # H
    Hrows = load_H_prim()
    if len(Hrows) != 37992:
        fail(f"H terms {len(Hrows)}")
    gH = 0
    for _, c in Hrows:
        gH = gcd(gH, abs(c))
    if gH != 1:
        fail(f"H content {gH}")
    if max(sum(m) for m, _ in Hrows) != 43:
        fail("H degree != 43")
    if max_lc >= 43:
        fail("lc degree should be < 43 so H cannot divide lc")

    # line match vs witness H21
    H21 = witness.get("H21_coeffs")
    if not H21 or len(H21) != 22:
        fail("witness missing H21 coeffs of length 22")
    line = specialize_H_line123(Hrows)
    if not proportional(line, H21):
        fail("H|(1,2,3,s) not proportional to witness H21")

    # witness internal consistency
    if witness.get("generic_rank_on_line_branch") != 1:
        fail("witness generic rank != 1")
    if witness.get("subresultant_criterion", {}).get("gcd_degree") != 1:
        fail("witness subresultant gcd deg != 1")
    if not witness.get("H21_irreducible"):
        fail("H21 not marked irreducible")
    sres = witness.get("subresultants_on_H21", [])
    if not sres:
        fail("missing subresultant ledger")
    if not sres[-1].get("zero_on_H21"):
        fail("Res (Sres deg 0) must vanish on H21")
    if sres[-2].get("deg_u") != 1 or sres[-2].get("zero_on_H21"):
        fail("Sres deg 1 must be nonzero on H21")

    # engine logs
    m2 = parse_m2_log(m2_log.read_text())
    sing = parse_sing_log(sing_log.read_text())
    if m2.get("dim") != 0 or m2.get("deg") != 21:
        fail(f"M2 dim/deg unexpected: {m2}")
    if m2.get("dim_puu") != -1 or m2.get("dim_lc") != -1:
        fail(f"M2 Puu/lc support not empty: {m2}")
    if m2.get("gcd_q11_h21") != 0 or m2.get("gcd_lc_h21") != 0:
        fail(f"M2 gcd degrees unexpected: {m2}")
    if sing.get("dim") != 0 or sing.get("mult") != 21:
        fail(f"Singular dim/mult unexpected: {sing}")
    if sing.get("dim_puu") != -1 or sing.get("dim_lc") != -1:
        fail(f"Singular Puu/lc support not empty: {sing}")

    # payload cross-check
    lw = payload.get("line_witness", {})
    if lw.get("m2") != m2:
        fail("payload m2 block does not match log")
    if lw.get("singular") != sing:
        fail("payload singular block does not match log")

    # source hashes
    sources = seal.get("sources_sha256", {})
    if sources.get(str(PRIMITIVE.relative_to(ROOT))) != file_hash(PRIMITIVE):
        fail("P source hash mismatch")
    if sources.get(str(H_PRIM.relative_to(ROOT))) != file_hash(H_PRIM):
        fail("H source hash mismatch")

    # SERRE plan must not claim completed normality
    serre_text = serre_md.read_text()
    if "PLAN ONLY" not in serre_text and "plan only" not in serre_text.lower():
        fail("SERRE_NORMALITY.md must remain a plan-only document")
    if "T-NORMAL" in serre_text and "Proved: T-NORMAL" in serre_text:
        fail("T2 normality must not be claimed proved")

    # no timing fields in payload/seal
    for blob_name, blob in ("payload", payload), ("seal", seal):
        raw = json.dumps(blob)
        for bad in ("seconds", "elapsed", "runtime", "wall_time", "cpu_time"):
            if bad in raw.lower():
                # allow words in prose paths only if exact key absent
                pass
        if any(k for k in blob if "time" in k.lower() or "duration" in k.lower()):
            fail(f"timing-like key in {blob_name}")

    print("POSTELO_T1_FOLD_BIRATIONAL_VERIFIER_ACCEPT")
    print("gate_T1=T-BIRATIONAL")
    print("generic_rank=1")
    print("line_bivariate_degree=21")
    print("T2_status=PLAN_ONLY")
    print(f"payload_sha256={seal['payload_sha256']}")
    print("headline=OPEN")


if __name__ == "__main__":
    main()
