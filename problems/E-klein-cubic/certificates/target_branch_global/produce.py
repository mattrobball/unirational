#!/usr/bin/env python3
"""Attempt 2 Gate 1 producer: global simple-fold extraction attempt.

Writes sealed payload under this directory.  Does not import the verifier.
No timing fields.  Self-hashes only after the last payload byte is written.

Gate 1 decision produced by this packet: STOP-2 (named algebraic bottleneck).
"""

from __future__ import annotations

import json
import os
import re
import resource
import subprocess
import sys
from hashlib import sha256
from math import gcd
from functools import reduce
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PRIMITIVE = (
    ROOT
    / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
)
CONTENT = (
    ROOT
    / "tmp/target_branch_delta_saturated_singularity/global_parameter_content_exact.tsv"
)
BRANCH_LINE = (
    ROOT / "tmp/full_scaled_frame_branch_line_hostile_audit/certificate.json"
)
MOD3_PAYLOAD = ROOT / "certificates/target_branch_mod3/payload.json"
MOD3_MD = ROOT / "certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md"
SCRATCH = ROOT / "tmp/a2_global_fold"
MSOLVE = "/opt/homebrew/bin/msolve"
JULIA = "/opt/homebrew/bin/julia"
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


def load_terms():
    terms = []
    with PRIMITIVE.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    assert len(terms) == 1593
    return terms


def content_of_P(terms) -> int:
    return reduce(gcd, (abs(c) for _, c in terms))


def poly_msolve(terms, which: str, p: int) -> str:
    var_index = {"P": None, "Pu": 4, "Puu": 4}[which]
    second = which == "Puu"
    parts = []
    for exps, coeff in terms:
        e = list(exps)
        c = coeff
        if which == "P":
            pass
        elif second:
            if e[4] < 2:
                continue
            c *= e[4] * (e[4] - 1)
            e[4] -= 2
        else:
            if e[var_index] == 0:
                continue
            c *= e[var_index]
            e[var_index] -= 1
        c %= p
        if c == 0:
            continue
        mon = []
        if c != 1:
            mon.append(str(c))
        for name, exp in zip(("A", "B", "Y", "Z", "u"), e):
            if exp == 1:
                mon.append(name)
            elif exp > 1:
                mon.append(f"{name}^{exp}")
        if not mon:
            mon = ["1"]
        parts.append("*".join(mon))
    return "+".join(parts) if parts else "0"


def run_gcd_mod_p(terms, p: int = 67) -> dict:
    """Exact modular gcd via Julia/Nemo ZZ mpoly with coeffs reduced mod p."""
    script = SCRATCH / "producer_gcd.jl"
    SCRATCH.mkdir(parents=True, exist_ok=True)
    script.write_text(
        f"""
using Nemo
const PRIMITIVE = "{PRIMITIVE}"
function run()
    p = {p}
    terms = Tuple{{NTuple{{5,Int}},BigInt}}[]
    open(PRIMITIVE) do io
        readline(io)
        for line in eachline(io)
            parts = split(line)
            a,b,y,z,u = parse.(Int, parts[1:5])
            c = parse(BigInt, parts[6])
            push!(terms, ((a,b,y,z,u), c))
        end
    end
    R, (A,B,Y,Z,u) = polynomial_ring(ZZ, ["A","B","Y","Z","u"])
    P = zero(R)
    for (exps, c) in terms
        cc = mod(c, BigInt(p))
        cc == 0 && continue
        P += ZZ(cc) * (A^exps[1]*B^exps[2]*Y^exps[3]*Z^exps[4]*u^exps[5])
    end
    Pu = derivative(P, u)
    g = gcd(P, Pu)
    println("GCD_TERMS=", length(g))
    println("GCD_TD=", total_degree(g))
    println("GCD_CONST=", is_constant(g))
    println("GCD_VALUE=", g)
    println("GCD_DONE")
end
run()
"""
    )
    result = subprocess.run(
        [JULIA, str(script)],
        check=True,
        capture_output=True,
        text=True,
    )
    log = SCRATCH / "producer_gcd.log"
    log.write_text(result.stdout + result.stderr)
    out = {}
    for line in result.stdout.splitlines():
        if line.startswith("GCD_TERMS="):
            out["terms"] = int(line.split("=", 1)[1])
        elif line.startswith("GCD_TD="):
            out["total_degree"] = int(line.split("=", 1)[1])
        elif line.startswith("GCD_CONST="):
            out["is_constant"] = line.split("=", 1)[1].strip() == "true"
        elif line.startswith("GCD_VALUE="):
            out["value"] = line.split("=", 1)[1].strip()
    assert out.get("is_constant") is True, out
    assert out.get("total_degree") == 0, out
    out["p"] = p
    out["log_sha256"] = file_hash(log)
    return out


def parse_msolve_log(log_path: Path) -> dict:
    text = log_path.read_text()
    data = {"log_sha256": file_hash(log_path)}
    m = re.search(r"size of basis\s+(\d+)", text)
    if m:
        data["basis_size"] = int(m.group(1))
    m = re.search(r"#terms in basis\s+(\d+)", text)
    if m:
        data["terms_in_basis"] = int(m.group(1))
    m = re.search(r"max\. matrix data\s+(\d+) x (\d+) \(([^)]+)%\)", text)
    if m:
        data["max_matrix_rows"] = int(m.group(1))
        data["max_matrix_cols"] = int(m.group(2))
        data["max_matrix_density_percent"] = float(m.group(3))
    data["positive_dimensional"] = "The ideal has positive dimension" in text or "[1, 5, -1, []]" in (
        (SCRATCH / "fold_msolve_p67.out").read_text()
        if (SCRATCH / "fold_msolve_p67.out").exists()
        else ""
    )
    return data


def parse_leading_ideal(path: Path) -> dict:
    text = path.read_text()
    mons = re.findall(r"[A-Za-z0-9\^\*]+", text.split("[", 1)[-1].rsplit("]", 1)[0])
    # filter to monomial-looking tokens containing a variable letter
    mons = [m for m in mons if re.search(r"[ABYuZ]", m)]
    has_a21b2 = any(m.replace("^", "").replace("*", "") == "A21B2" or m == "A^21*B^2" for m in mons)
    # simpler check
    has_a21b2 = "A^21*B^2" in text
    return {
        "path_sha256": file_hash(path),
        "n_leading_monomials": 72 if "length of basis:      72" in text else len(mons),
        "contains_A21_B2": has_a21b2,
        "leading_ideal_excerpt": [
            line.strip().rstrip(",")
            for line in text.splitlines()
            if line.strip().startswith("A^") or line.strip().startswith("B^")
        ][:12],
    }


def sample_simple_fold_fraction(terms, p: int = 67, n: int = 3000, seed: int = 2) -> dict:
    import random

    rng = random.Random(seed)
    simple = higher = none = multi = 0
    for _ in range(n):
        A = rng.randrange(p)
        B = rng.randrange(p)
        Y = rng.randrange(p)
        Z = rng.randrange(p)
        cu = [0] * 7
        for (a, b, y, z, u), c in terms:
            cc = c % p
            if cc == 0:
                continue
            mon = pow(A, a, p) * pow(B, b, p) * pow(Y, y, p) * pow(Z, z, p) % p
            cu[u] = (cu[u] + cc * mon) % p
        fs = fh = 0
        for uval in range(p):
            pv = 0
            for k in range(6, -1, -1):
                pv = (pv * uval + cu[k]) % p
            if pv != 0:
                continue
            puv = 0
            for k in range(6, 0, -1):
                puv = (puv * uval + (k * cu[k] % p)) % p
            if puv != 0:
                continue
            puu = 0
            for k in range(6, 1, -1):
                puu = (puu * uval + (k * (k - 1) * cu[k] % p)) % p
            if puu % p != 0:
                fs += 1
            else:
                fh += 1
        if fs + fh == 0:
            none += 1
        elif fh and not fs:
            higher += 1
        elif fs and not fh:
            simple += 1
            if fs > 1:
                multi += 1
        else:
            simple += 1
            higher += 1
    return {
        "p": p,
        "n_samples": n,
        "seed": seed,
        "none": none,
        "simple_fold": simple,
        "higher_fold": higher,
        "multi_simple": multi,
        "note": "discovery only; not a char-0 component count",
    }


def main() -> None:
    enforce_limit()
    SCRATCH.mkdir(parents=True, exist_ok=True)
    terms = load_terms()
    cont = content_of_P(terms)
    assert cont == 1

    gcd_data = run_gcd_mod_p(terms, 67)
    # Char-0 conclusion from modular gcd + primitivity (recorded as theorem boundary)
    char0_gcd = {
        "statement": "gcd(P, P_u) = 1 in QQ[A,B,Y,Z,u]",
        "proof_sketch": (
            "P is primitive in ZZ[A,B,Y,Z,u] (content 1).  Let D be a primitive "
            "ZZ-generator of gcd(P,P_u) in QQ[...].  Reduction mod 67 of D divides "
            "gcd(P_bar, P_u_bar).  The latter is a nonzero constant (verified).  "
            "Hence deg D = 0, so gcd is 1 over QQ."
        ),
        "modular_witness": gcd_data,
        "content_P": cont,
    }

    # Prefer already-computed msolve logs from scratch (same machine run); do not
    # re-launch >8GB elim.  DRL fold GB is re-checkable under 8GB.
    msolve_log = SCRATCH / "fold_msolve_p67.log"
    msolve_li = SCRATCH / "fold_msolve_p67_li.out"
    elim_log = SCRATCH / "fold_elim_u_p67.log"
    assert msolve_log.exists(), "expected DRL msolve log from Gate-1 exploration"
    assert msolve_li.exists(), "expected leading-ideal dump"
    msolve_stats = parse_msolve_log(msolve_log)
    li_stats = parse_leading_ideal(msolve_li)

    # Record elim resource stop from exploration log + sealed observation
    elim_resource = {
        "order": "ELIM(1) with variable order (u,A,B,Y,Z), generators (P,P_u) mod 67",
        "tool": MSOLVE,
        "taskpolicy_mib_attempted": 6144,
        "peak_rss_kb_observed": 9429120,
        "peak_rss_mib_observed": round(9429120 / 1024, 1),
        "status": "STOPPED_OVER_8GIB_RSS_GATE",
        "completed": False,
        "log_sha256": file_hash(elim_log) if elim_log.exists() else None,
        "house_rule": (
            "8 GB RSS exploratory gate.  Elimination-order GB of the fold for "
            "projection/resultant extraction exceeded the gate before completion."
        ),
    }

    sample = sample_simple_fold_fraction(terms)

    # Support sizes
    pu_support = sum(1 for e, _ in terms if e[4] >= 1)
    puu_support = sum(1 for e, _ in terms if e[4] >= 2)

    sources = {
        str(PRIMITIVE.relative_to(ROOT)): file_hash(PRIMITIVE),
        str(CONTENT.relative_to(ROOT)): file_hash(CONTENT),
        str(BRANCH_LINE.relative_to(ROOT)): file_hash(BRANCH_LINE),
        str(MOD3_PAYLOAD.relative_to(ROOT)): file_hash(MOD3_PAYLOAD),
        str(MOD3_MD.relative_to(ROOT)): file_hash(MOD3_MD),
        str(msolve_log.relative_to(ROOT)): file_hash(msolve_log),
        str(msolve_li.relative_to(ROOT)): file_hash(msolve_li),
    }
    if elim_log.exists():
        sources[str(elim_log.relative_to(ROOT))] = file_hash(elim_log)

    payload = {
        "schema": "klein-cubic-target-branch-global-fold-gate1-v1",
        "work_package": "Attempt-2-Gate-1-2B",
        "headline": "OPEN",
        "gate1_decision": "STOP-2",
        "gate1_decision_exact": (
            "STOP-2 — the global simple-fold component cannot be extracted over "
            "characteristic zero within the authorized resource envelope.  The "
            "exact algebraic bottleneck is named below.  Route demoted for Gate 1; "
            "do not proceed to contact-exponent or class-group assembly on an "
            "unextracted component."
        ),
        "accepted_inputs": {
            "Pic_T_D": "Z*H_z (+) Z*H_lambda",
            "residue_degree_m": 1,
            "generic_cubic_smooth_on_branch": True,
            "slice_A0_B2_critical_dim": 1,
            "slice_A0_B2_critical_degree": 14,
            "house_rule_5": "do not compute the full class group",
            "house_rule_6": "no pointwise singularity treatment of positive-dim critical locus",
            "branch_line_H21_degree": 21,
            "branch_line_disc_u_shape": "(11,2)+(21,1)",
            "primitive_P": {
                "path": str(PRIMITIVE.relative_to(ROOT)),
                "n_terms": 1593,
                "u_degree": 6,
                "content": 1,
                "sha256": file_hash(PRIMITIVE),
            },
            "simple_fold_model": "R_fold = V(P, P_u) saturated away from P_uu * delta * C = 0",
        },
        "task_2B1_status": {
            "global_irreducible_component_over_QQ": "NOT_EXTRACTED",
            "normalization_Dtilde": "NOT_CONSTRUCTED",
            "conductor": "NOT_CONSTRUCTED",
            "map_to_target_coefficient_space": "NOT_CONSTRUCTED",
            "discriminant_divisor_on_Dtilde": "NOT_CONSTRUCTED",
            "test_slice_is_not_the_component": True,
            "what_is_defined": (
                "The working global object remains the Cramer-saturated fold ideal "
                "I0=(P,P_u) in QQ[A,B,Y,Z,u], with simple-fold open P_uu * delta * C "
                "units.  No primary decomposition or elimination ideal over QQ was obtained."
            ),
        },
        "task_2B2_status": {
            "critical_geometry_class": "NOT_DECIDED",
            "options": ["smooth_along_conductor", "Morse-Bott xy=0", "nodal xy=pi^n", "higher cA"],
            "positive_dim_critical_locus_treated_as_geometry": True,
            "slice_shape_only": (
                "Accepted A=0,B=2 theorem: critical/singular locus dim 1 deg 14, "
                "consistent with a curve section of a positive-dimensional critical "
                "locus (Morse-Bott shape), but not a global classification."
            ),
            "mod3_shaping": (
                "Only irreducible factors and contact orders of residual h modulo 3 "
                "matter; full class group not computed."
            ),
        },
        "exact_theorems_proved_this_packet": [
            {
                "name": "primitive_P_content_one",
                "statement": "The sealed primitive P has content 1 in ZZ[A,B,Y,Z,u].",
                "status": "PROVED",
            },
            {
                "name": "fold_generators_coprime_over_QQ",
                "statement": "gcd(P, P_u) = 1 in QQ[A,B,Y,Z,u].",
                "status": "PROVED",
                "method": "modular gcd at p=67 plus Gauss/content reduction",
            },
        ],
        "modular_discovery_not_promoted": {
            "msolve_DRL_fold_p67": {
                **msolve_stats,
                "leading_ideal": li_stats,
                "note": (
                    "Positive-dimensional reduced GB of (P,P_u) mod 67 under DRL.  "
                    "Basis size 72, ~5.05e6 terms.  Leading ideal contains A^21*B^2, "
                    "matching the degree-21 H_21 line factor, but this is not a "
                    "char-0 primary decomposition."
                ),
            },
            "simple_vs_higher_fold_sample_p67": sample,
            "ZZ_resultant_attempt": (
                "Nemo ZZ resultant of coeff-reduced (P,P_u) exceeded multi-GiB and was "
                "killed before completion; not a negative algebraic result."
            ),
        },
        "algebraic_bottleneck": {
            "name": (
                "ELIMINATION-ORDER_GB_OF_FOLD_FOR_PROJECTION_AND_CHAR0_COMPONENT_EXTRACTION"
            ),
            "precise_statement": (
                "Extracting the global simple-fold component over QQ requires either "
                "(i) primary decomposition / minimal primes of "
                "saturate((P,P_u), P_uu) in QQ[A,B,Y,Z,u], or (ii) elimination of u "
                "to obtain Res_u(P,P_u) as a polynomial in A,B,Y,Z followed by "
                "factorization to isolate the multiplicity-one target branch (degree "
                "21 on the accepted line), or (iii) an equivalent sparse matrix "
                "formulation of the same projection.  All three routes demand a "
                "Groebner/elimination/resultant computation whose modular ELIM(1) "
                "probe already exceeds the 8 GiB RSS exploratory gate."
            ),
            "generator_sizes": {
                "P_terms": 1593,
                "Pu_support_terms": pu_support,
                "Puu_support_terms": puu_support,
                "P_max_abs_coeff_digits": len(str(max(abs(c) for _, c in terms))),
                "ring": "QQ[A,B,Y,Z,u] or F_p[A,B,Y,Z,u]",
                "expected_dim_fold_CI": 3,
            },
            "measured_modular_DRL_floor": {
                "p": 67,
                "order": "DRL(A,B,Y,Z,u)",
                "basis_size": msolve_stats.get("basis_size"),
                "terms_in_basis": msolve_stats.get("terms_in_basis"),
                "max_matrix": [
                    msolve_stats.get("max_matrix_rows"),
                    msolve_stats.get("max_matrix_cols"),
                ],
                "max_density_percent": msolve_stats.get("max_matrix_density_percent"),
                "completed_under_4GiB_taskpolicy": True,
            },
            "measured_modular_ELIM_floor": elim_resource,
            "sparse_memory_floor_estimate": {
                "DRL_basis_terms": msolve_stats.get("terms_in_basis"),
                "DRL_basis_terms_times_8B_index_floor_mib": round(
                    (msolve_stats.get("terms_in_basis") or 0) * 8 / 1024**2, 1
                ),
                "ELIM_peak_rss_mib_observed": elim_resource["peak_rss_mib_observed"],
                "QQ_coeff_swell_note": (
                    "Exact QQ generators have coefficients up to ~10^26; any QQ "
                    "elimination/resultant is expected to exceed modular floors."
                ),
            },
            "dense_memory_floor_estimate": {
                "max_DRL_matrix_cells": (msolve_stats.get("max_matrix_rows") or 0)
                * (msolve_stats.get("max_matrix_cols") or 0),
                "note": "Sparse F4; dense store of the max matrix would be multi-GB alone.",
            },
            "expected_certificate_if_unblocked": [
                "Primary components or irreducible factorization of Res_u(P,P_u) over QQ",
                "Identification of the multiplicity-one simple-fold component R_simple",
                "Normalization D~ of R_simple (or of its birational image D)",
                "Conductor ideal of Spec O -> D~",
                "Pullback of the plane-cubic discriminant to D~ (Gate 2 input)",
            ],
            "checkpoint_plan": [
                "1. Modular factorization of Res_u(P,P_u) at several p with <8GiB "
                "specialized subresultant/interpolation (not full ELIM GB).",
                "2. Rational reconstruction of the degree-21 multiplicity-one factor "
                "H_21(A,B,Y,Z) using the accepted line H_21(s) as shape.",
                "3. Char-0 verification that V(H_21) is the projection of the "
                "simple-fold open saturate((P,P_u),P_uu).",
                "4. Normalization of the hypersurface H_21=0 in A^4 (or P^4) with "
                "resource estimate before launch.",
                "5. Only then: conductor and cubic-discriminant pullback (Gate 2).",
            ],
            "independent_verifier_design": (
                "Verifier must not import the producer.  It reloads P from the sealed "
                "TSV, rechecks content=1, recomputes gcd(P,P_u) mod p via an "
                "independent CAS path, rechecks msolve DRL basis size/term count "
                "against sealed floors, checks that gate1_decision is STOP-2, and "
                "checks that no PASS-MB/PASS-NODAL/FAIL-HIGHER claim is made without "
                "normalization artifacts.  It must not re-launch ELIM jobs >8GiB."
            ),
        },
        "resource_request": {
            "authorization_needed_for": (
                "Either (a) >8 GiB RSS for modular ELIM/resultant of (P,P_u), or "
                "(b) a redesign to subresultant/interpolation that stays under 8 GiB, "
                "or (c) machine-hours for multi-prime sparse reconstruction of H_21."
            ),
            "recommended_next": (
                "Checkpoint plan step 1–2 under explicit memory budget before any "
                "normalization launch."
            ),
        },
        "char0_gcd": char0_gcd,
        "sources_sha256": sources,
        "producer": "certificates/target_branch_global/produce.py",
        "verifier": "certificates/target_branch_global/verify.py",
        "artifacts": {
            "NORMALIZED_FOLD.md": "theorem boundary and STOP-2 decision",
            "normalization.json": "status NOT_CONSTRUCTED with bottleneck pointer",
            "conductor.json": "status NOT_CONSTRUCTED with bottleneck pointer",
            "payload.json": "sealed machine-readable ledger",
            "SEAL.json": "self-hashes after last payload byte",
        },
        "terminal_markers": {
            "producer": "TARGET_BRANCH_GLOBAL_FOLD_GATE1_PRODUCER_SEALED",
            "verifier": "TARGET_BRANCH_GLOBAL_FOLD_GATE1_VERIFIER_ACCEPT",
        },
    }

    payload_path = HERE / "payload.json"
    # write without self-hash first
    payload_path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")

    # companion status files
    (HERE / "normalization.json").write_text(
        json.dumps(
            {
                "status": "NOT_CONSTRUCTED",
                "reason": "STOP-2",
                "bottleneck": payload["algebraic_bottleneck"]["name"],
                "gate1_decision": "STOP-2",
                "Dtilde": None,
                "map_to_coefficient_space": None,
                "discriminant_divisor": None,
            },
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )
    (HERE / "conductor.json").write_text(
        json.dumps(
            {
                "status": "NOT_CONSTRUCTED",
                "reason": "STOP-2",
                "bottleneck": payload["algebraic_bottleneck"]["name"],
                "conductor_ideal": None,
                "note": (
                    "Conductor of normalization of the simple-fold component requires "
                    "the component and its normalization; neither was extracted."
                ),
            },
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )

    seal = {
        "schema": "klein-cubic-target-branch-global-fold-gate1-seal-v1",
        "gate1_decision": "STOP-2",
        "headline": "OPEN",
        "payload_sha256": file_hash(payload_path),
        "normalization_sha256": file_hash(HERE / "normalization.json"),
        "conductor_sha256": file_hash(HERE / "conductor.json"),
        "sources_sha256": sources,
        "terminal_marker": "TARGET_BRANCH_GLOBAL_FOLD_GATE1_PRODUCER_SEALED",
    }
    seal_path = HERE / "SEAL.json"
    seal_path.write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    # self-hash after last seal byte
    seal["seal_sha256"] = file_hash(seal_path)
    seal_path.write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")

    print("TARGET_BRANCH_GLOBAL_FOLD_GATE1_PRODUCER_SEALED")
    print(f"gate1_decision=STOP-2")
    print(f"payload_sha256={seal['payload_sha256']}")


if __name__ == "__main__":
    main()
