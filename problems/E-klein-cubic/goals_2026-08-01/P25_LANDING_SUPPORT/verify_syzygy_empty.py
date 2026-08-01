#!/usr/bin/env python3
"""Independent exact verifier for the syzygy-incidence emptiness route.

The verifier starts from the sealed 690-row lower-presentation matrix.  It
checks the saved linear left syzygies coefficient by coefficient, reconstructs
their contractions, and compares them with the two exact Singular inputs.  By
default it then reruns both irrelevant saturations in fresh replay files.

The logical cover is exhaustive:

* ``b0=b1=0`` is the independently replayed Stage-A certificate;
* ``b0=0,b1!=0`` is the double (q,b1)-irrelevant saturation;
* ``b0!=0`` is normalized to ``b0=1`` and uses the q-irrelevant saturation.

All arithmetic before the CAS replay is exact over F_89.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FM = ROOT / "certificates" / "degree25_finite_module"
P25W = ROOT / "certificates" / "degree25_p25w"
ROW_VERIFY = ROOT / "certificates" / "degree25_rowrank" / "verify_rowrank.py"
BORDER_VERIFY = ROOT / "certificates" / "degree25_support_f4" / "verify_support.py"
DVR_VERIFY = ROOT / "certificates" / "degree25_direct_support" / "verify_dvr.py"
RELATION = FM / "relation_matrix.npz"
RECONSTRUCTED_SYZYGIES = HERE / "linear_syzygies_r48_reconstructed.npz"
RECONSTRUCT = HERE / "reconstruct_syzygies96.py"
CONTRACTED = HERE / "syzygy_r48_q0_contracted.npz"
RUN_SINGULAR = HERE / "run_singular.py"
P = 89
NQ = 37
NB1 = 6
NROWS = 48


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    answer = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, index] = target_index[tuple(exponent)]
    return answer


def direct_syzygy_check(syzygy: np.ndarray, m2: np.ndarray) -> bool:
    """Check C(q) M2(q)=0 after symmetrizing its two q indices."""
    raw = np.einsum(
        "au,ajv->ujv", syzygy.astype(np.int64), m2.astype(np.int64),
        optimize=True,
    ) % P
    for u in range(NQ):
        if np.any(raw[u, :, u] % P):
            return False
        for v in range(u + 1, NQ):
            if np.any((raw[u, :, v] + raw[v, :, u]) % P):
                return False
    return True


def contract(
    syzygy: np.ndarray,
    block: np.ndarray,
    product_map: np.ndarray,
    target_size: int,
) -> np.ndarray:
    output = np.zeros(target_size, dtype=np.int64)
    block64 = block.astype(np.int64)
    for variable in range(NQ):
        coefficients = (syzygy[:, variable].astype(np.int64) @ block64) % P
        np.add.at(output, product_map[variable], coefficients)
    return (output % P).astype(np.uint8)


def polynomial_string(
    coefficients: np.ndarray, monomials: list[tuple[int, ...]]
) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        factors = []
        for variable, power in enumerate(exponent):
            if power:
                factors.append(
                    f"q_{variable}" if power == 1 else f"q_{variable}^{power}"
                )
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def write_singular(
    target: Path,
    result: Path,
    p3: np.ndarray,
    p4: np.ndarray,
    stratum: str,
) -> None:
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    variables = [f"b1_{j}" for j in range(NB1)] + [f"q_{j}" for j in range(NQ)]
    with target.open("w") as handle:
        handle.write('LIB "elim.lib";\n')
        handle.write(f"ring R={P},({','.join(variables)}),dp;\n")
        handle.write("option(prot);\n")
        handle.write("ideal qideal=" + ",".join(f"q_{j}" for j in range(NQ)) + ";\n")
        handle.write("ideal bideal=" + ",".join(f"b1_{j}" for j in range(NB1)) + ";\n")
        handle.write("ideal I=\n")
        for row in range(NROWS):
            terms: list[str] = []
            if stratum == "b0":
                terms.append(polynomial_string(p4[row], q4))
            for j in range(NB1):
                terms.append(f"({polynomial_string(p3[row, j], q3)})*b1_{j}")
            handle.write("+".join(terms))
            handle.write(",\n" if row + 1 < NROWS else ";\n")
        if stratum == "boundary":
            # Sequential saturation by bideal then qideal equals saturation by
            # their product; this order removes the manifest b1=0 component
            # before the larger q computation.
            handle.write("ideal Jb=sat(I,bideal);\n")
            handle.write("ideal J=sat(Jb,qideal);\n")
        elif stratum == "b0":
            handle.write("ideal J=sat(I,qideal);\n")
        else:
            raise ValueError(stratum)
        handle.write("int is_unit=(reduce(1,J)==0);\n")
        handle.write('print("sat unit="+string(is_unit)+" ngens="+string(size(J)));\n')
        handle.write(
            f'write(":w {result}","unit="+string(is_unit)'
            '+",saturated_generators="+string(size(J)));\n'
        )
        handle.write("quit;\n")


def run_logged(command: list[str], log: Path) -> None:
    with log.open("w") as handle:
        completed = subprocess.run(
            command, text=True, stdout=handle, stderr=subprocess.STDOUT
        )
    if completed.returncode:
        raise RuntimeError(
            f"subcheck failed ({completed.returncode}): {' '.join(command)}"
        )


def replay_python_verifier(source: Path, log: Path, redirected: Path) -> None:
    """Run an upstream verifier while redirecting its report write."""
    launcher = f"""
import pathlib, runpy
original = pathlib.Path.write_text
target = pathlib.Path({str(redirected)!r})
def patched(self, data, *args, **kwargs):
    if self.suffix == '.json':
        return original(target, data, *args, **kwargs)
    return original(self, data, *args, **kwargs)
pathlib.Path.write_text = patched
runpy.run_path({str(source)!r}, run_name='__main__')
"""
    run_logged([sys.executable, "-c", launcher], log)


def replay_upstream() -> dict[str, str]:
    replay_python_verifier(
        P25W / "verify_stageA.py",
        HERE / "stageA_replay.log",
        HERE / "stageA_replay_result.json",
    )
    replay_python_verifier(
        ROW_VERIFY,
        HERE / "rowrank_replay.log",
        HERE / "rowrank_replay_report.json",
    )
    run_logged([sys.executable, str(BORDER_VERIFY)], HERE / "border_replay.log")
    run_logged([sys.executable, str(DVR_VERIFY)], HERE / "dvr_replay.log")
    return {
        name: sha256_file(HERE / name)
        for name in (
            "stageA_replay.log",
            "stageA_replay_result.json",
            "rowrank_replay.log",
            "rowrank_replay_report.json",
            "border_replay.log",
            "dvr_replay.log",
        )
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--equations-only", action="store_true")
    parser.add_argument("--no-upstream-checks", action="store_true")
    parser.add_argument("--cas-timeout", type=int, default=43200)
    parser.add_argument("--cas-rss-gib", type=float, default=64.0)
    args = parser.parse_args()
    started = time.monotonic()

    with np.load(RELATION) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise RuntimeError("sealed relation matrix has the wrong prime")
    if seeds.shape != (690, 14134):
        raise RuntimeError(f"sealed relation matrix has shape {seeds.shape}")

    print("[verify] reconstruct overwritten deterministic syzygy selection", flush=True)
    run_logged(
        [sys.executable, str(RECONSTRUCT)], HERE / "syzygy_reconstruction_replay.log"
    )
    with np.load(RECONSTRUCTED_SYZYGIES) as frozen:
        syzygies = frozen["syzygies"].astype(np.uint8)
        reconstructed_chosen = frozen["chosen_syzygies"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise RuntimeError("reconstructed syzygy artifact has the wrong prime")
    with np.load(CONTRACTED) as frozen:
        stored_p4 = frozen["p4"].astype(np.uint8)
        stored_p3 = frozen["p3"].astype(np.uint8)
        chosen = frozen["chosen_syzygies"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise RuntimeError("contraction artifact has the wrong prime")
    if len(chosen) != NROWS or len(set(chosen.tolist())) != NROWS:
        raise RuntimeError("the 48 contracted syzygies are not distinct")
    if not np.array_equal(chosen, reconstructed_chosen):
        raise RuntimeError("reconstructed selection differs from contraction metadata")
    if syzygies.shape != (NROWS, 690, NQ):
        raise RuntimeError(f"reconstructed syzygies have shape {syzygies.shape}")

    linear = weak_compositions(1, NQ)
    variable_of = [monomial.index(1) for monomial in linear]
    m2 = np.empty((690, 21, NQ), dtype=np.uint8)
    for j in range(21):
        block = seeds[:, int(offsets[7 + j]):int(offsets[8 + j])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, j, variable] = block[:, monomial_index]
    for index, syzygy in enumerate(syzygies):
        if not direct_syzygy_check(syzygy, m2):
            raise RuntimeError(f"contracted syzygy {index} does not annihilate M2")
    print("[verify] all 48 C(q)M2(q) contractions vanish exactly", flush=True)

    q2 = weak_compositions(2, NQ)
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    map_2_to_3 = multiplication_map(q2, q3)
    map_3_to_4 = multiplication_map(q3, q4)
    b0_block = seeds[:, int(offsets[0]):int(offsets[1])]
    b1_blocks = [
        seeds[:, int(offsets[1 + j]):int(offsets[2 + j])] for j in range(NB1)
    ]
    p4 = np.empty_like(stored_p4)
    p3 = np.empty_like(stored_p3)
    for row, syzygy in enumerate(syzygies):
        p4[row] = contract(syzygy, b0_block, map_3_to_4, len(q4))
        for j, block in enumerate(b1_blocks):
            p3[row, j] = contract(syzygy, block, map_2_to_3, len(q3))
    if not np.array_equal(p4, stored_p4) or not np.array_equal(p3, stored_p3):
        raise RuntimeError("stored contracted equations do not rebuild from seed_F3")
    print("[verify] rebuilt all P4 and P3 contracted coefficients", flush=True)

    upstream = {} if args.no_upstream_checks else replay_upstream()
    if args.equations_only:
        print("PASS: contraction equations only; no emptiness verdict requested")
        return

    cas: dict[str, dict[str, str]] = {}
    for stratum in ("boundary", "b0"):
        script = HERE / f"syzygy_r48_{stratum}_replay.sing"
        result = HERE / f"syzygy_r48_{stratum}_replay_result.txt"
        stem = f"syzygy_r48_{stratum}_replay_run"
        log = HERE / f"{stem}.log"
        report = HERE / f"{stem}.json"
        driver_log = HERE / f"{stem}_driver.log"
        result.unlink(missing_ok=True)
        write_singular(script, result, p3, p4, stratum)
        print(f"[verify] exact Singular replay: {stratum}", flush=True)
        run_logged(
            [
                sys.executable,
                str(RUN_SINGULAR),
                script.name,
                result.name,
                "--stem",
                stem,
                "--timeout",
                str(args.cas_timeout),
                "--rss-gib",
                str(args.cas_rss_gib),
            ],
            driver_log,
        )
        run_report = json.loads(report.read_text())
        if not run_report.get("complete") or not run_report.get("saturated_unit_ideal"):
            raise RuntimeError(f"{stratum} irrelevant saturation is not the unit ideal")
        cas[stratum] = {
            "script_sha256": sha256_file(script),
            "result_sha256": sha256_file(result),
            "log_sha256": sha256_file(log),
            "runner_report_sha256": sha256_file(report),
            "driver_log_sha256": sha256_file(driver_log),
        }

    payload = {
        "verdict": "PASS",
        "exit": "P25-DEGREE25-EMPTY",
        "prime": P,
        "relation_matrix_sha256": sha256_file(RELATION),
        "seed_F3_sha256": sha256_array(seeds),
        "reconstructed_syzygies_sha256": sha256_file(RECONSTRUCTED_SYZYGIES),
        "syzygy_reconstruction_log_sha256": sha256_file(
            HERE / "syzygy_reconstruction_replay.log"
        ),
        "contracted_sha256": sha256_file(CONTRACTED),
        "verified_syzygies": NROWS,
        "stage_cover": [
            "b0=b1=0: upstream Stage-A exact rank-one certificate",
            "b0=0,b1!=0: (q,b1)-irrelevant saturated unit ideal",
            "b0!=0: normalize b0=1; q-irrelevant saturated unit ideal",
        ],
        "cas_replays": cas,
        "upstream_replays": upstream,
        "special_fibre_empty": True,
        "generic_degree25_empty_by_proper_dvr_transfer": True,
        "headline_problem_e_remains_open": True,
        "elapsed_seconds": time.monotonic() - started,
    }
    (HERE / "verify_syzygy_empty_result.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("PASS: P25-DEGREE25-EMPTY", flush=True)


if __name__ == "__main__":
    main()
