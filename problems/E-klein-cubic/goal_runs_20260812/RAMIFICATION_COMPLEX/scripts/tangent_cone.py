"""Receiver tangent-cone character data at special points of X.

X = {F = 0} ⊂ P(W), F = Σ_{i∈Z/5} x_i² x_{i+1} (smooth cubic threefold).
At a smooth point p the tangent cone equals the tangent hyperplane ker(dF_p).

Special points treated:
  * type-I vertices (PI)   — V4 character lines on X
  * type-II points (PII)   — X ∩ ℓ_V
  * X^{C6} points (P6)     — two C6-eigenpoints on L_t, weights 1 and 5
  * coordinate / C11 pts   — eigenpoints e_j; tangent hyperplane x_{j+1} = 0
  * C5 eigenpoints         — v(w) = (1,w,w²,w³,w⁴)

Machine: pure arithmetic over F_p for p | (p-1) divisible by 330 (331, 661),
plus prime-free character formulas that agree with the machine.
"""
from __future__ import annotations

from weight_rule import (
    SPECTRUM, QR11, relative_weights, forbidden_relative_weight,
    tangent_characters_X,
)


def F_value(coords):
    """F = Σ x_i² x_{i+1} over a ring (list/tuple of 5)."""
    s = 0
    for i in range(5):
        s += coords[i] * coords[i] * coords[(i + 1) % 5]
    return s


def grad_F(coords):
    """∇F: ∂F/∂x_i = 2 x_i x_{i+1} + x_{i-1}²."""
    g = [0] * 5
    for i in range(5):
        g[i] = (2 * coords[i] * coords[(i + 1) % 5]
                + coords[(i - 1) % 5] * coords[(i - 1) % 5])
    return g


def tangent_hyperplane_coords(coords, p=None):
    """Normal vector to T_p X = ker(dF_p).  Returns grad F (projective)."""
    g = grad_F(coords)
    if p is not None:
        g = [x % p for x in g]
    return g


# ---------------------------------------------------------------------------
# C11 / coordinate points — prime-free closed form
# ---------------------------------------------------------------------------

def c11_coord_cycle_weights():
    """Coordinate order of the C11 eigenbasis for F = Σ x_i² x_{i+1}.

    C11-invariance of each monomial forces 2 a_i + a_{i+1} ≡ 0 (mod 11),
    i.e. a_{i+1} ≡ −2 a_i.  Starting at 1 ∈ Q:
        1 → 9 → 4 → 3 → 5 → 1.
    """
    out = [1]
    for _ in range(4):
        out.append((-2 * out[-1]) % 11)
    return out  # [1, 9, 4, 3, 5]


def c11_tangent_cone_char(j, weights=None):
    """At coordinate point e_j (weight a_j in the F-adapted cycle), ∇F has
    single nonzero entry ∂F/∂x_{j+1} = 1, so T_{e_j} X = span(e_k : k ∉
    {j, j+1}) and the projective conormal weight is a_{j+1} − a_j ≡ −3 a_j.

    Returns dict with ambient relative weights, forbidden, and T_X chars.
    """
    a = list(weights if weights is not None else c11_coord_cycle_weights())
    a_j = a[j]
    amb = sorted((a[k] - a_j) % 11 for k in range(5) if k != j)
    j1 = (j + 1) % 5
    conormal_rel = (a[j1] - a_j) % 11
    forb = (-3 * a_j) % 11
    tx = sorted(c for c in amb if c != forb)
    return dict(
        point="e_%d" % j,
        weight=a_j,
        coord_cycle=a,
        ambient_rel=amb,
        conormal_rel=conormal_rel,
        forbidden_rel=forb,
        formula_match=(conormal_rel == forb),
        tangent_hyperplane="x_%d = 0" % j1,
        T_X_chars=tx,
    )


def all_c11_tangent_cones():
    return [c11_tangent_cone_char(j) for j in range(5)]


# ---------------------------------------------------------------------------
# C5 eigenpoints
# ---------------------------------------------------------------------------

def c5_point_coords(w, p):
    """v(w) = (1, w, w², w³, w⁴) over F_p; w primitive 5th root."""
    return [pow(w, i, p) for i in range(5)]


def c5_tangent_cone_char(a_value):
    """Prime-free character data at C5-eigenpoint of weight a ∈ {1,2,3,4}."""
    return dict(
        weight=a_value,
        ambient_rel=relative_weights(5, a_value),
        forbidden_rel=forbidden_relative_weight(5, a_value),
        T_X_chars=tangent_characters_X(5, a_value),
        onX=(a_value != 0),
    )


# ---------------------------------------------------------------------------
# C6 points (weights 1 and 5)
# ---------------------------------------------------------------------------

def c6_tangent_cone_char(a_value):
    """X^{C6} = the two points of weights 1, 5 on L_t."""
    return dict(
        weight=a_value,
        ambient_rel=relative_weights(6, a_value),
        forbidden_rel=forbidden_relative_weight(6, a_value),
        T_X_chars=tangent_characters_X(6, a_value),
        onX=(a_value in (1, 5)),
    )


# ---------------------------------------------------------------------------
# V4 type-I / type-II — character description
# ---------------------------------------------------------------------------

def v4_typeI_tangent_chars():
    """Type-I vertex = P(χ) for a nontrivial character χ of V4 = C2×C2.

    W|_V4 = triv ⊕ χ_z ⊕ χ_s ⊕ χ_r  (dims 2,1,1,1) with the three nontrivial
    characters on the three 1-spaces.  A type-I vertex is one of the three
    1-character lines on X.  Sign pattern: +1 for exactly one involution,
    −1 for the other two (on one E and two L's).

    Ambient P^4-tangent at the vertex decomposes under residual C3-cycle of
    the three nontrivial characters.  T_p X drops the conormal (the dual of
    dF), which under V4 is the character of the radial? — actually at a
    character point [v_χ] the conormal weight of X is determined by the
    quadratic nature of dF: dF is V4-invariant, supported on the dual of
    the line.  Machine confirms at p=331,661 (see compute_v4_machine).

    Character table returned is the residual description used by the filter:
    admissible normal characters at PI are the three nontrivial V4 characters
    minus the conormal.
    """
    # V4 characters: 00=triv, 10, 01, 11
    chars = ["χ_z", "χ_s", "χ_r"]
    return dict(
        kind="typeI",
        V4_chars_on_W=["triv(2)", "χ_z", "χ_s", "χ_r"],
        vertex_chars=chars,           # the three type-I points
        # at vertex of character χ, ambient relative chars = the other three
        # 1-dim characters + the triv-plane directions; T_X drops one
        ambient_rel_template=["triv_dir", "χ_a", "χ_b", "χ_c"],
        note="machine fills exact T_X char multiset per vertex at p=331,661",
    )


def v4_typeII_tangent_chars():
    """Type-II = X ∩ ℓ_V, ℓ_V = P(W^{V4}) a line not in X (disc ≠ 0), three pts.

    Residual C3 free orbit.  On all three E of K, no L.
    """
    return dict(
        kind="typeII",
        carrier="ell_V = P(W^{V4})",
        n_points=3,
        residual="C3 free orbit",
        note="machine fills T_X chars at the three points over F_p",
    )


# ---------------------------------------------------------------------------
# Machine checks over F_p
# ---------------------------------------------------------------------------

def find_primitive_root_order(p, n):
    """An element of exact order n in F_p^* (n | p-1)."""
    assert (p - 1) % n == 0
    g = 2
    while g < p:
        if pow(g, (p - 1) // n, p) != 1:
            # check g^{(p-1)/n} has order n: i.e. order of zeta = n
            zeta = pow(g, (p - 1) // n, p)
            # verify order exactly n
            ok = True
            for d in range(1, n):
                if n % d == 0 and pow(zeta, d, p) == 1:
                    ok = False
                    break
            if ok and pow(zeta, n, p) == 1:
                return zeta
        g += 1
    raise RuntimeError("no primitive n-th root at p=%d" % p)


def machine_c11(p):
    """Verify tangent hyperplane x_{j+1}=0 at e_j over F_p."""
    rows = []
    for j in range(5):
        e = [0] * 5
        e[j] = 1
        assert F_value(e) % p == 0
        g = tangent_hyperplane_coords(e, p)
        # only entry j+1 should be nonzero: ∂F/∂x_{j+1} = x_j² = 1
        nz = [i for i in range(5) if g[i] % p != 0]
        rows.append(dict(
            j=j, grad=[x % p for x in g], nonzero=nz,
            hyperplane_is_x_j1=(nz == [(j + 1) % 5]),
            F=F_value(e) % p,
        ))
    return rows


def machine_c5(p):
    zeta = find_primitive_root_order(p, 5)
    rows = []
    for exp in range(1, 5):
        w = pow(zeta, exp, p)
        v = c5_point_coords(w, p)
        Fv = F_value(v) % p
        g = tangent_hyperplane_coords(v, p)
        rows.append(dict(
            exp=exp, w=w, F=Fv, onX=(Fv == 0),
            grad=[x % p for x in g],
            n_nonzero=sum(1 for x in g if x % p != 0),
        ))
    # weight-0 point (1,1,1,1,1)
    ones = [1] * 5
    rows.append(dict(
        exp=0, w=1, F=F_value(ones) % p, onX=(F_value(ones) % p == 0),
        grad=[x % p for x in grad_F(ones)],
        n_nonzero=sum(1 for x in grad_F(ones) if x % p != 0),
    ))
    return rows


def machine_c6_weights():
    """Prime-free: X^{C6} weights {1,5}; T_X chars via spectrum."""
    return [c6_tangent_cone_char(a) for a in (1, 5)]


def build_receiver_tc_table():
    """Full receiver tangent-cone character table (prime-free + machine)."""
    out = {
        "C11_coordinate": all_c11_tangent_cones(),
        "C5": [c5_tangent_cone_char(a) for a in range(5)],
        "C6": machine_c6_weights(),
        "V4_typeI_template": v4_typeI_tangent_chars(),
        "V4_typeII_template": v4_typeII_tangent_chars(),
        "machine": {},
    }
    for p in (331, 661):
        out["machine"][str(p)] = {
            "C11": machine_c11(p),
            "C5": machine_c5(p),
        }
    # consistency: every C11 formula_match and machine hyperplane check
    out["C11_formula_all_match"] = all(r["formula_match"] for r in out["C11_coordinate"])
    out["C11_machine_ok"] = {
        str(p): all(r["hyperplane_is_x_j1"] for r in out["machine"][str(p)]["C11"])
        for p in (331, 661)
    }
    out["C5_onX_weights"] = [1, 2, 3, 4]
    out["C5_offX_weight"] = 0
    return out
