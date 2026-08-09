#!/usr/bin/env python3
"""Exact grouped-CNF solver replay for the fixed pattern at root degree eight.

This script is deliberately labeled a solver replay.  It reconstructs the
finite Boolean problem exactly and solves it twice, once from the unordered
Sym^2 expansion and once after literal ordered multiplication has been shown
coefficient-identical.  PicoSAT returns UNSAT, but the packet does not contain
a DRAT/RUP proof.  The conclusion therefore retains a trusted-solver caveat.
"""

from __future__ import annotations

from collections import Counter
from hashlib import sha256
from math import ceil, sqrt
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
VENDOR = HERE / "vendor"
sys.dont_write_bytecode = True
sys.path.insert(0, str(VENDOR))
sys.path.insert(0, str(HERE))

import pycosat
import reconstruct as model


EXPECTED_PYCOSAT_SHA256 = (
    "b41545dfc38f29d6b9f8aaa49d330383d597e673c2cd66d93a28b175dc00cecf"
)
EXPECTED_POLYNOMIAL_SHA256 = (
    "d17c8974df5e8ce9699b99f8dd972fc5be56f4c17ee31a63a42f121b03e771cd"
)
EXPECTED_SUPPORT_SHA256 = (
    "14a23775efd6f56b90af437715b6bdf011f27fbea061a0f11ae341e65d8523de"
)
EXPECTED_CNF_SHA256 = (
    "f2e5180fdb315cb5705eba6ebd96e8b5b76e43a68d591d0fee885726c223fb83"
)


def prepare(rows, groups, n_x):
    masks = tuple(sorted({mask for row in rows for mask in row}))
    y = {mask: n_x + 1 + index for index, mask in enumerate(masks)}
    next_variable = n_x + len(masks) + 1
    row_data = []
    row_clause_count = 0
    for row in rows:
        counts = Counter(row)
        singles = tuple(y[mask] for mask in sorted(counts) if counts[mask] == 1)
        safe = tuple(y[mask] for mask in sorted(counts) if counts[mask] >= 2)
        number = len(singles)
        if number <= 16:
            partitions = (singles,) if singles else ()
            group_variables = ()
            row_clause_count += number
        else:
            block_size = ceil(sqrt(number))
            partitions = tuple(
                singles[i : i + block_size]
                for i in range(0, number, block_size)
            )
            group_variables = tuple(
                range(next_variable, next_variable + len(partitions))
            )
            next_variable += len(partitions)
            # member=>group, group=>OR(members), then one exact exclusion
            # clause for each singleton occurrence.
            row_clause_count += number + len(partitions) + number
        row_data.append((singles, safe, partitions, group_variables))

    conjunction_clause_count = sum(mask.bit_count() + 1 for mask in masks)
    clause_count = len(groups) + conjunction_clause_count + row_clause_count
    return masks, y, tuple(row_data), next_variable - 1, clause_count


def clauses(masks, y, row_data, groups, n_x):
    # Each residue block is nonempty.
    for group in groups:
        yield [j + 1 for j in group]

    # y_mask is equivalent to the conjunction of its x variables.
    for mask in masks:
        y_variable = y[mask]
        bits = tuple(j + 1 for j in range(n_x) if mask & (1 << j))
        for x_variable in bits:
            yield [-y_variable, x_variable]
        yield [y_variable] + [-x_variable for x_variable in bits]

    # Exclude exactly one active coefficient monomial in each row.  A support
    # mask occurring at least twice is already safe because its activation
    # produces at least two distinct coefficient monomials.
    for singles, safe, partitions, group_variables in row_data:
        if len(singles) <= 16:
            for singled in singles:
                yield (
                    [-singled]
                    + [other for other in singles if other != singled]
                    + list(safe)
                )
            continue

        membership = {}
        for group_index, (members, group_variable) in enumerate(
            zip(partitions, group_variables)
        ):
            for member in members:
                membership[member] = group_index
                yield [-member, group_variable]
            yield [-group_variable] + list(members)
        for singled in singles:
            own_group = membership[singled]
            yield (
                [-singled]
                + [m for m in partitions[own_group] if m != singled]
                + [
                    group_variables[j]
                    for j in range(len(group_variables))
                    if j != own_group
                ]
                + list(safe)
            )


def clause_digest(iterator):
    state = sha256()
    count = 0
    for clause in iterator:
        state.update(repr(clause).encode("ascii"))
        state.update(b"\n")
        count += 1
    return state.hexdigest(), count


def solver_binary():
    candidates = tuple(VENDOR.glob("pycosat*.so"))
    assert len(candidates) == 1
    binary = candidates[0]
    digest = sha256(binary.read_bytes()).hexdigest()
    assert digest == EXPECTED_PYCOSAT_SHA256
    return binary, digest


def main():
    binary, binary_digest = solver_binary()
    variable_data, groups = model.variables(8)
    assert tuple(map(len, groups)) == (45, 45, 45)
    assert len(variable_data) == 135

    primary = model.unordered_expansion(variable_data)
    all_rows, rows = model.support_rows(primary)
    assert len(primary) == len(all_rows) == 60515
    assert len(rows) == 12085
    assert model.polynomial_digest(primary) == EXPECTED_POLYNOMIAL_SHA256
    assert model.support_digest(rows) == EXPECTED_SUPPORT_SHA256

    masks, y, row_data, nvars, nclauses = prepare(rows, groups, len(variable_data))
    assert len(masks) == 410175
    assert nvars - len(variable_data) - len(masks) == 82232
    assert nvars == 492542
    assert nclauses == 4163268
    cnf_digest, counted = clause_digest(
        clauses(masks, y, row_data, groups, len(variable_data))
    )
    assert counted == nclauses
    print("CANONICAL_CNF_SHA256", cnf_digest, flush=True)
    assert cnf_digest == EXPECTED_CNF_SHA256

    first = pycosat.solve(
        clauses(masks, y, row_data, groups, len(variable_data)),
        vars=nvars,
    )
    assert first == "UNSAT"
    print("UNORDERED_RECONSTRUCTION_PICOSAT", first, flush=True)

    # Reconstruct from literal ordered products and compare every target and
    # every coefficient monomial before rebuilding the CNF and solving again.
    secondary = model.ordered_expansion(variable_data)
    assert secondary == primary
    all_rows_2, rows_2 = model.support_rows(secondary)
    assert all_rows_2 == all_rows and rows_2 == rows
    prepared_2 = prepare(rows_2, groups, len(variable_data))
    assert prepared_2 == (masks, y, row_data, nvars, nclauses)
    second = pycosat.solve(
        clauses(masks, y, row_data, groups, len(variable_data)),
        vars=nvars,
    )
    assert second == "UNSAT"

    print("ORDERED_RECONSTRUCTION_COEFFICIENT_MATCH", True)
    print("ORDERED_RECONSTRUCTION_PICOSAT", second)
    print("PYCOSAT_VERSION", pycosat.__version__)
    print("PYCOSAT_BINARY", binary.name)
    print("PYCOSAT_BINARY_SHA256", binary_digest)
    print("N8_X_Y_AUX_VARS", len(variable_data), len(masks), 82232)
    print("N8_SOURCE_UNIQUE_ROWS", len(primary), len(rows))
    print("N8_GROUPED_CNF_CLAUSES", nclauses)
    print("F55-CHAR5-FIXED-THREE-RESIDUE-N8-SUPPORT-UNSAT-SOLVER-REPLAY")
    print("CAVEAT_NO_DRAT_OR_RUP_PROOF")


if __name__ == "__main__":
    main()
