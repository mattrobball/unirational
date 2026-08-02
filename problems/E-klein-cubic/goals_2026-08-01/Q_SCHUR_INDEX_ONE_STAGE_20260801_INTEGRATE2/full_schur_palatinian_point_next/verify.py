#!/usr/bin/env python3
"""Independent replay of the scoped ten-pencil irreducibility packet."""
from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path
import runpy
import subprocess
import sys

import numpy as np

import pencil_mod23
import produce_certificate


HERE = Path(__file__).resolve().parent
PYTHON = "/opt/homebrew/bin/python3"


def load(name: str, path: Path):
    specification = importlib.util.spec_from_file_location(name, path)
    assert specification and specification.loader
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


def run(path: Path, markers: tuple[str, ...]) -> None:
    process = subprocess.run(
        [PYTHON, "-u", str(path)],
        cwd=path.parent,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    assert process.returncode == 0, process.stdout
    assert all(marker in process.stdout for marker in markers), process.stdout
    print(process.stdout, end="")


def evaluate(polynomial, point: tuple[int, ...]) -> int:
    return pencil_mod23.evaluate(polynomial, point)


def main() -> None:
    manifest = json.loads((HERE / "source_manifest.json").read_text())
    root = Path(manifest["root"])
    for relative, expected in manifest["sources"].items():
        actual = hashlib.sha256((root / relative).read_bytes()).hexdigest()
        assert actual == expected, (relative, actual, expected)
    print("PASS immutable source manifest")

    exact_core_path = root / "tmp/pfaffian_representation_alignment/core.py"
    modular_core_path = root / "tmp/fano14_twist/fano_covariant_scan.py"
    exact = runpy.run_path(str(exact_core_path))
    modular = load("full_schur_point_next_modular", modular_core_path)
    assert pow(2, 11, 23) == 1 and 2 != 1
    exact_generators = exact["schur_generators"]()
    reduced_generators = tuple(
        np.asarray(
            [
                [exact["reduce_k11"](entry, 2, 23) for entry in row]
                for row in generator.to_list()
            ],
            dtype=np.int64,
        )
        % 23
        for generator in exact_generators
    )
    modular_generators = modular.six_dimensional_generators()
    assert all(
        np.array_equal(left, right)
        for left, right in zip(reduced_generators, modular_generators)
    )
    assert exact["abstract_alignment"]()["generated_projective_order"] == 660
    assert len(modular.generate_group(modular_generators)) == 1320
    print("PASS exact Q(zeta_11) Schur generators and good-fibre action alignment")

    group, inverses = pencil_mod23.group_data()
    q3 = pencil_mod23.reynolds_seed(group, inverses, 3, 0)
    q5 = [
        pencil_mod23.reynolds_seed(group, inverses, 5, output)
        for output in (0, 1, 5)
    ]
    points = (
        (1, 2, 3, 4, 5, 6),
        (2, 5, 7, 11, 13, 17),
        (3, 1, 4, 1, 5, 9),
    )
    q3_vector = np.asarray(
        [evaluate(component, points[0]) for component in q3], dtype=np.int64
    )
    assert np.any(q3_vector % 23)
    q5_rows = np.asarray(
        [
            [evaluate(component, point) for point in points for component in covariant]
            for covariant in q5
        ],
        dtype=np.int64,
    )
    assert modular.rank(q5_rows.T) == 3
    print("PASS nonzero q3 and independent canonical q5 Reynolds maps")

    upstream = root / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian"
    run(
        upstream / "verify_palatinian_equation.py",
        (
            "PALATINI_REYNOLDS_I4_IDENTITY_OK",
            "PALATINI_ALL_SIX_MAXIMAL_MINOR_SYZYGIES_OK",
        ),
    )
    run(
        upstream / "verify_char0_palatinian_lift.py",
        (
            "CHAR0_B5_REDUCTION_MATCH_OK",
            "CHAR0_PALATINI_EQUALS_REYNOLDS_I4_LIFT_OK",
        ),
    )

    frozen = json.loads((HERE / "certificate.json").read_text())
    regenerated = produce_certificate.produce()
    assert regenerated == frozen
    ordinary = [
        record for record in frozen["records"] if record["extension_degree"] == 1
    ]
    assert len(ordinary) == 10
    assert all(record["factor_count_with_unit"] == 2 for record in ordinary)
    q1_q3 = [
        record for record in frozen["records"] if record["name"] == "q1__q3"
    ]
    assert [record["extension_degree"] for record in q1_q3] == [1, 2, 3, 4]
    assert all(record["factor_count_with_unit"] == 2 for record in q1_q3)
    print("PASS all ten F_23-irreducible pencils")
    print("PASS q1--q3 has no hidden t-linear factor over algebraic constants")
    print("FULL_SCHUR_TEN_PENCIL_IRREDUCIBILITY_REPLAY_OK")
    print(
        "SCOPE: one full-constant-field pencil exclusion and nine "
        "Q(zeta_11)(x)-pencil exclusions; no K_Schur point and no binary verdict"
    )


if __name__ == "__main__":
    main()
