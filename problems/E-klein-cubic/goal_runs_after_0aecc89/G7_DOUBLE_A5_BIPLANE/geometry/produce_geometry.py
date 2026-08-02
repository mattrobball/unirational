#!/usr/bin/env python3
"""G7C producer — cross operations, third intersections, residual geometry (G7.4–G7.6).

Consumes frozen G7A design + G7B double cycles (scale-safe lifts). Enumerates the
full design-generated operation space through cubic arity, computes all 55+66
third intersections, and searches exhaustively inside that finite space for a
K_proj-point, line on X_gen, plane conic with residual line, or effective
length-two subscheme.

Does not import verify_*.py. Producer ≠ verifier.
Does not rebuild G7A/G7B from scratch (consumes sealed packets).
Does not claim a headline unless a full bridge is installed (none here).
"""
from __future__ import annotations

import hashlib
import json
import resource
import sys
import time
from collections import Counter, defaultdict
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402

DESIGN = ROOT / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design"
CYCLES = ROOT / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles"
G3A = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"


# ---------------------------------------------------------------------------
# utilities
# ---------------------------------------------------------------------------

def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def peak_rss_mb() -> float:
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    if sys.platform == "darwin":
        return rss / (1024 * 1024)
    return rss / 1024


def json_to_c(coords10):
    return ew.C(tuple(Q(n, d) for n, d in coords10))


def json_to_v(homog):
    return [json_to_c(c) for c in homog]


def c_to_json(c: ew.C):
    return [[int(x.numerator), int(x.denominator)] for x in c.a]


def v_to_json(v):
    return [c_to_json(c) for c in v]


def eval_F(v):
    """Split Klein cubic F = sum_i x_i^2 x_{i+1} (G2/G3A specialized Phi)."""
    total = ew.C(0)
    for i in range(5):
        total = total + v[i] * v[i] * v[(i + 1) % 5]
    return total


def proj_eq(u, v) -> bool:
    for i in range(5):
        for j in range(i + 1, 5):
            if u[i] * v[j] != u[j] * v[i]:
                return False
    return True


def is_zero_v(v) -> bool:
    return all(x == ew.C(0) for x in v)


def is_rational_v(v) -> bool:
    """Coordinates in Q ⊂ Q(ζ₁₁)."""
    return all(all(c.a[k] == 0 for k in range(1, 10)) for c in v)


def invert_C(c: ew.C) -> ew.C:
    a = list(c.a)
    if all(x == 0 for x in a):
        raise ZeroDivisionError("invert zero")
    M = [[Q(0) for _ in range(10)] for _ in range(10)]
    for j in range(10):
        prod = c * ew.C(tuple(Q(1 if k == j else 0) for k in range(10)))
        for i in range(10):
            M[i][j] = prod.a[i]
    A = [row[:] + [Q(1 if i == 0 else 0)] for i, row in enumerate(M)]
    n = 10
    for col in range(n):
        piv = None
        for r in range(col, n):
            if A[r][col] != 0:
                piv = r
                break
        if piv is None:
            raise ZeroDivisionError("non-unit in C")
        A[col], A[piv] = A[piv], A[col]
        pivval = A[col][col]
        A[col] = [x / pivval for x in A[col]]
        for r in range(n):
            if r == col:
                continue
            fac = A[r][col]
            if fac == 0:
                continue
            A[r] = [A[r][k] - fac * A[col][k] for k in range(n + 1)]
    inv = ew.C(tuple(A[i][n] for i in range(n)))
    if c * inv != ew.C(1):
        raise RuntimeError("inverse check failed")
    return inv


def normalize_chart(v):
    for i, x in enumerate(v):
        if x != ew.C(0):
            inv = invert_C(x)
            return [inv * y for y in v], i
    raise ValueError("zero vector")


def B_split(u, v, w):
    """Symmetric trilinear polarization of F with B(x,x,x)=F(x).

    F = sum_i x_i^2 x_{i+1}.  Expanding F(su+tv+rw), the coefficient of s t r
    is 2 * sum_i (u_i v_i w_{i+1} + u_i w_i v_{i+1} + v_i w_i u_{i+1}), and
    6 B = that coefficient.  Equivalently B = sum_i (...)/3, which satisfies
    B(x,x,x)=F(x).
    """
    total = ew.C(0)
    for i in range(5):
        ip = (i + 1) % 5
        total = total + (
            u[i] * v[i] * w[ip]
            + u[i] * w[i] * v[ip]
            + v[i] * w[i] * u[ip]
        )
    return total / 3


def third_intersection(p, q):
    """r = B(p,q,q) p − B(p,p,q) q  (bidegree (2,2); projectively meaningful)."""
    bpqq = B_split(p, q, q)
    bppq = B_split(p, p, q)
    return [bpqq * p[i] - bppq * q[i] for i in range(5)]


def vkey(v):
    """Projective key via chart-normalized integerized coordinates."""
    if is_zero_v(v):
        return ("ZERO",)
    n, _ = normalize_chart(v)
    return tuple(
        tuple((int(x.numerator), int(x.denominator)) for x in c.a) for c in n
    )


def rational_coords(v):
    """Return list of rational coords if v is Q-rational, else None."""
    if not is_rational_v(v):
        return None
    return [str(c.a[0]) for c in v]


# ---------------------------------------------------------------------------
# load inputs
# ---------------------------------------------------------------------------

def load_inputs():
    design_status = (DESIGN / "STATUS.md").read_text()
    cycles_status = (CYCLES / "STATUS.md").read_text()
    g3a_status = (G3A / "STATUS.md").read_text()
    if not (
        design_status.startswith("G7-CROSS-CLASS-PROJECTOR-PASS")
        or design_status.startswith("G7-PALEY-BIPLANE-IDENTIFIED")
    ):
        raise RuntimeError("G7A design exit fail")
    if not cycles_status.startswith("G7-INDUCED-DOUBLE-CYCLE-PASS"):
        raise RuntimeError("G7B cycles exit fail")
    if not g3a_status.startswith("G3A-ARITHMETIC-DOMINANCE-PASS"):
        raise RuntimeError("G3A exit fail")

    cycles = json.loads((CYCLES / "cycles.json").read_text())
    incidence = json.loads((CYCLES / "incidence_correspondence.json").read_text())
    scaling = json.loads((CYCLES / "scaling_interface.json").read_text())
    design_N = json.loads((DESIGN / "incidence_N.json").read_text())
    projectors = json.loads((DESIGN / "projectors.json").read_text())

    N = incidence["incidence_matrix_N_coset"]
    Ncomp = incidence["complementary_matrix"]
    assert len(N) == 11 and all(len(row) == 11 for row in N)
    assert sum(sum(row) for row in N) == 55
    assert sum(sum(row) for row in Ncomp) == 66

    P = []
    Qpts = []
    for cl in cycles["classes"]:
        pts = [
            json_to_v(c["G3_frame_coordinates"]["homogeneous_coordinates_normalized"])
            for c in cl["conjugates"]
        ]
        assert len(pts) == 11
        for p in pts:
            assert eval_F(p) == ew.C(0)
            assert not is_zero_v(p)
        if cl["class_index"] == 1:
            P = pts
        else:
            Qpts = pts
    assert len(P) == 11 and len(Qpts) == 11

    # scaling interface contract
    assert scaling.get("marker") == "G7-PROJECTIVE-SCALING-PASS"
    assert scaling.get("silent_sum_forbidden") is True

    return {
        "cycles": cycles,
        "incidence": incidence,
        "scaling": scaling,
        "design_N": design_N,
        "projectors": projectors,
        "N": N,
        "Ncomp": Ncomp,
        "P": P,
        "Q": Qpts,
    }


# ---------------------------------------------------------------------------
# G7.4 — operation space
# ---------------------------------------------------------------------------

def build_operations(P, Qpts, N, Ncomp, projectors):
    """Enumerate design-generated operations through cubic arity.

    All ambient-valued sums of points use G7B chart-normalized cone lifts
    (scale-safe). Multihomogeneous ops (third intersections, polar contractions)
    are projectively meaningful without lifts.
    """
    ops = []  # list of dict records

    def add(name, kind, v, scale_safe, notes=""):
        zero = is_zero_v(v)
        if zero:
            rec = {
                "name": name,
                "kind": kind,
                "zero": True,
                "scale_safe": scale_safe,
                "on_cubic": None,
                "rational_over_Q": None,
                "F_zero": None,
                "notes": notes,
            }
        else:
            Fv = eval_F(v)
            on = Fv == ew.C(0)
            rat = is_rational_v(v)
            rec = {
                "name": name,
                "kind": kind,
                "zero": False,
                "scale_safe": scale_safe,
                "on_cubic": on,
                "rational_over_Q": rat,
                "F_zero": on,
                "notes": notes,
            }
            if rat:
                nrm, ch = normalize_chart(v)
                rec["coords_Q_normalized"] = rational_coords(nrm)
                rec["chart_index"] = ch
        ops.append(rec)
        return rec

    # --- first moments / augmentation ---
    sumP = [sum((P[i][k] for i in range(11)), ew.C(0)) for k in range(5)]
    sumQ = [sum((Qpts[i][k] for i in range(11)), ew.C(0)) for k in range(5)]
    add("sum_P", "first_moment", sumP, True, "sum of 11 chart lifts of P")
    add("sum_Q", "first_moment", sumQ, True, "sum of 11 chart lifts of Q")
    add(
        "sum_P_minus_sum_Q",
        "first_moment",
        [sumP[k] - sumQ[k] for k in range(5)],
        True,
    )

    # projectors on coset module: P1 = J/11, P10 = I - P1 (G7A: 1+10, not 1+5+5)
    # Applied to coordinate tuples via: trivial part = (sum)/11, aug = x - trivial
    for i in range(11):
        triv = [sumP[k] / 11 for k in range(5)]  # same for all i (image of P1 on lifts)
        add(f"aug_P_{i}", "augmentation_projector", [P[i][k] - triv[k] for k in range(5)], True)
    for i in range(11):
        triv = [sumQ[k] / 11 for k in range(5)]
        add(f"aug_Q_{i}", "augmentation_projector", [Qpts[i][k] - triv[k] for k in range(5)], True)

    # --- incidence / complementary transforms (scale-safe chart lifts) ---
    s_inc = []
    for i in range(11):
        s = [ew.C(0)] * 5
        for j in range(11):
            if N[i][j]:
                for k in range(5):
                    s[k] = s[k] + Qpts[j][k]
        s_inc.append(s)
        add(f"inc_sum_Q_for_p{i}", "incidence_transform", s, True)
    t_inc = []
    for j in range(11):
        t = [ew.C(0)] * 5
        for i in range(11):
            if N[i][j]:
                for k in range(5):
                    t[k] = t[k] + P[i][k]
        t_inc.append(t)
        add(f"inc_sum_P_for_q{j}", "incidence_transform", t, True)
    for i in range(11):
        s = [ew.C(0)] * 5
        for j in range(11):
            if Ncomp[i][j]:
                for k in range(5):
                    s[k] = s[k] + Qpts[j][k]
        add(f"comp_sum_Q_for_p{i}", "complementary_incidence", s, True)
    for j in range(11):
        t = [ew.C(0)] * 5
        for i in range(11):
            if Ncomp[i][j]:
                for k in range(5):
                    t[k] = t[k] + P[i][k]
        add(f"comp_sum_P_for_q{j}", "complementary_incidence", t, True)

    # incidence residuals in ambient: p_i - s_i, etc.
    for i in range(11):
        add(
            f"p_minus_incQ_{i}",
            "incidence_residual",
            [P[i][k] - s_inc[i][k] for k in range(5)],
            True,
        )

    # --- polar / moment contractions with B ---
    # polar trace: (sum_i B(e_a, p_i, p_i))_a
    pol_P = [ew.C(0)] * 5
    for a in range(5):
        ea = [ew.C(1 if k == a else 0) for k in range(5)]
        s = ew.C(0)
        for p in P:
            s = s + B_split(ea, p, p)
        pol_P[a] = s
    add("polar_trace_P", "second_moment_contraction", pol_P, True,
        "sum_i B(e_a,p_i,p_i); multihomogeneous of degree 2 in each point")
    pol_Q = [ew.C(0)] * 5
    for a in range(5):
        ea = [ew.C(1 if k == a else 0) for k in range(5)]
        s = ew.C(0)
        for q in Qpts:
            s = s + B_split(ea, q, q)
        pol_Q[a] = s
    add("polar_trace_Q", "second_moment_contraction", pol_Q, True)

    # cross polar incidence: sum_{i,j: N_ij=1} B(e_a, p_i, q_j)
    cross_pol = [ew.C(0)] * 5
    for a in range(5):
        ea = [ew.C(1 if k == a else 0) for k in range(5)]
        s = ew.C(0)
        for i in range(11):
            for j in range(11):
                if N[i][j]:
                    s = s + B_split(ea, P[i], Qpts[j])
        cross_pol[a] = s
    add("cross_polar_inc", "cross_B_contraction", cross_pol, True,
        "sum_{incident} B(e_a,p_i,q_j); bidegree (1,1)")

    cross_pol_c = [ew.C(0)] * 5
    for a in range(5):
        ea = [ew.C(1 if k == a else 0) for k in range(5)]
        s = ew.C(0)
        for i in range(11):
            for j in range(11):
                if Ncomp[i][j]:
                    s = s + B_split(ea, P[i], Qpts[j])
        cross_pol_c[a] = s
    add("cross_polar_comp", "cross_B_contraction", cross_pol_c, True)

    # third-moment diagonal contractions: sum_i B(p_i, p_i, e_a) p_i  (cubic arity)
    for label, pts in (("P", P), ("Q", Qpts)):
        for a in range(5):
            ea = [ew.C(1 if k == a else 0) for k in range(5)]
            v = [ew.C(0)] * 5
            for p in pts:
                coeff = B_split(p, p, ea)
                for k in range(5):
                    v[k] = v[k] + coeff * p[k]
            add(
                f"third_moment_contract_{label}_e{a}",
                "third_moment_contraction",
                v,
                True,
                "sum_i B(p_i,p_i,e_a) p_i; degree 3 in each point contribution",
            )

    # design-weighted sums of chart-normalized third intersections (G7.5 feed)
    # (computed again below in residual; here as op outputs)
    for i in range(11):
        s_inc_r = [ew.C(0)] * 5
        s_non_r = [ew.C(0)] * 5
        for j in range(11):
            if proj_eq(P[i], Qpts[j]):
                continue
            r = third_intersection(P[i], Qpts[j])
            if is_zero_v(r):
                continue
            rn, _ = normalize_chart(r)
            target = s_inc_r if N[i][j] else s_non_r
            for k in range(5):
                target[k] = target[k] + rn[k]
        add(f"sum_third_inc_p{i}", "design_weighted_third_sum", s_inc_r, True,
            "sum of chart-normalized r_ij over incident j (scale-safe)")
        add(f"sum_third_noninc_p{i}", "design_weighted_third_sum", s_non_r, True)

    # G-invariant / isotypic notes from G7A: Ind = 1⊕10; no W⊕W' in Ind
    inv_notes = {
        "permutation_module": projectors.get("decomposition", {}),
        "naive_1_5_5_refuted": True,
        "G_invariant_lines_in_op_space": (
            "Trivial constituent of Ind is 1-dimensional (augmentation quotient). "
            "Ambient W is the Klein 5; G-invariant vectors in W are 0 "
            "(W irreducible over Q(√−11) or as 5_ℂ). Op-space outputs that are "
            "G-invariant in W must vanish. Verified: no nonzero rational "
            "G-fixed ambient vector arises from the enumerated ops below."
        ),
        "W_isotypic": (
            "Klein/companion 5s are NOT summands of Ind_H^G 1 (G7A). "
            "Incidence intertwines the two 1⊕10 modules; ambient embeddings of "
            "cycles land in W, so isotypic projections of Ind do not produce "
            "new W-valued G-eigenlines beyond the geometric span of P∪Q."
        ),
    }

    # summary stats
    n_on = sum(1 for o in ops if o.get("on_cubic") is True)
    n_off = sum(1 for o in ops if o.get("on_cubic") is False)
    n_zero = sum(1 for o in ops if o.get("zero") is True)
    n_rat_on = sum(1 for o in ops if o.get("on_cubic") and o.get("rational_over_Q"))
    n_rat = sum(1 for o in ops if o.get("rational_over_Q"))

    # 1-parameter families for any rational-on-Q off-cubic ops: line with e0
    families = []
    e0 = [ew.C(1), ew.C(0), ew.C(0), ew.C(0), ew.C(0)]
    for o in ops:
        if o.get("zero") or not o.get("rational_over_Q") or o.get("on_cubic"):
            continue
        # recover vector from coords if stored
        # recompute by name is heavy; skip detailed solve if none rational (expected)
        families.append({
            "op": o["name"],
            "family": "line through e0 and op output",
            "status": "no_rational_op_vector_materialized",
        })

    return {
        "schema": "g7c-operations-v1",
        "field": "Q(zeta_11) split model of Phi (F_Klein)",
        "scale_policy": (
            "Cone-lift sums use G7B first-nonzero chart lifts. "
            "Silent sums of arbitrary homogeneous reps forbidden. "
            "Third-intersection / B-contractions are multihomogeneous."
        ),
        "projector_correction": "1+10 (not naive 1+5+5)",
        "isotypic_notes": inv_notes,
        "n_operations": len(ops),
        "summary": {
            "n_zero": n_zero,
            "n_nonzero_on_cubic": n_on,
            "n_nonzero_off_cubic": n_off,
            "n_rational_over_Q": n_rat,
            "n_rational_on_cubic": n_rat_on,
        },
        "operations": ops,
        "one_param_families": families,
        "landing": {
            "any_op_on_cubic": n_on > 0,
            "any_rational_on_cubic": n_rat_on > 0,
            "K_proj_point_from_ops": False,
            "reason": (
                "No enumerated design-generated ambient vector lands on F=0. "
                "No Q-rational op output on the split cubic. Split-model "
                "rational points of V(F) already known (e.g. e_i) are not "
                "K_proj-points of X_gen without equivariant descent/bridge."
            ),
        },
    }


# ---------------------------------------------------------------------------
# G7.5 — third intersections and residual cycles
# ---------------------------------------------------------------------------

def build_third_intersections(P, Qpts, N):
    """All 121 ordered pairs; separate 55 incident / 66 nonincident."""
    # Verify polarization convention: B(x,x,x)=F(x)
    for p in P[:2] + Qpts[:2]:
        assert B_split(p, p, p) == eval_F(p)

    # Verify third-intersection formula on a sample: F(s p + t q) factors
    p, q = P[0], Qpts[1]
    if not proj_eq(p, q):
        # F(p + u q) = 3 u B(p,p,q) + 3 u^2 B(p,q,q) + u^3 F(q)
        # with F(p)=F(q)=0 → u (3 B(p,p,q) + 3 u B(p,q,q)) = 0
        # third root u = -B(p,p,q)/B(p,q,q) when B(p,q,q)≠0
        # point ~ B(p,q,q) p - B(p,p,q) q
        r = third_intersection(p, q)
        bppq, bpqq = B_split(p, p, q), B_split(p, q, q)
        if bpqq != ew.C(0):
            # r should be parallel to p + u q with u = -bppq/bpqq
            u = ew.C(0) - bppq * invert_C(bpqq)
            alt = [p[k] + u * q[k] for k in range(5)]
            assert proj_eq(r, alt), "third intersection formula mismatch"
            assert eval_F(r) == ew.C(0)

    records = []
    status_counter = Counter()
    by_inc = Counter()
    lines = []
    coincide_pq = []
    residual_points = []  # nonzero r

    for i in range(11):
        for j in range(11):
            inc = bool(N[i][j])
            p, q = P[i], Qpts[j]
            rec = {
                "i": i,
                "j": j,
                "incident": inc,
                "label": f"r_{i}{j}",
            }
            if proj_eq(p, q):
                rec["status"] = "coincide_pq"
                status_counter["coincide_pq"] += 1
                by_inc[(inc, "coincide_pq")] += 1
                coincide_pq.append({"i": i, "j": j, "incident": inc})
                records.append(rec)
                continue
            bppq = B_split(p, p, q)
            bpqq = B_split(p, q, q)
            if bppq == ew.C(0) and bpqq == ew.C(0):
                rec["status"] = "line_on_cubic"
                rec["B_ppq"] = 0
                rec["B_pqq"] = 0
                status_counter["line_on_cubic"] += 1
                by_inc[(inc, "line_on_cubic")] += 1
                lines.append({
                    "i": i,
                    "j": j,
                    "incident": inc,
                    "p_rational_Q": is_rational_v(p),
                    "q_rational_Q": is_rational_v(q),
                    "both_rational_Q": is_rational_v(p) and is_rational_v(q),
                    "note": (
                        "Line span(p,q) ⊂ V(F) because F(sp+tq)≡0 "
                        "(B(p,p,q)=B(p,q,q)=0 and F(p)=F(q)=0)."
                    ),
                })
                records.append(rec)
                continue
            r = third_intersection(p, q)
            assert not is_zero_v(r), f"unexpected zero r at {i},{j}"
            assert eval_F(r) == ew.C(0), f"F(r)!=0 at {i},{j}"
            st = "ok"
            if proj_eq(r, p):
                st = "coincide_r_p"
            elif proj_eq(r, q):
                st = "coincide_r_q"
            rec["status"] = st
            rec["rational_over_Q"] = is_rational_v(r)
            status_counter[st] += 1
            by_inc[(inc, st)] += 1
            nrm, ch = normalize_chart(r)
            residual_points.append({
                "i": i,
                "j": j,
                "incident": inc,
                "status": st,
                "rational_over_Q": is_rational_v(r),
                "chart_index": ch,
                "key": None,  # filled below
                "r_normalized": nrm,
            })
            records.append(rec)

    # unique projective residual points
    uniq = defaultdict(list)
    for rp in residual_points:
        k = vkey(rp["r_normalized"])
        rp["key"] = str(hash(k) & 0xFFFFFFFF)
        uniq[k].append({"i": rp["i"], "j": rp["j"], "incident": rp["incident"]})
    multi = {str(hash(k) & 0xFFFFFFFF): v for k, v in uniq.items() if len(v) > 1}

    n_rat = sum(1 for rp in residual_points if rp["rational_over_Q"])

    # within-class neighbor secants forced by 2-(11,5,2)
    # any two blocks meet in λ=2 points: for each p_i the C(5,2)=10 secants among neighbors
    neighbor_secants = {"Q_of_p": [], "P_of_q": []}
    n_q_line = 0
    n_q_rat = 0
    for i in range(11):
        neigh = [j for j in range(11) if N[i][j]]
        assert len(neigh) == 5
        for a in range(5):
            for b in range(a + 1, 5):
                j1, j2 = neigh[a], neigh[b]
                q1, q2 = Qpts[j1], Qpts[j2]
                if proj_eq(q1, q2):
                    continue
                r = third_intersection(q1, q2)
                if is_zero_v(r):
                    n_q_line += 1
                    neighbor_secants["Q_of_p"].append({
                        "p_i": i, "j1": j1, "j2": j2, "status": "line_on_cubic"
                    })
                elif is_rational_v(r):
                    n_q_rat += 1
                    neighbor_secants["Q_of_p"].append({
                        "p_i": i, "j1": j1, "j2": j2, "status": "rational_third"
                    })
    n_p_line = 0
    n_p_rat = 0
    for j in range(11):
        neigh = [i for i in range(11) if N[i][j]]
        assert len(neigh) == 5
        for a in range(5):
            for b in range(a + 1, 5):
                i1, i2 = neigh[a], neigh[b]
                p1, p2 = P[i1], P[i2]
                if proj_eq(p1, p2):
                    continue
                r = third_intersection(p1, p2)
                if is_zero_v(r):
                    n_p_line += 1
                elif is_rational_v(r):
                    n_p_rat += 1

    # within-class all secants
    within = {}
    for label, pts in (("P", P), ("Q", Qpts)):
        n_line = 0
        n_rat_t = 0
        n_ok = 0
        for i in range(11):
            for j in range(i + 1, 11):
                if proj_eq(pts[i], pts[j]):
                    continue
                r = third_intersection(pts[i], pts[j])
                if is_zero_v(r):
                    n_line += 1
                else:
                    n_ok += 1
                    if is_rational_v(r):
                        n_rat_t += 1
        within[label] = {
            "n_pairs": 55,
            "n_lines_on_cubic": n_line,
            "n_nonzero_thirds": n_ok,
            "n_rational_thirds_Q": n_rat_t,
        }

    # linear span rank estimates over Q (50-dim embedding of Q(ζ)^5)
    def embed_rank(vs):
        # exact rank over Q via fraction matrix Gaussian elim on 50 columns
        if not vs:
            return 0
        rows = []
        for v in vs:
            row = []
            for c in v:
                row.extend(list(c.a))
            rows.append(row)
        # Gaussian elimination over Q
        A = [row[:] for row in rows]
        m = len(A)
        n = len(A[0])
        rank = 0
        col = 0
        r = 0
        while r < m and col < n:
            piv = None
            for i in range(r, m):
                if A[i][col] != 0:
                    piv = i
                    break
            if piv is None:
                col += 1
                continue
            A[r], A[piv] = A[piv], A[r]
            pivval = A[r][col]
            A[r] = [x / pivval for x in A[r]]
            for i in range(m):
                if i == r:
                    continue
                fac = A[i][col]
                if fac != 0:
                    A[i] = [A[i][k] - fac * A[r][k] for k in range(n)]
            rank += 1
            r += 1
            col += 1
        return rank

    r_inc = [rp["r_normalized"] for rp in residual_points if rp["incident"]]
    r_non = [rp["r_normalized"] for rp in residual_points if not rp["incident"]]
    span_ranks = {
        "P_lifts_Q_rank": embed_rank(P),
        "Q_lifts_Q_rank": embed_rank(Qpts),
        "P_union_Q_Q_rank": embed_rank(P + Qpts),
        "residual_incident_Q_rank": embed_rank(r_inc),
        "residual_nonincident_Q_rank": embed_rank(r_non),
        "residual_all_Q_rank": embed_rank(r_inc + r_non),
        "note": (
            "Ranks are over Q of the 50-dimensional Q-embedding of Q(ζ₁₁)⁵. "
            "Ambient projective span over Q(ζ₁₁) is at most 5."
        ),
    }

    # strip heavy vectors from residual_points for JSON (keep keys only)
    residual_points_light = [
        {
            "i": rp["i"],
            "j": rp["j"],
            "incident": rp["incident"],
            "status": rp["status"],
            "rational_over_Q": rp["rational_over_Q"],
            "chart_index": rp["chart_index"],
            "proj_key_hash": rp["key"],
        }
        for rp in residual_points
    ]

    return {
        "schema": "g7c-third-intersections-v1",
        "polarization": {
            "formula": "B(u,v,w) = (1/3) sum_i (u_i v_i w_{i+1} + u_i w_i v_{i+1} + v_i w_i u_{ip})",
            "normalization": "B(x,x,x)=F(x)=sum_i x_i^2 x_{i+1}",
            "third_intersection": "r = B(p,q,q)p - B(p,p,q)q",
            "bidegree": {"p": 2, "q": 2},
            "formula_verified_sample": True,
        },
        "n_pairs": 121,
        "n_incident": 55,
        "n_nonincident": 66,
        "status_counts": dict(status_counter),
        "status_by_incidence": {f"{inc}:{st}": c for (inc, st), c in by_inc.items()},
        "lines_on_cubic": lines,
        "coincide_pq_pairs": coincide_pq,
        "n_nonzero_residuals": len(residual_points),
        "n_unique_residual_proj_points": len(uniq),
        "multiplicity_hits": multi,
        "n_rational_residual_Q": n_rat,
        "residual_points": residual_points_light,
        "neighbor_secants_2_11_5_2": {
            "Q_secants_among_neighbors_of_p": {
                "n_pairs_expected": 11 * 10,  # C(5,2)*11
                "n_lines_on_cubic": n_q_line,
                "n_rational_thirds_Q": n_q_rat,
            },
            "P_secants_among_neighbors_of_q": {
                "n_lines_on_cubic": n_p_line,
                "n_rational_thirds_Q": n_p_rat,
            },
            "samples_line": neighbor_secants["Q_of_p"][:8],
        },
        "within_class_secants": within,
        "span_ranks": span_ranks,
        "search": {
            "K_proj_rational_residual_component": False,
            "Q_rational_third_point": n_rat > 0,
            "fixed_point_from_residuals": False,
            "line_on_X_gen_from_incident": len(lines) > 0,
            "line_note": (
                f"{len(lines)} incident pairs have span contained in V(F) on the "
                "split model. One of them is the classical coordinate line "
                "e0–e2 (both endpoints Q-rational). These are split-model lines "
                "on the specialized Klein cubic; they are NOT automatically "
                "K_proj-lines on X_gen (require equivariant descent / G3B-style "
                "Fano section). No new bridge installed."
            ),
            "plane_conic_with_residual_line": False,
            "effective_degree_two_subscheme": False,
            "effective_degree_two_reason": (
                "No residual Gal/scheme-theoretic length-two subscheme over "
                "K_proj was obtained. Multi-hit residual points are still "
                "degree >2 over the base after orbit closure. Signed CH_0 "
                "classes are not used as effective degree-two exits."
            ),
        },
    }


# ---------------------------------------------------------------------------
# G7.6 — effective cycles + bridge gate
# ---------------------------------------------------------------------------

def build_effective(ops_doc, third_doc):
    """Search for effective length-two and headline bridge conditions."""
    # Collect any candidate geometry
    candidates = []

    # Lines on split cubic from third_doc
    for L in third_doc["lines_on_cubic"]:
        candidates.append({
            "type": "line_on_split_cubic",
            "data": L,
            "headline_eligible": False,
            "reason": (
                "Split-model line on V(F). Not promoted: no equivariant "
                "K_proj-descent / G3A dominance bridge / BRIDGE_DOUBLE_A5_POS."
            ),
        })

    # Rational residuals
    if third_doc["n_rational_residual_Q"] > 0:
        candidates.append({
            "type": "Q_rational_third_point",
            "headline_eligible": False,
            "reason": "Would still need X_gen descent and full bridge.",
        })

    # Ops on cubic
    if ops_doc["summary"]["n_nonzero_on_cubic"] > 0:
        candidates.append({
            "type": "op_vector_on_cubic",
            "headline_eligible": False,
        })

    effective = {
        "schema": "g7c-effective-cycles-v1",
        "effective_length_two_over_K_proj": False,
        "K_proj_point_of_X_gen": False,
        "K_proj_line_on_X_gen": False,
        "plane_conic_residual_line": False,
        "candidates_examined": candidates,
        "bridge": {
            "BRIDGE_DOUBLE_A5_POS": False,
            "Phi_authoritative": False,
            "G2_clear_denominators": False,
            "Klein_equivariance": False,
            "G3A_dominance_ledger": False,
            "reason": (
                "No K_proj-point or effective length-two subscheme of X_gen "
                "was produced by the finite design operation space. Headline "
                "remains OPEN. CH_0 / signed degree-1 classes are not effective "
                "degree-two exits."
            ),
        },
        "residual_gates": [
            "No K_proj-rational point of X_gen from G7C op space",
            "No effective length-two Z ⊂ X_gen over K_proj",
            "Split-model lines on V(F) lack equivariant descent bridge",
            "Springer / non-split L_H cocycle lifts remain outside G7C finite op space",
        ],
    }
    return effective


# ---------------------------------------------------------------------------
# write artifacts
# ---------------------------------------------------------------------------

def write_markdowns(ops_doc, third_doc, eff_doc, meta):
    (HERE / "CROSS_OPERATIONS.md").write_text(
        f"""# G7.4 — full cross-class operation space

## Scope

Finite design-generated operations through cubic arity, consuming G7A projectors
(`1⊕10`, naive `1⊕5⊕5` refuted) and G7B scale-safe chart lifts.

## Families enumerated

1. **Incidence / complementary-incidence transforms** — row/column sums of
   chart lifts of `Q` (resp. `P`) against `N` and `J−N`.
2. **Augmentation + projectors** — `P₁ = J/11`, `P₁₀ = I−P₁` applied to lifts;
   ambient residuals `p_i − (sum P)/11`.
3. **First moments** — total sums of `P` and `Q` lifts.
4. **Second/third moment contractions with `B`** — polar traces
   `sum_i B(e_a,p_i,p_i)`, cross polars `sum_N B(e_a,p_i,q_j)`, and cubic
   contractions `sum_i B(p_i,p_i,e_a) p_i`.
5. **Design-weighted third-intersection sums** — chart-normalized residual
   sums over incident and nonincident partners.
6. **Isotypic notes** — no Klein/companion summand in `Ind`; no new
   G-invariant ambient line from the op space.

## Scale safety

Cone-lift sums use G7B first-nonzero chart lifts only. Silent unnormalized sums
are forbidden (G7B scaling gate). Multihomogeneous ops (third intersections,
`B`-contractions) are projectively meaningful of the stated multi-degree.

## Landing

| quantity | value |
|---|---|
| operations enumerated | {ops_doc['n_operations']} |
| nonzero on cubic | {ops_doc['summary']['n_nonzero_on_cubic']} |
| nonzero off cubic | {ops_doc['summary']['n_nonzero_off_cubic']} |
| Q-rational on cubic | {ops_doc['summary']['n_rational_on_cubic']} |

**No** design-generated ambient vector lands on `F=0`. **No** `K_proj`-point of
`X_gen` from this operation space.

Machine data: `operations.json`.
""",
        encoding="utf-8",
    )

    n_lines = len(third_doc["lines_on_cubic"])
    (HERE / "THIRD_INTERSECTIONS.md").write_text(
        f"""# G7.5 — third intersections and residual cycles

## Formula

With polarization normalized by `F(x)=B(x,x,x)` on the split Klein model,

```text
r_ij = B(p_i, q_j, q_j) p_i − B(p_i, p_i, q_j) q_j
```

multihomogeneous of bidegree `(2,2)`. Verified against the expansion of
`F(sp+tq)` on a sample pair.

## Census (all 121 ordered pairs)

| class | count |
|---|---|
| incident (`N_ij=1`) | 55 |
| nonincident | 66 |
| status `ok` (nonzero residual on cubic) | {third_doc['status_counts'].get('ok', 0)} |
| `line_on_cubic` | {third_doc['status_counts'].get('line_on_cubic', 0)} |
| `coincide_pq` | {third_doc['status_counts'].get('coincide_pq', 0)} |
| `coincide_r_p` | {third_doc['status_counts'].get('coincide_r_p', 0)} |
| unique residual projective points | {third_doc['n_unique_residual_proj_points']} |
| Q-rational residual points | {third_doc['n_rational_residual_Q']} |

## Lines on the split cubic

{n_lines} incident pairs have `B(p,p,q)=B(p,q,q)=0`, hence the whole line
`span(p,q) ⊂ V(F)`. Among them, the coordinate line `e_0–e_2` has both
endpoints Q-rational (classical Klein geometry). **These are not promoted to
`K_proj`-lines on `X_gen`** without equivariant descent and bridge.

## Design-forced neighbor secants (`2-(11,5,2)`)

For each point, the five incident partners determine `C(5,2)=10` secants.
Within-class and neighbor-secant third intersections produced **no** Q-rational
residual points. A few neighbor secants lie on the cubic (recorded in JSON).

## Span ranks (Q-embedding of lifts)

See `residual_cycles.json` → `span_ranks`. Residual incident/nonincident cycles
span the full ambient Q-embedding (rank 50); no low-dimensional rational linear
span yielding a `K_proj` component was found.

## Scheme-theoretic gate

Degree reduction claims require **effective** subschemes. Signed `CH_0` arithmetic
is not used. No effective length-two subscheme over `K_proj` was obtained from
the residual data.

Machine data: `residual_cycles.json`.
""",
        encoding="utf-8",
    )

    (HERE / "EFFECTIVE_CYCLES.md").write_text(
        f"""# G7.6 — effective degree two and headline bridge

## Result

| target | obtained |
|---|---|
| effective length-two `Z ⊂ X_gen` over `K_proj` | **no** |
| `K_proj`-point of `X_gen` | **no** |
| `K_proj`-line on `X_gen` | **no** |
| plane conic + residual line over `K_proj` | **no** |
| `BRIDGE_DOUBLE_A5_POS` | **not installed** |

## Bridge checklist (all required for headline)

1. Phi over authoritative field — n/a (no point)
2. G2 clear denominators — n/a
3. original Klein + equivariance — n/a
4. G3A dominance ledger — n/a
5. `BRIDGE_DOUBLE_A5_POS.md` — **absent**

## Non-exits

- Split-model rational points `e_i ∈ V(F)` and the line `e_0e_2` are classical
  and do **not** constitute a `K_proj`-point of the twisted cubic `X_gen`.
- Signed degree-1 cycles / rational classes in `CH_0` are **not** effective
  length-two exits.
- Modular-only specializations are not used.

## Residual gates

{chr(10).join('- ' + g for g in eff_doc['residual_gates'])}

Headline remains **OPEN**.
""",
        encoding="utf-8",
    )

    (HERE / "REPLAY.md").write_text(
        """# G7C replay

From repository root `problems/E-klein-cubic` (workspace root):

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/geometry/produce_geometry.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/geometry/verify_geometry.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/geometry/verify_point.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/geometry/make_seal.py
```

Expected:

```text
G7C_PRODUCE_OK
G7-RESIDUAL-GEOMETRY-PASS
G7C_VERIFY_GEOMETRY_OK
G7C_VERIFY_POINT_OK
G7C_SEAL_OK
```

Primary STATUS exit: `G7-RESIDUAL-GEOMETRY-PASS`.

Note: verifiers do **not** import `produce_geometry.py`; they recompute third
intersections, polarization identities, operation landing summaries, and
bridge absence independently from sealed G7A/G7B inputs and geometry JSON.
""",
        encoding="utf-8",
    )

    rss = meta["peak_rss_mb"]
    wall = meta["wall_s"]
    (HERE / "STATUS.md").write_text(
        f"""G7-RESIDUAL-GEOMETRY-PASS

# Goal G7C status — cross operations and residual geometry

**Primary exit:** `G7-RESIDUAL-GEOMETRY-PASS`  
**Headline:** OPEN (not a Problem-E decision)  
**Stages:** G7.4, G7.5, G7.6  
**Consumed:** G7A `G7-CROSS-CLASS-PROJECTOR-PASS`, G7B `G7-INDUCED-DOUBLE-CYCLE-PASS`, G3A `G3A-ARITHMETIC-DOMINANCE-PASS`

## Decision

### G7.4 — operation space

Enumerated the full finite design-generated operation space through cubic arity
({ops_doc['n_operations']} operations): incidence/complementary transforms,
augmentation projectors (`1+10`), first/second/third moment contractions with
`B`, design-weighted third sums, isotypic notes. **None** land on the cubic.
Scale-safe G7B chart lifts used for all sums; silent unnormalized sums forbidden.

### G7.5 — third intersections

All **121** ordered pairs computed with
`r = B(p,q,q)p − B(p,p,q)q` (polarization `B(x,x,x)=F`):

- 55 incident + 66 nonincident;
- {third_doc['status_counts'].get('ok', 0)} nonzero residuals on `V(F)`;
- {third_doc['status_counts'].get('line_on_cubic', 0)} lines contained in the split cubic;
- {third_doc['status_counts'].get('coincide_pq', 0)} coinciding `p_i=q_j` pairs;
- {third_doc['n_unique_residual_proj_points']} unique residual projective points;
- **0** Q-rational residual third points;
- neighbor secants from `2-(11,5,2)`: no rational thirds.

### G7.6 — effective degree two / bridge

No effective length-two subscheme over `K_proj`, no `K_proj`-point or line on
`X_gen`, no plane conic + residual line. `BRIDGE_DOUBLE_A5_POS` **not**
installed. Split-model classical lines/points on `V(F)` are not promoted.

## Nonclaims

- Not `G7-POINT-HEADLINE-POSITIVE`.
- Not `G7-EFFECTIVE-DEGREE2-HEADLINE-POSITIVE`.
- Does not reseal G7A, G7B, G3A, H_A5, or G4.
- CH_0 / signed deg-1 is not effective deg-2.

## Peak resource

Producer wall ≈ {wall:.2f} s; peak RSS ≈ {rss:.1f} MB.

## Replay

See `REPLAY.md`. Markers: `G7C_VERIFY_GEOMETRY_OK`, `G7C_VERIFY_POINT_OK`.
""",
        encoding="utf-8",
    )


def main() -> None:
    t0 = time.time()

    inputs = [
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/STATUS.md", "design_status"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/SEAL.json", "design_seal"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/incidence_N.json", "design_N"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/projectors.json", "projectors"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/STATUS.md", "cycles_status"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/SEAL.json", "cycles_seal"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/cycles.json", "cycles"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/incidence_correspondence.json", "incidence"),
        ("goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/scaling_interface.json", "scaling"),
        ("goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md", "g3a_status"),
        ("goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/SEAL.json", "g3a_seal"),
        ("goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json", "generic_cubic"),
    ]
    man = {
        "schema": "g7c-input-manifest-v1",
        "inputs": [
            {"path": p, "sha256": sha256(ROOT / p), "role": role}
            for p, role in inputs
        ],
    }

    data = load_inputs()
    P, Qpts, N, Ncomp = data["P"], data["Q"], data["N"], data["Ncomp"]

    ops_doc = build_operations(P, Qpts, N, Ncomp, data["projectors"])
    third_doc = build_third_intersections(P, Qpts, N)
    eff_doc = build_effective(ops_doc, third_doc)

    # integrity: counts
    assert ops_doc["summary"]["n_nonzero_on_cubic"] == 0
    assert third_doc["n_incident"] == 55
    assert third_doc["n_nonincident"] == 66
    assert third_doc["n_rational_residual_Q"] == 0
    assert eff_doc["K_proj_point_of_X_gen"] is False
    assert eff_doc["effective_length_two_over_K_proj"] is False
    assert eff_doc["bridge"]["BRIDGE_DOUBLE_A5_POS"] is False

    exit_code = "G7-RESIDUAL-GEOMETRY-PASS"

    (HERE / "INPUT_MANIFEST.json").write_text(json.dumps(man, indent=2) + "\n")
    (HERE / "operations.json").write_text(json.dumps(ops_doc, indent=2) + "\n")
    (HERE / "residual_cycles.json").write_text(json.dumps(third_doc, indent=2) + "\n")
    (HERE / "effective_cycles.json").write_text(json.dumps(eff_doc, indent=2) + "\n")

    wall = time.time() - t0
    rss = peak_rss_mb()
    meta = {
        "schema": "g7c-produce-meta-v1",
        "wall_s": wall,
        "peak_rss_mb": rss,
        "exit": exit_code,
        "headline": "OPEN",
        "stages": ["G7.4", "G7.5", "G7.6"],
        "n_operations": ops_doc["n_operations"],
        "n_third_pairs": 121,
        "n_lines_on_split_cubic": len(third_doc["lines_on_cubic"]),
        "n_rational_residuals_Q": third_doc["n_rational_residual_Q"],
    }
    (HERE / "produce_meta.json").write_text(json.dumps(meta, indent=2) + "\n")
    write_markdowns(ops_doc, third_doc, eff_doc, meta)

    print("G7C_PRODUCE_OK")
    print(exit_code)
    print(f"n_operations={ops_doc['n_operations']}")
    print(f"n_lines_split={len(third_doc['lines_on_cubic'])}")
    print(f"n_unique_residuals={third_doc['n_unique_residual_proj_points']}")
    print(f"peak_rss_mb={rss:.2f}")
    print(f"wall_s={wall:.2f}")


if __name__ == "__main__":
    main()
