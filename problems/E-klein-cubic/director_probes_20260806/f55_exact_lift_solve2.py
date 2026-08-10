#!/usr/bin/env python3
"""f55_exact_lift_solve2.py -- solver, formulation 2.

Formulation 1 (one Rabinowitsch variable inverting the PRODUCT of all 19
extremal coefficients) makes a degree-20 generator and is hopeless.  Here:

  * normalise with the 2-torus that acts on every solution
      lambda : D_ab -> lambda*D_ab            (projective scale)
      mu     : z -> mu*z, coeff at z^k -> mu^k * coeff   (reparametrisation)
    Both act over the ALGEBRAIC CLOSURE with surjective orbit maps, so
    normalising one coefficient at exponent 0 and one at a positive exponent
    to 1 loses no F-bar point.
  * invert the remaining required-nonzero coefficients with ONE INVERSE
    VARIABLE EACH (all generators then have degree <= 2).
  * cross-check with M2's successive `saturate`, which is exactly
    I : (f1*f2*...*fn)^infinity.

Every emptiness verdict is produced by >= 2 engines and is accompanied by the
GATE-1 unit / non-unit parser controls from f55_exact_lift_run.py.
"""
import sys, os, json, subprocess
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from f55_exact_lift_system import System, INDEP, PAIRS, vname, poly_str

M2 = '/opt/homebrew/bin/M2'
SING = '/opt/homebrew/bin/Singular'
MSOLVE = '/opt/homebrew/bin/msolve'


def build(S, mod, invert='each'):
    """returns (vars, gens, normalized-vars, inverted-vars)"""
    eqs = S.equations()
    gens = [poly_str(p, mod=mod) for (_, _, p) in eqs]
    varlist = list(S.vars)
    nz = sorted({vname(pr, 0) for pr in INDEP} | {vname(pr, len(S.exps[pr]) - 1) for pr in INDEP})
    normed = []
    # lambda: the z^0 coefficient of D_49 (w_49 = 0, so it is required nonzero)
    n0 = vname((4, 9), 0)
    gens.append(f"{n0}-1")
    normed.append(n0)
    # mu: any required-nonzero coefficient sitting at a POSITIVE z-exponent
    cand = None
    for pr in INDEP:
        for i in (len(S.exps[pr]) - 1, 0):
            if S.exps[pr][i] > 0:
                cand = vname(pr, i)
                break
        if cand:
            break
    if cand:
        gens.append(f"{cand}-1")
        normed.append(cand)
    inv = [v for v in nz if v not in normed]
    if invert == 'each':
        for k, v in enumerate(inv):
            varlist.append(f"iv{k}")
            gens.append(f"iv{k}*{v}-1")
    return varlist, gens, normed, inv


def write_and_run(S, tag, mod, invert='each', do_msolve=True, timeout=3600):
    varlist, gens, normed, inv = build(S, mod, invert=invert)
    base = os.path.join(HERE, f"f55_exact_lift_{tag}")
    kk = f"ZZ/{mod}" if mod else "QQ"
    with open(base + ".m2", 'w') as f:
        f.write(f"kk = {kk};\nR = kk[{','.join(varlist)}];\n")
        f.write("I = ideal(\n  " + ",\n  ".join(gens) + "\n);\n")
        f.write("G = gb I; g = flatten entries gens G;\n")
        f.write("isunit = (#g == 1 and (first g) == 1_R);\n")
        f.write(f'<< "{tag} M2 unit=" << isunit << " ngens=" << #g << endl;\n')
    with open(base + ".sing", 'w') as f:
        f.write(f"ring r = {mod if mod else 0},({','.join(varlist)}),dp;\n")
        f.write("ideal I = " + ",\n  ".join(gens) + ";\nideal G = std(I);\n")
        f.write(f'"{tag} SINGULAR leadone=" + string(size(G)==1 && lead(G[1])==1)'
                f' + " size=" + string(size(G));\n')
        f.write("quit;\n")
    res = {}
    r = subprocess.run([M2, '--script', base + '.m2'], capture_output=True, text=True, timeout=timeout)
    res['M2'] = (r.stdout.strip() or 'ERR:' + r.stderr.strip()[:200])
    r = subprocess.run([SING, '-q', base + '.sing'], capture_output=True, text=True, timeout=timeout)
    res['SING'] = (r.stdout.strip() or 'ERR:' + r.stderr.strip()[:200])
    if mod and do_msolve:
        with open(base + ".ms", 'w') as f:
            f.write(",".join(varlist) + f"\n{mod}\n" + ",\n".join(gens) + "\n")
        out = base + ".out"
        if os.path.exists(out):
            os.remove(out)
        r = subprocess.run([MSOLVE, '-g', '2', '-f', base + '.ms', '-o', out],
                           capture_output=True, text=True, timeout=timeout)
        if not os.path.exists(out):
            res['MSOLVE'] = 'ERROR-NO-OUTPUT-FILE'
        elif len(open(out).read().strip()) == 0:
            res['MSOLVE'] = 'ERROR-EMPTY-OUTPUT-FILE'
        else:
            raw = open(out).read()
            body = "\n".join(l for l in raw.splitlines() if not l.lstrip().startswith('#')).strip()
            if body.endswith(':'):
                body = body[:-1].strip()
            if body.startswith('[') and body.endswith(']'):
                body = body[1:-1].strip()
            toks = [t.strip() for t in body.replace('\n', '').split(',') if t.strip()]
            res['MSOLVE'] = 'UNIT' if (len(toks) == 1 and toks[0] in ('1', '-1')) else 'NONUNIT'
    return res, varlist, gens, normed, inv


def m2_saturate(S, tag, mod, timeout=3600):
    """independent cross-check: I : (product of required-nonzero coeffs)^infinity,
       done as M2 SUCCESSIVE saturation (which is exactly that ideal quotient)."""
    eqs = S.equations()
    gens = [poly_str(p, mod=mod) for (_, _, p) in eqs]
    varlist = list(S.vars)
    nz = sorted({vname(pr, 0) for pr in INDEP} | {vname(pr, len(S.exps[pr]) - 1) for pr in INDEP})
    n0 = vname((4, 9), 0)
    gens.append(f"{n0}-1")
    base = os.path.join(HERE, f"f55_exact_lift_{tag}sat")
    kk = f"ZZ/{mod}" if mod else "QQ"
    with open(base + ".m2", 'w') as f:
        f.write(f"kk = {kk};\nR = kk[{','.join(varlist)}];\n")
        f.write("I = ideal(\n  " + ",\n  ".join(gens) + "\n);\n")
        f.write("J = saturate(I, {" + ",".join(nz) + "});\n")
        f.write("gj = flatten entries gens J;\n")
        f.write("isunit = (#gj == 1 and (first gj) == 1_R);\n")
        f.write(f'<< "{tag} M2SAT unit=" << isunit << " ngens=" << #gj << endl;\n')
    r = subprocess.run([M2, '--script', base + '.m2'], capture_output=True, text=True, timeout=timeout)
    return r.stdout.strip() or ('ERR:' + r.stderr.strip()[:300])


def load_profiles():
    prof = json.load(open(os.path.join(HERE, 'f55_exact_lift_profiles.json')))
    w = {tuple(int(c) for c in k): v for k, v in prof['w'].items()}
    return prof['sigma'], w, prof['profiles']


if __name__ == '__main__':
    mods = [int(x) for x in sys.argv[1:]] or [397]
    sigma, w, profiles = load_profiles()
    emin = min(p['e'] for p in profiles)
    for idx, p in enumerate([x for x in profiles if x['e'] == emin]):
        wp = {tuple(int(c) for c in k): v for k, v in p['wp'].items()}
        S = System(sigma, emin, w=w, wp=wp)
        for mod in mods:
            res, vl, gens, normed, inv = write_and_run(S, f"f2p{idx}m{mod}", mod)
            print(f"profile {idx} mod {mod}: vars={len(vl)} eqs={len(gens)} "
                  f"normed={normed} -> {res}", flush=True)
