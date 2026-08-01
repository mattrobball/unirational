#!/usr/bin/env python3
"""Extend the deterministic p=353 C3 sample set inside this run directory."""

from __future__ import annotations

import json
import runpy
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "tmp" / "c3_work" / "degree_probe_p353.npz"
OUTPUT = HERE / "la_samples_p353.npz"
P = 353
ZETA = 58
TARGET = 7500


def main():
    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()

    kproj = {}
    core_path = ROOT / "tmp" / "kproj_arithmetic" / "core.py"
    exec(compile(core_path.read_text().replace("ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"), str(core_path), "exec"), kproj)
    forms = kproj["forms"]()
    evaluate_mod = kproj["evaluate_mod"]
    certificate = json.loads((ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json").read_text())
    seeds = certificate["end36_reynolds_frame"]["selected_reynolds_seeds"]
    conjugation, inverse_targets = c3["build_group"](c2, P, ZETA)

    source_path = OUTPUT if OUTPUT.exists() else SOURCE
    old = np.load(source_path)
    records = [{name: old[name][index] for name in old.files} for index in range(len(old["pts"]))]
    seen = {tuple(map(int, row["pts"])) for row in records}

    candidates = []
    for a in range(1, 41):
        for b in range(1, 41):
            for c in (1, 2, 3, 5, 7):
                candidates.append((a, b, c, a * b + c, a + 2 * b + 3 * c))
    for t in range(1, P):
        candidates.append((t, t * t + 1, t * t * t + 2, 2 * t + 3, 3 * t + 5))

    for candidate in candidates:
        if len(records) >= TARGET:
            break
        point = tuple(int(value) % P for value in candidate)
        if point in seen:
            continue
        seen.add(point)
        try:
            basis_mats, _basis_vecs = c3["frame_at_point"](
                c2, conjugation, inverse_targets, seeds, forms, evaluate_mod, point, P
            )
            compressed = c3["compressed_data_at"](basis_mats[1], basis_mats[2], P)
            tinfo = c3["evaluate_kproj_t_beta"](forms, evaluate_mod, point, P)
        except Exception:
            continue
        if compressed is None or tinfo is None:
            continue
        tvals, betas, _fvals = tinfo
        records.append({
            "pts": np.asarray(point, dtype=np.int64),
            "ts": np.asarray(tvals, dtype=np.int64),
            "betas": np.asarray(betas, dtype=np.int64),
            "minpolys": np.asarray(compressed["minpoly"], dtype=np.int64),
            "e_coords": np.asarray(compressed["e_coords"], dtype=np.uint16),
            "La_E": np.asarray(compressed["La_E"], dtype=np.uint16),
            "rect_dets": np.asarray(compressed["rect_det_m6"], dtype=np.int64),
        })
        if len(records) % 100 == 0:
            print(f"samples={len(records)}/{TARGET}", flush=True)

    assert len(records) >= TARGET, len(records)
    np.savez_compressed(
        OUTPUT,
        pts=np.stack([row["pts"] for row in records]),
        ts=np.stack([row["ts"] for row in records]),
        betas=np.stack([row["betas"] for row in records]),
        minpolys=np.stack([row["minpolys"] for row in records]),
        e_coords=np.stack([row["e_coords"] for row in records]),
        La_E=np.stack([row["La_E"] for row in records]),
        rect_dets=np.stack([row["rect_dets"] for row in records]),
    )
    print(f"WROTE {OUTPUT} samples={len(records)}")
    print("C0-LA-SAMPLES-P353")


if __name__ == "__main__":
    main()
