#!/usr/bin/env python3
"""Independent verifier for Goal H5.

Does not import produce.py.  Reconstructs the cyclic trace form from the
H4-bound field data, checks the input manifest hashes, replays modular
sample points, and re-runs a subset of the constructive identity screens.
"""

from __future__ import annotations

from hashlib import sha256
import itertools
import json
from pathlib import Path
import random


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H4 = ROOT / "goal_runs_after_35fa" / "H_11_5_TWIST"
GOAL = ROOT / "goals_after_bd610a" / "GOAL_H5_11_5_TRACE_CUBIC_DECISION.md"

WEIGHTS = (1, 9, 4, 3, 5)
R_EXPONENTS = (
    (-2, 1, 1, 0, 0),
    (0, -2, 1, 1, 0),
    (0, 0, -2, 1, 1),
    (1, 0, 0, -2, 1),
    (1, 1, 0, 0, -2),
)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def mod_inv(x: int, p: int) -> int:
    return pow(x, -1, p)


def random_r(p: int, rng: random.Random):
    for _ in range(4000):
        head = [rng.randrange(1, p) for _ in range(4)]
        prod = 1
        for x in head:
            prod = prod * x % p
        r = head + [mod_inv(prod, p)]
        if 0 not in r and len(set(r)) == 5:
            return r
    return None


def mon(r, exp, p):
    v = 1
    for i, e in enumerate(exp):
        v = v * pow(r[i], e, p) % p
    return v


def sigma_exp(exp):
    return (exp[4], exp[0], exp[1], exp[2], exp[3])


def phi_from_orbit(avals, r, p):
    total = 0
    for i in range(5):
        total = (
            total
            + mod_inv(r[(i + 2) % 5], p)
            * (avals[i] * avals[i] % p)
            * avals[(i + 1) % 5]
        ) % p
    return total


def orbit_from_terms(terms, r, p):
    out = []
    cur = terms
    for _ in range(5):
        val = 0
        for c, exp in cur:
            val = (val + (c % p) * mon(r, exp, p)) % p
        out.append(val)
        cur = [(c, sigma_exp(exp)) for c, exp in cur]
    return out


def eval_Z_orbit(z, r, p):
    return [sum(z[j] * pow(r[i], j, p) for j in range(5)) % p for i in range(5)]


def determinant(a):
    from fractions import Fraction

    work = [[Fraction(x) for x in row] for row in a]
    out = Fraction(1)
    n = len(work)
    for column in range(n):
        pivot = next((i for i in range(column, n) if work[i][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            out = -out
        value = work[column][column]
        out *= value
        for i in range(column + 1, n):
            scale = work[i][column] / value
            for j in range(column, n):
                work[i][j] -= scale * work[column][j]
    return int(out)


def main() -> None:
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    assert manifest["format"] == "H5-11_5-INPUT-MANIFEST-v1"
    assert manifest["h4_exit"] == "H-11_5-NORM-MODEL-PASS"

    for key, meta in manifest["inputs"].items():
        path = ROOT / meta["path_relative_to_problem"]
        assert path.is_file(), path
        assert digest(path) == meta["sha256"], key

    # H4 decision still undecided on the point.
    h4_decision = json.loads((H4 / "decision.json").read_text())
    assert h4_decision["rational_point_over_K"] is None
    assert h4_decision["exit"] == "H-11_5-NORM-MODEL-PASS"

    field = json.loads((H4 / "field_model.json").read_text())
    norm = json.loads((H4 / "norm_model.json").read_text())
    twist = json.loads((H4 / "twist_model.json").read_text())

    # Lattice / group audit independent of produce.
    assert all(sum(row) == 0 for row in R_EXPONENTS)
    assert all(sum(a * b for a, b in zip(row, WEIGHTS)) % 11 == 0 for row in R_EXPONENTS)
    exponent_minor = [[R_EXPONENTS[j][i] for j in range(4)] for i in range(1, 5)]
    assert determinant(exponent_minor) == 11
    assert field["C11_invariants"]["four_by_four_exponent_determinant"] == 11
    assert field["fields"]["degrees"]["E_over_K"] == 5

    # Reconstruct Phi on the H4 common-open witness and match cubic coeffs.
    common = twist["common_open_good_reduction_witness"]
    p = common["prime"]
    assert p == 89
    r = common["r"]
    prod = 1
    for x in r:
        prod = prod * x % p
    assert prod == 1

    def compositions(total, length):
        if length == 1:
            yield (total,)
            return
        for first in range(total + 1):
            for rest in compositions(total - first, length - 1):
                yield (first,) + rest

    out = {e: 0 for e in compositions(3, 5)}
    for i in range(5):
        c = mod_inv(r[(i + 2) % 5], p)
        left = [pow(r[i], j, p) for j in range(5)]
        right = [pow(r[(i + 1) % 5], j, p) for j in range(5)]
        for j, k, ell in itertools.product(range(5), repeat=3):
            exponents = [0] * 5
            exponents[j] += 1
            exponents[k] += 1
            exponents[ell] += 1
            key = tuple(exponents)
            out[key] = (out[key] + c * left[j] * left[k] * right[ell]) % p
    rebuilt = {",".join(map(str, k)): v for k, v in sorted(out.items()) if v}
    assert rebuilt == common["trace_twist_coefficients"]

    # Norm of c = r2^{-1} is 1 on the witness.
    c_norm = 1
    for i in range(5):
        c_norm = c_norm * mod_inv(r[(2 + i) % 5], p) % p
    assert c_norm == 1

    # Order-11 witness from H4: d = r1 r2^6 r3^{-2} r4^2 has psi(d)=r2^{11}.
    d_exp = (0, 1, 6, -2, 2)  # exponents of r0..r4 for d
    # psi(d)=d^2 sigma(d) => exp (2I+S) v
    # S cycles exponents: sigma(r_i)=r_{i+1} means exponent vector rotates
    # If d = prod r_i^{v_i}, sigma(d)=prod r_i^{v_{i-1}} = prod r_i^{v_{i+4}}
    v = list(d_exp)
    sv = [v[(i - 1) % 5] for i in range(5)]  # exponent of r_i in sigma(d) is v_{i-1}
    psi = [(2 * v[i] + sv[i]) for i in range(5)]
    # r2^{11} has exp (0,0,11,0,0)
    # reduce mod product relation: may add n(1,1,1,1,1)
    target = [0, 0, 11, 0, 0]
    diff = [psi[i] - target[i] for i in range(5)]
    assert len(set(diff)) == 1  # equal components => multiple of (1,1,1,1,1)

    # Packet decision integrity.
    decision = json.loads((HERE / "decision.json").read_text())
    assert decision["exit"] == "H5-UNDECIDED"
    assert decision["headline"] == "OPEN"
    assert decision["rational_point_over_K"] is None
    assert decision["pointlessness"] is None

    point = json.loads((HERE / "point.json").read_text())
    assert point["rational_point_over_K"] is None

    coeff = json.loads((HERE / "coefficient_class.json").read_text())
    assert coeff["order_modulo_psi"] == 11
    assert "FORBIDDEN" in coeff["promotion"]

    valuation = json.loads((HERE / "valuation_ledger.json").read_text())
    assert valuation["verdict"] == "structural_inventory_only"

    constructive = json.loads((HERE / "constructive_search.json").read_text())
    assert constructive["any_identity_hit"] is False
    assert constructive["points_found_over_K"] == []

    modular = json.loads((HERE / "modular_screen.json").read_text())
    # Replay every recorded sample point.
    for row in modular["rows"]:
        if row["sample_r"] is None:
            continue
        p = row["prime"]
        r = row["sample_r"]
        z = row["sample_z"]
        assert phi_from_orbit(eval_Z_orbit(z, r, p), r, p) == 0
        assert any(z)

    # Independent subset of identity screens: constant z box {-2..2}, additive bound 1.
    rng = random.Random(4242)

    def identity_zero(make_terms, primes=(31, 41, 61, 71, 101), trials=8):
        saw = False
        for p in primes:
            for _ in range(trials):
                r = random_r(p, rng)
                if r is None:
                    continue
                terms = make_terms(p)
                avals = orbit_from_terms(terms, r, p)
                if all(x == 0 for x in avals):
                    continue
                saw = True
                if phi_from_orbit(avals, r, p) != 0:
                    return False
        return saw

    # A few explicit constant z must fail (witness non-identity).
    for zs in ((1, 0, 0, 0, 0), (1, 1, 1, 1, 1), (1, -1, 0, 0, 0), (0, 1, 0, -1, 0)):

        def make(p, zs=zs):
            terms = []
            for j, z in enumerate(zs):
                if z:
                    exp = [0] * 5
                    exp[0] = j
                    terms.append((z % p, tuple(exp)))
            return terms

        assert identity_zero(make) is False

    # Additive monoms that are nondegenerate must fail.
    for e in ((1, 0, 0, 0, 0), (1, -1, 0, 0, 0), (2, 0, -1, 0, 0), (1, 1, 0, -1, 0)):

        def make(p, e=e):
            return [(1, e), ((-1) % p, sigma_exp(e))]

        assert identity_zero(make) is False

    # Pure monom replay: must fail.
    def make_mon(p, e=(1, 0, 0, 0, -1)):
        return [(1, e)]

    assert identity_zero(make_mon) is False

    # Holdout prime not used as the sole discovery certificate: check p=199 sample if present.
    row199 = next(r for r in modular["rows"] if r["prime"] == 199)
    if row199["sample_z"] is not None:
        p = 199
        assert (
            phi_from_orbit(
                eval_Z_orbit(row199["sample_z"], row199["sample_r"], p),
                row199["sample_r"],
                p,
            )
            == 0
        )

    # Trace cubic payload equation matches H4.
    trace = json.loads((HERE / "TRACE_CUBIC.json").read_text())
    assert "Tr_{E/K}(r2^{-1} a^2 sigma(a))" in trace["equation"]
    assert norm["cyclic_coefficient"]["c"] == "beta^2*sigma(beta)=r2^-1"

    # Ensure STATUS exists and declares the authorized exit.
    status = (HERE / "STATUS.md").read_text()
    assert "H5-UNDECIDED" in status
    assert "OPEN" in status

    # Seal integrity (SEAL.json excludes its own hash).
    seal_path = HERE / "SEAL.json"
    if seal_path.is_file():
        seal = json.loads(seal_path.read_text())
        assert seal["format"] == "H5-11_5-TRACE-CUBIC-SEAL-v1"
        assert seal["exit"] == "H5-UNDECIDED"
        durable = {
            path.relative_to(HERE).as_posix(): digest(path)
            for path in HERE.rglob("*")
            if path.is_file()
            and path.name != "SEAL.json"
            and path.suffix != ".pyc"
            and "__pycache__" not in path.parts
            and path.name != ".DS_Store"
        }
        assert durable == seal["files"], sorted(set(durable) ^ set(seal["files"]))

    print("H5_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
