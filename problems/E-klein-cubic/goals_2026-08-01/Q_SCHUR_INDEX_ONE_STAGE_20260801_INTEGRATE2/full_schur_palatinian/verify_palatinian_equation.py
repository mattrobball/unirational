#!/usr/bin/env python3
"""Identify the rank-drop Palatini quartic with the unique Reynolds I4 mod 23."""

from __future__ import annotations

import importlib.util
import itertools
import math
import sys
from pathlib import Path

import numpy as np

ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
SRC = ROOT / "tmp/fano14_twist/fano_covariant_scan.py"
spec = importlib.util.spec_from_file_location("fano_pal_eq", SRC)
assert spec and spec.loader
fano = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = fano
spec.loader.exec_module(fano)

P = fano.P


def add(a, b, scale=1):
    out = dict(a)
    for monomial, coefficient in b.items():
        value = (out.get(monomial, 0) + scale * coefficient) % P
        if value:
            out[monomial] = value
        elif monomial in out:
            del out[monomial]
    return out


def multiply(a, b):
    out = {}
    for ma, ca in a.items():
        for mb, cb in b.items():
            monomial = tuple(x + y for x, y in zip(ma, mb))
            out[monomial] = (out.get(monomial, 0) + ca * cb) % P
    return {m:c for m,c in out.items() if c}


def permutation_sign(perm):
    inversions = sum(perm[i] > perm[j] for i in range(len(perm)) for j in range(i+1, len(perm)))
    return -1 if inversions % 2 else 1


def determinant(matrix):
    n = len(matrix)
    out = {}
    for perm in itertools.permutations(range(n)):
        term = {(0, 0, 0, 0, 0, 0): 1}
        for row, column in enumerate(perm):
            term = multiply(term, matrix[row][column])
        out = add(out, term, permutation_sign(perm))
    return out


def linear_form(coefficients):
    out = {}
    for i, coefficient in enumerate(coefficients):
        coefficient = int(coefficient % P)
        if coefficient:
            exponent = [0] * 6
            exponent[i] = 1
            out[tuple(exponent)] = coefficient
    return out


def linear_power(coefficients, degree):
    base = linear_form(coefficients)
    out = {(0, 0, 0, 0, 0, 0): 1}
    for _ in range(degree):
        out = multiply(out, base)
    return out


def main():
    domain_basis, _, _ = fano.representation_data()
    assert domain_basis.shape == (15, 5)
    forms = []
    for k in range(5):
        omega = np.zeros((6, 6), dtype=np.int64)
        for position, (i, j) in enumerate(fano.PAIRS):
            omega[i, j] = domain_basis[position, k]
            omega[j, i] = -domain_basis[position, k] % P
        forms.append(omega % P)

    # C(v) has columns omega_k v. Delete row zero; its signed maximal minor
    # equals v_0 times the rank-drop quartic, up to a scalar.
    rows = list(range(1, 6))
    matrix = []
    for row in rows:
        matrix.append([linear_form(forms[k][row]) for k in range(5)])
    minor = determinant(matrix)
    assert minor and all(monomial[0] >= 1 for monomial in minor)
    palatini = {}
    for monomial, coefficient in minor.items():
        exponent = list(monomial)
        exponent[0] -= 1
        palatini[tuple(exponent)] = coefficient
    assert {sum(m) for m in palatini} == {4}

    generators = fano.six_dimensional_generators()
    group = fano.generate_group(generators)
    assert len(group) == 1320
    reynolds = {}
    for g in group:
        reynolds = add(reynolds, linear_power(g[5], 4))
    assert reynolds
    pivot = next(iter(palatini))
    scalar = reynolds.get(pivot, 0) * pow(palatini[pivot], -1, P) % P
    assert scalar
    scaled = {m: c * scalar % P for m, c in palatini.items()}
    assert scaled == reynolds

    # All maximal minors obey the same cofactor identity.
    for deleted in range(6):
        matrix = []
        for row in range(6):
            if row == deleted:
                continue
            matrix.append([linear_form(forms[k][row]) for k in range(5)])
        current = determinant(matrix)
        predicted = {}
        for monomial, coefficient in palatini.items():
            exponent = list(monomial)
            exponent[deleted] += 1
            predicted[tuple(exponent)] = coefficient * ((-1) ** deleted) % P
        # Calibrate the sign convention from deleted zero.
        if deleted == 0:
            calibration = next(iter(current.values())) * pow(next(iter(predicted.values())), -1, P) % P
        predicted = {m: c * calibration % P for m,c in predicted.items()}
        assert current == predicted, deleted

    print(f"PALATINI_REYNOLDS_I4_IDENTITY_OK terms={len(palatini)} scalar={scalar}")
    print("PALATINI_ALL_SIX_MAXIMAL_MINOR_SYZYGIES_OK")


if __name__ == "__main__":
    main()
