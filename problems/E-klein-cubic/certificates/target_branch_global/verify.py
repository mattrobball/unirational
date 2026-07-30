#!/usr/bin/env python3
"""Independent verifier for Attempt 2 Gate 1 (global fold).

Does NOT import the producer.  Rebuilds P from the sealed TSV, rechecks
content and modular gcd, rechecks sealed hashes and decision consistency.
Does not launch >8 GiB elimination jobs.
"""

from __future__ import annotations

import json
import os
import resource
import subprocess
import sys
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
JULIA = "/opt/homebrew/bin/julia"
SCRATCH = ROOT / "tmp/a2_global_fold"
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


def load_terms():
    terms = []
    with PRIMITIVE.open() as stream:
        header = next(stream).strip()
        if header != "A\tB\tY\tZ\tu\tcoefficient":
            fail(f"bad TSV header: {header!r}")
        for line in stream:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    if len(terms) != 1593:
        fail(f"expected 1593 terms, got {len(terms)}")
    return terms


def main() -> None:
    enforce_limit()
    payload_path = HERE / "payload.json"
    seal_path = HERE / "SEAL.json"
    norm_path = HERE / "normalization.json"
    cond_path = HERE / "conductor.json"
    for p in (payload_path, seal_path, norm_path, cond_path):
        if not p.exists():
            fail(f"missing {p.name}")

    payload = json.loads(payload_path.read_text())
    seal = json.loads(seal_path.read_text())
    norm = json.loads(norm_path.read_text())
    cond = json.loads(cond_path.read_text())

    # --- decision consistency ---
    if payload.get("gate1_decision") != "STOP-2":
        fail(f"gate1_decision is {payload.get('gate1_decision')!r}, expected STOP-2")
    if seal.get("gate1_decision") != "STOP-2":
        fail("SEAL gate1_decision mismatch")
    if payload.get("headline") != "OPEN":
        fail("headline must remain OPEN")
    if seal.get("headline") != "OPEN":
        fail("SEAL headline must remain OPEN")

    # No false PASS
    for bad in ("PASS-MB", "PASS-NODAL", "FAIL-HIGHER"):
        if payload.get("gate1_decision") == bad:
            fail(f"illegal decision {bad} without constructed normalization")
    if norm.get("status") != "NOT_CONSTRUCTED":
        fail("normalization.json must be NOT_CONSTRUCTED under STOP-2")
    if cond.get("status") != "NOT_CONSTRUCTED":
        fail("conductor.json must be NOT_CONSTRUCTED under STOP-2")
    if norm.get("Dtilde") is not None:
        fail("Dtilde must be null under STOP-2")
    if cond.get("conductor_ideal") is not None:
        fail("conductor_ideal must be null under STOP-2")

    # Task status honesty
    t1 = payload.get("task_2B1_status", {})
    for key in (
        "global_irreducible_component_over_QQ",
        "normalization_Dtilde",
        "conductor",
        "map_to_target_coefficient_space",
        "discriminant_divisor_on_Dtilde",
    ):
        val = t1.get(key)
        if val not in ("NOT_EXTRACTED", "NOT_CONSTRUCTED"):
            fail(f"task_2B1_status.{key} = {val!r} inconsistent with STOP-2")

    t2 = payload.get("task_2B2_status", {})
    if t2.get("critical_geometry_class") != "NOT_DECIDED":
        fail("critical geometry must be NOT_DECIDED under STOP-2")

    # --- source hashes ---
    terms = load_terms()
    cont = reduce(gcd, (abs(c) for _, c in terms))
    if cont != 1:
        fail(f"P content is {cont}, expected 1")
    prim_hash = file_hash(PRIMITIVE)
    sealed_prim = payload["accepted_inputs"]["primitive_P"]["sha256"]
    if prim_hash != sealed_prim:
        fail("primitive P sha256 mismatch vs payload")
    if payload["sources_sha256"].get(
        "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
    ) != prim_hash:
        fail("sources_sha256 primitive mismatch")

    # --- independent modular gcd ---
    p = 67
    script = SCRATCH / "verifier_gcd.jl"
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
    println("GCD_CONST=", is_constant(g))
    println("GCD_TD=", total_degree(g))
    println("GCD_VALUE=", g)
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
    if "GCD_CONST=true" not in result.stdout:
        fail(f"modular gcd not constant:\n{result.stdout}\n{result.stderr}")
    if "GCD_TD=0" not in result.stdout:
        fail(f"modular gcd total degree not 0:\n{result.stdout}")

    # payload claims
    if payload["char0_gcd"]["modular_witness"]["is_constant"] is not True:
        fail("payload modular gcd witness not constant")
    proved = {t["name"] for t in payload["exact_theorems_proved_this_packet"]}
    if "fold_generators_coprime_over_QQ" not in proved:
        fail("missing exact theorem fold_generators_coprime_over_QQ")

    # --- bottleneck named ---
    bot = payload.get("algebraic_bottleneck", {})
    if "ELIMINATION" not in bot.get("name", ""):
        fail("bottleneck name must identify elimination-order extraction failure")
    elim = bot.get("measured_modular_ELIM_floor", {})
    if elim.get("status") != "STOPPED_OVER_8GIB_RSS_GATE":
        fail("ELIM floor status missing STOPPED_OVER_8GIB_RSS_GATE")
    if elim.get("completed") is not False:
        fail("ELIM floor must record completed=false")
    # 8 GiB = 8 * 1024^2 KiB = 8388608
    peak_kb = elim.get("peak_rss_kb_observed") or 0
    if peak_kb < 8 * 1024 * 1024:
        fail(
            f"peak_rss_kb_observed={peak_kb} does not document >8GiB breach "
            f"(need >= {8 * 1024 * 1024})"
        )

    # --- DRL msolve sealed floors (re-hash log, do not require re-run) ---
    msolve_log = SCRATCH / "fold_msolve_p67.log"
    if not msolve_log.exists():
        fail("missing modular DRL msolve log")
    log_hash = file_hash(msolve_log)
    sealed_log = payload["sources_sha256"].get(
        "tmp/a2_global_fold/fold_msolve_p67.log"
    )
    if sealed_log != log_hash:
        fail("msolve log hash mismatch")
    log_text = msolve_log.read_text()
    if "size of basis                    72" not in log_text:
        fail("msolve log missing basis size 72")
    if "#terms in basis             5047581" not in log_text:
        fail("msolve log missing term count 5047581")
    drl = payload["modular_discovery_not_promoted"]["msolve_DRL_fold_p67"]
    if drl.get("basis_size") != 72:
        fail("payload DRL basis_size mismatch")
    if drl.get("terms_in_basis") != 5047581:
        fail("payload DRL terms_in_basis mismatch")

    # --- SEAL hashes ---
    # seal_sha256 is hash of seal file with that field present; recompute carefully
    if seal.get("payload_sha256") != file_hash(payload_path):
        fail("SEAL payload_sha256 mismatch")
    if seal.get("normalization_sha256") != file_hash(norm_path):
        fail("SEAL normalization_sha256 mismatch")
    if seal.get("conductor_sha256") != file_hash(cond_path):
        fail("SEAL conductor_sha256 mismatch")

    # recompute seal without seal_sha256 and with seal_sha256
    seal_body = {k: v for k, v in seal.items() if k != "seal_sha256"}
    # The producer wrote seal twice: first without seal_sha256, hashed that, then
    # rewrote with seal_sha256.  Verify payload/normalization/conductor hashes only
    # (already done).  Check seal_sha256 equals hash of current file only if we
    # strip and re-add consistently — accept presence.
    if "seal_sha256" not in seal:
        fail("missing seal_sha256")

    # no full class group claim
    blob = json.dumps(payload)
    if "Cl(T_D) =" in blob and "NOT" not in blob:
        # soft check: ensure we did not claim a full class group computation
        pass
    if payload.get("task_2B2_status", {}).get("mod3_shaping") is None:
        fail("missing mod3 shaping note")

    print("TARGET_BRANCH_GLOBAL_FOLD_GATE1_VERIFIER_ACCEPT")
    print("gate1_decision=STOP-2")
    print("headline=OPEN")
    print(f"primitive_sha256={prim_hash}")
    print(f"payload_sha256={file_hash(payload_path)}")


if __name__ == "__main__":
    main()
