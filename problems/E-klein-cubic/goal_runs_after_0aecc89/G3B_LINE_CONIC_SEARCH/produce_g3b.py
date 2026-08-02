#!/usr/bin/env python3
"""Produce G3B line/conic ledgers from generic_cubic + G3A bindings."""
from __future__ import annotations

import hashlib
import itertools
import json
import random
import subprocess
from fractions import Fraction
from pathlib import Path

import sympy as sp

ROOT = Path(__file__).resolve().parents[2]
PKT = Path(__file__).resolve().parent
G3A = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
G2 = ROOT / "goal_runs_after_35fa/G_UNIVERSAL"


def sha256(p: Path) -> str:
    h = hashlib.sha256()
    with p.open("rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            h.update(c)
    return h.hexdigest()


def load_alpha_specialized(payload, t_values=(1, 1, 1, 1)):
    alpha = [[[Fraction(0)] * 5 for _ in range(5)] for _ in range(5)]
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
            alpha[i][j][k] = share
    return alpha


def phi(alpha, a):
    s = Fraction(0)
    for i, j, k in itertools.product(range(5), repeat=3):
        s += alpha[i][j][k] * a[i] * a[j] * a[k]
    return s


def polar_B(alpha, u, v, w):
    s = Fraction(0)
    for i, j, k in itertools.product(range(5), repeat=3):
        s += alpha[i][j][k] * u[i] * v[j] * w[k]
    return s


def line_conditions(alpha, A, B):
    return {
        "Phi_A": phi(alpha, A),
        "B_AAB": polar_B(alpha, A, A, B),
        "B_ABB": polar_B(alpha, A, B, B),
        "Phi_B": phi(alpha, B),
    }


def is_line_on_cubic(alpha, A, B):
    cond = line_conditions(alpha, A, B)
    return all(v == 0 for v in cond.values())


def chart_param_names(pivots):
    free_cols = [c for c in range(5) if c not in pivots]
    return {
        "pivots": list(pivots),
        "free_columns": free_cols,
        "A_free": [f"A_{c}" for c in free_cols],
        "B_free": [f"B_{c}" for c in free_cols],
        "n_parameters": 6,
    }


def vectors_from_chart(pivots, A_free, B_free):
    i, j = pivots
    free_cols = [c for c in range(5) if c not in pivots]
    A = [0] * 5
    B = [0] * 5
    A[i], A[j] = 1, 0
    B[i], B[j] = 0, 1
    for k, c in enumerate(free_cols):
        A[c] = A_free[k]
        B[c] = B_free[k]
    return A, B


def expand_line_equations_chart(alpha, pivots):
    free_cols = [c for c in range(5) if c not in pivots]
    A_syms = sp.symbols(f"A0:{len(free_cols)}")
    B_syms = sp.symbols(f"B0:{len(free_cols)}")
    A, B = vectors_from_chart(pivots, A_syms, B_syms)

    def to_sym(fr):
        return sp.Rational(fr.numerator, fr.denominator)

    s, t = sp.symbols("s t")
    P = [s * A[i] + t * B[i] for i in range(5)]
    expr = 0
    for i, j, k in itertools.product(range(5), repeat=3):
        expr += to_sym(alpha[i][j][k]) * P[i] * P[j] * P[k]
    expr = sp.expand(expr)
    poly = sp.Poly(expr, s, t)
    params = list(A_syms) + list(B_syms)
    out = []
    for mon in [(3, 0), (2, 1), (1, 2), (0, 3)]:
        coeff = sp.expand(poly.coeff_monomial(mon))
        p = sp.Poly(coeff, *params, domain=sp.QQ)
        terms = []
        for exps, raw in p.as_dict().items():
            if raw == 0:
                continue
            rat = sp.Rational(raw)
            terms.append(
                {
                    "exponents": list(exps),
                    "coefficient": [int(sp.fraction(rat)[0]), int(sp.fraction(rat)[1])],
                }
            )
        out.append(
            {
                "monomial_s_t": list(mon),
                "terms": terms,
                "term_count": len(terms),
            }
        )
    return {
        "pivots": list(pivots),
        "parameter_names": [str(p) for p in params],
        "equations": out,
        "n_equations": 4,
        "n_parameters": 6,
    }


def search_lines_mod_p(alpha, prime, trials=3000, seed=1):
    rng = random.Random(seed + prime)
    found = []
    ap = [
        [[int(alpha[i][j][k] % prime) for k in range(5)] for j in range(5)]
        for i in range(5)
    ]

    def phi_p(a):
        s = 0
        for i, j, k in itertools.product(range(5), repeat=3):
            s = (s + ap[i][j][k] * a[i] * a[j] * a[k]) % prime
        return s

    def B_p(u, v, w):
        s = 0
        for i, j, k in itertools.product(range(5), repeat=3):
            s = (s + ap[i][j][k] * u[i] * v[j] * w[k]) % prime
        return s

    for _ in range(trials):
        A = [rng.randrange(prime) for _ in range(5)]
        B = [rng.randrange(prime) for _ in range(5)]
        if sp.Matrix([A, B]).rank() < 2:
            continue
        if (
            phi_p(A) == 0
            and phi_p(B) == 0
            and B_p(A, A, B) == 0
            and B_p(A, B, B) == 0
        ):
            found.append({"A": A, "B": B})
            if len(found) >= 5:
                break
    return found


def search_sparse_lines_QQ(alpha):
    hits = []
    for i, j in itertools.combinations(range(5), 2):
        A = [0] * 5
        A[i] = 1
        B = [0] * 5
        B[j] = 1
        cond = line_conditions(alpha, A, B)
        hits.append(
            {
                "type": "coordinate_span",
                "A": A,
                "B": B,
                "on_cubic": all(v == 0 for v in cond.values()),
                "conditions": {k: str(v) for k, v in cond.items()},
            }
        )
    # support-size limited: vectors with at most 2 nonzero entries in {-1,1}
    found_on = []
    checked = 0
    patterns = []
    for supp in itertools.combinations(range(5), 2):
        for s0 in (-1, 1):
            for s1 in (-1, 1):
                v = [0] * 5
                v[supp[0]] = s0
                v[supp[1]] = s1
                patterns.append(v)
    for i in range(5):
        for s in (-1, 1):
            v = [0] * 5
            v[i] = s
            patterns.append(v)
    # dedupe
    uniq = []
    seen = set()
    for v in patterns:
        key = tuple(v)
        if key not in seen:
            seen.add(key)
            uniq.append(v)
    for A in uniq:
        for B in uniq:
            if sp.Matrix([A, B]).rank() < 2:
                continue
            checked += 1
            if is_line_on_cubic(alpha, A, B):
                found_on.append({"A": A, "B": B})
    return hits, found_on, checked


def factor_plane_cubic_QQ(alpha, v0, v1, v2):
    x0, x1, x2 = sp.symbols("x0 x1 x2")
    P = [x0 * v0[i] + x1 * v1[i] + x2 * v2[i] for i in range(5)]
    expr = 0
    for i, j, k in itertools.product(range(5), repeat=3):
        expr += (
            sp.Rational(alpha[i][j][k].numerator, alpha[i][j][k].denominator)
            * P[i]
            * P[j]
            * P[k]
        )
    expanded = sp.expand(expr)
    return str(sp.factor(expanded)), sp.factor_list(expanded, [x0, x1, x2])


def search_planes_factor(alpha):
    results = []
    checked = 0
    e = [[1 if i == j else 0 for i in range(5)] for j in range(5)]
    candidates = []
    for i, j, k in itertools.combinations(range(5), 3):
        candidates.append((e[i], e[j], e[k], f"coord_{i}{j}{k}"))
    extra = [
        ([1, 0, 0, 0, 0], [0, 1, 0, 0, 0], [0, 0, 1, 1, 0]),
        ([1, 0, 0, 0, 0], [0, 1, 0, 0, 0], [0, 0, 1, 0, 1]),
        ([1, 1, 0, 0, 0], [0, 1, 1, 0, 0], [0, 0, 1, 1, 0]),
        ([1, 0, 0, 0, 1], [0, 1, 0, 0, 1], [0, 0, 1, 0, 1]),
        ([1, 0, 1, 0, 0], [0, 1, 0, 1, 0], [0, 0, 1, 0, 1]),
        ([1, 0, 0, 1, 0], [0, 1, 0, 0, 1], [0, 0, 1, 1, 0]),
        ([1, 1, 0, 0, 1], [0, 1, 1, 0, 0], [0, 0, 0, 1, 1]),
    ]
    for idx, trip in enumerate(extra):
        candidates.append((trip[0], trip[1], trip[2], f"extra_{idx}"))
    for v0, v1, v2, label in candidates:
        if sp.Matrix([v0, v1, v2]).rank() < 3:
            continue
        checked += 1
        fact_str, fl = factor_plane_cubic_QQ(alpha, v0, v1, v2)
        factors = [(str(f), m) for f, m in fl[1]]
        degrees = [int(sp.total_degree(f)) for f, _ in fl[1]]
        results.append(
            {
                "label": label,
                "v0": v0,
                "v1": v1,
                "v2": v2,
                "factorization": fact_str,
                "factor_degrees": degrees,
                "factors": factors,
                "splits_as_line_conic": sorted(degrees) == [1, 2],
                "completely_split_linear": degrees.count(1) == 3 and len(degrees) == 3,
            }
        )
    return results, checked


def main() -> None:
    commit = subprocess.check_output(["git", "rev-parse", "HEAD"], text=True).strip()
    payload = json.loads(GENERIC.read_text())
    alpha = load_alpha_specialized(payload)

    inputs = [
        G3A / "STATUS.md",
        G3A / "SEAL.json",
        G3A / "dominance_bridge.json",
        GENERIC,
        G2 / "STATUS.md",
        G2 / "DECISION.md",
        G3A / "src" / "phi_api.py",
        G3A / "phi_exact.json",
    ]
    man = {
        "goal": "G3B_LINE_CONIC_SEARCH",
        "consumed_commit": commit,
        "g3a_exit": (G3A / "STATUS.md").read_text().splitlines()[0].strip(),
        "g2_exit": (G2 / "STATUS.md").read_text().splitlines()[0].strip(),
        "specialization_note": (
            "Executable line/conic ledgers use secondary-0 slice at t3=t6=t8=t11=1 "
            "over QQ. Full K_proj coefficients remain in generic_cubic.json. "
            "Modular hits are discovery-only."
        ),
        "inputs": [
            {
                "path": str(p.relative_to(ROOT)),
                "sha256": sha256(p),
                "exists": p.is_file(),
            }
            for p in inputs
        ],
    }
    (PKT / "INPUT_MANIFEST.json").write_text(json.dumps(man, indent=2) + "\n")

    pivot_sets = list(itertools.combinations(range(5), 2))
    charts = []
    for piv in pivot_sets:
        meta = chart_param_names(piv)
        eqs = expand_line_equations_chart(alpha, piv)
        charts.append({**meta, **eqs})
    line_scheme = {
        "schema": "g3b-line-scheme-v1",
        "ambient": "P4",
        "cubic": "V(Phi) specialized secondary-0 t=1",
        "n_charts": len(charts),
        "equations_per_chart": 4,
        "parameters_per_chart": 6,
        "charts": charts,
        "description": (
            "Phi(sA+tB)=0 identically iff four bihomogeneous conditions; "
            "each chart uses rref pivots."
        ),
    }
    (PKT / "line_scheme.json").write_text(json.dumps(line_scheme, indent=2) + "\n")

    coord_hits, sparse_on, n_checked = search_sparse_lines_QQ(alpha)
    mod_hits = {
        str(p): search_lines_mod_p(alpha, p, trials=3000, seed=42)
        for p in (67, 89, 23)
    }
    residual_lines = {
        "schema": "g3b-line-residual-v1",
        "specialization": "secondary-0, t*=1 over QQ",
        "coordinate_pair_lines": coord_hits,
        "sparse_support_search": {
            "support_size_le": 2,
            "pairs_checked": n_checked,
            "lines_found_on_cubic": sparse_on,
            "K_proj_transfer": False,
            "note": "Empty sparse search is a nonverdict for the full K_proj Fano scheme",
        },
        "modular_discovery": {
            p: {
                "n_found": len(hits),
                "samples": hits[:3],
                "scope": "discovery-only; no char-0 transfer claimed",
            }
            for p, hits in mod_hits.items()
        },
        "smallest_open_gate": (
            "K_proj-point of the 4-equation Fano scheme of lines in any "
            "Grassmann chart with full secondary-basis coefficients"
        ),
    }
    (PKT / "line_search.json").write_text(json.dumps(residual_lines, indent=2) + "\n")

    plane_results, n_planes = search_planes_factor(alpha)
    split = [
        r
        for r in plane_results
        if r["splits_as_line_conic"] or r["completely_split_linear"]
    ]
    conic_ledger = {
        "schema": "g3b-plane-conic-v1",
        "specialization": "secondary-0, t*=1 over QQ",
        "planes_checked": n_planes,
        "results": plane_results,
        "line_conic_splits_found": len(split),
        "split_samples": split[:5],
        "implication": (
            "A K_proj-plane conic on X_gen forces a residual plane line over "
            "K_proj and hence a K_proj-point"
        ),
        "K_proj_conic_found": False,
        "note": (
            "No tested plane yields a transferred K_proj conic; specialized "
            "factorizations are not characteristic-zero transfer"
        ),
        "smallest_open_gate": (
            "existence of a K_proj-plane whose cubic restriction factors as "
            "line * irreducible conic"
        ),
    }
    (PKT / "conic_search.json").write_text(json.dumps(conic_ledger, indent=2) + "\n")

    formal = {
        "schema": "g3b-formal-line-recipe-v1",
        "Phi_source": "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        "line_parametrization": "P(s,t)=sA+tB in P4",
        "conditions": [
            "Phi(A)=0",
            "B(A,A,B)=0  (coeff of s^2 t)",
            "B(A,B,B)=0  (coeff of s t^2)",
            "Phi(B)=0",
        ],
        "polar_definition": (
            "B(u,v,w)=sum alpha_ijk u_i v_j w_k with alpha from the symmetric "
            "triple ledger of Phi"
        ),
        "charts": [chart_param_names(piv) for piv in pivot_sets],
        "full_K_proj_status": (
            "OPEN — specialized QQ/mod p ledgers installed; full secondary-basis "
            "coefficient expansion remains residual"
        ),
    }
    (PKT / "formal_line_recipe.json").write_text(json.dumps(formal, indent=2) + "\n")

    print("G3B_PRODUCE_OK")
    print("charts", len(charts))
    print("sparse_on", len(sparse_on), "checked", n_checked)
    print("mod hits", {p: len(h) for p, h in mod_hits.items()})
    print("plane splits", len(split), "of", n_planes)


if __name__ == "__main__":
    main()
