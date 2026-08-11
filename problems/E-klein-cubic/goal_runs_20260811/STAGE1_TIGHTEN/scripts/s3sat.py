"""STAGE1_TIGHTEN -- saturation: the realized multidegree classes and the threshold.

Theorem S (THEOREM.md section 3):
  (a) with psi fixed, the value vector of a component depends on the multidegree
      a only through a mod 6 (per slot);
  (b) for every slot r of every sweep row there is a Gamma-INVARIANT form
      h_r in Sym^6(V_r^*) not vanishing at any child's r-th coordinate
      (the minimal such degree g_r divides 6 in all 15 rows -- computed);
  (c) hence  V(a,psi).h_r  is contained in  V(a+6e_r,psi), so both "the module is
      non-zero" and "the evaluation at child j is non-zero" PROPAGATE under
      a -> a + 6 e_r; therefore contribution(a+6e_r) is contained in
      contribution(a) and the image is the union over the coordinatewise-MINIMAL
      realized multidegrees;
  (d) those minimal multidegrees lie in an explicit finite box, computed here by
      the exact trace formula.  The threshold Theta is their largest coordinate.
"""
import itertools
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from s3sweep import FullSweep      # noqa: E402


def realized_box(S, box, psi=None):
    """{a in [0,box]^nslot : dim V(a,psi) > 0}, by the exact trace formula."""
    out = set()
    for a in itertools.product(range(box + 1), repeat=S.nslot):
        if S.module_dim(a, psi):
            out.add(a)
    return out


def minimal_realized(S, box=23, psi=None):
    """coordinatewise-minimal elements of the realized set, and the check that the
    realized set is the up-set they generate under the steps 6.e_r."""
    R = realized_box(S, box, psi)
    mins = []
    for a in sorted(R, key=sum):
        if any(tuple(a[i] - (6 if i == r else 0) for i in range(S.nslot)) in R
               for r in range(S.nslot) if a[r] >= 6):
            continue
        mins.append(a)
    # consistency: every realized a in the box is >= some minimal one by 6.e steps
    ok = True
    for a in R:
        hit = False
        for b in mins:
            if all((a[i] - b[i]) >= 0 and (a[i] - b[i]) % 6 == 0
                   for i in range(S.nslot)):
                hit = True
                break
        if not hit:
            ok = False
    return mins, R, ok


def classes(S, box=23, psi=None):
    """realized residue classes mod 6, with the minimal realized representative(s)."""
    mins, R, ok = minimal_realized(S, box, psi)
    cls = {}
    for a in mins:
        rho = tuple(x % 6 for x in a)
        cls.setdefault(rho, []).append(a)
    return cls, mins, R, ok


def contribution(S, a, E, psi=None):
    """{child row -> value} for the component a; children omitted are degenerate."""
    nV, ev = S.explicit(a, psi)
    out = {}
    for kid in S.kids:
        rk, w = ev[kid["idx"]]
        if rk == 0:
            continue
        assert rk == 1, ("NONRIGID", S.rid, a)
        U = E.m.canon([list(tuple(sum(w[i] * S.Wm[i][c] for i in range(2)) % S.p
                                  for c in range(5)))])
        v = S.own_frame(kid, U)
        if v is None:
            return None
        r0 = kid["row"]
        if r0 in out and out[r0] != v:
            return None
        out[r0] = v
    return out


def contribution_by_character(S, a, E, psi=None):
    """same, but values from the CHARACTER RULE and degeneracy from `explicit`
    is NOT needed -- used only for classes whose minimal representative is too
    large to build explicitly.  Degeneracy is then read from the propagation
    theorem: a class's minimal representative carries the degeneracy."""
    out = {}
    for kid in S.kids:
        U = S.value(a, kid, psi)
        if U is None:
            return None
        v = S.own_frame(kid, U)
        if v is None:
            return None
        r0 = kid["row"]
        if r0 in out and out[r0] != v:
            return None
        out[r0] = v
    return out
