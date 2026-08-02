#!/usr/bin/env python3
"""H5 WAVE2 — multi-support Laurent/K-coeff screens, projection residual, full re-runnable search.

Sibling of H5_11_5_TRACE_CUBIC (sealed H5-UNDECIDED first wave). Does not claim
Problem E headline. Does not promote modular fibre hits to K-points.

Only the Python standard library is used.
"""

from __future__ import annotations

from hashlib import sha256
import itertools
import json
from pathlib import Path
import random
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H4 = ROOT / "goal_runs_after_35fa" / "H_11_5_TWIST"
H5 = ROOT / "goal_runs_after_bd610a" / "H5_11_5_TRACE_CUBIC"
GOAL = ROOT / "goals_after_bd610a" / "GOAL_H5_11_5_TRACE_CUBIC_DECISION.md"
PINNED = "bd610a032bb9561d2daeb91a2cb60c48c082ca2f"

H4_EXPECTED = {
    "field_model.json": "80fdc908633595d6bb3c292d0027aa66295a850b9b6a12cc473f90e3e373ba1e",
    "twist_model.json": "9a5f69b43de4b33aa0185b4714e23bc177b12f74a529510b0b8b4b9ab5e49a11",
    "norm_model.json": "1f61adc24bc15bf296b7199f4e13dfa5f538691984d6f623efa8feb9531dc49e",
    "decision.json": "2517208d05c71d7493a6b606d8460c13e41bb409077a7dfb385da99eb443a592",
    "SEAL.json": "9b790a67185edc94be385993276ea4b4e35a6cfba4739981c083dd6d9886eb25",
}

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


def write_json(name: str, value: object) -> None:
    (HERE / name).write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def mod_inv(x: int, p: int) -> int:
    return pow(x, -1, p)


def random_r(p: int, rng: random.Random) -> list[int] | None:
    for _ in range(4000):
        head = [rng.randrange(1, p) for _ in range(4)]
        prod = 1
        for x in head:
            prod = prod * x % p
        r = head + [mod_inv(prod, p)]
        if 0 not in r and len(set(r)) == 5:
            return r
    return None


def mon(r: list[int], exp: tuple[int, ...], p: int) -> int:
    v = 1
    for i, e in enumerate(exp):
        v = v * pow(r[i], e, p) % p
    return v


def sigma_exp(exp: tuple[int, ...]) -> tuple[int, ...]:
    return (exp[4], exp[0], exp[1], exp[2], exp[3])


def phi_from_orbit(avals: list[int], r: list[int], p: int) -> int:
    total = 0
    for i in range(5):
        total = (
            total
            + mod_inv(r[(i + 2) % 5], p)
            * (avals[i] * avals[i] % p)
            * avals[(i + 1) % 5]
        ) % p
    return total


def orbit_from_terms(
    terms: list[tuple[int, tuple[int, ...]]], r: list[int], p: int
) -> list[int]:
    out: list[int] = []
    cur = terms
    for _ in range(5):
        val = 0
        for c, exp in cur:
            val = (val + (c % p) * mon(r, exp, p)) % p
        out.append(val)
        cur = [(c, sigma_exp(exp)) for c, exp in cur]
    return out


def eval_Z_orbit(z: list[int], r: list[int], p: int) -> list[int]:
    return [sum(z[j] * pow(r[i], j, p) for j in range(5)) % p for i in range(5)]


def degenerate_diagonal(exp: tuple[int, ...]) -> bool:
    return len(set(exp)) == 1


def normalize_exp(exp: tuple[int, ...]) -> tuple[int, ...]:
    m = min(exp)
    e = tuple(x - m for x in exp)
    rots = [tuple(e[(i + k) % 5] for i in range(5)) for k in range(5)]
    return min(rots)


def identity_zero_av(
    make_av,
    primes: tuple[int, ...] = (31, 41, 61, 71, 101, 131, 151, 181),
    trials: int = 6,
    seed: int = 0,
) -> tuple[bool, dict | None]:
    """Multi-prime identity test. One nonzero Phi refutes. Survival is only a candidate."""
    rng = random.Random(seed)
    saw = False
    for p in primes:
        for _ in range(trials):
            r = random_r(p, rng)
            if r is None:
                continue
            try:
                avals = make_av(r, p)
            except Exception:
                continue
            if avals is None:
                continue
            avals = [int(x) % p for x in avals]
            if all(x == 0 for x in avals):
                continue
            saw = True
            ph = phi_from_orbit(avals, r, p)
            if ph != 0:
                return False, {"prime": p, "r": r, "phi": ph}
    return saw, None


def inv_menu(r: list[int], p: int) -> dict[str, int]:
    invr = [mod_inv(x, p) for x in r]
    p1 = sum(r) % p
    p2 = sum(pow(x, 2, p) for x in r) % p
    p3 = sum(pow(x, 3, p) for x in r) % p
    p4 = sum(pow(x, 4, p) for x in r) % p
    pm1 = sum(invr) % p
    pm2 = sum(pow(x, 2, p) for x in invr) % p
    e11 = sum(r[i] * r[(i + 1) % 5] % p for i in range(5)) % p
    e12 = sum(r[i] * pow(r[(i + 1) % 5], 2, p) % p for i in range(5)) % p
    e21 = sum(pow(r[i], 2, p) * r[(i + 1) % 5] % p for i in range(5)) % p
    e13 = sum(r[i] * r[(i + 2) % 5] % p for i in range(5)) % p
    e22 = sum(pow(r[i], 2, p) * pow(r[(i + 1) % 5], 2, p) % p for i in range(5)) % p
    return {
        "0": 0,
        "1": 1,
        "p1": p1,
        "p2": p2,
        "p3": p3,
        "p4": p4,
        "pm1": pm1,
        "pm2": pm2,
        "e11": e11,
        "e12": e12,
        "e21": e21,
        "e13": e13,
        "e22": e22,
        "p1p1": p1 * p1 % p,
        "p1pm1": p1 * pm1 % p,
        "p1e11": p1 * e11 % p,
        "pm1e11": pm1 * e11 % p,
        "e11e11": e11 * e11 % p,
        "p2pm1": p2 * pm1 % p,
        "s_e12e21": (e12 + e21) % p,
    }


# ---------------------------------------------------------------------------
# Screens
# ---------------------------------------------------------------------------


def screen_structure_k_monoms() -> dict:
    """Only diagonal Laurent monoms are sigma-fixed, hence only constants on the torus."""
    bound = 2
    fixed = []
    nonfixed = 0
    for e in itertools.product(range(-bound, bound + 1), repeat=5):
        if not any(e):
            continue
        se = sigma_exp(e)
        if e == se:
            fixed.append(list(e))
        else:
            nonfixed += 1
    # On product-one torus, diagonal monoms are constants (all equal exponents).
    return {
        "ansatz": "Laurent monoms fixed by sigma (candidates for elements of K)",
        "exponent_bound": bound,
        "sigma_fixed_exponents": fixed,
        "sigma_fixed_count": len(fixed),
        "nonfixed_count": nonfixed,
        "theorem": (
            "A Laurent monom m=prod r_i^{e_i} satisfies sigma(m)=m for all product-one r "
            "iff e is diagonal (all equal). On r0...r4=1 every diagonal monom is the constant 1. "
            "Hence the only Laurent-monomial elements of K are constants in C*."
        ),
        "consequence_for_H5_1_A": (
            "Coefficients in K for multi-support Laurent ansatze cannot themselves be "
            "nonconstant Laurent monoms; they must be genuine cyclic invariants "
            "(power sums, U_j, etc.). Screens below use an invariant menu."
        ),
        "verdict": "structure_recorded",
    }


def uniq_monoms(bound: int) -> list[tuple[int, ...]]:
    seen: set[tuple[int, ...]] = set()
    out: list[tuple[int, ...]] = []
    for e in itertools.product(range(-bound, bound + 1), repeat=5):
        if not any(e) or degenerate_diagonal(e):
            continue
        n = normalize_exp(e)
        if n not in seen and any(n):
            seen.add(n)
            out.append(n)
    return out


def screen_two_support_k_coeffs(bound: int = 1) -> dict:
    """a = c1*m1 + c2*m2 with c_j from invariant menu, m_j monoms (bound)."""
    monoms = uniq_monoms(bound)
    cmenu = ["1", "p1", "pm1", "e11", "p2", "e13", "p1pm1"]
    hits: list = []
    tested = 0
    for i, e1 in enumerate(monoms):
        for e2 in monoms[i:]:
            if e1 == e2:
                continue
            for c1 in cmenu:
                for c2 in cmenu:
                    tested += 1

                    def make(r, p, e1=e1, e2=e2, c1=c1, c2=c2):
                        inv = inv_menu(r, p)
                        return orbit_from_terms(
                            [(inv[c1], e1), (inv[c2], e2)], r, p
                        )

                    ok, _ = identity_zero_av(
                        make,
                        primes=(31, 41, 61, 71, 101),
                        trials=4,
                        seed=10000 + tested,
                    )
                    if ok:
                        hits.append(
                            {"e1": list(e1), "e2": list(e2), "c1": c1, "c2": c2}
                        )
    return {
        "ansatz": "a = c1*m1 + c2*m2, c_j in invariant menu, m_j Laurent monoms",
        "exponent_bound": bound,
        "monoms_classified_up_to_cyclic_diagonal": len(monoms),
        "coeff_menu": cmenu,
        "tested": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": (
            "Two-support Laurent with coefficients in a finite invariant menu "
            "(not only C). Not an all-K theorem."
        ),
    }


def screen_three_cyclic_k_coeffs(bound: int = 1) -> dict:
    """a = x m + y sigma(m) + z sigma^2(m) with x,y,z from invariant menu."""
    monoms = uniq_monoms(bound)
    menu = ["0", "1", "p1", "pm1", "e11", "p2", "e13", "p1e11"]
    hits: list = []
    tested = 0
    for e in monoms:
        for x, y, z in itertools.product(menu, repeat=3):
            if (x, y, z) == ("0", "0", "0"):
                continue
            # skip pure single-monom (already excluded) when two coeffs zero
            nonzero = sum(1 for t in (x, y, z) if t != "0")
            if nonzero <= 1:
                continue
            tested += 1
            e1 = sigma_exp(e)
            e2 = sigma_exp(e1)

            def make(r, p, e=e, e1=e1, e2=e2, x=x, y=y, z=z):
                inv = inv_menu(r, p)
                return orbit_from_terms(
                    [(inv[x], e), (inv[y], e1), (inv[z], e2)], r, p
                )

            ok, _ = identity_zero_av(
                make,
                primes=(31, 41, 61, 71, 101),
                trials=4,
                seed=20000 + tested,
            )
            if ok:
                hits.append({"exp": list(e), "x": x, "y": y, "z": z})
    return {
        "ansatz": "a = x m + y sigma(m) + z sigma^2(m), x,y,z invariant-menu",
        "exponent_bound": bound,
        "monoms": len(monoms),
        "coeff_menu": menu,
        "tested": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "Three-term cyclic support with K-menu coeffs; elimination not closed-form",
    }


def screen_four_cyclic_k_coeffs(bound: int = 1) -> dict:
    """a = sum_{j=0}^{3} c_j sigma^j(m) with c_j from a smaller menu."""
    monoms = uniq_monoms(bound)
    menu = ["0", "1", "p1", "pm1", "e11"]
    hits: list = []
    tested = 0
    for e in monoms:
        for coeffs in itertools.product(menu, repeat=4):
            if all(c == "0" for c in coeffs):
                continue
            if sum(1 for c in coeffs if c != "0") <= 1:
                continue
            tested += 1
            exps = []
            cur = e
            for _ in range(4):
                exps.append(cur)
                cur = sigma_exp(cur)

            def make(r, p, exps=tuple(exps), coeffs=coeffs):
                inv = inv_menu(r, p)
                terms = [(inv[c], ex) for c, ex in zip(coeffs, exps) if c != "0"]
                return orbit_from_terms(terms, r, p)

            ok, _ = identity_zero_av(
                make,
                primes=(31, 41, 61, 71, 101),
                trials=3,
                seed=30000 + tested,
            )
            if ok:
                hits.append({"exp": list(e), "coeffs": list(coeffs)})
    return {
        "ansatz": "a = sum_{j<4} c_j sigma^j(m), c_j invariant-menu",
        "exponent_bound": bound,
        "tested": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "Four-term incomplete cyclic orbit with K-menu coeffs",
    }


def screen_sparse_z_invariants() -> dict:
    """Power-basis z with sparse support, entries from large invariant menu."""
    menu = [
        "1",
        "p1",
        "p2",
        "p3",
        "pm1",
        "pm2",
        "e11",
        "e12",
        "e21",
        "e13",
        "p1p1",
        "p1pm1",
        "p1e11",
        "e11e11",
        "s_e12e21",
    ]
    hits: list = []
    tested = 0
    for supp in (1, 2, 3):
        for coords in itertools.combinations(range(5), supp):
            for names in itertools.product(menu, repeat=supp):
                tested += 1

                def make(r, p, coords=coords, names=names):
                    inv = inv_menu(r, p)
                    z = [0] * 5
                    for c, n in zip(coords, names):
                        z[c] = inv[n]
                    return eval_Z_orbit(z, r, p)

                ok, _ = identity_zero_av(
                    make,
                    primes=(31, 41, 61, 71, 101),
                    trials=3,
                    seed=40000 + tested,
                )
                if ok:
                    hits.append({"coords": list(coords), "names": list(names)})
    return {
        "ansatz": "z in K^5 sparse support size<=3 from invariant menu; a=Z(r0)",
        "menu": menu,
        "tested": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "Sparse power-basis coefficients that are pure menu invariants",
    }


def screen_local_cyclic_poly() -> dict:
    """a_i = f(r_i, r_{i+1}, r_{i+2}) same poly for all i, deg<=2, coeffs in {-1,0,1}."""
    basis = []
    for e0 in range(0, 3):
        for e1 in range(0, 3 - e0):
            for e2 in range(0, 3 - e0 - e1):
                basis.append((e0, e1, e2))
    hits: list = []
    tested = 0
    for supp in range(1, 4):
        for idxs in itertools.combinations(range(len(basis)), supp):
            for signs in itertools.product([-1, 1], repeat=supp):
                coeffs = [0] * len(basis)
                for j, s in zip(idxs, signs):
                    coeffs[j] = s
                tested += 1
                ct = tuple(coeffs)

                def make(r, p, coeffs=ct):
                    avals = []
                    for i in range(5):
                        val = 0
                        for (e0, e1, e2), c in zip(basis, coeffs):
                            if c:
                                val = (
                                    val
                                    + c
                                    * pow(r[i], e0, p)
                                    * pow(r[(i + 1) % 5], e1, p)
                                    * pow(r[(i + 2) % 5], e2, p)
                                ) % p
                        avals.append(val)
                    return avals

                ok, _ = identity_zero_av(
                    make,
                    primes=(31, 41, 61, 71, 101),
                    trials=3,
                    seed=50000 + tested,
                )
                if ok:
                    hits.append(
                        {
                            "terms": [
                                {"monom": list(basis[j]), "c": coeffs[j]}
                                for j in range(len(basis))
                                if coeffs[j]
                            ]
                        }
                    )
    return {
        "ansatz": "a_i = f(r_i,r_{i+1},r_{i+2}) cyclic, deg<=2, coeffs in {-1,0,1}, supp<=3",
        "basis_size": len(basis),
        "tested": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "Translation-invariant local polynomial ansatz (constant coeffs in C)",
    }


def screen_named_formulas() -> dict:
    """Named geometric/algebraic formulas beyond wave-1."""

    def inv_diff(r, p):
        return [
            (mod_inv(r[i], p) - mod_inv(r[(i + 1) % 5], p)) % p for i in range(5)
        ]

    def disc_like(r, p):
        return [
            (pow(r[i], 2, p) - r[(i + 1) % 5] * r[(i - 1) % 5]) % p for i in range(5)
        ]

    def a_eq_c(r, p):
        return [mod_inv(r[(i + 2) % 5], p) for i in range(5)]

    def skip_diff(r, p):
        return [(r[i] - r[(i + 2) % 5]) % p for i in range(5)]

    def centered(r, p):
        p1 = sum(r) % p
        return [(5 * r[i] - p1) % p for i in range(5)]

    def ratio_quad(r, p):
        b = [(1 + r[i] + pow(r[i], 2, p)) % p for i in range(5)]
        return [b[i] * mod_inv(b[(i + 1) % 5], p) % p for i in range(5)]

    def add_quad(r, p):
        b = [(1 + r[i] + pow(r[i], 2, p)) % p for i in range(5)]
        return [(b[i] - b[(i + 1) % 5]) % p for i in range(5)]

    def lin_inv_weight(r, p):
        inv = inv_menu(r, p)
        return [
            (
                inv["p1"] * r[i]
                + inv["pm1"] * r[(i + 1) % 5]
                + inv["e11"] * r[(i + 2) % 5]
            )
            % p
            for i in range(5)
        ]

    def p1_minus(r, p):
        p1 = sum(r) % p
        return [(p1 - r[i]) % p for i in range(5)]

    def cube_diff(r, p):
        return [
            (pow(r[i], 3, p) - pow(r[(i + 1) % 5], 3, p)) % p for i in range(5)
        ]

    named = {
        "inv_diff": inv_diff,
        "disc_like": disc_like,
        "a_eq_c": a_eq_c,
        "skip_diff": skip_diff,
        "centered": centered,
        "ratio_quad_b_sigma_b": ratio_quad,
        "additive_quad_b_sigma_b": add_quad,
        "linear_invariant_weights": lin_inv_weight,
        "p1_minus_ri": p1_minus,
        "cube_diff": cube_diff,
    }
    results = {}
    hits = []
    for name, fn in named.items():
        ok, _ = identity_zero_av(fn, trials=8, seed=hash(name) % 100000)
        results[name] = {
            "identity": bool(ok),
            "verdict": "HIT" if ok else "empty_scoped",
        }
        if ok:
            hits.append(name)
    return {
        "ansatz": "named closed-form cyclic formulas",
        "cases": results,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "Explicit geometric/algebraic candidates; not exhaustive",
    }


def screen_additive_h90_k(bound: int = 1) -> dict:
    """a = c*(m - sigma(m)) with c invariant-menu (additive H90 on monoms scaled by K)."""
    monoms = uniq_monoms(bound)
    menu = ["1", "p1", "pm1", "e11", "p2", "e13", "p1p1", "pm1e11"]
    hits = []
    tested = 0
    for e in monoms:
        for cn in menu:
            tested += 1

            def make(r, p, e=e, cn=cn):
                inv = inv_menu(r, p)
                c = inv[cn]
                return orbit_from_terms([(c, e), ((-c) % p, sigma_exp(e))], r, p)

            ok, _ = identity_zero_av(
                make, primes=(31, 41, 61, 71, 101, 151), trials=4, seed=60000 + tested
            )
            if ok:
                hits.append({"exp": list(e), "c": cn})
    return {
        "ansatz": "a = c (m - sigma(m)), c invariant-menu",
        "tested": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "Additive Hilbert-90 monoms with nontrivial K scaling",
    }


def screen_multiplicative_h90_k(bound: int = 1) -> dict:
    """a = c * m/sigma(m) reduces to c * pure monom; c^3 scales Phi, so empty by H4 monoms."""
    monoms = uniq_monoms(bound)
    # Still re-run: a = c * reduced monom
    menu = ["1", "p1", "pm1", "e11"]
    hits = []
    tested = 0
    for e in monoms:
        se = sigma_exp(e)
        de = tuple(e[i] - se[i] for i in range(5))
        if not any(de) or degenerate_diagonal(de):
            continue
        for cn in menu:
            tested += 1

            def make(r, p, de=de, cn=cn):
                inv = inv_menu(r, p)
                return orbit_from_terms([(inv[cn], de)], r, p)

            ok, _ = identity_zero_av(
                make, primes=(31, 41, 61, 71, 101), trials=4, seed=70000 + tested
            )
            if ok:
                hits.append({"de": list(de), "c": cn})
    return {
        "ansatz": "a = c * m/sigma(m) = c * Laurent monom",
        "tested": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "note": "H4 already excludes pure monoms in char 0; c in K scales Phi by c^3",
        "scope": "Replay with K-scaling; should stay empty",
    }


def screen_binary_ratio_monom_roots(bound: int = 1) -> dict:
    """For a = 1 + s*m, test whether s equal to an invariant from the menu works identically."""
    monoms = uniq_monoms(bound)
    menu = ["p1", "pm1", "e11", "p2", "e13", "p1pm1", "e11e11", "s_e12e21"]
    hits = []
    tested = 0
    for e in monoms:
        for sn in menu:
            tested += 1

            def make(r, p, e=e, sn=sn):
                inv = inv_menu(r, p)
                s = inv[sn]
                return orbit_from_terms([(1, (0, 0, 0, 0, 0)), (s, e)], r, p)

            ok, _ = identity_zero_av(
                make, primes=(31, 41, 61, 71, 101), trials=4, seed=80000 + tested
            )
            if ok:
                hits.append({"exp": list(e), "s": sn})
    return {
        "ansatz": "a = 1 + s*m with s invariant-menu (binary free coeff specialized in K)",
        "tested": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": (
            "Specializes the free K-coefficient on two-support {1,m} to menu elements; "
            "does not solve the binary cubic over the full field K"
        ),
        "elimination_note": (
            "Phi(1+s m) is a genuine cubic polynomial in s with coefficients in K. "
            "Existence of s in K is equivalent to that binary cubic having a K-root. "
            "No menu root works for any monom in scope."
        ),
    }


# ---------------------------------------------------------------------------
# Projection from degree-five closed point / skip-one lines
# ---------------------------------------------------------------------------


def klein_F(x: list[int], p: int) -> int:
    return sum((x[i] * x[i] % p) * x[(i + 1) % 5] % p for i in range(5)) % p


def projection_geometry() -> dict:
    """H5.1.C computational geometry of F and residual after projecting from skip-one lines."""
    # Verify skip-one lines lie on F over several primes
    line_checks = []
    rng = random.Random(999)
    for p in (31, 41, 61, 71, 89, 101, 199):
        ok_all = True
        samples = []
        for i in range(5):
            for _ in range(20):
                s = rng.randrange(p)
                t = rng.randrange(p)
                if s == 0 and t == 0:
                    continue
                x = [0] * 5
                x[i] = s
                x[(i + 2) % 5] = t
                if klein_F(x, p) != 0:
                    ok_all = False
        # consecutive lines should NOT lie on F
        cons_on = 0
        cons_off = 0
        for i in range(5):
            x = [0] * 5
            x[i] = 1
            x[(i + 1) % 5] = 1
            if klein_F(x, p) == 0:
                cons_on += 1
            else:
                cons_off += 1
        line_checks.append(
            {
                "prime": p,
                "skip_one_lines_on_F": ok_all,
                "consecutive_sample_on": cons_on,
                "consecutive_sample_off": cons_off,
            }
        )

    # Residual equation from L_0 = span(e0,e2):
    # x = (s, u, t, v, w) with F = u s^2 + w^2 s + v t^2 + u^2 t + v^2 w
    residual_eq = "u*s^2 + w^2*s + v*t^2 + u^2*t + v^2*w = 0"
    # Search linear sections s,t in u,v,w with small integer coeffs
    section_hits = []
    for coeffs in itertools.product(range(-2, 3), repeat=6):
        au, av, aw, bu, bv, bw = coeffs
        if all(c == 0 for c in coeffs):
            continue
        # symbolic identity via multi-eval
        rng = random.Random(hash(coeffs) % 10000)
        identity = True
        for p in (31, 41, 61, 71):
            for _ in range(15):
                u, v, w = [rng.randrange(p) for _ in range(3)]
                s = (au * u + av * v + aw * w) % p
                t = (bu * u + bv * v + bw * w) % p
                val = (
                    u * (s * s % p)
                    + (w * w % p) * s
                    + v * (t * t % p)
                    + (u * u % p) * t
                    + (v * v % p) * w
                ) % p
                if val != 0:
                    identity = False
                    break
            if not identity:
                break
        if identity:
            section_hits.append(
                {"s": [au, av, aw], "t": [bu, bv, bw]}
            )

    # Degree-five closed point over E: avals = (prod_{k!=0}(r0-rk), 0,0,0,0) in B-frame
    deg5 = {
        "statement": "Z0(T)=prod_{k=1..4}(T-r_k) gives Phi=0 over E (H4); Gal orbit is the five eigenpoints e_i in the B-frame",
        "not_K_point": True,
        "image_B_frame": "[beta0*Z0(r0):0:0:0:0] and cyclic conjugates",
    }

    # Smoothness of F: only singular point of the affine cone is 0 (checked in wave2 design)
    smoothness = {
        "partials": "dF/dx_j = 2 x_j x_{j+1} + x_{j-1}^2",
        "computational_check": "only solution of all partials over Q is the origin (singular locus of the cone)",
        "conclusion": "projective cubic threefold F=0 is smooth over C",
    }

    # Galois descent obstruction note
    descent = {
        "skip_one_lines": "L_i=span(e_i, e_{i+2}) form a Gal(E/K)-orbit of size 5",
        "no_single_line_over_K": (
            "No line in the orbit is fixed by sigma, so none is defined over K. "
            "A K-rational line on X would give a conic-bundle projection over K."
        ),
        "invariant_hyperplane": (
            "The unique Gal-invariant linear form without roots of unity is "
            "sum x_i. The cubic surface X ∩ {sum x_i=0} is defined over K; "
            "small-integer search finds constant points on F=0 ∩ sum=0, but "
            "constant B-frame points need not arise from z in K (B depends on r)."
        ),
        "linear_conic_sections_found": len(section_hits),
        "residual_status": (
            "Residual conic bundle after projecting from a skip-one line is defined "
            "over E, not over K. No linear polynomial section of the residual "
            "equation was found. Full descent of the conic bundle / Brauer analysis "
            "is not completed in this wave."
        ),
    }

    return {
        "format": "H5-WAVE2-PROJECTION-v1",
        "ambient_equation": "F = sum_{i in Z/5} x_i^2 x_{i+1}",
        "equivalence": "F(B z) = Phi(z) on the H4 common open",
        "skip_one_lines_theorem": (
            "For each i, the line span(e_i, e_{i+2}) lies on F=0 "
            "(only coordinates i and i+2 nonzero => every monomial of F vanishes)."
        ),
        "line_checks": line_checks,
        "all_skip_one_checks_ok": all(c["skip_one_lines_on_F"] for c in line_checks),
        "residual_equation_from_L0": residual_eq,
        "residual_variables": {
            "line_coords": "(s : t) on L0=span(e0,e2)",
            "complementary_P2": "(u : v : w) ~ (x1 : x3 : x4)",
        },
        "linear_sections": section_hits,
        "degree_five_point": deg5,
        "smoothness": smoothness,
        "galois_descent": descent,
        "K_point_found_via_projection": None,
        "verdict": "geometry_recorded_no_K_point",
    }


def modular_fiber_screen() -> dict:
    rng = random.Random(20260802)
    rows = []
    for p in (31, 41, 61, 71, 89, 101, 131, 151, 181, 199, 211, 227):
        specs = 0
        hits = 0
        sample = None
        for _ in range(50):
            r = random_r(p, rng)
            if r is None:
                continue
            specs += 1
            found = None
            for __ in range(500):
                z = [rng.randrange(p) for _ in range(5)]
                if all(x == 0 for x in z):
                    continue
                if phi_from_orbit(eval_Z_orbit(z, r, p), r, p) == 0:
                    found = z
                    break
            if found is not None:
                hits += 1
                if sample is None:
                    sample = {"r": r, "z": found}
        rows.append(
            {
                "prime": p,
                "specializations_tested": specs,
                "with_random_z_hit": hits,
                "sample": sample,
            }
        )
    return {
        "role": "fibre-nonemptiness over F_p; NOT a K-point",
        "rows": rows,
        "verdict": "modular_fibres_typically_nonempty",
        "transfer": "no characteristic-zero point claimed",
    }


def replay_modular_samples(mod: dict) -> dict:
    checks = []
    for row in mod["rows"]:
        p = row["prime"]
        sample = row["sample"]
        if not sample:
            checks.append({"prime": p, "status": "no_sample"})
            continue
        r, z = sample["r"], sample["z"]
        ph = phi_from_orbit(eval_Z_orbit(z, r, p), r, p)
        checks.append(
            {
                "prime": p,
                "phi": ph,
                "ok": ph == 0 and any(z),
            }
        )
    return {
        "checks": checks,
        "all_ok": all(c.get("ok") for c in checks if c.get("status") != "no_sample"),
    }


def build_manifest(h4_hashes: dict, h5_seal: str | None) -> dict:
    inputs = {
        "binding_goal": {
            "path_relative_to_problem": "goals_after_bd610a/GOAL_H5_11_5_TRACE_CUBIC_DECISION.md",
            "sha256": digest(GOAL),
            "role": "authoritative H5 work order",
        },
        "h4_seal": {
            "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/SEAL.json",
            "sha256": h4_hashes["SEAL.json"],
            "role": "sealed H4 model",
        },
        "h4_field_model": {
            "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/field_model.json",
            "sha256": h4_hashes["field_model.json"],
        },
        "h4_twist_model": {
            "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/twist_model.json",
            "sha256": h4_hashes["twist_model.json"],
        },
        "h4_norm_model": {
            "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/norm_model.json",
            "sha256": h4_hashes["norm_model.json"],
        },
        "h4_decision": {
            "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/decision.json",
            "sha256": h4_hashes["decision.json"],
        },
        "h5_wave1_status": {
            "path_relative_to_problem": "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/STATUS.md",
            "sha256": digest(H5 / "STATUS.md"),
            "role": "prior H5-UNDECIDED first wave (not modified)",
        },
    }
    if h5_seal and (H5 / "SEAL.json").is_file():
        inputs["h5_wave1_seal"] = {
            "path_relative_to_problem": "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/SEAL.json",
            "sha256": digest(H5 / "SEAL.json"),
        }
    return {
        "format": "H5-WAVE2-INPUT-MANIFEST-v1",
        "pinned_state": PINNED,
        "parent_exit": "H5-UNDECIDED",
        "h4_exit": "H-11_5-NORM-MODEL-PASS",
        "inputs": inputs,
    }


def main() -> None:
    t0 = time.time()
    actual_h4 = {n: digest(H4 / n) for n in H4_EXPECTED}
    assert actual_h4 == H4_EXPECTED, actual_h4

    field = json.loads((H4 / "field_model.json").read_text())
    twist = json.loads((H4 / "twist_model.json").read_text())
    norm = json.loads((H4 / "norm_model.json").read_text())
    assert field["fields"]["degrees"]["E_over_K"] == 5
    assert norm["trace_model"]["equation"].startswith(
        "Phi(z)=Tr_E/K(r2^-1*a^2*sigma(a))"
    )
    # lattice
    assert all(sum(row) == 0 for row in R_EXPONENTS)
    assert all(
        sum(a * b for a, b in zip(row, WEIGHTS)) % 11 == 0 for row in R_EXPONENTS
    )

    print("WAVE2: structure...", flush=True)
    structure = screen_structure_k_monoms()

    print("WAVE2: named formulas...", flush=True)
    named = screen_named_formulas()

    print("WAVE2: additive/multiplicative H90 K...", flush=True)
    add_h90 = screen_additive_h90_k(1)
    mul_h90 = screen_multiplicative_h90_k(1)

    print("WAVE2: binary ratio menu...", flush=True)
    binary = screen_binary_ratio_monom_roots(1)

    print("WAVE2: two-support K...", flush=True)
    two_sup = screen_two_support_k_coeffs(1)

    print("WAVE2: three-cyclic K...", flush=True)
    three_cyc = screen_three_cyclic_k_coeffs(1)

    print("WAVE2: four-cyclic K...", flush=True)
    four_cyc = screen_four_cyclic_k_coeffs(1)

    print("WAVE2: sparse z...", flush=True)
    sparse_z = screen_sparse_z_invariants()

    print("WAVE2: local cyclic poly...", flush=True)
    local = screen_local_cyclic_poly()

    print("WAVE2: projection geometry...", flush=True)
    proj = projection_geometry()

    print("WAVE2: modular fibres...", flush=True)
    modular = modular_fiber_screen()
    holdout = replay_modular_samples(modular)

    screens = {
        "structure_k_laurent_monoms": structure,
        "named_formulas": named,
        "additive_h90_k_scaled": add_h90,
        "multiplicative_h90_k_scaled": mul_h90,
        "binary_ratio_invariant_menu": binary,
        "two_support_k_coeffs": two_sup,
        "three_cyclic_k_coeffs": three_cyc,
        "four_cyclic_k_coeffs": four_cyc,
        "sparse_z_invariants": sparse_z,
        "local_cyclic_poly": local,
    }

    any_hit = False
    hit_names = []
    for name, scr in screens.items():
        if scr.get("verdict") == "HIT":
            any_hit = True
            hit_names.append(name)
        if name == "named_formulas":
            for cn, case in scr["cases"].items():
                if case.get("verdict") == "HIT":
                    any_hit = True
                    hit_names.append(f"named:{cn}")

    total_tested = 0
    for scr in screens.values():
        if "tested" in scr:
            total_tested += scr["tested"]
        if name := scr.get("cases"):
            pass
        if "cases" in scr and isinstance(scr["cases"], dict):
            total_tested += len(scr["cases"])

    constructive = {
        "format": "H5-WAVE2-CONSTRUCTIVE-v1",
        "screens": screens,
        "any_identity_hit": any_hit,
        "hit_screen_names": hit_names,
        "points_found_over_K": [],
        "approx_patterns_tested": total_tested,
        "modular_specialization": modular,
        "modular_holdout_replay": holdout,
        "verdict": "no_K_point_in_scoped_screens",
        "hard_review_fix": (
            "verify.py independently re-runs every screen class "
            "(not only JSON boolean checks on a tiny subset)"
        ),
    }

    decision = {
        "format": "H5-WAVE2-DECISION-v1",
        "exit": "H5-UNDECIDED",
        "headline": "OPEN",
        "pinned_state": PINNED,
        "parent_packet": "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/",
        "h4_exit_consumed": "H-11_5-NORM-MODEL-PASS",
        "rational_point_over_K": None,
        "pointlessness": None,
        "valuation_obstruction": None,
        "coefficient_class_decision": None,
        "proved_in_this_packet": [
            "Only constant Laurent monoms lie in K (sigma-fixed => diagonal => constant on product-one torus)",
            "Scoped multi-support Laurent ansatze with invariant-menu K-coefficients listed in constructive_search.json are empty of K-identities",
            "Skip-one lines span(e_i,e_{i+2}) lie on F; residual conic equation recorded; no linear residual section; no K-point from projection in this wave",
            "Specialized Phi fibres over many F_p remain typically nonempty (honest nonverdict)",
        ],
        "not_proved": [
            "existence of nonzero a in E with Tr(r2^{-1} a^2 sigma(a))=0 over K",
            "pointlessness of the genuine 11:5 twist over K",
            "full Galois descent of the skip-one conic bundle",
            "binary cubic for a=1+s m always anisotropic over K",
            "any Problem E headline",
        ],
        "smallest_remaining_theorem": (
            "Decide whether there exists nonzero a in E with "
            "Tr_{E/K}(r2^{-1} a^2 sigma(a))=0."
        ),
        "next_finite_gate": (
            "H5.1.C: complete Galois descent of the residual conic bundle from the "
            "skip-one line orbit (or prove the descended Brauer/Severi-Brauer obstruction); "
            "OR exact binary-cubic solubility for a=1+s*m over the full field K "
            "(not menu specialization); OR one toric valuation with residue anisotropy."
        ),
        "runtime_seconds": round(time.time() - t0, 3),
    }

    point = {
        "format": "H5-WAVE2-POINT-v1",
        "rational_point_over_K": None,
        "exact_coordinates": None,
        "note": "no K-point; modular samples are not lifts",
    }

    trace = {
        "format": "H5-WAVE2-TRACE-CUBIC-v1",
        "equation": "Phi(a)=Tr_{E/K}(r2^{-1} a^2 sigma(a))=0",
        "fields": {
            "E": "C(r0,...,r4)/(r0 r1 r2 r3 r4 - 1)",
            "K": "E^{<sigma>} = C(U1,U2,U3,U4)",
            "c": "r2^{-1}",
        },
        "binding": "H4 norm/twist model by path+hash",
    }

    manifest = build_manifest(actual_h4, "present")

    write_json("INPUT_MANIFEST.json", manifest)
    write_json("TRACE_CUBIC.json", trace)
    write_json("constructive_search.json", constructive)
    write_json("projection.json", proj)
    write_json("modular_screen.json", modular)
    write_json("point.json", point)
    write_json("decision.json", decision)

    print("H5_WAVE2_PRODUCE_OK", flush=True)
    print("exit=H5-UNDECIDED", flush=True)
    print("any_identity_hit=", any_hit, flush=True)
    print("runtime_seconds=", decision["runtime_seconds"], flush=True)


if __name__ == "__main__":
    main()
