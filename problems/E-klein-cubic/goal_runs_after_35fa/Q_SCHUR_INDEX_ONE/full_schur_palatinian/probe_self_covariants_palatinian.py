#!/usr/bin/env python3
"""Exact F_23 discovery for low-degree V6 self-covariants landing on I4=0."""

from __future__ import annotations

import importlib.util
import sys
from itertools import product
from pathlib import Path

import numpy as np

ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
FANO_SRC = ROOT / "tmp/fano14_twist/fano_covariant_scan.py"
spec = importlib.util.spec_from_file_location("fano_self_probe", FANO_SRC)
assert spec and spec.loader
fano = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = fano
spec.loader.exec_module(fano)

P = fano.P


def monomials(degree: int, variables: int):
    out = []
    def rec(prefix, left, slots):
        if slots == 1:
            out.append(prefix + (left,))
            return
        for x in range(left + 1):
            rec(prefix + (x,), left - x, slots - 1)
    rec((), degree, variables)
    return out


def add_row(echelon, row):
    row = np.asarray(row, dtype=np.int64) % P
    for pivot, old in echelon:
        if row[pivot]:
            row = (row - row[pivot] * old) % P
    nz = np.flatnonzero(row)
    if len(nz) == 0:
        return False
    pivot = int(nz[0])
    row = row * pow(int(row[pivot]), -1, P) % P
    echelon.append((pivot, row))
    return True


class Probe:
    def __init__(self):
        generators = fano.six_dimensional_generators()
        raw = fano.generate_group(generators)
        assert len(raw) == 1320
        self.group = np.stack(raw)
        self.inverse = np.stack([fano.inv(g) for g in raw])
        self.rng = np.random.default_rng(2026080102)
        self.selection = [self.rng.integers(0, P, 6, dtype=np.int64) for _ in range(8)]

    def eval_seed(self, output: int, exponents: tuple[int, ...], point: np.ndarray) -> np.ndarray:
        transformed = np.einsum("gij,j->gi", self.group, point, optimize=True) % P
        values = np.ones(len(self.group), dtype=np.int64)
        for i, e in enumerate(exponents):
            if e:
                values = values * np.power(transformed[:, i], e) % P
        # Reynolds: g^{-1}(m(gx)e_output)
        return np.einsum("g,gij,j->i", values, self.inverse, np.eye(6, dtype=np.int64)[output], optimize=True) % P

    def basis(self, degree: int, expected: int):
        echelon = []
        basis = []
        for exponents, output in product(monomials(degree, 6), range(6)):
            row = np.concatenate([self.eval_seed(output, exponents, p) for p in self.selection])
            if add_row(echelon, row):
                basis.append((output, exponents))
                if len(basis) == expected:
                    return basis
        raise AssertionError((degree, len(basis), expected))

    def invariant_quartic(self, point: np.ndarray) -> int:
        transformed = np.einsum("gij,j->gi", self.group, point, optimize=True) % P
        return int(np.sum(np.power(transformed[:, 5], 4), dtype=np.int64) % P)


def main() -> None:
    probe = Probe()
    for degree, expected in [(1, 1), (3, 1), (5, 3), (7, 8)]:
        basis = probe.basis(degree, expected)
        print(f"degree={degree} basis={basis}")
        samples = []
        for seed in basis:
            vals = []
            for _ in range(16):
                x = probe.rng.integers(0, P, 6, dtype=np.int64)
                vals.append(probe.invariant_quartic(probe.eval_seed(*seed, x)))
            samples.append(vals)
        print(f"degree={degree} I4(each basis)={samples}")
        print(f"degree={degree} individual_landers={[all(v == 0 for v in vals) for vals in samples]}")
        if degree == 7:
            for point in probe.selection:
                matrix = np.stack([probe.eval_seed(*seed, point) for seed in basis[:6]], axis=1)
                det = int(round(np.linalg.det(matrix))) % P
                # Exact modular rank is the relevant check; determinant print is discovery only.
                print(f"degree7_frame_witness={point.tolist()} rank={fano.rank(matrix)} det_float_mod={det}")
                if fano.rank(matrix) == 6:
                    break


if __name__ == "__main__":
    main()
