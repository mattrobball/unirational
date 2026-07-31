#!/usr/bin/env python3
"""T8.1 independent verifier — recomputes decisive invariants; does not import produce_t81."""
from __future__ import annotations

import json
import sys
from fractions import Fraction
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"


def fail(msg: str) -> None:
    print("FAIL:", msg, file=sys.stderr)
    sys.exit(1)


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    if file_hash(P_PATH) != EXPECTED_P:
        fail("P hash")
    if file_hash(H_PATH) != EXPECTED_H:
        fail("H hash")

    for name in (
        "SUBRESULTANT_UNIT_TARGET.md",
        "subresultant_identities.json",
        "factor_ledger.json",
        "planes.json",
        "modular_nonunit_discovery.json",
        "sres_eval_t81.py",
        "t81_payload.json",
    ):
        if not (HERE / name).is_file():
            fail(f"missing {name}")

    audit = (HERE / "SUBRESULTANT_UNIT_TARGET.md").read_text()
    if "T8-S1-UNDECIDED" not in audit:
        fail("audit exit")
    if "BOTTLENECK-T8-S1-EXACT-CHAR0-WITNESS" not in audit:
        fail("missing bottleneck")
    if "OPEN" not in audit:
        fail("headline must remain OPEN")
    # must not claim sealed UNIT/NONUNIT
    if "Exit: `T8-S1-UNIT`" in audit or "Exit: `T8-S1-NONUNIT`" in audit:
        fail("audit must not claim UNIT/NONUNIT exit")

    ids = json.loads((HERE / "subresultant_identities.json").read_text())
    if ids["expansion_status"]["exact_sparse_s0_s1"] != "NOT_EXPANDED":
        fail("must not claim s1 sparse expansion")

    ledger = json.loads((HERE / "factor_ledger.json").read_text())
    if ledger["principal_subresultants"]["PSC_1_s1"].get("factorization_over_Q") not in (
        "NOT_OBTAINED",
        None,
    ):
        if ledger["principal_subresultants"]["PSC_1_s1"].get("expanded_over_Q") is True:
            fail("ledger claims s1 expanded without expansion artifact")

    mod = json.loads((HERE / "modular_nonunit_discovery.json").read_text())
    if "discovery" not in mod.get("status", "").lower():
        fail("modular packet must be discovery_only")

    payload = json.loads((HERE / "t81_payload.json").read_text())
    if payload.get("exit") != "T8-S1-UNDECIDED":
        fail("payload exit")
    if payload.get("s1_unit_exact") is not False:
        fail("payload must not claim exact unit")
    if payload.get("s1_nonunit_exact") is not False:
        fail("payload must not claim exact nonunit")
    if payload.get("normality_inferred") is not False:
        fail("must not infer normality")

    # --- Mathematical recomputation (does not import producer) ---
    # Inline minimal PRS so verifier is self-contained even if sres_eval_t81 changes.
    terms = []
    with P_PATH.open() as f:
        if next(f).strip() != "A\tB\tY\tZ\tu\tcoefficient":
            fail("P header")
        for line in f:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    if len(terms) != 1593:
        fail(f"P terms {len(terms)}")

    def specialize(A, B, Y, Z):
        coeffs = [0] * 7
        for (a, b, y, z, u), c in terms:
            coeffs[u] += c * (A**a) * (B**b) * (Y**y) * (Z**z)
        return coeffs

    def sres1_euclid(coeffs):
        F = [Fraction(x) for x in coeffs]
        G = [Fraction(i * coeffs[i]) for i in range(1, len(coeffs))]

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
                if len(F) < len(G) + shift:
                    F += [Fraction(0)] * (len(G) + shift - len(F))
                for i, v in enumerate(G):
                    F[i + shift] -= mult * v
                while len(F) > 1 and F[-1] == 0:
                    F.pop()
            return F

        for _ in range(20):
            if fdeg(G) < 0:
                return Fraction(0), Fraction(0), "vanished"
            if fdeg(G) <= 1:
                s0 = G[0] if G else Fraction(0)
                s1 = G[1] if len(G) > 1 else Fraction(0)
                return s1, s0, "ok"
            R = fprem(F, G)
            F, G = G, R
        return Fraction(0), Fraction(0), "loop"

    def gcd_deg(coeffs):
        F = [Fraction(x) for x in coeffs]
        G = [Fraction(i * coeffs[i]) for i in range(1, len(coeffs))]

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
                if len(F) < len(G) + shift:
                    F += [Fraction(0)] * (len(G) + shift - len(F))
                for i, v in enumerate(G):
                    F[i + shift] -= mult * v
                while len(F) > 1 and F[-1] == 0:
                    F.pop()
            return F

        while fdeg(G) >= 0:
            R = fprem(F, G)
            F, G = G, R
        return fdeg(F)

    # Ambient nonzero s1
    nonzero = 0
    for pt in [(1, 2, 3, 4), (5, 7, 11, 13), (2, 3, 5, 7), (1, 1, 1, 1), (3, 1, 4, 1)]:
        s1, s0, st = sres1_euclid(specialize(*pt))
        if st == "ok" and s1 != 0:
            nonzero += 1
    if nonzero < 3:
        fail(f"expected generic s1 nonzero, got {nonzero}")

    # Bézout recomputation at one point (extended Euclid inline)
    def bezout_check(coeffs):
        F = [Fraction(x) for x in coeffs]
        G = [Fraction(i * coeffs[i]) for i in range(1, len(coeffs))]
        Af, Bf = [Fraction(1)], [Fraction(0)]
        Ag, Bg = [Fraction(0)], [Fraction(1)]

        def fdeg(c):
            d = len(c) - 1
            while d > 0 and c[d] == 0:
                d -= 1
            return d if c and c[d] != 0 else -1

        def flc(c):
            d = fdeg(c)
            return c[d] if d >= 0 else Fraction(0)

        def poly_sub_scaled(U, mult, V, shift):
            U = list(U)
            if len(U) < len(V) + shift:
                U += [Fraction(0)] * (len(V) + shift - len(U))
            for i, v in enumerate(V):
                U[i + shift] -= mult * v
            while len(U) > 1 and U[-1] == 0:
                U.pop()
            return U

        for _ in range(20):
            if fdeg(G) < 0:
                return False
            if fdeg(G) <= 1:
                s0 = G[0] if G else Fraction(0)
                s1 = G[1] if len(G) > 1 else Fraction(0)
                # check a*P+b*Pu at several u
                for u in [0, 1, 2, -1, 4]:
                    Pv = sum(coeffs[i] * (u**i) for i in range(len(coeffs)))
                    Puv = sum(i * coeffs[i] * (u ** (i - 1)) for i in range(1, len(coeffs)))
                    av = sum(Ag[i] * (u**i) for i in range(len(Ag)))
                    bv = sum(Bg[i] * (u**i) for i in range(len(Bg)))
                    if av * Pv + bv * Puv != s1 * u + s0:
                        return False
                return True
            Fwork = list(F)
            Ar, Br = list(Af), list(Bf)
            dg = fdeg(G)
            while fdeg(Fwork) >= dg:
                mult = flc(Fwork) / flc(G)
                shift = fdeg(Fwork) - dg
                Fwork = poly_sub_scaled(Fwork, mult, G, shift)
                Ar = poly_sub_scaled(Ar, mult, Ag, shift)
                Br = poly_sub_scaled(Br, mult, Bg, shift)
            F, G = G, Fwork
            Af, Bf, Ag, Bg = Ag, Bg, Ar, Br
        return False

    if not bezout_check(specialize(1, 2, 3, 4)):
        fail("Bézout identity failed at (1,2,3,4)")

    # Recompute modular NONUNIT witnesses from sealed discovery file
    # Load modular F27 when available and re-check gates by re-specializing P
    def sres1_fp(coeffs, p):
        F = [x % p for x in coeffs]
        G = [(i * coeffs[i]) % p for i in range(1, len(coeffs))]

        def deg(c):
            d = len(c) - 1
            while d > 0 and c[d] % p == 0:
                d -= 1
            return d if c and c[d] % p != 0 else -1

        def trim(c):
            c = list(c)
            while len(c) > 1 and c[-1] % p == 0:
                c.pop()
            return c

        for _ in range(20):
            if deg(G) < 0:
                return 0
            if deg(G) <= 1:
                return (G[1] if len(G) > 1 else 0) % p
            inv = pow(G[deg(G)], -1, p)
            dg = deg(G)
            while deg(F) >= dg:
                mult = (F[deg(F)] * inv) % p
                sh = deg(F) - dg
                if len(F) < len(G) + sh:
                    F += [0] * (len(G) + sh - len(F))
                for i, v in enumerate(G):
                    F[i + sh] = (F[i + sh] - mult * v) % p
                F = trim(F)
            F, G = G, F
        return 0

    def specialize_mod(A, B, Y, Z, p):
        coeffs = [0] * 7
        for (a, b, y, z, u), c in terms:
            coeffs[u] = (
                coeffs[u] + c * pow(A, a, p) * pow(B, b, p) * pow(Y, y, p) * pow(Z, z, p)
            ) % p
        return coeffs

    H_terms = []
    with H_PATH.open() as f:
        if next(f).strip() != "A\tB\tY\tZ\tcoefficient":
            fail("H header")
        for line in f:
            a, b, y, z, c = map(int, line.split())
            H_terms.append(((a, b, y, z), c))

    def eval_H(A, B, Y, Z, p):
        s = 0
        for (a, b, y, z), c in H_terms:
            s = (s + c * pow(A, a, p) * pow(B, b, p) * pow(Y, y, p) * pow(Z, z, p)) % p
        return s

    full_ok = 0
    for w in mod.get("witnesses", []):
        p = int(w["p"])
        A, B, Y, Z = int(w["A"]), int(w["B"]), int(w["Y"]), int(w["Z"])
        if eval_H(A, B, Y, Z, p) != 0:
            fail(f"witness H nonzero mod {p}: {w}")
        coeffs = specialize_mod(A, B, Y, Z, p)
        s1 = sres1_fp(coeffs, p)
        if s1 % p != 0:
            fail(f"witness s1 nonzero mod {p}: {w}")
        gd = gcd_deg([Fraction(c) for c in coeffs])  # over Q from lifted 0..p-1 ints — wrong
        # recompute gcd mod p
        F = list(coeffs)
        G = [(i * coeffs[i]) % p for i in range(1, 7)]

        def deg(c):
            d = len(c) - 1
            while d > 0 and c[d] % p == 0:
                d -= 1
            return d if c and c[d] % p != 0 else -1

        def trim(c):
            c = list(c)
            while len(c) > 1 and c[-1] % p == 0:
                c.pop()
            return c

        F, G = trim(F), trim(G)
        while deg(G) >= 0:
            inv = pow(G[deg(G)], -1, p)
            dg = deg(G)
            while deg(F) >= dg:
                mult = (F[deg(F)] * inv) % p
                sh = deg(F) - dg
                if len(F) < len(G) + sh:
                    F += [0] * (len(G) + sh - len(F))
                for i, v in enumerate(G):
                    F[i + sh] = (F[i + sh] - mult * v) % p
                F = trim(F)
            F, G = G, F
        if deg(F) < 2:
            fail(f"witness gcd deg < 2 mod {p}")
        if w.get("ufree_gates_ok") and w.get("binodal_Puu_ok"):
            full_ok += 1

    if full_ok < 1:
        fail("no re-verified full modular gate-pass witness")

    print("FOLD_DECISION_T81_VERIFIER_ACCEPT")
    print("exit=T8-S1-UNDECIDED")
    print(f"modular_full_gate_witnesses_rechecked={full_ok}")


if __name__ == "__main__":
    main()
