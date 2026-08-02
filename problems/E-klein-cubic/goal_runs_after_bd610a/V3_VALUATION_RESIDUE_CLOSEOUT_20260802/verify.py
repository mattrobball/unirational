#!/usr/bin/env python3
"""Independent verifier for the V3 valuation/residue close-out packet."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git_blob_sha1(path: Path) -> str:
    data = path.read_bytes()
    header = f"blob {len(data)}\0".encode()
    return hashlib.sha1(header + data).hexdigest()


def problem_root() -> Path:
    for candidate in HERE.parents:
        if (candidate / "SPEC.md").is_file() and (candidate / "certificates").is_dir():
            return candidate
    raise AssertionError("Problem E root not found; use --packet-only outside a checkout")


def verify_source_bindings(root: Path, audit: dict[str, object]) -> None:
    source_blobs = audit["source_git_blobs"]
    assert isinstance(source_blobs, dict)
    for relative, expected in source_blobs.items():
        path = root / relative
        assert path.is_file(), path
        actual = git_blob_sha1(path)
        assert actual == expected, (relative, expected, actual)

    old_payload = json.loads(
        (root / "goals_2026-08-01/V_VALUATION_TROPICAL/proof_payload.json").read_text()
    )
    assert old_payload["status"] == "V-UNDECIDED"
    assert old_payload["local_index"]["bezout_value"] == 1
    assert old_payload["all_rank_inertia_tropical"]["ramified_conclusion"] == (
        "every valuation with nontrivial torsor inertia is locally soluble"
    )
    assert old_payload["all_rank_inertia_tropical"]["unramified_conclusion"] == (
        "the local point problem is exactly the residue twist point problem"
    )
    assert old_payload["next_bounded_frontier"]["degree"] == 16
    assert old_payload["next_bounded_frontier"]["block_dimensions"] == [7, 5, 2, 2, 3]
    assert old_payload["next_bounded_frontier"]["equation_rank"] == 151

    low_rank = (
        root
        / "goals_2026-08-01/G_ALL_DEGREE/attacks/low_rank_valuations_v2/THEOREM.md"
    ).read_text()
    foundations = (
        root
        / "goals_2026-08-01/G_ALL_DEGREE/attacks/low_rank_valuations_v2/VALUATION_FOUNDATIONS.md"
    ).read_text()
    a5 = (
        root
        / "goals_2026-08-01/Q_SCHUR_A5_VALUATION_ELIMINATION_CODEX_ROOT_20260801_EA52/THEOREM.md"
    ).read_text()
    v2 = (root / "goal_runs_after_35fa/V_GENUINE_VALUATION/STATUS.md").read_text()
    h5 = (root / "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/STATUS.md").read_text()
    assert "C1-residue local-solubility theorem" in low_rank
    assert "D is G, one of the two maximal A5 classes, or maximal 11:5" in low_rank
    assert "Trivial inertia and the finite-etale model" in foundations
    assert "survivor list" in a5 and "{G, 11:5}" in a5
    assert "For every extension field `L/C` and every torsor" in a5
    assert v2.startswith("V2-FIXED-FRAME-PLACE-NONTRANSFERABLE")
    assert h5.startswith("H5-UNDECIDED")


def verify_rank_normal_form(audit: dict[str, object]) -> None:
    normal = audit["normal_form"]
    assert normal["negative_residue_transcendence_degree_lower_bound"] == 2
    assert normal["negative_rational_rank_upper_bound"] == 2
    assert normal["negative_krull_rank_upper_bound"] == 2
    assert normal["surviving_decomposition_groups"] == ["PSL(2,11)", "11:5"]

    # Integer shadow of Abhyankar's inequality q+d <= 4.  Once d>=2,
    # rational rank q is at most two.  If Krull rank is two, q>=2; together
    # with d>=2 this forces (q,d)=(2,2).
    admissible = [(q, d) for q in range(5) for d in range(5) if q + d <= 4]
    negative = [(q, d) for q, d in admissible if d >= 2]
    assert all(q <= 2 for q, _ in negative)
    rank_two = [(q, d) for q, d in negative if q >= 2]
    assert rank_two == [(2, 2)]


def verify_packet_text(audit: dict[str, object]) -> None:
    status = (HERE / "STATUS.md").read_text()
    theorem = (HERE / "RESIDUE_NORMAL_FORM_THEOREM.md").read_text()
    finite = (HERE / "F5_DEGREE16_SMALL_SUPPORT.md").read_text()
    assert status.startswith("V-UNDECIDED\n")
    assert "V3-RESIDUE-NORMAL-FORM-PASS" in status
    assert "V-F5-DEGREE16-SUPPORT-LE5-EMPTY" in status
    assert "Problem E remains" in status and "OPEN" in status
    assert "Krull_rank(v)=2" in theorem
    assert "D_v is conjugate to G or to the maximal 11:5 subgroup" in theorem
    assert "V-UNDECIDED" in theorem
    assert "does **not** prove" in finite
    assert audit["headline_claim_made"] is False
    assert audit["problem_e_headline"] == "OPEN"
    assert audit["strict_nonclaims"][-1] == "Problem E remains open"


def replay_finite_certificate() -> None:
    completed = subprocess.run(
        [sys.executable, str(HERE / "reproduce_f5_degree16_support.py")],
        cwd=HERE,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    assert "V_F5_DEGREE16_SMALL_SUPPORT_QUICK_OK" in completed.stdout, completed.stdout
    print(completed.stdout, end="")


def verify_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    files = {
        str(path.relative_to(HERE)): sha256(path)
        for path in sorted(HERE.rglob("*"))
        if path.is_file() and path.name != "SEAL.json" and "__pycache__" not in path.parts
    }
    assert seal["schema"] == "klein-v3-valuation-residue-seal-v1"
    assert seal["goal_exit"] == "V-UNDECIDED"
    assert seal["scoped_exit"] == "V3-RESIDUE-NORMAL-FORM-PASS"
    assert seal["finite_exit"] == "V-F5-DEGREE16-SUPPORT-LE5-EMPTY"
    assert seal["problem_e_headline"] == "OPEN"
    assert seal["files_sha256"] == files


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--packet-only",
        action="store_true",
        help="skip live source-blob bindings when running outside the repository checkout",
    )
    args = parser.parse_args()

    audit = json.loads((HERE / "audit_payload.json").read_text())
    assert audit["schema"] == "klein-v3-valuation-residue-closeout-v1"
    assert audit["goal_exit"] == "V-UNDECIDED"
    assert audit["scoped_exit"] == "V3-RESIDUE-NORMAL-FORM-PASS"
    if not args.packet_only:
        verify_source_bindings(problem_root(), audit)
    verify_rank_normal_form(audit)
    verify_packet_text(audit)
    replay_finite_certificate()
    verify_seal()
    print("PASS source-bound valuation and A5 inputs" if not args.packet_only else "PASS packet-only source-binding bypass")
    print("PASS Abhyankar rank/residue normal form")
    print("PASS exact f5 degree-16 support<=5 certificate")
    print("PASS recursive packet seal and strict nonclaim boundary")
    print("V3_VALUATION_RESIDUE_CLOSEOUT_OK")


if __name__ == "__main__":
    main()
