#!/usr/bin/env python3
"""G5 producer: exact f5/f6 residue cubic models from the sealed generic Phi.

Stages G5.0–G5.1 (models) and a bounded G5.2 discovery probe (not a verdict).

Producer only. Verifiers must not import this module.
"""

from __future__ import annotations

import hashlib
import json
import random
import resource
import subprocess
import time
from collections import defaultdict
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

GENERIC_CUBIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
PRIMARY_NAMES = ["f3", "f5", "f6", "f8", "f11"]
SECONDARY_NAMES = [
    "1",
    "f7",
    "f9",
    "f10",
    "f12",
    "f14",
    "f7^2",
    "f7*f9",
    "f9^2",
    "f9*f10",
    "f7^3",
    "f9^2*f10",
]
FRAME_NAMES = ["x", "C", "D", "E", "K"]
FRAME_DEGREES = [1, 4, 5, 6, 7]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def peak_rss_mb() -> float:
    # macOS ru_maxrss is bytes; Linux is kilobytes.
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    if rss > 10**9:  # clearly bytes
        return rss / (1024 * 1024)
    if rss > 10**7:  # bytes on some Darwin builds
        return rss / (1024 * 1024)
    return rss / 1024.0


def reduce_entries(entries: list[dict], drop_idx: int) -> list[dict]:
    out = []
    for e in entries:
        pe = e["primary_exponents"]
        if pe[drop_idx] != 0:
            continue
        out.append(
            {
                "numerator": e["numerator"],
                "denominator": e["denominator"],
                "primary_exponents": list(pe),
                "secondary": e["secondary"],
                "primary_label": mon_label(pe, drop_idx),
                "secondary_name": SECONDARY_NAMES[e["secondary"]],
            }
        )
    return out


def mon_label(pe: list[int], drop_idx: int) -> str:
    factors = []
    for i, exp in enumerate(pe):
        if i == drop_idx or exp == 0:
            continue
        name = PRIMARY_NAMES[i]
        factors.append(name if exp == 1 else f"{name}^{exp}")
    return "*".join(factors) if factors else "1"


def triple_mult(triple: list[int]) -> int:
    i, j, k = triple
    if i == j == k:
        return 1
    if i == j or j == k or i == k:
        return 3
    return 6


def build_residue_cubic(generic: dict, site: str, drop_idx: int) -> dict:
    coeffs_out = []
    vanishing = []
    unit_terms = []
    min_term_count = 10**9
    max_term_count = 0
    total_terms = 0
    for c in generic["coefficients"]:
        red = reduce_entries(c["entries"], drop_idx)
        total_terms += len(red)
        min_term_count = min(min_term_count, len(red) if red else 0)
        max_term_count = max(max_term_count, len(red))
        if not red:
            vanishing.append(c["label"])
        # unit: pure constant secondary-0, all remaining primaries zero
        if any(
            e["secondary"] == 0
            and all(x == 0 for i, x in enumerate(e["primary_exponents"]) if i != drop_idx)
            and e["numerator"] != 0
            for e in red
        ):
            unit_terms.append(c["label"])
        # projective-normalized residual exponents (drop f5 or f6 slot)
        # keep primary exponents with the dropped coordinate removed for clarity
        compact = []
        for e in red:
            pe = e["primary_exponents"]
            residual_primaries = [pe[i] for i in range(5) if i != drop_idx]
            residual_names = [PRIMARY_NAMES[i] for i in range(5) if i != drop_idx]
            compact.append(
                {
                    "numerator": e["numerator"],
                    "denominator": e["denominator"],
                    "secondary": e["secondary"],
                    "secondary_name": e["secondary_name"],
                    "primary_exponents_full": pe,
                    "residual_primary_exponents": residual_primaries,
                    "residual_primary_names": residual_names,
                    "primary_label": e["primary_label"],
                }
            )
        coeffs_out.append(
            {
                "label": c["label"],
                "triple": list(c["triple"]),
                "frame_degree": c["degree"],
                "generic_term_count": len(c["entries"]),
                "residue_term_count": len(compact),
                "entries": compact,
            }
        )

    residual_primary_names = [PRIMARY_NAMES[i] for i in range(5) if i != drop_idx]
    payload = {
        "schema": f"g5-residue-cubic-{site}-v1",
        "site": site,
        "divisor": f"{PRIMARY_NAMES[drop_idx]}=0",
        "drop_primary_index": drop_idx,
        "drop_primary_name": PRIMARY_NAMES[drop_idx],
        "source": "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        "source_sha256": sha256(GENERIC_CUBIC),
        "model": {
            "ambient": "P^4 over residue field kappa",
            "equation": "Phi_bar(a0:a1:a2:a3:a4)=0",
            "construction": (
                "coefficientwise reduction of the sealed affine Hilbert-90 cubic "
                "F(a0*x+a1*C+a2*D+a3*E+a4*K) in the free Hironaka module; "
                f"drop every primary monomial divisible by {PRIMARY_NAMES[drop_idx]}; "
                "no uniformizer content to clear (every coefficient has valuation 0)"
            ),
            "frame_names": FRAME_NAMES,
            "frame_degrees": FRAME_DEGREES,
            "secondary_names": SECONDARY_NAMES,
            "secondary_degrees": list(generic["secondary_degrees"]),
            "residual_primary_names": residual_primary_names,
            "residual_ring_presentation": (
                f"R/({PRIMARY_NAMES[drop_idx]}) free of rank 12 over "
                f"C[{','.join(residual_primary_names)}] on the sealed secondary basis; "
                "structure constants are the affine multiplication table reduced by the same primary"
            ),
            "residue_field": (
                f"kappa = Frac(R/({PRIMARY_NAMES[drop_idx]})); "
                f"for the K_proj valuation, take the degree-zero subfield of the residue of K_aff"
            ),
        },
        "coefficient_count": 35,
        "vanishing_coefficients": vanishing,
        "has_unit_coefficient": len(unit_terms) > 0 or any(
            c["residue_term_count"] > 0 for c in coeffs_out
        ),
        "unit_like_constant_terms": unit_terms,
        "statistics": {
            "total_residue_terms": total_terms,
            "min_terms_per_coeff": min_term_count if min_term_count < 10**9 else 0,
            "max_terms_per_coeff": max_term_count,
            "nonzero_coefficients": sum(1 for c in coeffs_out if c["residue_term_count"] > 0),
        },
        "index_one": {
            "effective_cycle_degrees": [60, 132, 165, 220],
            "bezout": "-13*60 + 3*132 + 165 + 220 = 1",
            "note": (
                "universal fixed-subgroup cycles survive every scalar extension, "
                "including the residue field; index one does not supply a point"
            ),
        },
        "coefficients": coeffs_out,
        "scope": (
            "Exact residue cubic model only. No K_proj-point, no residue point, "
            "and no pointlessness claim is made by this payload alone."
        ),
    }
    return payload


def phi_module_vector(generic: dict, a: list[int], drop_idx: int) -> dict:
    acc: dict[tuple, Fraction] = defaultdict(lambda: Fraction(0))
    for c in generic["coefficients"]:
        i, j, k = c["triple"]
        mon = a[i] * a[j] * a[k]
        if mon == 0:
            continue
        mult = triple_mult([i, j, k])
        for e in c["entries"]:
            if e["primary_exponents"][drop_idx] != 0:
                continue
            key = (e["secondary"], tuple(e["primary_exponents"]))
            acc[key] += Fraction(e["numerator"], e["denominator"]) * mult * mon
    return {k: v for k, v in acc.items() if v != 0}


def expand_sec(gens: list[int], p: int) -> list[int]:
    f7, f9, f10, f12, f14 = [x % p for x in gens]
    return [
        1,
        f7,
        f9,
        f10,
        f12,
        f14,
        (f7 * f7) % p,
        (f7 * f9) % p,
        (f9 * f9) % p,
        (f9 * f10) % p,
        (f7 * f7 * f7) % p,
        (f9 * f9 * f10) % p,
    ]


def eval_red_coeff(entries: list[dict], drop: int, prim: list[int], sec: list[int], p: int):
    total = 0
    for e in entries:
        if e["primary_exponents"][drop] != 0:
            continue
        mon = 1
        for i, ex in enumerate(e["primary_exponents"]):
            if ex:
                mon = mon * pow(prim[i], ex, p) % p
        den = e["denominator"] % p
        if den == 0:
            return None
        term = (
            (e["numerator"] % p)
            * mon
            % p
            * (sec[e["secondary"]] % p)
            % p
            * pow(den, -1, p)
            % p
        )
        total = (total + term) % p
    return total


def cubic_mod(alphas: list[int], a: list[int], triples: list[list[int]], p: int) -> int:
    s = 0
    for alpha, triple in zip(alphas, triples):
        i, j, k = triple
        mult = triple_mult(triple)
        s = (s + mult * alpha * a[i] % p * a[j] % p * a[k]) % p
    return s


def partials_mod(alphas: list[int], a: list[int], triples: list[list[int]], p: int) -> list[int]:
    grads = [0] * 5
    for alpha, triple in zip(alphas, triples):
        i, j, k = triple
        if i == j == k:
            grads[i] = (grads[i] + 3 * alpha * a[i] * a[i]) % p
        elif i == j != k:
            grads[i] = (grads[i] + 6 * alpha * a[i] % p * a[k]) % p
            grads[k] = (grads[k] + 3 * alpha * a[i] * a[i]) % p
        elif j == k != i:
            grads[j] = (grads[j] + 6 * alpha * a[j] % p * a[i]) % p
            grads[i] = (grads[i] + 3 * alpha * a[j] * a[j]) % p
        else:
            grads[i] = (grads[i] + 6 * alpha * a[j] % p * a[k]) % p
            grads[j] = (grads[j] + 6 * alpha * a[i] % p * a[k]) % p
            grads[k] = (grads[k] + 6 * alpha * a[i] % p * a[j]) % p
    return grads


def modular_probe(generic: dict, drop: int, p: int = 67, trials: int = 40) -> dict:
    random.seed(0)
    triples = [c["triple"] for c in generic["coefficients"]]
    has_pt = 0
    smooth_pt = 0
    bad = 0
    samples = []
    for _ in range(trials):
        prim = [random.randrange(p) for _ in range(5)]
        prim[drop] = 0
        if all(prim[i] == 0 for i in range(5) if i != drop):
            prim[0] = 1
        sec = expand_sec([random.randrange(p) for _ in range(5)], p)
        alphas = []
        ok = True
        for c in generic["coefficients"]:
            v = eval_red_coeff(c["entries"], drop, prim, sec, p)
            if v is None:
                ok = False
                break
            alphas.append(v)
        if not ok or all(x == 0 for x in alphas):
            bad += 1
            continue
        found = None
        for __ in range(2500):
            a = [random.randrange(p) for _ in range(5)]
            if all(x == 0 for x in a):
                continue
            if cubic_mod(alphas, a, triples, p) == 0:
                found = a
                break
        if found is None:
            continue
        has_pt += 1
        gvec = partials_mod(alphas, found, triples, p)
        if any(x != 0 for x in gvec):
            smooth_pt += 1
            if len(samples) < 3:
                samples.append(
                    {
                        "point": found,
                        "primaries": prim,
                        "secondary_gens": sec[1:6],
                        "gradient_nonzero": True,
                    }
                )
    return {
        "prime": p,
        "trials": trials,
        "specializations_with_point": has_pt,
        "smooth_points_among_them": smooth_pt,
        "bad_or_zero_forms": bad,
        "samples": samples,
        "interpretation": (
            "Finite-field specializations of the residue cubic almost always have "
            "smooth points; this is discovery metadata only and is not a generic "
            "residue-field point."
        ),
    }


def constant_point_search(generic: dict, drop: int) -> dict:
    found = []
    # projective representatives with coords in -2..2
    seen = set()
    for vals in __import__("itertools").product(range(-2, 3), repeat=5):
        if all(v == 0 for v in vals):
            continue
        a = list(vals)
        for v in a:
            if v != 0:
                if v < 0:
                    a = [-x for x in a]
                break
        t = tuple(a)
        if t in seen:
            continue
        seen.add(t)
        if not phi_module_vector(generic, a, drop):
            found.append(a)
    return {
        "range": [-2, 2],
        "projective_representatives_tested": len(seen),
        "hits": found,
        "conclusion": "no constant P^4(Z)-point with Phi divisible by the primary",
    }


def coordinate_line_gcds(generic: dict, drop: int) -> list[dict]:
    import sympy as sp

    rows = []
    s, t = sp.symbols("s t")
    for i in range(5):
        for j in range(i + 1, 5):
            acc: dict = defaultdict(lambda: 0)
            a = [0, 0, 0, 0, 0]
            a[i] = s
            a[j] = t
            for c in generic["coefficients"]:
                ii, jj, kk = c["triple"]
                mon = a[ii] * a[jj] * a[kk]
                if mon == 0:
                    continue
                mult = triple_mult([ii, jj, kk])
                for e in c["entries"]:
                    if e["primary_exponents"][drop] != 0:
                        continue
                    key = (e["secondary"], tuple(e["primary_exponents"]))
                    acc[key] += sp.Rational(e["numerator"], e["denominator"]) * mult * mon
            polys = [
                sp.Poly(sp.expand(v), s, t)
                for v in acc.values()
                if sp.expand(v) != 0
            ]
            if not polys:
                rows.append(
                    {
                        "line": [FRAME_NAMES[i], FRAME_NAMES[j]],
                        "forms": 0,
                        "gcd": "0",
                        "identically_on_cubic": True,
                    }
                )
                continue
            gpoly = polys[0]
            for p in polys[1:]:
                gpoly = sp.gcd(gpoly, p)
            rows.append(
                {
                    "line": [FRAME_NAMES[i], FRAME_NAMES[j]],
                    "forms": len(polys),
                    "gcd": str(gpoly.as_expr()),
                    "gcd_total_degree": int(gpoly.total_degree()),
                    "identically_on_cubic": False,
                    "common_zero_in_P1": int(gpoly.total_degree()) > 0,
                }
            )
    return rows


def build_valuation_models(generic_sha: str) -> dict:
    return {
        "schema": "g5-valuation-models-v1",
        "field": "K_proj = C(P(W))^G with trdeg_C = 4; K_aff = C(W)^G pure transcendental of degree 1 over K_proj",
        "group": "G = PSL_2(F_11), order 660, perfect",
        "sites": {
            "f5": {
                "divisor_source": "V(f5) subset P(W), integral normal quintic",
                "quotient_center": "image D5 of V(f5) in the geometric quotient; one prime (geometrically integral)",
                "uniformizer_K_aff": "f5 (source order 1 => e(E/D)=1)",
                "uniformizer_K_proj_open": "pi5 = f3*f5/f8 on the open f3*f8 != 0",
                "ramification": "e = 1 (unramified quotient valuation)",
                "inertia": "trivial: a nonidentity projective linear g cannot fix an irreducible nonlinear hypersurface pointwise",
                "decomposition_group": "full G (only surviving unramified full-group class after V3/A5 elimination)",
                "residue_transcendence_degree_K_proj": 3,
                "residue_field": "kappa5 = Frac(R/(f5)) degree-zero part for K_proj; free rank-12 over C(f3,f6,f8,f11) before localization",
                "residue_G_torsor": (
                    "unramified generic G-torsor reduces to a genuine G-torsor over kappa5 "
                    "(finite-etale equivalence for henselian rings; not a single H90 matrix reduction)"
                ),
                "gauge_independence": (
                    "any two Hilbert-90 frames differ by GL_5 on a common open; "
                    "integral models with unit determinant reduce to isomorphic residue twists"
                ),
                "retired_bounded_fact": (
                    "degree-16 support-at-most-five emptiness on the Hironaka quotient "
                    "(V-F5-DEGREE16-SUPPORT-LE5-EMPTY) is consumed only as a finite support theorem, "
                    "not as full residue pointlessness"
                ),
            },
            "f6": {
                "divisor_source": "V(f6) subset P(W), geometrically integral sextic",
                "quotient_center": "image D6 of V(f6); one prime",
                "uniformizer_K_aff": "f6",
                "uniformizer_K_proj_open": "pi6 = f3^2/f5 * (f6-free alternate) or f6/f3^2 after tau-open; use affine f6 on K_aff",
                "alternate_weight_one_gauge": "q6 = f3^2/f5 is a unit at f6=0 when f3,f5 != 0",
                "ramification": "e = 1",
                "inertia": "trivial (same hypersurface argument)",
                "decomposition_group": "full G",
                "residue_transcendence_degree_K_proj": 3,
                "residue_field": "kappa6 = Frac(R/(f6)) degree-zero part",
                "residue_G_torsor": "unramified reduction of the generic G-torsor; genuine residue G-torsor",
                "gauge_independence": "same GL_5 open argument as f5",
            },
        },
        "v3_normal_form_input": "V3-RESIDUE-NORMAL-FORM-PASS",
        "generic_cubic_sha256": generic_sha,
        "marker": "G5-RESIDUE-TORSOR-MODEL-PASS",
    }


def build_input_manifest(commit: str) -> dict:
    inputs = [
        "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/STATUS.md",
        "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/SEAL.json",
        "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/RESIDUE_NORMAL_FORM_THEOREM.md",
        "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/F5_DEGREE16_SMALL_SUPPORT.md",
        "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/f5_degree16_support_payload.json",
        "goal_runs_after_35fa/G_UNIVERSAL/STATUS.md",
        "goal_runs_after_35fa/G_UNIVERSAL/SEAL.json",
        "goal_runs_after_35fa/G_UNIVERSAL/UNIVERSAL_OBJECT.md",
        "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        "goals_2026-08-01/V_VALUATION_TROPICAL_CODEX_ROOT_20260801/STATUS.md",
        "goals_2026-08-01/V_VALUATION_TROPICAL_CODEX_ROOT_20260801/SEAL.json",
        "goals_2026-08-01/V_VALUATION_TROPICAL_CODEX_ROOT_20260801/VALUATION_CENSUS.md",
        "goals_2026-08-01/V_VALUATION_TROPICAL_CODEX_ROOT_20260801/MODEL.md",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/SEAL.json",
        "tmp/kproj_arithmetic/normalized_kproj_table.json",
    ]
    rows = []
    for rel in inputs:
        path = ROOT / rel
        rows.append(
            {
                "path": rel,
                "exists": path.is_file(),
                "sha256": sha256(path) if path.is_file() else None,
            }
        )
    return {
        "goal": "G5_FULL_RESIDUE_CUBICS",
        "stages": ["G5.0", "G5.1", "G5.2"],
        "consumed_commit": commit,
        "pinned_goal_baseline": "141f6042f628f984771fc79d8d16beb12cedcb94",
        "inputs": rows,
    }


def write_json(path: Path, obj: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, indent=2) + "\n")


def main() -> None:
    t0 = time.time()
    commit = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
    ).strip()
    generic = json.loads(GENERIC_CUBIC.read_text())
    gsha = sha256(GENERIC_CUBIC)
    assert generic["schema"] == "G_GENERIC_KLEIN_CUBIC_V1"
    assert generic["coefficient_count"] == 35

    manifest = build_input_manifest(commit)
    write_json(HERE / "INPUT_MANIFEST.json", manifest)

    val_models = build_valuation_models(gsha)
    write_json(HERE / "valuation_models.json", val_models)

    f5 = build_residue_cubic(generic, "f5", 1)
    f6 = build_residue_cubic(generic, "f6", 2)
    write_json(HERE / "f5" / "residue_cubic.json", f5)
    write_json(HERE / "f6" / "residue_cubic.json", f6)

    # G5.2 probes
    point_search = {
        "schema": "g5-point-search-v1",
        "f5": {
            "constant_points": constant_point_search(generic, 1),
            "coordinate_lines": coordinate_line_gcds(generic, 1),
            "modular_specializations": modular_probe(generic, 1),
        },
        "f6": {
            "constant_points": constant_point_search(generic, 2),
            "coordinate_lines": coordinate_line_gcds(generic, 2),
            "modular_specializations": modular_probe(generic, 2),
        },
        "retired_bounded": {
            "f5_degree16_support_le5": "V-F5-DEGREE16-SUPPORT-LE5-EMPTY",
            "scope": "finite homogeneous support only; not full residue pointlessness",
        },
        "verdict": {
            "f5_residue_point": "UNDECIDED",
            "f6_residue_point": "UNDECIDED",
            "f5_pointless": "NOT_PROVED",
            "f6_pointless": "NOT_PROVED",
        },
        "residual_gates": [
            "generic rational point on the smooth index-one residue cubic over kappa5 (trdeg 3)",
            "generic rational point on the smooth index-one residue cubic over kappa6 (trdeg 3)",
            "or an authorized Lane-B obstruction (anisotropic fibration / complete descent / terminal unramified pointless residue respecting V3)",
        ],
    }
    write_json(HERE / "point_search.json", point_search)

    meta = {
        "schema": "g5-produce-meta-v1",
        "consumed_commit": commit,
        "generic_cubic_sha256": gsha,
        "wall_seconds": round(time.time() - t0, 3),
        "peak_rss_mb_approx": round(peak_rss_mb(), 2),
        "exits": {
            "primary": "G5-F5-CUBIC-MODEL-PASS",
            "per_site": {
                "f5": "G5-F5-CUBIC-MODEL-PASS",
                "f6": "G5-F6-CUBIC-MODEL-PASS",
                "torsor": "G5-RESIDUE-TORSOR-MODEL-PASS",
            },
            "point_decision": "UNDECIDED",
        },
        "f5_stats": f5["statistics"],
        "f6_stats": f6["statistics"],
        "f5_vanishing": f5["vanishing_coefficients"],
        "f6_vanishing": f6["vanishing_coefficients"],
    }
    write_json(HERE / "produce_meta.json", meta)
    print("G5_PRODUCE_OK")
    print(json.dumps(meta["exits"], indent=2))
    print(f"peak_rss_mb_approx={meta['peak_rss_mb_approx']} wall_s={meta['wall_seconds']}")


if __name__ == "__main__":
    main()
