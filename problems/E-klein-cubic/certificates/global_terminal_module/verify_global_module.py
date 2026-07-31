#!/usr/bin/env python3
"""Independent verifier for G4.2 / gate G-A.

Does NOT import produce_global_module.py.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "global_finite_lifting"))

from common_g4 import (  # noqa: E402
    compute_universal_jets,
    residual_from_universal,
    sha256_bytes,
)
from common_g3 import dim_sym, multi_rees_dim  # noqa: E402


def load(path: Path) -> dict:
    return json.loads(path.read_text())


def check_self_hash(path: Path) -> dict:
    obj = load(path)
    stored = obj.get("self_sha256")
    obj2 = dict(obj)
    obj2["self_sha256"] = None
    text = json.dumps(obj2, indent=2, sort_keys=True) + "\n"
    h = sha256_bytes(text.encode())
    if stored != h:
        raise AssertionError(f"self_sha256 mismatch {path.name}")
    return obj


def main() -> int:
    required = [
        "semigroup_generators.json",
        "source_presentation.json",
        "target_presentation.json",
        "terminal_matrix.json",
        "regression_7_13_19.json",
        "global_terminal_module_seal.json",
        "GLOBAL_TERMINAL_MODULE.md",
    ]
    for name in required:
        assert (HERE / name).exists(), name

    semi = check_self_hash(HERE / "semigroup_generators.json")
    reg = check_self_hash(HERE / "regression_7_13_19.json")
    seal = check_self_hash(HERE / "global_terminal_module_seal.json")
    source = check_self_hash(HERE / "source_presentation.json")
    target = check_self_hash(HERE / "target_presentation.json")

    # Semigroup finite
    assert semi["generators"]["finite"] is True
    assert semi["normaliz"]["finite"] is True
    print("OK semigroup finite")

    # Regression
    assert all(reg["matches_TERMINAL_PATTERN"].values()), reg["matches_TERMINAL_PATTERN"]
    jets = compute_universal_jets(81)
    for m, d, nsq in [(1, 7, "1296"), (1, 13, "156816"), (3, 19, "15968016")]:
        res = residual_from_universal(m, d, jets)
        assert res["residual_norm_sq"] == nsq
        key = f"m{m}_d{d}"
        assert reg["samples"][key]["residual_norm_sq"] == nsq
    print("OK regression 7/13/19")

    # Gate G-A: no full global finite presentation; free fibre yes
    assert seal["free_fibre_finite_presentation"] is True
    assert seal["full_global_finite_presentation"] is False
    assert seal["do_not_run_degree_ladder"] is True
    assert seal["gate_G_A"] == "G_A_NO_FINITE_GLOBAL_PRESENTATION"
    assert "EQUALIZER" in seal["obstruction_code"]
    print("OK gate G-A obstruction recorded")

    # Dimension samples recomputed
    for s in seal["dimension_samples"]:
        m, d = s["m"], s["d"]
        N = d + 2 * m + 1
        cod = dim_sym(3, 3 * d - N) * (N + 1)
        assert cod == s["multi_rees_codomain_at_Nstar"]
        dom = 0
        for k in range(m, d + 1):
            tdim = 3 if k % 2 == 0 else 2
            dom += multi_rees_dim(k, tdim, d)
        assert dom == s["multi_rees_total_jet_dim"]
    print("OK dimension samples")

    # Source/target mark free fibre finite, global not
    assert source["full_global_finite_presentation"] is False
    assert target["full_global_finite_presentation"] is False
    assert source["free_fibre_chart_presentation"]["finite_presentation"] is True

    # No timing fields in sealed payloads
    for obj in (semi, reg, seal, source, target):
        blob = json.dumps(obj)
        assert "wall_clock" not in blob
        assert "elapsed_sec" not in blob

    print("G42_GLOBAL_MODULE_VERIFY_OK")
    print("G_A_NO_FINITE_GLOBAL_PRESENTATION")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as e:
        print("VERIFY_FAIL", type(e).__name__, e, file=sys.stderr)
        raise
