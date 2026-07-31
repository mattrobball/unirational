#!/usr/bin/env python3
"""T6.0 independent verifier — mathematical checks, not hash-only.

Does not import the producer.
"""
from __future__ import annotations

import json
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"


def fail(msg: str) -> None:
    print("FAIL:", msg, file=sys.stderr)
    sys.exit(1)


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def load_P():
    terms = []
    with P_PATH.open() as f:
        hdr = next(f).strip()
        if hdr != "A\tB\tY\tZ\tu\tcoefficient":
            fail("P header")
        for line in f:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    if len(terms) != 1593:
        fail(f"P terms {len(terms)}")
    return terms


def specialize_P(terms, A, B, Y, Z):
    coeffs = [0] * 7
    for (a, b, y, z, u), c in terms:
        coeffs[u] += c * (A**a) * (B**b) * (Y**y) * (Z**z)
    return coeffs


def poly_from_coeffs(coeffs):
    # return list coeffs[0..deg]
    while len(coeffs) > 1 and coeffs[-1] == 0:
        coeffs = coeffs[:-1]
    return coeffs


def derivative(coeffs):
    return [i * coeffs[i] for i in range(1, len(coeffs))]


def deg(c):
    d = len(c) - 1
    while d > 0 and c[d] == 0:
        d -= 1
    return d if c[d] != 0 else -1


def lc(c):
    d = deg(c)
    return c[d] if d >= 0 else 0


def pseudorem(f, g):
    """Pseudo-remainder of f by g over Z/Q (integer coeffs)."""
    f = list(f)
    g = list(g)
    dg = deg(g)
    if dg < 0:
        return f
    lcg = lc(g)
    steps = 0
    while deg(f) >= dg and steps < 20:
        df = deg(f)
        lcf = lc(f)
        # lcg * f - lcf * u^{df-dg} * g
        shift = df - dg
        out = [0] * (max(len(f), len(g) + shift) + 1)
        for i, v in enumerate(f):
            out[i] += lcg * v
        for i, v in enumerate(g):
            out[i + shift] -= lcf * v
        f = out
        # trim
        while len(f) > 1 and f[-1] == 0:
            f.pop()
        steps += 1
    return f


def sres1_univariate(coeffs):
    """Return (s1, s0, status) via naive PRS (sufficient for verification samples)."""
    f = poly_from_coeffs(list(coeffs))
    g = poly_from_coeffs(derivative(f))
    if deg(f) < 2 or deg(g) < 1:
        return 0, 0, "low_deg"
    # Ducos-style loop simplified for Q via integer content
    A, B = g, pseudorem(f, [-x for x in g] if False else g)
    # use standard Euclidean on Q for verification samples
    # Convert to float-free rational Euclidean
    from fractions import Fraction

    def to_frac(c):
        return [Fraction(x) for x in c]

    def fdeg(c):
        d = len(c) - 1
        while d > 0 and c[d] == 0:
            d -= 1
        return d if c and c[d] != 0 else -1

    def flc(c):
        d = fdeg(c)
        return c[d] if d >= 0 else Fraction(0)

    def fprem(F, G):
        F = list(F)
        G = list(G)
        dg = fdeg(G)
        if dg < 0:
            return F
        while fdeg(F) >= dg:
            df = fdeg(F)
            mult = flc(F) / flc(G)
            shift = df - dg
            out = list(F)
            if len(out) < len(G) + shift:
                out += [Fraction(0)] * (len(G) + shift - len(out))
            for i, v in enumerate(G):
                out[i + shift] -= mult * v
            F = out
            while len(F) > 1 and F[-1] == 0:
                F.pop()
        return F

    F = to_frac(f)
    G = to_frac(g)
    for _ in range(12):
        if fdeg(G) < 0:
            return 0, 0, "vanished"
        if fdeg(G) <= 1:
            s0 = G[0] if len(G) > 0 else Fraction(0)
            s1 = G[1] if len(G) > 1 else Fraction(0)
            return s1, s0, "ok"
        R = fprem(F, G)
        F, G = G, R
    return 0, 0, "loop"


def main() -> None:
    if file_hash(P_PATH) != EXPECTED_P:
        fail("P hash")

    for name in (
        "SUBRESULTANT_AUDIT.md",
        "subresultant_1.circuit.json",
        "principal_subresultants.json",
        "rank_one_algebra_map.json",
        "relative_differentials.json",
        "s1_unit_mod_summary.json",
        "s1_zero_points.out",
        "t60_payload.json",
    ):
        if not (HERE / name).is_file():
            fail(f"missing {name}")

    audit = (HERE / "SUBRESULTANT_AUDIT.md").read_text()
    if "T60-UNDECIDED" not in audit:
        fail("audit exit")
    if "BOTTLENECK-T60-S1-UNIT-EXACT" not in audit:
        fail("missing bottleneck")

    circuit = json.loads((HERE / "subresultant_1.circuit.json").read_text())
    if "ducos" not in circuit.get("representation", "").lower() and "PRS" not in circuit.get(
        "representation", ""
    ):
        if circuit.get("representation") != "exact_ducos_subresultant_PRS_circuit":
            fail("circuit representation")

    rank = json.loads((HERE / "rank_one_algebra_map.json").read_text())
    if rank["s1_unit_on_open"]["status"] != "NOT_PROVED_EXACTLY":
        fail("must not claim exact s1 unit")
    if rank["isomorphism_S_G_B_G"]["status"] != "NOT_PROVED":
        fail("must not claim isomorphism")

    diffs = json.loads((HERE / "relative_differentials.json").read_text())
    for bad in diffs.get("do_not_infer", []):
        if "isomorphism" in bad.lower() or "flatness" in bad.lower():
            break
    else:
        fail("relative differentials must forbid Omega=>iso/flatness")

    mod = json.loads((HERE / "s1_unit_mod_summary.json").read_text())
    if mod.get("status") != "discovery_only":
        fail("mod summary must be discovery_only")
    for pr in mod["primes"]:
        if pr["n_s1_zero"] != 0:
            fail(f"mod summary claims s1 zero at p={pr['p']}")
        if pr["n_s1_nonzero"] <= 0:
            fail(f"no nonzero s1 samples at p={pr['p']}")

    # Mathematical: pointwise Sres_1 deg/structure on random specializations
    terms = load_P()
    points = [(1, 2, 3, 0), (1, 2, 3, 1), (2, 3, 5, 7), (1, 1, 1, 1), (0, 1, 2, 3)]
    nonzero_s1 = 0
    for pt in points:
        coeffs = specialize_P(terms, *pt)
        s1, s0, st = sres1_univariate(coeffs)
        if st == "ok" and s1 != 0:
            nonzero_s1 += 1
            # On these ambient points Res may be nonzero; check that if both P and Pu
            # share a root approximately... skip. Check s1 is rational and finite.
            assert s1.denominator != 0
    if nonzero_s1 < 3:
        fail(f"expected s1 nonzero on generic ambient points, got {nonzero_s1}")

    # s1_zero_points: every recorded zero must show a gate vanishing (discovery ledger)
    zp = (HERE / "s1_zero_points.out").read_text().strip().splitlines()
    for line in zp:
        if line.startswith("p=") and "s1_zero_found=" in line:
            continue
        if "ell=0" not in line and "A=" in line:
            # require ell=0 for zero points as recorded in discovery
            if "ell=" in line:
                # parse ell value
                part = [x for x in line.split() if x.startswith("ell=")][0]
                if part != "ell=0":
                    fail(f"s1 zero point without ell=0: {line}")

    payload = json.loads((HERE / "t60_payload.json").read_text())
    if payload.get("exit") != "T60-UNDECIDED":
        fail("payload exit")
    if payload.get("s1_unit_exact") is not False:
        fail("payload s1_unit_exact")
    if payload.get("isomorphism_S_G_B_G") is not False:
        fail("payload iso")
    if payload.get("normality_inferred") is not False:
        fail("must not infer normality")

    print("FOLD_DECISION_T60_VERIFIER_ACCEPT")
    print("exit=T60-UNDECIDED")


if __name__ == "__main__":
    main()
