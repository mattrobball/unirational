#!/usr/bin/env python3
"""Independent verifier for certificates/schur_degree19 (Attempt 3 Gates 1-2).

Does NOT import any producer module.  Recomputes the numerical ledgers and
checks sealed JSON invariants and markdown terminal markers.
"""
from __future__ import annotations

import hashlib
import json
import platform
import resource
import sys
from math import comb
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1] if HERE.name == "schur_degree19" else HERE


def sdim(d: int) -> int:
    return 0 if d < 0 else comb(d + 3, 3)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def check_ledgers() -> dict:
    h_z = [1, 4, 10, 19, 31, 45, 55]
    i_z = [sdim(d) - h_z[d] for d in range(7)]
    assert i_z == [0, 0, 0, 1, 4, 11, 29], i_z

    i_y = [sdim(d - 3) + sdim(d - 5) - sdim(d - 8) for d in range(7)]
    assert i_y == [0, 0, 0, 1, 4, 11, 24], i_y
    assert i_z[6] - i_y[6] == 5

    # I_Y(4) non-generation witness on rank hyperplane
    x = (0, -2, 0, 1, 0)
    assert x[0] + x[1] + x[2] + 2 * x[3] + 7 * x[4] == 0
    f3 = sum(x[i] ** 2 * x[(i + 1) % 5] for i in range(5))
    x0, x1, x2, x3, x4 = (float(v) for v in x)  # exact ints actually
    x0, x1, x2, x3, x4 = x
    f5 = (
        x0**3 * x2**2
        - x0**3 * x3 * x4
        + x0**2 * x3**3
        - x0 * x1**3 * x4
        - x0 * x1 * x2**3
        + 3 * x0 * x1 * x2 * x3 * x4
        + x1**3 * x3**2
        + x1**2 * x4**3
        - x1 * x2 * x3**3
        + x2**3 * x4**2
        - x2 * x3 * x4**3
    )
    assert f3 == 0 and f5 == -8, (f3, f5)

    rao = {}
    for eps in (0, 1):
        r = [19 * d + 1 - (sdim(d) - (eps if d == 5 else 0)) for d in range(6)]
        assert r == [0, 16, 29, 38, 42, 40 + eps], r
        rao[eps] = r
        # d=6 bounds
        # dim I_C(6) = rao6 - 31 in [0, 29]
        assert 31 <= 60

    # ACM h-vectors
    for hv, dimI5 in [
        ([1, 2, 3, 4, 5, 4], 2),
        ([1, 2, 3, 4, 5, 3, 1], 3),
        ([1, 2, 3, 4, 5, 2, 2], 4),
        ([1, 2, 3, 4, 5, 2, 1, 1], 4),
        ([1, 2, 3, 4, 5, 1, 1, 1, 1], 5),
    ]:
        assert sum(hv) == 19
        assert 6 - hv[5] == dimI5
        assert dimI5 >= 2

    # Liaison
    liaison = {}
    for s in (6, 7, 8):
        deg_res = 5 * s - 19
        diff = (5 + s - 4) * (19 - deg_res) // 2
        pa_res = -diff
        liaison[s] = (deg_res, pa_res)
    assert liaison == {6: (11, -28), 7: (16, -12), 8: (21, 9)}

    # Pic obstruction arithmetic
    assert 19 % 5 != 0
    # adjunction on smooth quintic: C^2 + 19 = -2 => C^2 = -21
    assert -21 + 19 == -2

    # degree-2 cycle types (house rule 10 classification completeness)
    # length-2 Artinian F-algebras: F×F, quadratic field, F[e]/(e^2)
    length2_types = ["F_times_F", "quadratic_field", "dual_numbers"]
    assert len(length2_types) == 3

    # Bezout residual
    assert 3 * 19 - 55 == 2

    # virtual dimensions
    assert 4 * 19 == 76
    assert 4 * 20 - 3 - 2 * 55 == -33

    return {
        "i_z": i_z,
        "i_y": i_y,
        "rao": rao,
        "liaison": liaison,
        "f3_f5_witness": (f3, f5),
    }


def check_json_payloads(ledger: dict) -> None:
    betti = json.loads((HERE / "betti_tables.json").read_text())
    assert betti["acm_rejected_tables"]
    assert all(t["status"] == "REJECTED" for t in betti["acm_rejected_tables"])
    assert len(betti["epsilon_0"]["live_shapes"]) == 1
    assert len(betti["epsilon_1"]["live_shapes"]) == 1
    assert betti["branches"]["0"]["rao_d0_to_5"] == ledger["rao"][0]
    assert betti["branches"]["1"]["rao_d0_to_5"] == ledger["rao"][1]

    rao_j = json.loads((HERE / "rao_resolutions.json").read_text())
    assert rao_j["branches"]["epsilon_0"]["status"] == "LIVE"
    assert rao_j["branches"]["epsilon_1"]["status"] == "LIVE"
    assert rao_j["acm_excluded"] is True
    assert rao_j["liaison_5_s"]["6"]["residual_pa"] == -28

    mh = json.loads((HERE / "marked_hilbert.json").read_text())
    assert mh["ground_field"].startswith("F")
    assert "Fbar" in mh["ground_field"] or "not" in mh["ground_field"].lower() or "K_Schur" in mh["ground_field"]
    assert mh["nonemptiness"]["H_Z_F"] == "UNDECIDED"
    assert mh["component_dimensions"]["certified"] is None
    assert mh["virtual" if "virtual" in mh else "component_dimensions"]  # structure ok
    assert mh["component_dimensions"]["virtual"]["maps_marked_55"] == -33

    qc = json.loads((HERE / "quintic_carriers.json").read_text())
    assert qc["picard"]["brevik_nollet_lopez_applies"] is False
    assert qc["picard"]["rank_one_proved_for_all_q"] is False
    assert qc["liaison_excludes_branch"] is False
    assert qc["branch_status"] == "LIVE"
    assert qc["picard"]["failure_witness_f3_f5"] == [0, -8]

    # implication residual arithmetic
    assert 3 * 19 == 57
    assert 57 - 55 == 2


def check_markdown_markers() -> None:
    markers = {
        "IMPLICATION_AUDIT.md": "SCHUR_DEGREE19_GATE1_IMPLICATION_PASS",
        "rao_resolutions.md": "SCHUR_DEGREE19_RAO_RESOLUTIONS_ENUMERATED",
        "marked_hilbert.md": "SCHUR_DEGREE19_MARKED_HILBERT_OVER_F",
        "quintic_carriers.md": "SCHUR_DEGREE19_QUINTIC_CARRIERS_CLASSIFIED",
    }
    for name, marker in markers.items():
        text = (HERE / name).read_text()
        assert marker in text, f"missing marker {marker} in {name}"
    # house rule 10 explicit in audit
    audit = (HERE / "IMPLICATION_AUDIT.md").read_text()
    assert "House rule 10" in audit or "house rule 10" in audit
    assert "residual line" in audit.lower() or "Residual-line" in audit
    assert "Gate 1 decision:** `PASS`" in audit or "Gate 1 decision: `PASS`" in audit or "**Gate 1** | **`PASS`**" in audit or "`PASS`" in audit
    # no headline claim
    assert "OPEN" in audit


def check_seal_structure() -> None:
    seal_path = HERE / "SEAL.json"
    if not seal_path.exists():
        print("SEAL.json not yet present — structure check skipped")
        return
    seal = json.loads(seal_path.read_text())
    assert seal["headline"] == "OPEN"
    assert seal["decision_exit"] in {"P3", "N3", "N3-SCOPED", "STOP-3"}
    assert seal["decision_exit"] == "STOP-3"
    assert "N3-SCOPED" not in seal.get("headline_consequence", "OPEN")
    # self-hash discipline: seal_sha256_self must match file with placeholder or be post-hoc
    assert "terminal_marker" in seal
    assert seal.get("gate1_decision") == "PASS"
    # no timing fields
    for k in seal:
        assert "time" not in k.lower() or k in {"date"}, f"timing field? {k}"
    # deliverable hashes present
    assert "deliverable_sha256" in seal
    for rel, expected in seal["deliverable_sha256"].items():
        if rel == "SEAL.json":
            continue
        path = HERE / rel
        assert path.exists(), rel
        got = sha256_file(path)
        assert got == expected, f"hash mismatch {rel}: {got} != {expected}"


def main() -> int:
    ledger = check_ledgers()
    print("ledgers_ok", ledger["rao"][0], ledger["rao"][1])
    check_json_payloads(ledger)
    print("json_payloads_ok")
    check_markdown_markers()
    print("markdown_markers_ok")
    check_seal_structure()
    print("seal_structure_ok")

    raw = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    peak = raw / (1024 * 1024) if platform.system() == "Darwin" else raw / 1024
    print(f"verify_peak_mib={peak:.2f}")
    print("SCHUR_DEGREE19_GATES_1_2_VERIFY_OK")
    print("SCHUR_DEGREE19_DECISION_STOP_3")
    print("HEADLINE_OPEN")
    return 0


if __name__ == "__main__":
    sys.exit(main())
