#!/usr/bin/env python3
"""Hash the authoritative inputs consumed or reported by this packet.

The manifest deliberately records the current sibling COV seal audit instead
of assuming that the mutable sibling directory still matches its old seal.
"""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUTPUT = HERE / "INPUT_MANIFEST.json"


INPUTS = [
    "goals_after_bd610a/GOAL_P25_COV_FINITE_SUPPORT.md",
    "certificates/degree25_finite_module/relation_matrix.npz",
    "certificates/degree25_finite_module/multiplication_matrices.npz",
    "certificates/degree25_finite_module/rewrite_rules.npz",
    "certificates/degree25_finite_module/basis_B.json",
    "certificates/degree25_molien/molien_values.json",
    "certificates/degree25_exact/change_of_basis/matrices_multiprime.npz",
    "certificates/degree25_exact/common_p25x.py",
    "certificates/degree25_direct_support/dvr_special_fibre_p89.npz",
    "tmp/d12_block_attack/results_d25.json",
    "certificates/degree25_direct_support/DVR_MODEL.md",
    "certificates/degree25_direct_support/dvr_certificate.json",
    "certificates/degree25_rowrank/ROW_RANK.md",
    "certificates/degree25_rowrank/rank_certificate.json",
    "goals_2026-08-01/P25_LANDING_SUPPORT/STATUS.md",
    "goals_2026-08-01/P25_LANDING_SUPPORT/ACCEPTANCE_AUDIT.md",
    "goals_2026-08-01/P25_LANDING_SUPPORT/NONVERDICT_RUNS.md",
    "goals_2026-08-01/P25_LANDING_SUPPORT/SEAL.json",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/full_linear_syzygy_basis.npy",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/full_p3_contractions.npy",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/lt_cover_analysis.json",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/lt_cover_nonpure_minor.npz",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/support_balanced_r43_stageBC.npz",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/enlarged_closure/support_balanced_r64_stageBC.npz",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/enlarged_closure/augmented_module_jobs.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/STATUS.md",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/SEAL.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/canonical_bases.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/landing_ideals.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/primitive_module.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/primitive_quotient_counterexample.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_25_fixed_k1_basis.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/dual_hironaka_generators.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/invariant_generators.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/produce_cross_basis.py",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_31/m1_cross_basis_circuits.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_35/m1_cross_basis_circuits.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/c3_constant_gate.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/c3_first_normal_gate.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/c3_second_normal_gate.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/c3_deep_normal_gate.json",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_31/p25_multiplier_embedding_p463.npz",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_31/p25_multiplier_embedding_p727.npz",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_35/p25_multiplier_embedding_p463.npz",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_35/p25_multiplier_embedding_p727.npz",
]


EXPECTED_CORE_HASHES = {
    "certificates/degree25_finite_module/relation_matrix.npz":
        "6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb",
    "certificates/degree25_finite_module/multiplication_matrices.npz":
        "cdee1a9cd2989f2d17e7771321b49723d8a9dfc71d2bd5a791f83a30142aa418",
    "certificates/degree25_finite_module/rewrite_rules.npz":
        "9dd25476c3927e533b2587e5048028ad0304141d6849f6649ca921ed5d057028",
    "certificates/degree25_finite_module/basis_B.json":
        "8224008341d458b5768ef7a418309f375cbcc47380b118e02af7cdd15d7dd045",
    "certificates/degree25_molien/molien_values.json":
        "996ff09154efced55712124c527ec6f7120a9dc032c70bd05220da6e2aaa3c7c",
    "certificates/degree25_exact/change_of_basis/matrices_multiprime.npz":
        "815666837ff861bb279f37d22d0a1bbe1f8f5745f42be46354ddbef865ac7614",
    "certificates/degree25_exact/common_p25x.py":
        "b5d27fe9174e859a88a9b1704963e07a4ff53f96ddd259d83c5a7d148d9588bc",
    "certificates/degree25_direct_support/dvr_special_fibre_p89.npz":
        "02b96da20504b902d3f53906382f3afb6c55e20792c31b8b0b5346957fcfe1b8",
    "tmp/d12_block_attack/results_d25.json":
        "8555137c5a3db1c99394591e4045ff974870ce22bdb4b9f4e30876dd4f9dc4c3",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/full_linear_syzygy_basis.npy":
        "3571e9879bf1af6d6a405d9761522d4253e76e40edd129afd4b9363287d60ca3",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/full_p3_contractions.npy":
        "93eb010020c7b808039243cd64aede54677c95f74c17efe8e3abb03c5dbf2019",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/lt_cover_analysis.json":
        "e1275a14fd8887418d0638437856e07e4b075b08e5be3147b4210ccaf394ded5",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/lt_cover_nonpure_minor.npz":
        "f7da4f4237290d046976cb5ac9df62aa1888db17f5d657c1cb0e614cb8f9db12",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/support_balanced_r43_stageBC.npz":
        "821e1340cd6242a1d89a3a59f89d6d0fbee7fa1b4207e931b28d4c402f5fbedb",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/enlarged_closure/support_balanced_r64_stageBC.npz":
        "c50de97aa4fc9465793f3fe84b544731b36cec1a2807113e94817c955897be2b",
    "goals_2026-08-01/P25_LANDING_SUPPORT/parallel/enlarged_closure/augmented_module_jobs.json":
        "06ec7f491fb7c6d8c99fe5693bfef0a5c4ff8334ceee93d3670a4f306ac827a0",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_25_fixed_k1_basis.json":
        "73e6132e19105d4489d70093edf310c766051b90583536ba3b3fa85e223722b1",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/dual_hironaka_generators.json":
        "b9aa1f8fe852e15b1b786b6a0577f06cf3ce200c5b092bcbd4c444678add874b",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/invariant_generators.json":
        "1912db3e0c30c09d7485804adb03e9aeaed739076e2b87b8a2890007727c6421",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/produce_cross_basis.py":
        "7b99bf7712fdf3dd898ab27ff3cb469c9f5213bdab1c35902813993ce6210f68",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_31/m1_cross_basis_circuits.json":
        "8adc3f91db76f97a47d1df6d3f9cccee9e8eef62a825c2dff045ad96db6ff2f6",
    "goals_2026-08-01/COV_M1_DEG31_35_WORK/degree_35/m1_cross_basis_circuits.json":
        "f28effc9a4c9e8923980b4726d264672141a030a61a23a416534b426a301775a",
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 22):
            digest.update(chunk)
    return digest.hexdigest()


def audit_seal(directory: Path) -> dict[str, object]:
    seal_path = directory / "SEAL.json"
    payload = json.loads(seal_path.read_text())
    records = payload["files"]
    if isinstance(records, dict):
        records = [
            dict(
                path=path,
                sha256=(value["sha256"] if isinstance(value, dict) else value),
            )
            for path, value in records.items()
        ]
    mismatches: list[dict[str, object]] = []
    for record in records:
        path = directory / record["path"]
        actual = sha256_file(path) if path.is_file() else None
        if actual != record["sha256"]:
            mismatches.append(
                {
                    "path": record["path"],
                    "sealed_sha256": record["sha256"],
                    "actual_sha256": actual,
                }
            )
    return {
        "seal": str(seal_path.relative_to(ROOT)),
        "records": len(records),
        "mismatches": mismatches,
        "intact": not mismatches,
    }


def git(*args: str) -> str:
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).strip()


def main() -> int:
    records = []
    for relative in INPUTS:
        path = ROOT / relative
        if not path.is_file():
            raise FileNotFoundError(path)
        digest = sha256_file(path)
        expected = EXPECTED_CORE_HASHES.get(relative)
        if expected is not None and digest != expected:
            raise AssertionError(f"core input hash mismatch for {relative}")
        records.append(
            {
                "path": relative,
                "bytes": path.stat().st_size,
                "sha256": digest,
                "expected_core_hash_match": None if expected is None else True,
            }
        )

    payload = {
        "schema": "p25-cov-support-input-manifest-v1",
        "pinned_state": "bd610a032bb9561d2daeb91a2cb60c48c082ca2f",
        "pinned_state_resolves_to": git(
            "rev-parse", "bd610a032bb9561d2daeb91a2cb60c48c082ca2f"
        ),
        "observed_head": git("rev-parse", "HEAD"),
        "field": "F_89 for PC.0--PC.2 computations; characteristic-zero and split-prime evidence is reported only at its inherited scope",
        "inputs": records,
        "sibling_seal_audits": {
            "p25_landing_support": audit_seal(
                ROOT / "goals_2026-08-01" / "P25_LANDING_SUPPORT"
            ),
            "cov_m1_deg31_35_work": audit_seal(
                ROOT / "goals_2026-08-01" / "COV_M1_DEG31_35_WORK"
            ),
        },
        "consumption_rule": (
            "Local producers and verifiers consume the named hash-pinned inputs above. "
            "PC.3 reporting consumes named core artifacts by their current hashes, "
            "not the mutable sibling directory as an intact seal."
        ),
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    cov_audit = payload["sibling_seal_audits"]["cov_m1_deg31_35_work"]
    print(
        "PASS_INPUT_MANIFEST "
        f"inputs={len(records)} cov_seal_mismatches={len(cov_audit['mismatches'])}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
