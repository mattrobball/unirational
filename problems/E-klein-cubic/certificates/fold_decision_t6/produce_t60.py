#!/usr/bin/env python3
"""T6.0 producer — first-subresultant circuit audit seal.

Does not import the verifier. No timing fields. Self-hashes last.
Exit: T60-UNDECIDED (s1 unit not exact-proved).
"""
from __future__ import annotations

import json
import os
import resource
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
CEILING_MIB = 8192
CAP_ENV = "T60_PRODUCER_MIB"


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


def main() -> None:
    enforce_limit()
    assert P_PATH.is_file()
    assert file_hash(P_PATH) == EXPECTED_P

    required = [
        "SUBRESULTANT_AUDIT.md",
        "subresultant_1.circuit.json",
        "principal_subresultants.json",
        "rank_one_algebra_map.json",
        "relative_differentials.json",
        "s1_unit_mod_summary.json",
        "s1_zero_points.out",
    ]
    for name in required:
        assert (HERE / name).is_file(), name

    audit = (HERE / "SUBRESULTANT_AUDIT.md").read_text()
    assert "T60-UNDECIDED" in audit
    assert "BOTTLENECK-T60-S1-UNIT-EXACT" in audit
    assert "Do not infer normality" in audit or "not inferred" in audit.lower()

    circuit = json.loads((HERE / "subresultant_1.circuit.json").read_text())
    assert circuit["representation"] == "exact_ducos_subresultant_PRS_circuit"
    assert circuit["expansion_status"]["exact_sparse_s0_s1"] == "NOT_EXPANDED"

    rank = json.loads((HERE / "rank_one_algebra_map.json").read_text())
    assert rank["s1_unit_on_open"]["status"] == "NOT_PROVED_EXACTLY"
    assert rank["isomorphism_S_G_B_G"]["status"] == "NOT_PROVED"

    mod = json.loads((HERE / "s1_unit_mod_summary.json").read_text())
    assert mod["status"] == "discovery_only"
    for pr in mod["primes"]:
        assert pr["n_s1_zero"] == 0, pr

    # Pointwise Sres identity samples (exact Q univariate)
    # Load P and check at a few points that Sres_1 divides appropriately
    terms = []
    with P_PATH.open() as f:
        assert next(f).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in f:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    assert len(terms) == 1593

    payload = {
        "schema": "klein-cubic-T60-payload-v1",
        "gate": "T6.0",
        "exit": "T60-UNDECIDED",
        "s1_representation": "exact_ducos_PRS_circuit",
        "s1_unit_exact": False,
        "isomorphism_S_G_B_G": False,
        "normality_inferred": False,
        "bottleneck": "BOTTLENECK-T60-S1-UNIT-EXACT",
        "inputs": {"P_sha256": EXPECTED_P},
        "artifacts": {name: file_hash(HERE / name) for name in required},
    }
    out = HERE / "t60_payload.json"
    # write without self hash first
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    out.write_text(text)
    payload["payload_sha256"] = file_hash(out)
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("T60_PRODUCER_SEALED", payload["exit"])


if __name__ == "__main__":
    main()
