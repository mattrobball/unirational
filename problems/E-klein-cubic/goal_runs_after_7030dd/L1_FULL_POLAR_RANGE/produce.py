#!/usr/bin/env python3
"""Complete WP-L1 through the full finite normal-order range 3m <= N <= 3d.

This producer is deliberately self-contained.  It uses only Python's standard
library and exact Fraction arithmetic.  It does not import the historical
WP-L1 producer or this packet's independent verifier.

The mathematical input already sealed by the historical WP-L1 packet is:

    F(p(t)) is even in the normal parameter t,
    p_{m+s} lies in E_- for s even and E_+ for s odd (m odd), and
    F|_{E_-}=0.

The new content is the complete finite coefficient ledger for a degree-d jet,
including both the isolable correction range and the terminal compatibility
tail after no new coefficient remains.
"""

from __future__ import annotations

import hashlib
import json
from fractions import Fraction
from itertools import permutations
from pathlib import Path
from typing import Any, Iterable

HERE = Path(__file__).resolve().parent
OUT = HERE / "FULL_RANGE.json"
PINNED_BASE = "7030ddafb53acdea23070b0d9d20050b592ceb1b"


def canonical_json(obj: Any) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def write_self_hashed_json(path: Path, body: dict[str, Any]) -> dict[str, Any]:
    payload = dict(body)
    payload.pop("self_sha256", None)
    digest = sha256_bytes(canonical_json(payload).encode())
    payload["self_sha256"] = digest
    path.write_text(canonical_json(payload))
    reread = json.loads(path.read_text())
    check_body = {k: v for k, v in reread.items() if k != "self_sha256"}
    assert sha256_bytes(canonical_json(check_body).encode()) == reread["self_sha256"]
    return reread


# ---------------------------------------------------------------------------
# Exact Klein cubic and symmetric polarization over Q
# ---------------------------------------------------------------------------

def klein_F(v: Iterable[int | Fraction]) -> Fraction:
    x = [Fraction(a) for a in v]
    assert len(x) == 5
    return sum(x[i] * x[i] * x[(i + 1) % 5] for i in range(5))


def Phi(u: Iterable[int | Fraction], v: Iterable[int | Fraction], w: Iterable[int | Fraction]) -> Fraction:
    """Symmetric trilinear polarization, normalized by Phi(x,x,x)=F(x)."""
    uu = [Fraction(a) for a in u]
    vv = [Fraction(a) for a in v]
    ww = [Fraction(a) for a in w]
    assert len(uu) == len(vv) == len(ww) == 5
    total = Fraction(0)
    for i in range(5):
        ip = (i + 1) % 5
        total += (
            uu[i] * vv[i] * ww[ip]
            + uu[i] * ww[i] * vv[ip]
            + vv[i] * ww[i] * uu[ip]
        ) / 3
    return total


def Phi_inclusion_exclusion(
    u: Iterable[int | Fraction],
    v: Iterable[int | Fraction],
    w: Iterable[int | Fraction],
) -> Fraction:
    uu = [Fraction(a) for a in u]
    vv = [Fraction(a) for a in v]
    ww = [Fraction(a) for a in w]

    def add(*xs: list[Fraction]) -> list[Fraction]:
        return [sum(z[i] for z in xs) for i in range(5)]

    return (
        klein_F(add(uu, vv, ww))
        - klein_F(add(uu, vv))
        - klein_F(add(uu, ww))
        - klein_F(add(vv, ww))
        + klein_F(uu)
        + klein_F(vv)
        + klein_F(ww)
    ) / 6


def exact_polarization_certificate() -> dict[str, Any]:
    # Equality of the explicit and inclusion-exclusion polarizations on the
    # 125 basis triples proves equality of their structure constants.
    for a in range(5):
        for b in range(5):
            for c in range(5):
                ea = [int(i == a) for i in range(5)]
                eb = [int(i == b) for i in range(5)]
                ec = [int(i == c) for i in range(5)]
                assert Phi(ea, eb, ec) == Phi_inclusion_exclusion(ea, eb, ec)

    for x in (
        [1, 0, 0, 0, 0],
        [1, 1, 0, 0, 0],
        [1, 2, 3, 4, 5],
        [2, -1, 0, 3, -4],
    ):
        assert Phi(x, x, x) == klein_F(x)

    u = [1, 0, 1, 0, 0]
    v = [0, 2, 0, 1, 0]
    w = [1, 1, 0, 0, 3]
    assert Phi(u, v, w) == Phi(v, u, w) == Phi(w, v, u)

    return {
        "field": "Q",
        "status": "PROVED_BY_STRUCTURE_CONSTANTS",
        "F": "sum_{i in Z/5} x_i^2 x_{i+1}",
        "Phi": (
            "(1/3) sum_i (u_i v_i w_{i+1} + u_i w_i v_{i+1} "
            "+ v_i w_i u_{i+1})"
        ),
        "normalization": "Phi(x,x,x)=F(x)",
        "basis_triples_checked": 125,
        "mixed_polar": "B(z;y1,y2)=3 Phi(z,y1,y2)",
    }


# ---------------------------------------------------------------------------
# Universal offset ledger
# ---------------------------------------------------------------------------

def target_for_offset(offset: int) -> str:
    """For odd m: offset even gives E_-, offset odd gives E_+."""
    assert offset >= 0
    return "E_minus" if offset % 2 == 0 else "E_plus"


def jet_label(m: int, offset: int) -> str:
    prefix = "a" if offset % 2 == 0 else "b"
    return f"{prefix}_{{{m + offset}}}"


def permutation_multiplicity(triple: tuple[int, int, int]) -> int:
    return len(set(permutations(triple)))


def sorted_offset_triples(delta: int, q: int) -> list[tuple[int, int, int]]:
    """All 0 <= a <= b <= c <= q with a+b+c=delta."""
    assert delta >= 0 and q >= 0
    out: list[tuple[int, int, int]] = []
    for a in range(0, min(q, delta) + 1):
        for b in range(a, min(q, delta - a) + 1):
            c = delta - a - b
            if b <= c <= q:
                out.append((a, b, c))
    return out


def term_record(m: int, triple: tuple[int, int, int]) -> dict[str, Any]:
    mult = permutation_multiplicity(triple)
    types = [target_for_offset(s) for s in triple]
    n_minus = types.count("E_minus")
    labels = [jet_label(m, s) for s in triple]

    base: dict[str, Any] = {
        "offsets": list(triple),
        "orders": [m + s for s in triple],
        "targets": types,
        "ordered_multiplicity": mult,
        "labels": labels,
    }

    if n_minus in (1, 3):
        base.update(
            {
                "live": False,
                "kind": "VANISHES_BY_INVOLUTION_PARITY",
                "formula": "0",
            }
        )
        return base

    if n_minus == 2:
        plus_pos = types.index("E_plus")
        minus_pos = [i for i, t in enumerate(types) if t == "E_minus"]
        # A mixed B term has multiplicity 3 or 6, hence coefficient 1 or 2.
        assert mult % 3 == 0
        coeff = mult // 3
        plus = labels[plus_pos]
        minus1 = labels[minus_pos[0]]
        minus2 = labels[minus_pos[1]]
        base.update(
            {
                "live": True,
                "kind": "B",
                "coefficient": coeff,
                "formula": f"{coeff}*B({plus}; {minus1}, {minus2})",
                "raw_phi_formula": f"{mult}*Phi({labels[0]}, {labels[1]}, {labels[2]})",
            }
        )
        return base

    assert n_minus == 0
    if triple[0] == triple[1] == triple[2]:
        base.update(
            {
                "live": True,
                "kind": "F_plus",
                "coefficient": 1,
                "formula": f"F_+({labels[0]})",
                "raw_phi_formula": f"Phi({labels[0]}, {labels[0]}, {labels[0]})",
            }
        )
    else:
        base.update(
            {
                "live": True,
                "kind": "Phi_plus",
                "coefficient": mult,
                "formula": f"{mult}*Phi({labels[0]}, {labels[1]}, {labels[2]})",
                "raw_phi_formula": f"{mult}*Phi({labels[0]}, {labels[1]}, {labels[2]})",
            }
        )
    return base


def live_terms(m: int, d: int, delta: int) -> list[dict[str, Any]]:
    q = d - m
    assert m > 0 and m % 2 == 1 and d >= m
    terms = [term_record(m, t) for t in sorted_offset_triples(delta, q)]
    return [t for t in terms if t["live"]]


def stage_record(m: int, d: int, delta: int, include_terms: bool = True) -> dict[str, Any]:
    q = d - m
    assert 0 <= delta <= 3 * q
    N = 3 * m + delta
    terms = live_terms(m, d, delta)
    terms_digest = sha256_bytes(canonical_json(terms).encode())

    # Since 3m is odd, N is odd exactly when delta is even.  F(p(t)) is even.
    if delta % 2 == 0:
        assert terms == []
        rec: dict[str, Any] = {
            "delta": delta,
            "F_order": N,
            "mode": "AUTOMATIC_ODD_ORDER",
            "equation": "0=0",
            "term_count": 0,
            "terms_sha256": terms_digest,
        }
        if include_terms:
            rec["terms"] = []
        return rec

    assert terms
    if delta <= q:
        newest = (0, 0, delta)
        matching = [t for t in terms if tuple(t["offsets"]) == newest]
        assert len(matching) == 1
        isolator = matching[0]
        assert isolator["kind"] == "B"
        assert isolator["coefficient"] == 1
        residual = [t for t in terms if tuple(t["offsets"]) != newest]
        rec = {
            "delta": delta,
            "F_order": N,
            "mode": "ISOLATE_NEW_EPLUS_CORRECTION",
            "new_correction_offset": delta,
            "new_correction_order": m + delta,
            "new_correction": jet_label(m, delta),
            "operator": f"L_{delta}(u)=B(u; a_{{{m}}}, a_{{{m}}})",
            "equation": f"L_{delta}({jet_label(m, delta)})=-R_{delta}",
            "obstruction": f"omega_{delta}=[R_{delta}] in coker(L_{delta})",
            "isolator": isolator,
            "residual_term_count": len(residual),
            "term_count": len(terms),
            "terms_sha256": terms_digest,
            "residual_terms_sha256": sha256_bytes(canonical_json(residual).encode()),
        }
        if include_terms:
            rec["terms"] = terms
            rec["residual_terms"] = residual
        return rec

    # No p_{m+delta} exists once delta > q.  These equations are the terminal
    # compatibility tail, not additional isolation equations.
    assert all(max(t["offsets"]) <= q for t in terms)
    rec = {
        "delta": delta,
        "F_order": N,
        "mode": "TERMINAL_COMPATIBILITY",
        "equation": f"T_{delta}=0",
        "new_correction": None,
        "term_count": len(terms),
        "terms_sha256": terms_digest,
        "note": (
            "All degree-d coefficients already exist; this coefficient of F(p) "
            "must vanish without introducing a new jet."
        ),
    }
    if include_terms:
        rec["terms"] = terms
    return rec


def full_case(m: int, d: int) -> dict[str, Any]:
    q = d - m
    summaries: list[dict[str, Any]] = []
    all_stage_material: list[dict[str, Any]] = []
    isolation_deltas: list[int] = []
    terminal_deltas: list[int] = []
    automatic_deltas: list[int] = []

    for delta in range(0, 3 * q + 1):
        stage = stage_record(m, d, delta, include_terms=False)
        summaries.append(stage)
        all_stage_material.append(stage)
        if stage["mode"] == "ISOLATE_NEW_EPLUS_CORRECTION":
            isolation_deltas.append(delta)
        elif stage["mode"] == "TERMINAL_COMPATIBILITY":
            terminal_deltas.append(delta)
        else:
            automatic_deltas.append(delta)

    expected_iso = [delta for delta in range(1, q + 1, 2)]
    expected_terminal = [delta for delta in range(q + 1, 3 * q + 1) if delta % 2 == 1]
    assert isolation_deltas == expected_iso
    assert terminal_deltas == expected_terminal
    assert len(summaries) == 3 * q + 1

    return {
        "m": m,
        "d": d,
        "q": q,
        "normal_F_order_range": [3 * m, 3 * d],
        "number_of_coefficients_in_range": 3 * q + 1,
        "isolation_deltas": isolation_deltas,
        "terminal_deltas": terminal_deltas,
        "automatic_deltas": automatic_deltas,
        "first_terminal_delta": terminal_deltas[0] if terminal_deltas else None,
        "last_nonautomatic_delta": (
            max(isolation_deltas + terminal_deltas) if isolation_deltas or terminal_deltas else None
        ),
        "stage_summaries_sha256": sha256_bytes(canonical_json(all_stage_material).encode()),
        "stage_term_counts_sha256": sha256_bytes(
            canonical_json([s["term_count"] for s in summaries]).encode()
        ),
        "mode_counts": {
            "automatic": len(automatic_deltas),
            "isolation": len(isolation_deltas),
            "terminal": len(terminal_deltas),
        },
    }


def ordered_vs_sorted_certificate(max_q: int = 18) -> dict[str, Any]:
    cases = 0
    ordered_total = 0
    for q in range(max_q + 1):
        for delta in range(3 * q + 1):
            ordered = 0
            for a in range(q + 1):
                for b in range(q + 1):
                    c = delta - a - b
                    if 0 <= c <= q:
                        ordered += 1
            sorted_weight = sum(permutation_multiplicity(t) for t in sorted_offset_triples(delta, q))
            assert ordered == sorted_weight
            cases += 1
            ordered_total += ordered
    return {
        "status": "PASS",
        "q_range": [0, max_q],
        "delta_cases_checked": cases,
        "ordered_triples_counted": ordered_total,
        "claim": (
            "The sorted-triple ledger with multiplicities 1,3,6 equals the "
            "ordered coefficient sum defining [t^N]F(p(t))."
        ),
    }


def first_equations_certificate() -> dict[str, Any]:
    # q >= 3 ensures both stages exist.  The formulas are independent of m.
    m, d = 1, 7
    s1 = stage_record(m, d, 1, include_terms=True)
    s3 = stage_record(m, d, 3, include_terms=True)
    assert [t["formula"] for t in s1["terms"]] == ["1*B(b_{2}; a_{1}, a_{1})"]
    formulas3 = [t["formula"] for t in s3["terms"]]
    assert formulas3 == [
        "1*B(b_{4}; a_{1}, a_{1})",
        "2*B(b_{2}; a_{1}, a_{3})",
        "F_+(b_{2})",
    ]
    return {
        "order_3m+1": "B(b_{m+1};a_m,a_m)=0",
        "order_3m+3": (
            "B(b_{m+3};a_m,a_m)+2B(b_{m+1};a_m,a_{m+2})"
            "+F_+(b_{m+1})=0"
        ),
        "status": "REPRODUCED_EXACTLY",
    }


def build_payload() -> dict[str, Any]:
    polarization = exact_polarization_certificate()
    regression_pairs = [(1, 1), (1, 2), (1, 7), (1, 13), (3, 19), (5, 35)]
    regressions = [full_case(m, d) for m, d in regression_pairs]

    return {
        "packet": "L1_FULL_POLAR_RANGE",
        "work_package": "WP-L1",
        "exit": "L1-FULL-RANGE-PASS",
        "headline": "OPEN",
        "pinned_base_commit": PINNED_BASE,
        "historical_packet_boundary": "historical WP-L1 stopped at F-order 3m+3",
        "completed_boundary": "all F-orders 3m <= N <= 3d for every odd m and d >= m",
        "cas": {
            "external_CAS_required": False,
            "engines_used": [],
            "exact_engine": "Python standard library Fraction + exhaustive combinatorics",
            "conditional_claims": [],
        },
        "polarization": polarization,
        "accepted_parity_input": {
            "m": "odd positive integer",
            "degree": "d >= m",
            "jet": "p(t)=sum_{r=m}^d p_r t^r",
            "eigenspaces": (
                "p_{m+s} is E_- for s even and E_+ for s odd; "
                "F(p(-t))=F(p(t)); F|_{E_-}=0"
            ),
            "source": (
                "historical exact WP-L1 packet and corrected source/normal/target "
                "incidence theorem, pinned in INPUT_MANIFEST.json"
            ),
        },
        "full_range_theorem": {
            "offset": "q=d-m, N=3m+delta, 0 <= delta <= 3q",
            "coefficient": (
                "C_delta=sum_{s1+s2+s3=delta, 0<=si<=q} "
                "Phi(p_{m+s1},p_{m+s2},p_{m+s3}) over ordered triples"
            ),
            "sorted_form": (
                "equivalently sum over 0<=s1<=s2<=s3<=q with multiplicity "
                "1,3,6"
            ),
            "automatic_orders": (
                "delta even gives odd N, hence C_delta=0 by involution parity"
            ),
            "isolation_range": (
                "for odd delta <= q, the unique term containing p_{m+delta} is "
                "(0,0,delta), so L_delta(u)=B(u;a_m,a_m) and "
                "L_delta(b_{m+delta})=-R_delta"
            ),
            "obstruction": "omega_delta=[R_delta] in coker(L_delta)",
            "terminal_tail": (
                "for odd q < delta <= 3q there is no p_{m+delta}; the remaining "
                "equation is the terminal compatibility T_delta=C_delta=0"
            ),
            "completeness": (
                "F(p)=0 iff every nonautomatic isolation equation and every "
                "terminal compatibility equation in 0<=delta<=3q vanishes"
            ),
        },
        "first_nonautomatic_equations": first_equations_certificate(),
        "ordered_vs_sorted": ordered_vs_sorted_certificate(),
        "regression_cases": regressions,
        "incidence_compatibility": {
            "status": "PRESERVED",
            "claims": [
                "The recurrence concerns normal jets on the exceptional normal cone.",
                "The source-line condition remains the separate terminal coefficient p_d(0,y).",
                "No source fixed line is identified with a subvariety of the plus-plane.",
                "A solution of the coefficient tower is only a formal landing jet, not a global covariant.",
            ],
        },
        "theorem_boundary": {
            "proved": [
                "exact Klein polarization over Q",
                "complete coefficient ledger from 3m through 3d",
                "uniform isolation operator at every available odd correction offset",
                "terminal compatibility tail after the final degree-d coefficient",
                "equivalence between the full finite ledger and coefficientwise F(p)=0",
            ],
            "not_proved": [
                "surjectivity of L_delta on any global survivor family",
                "vanishing of omega_delta or T_delta for any global survivor family",
                "existence or algebraization of a formal lift",
                "existence of a homogeneous landing covariant",
                "the Problem-E headline",
            ],
        },
        "producer": {
            "path": "goal_runs_after_7030dd/L1_FULL_POLAR_RANGE/produce.py",
            "independent_verifier": "goal_runs_after_7030dd/L1_FULL_POLAR_RANGE/verify.py",
            "does_not_import_verifier": True,
        },
    }


def main() -> int:
    data = write_self_hashed_json(OUT, build_payload())
    print(f"wrote {OUT}")
    print(f"self_sha256={data['self_sha256']}")
    print(data["exit"])
    print("HEADLINE", data["headline"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
