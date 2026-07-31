#!/usr/bin/env python3
"""Independent verifier for P25R.1 global correction spaces.

Does not import produce_correction_spaces.py.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import common_p25r as C  # noqa: E402


def check_self_hash(path: Path) -> None:
    data = json.loads(path.read_text())
    claimed = data["self_sha256"]
    body = {k: v for k, v in data.items() if k != "self_sha256"}
    assert claimed == C.sha256_bytes(C.canonical_json(body).encode()), path.name


def main() -> None:
    for name in (
        "exit_p25r0.json",
        "exit_p25r1.json",
        "family_linear_gates.json",
        "stage_subspaces.json",
        "global_jet_map.json",
    ):
        check_self_hash(HERE / name)

    e0 = json.loads((HERE / "exit_p25r0.json").read_text())
    e1 = json.loads((HERE / "exit_p25r1.json").read_text())
    gates = json.loads((HERE / "family_linear_gates.json").read_text())
    stages = json.loads((HERE / "stage_subspaces.json").read_text())
    gmap = json.loads((HERE / "global_jet_map.json").read_text())

    assert e0["exit"] == "P25R0-PASS"
    assert e1["exit"] == "P25R1-PASS"
    assert e1["free_a_d_proxy_rejected"] is True
    assert e1["residual_image_rank"] == 7
    assert e1["based_kernel_dim"] == 36

    based = gates["based_minus_lines_odd_m"]
    resid = gates["residual_e_ge7_generic_swap_both"]
    assert based["linear_conditions"]["kernel_dim_in_V25"] == 36
    assert resid["a_d_global"]["genuine_image_rank"] == 7
    assert resid["a_d_global"]["free_fibre_dim"] == 52

    assert stages["global_coordinate_vector"]["dim"] == 43
    assert stages["residual_stage"]["genuine_global_image_rank"] == 7
    assert all(s["C_r_glob"]["not_independent_per_stage"] for s in stages["stages"])
    assert gmap["dense_868x43_materialized"] is False
    assert (HERE / "GLOBAL_CORRECTION_SPACES.md").is_file()
    print("P25R1_CORRECTION_SPACES_VERIFIED", flush=True)


if __name__ == "__main__":
    main()
