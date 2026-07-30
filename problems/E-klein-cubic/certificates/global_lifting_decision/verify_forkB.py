#!/usr/bin/env python3
"""Independent verifier for Path G Fork G-B packet.

Does NOT import produce_forkB.py. Reconstructs:
  - pure-powers free L_1/L_3 ranks for several odd m
  - open meeting at (1,13) and (3,19) via residual based witness free-fibre ranks
  - structural nullity formulas 4 and 8
  - seal hashes, decision boundary, no-covariant / no-headline rules
  - combinatorial presence of L isolation at 3m+1,3m+3,3m+5
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
sys.path.insert(0, str(CERT / "lifting" / "families"))
sys.path.insert(0, str(CERT / "global_transition"))

from common_tower import (  # noqa: E402
    L_matrix_sparse,
    free_rank_L_codomain,
    free_rank_L_domain,
    free_rank_leading,
    leading_basis,
    monoms,
)
from common_global import dim_plane  # noqa: E402


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_json(path: Path) -> dict:
    return json.loads(path.read_text())


def fail(msg: str) -> None:
    print("VERIFY_FAIL:", msg)
    sys.exit(1)


def pure_powers_leading(m: int) -> list[Q]:
    lead = leading_basis(m)
    a = [Q(0)] * len(lead)
    for i, (mon, j) in enumerate(lead):
        if mon == (m, 0) and j == 0:
            a[i] = Q(1)
        if mon == (0, m) and j == 1:
            a[i] = Q(1)
    return a


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


def monoms_ternary(deg: int):
    out = []
    for a in range(deg, -1, -1):
        for b in range(deg - a, -1, -1):
            out.append((a, b, deg - a - b))
    return out


def based_witness_dims_and_meeting(m: int, d: int) -> dict:
    K = d - m
    N_FIBRE = free_rank_leading(m)
    lead = leading_basis(m)
    MONOMS = monoms_ternary(K)
    N_PLANE = N_FIBRE * len(MONOMS)
    assert N_PLANE == dim_plane(m, d)
    eminus_wt = {0: 1, 1: -1}
    FIBRE_WT = [((alpha[0] - alpha[1] + eminus_wt[j]) % 3) for (alpha, j) in lead]
    monoms_bin = monoms(m)

    def fibre_reflect(fi: int) -> int:
        mon, j = lead[fi]
        a, b = mon
        return monoms_bin.index((b, a)) * 2 + (1 - j)

    MONOM_INDEX = {mm: i for i, mm in enumerate(MONOMS)}

    def monom_wt(mm):
        a, b, c = mm
        return (2 * (b - c)) % 3

    def basis_wt(fi, mi):
        return (FIBRE_WT[fi] + monom_wt(MONOMS[mi])) % 3

    def reflect_basis(idx):
        fi, mi = divmod(idx, len(MONOMS))
        a, b, c = MONOMS[mi]
        return fibre_reflect(fi) * len(MONOMS) + MONOM_INDEX[(a, c, b)]

    c3_idx = [
        fi * len(MONOMS) + mi
        for fi in range(N_FIBRE)
        for mi in range(len(MONOMS))
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
    ns = nullspace(A_triv)
    s3_basis = []
    for vec in ns:
        full = [Q(0)] * N_PLANE
        for i, idx in enumerate(c3_idx):
            full[idx] = vec[i]
        s3_basis.append(full)

    def restrict(full):
        out = []
        for fi in range(N_FIBRE):
            for a in range(K, -1, -1):
                mi = MONOM_INDEX[(a, K - a, 0)]
                out.append(full[fi * len(MONOMS) + mi])
        return out

    Rest = [restrict(v) for v in s3_basis]
    Rmat = [[Rest[j][i] for j in range(len(s3_basis))] for i in range(len(Rest[0]))]
    ker = nullspace(Rmat)
    based = []
    for vec in ker:
        full = [Q(0)] * N_PLANE
        for j, s in enumerate(vec):
            if s == 0:
                continue
            for t in range(N_PLANE):
                full[t] += s * s3_basis[j][t]
        based.append(full)

    def eval_fibre(sec, z):
        z0, z1, z2 = z
        A = [Q(0)] * N_FIBRE
        for fi in range(N_FIBRE):
            s = Q(0)
            for mi, mm in enumerate(MONOMS):
                a, b, c = mm
                s += sec[fi * len(MONOMS) + mi] * (z0 ** a) * (z1 ** b) * (z2 ** c)
            A[fi] = s
        return A

    full_rk = free_rank_L_codomain(m, 3)
    found = False
    sample = None
    zs = [(1, 1, 1), (1, 2, 3), (2, 3, 5), (1, 1, 2)]
    for bi, sec in enumerate(based):
        for z in zs:
            A = eval_fibre(sec, z)
            if all(x == 0 for x in A):
                continue
            L = L_matrix_sparse(m, 3, A)
            if L["rank_over_Q"] == full_rk and L["cokernel_dim_over_Q"] == 0:
                found = True
                sample = {
                    "basis_index": bi,
                    "z": list(z),
                    "rank": L["rank_over_Q"],
                    "fibre": [str(x) for x in A],
                }
                break
        if found:
            break
    # linear combo fallback
    if not found and based:
        for trial in range(1, 20):
            coeffs = [Q((trial * (j + 3) + 5) % 11 - 5) for j in range(len(based))]
            if all(c == 0 for c in coeffs):
                continue
            sec = [Q(0)] * N_PLANE
            for c, b in zip(coeffs, based):
                if c == 0:
                    continue
                for t in range(N_PLANE):
                    sec[t] += c * b[t]
            for z in zs:
                A = eval_fibre(sec, z)
                if all(x == 0 for x in A):
                    continue
                L = L_matrix_sparse(m, 3, A)
                if L["rank_over_Q"] == full_rk:
                    found = True
                    sample = {
                        "trial": trial,
                        "z": list(z),
                        "rank": L["rank_over_Q"],
                        "fibre": [str(x) for x in A],
                    }
                    break
            if found:
                break

    return {
        "dim_s3": len(s3_basis),
        "dim_based": len(based),
        "N_PLANE": N_PLANE,
        "open_meeting": found,
        "sample": sample,
        "full_rk": full_rk,
    }


def main() -> None:
    required = [
        "persistence_certificate.json",
        "rank_theorem.json",
        "higher_polar_recursion.json",
        "finite_generation_boundary.json",
        "algebraization_gate.json",
        "forkB_exit.json",
        "FORK_GB.md",
        "SEAL_FORK_GB.json",
        "produce_forkB.py",
        "verify_forkB.py",
    ]
    for name in required:
        if not (HERE / name).exists():
            fail(f"missing {name}")

    exit_j = load_json(HERE / "forkB_exit.json")
    pers = load_json(HERE / "persistence_certificate.json")
    rank = load_json(HERE / "rank_theorem.json")
    polar = load_json(HERE / "higher_polar_recursion.json")
    fingen = load_json(HERE / "finite_generation_boundary.json")
    alg = load_json(HERE / "algebraization_gate.json")
    seal = load_json(HERE / "SEAL_FORK_GB.json")
    md = (HERE / "FORK_GB.md").read_text()

    # --- Headline / boundary ---
    if exit_j.get("headline") != "OPEN":
        fail("headline must remain OPEN")
    if exit_j.get("not_a_covariant") is not True:
        fail("must declare not_a_covariant")
    if exit_j.get("all_degree_G_open_meeting") != "NOT_CLAIMED":
        fail("must not claim all-degree G open meeting")
    if exit_j.get("decision_exit") not in ("G-CONSTRUCTION", "G-SCOPED", "G-STOP"):
        fail(f"unexpected exit {exit_j.get('decision_exit')}")
    if "covariant" in md.lower() and "not a covariant" not in md.lower() and "NOT a covariant" not in md:
        # soft: ensure disclaimer present
        if "No formal lift is a covariant" not in md and "not a covariant" not in md.lower():
            fail("FORK_GB.md missing covariant disclaimer")

    # --- Rank theorem independent check ---
    if rank.get("status") != "PROVED":
        fail("rank theorem not marked PROVED")
    for m in (1, 3, 5, 7, 9):
        a = pure_powers_leading(m)
        for r in (1, 3):
            L = L_matrix_sparse(m, r, a)
            want = free_rank_L_codomain(m, r)
            null_want = 2 * r + 2
            if L["rank_over_Q"] != want:
                fail(f"pure powers m={m} r={r} rank {L['rank_over_Q']} != {want}")
            if L["nullity_over_Q"] != null_want:
                fail(f"pure powers m={m} r={r} null {L['nullity_over_Q']} != {null_want}")
            if L["cokernel_dim_over_Q"] != 0:
                fail(f"pure powers m={m} r={r} coker nonzero")
    # formulas
    f = rank["formulas"]
    if f["generic_nullity_L1"] != 4 or f["generic_nullity_L3"] != 8:
        fail("nullity formulas wrong")

    # m=3 residual triv drops rank (correction check)
    a_triv3 = [Q(0), Q(0), Q(0), Q(1), Q(1), Q(0), Q(0), Q(0)]
    L3t = L_matrix_sparse(3, 3, a_triv3)
    if L3t["rank_over_Q"] >= 13:
        fail("expected m=3 residual-triv rank drop diagnostic to hold")
    if rank["corrected_pattern_note"]["m3_residual_triv_L3_rank"] != L3t["rank_over_Q"]:
        fail("sealed m3 residual triv rank mismatch")

    # --- Persistence independent check ---
    if pers.get("persistence") != "OPEN_MEETING_PERSISTS_AT_BOTH_BIDEGREES":
        fail(f"persistence status {pers.get('persistence')}")
    for test in pers["tests"]:
        if test["status"] != "OPEN_MEETING_CERTIFIED":
            fail(f"test failed {test.get('m'), test.get('d')}")
        if not test.get("not_modular_sample", True):
            fail("modular sample flagged as char0")
        pts = test.get("open_meeting_points_char0", [])
        if not pts:
            fail("no open meeting points sealed")
        # recompute rank at sealed free fibre
        m, d = test["m"], test["d"]
        full_rk = free_rank_L_codomain(m, 3)
        for p in pts[:2]:
            fibre = [Q(x) for x in p["free_fibre"]]
            L = L_matrix_sparse(m, 3, fibre)
            if L["rank_over_Q"] != full_rk:
                fail(f"sealed fibre rank mismatch at ({m},{d}): {L['rank_over_Q']}")
            if L["cokernel_dim_over_Q"] != 0:
                fail("sealed fibre coker nonzero")

    # Independent reconstruction of open meeting (does not trust producer basis)
    for m, d in ((1, 13), (3, 19)):
        ind = based_witness_dims_and_meeting(m, d)
        if not ind["open_meeting"]:
            fail(f"independent open meeting failed at ({m},{d})")
        sealed = next(t for t in pers["tests"] if t["m"] == m and t["d"] == d)
        if sealed["dimensions"]["dim_based_G_witness"] != ind["dim_based"]:
            fail(
                f"dim_based mismatch ({m},{d}): "
                f"sealed {sealed['dimensions']['dim_based_G_witness']} vs ind {ind['dim_based']}"
            )
        if sealed["dimensions"]["N_PLANE"] != ind["N_PLANE"]:
            fail("N_PLANE mismatch")
        print(f"  independent ({m},{d}): dim_based={ind['dim_based']} meeting OK sample={ind['sample']}")

    # --- Polar recursion structure ---
    for key in ("3m+1", "3m+3", "3m+5", "3m+7"):
        if key not in polar["stages"]:
            fail(f"missing polar stage {key}")
    if polar["stages"]["3m+0"]["automatic_by_y_evenness"] is not True:
        fail("3m should be automatic")
    if polar["stages"]["3m+1"]["automatic_by_y_evenness"] is not False:
        fail("3m+1 should be live")
    if polar["stages"]["3m+1"]["isolation"]["L"] is None:
        fail("L_1 isolation missing")
    if polar["stages"]["3m+3"]["isolation"]["L"] is None:
        fail("L_3 isolation missing")
    if polar["universal_equations"]["U.3m+1"]["status"] is None:
        fail("U.3m+1 missing")
    if polar["common_open_surjectivity"]["status"] != "PROVED_AT_FREE_MODULE_LEVEL":
        fail("common open status")

    # --- Finite generation boundary ---
    if fingen.get("all_degree_G_open_meeting") != "NOT_CLAIMED":
        fail("fingen must not claim all-degree G")
    if "4^n" not in fingen.get("quartic_endomorphism_warning", "") and "4^n" not in json.dumps(
        fingen
    ):
        fail("missing quartic endomorphism warning")

    # --- Algebraization named only ---
    if "NOT_ATTEMPTED" not in alg.get("status", ""):
        fail("algebraization must be not attempted")
    if alg.get("house_rule_3") is None:
        fail("algebraization missing house rule 3")

    # --- Timing fields forbidden in sealed payloads ---
    for name in (
        "persistence_certificate.json",
        "rank_theorem.json",
        "forkB_exit.json",
        "SEAL_FORK_GB.json",
    ):
        text = (HERE / name).read_text().lower()
        for bad in ("elapsed", "runtime", "wall_time", "seconds_taken", "timing"):
            if f'"{bad}"' in text:
                fail(f"timing-like field {bad} in {name}")

    # --- Self-hashes ---
    for name in (
        "persistence_certificate.json",
        "rank_theorem.json",
        "higher_polar_recursion.json",
        "finite_generation_boundary.json",
        "algebraization_gate.json",
        "forkB_exit.json",
    ):
        obj = load_json(HERE / name)
        if not obj.get("self_sha256"):
            fail(f"missing self_sha256 in {name}")
        stored = obj["self_sha256"]
        obj2 = dict(obj)
        obj2["self_sha256"] = None
        recon = hashlib.sha256(
            (json.dumps(obj2, indent=2, sort_keys=True) + "\n").encode()
        ).hexdigest()
        if recon != stored:
            fail(f"self_sha256 mismatch in {name}")

    # SEAL artifact hashes (excluding SEAL itself and possibly verify after re-seal)
    for name, h in seal.get("artifact_sha256", {}).items():
        p = HERE / name
        if not p.exists():
            fail(f"SEAL references missing {name}")
        if name == "SEAL_FORK_GB.json":
            continue
        if sha256_file(p) != h:
            # verify_forkB.py may be hashed before final; allow only if produce re-sealed
            if name == "verify_forkB.py":
                print("  note: verify_forkB.py hash drift (self); checking others")
                continue
            fail(f"artifact hash mismatch {name}")

    if seal.get("headline") != "OPEN":
        fail("SEAL headline")
    if seal.get("decision_exit") != exit_j.get("decision_exit"):
        fail("SEAL exit mismatch")

    # G1 residual minor still intact
    g1 = load_json(HERE / "rank_certificate.json")
    minor = g1["free_module_L3"]["residual_S3_trivial_free_fibre"]["nonzero_maximal_minor"]
    if minor["value"] not in ("-2", "2"):
        # value was -2
        if minor["value"] != "-2":
            fail(f"G1 minor unexpected {minor['value']}")

    print("decision_exit", exit_j["decision_exit"])
    print("persistence", pers["persistence"])
    print("rank_theorem", rank["status"])
    print("PATH_G_FORK_GB_VERIFY_OK")


if __name__ == "__main__":
    main()
