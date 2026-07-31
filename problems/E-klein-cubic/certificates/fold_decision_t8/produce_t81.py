#!/usr/bin/env python3
"""T8.1 producer — first-subresultant unit-target seal.

Does not import the verifier. Exit: T8-S1-UNDECIDED.
Independent of certificates/fold_decision_t6 producers.
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
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"
CEILING_MIB = 8192
CAP_ENV = "T81_PRODUCER_MIB"


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
    assert file_hash(P_PATH) == EXPECTED_P
    assert file_hash(H_PATH) == EXPECTED_H

    required = [
        "SUBRESULTANT_UNIT_TARGET.md",
        "subresultant_identities.json",
        "factor_ledger.json",
        "planes.json",
        "modular_nonunit_discovery.json",
        "sres_eval_t81.py",
        "verify_t81.py",
    ]
    for name in required:
        assert (HERE / name).is_file(), name

    audit = (HERE / "SUBRESULTANT_UNIT_TARGET.md").read_text()
    assert "T8-S1-UNDECIDED" in audit
    assert "BOTTLENECK-T8-S1-EXACT-CHAR0-WITNESS" in audit
    assert "OPEN" in audit
    assert "Do not promote modular" in audit or "discovery only" in audit.lower()

    ids = json.loads((HERE / "subresultant_identities.json").read_text())
    assert ids["expansion_status"]["exact_sparse_s0_s1"] == "NOT_EXPANDED"

    mod = json.loads((HERE / "modular_nonunit_discovery.json").read_text())
    assert "discovery" in mod.get("status", "").lower() or mod.get("status", "").startswith(
        "discovery"
    )
    # At least one full gate-pass modular witness recorded
    wits = mod.get("witnesses", [])
    full = [w for w in wits if w.get("ufree_gates_ok") and w.get("binodal_Puu_ok")]
    assert full, "expected at least one modular full gate-pass binodal witness"

    # Spot-check evaluation oracle
    sys.path.insert(0, str(HERE))
    import sres_eval_t81 as S  # noqa: E402

    P = S.load_P()
    s1, s0, st = S.eval_s1_at_point(P, 1, 2, 3, 4)
    assert st == "ok"
    assert s1 != 0

    payload = {
        "schema": "klein-cubic-T81-payload-v1",
        "gate": "T8.1",
        "exit": "T8-S1-UNDECIDED",
        "s1_representation": "independent_euclidean_PRS_circuit",
        "s1_unit_exact": False,
        "s1_nonunit_exact": False,
        "modular_nonunit_discovery": True,
        "structural_reduction_s4_verified": True,
        "normality_inferred": False,
        "bottleneck": "BOTTLENECK-T8-S1-EXACT-CHAR0-WITNESS",
        "secondary_bottleneck": "BOTTLENECK-T8-SRES1-EXPANSION",
        "inputs": {"P_sha256": EXPECTED_P, "H_sha256": EXPECTED_H},
        "n_modular_full_gate_witnesses": len(full),
        "artifacts": {name: file_hash(HERE / name) for name in required},
    }
    out = HERE / "t81_payload.json"
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    payload["payload_sha256"] = file_hash(out)
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("T81_PRODUCER_SEALED", payload["exit"])


if __name__ == "__main__":
    main()
