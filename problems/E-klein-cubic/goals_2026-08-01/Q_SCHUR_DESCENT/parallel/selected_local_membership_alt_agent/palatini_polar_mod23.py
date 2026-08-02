#!/usr/bin/env python3
"""Exact good-fibre audit of the polar/self-covariant distinction."""

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import numpy as np


ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
CORE_PATH = (
    ROOT
    / "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/"
    "full_schur_palatinian_point_next/pencil_mod23.py"
)
FANO_PATH = ROOT / "tmp/fano14_twist/fano_covariant_scan.py"


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def derivative(polynomial, variable: int, modulus: int):
    answer = {}
    for monomial, coefficient in polynomial.items():
        exponent = monomial[variable]
        if not exponent:
            continue
        reduced = list(monomial)
        reduced[variable] -= 1
        value = coefficient * exponent % modulus
        if value:
            answer[tuple(reduced)] = value
    return answer


def scale_add(polynomials, coefficients, modulus: int):
    answer = {}
    for polynomial, coefficient in zip(polynomials, coefficients):
        for monomial, value in polynomial.items():
            new_value = (answer.get(monomial, 0) + int(coefficient) * value) % modulus
            if new_value:
                answer[monomial] = new_value
            else:
                answer.pop(monomial, None)
    return answer


def proportional(left, right, modulus: int):
    support = set(left) | set(right)
    pivot = next((m for m in support if right.get(m, 0)), None)
    assert pivot is not None
    scalar = left.get(pivot, 0) * pow(right[pivot], -1, modulus) % modulus
    if all(left.get(m, 0) == scalar * right.get(m, 0) % modulus for m in support):
        return scalar
    return None


def invariant_bilinear_forms(generators, fano):
    # Flatten J by row.  Each equation in M^T J M-J is linear in its entries.
    rows = []
    for matrix in generators:
        for i in range(6):
            for j in range(6):
                row = np.zeros(36, dtype=np.int64)
                for a in range(6):
                    for b in range(6):
                        row[6 * a + b] += matrix[a, i] * matrix[b, j]
                row[6 * i + j] -= 1
                rows.append(row % fano.P)
    return fano.nullspace(np.stack(rows))


def commuting_endomorphisms(generators, fano):
    rows = []
    for matrix in generators:
        for i in range(6):
            for j in range(6):
                row = np.zeros(36, dtype=np.int64)
                # (X M - M X)_{ij}=0.
                for a in range(6):
                    row[6 * i + a] += matrix[a, j]
                    row[6 * a + j] -= matrix[i, a]
                rows.append(row % fano.P)
    return fano.nullspace(np.stack(rows))


def main() -> None:
    core = load("palatini_polar_core", CORE_PATH)
    fano = load("palatini_polar_fano", FANO_PATH)
    quartic, cubic = core.reconstruct()
    assert quartic and all(cubic)
    generators = fano.six_dimensional_generators()
    centralizer = commuting_endomorphisms(generators, fano)
    print(f"COMMUTING_ENDOMORPHISM_DIM={centralizer.shape[1]}")
    assert centralizer.shape[1] == 1
    forms = invariant_bilinear_forms(generators, fano)
    print(f"INVARIANT_BILINEAR_FORM_DIM={forms.shape[1]}")
    assert forms.shape[1] == 0
    gradient = [derivative(quartic, index, fano.P) for index in range(6)]
    assert all(gradient)
    print(f"I4_GRADIENT_COMPONENT_TERMS={[len(component) for component in gradient]}")
    print(f"Q3_SELF_COVARIANT_COMPONENT_TERMS={[len(component) for component in cubic]}")
    print("POLAR_LANDS_IN_DUAL_NOT_V6_MOD23_OK")


if __name__ == "__main__":
    main()
