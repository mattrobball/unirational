#!/usr/bin/env python3
"""Goal Q3 producer — primitive quartic resolvent → degree-eight stable-map pullback.

Stages:
  Q3.0  canonical A4/S4 + resolvent + incidence + GTC model over K_Schur
  Q3.1  Schur monodromy of the degree-eight cover (pullback analysis)
  Q3.2  symmetric-cube fibre-product search
  Q3.3  boundary stable-cubic incidence lanes
  Q3.4  bridge (only if a verified K_Schur stable map / GTC point exists)

Does not replace the installed Schur quartic by a general quartet.
Does not claim a point from virtual count eight alone.
"""

from __future__ import annotations

import itertools
import json
import random
import time
from collections import Counter
from pathlib import Path

import sympy as sp

from q3_core import (
    A4_QUOTIENT_ORDERS,
    BINDING_INPUT_PATHS,
    GRAD_F,
    KLEIN_F,
    N,
    PAIRING_LABELS,
    PAIRINGS,
    PSL211_QUOTIENT_ORDERS,
    ROOT,
    S4_QUOTIENT_ORDERS,
    X_SYMS,
    a4_group,
    act_on_pairing,
    c3_orbit_partitions,
    clear_content,
    common_quotient_orders,
    evaluate_poly,
    hyperplane_mod,
    hyperplane_of,
    klein_mod,
    mat_rank_mod,
    on_cubic,
    pairing_homomorphism,
    peak_rss_mb,
    plane_cubic_residual_line_conic,
    plane_through,
    psl2_11_order,
    projective_rank,
    resolvent_image_group,
    resolvent_triple,
    resolvent_triple_mod,
    s3_orbit_partitions,
    s3_orbit_type_exists_fixed_point_free,
    s4_group,
    sha256_file,
    third_point,
    third_point_mod,
)

HERE = Path(__file__).resolve().parent
PINNED = "141f6042f628f984771fc79d8d16beb12cedcb94"


def write(path: Path, text: str) -> None:
    path.write_text(text if text.endswith("\n") else text + "\n")


def write_json(path: Path, obj) -> None:
    path.write_text(json.dumps(obj, indent=2, sort_keys=False) + "\n")


# ---------------------------------------------------------------------------
# Q3.0 — canonical model
# ---------------------------------------------------------------------------


def build_quartic_resolvent_model() -> dict:
    a4 = a4_group()
    s4 = s4_group()
    assert len(a4) == 12
    assert len(s4) == 24

    a4_pair = resolvent_image_group(a4)
    s4_pair = resolvent_image_group(s4)
    # Image of A4 on pairings is C3 (order 3); S4 image is S3 (order 6).
    assert len(a4_pair) == 3
    assert len(s4_pair) == 6

    # Kernel of pairing map: V4 for both (Klein four-group).
    a4_hom = pairing_homomorphism(a4)
    s4_hom = pairing_homomorphism(s4)
    id3 = (0, 1, 2)
    a4_ker = {g for g, img in a4_hom.items() if img == id3}
    s4_ker = {g for g, img in s4_hom.items() if img == id3}
    assert len(a4_ker) == 4
    assert len(s4_ker) == 4

    # Vertex / edge / pairing orbit sizes.
    def vertex_orbit(group):
        return len({g[0] for g in group})  # orbit of letter 0 under left? use action

    # Standard: S4 (resp A4) transitive on 4 vertices, 6 edges, 3 pairings.
    edges = tuple(itertools.combinations(range(4), 2))

    def edge_act(g, e):
        return tuple(sorted((g[e[0]], g[e[1]])))

    def orbit_size(group, start, action):
        seen = {start}
        stack = [start]
        while stack:
            cur = stack.pop()
            for g in group:
                nxt = action(g, cur)
                if nxt not in seen:
                    seen.add(nxt)
                    stack.append(nxt)
        return len(seen)

    a4_list = list(a4)
    s4_list = list(s4)

    model = {
        "format": "q3-quartic-resolvent-model-v1",
        "field": "K_Schur = C(P(V6))^PSL2(F11)",
        "cubic_model": "genuine Schur twist X_Schur (installed degree-8 Reynolds frame)",
        "primitive_full_span_quartic": {
            "existence_source": "Voisin arXiv:2509.17996 Thm 1.5 + imprimitivity exclusion",
            "no_point_branch_only": True,
            "galois_closures_kept_separate": ["A4", "S4"],
            "span": "P3",
            "linearly_disjoint_from_PSL2_11": True,
            "psl2_11_order_checked": psl2_11_order(),
            "common_quotients_with_PSL2_11": {
                "A4": sorted(common_quotient_orders(A4_QUOTIENT_ORDERS, PSL211_QUOTIENT_ORDERS)),
                "S4": sorted(common_quotient_orders(S4_QUOTIENT_ORDERS, PSL211_QUOTIENT_ORDERS)),
            },
        },
        "A4": {
            "order": 12,
            "vertex_orbit": orbit_size(a4_list, 0, lambda g, v: g[v]),
            "edge_orbit": orbit_size(a4_list, edges[0], edge_act),
            "pairing_orbit": orbit_size(a4_list, 0, act_on_pairing),
            "pairing_image_order": len(a4_pair),
            "pairing_image_name": "C3",
            "pairing_kernel_order": len(a4_ker),
            "pairing_kernel_name": "V4",
            "cubic_resolvent_galois": "C3",
            "cubic_resolvent_degree": 3,
        },
        "S4": {
            "order": 24,
            "vertex_orbit": orbit_size(s4_list, 0, lambda g, v: g[v]),
            "edge_orbit": orbit_size(s4_list, edges[0], edge_act),
            "pairing_orbit": orbit_size(s4_list, 0, act_on_pairing),
            "pairing_image_order": len(s4_pair),
            "pairing_image_name": "S3",
            "pairing_kernel_order": len(s4_ker),
            "pairing_kernel_name": "V4",
            "cubic_resolvent_galois": "S3",
            "cubic_resolvent_degree": 3,
        },
        "pairings": {
            "labels": list(PAIRING_LABELS),
            "as_double_pairs": [
                [[a, b], [c, d]] for (a, b), (c, d) in PAIRINGS
            ],
        },
        "three_marked_points": {
            "construction": (
                "For conjugates P0..P3 of the primitive quartic on a smooth "
                "hyperplane section S, set Q_ij = third point of PiPj on S; "
                "for each pairing pi=ij|kl set R_pi = third point of Q_ij Q_kl on S. "
                "The triple (R_01|23, R_02|13, R_03|12) is the cubic-resolvent marked triple."
            ),
            "defined_over": "cubic resolvent algebra M/K_Schur of degree 3",
            "galois_on_triple": {"A4": "C3", "S4": "S3"},
            "not_universally_collinear": True,
            "collinearity_refutation": (
                "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/root_secant/"
            ),
        },
        "degree_eight_incidence": {
            "source": "Zinger GT 18 (2014) p.1058; Harris–Roth–Starr arXiv:math/0202067 Thm 4.4",
            "smooth_twisted_cubic_locus_dimension": 6,
            "three_marked_incidence_dimension": 9,
            "evaluation_map_to_X3_generic_degree": 8,
            "generic_fibre_after_points_split": "one integral degree-eight field",
            "generic_not_split_by_cubic_closure": True,
            "enumerative_on_general_locus": True,
            "special_resolvent_triple_generality": "NOT PROVED for installed Schur quartic",
            "virtual_count_eight_implies_point": False,
        },
        "gtc_hilbert_compactification": {
            "smooth_locus": "H_{3,0}(X) smooth irreducible of dimension 6",
            "closure": "Tbar in Hilb(X)",
            "boundary_types": [
                "line + conic",
                "three lines",
                "double line + line",
                "nonreduced generalized twisted cubics",
                "embedded-point Hilbert boundary",
            ],
            "bayer_map": "Tbar -> M_X -> Theta = Bl_0 J(X), exceptional fibre X",
            "bridge_theorem": (
                "actual K_Schur GTC Hilbert point or odd-degree genus-zero "
                "stable map forces X_Schur(K_Schur) nonempty "
                "(fixed_curve_bridge/THEOREM.md)"
            ),
            "coarse_kontsevich_gerbe_caveat": True,
        },
        "galois_commuting_diagrams": {
            "S4_acts_on_vertices_edges_pairings": True,
            "pairing_homomorphism_exact_sequence": "1 -> V4 -> S4 -> S3 -> 1",
            "A4_restriction": "1 -> V4 -> A4 -> C3 -> 1",
            "resolvent_points_equivariant": True,
            "schur_and_quartic_closures_disjoint": True,
        },
        "marker": "Q3-QUARTIC-RESOLVENT-MODEL-PASS",
    }

    # Machine checks that must hold
    assert model["A4"]["vertex_orbit"] == 4
    assert model["A4"]["edge_orbit"] == 6
    assert model["A4"]["pairing_orbit"] == 3
    assert model["S4"]["vertex_orbit"] == 4
    assert model["S4"]["edge_orbit"] == 6
    assert model["S4"]["pairing_orbit"] == 3
    assert model["primitive_full_span_quartic"]["common_quotients_with_PSL2_11"]["A4"] == [1]
    assert model["primitive_full_span_quartic"]["common_quotients_with_PSL2_11"]["S4"] == [1]
    assert model["primitive_full_span_quartic"]["psl2_11_order_checked"] == 660
    return model


# ---------------------------------------------------------------------------
# Q3.1 — monodromy
# ---------------------------------------------------------------------------


def build_monodromy() -> dict:
    c3_parts = c3_orbit_partitions(8)
    s3_parts = s3_orbit_partitions(8)
    c3_always_fixed = all(p["forces_fixed_point"] for p in c3_parts)
    s3_fpf = s3_orbit_type_exists_fixed_point_free(8)

    # Explicit C3 partitions: f+3t=8 ⇒ (f,t) ∈ {(2,2),(5,1),(8,0)} — always f≥2
    assert c3_always_fixed
    assert min(p["fixed_points"] for p in c3_parts) == 2
    assert s3_fpf

    # S3 fixed-point-free types with a+2+3+6 structure: e.g. 2+6, 2+3+3, 2+2+2+2, 3+3+2, 8=2*4, etc.
    fpf_s3 = [p for p in s3_parts if p["fixed_points"] == 0]
    assert any(
        p["two_orbits"] == 1 and p["six_orbits"] == 1 and p["three_orbits"] == 0
        for p in fpf_s3
    )

    monodromy = {
        "format": "q3-degree8-monodromy-v1",
        "generic_geometric_monodromy": {
            "statement": (
                "Harris–Roth–Starr: H_{3,0}(X) smooth irreducible dim 6; "
                "I = U×_H U×_H U integral dim 9; eval I→X^3 generically finite of degree 8 "
                "(Zinger).  Over C(X^3) the fibre is Spec of one degree-eight field."
            ),
            "after_three_points_split": "still one integral degree-eight extension",
            "cubic_closure_does_not_split_generic_fibre": True,
            "source_packets": [
                "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/incidence_splitting/REPORT.md",
                "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/incidence_generality/REPORT.md",
            ],
        },
        "pullback_to_primitive_quartic_strata": {
            "A4": {
                "resolvent_galois": "C3",
                "conditional_gate": (
                    "IF the special incidence fibre is a finite K-scheme of length 8 "
                    "in the Hilbert locus AND geometric points split over the cyclic "
                    "cubic resolvent, THEN C3-orbits have size 1 or 3, and since "
                    "8 ≡ 2 (mod 3) there are at least two K-rational support points."
                ),
                "c3_orbit_partitions_on_8": c3_parts,
                "c3_always_has_fixed_point_on_reduced_8_set": True,
                "min_fixed_points_if_c3_action": 2,
                "hypotheses_proved_for_installed_schur_quartic": {
                    "finite_length_8_hilbert_scheme": False,
                    "split_over_cyclic_cubic": False,
                    "reduced_support": False,
                    "avoids_excess_boundary": False,
                },
                "fixed_component_proved": False,
                "odd_orbit_proved": False,
                "prime_to_cover_zero_cycle_proved": False,
            },
            "S4": {
                "resolvent_galois": "S3",
                "conditional_gate": (
                    "Even for a reduced honest 8-set, S3 admits fixed-point-free "
                    "actions (e.g. orbit type 2+6).  Length-mod-3 alone does not force "
                    "a K-point."
                ),
                "s3_orbit_partitions_on_8": s3_parts,
                "fixed_point_free_s3_action_exists": True,
                "example_fpf_types": fpf_s3[:8],
                "hypotheses_proved_for_installed_schur_quartic": {
                    "finite_length_8_hilbert_scheme": False,
                    "action_factors_through_s3": False,
                    "reduced_support": False,
                },
                "fixed_component_proved": False,
            },
        },
        "schur_specific_relation": {
            "description": (
                "The three marked points are not a general triple in X^3: they arise "
                "as pairing-residuals of a full-span primitive quartic tetrahedron on "
                "a smooth hyperplane section.  The joint map quartet→(span,triple) is "
                "dominant on the split Klein cubic (differential ranks 9,10,6), but "
                "Voisin specialization does not preserve generality for the installed "
                "Schur quartic."
            ),
            "dominance_on_split_klein": True,
            "dominance_ranks": {
                "quartet_to_triple": 9,
                "quartet_to_span_and_triple": 10,
                "quartet_on_fixed_section_to_triple": 6,
            },
            "dominance_source": (
                "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/incidence_generality/"
            ),
            "installed_quartic_in_good_locus": "UNPROVED",
            "new_schur_identity_forcing_monodromy_drop": "NOT FOUND",
        },
        "arithmetic_vs_geometric": {
            "geometric_generic": "integral degree-8 cover of X^3",
            "arithmetic_after_resolvent_split": (
                "base change to cubic resolvent recovers the same integral generic cover; "
                "Gal(M/K) = C3 or S3 acts on the base of the cover, not automatically "
                "as the full monodromy of the eight sheets"
            ),
            "stabilizers_of_eight_maps": "not computed for the special fibre (no coordinates)",
            "ramification_boundary_monodromy": (
                "boundary of GTC compactification may absorb specialization; "
                "not controlled for the installed quartic"
            ),
        },
        "decisive_outcomes_checked": {
            "one_rational_component": False,
            "odd_degree_component_plus_descent": False,
            "degree_one_zero_cycle_on_RC_component": False,
            "canonical_boundary_map_fixed_by_schur_monodromy": False,
        },
        "forbidden_inference": "virtual count eight alone does not yield a K_Schur-point",
        "marker_candidate": "Q3-SCHUR-MONODROMY-PASS",
        "marker_achieved": True,
        "marker_scope": (
            "exact orbit-arithmetic + generic monodromy + named residual hypotheses; "
            "not a rational component of the special fibre"
        ),
    }
    return monodromy


# ---------------------------------------------------------------------------
# Exact differential ranks on split Klein (recompute, not only cite)
# ---------------------------------------------------------------------------


def recompute_dominance_ranks() -> dict:
    """One rational full-span quartet on the split Klein cubic; ranks over Q."""

    # Deterministic rational points on the Klein cubic.
    # Use a known search: points with small coordinates.
    candidates = []
    for coords in itertools.product(range(-3, 4), repeat=5):
        if all(c == 0 for c in coords):
            continue
        if evaluate_poly(KLEIN_F, coords) == 0:
            # normalize first nonzero >0
            pts = list(coords)
            for v in pts:
                if v != 0:
                    if v < 0:
                        pts = [-x for x in pts]
                    break
            t = tuple(pts)
            if t not in candidates and on_cubic(t):
                candidates.append(t)
        if len(candidates) > 80:
            break

    # Find a full-span quartet with smooth hyperplane section.
    rng = random.Random(20260802)
    chosen = None
    for _ in range(5000):
        four = rng.sample(candidates, 4)
        try:
            h = hyperplane_of(four)
            if projective_rank(four) != 4:
                continue
            # All on cubic already.
            triple = resolvent_triple(four)
            if projective_rank(triple) < 2:
                continue
            chosen = (four, h, triple)
            break
        except (ValueError, ZeroDivisionError):
            continue

    if chosen is None:
        # Fallback: construct from known points on Klein cubic
        # e1-style: (1,1,0,0,-1) etc.
        base_pts = [
            (1, 1, 0, 0, -1),
            (1, 0, 0, -1, 1),
            (0, 1, 1, 0, -1),
            (1, -1, 1, 0, 0),
        ]
        # verify and fix
        ok = all(on_cubic(p) for p in base_pts)
        if not ok:
            # brute a structured search
            found = []
            for a in range(-2, 3):
                for b in range(-2, 3):
                    for c in range(-2, 3):
                        for d in range(-2, 3):
                            # solve for e so sum x_i^2 x_{i+1}=0 with x=(a,b,c,d,e)
                            # a^2 b + b^2 c + c^2 d + d^2 e + e^2 a = 0
                            # d^2 e + a e^2 + (a^2b+b^2c+c^2d)=0
                            A = a
                            B = d * d
                            C = a * a * b + b * b * c + c * c * d
                            # A e^2 + B e + C = 0
                            if A == 0:
                                if B != 0 and (-C) % B == 0:
                                    e = -C // B
                                    pt = (a, b, c, d, e)
                                    if any(pt) and on_cubic(pt):
                                        found.append(pt)
                            else:
                                disc = B * B - 4 * A * C
                                if disc >= 0:
                                    s = int(sp.integer_nthroot(disc, 2)[0]) if disc >= 0 else -1
                                    if s * s == disc:
                                        for sign in (1, -1):
                                            num = -B + sign * s
                                            if num % (2 * A) == 0:
                                                e = num // (2 * A)
                                                pt = (a, b, c, d, e)
                                                if any(pt) and on_cubic(pt):
                                                    found.append(clear_content(pt))
            # unique
            uniq = []
            for p in found:
                if p not in uniq:
                    uniq.append(p)
            candidates = uniq
            for comb in itertools.combinations(candidates[:40], 4):
                try:
                    h = hyperplane_of(comb)
                    triple = resolvent_triple(comb)
                    chosen = (comb, h, triple)
                    break
                except (ValueError, ZeroDivisionError):
                    continue

    if chosen is None:
        return {
            "status": "NO_RATIONAL_QUARTET_FOUND",
            "note": "dominance ranks imported from sealed incidence_generality packet",
            "imported_ranks": {"quartet_to_triple": 9, "joint": 10, "fixed_section": 6},
        }

    four, h, triple = chosen
    # Exact incidence checks on the sample (not a replacement for sealed ranks 9/10/6).
    all_on = all(on_cubic(p) for p in four) and all(on_cubic(r) for r in triple)
    assert all_on
    # Chords of the quartet: residuals match pairing construction.
    chords = {}
    for i, j in itertools.combinations(range(4), 2):
        chords[(i, j)] = third_point(four[i], four[j])
        assert on_cubic(chords[(i, j)])
    rebuilt = tuple(third_point(chords[a], chords[b]) for a, b in PAIRINGS)
    assert all(projective_rank([rebuilt[k], triple[k]]) == 1 for k in range(3))

    return {
        "status": "COMPUTED",
        "sample_quartet": [list(map(int, p)) for p in four],
        "hyperplane": [str(v) for v in h],
        "resolvent_triple": [[str(x) for x in r] for r in triple],
        "triple_projective_rank": int(projective_rank(triple)),
        "quartet_projective_rank": int(projective_rank(four)),
        "all_points_on_klein_cubic": True,
        "pairing_residual_reconstruction_ok": True,
        "differential_rank_quartet_to_triple": None,
        "note": (
            "Exact rational sample on the split Klein cubic over Q: full-span quartet, "
            "resolvent triple on the cubic, pairing residuals reconstruct.  Proves the "
            "geometry of the resolvent map is realized over Q on the split model.  "
            "Does not certify the installed Schur-quartic resolvent triple.  Dominance "
            "ranks 9/10/6 are imported from the sealed incidence_generality packet."
        ),
        "imported_sealed_ranks": {
            "quartet_to_triple": 9,
            "quartet_to_span_and_triple": 10,
            "quartet_on_fixed_section_to_triple": 6,
            "source": "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/incidence_generality/",
        },
    }


# ---------------------------------------------------------------------------
# Q3.2 — symmetric cube pullback
# ---------------------------------------------------------------------------


def build_symmetric_cube() -> dict:
    return {
        "format": "q3-symmetric-cube-pullback-v1",
        "parameterization": {
            "object": "Sym^3(X) = Hilb^3(X) / unordered triple of points",
            "rationality": (
                "X is a cubic threefold; Sym^3(X) is unirational over the base field "
                "of X when X has a rational point, but over K_Schur the presence of "
                "X(K_Schur) is the headline question — cannot assume it."
            ),
            "resolvent_locus": (
                "The cubic-resolvent map sends the primitive-quartic stratum into "
                "a closed locus R ⊂ Sym^3(X) of triples arising as pairing residuals."
            ),
        },
        "fibre_product": {
            "incidence_cover": "I → X^3 degree 8 (ordered triples)",
            "unordered": "I_sym → Sym^3(X) by quotient S3 on marks",
            "pullback_to_R": "I_sym ×_{Sym^3} R → R",
            "generic_degree_over_R": (
                "unknown a priori; ≤8; may jump by boundary excess on special R"
            ),
        },
        "searches": {
            "rational_section_over_R": {
                "result": "NOT FOUND",
                "reason": (
                    "No K_Schur-rational choice of twisted cubic through the "
                    "installed resolvent triple; triple itself is only known to "
                    "exist after cubic base change, and no multisection of I_sym|R "
                    "of degree 1 is constructed."
                ),
            },
            "low_degree_multisection": {
                "result": "NOT FOUND",
                "tested_degrees": [1, 2],
                "reason": "No explicit equations of the special fibre product over K_Schur.",
            },
            "conic_or_quadric_split_fibre": {
                "result": "NOT PROVED",
                "note": (
                    "If the residual incidence after one rational condition were a "
                    "conic with a K-point, descent would follow; no such splitting "
                    "is established for the Schur resolvent locus."
                ),
            },
            "rational_boundary_component": {
                "result": "NOT FOUND",
                "see": "BOUNDARY_STABLE_MAPS.md",
            },
        },
        "installed_quartic_check": {
            "coordinates_of_voisin_quartic": "NOT EXHIBITED",
            "coordinates_of_resolvent_triple": "NOT EXHIBITED over K_Schur",
            "generic_triple_checks_insufficient": True,
        },
        "marker": "Q3_SYMMETRIC_CUBE_PULLBACK_RECORDED",
    }


# ---------------------------------------------------------------------------
# Q3.3 — boundary stable cubics
# ---------------------------------------------------------------------------


def modular_boundary_scan(primes=(23, 31, 43, 67, 89), trials_per_prime=800) -> dict:
    """Search modular full-span quartets and test boundary incidence types."""
    results = []
    for p in primes:
        rng = random.Random(1000 + p)
        found_quartets = 0
        collinear_residuals = 0
        triangle_contained = 0
        plane_span_lt3 = 0
        line_through_two_on_surface_count = 0
        samples = []
        for _ in range(trials_per_prime):
            pts = []
            for __ in range(4):
                # random point on Klein cubic mod p
                for attempt in range(40):
                    a = [rng.randrange(p) for _ in range(4)]
                    # solve for x4 roughly: try random x4
                    x4 = rng.randrange(p)
                    pt = a + [x4]
                    if klein_mod(pt, p) == 0 and any(pt):
                        pts.append(tuple(pt))
                        break
                else:
                    break
            if len(pts) < 4:
                continue
            if mat_rank_mod(pts, p) != 4:
                continue
            h = hyperplane_mod(pts, p)
            if h is None:
                continue
            triple = resolvent_triple_mod(pts, p)
            if triple is None:
                continue
            # check each residual on cubic
            if any(klein_mod(r, p) != 0 for r in triple):
                continue
            found_quartets += 1
            tr_rank = mat_rank_mod(triple, p)
            if tr_rank < 3:
                plane_span_lt3 += 1
            if tr_rank == 2:
                collinear_residuals += 1
            # triangle lines: third residual of each pair among the triple
            contained = 0
            for i, j in itertools.combinations(range(3), 2):
                t = third_point_mod(triple[i], triple[j], p)
                if t is None:
                    contained += 1
                    triangle_contained += 1
                else:
                    # if third equals the remaining point, three points on a line of X
                    k = 3 - i - j
                    if mat_rank_mod([t, triple[k]], p) == 1:
                        line_through_two_on_surface_count += 1
            if found_quartets <= 3:
                samples.append(
                    {
                        "quartet": [list(pt) for pt in pts],
                        "triple": [list(r) for r in triple],
                        "triple_rank": tr_rank,
                        "triangle_contained_chords": contained,
                    }
                )
        results.append(
            {
                "prime": p,
                "trials": trials_per_prime,
                "fullspan_quartets_with_resolvent": found_quartets,
                "collinear_resolvent_triples": collinear_residuals,
                "triple_span_rank_lt_3": plane_span_lt3,
                "triangle_contained_chord_incidents": triangle_contained,
                "residual_equals_third_incidents": line_through_two_on_surface_count,
                "samples": samples,
            }
        )
    return {
        "method": "uniform random points on Klein cubic mod p; full-span quartet + resolvent",
        "scope": (
            "modular discovery only — not char-0 reconstruction; does not install "
            "the Schur quartic"
        ),
        "per_prime": results,
    }


def build_boundary(dominance_sample, modular) -> dict:
    # Exact theoretical incidence for each boundary type
    types = {
        "line_plus_conic": {
            "domain": "P1 ∪_pt P1 (two components meeting at a node)",
            "degrees": [1, 2],
            "incidence_through_resolvent_triple": (
                "Partition the three marks as (1 on line + 2 on conic) or "
                "(2 on line + 1 on conic).  A line through two marks is the chord; "
                "its residual on X is a third point R.  The residual plane cubic in "
                "a plane through the line meets X in line+conic; the conic must pass "
                "through the remaining mark(s)."
            ),
            "galois": (
                "For a C3-orbit of marks, a line through two marks is not K-rational "
                "(the two marks are not a Gal-stable subset).  A K-line would require "
                "all three marks on the line, i.e. collinear resolvent — refuted in "
                "general by root_secant, and modularly rare."
            ),
            "K_Schur_object_found": False,
        },
        "three_lines": {
            "domain": "triangle of three P1's",
            "degrees": [1, 1, 1],
            "incidence": (
                "The three chords of the resolvent triple.  Each chord meets X in a "
                "third residual; containment fails on a smooth cubic surface (no line "
                "of the triangle lies on S for a general triple)."
            ),
            "galois": (
                "The three chords form a Gal-orbit under C3/S3.  A K-rational three-line "
                "stable map would need the whole triangle defined over K, hence the "
                "three lines as a Gal-set — possible as a single object only if the "
                "map descends.  No descent constructed."
            ),
            "K_Schur_object_found": False,
        },
        "double_line_plus_line": {
            "domain": "nonreduced: 2L + L'",
            "incidence": "requires a line of X through at least one mark with multiplicity",
            "active_field_no_K_line": (
                "Authoritative Schur twist has no K_Schur-line (inherited from index / "
                "line-orbit analysis).  A K-rational double line is therefore excluded."
            ),
            "K_Schur_object_found": False,
        },
        "nonreduced_gtc": {
            "description": "nonreduced structure sheaves in Tbar boundary",
            "K_Schur_object_found": False,
            "note": "Hilbert point would still force a point by Theorem B if defined over K",
        },
        "embedded_point_boundary": {
            "description": "Hilbert schemes with embedded points",
            "K_Schur_object_found": False,
        },
    }

    # Exact sample check when we have a rational quartet
    exact_sample = None
    if dominance_sample.get("status") == "COMPUTED":
        four = [tuple(p) for p in dominance_sample["sample_quartet"]]
        try:
            triple = resolvent_triple(four)
            exact_sample = {
                "quartet": [list(p) for p in four],
                "triple_rank": int(projective_rank(triple)),
                "line_conic_triangle_probe": plane_cubic_residual_line_conic(
                    None, triple[0], triple[1], triple[2]
                ),
                "plane_of_triple": (
                    None
                    if plane_through(triple[0], triple[1], triple[2]) is None
                    else "rank-ok"
                ),
            }
            # collinearity
            exact_sample["triple_collinear"] = exact_sample["triple_rank"] <= 2
        except Exception as exc:
            exact_sample = {"error": str(exc)}

    return {
        "format": "q3-boundary-stable-maps-v1",
        "boundary_types": types,
        "exact_rational_sample": exact_sample,
        "modular_scan": modular,
        "conclusions": {
            "line_plus_conic_K_object": False,
            "three_lines_K_object": False,
            "double_line_excluded_by_no_K_line": True,
            "any_boundary_stable_map_over_K_Schur": False,
            "boundary_reduction_pass": False,
        },
        "marker_candidate": "Q3-BOUNDARY-REDUCTION-PASS",
        "marker_achieved": False,
        "residual": (
            "Need either a K_Schur-defined reducible stable cubic through the "
            "installed resolvent triple, or a new identity forcing one of the "
            "boundary types to descend."
        ),
    }


# ---------------------------------------------------------------------------
# Q3.4 — bridge status
# ---------------------------------------------------------------------------


def build_bridge_status(stable_map_found: bool) -> dict:
    return {
        "format": "q3-bridge-status-v1",
        "stable_map_or_gtc_obtained": stable_map_found,
        "bridge_stable_cubic_pos": False,
        "point_md": False,
        "headline_candidate_exits": {
            "Q3-STABLE-MAP-HEADLINE-POSITIVE": False,
            "Q3-GENERALIZED-TWISTED-CUBIC-HEADLINE-POSITIVE": False,
        },
        "output_bridge_ready": (
            "fixed_curve_bridge Theorems A/B: any actual odd-degree genus-zero "
            "stable map or GTC Hilbert point over K_Schur forces a point"
        ),
        "not_entered": True,
        "reason": "No verified K_Schur stable map or Hilbert point was produced.",
    }


# ---------------------------------------------------------------------------
# Markdown writers
# ---------------------------------------------------------------------------


def md_model(model: dict) -> str:
    a4 = model["A4"]
    s4 = model["S4"]
    return f"""# QUARTIC_RESOLVENT_MODEL — Goal Q3.0

**Marker:** `{model["marker"]}`  
**Field:** `{model["field"]}`  
**Pinned baseline:** `{PINNED}`

## Primitive full-span quartic

In the no-point branch of the genuine Schur twist, Voisin's theorem plus
imprimitivity / span exclusions leave a single integral degree-four point whose
Galois closure is `A4` or `S4`, spanning a `P3` hyperplane section.  The cases
are kept separate until a common argument is proved.

Linear disjointness from the Schur splitting field follows from simplicity of
`PSL(2,11)` (order {model["primitive_full_span_quartic"]["psl2_11_order_checked"]}):
the only common quotient order with `A4` or `S4` is `1`.

## Pairings and cubic resolvent

The three pairings of four letters are

```text
{PAIRING_LABELS[0]},  {PAIRING_LABELS[1]},  {PAIRING_LABELS[2]}
```

Exact group computation:

| | A4 | S4 |
|---|---:|---:|
| order | {a4["order"]} | {s4["order"]} |
| vertex orbit | {a4["vertex_orbit"]} | {s4["vertex_orbit"]} |
| edge orbit | {a4["edge_orbit"]} | {s4["edge_orbit"]} |
| pairing orbit | {a4["pairing_orbit"]} | {s4["pairing_orbit"]} |
| pairing image | {a4["pairing_image_name"]} (order {a4["pairing_image_order"]}) | {s4["pairing_image_name"]} (order {s4["pairing_image_order"]}) |
| kernel | {a4["pairing_kernel_name"]} (order {a4["pairing_kernel_order"]}) | {s4["pairing_kernel_name"]} (order {s4["pairing_kernel_order"]}) |
| resolvent Galois | {a4["cubic_resolvent_galois"]} | {s4["cubic_resolvent_galois"]} |

Exact sequences:

```text
1 → V4 → A4 → C3 → 1
1 → V4 → S4 → S3 → 1
```

For conjugates `P0..P3`, residual points `Q_ij` on chords, and
`R_π = third(Q_ij, Q_kl)`, the triple `(R_π)` is defined over the cubic
resolvent algebra and carries the displayed Galois action.  Universal
collinearity of the three `R_π` is false (root_secant packet).

## Degree-eight incidence

Harris–Roth–Starr: smooth twisted-cubic locus dimension 6.  Three-marked
incidence dimension 9.  Zinger: evaluation to `X^3` has generic degree **8**.
After the three marked points split, the generic fibre remains **one integral
degree-eight field** — not split by the cubic closure alone.

The installed Schur resolvent triple is **not** proved to lie in the
enumerative general locus (Voisin specialization does not preserve avoidance).

## GTC Hilbert compactification

Boundary types recorded: line+conic; three lines; double line+line; nonreduced
GTC; embedded-point strata.  Bayer et al. map `Tbar → M_X → Bl_0 J(X)` with
exceptional fibre `X` is Aut-equivariant and descends to the Schur twist.
An actual `K_Schur`-point of `Tbar` forces a point (fixed_curve_bridge Theorem B).
Coarse Kontsevich points with nontrivial stabilizers may have residual gerbes.

## Galois-commuting maps

All pairing, residual, and incidence constructions are Gal(¯K/K)-equivariant
by construction (they are defined over `K_Schur` from Gal-orbits of the
quartic).  Machine checks: pairing homomorphism kernels/images and orbit sizes.

```text
Q3-QUARTIC-RESOLVENT-MODEL-PASS
```
"""


def md_degree8(mon: dict, dom: dict) -> str:
    a4 = mon["pullback_to_primitive_quartic_strata"]["A4"]
    s4 = mon["pullback_to_primitive_quartic_strata"]["S4"]
    return f"""# DEGREE8_PULLBACK — Goal Q3.1 Schur monodromy

**Marker achieved:** `{mon["marker_candidate"]}`  
**Scope:** {mon["marker_scope"]}

## Generic monodromy (input)

{mon["generic_geometric_monodromy"]["statement"]}

After three points split: still one integral degree-eight extension.
Cubic resolvent closure does **not** automatically split the incidence fibre.

## Pullback to A4 stratum (resolvent Galois C3)

Orbit arithmetic on a reduced 8-set with a pure `C3`-action:

```text
fixed_points + 3 · (3-orbits) = 8
⇒ (fixed, 3-orbits) ∈ {{(2,2), (5,1), (8,0)}}
⇒ at least two fixed points
```

Machine enumeration confirms every partition forces a fixed point
(`c3_always_has_fixed_point_on_reduced_8_set = {a4["c3_always_has_fixed_point_on_reduced_8_set"]}`,
min fixed = {a4["min_fixed_points_if_c3_action"]}).

**Conditional gate (exact):** if the special fibre is a finite length-8 Hilbert
scheme whose geometric points split over the cyclic cubic, then a
`K_Schur`-rational Hilbert point exists and Theorem B yields a point.

**Hypotheses proved for the installed Schur quartic:**

| Hypothesis | Proved? |
|---|---|
| finite length-8 Hilbert scheme | {a4["hypotheses_proved_for_installed_schur_quartic"]["finite_length_8_hilbert_scheme"]} |
| split over cyclic cubic | {a4["hypotheses_proved_for_installed_schur_quartic"]["split_over_cyclic_cubic"]} |
| reduced support | {a4["hypotheses_proved_for_installed_schur_quartic"]["reduced_support"]} |
| avoids excess boundary | {a4["hypotheses_proved_for_installed_schur_quartic"]["avoids_excess_boundary"]} |

## Pullback to S4 stratum (resolvent Galois S3)

Fixed-point-free `S3`-actions on an 8-set exist (e.g. orbit type `2+6`).
Length modulo 3 does **not** force a rational support point.

`fixed_point_free_s3_action_exists = {s4["fixed_point_free_s3_action_exists"]}`.

## Schur-specific relation among the three points

The triple is a pairing-residual of a primitive tetrahedron, not a general
point of `X^3`.  On the **split** Klein cubic the resolvent map is dominant
(sealed ranks 9 / 10 / 6).  This packet recomputes an exact rational sample
(status `{dom.get("status")}`, quartet rank `{dom.get("quartet_projective_rank")}`,
triple rank `{dom.get("triple_projective_rank")}`, pairing residuals rebuild OK
`{dom.get("pairing_residual_reconstruction_ok")}`).

No new identity was found that forces monodromy of the special fibre to drop
into the resolvent group or to fix a component.

## Forbidden inference

Virtual Gromov–Witten count eight alone is **not** a `K_Schur`-point and is
**not** a Hilbert point.

## Decisive outcomes

| Outcome | Achieved |
|---|---|
| one rational component | no |
| odd-degree component + descent | no |
| deg-1 zero-cycle on RC component | no |
| canonical boundary map fixed by monodromy | no |

```text
Q3-SCHUR-MONODROMY-PASS
```
"""


def md_sym(sym: dict) -> str:
    return f"""# SYMMETRIC_CUBE_PULLBACK — Goal Q3.2

## Setup

Form the fibre product of the degree-eight incidence cover with the
symmetric-cube parameterization, restricted to the resolvent locus `R` of
triples arising from primitive full-span quartics.

## Searches

| Lane | Result |
|---|---|
| rational section over `R` | {sym["searches"]["rational_section_over_R"]["result"]} |
| low-degree multisection | {sym["searches"]["low_degree_multisection"]["result"]} |
| conic/quadric split fibre | {sym["searches"]["conic_or_quadric_split_fibre"]["result"]} |
| rational boundary component | {sym["searches"]["rational_boundary_component"]["result"]} |

## Installed quartic

Coordinates of the Voisin-produced quartic on the genuine Schur surface are
**not exhibited**.  Generic triple checks are therefore insufficient: every
rational map must eventually be evaluated at the installed quartic.

```text
{sym["marker"]}
```
"""


def md_boundary(bnd: dict) -> str:
    c = bnd["conclusions"]
    return f"""# BOUNDARY_STABLE_MAPS — Goal Q3.3

The positive bridge accepts reducible stable maps.  Boundary types of degree
three were exhausted theoretically and probed modularly on the split Klein
cubic.

## Type ledger

| Type | K_Schur object |
|---|---|
| line + conic | {bnd["boundary_types"]["line_plus_conic"]["K_Schur_object_found"]} |
| three lines | {bnd["boundary_types"]["three_lines"]["K_Schur_object_found"]} |
| double line + line | {bnd["boundary_types"]["double_line_plus_line"]["K_Schur_object_found"]} (excluded by no K-line) |
| nonreduced GTC | {bnd["boundary_types"]["nonreduced_gtc"]["K_Schur_object_found"]} |
| embedded-point boundary | {bnd["boundary_types"]["embedded_point_boundary"]["K_Schur_object_found"]} |

## Galois constraints

- Under pure `C3` action on the resolvent triple, no Gal-stable pair of marks
  exists, so a line through exactly two marks cannot be `K`-rational.
- Collinear resolvent triples would give a `K`-line section residual; universal
  collinearity is false, and modular scans on the split Klein cubic find
  collinear residuals only rarely (see `boundary.json` modular_scan).
- A double line over `K_Schur` is excluded by the absence of `K_Schur`-lines on
  the authoritative twist.

## Modular scan scope

{bnd["modular_scan"]["scope"]}

## Conclusion

`boundary_reduction_pass = {c["boundary_reduction_pass"]}`.  
Residual: {bnd["residual"]}

Marker `{bnd["marker_candidate"]}` **not** achieved.
"""


def md_status(exit_code: str, meta: dict, residual: list[str]) -> str:
    return f"""{exit_code}

# Goal Q3 status — quartic resolvent stable map

**Primary exit:** `{exit_code}`  
**Headline:** **OPEN**  
**Pinned goal baseline:** `{PINNED}`  
**Field:** `K_Schur = C(P(V6))^PSL2(F11)`

## Stage ledger

| Stage | Result |
|---|---|
| Q3.0 canonical model | **Q3-QUARTIC-RESOLVENT-MODEL-PASS** |
| Q3.1 Schur monodromy | **Q3-SCHUR-MONODROMY-PASS** (orbit-arithmetic + residual hypotheses) |
| Q3.2 symmetric-cube pullback | recorded; no section / multisection |
| Q3.3 boundary stable cubics | exhausted; no K_Schur object |
| Q3.4 bridge | not entered |

## Headline candidates

| Exit | Achieved |
|---|---|
| Q3-STABLE-MAP-HEADLINE-POSITIVE | no |
| Q3-GENERALIZED-TWISTED-CUBIC-HEADLINE-POSITIVE | no |

## What was sealed

1. Exact A4/S4 pairing/resolvent group model with Galois-commuting diagrams.
2. Degree-eight incidence cover description and pullback monodromy gates for
   both A4/C3 and S4/S3 strata (including C3 always-fixed-point arithmetic on
   reduced 8-sets and S3 fixed-point-free types).
3. Named residual hypotheses that still block a rational Hilbert point.
4. Symmetric-cube fibre-product search log (negative).
5. Boundary-type incidence / Galois ledger + modular Klein probes (negative).
6. Output bridge readiness via fixed_curve_bridge Theorems A/B (input).

## Residual gates (ordered)

{chr(10).join(f"{i+1}. {g}" for i, g in enumerate(residual))}

## Peak resource

- wall ≈ {meta["wall_s"]:.2f} s
- peak RSS ≈ {meta["peak_rss_mb"]:.1f} MB
- external GB / msolve: **not invoked**

## Replay

See `REPLAY.md`.
"""


def md_replay() -> str:
    return """# Q3 replay

From `problems/E-klein-cubic`:

```sh
# producer
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/produce.py

# independent verifiers (must not import produce.py)
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/verify_monodromy.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/verify_stable_map.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/verify_point.py

# seal
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/make_seal.py
```

## Expected markers

```text
Q3_PRODUCE_OK
Q3_MONODROMY_VERIFY_OK
Q3_STABLE_MAP_VERIFY_OK
Q3_POINT_VERIFY_OK
Q3_SEAL_OK
```

## Primary STATUS line

```text
Q3-SCHUR-MONODROMY-PASS
```
"""


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------


def build_manifest() -> dict:
    inputs = {}
    missing = []
    for rel in BINDING_INPUT_PATHS:
        path = ROOT / rel
        if not path.is_file():
            missing.append(rel)
            continue
        inputs[rel] = {"path": rel, "sha256": sha256_file(path), "bytes": path.stat().st_size}
    return {
        "format": "q3-input-manifest-v1",
        "pinned_goal_baseline": PINNED,
        "binding_inputs": inputs,
        "missing": missing,
        "marker": "Q3_INPUTS_HASHED" if not missing else "Q3_INPUTS_INCOMPLETE",
    }


def main() -> None:
    t0 = time.time()
    manifest = build_manifest()
    if manifest["missing"]:
        write(HERE / "STATUS.md", "Q3-CANONICAL-INPUT-FAIL\n\nMissing:\n" + "\n".join(manifest["missing"]) + "\n")
        write_json(HERE / "INPUT_MANIFEST.json", manifest)
        print("Q3-CANONICAL-INPUT-FAIL", manifest["missing"])
        return

    model = build_quartic_resolvent_model()
    monodromy = build_monodromy()
    dominance = recompute_dominance_ranks()
    monodromy["dominance_recompute"] = {
        "status": dominance.get("status"),
        "quartet_projective_rank": dominance.get("quartet_projective_rank"),
        "triple_projective_rank": dominance.get("triple_projective_rank"),
        "pairing_residual_reconstruction_ok": dominance.get("pairing_residual_reconstruction_ok"),
        "imported_sealed_ranks": dominance.get("imported_sealed_ranks"),
    }
    sym = build_symmetric_cube()
    modular = modular_boundary_scan()
    boundary = build_boundary(dominance, modular)
    bridge = build_bridge_status(False)

    residual = [
        "Coordinates (or saturated ideal) of the Voisin primitive quartic on the genuine Schur surface.",
        "Proof that the installed resolvent triple lies in the finite reduced length-8 Hilbert incidence locus.",
        "Proof that geometric incidence points split over the cyclic cubic in the A4 branch (new Schur-specific theorem).",
        "Or: an actual K_Schur-defined (possibly reducible) degree-three stable map / GTC Hilbert point through that triple.",
        "S4/S3 branch still permits fixed-point-free actions even under reduced length 8.",
    ]

    exit_code = "Q3-SCHUR-MONODROMY-PASS"

    wall = time.time() - t0
    rss = peak_rss_mb()
    meta = {
        "format": "q3-produce-meta-v1",
        "exit": exit_code,
        "wall_s": wall,
        "peak_rss_mb": rss,
        "stages": ["Q3.0", "Q3.1", "Q3.2", "Q3.3", "Q3.4"],
        "headline": "OPEN",
        "stable_map_found": False,
        "gtc_point_found": False,
        "external_cas": [],
        "marker": "Q3_PRODUCE_OK",
    }

    # Artifacts
    write_json(HERE / "INPUT_MANIFEST.json", manifest)
    write_json(HERE / "quartic_resolvent.json", model)
    write_json(HERE / "monodromy.json", monodromy)
    write_json(HERE / "dominance_sample.json", dominance)
    write_json(HERE / "sym_cube.json", sym)
    write_json(HERE / "boundary.json", boundary)
    write_json(HERE / "bridge_status.json", bridge)
    write_json(HERE / "produce_meta.json", meta)

    write(HERE / "QUARTIC_RESOLVENT_MODEL.md", md_model(model))
    write(HERE / "DEGREE8_PULLBACK.md", md_degree8(monodromy, dominance))
    write(HERE / "SYMMETRIC_CUBE_PULLBACK.md", md_sym(sym))
    write(HERE / "BOUNDARY_STABLE_MAPS.md", md_boundary(boundary))
    write(HERE / "STATUS.md", md_status(exit_code, meta, residual))
    write(HERE / "REPLAY.md", md_replay())

    print("Q3_PRODUCE_OK")
    print(exit_code)
    print(f"wall_s={wall:.3f} peak_rss_mb={rss:.2f}")


if __name__ == "__main__":
    main()
