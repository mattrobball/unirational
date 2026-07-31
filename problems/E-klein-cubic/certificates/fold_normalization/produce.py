#!/usr/bin/env python3
"""Path T / Gate T1 producer — finite birationality of the fold algebra.

Seals T-BIRATIONAL from installed H, P, and exact line fibre-rank witnesses.
Does not import the verifier.  Does not re-eliminate u globally for H.
Does not run T2/T3/T4.  No timing fields.  Self-hashes after last payload byte.
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
H_SEAL = ROOT / "certificates/target_branch_global/SEAL.json"
WITNESS = HERE / "line_fiber_rank_witness.json"
M2_LOG = HERE / "line_fiber_rank.m2.certificate"
SING_LOG = HERE / "line_fiber_rank.sing.certificate"
SCRATCH_M2_LOG = ROOT / "tmp/postelo_T/line_fiber_rank.m2.log"
SCRATCH_SING_LOG = ROOT / "tmp/postelo_T/line_fiber_rank.sing.log"
CEILING_MIB = 8192
CAP_ENV = "POSTELO_T_PRODUCER_MIB"


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


def load_P_terms():
    terms = []
    with PRIMITIVE.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    assert len(terms) == 1593
    return terms


def load_H_prim():
    rows = []
    with H_PRIM.open() as f:
        assert next(f).strip() == "A\tB\tY\tZ\tcoefficient"
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
    assert PRIMITIVE.is_file(), f"missing {PRIMITIVE}"
    assert H_PRIM.is_file(), f"missing {H_PRIM}"
    assert WITNESS.is_file(), f"missing {WITNESS}"

    # Prefer certificate-local logs; fall back to scratch.
    m2_log_path = M2_LOG if M2_LOG.is_file() else SCRATCH_M2_LOG
    sing_log_path = SING_LOG if SING_LOG.is_file() else SCRATCH_SING_LOG
    assert m2_log_path.is_file(), "missing M2 log"
    assert sing_log_path.is_file(), "missing Singular log"

    terms = load_P_terms()
    content = reduce(gcd, (abs(c) for _, c in terms))
    assert content == 1
    deg_u = max(e[4] for e, _ in terms)
    assert deg_u == 6
    lc_terms = [((a, b, y, z), c) for (a, b, y, z, u), c in terms if u == 6]
    max_lc_deg = max(a + b + y + z for (a, b, y, z), _ in lc_terms)

    Hrows = load_H_prim()
    assert len(Hrows) == 37992
    gH = 0
    for _, c in Hrows:
        gH = gcd(gH, abs(c))
    assert gH == 1
    max_H_deg = max(sum(m) for m, _ in Hrows)
    assert max_H_deg == 43
    assert max_lc_deg < max_H_deg

    witness = json.loads(WITNESS.read_text())
    assert witness["generic_rank_on_line_branch"] == 1
    assert witness["subresultant_criterion"]["gcd_degree"] == 1
    assert witness["H21_irreducible"] is True
    assert witness["H_line_proportional_to_H21"] is True

    H21 = witness["H21_coeffs"]
    line = specialize_H_line123(Hrows)
    assert proportional(line, H21), "H line specialization not prop to sealed H21"

    m2 = parse_m2_log(m2_log_path.read_text())
    sing = parse_sing_log(sing_log_path.read_text())
    assert m2.get("dim") == 0 and m2.get("deg") == 21
    assert m2.get("dim_puu") == -1 and m2.get("dim_lc") == -1
    assert m2.get("gcd_q11_h21") == 0 and m2.get("gcd_lc_h21") == 0
    assert sing.get("dim") == 0 and sing.get("mult") == 21
    assert sing.get("dim_puu") == -1 and sing.get("dim_lc") == -1

    p_sha = file_hash(PRIMITIVE)
    h_sha = file_hash(H_PRIM)
    w_sha = file_hash(WITNESS)
    m2_sha = file_hash(m2_log_path)
    sing_sha = file_hash(sing_log_path)
    h_global_seal = None
    if H_SEAL.is_file():
        h_global_seal = json.loads(H_SEAL.read_text()).get("H_primitive_sha256")
        assert h_global_seal == h_sha

    # Copy logs into certificate dir if needed
    if not M2_LOG.is_file():
        M2_LOG.write_text(m2_log_path.read_text())
        m2_sha = file_hash(M2_LOG)
    if not SING_LOG.is_file():
        SING_LOG.write_text(sing_log_path.read_text())
        sing_sha = file_hash(SING_LOG)

    payload = {
        "schema": "klein-cubic-postelo-T1-fold-birational-v1",
        "headline": "OPEN",
        "gate_T1": "T-BIRATIONAL",
        "base_commit": "c5e71be",
        "dispatch": "WORKORDER_POST_ELO_CONSTRUCTION.md §3 Dispatch T (T1+T2 plan)",
        "accepted_inputs": {
            "primitive_P": {
                "path": str(PRIMITIVE.relative_to(ROOT)),
                "n_terms": 1593,
                "u_degree": 6,
                "content": 1,
                "sha256": p_sha,
            },
            "H_prim": {
                "path": str(H_PRIM.relative_to(ROOT)),
                "n_terms": 37992,
                "total_degree": 43,
                "content": 1,
                "sha256": h_sha,
                "role": "irreducible mult-1 factor of Res_u(P,P_u); sealed input, not re-eliminated",
            },
            "branch_line": "(A,B,Y,Z)=(1,2,3,s)",
            "simple_fold_gates": ["lc_u(P)", "P_uu", "delta_Cramer", "C_content"],
            "rss_gate_gib": 8,
            "house_rule": "no re-elimination of u for H; no pointwise positive-dim critical locus",
        },
        "definitions": {
            "B": "Q[A,B,Y,Z]/(H_prim)",
            "S": "(B[u]/(P,P_u))[Sigma^{-1}] with Sigma = simple_fold_gates",
            "K": "Frac(B)",
        },
        "claims": {
            "S_finite_over_B": True,
            "generic_rank": 1,
            "Frac_S_equals_Frac_B": True,
            "selected_component_is_mult1_simple_fold": True,
        },
        "proof_summary": {
            "finiteness": "after inverting lc_u(P), P scales to monic deg 6; S is a quotient of a free rank-6 algebra",
            "rank_ge_1": "H divides Res_u(P,P_u) by sealed construction, so gcd deg >= 1 over K",
            "rank_le_1": (
                "mult-1 of H in Res implies simple double root generically; "
                "line branch has subresultant gcd deg 1 and bivariate deg(H21,P,Pu)=21"
            ),
            "fraction_fields": "over K, (P,P_u)=(u-alpha) reduced because P_uu is a gate",
            "component": "B built from mult-1 H selected by H21; Q11 and P_uu=0 excluded by gates",
        },
        "line_witness": {
            "path": "line_fiber_rank_witness.json",
            "sha256": w_sha,
            "disc_shape": witness["disc_u_factor_shape"],
            "generic_rank_on_line_branch": 1,
            "subresultant_gcd_degree": 1,
            "H21_irreducible": True,
            "H_line_match_H21": True,
            "m2": m2,
            "singular": sing,
            "m2_certificate_sha256": m2_sha,
            "singular_certificate_sha256": sing_sha,
        },
        "lc_u": {
            "n_terms": len(lc_terms),
            "max_total_degree": max_lc_deg,
            "H_does_not_divide_lc": True,
        },
        "T2_status": "PLAN_ONLY",
        "T2_plan": "SERRE_NORMALITY.md",
        "T3_status": "NOT_STARTED",
        "T4_status": "NOT_STARTED",
        "not_proved": [
            "Serre normality of S (S2+R1)",
            "conductor ideal",
            "discriminant contacts mod 3",
            "(Cl/Pic)[3]",
            "Problem E resolution",
        ],
        "artifacts": {
            "FINITE_BIRATIONAL.md": "T1 proof",
            "SERRE_NORMALITY.md": "T2 plan only",
            "line_fiber_rank_witness.json": "exact line fibre-rank ledger",
            "line_fiber_rank.m2.certificate": "M2 dim/deg certificate",
            "line_fiber_rank.sing.certificate": "Singular dim/mult certificate",
            "payload.json": "machine-readable T1 seal body",
            "SEAL.json": "self-hashes after last payload byte",
        },
        "terminal_marker": "POSTELO_T1_FOLD_BIRATIONAL_PRODUCER_SEALED",
    }

    payload_path = HERE / "payload.json"
    payload_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    payload_sha = file_hash(payload_path)

    finite_md = HERE / "FINITE_BIRATIONAL.md"
    serre_md = HERE / "SERRE_NORMALITY.md"
    assert finite_md.is_file() and serre_md.is_file()

    seal = {
        "schema": "klein-cubic-postelo-T1-fold-birational-seal-v1",
        "headline": "OPEN",
        "gate_T1": "T-BIRATIONAL",
        "payload_sha256": payload_sha,
        "FINITE_BIRATIONAL_sha256": file_hash(finite_md),
        "SERRE_NORMALITY_sha256": file_hash(serre_md),
        "line_fiber_rank_witness_sha256": w_sha,
        "line_fiber_rank_m2_certificate_sha256": file_hash(M2_LOG),
        "line_fiber_rank_sing_certificate_sha256": file_hash(SING_LOG),
        "sources_sha256": {
            str(PRIMITIVE.relative_to(ROOT)): p_sha,
            str(H_PRIM.relative_to(ROOT)): h_sha,
        },
        "terminal_marker": "POSTELO_T1_FOLD_BIRATIONAL_PRODUCER_SEALED",
    }
    # self-hash after last non-seal_sha256 byte
    core = {k: v for k, v in seal.items()}
    core_bytes = (json.dumps(core, indent=2, sort_keys=True) + "\n").encode()
    seal["seal_sha256"] = sha256(core_bytes).hexdigest()
    seal_path = HERE / "SEAL.json"
    seal_path.write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")

    print("POSTELO_T1_FOLD_BIRATIONAL_PRODUCER_SEALED")
    print("gate_T1=T-BIRATIONAL")
    print(f"payload_sha256={payload_sha}")
    print(f"seal_sha256={seal['seal_sha256']}")
    print("headline=OPEN")


if __name__ == "__main__":
    main()
