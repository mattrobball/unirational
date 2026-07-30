#!/usr/bin/env python3
"""Independent WP-T1 verifier.

Does not import produce.py.  Rebuilds the A=0,B=2 critical ideal from the
primitive TSV, recomputes dim/degree in Macaulay2, and checks the sealed
payload hashes and theorem boundary claims.
"""

from __future__ import annotations

import json
import os
import resource
import subprocess
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PRIMITIVE = (
    ROOT
    / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
)
M2 = "/opt/homebrew/bin/M2"
CAP_ENV = "WP_T1_TARGET_BRANCH_MOD3_VERIFY_MIB"
CEILING_MIB = 4096


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


def specialize(terms, which: str) -> str:
    var_index = {
        "P": None,
        "PA": 0,
        "PB": 1,
        "PY": 2,
        "PZ": 3,
        "Pu": 4,
    }[which]
    parts = []
    for exps, coeff in terms:
        if var_index is None:
            new = list(exps)
            c = coeff
        else:
            e = exps[var_index]
            if e == 0:
                continue
            new = list(exps)
            new[var_index] = e - 1
            c = coeff * e
        a, b, y, z, u = new
        if a > 0:
            continue
        c *= 2**b
        mon = []
        if c != 1 and c != -1:
            mon.append(f"({c})" if c < 0 else str(c))
        elif c == -1:
            mon.append("(-1)")
        for name, exp in (("Y", y), ("Z", z), ("u", u)):
            if exp == 1:
                mon.append(name)
            elif exp:
                mon.append(f"{name}^{exp}")
        if not mon:
            mon = ["1"]
        parts.append("*".join(mon))
    return "+".join(parts) if parts else "0"


def main() -> None:
    enforce_limit()
    payload_path = HERE / "payload.json"
    seal_path = HERE / "SEAL.json"
    assert payload_path.is_file(), "missing payload.json"
    assert seal_path.is_file(), "missing SEAL.json"

    seal = json.loads(seal_path.read_text())
    payload_bytes = payload_path.read_bytes()
    assert sha256(payload_bytes).hexdigest() == seal["payload_sha256"]
    payload = json.loads(payload_bytes)

    # Source hash checks
    for rel, digest in payload["sources_sha256"].items():
        path = ROOT / rel
        assert path.is_file(), rel
        assert file_hash(path) == digest, rel

    # Independent M2 recomputation of the slice critical theorem
    terms = load_terms()
    script = HERE / "verify_slice_critical_qq.m2"
    log = HERE / "verify_slice_critical_qq.m2.log"
    lines = [
        "-- independent verifier rebuild; does not import producer output polynomials",
        "R=QQ[Y,Z,u,MonomialOrder=>GRevLex];",
        f"P={specialize(terms, 'P')};",
        f"PA={specialize(terms, 'PA')};",
        f"PB={specialize(terms, 'PB')};",
        f"PY={specialize(terms, 'PY')};",
        f"PZ={specialize(terms, 'PZ')};",
        f"Pu={specialize(terms, 'Pu')};",
        "J=ideal(P,PA,PB,PY,PZ,Pu);",
        'print "VERIFY_SLICE_BUILT";',
        'print("VERIFY_CRIT_DIM="|toString dim J);',
        'print("VERIFY_CRIT_DEGREE="|toString degree J);',
        'print("VERIFY_CRIT_CODIM="|toString codim J);',
        "Jsing=ideal(P,diff(Y,P),diff(Z,P),diff(u,P));",
        'print("VERIFY_SING_DIM="|toString dim Jsing);',
        'print("VERIFY_SING_DEGREE="|toString degree Jsing);',
        'print "VERIFY_SLICE_CRITICAL_OK";',
        "exit 0;",
    ]
    script.write_text("\n".join(lines) + "\n")
    result = subprocess.run(
        [M2, "--stop", "--no-prompts", "--silent", str(script)],
        check=True,
        capture_output=True,
        text=True,
        timeout=600,
    )
    text = result.stdout + result.stderr
    log.write_text(text)
    assert "VERIFY_SLICE_CRITICAL_OK" in text

    got = {}
    for line in text.splitlines():
        for key in (
            "VERIFY_CRIT_DIM",
            "VERIFY_CRIT_DEGREE",
            "VERIFY_CRIT_CODIM",
            "VERIFY_SING_DIM",
            "VERIFY_SING_DEGREE",
        ):
            if line.startswith(key + "="):
                got[key] = int(line.split("=", 1)[1])

    slice_model = payload["cramer_saturated_model"]["slice_A0_B2"]
    assert got["VERIFY_CRIT_DIM"] == slice_model["critical_dim"] == 1
    assert got["VERIFY_CRIT_DEGREE"] == slice_model["critical_degree"] == 14
    assert got["VERIFY_CRIT_CODIM"] == slice_model["critical_codim"] == 2
    assert got["VERIFY_SING_DIM"] == slice_model["sing_dim"] == 1
    assert got["VERIFY_SING_DEGREE"] == slice_model["sing_degree"] == 14

    # Theorem-boundary checks: producer must not claim a closed mod-3 gate
    verdict = payload["verdict"]
    assert verdict["headline"] == "OPEN"
    assert verdict["three_primary_defect"] == "NOT_DECIDED"
    assert verdict["horizontal_degree_subgroup"] == "NOT_DECIDED"
    assert verdict["dangerous_class_exhibited"] is False
    assert verdict["prime_to_three_vertical_classes_proved"] is False
    assert payload["headline"] == "OPEN"

    # Seal script hash matches the producer script that was sealed
    prod_script = HERE / seal["slice_script"]
    assert prod_script.is_file()
    assert file_hash(prod_script) == seal["slice_script_sha256"]
    assert file_hash(HERE / seal["slice_log"]) == seal["slice_log_sha256"]

    print("VERIFY_CRIT_DIM=1")
    print("VERIFY_CRIT_DEGREE=14")
    print("VERIFY_BOUNDARY_OPEN_OK")
    print("TARGET_BRANCH_MOD3_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
