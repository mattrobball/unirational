#!/usr/bin/env python3
"""Exhibit the transposition error in the installed bounded A4 search."""

from __future__ import annotations

import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
REPO = next(
    parent for parent in HERE.parents
    if (parent / "certificates" / "exact_weil_check.py").is_file()
    and (parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json").is_file()
)
UPSTREAM = REPO / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
sys.path.insert(0, str(UPSTREAM))
import a4_direct_search as old  # noqa: E402
import produce as base  # noqa: E402


def main():
    first, _ = base.two_a5_classes()
    a, b, a5 = first
    mapping = base.iso(a, b, a5)
    involutions = [g for g in a5 if base.ORDERS[g] == 2]
    v4 = next(
        frozenset({base.ew.fone, x, y, base.gmul(x, y)})
        for index, x in enumerate(involutions)
        for y in involutions[index + 1:]
        if base.gmul(x, y) == base.gmul(y, x)
    )
    a4 = base.normalizer(v4, a5)
    ga, gb = base.gens(a4)
    source = [old.SOURCE_A5[mapping[g]] for g in (ga, gb)]
    quotient_generator = next(g for g in a4 if base.ORDERS[g] == 3)
    cosets = [
        frozenset(base.gmul(v, base.gpow(quotient_generator, exponent)) for v in v4)
        for exponent in range(3)
    ]
    character = {
        g: next(exponent for exponent, coset in enumerate(cosets) if g in coset)
        for g in a4
    }
    exponent = 1
    target = [
        [[pow(old.OMEGA, exponent * character[g], old.P) * value % old.P for value in row]
         for row in old.RHO[g]]
        for g in (ga, gb)
    ]
    mons, basis = old.covariant_basis(source, target, degree=3)
    assert len(basis) == 4
    failures = []
    for basis_index, vector in enumerate(basis):
        count = len(mons)
        C = [vector[row * count:(row + 1) * count] for row in range(5)]
        for generator_index, (sigma, rho) in enumerate(zip(source, target)):
            M = old.symmetric_action(sigma, mons)
            # Actual substitution is m(sigma*y)=M^T*m(y).
            left = [[sum(C[i][k] * M[j][k] for k in range(count)) % old.P
                     for j in range(count)] for i in range(5)]
            right = [[sum(rho[i][k] * C[k][j] for k in range(5)) % old.P
                      for j in range(count)] for i in range(5)]
            disagreements = sum(left[i][j] != right[i][j] for i in range(5) for j in range(count))
            if disagreements:
                failures.append({
                    "basis_index": basis_index,
                    "generator_index": generator_index,
                    "coefficient_disagreements": disagreements,
                })
    assert failures
    payload = {
        "format": "H2-A4-UPSTREAM-TRANSPOSE-AUDIT-v1",
        "prime": old.P,
        "degree": 3,
        "character_exponent": exponent,
        "upstream_reported_basis_dimension": len(basis),
        "direct_covariance_failures": failures,
        "diagnosis": "upstream solves C*M=R*C, while direct polynomial substitution requires C*M^T=R*C",
        "consequence": "the installed degree-1--4 landing emptiness statements are invalid and are not used by H2",
    }
    (HERE / "upstream_transpose_audit.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    messages = [
        f"PASS detected {len(failures)} direct covariance failures in the installed degree-3 character-1 basis",
        "PASS diagnosed C*M versus C*M^T convention error",
        "H2_UPSTREAM_TRANSPOSE_BUG_CONFIRMED",
    ]
    (HERE / "upstream_transpose_audit.log").write_text("\n".join(messages) + "\n")
    print("\n".join(messages))


if __name__ == "__main__":
    main()
