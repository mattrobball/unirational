#!/usr/bin/env python3
"""Independent verifier for WP-L2 relative obstruction tower.

Does NOT import produce.py.  Rebuilds free-module L_1 ranks and checks
sealed JSON invariants.
"""

from __future__ import annotations

import json
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parents[1]
ROOT = CERT.parent
sys.path.insert(0, str(HERE))

import common_tower as ct  # noqa: E402


def load(path: Path) -> dict:
    return json.loads(path.read_text())


def check_self_hash(path: Path) -> None:
    data = load(path)
    assert "self_sha256" in data
    body = dict(data)
    h = body.pop("self_sha256")
    text = ct.canonical_json(body)
    assert ct.sha256_bytes(text.encode()) == h, path


def main() -> None:
    print("WP-L2 independent verify")

    # B isomorphism
    iso = ct.certify_B_isomorphism()
    assert iso["isomorphism"] and iso["det_phi"] == "2"
    print("PASS B: E_+ → Sym² E_-^* isomorphism (det=2)")

    # Free ranks
    assert ct.free_rank_leading(1) == 4
    assert ct.free_rank_L_domain(1, 1) == 9
    assert ct.free_rank_L_codomain(1, 1) == 5
    assert ct.free_rank_L_domain(1, 3) == 15
    assert ct.free_rank_L_codomain(1, 3) == 7
    print("PASS free ranks m=1")

    # Exact generic rank rebuild
    g1 = ct.generic_rank_report(1, 1, n_samples=3)
    assert g1["rank_constant_on_samples"]
    assert g1["generic_rank_Q"] == 5  # expected full row rank
    assert g1["generic_nullity_Q"] == 4
    g3 = ct.generic_rank_report(1, 3, n_samples=3)
    assert g3["generic_rank_Q"] == 7
    print("PASS generic ranks L1=5/9, L3=7/15 at m=1")

    # Symbolic matrix nnz positive
    sym = ct.L_matrix_symbolic_quadratic(1, 1)
    assert sym["shape"] == [5, 9]
    assert sym["nnz_quadratic_terms"] > 0
    print("PASS symbolic L1 shape and sparsity")

    # omega1 structure
    a = ct.sample_leading(1, seed=2)
    M = ct.L_matrix_sparse(1, 1, a)
    assert M["cokernel_dim_over_Q"] == 0  # surjective at generic
    print("PASS L1 surjective at sample (coker 0 ⇒ omega1 trivial)")

    # omega3 sample runs without error
    o = ct.omega3_vanishes_sample(1, seed=1)
    assert "omega3_in_image" in o
    print("PASS omega3 sample fiber computed")

    # Sealed artifacts
    summary = HERE / "SUMMARY.json"
    free = HERE / "free_module_stages.json"
    assert summary.exists() and free.exists()
    check_self_hash(summary)
    check_self_hash(free)
    print("PASS self-hashes SUMMARY + free_module_stages")

    s = load(summary)
    assert s["headline"] == "OPEN"
    assert s["decision_exit"] in ("L-P", "L-N", "L-F")
    assert s["decision_exit"] == "L-P"
    assert "timing" not in json.dumps(s).lower() or "timing_fields" not in s
    # no timing fields key
    assert "wall_time" not in s and "timing" not in s
    print("PASS headline OPEN, exit L-P, no timing fields")

    for fam in ct.FAMILIES:
        p = HERE / fam / "tower_stages.json"
        assert p.exists(), fam
        check_self_hash(p)
        d = load(p)
        assert d["headline"] == "OPEN"
        assert d["verdict"]["family_empty_at_finite_stage"] is False
        assert d["verdict"]["exit_contribution"] == "L-P"
        # every bidegree labelled
        for bd in d["bidegree_runs"]:
            assert bd["label"] == "regression_bidegree"
            assert "justification" in bd
        print(f"PASS family {fam}")

    # C3 decomposition dims sum
    d = ct.c3_decompose_domain(1, 1)
    assert sum(int(v) for v in d["dims"].values()) == 9
    print("PASS C3 domain dims sum to free rank")

    # polar_expansion still present as accepted input
    pe = CERT / "lifting" / "polar_expansion.json"
    assert pe.exists()
    print("PASS polar_expansion.json present")

    print("WP_L2_TOWER_SEALED")


if __name__ == "__main__":
    main()
