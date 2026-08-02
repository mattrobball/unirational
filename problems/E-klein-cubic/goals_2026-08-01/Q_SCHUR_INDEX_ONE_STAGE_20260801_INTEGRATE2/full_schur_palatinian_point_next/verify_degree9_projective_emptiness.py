#!/usr/bin/env python3
"""Independent replay of the full degree-nine projective-emptiness proof."""
from __future__ import annotations

import hashlib
import importlib.util
import json
from math import comb
import os
from pathlib import Path
import runpy
import subprocess
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
PYTHON = "/opt/homebrew/bin/python3"
CERTIFICATE = HERE / "degree9_projective_emptiness_certificate.json"


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def semantic_sha256(path, ignored=()):
    payload = json.loads(path.read_text())
    for key in ignored:
        payload.pop(key, None)
    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def load(name, path):
    specification = importlib.util.spec_from_file_location(name, path)
    assert specification and specification.loader
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


def run_script(path, marker, environment=None):
    merged = os.environ.copy()
    if environment:
        merged.update(environment)
    process = subprocess.run(
        [PYTHON, "-u", str(path)], cwd=path.parent, env=merged,
        text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False,
    )
    assert process.returncode == 0, process.stdout
    assert marker in process.stdout, process.stdout
    print(process.stdout, end="")


def main():
    certificate = json.loads(CERTIFICATE.read_text())
    for relative, expected in certificate["local_source_sha256"].items():
        actual = sha256(HERE / relative)
        assert actual == expected, (relative, actual, expected)
    for relative, expected in certificate["external_source_sha256"].items():
        actual = sha256(ROOT / relative)
        assert actual == expected, (relative, actual, expected)
    print("PASS frozen local and external source hashes")

    exact = runpy.run_path(str(ROOT / "tmp/pfaffian_representation_alignment/core.py"))
    fano = load("degree9_verify_fano", ROOT / "tmp/fano14_twist/fano_covariant_scan.py")
    exact_generators = exact["schur_generators"]()
    reduced = tuple(
        np.asarray(
            [[exact["reduce_k11"](entry, 2, 23) for entry in row]
             for row in generator.to_list()], dtype=np.int64,
        ) % 23
        for generator in exact_generators
    )
    modular = fano.six_dimensional_generators()
    assert all(np.array_equal(left, right) for left, right in zip(reduced, modular))
    assert len(fano.generate_group(modular)) == 1320
    assert pow(5, 11, 23) == 22
    print("PASS exact Schur action reduction and F_529 field polynomial")

    molien = load(
        "degree9_verify_molien",
        ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/schur_self_molien.py",
    )
    primes = [23, 67, 89]
    residues = [molien.scan(prime, 9)[1][9] for prime in primes]
    multiplicity, modulus = molien.chars.crt(residues, primes)
    upper = 6 * comb(14, 5)
    assert modulus > upper and multiplicity == 19
    probe_source = (
        ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/"
        "probe_self_covariants_palatinian.py"
    )
    probe_module = load("degree9_verify_probe", probe_source)
    basis = probe_module.Probe().basis(9, 19)
    assert len(basis) == multiplicity
    print(
        f"PASS exact characteristic-zero degree-nine self-covariant dimension "
        f"19 residues={residues} modulus={modulus} and good-fibre Reynolds basis"
    )

    installed = ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian"
    run_script(
        installed / "verify_palatinian_equation.py",
        "PALATINI_REYNOLDS_I4_IDENTITY_OK",
    )
    run_script(
        installed / "verify_char0_palatinian_lift.py",
        "CHAR0_PALATINI_EQUALS_REYNOLDS_I4_LIFT_OK",
    )

    run_script(
        HERE / "eigenline_rank_one_probe.py",
        "SCOPE exact F_529 eigenline probe",
    )
    eigenline_info = certificate["artifacts"]["degree9_rank_one_eigenlines_f529.json"]
    assert sha256(HERE / "degree9_rank_one_eigenlines_f529.json") == eigenline_info["sha256"]
    print("PASS exact eigenline seed reconstruction")

    run_script(
        HERE / "degree9_binary_factor_sat_exhaustive.py",
        "CACHE_ONLY_OK",
        {"DEGREE9_CACHE_ONLY": "1"},
    )
    clause_info = certificate["artifacts"]["degree9_binary_clauses_f529.json"]
    assert sha256(HERE / "degree9_binary_clauses_f529.json") == clause_info["sha256"]
    cache = json.loads((HERE / "degree9_binary_clauses_f529.json").read_text())
    assert len(cache["mandatory_forms"]) == clause_info["mandatory_rank"] == 8
    assert len(cache["clauses"]) == clause_info["clause_count"] == 395
    assert all(check["covers_complete_type"] for check in cache["conjugacy_checks"])
    print(
        "PASS all 3180 stabilizer lines, nonzero rank-one endpoints, "
        "binary factorizations, and complete conjugacy-type coverage"
    )

    run_script(
        HERE / "degree9_fast_linear_sat.py",
        "FULL_DEGREE9_PROJECTIVE_EMPTINESS_FAST_LINEAR_SAT_OK",
    )
    result_info = certificate["artifacts"]["degree9_fast_linear_sat_f529.json"]
    actual_semantic = semantic_sha256(
        HERE / "degree9_fast_linear_sat_f529.json", ("elapsed_seconds",)
    )
    assert actual_semantic == result_info["semantic_sha256_ignoring_elapsed_seconds"]
    result = json.loads((HERE / "degree9_fast_linear_sat_f529.json").read_text())
    assert result["sat"]["status"] == "closed"
    assert result["sat"]["nodes"] == 13612
    assert result["sat"]["open_witness"] is None
    assert result["projective_emptiness_over_algebraic_closure"]
    print(
        "PASS every four-hyperplane clause branch and adaptive split branch "
        "ends at coefficient rank 19"
    )
    print("FULL_DEGREE9_CHAR0_PALATINI_LANDING_EXCLUSION_REPLAY_OK")
    print(
        "SCOPE: no nonzero constant-coefficient degree-nine polynomial "
        "self-covariant lands on I4; no arbitrary K_Schur coefficient verdict"
    )


if __name__ == "__main__":
    main()
