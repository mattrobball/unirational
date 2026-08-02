#!/usr/bin/env python3
"""Bind prepared future job variants and the conservative resource forecast."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "job_plan.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    stem = "r66_stageC_q0_1_b0_1"
    manifest = json.loads((HERE / f"{stem}.json").read_text())
    common = "/opt/homebrew/bin/python3 P25_LANDING_SUPPORT/parallel/r66_stagec/run_guarded.py"
    jobs = [
        {
            "name": "msolve_paircap100_preferred",
            "command_not_run": f"{common} --engine msolve --tag paircap100 --pair-cap 100 --threads 4 --timeout 43200 --rss-gib 16 --execute",
            "algorithm": "exact ordinary F4 with at most 100 pairs selected per matrix",
            "note": "-m 100 splits F4 matrices; it is not a resumable decomposition and has no force unless the full job completes with a unit sentinel.",
        },
        {
            "name": "msolve_ordinary_all_pairs",
            "command_not_run": f"{common} --engine msolve --tag ordinary --pair-cap 0 --threads 4 --timeout 43200 --rss-gib 32 --execute",
            "algorithm": "exact ordinary F4, unlimited pairs per matrix",
            "note": "Do not run concurrently with another large CAS job.",
        },
        {
            "name": "singular_std",
            "command_not_run": f"{common} --engine singular --tag std --threads 1 --timeout 43200 --rss-gib 32 --execute",
            "algorithm": "Singular exact std in characteristic 89, degree-reverse-lex order",
            "note": "Do not run concurrently with another large CAS job.",
        },
    ]
    payload = {
        "status": "PREPARED_NOT_RUN",
        "cas_launched": False,
        "input_manifest": f"{stem}.json",
        "input_manifest_sha256": sha256(HERE / f"{stem}.json"),
        "msolve_input_sha256": manifest["inputs"]["msolve"]["sha256"],
        "singular_input_sha256": manifest["inputs"]["singular"]["sha256"],
        "runner": "run_guarded.py",
        "runner_sha256": sha256(HERE / "run_guarded.py"),
        "jobs": jobs,
        "resource_forecast": {
            "observed_neighbor": (
                "The simpler r66 Stage-B q0=1,b1_0=1 job (41 variables, "
                "2,363,052 terms) reached 4.2753 GiB RSS during its incomplete "
                "all-pairs degree-six round after 548.96 seconds."
            ),
            "this_job": (
                "Stage C has 42 variables and 6,809,430 terms (2.881 times the "
                "neighbor's term count), including 4,446,378 added P4 terms. "
                "It must not be assumed to fit below the neighbor's peak."
            ),
            "current_gate": (
                "Do not launch with only about 5.85 GiB free+speculative memory "
                "or while the main Singular process is active."
            ),
            "recommended_sequence": (
                "After contention ends, try pair-cap 100 alone with at least "
                "20 GiB genuinely available and the 16-GiB fail-closed fence. "
                "Treat a fence stop as a nonverdict. Reserve ordinary msolve or "
                "Singular for a window with at least 40 GiB available and a "
                "32-GiB fence. These are scheduling estimates, not completion guarantees."
            ),
        },
        "decision_rule": (
            "Only a return-code-zero, non-resource-stopped, exact unit sentinel "
            "proves this one chart empty. Every other outcome is a nonverdict."
        ),
    }
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if OUTPUT.exists() and OUTPUT.read_text() != text:
        raise SystemExit(f"refusing to overwrite mismatching {OUTPUT}")
    if not OUTPUT.exists():
        OUTPUT.write_text(text)
    print("PREPARED_NOT_RUN")


if __name__ == "__main__":
    main()

