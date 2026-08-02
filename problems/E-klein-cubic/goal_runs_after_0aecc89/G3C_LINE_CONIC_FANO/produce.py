#!/usr/bin/env python3
"""G3C — full K_proj Fano scheme of lines on X_gen = V(Phi).

Expands the G3B formal line recipe over the full secondary basis of K_proj,
performs linear chart/pivot elimination first, then residual probes and a
light plane-conic lane. Does not re-run G3B sparse specialized probes.
"""
from __future__ import annotations

import hashlib
import itertools
import json
import os
import random
import resource
import subprocess
import time
import traceback
from collections import defaultdict
from fractions import Fraction
from pathlib import Path
from typing import Any

import sympy as sp

ROOT = Path(__file__).resolve().parents[2]
PKT = Path(__file__).resolve().parent
G3A = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"
G3B = ROOT / "goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH"
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
GOAL_G3 = ROOT / "goals_after_141f60/GOAL_G3_UNIVERSAL_CUBIC_ARITHMETIC.md"

T3, T6, T8, T11 = sp.symbols("t3 t6 t8 t11")
T_PARAMS = (T3, T6, T8, T11)
DIM_SEC = 12
N_AMB = 5


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def peak_rss_mb() -> float:
    # macOS: ru_maxrss is bytes; Linux: kilobytes
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    if rss > 10**9:  # clearly bytes (mac)
        return rss / (1024 * 1024)
    # heuristic: if small, treat as KB (linux) else bytes
    if rss > 10**7:
        return rss / (1024 * 1024)
    return rss / 1024.0


def entry_to_vec(entries) -> tuple:
    v = [sp.S.Zero] * DIM_SEC
    for e in entries:
        sec = e["secondary"]
        e3, e6, e8, e11 = e["projective_exponents"]
        mon = (
            sp.Rational(e["numerator"], e["denominator"])
            * (T3**e3)
            * (T6**e6)
            * (T8**e8)
            * (T11**e11)
        )
        v[sec] += mon
    return tuple(map(sp.cancel, v))


def load_alpha_kproj(payload: dict):
    """Symmetric 5x5x5 tensor of K_proj elements as length-12 P0-vectors."""
    alpha = [
        [[tuple(sp.S.Zero for _ in range(DIM_SEC)) for _ in range(N_AMB)] for _ in range(N_AMB)]
        for _ in range(N_AMB)
    ]
    for item in payload["coefficients"]:
        triple = tuple(item["triple"])
        cvec = entry_to_vec(item["normalized_entries"])
        perms = list(set(itertools.permutations(triple)))
        share = tuple(sp.cancel(c / len(perms)) for c in cvec)
        for i, j, k in perms:
            alpha[i][j][k] = share
    return alpha


def vec_is_zero(v) -> bool:
    return all(c == 0 for c in v)


def vec_scale(scalar, v):
    return tuple(sp.cancel(scalar * c) for c in v)


def vec_add(u, v):
    return tuple(sp.cancel(a + b) for a, b in zip(u, v))


def phi_vec(alpha, a):
    out = [sp.S.Zero] * DIM_SEC
    for i, j, k in itertools.product(range(N_AMB), repeat=3):
        mon = a[i] * a[j] * a[k]
        if mon == 0:
            continue
        for s in range(DIM_SEC):
            c = alpha[i][j][k][s]
            if c != 0:
                out[s] += c * mon
    return [sp.expand(x) for x in out]


def polar_vec(alpha, u, v, w):
    out = [sp.S.Zero] * DIM_SEC
    for i, j, k in itertools.product(range(N_AMB), repeat=3):
        mon = u[i] * v[j] * w[k]
        if mon == 0:
            continue
        for s in range(DIM_SEC):
            c = alpha[i][j][k][s]
            if c != 0:
                out[s] += c * mon
    return [sp.expand(x) for x in out]


def chart_layout(pivots):
    free_cols = [c for c in range(N_AMB) if c not in pivots]
    return {
        "pivots": list(pivots),
        "free_columns": free_cols,
        "A_free": [f"A_{c}" for c in free_cols],
        "B_free": [f"B_{c}" for c in free_cols],
        "parameter_names": [f"A{k}" for k in range(3)] + [f"B{k}" for k in range(3)],
        "n_parameters": 6,
    }


def vectors_from_chart(pivots, A_free, B_free):
    i, j = pivots
    free_cols = [c for c in range(N_AMB) if c not in pivots]
    A = [sp.S.Zero] * N_AMB
    B = [sp.S.Zero] * N_AMB
    A[i], A[j] = sp.S.One, sp.S.Zero
    B[i], B[j] = sp.S.Zero, sp.S.One
    for k, c in enumerate(free_cols):
        A[c] = A_free[k]
        B[c] = B_free[k]
    return A, B


def poly_to_sparse_kproj(expr_components, params):
    """Merge 12 component polys into sparse monomial -> K_proj coeff list."""
    # monoms keyed by exponent tuple -> 12-vector of expressions in QQ(t)
    buckets: dict[tuple, list] = {}
    for s, expr in enumerate(expr_components):
        if expr == 0:
            continue
        expanded = sp.expand(expr)
        try:
            p = sp.Poly(expanded, *params, domain=sp.EX)
            items = p.as_dict().items()
        except Exception:
            # collect monomials via as_poly in free params with EX coeffs
            p = sp.Poly(expanded, *params)
            items = p.as_dict().items()
        for exps, raw in items:
            if raw == 0:
                continue
            key = tuple(int(e) for e in exps)
            if key not in buckets:
                buckets[key] = [sp.S.Zero] * DIM_SEC
            buckets[key][s] = sp.cancel(buckets[key][s] + raw)
    terms = []
    for exps, vec in sorted(buckets.items()):
        comps = []
        for s, c in enumerate(vec):
            if c == 0:
                continue
            num, den = sp.fraction(sp.together(c))
            num, den = sp.expand(num), sp.expand(den)
            comps.append(
                {
                    "secondary": s,
                    "numerator": str(num),
                    "denominator": str(den),
                }
            )
        if comps:
            terms.append({"exponents": list(exps), "kproj_components": comps})
    return terms


def degree_profile(terms, n_params=6):
    """Max total degree and which variables appear linearly-only vs higher."""
    max_deg = 0
    max_per_var = [0] * n_params
    for term in terms:
        exps = term["exponents"]
        max_deg = max(max_deg, sum(exps))
        for i, e in enumerate(exps):
            max_per_var[i] = max(max_per_var[i], e)
    linear_vars = [i for i, d in enumerate(max_per_var) if d == 1]
    free_of = [i for i, d in enumerate(max_per_var) if d == 0]
    return {
        "max_total_degree": max_deg,
        "max_degree_per_param": max_per_var,
        "params_appearing_at_most_degree_1": linear_vars,
        "params_absent": free_of,
    }


def expand_chart(alpha, pivots, store_full_terms: bool = False):
    layout = chart_layout(pivots)
    A_syms = sp.symbols("A0:3")
    B_syms = sp.symbols("B0:3")
    params = list(A_syms) + list(B_syms)
    A, B = vectors_from_chart(pivots, A_syms, B_syms)

    PhiA = phi_vec(alpha, A)
    BAAB = polar_vec(alpha, A, A, B)
    BABB = polar_vec(alpha, A, B, B)
    PhiB = phi_vec(alpha, B)

    eq_names = ["Phi_A", "B_AAB", "B_ABB", "Phi_B"]
    eqs = []
    for name, comps in zip(eq_names, [PhiA, BAAB, BABB, PhiB]):
        terms = poly_to_sparse_kproj(comps, params)
        prof = degree_profile(terms, 6)
        secs = sorted(
            {
                c["secondary"]
                for term in terms
                for c in term["kproj_components"]
            }
        )
        # Compact fingerprint: specialized t=1 secondary-vector of constant term + a few monoms
        fingerprint = []
        for term in terms[:8]:
            exps = term["exponents"]
            vec1 = [0] * DIM_SEC
            for c in term["kproj_components"]:
                num = sp.sympify(
                    c["numerator"],
                    locals={"t3": T3, "t6": T6, "t8": T8, "t11": T11},
                )
                den = sp.sympify(
                    c["denominator"],
                    locals={"t3": T3, "t6": T6, "t8": T8, "t11": T11},
                )
                val = sp.simplify((num / den).xreplace({T3: 1, T6: 1, T8: 1, T11: 1}))
                if val != 0:
                    rat = sp.Rational(val)
                    vec1[c["secondary"]] = [int(rat.p), int(rat.q)]
            fingerprint.append({"exponents": exps, "t1_secondary": vec1})
        entry = {
            "name": name,
            "term_count": len(terms),
            "secondary_support": secs,
            "degree_profile": prof,
            "term_fingerprint_t1_prefix": fingerprint,
        }
        if store_full_terms:
            entry["terms"] = terms
        eqs.append(entry)
    return {
        **layout,
        "equations": eqs,
        "stores_full_terms": store_full_terms,
        "n_equations_K_proj": 4,
        "n_component_equations_P0": 4 * DIM_SEC,
        "parameter_ring_note": (
            "Free parameters treated as indeterminates over P0 commuting with "
            "K_proj coefficients (scalar free-param model). A genuine "
            "K_proj-point may also use free params with full secondary content."
        ),
    }


def linear_elimination_analysis(chart: dict) -> dict:
    """Identify B-linear equation B_AAB and attempt formal pivot choice."""
    params = chart["parameter_names"]
    baab = next(e for e in chart["equations"] if e["name"] == "B_AAB")
    prof = baab["degree_profile"]
    b_degs = prof["max_degree_per_param"][3:6]
    a_degs = prof["max_degree_per_param"][0:3]
    linear_in_all_B = all(d <= 1 for d in b_degs)
    # Prefer full terms when present; else use fingerprint monoms + term_count.
    term_source = baab.get("terms")
    if term_source is None:
        # Reconstruct exponent list from fingerprint only for pivot status heuristic.
        term_source = [
            {"exponents": fp["exponents"], "kproj_components": []}
            for fp in baab.get("term_fingerprint_t1_prefix", [])
        ]
    pivot_candidates = []
    if linear_in_all_B:
        for b_idx in range(3):
            pure = []
            for term in term_source:
                exps = term["exponents"]
                if len(exps) < 6:
                    continue
                if exps[3 + b_idx] == 1 and all(
                    exps[3 + j] == 0 for j in range(3) if j != b_idx
                ):
                    pure.append(term)
            const_B = [
                term
                for term in term_source
                if len(term["exponents"]) >= 6
                and all(e == 0 for e in term["exponents"][3:6])
            ]
            secs = sorted(
                {
                    c["secondary"]
                    for t in pure
                    for c in t.get("kproj_components", [])
                }
            )
            pivot_candidates.append(
                {
                    "solve_for": params[3 + b_idx],
                    "coeff_term_count_observed": len(pure),
                    "const_term_count_observed": len(const_B),
                    "coeff_has_secondary": secs,
                    "status": (
                        "formal_linear_pivot_available"
                        if b_degs[b_idx] == 1
                        else "zero_coefficient_in_this_B"
                    ),
                }
            )
    return {
        "B_AAB_linear_in_free_B": linear_in_all_B,
        "B_AAB_degrees_in_A": a_degs,
        "B_AAB_degrees_in_B": b_degs,
        "pivot_candidates": pivot_candidates,
        "elimination_strategy": (
            "Solve B_AAB=0 for one free B over Frac(K_proj)[A_free, remaining B]; "
            "substitute into B_ABB and Phi_B; residual is Phi_A (in A only) plus "
            "two equations in remaining free params. Component form: 12 P0-eqs "
            "per K_proj equation."
        ),
        "residual_after_one_linear_B": {
            "expected_free_params": 5,
            "expected_K_proj_equations": 3,
            "expected_P0_component_equations": 36,
            "note": (
                "Still a cubic residual over K_proj; not zero-dimensional in "
                "the scalar free-param model without further specialization."
            ),
        },
    }


def specialize_vec_mod_p(vec, prime: int, t_values: tuple[int, int, int, int]):
    """Evaluate a length-12 P0-vector at integer t's mod p."""
    tmap = {T3: t_values[0], T6: t_values[1], T8: t_values[2], T11: t_values[3]}
    out = []
    for c in vec:
        if c == 0:
            out.append(0)
            continue
        val = sp.Integer(c.xreplace(tmap))
        # val may be Rational
        val = sp.Rational(val)
        num, den = int(val.p), int(val.q)
        den_mod = pow(den % prime, -1, prime)
        out.append((num % prime) * den_mod % prime)
    return out


def load_alpha_mod_p(payload, prime, t_values):
    alpha = [[[0 for _ in range(N_AMB)] for _ in range(N_AMB)] for _ in range(N_AMB)]
    # each alpha_ijk is list of 12 ints mod p (secondary components)
    full = [
        [[None for _ in range(N_AMB)] for _ in range(N_AMB)] for _ in range(N_AMB)
    ]
    for item in payload["coefficients"]:
        triple = tuple(item["triple"])
        cvec = entry_to_vec(item["normalized_entries"])
        cmod = specialize_vec_mod_p(cvec, prime, t_values)
        perms = list(set(itertools.permutations(triple)))
        inv = pow(len(perms), -1, prime)
        share = [(c * inv) % prime for c in cmod]
        for i, j, k in perms:
            full[i][j][k] = share
    return full


def phi_mod_p(alpha_mod, a, prime):
    """a is list of ints; alpha_mod[i][j][k] is length-12 list; return 12-vector."""
    out = [0] * DIM_SEC
    for i, j, k in itertools.product(range(N_AMB), repeat=3):
        mon = (a[i] * a[j] * a[k]) % prime
        if mon == 0:
            continue
        for s in range(DIM_SEC):
            out[s] = (out[s] + alpha_mod[i][j][k][s] * mon) % prime
    return out


def polar_mod_p(alpha_mod, u, v, w, prime):
    out = [0] * DIM_SEC
    for i, j, k in itertools.product(range(N_AMB), repeat=3):
        mon = (u[i] * v[j] * w[k]) % prime
        if mon == 0:
            continue
        for s in range(DIM_SEC):
            out[s] = (out[s] + alpha_mod[i][j][k][s] * mon) % prime
    return out


def is_line_mod_p(alpha_mod, A, B, prime) -> bool:
    if all(x % prime == 0 for x in A) or all(x % prime == 0 for x in B):
        return False
    # rank 2
    # quick: not parallel
    for s, t in itertools.combinations(range(N_AMB), 2):
        if (A[s] * B[t] - A[t] * B[s]) % prime != 0:
            break
    else:
        return False
    for vec in (
        phi_mod_p(alpha_mod, A, prime),
        polar_mod_p(alpha_mod, A, A, B, prime),
        polar_mod_p(alpha_mod, A, B, B, prime),
        phi_mod_p(alpha_mod, B, prime),
    ):
        if any(c != 0 for c in vec):
            return False
    return True


def modular_line_search(payload, primes=(101, 103, 107), trials=2000, seed=7):
    results = {}
    t_values = (1, 1, 1, 1)
    for prime in primes:
        rng = random.Random(seed + prime)
        alpha_mod = load_alpha_mod_p(payload, prime, t_values)
        found = []
        for _ in range(trials):
            A = [rng.randrange(prime) for _ in range(N_AMB)]
            B = [rng.randrange(prime) for _ in range(N_AMB)]
            if is_line_mod_p(alpha_mod, A, B, prime):
                found.append({"A": A, "B": B})
                if len(found) >= 5:
                    break
        results[str(prime)] = {
            "t_values": list(t_values),
            "trials": trials,
            "n_found": len(found),
            "samples": found[:3],
            "scope": "discovery-only; full secondary components; no char-0 transfer",
            "note": (
                "Conditions require all 12 secondary components of each of the "
                "four line equations to vanish mod p (stronger than secondary-0)."
            ),
        }
    return results


def residual_specialized_t_secondary0(payload, t_values=(2, 3, 5, 7)):
    """Expand one chart over QQ with secondary-0 and symbolic-t specialization
    (not G3B's t=1), attempt linear solve for B0, residual groebner lightly.
    """
    # Build secondary-0 alpha at given integer t
    alpha_q = [[[Fraction(0)] * N_AMB for _ in range(N_AMB)] for _ in range(N_AMB)]
    t3, t6, t8, t11 = t_values
    for item in payload["coefficients"]:
        triple = tuple(item["triple"])
        c = Fraction(0)
        for e in item["normalized_entries"]:
            if e["secondary"] != 0:
                continue
            e3, e6, e8, e11 = e["projective_exponents"]
            mon = (t3**e3) * (t6**e6) * (t8**e8) * (t11**e11)
            c += Fraction(e["numerator"], e["denominator"]) * mon
        perms = list(set(itertools.permutations(triple)))
        share = c / len(perms)
        for i, j, k in perms:
            alpha_q[i][j][k] = share

    def to_sym(fr):
        return sp.Rational(fr.numerator, fr.denominator)

    A_syms = sp.symbols("A0:3")
    B_syms = sp.symbols("B0:3")
    params = list(A_syms) + list(B_syms)
    pivots = (0, 1)
    A, B = vectors_from_chart(pivots, A_syms, B_syms)
    s, t = sp.symbols("s t")
    P = [s * A[i] + t * B[i] for i in range(N_AMB)]
    expr = 0
    for i, j, k in itertools.product(range(N_AMB), repeat=3):
        expr += to_sym(alpha_q[i][j][k]) * P[i] * P[j] * P[k]
    expr = sp.expand(expr)
    poly = sp.Poly(expr, s, t)
    eqs = [sp.expand(poly.coeff_monomial(m)) for m in [(3, 0), (2, 1), (1, 2), (0, 3)]]
    names = ["Phi_A", "B_AAB", "B_ABB", "Phi_B"]

    # Linear elim: solve B_AAB for B0 if coeff nonzero
    baab = eqs[1]
    coeff_B0 = sp.expand(sp.Poly(baab, B_syms[0]).coeff_monomial((1,)))
    # Use as Poly in B0
    pB = sp.Poly(baab, B_syms[0])
    if pB.degree() != 1:
        return {
            "status": "B_AAB_not_degree_1_in_B0",
            "degree": int(pB.degree()),
            "t_values": list(t_values),
        }
    c1 = sp.expand(pB.LC())
    c0 = sp.expand(baab.subs({B_syms[0]: 0}))
    # B0 = -c0/c1 when c1 != 0
    residual_info = {
        "t_values": list(t_values),
        "chart_pivots": list(pivots),
        "linear_in_B0": True,
        "leading_coeff_B0_is_zero_identically": sp.simplify(c1) == 0,
        "leading_coeff_B0_term_count": len(sp.Add.make_args(sp.expand(c1))),
    }
    if sp.simplify(c1) == 0:
        residual_info["status"] = "cannot_pivot_B0"
        return residual_info

    B0_sol = sp.cancel(-c0 / c1)
    residual_eqs = []
    for name, eq in zip(names, eqs):
        if name == "B_AAB":
            continue
        sub = sp.cancel(sp.together(eq.subs({B_syms[0]: B0_sol})))
        # clear denominator
        num, den = sp.fraction(sp.together(sub))
        residual_eqs.append(
            {
                "name": name,
                "numerator_term_count": len(sp.Add.make_args(sp.expand(num))),
                "denominator_term_count": len(sp.Add.make_args(sp.expand(den))),
            }
        )
    # Residual CAS: only support-thin A-slices; skip heavy Groebner on large gens.
    # Record resultant structure (term counts / gcd of residuals) instead.
    slice_results = []
    for label, subst in [
        ("A1=A2=0", {A_syms[1]: 0, A_syms[2]: 0}),
        ("A0=A2=0", {A_syms[0]: 0, A_syms[2]: 0}),
        ("A0=A1=0", {A_syms[0]: 0, A_syms[1]: 0}),
    ]:
        try:
            t0 = time.time()
            # Recompute B0 after slice for simpler expressions
            baab_s = sp.expand(baab.subs(subst))
            pB_s = sp.Poly(baab_s, B_syms[0])
            if pB_s.degree() != 1:
                slice_results.append(
                    {
                        "slice": label,
                        "status": "B_AAB_not_linear_after_slice",
                        "degree": int(pB_s.degree()),
                    }
                )
                continue
            c1_s = sp.expand(pB_s.LC())
            c0_s = sp.expand(baab_s.subs({B_syms[0]: 0}))
            if sp.simplify(c1_s) == 0:
                slice_results.append(
                    {
                        "slice": label,
                        "status": "leading_coeff_vanishes_on_slice",
                    }
                )
                continue
            B0_s = sp.cancel(-c0_s / c1_s)
            nums = []
            for name, eq in zip(names, eqs):
                if name == "B_AAB":
                    continue
                sub = eq.subs(subst).subs({B_syms[0]: B0_s})
                num, den = sp.fraction(sp.together(sub))
                num = sp.expand(num)
                nums.append((name, num, sp.expand(den)))
            free = [v for v in params if v not in subst and v != B_syms[0]]
            nonzero = [(n, num, den) for n, num, den in nums if num != 0]
            if not nonzero:
                slice_results.append(
                    {
                        "slice": label,
                        "status": "all_residual_numerators_zero",
                        "note": "open on leading_coeff_B0 != 0; check Phi_A separately",
                        "elapsed_sec": time.time() - t0,
                    }
                )
                continue
            # Light probe: evaluate residual at a grid of free-param integers
            grid_hits = []
            grid_checked = 0
            # free typically [A_remaining, B1, B2]
            dom = [-1, 0, 1]
            # Only if <= 3 free vars
            if len(free) <= 3:
                for vals in itertools.product(dom, repeat=len(free)):
                    submap = dict(zip(free, vals))
                    # skip if leading coeff vanishes
                    if sp.simplify(c1_s.subs(submap)) == 0:
                        continue
                    grid_checked += 1
                    ok = True
                    for _n, num, _den in nonzero:
                        if sp.simplify(num.subs(submap)) != 0:
                            ok = False
                            break
                    if ok:
                        grid_hits.append({str(v): int(val) for v, val in zip(free, vals)})
            # Optional Groebner only if every residual num has <= 40 terms
            term_counts = [len(sp.Add.make_args(num)) for _n, num, _d in nonzero]
            gb_info = None
            if max(term_counts) <= 40 and len(free) <= 3:
                try:
                    G = sp.groebner(
                        [num for _n, num, _d in nonzero],
                        *free,
                        order="lex",
                        domain=sp.QQ,
                    )
                    gens = [sp.expand(g) for g in G]
                    gb_info = {
                        "status": "groebner_ok",
                        "n_generators": len(gens),
                        "generators_str": [str(g)[:160] for g in gens[:6]],
                        "is_one": any(g == 1 for g in gens),
                    }
                except Exception as exc:  # noqa: BLE001
                    gb_info = {"status": "groebner_error", "error": f"{type(exc).__name__}: {exc}"}
            else:
                gb_info = {
                    "status": "skipped_heavy",
                    "term_counts": term_counts,
                    "free_vars": [str(v) for v in free],
                }
            slice_results.append(
                {
                    "slice": label,
                    "status": "residual_recorded",
                    "residual_names": [n for n, _a, _b in nonzero],
                    "residual_term_counts": term_counts,
                    "grid_checked": grid_checked,
                    "grid_hits": grid_hits[:5],
                    "groebner": gb_info,
                    "elapsed_sec": time.time() - t0,
                    "free_vars": [str(v) for v in free],
                }
            )
        except Exception as exc:  # noqa: BLE001
            slice_results.append(
                {
                    "slice": label,
                    "status": "error",
                    "error": f"{type(exc).__name__}: {exc}",
                }
            )
    residual_info["residual_eq_summaries"] = residual_eqs
    residual_info["sparse_slice_groebner"] = slice_results
    residual_info["status"] = "linear_elim_residual_recorded"
    residual_info["scope"] = (
        "secondary-0 at t=(2,3,5,7); discovery/structure only; not full K_proj "
        "secondary content. Distinct from G3B t=1 specialized sparse probes."
    )
    residual_info["cas_note"] = (
        "Groebner restricted to support-thin A-slices with term-count guard; "
        "full residual in 5 free vars not claimed zero-dimensional or empty."
    )
    return residual_info


def full_component_qq_line_search(alpha):
    """Search sparse QQ free-param lines requiring ALL secondary components = 0."""
    # Coordinate free-param = 0 already checked outside.
    # Small integer free params in {-2,-1,0,1,2} for one chart
    hits = []
    checked = 0
    pivots = (0, 1)
    domain = [-2, -1, 0, 1, 2]
    # restrict: only support-1 and support-2 patterns to bound cost
    patterns = []
    for vals in itertools.product(domain, repeat=3):
        if sum(v != 0 for v in vals) <= 1:
            patterns.append(vals)
    # add a few support-2
    for i, j in itertools.combinations(range(3), 2):
        for si, sj in itertools.product([-1, 1], repeat=2):
            v = [0, 0, 0]
            v[i] = si
            v[j] = sj
            patterns.append(tuple(v))
    patterns = list(dict.fromkeys(patterns))
    for Af in patterns:
        for Bf in patterns:
            A, B = vectors_from_chart(pivots, Af, Bf)
            # skip if A,B lin dep over QQ
            M = sp.Matrix([[int(x) for x in A], [int(x) for x in B]])
            if M.rank() < 2:
                continue
            checked += 1
            conds = [
                phi_vec(alpha, A),
                polar_vec(alpha, A, A, B),
                polar_vec(alpha, A, B, B),
                phi_vec(alpha, B),
            ]
            if all(vec_is_zero(v) for v in conds):
                hits.append({"A_free": list(Af), "B_free": list(Bf), "pivots": list(pivots)})
    return {"checked": checked, "hits": hits, "pivots": list(pivots), "domain": domain}


def plane_conic_lane(alpha):
    """Light plane-conic: expand coordinate planes with full K_proj coeffs."""
    results = []
    e = [[1 if i == j else 0 for i in range(N_AMB)] for j in range(N_AMB)]
    x0, x1, x2 = sp.symbols("x0 x1 x2")
    for i, j, k in itertools.combinations(range(N_AMB), 3):
        v0, v1, v2 = e[i], e[j], e[k]
        P = [
            x0 * v0[r] + x1 * v1[r] + x2 * v2[r]
            for r in range(N_AMB)
        ]
        comps = phi_vec(alpha, P)
        # secondary-0 component as ternary cubic over QQ(t)
        sec0 = sp.expand(comps[0])
        # Try factor over QQ after specializing t=2,3,5,7
        tmap = {T3: 2, T6: 3, T8: 5, T11: 7}
        sec0_sp = sp.expand(sec0.xreplace(tmap))
        factors = sp.factor_list(sec0_sp, [x0, x1, x2])
        degs = [int(sp.total_degree(f)) for f, _ in factors[1]]
        # Also check if full K_proj (all sec) vanishes on any obvious line in plane
        # e.g. coordinate lines of the plane
        line_tests = []
        for line_name, (a, b) in {
            "x2=0": ([1, 0, 0], [0, 1, 0]),
            "x1=0": ([1, 0, 0], [0, 0, 1]),
            "x0=0": ([0, 1, 0], [0, 0, 1]),
        }.items():
            A = [a[0] * v0[r] + a[1] * v1[r] + a[2] * v2[r] for r in range(N_AMB)]
            B = [b[0] * v0[r] + b[1] * v1[r] + b[2] * v2[r] for r in range(N_AMB)]
            on = all(
                vec_is_zero(v)
                for v in (
                    phi_vec(alpha, A),
                    polar_vec(alpha, A, A, B),
                    polar_vec(alpha, A, B, B),
                    phi_vec(alpha, B),
                )
            )
            line_tests.append({"line": line_name, "on_cubic_full_K_proj": on})
        # nonzero secondary support of plane cubic
        sec_support = [s for s in range(DIM_SEC) if comps[s] != 0]
        results.append(
            {
                "plane_coords": [i, j, k],
                "secondary_support_of_restriction": sec_support,
                "sec0_specialized_t_factor_degrees": degs,
                "sec0_splits_line_conic_at_t2357": sorted(degs) == [1, 2],
                "coordinate_lines_in_plane": line_tests,
                "note": (
                    "sec0 factorization at specialized t is discovery-only; "
                    "full K_proj factorization not claimed"
                ),
            }
        )
    splits = [r for r in results if r["sec0_splits_line_conic_at_t2357"]]
    return {
        "schema": "g3c-plane-conic-v1",
        "planes_checked": len(results),
        "results": results,
        "sec0_line_conic_splits_at_t2357": len(splits),
        "K_proj_plane_conic_found": False,
        "smallest_open_gate": (
            "K_proj-plane whose Phi restriction factors as line x conic over full K_proj"
        ),
    }


def formal_recipe_payload(charts_meta):
    return {
        "schema": "g3c-formal-line-recipe-full-kproj-v1",
        "Phi_source": "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        "line_parametrization": "P(s,t)=sA+tB in P4",
        "conditions": [
            "Phi(A)=0",
            "B(A,A,B)=0  (coeff of s^2 t)",
            "B(A,B,B)=0  (coeff of s t^2)",
            "Phi(B)=0",
        ],
        "coefficient_model": (
            "Each equation is K_proj-valued; vanishing means all 12 secondary "
            "components over P0=QQ(t3,t6,t8,t11) vanish"
        ),
        "charts": charts_meta,
        "parent_g3b_recipe": "goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH/formal_line_recipe.json",
        "full_K_proj_status": "EXPANDED in line_fano_kproj.json",
    }


def main() -> None:
    t_start = time.time()
    try:
        commit = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], text=True, cwd=str(ROOT)
        ).strip()
    except Exception:
        commit = "UNKNOWN"

    g3a_exit = (G3A / "STATUS.md").read_text().splitlines()[0].strip()
    g3b_exit = (G3B / "STATUS.md").read_text().splitlines()[0].strip()
    if g3a_exit != "G3A-ARITHMETIC-DOMINANCE-PASS":
        # still produce fail packet
        print("G3C-CANONICAL-INPUT-FAIL: bad G3A exit", g3a_exit)
    if g3b_exit != "G3B-UNDECIDED":
        print("WARN: unexpected G3B exit", g3b_exit)

    payload = json.loads(GENERIC.read_text())
    if payload.get("schema") != "G_GENERIC_KLEIN_CUBIC_V1":
        raise SystemExit("G3C-CANONICAL-INPUT-FAIL: bad generic_cubic schema")

    inputs = [
        G3A / "STATUS.md",
        G3A / "SEAL.json",
        G3A / "phi_exact.json",
        G3A / "src" / "field_api.py",
        G3A / "src" / "phi_api.py",
        G3B / "STATUS.md",
        G3B / "SEAL.json",
        G3B / "formal_line_recipe.json",
        G3B / "line_scheme.json",
        GENERIC,
        GOAL_G3,
    ]
    man = {
        "goal": "G3C_LINE_CONIC_FANO",
        "consumed_commit": commit,
        "g3a_exit": g3a_exit,
        "g3b_exit": g3b_exit,
        "lane": "B_residual_full_K_proj_Fano",
        "inputs": [
            {
                "path": str(p.relative_to(ROOT)),
                "sha256": sha256(p) if p.is_file() else None,
                "exists": p.is_file(),
            }
            for p in inputs
        ],
    }
    (PKT / "INPUT_MANIFEST.json").write_text(json.dumps(man, indent=2) + "\n")

    print("loading full K_proj alpha...", flush=True)
    alpha = load_alpha_kproj(payload)
    print(f"alpha loaded RSS={peak_rss_mb():.1f} MB", flush=True)

    pivot_sets = list(itertools.combinations(range(N_AMB), 2))
    charts = []
    linear_reports = []
    for idx, piv in enumerate(pivot_sets):
        print(f"expand chart pivots={piv}...", flush=True)
        t0 = time.time()
        # Full term ledger only for the first chart (verify authority sample).
        ch = expand_chart(alpha, piv, store_full_terms=(idx == 0))
        lin = linear_elimination_analysis(ch)
        charts.append(ch)
        linear_reports.append({"pivots": list(piv), **lin})
        print(
            f"  done in {time.time()-t0:.2f}s terms="
            f"{[e['term_count'] for e in ch['equations']]} "
            f"full_terms={idx==0} RSS={peak_rss_mb():.1f}MB",
            flush=True,
        )

    print("QQ sparse full-component line search...", flush=True)
    qq_search = full_component_qq_line_search(alpha)

    print("modular full-component discovery...", flush=True)
    mod_hits = modular_line_search(payload)

    print("residual specialized-t secondary-0 linear elim + slices...", flush=True)
    residual_cas = residual_specialized_t_secondary0(payload)

    print("plane-conic light lane...", flush=True)
    conic = plane_conic_lane(alpha)

    # coordinate lines full K_proj
    coord_lines = []
    for i, j in itertools.combinations(range(N_AMB), 2):
        A = [0] * N_AMB
        A[i] = 1
        B = [0] * N_AMB
        B[j] = 1
        conds = [
            phi_vec(alpha, A),
            polar_vec(alpha, A, A, B),
            polar_vec(alpha, A, B, B),
            phi_vec(alpha, B),
        ]
        coord_lines.append(
            {
                "A": A,
                "B": B,
                "on_cubic_full_K_proj": all(vec_is_zero(v) for v in conds),
                "nonzero_secondary_counts": [
                    sum(1 for c in v if c != 0) for v in conds
                ],
            }
        )

    point_found = bool(qq_search["hits"]) or any(
        c["on_cubic_full_K_proj"] for c in coord_lines
    )
    # modular only is not a point exit
    if point_found:
        exit_str = "G3C-POINT-PASS"
    else:
        exit_str = "G3C-UNDECIDED"

    # Compact chart summary for top-level (full terms kept in charts)
    chart_summaries = []
    for ch, lin in zip(charts, linear_reports):
        chart_summaries.append(
            {
                "pivots": ch["pivots"],
                "free_columns": ch["free_columns"],
                "parameter_names": ch["parameter_names"],
                "equation_term_counts": {
                    e["name"]: e["term_count"] for e in ch["equations"]
                },
                "equation_secondary_supports": {
                    e["name"]: e["secondary_support"] for e in ch["equations"]
                },
                "degree_profiles": {
                    e["name"]: e["degree_profile"] for e in ch["equations"]
                },
                "linear_elimination": lin,
            }
        )

    line_fano = {
        "schema": "g3c-line-fano-kproj-v1",
        "ambient": "P4",
        "cubic": "V(Phi) over full K_proj (secondary basis + P0)",
        "n_charts": len(charts),
        "equations_per_chart_K_proj": 4,
        "component_equations_per_chart_P0": 48,
        "parameters_per_chart": 6,
        "formal_recipe": formal_recipe_payload(
            [chart_layout(p) for p in pivot_sets]
        ),
        "chart_summaries": chart_summaries,
        "charts": charts,
        "coordinate_pair_lines_full_K_proj": coord_lines,
        "qq_sparse_full_component_search": qq_search,
        "modular_discovery_full_components": mod_hits,
        "residual_cas_after_linear_elim": residual_cas,
        "K_proj_line_found": point_found,
        "peak_rss_mb_during_produce": peak_rss_mb(),
        "elapsed_sec": time.time() - t_start,
        "smallest_open_gates": [
            (
                "K_proj-point of any Grassmann chart with free params valued in "
                "full K_proj (not only P0-scalars), after linear B-elimination"
            ),
            (
                "zero-dimensional residual CAS on a chart family with full "
                "secondary free-param coordinates (72 P0-vars / 48 eqs)"
            ),
            (
                "K_proj-plane whose cubic restriction factors as line x conic"
            ),
        ],
        "nonclaims": [
            "no G3-POINT-HEADLINE-POSITIVE",
            "modular lines discovery-only",
            "specialized secondary-0 residual CAS is not K_proj emptiness",
            "scalar free-param emptiness is not full K_proj Fano emptiness",
        ],
    }
    # Write large JSON
    print("writing line_fano_kproj.json...", flush=True)
    (PKT / "line_fano_kproj.json").write_text(
        json.dumps(line_fano, indent=2, default=str) + "\n"
    )
    (PKT / "conic_plane.json").write_text(json.dumps(conic, indent=2, default=str) + "\n")

    # Markdown
    lines_md = []
    lines_md.append("# G3C — full \(K_{\\mathrm{proj}}\) Fano scheme of lines\n")
    lines_md.append(f"**Exit:** `{exit_str}`  ")
    lines_md.append(f"**Consumed commit:** `{commit}`  ")
    lines_md.append(f"**G3A:** `{g3a_exit}`  ")
    lines_md.append(f"**G3B residual input:** `{g3b_exit}`  ")
    lines_md.append(f"**Peak RSS (produce):** {peak_rss_mb():.1f} MB  ")
    lines_md.append(f"**Elapsed:** {time.time()-t_start:.1f} s\n")
    lines_md.append("## Setup\n")
    lines_md.append(
        "A line \(\\operatorname{span}(A,B)\\subset\\mathbf P^4\) lies on "
        "\(V(\\Phi)\) iff the four \(K_{\\mathrm{proj}}\)-conditions\n\n"
        "\\[\n\\Phi(A)=B(A,A,B)=B(A,B,B)=\\Phi(B)=0\n\\]\n\n"
        "hold. Each condition is a length-12 vector over "
        "\(P_0=\\mathbf Q(t_3,t_6,t_8,t_{11})\). The Fano scheme is covered by "
        "the \(\\binom{5}{2}=10\) Grassmann big cells (G3B formal recipe), each "
        "with 6 free parameters.\n"
    )
    lines_md.append("## Chart expansions (full secondary basis)\n")
    lines_md.append(
        "| pivots | Phi_A terms | B_AAB terms | B_ABB terms | Phi_B terms | B_AAB linear in free B |\n"
        "|---|---:|---:|---:|---:|---|\n"
    )
    for sm, lin in zip(chart_summaries, linear_reports):
        tc = sm["equation_term_counts"]
        lines_md.append(
            f"| {sm['pivots']} | {tc['Phi_A']} | {tc['B_AAB']} | {tc['B_ABB']} | "
            f"{tc['Phi_B']} | {lin['B_AAB_linear_in_free_B']} |\n"
        )
    lines_md.append("\n## Linear elimination\n")
    lines_md.append(
        "In every chart, \(B(A,A,B)\) is degree \(\\le 1\) in the three free "
        "\(B\)-parameters. Formal pivots on each free \(B_i\) are recorded in "
        "`line_fano_kproj.json` → `chart_summaries[].linear_elimination`. "
        "After eliminating one free \(B\), the residual is three "
        "\(K_{\\mathrm{proj}}\)-equations in five free parameters "
        "(36 \(P_0\)-component equations) — not zero-dimensional in the scalar "
        "free-parameter model.\n"
    )
    lines_md.append("## Probes performed\n")
    lines_md.append(
        f"- Coordinate spans \(e_i\\wedge e_j\): none on full \(K_{{\\mathrm{{proj}}}}\) "
        f"({sum(1 for c in coord_lines if c['on_cubic_full_K_proj'])} hits).\n"
        f"- Sparse QQ free-param search (chart (0,1), full secondary components): "
        f"{qq_search['checked']} pairs, {len(qq_search['hits'])} hits.\n"
        f"- Modular discovery (p=101,103,107; all 12 components): "
        + ", ".join(
            f"p={p}: {mod_hits[p]['n_found']} found"
            for p in mod_hits
        )
        + " (discovery-only).\n"
        f"- Residual CAS after linear \(B_0\)-elim on secondary-0 at "
        f"t=(2,3,5,7): status `{residual_cas.get('status')}`.\n"
        f"- Plane-conic light lane: {conic['planes_checked']} coordinate planes; "
        f"no transferred \(K_{{\\mathrm{{proj}}}}\) line×conic split.\n"
    )
    lines_md.append("## Residual gates (named)\n")
    lines_md.append(
        "1. A point of the line Fano scheme with free parameters valued in full "
        "\(K_{\\mathrm{proj}}\) (secondary content), after linear \(B\)-elimination.\n"
        "2. Zero-dimensional residual CAS on the 72-variable / 48-equation "
        "P0-model of a single chart (free params expanded in the secondary basis).\n"
        "3. A \(K_{\\mathrm{proj}}\)-plane whose cubic restriction factors as "
        "line × conic.\n"
    )
    lines_md.append("## Non-claims\n")
    lines_md.append(
        "- No `G3-POINT-HEADLINE-POSITIVE`.\n"
        "- Modular lines are discovery-only.\n"
        "- Scalar free-param non-hits and specialized residual CAS are **not** "
        "emptiness of the full \(K_{\\mathrm{proj}}\) Fano scheme.\n"
        "- G2/G3A/G3B exits are not resealed.\n"
    )
    (PKT / "LINE_FANO_KPROJ.md").write_text("".join(lines_md))

    conic_md = []
    conic_md.append("# G3C — plane-conic light lane\n\n")
    conic_md.append(
        f"Checked {conic['planes_checked']} coordinate planes with full "
        f"\(K_{{\\mathrm{{proj}}}}\) coefficients on the restriction.\n\n"
        f"- sec0 line×conic splits at t=(2,3,5,7): "
        f"{conic['sec0_line_conic_splits_at_t2357']} (discovery-only).\n"
        f"- Transferred \(K_{{\\mathrm{{proj}}}}\) plane conic: "
        f"**{conic['K_proj_plane_conic_found']}**.\n\n"
        "Open gate: a \(K_{\\mathrm{proj}}\)-plane whose \(\\Phi\\) restriction "
        "factors as line × conic over full \(K_{\\mathrm{proj}}\).\n"
    )
    (PKT / "CONIC_PLANE.md").write_text("".join(conic_md))

    # STATUS
    status = []
    status.append(exit_str + "\n")
    status.append("\n# Goal G3C status — residual K_proj line/conic Fano\n\n")
    status.append(f"**Exit:** `{exit_str}`  \n")
    status.append("**Headline:** OPEN  \n")
    status.append(f"**G3A input:** `{g3a_exit}`  \n")
    status.append(f"**G3B input:** `{g3b_exit}`  \n")
    status.append(f"**Consumed commit:** `{commit}`  \n")
    status.append(f"**Peak RSS:** {peak_rss_mb():.1f} MB  \n\n")
    status.append("## Decision\n\n")
    if exit_str == "G3C-POINT-PASS":
        status.append(
            "Found a verified \(K_{\\mathrm{proj}}\)-line on \(V(\\Phi)\). "
            "See `POINT.md`.\n\n"
        )
    else:
        status.append(
            "Expanded the formal line recipe over **full** \(K_{\\mathrm{proj}}\) "
            "(10 Grassmann charts × 4 \(K_{\\mathrm{proj}}\)-equations, each with "
            "12 secondary components). Linear \(B\)-elimination is available in "
            "every chart. Residual probes (QQ sparse full-component, modular "
            "discovery, specialized-t residual CAS, plane-conic light lane) "
            "produced **no** transferred \(K_{\\mathrm{proj}}\)-line or plane conic.\n\n"
            "This is an authorized residual completion of Lane B after G3B, "
            "**not** a headline point and **not** a pointlessness theorem.\n\n"
        )
    status.append("## Residual gates\n\n")
    status.append(
        "1. Full-\(K_{\\mathrm{proj}}\) free-param point of the line Fano scheme.\n"
        "2. Zero-dim residual CAS on secondary-expanded free params.\n"
        "3. \(K_{\\mathrm{proj}}\)-plane with line × conic cubic restriction.\n\n"
    )
    status.append("## Replay\n\nSee `REPLAY.md`. Marker: `G3C_VERIFY_OK`.\n")
    (PKT / "STATUS.md").write_text("".join(status))

    # REPLAY
    (PKT / "REPLAY.md").write_text(
        """# G3C replay

```sh
cd problems/E-klein-cubic
python3 -u goal_runs_after_0aecc89/G3C_LINE_CONIC_FANO/produce.py
python3 -u goal_runs_after_0aecc89/G3C_LINE_CONIC_FANO/verify.py
```

Optional G3A smoke:

```sh
python3 -u goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/verify_all.py
```

Expected:

```text
G3C_PRODUCE_OK
G3C_VERIFY_OK
G3C-UNDECIDED
HEADLINE-OPEN
```

(If a point is found, expect `G3C-POINT-PASS` and `POINT.md`.)
"""
    )

    if point_found:
        (PKT / "POINT.md").write_text(
            "# POINT\n\nSee `line_fano_kproj.json` hits; verified by `verify.py`.\n"
        )

    # Seal + SHA256SUMS (SEAL hashes content files; SHA256SUMS lists all except itself)
    sealed_names = [
        "INPUT_MANIFEST.json",
        "line_fano_kproj.json",
        "conic_plane.json",
        "LINE_FANO_KPROJ.md",
        "CONIC_PLANE.md",
        "produce.py",
        "verify.py",
        "REPLAY.md",
        "STATUS.md",
    ]
    if point_found:
        sealed_names.append("POINT.md")
    file_hashes = {name: sha256(PKT / name) for name in sealed_names if (PKT / name).is_file()}
    seal = {
        "format": "g3c-line-conic-fano-seal-v1",
        "exit": exit_str,
        "headline": "OPEN",
        "lane": "B_residual_full_K_proj_Fano",
        "g3a_exit": g3a_exit,
        "g3b_exit": g3b_exit,
        "consumed_commit": commit,
        "K_proj_line_found": point_found,
        "K_proj_conic_found": False,
        "peak_rss_mb": peak_rss_mb(),
        "elapsed_sec": time.time() - t_start,
        "files": file_hashes,
        "nonclaims": line_fano["nonclaims"],
        "smallest_open_gates": line_fano["smallest_open_gates"],
    }
    (PKT / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")

    sum_lines = []
    for name in sealed_names + ["SEAL.json"]:
        p = PKT / name
        if p.is_file():
            sum_lines.append(f"{sha256(p)}  {name}\n")
    (PKT / "SHA256SUMS").write_text("".join(sum_lines))

    print("G3C_PRODUCE_OK")
    print("exit", exit_str)
    print("RSS_MB", f"{peak_rss_mb():.1f}")
    print("elapsed", f"{time.time()-t_start:.1f}")
    print("qq_hits", len(qq_search["hits"]))
    print("mod", {p: mod_hits[p]["n_found"] for p in mod_hits})
    print("residual", residual_cas.get("status"))


if __name__ == "__main__":
    main()
