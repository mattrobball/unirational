#!/usr/bin/env python3
"""Exact replay for the bounded C_012 one-parameter stop packet.

This verifier deliberately does not search above polynomial degree three and
does not infer a generic-section verdict from a single specialization.
"""

from __future__ import annotations

import hashlib
import json
import re
import subprocess
from pathlib import Path

import sympy as sp

import analyze_specialization as A
import search_degree3_msolve as M
import search_polynomial_sections as S


HERE = Path(__file__).resolve().parent


def project_root() -> Path:
    for candidate in (HERE, *HERE.parents):
        if (candidate / "goals_2026-08-01").is_dir() and (
            candidate / "goal_runs_after_35fa"
        ).is_dir():
            return candidate
    raise AssertionError("E-klein-cubic project root not found")


WORKSPACE = project_root() / "goals_2026-08-01"
MARKER = "C012_ONE_PARAMETER_BOUNDED_STOP_OK"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def digest(rows) -> str:
    raw = json.dumps(rows, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(raw).hexdigest()


def canonical_cubic_terms(expression):
    polynomial = sp.Poly(
        sp.expand(expression),
        S.V.s,
        S.V.X,
        S.V.Y,
        S.V.Z,
        domain=sp.QQ.frac_field(S.V.e),
    )
    rows = []
    for monomial, coefficient in polynomial.terms():
        epsilon_polynomial = sp.Poly(sp.expand(coefficient), S.V.e, domain=sp.QQ)
        assert epsilon_polynomial.degree() <= 3
        rows.append(
            {
                "exp": list(monomial),
                "coeff": [
                    str(epsilon_polynomial.coeff_monomial(S.V.e**degree))
                    for degree in range(4)
                ],
            }
        )
    return rows


def canonical_univariate_terms(expression):
    polynomial = sp.Poly(
        sp.expand(expression), A.TORSOR.s, domain=sp.QQ.frac_field(A.TORSOR.e)
    )
    rows = []
    for (exponent,), coefficient in polynomial.terms():
        epsilon_polynomial = sp.Poly(
            sp.expand(coefficient), A.TORSOR.e, domain=sp.QQ
        )
        assert epsilon_polynomial.degree() <= 3
        rows.append(
            {
                "exp": exponent,
                "coeff": [
                    str(epsilon_polynomial.coeff_monomial(A.TORSOR.e**degree))
                    for degree in range(4)
                ],
            }
        )
    return rows


def factor_patterns(polynomials):
    """Factor univariate polynomials exactly over Q(epsilon) with Singular."""
    lines = [
        "ring r=(0,e),(s),dp;",
        "minpoly=e^4+e^3+e^2+e+1;",
    ]
    for name, polynomial in polynomials.items():
        lines.append(f"poly {name}={A.singular_expression(polynomial)};")
        lines.append(f"list L_{name}=factorize({name});")
        lines.append(f'"BEGIN_{name.upper()}";')
        lines.append(f"size(L_{name}[1]);")
        lines.append("int i;")
        lines.append(
            f"for (i=1;i<=size(L_{name}[1]);i++)"
            f" {{ deg(L_{name}[1][i]); L_{name}[2][i]; }}"
        )
        lines.append(f'"END_{name.upper()}";')
    completed = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q"],
        input="\n".join(lines) + "\n",
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=180,
        check=True,
    )
    answer = {}
    for name in polynomials:
        start = f"BEGIN_{name.upper()}"
        end = f"END_{name.upper()}"
        assert start in completed.stdout and end in completed.stdout, completed.stdout
        block = completed.stdout.split(start, 1)[1].split(end, 1)[0]
        integers = [
            int(line.strip())
            for line in block.splitlines()
            if re.fullmatch(r"-?\d+", line.strip())
        ]
        size = integers[0]
        assert len(integers) == 1 + 2 * size
        answer[name] = sorted(
            (integers[1 + 2 * index], integers[2 + 2 * index])
            for index in range(size)
        )
    return answer


def section_system_digest(variables, equations):
    # M.equations_for_degree orders coefficients from low to high s-degree.
    # Store the canonical high-to-low list used when the payload was made.
    rendered = []
    for equation in reversed(equations):
        reduced = sp.Poly(
            sp.expand(equation.subs(S.V.e, 3)), *variables, modulus=11
        ).as_expr()
        rendered.append(S.singular_text(reduced))
    raw = json.dumps(rendered, separators=(",", ":")).encode()
    return hashlib.sha256(raw).hexdigest()


def main():
    payload = json.loads((HERE / "payload.json").read_text())
    assert payload["marker"] == MARKER
    assert payload["scope"]["status"] == "C012_GENERIC_SECTION_UNDECIDED"

    manifest = json.loads((HERE / "source_manifest.json").read_text())
    actual_sources = {name: sha256(WORKSPACE / name) for name in manifest}
    assert actual_sources == manifest
    print("SOURCE_HASHES_OK", len(manifest))

    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["marker"] == MARKER
    actual_seal = {name: sha256(HERE / name) for name in seal["files"]}
    assert actual_seal == seal["files"]
    print("PACKET_SEAL_OK", len(actual_seal))

    # Reconstruct the exact (s,3,5,7) plane directly from the upstream trace data.
    raw_cubic = S.specialized_cubic()
    cubic = sp.expand(raw_cubic / 5)
    assert sp.expand(raw_cubic - 5 * cubic) == 0
    cubic_rows = canonical_cubic_terms(cubic)
    expected_specialization = payload["specialization"]
    assert cubic_rows == expected_specialization["terms"]
    assert len(cubic_rows) == expected_specialization["term_count"] == 26
    assert digest(cubic_rows) == expected_specialization["sha256"]
    assert sp.degree(cubic, S.V.s) == 3
    assert sp.expand(cubic.subs(S.V.s, 0) - S.V.X**3) == 0
    print("SPECIALIZED_CUBIC_TERMS", len(cubic_rows))
    print("SPECIALIZED_CUBIC_SHA256", digest(cubic_rows))
    print("SPECIALIZED_FIBER_S0", "X^3")

    # Specialize the upstream canonical Fisher invariants and factor them exactly.
    triple = json.loads((A.TRIPLE_DIR / "payload.json").read_text())
    jacobian = json.loads((A.JACOBIAN_DIR / "payload.json").read_text())
    u2, u3, u4 = sp.symbols("U2 U3 U4")
    traces = [
        A.TORSOR.reduce_e_polynomial(
            A.TORSOR.actual_trace(
                triple["trace_coefficients"], index, u2, u3, u4
            ).subs({u2: 3, u3: 5, u4: 7}),
            (A.TORSOR.s,),
        )
        for index in range(5)
    ]
    c4 = A.deserialize_invariant(jacobian["c4"]["terms"], traces)
    c6 = A.deserialize_invariant(jacobian["c6"]["terms"], traces)
    delta = A.TORSOR.reduce_e_polynomial(
        sp.expand(c4**3 - c6**2), (A.TORSOR.s,)
    )

    invariant_data = payload["jacobian"]["invariants"]
    exact_invariants = {
        "c4": c4,
        "c6": c6,
        "Delta_reduced=c4^3-c6^2": delta,
    }
    for name, polynomial in exact_invariants.items():
        rows = canonical_univariate_terms(polynomial)
        expected = invariant_data[name]
        assert len(rows) == expected["univariate_terms"]
        assert digest(rows) == expected["sha256"]
        assert sp.degree(polynomial, A.TORSOR.s) == expected["degree"]
        assert A.valuation(polynomial) == expected["valuation_at_zero"]
        print(
            "INVARIANT",
            name,
            "DEGREE",
            expected["degree"],
            "VALUATION_S0",
            expected["valuation_at_zero"],
            "SHA256",
            expected["sha256"],
        )

    patterns = factor_patterns({"c4": c4, "c6": c6, "delta": delta})
    assert patterns == {
        "c4": [(0, 1), (1, 3), (9, 1)],
        "c6": [(0, 1), (1, 4), (14, 1)],
        "delta": [(0, 1), (1, 8), (27, 1)],
    }
    # In the infinity chart t=1/s, the global coefficients are
    # t^12*c4(1/t), t^18*c6(1/t), and t^36*Delta(1/t).
    assert 12 - sp.degree(c4, A.TORSOR.s) == 0
    assert 18 - sp.degree(c6, A.TORSOR.s) == 0
    assert 36 - sp.degree(delta, A.TORSOR.s) == 1
    print("FACTOR_PATTERNS", patterns)
    print("JACOBIAN_FIBERS", "IV*_AT_0", "27_FINITE_I1", "I1_AT_INFINITY")

    # The degree-three coefficient projective space includes all lower degrees.
    assert sum(pow(3, exponent, 11) for exponent in range(5)) % 11 == 0
    assert 3 % 11 != 1
    variables, equations = M.equations_for_degree(cubic, 3)
    bounded = payload["bounded_section_exclusion"]
    assert len(variables) == bounded["coefficient_variables"] == 12
    assert len(equations) == bounded["coefficient_equations"] == 13
    assert section_system_digest(variables, equations) == bounded[
        "equation_system_sha256"
    ]
    outcomes = []
    for chart, variable in enumerate(variables):
        empty = M.solve_chart(variables, equations, chart, verbose=False)
        outcomes.append(empty)
        print("MOD11_CHART", chart, variable, "EMPTY" if empty else "SURVIVOR")
    assert len(outcomes) == bounded["projective_charts"] == 12
    assert all(outcomes)
    print("POLYNOMIAL_SECTION_DEGREE_LE_3_MOD11", "EXCLUDED")

    assert payload["scope"]["not_proved"] == [
        "nonexistence of polynomial-coordinate representatives of degree greater than 3",
        "pointlessness or solubility of the specialized genus-one curve over Q(epsilon)(s)",
        "absence or existence of a section for generic (U2,U3,U4)",
        "nontriviality or triviality of the generic C_012 torsor class",
        "a rational point or pointlessness theorem for the full Schur twist",
    ]
    print("STATUS", payload["scope"]["status"])
    print(MARKER)


if __name__ == "__main__":
    main()
