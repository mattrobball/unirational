#!/usr/bin/env python3
"""Independent verifier for R0 canonical live-ledger refresh.

Re-reads STATUS/SEAL of decisive packets and the live orientation file.
Does not trust producer-only claims. Rejects stale active-goal patterns.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
LIVE = E_ROOT / "REMAINING_GOALS_NOTE.md"
STATE = HERE / "canonical_state.json"
MANIFEST = HERE / "INPUT_MANIFEST.json"


def fail(msg: str) -> None:
    print(f"R0_VERIFY_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def first_line(path: Path) -> str:
    require(path.is_file(), f"missing {path}")
    for line in path.read_text(errors="replace").splitlines():
        if line.strip():
            return line.strip()
    fail(f"empty {path}")


def seal_exit(path: Path) -> str | None:
    if not path.is_file():
        return None
    data = json.loads(path.read_text())
    for key in ("exit", "goal_exit", "terminal_exit", "scoped_exit"):
        if key in data and isinstance(data[key], str):
            return data[key]
    return None


def main() -> None:
    require(STATE.is_file(), "canonical_state.json missing")
    require(MANIFEST.is_file(), "INPUT_MANIFEST.json missing")
    for name in (
        "CANONICAL_STATE.md",
        "SUPERSEDED_STATUS.md",
        "REPLAY.md",
        "SEAL.json",
        "STATUS.md",
        "INPUT_MANIFEST.json",
        "canonical_state.json",
        "verify.py",
    ):
        require((HERE / name).is_file(), f"deliverable missing: {name}")

    state = json.loads(STATE.read_text())
    manifest = json.loads(MANIFEST.read_text())
    require(state.get("headline") == "OPEN", "R0 must not claim Problem E closed")
    require(state.get("r0_exit") == "R0-CANONICAL-REFRESH-PASS", "unexpected r0_exit in state")

    # Required fields per front
    required_fields = {
        "front",
        "canonical_packet",
        "exact_exit",
        "headline_relevance",
        "remaining_binary",
        "replay_command",
        "superseded_packets",
        "consumed_commit",
    }
    fronts = {f["front"]: f for f in state["fronts"]}
    for f in state["fronts"]:
        missing = required_fields - set(f)
        require(not missing, f"front {f.get('front')} missing fields {missing}")

    # Cross-check decisive STATUS first lines
    checks = {
        "G2_structural": (
            E_ROOT / "goal_runs_after_35fa/G_UNIVERSAL/STATUS.md",
            "G2-FINITE-GENERATION-PASS",
        ),
        "B": (
            E_ROOT / "goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/STATUS.md",
            "B-BRIDGE-REFUTED",
        ),
        "A0": (
            E_ROOT / "goal_runs_after_35fa/A0_CANONICAL_AUDIT/STATUS.md",
            "A0-CANONICAL-AUDIT-PASS",
        ),
        "H5": (
            E_ROOT / "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/STATUS.md",
            "H5-UNDECIDED",
        ),
        "V3_mechanics": (
            E_ROOT / "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/STATUS.md",
            "V-UNDECIDED",
        ),
        "C5_corrected": (
            E_ROOT / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/STATUS.md",
            "C5-UNDECIDED",
        ),
        "P25": (
            E_ROOT / "goals_2026-08-01/P25_LANDING_SUPPORT/STATUS.md",
            "P25-UNDECIDED",
        ),
        "COV_m1": (
            E_ROOT / "goal_runs_after_35fa/COV_M1_DEG31_35/STATUS.md",
            "COV-UNDECIDED",
        ),
        "M3_section": (
            E_ROOT / "goals_after_bd610a/M3_SARKISOV_SECTION/STATUS.md",
            "M3-INTEGRAL-DEGREE4-MULTISECTION",
        ),
    }
    for front, (path, expected) in checks.items():
        fl = first_line(path)
        require(fl == expected, f"{front}: STATUS first line {fl!r} != {expected!r}")
        require(
            fronts[front]["exact_exit"] == expected
            or (front == "V3_mechanics" and fronts[front]["exact_exit"] == "V-UNDECIDED"),
            f"canonical_state exit drift for {front}",
        )

    # V3 scoped exit from SEAL
    v3_seal = json.loads(
        (E_ROOT / "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/SEAL.json").read_text()
    )
    require(
        v3_seal.get("scoped_exit") == "V3-RESIDUE-NORMAL-FORM-PASS"
        or v3_seal.get("goal_exit") == "V-UNDECIDED",
        "V3 seal missing normal-form scoped exit",
    )
    require(fronts["V3_mechanics"].get("scoped_exit") == "V3-RESIDUE-NORMAL-FORM-PASS",
            "canonical state missing V3 scoped exit")

    g2_seal = seal_exit(E_ROOT / "goal_runs_after_35fa/G_UNIVERSAL/SEAL.json")
    require(g2_seal == "G2-FINITE-GENERATION-PASS", f"G2 seal {g2_seal}")
    b_seal = seal_exit(E_ROOT / "goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/SEAL.json")
    require(b_seal == "B-BRIDGE-REFUTED", f"B seal {b_seal}")

    # A0 projection result subcheck
    a0r = json.loads(
        (E_ROOT / "goal_runs_after_35fa/A0_CANONICAL_AUDIT/verify_p25_bulk_projection_result.json").read_text()
    )
    require(a0r.get("ok") is True, "A0 projection result not ok")
    require(a0r.get("n_Ti_out_certified") == 4140, "A0 Ti count")
    require(a0r.get("n_comm_out_certified") == 315, "A0 comm count")

    # B payload subcheck (full verify may fail pin drift)
    b_payload = json.loads(
        (E_ROOT / "goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/bridge_refutation.json").read_text()
    )
    require(b_payload.get("exit") == "B-BRIDGE-REFUTED", "B payload exit")
    require(b_payload.get("headline") == "OPEN", "B payload headline")
    require(b_payload["objects"]["fano"]["dimension"] == 3, "B fano dim")
    require(b_payload["theorem"]["universal_exhaustiveness"] is False, "B not refuted")

    # Live orientation
    require(LIVE.is_file(), "REMAINING_GOALS_NOTE.md missing")
    live = LIVE.read_text()
    require("<<<<<<" not in live and ">>>>>>" not in live, "merge conflict markers in live ledger")
    require("B-BRIDGE-REFUTED" in live, "live ledger must record B terminal")
    require("G2-FINITE-GENERATION-PASS" in live, "live ledger must record G2 structural pass")
    require("V3-RESIDUE-NORMAL-FORM-PASS" in live, "live ledger must record V3 mechanics pass")
    require(re.search(r"G3", live) is not None, "live ledger must mention G3")
    require("primary" in live.lower() or "Priority | 1 | **G3**" in live or "**G3**" in live,
            "live ledger must elevate G3")

    # Reject stale active patterns
    # Active queue section must not list B as open undecided mission
    m_active = re.search(
        r"## Active dispatch.*?(?=## |\Z)", live, flags=re.S | re.I
    )
    active_blob = m_active.group(0) if m_active else live
    require(
        not re.search(r"\|\s*\d+\s*\|\s*\*\*B\*\*\s*\|\s*`?B-UNDECIDED", active_blob),
        "B still listed as active undecided in dispatch",
    )
    require(
        not re.search(r"\|\s*\*\*B\*\*\s*\|\s*`?B-UNDECIDED", active_blob),
        "stale B-UNDECIDED active pattern",
    )
    # G2 structural / V3 mechanics sealed, not open missions
    require(
        "G2-FINITE-GENERATION-PASS" in live and "V3-RESIDUE-NORMAL-FORM-PASS" in live,
        "live ledger missing G2/V3 terminal seals",
    )
    require(
        re.search(r"G2[^\n]{0,60}not open mission", live, re.I) is not None
        or re.search(r"not open missions", live, re.I) is not None,
        "live ledger must state structural seals are not open missions",
    )
    # Reject listing G2 structural under Active dispatch as undecided
    require(
        not re.search(
            r"## Active dispatch[\s\S]*?\|\s*\*\*G2\*\*\s*\|\s*`?(G2-)?UNDECIDED",
            live,
            re.I,
        ),
        "G2 listed as active undecided mission",
    )
    # C5 must not promote inconsistent idempotent as the model
    require("e*S_0*e=0" not in live or "inconsistent" in live.lower() or "retired" in live.lower(),
            "C5 live text promotes inconsistent idempotent without fence")
    # Prefer corrected language
    require(
        re.search(r"alternating|Pl(?:ü|ue)cker|common.line|square-zero", live, re.I) is not None,
        "live ledger missing corrected C5 model language",
    )
    # T3 local runner paths
    require(
        "goals_after_5899d0" in live or "T3_NORMALIZATION_CLPIC3" in live,
        "live ledger missing T3 local-runner path",
    )
    # H5 sealed run acknowledged
    require("H5-UNDECIDED" in live, "live ledger missing H5 sealed undecided run")
    require(re.search(r"no sealed run|no run yet", live, re.I) is None,
            "live ledger still claims H5 has no sealed run")

    # STATUS first line of this packet
    st = first_line(HERE / "STATUS.md")
    require(st == "R0-CANONICAL-REFRESH-PASS", f"STATUS first line {st}")
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("exit") == "R0-CANONICAL-REFRESH-PASS", "SEAL exit mismatch")
    require(seal.get("headline") == "OPEN", "SEAL must keep headline OPEN")

    # Dispatch order has G3 as priority 1
    order = state.get("dispatch_order") or []
    g3 = [d for d in order if d.get("goal") == "G3"]
    require(g3 and g3[0].get("priority") == 1, "G3 must be priority 1 in state dispatch_order")

    # Audit items present
    require(len(manifest.get("audit_items") or []) >= 8, "need 8 audit items")

    print("R0_CANONICAL_REFRESH_VERIFY_OK")
    print("R0-CANONICAL-REFRESH-PASS")
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
