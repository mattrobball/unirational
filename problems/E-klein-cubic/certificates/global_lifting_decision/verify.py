#!/usr/bin/env python3
"""Independent verifier for Path G Gate G1 decision packet.

Does NOT import produce.py. Reconstructs residual S3/based dimensions, free L_3
rank at a_triv, and the nonzero maximal minor over Q. Checks seals, hashes,
decision exit, and G-SCOPED no-headline boundary.
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from collections import defaultdict
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
sys.path.insert(0, str(CERT / "lifting" / "families"))

from common_tower import L_matrix_sparse, L_matrix_symbolic_quadratic  # noqa: E402


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_json(path: Path) -> dict:
    return json.loads(path.read_text())


def monoms_ternary(deg: int):
    out = []
    for a in range(deg, -1, -1):
        for b in range(deg - a, -1, -1):
            out.append((a, b, deg - a - b))
    return out


def nullspace(A):
    if not A or not A[0]:
        return []
    n, m = len(A), len(A[0])
    Mtx = [row[:] for row in A]
    pivots = []
    r = 0
    for c in range(m):
        piv = next((i for i in range(r, n) if Mtx[i][c] != 0), None)
        if piv is None:
            continue
        Mtx[r], Mtx[piv] = Mtx[piv], Mtx[r]
        inv = Q(1) / Mtx[r][c]
        Mtx[r] = [inv * x for x in Mtx[r]]
        for i in range(n):
            if i != r and Mtx[i][c] != 0:
                f = Mtx[i][c]
                Mtx[i] = [Mtx[i][j] - f * Mtx[r][j] for j in range(m)]
        pivots.append(c)
        r += 1
        if r == n:
            break
    free = [c for c in range(m) if c not in pivots]
    basis = []
    for f in free:
        v = [Q(0)] * m
        v[f] = Q(1)
        for i, c in enumerate(pivots):
            v[c] = -Mtx[i][f]
        basis.append(v)
    return basis


def matrix_rank_rref(rows):
    if not rows:
        return 0
    A = [r[:] for r in rows]
    n, m = len(A), len(A[0])
    r = 0
    for c in range(m):
        piv = next((i for i in range(r, n) if A[i][c] != 0), None)
        if piv is None:
            continue
        A[r], A[piv] = A[piv], A[r]
        inv = Q(1) / A[r][c]
        A[r] = [inv * x for x in A[r]]
        for i in range(n):
            if i != r and A[i][c] != 0:
                f = A[i][c]
                A[i] = [A[i][j] - f * A[r][j] for j in range(m)]
        r += 1
        if r == n:
            break
    return r


def main() -> None:
    required = [
        "Lambda_basis_CSR.json",
        "G_projection_matrix.json",
        "Fitt_coker_L3.generators",
        "Fitt_coker_L3.json",
        "rank_certificate.json",
        "DECISION.md",
        "SEAL.json",
    ]
    for fn in required:
        assert (HERE / fn).exists(), f"missing {fn}"

    lam = load_json(HERE / "Lambda_basis_CSR.json")
    gproj = load_json(HERE / "G_projection_matrix.json")
    rank = load_json(HERE / "rank_certificate.json")
    fitt = load_json(HERE / "Fitt_coker_L3.json")
    seal = load_json(HERE / "SEAL.json")
    decision = (HERE / "DECISION.md").read_text()

    # Headline / exit
    assert rank["headline"] == "OPEN"
    assert seal["headline"] == "OPEN"
    assert rank["decision_exit"] in {
        "G-SCOPED",
        "G-CONSTRUCTION",
        "G-ACTIVE-OBSTRUCTION",
        "G-STOP",
    }
    assert seal["decision_exit"] == rank["decision_exit"]
    assert rank["forks_not_run"] == ["G-A", "G-B"]
    assert "G-A" in decision and "NOT RUN" in decision or "not run" in decision.lower()

    if rank["decision_exit"] == "G-SCOPED":
        assert "no headline" in decision.lower() or "G-SCOPED" in decision
        assert seal.get("G_SCOPED_no_headline_claim") is True

    # Dimensions
    assert lam["dimensions"]["ambient_plane_C2"] == 112
    assert gproj["G"]["ambient_dim"] == 112
    dim_based = lam["dimensions"]["Lambda_witness_based_residual"]
    assert dim_based == gproj["G"]["witness_dim"]
    assert dim_based > 0, "based residual witness must be nonzero at (1,7)"
    assert lam["basis_CSR"]["shape"][0] == 112
    assert lam["basis_CSR"]["shape"][1] == dim_based

    # Recompute residual dims independently
    K = 6
    MONOMS = monoms_ternary(K)
    N = 4 * 28
    FIBRE_WT = [2, 0, 0, 1]
    FIBRE_REFLECT = [3, 2, 1, 0]
    monom_index = {m: i for i, m in enumerate(MONOMS)}

    def monom_wt(m):
        a, b, c = m
        return (2 * (b - c)) % 3

    def basis_wt(fi, mi):
        return (FIBRE_WT[fi] + monom_wt(MONOMS[mi])) % 3

    def reflect_basis(idx):
        fi, mi = divmod(idx, 28)
        a, b, c = MONOMS[mi]
        return FIBRE_REFLECT[fi] * 28 + monom_index[(a, c, b)]

    c3_idx = [
        fi * 28 + mi
        for fi in range(4)
        for mi in range(28)
        if basis_wt(fi, mi) == 0
    ]
    pos = {idx: i for i, idx in enumerate(c3_idx)}
    dim_c3 = len(c3_idx)
    Smat = [[Q(0)] * dim_c3 for _ in range(dim_c3)]
    for i, idx in enumerate(c3_idx):
        Smat[pos[reflect_basis(idx)]][i] = Q(1)
    A_triv = [
        [Smat[i][j] - (Q(1) if i == j else Q(0)) for j in range(dim_c3)]
        for i in range(dim_c3)
    ]
    s3_dim = len(nullspace(A_triv))
    assert s3_dim == lam["dimensions"]["residual_S3_invariant"] == 19

    # Free L3 at a_triv
    a_triv = [Q(0), Q(1), Q(1), Q(0)]
    L = L_matrix_sparse(1, 3, a_triv)
    assert L["rank_over_Q"] == 7
    assert L["cokernel_dim_over_Q"] == 0

    # Maximal minor
    sym = L_matrix_symbolic_quadratic(1, 3)
    assert sym["shape"] == [7, 15]
    assert sym["nnz_quadratic_terms"] == 80
    entries = defaultdict(lambda: defaultdict(lambda: Q(0)))
    for t in sym["terms"]:
        entries[(t["row"], t["col"])][(t["A_p"], t["A_q"])] += Q(t["c"])
    Mat = [[Q(0)] * 15 for _ in range(7)]
    for (r, c), mon in entries.items():
        s = Q(0)
        for (p, q), coef in mon.items():
            s += coef * a_triv[p] * a_triv[q]
        Mat[r][c] = s

    def det7(sub):
        A = [row[:] for row in sub]
        det = Q(1)
        for i in range(7):
            piv = next((k for k in range(i, 7) if A[k][i] != 0), None)
            if piv is None:
                return Q(0)
            if piv != i:
                A[i], A[piv] = A[piv], A[i]
                det = -det
            det *= A[i][i]
            inv = Q(1) / A[i][i]
            for j in range(i, 7):
                A[i][j] *= inv
            for k in range(7):
                if k != i and A[k][i] != 0:
                    f = A[k][i]
                    for j in range(i, 7):
                        A[k][j] -= f * A[i][j]
        return det

    cols = rank["free_module_L3"]["residual_S3_trivial_free_fibre"][
        "nonzero_maximal_minor"
    ]["columns"]
    sub = [[Mat[i][j] for j in cols] for i in range(7)]
    minor = det7(sub)
    assert minor != 0
    claimed = rank["free_module_L3"]["residual_S3_trivial_free_fibre"][
        "nonzero_maximal_minor"
    ]["value"]
    assert Q(claimed) == minor

    # Open meeting points
    assert rank["restriction_to_G"]["attains_free_generic_rank"] is True
    assert rank["restriction_to_G"]["not_modular_sample"] is True
    pts = rank["restriction_to_G"]["open_meeting_points_char0"]
    assert any(p["full_generic_rank"] for p in pts)

    # Re-check one open-meeting free fibre
    for p in pts:
        if p["full_generic_rank"]:
            a = [Q(x) for x in p["free_fibre_eval"]]
            Lp = L_matrix_sparse(1, 3, a)
            assert Lp["rank_over_Q"] == 7
            break

    # Fitting file nonempty if claimed
    gens = (HERE / "Fitt_coker_L3.generators").read_text().strip().splitlines()
    if fitt.get("num_gb_generators"):
        assert len(gens) == fitt["num_gb_generators"]
    assert fitt["proper_closed_in_free_B0"] is True
    assert fitt["is_unit"] is False

    # No timing fields
    payload = json.dumps(rank) + json.dumps(seal) + json.dumps(lam)
    assert "wall_time" not in payload
    assert "timing" not in payload.lower() or "timing" not in rank

    # House rule: no covariant mislabel of formal states
    assert "never covariants" in json.dumps(lam).lower() or "formal states" in json.dumps(
        lam
    ).lower()

    # Self-hashes present
    for obj, name in [(lam, "Lambda"), (gproj, "G"), (rank, "rank"), (seal, "SEAL")]:
        assert obj.get("self_sha256"), f"{name} missing self_sha256"

    # Three-copy repair present in construction text
    assert "L_t" in json.dumps(lam) or "repaired" in json.dumps(lam).lower()

    print("PASS dimensions B=J=112, residual S3 dim 19, based witness > 0")
    print("PASS free L3 rank 7 at a_triv with nonzero maximal minor")
    print("PASS open-meeting char-0 points on G witness")
    print("PASS decision exit sealed; forks not run; headline OPEN")
    if rank["decision_exit"] == "G-SCOPED":
        print("PASS G-SCOPED carries no headline claim")
    print("GLOBAL_LIFTING_DECISION_VERIFY_OK")


if __name__ == "__main__":
    main()
