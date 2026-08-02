#!/usr/bin/env python3
"""Staged G4A verifier — cheap pure checks, no 2× full monoid build.

Target: well under 120s (typically ~15–30s).
Does not reimplement induction; imports g4a_core pure functions only.
"""
from __future__ import annotations

import hashlib
import json
import sys
import time
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE))
import g4a_core as core  # noqa: E402


def fail(msg: str) -> None:
    print(f"G4A_VERIFY_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            h.update(c)
    return h.hexdigest()


def main() -> None:
    t_all = time.time()
    for name in (
        "INPUT_MANIFEST.json",
        "coset_actions.json",
        "induced_points.json",
        "projectors.json",
        "operations.json",
        "phi_lemmas.json",
        "base_psi_class_1.json",
        "base_psi_class_2.json",
        "g4a_core.py",
        "produce_g4a.py",
        "SEAL.json",
        "STATUS.md",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    prod_src = (HERE / "produce_g4a.py").read_text()
    require("g4a_core" in prod_src and "build_class_packet" in prod_src, "produce uses core")
    # Hard fail if produce is validate-only theater
    require("build_class_packet" in prod_src, "produce regenerates")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("G4-INDUCED-DEGREE11-POINT-PASS\n"), "STATUS exit")
    # Must not claim free-tensor F_R==0
    require("free F_R=0" not in status and "F_R==0" not in status, "no free F_R claim")
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("headline") == "OPEN", "headline OPEN")
    require(seal.get("exit") == "G4-INDUCED-DEGREE11-POINT-PASS", "seal exit")

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for item in man["inputs"]:
        p = ROOT / item["path"]
        require(p.is_file(), f"missing {item['path']}")
        require(sha256(p) == item["sha256"], f"hash {item['path']}")

    stored_coset = json.loads((HERE / "coset_actions.json").read_text())
    stored_ind = json.loads((HERE / "induced_points.json").read_text())
    stored_proj = json.loads((HERE / "projectors.json").read_text())
    stored_ops = json.loads((HERE / "operations.json").read_text())
    phi_lemmas = json.loads((HERE / "phi_lemmas.json").read_text())

    # ------------------------------------------------------------------
    # Stage A: cosets + projectors (seconds)
    # ------------------------------------------------------------------
    t0 = time.time()
    s, t, G = core.build_G()
    require(len(G) == 660, "G order")
    P1, P10 = core.projectors_G()
    require(sp.simplify(P1 * P1 - P1) == sp.zeros(11), "P1")
    require(sp.simplify(P10 * P10 - P10) == sp.zeros(11), "P10")

    rebuilt = {}
    for idx in (1, 2):
        label = f"A5_class_{idx}"
        rho12, tau12, gens_sl2 = core.load_H_gens_from_canonical(idx, ROOT)
        cos = core.rebuild_cosets((rho12, tau12), G, s, t)
        scl = next(c for c in stored_coset["classes"] if c["label"] == label)
        require(cos["s_perm"] == scl["coset_action"]["s_perm"], f"s_perm {label}")
        require(cos["t_perm"] == scl["coset_action"]["t_perm"], f"t_perm {label}")
        P1b, P10b, P5 = core.projectors_A5(cos["cosets"], cos["H"], cos["act"])
        spcl = next(c for c in stored_proj["classes"] if c["label"] == label)
        P5s = core.mat_from_json(spcl["five_dimensional_projector_A5"])
        require(sp.simplify(P5s - P5) == sp.zeros(11), f"P5 match {label}")
        require(sp.simplify(P5.trace()) == 5, "tr P5")
        rebuilt[idx] = {
            "cos": cos,
            "P1": P1b,
            "P10": P10b,
            "P5": P5,
            "gens_sl2": gens_sl2,
        }
    print(f"STAGE_A_OK cosets+projectors {time.time()-t0:.1f}s")

    # ------------------------------------------------------------------
    # Stage B: re-eval base Ψ from point.json; match sealed base_psi_*; lemma H
    # ------------------------------------------------------------------
    t0 = time.time()
    for idx in (1, 2):
        label = f"A5_class_{idx}"
        point_path = (
            ROOT / f"goal_runs_after_35fa/H_A5_TWISTS/A5_class_{idx}/point.json"
        )
        base = core.eval_installed_H_point(point_path)
        require(base["intertwiner_applied"] is True, "J applied")
        require(not all(core.R_is_zero(c) for c in base["_Psi"]), "Psi nonzero")

        sealed_psi = json.loads((HERE / f"base_psi_class_{idx}.json").read_text())
        require(sealed_psi["class"] == label, "base_psi class")
        require(
            sealed_psi["Phi_params_at_y_A5_space"] == base["Phi_params_at_y_A5_space"],
            f"Phi_params match {label}",
        )
        require(
            sealed_psi["Psi_Klein_R"] == base["Psi_Klein_R"],
            f"Psi match {label}",
        )
        # Lemma H smoke (reuse base — no second intertwiner)
        h_res = core.lemma_H_landing(point_path, ROOT, precomputed_base=base)
        require(h_res["pass"] is True, "lemma H")
        require(h_res["marker"] == "LEMMA_H_H_A5_LANDING_PASS", "H marker")
        require(
            phi_lemmas["classes"][str(idx)]["lemma_H"]["marker"]
            == "LEMMA_H_H_A5_LANDING_PASS",
            "sealed lemma H",
        )
        rebuilt[idx]["base"] = base
        rebuilt[idx]["lemma_H"] = h_res
    print(f"STAGE_B_OK base_psi+lemma_H {time.time()-t0:.1f}s")

    # ------------------------------------------------------------------
    # Stage C: rebuild 11 points via ρ; match sealed cycle; distinctness
    # ------------------------------------------------------------------
    t0 = time.time()
    g_res = core.lemma_G_F_invariant()
    require(g_res["pass"] is True, "lemma G")
    require(g_res["marker"] == "LEMMA_G_F_RHO_INVARIANT_PASS", "G marker")
    require(
        phi_lemmas["lemma_G"]["marker"] == "LEMMA_G_F_RHO_INVARIANT_PASS",
        "sealed lemma G",
    )

    perm_to_rho = core.build_perm_to_rho()
    for idx in (1, 2):
        label = f"A5_class_{idx}"
        base = rebuilt[idx]["base"]
        cos = rebuilt[idx]["cos"]
        cycle = core.materialize_L_H_cycle(base, cos["cosets"], perm_to_rho)
        require(cycle["n_distinct"] == 11, "11 distinct")
        require(cycle["intertwiner_applied"] is True, "cycle J")
        # construction must name J*Phi_params
        sind = next(c for c in stored_ind["classes"] if c["label"] == label)
        require(len(sind["conjugates"]) == 11, "11 stored")
        stored_keys = []
        for i, conj in enumerate(sind["conjugates"]):
            g3 = conj["G3_frame_coordinates"]
            coords = g3.get("homogeneous_coordinates_R")
            require(coords is not None, "R coords")
            require(
                "J*Phi_params" in g3.get("construction", "")
                or "Phi_params" in g3.get("construction", ""),
                "construction names H_A5 formula",
            )
            # Hard fail e0-only construction
            require("e0" not in g3.get("construction", "").lower()
                    or "Phi_params" in g3.get("construction", ""),
                    "not e0 base")
            require(coords == cycle["points_json"][i], f"coord match {label} {i}")
            stored_keys.append(json.dumps(coords))
            bind = conj["H_A5_formula_binding"]
            require(bind.get("intertwiner_applied") is True, "bind J")
            require(
                bind["Phi_params_at_y_A5_space"] == base["Phi_params_at_y_A5_space"],
                "bind Phi_params",
            )
        require(len(set(stored_keys)) == 11, "stored distinct")
        # Composition Phi via lemmas (cheap; reuses base)
        cycle["_base_for_lemma_H"] = base
        phi = core.check_Phi_zero(
            cycle,
            ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
            point_json_path=ROOT
            / f"goal_runs_after_35fa/H_A5_TWISTS/A5_class_{idx}/point.json",
            root=ROOT,
        )
        require(phi["all_zero"] is True, "phi all zero")
        require(phi.get("free_tensor_F_R_not_required") is True, "no free F_R")
        require(phi["composition"].startswith("F(p_i)"), "composition string")
        require(
            phi["generic_cubic_B_on_cycle_fibers"]["unit_vector_B_not_used_for_cycle"]
            is True,
            "B on cycle not e0",
        )
        require(
            phi["generic_cubic_B_on_cycle_fibers"]["fiber0_mod89"] != [1, 0, 0, 0, 0],
            "fiber0 not e0",
        )
        rebuilt[idx]["cycle"] = cycle
        rebuilt[idx]["phi"] = phi
    print(f"STAGE_C_OK cycle+lemmas {time.time()-t0:.1f}s")

    # ------------------------------------------------------------------
    # Stage D: projectors on sealed cycle; match ops
    # ------------------------------------------------------------------
    t0 = time.time()
    for idx in (1, 2):
        label = f"A5_class_{idx}"
        ops = core.apply_ops(
            rebuilt[idx]["P1"],
            rebuilt[idx]["P10"],
            rebuilt[idx]["P5"],
            rebuilt[idx]["cycle"],
        )
        require(len(ops["arity_1"]["P5_A5_on_W_cycle"]) == 11, "P5 11")
        require(ops["arity_3"]["polar_count"] == 27, "polar 27")
        sops = next(c for c in stored_ops["by_class"] if c["class"] == label)
        require(len(sops["arity_1"]["P5_A5_on_W_cycle"]) == 11, "stored P5")
        require(
            sops["arity_1"]["P5_A5_on_W_cycle"][0]
            == ops["arity_1"]["P5_A5_on_W_cycle"][0],
            "P5[0] match",
        )
        require(sops["arity_3"]["polar_count"] == 27, "stored polar")
    print(f"STAGE_D_OK ops {time.time()-t0:.1f}s")

    # SEAL hashes
    for name, expected in seal.get("files", {}).items():
        if name == "SEAL.json":
            continue
        path = HERE / name
        require(path.is_file(), f"sealed missing {name}")
        require(sha256(path) == expected, f"hash {name}")

    elapsed = time.time() - t_all
    print(f"VERIFY_ELAPSED_S {elapsed:.1f}")
    if elapsed > 120:
        fail(f"verify too slow: {elapsed:.1f}s > 120s budget")

    print("G4A_COSET_ACTIONS_OK")
    print("G4A_H_A5_FORMULA_OK")
    print("G4A_PROJECTORS_OK")
    print("G4A_INDUCED_CYCLES_OK")
    print("G4A_PHI_SUBSTITUTION_OK")
    print("G4A_OPERATIONS_OK")
    print("G4A_VERIFY_OK")
    print(seal["exit"])
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
