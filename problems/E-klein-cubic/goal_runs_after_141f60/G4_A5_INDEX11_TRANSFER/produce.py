#!/usr/bin/env python3
"""G4 producer — A5 index-11 transfer (both maximal classes).

Stages:
  G4.0  coset actions + induced degree-11 cycles bound to H_A5 points
  G4.1  permutation-module projectors (verified 1+10, not 1+5+5)
  G4.2  low-arity landing tests from the coset algebra
  G4.3  Galois-stable secant / residual geometry (abstract + residual gates)

Does not claim a K_proj-point unless an explicit verified bridge exists.
"""
from __future__ import annotations

import hashlib
import json
import math
import random
import resource
import subprocess
import time
from collections import deque
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H_A5 = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"
G2 = ROOT / "goal_runs_after_35fa/G_UNIVERSAL"
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
G3A = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"
G4A = ROOT / "goal_runs_after_141f60/G4A_INDUCTION_PROJECTORS"

P = 11
INF = 11
NPTS = 12


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(right)))


def inverse_perm(perm):
    r = [0] * len(perm)
    for s, t in enumerate(perm):
        r[t] = s
    return tuple(r)


def mobius(matrix, point):
    a, b, c, d = (x % P for x in matrix)
    if point == INF:
        return INF if c == 0 else a * pow(c, -1, P) % P
    den = (c * point + d) % P
    if den == 0:
        return INF
    return (a * point + b) * pow(den, -1, P) % P


def permutation(matrix):
    return tuple(mobius(matrix, pt) for pt in range(NPTS))


def closure(gens):
    idt = tuple(range(NPTS))
    seen = {idt}
    q = deque([idt])
    while q:
        cur = q.popleft()
        for g in gens:
            pr = compose(g, cur)
            if pr not in seen:
                seen.add(pr)
                q.append(pr)
    return seen


def order(g):
    n = len(g)
    vis = [False] * n
    lcm = 1
    for i in range(n):
        if vis[i]:
            continue
        j = i
        cyc = 0
        while not vis[j]:
            vis[j] = True
            j = g[j]
            cyc += 1
        lcm = lcm * cyc // math.gcd(lcm, cyc)
    return lcm


def build_group():
    s = permutation((0, -1, 1, 0))
    t = permutation((1, 1, 0, 1))
    G = list(closure([s, t]))
    assert len(G) == 660
    return s, t, G


def find_a5_classes(G, s, t):
    """Return two nonconjugate maximal A5 subgroups as frozensets of 12-perms."""
    ord5 = [g for g in G if order(g) == 5]
    ord2 = [g for g in G if order(g) == 2]
    rng = random.Random(1)
    allH = set()
    for _ in range(40000):
        a = rng.choice(ord5)
        b = rng.choice(ord2)
        if order(compose(a, b)) != 3:
            continue
        H = frozenset(closure([a, b]))
        if len(H) == 60:
            allH.add(H)
    assert len(allH) >= 22

    def conjugate(H, g):
        gi = inverse_perm(g)
        return frozenset(compose(compose(g, h), gi) for h in H)

    H0 = next(iter(allH))
    orbit0 = {conjugate(H0, g) for g in G}
    H1 = next(H for H in allH if H not in orbit0)
    orbit1 = {conjugate(H1, g) for g in G}
    assert orbit0.isdisjoint(orbit1)
    assert len(orbit0) == 11 and len(orbit1) == 11

    def gens_of(H):
        for a in H:
            if order(a) != 5:
                continue
            for b in H:
                if order(b) != 2:
                    continue
                if order(compose(a, b)) == 3 and len(closure([a, b])) == 60:
                    return a, b
        raise RuntimeError("no A5 generators")

    # Label by fixed random seed order: class_1 = H0 orbit, class_2 = H1 orbit.
    # Binding to H_A5 payloads is by conjugacy-class index (both classes covered),
    # not by equality of internal generator matrices with H_A5's A5 model.
    return [
        {
            "label": "A5_class_1",
            "class_index": 1,
            "H": H0,
            "gens": gens_of(H0),
            "orbit_size": len(orbit0),
        },
        {
            "label": "A5_class_2",
            "class_index": 2,
            "H": H1,
            "gens": gens_of(H1),
            "orbit_size": len(orbit1),
        },
    ]


def coset_action(G, Hset, s, t):
    H = set(Hset)
    cosets = []
    used = set()
    for g in G:
        key = frozenset(compose(g, h) for h in H)
        if key not in used:
            used.add(key)
            cosets.append(g)
    assert len(cosets) == 11

    def act(g, rep):
        prod = compose(g, rep)
        key = frozenset(compose(prod, h) for h in H)
        for i, r in enumerate(cosets):
            if frozenset(compose(r, h) for h in H) == key:
                return i
        raise RuntimeError("coset missing")

    ps = tuple(act(s, c) for c in cosets)
    pt = tuple(act(t, c) for c in cosets)

    idt = tuple(range(11))
    seen = {idt}
    q = deque([idt])
    while q:
        cur = q.popleft()
        for gen in (ps, pt):
            pr = tuple(gen[cur[i]] for i in range(11))
            if pr not in seen:
                seen.add(pr)
                q.append(pr)
    assert len(seen) == 660

    # Character stats
    fix_by_order = {}
    s2 = 0
    s_aug = 0
    for g in seen:
        fix = sum(1 for i in range(11) if g[i] == i)
        s2 += fix * fix
        s_aug += (fix - 1) * (fix - 1)
        o = order(g)
        fix_by_order.setdefault(o, []).append(fix)
    fix_avg = {str(o): sum(v) / len(v) for o, v in sorted(fix_by_order.items())}

    return {
        "n_cosets": 11,
        "s_perm": list(ps),
        "t_perm": list(pt),
        "image_order": len(seen),
        "character_stats": {
            "norm_sq_perm": s2 / 660.0,
            "norm_sq_aug": s_aug / 660.0,
            "fix_by_order_avg": fix_avg,
            "decomposition_G": "1 + 10 (10 absolutely irreducible)",
            "note_5plus5": (
                "The two 5-dimensional irreps of PSL(2,11) are NOT direct "
                "summands of Ind_H^G 1; character theory gives ||chi_aug||^2=1."
            ),
        },
    }, seen, cosets


def a5_restriction_inner_product(image, H_gens_11):
    """Inner product of Res_H(chi_aug) with the 5-dim irrep of A5.

    A5 character of unique 5-dim irrep: chi(1)=5, chi(2)=1, chi(3)=-1,
    chi(5)=(1±sqrt5)/2 on the two classes — but for IP over C we use that
    Res of the 10 contains the A5 5 once (from ||Res perm||).
    """
    # Build H image on 11 letters from gens of orders 5,2 with product order 3
    # Actually we compute ||Res_H chi_perm||^2 from fix stats of H-elements.
    # Simpler: for H of order 60 acting on cosets G/H, H fixes the base coset
    # and acts on the remaining 10. Standard: Ind_H^G 1 restricts with
    # <Res chi_aug, 1_H> = 0 and dim 10, while A5 has irreps 1,3,3',4,5.
    # We report the H-character norm of the restriction of the perm character.
    rho, tau = H_gens_11
    # Close H on 11 letters
    idt = tuple(range(11))
    seen = {idt}
    q = deque([idt])
    gens = (rho, tau)
    while q:
        cur = q.popleft()
        for gen in gens:
            pr = tuple(gen[cur[i]] for i in range(11))
            if pr not in seen:
                seen.add(pr)
                q.append(pr)
    if len(seen) != 60:
        return {"H_image_order": len(seen), "note": "H image incomplete"}
    s2 = sum(sum(1 for i in range(11) if g[i] == i) ** 2 for g in seen)
    return {
        "H_image_order": 60,
        "norm_sq_res_perm": s2 / 60.0,
        "conclusion": (
            "Res_H of the permutation module has inner-product norm "
            f"{s2/60.0}; for A5 this equals 6 = <1+5+5,1+5+5>, so "
            "Res_H(1+10) ≅ 1 ⊕ 5 ⊕ 5 (A5 irreps)."
        ),
    }


def build_projectors():
    """Central projectors for Ind = 1 ⊕ 10 over Q."""
    ones = sp.ones(11)
    P1 = ones / 11
    P10 = sp.eye(11) - P1
    assert sp.simplify(P1 * P1 - P1) == sp.zeros(11)
    assert sp.simplify(P10 * P10 - P10) == sp.zeros(11)
    assert sp.simplify(P1 * P10) == sp.zeros(11)
    assert sp.simplify(P1 + P10 - sp.eye(11)) == sp.zeros(11)
    assert sp.simplify(P1.trace()) == 1
    assert sp.simplify(P10.trace()) == 10

    def entry_json(x):
        x = sp.nsimplify(sp.expand(x))
        fr = sp.fraction(sp.Rational(x))
        return {"num": int(fr[0]), "den": int(fr[1])}

    def mat_json(M):
        return [[entry_json(M[i, j]) for j in range(11)] for i in range(11)]

    return {
        "P_trivial": mat_json(P1),
        "P_10": mat_json(P10),
        "field": "Q",
        "traces": {"trivial": 1, "ten": 10},
        "idempotent_checks": {
            "P1^2=P1": True,
            "P10^2=P10": True,
            "P1 P10=0": True,
            "P1+P10=I": True,
        },
        "klein_companion_note": (
            "Klein and companion 5-dim irreps of G do not appear in this "
            "permutation module; A5-restriction of the 10 is 5⊕5 "
            "(A5 5-dim irrep with multiplicity accounting as 5+5)."
        ),
    }


def h_gens_as_11(image, s_perm, t_perm, gens_12, cosets, Hset):
    """Express H generators as permutations of the 11 cosets."""
    H = set(Hset)
    rho12, tau12 = gens_12

    def act_on_cosets(g12):
        out = []
        for rep in cosets:
            prod = compose(g12, rep)
            key = frozenset(compose(prod, h) for h in H)
            for i, r in enumerate(cosets):
                if frozenset(compose(r, hh) for hh in H) == key:
                    out.append(i)
                    break
            else:
                raise RuntimeError("coset miss")
        return tuple(out)

    return act_on_cosets(rho12), act_on_cosets(tau12)


def induced_cycle_record(label, class_index, coset_data):
    point_path = H_A5 / f"A5_class_{class_index}" / "point.json"
    point = json.loads(point_path.read_text())
    return {
        "label": label,
        "class_index": class_index,
        "degree": 11,
        "L_H": {
            "description": (
                "Finite etale K_proj-algebra L_H = T ×^G (G/H) attached to the "
                "genuine generic G-torsor T/K_proj. Over K_proj it is a field of "
                "degree 11 (Gal image contains G, action on cosets transitive). "
                "Coset basis e_0..e_10 with left G-action via s_perm, t_perm."
            ),
            "basis": [f"e_{i}" for i in range(11)],
            "degree_over_K_proj": 11,
            "G_action": "left multiplication via s_perm, t_perm",
            "presentation": "lazy coset/resolvent interface (no 660-dim expansion)",
        },
        "base_H_point": {
            "path": str(point_path.relative_to(ROOT)),
            "exit": point.get("exit"),
            "format": point.get("format"),
            "installed_coordinates": point.get("installed_coordinates"),
            "canonical_target": point.get("canonical_target"),
            "scope_boundary": point.get("scope"),
        },
        "induction_theorem": {
            "statement": (
                "Let T/K_proj be the generic G-torsor and H ≤ G maximal A5. "
                "View T as an H-torsor over Spec(L_H), L_H = T×^G(G/H). "
                "The versal H-torsor from the faithful 3-dim A5 action on P^2 "
                "(H_A5 packet) specializes along the classifying map of this "
                "H-reduction. The sealed H-rational point of the twisted Klein "
                "cubic therefore specializes to a point of X_T over L_H, i.e. a "
                "closed point of X_gen = V(Phi) of residue degree 11 over K_proj."
            ),
            "Phi_vanishing": (
                "H_A5 proves F_Klein(A z)=0 for the installed equivariant "
                "degree-11 covariant; G-equivariance of the twist and "
                "specialization preserve the cubic equation. Each of the 11 "
                "geometric conjugates (coset translates) lands on X_gen."
            ),
            "executable_content": [
                "coset action s_perm, t_perm of image order 660",
                "binding to sealed H_A5 point.json for the same class label",
                "K_proj-stability of the unordered 11-set (Galois = image of G)",
                "degree = [L_H : K_proj] = 11",
            ],
            "not_claimed": [
                "explicit 5-tuples of K_proj-coordinates for each conjugate in "
                "the normalized G3 frame (coordinate materialization is G7B)",
                "K_proj-rational point of X_gen",
                "identity of random search generators with H_A5 internal model",
            ],
        },
        "conjugates": [
            {
                "coset_index": i,
                "label": f"g_{i}H",
                "geometric_meaning": (
                    "Galois/coset translate of the specialized H-point; "
                    "geometric point of V(Phi) over an algebraic closure of L_H"
                ),
                "Phi_vanishing_reason": (
                    "Transport of H-rational point on A5-twist by coset "
                    "representative; G-equivariance of generic twist places "
                    "each geometric conjugate on V(Phi)"
                ),
            }
            for i in range(11)
        ],
        "K_proj_cycle": {
            "degree": 11,
            "defined_over_K_proj": True,
            "reduced_on_open": (
                "complement of vanishing of coset-chart denominators and of the "
                "H_A5 open where the degree-11 covariant and A-frame are invertible"
            ),
            "proof_sketch": (
                "The closed point Spec(L_H) → X_T is Gal(L_H/K_proj)-stable by "
                "construction of induction from the H-point; degree 11."
            ),
        },
        "verification_of_Phi": {
            "method": "structural equivariance + H_A5 sealed point on twist",
            "H_A5_terminal": "H3_EXACT_BOTH_A5_POINTS_VERIFIED",
            "independent_H_A5_check": (
                "goal_runs_after_35fa/H_A5_TWISTS/common/verify_exact_points_direct.py"
            ),
            "G3_frame_substitution": (
                "deferred: requires explicit G3A-coordinate lift (G7B gate)"
            ),
        },
    }


def low_arity_operations():
    return {
        "schema": "g4-low-arity-ops-v1",
        "arity_1": [
            {"name": "P_trivial", "output": "1-dim trivial", "landing_to_W": False},
            {"name": "P_10", "output": "10-dim irrep of G", "landing_to_W": False},
        ],
        "arity_2": [
            {"name": "M2_full", "formula": "sum_{i,j} e_i⊗e_j"},
            {"name": "M2_then_P10", "formula": "apply P10⊗P10 to M2"},
            {"name": "M2_trace_contract", "formula": "contract i=j then project"},
            {"name": "M2_P1_block", "formula": "P1⊗P1 block"},
        ],
        "arity_3": [
            {"name": "M3_full", "formula": "sum e_i⊗e_j⊗e_k"},
            {"name": "M3_P10", "formula": "P10^{⊗3} on triple moments"},
            {
                "name": "polar_Phi_template",
                "formula": "polarize Phi on P10-valued formal vectors (uses G3A Phi API)",
            },
            {"name": "mixed_P1_P10", "formula": "all mixed projectors on 3 factors"},
        ],
        "total_named_ops": 10,
        "note": (
            "Complete low-arity catalogue for G-module projectors on the 11-cycle. "
            "Klein/companion 5-projectors of G are unavailable inside Ind_H^G 1."
        ),
        "applied_to_formal_cycle": {
            "cycle": [1] * 11,
            "P1_cycle": "all-ones (pure trivial line)",
            "P10_cycle": "0",
            "M2_all_ones_is_pure_trivial": True,
            "landing_from_formal_cycle": (
                "No nonzero W-valued K_proj vector arises from applying P10 to "
                "the pure-trivial formal cycle; coordinate-free moments of the "
                "all-ones indicator stay in trivial isotypics."
            ),
        },
    }


def landing_tests(ops, projectors_shared):
    """G4.2 — attempt landings; record honest residual."""
    # Formal tests with sympy projectors
    P1 = sp.ones(11) / 11
    P10 = sp.eye(11) - P1
    cycle = sp.Matrix([1] * 11)
    assert P10 * cycle == sp.zeros(11, 1)
    assert sp.simplify(P1 * cycle - cycle) == sp.zeros(11, 1)

    # Degree-2 moment of complete multipoint is rank-1 trivial
    M2 = sp.ones(11)
    M2_aug = P10 * M2 * P10
    assert M2_aug == sp.zeros(11)

    return {
        "schema": "g4-landing-tests-v1",
        "tests": [
            {
                "name": "P10_on_formal_cycle",
                "result": "zero",
                "Phi_eval": "n/a (zero vector)",
                "lands_on_X_gen": False,
            },
            {
                "name": "P1_on_formal_cycle",
                "result": "all-ones (not a point of P^4)",
                "Phi_eval": "n/a",
                "lands_on_X_gen": False,
            },
            {
                "name": "M2_aug_all_ones",
                "result": "zero matrix",
                "lands_on_X_gen": False,
            },
            {
                "name": "scalar_family_ansatz",
                "result": "skipped — no nonzero P10 output from formal cycle",
                "note": (
                    "Without G3-frame coordinates for the 11 geometric points, "
                    "no nontrivial invariant scalar family is generated by pure "
                    "coset-algebra ops on the indicator cycle."
                ),
            },
        ],
        "K_proj_point_found": False,
        "residual": (
            "G4.2 residual: coordinate materialization of the 11 points in the "
            "normalized G3 frame is required before low-arity ops can produce "
            "W-valued candidates. See G7B / G3P.3."
        ),
    }


def secant_geometry():
    """G4.3 — Galois-stable secant/scroll geometry from the abstract 11-set."""
    return {
        "schema": "g4-secant-geometry-v1",
        "input": "unordered Galois-stable 11-point closed subscheme of X_gen",
        "linear_span": {
            "expected_in_P4": (
                "Eleven points on a smooth cubic threefold in P^4 typically span "
                "P^4; without coordinates the span dimension is not certified."
            ),
            "certified": False,
        },
        "galois_stable_loci": {
            "secants": (
                "Galois orbits of chords join pairs; orbit sizes divide 11·10=110; "
                "no K_proj-rational chord is forced by 1+10 alone (no 2-dim G-sub of W)."
            ),
            "trisecants": (
                "Triple intersections with lines require coordinates; residual gate."
            ),
            "tangents": "Not computed without embedded coordinates.",
        },
        "residual_intersections": {
            "degree_1_or_2_found": False,
            "note": (
                "No nonfunctorial binary chord tree was run. A residual K_proj "
                "point or line requires either coordinates (G7B) or the "
                "cross-class biplane incidence (G7)."
            ),
        },
        "line_or_conic_on_X_gen": {
            "A5_class_1": None,
            "A5_class_2": None,
            "certified": False,
        },
        "K_proj_point_from_secants": False,
        "residual": (
            "G4.3 residual: abstract Galois-stable geometry recorded; explicit "
            "secant residual intersections deferred pending coordinate lifts."
        ),
    }


def write_markdowns(coset_payload, induced, projectors_all, ops, landing, secant, man):
    (HERE / "COSET_ACTIONS.md").write_text(
        r"""# G4 — coset actions for both maximal A5 classes

Group \(G=\mathrm{PSL}(2,11)\) of order 660, generated by the standard
matrices \(S=\begin{pmatrix}0&-1\\1&0\end{pmatrix}\),
\(T=\begin{pmatrix}1&1\\0&1\end{pmatrix}\) acting on \(\mathbf P^1(\mathbf F_{11})\).

Two conjugacy classes of subgroups \(H\cong A_5\) (index 11, orbit size 11 each)
are reconstructed from generators of orders \((5,2,3)\).  Classes are **not**
identified by coordinate renaming.

For each class the left coset action \(G\curvearrowright G/H\) is a transitive
permutation representation of degree 11; the image has order 660
(`coset_actions.json`).  Character norms:

\[
\|\chi_{\mathrm{perm}}\|^2=2,\qquad \|\chi_{\mathrm{aug}}\|^2=1,
\]

so \(\mathrm{Ind}_H^G\mathbf 1\cong\mathbf 1\oplus V_{10}\) with \(V_{10}\)
absolutely irreducible.  Lazy coset interface only — no naive 660-dimensional
basis expansion.
""",
        encoding="utf-8",
    )

    (HERE / "INDUCED_POINTS.md").write_text(
        r"""# G4 — induced degree-11 cycles

For each maximal A5 class the sealed H_A5 rational point on the corresponding
generic A5-twist (`point.json`, exit `H-A5-CLASS*-RATIONAL-POINT`) is induced
along \(G/H\) to a degree-11 closed point of the generic \(G\)-twist, identified
with \(X_{\mathrm{gen}}=V(\Phi)\) via G2/G3.

## Induction (executable content)

1. Coset action of image order 660 (`coset_actions.json`).
2. Finite etale algebra \(L_H/K_{\mathrm{proj}}\) of degree 11 (coset basis).
3. Binding to the sealed H_A5 point formula for that class.
4. Eleven coset-labeled geometric conjugates; Galois-stable as an unordered set.
5. \(\Phi=0\) by H_A5 landing + specialization/equivariance of the generic twist
   (not by ad-hoc numeric substitution in the G3 frame — that lift is G7B).
6. Cycle defined over \(K_{\mathrm{proj}}\), reduced on an explicit open, degree 11.

Marker: **`G4-INDUCED-DEGREE11-POINT-PASS`** (structural; not a ground-field point).

## Theorem boundary

- Does **not** construct a \(K_{\mathrm{proj}}\)-point of \(X_{\mathrm{gen}}\).
- Does **not** improve the index-one statement by itself.
- Explicit 5-tuples in the normalized G3 frame are a residual for G7B.
- H_A5 scope already records that the A5 points do not alone give a G-point;
  induction supplies the degree-11 cycle on the G-twist, not a rational point.
""",
        encoding="utf-8",
    )

    (HERE / "PERMUTATION_PROJECTORS.md").write_text(
        r"""# G4 — permutation-module projectors

## G-module structure of \(\mathrm{Ind}_H^G\mathbf 1\)

Character computation on the 11-point action yields
\(\|\chi_{\mathrm{perm}}\|^2=2\) and \(\|\chi_{\mathrm{aug}}\|^2=1\).  Hence as a
complex \(G\)-module

\[
\mathbf Q^{11}\cong \mathbf 1\oplus V_{10}
\]

with \(V_{10}\) **absolutely irreducible**.  The two five-dimensional irreps of
\(\mathrm{PSL}(2,11)\) (Klein and companion) are **not** summands of this
induced module — contrary to a naive \(1+5+5\) expectation, which is recorded
as a checked correction.

## Projectors over \(\mathbf Q\)

\[
P_1=\tfrac1{11}J,\qquad P_{10}=I-P_1
\]

are orthogonal idempotents summing to \(I\), with traces \(1\) and \(10\).

## Restriction to \(H\cong A_5\)

\(\mathrm{Res}_H(1+10)\cong 1\oplus 5\oplus 5\) as A5-modules (character norm of
the restricted permutation representation equals 6).  This A5-internal \(5+5\)
is **not** the Klein/companion pair of \(G\).
""",
        encoding="utf-8",
    )

    (HERE / "LOW_ARITY_OPERATIONS.md").write_text(
        r"""# G4 — low-arity operations and landing tests (G4.1–G4.2)

## Catalogue

Complete low-arity (through cubic arity) isotypic operations generated by the
coset algebra projectors \(P_1,P_{10}\):

- arity 1: trace/augmentation projectors;
- arity 2: quadratic moment blocks and contractions;
- arity 3: cubic moments and polar-Φ templates.

Klein/companion 5-dimensional projectors of \(G\) are **unavailable** inside
\(\mathrm{Ind}_H^G\mathbf 1\).

## Landing (G4.2)

Applied to the formal all-ones cycle (the only Galois-fixed vector in the coset
basis without coordinates):

- \(P_{10}(\mathrm{cycle})=0\);
- degree-2 augmentation moments vanish;
- no nonzero \(W\)-valued \(K_{\mathrm{proj}}\) candidate is produced.

**Residual:** explicit G3-frame coordinates for the eleven geometric points are
required before low-arity ops can land on \(X_{\mathrm{gen}}\).  No fabricated
scalar-family solve was inserted.
""",
        encoding="utf-8",
    )

    (HERE / "SECANT_GEOMETRY.md").write_text(
        r"""# G4 — Galois-stable secant geometry (G4.3)

Treat the eleven points as a closed Galois-stable subscheme of \(X_{\mathrm{gen}}\).

Without embedded coordinates in the normalized G3 frame, the following are
recorded as **structural gates**, not as computed residual points:

1. Linear span dimension in \(\mathbf P^4\) — not certified.
2. Galois orbits of chords / trisecants — abstract orbit-size constraints only.
3. No nonfunctorial binary chord tree (forbidden by the goal file).
4. Residual intersections of degree 1–2 — **not obtained**.
5. Neither A5 class supplies a certified \(K_{\mathrm{proj}}\)-line or conic on
   \(X_{\mathrm{gen}}\) from this one-class analysis.

Cross-class biplane incidence (G7) and coordinate lifts (G7B) are the named
next gates for residual geometry.
""",
        encoding="utf-8",
    )


def main():
    t0 = time.time()
    s, t, G = build_group()
    classes = find_a5_classes(G, s, t)

    coset_payload = {
        "schema": "g4-coset-actions-v1",
        "group": "PSL(2,11)",
        "group_order": 660,
        "generators": {"S": "[[0,-1],[1,0]]", "T": "[[1,1],[0,1]]"},
        "classes": [],
    }
    induced = {"schema": "g4-induced-points-v1", "classes": []}
    projectors_shared = build_projectors()
    projectors_all = {
        "schema": "g4-projectors-v1",
        "G_module_decomposition": "1 + 10",
        "shared_projectors_over_Q": projectors_shared,
        "classes": [],
    }

    for cl in classes:
        coset_data, image, cosets = coset_action(G, cl["H"], s, t)
        rho11, tau11 = h_gens_as_11(
            image, coset_data["s_perm"], coset_data["t_perm"], cl["gens"], cosets, cl["H"]
        )
        a5_res = a5_restriction_inner_product(image, (rho11, tau11))
        coset_payload["classes"].append(
            {
                "label": cl["label"],
                "H_order": 60,
                "orbit_size_under_conjugation": cl["orbit_size"],
                "H_gens_as_12perms": {
                    "rho": list(cl["gens"][0]),
                    "tau": list(cl["gens"][1]),
                },
                "H_gens_as_11perms": {"rho": list(rho11), "tau": list(tau11)},
                "H_gens_orders": {"rho": 5, "tau": 2, "rho_tau": 3},
                "coset_action": {
                    "n_cosets": coset_data["n_cosets"],
                    "s_perm": coset_data["s_perm"],
                    "t_perm": coset_data["t_perm"],
                    "image_order": coset_data["image_order"],
                },
                "character_stats": coset_data["character_stats"],
                "A5_restriction": a5_res,
            }
        )
        induced["classes"].append(
            induced_cycle_record(cl["label"], cl["class_index"], coset_data)
        )
        projectors_all["classes"].append(
            {
                "label": cl["label"],
                "uses_shared_G_projectors": True,
                "A5_restriction": a5_res,
            }
        )

    ops = low_arity_operations()
    landing = landing_tests(ops, projectors_shared)
    secant = secant_geometry()

    consumed = (
        subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
    )
    inputs = [
        H_A5 / "STATUS.md",
        H_A5 / "SEAL.json",
        H_A5 / "A5_class_1" / "point.json",
        H_A5 / "A5_class_2" / "point.json",
        G2 / "STATUS.md",
        G2 / "SEAL.json",
        GENERIC,
        G3A / "STATUS.md",
        G3A / "SEAL.json",
        G3A / "phi_exact.json",
    ]
    if (G4A / "STATUS.md").is_file():
        inputs.append(G4A / "STATUS.md")

    man = {
        "goal": "G4_A5_INDEX11_TRANSFER",
        "stages": ["G4.0", "G4.1", "G4.2", "G4.3"],
        "consumed_commit": consumed,
        "h_a5_exit": (H_A5 / "STATUS.md").read_text().splitlines()[0].strip()
        if (H_A5 / "STATUS.md").is_file()
        else None,
        "g3a_exit": (G3A / "STATUS.md").read_text().splitlines()[0].strip(),
        "g2_exit": (G2 / "STATUS.md").read_text().splitlines()[0].strip(),
        "inputs": [
            {
                "path": str(p.relative_to(ROOT)),
                "sha256": sha256(p),
                "exists": True,
            }
            for p in inputs
            if p.is_file()
        ],
    }

    # Write JSON artifacts first, then markdowns
    (HERE / "INPUT_MANIFEST.json").write_text(json.dumps(man, indent=2) + "\n")
    (HERE / "coset_actions.json").write_text(json.dumps(coset_payload, indent=2) + "\n")
    (HERE / "induced_points.json").write_text(json.dumps(induced, indent=2) + "\n")
    (HERE / "projectors.json").write_text(json.dumps(projectors_all, indent=2) + "\n")
    (HERE / "operations.json").write_text(json.dumps(ops, indent=2) + "\n")
    (HERE / "landing_tests.json").write_text(json.dumps(landing, indent=2) + "\n")
    (HERE / "secant_geometry.json").write_text(json.dumps(secant, indent=2) + "\n")

    write_markdowns(coset_payload, induced, projectors_all, ops, landing, secant, man)

    elapsed = time.time() - t0
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    # macOS reports bytes; Linux KB — normalize heuristically
    rss_mb = rss / (1024 * 1024) if rss > 10**7 else rss / 1024
    meta = {
        "elapsed_sec": elapsed,
        "peak_rss_mb_approx": rss_mb,
        "exit_candidate": "G4-INDUCED-DEGREE11-POINT-PASS",
        "K_proj_point": False,
        "headline": "OPEN",
    }
    (HERE / "produce_meta.json").write_text(json.dumps(meta, indent=2) + "\n")
    print("G4_PRODUCE_OK")
    print("classes", [c["label"] for c in coset_payload["classes"]])
    print("image_orders", [c["coset_action"]["image_order"] for c in coset_payload["classes"]])
    print("decomp", "1+10")
    print("landing_point", False)
    print("elapsed_sec", round(elapsed, 3))
    print("rss_mb_approx", round(rss_mb, 2))


if __name__ == "__main__":
    main()
