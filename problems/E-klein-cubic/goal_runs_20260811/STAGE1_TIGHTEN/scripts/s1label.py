"""Geometric names for the source rows and the target values."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


def sub_label(E, U):
    """name a member of the level-0 arrangement A."""
    m = E.m
    S = E.S
    st = [g for g in m.G if m.canon([list(m.act(g, v)) for v in U]) == U]
    pw = [g for g in st if all(S.scalar_on(g, (), U) for _ in (0,))]
    n = len(st)
    d = len(U)
    if d == 1:
        v = U[0]
        onX = (m.F(v) % E.p == 0)
        nm = {660: "G", 60: "A5", 55: "F55", 12: None, 11: "C11", 10: "D10",
              6: "C6", 5: "C5", 4: "V4", 3: "C3", 2: "C2", 1: "1"}.get(n, "?%d" % n)
        if n == 12:
            nm = "D12" if any(m.order[g] == 2 and m.mm(g, h) != m.mm(h, g)
                              for g in st for h in st) else "C12"
        if n == 12 and all(m.mm(g, h) == m.mm(h, g) for g in st for h in st):
            nm = "A4?"
        if n == 12:
            # A4 has no element of order 6; D12 does
            nm = "D12" if any(m.order[g] == 6 for g in st) else "A4"
        return "pt_%s%s" % (nm, "" if not onX else "*")
    if d == 2:
        pw = [g for g in st if S.scalar_on(g, (), U)]
        if len(pw) == 4:
            return "ell_V"
        if len(pw) == 3:
            return "C3line"
        return "Lminus_sigma"
    if d == 3:
        return "P_sigma"
    return "?"


def row_label(E, r):
    S = E.S
    C, L, H = S.comps[r["rep"]]
    return "<".join(sub_label(E, U) for U in C) or "(free)"


def val_label(E, v):
    m, T = E.m, E.T
    kind, cell, lab = v
    if kind == "dom" and cell == "X":
        return "X (dominant)"
    if kind == "dom":
        return "L_sigma (ONTO)"
    if kind == "gen":
        return "generic pt of %s_sigma" % cell
    if cell == "PI":
        K, sig = T.typeI_of[lab]
        return "typeI vertex"
    return {"PII": "typeII point", "P6": "C6-point of X", "P3": "exact-C3 point",
            "P5a": "C5-point (a)", "P5b": "C5-point (b)",
            "P11": "C11-point"}[cell]
