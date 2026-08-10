"""Subgroup representatives inside the 660-element image G = PSL(2,11)."""
import fp
import v14lib as V


def elements_by_order(g15, p):
    d = {}
    for X in g15.values():
        d.setdefault(V.order_of(X, p), []).append(X)
    return d


def mmul(A, B, p):
    return fp.matmul(A, B, p)


def commutes(A, B, p):
    return fp.key(mmul(A, B, p), p) == fp.key(mmul(B, A, p), p)


def subgroup(gens, p):
    return V.closure(gens, p, limit=1000)


def centralizer(X, g15, p):
    return [Y for Y in g15.values() if commutes(X, Y, p)]


def pick(model):
    """Return a dict of subgroup generator lists (15-dim matrices)."""
    p = model.p
    g15 = model.group15()
    byord = elements_by_order(g15, p)
    out = {}
    s = byord[2][0]
    out["C2"] = [s]
    out["C3"] = [byord[3][0]]
    out["C5"] = [byord[5][0]]
    out["C11"] = [byord[11][0]]
    g6 = byord[6][0]
    out["C6"] = [g6]
    # V4: Sylow 2 = <s, t> with t an involution commuting with s
    t = None
    for Y in byord[2]:
        if fp.key(Y, p) != fp.key(s, p) and commutes(s, Y, p):
            t = Y
            break
    assert t is not None
    out["V4"] = [s, t]
    assert len(subgroup([s, t], p)) == 4
    # D12 = centralizer of the involution s
    cen = centralizer(s, g15, p)
    assert len(cen) == 12, len(cen)
    gens = []
    for Y in cen:
        gens.append(Y)
        if len(subgroup(gens, p)) == 12:
            break
    out["D12"] = gens
    # A5: <a,b> with |a|=2,|b|=3,|ab|=5
    found = None
    for a in byord[2]:
        for b in byord[3]:
            if V.order_of(mmul(a, b, p), p) == 5:
                H = subgroup([a, b], p)
                if len(H) == 60:
                    found = [a, b]
                    break
        if found:
            break
    assert found is not None
    out["A5"] = found
    return out, byord
