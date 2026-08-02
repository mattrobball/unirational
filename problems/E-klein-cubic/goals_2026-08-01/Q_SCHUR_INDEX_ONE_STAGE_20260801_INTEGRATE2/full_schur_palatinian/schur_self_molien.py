#!/usr/bin/env python3
"""Exact CRT multiplicities for Schur self-covariants V6 -> V6."""

from __future__ import annotations

import importlib.util
import sys
from math import comb
from pathlib import Path

ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
SRC = ROOT / "tmp/projective_source/character_scan.py"
spec = importlib.util.spec_from_file_location("schur_chars_self", SRC)
assert spec and spec.loader
chars = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = chars
spec.loader.exec_module(chars)


def scan(prime: int, maximum: int) -> tuple[int, list[int]]:
    zeta = chars.configure_prime(prime)
    paired = chars.paired_schur_group()
    totals = [0] * (maximum + 1)
    for v, _ in paired:
        sym = chars.complete_symmetric_traces(chars.FANO.inv(v), maximum)
        target_trace = int(v.trace() % prime)
        for d in range(maximum + 1):
            totals[d] = (totals[d] + sym[d] * target_trace) % prime
    inv_order = pow(len(paired), -1, prime)
    return zeta, [x * inv_order % prime for x in totals]


def main() -> None:
    # Three CRT primes dominate the elementary coefficient bound through d=7,
    # which is exactly the range certified by this packet.
    maximum = 7
    primes = [23, 67, 89]
    scans = []
    for p in primes:
        z, values = scan(p, maximum)
        scans.append(values)
        print(f"prime={p} zeta={z}")
    for d in range(maximum + 1):
        residues = [row[d] for row in scans]
        value, modulus = chars.crt(residues, primes)
        upper = 6 * comb(d + 5, 5)
        assert modulus > upper
        print(f"{d:2d} {value:6d} residues={residues} upper={upper}")


if __name__ == "__main__":
    main()
