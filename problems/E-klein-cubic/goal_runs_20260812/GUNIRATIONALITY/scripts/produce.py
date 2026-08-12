#!/usr/bin/env python3
"""Emit the [T1] arithmetic and the citation census for GUNIRATIONALITY."""

from __future__ import annotations

import json
import re
from pathlib import Path

PACKET = Path(__file__).resolve().parent.parent
RESULTS = PACKET / "results"
THEOREM = PACKET / "THEOREM.md"


def psl2_order(q: int) -> int:
    return q * (q * q - 1) // 2


def main() -> None:
    RESULTS.mkdir(exist_ok=True)
    text = THEOREM.read_text()

    order_formula = psl2_order(11)
    order_factors = 4 * 3 * 5 * 11
    degrees = [1, 5, 5, 10, 10, 11, 12, 12]
    sos = sum(d * d for d in degrees)
    two_sylow_order = 4
    has_dim_le_4_faithful = any(2 <= d <= 4 for d in degrees)

    citations = {
        "buhler-reichstein-1997": "On the essential dimension of a finite group",
        "reichstein-2000": "On the notion of essential dimension for algebraic groups",
        "reichstein-youssin-2000": "Essential dimensions of algebraic groups and a resolution theorem",
        "serre-2003": "Cohomological invariants, Witt invariants, and trace forms",
        "merkurjev-survey": "Essential dimension",
        "duncan-reichstein-2015": "Versality of algebraic group actions",
        "duncan-2016": "Equivariant unirationality of del Pezzo surfaces",
        "kollar-2002": "Unirationality of cubic hypersurfaces",
        "prokhorov-2012": "Simple finite subgroups of the Cremona group of rank 3",
        "kunyavskii-2010": "The Bogomolov multiplier of finite simple groups",
        "domokos-2008": "Covariants and the no-name lemma",
        "cheltsov-tschinkel-zhang-2025": "Equivariant unirationality of Fano threefolds",
        "tschinkel-zhang-2025": "Cohomological obstructions to equivariant unirationality",
        "scavia-2026": "A counterexample to a conjecture of Duncan",
        "dolgachev-2026": "The essential and Cremona dimensions of a group",
        "beauville-2011": "Finite simple groups of essential dimension 3",
    }
    cite_needles = {
        "buhler-reichstein-1997": "Buhler",
        "reichstein-2000": "Transform. Groups 5",
        "reichstein-youssin-2000": "Reichstein and B. Youssin",
        "serre-2003": "Cohomological invariants, Witt invariants",
        "merkurjev-survey": "Merkurjev",
        "duncan-reichstein-2015": "1109.6093",
        "duncan-2016": "1410.8434",
        "kollar-2002": "Kollár",
        "prokhorov-2012": "Prokhorov",
        "kunyavskii-2010": "Kunyavski",
        "domokos-2008": "0803.1327",
        "cheltsov-tschinkel-zhang-2025": "2502.19598",
        "tschinkel-zhang-2025": "2504.10204",
        "scavia-2026": "2607.25118",
        "dolgachev-2026": "2507.15096",
        "beauville-2011": "1101.1372",
    }

    cite_hits = {key: needle in text for key, needle in cite_needles.items()}

    required_phrases = [
        "Problem E remains OPEN; this packet excludes no degree.",
        "GUNI-NO-DEGREE-EXCLUSION",
        "[READ]",
        "[HOUSE]",
        "[INFERRED]",
        "Not claimed",
        "Proposition 3.5",
        "no-name",
    ]
    phrase_hits = {p: p in text for p in required_phrases}

    summary = {
        "order_formula": order_formula,
        "order_factors": order_factors,
        "order_ok": order_formula == order_factors == 660,
        "character_degrees": degrees,
        "sum_of_squares": sos,
        "sum_of_squares_ok": sos == 660,
        "two_sylow_order": two_sylow_order,
        "smallest_faithful_irrep_dim": 5,
        "has_faithful_irrep_dim_le_4": has_dim_le_4_faithful,
        "citations": citations,
        "cite_needles": cite_needles,
        "cite_hits": cite_hits,
        "all_citations_present": all(cite_hits.values()),
        "phrase_hits": phrase_hits,
        "all_phrases_present": all(phrase_hits.values()),
        "read_count": len(re.findall(r"\*\*\[READ\]\*\*", text)),
        "house_count": len(re.findall(r"\*\*\[HOUSE\]\*\*", text)),
        "inferred_count": len(re.findall(r"\*\*\[INFERRED\]\*\*", text)),
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "primary_import": "CTZ Proposition 3.5 / Remark 3.6 on a non-hyperplane G-invariant divisor",
        "verdict": "no literature obstruction and no literature construction",
    }

    (RESULTS / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    (RESULTS / "citations.json").write_text(
        json.dumps(
            {
                "citations": citations,
                "needles": cite_needles,
                "hits": cite_hits,
            },
            indent=2,
        )
        + "\n"
    )
    (RESULTS / "group_arithmetic.json").write_text(
        json.dumps(
            {
                "psl2_11_order_formula": order_formula,
                "psl2_11_order_factors": order_factors,
                "character_degrees": degrees,
                "sum_of_squares": sos,
                "two_sylow_order": two_sylow_order,
                "index_of_borel_c11_rtimes_c5": 660 // 55,
            },
            indent=2,
        )
        + "\n"
    )
    print("wrote results/summary.json")
    print("order", order_formula, order_factors, "sos", sos)
    print("citations", sum(cite_hits.values()), "/", len(cite_hits))
    print("phrases", sum(phrase_hits.values()), "/", len(phrase_hits))


if __name__ == "__main__":
    main()
