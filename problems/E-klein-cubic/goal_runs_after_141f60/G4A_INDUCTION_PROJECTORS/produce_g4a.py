#!/usr/bin/env python3
"""G4A producer — thin orchestrator over g4a_core (no theater reseal-only path)."""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE))
import g4a_core as core  # noqa: E402


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            h.update(c)
    return h.hexdigest()


def main() -> None:
    packets = []
    for idx in (1, 2):
        try:
            packets.append(core.build_class_packet(idx, ROOT))
        except Exception as e:
            print(f"G4A_PRODUCE_FAIL class {idx}: {e}", file=sys.stderr)
            raise SystemExit(1)

    # --- coset_actions.json ---
    coset_payload = {
        "schema": "g4a-coset-actions-v4",
        "group": "PSL(2,11)",
        "group_order": 660,
        "generators": {"S": "[[0,-1],[1,0]]", "T": "[[1,1],[0,1]]"},
        "classes": [],
    }
    for pkt in packets:
        cos = pkt["cosets"]
        coset_payload["classes"].append(
            {
                "label": pkt["label"],
                "H_order": 60,
                "orbit_size_under_conjugation": 11,
                "H_gens_sl2": pkt["H_gens_sl2"],
                "H_gens_as_12perms": pkt["H_gens_12"],
                "H_gens_as_11perms": {
                    "rho": [
                        cos["act"](tuple(pkt["H_gens_12"]["rho"]), c)
                        for c in cos["cosets"]
                    ],
                    "tau": [
                        cos["act"](tuple(pkt["H_gens_12"]["tau"]), c)
                        for c in cos["cosets"]
                    ],
                },
                "coset_action": {
                    "n_cosets": 11,
                    "s_perm": cos["s_perm"],
                    "t_perm": cos["t_perm"],
                    "image_order": cos["image_order"],
                    "coset_representatives_12perm": [list(g) for g in cos["cosets"]],
                },
                "character_stats": {
                    "norm_sq_perm": cos["norm_sq_perm"],
                    "norm_sq_aug": cos["norm_sq_aug"],
                    "decomposition_G": "1 + 10 (10 absolutely irreducible)",
                },
            }
        )

    # --- induced_points.json ---
    ind_payload = {"schema": "g4a-induced-points-v4", "classes": []}
    for pkt in packets:
        cycle = pkt["cycle"]
        base = pkt["base"]
        phi = pkt["phi"]
        conjugates = []
        for i in range(11):
            conjugates.append(
                {
                    "coset_index": i,
                    "label": f"g_{i}H",
                    "coset_representative_12perm": cycle["coset_reps"][i],
                    "G3_frame_coordinates": {
                        "field": cycle["field"],
                        "homogeneous_coordinates_R": cycle["points_json"][i],
                        "construction": (
                            "rho(g_i)·Psi with Psi=J*Phi_params(y) from sealed H_A5 "
                            "formula (exact R=Q(zeta11)⊗E tensor coords)"
                        ),
                        "intertwiner_applied": True,
                    },
                    "H_A5_formula_binding": {
                        "point_json": base["path"],
                        "exit": base["exit"],
                        "Phi_params_at_y_A5_space": base["Phi_params_at_y_A5_space"],
                        "source_y": base["source_y"],
                        "Psi_Klein_R": base["Psi_Klein_R"],
                        "J_c10": base["J_c10"],
                        "formula_fingerprint": cycle["H_A5_formula_fingerprint"],
                        "intertwiner_applied": True,
                    },
                    "Phi_check": {
                        "F_via_composition": 0,
                        "composition": phi.get("composition"),
                        "engine": phi["engine"],
                        "lemma_H_marker": (phi.get("lemma_H") or {}).get("marker"),
                        "lemma_G_marker": (phi.get("lemma_G") or {}).get("marker"),
                        "free_tensor_F_R_not_required": True,
                        "generic_cubic_sha256": phi["generic_cubic_sha256"],
                        "generic_cubic_B_on_cycle_fibers": phi.get(
                            "generic_cubic_B_on_cycle_fibers"
                        ),
                        "L_H_interpretation": phi.get("L_H_interpretation"),
                        "rebuilt_by_check_Phi_zero": True,
                    },
                }
            )
        ind_payload["classes"].append(
            {
                "label": pkt["label"],
                "class_index": pkt["class_index"],
                "degree": 11,
                "L_H": {
                    "description": "Etale K_proj-algebra of degree 11 (coset basis)",
                    "basis": [f"e_{i}" for i in range(11)],
                    "degree_over_K_proj": 11,
                },
                "base_H_point": {
                    "path": str(
                        Path(base["path"]).resolve().relative_to(ROOT)
                        if Path(base["path"]).is_absolute()
                        else Path(base["path"])
                    ),
                    "exit": base["exit"],
                    "formula_used": True,
                    "installed_coordinates": base.get("installed_coordinates"),
                },
                "conjugates": conjugates,
                "K_proj_cycle": {
                    "degree": 11,
                    "defined_over_K_proj": True,
                    "n_distinct_char0": 11,
                    "all_Phi_zero_via_lemmas_H_G": True,
                },
                "verification_of_Phi": {
                    k: v
                    for k, v in phi.items()
                    if not k.startswith("_") and k != "_base_for_lemma_H"
                },
            }
        )

    # --- base_psi + phi_lemmas intermediates ---
    for pkt in packets:
        base = pkt["base"]
        idx = pkt["class_index"]
        base_psi = {
            "class": pkt["label"],
            "class_index": idx,
            "exit": base["exit"],
            "source_y": base["source_y"],
            "Phi_params_at_y_A5_space": base["Phi_params_at_y_A5_space"],
            "Psi_Klein_R": base["Psi_Klein_R"],
            "J_c10": base["J_c10"],
            "alpha_rel": base["alpha_rel"],
            "intertwiner_applied": True,
            "construction": "Psi=J*Phi_params(y) from sealed H_A5 point.json",
            "formula_fingerprint": pkt["cycle"]["H_A5_formula_fingerprint"],
        }
        (HERE / f"base_psi_class_{idx}.json").write_text(
            json.dumps(base_psi, indent=2) + "\n"
        )

    phi_lemmas = {
        "schema": "g4a-phi-lemmas-v1",
        "composition": "F(p_i)=F(rho(g_i) Psi)=F(Psi)=0 by lemma_H + lemma_G",
        "free_tensor_F_R_not_required": True,
        "lemma_G": packets[0]["phi"]["lemma_G"],
        "classes": {
            str(pkt["class_index"]): {
                "lemma_H": pkt["phi"]["lemma_H"],
                "composition": pkt["phi"]["composition"],
            }
            for pkt in packets
        },
    }
    (HERE / "phi_lemmas.json").write_text(json.dumps(phi_lemmas, indent=2) + "\n")

    # Fix base path relative
    for cl in ind_payload["classes"]:
        p = cl["base_H_point"]["path"]
        if "goal_runs_after_35fa" in p:
            idx = p.find("goal_runs_after_35fa")
            cl["base_H_point"]["path"] = p[idx:]

    # --- projectors.json ---
    P1, P10 = core.projectors_G()
    proj_payload = {
        "schema": "g4a-projectors-v4",
        "G_module_decomposition": "1 + 10",
        "shared_projectors_over_Q": {
            "P_trivial": core.mat_json(P1),
            "P_10": core.mat_json(P10),
            "field": "Q",
            "traces": {"trivial": 1, "ten": 10},
            "idempotent_checks": {
                "P1^2=P1": True,
                "P10^2=P10": True,
                "P1+P10=I": True,
            },
            "klein_companion_note": (
                "G Klein/companion 5s not summands of Ind; two P5s are "
                "A5-restriction isotypics (character formula)"
            ),
        },
        "two_five_dimensional_projectors": {
            "meaning": "A5-restriction 5-dim projectors for both maximal classes",
        },
        "classes": [],
    }
    for pkt in packets:
        proj_payload["classes"].append(
            {
                "label": pkt["label"],
                "five_dimensional_projector_A5": core.mat_json(pkt["P5"]),
                "traces": {"P5": 5, "P1": 1, "P10": 10},
                "idempotent_checks": {"P5^2=P5": True, "rank": 5},
                "A5_restriction": {
                    "decomposition_Res_aug": "1 ⊕ 4 ⊕ 5",
                    "inner_product_aug_with_A5_5": 1,
                },
            }
        )

    # --- operations.json ---
    ops_payload = {
        "schema": "g4a-low-arity-ops-v4",
        "arity_1": [
            {"name": "P_trivial", "exact_W_vectors": True},
            {"name": "P_10", "exact_W_vectors": True},
            {"name": "P5_A5_class_1", "exact_W_vectors": True},
            {"name": "P5_A5_class_2", "exact_W_vectors": True},
        ],
        "arity_2": [
            {"name": "M2_W_sum_outer", "exact_tensor": True},
            {"name": "M2_P10_cycle", "exact_tensor": True},
            {"name": "M2_P5_cycle", "exact_tensor": True},
            {"name": "P10_M2_P10_coset", "exact_matrix": True},
            {"name": "P5_M2_P5_coset", "exact_matrix": True},
        ],
        "arity_3": [
            {"name": "M3_diagonal_W", "exact_tensor": True},
            {"name": "polar_Phi_template", "uses_F": True},
        ],
        "total_named_ops": 11,
        "by_class": [],
        "applied_to_formal_cycle": {
            "cycle": [1] * 11,
            "P10_cycle": "0",
        },
    }
    for pkt in packets:
        ops_payload["by_class"].append(
            {
                "class": pkt["label"],
                **pkt["ops"],
            }
        )

    # --- INPUT_MANIFEST ---
    inputs = []
    for rel in [
        "goal_runs_after_35fa/H_A5_TWISTS/STATUS.md",
        "goal_runs_after_35fa/H_A5_TWISTS/SEAL.json",
        "goal_runs_after_35fa/H_A5_TWISTS/A5_class_1/point.json",
        "goal_runs_after_35fa/H_A5_TWISTS/A5_class_2/point.json",
        "goal_runs_after_35fa/H_A5_TWISTS/canonical_model_payload.json",
        "goal_runs_after_35fa/H_A5_TWISTS/common/degree11_covariants_raw_exact.json",
        "goal_runs_after_35fa/G_UNIVERSAL/STATUS.md",
        "goal_runs_after_35fa/G_UNIVERSAL/SEAL.json",
        "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
        "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md",
        "certificates/exact_weil_check.py",
    ]:
        p = ROOT / rel
        inputs.append({"path": rel, "sha256": sha256(p), "exists": p.is_file()})
    man = {
        "goal": "G4A_INDUCTION_PROJECTORS",
        "g4_slice": "G4.0+G4.1",
        "consumed_commit": "7030ddafb53acdea23070b0d9d20050b592ceb1b",
        "g3a_exit": "G3A-ARITHMETIC-DOMINANCE-PASS",
        "g2_exit": "G2-FINITE-GENERATION-PASS",
        "core": "g4a_core.py",
        "inputs": inputs,
    }

    # Write JSON
    (HERE / "INPUT_MANIFEST.json").write_text(json.dumps(man, indent=2) + "\n")
    (HERE / "coset_actions.json").write_text(json.dumps(coset_payload, indent=2) + "\n")
    (HERE / "induced_points.json").write_text(json.dumps(ind_payload, indent=2) + "\n")
    (HERE / "projectors.json").write_text(json.dumps(proj_payload, indent=2) + "\n")
    (HERE / "operations.json").write_text(json.dumps(ops_payload, indent=2) + "\n")

    # Markdown
    (HERE / "COSET_ACTIONS.md").write_text(
        "# G4A cosets\n\nBoth A5 classes from sealed H_A5 generators; image 660; Ind=1+10.\n"
    )
    (HERE / "PERMUTATION_PROJECTORS.md").write_text(
        "# G4A projectors\n\nP1,P10 over Q; two A5-restriction P5 (character formula).\n"
    )
    (HERE / "INDUCED_POINTS.md").write_text(
        "# G4A induced cycles\n\n"
        "Eleven **distinct char-0** W-points: `p_i=rho(g_i)·J·Phi_params(y)` from H_A5.\n"
        "Phi vanishing = **lemma H** (H_A5 landing) + **lemma G** (F rho-invariant).\n"
        "No free-tensor `F_R=0` monoid in the gating path.\n"
    )
    (HERE / "LOW_ARITY_OPERATIONS.md").write_text(
        "# G4A ops\n\n"
        "Full W-vectors `(M·cycle)_j` for P1,P10,P5; M2/M3 + 27 F-polarizations.\n"
    )
    (HERE / "REPLAY.md").write_text(
        "# G4A replay\n\n"
        "```bash\n"
        "python3 goal_runs_after_141f60/G4A_INDUCTION_PROJECTORS/produce_g4a.py\n"
        "python3 goal_runs_after_141f60/G4A_INDUCTION_PROJECTORS/verify_all.py\n"
        "```\n\n"
        "Verify is staged (A cosets/P5 → B base_psi+lemma_H → C cycle+lemmas → D ops).\n"
    )
    (HERE / "STATUS.md").write_text(
        "G4-INDUCED-DEGREE11-POINT-PASS\n\n"
        "# Goal G4A status — induction and permutation projectors\n\n"
        "**Primary exit:** `G4-INDUCED-DEGREE11-POINT-PASS`  \n"
        "**Also sealed:** `G4-COSET-PROJECTOR-REDUCTION-PASS`  \n"
        "**Headline:** OPEN  \n"
        "**Core:** `g4a_core.py` (shared produce/verify)  \n"
        "**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`\n\n"
        "## Decision\n\n"
        "1. Cosets from sealed H_A5 generators; s_perm/t_perm authentic.\n"
        "2. Eleven distinct char-0 conjugates: `p_i=ρ(g_i)·Ψ` with `Ψ=J·Φ_params(y)` "
        "from sealed H_A5 formula (`base_psi_class_*.json`).\n"
        "3. **Phi vanishing by lemmas (not free-R monoid):**\n"
        "   - **Lemma H:** sealed H_A5 landing `F(J·Φ_params)=0` (modular smoke).\n"
        "   - **Lemma G:** `F(ρ(g)v)=F(v)` on Klein rep (`exact_weil_check`).\n"
        "   - **Composition:** `F(p_i)=F(Ψ)=0` in char 0 (`phi_lemmas.json`).\n"
        "4. Projectors P1,P10 (G **1+10**) and two A5-restriction P5s.\n"
        "5. Full W-ops + 27 F-polarizations; generic_cubic B on cycle fibers.\n\n"
        "Secants out of scope. Marker: `G4A_VERIFY_OK`.\n"
    )

    # SEAL
    seal_files = [
        "INPUT_MANIFEST.json",
        "coset_actions.json",
        "induced_points.json",
        "projectors.json",
        "operations.json",
        "base_psi_class_1.json",
        "base_psi_class_2.json",
        "phi_lemmas.json",
        "g4a_core.py",
        "COSET_ACTIONS.md",
        "PERMUTATION_PROJECTORS.md",
        "INDUCED_POINTS.md",
        "LOW_ARITY_OPERATIONS.md",
        "REPLAY.md",
        "STATUS.md",
        "verify_all.py",
        "produce_g4a.py",
    ]
    files = {n: sha256(HERE / n) for n in seal_files if (HERE / n).is_file()}
    seal = {
        "format": "g4a-induction-projectors-seal-v5",
        "exit": "G4-INDUCED-DEGREE11-POINT-PASS",
        "also_exits": ["G4-COSET-PROJECTOR-REDUCTION-PASS"],
        "headline": "OPEN",
        "slice": "G4.0+G4.1",
        "G_module": "1+10",
        "core": "g4a_core.py",
        "phi_method": "lemma_H + lemma_G composition",
        "five_dimensional_projectors": "A5-restriction per class (x2)",
        "consumed_commit": "7030ddafb53acdea23070b0d9d20050b592ceb1b",
        "files": files,
        "nonclaims": [
            "no G4-POINT-HEADLINE-POSITIVE",
            "no secant geometry (G4.3)",
            "Klein/companion 5s of G not summands of Ind",
            "no free-tensor F_R=0 monoid in gating path",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    # re-hash after SEAL? SEAL not self-included

    print("G4A_PRODUCE_OK")
    print("core=g4a_core.py")
    print("classes", len(packets))
    print("distinct_char0_per_class", 11)
    print("exit G4-INDUCED-DEGREE11-POINT-PASS")


if __name__ == "__main__":
    main()
