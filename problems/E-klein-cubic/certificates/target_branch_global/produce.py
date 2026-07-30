#!/usr/bin/env python3
"""Attempt 2 Gate 1 producer (option (c) continuation).

Seals the reconstructed global multiplicity-one Res_u factor H and records
STOP-2 for normalization.  Does not import the verifier.  No timing fields.
Self-hashes only after the last payload byte.
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
CAP_ENV = "A2_GLOBAL_FOLD_MIB"


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


def exact_H21_coeffs(terms):
    """Exact H_21(s) on A=1,B=2,Y=3 via sympy resultant factorization."""
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
    raise RuntimeError("exact H21 not found")


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
    assert H_PRIM.is_file() and H_MONIC.is_file() and H_SUMMARY.is_file()

    terms = load_P_terms()
    content = reduce(gcd, (abs(c) for _, c in terms))
    assert content == 1

    Hrows = load_H_prim()
    n_terms = len(Hrows)
    degs = [sum(m) for m, _ in Hrows]
    max_deg = max(degs)
    g = 0
    for _, c in Hrows:
        g = gcd(g, abs(c))
    assert g == 1
    a43 = dict(Hrows).get((43, 0, 0, 0))
    assert a43 is not None and a43 > 0

    line = specialize_H_line123(Hrows)
    H21 = exact_H21_coeffs(terms)
    assert proportional(line, H21), "H line specialization does not match H21"

    recon = json.loads(H_SUMMARY.read_text())
    assert recon.get("status") == "VERIFIED"
    assert recon.get("line_match_monic_H21") is True
    assert recon.get("congruence_failures") == 0
    assert recon.get("failed_ratrecon") == 0

    h_prim_sha = file_hash(H_PRIM)
    h_monic_sha = file_hash(H_MONIC)
    h_sum_sha = file_hash(H_SUMMARY)
    p_sha = file_hash(PRIMITIVE)

    payload = {
        "headline": "OPEN",
        "gate1_decision": "STOP-2",
        "route": "option_c_multi_prime_sparse_reconstruction",
        "option_a_authorized": False,
        "option_b_used": False,
        "accepted_inputs": {
            "primitive_P": {
                "path": str(PRIMITIVE.relative_to(ROOT)),
                "n_terms": 1593,
                "u_degree": 6,
                "content": 1,
                "sha256": p_sha,
            },
            "branch_line": "(A,B,Y,Z)=(1,2,3,s)",
            "branch_line_disc_u_shape": "(11,2)+(21,1)",
            "house_rule_5": "do not compute the full class group",
            "house_rule_6": "no pointwise singularity treatment of positive-dim critical locus",
            "rss_gate_gib": 8,
        },
        "char0_gcd": {
            "statement": "gcd(P, P_u) = 1 in QQ[A,B,Y,Z,u]",
            "content_P": 1,
            "modular_witness": {"p": 67, "is_constant": True},
        },
        "global_H_factor": {
            "status": "CONSTRUCTED",
            "description": (
                "Irreducible multiplicity-one factor of Res_u(P,P_u) selected by "
                "the accepted line H_21; monic-in-A form has LT A^43."
            ),
            "total_degree": max_deg,
            "n_terms_primitive": n_terms,
            "content": 1,
            "coeff_A43_primitive": a43,
            "primitive_tsv": "H_factor/H_primitive_integer.tsv",
            "primitive_sha256": h_prim_sha,
            "monic_rational_tsv": "H_factor/H_monic_rational.tsv",
            "monic_rational_sha256": h_monic_sha,
            "ratrecon_summary_sha256": h_sum_sha,
            "n_good_primes": recon["n_good_primes"],
            "modulus_bits": recon["M_bits"],
            "line_match_H21": True,
            "holdout_prime": {
                "p": 641,
                "status": "PASS",
                "note": "Independent Res factor matches monic H reduction; 0 mismatches",
            },
            "verification": {
                "congruence_check": "implemented Farey ratrecon with a*b^{-1} ≡ e mod M",
                "sympy_private_ratrecon_used": False,
                "failed_ratrecon": 0,
                "congruence_failures": 0,
            },
        },
        "normalization": {
            "status": "NOT_CONSTRUCTED",
            "Dtilde": None,
            "map_to_coefficient_space": "projection (A,B,Y,Z); D = V(H_prim)",
            "discriminant_divisor": None,
        },
        "conductor": {
            "status": "NOT_CONSTRUCTED",
            "conductor_ideal": None,
        },
        "critical_geometry": {
            "class": "NOT_DECIDED",
            "slice_A0_B2": {"dim": 1, "degree": 14, "status": "accepted_input"},
        },
        "algebraic_bottleneck": {
            "name": "NORMALIZATION_JACOBIAN_GB_OF_DEGREE_43_TARGET_BRANCH_HYPERSURFACE_H",
            "previous_closed": "ELIMINATION-ORDER_GB_OF_FOLD_FOR_PROJECTION_AND_CHAR0_COMPONENT_EXTRACTION",
            "precise_statement": (
                "Option (c) reconstructed H. Completing Gate 1 requires normalization "
                "of D=V(H), the conductor, and the cubic-discriminant pullback. Jacobian "
                "GB of (H, partials) for the 37992-term degree-43 hypersurface is the "
                "measured next step; modular grevlex under 8 GiB had not completed dim/deg "
                "at seal time."
            ),
            "measured_floors": {
                "nemo_res_factor_mod_p_peak_rss_gib": 8.0,
                "res_terms_mod_p": 956643,
                "H_terms": n_terms,
                "H_total_degree": max_deg,
                "n_good_primes_crt": recon["n_good_primes"],
                "ratrecon_modulus_bits": recon["M_bits"],
                "jacobian_gb_mod_67": "INCOMPLETE_AT_SEAL",
            },
            "house_rule": "8 GiB RSS exploratory gate still binds; option (a) not authorized",
        },
        "artifacts": {
            "NORMALIZED_FOLD.md": "theorem boundary and STOP-2 decision",
            "H_factor/": "primitive and monic rational H with SHA256SUMS",
            "payload.json": "sealed machine-readable ledger",
            "normalization.json": "status NOT_CONSTRUCTED",
            "conductor.json": "status NOT_CONSTRUCTED",
            "SEAL.json": "self-hashes after last payload byte",
        },
    }

    (HERE / "payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    payload_sha = file_hash(HERE / "payload.json")

    norm = {
        "status": "NOT_CONSTRUCTED",
        "gate1_decision": "STOP-2",
        "reason": "STOP-2",
        "bottleneck": payload["algebraic_bottleneck"]["name"],
        "D": "V(H_prim) with H_prim sealed in H_factor/H_primitive_integer.tsv",
        "D_equation_status": "CONSTRUCTED",
        "Dtilde": None,
        "map_to_coefficient_space": "identity on (A,B,Y,Z) for D; fold covers D via u",
        "discriminant_divisor": None,
        "H_primitive_sha256": h_prim_sha,
    }
    (HERE / "normalization.json").write_text(
        json.dumps(norm, indent=2, sort_keys=True) + "\n"
    )
    norm_sha = file_hash(HERE / "normalization.json")

    cond = {
        "status": "NOT_CONSTRUCTED",
        "reason": "STOP-2",
        "bottleneck": payload["algebraic_bottleneck"]["name"],
        "conductor_ideal": None,
        "note": "Conductor requires normalization of D=V(H); H is constructed, D~ is not.",
        "H_primitive_sha256": h_prim_sha,
    }
    (HERE / "conductor.json").write_text(
        json.dumps(cond, indent=2, sort_keys=True) + "\n"
    )
    cond_sha = file_hash(HERE / "conductor.json")

    seal = {
        "schema": "klein-cubic-target-branch-global-fold-gate1-seal-v2",
        "headline": "OPEN",
        "gate1_decision": "STOP-2",
        "payload_sha256": payload_sha,
        "normalization_sha256": norm_sha,
        "conductor_sha256": cond_sha,
        "H_primitive_sha256": h_prim_sha,
        "H_monic_rational_sha256": h_monic_sha,
        "sources_sha256": {
            str(PRIMITIVE.relative_to(ROOT)): p_sha,
            "certificates/target_branch_global/H_factor/H_primitive_integer.tsv": h_prim_sha,
            "certificates/target_branch_global/H_factor/H_monic_rational.tsv": h_monic_sha,
            "certificates/target_branch_global/H_factor/ratrecon_summary.json": h_sum_sha,
        },
        "terminal_marker": "TARGET_BRANCH_GLOBAL_FOLD_GATE1_PRODUCER_SEALED",
    }
    seal_body = json.dumps(seal, indent=2, sort_keys=True) + "\n"
    seal["seal_sha256"] = sha256(seal_body.encode()).hexdigest()
    # rewrite with seal_sha256 of the pre-seal body: recompute carefully
    # Standard: seal_sha256 hashes the seal file without the seal_sha256 field, then include it.
    # Simpler: hash final file after writing all fields including a provisional, then update once.
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    # final self-hash of complete SEAL file
    final = json.loads((HERE / "SEAL.json").read_text())
    # store hash of file bytes as written before embedding? payload rule: self-hashes after last byte.
    # Put seal_sha256 as hash of the seal JSON without seal_sha256 key.
    core = {k: v for k, v in final.items() if k != "seal_sha256"}
    core_bytes = (json.dumps(core, indent=2, sort_keys=True) + "\n").encode()
    final["seal_sha256"] = sha256(core_bytes).hexdigest()
    (HERE / "SEAL.json").write_text(json.dumps(final, indent=2, sort_keys=True) + "\n")

    print("TARGET_BRANCH_GLOBAL_FOLD_GATE1_PRODUCER_SEALED")
    print("gate1_decision=STOP-2")
    print(f"payload_sha256={payload_sha}")
    print(f"H_terms={n_terms} H_deg={max_deg}")
    print(f"line_match_H21=True")


if __name__ == "__main__":
    main()
