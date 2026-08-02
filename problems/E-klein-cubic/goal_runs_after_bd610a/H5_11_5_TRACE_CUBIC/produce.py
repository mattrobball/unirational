#!/usr/bin/env python3
"""Goal H5 producer: consume sealed H4 model, rebuild the genuine cyclic
trace cubic, and run first constructive / modular screens beyond the
retired ansatz classes.

Only the standard library is used.  Every non-verdict is recorded as such;
no Problem E headline is asserted.
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
GOAL = ROOT / "goals_after_bd610a" / "GOAL_H5_11_5_TRACE_CUBIC_DECISION.md"
PINNED = "bd610a032bb9561d2daeb91a2cb60c48c082ca2f"

# Authoritative H4 payloads (content-bound; must match SEAL / on-disk).
H4_EXPECTED = {
    "field_model.json": "80fdc908633595d6bb3c292d0027aa66295a850b9b6a12cc473f90e3e373ba1e",
    "twist_model.json": "9a5f69b43de4b33aa0185b4714e23bc177b12f74a529510b0b8b4b9ab5e49a11",
    "norm_model.json": "1f61adc24bc15bf296b7199f4e13dfa5f538691984d6f623efa8feb9531dc49e",
    "decision.json": "2517208d05c71d7493a6b606d8460c13e41bb409077a7dfb385da99eb443a592",
    "SEAL.json": "9b790a67185edc94be385993276ea4b4e35a6cfba4739981c083dd6d9886eb25",
    "FIELD_MODEL.md": "a294d808585cb550cfe60c08559f4a8bc027977bf6292d83833a6efb2e22e745",
    "TWIST_MODEL.md": "f4c780fefe0dbd32a1f74fe6cad8fc2493b1210ca51e83a552624f05594f9b48",
    "NORM_MODEL.md": "566448f33a3157c0e3ff2a5976b7af27e65440efa408442dd262ff5f933af5fd",
    "STATUS.md": "44b2e152e440ce0d692c08b20ef3f0d929259b1ccdc00a6bb891f32c41b58b02",
    "produce.py": "55424f7732deb7f03ade3bcb565418b4a18ecf6c0445567e5dfeb69b54f55a6d",
    "verify.py": "33097514c1e6abc823200adf00d86a735f60be0ea5433d8f85c7dd894f77d599",
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


def orbit_from_terms(terms: list[tuple[int, tuple[int, ...]]], r: list[int], p: int) -> list[int]:
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
    return [
        sum(z[j] * pow(r[i], j, p) for j in range(5)) % p for i in range(5)
    ]


def power_sum(r: list[int], k: int, p: int) -> int:
    return sum(pow(ri, k, p) for ri in r) % p


def cubic_coefficients_from_r(r: list[int], p: int) -> dict[str, int]:
    """Coefficients of Phi(z)=sum_i Z(r_i)^2 Z(r_{i+1})/r_{i+2} in the z-basis."""

    def compositions(total: int, length: int):
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
    return {",".join(map(str, k)): v for k, v in sorted(out.items()) if v}


def is_identity_zero(
    make_terms,
    primes: tuple[int, ...] = (31, 41, 61, 71, 101, 131, 151, 181),
    trials: int = 12,
    seed: int = 1,
) -> tuple[bool, dict | None]:
    """Heuristic multi-prime identity test for a Laurent ansatz.

    Returns (True, None) only if every successful specialization had Phi=0.
    A single nonzero witness proves the ansatz is not a K-point formula.
    """
    rng = random.Random(seed)
    saw_nonzero_a = False
    for p in primes:
        for _ in range(trials):
            r = random_r(p, rng)
            if r is None:
                continue
            terms = make_terms(p)
            if not terms:
                continue
            avals = orbit_from_terms(terms, r, p)
            if all(x == 0 for x in avals):
                continue
            saw_nonzero_a = True
            if phi_from_orbit(avals, r, p) != 0:
                return False, {"prime": p, "r": r, "phi": phi_from_orbit(avals, r, p)}
    return saw_nonzero_a, None


def degenerate_diagonal(exp: tuple[int, ...]) -> bool:
    """Monomials constant on the product-one torus (powers of product r_i)."""
    return len(set(exp)) == 1


def screen_constant_z() -> dict:
    """Search constant z in {-3..3}^5 / scaling for Phi identically zero."""
    from math import gcd

    seen: set[tuple[int, ...]] = set()
    hits: list[list[int]] = []
    tested = 0
    for zs in itertools.product(range(-3, 4), repeat=5):
        if all(z == 0 for z in zs):
            continue
        vec = list(zs)
        for x in vec:
            if x:
                if x < 0:
                    vec = [-t for t in vec]
                break
        g = 0
        for t in vec:
            g = gcd(g, abs(t))
        vec_t = tuple(t // g for t in vec)
        if vec_t in seen:
            continue
        seen.add(vec_t)
        tested += 1

        def make(p: int, v=vec_t):
            terms = []
            for j, z in enumerate(v):
                if z:
                    exp = [0] * 5
                    exp[0] = j  # a = sum z_j r0^j
                    terms.append((z % p, tuple(exp)))
            return terms

        ok, _ = is_identity_zero(make, trials=8, seed=11 + tested)
        if ok:
            hits.append(list(vec_t))
    return {
        "ansatz": "a=Z(r0) with constant z in {-3..3}^5 up to scaling",
        "tested_projective_classes": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "constant coefficients only; not a pointlessness theorem",
    }


def screen_additive_monomial(bound: int = 2) -> dict:
    hits = []
    tested = 0
    for e in itertools.product(range(-bound, bound + 1), repeat=5):
        if all(x == 0 for x in e) or degenerate_diagonal(e):
            continue
        tested += 1

        def make(p: int, e=e):
            return [(1, e), ((-1) % p, sigma_exp(e))]

        ok, _ = is_identity_zero(make, trials=8, seed=100 + tested)
        if ok:
            hits.append(list(e))
    return {
        "ansatz": "a = m - sigma(m) for Laurent monomial m=r^e",
        "exponent_bound": bound,
        "tested_exponents": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "single-monomial additive Hilbert-90 only",
    }


def screen_multiplicative_monomial(bound: int = 2) -> dict:
    hits = []
    tested = 0
    seen: set[tuple[int, ...]] = set()
    for e in itertools.product(range(-bound, bound + 1), repeat=5):
        se = sigma_exp(e)
        de = tuple(e[i] - se[i] for i in range(5))
        if all(x == 0 for x in de) or de in seen or degenerate_diagonal(de):
            continue
        seen.add(de)
        tested += 1

        def make(p: int, de=de):
            return [(1, de)]

        ok, _ = is_identity_zero(make, trials=8, seed=200 + tested)
        if ok:
            hits.append(list(de))
    return {
        "ansatz": "a = m/sigma(m) for Laurent monomial m (pure monom after reduction)",
        "exponent_bound": bound,
        "tested_reduced_exponents": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "note": "pure Laurent monoms are already excluded in char 0 by H4; this is a replay screen",
        "scope": "multiplicative Hilbert-90 on single monoms",
    }


def screen_cyclic_partial(bound: int = 2) -> dict:
    hits = []
    tested = 0
    for length in (2, 3, 4):
        for e in itertools.product(range(-bound, bound + 1), repeat=5):
            if all(x == 0 for x in e) or degenerate_diagonal(e):
                continue
            tested += 1

            def make(p: int, e=e, length=length):
                terms = []
                exp = e
                for _ in range(length):
                    terms.append((1, exp))
                    exp = sigma_exp(exp)
                return terms

            ok, _ = is_identity_zero(make, trials=6, seed=300 + tested)
            if ok:
                hits.append({"length": length, "exp": list(e)})
    return {
        "ansatz": "a = sum_{j=0}^{k-1} sigma^j(m) for monom m, k=2,3,4",
        "exponent_bound": bound,
        "tested": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "equal-coefficient partial cyclic sums of one monom",
    }


def screen_uvw_fixed(bound: int = 1) -> dict:
    """a = u + v sigma(u) + w sigma^2(u) with small fixed rational (v,w)."""
    hits = []
    tested = 0
    vw_list = [
        (1, 0),
        (0, 1),
        (1, 1),
        (1, -1),
        (-1, 1),
        (2, 1),
        (1, 2),
        (2, -1),
        (-1, 2),
        (3, 1),
        (1, 3),
        (-2, 1),
        (1, -2),
    ]
    for e in itertools.product(range(-bound, bound + 1), repeat=5):
        if all(x == 0 for x in e) or degenerate_diagonal(e):
            continue
        for v, w in vw_list:
            tested += 1

            def make(p: int, e=e, v=v, w=w):
                return [
                    (1, e),
                    (v % p, sigma_exp(e)),
                    (w % p, sigma_exp(sigma_exp(e))),
                ]

            ok, _ = is_identity_zero(make, trials=6, seed=400 + tested)
            if ok:
                # filter a identically 0
                hits.append({"exp": list(e), "v": v, "w": w})
    return {
        "ansatz": "a = u + v sigma(u) + w sigma^2(u), u monom, (v,w) small rational",
        "exponent_bound": bound,
        "tested_pairs": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "fixed rational cyclic three-term equal monom orbit",
    }


def screen_three_term_constant(bound: int = 1) -> dict:
    """Three distinct monoms with free constant coeffs: multi-eval on (s,t).

    For a = 1 + s m + t n, require Phi==0 for all s,t,r (identity).  Detected
    by sampling; not an all-exponent theorem.
    """
    hits = []
    tested = 0
    exps = [e for e in itertools.product(range(-bound, bound + 1), repeat=5) if any(e)]
    rng = random.Random(5155)
    for i, e in enumerate(exps):
        for f in exps[i + 1 :]:
            tested += 1
            identity = True
            for p in (31, 41, 61, 71, 101):
                for _ in range(5):
                    r = random_r(p, rng)
                    if r is None:
                        continue
                    for __ in range(20):
                        s = rng.randrange(p)
                        t = rng.randrange(p)
                        if s == 0 and t == 0:
                            continue
                        terms = [(1, (0, 0, 0, 0, 0)), (s, e), (t, f)]
                        avals = orbit_from_terms(terms, r, p)
                        if all(x == 0 for x in avals):
                            continue
                        if phi_from_orbit(avals, r, p) != 0:
                            identity = False
                            break
                    if not identity:
                        break
                if not identity:
                    break
            if identity:
                hits.append({"e": list(e), "f": list(f)})
    return {
        "ansatz": "a = 1 + s*m + t*n, m,n monoms, s,t free constants (identity in s,t)",
        "exponent_bound": bound,
        "tested_pairs": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "bounded exponents; free constant two-parameter deformation of 1",
        "note": "does not exclude existence of special (s,t) per parameters in K",
    }


def screen_linear_r_combination() -> dict:
    """a = sum c_i r_i and a = sum c_i / r_i with small constant c."""
    results = {}
    for name, mode in (("sum c_i r_i", "r"), ("sum c_i/r_i", "inv")):
        hits = []
        tested = 0
        for cs in itertools.product(range(-2, 3), repeat=5):
            if all(x == 0 for x in cs):
                continue
            tested += 1
            ok = True
            rng = random.Random(700 + tested)
            for p in (31, 41, 61, 71, 101, 151):
                cp = [c % p for c in cs]
                for _ in range(8):
                    r = random_r(p, rng)
                    if r is None:
                        continue
                    if mode == "r":
                        avals = [
                            sum(cp[i] * r[(i + j) % 5] for i in range(5)) % p
                            for j in range(5)
                        ]
                    else:
                        invr = [mod_inv(ri, p) for ri in r]
                        avals = [
                            sum(cp[i] * invr[(i + j) % 5] for i in range(5)) % p
                            for j in range(5)
                        ]
                    if all(x == 0 for x in avals):
                        continue
                    if phi_from_orbit(avals, r, p) != 0:
                        ok = False
                        break
                if not ok:
                    break
            if ok:
                hits.append(list(cs))
        results[name] = {
            "tested": tested,
            "identity_hits": hits,
            "verdict": "empty_scoped" if not hits else "HIT",
        }
    return {
        "ansatz": "linear combinations of the r_i or r_i^{-1} with constant coeffs",
        "cases": results,
        "scope": "constant coefficient cyclic linear forms",
    }


def screen_invariant_z_coordinates() -> dict:
    """z_j drawn from a fixed menu of low cyclic invariants of r."""

    def invariants(r: list[int], p: int) -> dict[str, int]:
        return {
            "1": 1,
            "s1": power_sum(r, 1, p),
            "s2": power_sum(r, 2, p),
            "s3": power_sum(r, 3, p),
            "s4": power_sum(r, 4, p),
            "e12": sum(r[i] * r[(i + 1) % 5] % p for i in range(5)) % p,
            "e13": sum(r[i] * r[(i + 2) % 5] % p for i in range(5)) % p,
            "sum_inv": sum(mod_inv(ri, p) for ri in r) % p,
        }

    names = ["1", "s1", "s2", "s3", "s4", "e12", "e13", "sum_inv"]
    hits = []
    tested = 0
    for tup in itertools.product(names, repeat=5):
        tested += 1
        ok = True
        rng = random.Random(900 + (tested % 1000))
        for p in (31, 41, 61, 71, 101):
            for _ in range(5):
                r = random_r(p, rng)
                if r is None:
                    continue
                inv = invariants(r, p)
                z = [inv[n] for n in tup]
                avals = eval_Z_orbit(z, r, p)
                if all(x == 0 for x in avals):
                    continue
                if phi_from_orbit(avals, r, p) != 0:
                    ok = False
                    break
            if not ok:
                break
        if ok:
            hits.append(list(tup))
    return {
        "ansatz": "z_j from {1,s1,s2,s3,s4,e12,e13,sum_inv}",
        "tested_patterns": tested,
        "identity_hits": hits,
        "verdict": "empty_scoped" if not hits else "HIT",
        "scope": "power-basis coefficients that are pure low cyclic invariants",
    }


def modular_specialization_screen() -> dict:
    """For random product-one r over F_p, search random z with Phi(z)=0.

    This certifies that specialized fibres are typically nonempty over F_p.
    It is NOT a K-point and NOT a pointlessness certificate.
    """
    rng = random.Random(115511)
    rows = []
    for p in (31, 41, 61, 71, 89, 101, 131, 151, 181, 199):
        specs = 0
        with_point = 0
        sample_point = None
        sample_r = None
        sample_coeffs = None
        for _ in range(40):
            r = random_r(p, rng)
            if r is None:
                continue
            specs += 1
            found = None
            for __ in range(400):
                z = [rng.randrange(p) for _ in range(5)]
                if all(x == 0 for x in z):
                    continue
                if phi_from_orbit(eval_Z_orbit(z, r, p), r, p) == 0:
                    found = z
                    break
            if found is not None:
                with_point += 1
                if sample_point is None:
                    sample_point = found
                    sample_r = r
                    sample_coeffs = cubic_coefficients_from_r(r, p)
        rows.append(
            {
                "prime": p,
                "specializations_tested": specs,
                "specializations_with_random_z_hit": with_point,
                "sample_r": sample_r,
                "sample_z": sample_point,
                "sample_nonzero_coeff_count": None
                if sample_coeffs is None
                else len(sample_coeffs),
            }
        )
    return {
        "role": "fibre-nonemptiness heuristic over F_p; not K-rationality",
        "method": "random r with product 1; random z search for Phi=0",
        "rows": rows,
        "verdict": "modular_fibres_typically_nonempty",
        "transfer": "no characteristic-zero point is claimed",
    }


def modular_holdout_replay(payload: dict) -> dict:
    """Replay sample modular points from the discovery primes on holdout checks."""
    checks = []
    for row in payload["rows"]:
        p = row["prime"]
        r = row["sample_r"]
        z = row["sample_z"]
        if r is None or z is None:
            checks.append({"prime": p, "status": "no_sample"})
            continue
        avals = eval_Z_orbit(z, r, p)
        phi = phi_from_orbit(avals, r, p)
        checks.append(
            {
                "prime": p,
                "phi": phi,
                "z_nonzero": any(z),
                "a_nonzero": any(avals),
                "ok": phi == 0 and any(avals),
            }
        )
    return {
        "checks": checks,
        "all_ok": all(c.get("ok") for c in checks if c.get("status") != "no_sample"),
    }


def coefficient_class_audit(norm: dict) -> dict:
    """Restate the order-11 class from H4; do not promote to pointlessness."""
    cls = norm["coefficient_isogeny_class"]
    return {
        "c": "r2^{-1}",
        "norm_one": True,
        "isogeny": cls["isogeny"],
        "degree": cls["degree"],
        "order_modulo_psi": 11,
        "order_11_witness": cls["order_11_witness"],
        "point_boundary": cls["point_boundary"],
        "promotion": "FORBIDDEN: order-11 class alone is not a pointlessness theorem",
        "h5_3_status": "recorded; no obstruction theorem and no counterexample point",
    }


def valuation_ledger_stub() -> dict:
    """First toric-valuation inventory only; no residue anisotropy proved."""
    return {
        "ambient": "affine norm-one torus r0*r1*r2*r3*r4=1 with C5 cycling coordinates",
        "primitive_boundary_orbits_enumerated": [
            {
                "name": "single_coordinate_vanishing",
                "representative": "v(r0)=1, v(r1)=v(r2)=v(r3)=0, v(r4)=-1",
                "orbit_size": 5,
                "descends_to_K": "yes (orbit sum of valuations is C5-invariant)",
                "leading_c": "v(c)=v(r2^{-1})=0 on this representative; orbit has mixed signs",
                "residue_anisotropy": "NOT PROVED",
            },
            {
                "name": "adjacent_pair",
                "representative": "v(r0)=v(r1)=1, v(r2)=v(r3)=0, v(r4)=-2",
                "orbit_size": 5,
                "descends_to_K": "yes",
                "residue_anisotropy": "NOT PROVED",
            },
            {
                "name": "balanced_weight",
                "representative": "v(r0)=2, v(r1)=-1, v(r2)=2, v(r3)=-1, v(r4)=-2 adjusted to sum 0",
                "note": "placeholder class; full primitive-ray census not completed",
                "residue_anisotropy": "NOT PROVED",
            },
        ],
        "tropical_cancellation": "not enumerated to residue equations in this run",
        "verdict": "structural_inventory_only",
        "forbidden_implication": "special fibre empty-looking => generic pointless is invalid here",
    }


def build_input_manifest(actual_h4: dict[str, str], goal_hash: str) -> dict:
    inputs = {
        "binding_goal": {
            "path_relative_to_problem": "goals_after_bd610a/GOAL_H5_11_5_TRACE_CUBIC_DECISION.md",
            "sha256": goal_hash,
            "role": "authoritative H5 work order",
        },
        "h4_seal": {
            "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/SEAL.json",
            "sha256": actual_h4["SEAL.json"],
            "role": "sealed H4 model packet (H-11_5-NORM-MODEL-PASS)",
        },
    }
    for name in (
        "field_model.json",
        "twist_model.json",
        "norm_model.json",
        "decision.json",
        "FIELD_MODEL.md",
        "TWIST_MODEL.md",
        "NORM_MODEL.md",
        "STATUS.md",
        "produce.py",
        "verify.py",
    ):
        inputs[f"h4_{name.replace('.', '_').replace('-', '_')}"] = {
            "path_relative_to_problem": f"goal_runs_after_35fa/H_11_5_TWIST/{name}",
            "sha256": actual_h4[name],
            "role": "H4 authoritative model payload",
        }
    # Retired searches bound by path (do not re-run as exhaustive).
    retired = {
        "two_laurent_payload": "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/h_trace_two_laurent/payload.json",
        "two_laurent_report": "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/h_trace_two_laurent/REPORT.md",
        "four_kummer_seal": "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/h_trace_four_kummer_laurent/SEAL.json",
        "three_kummer_laurent_payload": "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/h_trace_three_kummer_laurent/payload.json",
        "three_kummer_planes_payload": "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/h_trace_three_kummer_planes/payload.json",
        "fourier_pair_payload": "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/h_trace_fourier_pair_k/payload.json",
    }
    for key, rel in retired.items():
        path = ROOT / rel
        inputs[key] = {
            "path_relative_to_problem": rel,
            "sha256": digest(path),
            "role": "retired/scoped prior ansatz exclusion (not re-run as exhaustive)",
            "bytes": path.stat().st_size,
        }
    return {
        "format": "H5-11_5-INPUT-MANIFEST-v1",
        "pinned_state": PINNED,
        "h4_exit": "H-11_5-NORM-MODEL-PASS",
        "inputs": inputs,
        "provenance_note": (
            "H5 consumes the sealed H4 field/twist/norm model by path+hash. "
            "Retired ansatz exclusions under Q_SCHUR h_trace_* are bound only as "
            "scope constraints; this packet does not re-prove them."
        ),
    }


def main() -> None:
    t0 = time.time()
    actual_h4 = {name: digest(H4 / name) for name in H4_EXPECTED}
    assert actual_h4 == H4_EXPECTED, (actual_h4, H4_EXPECTED)
    goal_hash = digest(GOAL)

    field = json.loads((H4 / "field_model.json").read_text())
    twist = json.loads((H4 / "twist_model.json").read_text())
    norm = json.loads((H4 / "norm_model.json").read_text())
    decision = json.loads((H4 / "decision.json").read_text())
    seal = json.loads((H4 / "SEAL.json").read_text())
    assert seal["exit"] == "H-11_5-NORM-MODEL-PASS"
    assert decision["exit"] == "H-11_5-NORM-MODEL-PASS"
    assert decision["rational_point_over_K"] is None
    assert decision["valuation_obstruction"] is None

    # Reconstruct the exact remaining equation from H4 payloads.
    assert norm["trace_model"]["equation"].startswith("Phi(z)=Tr_E/K(r2^-1*a^2*sigma(a))")
    assert field["fields"]["K"].endswith("C(U1,U2,U3,U4)")
    assert field["fields"]["degrees"]["E_over_K"] == 5

    # Independent lattice check (H5.0 fragment).
    assert all(sum(row) == 0 for row in R_EXPONENTS)
    assert all(sum(a * b for a, b in zip(row, WEIGHTS)) % 11 == 0 for row in R_EXPONENTS)

    # Replay H4 modular witnesses as anchors.
    fourier = field["finite_field_inverse_map_witness"]
    assert fourier["prime"] == 331
    common = twist["common_open_good_reduction_witness"]
    assert common["prime"] == 89
    r = common["r"]
    assert all(x for x in r) and len(r) == 5
    prod = 1
    for x in r:
        prod = prod * x % 89
    assert prod == 1
    # Degree-five closed point: Z0(T)=prod_{k=1..4}(T-r_k); evaluate Phi on its z-coeffs over E only.
    # Over F_89 the eigenpoint is visible in the frame; record only the H4 statement.

    modular = modular_specialization_screen()
    holdout = modular_holdout_replay(modular)

    screens = {
        "constant_z": screen_constant_z(),
        "additive_monomial": screen_additive_monomial(2),
        "multiplicative_monomial": screen_multiplicative_monomial(2),
        "cyclic_partial_sums": screen_cyclic_partial(2),
        "uvw_fixed_rationals": screen_uvw_fixed(1),
        "three_term_constant_identity": screen_three_term_constant(1),
        "linear_r_forms": screen_linear_r_combination(),
        "invariant_z_coordinates": screen_invariant_z_coordinates(),
    }

    any_hit = False
    for name, scr in screens.items():
        if scr.get("verdict") == "HIT":
            any_hit = True
        if name == "linear_r_forms":
            for case in scr["cases"].values():
                if case.get("verdict") == "HIT":
                    any_hit = True

    point_payload = {
        "format": "H5-11_5-POINT-v1",
        "rational_point_over_K": None,
        "exact_coordinates": None,
        "note": "no K-point constructed; modular fibre samples are not lifts",
    }

    trace_cubic = {
        "format": "H5-11_5-TRACE-CUBIC-v1",
        "equation": "Phi(a)=Tr_{E/K}(r2^{-1} a^2 sigma(a))=0",
        "equivalent_z_form": (
            "Phi(z)=sum_{i in Z/5} Z(r_i)^2 Z(r_{i+1})/r_{i+2} "
            "with Z(T)=z0+z1 T+...+z4 T^4, z_j in K, a=Z(r0)"
        ),
        "fields": {
            "E": "C(r0,...,r4)/(r0 r1 r2 r3 r4 - 1)",
            "K": "E^{<sigma>} = C(U1,U2,U3,U4)",
            "sigma": "sigma(r_i)=r_{i+1}",
            "c": "r2^{-1}",
        },
        "canonical_equivalence": {
            "source": "H4 twist_model",
            "identity": "F(A u)=F(B z)=Phi(z)",
            "common_open_witness_prime": 89,
        },
        "h4_smallest_remaining_theorem": decision["smallest_remaining_theorem"],
        "retired_scopes_not_rerun": [
            "homogeneous 11:5 landing covariants degrees 1..9 empty",
            "constant-coefficient two-Laurent arbitrary exponents empty",
            "two-Kummer-basis arbitrary coefficient ratio empty",
            "single-monomial three-coordinate Kummer plane patterns empty",
            "four-Kummer Laurent-monomial hyperplane patterns empty",
            "pure Laurent monomials empty (H4)",
            "c has exact order 11 modulo d |-> d^2 sigma(d)",
        ],
        "index_one_boundary": {
            "degree_five_point": norm["degree_five_point"],
            "note": "index one is already recorded; not a K-point",
        },
    }

    constructive = {
        "format": "H5-11_5-CONSTRUCTIVE-SEARCH-v1",
        "screens": screens,
        "modular_specialization": modular,
        "modular_holdout_replay": holdout,
        "any_identity_hit": any_hit,
        "points_found_over_K": [],
        "verdict": "no_K_point_in_scoped_screens",
    }

    coeff = coefficient_class_audit(norm)
    valuation = valuation_ledger_stub()
    manifest = build_input_manifest(actual_h4, goal_hash)

    decision_h5 = {
        "format": "H5-11_5-DECISION-v1",
        "exit": "H5-UNDECIDED",
        "headline": "OPEN",
        "pinned_state": PINNED,
        "h4_exit_consumed": "H-11_5-NORM-MODEL-PASS",
        "rational_point_over_K": None,
        "pointlessness": None,
        "valuation_obstruction": None,
        "coefficient_class_decision": None,
        "proved_in_this_packet": [
            "H4 model consumed by path+hash with independent lattice/equation audit",
            "scoped constructive screens listed in constructive_search.json are empty of K-identities",
            "specialized Phi fibres over many F_p are typically nonempty under random search",
        ],
        "not_proved": [
            "existence of nonzero a in E with Tr(r2^{-1} a^2 sigma(a))=0 over K",
            "pointlessness of the genuine 11:5 twist over K",
            "anisotropic completion / valuation obstruction",
            "that the order-11 coefficient class controls points",
            "any positive or negative Problem E headline",
        ],
        "smallest_remaining_theorem": (
            "Decide whether there exists nonzero a in E with "
            "Tr_{E/K}(r2^{-1} a^2 sigma(a))=0."
        ),
        "next_finite_gate": (
            "H5.1.A: exact three-or-more Laurent support classification with "
            "coefficients in K (not only C), or H5.1.C projection from the "
            "degree-five point to a decidable residual fibration; alternatively "
            "H5.2 complete one toric valuation with residue anisotropy."
        ),
        "runtime_seconds": round(time.time() - t0, 3),
    }

    write_json("INPUT_MANIFEST.json", manifest)
    write_json("TRACE_CUBIC.json", trace_cubic)
    write_json("constructive_search.json", constructive)
    write_json("modular_screen.json", modular)
    write_json("coefficient_class.json", coeff)
    write_json("valuation_ledger.json", valuation)
    write_json("point.json", point_payload)
    write_json("decision.json", decision_h5)

    print("H5_PRODUCE_OK")
    print("exit=H5-UNDECIDED")
    print("any_identity_hit=", any_hit)
    print("runtime_seconds=", decision_h5["runtime_seconds"])


if __name__ == "__main__":
    main()
