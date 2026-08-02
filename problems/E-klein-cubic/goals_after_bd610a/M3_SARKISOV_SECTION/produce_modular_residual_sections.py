#!/usr/bin/env python3
"""Find genuine gcd-free d=4 sections in two split good reductions.

The construction takes fibrewise third intersection of two installed line
sections.  It is exact over the chosen finite field, but a nontrivial orbit of
such sections does not descend to the projective Schur field.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path

import numpy as np
import sympy as sp


HERE = Path(__file__).resolve().parent
MODULAR_PATH = HERE / "produce_modular_sections.py"


def load_modular():
    spec = importlib.util.spec_from_file_location("m3_modular_sections", MODULAR_PATH)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def all_line_sections(modular, certificate, probe, frame, prime, zeta):
    generators = modular.target_generators(certificate, probe, prime, zeta)
    identity = np.eye(5, dtype=np.int64) % prime
    target_to_a = modular.inverse_matrix(frame, prime)
    seen_matrices = set()
    sections = set()
    involutions = 0
    for word in certificate["projective_words"]:
        matrix = identity.copy()
        for letter in word:
            matrix = matrix @ generators[letter] % prime
        key = tuple(map(int, matrix.reshape(-1)))
        if key in seen_matrices:
            continue
        seen_matrices.add(key)
        if np.array_equal(matrix, identity) or not np.array_equal(
            matrix @ matrix % prime, identity
        ):
            continue
        involutions += 1
        line_target = modular.nullspace(matrix + identity, prime)
        assert line_target.shape == (5, 2)
        line_a = target_to_a @ line_target % prime
        projection = line_a[3:5, :]
        determinant = int(
            projection[0, 0] * projection[1, 1]
            - projection[0, 1] * projection[1, 0]
        ) % prime
        if not determinant:
            continue
        section = line_a @ modular.inverse_2x2(projection, prime) % prime
        assert np.array_equal(section[3:5], np.eye(2, dtype=np.int64))
        sections.add(tuple(map(int, section.reshape(-1))))
    assert len(seen_matrices) == 660 and involutions == 55
    return [np.asarray(value, dtype=np.int64).reshape(5, 2) for value in sorted(sections)]


def coefficient_vector(polynomial: sp.Poly, degree: int, prime: int) -> list[int]:
    s, t = polynomial.gens
    return [
        int(polynomial.coeff_monomial(s ** (degree - index) * t**index)) % prime
        for index in range(degree + 1)
    ]


def common_gcd(polynomials: list[sp.Poly]) -> sp.Poly:
    result = next(polynomial for polynomial in polynomials if not polynomial.is_zero)
    for polynomial in polynomials:
        if not polynomial.is_zero:
            result = sp.gcd(result, polynomial)
    return result


def build(prime: int) -> dict:
    modular = load_modular()
    probe = modular.load_probe()
    certificate = json.loads(probe.FRAME.read_text())
    zeta, frame_rows = probe.frame_mod_prime(certificate, prime)
    frame = np.asarray(frame_rows, dtype=np.int64) % prime
    sections = all_line_sections(
        modular, certificate, probe, frame, prime, zeta
    )
    s, t = sp.symbols("s t")
    phi = probe.transformed_klein(frame_rows, prime)
    variables = phi.gens
    expression = phi.as_expr()

    selected = None
    for first in range(len(sections)):
        for second in range(first + 1, len(sections)):
            p = [
                sp.Poly(sections[first][row, 0] * s + sections[first][row, 1] * t, s, t, modulus=prime)
                for row in range(5)
            ]
            q = [
                sp.Poly(sections[second][row, 0] * s + sections[second][row, 1] * t, s, t, modulus=prime)
                for row in range(5)
            ]
            p_substitution = {variable: value.as_expr() for variable, value in zip(variables, p)}
            q_substitution = {variable: value.as_expr() for variable, value in zip(variables, q)}
            alpha = sp.Poly(
                sum(
                    sp.diff(expression, variable).subs(p_substitution) * q[index].as_expr()
                    for index, variable in enumerate(variables)
                ),
                s,
                t,
                modulus=prime,
            )
            beta = sp.Poly(
                sum(
                    sp.diff(expression, variable).subs(q_substitution) * p[index].as_expr()
                    for index, variable in enumerate(variables)
                ),
                s,
                t,
                modulus=prime,
            )
            residual = [
                sp.Poly(
                    -beta.as_expr() * p[index].as_expr()
                    + alpha.as_expr() * q[index].as_expr(),
                    s,
                    t,
                    modulus=prime,
                )
                for index in range(5)
            ]
            if all(value.is_zero for value in residual):
                continue
            graph = sp.Poly(
                residual[3].as_expr() * t - residual[4].as_expr() * s,
                s,
                t,
                modulus=prime,
            )
            assert graph.is_zero
            b = residual[3].exquo(sp.Poly(s, s, t, modulus=prime))
            assert residual[4] == b * sp.Poly(t, s, t, modulus=prime)
            gcd = common_gcd(residual[:3] + [b])
            if gcd.total_degree() != 0:
                continue
            cubic_value = sp.Poly(
                expression.subs(
                    {variable: residual[index].as_expr() for index, variable in enumerate(variables)}
                ),
                s,
                t,
                modulus=prime,
            )
            assert cubic_value.is_zero
            parameters = []
            for value in residual[:3]:
                parameters.extend(coefficient_vector(value, 4, prime))
            parameters.extend(coefficient_vector(b, 3, prime))
            section_parameters, equations = modular.section_polynomials(
                probe, phi, 4, prime
            )
            assert not any(
                modular.evaluate_poly(equation, parameters, prime)
                for equation in equations
            )
            rank = modular.jacobian_rank(
                equations, section_parameters, parameters, prime
            )
            selected = {
                "pair_indices": [first, second],
                "line_section_matrices": [
                    sections[first].tolist(),
                    sections[second].tolist(),
                ],
                "residual_parameters": parameters,
                "residual_common_gcd_degree": 0,
                "residual_H_degree": 4,
                "section_equations_zero": True,
                "graph_identity_zero": True,
                "jacobian_rank_of_13_equations": rank,
                "projective_local_dimension_if_smooth": 18 - rank,
            }
            break
        if selected is not None:
            break
    assert selected is not None
    return {
        "schema": "m3-two-prime-gcd-free-residual-section-v1",
        "scope": "split good-reduction component evidence only",
        "prime": prime,
        "zeta11": zeta,
        "usable_involution_line_sections": len(sections),
        **selected,
        "theorem_boundary": (
            "This is a genuine section over the frozen finite field, not a "
            "K_Schur-rational section or an invariant characteristic-zero branch."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, required=True, choices=(23, 67))
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    payload = build(args.prime)
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.write:
        output = HERE / f"modular_residual_section_p{args.prime}.json"
        output.write_text(text)
        print(f"WROTE {output}")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
