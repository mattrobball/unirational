#!/usr/bin/env python3
"""Build exact pivot-adapted direct-module jobs from all 690 sealed rows.

The ordinary `(dp,C)` presentation hides the systematic linear M2 block
behind the quadratic/cubic entries of the higher components.  We instead use
the injective shifted-module embedding

    p(q) e_j |-> h^w_j p(q) e_j

and degree-lex order with h first.  All entries of a relation then have the
same ordinary degree and the M2 terms have the largest h exponent.  After the
exact systematic row permutation, all 690 input leading terms are the unit
M2 pivots.  Runtime assertions in each Singular input independently check all
690 claimed leading terms before starting `std`.

Evaluation h=1 proves membership equivalence in both directions.  Thus the
homogenized jobs are exact, not merely sufficient relaxations.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
DECOMPOSITION = HERE / "systematic_m2_decomposition.npz"
CERTIFICATE = HERE / "systematic_leading_terms.json"
P = 89
NQ = 37


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def polynomial(
    coefficients: np.ndarray,
    monomials: list[tuple[int, ...]],
    h_power: int,
) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        factors = (["h"] * h_power) + [
            (f"q{variable}" if power == 1 else f"q{variable}^{power}")
            for variable, power in enumerate(exponent)
            if power
        ]
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def write_immutable(path: Path, content: bytes) -> None:
    if path.exists():
        if path.read_bytes() != content:
            raise RuntimeError(f"refusing to overwrite mismatching artifact: {path}")
        return
    path.write_bytes(content)


def decomposition(
    seeds: np.ndarray, offsets: np.ndarray, q1: list[tuple[int, ...]]
) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    variable_of = [monomial.index(1) for monomial in q1]
    m2 = np.empty((690, 21, 37), dtype=np.uint8)
    for component in range(21):
        block = seeds[:, int(offsets[7 + component]) : int(offsets[8 + component])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, component, variable] = block[:, monomial_index]
    flatten = m2.reshape(690, 777)
    nnz = np.count_nonzero(flatten, axis=0)
    unit_columns = np.flatnonzero(nnz == 1).astype(np.int32)
    free_columns = np.flatnonzero(nnz > 1).astype(np.int32)
    if len(unit_columns) != 690 or len(free_columns) != 87 or np.any(nnz == 0):
        raise AssertionError("systematic M2 column census failed")
    unit_rows = np.asarray(
        [int(np.flatnonzero(flatten[:, column])[0]) for column in unit_columns],
        dtype=np.int32,
    )
    if len(np.unique(unit_rows)) != 690:
        raise AssertionError("unit columns do not cover every row exactly once")
    identity = flatten[unit_rows][:, unit_columns]
    if not np.array_equal(identity, np.eye(690, dtype=np.uint8)):
        raise AssertionError("systematic minor is not the identity")
    expected_free = [
        component * 37 + variable
        for component in range(21)
        for variable in range(5 if component < 3 else 4)
    ]
    if free_columns.tolist() != expected_free:
        raise AssertionError("unexpected free-coordinate set")
    tail = flatten[unit_rows][:, free_columns]
    return flatten, unit_columns, free_columns, unit_rows, tail


def runtime_leading_checks(
    unit_columns: np.ndarray, component_offset: int
) -> list[str]:
    lines = ["int lt_ok=1;"]
    for generator, column in enumerate(unit_columns):
        b2 = int(column) // 37
        variable = int(column) % 37
        component = component_offset + b2 + 1
        lines.append(
            f"if (lead(N[{generator + 1}])!=h^2*q{variable}*gen({component}))"
            f" {{ lt_ok=0; print(\"LT_FAIL generator={generator + 1}\"); }}"
            if component_offset == 7
            else f"if (lead(N[{generator + 1}])!=h*q{variable}*gen({component}))"
            f" {{ lt_ok=0; print(\"LT_FAIL generator={generator + 1}\"); }}"
        )
    lines.extend(
        [
            'print("SYSTEMATIC_LT_CHECK="+string(lt_ok));',
            'if (lt_ok==0) { print("ABORT_BAD_LEADING_TERMS"); quit; }',
        ]
    )
    return lines


def build_stage_b(
    seeds: np.ndarray,
    offsets: np.ndarray,
    unit_rows: np.ndarray,
    unit_columns: np.ndarray,
    monomials: dict[int, list[tuple[int, ...]]],
) -> tuple[str, dict]:
    stem = "systematic_stageB_homogenized_all222"
    result = HERE / f"{stem}.result"
    blocks = [
        seeds[:, int(offsets[1 + component]) : int(offsets[2 + component])]
        for component in range(6)
    ] + [
        seeds[:, int(offsets[7 + component]) : int(offsets[8 + component])]
        for component in range(21)
    ]
    variables = ["h"] + [f"q{i}" for i in range(5, 37)] + ["q4"] + [f"q{i}" for i in range(4)]
    lines = [
        f"ring R={P},({','.join(variables)}),(Dp,C);",
        "option(prot); option(redSB);",
        "module N=",
    ]
    for generator, source_row in enumerate(unit_rows):
        entries = [polynomial(block[int(source_row)], monomials[2], 0) for block in blocks[:6]]
        entries.extend(polynomial(block[int(source_row)], monomials[1], 1) for block in blocks[6:])
        lines.append("[" + ",".join(entries) + "]" + ("," if generator < 689 else ";"))
    lines.extend(runtime_leading_checks(unit_columns, component_offset=6))
    lines.extend(
        [
            'print("INPUT_GENS="+string(size(N)));',
            "degBound=5; timer=1; module G=std(N); int elapsed=timer;",
            'print("STD_GENS="+string(size(G))+" ELAPSED_MS="+string(elapsed));',
            f'write(":w {result}","status=STD_COMPLETE,degree_bound=5"'
            '+",std_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            "vector target; vector rem; int member; int all_member=1; int passed=0;",
        ]
    )
    for axis in range(37):
        for component in range(6):
            lines.extend(
                [
                    f"target=q{axis}^5*gen({component + 1});",
                    "rem=reduce(target,G); member=(rem==0);",
                    "all_member=all_member*member; passed=passed+member;",
                    f'write(":a {result}","axis={axis},component={component},member="+string(member));',
                ]
            )
    lines.extend(
        [
            f'write(":a {result}","status=ALL_TARGETS_COMPLETE,total=222,passed="'
            '+string(passed)+",all_member="+string(all_member));',
            'print("ALL_TARGETS_COMPLETE PASSED="+string(passed)+" ALL_MEMBER="+string(all_member));',
            "quit;",
        ]
    )
    metadata = {
        "stem": stem,
        "module_components": 27,
        "source_component_weights": [0] * 6 + [1] * 21,
        "homogenized_generator_degree": 2,
        "term_order": "degree lexicographic (Dp,C), variables h,q5..q36,q4,q0..q3",
        "targets": "q_i^5 e_j for 37 axes and six M1 components",
        "target_count": 222,
        "degree_bound": 5,
        "result": result.name,
    }
    return "\n".join(lines) + "\n", metadata


def build_full28(
    seeds: np.ndarray,
    offsets: np.ndarray,
    unit_rows: np.ndarray,
    unit_columns: np.ndarray,
    monomials: dict[int, list[tuple[int, ...]]],
) -> tuple[str, dict]:
    stem = "systematic_full28_homogenized_degree8"
    result = HERE / f"{stem}.result"
    blocks = [
        seeds[:, int(offsets[component]) : int(offsets[component + 1])]
        for component in range(28)
    ]
    degrees = [3] + [2] * 6 + [1] * 21
    weights = [0] + [1] * 6 + [2] * 21
    variables = ["h"] + [f"q{i}" for i in range(5, 37)] + ["q4"] + [f"q{i}" for i in range(4)]
    lines = [
        f"ring R={P},({','.join(variables)}),(Dp,C);",
        "option(prot); option(redSB);",
        "module N=",
    ]
    for generator, source_row in enumerate(unit_rows):
        entries = [
            polynomial(block[int(source_row)], monomials[degree], weight)
            for block, degree, weight in zip(blocks, degrees, weights)
        ]
        lines.append("[" + ",".join(entries) + "]" + ("," if generator < 689 else ";"))
    lines.extend(runtime_leading_checks(unit_columns, component_offset=7))
    lines.extend(
        [
            'print("INPUT_GENS="+string(size(N)));',
            "degBound=8; timer=1; module G=std(N); int elapsed=timer;",
            'print("STD_GENS="+string(size(G))+" ELAPSED_MS="+string(elapsed));',
            f'write(":w {result}","status=STD_COMPLETE,degree_bound=8"'
            '+",std_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            "vector target; vector rem; int member; int all_member=1; int passed=0;",
        ]
    )
    exponents = [8] + [7] * 6 + [6] * 21
    for axis in range(37):
        for component, (weight, exponent) in enumerate(zip(weights, exponents)):
            h_factor = "" if weight == 0 else ("h*" if weight == 1 else "h^2*")
            lines.extend(
                [
                    f"target={h_factor}q{axis}^{exponent}*gen({component + 1});",
                    "rem=reduce(target,G); member=(rem==0);",
                    "all_member=all_member*member; passed=passed+member;",
                    f'write(":a {result}","axis={axis},component={component},member="+string(member));',
                ]
            )
    lines.extend(
        [
            f'write(":a {result}","status=ALL_TARGETS_COMPLETE,total=1036,passed="'
            '+string(passed)+",all_member="+string(all_member));',
            'print("ALL_TARGETS_COMPLETE PASSED="+string(passed)+" ALL_MEMBER="+string(all_member));',
            "quit;",
        ]
    )
    metadata = {
        "stem": stem,
        "module_components": 28,
        "source_component_weights": weights,
        "homogenized_generator_degree": 3,
        "term_order": "degree lexicographic (Dp,C), variables h,q5..q36,q4,q0..q3",
        "targets": "h^w_j q_i^(8-w_j) e_j for 37 axes and all 28 components",
        "target_count": 1036,
        "degree_bound": 8,
        "result": result.name,
    }
    return "\n".join(lines) + "\n", metadata


def main() -> None:
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        prime = int(frozen["prime"])
    if prime != P or seeds.shape != (690, 14134):
        raise AssertionError("sealed relation layout mismatch")
    monomials = {degree: weak_compositions(degree, NQ) for degree in (1, 2, 3)}
    flatten, unit_columns, free_columns, unit_rows, tail = decomposition(
        seeds, offsets, monomials[1]
    )
    # The compressed packet is small enough to retain the full exact tail and
    # independently replay the claimed [I|T] form.
    if DECOMPOSITION.exists():
        with np.load(DECOMPOSITION, allow_pickle=False) as old:
            for key, expected in {
                "unit_columns": unit_columns,
                "free_columns": free_columns,
                "unit_rows": unit_rows,
                "tail": tail,
            }.items():
                if not np.array_equal(old[key], expected):
                    raise RuntimeError(f"immutable decomposition mismatch: {key}")
    else:
        np.savez_compressed(
            DECOMPOSITION,
            prime=np.int32(P),
            unit_columns=unit_columns,
            free_columns=free_columns,
            unit_rows=unit_rows,
            tail=tail,
        )

    jobs = []
    for content, metadata in (
        build_stage_b(seeds, offsets, unit_rows, unit_columns, monomials),
        build_full28(seeds, offsets, unit_rows, unit_columns, monomials),
    ):
        script = HERE / f"{metadata['stem']}.sing"
        write_immutable(script, content.encode())
        metadata["script"] = {
            "file": script.name,
            "bytes": script.stat().st_size,
            "sha256": sha256(script),
            "immutable_rebuild_match": True,
        }
        metadata["status"] = "PREPARED_NOT_RUN"
        metadata["criterion"] = (
            "A terminal all_member=1 after SYSTEMATIC_LT_CHECK=1 is an exact "
            "membership certificate for every listed target."
        )
        metadata["nonverdicts"] = (
            "Any missing leading-term check, timeout, resource kill, crash, "
            "or nonzero target remainder."
        )
        manifest = HERE / f"{metadata['stem']}.json"
        write_immutable(manifest, (json.dumps(metadata, indent=2, sort_keys=True) + "\n").encode())
        jobs.append(metadata)

    certificate = {
        "status": "PASS_EXACT_SYSTEMATIC_LEADING_TERM_PROOF",
        "prime": P,
        "source": {"path": str(RELATION), "sha256": sha256(RELATION)},
        "flattening_shape": list(flatten.shape),
        "unit_columns": len(unit_columns),
        "free_columns": len(free_columns),
        "free_coordinates": [
            {"b2": int(column) // 37, "q": int(column) % 37}
            for column in free_columns
        ],
        "systematic_identity_minor": True,
        "tail_shape": list(tail.shape),
        "tail_nnz": int(np.count_nonzero(tail)),
        "decomposition": {
            "file": DECOMPOSITION.name,
            "sha256": sha256(DECOMPOSITION),
            "bytes": DECOMPOSITION.stat().st_size,
        },
        "embedding": "iota_w(p e_j)=h^w_j p e_j",
        "membership_equivalence": (
            "Forward direction applies iota to an S-linear combination; reverse "
            "direction evaluates a homogenized S[h]-linear combination at h=1."
        ),
        "term_order_proof": (
            "All relation entries have one ordinary degree after iota. Dp first "
            "maximizes h exponent, hence selects M2. The variable order makes "
            "q5..q36 larger than q4 and q0..q3. The only q4 free terms occupy "
            "b2_0..b2_2, while every q4 pivot occupies b2_3..b2_20 and is larger "
            "under trailing C. Therefore all 690 displayed unit M2 coordinates "
            "are exactly the input leading terms."
        ),
        "same_component_initial_spairs": 3 * (32 * 31 // 2) + 18 * (33 * 32 // 2),
        "jobs": jobs,
        "scope": (
            "This proves the term-order claim and prepares exact jobs. It does "
            "not assert that either standard-basis computation has completed."
        ),
    }
    write_immutable(CERTIFICATE, (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode())
    print(json.dumps(certificate, sort_keys=True))


if __name__ == "__main__":
    main()

