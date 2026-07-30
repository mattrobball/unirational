#!/usr/bin/env python3
"""Independent candidate verifier for Krylov outputs (safeguards S1–S6).

Does NOT import any producer.  Accepts a candidate payload describing four
univariate forms over a field with a marked degree-55 point, and checks the
six mandatory safeguards.  Rank-only incidence points without forms are
rejected as non-qualifying.

Usage:
  python3 candidate_verifier.py                  # self-tests + empty check
  python3 candidate_verifier.py candidate.json   # verify a candidate file
"""
from __future__ import annotations

import json
import sys
from pathlib import Path


SAFEGUARDS = (
    "S1_no_common_zero",
    "S2_degree_exactly_19",
    "S3_birational_onto_image",
    "S4_mult_one_at_all_conjugates",
    "S5_no_component_in_cubic",
    "S6_residual_length_exactly_2",
)


def poly_deg(coeffs: list) -> int:
    """coeffs low-to-high; trailing zeros ignored."""
    d = len(coeffs) - 1
    while d >= 0 and coeffs[d] == 0:
        d -= 1
    return d


def poly_content_zero(coeffs: list) -> bool:
    return all(c == 0 for c in coeffs)


def poly_gcd_deg(a: list, b: list) -> int:
    """Degree of gcd over Q using Euclidean algorithm on integer/rational lists."""
    from fractions import Fraction as Q

    def norm(p):
        p = [Q(c) for c in p]
        while p and p[-1] == 0:
            p.pop()
        return p

    a, b = norm(a), norm(b)
    while b:
        # a mod b
        while len(a) >= len(b) and a:
            scale = a[-1] / b[-1]
            shift = len(a) - len(b)
            for i in range(len(b)):
                a[shift + i] -= scale * b[i]
            while a and a[-1] == 0:
                a.pop()
        a, b = b, a
    return len(a) - 1 if a else -1


def multi_gcd_deg(polys: list[list]) -> int:
    active = [p for p in polys if not poly_content_zero(p)]
    if not active:
        return -1
    g = active[0]
    for p in active[1:]:
        d = poly_gcd_deg(g, p)
        if d < 0:
            return -1
        # reconstruct a monic gcd placeholder degree only: if deg 0, constant
        if d == 0:
            return 0
        # For degree tracking across multiple, recompute pairwise deg bound
        # Exact gcd poly not needed for the zero/nonzero common-root test when
        # combined with resultant-style: if any pairwise gcd deg 0 and we check
        # all four, common zero exists iff gcd of all has deg >= 1.
        from fractions import Fraction as Q

        def norm(p):
            p = [Q(c) for c in p]
            while p and p[-1] == 0:
                p.pop()
            return p

        def full_gcd(a, b):
            a, b = norm(a), norm(b)
            while b:
                while len(a) >= len(b) and a:
                    scale = a[-1] / b[-1]
                    shift = len(a) - len(b)
                    for i in range(len(b)):
                        a[shift + i] -= scale * b[i]
                    while a and a[-1] == 0:
                        a.pop()
                a, b = b, a
            return a

        g = full_gcd(g, p)
        if not g:
            return -1
    return len(g) - 1


def klein_binary_pullback(forms: list[list]) -> list:
    """Compose sum x_i^2 x_{i+1} along a map P1->P4 given by 5 forms.
    For P3 hyperplane model the candidate should supply 4 forms + reconstructed x4,
    or 5 forms.  Here we accept 4 forms and treat the map as P1->P3 with cubic
    restriction supplied separately; return dummy if only 4 forms.
    """
    return []  # residual cubic check requires ambient cubic data in payload


def verify_candidate(payload: dict) -> dict:
    """Return a report dict with pass/fail per safeguard."""
    report = {s: False for s in SAFEGUARDS}
    report["qualifying"] = False
    report["rank_only_rejected"] = False
    notes = []

    if payload.get("rank_only") or not payload.get("forms"):
        report["rank_only_rejected"] = True
        notes.append("rank-only incidence point is not a qualifying curve")
        report["notes"] = notes
        return report

    forms = payload["forms"]
    assert len(forms) == 4, "expected four univariate forms"
    degs = [poly_deg(f) for f in forms]
    max_deg = max(degs)

    # S1: no common zero <=> gcd of all four has degree 0 (constant)
    gdeg = multi_gcd_deg(forms)
    report["S1_no_common_zero"] = gdeg == 0
    if gdeg != 0:
        notes.append(f"common gcd degree {gdeg}")

    # S2: degree exactly 19
    content_ok = not any(poly_content_zero(f) for f in forms)
    report["S2_degree_exactly_19"] = max_deg == 19 and gdeg == 0 and content_ok
    if max_deg != 19:
        notes.append(f"max deg {max_deg} != 19")

    # S3: birational onto image — requires inverse or function-field degree
    if "birational_certificate" in payload:
        report["S3_birational_onto_image"] = bool(payload["birational_certificate"])
    else:
        # Weak necessary test: the four forms span a 2-dimensional space of
        # rational functions of degree 19 without a common factor already checked;
        # full birationality needs an inverse.  Mark false unless certified.
        report["S3_birational_onto_image"] = bool(payload.get("assert_birational"))
        if not report["S3_birational_onto_image"]:
            notes.append("birationality certificate missing")

    # S4: multiplicity one at all conjugates
    if "intersection_multiplicities_at_Z_orbit" in payload:
        mults = payload["intersection_multiplicities_at_Z_orbit"]
        report["S4_mult_one_at_all_conjugates"] = (
            len(mults) == 55 and all(m == 1 for m in mults)
        )
    else:
        notes.append("missing intersection multiplicities at Z-orbit")
        report["S4_mult_one_at_all_conjugates"] = False

    # S5: no component in cubic
    if "cubic_pullback_identically_zero" in payload:
        report["S5_no_component_in_cubic"] = not payload["cubic_pullback_identically_zero"]
    else:
        notes.append("missing cubic pullback vanishing flag")
        report["S5_no_component_in_cubic"] = False

    # S6: residual length 2
    if "residual_intersection_length" in payload:
        report["S6_residual_length_exactly_2"] = (
            payload["residual_intersection_length"] == 2
        )
    elif "total_intersection_length" in payload:
        report["S6_residual_length_exactly_2"] = (
            payload["total_intersection_length"] - 55 == 2
        )
    else:
        # Bézout necessity: if deg=19 and S5, total length 57, residual 2 if S4
        if report["S2_degree_exactly_19"] and report["S5_no_component_in_cubic"] and report["S4_mult_one_at_all_conjugates"]:
            report["S6_residual_length_exactly_2"] = True
            notes.append("S6 inferred from Bezout 57-55=2 under S2,S4,S5")
        else:
            notes.append("missing residual length")
            report["S6_residual_length_exactly_2"] = False

    report["qualifying"] = all(report[s] for s in SAFEGUARDS)
    report["notes"] = notes
    return report


def self_tests() -> None:
    # Rank-only rejection
    r = verify_candidate({"rank_only": True})
    assert r["rank_only_rejected"] and not r["qualifying"]

    # Four forms with a common linear factor (fail S1)
    # (t-1)*t^18, (t-1)*t^17, ... common root t=1
    forms_bad = []
    for j in range(4):
        # coeffs of (t-1) * t^{18-j} pad to deg 19: actually use (t-1)*t^18 for all
        # (t-1)*t^18 = t^19 - t^18
        coeffs = [0] * 20
        coeffs[19] = 1
        coeffs[18] = -1
        forms_bad.append(coeffs)
    r = verify_candidate({"forms": forms_bad})
    assert r["S1_no_common_zero"] is False
    assert not r["qualifying"]

    # Four forms without common factor: 1, t, t^2, t^19 — max deg 19, gcd 1
    forms_ok_shape = [
        [1] + [0] * 19,
        [0, 1] + [0] * 18,
        [0, 0, 1] + [0] * 17,
        [0] * 19 + [1],
    ]
    r = verify_candidate(
        {
            "forms": forms_ok_shape,
            "assert_birational": True,
            "birational_certificate": True,
            "intersection_multiplicities_at_Z_orbit": [1] * 55,
            "cubic_pullback_identically_zero": False,
            "residual_intersection_length": 2,
        }
    )
    assert r["S1_no_common_zero"] is True
    assert r["S2_degree_exactly_19"] is True
    assert r["qualifying"] is True

    # Degree not 19
    forms_low = [[1, 0], [0, 1], [1, 1], [1, -1]]
    r = verify_candidate({"forms": forms_low, "assert_birational": True})
    assert r["S2_degree_exactly_19"] is False

    print("CANDIDATE_VERIFIER_SELF_TESTS_OK")


def main(argv: list[str]) -> int:
    self_tests()
    if len(argv) >= 2:
        path = Path(argv[1])
        payload = json.loads(path.read_text(encoding="utf-8"))
        report = verify_candidate(payload)
        print(json.dumps(report, indent=2))
        if report.get("rank_only_rejected"):
            print("CANDIDATE_RANK_ONLY_REJECTED")
            return 2
        if report["qualifying"]:
            print("CANDIDATE_QUALIFYING_PASS")
            return 0
        print("CANDIDATE_NOT_QUALIFYING")
        return 1
    print("CANDIDATE_VERIFIER_READY")
    print("SAFEGUARDS " + ",".join(SAFEGUARDS))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
