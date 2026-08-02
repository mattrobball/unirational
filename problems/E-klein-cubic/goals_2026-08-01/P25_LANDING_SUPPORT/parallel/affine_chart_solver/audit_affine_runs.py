#!/usr/bin/env python3
"""Audit the affine r64 inputs and their bounded nonverdict run records."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PACKET = HERE.parent / "enlarged_closure" / "support_balanced_r64_stageBC.npz"
EXPECTED_PACKET_SHA256 = (
    "c50de97aa4fc9465793f3fe84b544731b36cec1a2807113e94817c955897be2b"
)
H8_CHARTS = [0, 1, 2, 3] + list(range(12, 37))


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def audit(label: str) -> dict:
    script = HERE / f"r64_combined_q0_eq_1_{label}.sing"
    metadata_path = HERE / f"r64_combined_q0_eq_1_{label}.input.json"
    run_path = HERE / f"r64_combined_q0_eq_1_{label}.run.json"
    log = HERE / f"r64_combined_q0_eq_1_{label}.log"
    for path in (script, metadata_path, run_path, log):
        if not path.is_file():
            raise FileNotFoundError(path)
    metadata = json.loads(metadata_path.read_text())
    run = json.loads(run_path.read_text())
    script_hash = sha256_file(script)
    log_hash = sha256_file(log)
    if metadata["packet_sha256"] != EXPECTED_PACKET_SHA256:
        raise AssertionError(f"{label}: packet hash mismatch in metadata")
    if metadata["script_sha256"] != script_hash:
        raise AssertionError(f"{label}: input metadata hash mismatch")
    if run["input_sha256"] != script_hash or run["input_bytes"] != script.stat().st_size:
        raise AssertionError(f"{label}: run/input provenance mismatch")
    if run["log_sha256"] != log_hash or run["log_bytes"] != log.stat().st_size:
        raise AssertionError(f"{label}: run/log provenance mismatch")
    if run["timeout_seconds"] > 600 or run["rss_limit_bytes"] > 8 * 1024**3:
        raise AssertionError(f"{label}: requested resource fence too large")
    if run["complete"] or run["returncode"] != -9:
        raise AssertionError(f"{label}: expected a fenced nonverdict")
    if run["stop_reason"] not in ("timeout", "rss"):
        raise AssertionError(f"{label}: unexpected stop reason")

    raw = script.read_text()
    module_text = raw.split("module N=\n", 1)[1].split('print("AFFINE_INPUT', 1)[0]
    if "q0" in module_text:
        raise AssertionError(f"{label}: q0 survived dehomogenization")
    generator_lines = [line for line in module_text.splitlines() if line.startswith("[")]
    comma_counts = [line.count(",") for line in generator_lines]
    if (
        len(generator_lines) != 64
        or comma_counts[:63] != [7] * 63
        or comma_counts[63:] != [6]
    ):
        raise AssertionError(f"{label}: malformed 64 by 7 module input")
    if (HERE / f"r64_combined_q0_eq_1_{label}.result.txt").exists():
        raise AssertionError(f"{label}: interrupted job unexpectedly wrote a result")
    return {
        "algorithm": label,
        "script_sha256": script_hash,
        "script_bytes": script.stat().st_size,
        "log_sha256": log_hash,
        "elapsed_seconds": run["elapsed_seconds"],
        "peak_rss_bytes_polled": run["peak_rss_bytes_polled"],
        "requested_rss_limit_bytes": run["rss_limit_bytes"],
        "stop_reason": run["stop_reason"],
        "complete": False,
        "verdict": "NONVERDICT",
    }


def main() -> None:
    if sha256_file(PACKET) != EXPECTED_PACKET_SHA256:
        raise AssertionError("sealed r64 packet hash mismatch")
    jobs = [audit("std"), audit("slimgb")]
    payload = {
        "status": "PASS_AFFINE_Q0_BOUNDED_NONVERDICTS_AUDITED",
        "prime": 89,
        "packet": str(PACKET),
        "packet_sha256": EXPECTED_PACKET_SHA256,
        "closed_linear_space": "L8=P<span(q4,...,q11)>",
        "open_complement": "D(H8), H8=(q0,q1,q2,q3,q12,...,q36)",
        "affine_cover_charts": H8_CHARTS,
        "number_of_charts": len(H8_CHARTS),
        "tested_chart": 0,
        "jobs": jobs,
        "theorem_status": "P25-UNDECIDED",
        "reason": (
            "Both exact q0=1 module standard-basis computations were resource-"
            "stopped before producing R^7. A stop is not a point and not an "
            "emptiness certificate; the other 28 H8 charts were not run."
        ),
    }
    output = HERE / "affine_chart_plan.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS_AFFINE_Q0_BOUNDED_NONVERDICTS_AUDITED")


if __name__ == "__main__":
    main()
