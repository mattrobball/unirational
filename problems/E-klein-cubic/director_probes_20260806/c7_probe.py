import sys, sympy as sp
sys.path.insert(0, '/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION')
import indep_r7 as I
om = I.om
x, y, z = sp.symbols('x y z')

for tag, lamS in (('one', sp.Integer(1)), ('om', om), ('om2', I.kred(om**2))):
    names, T, eqs = I.landing_equations(7, 1, lamS)
    eqs = [e for _, e in eqs] if eqs and isinstance(eqs[0], tuple) else list(eqs)
    slots = list(T)
    def coeff_syms(slot_ix, cond):
        out = set()
        p = sp.Poly(slots[slot_ix], x, y, z)
        for mono, coeff in zip(p.monoms(), p.coeffs()):
            if cond(mono):
                out |= (coeff.free_symbols - {I.om, I.kp})
        return out
    plus_deep = set().union(*[coeff_syms(i, lambda m: m[1]+m[2] == 2) for i in range(3)])
    low_check = set().union(*[coeff_syms(i, lambda m: m[1]+m[2] < 2) for i in range(3)])
    plus_all  = set().union(*[coeff_syms(i, lambda m: True) for i in range(3)])
    po1       = set().union(*[coeff_syms(i, lambda m: m[1]+m[2] == 1) for i in (3,4)])
    print(f"[{tag}] low(should be empty)={sorted(map(str,low_check))}")
    print(f"   plus-deep (set to 0): {sorted(map(str,plus_deep))}")
    plus_rest = sorted(plus_all - plus_deep, key=str)
    print(f"   remaining plus params: {list(map(str,plus_rest))}   PO-1 minus params: {sorted(map(str,po1))}")
    subs0 = {v: sp.Integer(0) for v in plus_deep}
    eqs2 = [sp.expand(e.subs(subs0)) for e in eqs]
    eqs2 = [e for e in eqs2 if e != 0]
    allsyms = sorted(set().union(*[e.free_symbols for e in eqs2]) - {I.om, I.kp}, key=str)
    print(f"   eqs after cut: {len(eqs2)} in {len(allsyms)} params")
    # Decisive question: on the locus with some PO-1 minus param != 0, are the remaining plus params forced to 0?
    # Work over QQ(om, kp) via kred-reduction: use sympy groebner over QQ with om,kp adjoined + minimal polys.
    t_aux = sp.Symbol('t_aux')
    po1v = sorted(po1, key=str)[0]
    minpolys = [I.om**2 + I.om + 1, 8*I.kp**2 - 13*I.kp - 4]
    gens = allsyms + [t_aux, I.om, I.kp]
    system = eqs2 + [po1v*t_aux - 1] + minpolys
    G = sp.groebner(system, *gens, order='grevlex', domain='QQ')
    gb = list(G.exprs)
    forced = [str(v) for v in plus_rest if v in gb]
    print(f"   GB size {len(gb)}; plus params forced literally to 0: {forced}")
    # check whether 1 is in the ideal (locus empty) as a control signal
    print(f"   unit ideal: {sp.Integer(1) in gb}")
