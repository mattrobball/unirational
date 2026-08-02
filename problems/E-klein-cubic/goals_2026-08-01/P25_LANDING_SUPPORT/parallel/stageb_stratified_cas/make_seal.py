#!/usr/bin/env python3
"""Seal the closed-L8 theorem artifacts and unlaunched complement-job ledger."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
ROOT = HERE.parents[3]
OUTPUT = HERE / "SEAL.json"

FILES = (
    "WORK_SCOPE.md",
    "REPORT.md",
    "audit_closed_L8_stageC.py",
    "closed_L8_stageC_preflight.json",
    "produce_closed_L8_stageC.py",
    "run_bounded_python.py",
    "produce_closed_L8_stageC.log",
    "produce_closed_L8_stageC.run.json",
    "closed_L8_stageC_certificate.json",
    "closed_L8_stageC_compatibility.npz",
    "verify_closed_L8_stageC.py",
    "verify_closed_L8_stageC.log",
    "verify_closed_L8_stageC.run.json",
    "verify_closed_L8_stageC_result.json",
    "produce_closed_L8_augmented_module.py",
    "run_closed_L8_augmented_module.py",
    "closed_L8_augmented_module_jobs.json",
    "closed_L8_augmented_module_degrevlex.sing",
    "closed_L8_augmented_module_deglex.sing",
    "closed_L8_augmented_module_degrevlex.log",
    "produce_stratified_jobs.py",
    "stratified_jobs.json",
    "verify_stratified_inputs.py",
    "verify_stratified_inputs_result.json",
    "stageB_new_r43_L8_complement_Hfirst.sing",
    "stageB_old_r48_L8_complement_Hfirst.sing",
    "stageC_new_r43_L8_complement_Hfirst.sing",
    "stageC_old_r48_L8_complement_Hfirst.sing",
    "combined_old_r48_L8_complement_Hfirst.sing",
    "combined_r64_L8_complement_Hfirst.sing",
    "make_seal.py",
    "verify_seal.py",
)

DEPENDENCIES = {
    "P25:syzygy_r256_q0_contracted.npz": P25 / "syzygy_r256_q0_contracted.npz",
    "P25:syzygy_r48_q0_contracted.npz": P25 / "syzygy_r48_q0_contracted.npz",
    "P25:linear_syzygies_r48_reconstructed.npz": P25
    / "linear_syzygies_r48_reconstructed.npz",
    "P25:parallel/stageb_strata/closed_L_degree6_certificate.json": P25
    / "parallel/stageb_strata/closed_L_degree6_certificate.json",
    "P25:parallel/stageb_strata/verify_closed_L_degree6_result.json": P25
    / "parallel/stageb_strata/verify_closed_L_degree6_result.json",
    "P25:parallel/stageb_global_basis/support_balanced_r43_stageBC.npz": P25
    / "parallel/stageb_global_basis/support_balanced_r43_stageBC.npz",
    "P25:parallel/stageb_global_basis/verify_sparse_packet_result.json": P25
    / "parallel/stageb_global_basis/verify_sparse_packet_result.json",
    "P25:parallel/enlarged_closure/support_balanced_r64_stageBC.npz": P25
    / "parallel/enlarged_closure/support_balanced_r64_stageBC.npz",
    "P25:parallel/enlarged_closure/verify_augmented_module_jobs_result.json": P25
    / "parallel/enlarged_closure/verify_augmented_module_jobs_result.json",
    "ROOT:certificates/degree25_finite_module/relation_matrix.npz": ROOT
    / "certificates/degree25_finite_module/relation_matrix.npz",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def file_record(path: Path) -> dict[str, int | str]:
    if not path.is_file():
        raise FileNotFoundError(path)
    return {"bytes": path.stat().st_size, "sha256": sha256(path)}


def main() -> None:
    with (HERE / "closed_L8_stageC_certificate.json").open() as handle:
        closed_c = json.load(handle)
    with (HERE / "verify_closed_L8_stageC_result.json").open() as handle:
        closed_v = json.load(handle)
    with (HERE / "stratified_jobs.json").open() as handle:
        ledger = json.load(handle)
    with (HERE / "verify_stratified_inputs_result.json").open() as handle:
        ledger_v = json.load(handle)
    if closed_c.get("status") != "PASS_CLOSED_L8_STAGEC_EMPTY":
        raise AssertionError("closed-L8 Stage-C certificate is not PASS")
    if closed_v.get("status") != "PASS_INDEPENDENT_CLOSED_L8_STAGEC_EMPTY":
        raise AssertionError("closed-L8 Stage-C replay is not PASS")
    if ledger.get("status") != "JOBS_GENERATED_NOT_LAUNCHED" or not ledger.get(
        "not_launched"
    ):
        raise AssertionError("complement ledger is not explicitly unlaunched")
    if ledger_v.get("status") != "PASS_STRATIFIED_INPUT_REPLAY":
        raise AssertionError("complement input replay is not PASS")
    if len(ledger.get("jobs", {})) != 6:
        raise AssertionError("complement job count changed")

    payload = {
        "status": "SEALED_CLOSED_L8_B_AND_C_EMPTY_COMPLEMENT_OPEN",
        "prime": 89,
        "closed_stratum": {
            "name": "L8=P<span(q4,...,q11)>",
            "stageB": "independently certified empty",
            "stageC": "independently certified empty",
            "stageC_degree8_rank": closed_c["degree8_map"]["rank"],
            "stageC_degree8_target": closed_c["degree8_map"]["target_dimension"],
            "stageC_certificate_sha256": sha256(
                HERE / "closed_L8_stageC_certificate.json"
            ),
            "stageC_replay_sha256": sha256(
                HERE / "verify_closed_L8_stageC_result.json"
            ),
        },
        "open_complement": {
            "name": "P36 minus L8",
            "status": "UNDECIDED",
            "prepared_exact_jobs": len(ledger["jobs"]),
            "jobs_launched": False,
            "ledger_sha256": sha256(HERE / "stratified_jobs.json"),
            "ledger_replay_sha256": sha256(
                HERE / "verify_stratified_inputs_result.json"
            ),
            "provenance_guard": ledger["provenance_guard"],
        },
        "files": {name: file_record(HERE / name) for name in FILES},
        "dependencies": {
            name: file_record(path) for name, path in DEPENDENCIES.items()
        },
        "scope_guard": (
            "This seal proves Stage B and normalized Stage C empty only on L8. "
            "It seals prepared but unlaunched exact jobs for P36 minus L8; it "
            "does not claim global Stage-B or Stage-C emptiness."
        ),
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {OUTPUT.name} with {len(FILES)} files and {len(DEPENDENCIES)} dependencies")


if __name__ == "__main__":
    main()
