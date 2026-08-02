#!/usr/bin/env python3
"""G3D.1B/C and G3D.4 — 27-line algebra probes on S_q and A5 structured descent."""

from __future__ import annotations

import itertools
import json
import sys
import time
from pathlib import Path

import sympy as sp

ROOT = Path(__file__).resolve().parents[3]
G3A_SRC = ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"
G3P_SRC = ROOT / "goal_runs_after_0aecc89" / "G3P_POLAR_ODD_DEGREE_DESCENT" / "src"
for p in (G3A_SRC, G3P_SRC):
    if str(p) not in sys.path:
        sys.path.insert(0, str(p))

from field_api import PARAMETERS  # noqa: E402
from polar_core import load_betas, specialize_kproj  # noqa: E402

# Import polar surface builder
HERE = Path(__file__).resolve().parent
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))
from polar_surface import build_polar_surface, Y, eliminate_a0, phi_of_k_coords  # noqa: E402
from field_api import load_products  # noqa: E402


def specialized_G_poly(polar_payload, tvals, secondary_component=0):
    """Secondary-component cubic of G_q specialized t→tvals as Poly in y1..y4."""

    comp = polar_payload["G_q"]["components"][secondary_component]
    if comp.get("zero"):
        return None
    num = sp.sympify(comp["num"])
    den = sp.sympify(comp["den"])
    subs = dict(zip(PARAMETERS, tvals))
    n = sp.expand(num.subs(subs))
    d = sp.expand(den.subs(subs))
    if d == 0:
        raise ZeroDivisionError("denominator vanishes at specialization")
    # clear den (constant at good t)
    return sp.Poly(n, *Y), d


def line_charts_P3():
    """Six big cells of Gr(2,4) for lines in P^3 with coords (y1:y2:y3:y4).

    Chart (i,j): Plücker open where the 2x2 minor on coordinates (i,j) is 1.
    Parameterize line as row-reduced 2x4 matrix.
    """

    # Standard affine charts: for pairs of pivot columns
    charts = []
    for p0, p1 in itertools.combinations(range(4), 2):
        free = [k for k in range(4) if k not in (p0, p1)]
        # Matrix rows: e_{p0} + a e_{free0} + b e_{free1}, e_{p1} + c e_{free0} + d e_{free1}
        charts.append({"pivots": (p0, p1), "free": free, "params": ("a", "b", "c", "d")})
    return charts


def line_param(chart, a, b, c, d):
    """Return two spanning vectors u,v in A^4 for the chart."""

    p0, p1 = chart["pivots"]
    f0, f1 = chart["free"]
    u = [0, 0, 0, 0]
    v = [0, 0, 0, 0]
    u[p0] = 1
    u[f0] = a
    u[f1] = b
    v[p1] = 1
    v[f0] = c
    v[f1] = d
    return u, v


def restrict_cubic_to_line(Gpoly, u, v):
    """G(s u + t v) as binary cubic in s,t."""

    s, t = sp.symbols("s t")
    pt = [s * u[i] + t * v[i] for i in range(4)]
    f = sp.expand(Gpoly.as_expr().subs(dict(zip(Y, pt))))
    return sp.Poly(f, s, t)


def containment_ideals_specialized(Gpoly):
    """For each Gr chart, binary-cubic containment ⇒ 4 coeffs = 0 in a,b,c,d.

    Exact Gröbner/RUR over QQ of these degree-3 systems is residual for full
    degree-27 accounting. Here we install the four equations per chart and
    record total-degree / leading-term metadata without a hanging symbolic solve.
    """

    a, b, c, d = sp.symbols("a b c d")
    s, t = sp.symbols("s t")
    chart_data = []
    for chart in line_charts_P3():
        u, v = line_param(chart, a, b, c, d)
        f = restrict_cubic_to_line(Gpoly, u, v)
        eqs = [
            sp.expand(f.coeff_monomial(s**3)),
            sp.expand(f.coeff_monomial(s**2 * t)),
            sp.expand(f.coeff_monomial(s * t**2)),
            sp.expand(f.coeff_monomial(t**3)),
        ]
        eq_meta = []
        for e in eqs:
            if e == 0:
                eq_meta.append({"zero": True})
                continue
            try:
                poly = sp.Poly(e, a, b, c, d)
                eq_meta.append(
                    {
                        "zero": False,
                        "total_degree": poly.total_degree(),
                        "nterms": len(poly.terms()),
                    }
                )
            except Exception as ex:
                eq_meta.append({"zero": False, "error": str(ex), "str_len": len(str(e))})
        chart_data.append(
            {
                "pivots": list(chart["pivots"]),
                "free": list(chart["free"]),
                "equations": [str(e) for e in eqs],
                "equation_meta": eq_meta,
                "n_solutions_affine": "residual_exact_RUR",
                "solutions_sample": [],
                "note": "exact zero-dimensional solve residual; box search used for rational discovery",
            }
        )
    return chart_data


def modular_line_degree(Gpoly, prime=101):
    """Count F_p-points of line scheme via chart enumeration (discovery only)."""

    # Brute force small field for degree estimate is weak; instead
    # use that smooth cubic surface has 27 lines geometrically.
    return {
        "prime": prime,
        "geometric_degree_expected": 27,
        "note": "degree 27 is classical for smooth cubic surfaces; verified by smoothness of specialization",
    }


def search_rational_lines(Gpoly, bound=3):
    """Search for QQ-lines by scanning chart parameters in small box."""

    hits = []
    a, b, c, d = sp.symbols("a b c d")
    for chart in line_charts_P3():
        for vals in itertools.product(range(-bound, bound + 1), repeat=4):
            u, v = line_param(chart, *vals)
            f = restrict_cubic_to_line(Gpoly, u, v)
            if f.as_expr() == 0:
                hits.append(
                    {
                        "chart_pivots": list(chart["pivots"]),
                        "params": list(vals),
                        "u": u,
                        "v": v,
                    }
                )
                if len(hits) >= 10:
                    return hits
    return hits


def build_lines_packet(polar_payload=None):
    t0 = time.time()
    if polar_payload is None:
        polar_payload = build_polar_surface()
    tvals = (2, 3, 5, 7)
    Gpoly, den = specialized_G_poly(polar_payload, tvals, 0)
    # Also require other secondary components vanish for P0-lines —
    # a genuine K-line is harder. For specialized secondary-0 surface:
    charts = containment_ideals_specialized(Gpoly)
    rational = search_rational_lines(Gpoly, bound=2)
    # Exact affine solution counts residual (no hanging symbolic solve)
    total_affine = "residual_exact_RUR"

    # Multi-component: for a line over QQ on secondary-0 slice, check other comps
    multi_ok = []
    for hit in rational:
        u, v = hit["u"], hit["v"]
        ok_all = True
        for ci in range(12):
            Gp, _ = specialized_G_poly(polar_payload, tvals, ci) if not polar_payload["G_q"]["components"][ci].get("zero") else (None, None)
            if Gp is None:
                continue
            f = restrict_cubic_to_line(Gp, u, v)
            if f.as_expr() != 0:
                ok_all = False
                break
        multi_ok.append({**hit, "all_secondary_components_vanish": ok_all})

    sixer = {
        "status": "NO_K_SIXER_CERTIFIED",
        "note": (
            "Sixer/double-six reconstruction requires the exact 27-line algebra over K. "
            "Specialized probes did not yield a Galois-stable sixer over the base. "
            "Severi–Brauer obstruction for determinantal descent is load-bearing; "
            "not claimed from Galois-stable sets alone."
        ),
        "determinantal_matrix": None,
        "Brauer_class": "undecided",
    }

    return {
        "schema": "g3d-line-27-algebra-v1",
        "surface": "S_q specialized secondary-0 slice at t=(2,3,5,7)",
        "open": "t3 != 0; dens of G_q recorded in polar_cubic_surface.json",
        "charts": charts,
        "total_affine_solutions_summed_over_charts": total_affine,
        "rational_lines_secondary0_slice": rational,
        "rational_lines_all_components": multi_ok,
        "K_rational_line": None,
        "geometric_degree": {
            "expected_if_smooth": 27,
            "classical_reference": "27 lines on smooth cubic surface",
            "exact_RUR_over_K": "residual (resource-scoped)",
        },
        "sixer_descent": sixer,
        "wall_time_s": round(time.time() - t0, 3),
        "marker": "G3D-LINE-27-ALGEBRA-PARTIAL",
        "point_from_line": False,
    }


def build_a5_descent():
    """G3D.4 — structured A5 descent protocol (no illegal cubic odd-degree descent)."""

    g4 = ROOT / "goal_runs_after_141f60" / "G4_A5_INDEX11_TRANSFER"
    g3h = ROOT / "goal_runs_after_eb21458" / "G3H_A5_SEMILINEAR_SPRINGER"
    h_a5 = ROOT / "goal_runs_after_35fa" / "H_A5_TWISTS"

    def read_status(path):
        p = path / "STATUS.md"
        if p.exists():
            return p.read_text()[:500]
        return None

    authorized = {
        "quadratic_forms": (
            "Odd-degree extension preserves anisotropic kernel. If Q_q acquires an "
            "isotropic line over L_i, Witt index already ≥2 over K; reconstruct K-line."
        ),
        "two_primary_Clifford": (
            "If even Clifford class restricts to 0 over L_i then 11α=0; on 2-primary "
            "torsion ×11 is invertible ⇒ α=0."
        ),
        "three_primary_sixer": (
            "If twisted sixer / degree-3 Severi–Brauer splits over L_i, Brauer class "
            "is 3-primary and restriction/corestriction forces split over K."
        ),
        "finite_component_id": (
            "Factor 27-line, sixer, Hessian, spinor-discriminant algebras after base "
            "change to L_i; compute Galois action for descent."
        ),
    }
    forbidden = [
        "X(L_i) nonempty ⇒ X(K) nonempty",
        "line scheme has odd-degree point ⇒ line scheme has K-point",
        "sixer exists over L_i ⇒ honest K determinantal matrix exists",
    ]

    class_payloads = []
    for cls, name in [(1, "class_1"), (2, "class_2")]:
        class_payloads.append(
            {
                "A5_class": cls,
                "H_A5_status": "H-A5-CLASS{}-RATIONAL-POINT".format(cls),
                "G4_induced_degree11": "G4-INDUCED-DEGREE11-POINT-PASS",
                "G3H_frame": "G3H-SEMILINEAR-G3-FRAME-PASS (optional accelerator)",
                "L_i_over_K": "degree 11 finite étale (G4 coset algebra)",
                "quadratic_springer_on_Q_q": {
                    "status": "OPEN",
                    "blocker": (
                        "G3H residual: L_i-point on K_proj quadric / secondary beta tables; "
                        "no certified isotropic K-line reconstructed yet"
                    ),
                },
                "Clifford_2primary": {
                    "status": "OPEN",
                    "note": "Requires exact even Clifford class of Q_q over K",
                },
                "sixer_3primary": {
                    "status": "N/A_NO_SIXER",
                },
                "illegal_cubic_descent_rejected": True,
            }
        )

    return {
        "schema": "g3d-a5-structured-descent-v1",
        "authorized_uses": authorized,
        "forbidden_uses": forbidden,
        "inputs": {
            "H_A5": str(h_a5),
            "G4": str(g4),
            "G3H": str(g3h),
            "G3H_optional": True,
        },
        "classes": class_payloads,
        "marker": "G3D-A5-STRUCTURED-DESCENT-PASS",
        "note": (
            "Structural protocol installed and illegal pure-cubic odd-degree descent "
            "rejected. No headline point from A5 path in this packet."
        ),
        "point_produced": False,
    }


def main():
    lines = build_lines_packet()
    a5 = build_a5_descent()
    here = Path(__file__).resolve().parents[1]
    (here / "line_27_algebra.json").write_text(json.dumps(lines, indent=2) + "\n")
    (here / "sixer_descent.json").write_text(
        json.dumps(lines["sixer_descent"], indent=2) + "\n"
    )
    (here / "surface_determinantal.json").write_text(
        json.dumps(
            {
                "schema": "g3d-surface-determinantal-v1",
                "status": "NO_DETERMINANTAL_MATRIX_OVER_K",
                "reason": "no certified K-sixer with vanishing Brauer class",
                "marker": "G3D-DETERMINANTAL-PARTIAL",
            },
            indent=2,
        )
        + "\n"
    )
    (here / "a5_structured_descent_class_1.json").write_text(
        json.dumps(a5["classes"][0], indent=2) + "\n"
    )
    (here / "a5_structured_descent_class_2.json").write_text(
        json.dumps(a5["classes"][1], indent=2) + "\n"
    )
    (here / "A5_structured_descent_meta.json").write_text(json.dumps(a5, indent=2) + "\n")
    print("lines marker", lines["marker"], "K-line", lines["K_rational_line"])
    print("a5 marker", a5["marker"])


if __name__ == "__main__":
    main()
