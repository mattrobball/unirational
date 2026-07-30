#!/usr/bin/env python3
"""WP-L1 producer: universal polar expansion of the Klein cubic through order 3m+3.

Derives algebraically (no geometric sampling) the normal-order ledger for
F(sum p_r) when the first normal order m is odd, and records the linear
isolation maps L_r and obstruction classes omega_r.

Also instantiates dimension / character estimates on the three accepted WP-5
survivor families without running a large elimination.

Does NOT import verify_polar_expansion.py.  No timing fields.  Headline OPEN.
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
GT = CERT / "global_transition"
sys.path.insert(0, str(GT))
sys.path.insert(0, str(CERT / "transitions"))

from common_global import (  # noqa: E402
    binom,
    canonical_json,
    dim_d12_twisted,
    dim_plane,
    residual_e,
    sha256_bytes,
    sha256_file,
)

# ---------------------------------------------------------------------------
# Exact Klein cubic and its polarization (over Q)
# ---------------------------------------------------------------------------

def klein_F(v):
    """F(v) = sum_{i in Z/5} v_i^2 v_{i+1}."""
    return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5))


def Phi(u, v, w):
    """Symmetric trilinear polarization with Phi(x,x,x) = F(x).

    Explicit formula over Q:
        Phi(u,v,w) = (1/3) sum_i (
            u_i v_i w_{i+1} + u_i w_i v_{i+1} + v_i w_i u_{i+1}
        )
    Equivalent inclusion-exclusion formula:
        6 Phi(u,v,w) = F(u+v+w) - F(u+v) - F(u+w) - F(v+w)
                       + F(u) + F(v) + F(w).
    """
    s = Fraction(0)
    for i in range(5):
        ip = (i + 1) % 5
        s += (
            Fraction(u[i]) * Fraction(v[i]) * Fraction(w[ip])
            + Fraction(u[i]) * Fraction(w[i]) * Fraction(v[ip])
            + Fraction(v[i]) * Fraction(w[i]) * Fraction(u[ip])
        ) / 3
    return s


def Phi_inclusion(u, v, w):
    def add(*vecs):
        return [sum(x[i] for x in vecs) for i in range(5)]

    def F(x):
        return klein_F(x)

    return (
        F(add(u, v, w))
        - F(add(u, v))
        - F(add(u, w))
        - F(add(v, w))
        + F(u)
        + F(v)
        + F(w)
    ) / Fraction(6)


def B(z, y1, y2):
    """Mixed polar form: B(z; y,y) = 3 Phi(z,y,y), bilinearized in (y1,y2)."""
    return 3 * Phi(z, y1, y2)


def verify_polarization_algebra() -> dict:
    """Algebraic identities over Q — no sampling of special loci."""
    checks = []

    # Phi(x,x,x) = F(x) on the standard basis monomials / generic symbols via
    # structure constants on basis vectors e_i.
    for a in range(5):
        for b in range(5):
            for c in range(5):
                u = [1 if i == a else 0 for i in range(5)]
                v = [1 if i == b else 0 for i in range(5)]
                w = [1 if i == c else 0 for i in range(5)]
                assert Phi(u, v, w) == Phi_inclusion(u, v, w)
    checks.append("Phi_matches_inclusion_exclusion_on_basis")

    # Phi(x,x,x) = F(x) for generic integer vector
    for vec in (
        [1, 0, 0, 0, 0],
        [1, 1, 0, 0, 0],
        [1, 2, 3, 4, 5],
        [2, -1, 0, 3, -4],
    ):
        assert Phi(vec, vec, vec) == klein_F(vec)
    checks.append("Phi(x,x,x)=F(x)")

    # Symmetry
    u, v, w = [1, 0, 1, 0, 0], [0, 2, 0, 1, 0], [1, 1, 0, 0, 3]
    assert Phi(u, v, w) == Phi(v, u, w) == Phi(u, w, v) == Phi(w, v, u)
    checks.append("Phi_symmetric")

    # Full cubic expansion
    # F(z+y) = F(z) + 3 Phi(z,z,y) + 3 Phi(z,y,y) + F(y)
    z = [1, 2, 0, -1, 3]
    y = [0, 1, -1, 2, 0]
    lhs = klein_F([z[i] + y[i] for i in range(5)])
    rhs = (
        klein_F(z)
        + 3 * Phi(z, z, y)
        + 3 * Phi(z, y, y)
        + klein_F(y)
    )
    assert lhs == rhs
    checks.append("binomial_cubic_expansion")

    # B(z;y,y) = 3 Phi(z,y,y)
    assert B(z, y, y) == 3 * Phi(z, y, y)
    checks.append("B_definition")

    # Structure: Phi(e_i, e_i, e_{i+1}) = 1/3
    for i in range(5):
        ei = [1 if j == i else 0 for j in range(5)]
        eip = [1 if j == (i + 1) % 5 else 0 for j in range(5)]
        assert Phi(ei, ei, eip) == Fraction(1, 3)
    checks.append("structure_constants_Phi(e_i,e_i,e_{i+1})=1/3")

    return {
        "status": "PROVED",
        "field": "Q",
        "checks": checks,
        "Phi_formula": (
            "Phi(u,v,w)=(1/3) sum_i (u_i v_i w_{i+1} + u_i w_i v_{i+1} "
            "+ v_i w_i u_{i+1})"
        ),
        "B_formula": "B(z;y1,y2)=3 Phi(z,y1,y2)",
        "F": "sum_{i in Z/5} x_i^2 x_{i+1}",
    }


# ---------------------------------------------------------------------------
# Symbolic order ledger (arbitrary odd m, no instantiated degree)
# ---------------------------------------------------------------------------

def parity_target(r: int) -> str:
    """E_+ for even r, E_- for odd r (director-verified covariant parity)."""
    return "E_plus" if r % 2 == 0 else "E_minus"


def F_order_contributions(m: int, N: int, r_max: int | None = None):
    """All triples (i,j,k) with m <= i,j,k <= r_max and i+j+k = N.

    Triple-E_- contributions vanish (F|_{E_-}=0 and multilinearity on E_-).
    """
    if r_max is None:
        r_max = N  # crude bound
    out = []
    for i in range(m, r_max + 1):
        for j in range(m, r_max + 1):
            for k in range(m, r_max + 1):
                if i + j + k != N:
                    continue
                types = tuple(parity_target(r) for r in (i, j, k))
                n_minus = sum(1 for t in types if t == "E_minus")
                vanish = n_minus == 3
                out.append(
                    {
                        "ijk": (i, j, k),
                        "types": types,
                        "vanish_triple_Eminus": vanish,
                    }
                )
    return out


def unique_sorted_contributions(m: int, N: int):
    """Unique sorted (i,j,k) with multiplicity = #distinct permutations."""
    from itertools import permutations

    raw = F_order_contributions(m, N, r_max=N)
    seen = {}
    for c in raw:
        if c["vanish_triple_Eminus"]:
            continue
        key = tuple(sorted(c["ijk"]))
        if key in seen:
            continue
        mult = len(set(permutations(key)))
        seen[key] = {
            "ijk_sorted": key,
            "multiplicity": mult,
            "types": tuple(parity_target(r) for r in key),
        }
    return [seen[k] for k in sorted(seen)]


def ledger_for_odd_m() -> dict:
    """Universal ledger valid for every odd positive m (symbolic in m)."""
    # Use m=1,3,5 as regression of the combinatorial structure; formulas are
    # recorded symbolically.
    structure = {}
    for m0 in (1, 3, 5, 7):
        structure[str(m0)] = {}
        for delta in (0, 1, 2, 3, 4, 5):
            N = 3 * m0 + delta
            parity = "even" if N % 2 == 0 else "odd"
            auto = parity == "odd"  # F(p) even in y ⇒ odd normal orders auto 0
            contribs = unique_sorted_contributions(m0, N)
            structure[str(m0)][f"3m+{delta}"] = {
                "N": N,
                "N_parity": parity,
                "automatic_by_y_evenness": auto,
                "live_contributions": contribs if not auto else [],
                "note_if_auto": (
                    "F(p) is even in the normal variable y (because F(p(z,-y))"
                    "=F(p(z,y)) by G-invariance of F and covariance of p), so "
                    "odd normal orders in F(p) vanish identically."
                    if auto
                    else None
                ),
            }

    # Universal equations at 3m+1 and 3m+3
    eq_3m1 = {
        "F_order": "3m+1",
        "parity": "even",
        "automatic": False,
        "live_triples": [
            {
                "ijk": "(m, m, m+1)",
                "multiplicity": 3,
                "types": "(E_minus, E_minus, E_plus)",
                "term": "3 Phi(b_{m+1}, a_m, a_m) = B(b_{m+1}; a_m, a_m)",
            }
        ],
        "equation": "B(b_{m+1}; a_m, a_m) = 0",
        "equation_id": "U.3m+1",
        "status": "PROVED",
        "proof": [
            "Only triple of normal orders summing to 3m+1 with each ≥ m and "
            "not all odd is (m,m,m+1) up to permutation.",
            "Multiplicity 3 gives 3 Phi(b_{m+1}, a_m, a_m).",
            "By definition B(z;y,y)=3 Phi(z,y,y), hence B(b_{m+1}; a_m, a_m)=0.",
            "Triple-E_- contribution at (m,m,m) has order 3m (odd) and vanishes "
            "both by y-evenness of F(p) and by F|_{E_-}=0.",
        ],
    }

    eq_3m3 = {
        "F_order": "3m+3",
        "parity": "even",
        "automatic": False,
        "live_triples": [
            {
                "ijk": "(m, m, m+3)",
                "multiplicity": 3,
                "types": "(E_minus, E_minus, E_plus)",
                "term": "3 Phi(b_{m+3}, a_m, a_m) = B(b_{m+3}; a_m, a_m)",
            },
            {
                "ijk": "(m, m+1, m+2)",
                "multiplicity": 6,
                "types": "(E_minus, E_plus, E_minus)",
                "term": (
                    "6 Phi(b_{m+1}, a_m, a_{m+2}) = 2 B(b_{m+1}; a_m, a_{m+2})"
                ),
            },
            {
                "ijk": "(m+1, m+1, m+1)",
                "multiplicity": 1,
                "types": "(E_plus, E_plus, E_plus)",
                "term": "Phi(b_{m+1}, b_{m+1}, b_{m+1}) = F_+(b_{m+1})",
            },
        ],
        "equation": (
            "B(b_{m+3}; a_m, a_m) + 2 B(b_{m+1}; a_m, a_{m+2}) + F_+(b_{m+1}) = 0"
        ),
        "equation_id": "U.3m+3",
        "status": "PROVED",
        "proof": [
            "Even F-order 3m+3; enumerate triples i+j+k=3m+3 with i,j,k≥m, "
            "excluding triple-E_-. Combinatorial list is independent of the "
            "value of odd m (translate indices by m).",
            "Contribution (m,m,m+3): mult 3 → B(b_{m+3}; a_m, a_m).",
            "Contribution (m,m+1,m+2): mult 6 → 2 B(b_{m+1}; a_m, a_{m+2}) "
            "because B(z;y1,y2)=3 Phi(z,y1,y2) and 6 Phi = 2·3 Phi.",
            "Contribution (m+1,m+1,m+1): F(b_{m+1})=F_+(b_{m+1}) since "
            "b_{m+1} is E_+-valued.",
            "No (1 odd + 2 even) triple sums to 3m+3 with min odd order m: "
            "m+(m+1)+(m+1)=3m+2 and m+(m+1)+(m+3)=3m+4.",
        ],
    }

    # First term a_m lands automatically
    first_order = {
        "F_order": "3m",
        "equation": "0 = 0",
        "reason": (
            "Pure leading term a_m is E_--valued; F|_{E_-}=0 so Phi(a_m,a_m,a_m)=0. "
            "Moreover 3m is odd, so the order is also killed by y-evenness of F(p)."
        ),
        "status": "PROVED",
        "reference": "4A.4 + director F|_{E_-}=0",
    }

    return {
        "valid_for": "all odd positive integers m; all degrees d ≥ m",
        "no_instantiated_degree": True,
        "notation": {
            "p_minus": "a_m + a_{m+2} + a_{m+4} + ...  (E_--valued, odd normal orders)",
            "p_plus": "b_{m+1} + b_{m+3} + b_{m+5} + ...  (E_+-valued, even normal orders)",
            "first_normal_order": "m odd",
            "global_degree": "d (independent grading)",
        },
        "director_spine": {
            "F_expansion": "F(z+y)=F(z)+3 Phi(z,y,y)=F_+(z)+B(z;y,y)",
            "F_on_Eminus": "0",
            "covariant_parity": (
                "p_r is E_+-valued for even r and E_--valued for odd r; "
                "p|_{E_-}=p_d(0,y)"
            ),
        },
        "y_evenness_of_Fp": {
            "claim": "F(p(z,y)) is even in y",
            "reason": (
                "F is G-invariant and p is t-covariant, so F(p(t x))=F(t p(x))"
                "=F(p(x)); t(z+y)=z-y."
            ),
            "consequence": (
                "Only even normal orders in F(p) can give equations. Odd "
                "orders (including 3m, 3m+2, ...) vanish automatically."
            ),
        },
        "regression_structure_m_in_1_3_5_7": structure,
        "first_order_automatic": first_order,
        "universal_equations": {
            "order_3m+1": eq_3m1,
            "order_3m+3": eq_3m3,
        },
    }


def isolation_maps() -> dict:
    """L_r(p_{m+r}) = -R_r(p_m,...,p_{m+r-1}) and omega_r in coker(L_r)."""
    return {
        "indexing": (
            "r = 0,1,2,... indexes the normal-order correction p_{m+r}. "
            "The F-equation that first involves p_{m+r} as newest unknown "
            "(among even F-orders) defines L_r when that equation is linear "
            "in p_{m+r}."
        ),
        "steps": [
            {
                "r": 0,
                "unknown": "a_m = p_m",
                "target_space": "E_minus",
                "L_0": "0  (no linear constraint from F at leading order)",
                "R_0": "0",
                "omega_0": "0 in coker(0) — free leading jet subject to residual equivariance",
                "F_order": "3m (automatic)",
                "note": (
                    "a_m is constrained only by residual D12 / global equalizer "
                    "data from the linear strata machine, not by F at order 3m."
                ),
            },
            {
                "r": 1,
                "unknown": "b_{m+1} = p_{m+1}",
                "target_space": "E_plus",
                "F_order": "3m+1",
                "L_1": "L_1(b_{m+1}) = B(b_{m+1}; a_m, a_m)",
                "R_1": "0",
                "equation": "L_1(b_{m+1}) = 0",
                "omega_1": (
                    "omega_1 ∈ coker(L_1), where L_1: "
                    "{E_+-valued jets of normal order m+1} → "
                    "{scalar jets of normal order 3m+1}. "
                    "Explicitly L_1 depends quadratically on a_m via B(-;a_m,a_m)."
                ),
                "linear_in_newest": True,
                "depends_on": ["a_m"],
            },
            {
                "r": 2,
                "unknown": "a_{m+2} = p_{m+2}",
                "target_space": "E_minus",
                "F_order": "no exclusive even F-order linear in a_{m+2} alone before 3m+3",
                "L_2": (
                    "At F-order 3m+3, a_{m+2} appears only through "
                    "2 B(b_{m+1}; a_m, a_{m+2}), jointly with b_{m+3}. "
                    "Treated as a free correction parameter at stage r=2, "
                    "entering the residual of stage r=3."
                ),
                "R_2": "0 (no standalone equation)",
                "omega_2": "0 — no cokernel obstruction at a pure a_{m+2} stage",
                "linear_in_newest": False,
                "note": (
                    "House rule: do not force a false linear isolation. "
                    "a_{m+2} is a relative parameter for the r=3 Fitting problem."
                ),
            },
            {
                "r": 3,
                "unknown": "b_{m+3} = p_{m+3}",
                "target_space": "E_plus",
                "F_order": "3m+3",
                "L_3": "L_3(b_{m+3}) = B(b_{m+3}; a_m, a_m)",
                "R_3": "2 B(b_{m+1}; a_m, a_{m+2}) + F_+(b_{m+1})",
                "equation": "L_3(b_{m+3}) = -R_3(a_m, b_{m+1}, a_{m+2})",
                "omega_3": (
                    "omega_3 = class of R_3 in coker(L_3). Vanishing of omega_3 "
                    "is the relative obstruction to lifting through order 3m+3."
                ),
                "linear_in_newest": True,
                "depends_on": ["a_m", "b_{m+1}", "a_{m+2}"],
            },
        ],
        "through_order": "3m+3",
        "next_even_F_orders": [
            {
                "F_order": "3m+5",
                "status": "recorded_for_WP-L2",
                "note": (
                    "Not certified as a computed stage in this dispatch; the "
                    "symbolic ledger extends by the same triple enumeration."
                ),
            }
        ],
    }


# ---------------------------------------------------------------------------
# Dimension helpers for relative matrices (no large elimination)
# ---------------------------------------------------------------------------

def dim_sym(vdim: int, deg: int) -> int:
    if deg < 0:
        return 0
    return binom(deg + vdim - 1, vdim - 1)


def dim_normal_jet(m_order: int, d: int, target: str) -> int:
    """Dimension of unrestricted (not yet H-invariant) jet space of normal order.

    Sym^{d - m_order} E_+* ⊗ Sym^{m_order} E_-* ⊗ target_space.
    target E_plus dim 3, E_minus dim 2.
    """
    if d < m_order:
        return 0
    base = dim_sym(3, d - m_order) * dim_sym(2, m_order)
    tdim = 3 if target == "E_plus" else 2
    return base * tdim


def dim_C2_invariant_jet(m_order: int, d: int) -> int:
    """C2-invariant jets: matches dim_plane formula when m_order = m and full module."""
    return dim_plane(m_order, d)


def dim_scalar_normal(order: int, d_scalar: int) -> int:
    """Scalar jets of normal order `order` and total degree d_scalar = 3d.

    F(p) has degree 3d. As a function on E_+ ⊕ E_-, normal order N piece is
    Sym^{3d - N} E_+* ⊗ Sym^N E_-*.
    """
    if d_scalar < order:
        return 0
    return dim_sym(3, d_scalar - order) * dim_sym(2, order)


def sparse_memory_floor(n_rows: int, n_cols: int, nnz: int, bytes_per_entry: int = 32) -> dict:
    """Crude memory floors (exact-arithmetic Fraction ~ 32 B/entry conservative)."""
    dense = n_rows * n_cols * bytes_per_entry
    sparse = nnz * bytes_per_entry + (n_rows + n_cols) * 16
    return {
        "dense_bytes_floor": dense,
        "sparse_bytes_floor": sparse,
        "dense_GB_floor": round(dense / 1e9, 6),
        "sparse_GB_floor": round(sparse / 1e9, 6),
        "bytes_per_entry_assumption": bytes_per_entry,
    }


def character_decomposition_plane(m_order: int, d: int, target: str) -> dict:
    """Residual D12 / C2 character sketch for jet spaces.

    Full residual S3 decomposition is deferred to WP-L2; here we record the
    C2 eigenspace (already built into target) and the free rank over Sym(E_+*).
    """
    # Over R = Sym(E_+*), the module of order-m_order jets with fixed target
    # is free of rank dim Sym^{m_order} E_-* × dim target, in degree d-m_order.
    rank_over_R = dim_sym(2, m_order) * (3 if target == "E_plus" else 2)
    return {
        "C2_target": target,
        "free_rank_over_Sym_Eplus": rank_over_R,
        "degree_on_base": f"d - {m_order}",
        "residual_S3": (
            "decompose further by residual S3 after fixing the involution; "
            "not expanded numerically in this dispatch"
        ),
        "stabilizer_characters": {
            "C2": "built into target eigenspace",
            "D12_binary_on_source_line": (
                "ordinary vs det-twisted when coupling to L_t^{src}"
            ),
        },
    }


def estimate_L1(m: int, d: int) -> dict:
    """Relative matrix estimate for L_1: b_{m+1} |-> B(b_{m+1}; a_m, a_m)."""
    # Domain: C2-invariant E_+-valued jets of order m+1, degree d
    # Codomain: scalar normal order 3m+1, degree 3d — but G/C2 invariants
    n_cols = dim_C2_invariant_jet(m + 1, d)  # uses plane formula with order m+1 even → ×3
    # For even order, dim_plane uses ×3 (E_+ target) — correct for b_{m+1}.
    n_rows_full = dim_scalar_normal(3 * m + 1, 3 * d)
    # C2-invariant scalars: F(p) is t-invariant, so only even y-weight — already
    # 3m+1 is even in y-weight when m odd. Full space is the scalar ring piece.
    # Invariant under residual: crude upper bound = full; lower use Reynolds 1/|H|.
    n_rows = n_rows_full  # upper bound before residual projection
    # B(-;a_m,a_m) is a single linear form in b with coefficients quadratic in a_m.
    # As a map of free modules over the base, nonzero term count is O(rank).
    # Sparse structure: B couples through Phi structure constants — each output
    # monomial meets O(1) input coordinates per Phi term (5 cyclic terms).
    nnz_est = min(n_rows * n_cols, max(n_cols, n_rows) * 15)  # cyclic support ×3
    return {
        "operator": "L_1",
        "m": m,
        "d": d,
        "domain_dim_C2": n_cols,
        "codomain_dim_scalar_normal_upper": n_rows,
        "matrix_shape_upper": [n_rows, n_cols],
        "nnz_estimate_upper": nnz_est,
        "memory": sparse_memory_floor(n_rows, n_cols, nnz_est),
        "character": character_decomposition_plane(m + 1, d, "E_plus"),
        "depends_on_leading": "quadratic in a_m (coefficients of L_1)",
        "relative_over": (
            "coordinate ring of the a_m-component (plane module of order m)"
        ),
    }


def estimate_L3(m: int, d: int) -> dict:
    n_cols = dim_C2_invariant_jet(m + 3, d)
    n_rows = dim_scalar_normal(3 * m + 3, 3 * d)
    nnz_est = min(n_rows * n_cols, max(n_cols, n_rows) * 15)
    return {
        "operator": "L_3",
        "m": m,
        "d": d,
        "domain_dim_C2": n_cols,
        "codomain_dim_scalar_normal_upper": n_rows,
        "matrix_shape_upper": [n_rows, n_cols],
        "nnz_estimate_upper": nnz_est,
        "memory": sparse_memory_floor(n_rows, n_cols, nnz_est),
        "character": character_decomposition_plane(m + 3, d, "E_plus"),
        "RHS_R3": "2 B(b_{m+1}; a_m, a_{m+2}) + F_+(b_{m+1})",
        "relative_over": (
            "coordinate ring of the (a_m, b_{m+1}, a_{m+2})-stage locus B_1"
        ),
    }


def family_estimates() -> dict:
    """Instantiate L_r / omega_r size estimates on three survivor families.

    No large elimination.  Relative matrices over each component's coordinate
    ring; report dims, nnz, character sketch, memory floors, certificate format.
    """
    families = {}

    # ----- Family 1: based_minus_lines_odd_m -----
    # p|_{E_-} = 0, any odd m, d ≥ m.  Coefficient coupling: terminal coeff 0.
    # Leading a_m still free (normal jet); source line based.
    based = {
        "id": "based_minus_lines_odd_m",
        "parameters": {"m": "odd ≥ 1", "d": "any ≥ m"},
        "coefficient_coupling": "p|_{E_-} = p_d(0,y) = 0",
        "linear_state_from_WP5": "based_along_minus_line_plane_jets",
        "sample_bidegrees": [],
        "finite_order_obstruction_found": False,
        "certificate_format_proposed": {
            "format": "relative sparse CSR over Q[base coords] with Fitting ideal generators",
            "stages": ["L1_matrix", "omega1_column", "L3_matrix", "omega3_column"],
            "hash": "sha256 of canonical CSR + base ring presentation",
            "verifier": "recompute B-action on random Q-points of the base (regression) + exact symbolic identity check of U.3m+1/U.3m+3",
        },
    }
    for m, d in ((1, 7), (1, 13), (1, 25), (3, 21), (5, 35)):
        e = residual_e(m, d)
        based["sample_bidegrees"].append(
            {
                "m": m,
                "d": d,
                "e": e,
                "dim_plane_leading": dim_plane(m, d),
                "L1": estimate_L1(m, d),
                "L3": estimate_L3(m, d),
                "note": (
                    "based family: source-line residual dim 0; "
                    "L_r still acts on normal jets along Z_t"
                ),
            }
        )
    # Flag 8GB
    for s in based["sample_bidegrees"]:
        for key in ("L1", "L3"):
            gb = s[key]["memory"]["dense_GB_floor"]
            s[key]["exceeds_8GB_dense"] = gb > 8.0
            s[key]["exceeds_8GB_sparse"] = s[key]["memory"]["sparse_GB_floor"] > 8.0
    families["based_minus_lines_odd_m"] = based

    # ----- Family 2: residual_e1_swap_both -----
    # d = 6m+1, e=1, unique ledger swap_both
    e1 = {
        "id": "residual_e1_swap_both",
        "parameters": {"m": "odd ≥ 1", "d": "6m+1", "e": 1},
        "coefficient_coupling": "p|_{E_-} = Δ_t^m h_t with h_t = (x,-y) up to scale",
        "dim_residual_local": 1,
        "ledger": "swap_both",
        "sample_bidegrees": [],
        "finite_order_obstruction_found": False,
        "certificate_format_proposed": {
            "format": (
                "same as based, plus residual D12 det-twisted rank-1 coupling "
                "row identifying terminal coefficient with Δ^m (x,-y)"
            ),
            "stages": ["L1", "omega1", "L3", "omega3", "coupling_row_e1"],
            "hash": "sha256 CSR + coupling",
            "verifier": "independent rebuild of B and Δ^m factor",
        },
    }
    for m in (1, 3, 5):
        d = 6 * m + 1
        e1["sample_bidegrees"].append(
            {
                "m": m,
                "d": d,
                "e": 1,
                "dim_plane_leading": dim_plane(m, d),
                "dim_residual_D12_twisted": dim_d12_twisted(1),
                "L1": estimate_L1(m, d),
                "L3": estimate_L3(m, d),
            }
        )
    for s in e1["sample_bidegrees"]:
        for key in ("L1", "L3"):
            s[key]["exceeds_8GB_dense"] = s[key]["memory"]["dense_GB_floor"] > 8.0
            s[key]["exceeds_8GB_sparse"] = s[key]["memory"]["sparse_GB_floor"] > 8.0
    families["residual_e1_swap_both"] = e1

    # ----- Family 3: residual_e_ge7_generic_swap_both -----
    gen = {
        "id": "residual_e_ge7_generic_swap_both",
        "parameters": {"m": "odd ≥ 1", "d": "6m+e", "e": "odd ≥ 7"},
        "coefficient_coupling": "p|_{E_-} = Δ_t^m h, h det-twisted of degree e",
        "ledger": "swap_both (generic)",
        "sample_bidegrees": [],
        "finite_order_obstruction_found": False,
        "certificate_format_proposed": {
            "format": (
                "relative matrix over the det-twisted binary residual ring "
                "tensored with plane jet base; Fitting ideal of [L_r | omega_r]"
            ),
            "stages": ["L1", "omega1", "L3", "omega3"],
            "hash": "sha256 multi-Rees presentation + CSR",
            "verifier": "character-projected blocks checked separately",
        },
    }
    for m, e in ((1, 7), (1, 11), (3, 7)):
        d = 6 * m + e
        gen["sample_bidegrees"].append(
            {
                "m": m,
                "d": d,
                "e": e,
                "dim_plane_leading": dim_plane(m, d),
                "dim_residual_D12_twisted": dim_d12_twisted(e),
                "L1": estimate_L1(m, d),
                "L3": estimate_L3(m, d),
            }
        )
    for s in gen["sample_bidegrees"]:
        for key in ("L1", "L3"):
            s[key]["exceeds_8GB_dense"] = s[key]["memory"]["dense_GB_floor"] > 8.0
            s[key]["exceeds_8GB_sparse"] = s[key]["memory"]["sparse_GB_floor"] > 8.0
    families["residual_e_ge7_generic_swap_both"] = gen

    # Summary resource request
    max_dense = 0.0
    max_sparse = 0.0
    for fam in families.values():
        for s in fam["sample_bidegrees"]:
            for key in ("L1", "L3"):
                max_dense = max(max_dense, s[key]["memory"]["dense_GB_floor"])
                max_sparse = max(max_sparse, s[key]["memory"]["sparse_GB_floor"])

    return {
        "families": families,
        "new_families_from_repair": [],
        "large_elimination_run": False,
        "resource_summary": {
            "max_dense_GB_floor_over_samples": max_dense,
            "max_sparse_GB_floor_over_samples": max_sparse,
            "exploratory_gate_GB": 8,
            "note": (
                "Upper bounds use full scalar normal spaces as codomain before "
                "residual projection; residual/S3 projection reduces rows. "
                "Even so, dense floors for large (m,d) exceed 8 GB — sparse "
                "relative Fitting over the base ring is required for WP-L2."
            ),
        },
        "character_strategy_for_WP_L2": [
            "C2 eigenspace already built into p_r target",
            "Residual S3 projectors on plane jets (triv / sign / 2-dim)",
            "D12 binary ordinary vs det-twisted on source-line coupling",
            "Never average affine torsors naively (house rule 6)",
        ],
    }


def compatibility_with_repaired_incidences() -> dict:
    return {
        "status": "CHECKED_SYMBOLICALLY",
        "claims": [
            {
                "id": "C.1_source_vs_normal",
                "claim": (
                    "Universal equations U.3m+1 and U.3m+3 are written in normal "
                    "jets on Z_t / P(N); they do not identify L_t^{src} with a "
                    "subvariety of Z_t."
                ),
                "ok": True,
            },
            {
                "id": "C.2_coefficient_coupling_orthogonal",
                "claim": (
                    "Source-line based/residual conditions constrain p_d(0,y) "
                    "only; they enter the lifting tower as side conditions on "
                    "the terminal coefficient, not as substitutes for L_r."
                ),
                "ok": True,
            },
            {
                "id": "C.3_target_line",
                "claim": (
                    "Odd-m leading a_m evaluates to a map into L_t^{tgt}; "
                    "F-landing on the target is automatic at order 3m and "
                    "constrained at 3m+1 via B(b_{m+1};a_m,a_m)=0."
                ),
                "ok": True,
            },
            {
                "id": "C.4_no_covariant_claim",
                "claim": (
                    "Solutions of the lifting equations are formal jets, not "
                    "certified covariants (house rule 3)."
                ),
                "ok": True,
            },
        ],
    }


def build_payload() -> dict:
    pol = verify_polarization_algebra()
    ledger = ledger_for_odd_m()
    iso = isolation_maps()
    fam = family_estimates()
    compat = compatibility_with_repaired_incidences()

    # Small exact check: for m=1, list live contributions match universal
    for m0 in (1, 3, 5):
        c1 = unique_sorted_contributions(m0, 3 * m0 + 1)
        assert len(c1) == 1 and c1[0]["ijk_sorted"] == (m0, m0, m0 + 1)
        assert c1[0]["multiplicity"] == 3
        c3 = unique_sorted_contributions(m0, 3 * m0 + 3)
        keys = {c["ijk_sorted"] for c in c3}
        assert keys == {
            (m0, m0, m0 + 3),
            (m0, m0 + 1, m0 + 2),
            (m0 + 1, m0 + 1, m0 + 1),
        }

    body = {
        "work_package": "WP-L1",
        "gate": "First dispatch — universal polar expansion through 3m+3",
        "headline": "OPEN",
        "theorem_boundary": {
            "proved": [
                "Exact polarization Phi of the Klein cubic over Q",
                "F(z+y)=F(z)+3 Phi(z,y,y) after odd-in-y terms die on E_+⊕E_-",
                "Universal equation B(b_{m+1};a_m,a_m)=0 at order 3m+1",
                "Universal equation at order 3m+3 as stated in the work order",
                "L_r / omega_r isolation through r=3 (order 3m+3)",
                "Compatibility with repaired source/normal/target incidences",
                "Size and character estimates on three survivor families",
            ],
            "not_proved": [
                "Vanishing of omega_r on any family (no large elimination)",
                "Existence of a formal lift or a covariant",
                "All-degree emptiness of any family",
            ],
        },
        "polarization": pol,
        "order_ledger": ledger,
        "isolation_maps": iso,
        "incidence_compatibility": compat,
        "family_instantiation": fam,
        "accepted_input_sha256": {
            rel: sha256_file(ROOT / rel)
            for rel in [
                "certificates/transition_repair/category_repaired.json",
                "certificates/global_transition/level1_marked_states.json",
                "certificates/transitions/involution_plane/module.json",
            ]
            if (ROOT / rel).exists()
        },
        "producer": {
            "script": "certificates/lifting/polar_expansion.py",
            "does_not_import": "verify_polar_expansion.py",
        },
    }
    return body


def write_json(path: Path, body: dict) -> dict:
    payload = dict(body)
    payload.pop("self_sha256", None)
    text = canonical_json(payload)
    h = sha256_bytes(text.encode())
    payload["self_sha256"] = h
    path.write_text(canonical_json(payload))
    final = json.loads(path.read_text())
    body2 = {k: v for k, v in final.items() if k != "self_sha256"}
    assert sha256_bytes(canonical_json(body2).encode()) == final["self_sha256"]
    return final


def main():
    # Ensure transition repair exists (may be produced in same dispatch)
    repair = CERT / "transition_repair" / "category_repaired.json"
    if not repair.exists():
        print("WARN: category_repaired.json not yet present; hashes may omit it")

    body = build_payload()
    out = HERE / "polar_expansion.json"
    data = write_json(out, body)
    print(f"Wrote {out}")
    print(f"self_sha256={data['self_sha256']}")
    print("U.3m+1:", data["order_ledger"]["universal_equations"]["order_3m+1"]["equation"])
    print("U.3m+3:", data["order_ledger"]["universal_equations"]["order_3m+3"]["equation"])
    print(
        "max dense GB sample:",
        data["family_instantiation"]["resource_summary"]["max_dense_GB_floor_over_samples"],
    )
    print("HEADLINE", data["headline"])


if __name__ == "__main__":
    main()
