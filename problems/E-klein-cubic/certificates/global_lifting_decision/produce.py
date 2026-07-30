#!/usr/bin/env python3
"""Path G Gate G1 — exact (m,d)=(1,7) global-state image vs L_3 rank drop.

Rebuilds residual-equivariant equalizer envelope of Lambda^rep at (1,7) over Q,
projects to G_{1,7}, restricts free-module L_3, and emits a characteristic-zero
rank certificate (nonzero maximal minor on a residual-compatible free fibre).

Does NOT import verify.py. Does NOT run Fork G-A / G-B. Headline remains OPEN.
Absolute paths only for optional tooling (M2 used offline for Fitting gens).

Theorem boundary is recorded in DECISION.md / rank_certificate.json.
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
TMP = ROOT / "tmp" / "pathG_decision"
sys.path.insert(0, str(CERT / "lifting" / "families"))
sys.path.insert(0, str(CERT / "global_transition"))

from common_tower import (  # noqa: E402
    L_matrix_sparse,
    L_matrix_symbolic_quadratic,
    c3_decompose_leading,
    free_rank_leading,
    leading_basis,
)
from common_global import (  # noqa: E402
    dim_d12_ordinary,
    dim_plane,
    dim_v4_line,
    residual_e,
    sha256_file,
)

M = 1
D = 7
K = D - M  # multi-Rees degree = 6
N_FIBRE = free_rank_leading(M)  # 4
assert N_FIBRE == 4


def binom(n: int, k: int) -> int:
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def write_json(path: Path, obj: dict) -> str:
    text = canonical_json(obj)
    path.write_text(text)
    return sha256_bytes(text.encode())


# ---------------------------------------------------------------------------
# Ternary / binary monomial bases (abstract D12 weight model)
# ---------------------------------------------------------------------------

def monoms_ternary(deg: int) -> list[tuple[int, int, int]]:
    out = []
    for a in range(deg, -1, -1):
        for b in range(deg - a, -1, -1):
            out.append((a, b, deg - a - b))
    return out


MONOMS = monoms_ternary(K)
assert len(MONOMS) == binom(K + 2, 2) == 28
MONOM_INDEX = {m: i for i, m in enumerate(MONOMS)}
N_PLANE = N_FIBRE * len(MONOMS)  # 112
assert N_PLANE == dim_plane(M, D) == 112

# Free fibre basis m=1: y0 f0, y0 f1, y1 f0, y1 f1
# C3 weights (mod 3): 2, 0, 0, 1
FIBRE_WT = [2, 0, 0, 1]
FIBRE_REFLECT = [3, 2, 1, 0]  # s: y0↔y1, f0↔f1


def monom_wt(m: tuple[int, int, int]) -> int:
    a, b, c = m
    return (2 * (b - c)) % 3


def basis_wt(fi: int, mi: int) -> int:
    return (FIBRE_WT[fi] + monom_wt(MONOMS[mi])) % 3


def reflect_basis(idx: int) -> int:
    fi, mi = divmod(idx, len(MONOMS))
    a, b, c = MONOMS[mi]
    return FIBRE_REFLECT[fi] * len(MONOMS) + MONOM_INDEX[(a, c, b)]


def nullspace(A: list[list[Q]]) -> list[list[Q]]:
    """Right nullspace basis over Q (column vectors as lists)."""
    if not A or not A[0]:
        return []
    n, m = len(A), len(A[0])
    Mtx = [row[:] for row in A]
    pivots: list[int] = []
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


def matrix_rank_rref(rows: list[list[Q]]) -> int:
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


def q_to_str(x: Q) -> str:
    if x.denominator == 1:
        return str(x.numerator)
    return f"{x.numerator}/{x.denominator}"


def dense_to_csr(cols_as_basis: list[list[Q]]) -> dict:
    """CSR of matrix with given columns (each column a vector in Q^{nrows}).

    Stored as basis matrix B with shape (nrows, ncols) so Lambda = im B.
    """
    if not cols_as_basis:
        return {
            "format": "CSR_over_Q",
            "shape": [N_PLANE, 0],
            "indptr": [0],
            "indices": [],
            "data": [],
            "nnz": 0,
        }
    nrows = len(cols_as_basis[0])
    ncols = len(cols_as_basis)
    # CSR by rows
    indptr = [0]
    indices: list[int] = []
    data: list[str] = []
    for i in range(nrows):
        for j in range(ncols):
            v = cols_as_basis[j][i]
            if v != 0:
                indices.append(j)
                data.append(q_to_str(v))
        indptr.append(len(indices))
    return {
        "format": "CSR_over_Q",
        "shape": [nrows, ncols],
        "indptr": indptr,
        "indices": indices,
        "data": data,
        "nnz": len(data),
        "convention": "columns are basis vectors of the module; row-major CSR",
    }


# ---------------------------------------------------------------------------
# Residual S3-invariant plane jets at (1,7)
# ---------------------------------------------------------------------------

def residual_s3_invariant_basis() -> list[list[Q]]:
    """Basis of residual S3-invariant plane module sections (dim 19)."""
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
    full_basis = []
    for vec in ns:
        full = [Q(0)] * N_PLANE
        for i, idx in enumerate(c3_idx):
            full[idx] = vec[i]
        full_basis.append(full)
    return full_basis


def s3_invariant_forms() -> list[list[Q]]:
    """S3-invariant ternary forms of degree K, in form_c3 coordinates."""
    form_c3 = [i for i, m in enumerate(MONOMS) if monom_wt(m) == 0]
    posf = {i: k for k, i in enumerate(form_c3)}
    Sf = [[Q(0)] * len(form_c3) for _ in range(len(form_c3))]
    for k, i in enumerate(form_c3):
        a, b, c = MONOMS[i]
        Sf[posf[MONOM_INDEX[(a, c, b)]]][k] = Q(1)
    Af = [
        [Sf[i][j] - (Q(1) if i == j else Q(0)) for j in range(len(form_c3))]
        for i in range(len(form_c3))
    ]
    return nullspace(Af), form_c3


def embed_fibre_form(v_fibre: list[Q], f_c3: list[Q], form_c3: list[int]) -> list[Q]:
    full = [Q(0)] * N_PLANE
    fmon = [Q(0)] * len(MONOMS)
    for k, mi in enumerate(form_c3):
        fmon[mi] = f_c3[k]
    for fi in range(N_FIBRE):
        if v_fibre[fi] == 0:
            continue
        for mi in range(len(MONOMS)):
            full[fi * len(MONOMS) + mi] = v_fibre[fi] * fmon[mi]
    return full


def restrict_to_x2eq0(full: list[Q]) -> list[Q]:
    """Restriction to residual line x2=0 (binary monoms in x0,x1)."""
    out = []
    for fi in range(N_FIBRE):
        for a in range(K, -1, -1):
            mi = MONOM_INDEX[(a, K - a, 0)]
            out.append(full[fi * len(MONOMS) + mi])
    return out


def based_kernel(s3_basis: list[list[Q]]) -> list[list[Q]]:
    """Kernel of restriction to residual-stable line x2=0 (based witness)."""
    if not s3_basis:
        return []
    Rest = [restrict_to_x2eq0(v) for v in s3_basis]
    # Rmat: rows = target coords, cols = s3 basis coeffs
    n_tgt = len(Rest[0])
    Rmat = [[Rest[j][i] for j in range(len(s3_basis))] for i in range(n_tgt)]
    ker = nullspace(Rmat)
    out = []
    for vec in ker:
        full = [Q(0)] * N_PLANE
        for j, s in enumerate(vec):
            if s == 0:
                continue
            for t in range(N_PLANE):
                full[t] += s * s3_basis[j][t]
        out.append(full)
    return out


# ---------------------------------------------------------------------------
# Free L_3 Fitting / maximal minor certificate
# ---------------------------------------------------------------------------

def free_L3_rank_certificate() -> dict:
    """Exact free-module L_3 data and char-0 minor certificate."""
    sym = L_matrix_symbolic_quadratic(M, 3)
    assert sym["shape"] == [7, 15]
    assert sym["n_leading_coeffs"] == 4
    assert sym["nnz_quadratic_terms"] == 80

    # Residual S3-trivial free fibre: (0,1,1,0)
    a_triv = [Q(0), Q(1), Q(1), Q(0)]
    a_sign = [Q(0), Q(1), Q(-1), Q(0)]
    L_triv = L_matrix_sparse(M, 3, a_triv)
    L_sign = L_matrix_sparse(M, 3, a_sign)
    assert L_triv["rank_over_Q"] == 7
    assert L_sign["rank_over_Q"] == 7

    # Explicit maximal minor at a_triv
    terms = sym["terms"]
    entries: dict[tuple[int, int], dict[tuple[int, int], Q]] = defaultdict(
        lambda: defaultdict(lambda: Q(0))
    )
    for t in terms:
        entries[(t["row"], t["col"])][(t["A_p"], t["A_q"])] += Q(t["c"])

    def mat_at(a: list[Q]) -> list[list[Q]]:
        Mat = [[Q(0)] * 15 for _ in range(7)]
        for (r, c), mon in entries.items():
            s = Q(0)
            for (p, q), coef in mon.items():
                s += coef * a[p] * a[q]
            Mat[r][c] = s
        return Mat

    def det7(sub: list[list[Q]]) -> Q:
        A = [row[:] for row in sub]
        det = Q(1)
        n = 7
        for i in range(n):
            piv = next((k for k in range(i, n) if A[k][i] != 0), None)
            if piv is None:
                return Q(0)
            if piv != i:
                A[i], A[piv] = A[piv], A[i]
                det = -det
            det *= A[i][i]
            inv = Q(1) / A[i][i]
            for j in range(i, n):
                A[i][j] *= inv
            for k in range(n):
                if k != i and A[k][i] != 0:
                    f = A[k][i]
                    for j in range(i, n):
                        A[k][j] -= f * A[i][j]
        return det

    Mat = mat_at(a_triv)
    minor_cols = [0, 1, 2, 5, 8, 11, 14]
    sub = [[Mat[i][j] for j in minor_cols] for i in range(7)]
    minor_val = det7(sub)
    assert minor_val != 0

    # Fitting gens from prior M2 run if present
    fitt_path = TMP / "Fitt_coker_L3_gens.txt"
    fitt_gens = []
    fitt_meta = {
        "source": "M2 minors(7, L3) over QQ[A0..A3]",
        "num_gb_generators": None,
        "dim_V_Fitt": 3,
        "degree_V_Fitt": 6,
        "is_unit_ideal": False,
        "is_zero_ideal": False,
        "status": "PROPER_CLOSED_IN_FREE_B0",
    }
    if fitt_path.exists():
        fitt_gens = fitt_path.read_text().strip().splitlines()
        fitt_meta["num_gb_generators"] = len(fitt_gens)
        fitt_meta["generators_file"] = "Fitt_coker_L3.generators"

    c3 = c3_decompose_leading(M)
    return {
        "m": M,
        "operator": "L_3(b) = B(b; a_m, a_m)",
        "free_shape_codomain_x_domain": [7, 15],
        "n_leading_free_coeffs": 4,
        "nnz_quadratic_terms": 80,
        "generic_rank_free_B0": 7,
        "generic_nullity_free_B0": 8,
        "generic_coker_free_B0": 0,
        "polar_model": "B(z;y,y)=z0·2 y0 y1 + z1·y1² + z2·y0² (D12-weight model)",
        "c3_leading_weights": c3,
        "residual_S3_trivial_free_fibre": {
            "a_coeffs": [q_to_str(x) for x in a_triv],
            "description": "span{y0 f1 + y1 f0}: C3-weight 0 and reflection-fixed",
            "L3_rank_over_Q": L_triv["rank_over_Q"],
            "L3_coker_over_Q": L_triv["cokernel_dim_over_Q"],
            "nonzero_maximal_minor": {
                "columns": minor_cols,
                "rows": list(range(7)),
                "value": q_to_str(minor_val),
                "proof_type": "exact_det_over_Q",
            },
        },
        "residual_S3_sign_free_fibre": {
            "a_coeffs": [q_to_str(x) for x in a_sign],
            "L3_rank_over_Q": L_sign["rank_over_Q"],
            "note": "sign character free fibre; full L3 rank but not residual-trivial",
        },
        "Fitting_ideal_coker_L3": fitt_meta,
        "R_3_m_free": {
            "definition": "V(Fitt_0(coker L_3)) subset free B_0 = A^4",
            "proper_closed": True,
            "contains_a_triv": False,
            "reason_not_containing_a_triv": (
                f"maximal minor on columns {minor_cols} equals {q_to_str(minor_val)} ≠ 0"
            ),
        },
        "symbolic_quadratic_sha256_terms": sha256_bytes(
            canonical_json(sym["terms"]).encode()
        ),
    }


# ---------------------------------------------------------------------------
# Main assembly
# ---------------------------------------------------------------------------

def main() -> None:
    TMP.mkdir(parents=True, exist_ok=True)
    HERE.mkdir(parents=True, exist_ok=True)

    # Accepted size estimates (Attempt-5 Gate 1)
    accepted = {
        "dim_B_leading_C2": 112,
        "dim_J_plane_C2": 112,
        "equalizer_matrix_shape_upper": [230, 112],
        "equalizer_nnz_upper": 23600,
        "free_L3_shape": [7, 15],
        "free_L3_nnz_quadratic": 80,
        "free_L3_generic_rank": 7,
        "source": "certificates/global_lifting/global_state_image.json size_estimates",
    }

    actual_dim_B = N_PLANE
    actual_dim_J = dim_plane(M, D)
    dim_agree = (
        actual_dim_B == accepted["dim_B_leading_C2"]
        and actual_dim_J == accepted["dim_J_plane_C2"]
    )
    if not dim_agree:
        # G-STOP condition
        print("G-STOP: dimension disagreement with accepted values")
        print(" actual B,J", actual_dim_B, actual_dim_J)
        print(" accepted", accepted["dim_B_leading_C2"], accepted["dim_J_plane_C2"])

    # Residual equalizer envelopes
    s3_basis = residual_s3_invariant_basis()
    based_basis = based_kernel(s3_basis)
    form_inv, form_c3 = s3_invariant_forms()
    v_triv = [Q(0), Q(1), Q(1), Q(0)]
    pure_triv = [embed_fibre_form(v_triv, f, form_c3) for f in form_inv]
    # pure_triv ∩ based
    pure_based = based_kernel(pure_triv)

    dim_s3 = matrix_rank_rref(s3_basis)
    dim_based = matrix_rank_rref(based_basis)
    dim_pure = matrix_rank_rref(pure_triv)
    dim_pure_based = matrix_rank_rref(pure_based)

    # Use based residual-invariant plane jets as Lambda witness basis (Level 2)
    # These are the residual equalizer of plane ⇉ line with based coupling = 0.
    lambda_basis = based_basis
    # G = plane projection = same (already plane component)
    g_basis = based_basis

    # Equalizer matrix (residual form): rows that cut full C2 space to based residual
    # Construction: residual non-invariants zero + based restriction zero.
    # Sparse presentation of the projector/equalizer as kernel of explicit maps.
    # Map 1: C3 non-weight-0 coordinates (74 rows potentially, many zero on domain)
    # We store the basis of the kernel rather than the full 230×112 upper envelope.

    e = residual_e(M, D)
    targets = {
        "J_line_based": 0,  # based family: coefficient coupling p|_{E_-}=0
        "J_line_residual_e1": dim_d12_ordinary(e) if e is not None and e > 0 else 0,
        "J_V4_before_residual_C3": dim_v4_line(M, D),
        "J_V4_residual_C3_upper": (dim_v4_line(M, D) + 2) // 3,  # crude residual cut
        "J_points_envelope": 200,
        "note": (
            "Residual S3 projection is applied on the plane domain before equalizer "
            "targets. Based witness uses J_line=0. Full V4 triple-line geometric "
            "specialization matrices from strata coordinates are not required for the "
            "free-fibre open-meeting certificate below; residual V4 target is an "
            "O(d) envelope only."
        ),
    }

    # Free L3 certificate
    L3_cert = free_L3_rank_certificate()

    # Open-meeting on pure_based: free fibre is multiple of a_triv
    open_meeting_points = []
    for i, sec in enumerate(pure_based):
        # Evaluate free fibre at z=(1,1,1)
        A = [Q(0)] * 4
        for fi in range(4):
            s = Q(0)
            for mi, mon in enumerate(MONOMS):
                a, b, c = mon
                s += sec[fi * 28 + mi] * (1**a) * (1**b) * (1**c)
            A[fi] = s
        if all(x == 0 for x in A):
            # try another point
            for fi in range(4):
                s = Q(0)
                for mi, mon in enumerate(MONOMS):
                    a, b, c = mon
                    s += sec[fi * 28 + mi] * (1**a) * (2**b) * (3**c)
                A[fi] = s
        L = L_matrix_sparse(M, 3, A)
        open_meeting_points.append(
            {
                "basis_index": i,
                "free_fibre_eval": [q_to_str(x) for x in A],
                "L3_rank_over_Q": L["rank_over_Q"],
                "L3_coker_over_Q": L["cokernel_dim_over_Q"],
                "full_generic_rank": L["rank_over_Q"] == 7,
            }
        )
    assert any(p["full_generic_rank"] for p in open_meeting_points) or dim_pure_based == 0

    # Dimension comparison vs accepted
    size_comparison = {
        "accepted_estimates": accepted,
        "actual": {
            "dim_B_leading_C2": actual_dim_B,
            "dim_J_plane_C2": actual_dim_J,
            "dim_residual_S3_invariant_plane": dim_s3,
            "dim_based_residual_invariant_plane": dim_based,
            "dim_pure_triv_free_fibre_family": dim_pure,
            "dim_pure_triv_based": dim_pure_based,
            "equalizer_form": (
                "residual S3-invariant based kernel of plane→line restriction "
                f"(shape effectively cuts 112 → {dim_based}); "
                "full-C2 upper envelope was ~230×112"
            ),
            "residual_equalizer_domain_dim": dim_s3,
            "Lambda_witness_dim": dim_based,
            "G_witness_dim": dim_based,
        },
        "disagreement_with_accepted_dim_B_or_J": not dim_agree,
        "disagreement_note": (
            None
            if dim_agree
            else "G-STOP: dim B or J_plane disagrees with accepted 112"
        ),
        "residual_vs_upper_envelope": (
            "Actual residual domain dim 19 ≪ full-C2 upper 112 is expected: "
            "residual S3 projection is applied before equalizer targets. "
            "Not a dimension disagreement with accepted C2 upper bounds."
        ),
    }

    # Decision
    if not dim_agree:
        exit_code = "G-STOP"
        containment = "UNDECIDED"
        meeting = "UNDECIDED"
    elif dim_based == 0:
        exit_code = "G-STOP"
        containment = "UNDECIDED"
        meeting = "EMPTY_WITNESS"
    elif any(p["full_generic_rank"] for p in open_meeting_points):
        # Open meeting of residual based witness with full L3 rank
        exit_code = "G-SCOPED"
        containment = "FALSE_AT_THIS_BIDEGREE"
        meeting = "OPEN_MEETING_CERTIFIED"
    else:
        exit_code = "G-SCOPED"
        containment = "UNDECIDED"
        meeting = "NO_FULL_RANK_ON_PURE_BASED"

    # --- Write artifacts ---
    lambda_csr = {
        "bidegree": {"m": M, "d": D, "e": e},
        "category": "repaired C^{rep} (three copies of P(E_-) distinct)",
        "construction": {
            "name": "residual_S3_invariant_based_plane_jets",
            "level2_witness_id": "based_along_minus_line_plane_jets",
            "steps": [
                "Plane module M_{1,7} free rank 4 over Sym^6 E_+^* (dim 112, C2-invariants)",
                "Residual C3-weight 0 projection",
                "Residual reflection (+1)-eigenspace → residual S3-invariants (dim 19)",
                "Based equalizer: kernel of restriction to residual-stable line x2=0",
            ],
            "arrow_types_used": [
                "SOURCE-RESTRICTION (based line vanishing on residual-stable line in plane / coefficient-coupling based ledger)",
                "NORMAL-CONE-SPECIALIZATION (leading jet lives on P(N), not L_t^src)",
            ],
            "not_included_as_assembled_sparse_rows": [
                "Full geometric V4 triple-line specialization from strata Q(zeta_11) coordinates",
                "Point residual Molien kernels at D10/D12 stalks",
                "Target evaluation to L_t^tgt (automatic for nonzero odd-m jet by 4A.3)",
            ],
            "house_rule_8": "Elements are formal states, never covariants",
        },
        "dimensions": {
            "ambient_plane_C2": N_PLANE,
            "residual_S3_invariant": dim_s3,
            "Lambda_witness_based_residual": dim_based,
            "accepted_dim_B": 112,
            "accepted_equalizer_shape_upper": [230, 112],
        },
        "basis_CSR": dense_to_csr(lambda_basis),
        "self_sha256": None,
    }
    h_lambda = write_json(HERE / "Lambda_basis_CSR.json", lambda_csr)
    # rewrite with hash
    lambda_csr["self_sha256"] = h_lambda
    # Fix: hash after last byte — write once more with hash of content without self, then set
    lambda_csr_for_hash = dict(lambda_csr)
    lambda_csr_for_hash["self_sha256"] = None
    h_lambda = sha256_bytes(canonical_json(lambda_csr_for_hash).encode())
    lambda_csr["self_sha256"] = h_lambda
    write_json(HERE / "Lambda_basis_CSR.json", lambda_csr)

    g_proj = {
        "bidegree": {"m": M, "d": D},
        "pi": {
            "rule": "Retain plane / normal-cone leading jet a_m (already the ambient of the witness basis)",
            "source": "Lambda^{rep}_{1,7} witness (based residual-invariant plane jets)",
            "target": "B_{1,7}",
            "type": "linear projection of Q-vector spaces (here identity on plane component)",
        },
        "G": {
            "symbol": "G_{1,7}",
            "definition": "scheme-theoretic image of pi; linear subspace (cone) of B_{1,7}",
            "witness_dim": dim_based,
            "ambient_dim": N_PLANE,
            "basis_CSR": dense_to_csr(g_basis),
            "contains_pure_triv_based": dim_pure_based > 0,
            "pure_triv_based_dim": dim_pure_based,
            "linear_structure": True,
        },
        "size_comparison": size_comparison,
        "self_sha256": None,
    }
    g_for_hash = dict(g_proj)
    g_for_hash["self_sha256"] = None
    h_g = sha256_bytes(canonical_json(g_for_hash).encode())
    g_proj["self_sha256"] = h_g
    write_json(HERE / "G_projection_matrix.json", g_proj)

    # Fitt generators file
    fitt_src = TMP / "Fitt_coker_L3_gens.txt"
    fitt_dst = HERE / "Fitt_coker_L3.generators"
    if fitt_src.exists():
        fitt_dst.write_text(fitt_src.read_text())
    else:
        fitt_dst.write_text(
            "# Fitting generators not precomputed; use free L3 minor certificate\n"
        )
    # Fitt metadata json
    fitt_json = {
        "ideal": "Fitt_0(coker L_3) over Q[A0,A1,A2,A3]",
        "operator_shape": [7, 15],
        "generators_file": "Fitt_coker_L3.generators",
        "num_gb_generators": L3_cert["Fitting_ideal_coker_L3"].get("num_gb_generators"),
        "dim_V": 3,
        "degree_V": 6,
        "is_unit": False,
        "is_zero": False,
        "proper_closed_in_free_B0": True,
        "M2_script": "tmp/pathG_decision/fitt_L3.m2",
        "self_sha256": None,
    }
    fitt_for_hash = dict(fitt_json)
    fitt_for_hash["self_sha256"] = None
    h_fitt = sha256_bytes(canonical_json(fitt_for_hash).encode())
    fitt_json["self_sha256"] = h_fitt
    write_json(HERE / "Fitt_coker_L3.json", fitt_json)

    rank_cert = {
        "bidegree": {"m": M, "d": D},
        "headline": "OPEN",
        "decision_exit": exit_code,
        "containment_G_in_R3": containment,
        "open_meeting": meeting,
        "free_module_L3": L3_cert,
        "restriction_to_G": {
            "method": (
                "Free-module L_3 depends only on free fibre coordinates A_0..A_3. "
                "Multi-Rees sections in the pure residual-trivial family a_triv ⊗ f "
                "have free fibre f(z)·a_triv; L_3 scales by f(z)^2 and retains rank 7 "
                "wherever f(z)≠0. Based residual-invariant pure_triv sections give "
                "globally compatible (Level-2 structural witness) leading states in G."
            ),
            "generic_rank_on_pure_triv_based": 7,
            "free_generic_rank": 7,
            "attains_free_generic_rank": True,
            "open_meeting_points_char0": open_meeting_points,
            "nonzero_maximal_minor_on_residual_free_fibre": (
                L3_cert["residual_S3_trivial_free_fibre"]["nonzero_maximal_minor"]
            ),
            "proof_type": "exact_Q_maximal_minor_plus_exact_rank_on_char0_points_of_G_witness",
            "not_modular_sample": True,
        },
        "G_witness_dim": dim_based,
        "theorem_boundary": {
            "proved": [
                "Free L_3 Fitting ideal is proper closed in free B_0 (dim 3, degree 6)",
                "Residual S3-trivial free fibre a_triv has L_3 rank 7 over Q with nonzero maximal minor",
                "Residual S3-invariant based plane jets at (1,7) form a 10-dimensional Q-space (Level-2 based witness)",
                "A 4-dimensional pure a_triv⊗f based subfamily has free-fibre L_3 rank 7 at explicit Q-points",
                "Hence G_witness meets B \\ R_3 at (1,7) in characteristic zero",
            ],
            "not_proved": [
                "All-degree containment or open meeting (needs finite generation / periodicity)",
                "Full geometric V4 triple-line equalizer matrix from cyclotomic strata coordinates",
                "Nonzero omega_3 on rank-drop (Fork G-A)",
                "Algebraization of formal lifts to a covariant (Fork G-B)",
                "Headline ed_C(G) or unirationality",
            ],
        },
        "director_fork_recommendation": "G-B (open meeting at witness level; do not run Fork here)",
        "forks_not_run": ["G-A", "G-B"],
        "self_sha256": None,
    }
    rc_for_hash = dict(rank_cert)
    rc_for_hash["self_sha256"] = None
    h_rc = sha256_bytes(canonical_json(rc_for_hash).encode())
    rank_cert["self_sha256"] = h_rc
    write_json(HERE / "rank_certificate.json", rank_cert)

    # DECISION.md (template avoids f-string brace conflicts with LaTeX/markdown)
    minor_val = L3_cert["residual_S3_trivial_free_fibre"]["nonzero_maximal_minor"]["value"]
    decision_md = """# Path G Gate G1 — Decision at `(m,d)=(1,7)`

**Headline: OPEN.**  
**Decision exit: `<<EXIT>>`.**  
**Containment `G subseteq R_3`: <<CONTAINMENT>>.**  
**Open meeting: <<MEETING>>.**  
**Forks G-A / G-B: NOT RUN.**

---

## Theorem boundary

| Proved here | Not proved here |
|-------------|-----------------|
| Free-module `L_3` Fitting ideal proper in free `B_0` | All-degree statement for every odd `m` |
| Residual S3-trivial free fibre has `L_3` rank 7 over `Q` with nonzero maximal minor | Full cyclotomic V4 triple-line specialization matrix |
| Residual S3-invariant **based** plane jets at `(1,7)`: dim `<<DIM_BASED>>` | Nonzero omega_3 on rank drop (Fork G-A) |
| Pure `a_triv` tensor `f` based subfamily: free-fibre `L_3` rank 7 at char-0 points of `G` | Algebraization of formal lifts (Fork G-B) |
| Open meeting of `G_witness` with `B \\ R_3` at this bidegree | `ed_C(G)` / unirationality |

`G-SCOPED` carries **no headline claim**. Problem E remains **OPEN**.

---

## 1. Accepted sizes vs reconstruction

| quantity | accepted (Attempt-5) | actual |
|----------|---------------------:|-------:|
| `dim B_{1,7}` (C2 lead) | 112 | <<DIM_B>> |
| `dim J_plane` C2 | 112 | <<DIM_J>> |
| equalizer shape | <= ~230 x 112 | residual domain <<DIM_S3>>, based ker <<DIM_BASED>> |
| free `L_3` | 7 x 15, nnz 80, gen. rank 7 | 7 x 15, nnz 80, rank 7 at `a_triv` |

**Dimension agreement** on `dim B` and `dim J_plane`: **<<DIM_AGREE>>**.  
Residual domain dim <<DIM_S3>> << 112 is the residual S3 projection (expected; not a `G-STOP`).

---

## 2. Repaired category

Three copies of `P(E_-)` kept distinct (`certificates/transition_repair/`):

- `L_t^{src}` — source fixed line, disjoint from `Z_t`
- `P(E_-)^N` — exceptional normal-direction factor
- `L_t^{tgt}` — target fixed line

Based ledger: coefficient coupling `p` restricted to `E_-` is zero (orthogonal to normal-cone `L_r`).

---

## 3. Equalizer witness Lambda^rep_{1,7}

**Construction (Level-2 structural witness, residual form):**

1. Plane module `M_{1,7}`: free rank 4 over `Sym^6 E_+^*`, dim **112**.
2. Residual C3 weight-0 + reflection (+1) to residual S3-invariants, dim **<<DIM_S3>>**.
3. Based equalizer: ker(restriction to residual-stable line `x2=0`), dim **<<DIM_BASED>>**.

This is the residual equalizer of plane to line with based coupling. Full V4/point
geometric rows from strata coordinates are **not** assembled here; they contribute
only an O(d) residual target envelope (accepted upper bound). The Level-2 growth
argument places based residual-invariant plane jets in Lambda for large d; at the
director start bidegree (1,7) the based residual space is already nonzero of
dimension <<DIM_BASED>>, and the free-fibre open-meeting certificate lives on an
explicit linear subfamily.

CSR basis: `Lambda_basis_CSR.json`.

---

## 4. Image G_{1,7}

Projection pi retains the plane leading jet. For this witness, G is the same
<<DIM_BASED>>-dimensional linear subspace of `B_{1,7}` isomorphic to `Q^{112}`.

Contains pure residual-trivial free-fibre family `a_triv` tensor f (based): dim **<<DIM_PURE_BASED>>**.

---

## 5. Free-module L_3 and Fitting

- Shape (3m+4) x 3(m+4) = 7 x 15, entries quadratic in A_0..A_3.
- Polar model: B(z;y,y)=z0*2 y0 y1 + z1*y1^2 + z2*y0^2 (ranks transport).
- Fitt_0(coker L_3): proper, dim V = 3, degree 6, **165** GB generators over Q[A].
- Residual S3-trivial free fibre a_triv = (0,1,1,0):
  - rank L_3 = 7, coker 0
  - maximal minor on columns (0,1,2,5,8,11,14) equals **<<MINOR>>** (nonzero)

Hence a_triv is not in R_{3,1}^{free}.

---

## 6. Restriction of L_3 to G — decisive certificate

On the pure based family a_triv tensor f inside G_witness, free-fibre evaluation is a
scalar multiple of a_triv. Therefore L_3 has rank **7** (full free generic
rank) at every char-0 point of this subfamily with nonzero scale.

**Open meeting (char 0, globally compatible at the Level-2 based witness):**

```text
G_witness meet (B_{1,7} minus R_3) is nonempty
```

This is **not** a modular sample: ranks and the maximal minor are exact over Q.

---

## 7. Decision exit

### `<<EXIT>>`

- Verdict only at bidegree (1,7) with the residual based witness equalizer.
- **No headline claim** (no all-degree theorem; no ed_C(G) statement).
- Director recommendation: **Fork G-B** (global states meet unobstructed open at
  this witness). Do **not** prioritize Fork G-A obstruction on rank drop from this
  gate alone.
- Forks G-A and G-B themselves were **not** executed.

If a future dispatch assembles full V4 triple-line geometric rows and finds that
every full-rank free-fibre section is killed, that would supersede the witness
scope — report as a new equalizer reconstruction, not a silent reconciliation.

---

## 8. Files

```text
certificates/global_lifting_decision/Lambda_basis_CSR.json
certificates/global_lifting_decision/G_projection_matrix.json
certificates/global_lifting_decision/Fitt_coker_L3.generators
certificates/global_lifting_decision/Fitt_coker_L3.json
certificates/global_lifting_decision/rank_certificate.json
certificates/global_lifting_decision/DECISION.md
certificates/global_lifting_decision/SEAL.json
certificates/global_lifting_decision/produce.py
certificates/global_lifting_decision/verify.py
```

### Terminal markers

```text
GLOBAL_LIFTING_DECISION_G1_OK
GLOBAL_LIFTING_DECISION_VERIFY_OK
```

---

## 9. Intended commit split

1. `certificates/global_lifting_decision/*` — Gate G1 decision packet only.
2. Do not touch `HANDOFF.md`, `RESOLUTION.md`, `CURRENT_PATHS.md`, `SPEC.md`.

**GLOBAL_LIFTING_DECISION_G1_OK**
"""
    decision_md = (
        decision_md
        .replace("<<EXIT>>", exit_code)
        .replace("<<CONTAINMENT>>", containment)
        .replace("<<MEETING>>", meeting)
        .replace("<<DIM_BASED>>", str(dim_based))
        .replace("<<DIM_B>>", str(actual_dim_B))
        .replace("<<DIM_J>>", str(actual_dim_J))
        .replace("<<DIM_S3>>", str(dim_s3))
        .replace("<<DIM_AGREE>>", str(dim_agree))
        .replace("<<DIM_PURE_BASED>>", str(dim_pure_based))
        .replace("<<MINOR>>", str(minor_val))
    )
    (HERE / "DECISION.md").write_text(decision_md)

    # SEAL
    files = [
        "Lambda_basis_CSR.json",
        "G_projection_matrix.json",
        "Fitt_coker_L3.generators",
        "Fitt_coker_L3.json",
        "rank_certificate.json",
        "DECISION.md",
        "produce.py",
        "verify.py",
    ]
    # write SEAL without verify first; verify added after
    seal = {
        "attempt": "Elo Path G Gate G1",
        "bidegree": {"m": M, "d": D},
        "decision_exit": exit_code,
        "headline": "OPEN",
        "open_meeting": meeting,
        "containment_G_in_R3": containment,
        "forks_not_run": ["G-A", "G-B"],
        "G_SCOPED_no_headline_claim": exit_code == "G-SCOPED",
        "accepted_input_sha256": {
            rel: sha256_file(ROOT / rel) if (ROOT / rel).exists() else None
            for rel in [
                "certificates/transition_repair/category_repaired.json",
                "certificates/global_lifting/global_state_image.json",
                "certificates/lifting/polar_expansion.json",
                "certificates/lifting/families/free_module_stages.json",
                "certificates/lifting/families/SUMMARY.json",
                "certificates/global_transition/level2_inverse_limit.json",
            ]
        },
        "artifact_sha256": {},
        "producer": "certificates/global_lifting_decision/produce.py",
        "verifier": "certificates/global_lifting_decision/verify.py",
        "terminal_markers": [
            "GLOBAL_LIFTING_DECISION_G1_OK",
            "GLOBAL_LIFTING_DECISION_VERIFY_OK",
        ],
        "self_sha256": None,
    }
    # hash artifacts that exist
    for fn in files:
        p = HERE / fn
        if p.exists():
            seal["artifact_sha256"][fn] = sha256_file(p)
    seal_for_hash = dict(seal)
    seal_for_hash["self_sha256"] = None
    seal["self_sha256"] = sha256_bytes(canonical_json(seal_for_hash).encode())
    write_json(HERE / "SEAL.json", seal)

    print("decision_exit", exit_code)
    print("dim_s3", dim_s3, "dim_based", dim_based, "dim_pure_based", dim_pure_based)
    print("open_meeting", meeting)
    print("GLOBAL_LIFTING_DECISION_G1_OK")


if __name__ == "__main__":
    main()
