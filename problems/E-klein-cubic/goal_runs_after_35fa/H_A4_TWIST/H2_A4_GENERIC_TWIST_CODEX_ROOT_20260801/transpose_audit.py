#!/usr/bin/env python3
"""Reproduce and diagnose the transpose defect in a4_direct_search.py."""

from __future__ import annotations

from contextlib import redirect_stdout
import io
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
with redirect_stdout(io.StringIO()):
    import a4_direct_search as old  # noqa: E402


P = old.P


def corrected_covariant_basis(source, target, degree):
    monomials = old.monomials(degree)
    count = len(monomials)
    rows = []
    for sigma, rho in zip(source, target):
        action = old.symmetric_action(sigma, monomials)
        for output in range(5):
            for monomial in range(count):
                row = [0] * (5 * count)
                # action[j][k] is the coefficient of m_j in m_k(sigma*y),
                # so polynomial columns transform by action^T.
                for source_monomial in range(count):
                    row[output * count + source_monomial] += action[monomial][source_monomial]
                for source_output in range(5):
                    row[source_output * count + monomial] -= rho[output][source_output]
                rows.append([value % P for value in row])
    return monomials, old.nullspace_mod(rows)


def residual_nonzero(source, target, degree, vector):
    monomials = old.monomials(degree)
    count = len(monomials)
    for sigma, rho in zip(source, target):
        action = old.symmetric_action(sigma, monomials)
        for output in range(5):
            for monomial in range(count):
                left = sum(
                    vector[output * count + k] * action[monomial][k]
                    for k in range(count)
                ) % P
                right = sum(
                    rho[output][k] * vector[k * count + monomial]
                    for k in range(5)
                ) % P
                if left != right:
                    return True
    return False


def setup():
    first, _ = old.base.two_a5_classes()
    a, b, a5 = first
    mapping = old.base.iso(a, b, a5)
    involutions = [g for g in a5 if old.base.ORDERS[g] == 2]
    v4 = next(
        frozenset({old.base.ew.fone, x, y, old.base.gmul(x, y)})
        for index, x in enumerate(involutions)
        for y in involutions[index + 1:]
        if old.base.gmul(x, y) == old.base.gmul(y, x)
    )
    a4 = old.base.normalizer(v4, a5)
    ga, gb = old.base.gens(a4)
    source = [old.SOURCE_A5[mapping[g]] for g in (ga, gb)]
    quotient_generator = next(g for g in a4 if old.base.ORDERS[g] == 3)
    cosets = [
        frozenset(old.base.gmul(v, old.base.gpow(quotient_generator, exponent)) for v in v4)
        for exponent in range(3)
    ]
    character = {
        g: next(exponent for exponent, coset in enumerate(cosets) if g in coset)
        for g in a4
    }
    return (ga, gb), source, character


def target(generators, character, exponent):
    return [
        [[pow(old.OMEGA, exponent * character[g], P) * value % P for value in row]
         for row in old.RHO[g]]
        for g in generators
    ]


def main():
    generators, source, character = setup()
    dimensions = []
    for degree in range(1, 5):
        for exponent in range(3):
            monomials, basis = corrected_covariant_basis(
                source, target(generators, character, exponent), degree
            )
            row = {
                "degree": degree,
                "character_exponent": exponent,
                "corrected_covariant_dimension": len(basis),
            }
            if degree == 3 and exponent in (1, 2):
                coefficients = old.landing_coefficients(monomials, basis)
                empty, charts = old.projective_empty(coefficients, len(basis))
                row["landing_geometrically_empty"] = empty
                row["charts"] = charts
                assert not empty
            dimensions.append(row)

    old_target = target(generators, character, 0)
    _monomials, old_basis = old.covariant_basis(source, old_target, 1)
    assert old_basis and residual_nonzero(source, old_target, 1, old_basis[0])
    payload = {
        "format": "H2-A4-TRANSPOSE-AUDIT-v1",
        "prime": P,
        "old_degree1_vector_fails_direct_covariance": True,
        "defect": "old code imposed C*M=R*C although symmetric_action stores m(sigma*y)=M^T*m(y)",
        "correct_equation": "C*M^T=R*C",
        "corrected_records": dimensions,
    }
    (HERE / "transpose_audit.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS old degree-1 output fails direct covariance")
    print("PASS corrected degree-3 character-1 and character-2 landing schemes are nonempty")
    print("H2_A4_TRANSPOSE_AUDIT_OK")


if __name__ == "__main__":
    main()
