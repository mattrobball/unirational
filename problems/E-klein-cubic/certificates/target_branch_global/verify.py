#!/usr/bin/env python3
"""Independent verifier for Attempt 2 Gate 1 (option (c) continuation).

Does NOT import the producer.  Reloads sealed H and P, rechecks content,
line specialization vs exact H_21, ratrecon summary claims, decision
consistency, and hashes.  Does not launch >8 GiB elimination jobs.
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
H_DIR = HERE / "H_factor"
H_PRIM = H_DIR / "H_primitive_integer.tsv"
H_MONIC = H_DIR / "H_monic_rational.tsv"
H_SUMMARY = H_DIR / "ratrecon_summary.json"
CEILING_MIB = 8192
CAP_ENV = "A2_GLOBAL_FOLD_VERIFY_MIB"


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


def exact_H21_coeffs(terms):
    import sympy as sp

    by_u = [defaultdict(int) for _ in range(7)]
    for (a, b, y, z, u), c in terms:
        by_u[u][z] += c * (2**b) * (3**y)
    s, u = sp.symbols("s u")
    P = sum(
        sum(c * s**e for e, c in d.items()) * u**k for k, d in enumerate(by_u)
    )
    R = sp.resultant(P, sp.diff(P, u), u)
    facs = sp.factor_list(sp.Poly(R, s))
    for base, exp in facs[1]:
        if base.degree() == 21 and exp == 1:
            return [int(base.nth(i)) for i in range(22)]
    fail("exact H21 not found in line resultant")


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


def main() -> None:
    enforce_limit()
    payload_path = HERE / "payload.json"
    seal_path = HERE / "SEAL.json"
    norm_path = HERE / "normalization.json"
    cond_path = HERE / "conductor.json"
    for p in (payload_path, seal_path, norm_path, cond_path, H_PRIM, H_MONIC, H_SUMMARY):
        if not p.is_file():
            fail(f"missing {p}")

    payload = json.loads(payload_path.read_text())
    seal = json.loads(seal_path.read_text())
    norm = json.loads(norm_path.read_text())
    cond = json.loads(cond_path.read_text())

    if payload.get("headline") != "OPEN":
        fail("headline must remain OPEN")
    if payload.get("gate1_decision") != "STOP-2":
        fail(f"expected STOP-2, got {payload.get('gate1_decision')}")
    if payload.get("option_a_authorized") is not False:
        fail("option (a) must not be authorized")
    if payload.get("route") != "option_c_multi_prime_sparse_reconstruction":
        fail("route must be option (c)")

    # hashes
    if file_hash(payload_path) != seal.get("payload_sha256"):
        fail("payload sha mismatch")
    if file_hash(norm_path) != seal.get("normalization_sha256"):
        fail("normalization sha mismatch")
    if file_hash(cond_path) != seal.get("conductor_sha256"):
        fail("conductor sha mismatch")
    if file_hash(H_PRIM) != seal.get("H_primitive_sha256"):
        fail("H primitive sha mismatch vs seal")
    if file_hash(H_MONIC) != seal.get("H_monic_rational_sha256"):
        fail("H monic sha mismatch vs seal")

    core = {k: v for k, v in seal.items() if k != "seal_sha256"}
    core_bytes = (json.dumps(core, indent=2, sort_keys=True) + "\n").encode()
    if sha256(core_bytes).hexdigest() != seal.get("seal_sha256"):
        fail("seal self-hash mismatch")

    # P content
    terms = load_P_terms()
    content = reduce(gcd, (abs(c) for _, c in terms))
    if content != 1:
        fail(f"P content {content} != 1")

    # H primitive
    Hrows = load_H_prim()
    gh = payload["global_H_factor"]
    if len(Hrows) != gh["n_terms_primitive"]:
        fail(f"H terms {len(Hrows)} != payload {gh['n_terms_primitive']}")
    g = 0
    for _, c in Hrows:
        g = gcd(g, abs(c))
    if g != 1:
        fail(f"H content {g} != 1")
    a43 = dict(Hrows).get((43, 0, 0, 0))
    if a43 != gh["coeff_A43_primitive"]:
        fail("A43 coeff mismatch")
    max_deg = max(sum(m) for m, _ in Hrows)
    if max_deg != gh["total_degree"]:
        fail(f"H degree {max_deg} != payload")

    # line vs exact H21
    line = specialize_H_line123(Hrows)
    H21 = exact_H21_coeffs(terms)
    if not proportional(line, H21):
        fail("H specialization to (1,2,3,s) not proportional to exact H21")

    # monic rational A43 = 1
    with H_MONIC.open() as f:
        if next(f).strip() != "A\tB\tY\tZ\tnum\tden":
            fail("bad monic header")
        found = False
        for line_r in f:
            a, b, y, z, n, d = map(int, line_r.split())
            if (a, b, y, z) == (43, 0, 0, 0):
                if n != 1 or d != 1:
                    fail(f"monic A43 = {n}/{d}, expected 1/1")
                found = True
                break
        if not found:
            fail("monic file missing A^43")

    recon = json.loads(H_SUMMARY.read_text())
    if recon.get("status") != "VERIFIED":
        fail(f"ratrecon status {recon.get('status')}")
    if recon.get("congruence_failures") != 0 or recon.get("failed_ratrecon") != 0:
        fail("ratrecon reported failures")
    if not recon.get("line_match_monic_H21"):
        fail("ratrecon line match false")

    # normalization/conductor not claimed complete
    if norm.get("status") != "NOT_CONSTRUCTED":
        fail("normalization must be NOT_CONSTRUCTED under STOP-2")
    if cond.get("status") != "NOT_CONSTRUCTED":
        fail("conductor must be NOT_CONSTRUCTED under STOP-2")
    if norm.get("Dtilde") is not None or cond.get("conductor_ideal") is not None:
        fail("D~ / conductor must be null under STOP-2")

    # no PASS claims without normalization
    if payload["gate1_decision"] in ("PASS-MB", "PASS-NODAL", "FAIL-HIGHER"):
        fail("PASS/FAIL-HIGHER requires constructed normalization geometry")

    # bottleneck renamed
    bn = payload["algebraic_bottleneck"]["name"]
    if "NORMALIZATION" not in bn and "JACOBIAN" not in bn:
        fail(f"unexpected bottleneck name {bn}")

    print("TARGET_BRANCH_GLOBAL_FOLD_GATE1_VERIFIER_ACCEPT")
    print("gate1_decision=STOP-2")
    print(f"H_terms={len(Hrows)} H_deg={max_deg}")
    print("line_match_H21=True")
    print(f"payload_sha256={seal['payload_sha256']}")


if __name__ == "__main__":
    main()
