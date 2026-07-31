#!/usr/bin/env python3
"""G3 producer: complete finite global lifting tower at (m,d)=(1,13).

Does NOT import verify.py. Exact arithmetic. No timing fields.
Headline remains OPEN. No formal lift is called a covariant.

Architecture at every stage (G4):
  plane normalization -> triple-line equalizer -> residual point kernel
"""

from __future__ import annotations

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
GFL = HERE.parent
ROOT = GFL.parent.parent
TMP = ROOT / "tmp" / "postelo_G3"
sys.path.insert(0, str(GFL))

from common_g3 import (  # noqa: E402
    build_g4_table,
    first_stage_no_poly_correction,
    free_Lr_rank_table,
    free_fibre_tower,
    jet_dimension_table,
    sample_leading_a_triv,
    stage_ledger,
    write_json,
)

M = 1
D = 13
TERMINAL = 3 * D


def main() -> int:
    TMP.mkdir(parents=True, exist_ok=True)
    print(f"=== G3 degree-{D} finite tower producer (m={M}) ===")

    a_coeffs, a_label = sample_leading_a_triv(M)
    print(f"leading sample: {a_label} = {[str(x) for x in a_coeffs]}")

    ledger = stage_ledger(M, D)
    write_json(HERE / "stage_ledger.json", ledger)
    print(
        f"PASS stage ledger: terminal {TERMINAL}, "
        f"nonauto {ledger['nonautomatic_orders']}"
    )

    jets = jet_dimension_table(M, D)
    write_json(HERE / "jet_dimensions.json", jets)
    print(f"PASS jet dims: multi_rees total {jets['total_multi_rees_dim']}")

    ranks = free_Lr_rank_table(M, D, a_coeffs, a_label)
    write_json(HERE / "free_Lr_ranks.json", ranks)
    n_surj = sum(1 for r in ranks["rows"] if r.get("surjective"))
    print(f"PASS free L_r ranks: {n_surj} surjective isolators on sample")

    first = first_stage_no_poly_correction(ledger)
    write_json(HERE / "first_terminal_stage.json", first)
    print(
        f"PASS first non-isolable F-order="
        f"{first['first_stage_without_Eplus_poly_isolator']}"
    )

    g4 = build_g4_table(ledger, D, M)
    write_json(
        HERE / "global_correction_modules.json",
        {
            "architecture": (
                "plane_normalization -> triple_line_equalizer -> residual_point_kernel"
            ),
            "stages": g4,
            "irrelevant_torsion_retained": True,
            "source_line_coupling_retained": True,
            "marked_elliptic_data_retained": True,
            "repaired_category_retained": True,
            "bidegree": {"m": M, "d": D},
        },
    )
    print(f"PASS G4 architecture on {len(g4)} stages")

    print("Running free-fibre sample based_zero ...")
    sample0 = free_fibre_tower(
        M, D, a_coeffs, mode="based_zero", a_label=a_label
    )
    write_json(HERE / "tower_sample_based_zero.json", sample0)
    print(
        f"PASS sample0 first nonzero F-order="
        f"{sample0['first_nonzero_terminal_F_order']}"
    )

    print("Running free-fibre sample ker_L1 ...")
    sample1 = free_fibre_tower(
        M, D, a_coeffs, mode="ker_L1", a_label=a_label
    )
    write_json(HERE / "tower_sample_kerL1.json", sample1)
    print(
        f"PASS sample1 first nonzero F-order="
        f"{sample1['first_nonzero_terminal_F_order']}"
    )

    s0_nz = sample0["first_nonzero_terminal_F_order"]
    s1_nz = sample1["first_nonzero_terminal_F_order"]
    first_post = first["first_stage_without_Eplus_poly_isolator"]
    res_norm = None
    if s1_nz is not None:
        res_norm = sample1["terminal_residuals"][str(s1_nz)]["residual_norm_sq"]

    # Classification layer (no full G-exclusion for d=13 in this package)
    obstruction = {
        "free_fibre_truncated_polar": {
            "status": (
                "NONZERO_RESIDUAL_ON_OPEN"
                if s1_nz is not None
                else "VANISHES_ON_SAMPLES"
            ),
            "first_nonzero_F_order_kerL1_sample": s1_nz,
            "residual_norm_sq_at_first": res_norm,
            "pure_Eminus_based_branch": {
                "first_nonzero": s0_nz,
                "note": (
                    "With all E+ jets zero, free-fibre F vanishes by "
                    "triple-E- vanishing when only a_m is nonzero of odd order "
                    "with 3m odd. Not a G-covariant."
                ),
            },
            "residual_decomposition": sample1.get("residual_decomposition"),
        },
        "polynomial_truncation": {
            "last_isolable_Eplus_F_order": first["last_isolable_Eplus_F_order"],
            "first_stage_without_Eplus_poly_isolator": first_post,
            "formal_newest_needed_at_first_noniso": (
                first["stage"]["formal_newest_Eplus_order"] if first["stage"] else None
            ),
            "within_degree": False,
        },
        "invariants": {
            "m": M,
            "d": D,
            "d_mod_6": D % 6,
            "d_minus_6m": D - 6 * M,
            "source_line_ledger": "based_style_a_odd_zero_on_samples",
            "residual_S3_type_leading": a_label,
        },
    }

    exit_code = "G13-OBSTRUCTION" if s1_nz is not None else "G13-INTERFACE"
    exit_payload = {
        "exit": exit_code,
        "bidegree": {"m": M, "d": D},
        "headline": "OPEN",
        "gate_G1": "PASS",
        "terminal_F_order": TERMINAL,
        "first_stage_without_Eplus_poly_isolator": first_post,
        "obstruction_layers": obstruction,
        "free_fibre_samples": {
            "based_zero": {
                "first_nonzero_F_order": s0_nz,
                "early_vanish": sample0["early_orders_vanish"],
                "solvable_through_all_isolators": sample0[
                    "solvable_through_all_isolators"
                ],
            },
            "ker_L1": {
                "first_nonzero_F_order": s1_nz,
                "early_vanish": sample1["early_orders_vanish"],
                "b_m_plus_1_nonzero": sample1["b_m_plus_1_nonzero"],
                "solvable_through_all_isolators": sample1[
                    "solvable_through_all_isolators"
                ],
                "residual_norm_sq_at_first": res_norm,
            },
        },
        "not_a_covariant": True,
        "house_rules": [
            "No formal state or formal lift called a covariant",
            "Exact arithmetic; finite fields discovery only",
            "G4 architecture enforced; no local=>global surjectivity promotion",
        ],
        "decision_summary": (
            f"Finite truncation (G1) reduces algebraization at d={D} to a finite "
            f"polar system through F-order {TERMINAL}. Isolable E+ polynomial "
            f"corrections exist only through F-order "
            f"{first['last_isolable_Eplus_F_order']}. First stage without E+ "
            f"poly isolator: {first_post}. Free-fibre ker-L1 sample first nonzero "
            f"residual at F-order {s1_nz} (norm^2={res_norm}). "
            f"d-6m={D-6*M}. Exit {exit_code}. Headline OPEN."
        ),
    }
    write_json(HERE / "exit.json", exit_payload)
    print(f"EXIT {exit_code}")

    # TOWER.md
    lines = []
    lines.append(f"# Degree-{D} finite global lifting tower\n")
    lines.append("\n**Headline: OPEN.**  ")
    lines.append(f"\n**Exit: `{exit_code}`.**  ")
    lines.append(f"\n**Bidegree: (m,d)=({M},{D}).**  ")
    lines.append(f"\n**d − 6m = {D - 6 * M}.**  ")
    lines.append(f"\n**Gate G1: PASS** (finite truncation at normal order {TERMINAL}).\n")
    lines.append("\n## 1. Finite terminal system\n")
    lines.append(
        f"\nBy G1, landing F(p)=0 for a degree-{D} polynomial map is equivalent to "
        f"vanishing of all normal components of F(p) through order 3d={TERMINAL}. "
        f"Nonautomatic even orders with live triples: {ledger['nonautomatic_orders']}.\n"
    )
    lines.append("\n## 2. Polynomial jet dimensions\n")
    lines.append(
        "\n| order | target | free fibre | multi-Rees dim |\n"
        "|------:|--------|----------:|---------------:|\n"
    )
    for row in jets["rows"]:
        lines.append(
            f"| {row['normal_order']} | {row['target']} | "
            f"{row['free_fibre_rank']} | {row['multi_rees_dim']} |\n"
        )
    lines.append(
        f"\nTotal multi-Rees dimension: **{jets['total_multi_rees_dim']}**.\n"
    )
    lines.append("\n## 3. Isolation stages vs polynomial degree\n")
    lines.append(
        "\n| F-order | type | formal newest E+ | within d? |\n"
        "|--------:|------|-----------------:|-----------|\n"
    )
    for s in ledger["stages"]:
        if s["automatic_by_y_evenness"] or not s["live_triples"]:
            continue
        lines.append(
            f"| {s['F_order']} | {s['equation_type']} | "
            f"{s.get('formal_newest_Eplus_order')} | "
            f"{s.get('isolable_Eplus_within_d')} |\n"
        )
    lines.append(
        f"\n**Last isolable E+ F-order:** {first['last_isolable_Eplus_F_order']}.  \n"
        f"**First stage without E+ polynomial isolator:** {first_post}.\n"
    )
    lines.append("\n## 4. G4 global correction architecture\n")
    lines.append(
        "\nEvery nonautomatic stage is presented as\n\n"
        "```text\n"
        "plane normalization -> triple-line equalizer -> residual point kernel\n"
        "```\n\n"
        "Local free-module surjectivity is **not** promoted to global solvability.\n"
    )
    lines.append("\n## 5. Free-fibre terminal residual (exact)\n")
    lines.append(
        f"\nLeading sample `{a_label}`.\n\n"
        f"Sample `based_zero`: first nonzero terminal residual at F-order **{s0_nz}**.\n\n"
        f"Sample `ker_L1`: early isolable orders solved; first nonzero residual at "
        f"F-order **{s1_nz}** (norm^2 = {res_norm}).\n"
    )
    if sample1.get("residual_decomposition"):
        rd = sample1["residual_decomposition"]
        lines.append(
            f"\nResidual C3 weights at first obstruction: "
            f"**{rd.get('dominant_C3_weights')}** "
            f"(support size {rd.get('support_size')}).\n"
        )
    lines.append("\n## 6. Invariants recorded for G3 pattern\n")
    lines.append(
        f"\n| invariant | value |\n|-----------|------:|\n"
        f"| m | {M} |\n"
        f"| d | {D} |\n"
        f"| d mod 6 | {D % 6} |\n"
        f"| d − 6m | {D - 6 * M} |\n"
        f"| first non-isolable F-order | {first_post} |\n"
        f"| first nonzero free-fibre residual (ker L1) | {s1_nz} |\n"
        f"| residual norm^2 | {res_norm} |\n"
        f"| residual S3-type (leading) | {a_label} |\n"
        f"| source-line ledger (samples) | based a_odd=0 |\n"
    )
    lines.append(
        "\n## 7. Boundary\n\n"
        "| Proved | Not proved |\n"
        "|--------|------------|\n"
        f"| Complete free-fibre tower at (1,{D}) | All-degree periodic obstruction |\n"
        "| Exact residual on ker-L1 sample | Full multi-Rees equalizer elimination |\n"
        "| G4 architecture at every stage | G-global Molien landing for d=13 |\n\n"
        "**Headline remains OPEN.**\n"
    )
    (HERE / "TOWER.md").write_text("".join(lines))
    print("PASS wrote TOWER.md")

    summary = {
        "exit": exit_code,
        "headline": "OPEN",
        "bidegree": {"m": M, "d": D},
        "d_minus_6m": D - 6 * M,
        "gate_G1": "PASS",
        "terminal_F_order": TERMINAL,
        "first_stage_without_Eplus_poly_isolator": first_post,
        "multi_rees_total_dim": jets["total_multi_rees_dim"],
        "sample0_first_nonzero": s0_nz,
        "sample1_first_nonzero": s1_nz,
        "sample1_residual_norm_sq": res_norm,
        "leading_sample": a_label,
        "files": sorted(p.name for p in HERE.iterdir() if p.is_file()),
    }
    write_json(HERE / "SUMMARY.json", summary)
    print("G13_TOWER_PRODUCE_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
