#!/usr/bin/env python3
"""Build unlaunched r43/r64 augmented [P4|P3] module jobs.

For every selected linear syzygy C(q) of the M2 block, contraction of the
690-row lower presentation gives

    P4(q) b0 + sum_{j=0}^5 P3_j(q) b1_j = 0.

Regard the row [P4|P3_0|...|P3_5] as a generator of a submodule N of S^7.
If dim(S^7/N)=0, this 7-column matrix has rank seven at every projective q,
simultaneously excluding the b0=0,b1!=0 and b0!=0 strata.  The already sealed
Stage A handles b0=b1=0.  A nonzero dimension or an interrupted computation
is not a verdict.

This producer reuses the exact support-balanced r43 packet and constructs a
modestly overdetermined r64 packet by extending it with rows which increase
the rank of every P3 component.  It writes Singular inputs but never launches
Singular.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path
import time

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
GB = HERE.parent / "stageb_global_basis"
FM = ROOT / "certificates" / "degree25_finite_module"
RELATION = FM / "relation_matrix.npz"
FULL_BASIS = GB / "full_linear_syzygy_basis.npy"
FULL_P3 = GB / "full_p3_contractions.npy"
P3_STATS = GB / "full_p3_statistics.npz"
R43_SOURCE = GB / "support_balanced_r43_stageBC.npz"
BOUNDED_RUNNER = HERE.parent / "stageb_cas" / "run_bounded.py"
P = 89
NQ = 37
NSEED = 690


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
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


def rank_fflas(matrix: np.ndarray) -> int:
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.Rank_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rows, columns = dense.shape
    return int(function(float(P), rows, columns, dense, columns, False))


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


def contract_p4(
    syzygies: np.ndarray,
    b0_block: np.ndarray,
    product_map: np.ndarray,
    target_dimension: int,
) -> np.ndarray:
    output = np.zeros((len(syzygies), target_dimension), dtype=np.uint8)
    block_double = np.asarray(b0_block, dtype=np.float64)
    for variable in range(NQ):
        product = (
            np.ascontiguousarray(syzygies[:, :, variable], dtype=np.float64)
            @ block_double
        )
        np.remainder(product, float(P), out=product)
        addition = product.astype(np.uint8)
        indices = product_map[variable]
        updated = output[:, indices].astype(np.uint16)
        updated += addition
        np.remainder(updated, P, out=updated)
        output[:, indices] = updated.astype(np.uint8)
    return output


def polynomial_string(
    coefficients: np.ndarray, monomials: list[tuple[int, ...]]
) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        factors: list[str] = []
        for variable, power in enumerate(exponent):
            if power:
                name = f"q{variable}"
                factors.append(name if power == 1 else f"{name}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def extend_to_r64(
    base_columns: np.ndarray,
    full_p3: np.ndarray,
    costs: np.ndarray,
) -> tuple[np.ndarray, list[list[int]]]:
    selected = [int(value) for value in base_columns]
    selected_set = set(selected)
    ledger: list[list[int]] = []
    for candidate_raw in np.argsort(costs, kind="stable"):
        if len(selected) == 64:
            break
        candidate = int(candidate_raw)
        if candidate in selected_set:
            continue
        trial = selected + [candidate]
        ranks = [
            rank_fflas(np.asarray(full_p3[trial, component, :], dtype=np.uint8))
            for component in range(6)
        ]
        if ranks == [len(trial)] * 6:
            selected.append(candidate)
            selected_set.add(candidate)
            ledger.append([candidate, int(costs[candidate])])
    if len(selected) != 64:
        raise AssertionError(f"component-balanced extension stopped at {len(selected)}")
    return np.asarray(selected, dtype=np.int32), ledger


def write_module_script(
    path: Path,
    result_path: Path,
    p4: np.ndarray,
    p3: np.ndarray,
    q3: list[tuple[int, ...]],
    q4: list[tuple[int, ...]],
) -> None:
    q_variables = [f"q{i}" for i in range(NQ)]
    with path.open("w") as handle:
        handle.write(f"ring R={P},({','.join(q_variables)}),(dp,C);\n")
        handle.write("option(prot);\n")
        handle.write("module N=\n")
        for row in range(len(p4)):
            entries = [polynomial_string(p4[row], q4)] + [
                polynomial_string(p3[row, component], q3)
                for component in range(6)
            ]
            handle.write("[" + ",".join(entries) + "]")
            handle.write(",\n" if row + 1 < len(p4) else ";\n")
        handle.write('print("input module gens="+string(size(N)));\n')
        handle.write("timer=1; module G=std(N); int elapsed=timer;\n")
        handle.write("int d=dim(G); int decisive=(d==0);\n")
        handle.write(
            'print("std gens="+string(size(G))+" dim="+string(d)'
            '+" elapsed_ms="+string(elapsed));\n'
        )
        handle.write(
            f'write(":w {result_path}","decisive="+string(decisive)'
            '+",dim="+string(d)+",std_gens="+string(size(G))'
            '+",elapsed_ms="+string(elapsed));\n'
        )
        handle.write("quit;\n")


def main() -> None:
    started = time.monotonic()
    for required in (
        RELATION,
        FULL_BASIS,
        FULL_P3,
        P3_STATS,
        R43_SOURCE,
        BOUNDED_RUNNER,
    ):
        if not required.is_file():
            raise FileNotFoundError(required)
    full_basis = np.load(FULL_BASIS, mmap_mode="r")
    full_p3 = np.load(FULL_P3, mmap_mode="r")
    with np.load(P3_STATS, allow_pickle=False) as frozen:
        p3_costs = frozen["p3_nnz"].astype(np.int32)
    with np.load(R43_SOURCE, allow_pickle=False) as frozen:
        r43_p4 = frozen["p4"].astype(np.uint8)
        r43_p3 = frozen["p3"].astype(np.uint8)
        r43_syzygies = frozen["syzygies"].astype(np.uint8)
        r43_columns = frozen["full_basis_columns"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("r43 packet prime mismatch")
    if r43_p4.shape != (43, 91390) or r43_p3.shape != (43, 6, 9139):
        raise AssertionError("unexpected r43 contraction shape")

    r64_columns, extension_ledger = extend_to_r64(r43_columns, full_p3, p3_costs)
    r64_p3 = np.asarray(full_p3[r64_columns], dtype=np.uint8)
    r64_syzygies = np.asarray(full_basis[r64_columns], dtype=np.uint8)
    component_ranks = [rank_fflas(r64_p3[:, component, :]) for component in range(6)]
    augmented_p3_rank = rank_fflas(r64_p3.reshape(64, -1))
    if component_ranks != [64] * 6 or augmented_p3_rank != 64:
        raise AssertionError("r64 P3 exact rank guard failed")

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    product_map = multiplication_map(q3, q4)
    b0_block = seeds[:, int(offsets[0]) : int(offsets[1])]
    r64_p4 = contract_p4(r64_syzygies, b0_block, product_map, len(q4))
    if r64_p4.shape != (64, 91390) or np.any(~np.any(r64_p4, axis=1)):
        raise AssertionError("r64 P4 contraction failed")

    r64_packet = HERE / "support_balanced_r64_stageBC.npz"
    np.savez_compressed(
        r64_packet,
        p4=r64_p4,
        p3=r64_p3,
        syzygies=r64_syzygies,
        full_basis_columns=r64_columns,
        p4_term_counts=np.count_nonzero(r64_p4, axis=1).astype(np.int32),
        p3_term_counts=np.count_nonzero(r64_p3, axis=(1, 2)).astype(np.int32),
        prime=np.int32(P),
        full_basis_sha256=np.asarray(sha256_file(FULL_BASIS)),
        full_p3_sha256=np.asarray(sha256_file(FULL_P3)),
        relation_matrix_sha256=np.asarray(sha256_file(RELATION)),
        r43_source_sha256=np.asarray(sha256_file(R43_SOURCE)),
    )

    jobs: dict[str, dict] = {}
    for label, p4, p3, packet in (
        ("r43", r43_p4, r43_p3, R43_SOURCE),
        ("r64", r64_p4, r64_p3, r64_packet),
    ):
        script = HERE / f"augmented_{label}_p4_p3_module.sing"
        result_path = HERE / f"augmented_{label}_p4_p3_module_result.txt"
        write_module_script(script, result_path, p4, p3, q3, q4)
        jobs[label] = {
            "rows": int(len(p4)),
            "packet": str(packet),
            "packet_sha256": sha256_file(packet),
            "p4_shape": list(p4.shape),
            "p3_shape": list(p3.shape),
            "p4_terms": int(np.count_nonzero(p4)),
            "p3_terms": int(np.count_nonzero(p3)),
            "script": script.name,
            "script_sha256": sha256_file(script),
            "script_bytes": script.stat().st_size,
            "result": result_path.name,
            "criterion": "dim(S^7/N)=0",
            "suggested_command_not_run": (
                f"/opt/homebrew/bin/python3 {BOUNDED_RUNNER} {script} "
                "--timeout 7200 --rss-gib 32"
            ),
        }

    r64_metadata = {
        "status": "PASS_SUPPORT_BALANCED_R64_PREPARED",
        "prime": P,
        "rows": 64,
        "extends_r43": True,
        "r43_columns": r43_columns.astype(int).tolist(),
        "extension_ledger_column_and_p3_cost": extension_ledger,
        "selected_full_basis_columns": r64_columns.astype(int).tolist(),
        "p3_component_ranks": component_ranks,
        "p3_augmented_row_rank": augmented_p3_rank,
        "p3_terms": int(np.count_nonzero(r64_p3)),
        "p4_terms": int(np.count_nonzero(r64_p4)),
        "packet": r64_packet.name,
        "packet_sha256": sha256_file(r64_packet),
        "source_hashes": {
            "full_basis": sha256_file(FULL_BASIS),
            "full_p3": sha256_file(FULL_P3),
            "relation_matrix": sha256_file(RELATION),
            "r43_source": sha256_file(R43_SOURCE),
        },
    }
    (HERE / "support_balanced_r64_stageBC.json").write_text(
        json.dumps(r64_metadata, indent=2, sort_keys=True) + "\n"
    )

    payload = {
        "status": "PASS_AUGMENTED_MODULE_JOBS_PREPARED",
        "prime": P,
        "module": "N generated by rows [P4|P3_0|...|P3_5] inside S^7",
        "jobs": jobs,
        "r64_selection": r64_metadata,
        "exact_implication_if_decisive": (
            "If either exact job returns dim(S^7/N)=0, the contraction matrix has "
            "rank seven at every nonzero q over the algebraic closure. Thus no "
            "lower-presentation kernel vector can have (b0,b1) nonzero: Stage B "
            "(b0=0,b1!=0) and Stage C (b0!=0) are both empty. Together with the "
            "sealed Stage-A exclusion of b0=b1=0, the lower incidence is empty; "
            "hence the complete 746-row special landing scheme is empty and the "
            "sealed DVR argument yields only the scoped characteristic-zero "
            "degree-25 exclusion."
        ),
        "nonverdict_cases": (
            "Positive module dimension, timeout, crash, or missing output does not "
            "produce a point and does not decide any original stratum."
        ),
        "not_run": True,
        "no_singular_launched": True,
        "pid_13036_left_untouched": True,
        "elapsed_seconds": round(time.monotonic() - started, 6),
    }
    output = HERE / "augmented_module_jobs.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
