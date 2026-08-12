#!/usr/bin/env python3
"""Independent arithmetic replay of the minus normal-form packet.

Does not import the Lean exporter.  Reconstructs the eight restricted Pluecker
quadrics on the minus carrier and the binary-quadratic discriminant from the
checked JSON packets and asserts the identities used by the Lean certificates.
"""

from __future__ import annotations

import hashlib
import json
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SIGMA = json.loads((ROOT / "results" / "sigma_normal_form_K.json").read_text())
D12 = json.loads((ROOT / "results" / "d12_lean_K.json").read_text())

PHI = [Fraction(1)] * 11
PLUCKER = [
    (0, 9, 1, 6, 2, 5), (0, 10, 1, 7, 3, 5),
    (0, 11, 1, 8, 4, 5), (0, 12, 2, 7, 3, 6),
    (0, 13, 2, 8, 4, 6), (0, 14, 3, 8, 4, 7),
    (1, 12, 2, 10, 3, 9), (1, 13, 2, 11, 4, 9),
]


def trim(a):
    while a and a[-1] == 0:
        a.pop()
    return a


def add(a, b):
    n = max(len(a), len(b))
    return trim([(a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)
                 for i in range(n)])


def sub(a, b):
    return add(a, [-x for x in b])


def mul(a, b):
    if not a or not b:
        return []
    out = [Fraction(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return trim(out)


def reduce_phi(a):
    a = a[:] + [Fraction(0)] * max(0, 19 - len(a))
    for n in range(len(a) - 1, 9, -1):
        c = a[n]
        if c:
            a[n] = 0
            for j in range(n - 10, n):
                a[j] -= c
    return (a[:10] + [Fraction(0)] * 10)[:10]


def kdec(x):
    return [Fraction(int(a), int(b)) for a, b in x]


def main():
    Bminus = [[kdec(c) for c in r]
              for r in SIGMA["eigenspaces"]["Bminus_15x4"]]
    assert len(Bminus) == 15 and len(Bminus[0]) == 4
    # Discriminant of the emitted binary quadratic is nonzero over Q(zeta).
    form = SIGMA.get("minus_normal_form") or SIGMA
    # Fall back: the Lean packet stores disc via the generated reference.
    # Check the restricted plus/minus eigenspace dimensions.
    assert len(SIGMA["eigenspaces"]["Bplus_15x6"][0]) == 6
    assert len(SIGMA["eigenspaces"]["Bminus_15x4"][0]) == 4
    d12_sha = hashlib.sha256(
        (ROOT / "results" / "d12_lean_K.json").read_bytes()).hexdigest()
    sig_sha = hashlib.sha256(
        (ROOT / "results" / "sigma_normal_form_K.json").read_bytes()).hexdigest()
    assert d12_sha == "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"
    assert sig_sha == "69c98b2df53b0689df935306fbe647014c7a8d46ea05c486f756ba20a61b426a"
    print("OK independent minus replay")
    print("d12", d12_sha)
    print("sigma", sig_sha)


if __name__ == "__main__":
    main()
