#!/usr/bin/env python3
"""Verify the prepared source, command delta, local semantics, and no-run state."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess

import run_pair_split as runner


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
BASE = P25 / "parallel" / "determinantal_cover"
BASE_SOURCE = BASE / "r66_stageB_qflag00_bflag0.ms"
BASE_RECORD = BASE / "r66_stageB_qflag00_bflag0.run.json"
SOURCE = HERE / "r66_stageB_q0_1_b1_0_1_m100.ms"
MANIFEST = HERE / "input_manifest.json"
RESULT = HERE / "verify_prepared_result.json"

EXPECTED_SOURCE_SHA256 = "9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b"
EXPECTED_PACKET_SHA256 = "b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def option_map(command: list[str]) -> dict[str, str]:
    answer: dict[str, str] = {}
    index = 1
    while index < len(command):
        flag = command[index]
        if index + 1 >= len(command):
            raise AssertionError(f"option without value: {flag}")
        answer[flag] = command[index + 1]
        index += 2
    return answer


def main() -> None:
    manifest = json.loads(MANIFEST.read_text())
    if manifest["status"] != "PASS_IMMUTABLE_R66_CHART_REGENERATED":
        raise AssertionError("input manifest status mismatch")
    if sha256(SOURCE) != EXPECTED_SOURCE_SHA256 or sha256(BASE_SOURCE) != EXPECTED_SOURCE_SHA256:
        raise AssertionError("chart source hash mismatch")
    if SOURCE.read_bytes() != BASE_SOURCE.read_bytes():
        raise AssertionError("regenerated chart is not byte-for-byte baseline-identical")
    if manifest["r66_packet_sha256"] != EXPECTED_PACKET_SHA256:
        raise AssertionError("manifest packet binding mismatch")

    baseline = json.loads(BASE_RECORD.read_text())["command"]
    proposed = [
        str(runner.MSOLVE), "-f", str(SOURCE), "-o", str(runner.LEADING),
        "-t", "4", "-v", "2", "-g", "1", "-l", "2", "-q", "0",
        "-r", "0", "-s", "20", "-m", "100", "--random-seed", "2026080189",
    ]
    old = option_map(baseline)
    new = option_map(proposed)
    path_options = {"-f", "-o"}
    changed = {
        key: [old.get(key), new.get(key)]
        for key in sorted(set(old) | set(new))
        if key not in path_options and old.get(key) != new.get(key)
    }
    if changed != {"-m": ["0", "100"]}:
        raise AssertionError(f"unexpected baseline command delta: {changed}")
    if "-u" in new:
        raise AssertionError("hash reset must remain at the baseline default OFF")

    help_text = subprocess.run(
        [str(runner.MSOLVE), "-h"], check=True, capture_output=True, text=True
    ).stdout
    required_help = {
        "pair_cap": "Maximal number of pairs used per matrix.",
        "pair_unlimited": "0 - unlimited (default).",
        "hash_reset": "hash table is newly generated.",
        "hash_default": "0 - no update (default).",
        "ordinary_mode": "0 - no (default).",
        "exact_sparse": "2 - exact sparse (default)",
    }
    for label, phrase in required_help.items():
        if phrase not in help_text:
            raise AssertionError(f"local msolve help lost {label}: {phrase}")
    version = subprocess.run(
        [str(runner.MSOLVE), "-V"], check=True, capture_output=True, text=True
    ).stdout.strip()
    if "0.10.1" not in version:
        raise AssertionError(f"unexpected msolve version: {version}")

    memory = runner.vm_free_speculative()
    process_gate: dict[str, object]
    try:
        import os

        rows = runner.process_rows()
        competing = runner.competing_p25_probes(rows)
        # Self-check: leader RSS for this verifier process is positive.
        self_rss = runner._rss_bytes(os.getpid())
        if self_rss is None or self_rss <= 0:
            raise RuntimeError("libproc RSS self-check failed")
        process_gate = {
            "available": True,
            "backend": "libproc+sysctl_no_ps",
            "row_count": len(rows),
            "self_rss_bytes": self_rss,
            "competing_p25_bounded_probes": competing,
            "ps_required": False,
        }
    except RuntimeError as exc:
        process_gate = {
            "available": False,
            "backend": "libproc+sysctl_no_ps",
            "ps_required": False,
            "error": str(exc),
        }

    generated_run_artifacts = [
        path.name for path in (runner.PRELAUNCH, runner.LEADING, runner.LOG, runner.RUN_RECORD)
        if path.exists()
    ]
    if generated_run_artifacts:
        raise AssertionError(f"retry was unexpectedly launched: {generated_run_artifacts}")

    default_rss_bytes = int(runner.DEFAULT_RSS_GIB * (1 << 30))
    memory_pass = memory["free_plus_speculative_bytes"] >= runner.MIN_FREE_SPEC_BYTES
    process_pass = bool(process_gate.get("available")) and not process_gate.get(
        "competing_p25_bounded_probes"
    )
    launch_path = (
        "LAUNCH_OK_GATES"
        if memory_pass and process_pass
        else "BLOCKED"
    )
    payload = {
        "status": "PREPARED_NOT_RUN",
        "source": {
            "sha256": sha256(SOURCE),
            "bytes": SOURCE.stat().st_size,
            "byte_for_byte_baseline_identical": True,
            "independently_regenerated_from_r66": True,
            "r66_packet_sha256": EXPECTED_PACKET_SHA256,
            "chart": "Stage B q0=1,b1_0=1",
            "field": 89,
        },
        "ordinary_msolve_retry": {
            "version": version,
            "binary_sha256": sha256(runner.MSOLVE.resolve()),
            "baseline_nonpath_option_delta": changed,
            "max_pairs_per_matrix": 100,
            "hash_table_reset": "OFF",
            "threads": runner.THREADS,
            "timeout_seconds_default": runner.DEFAULT_TIMEOUT_SECONDS,
            "timeout_seconds_range": [
                runner.MIN_TIMEOUT_SECONDS,
                runner.MAX_TIMEOUT_SECONDS,
            ],
            "rss_limit_bytes_default": default_rss_bytes,
            "rss_limit_gib_default": runner.DEFAULT_RSS_GIB,
            "rss_limit_gib_range": [runner.MIN_RSS_GIB, runner.MAX_RSS_GIB],
            "retired_theater_fence_gib": 4.5,
            "arithmetic": "exact sparse, ordinary F4, characteristic from unchanged input",
        },
        "pair_split_semantics": {
            "supported_by_local_help": True,
            "local_help_statement": required_help["pair_cap"],
            "effect": (
                "Each F4 matrix selects at most 100 pairs, so the observed 1708-pair "
                "degree-6 batch cannot be selected as one matrix. Basis updates may change "
                "the later pair list, so this is a cap, not a fixed 18-block partition."
            ),
            "ideal_or_field_change": False,
            "reason": (
                "The input is byte-identical over F_89 and every nonpath option is identical "
                "except the documented F4 per-matrix pair cap."
            ),
            "hash_reset_not_enabled": (
                "No reset is justified before observing the isolated -m 100 retry; omitting "
                "-u preserves the baseline OFF setting and isolates pair batching."
            ),
        },
        "launch_gate_snapshot": {
            "memory": memory,
            "minimum_free_plus_speculative_bytes": runner.MIN_FREE_SPEC_BYTES,
            "memory_gate_pass": memory_pass,
            "process_gate": process_gate,
            "process_gate_pass": process_pass,
            "launch_path_verdict": launch_path,
            "fence_proposal": {
                "rss_gib": runner.DEFAULT_RSS_GIB,
                "timeout_seconds": runner.DEFAULT_TIMEOUT_SECONDS,
                "host_ram_gib": 128,
                "rationale": (
                    "Prior incomplete stop at ~4.28 GiB makes 4.5 GiB theater; "
                    "16 GiB default (flag up to 32) is a realistic completion fence "
                    "on a 128 GiB host with >=14 GiB free+speculative prelaunch."
                ),
            },
            "parent_instruction": "READY_FOR_SINGLE_CHART_IF_GATES_PASS",
        },
        "run_artifacts": generated_run_artifacts,
        "exact_blocker": (
            None
            if launch_path == "LAUNCH_OK_GATES"
            else (
                "Launch still blocked: "
                + (
                    "process census/RSS backend unavailable or competing probes present"
                    if not process_pass
                    else "free+speculative memory below 14 GiB"
                )
            )
        ),
        "criterion": (
            "A completed exact unit ideal is decisive only for this affine chart. Every "
            "other result, including a completed nonunit basis, is a nonverdict."
        ),
    }
    RESULT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(payload["status"])
    print("launch_path_verdict:", launch_path)
    print("process_gate:", json.dumps(process_gate, sort_keys=True)[:500])


if __name__ == "__main__":
    main()
