#!/usr/bin/env python3
"""Independent replay for the exact degree-25 landing-support decision.

This verifier does not import ``produce_msolve_input.py`` or ``run_msolve.py``.
It recomputes the preferred RREF from the raw 746 landing rows, regenerates
the canonical msolve input hash, and (by default) reruns msolve into separate
replay files.  It also invokes the repository's independent semantic, border,
and DVR verifiers.  Merely reading a stored Boolean is never accepted.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import os
import re
import signal
import subprocess
import sys
import time
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
EXACT = ROOT / "certificates" / "degree25_exact"
STANDARD_SOURCE = EXACT / "landing_cubics.npz"
SEMANTIC_ROWS = ROOT / "certificates" / "degree25_rowrank" / "landing_rows_unisolvent.npz"
ROW_VERIFY = ROOT / "certificates" / "degree25_rowrank" / "verify_rowrank.py"
BORDER_VERIFY = ROOT / "certificates" / "degree25_support_f4" / "verify_support.py"
DVR_VERIFY = ROOT / "certificates" / "degree25_direct_support" / "verify_dvr.py"
P = 89
N_ROWS = 746
N_COLS = 14190
VARIABLES = [f"q{i}" for i in range(37)] + [f"k{i}" for i in range(6)]

sys.path.insert(0, str(EXACT))
import common_p25x as common  # noqa: E402


class ProcTaskInfo(ctypes.Structure):
    _fields_ = [
        ("virtual_size", ctypes.c_uint64), ("resident_size", ctypes.c_uint64),
        ("total_user", ctypes.c_uint64), ("total_system", ctypes.c_uint64),
        ("threads_user", ctypes.c_uint64), ("threads_system", ctypes.c_uint64),
        ("policy", ctypes.c_int32), ("faults", ctypes.c_int32),
        ("pageins", ctypes.c_int32), ("cow_faults", ctypes.c_int32),
        ("messages_sent", ctypes.c_int32), ("messages_received", ctypes.c_int32),
        ("syscalls_mach", ctypes.c_int32), ("syscalls_unix", ctypes.c_int32),
        ("context_switches", ctypes.c_int32), ("thread_count", ctypes.c_int32),
        ("running_threads", ctypes.c_int32), ("priority", ctypes.c_int32),
    ]


LIBPROC = ctypes.CDLL("/usr/lib/libproc.dylib") if sys.platform == "darwin" else None
if LIBPROC is not None:
    LIBPROC.proc_pidinfo.argtypes = [
        ctypes.c_int, ctypes.c_int, ctypes.c_uint64, ctypes.c_void_p, ctypes.c_int
    ]
    LIBPROC.proc_pidinfo.restype = ctypes.c_int


def rss(pid: int) -> int:
    if LIBPROC is None:
        return 0
    info = ProcTaskInfo()
    returned = LIBPROC.proc_pidinfo(pid, 4, 0, ctypes.byref(info), ctypes.sizeof(info))
    return int(info.resident_size) if returned == ctypes.sizeof(info) else 0


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def standard_permutation() -> np.ndarray:
    return np.arange(N_COLS, dtype=np.int32)


def rref(matrix: np.ndarray) -> tuple[np.ndarray, list[int]]:
    """Exact left-to-right RREF over F_89, independently of the cache."""
    answer = np.asarray(matrix, dtype=np.int64).copy() % P
    pivots: list[int] = []
    row = 0
    for column in range(answer.shape[1]):
        candidates = np.flatnonzero(answer[row:, column] % P)
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        if pivot != row:
            answer[[row, pivot]] = answer[[pivot, row]]
        answer[row] = answer[row] * pow(int(answer[row, column]), -1, P) % P
        column_data = answer[:, column].copy()
        for other in np.flatnonzero(column_data % P):
            other = int(other)
            if other != row:
                answer[other] = (
                    answer[other] - int(column_data[other]) * answer[row]
                ) % P
        pivots.append(column)
        row += 1
        if row == answer.shape[0]:
            break
    return answer.astype(np.uint8), pivots


def monomial_string(exponents: tuple[int, ...]) -> str:
    names = [f"q{i}" for i in range(37)] + [f"k{i}" for i in range(6)]
    factors = []
    for exponent, name in zip(exponents, names):
        if exponent == 1:
            factors.append(name)
        elif exponent > 1:
            factors.append(f"{name}^{exponent}")
    return "*".join(factors) if factors else "1"


def canonical_input_sha(rows: np.ndarray, permutation: np.ndarray) -> str:
    """Re-emit the producer's canonical bytes without calling the producer."""
    monomials = common.cubic_monomials()
    ordered = [monomials[int(index)] for index in permutation]
    monomial_text = [monomial_string(exponents) for exponents in ordered]
    digest = hashlib.sha256()
    digest.update((",".join(VARIABLES) + f"\n{P}\n").encode())
    for row_index, row in enumerate(rows):
        terms = []
        for coefficient, monomial in zip(row, monomial_text):
            coefficient = int(coefficient) % P
            if coefficient:
                terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
        suffix = ",\n" if row_index + 1 < len(rows) else "\n"
        digest.update(("+".join(terms) + suffix).encode())
    return digest.hexdigest()


def pure_powers(path: Path) -> dict[str, int]:
    """Read only literal pure-power generators from an msolve leading ideal."""
    answer: dict[str, int] = {}
    for line in path.read_text(errors="replace").splitlines():
        token = line.strip().lstrip("[").rstrip(",]")
        match = re.fullmatch(r"(k\d+|q\d+)\^(\d+)", token)
        if match:
            answer[match.group(1)] = min(
                answer.get(match.group(1), int(match.group(2))), int(match.group(2))
            )
    return answer


def run_logged(command: list[str], log: Path) -> None:
    with log.open("w") as handle:
        completed = subprocess.run(command, text=True, stdout=handle, stderr=subprocess.STDOUT)
    if completed.returncode:
        raise RuntimeError(f"subcheck failed ({completed.returncode}): {' '.join(command)}")


def replay_upstream_checks() -> dict[str, str]:
    """Replay source semantics, Q/K border, and the proper DVR model."""
    # verify_rowrank.py writes beside itself.  Redirect that one write into this
    # packet so sealed historical directories remain untouched.
    redirected = HERE / "rowrank_replay_report.json"
    launcher = f"""
import pathlib, runpy
original = pathlib.Path.write_text
target = pathlib.Path({str(redirected)!r})
def patched(self, data, *args, **kwargs):
    if self.name == 'verify_report.json' and self.parent.name == 'degree25_rowrank':
        return original(target, data, *args, **kwargs)
    return original(self, data, *args, **kwargs)
pathlib.Path.write_text = patched
runpy.run_path({str(ROW_VERIFY)!r}, run_name='__main__')
"""
    print("[verify] replay original coefficient semantics and rank", flush=True)
    run_logged([sys.executable, "-c", launcher], HERE / "rowrank_replay.log")
    print("[verify] replay Q/K border", flush=True)
    run_logged([sys.executable, str(BORDER_VERIFY)], HERE / "border_replay.log")
    print("[verify] replay proper DVR model", flush=True)
    run_logged([sys.executable, str(DVR_VERIFY)], HERE / "dvr_replay.log")
    report = json.loads(redirected.read_text())
    if not report.get("ok") or int(report.get("recomputed_landing_rank", -1)) != N_ROWS:
        raise RuntimeError("independent coefficient-semantic/rank replay did not certify rank 746")
    return {
        "rowrank_log_sha256": sha256_file(HERE / "rowrank_replay.log"),
        "rowrank_report_sha256": sha256_file(redirected),
        "border_log_sha256": sha256_file(HERE / "border_replay.log"),
        "dvr_log_sha256": sha256_file(HERE / "dvr_replay.log"),
    }


def replay_solver(
    source: Path, timeout: int, rss_gib: float, threads: int, max_pairs: int
) -> tuple[Path, dict]:
    leading = HERE / "landing_746_replay_leading.out"
    log = HERE / "landing_746_replay_msolve.log"
    leading.write_text("")
    command = [
        "/opt/homebrew/bin/msolve", "-f", str(source), "-o", str(leading),
        "-t", str(threads), "-v", "2", "-g", "1", "-l", "2",
        "-q", "0", "-r", "0", "-s", "20", "-m", str(max_pairs),
        "--random-seed", "2026080189",
    ]
    started = time.monotonic()
    peak = 0
    stop_reason = None
    with log.open("w") as handle:
        process = subprocess.Popen(
            command, text=True, stdout=handle, stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        while process.poll() is None:
            peak = max(peak, rss(process.pid))
            if peak >= rss_gib * 1024**3:
                stop_reason = "memory"
                os.killpg(process.pid, signal.SIGKILL)
                break
            if time.monotonic() - started >= timeout:
                stop_reason = "timeout"
                os.killpg(process.pid, signal.SIGKILL)
                break
            time.sleep(0.2)
        returncode = process.wait()
    payload = {
        "command": command,
        "returncode": returncode,
        "stop_reason": stop_reason,
        "elapsed_seconds": time.monotonic() - started,
        "peak_rss_bytes": peak,
        "leading_sha256": sha256_file(leading),
        "log_sha256": sha256_file(log),
    }
    if returncode or stop_reason:
        raise RuntimeError(f"independent msolve replay incomplete: {payload}")
    return leading, payload


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--no-replay-solver", action="store_true")
    parser.add_argument("--no-upstream-checks", action="store_true")
    parser.add_argument("--timeout", type=int, default=43200)
    parser.add_argument("--rss-gib", type=float, default=64.0)
    parser.add_argument("--threads", type=int, default=4)
    parser.add_argument("--max-pairs", type=int, default=512)
    args = parser.parse_args()
    started = time.time()

    print("[verify] rebuild standard RREF from the sealed 746-row span", flush=True)
    with np.load(STANDARD_SOURCE) as frozen:
        raw = frozen["p89"].astype(np.int64) % P
    if raw.shape != (N_ROWS, N_COLS):
        raise RuntimeError(f"wrong raw shape {raw.shape}")
    with np.load(SEMANTIC_ROWS) as frozen:
        semantic = frozen["echelon"].astype(np.int64) % P
        if int(frozen["prime"]) != P or int(frozen["rank"]) != N_ROWS:
            raise RuntimeError("semantic landing-row seal has wrong prime/rank")
    if not np.array_equal(raw, semantic):
        raise RuntimeError("standard system differs from the semantic landing-row seal")
    permutation = standard_permutation()
    recomputed, pivots = rref(raw[:, permutation])
    if pivots != list(range(N_ROWS)):
        raise RuntimeError(f"wrong standard pivot profile: {pivots[:10]}...{pivots[-10:]}")
    if not np.array_equal(raw.astype(np.uint8), recomputed):
        raise RuntimeError("sealed standard rows are not their claimed exact RREF")

    print("[verify] regenerate canonical msolve input hash", flush=True)
    source = HERE / "landing_746_standard.ms"
    rebuilt_input_sha = canonical_input_sha(recomputed, permutation)
    if rebuilt_input_sha != sha256_file(source):
        raise RuntimeError("canonical input is not the independently rebuilt 746-row system")

    upstream = {} if args.no_upstream_checks else replay_upstream_checks()
    if args.no_replay_solver:
        print("[verify] audit stored exact leading ideal", flush=True)
        leading = HERE / "landing_746_standard_leading.out"
        solver = {"mode": "stored-output-audit", "leading_sha256": sha256_file(leading)}
    else:
        print("[verify] rerun exact msolve leading-ideal computation", flush=True)
        leading, solver = replay_solver(
            source, args.timeout, args.rss_gib, args.threads, args.max_pairs
        )
        solver["mode"] = "independent-exact-replay"

    text = leading.read_text(errors="replace")
    if "#field characteristic: 89" not in text:
        raise RuntimeError("leading output does not declare characteristic 89")
    powers = pure_powers(leading)
    missing = [variable for variable in VARIABLES if variable not in powers]
    if missing:
        raise RuntimeError(f"leading ideal lacks pure powers for {missing}")

    payload = {
        "verdict": "PASS",
        "exit": "P25-DEGREE25-EMPTY",
        "prime": P,
        "raw_rows_sha256": sha256_array(raw.astype(np.uint8)),
        "recomputed_rref_sha256": sha256_array(recomputed),
        "recomputed_rank": len(pivots),
        "pivot_profile": {"standard_columns": [0, 745]},
        "canonical_input_sha256": rebuilt_input_sha,
        "solver": solver,
        "pure_power_variables": powers,
        "all_43_pure_powers": True,
        "projective_special_fibre_empty": True,
        "upstream_replays": upstream,
        "logical_implication": (
            "The initial ideal contains a pure power of every homogeneous "
            "coordinate, so its radical contains the irrelevant ideal. "
            "Therefore Proj of the complete landing ideal over F_89 is empty."
        ),
        "elapsed_seconds": time.time() - started,
    }
    (HERE / "verify_result.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(payload, indent=2, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
