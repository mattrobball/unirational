#!/usr/bin/env python3
"""Produce the exact arithmetic payload for the Parshin-completion theorem."""

from __future__ import annotations

from hashlib import sha256
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
GOALS = HERE.parents[2]
PROBLEM = GOALS.parent

GENERIC = GOALS / "G_ALL_DEGREE/generic_cubic.json"
KPROJ = PROBLEM / "tmp/kproj_arithmetic/normalized_kproj_table.json"
KPROJ_MODEL = PROBLEM / "tmp/kproj_arithmetic/model.py"
GENERIC_VERIFY = GOALS / "G_ALL_DEGREE/verify_generic_cubic.py"
ZERO = GOALS / "Q_SCHUR_DESCENT/zero_cycle_payload.json"
ZERO_VERIFY = GOALS / "Q_SCHUR_DESCENT/verify_zero_cycle_ledger.py"


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    generic = json.loads(GENERIC.read_text())
    kproj = json.loads(KPROJ.read_text())
    zero = json.loads(ZERO.read_text())

    triples = sorted(tuple(item["triple"]) for item in generic["coefficients"])
    expected = list(itertools.combinations_with_replacement(range(5), 3))
    assert triples == expected
    assert generic["coefficient_count"] == 35
    assert len(generic["projective_basis"]) == 12
    assert kproj["coefficient_field"] == "QQ(t3,t6,t8,t11)"
    assert len(kproj["secondary_degrees"]) == 12
    assert zero["group_order"] == 660
    assert zero["d12_order"] == 12
    assert zero["d12_line_orbit_degree"] == 55 == 660 // 12
    assert zero["linear_section_degree"] == 3
    assert 55 + zero["degree55_section_coefficient"] * 3 == 1

    payload = {
        "schema": "G_VALUATION_PARSHIN_SOLUBILITY_V1",
        "live_commit_at_production": None,
        "generic_cubic": {
            "variables": 5,
            "degree": 3,
            "coefficient_count": 35,
            "field": "K_proj",
            "base": "QQ(t3,t6,t8,t11)",
            "base_transcendence_degree": 4,
            "field_degree_over_base": 12,
        },
        "effective_cycle": {
            "group_order": 660,
            "stabilizer": "D12",
            "stabilizer_order": 12,
            "orbit_degree": 55,
            "prime_to_three": True,
            "signed_index_identity": [1, -18],
            "signed_index_degrees": [55, 3],
        },
        "covered_parshin_ranks": [3, 4],
        "completion_model": (
            "standard successive complete-DVR field attached to a saturated "
            "geometric Parshin chain"
        ),
        "rank_table": [
            {
                "rank": rank,
                "terminal_residue_trdeg": 4 - rank,
                "coray_base_property": "CS by C1/plane-cubic/elementary cases",
                "conclusion": "completion point exists",
            }
            for rank in (3, 4)
        ],
        "unresolved_parshin_ranks": [1, 2],
        "completion_only": True,
        "henselization_claim": False,
        "coray": {
            "citation": "D. F. Coray, Acta Arith. 30 (1976), 267-296",
            "section": "4 Quasi-local fields",
            "theorem": "4.7",
            "pages": "281-282",
            "doi": "10.4064/aa-30-3-267-296",
            "archival_pdf": "http://matwbn.icm.edu.pl/ksiazki/aa/aa30/aa3037.pdf",
            "archival_pdf_sha256_observed_2026_08_01": (
                "ea2dcf48c17b9a2c5c5ec8a73d3ccf1c9178033da8d5e1e33fbf5323624c73c6"
            ),
        },
        "authoritative_hashes": {
            "G_ALL_DEGREE/generic_cubic.json": digest(GENERIC),
            "G_ALL_DEGREE/verify_generic_cubic.py": digest(GENERIC_VERIFY),
            "../tmp/kproj_arithmetic/normalized_kproj_table.json": digest(KPROJ),
            "../tmp/kproj_arithmetic/model.py": digest(KPROJ_MODEL),
            "Q_SCHUR_DESCENT/zero_cycle_payload.json": digest(ZERO),
            "Q_SCHUR_DESCENT/verify_zero_cycle_ledger.py": digest(ZERO_VERIFY),
        },
        "scope": (
            "Positive local solubility for standard successive complete-DVR "
            "fields of saturated geometric length-3/4 Parshin chains; no "
            "claim for arbitrary rank-valuation completions or henselizations, "
            "no K_proj point, and no pointlessness theorem."
        ),
    }

    import subprocess

    payload["live_commit_at_production"] = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=GOALS,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
    ).stdout.strip()
    (HERE / "certificate.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("G_VALUATION_PARSHIN_CERTIFICATE_PRODUCED")


if __name__ == "__main__":
    main()
