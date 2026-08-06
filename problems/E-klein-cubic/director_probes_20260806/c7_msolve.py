import sys, sympy as sp
sys.path.insert(0, '/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION')
import indep_r7 as I
om = I.om; kp = I.kp
x, y, z = sp.symbols('x y z')

def build(tag, lamS, po1_name):
    names, T, eqs = I.landing_equations(7, 1, lamS)
    eqs = [e for _, e in eqs] if eqs and isinstance(eqs[0], tuple) else list(eqs)
    slots = list(T)
    deep = set()
    for i in range(3):
        p = sp.Poly(slots[i], x, y, z)
        for mono, coeff in zip(p.monoms(), p.coeffs()):
            if mono[1] + mono[2] == 2:
                deep |= (coeff.free_symbols - {om, kp})
    subs0 = {v: sp.Integer(0) for v in deep}
    eqs2 = [sp.expand(e.subs(subs0)) for e in eqs]
    eqs2 = [e for e in eqs2 if e != 0]
    syms = sorted(set().union(*[e.free_symbols for e in eqs2]) - {om, kp}, key=str)
    t = sp.Symbol('taux')
    po1v = sp.Symbol(po1_name)
    system = [sp.together(e) for e in eqs2] + [po1v*t - 1, om**2 + om + 1, 8*kp**2 - 13*kp - 4]
    polys = []
    for e in system:
        n, d = sp.fraction(sp.cancel(e))
        polys.append(sp.expand(n))
    gens = syms + [t, om, kp]
    lines = [",".join(str(g) for g in gens), "0"]
    body = []
    for pp in polys:
        s = sp.sstr(pp).replace('**','^').replace(' ','')
        assert '(' not in s, s[:80]
        body.append(s)
    open(f'c7_{tag}_{po1_name}.ms','w').write("\n".join(lines) + "\n" + ",\n".join(body) + "\n")
    return len(polys), len(gens)

for tag, lamS in (('one', sp.Integer(1)), ('om', om), ('om2', I.kred(om**2))):
    for po1 in ('B5','B8'):
        ne, ng = build(tag, lamS, po1)
        print(f"emitted c7_{tag}_{po1}.ms: {ne} polys, {ng} gens", flush=True)
