#!/usr/bin/env python3
"""Independent replay of the complete C_015 degree-eight invariant test."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess

import numpy as np

import degree8_invariant_linear_slice as producer
import degree9_fast_linear_sat as fast
import degree9_full_landing as landing


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
PYTHON = "/opt/homebrew/bin/python3"
CERTIFICATE = HERE / "degree8_invariant_linear_slice_certificate.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(path: Path, marker: str) -> None:
    process = subprocess.run(
        [PYTHON, "-u", str(path)], cwd=path.parent,
        text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        check=False,
    )
    assert process.returncode == 0, process.stdout
    assert marker in process.stdout, process.stdout
    print(process.stdout, end="")


def encode_form(form):
    return tuple(fast.encode(tuple(entry)) for entry in form)


def independent_sat_audit(stabilizer, expected):
    state = tuple()
    for raw_form in stabilizer["mandatory_forms"]:
        state = fast.extend(state, encode_form(raw_form))
    assert len(state) == stabilizer["mandatory_rank"] == 3
    clauses = [
        tuple(encode_form(factor) for factor in raw_clause)
        for raw_clause in stabilizer["clauses"]
    ]
    nodes = 0
    memo = set()
    terminals = set()

    def visit(current, remaining):
        nonlocal nodes
        nodes += 1
        unsatisfied = [
            index for index in remaining
            if not any(fast.in_span(factor, current) for factor in clauses[index])
        ]
        if not unsatisfied:
            terminals.add(current)
            return
        key = (current, tuple(unsatisfied))
        if key in memo:
            return
        selected = unsatisfied[0]
        remaining_next = tuple(
            index for index in unsatisfied if index != selected
        )
        extensions = {
            fast.extend(current, factor) for factor in clauses[selected]
        }
        for extension in sorted(extensions):
            visit(extension, remaining_next)
        memo.add(key)

    visit(state, tuple(range(len(clauses))))
    assert nodes == expected["nodes"] == 597
    assert len(memo) == expected["memoized_states"] == 341
    assert len(terminals) == expected["terminal_count"] == 1
    terminal = next(iter(terminals))
    assert len(terminal) == expected["terminal_rank"] == 8
    decoded = [
        [list(fast.decode(value)) for value in row] for row in terminal
    ]
    assert decoded == expected["terminal_rref"]


def main() -> None:
    frozen = json.loads(CERTIFICATE.read_text())
    for relative, expected in frozen["local_source_sha256"].items():
        assert sha256(HERE / relative) == expected, relative
    for relative, expected in frozen["external_source_sha256"].items():
        assert sha256(ROOT / relative) == expected, relative
    print("PASS frozen local and external source hashes")

    run(HERE / "verify_seal.py", "FULL_SCHUR_PALATINIAN_POINT_NEXT_STRICT_SEAL_OK")
    run(
        ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/"
        "verify_char0_palatinian_lift.py",
        "CHAR0_PALATINI_EQUALS_REYNOLDS_I4_LIFT_OK",
    )

    regenerated = producer.produce()
    assert regenerated == frozen
    dimension = frozen["invariant_dimension_certificate"]
    assert dimension["residues"] == [4, 4, 4]
    assert dimension["crt_dimension"] == 4
    stabilizer = frozen["stabilizer_constraints"]
    assert stabilizer["counts"] == {
        "nonzero_fourth_power": 12,
        "rank_0": 2120,
        "rank_1": 12,
        "rank_2": 1048,
        "split_binary_quartic": 1048,
    }
    assert stabilizer["clause_count"] == 131
    independent_sat_audit(stabilizer, frozen["linear_sat"])
    rows = np.asarray(frozen["residual_certificate"]["rows"], dtype=np.int64)
    assert rows.shape == (40, 35)
    assert landing.probe_core.fano.rank(rows) == 35
    assert frozen["residual_certificate"]["projective_emptiness"]
    assert frozen["special_fibre_projective_landing_locus_empty"]
    print("PASS independent 131-clause SAT and terminal 35/35 residual rank audit")
    print("FULL_SCHUR_C015_DEGREE8_INVARIANT_LINEAR_EXCLUSION_REPLAY_OK")
    print("SCOPE: complete common-degree-eight invariant coordinates only; no K_Schur point verdict")


if __name__ == "__main__":
    main()
