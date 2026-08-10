#!/usr/bin/env python3
"""f55_exact_lift_run.py -- the exact-lift campaign, step D: SOLVE.

Runs, in order:
  GATE-0  generator self-check: the KNOWN pentagon-line solution is substituted
          into the generated equations and must vanish identically; a perturbed
          version must NOT vanish.  (validates Plucker signs, E_q, t_q, supports)
  GATE-1  parser controls: a unit ideal and a non-unit ideal through every
          engine, so that every emptiness verdict below is read by a test that
          demonstrably distinguishes the two.
  GATE-2  the free-support system at (sigma, e) with NO profile constraints:
          must come back NON-EMPTY (pentagon-line covers live there).
  MAIN    the Lemma G profiles.

Engines: Macaulay2, Singular, msolve (ff-mode, bare integer coefficients).
"""
import sys, os, json, subprocess, re
from fractions import Fraction
from itertools import combinations

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from f55_exact_lift_system import (System, build_ideal, emit, PAIRS, QUADS, INDEP,
                                   DIAG, QR, CD, TQ, vname, L)

M2 = '/opt/homebrew/bin/M2'
SING = '/opt/homebrew/bin/Singular'
MSOLVE = '/opt/homebrew/bin/msolve'


# ---------------------------------------------------------------- engines
def run_m2(path):
    r = subprocess.run([M2, '--script', path], capture_output=True, text=True, timeout=7200)
    return r.stdout.strip(), r.stderr.strip()


def run_sing(path):
    r = subprocess.run([SING, '-q', path], capture_output=True, text=True, timeout=7200)
    return r.stdout.strip(), r.stderr.strip()


def run_msolve(path, out):
    if os.path.exists(out):
        os.remove(out)
    r = subprocess.run([MSOLVE, '-g', '2', '-f', path, '-o', out],
                       capture_output=True, text=True, timeout=7200)
    if not os.path.exists(out):
        return 'ERROR-NO-OUTPUT-FILE', r.stderr.strip()
    raw = open(out).read()
    if len(raw.strip()) == 0:
        return 'ERROR-EMPTY-OUTPUT-FILE', r.stderr.strip()
    # HAZARD: msolve -g output starts with a '#' comment header and the basis is
    # printed as "[g1,\ng2,...]:".  Strip comments, then the trailing ':' and the
    # surrounding brackets, THEN compare the body -- never startswith('[1]').
    body = "\n".join(ln for ln in raw.splitlines() if not ln.lstrip().startswith('#'))
    body = body.strip()
    if body.endswith(':'):
        body = body[:-1].strip()
    if body.startswith('[') and body.endswith(']'):
        body = body[1:-1].strip()
    toks = [t.strip() for t in body.replace('\n', '').split(',') if t.strip()]
    unit = (len(toks) == 1 and toks[0] in ('1', '-1'))
    return ('UNIT' if unit else 'NONUNIT'), (raw[:300], r.stderr.strip()[:200])


# ---------------------------------------------------------------- helpers
def evaluate(S, assign):
    """substitute a dict var->Fraction into every generated Plucker equation;
       return the list of nonzero residues."""
    bad = []
    for (quad, ex, poly) in S.equations():
        v = Fraction(0)
        for mono, c in poly.items():
            t = c
            for var in mono:
                t *= assign.get(var, Fraction(0))
            v += t
        if v != 0:
            bad.append((quad, ex, v))
    return bad


def gate0(sigma=7, e=39):
    """GATE-0: the pentagon line (and a cover of it) must satisfy the system."""
    w = {pr: 0 for pr in PAIRS}
    wp = {pr: 0 for pr in PAIRS}
    S = System(sigma, e, w=w, wp=wp, free=True)
    d = (sigma * 5) % 11                       # exponent of z in D_34
    assign = {v: Fraction(0) for v in S.vars}
    assign[vname((4, 9), S.exps[(4, 9)].index(0))] = Fraction(1)
    assign[vname((3, 4), S.exps[(3, 4)].index(d))] = Fraction(-1)
    bad = evaluate(S, assign)
    print(f"  GATE-0a pentagon line (D49=1, D34=-z^{d}) residues: "
          f"{'ALL ZERO (pass)' if not bad else bad[:4]}")
    ok1 = not bad
    # a genuine cover: D49 = 1 + z^11, D34 = -z^d (1 + z^11)
    assign2 = dict(assign)
    for pr, coef in (((4, 9), Fraction(1)), ((3, 4), Fraction(-1))):
        k = S.exps[pr][0] + 11
        if k in S.exps[pr]:
            assign2[vname(pr, S.exps[pr].index(k))] = coef
    bad2 = evaluate(S, assign2)
    print(f"  GATE-0b pentagon-line 11-cover residues: "
          f"{'ALL ZERO (pass)' if not bad2 else bad2[:4]}")
    # perturbation: switch on a u_0-minor -> must break something
    assign3 = dict(assign)
    assign3[vname((0, 9), 0)] = Fraction(1)
    bad3 = evaluate(S, assign3)
    print(f"  GATE-0c perturbed (D09 switched on) residues nonzero: "
          f"{'YES (pass)' if bad3 else 'NO (FAIL)'}  [{len(bad3)} broken equations]")
    return ok1 and not bad2 and bool(bad3)


def gate1(mod):
    """GATE-1: unit + non-unit controls through all three engines."""
    res = {}
    for tag, gens, expect in (('ctrlUNIT', ['xx-1', 'xx'], 'unit'),
                              ('ctrlNONUNIT', ['xx*yy-1'], 'nonunit')):
        base = os.path.join(HERE, f"f55_exact_lift_{tag}_p{mod}")
        varlist = ['xx', 'yy']
        with open(base + '.m2', 'w') as f:
            f.write(f"kk = ZZ/{mod};\nR = kk[{','.join(varlist)}];\n")
            f.write("I = ideal(" + ",".join(gens) + ");\n")
            f.write("G = gb I; g = flatten entries gens G;\n")
            f.write("isunit = (#g == 1 and (first g) == 1_R);\n")
            f.write(f'<< "{tag} M2 unit=" << isunit << endl;\n')
        with open(base + '.sing', 'w') as f:
            f.write(f"ring r = {mod},({','.join(varlist)}),dp;\n")
            f.write("ideal I = " + ",".join(gens) + ";\nideal G = std(I);\n")
            f.write(f'"{tag} SINGULAR leadone=" + string(size(G)==1 && lead(G[1])==1);\n')
            f.write("quit;\n")
        with open(base + '.ms', 'w') as f:
            f.write(",".join(varlist) + f"\n{mod}\n" + ",\n".join(gens) + "\n")
        a = run_m2(base + '.m2')[0]
        b = run_sing(base + '.sing')[0]
        c = run_msolve(base + '.ms', base + '.out')[0]
        res[tag] = (a, b, c, expect)
        print(f"  GATE-1 {tag:12s} expect {expect:8s} | M2: {a} | SING: {b} | MSOLVE: {c}")
    ok = ('true' in res['ctrlUNIT'][0] and 'UNIT' == res['ctrlUNIT'][2]
          and 'false' in res['ctrlNONUNIT'][0] and 'NONUNIT' == res['ctrlNONUNIT'][2]
          and 'leadone=1' in res['ctrlUNIT'][1] and 'leadone=0' in res['ctrlNONUNIT'][1])
    print(f"  GATE-1 verdict: {'PASS' if ok else 'FAIL'}")
    return ok


def solve(S, tag, mod, rabino=True, normalize=True):
    varlist, gens, nz = build_ideal(S, mod=mod, rabino=rabino, normalize=normalize)
    base = os.path.join(HERE, f"f55_exact_lift_{tag}")
    kk = f"ZZ/{mod}" if mod else "QQ"
    with open(base + ".m2", 'w') as f:
        f.write(f"kk = {kk};\nR = kk[{','.join(varlist)}];\n")
        f.write("I = ideal(\n  " + ",\n  ".join(gens) + "\n);\n")
        f.write("G = gb I; g = flatten entries gens G;\n")
        f.write("isunit = (#g == 1 and (first g) == 1_R);\n")
        f.write(f'<< "{tag} M2 unit=" << isunit << " ngens=" << #g'
                f' << " dim=" << (if isunit then -1 else dim I) << endl;\n')
    with open(base + ".sing", 'w') as f:
        f.write(f"ring r = {mod if mod else 0},({','.join(varlist)}),dp;\n")
        f.write("ideal I = " + ",\n  ".join(gens) + ";\nideal G = std(I);\n")
        f.write(f'"{tag} SINGULAR leadone=" + string(size(G)==1 && lead(G[1])==1)'
                f' + " size=" + string(size(G)) + " dim=" + string(dim(G));\n')
        f.write("quit;\n")
    outs = {}
    outs['M2'] = run_m2(base + ".m2")
    outs['SING'] = run_sing(base + ".sing")
    if mod:
        with open(base + ".ms", 'w') as f:
            f.write(",".join(varlist) + f"\n{mod}\n" + ",\n".join(gens) + "\n")
        outs['MSOLVE'] = run_msolve(base + ".ms", base + ".out")
    return varlist, gens, nz, outs


def report(tag, outs, nvars, neqs):
    m2 = outs['M2'][0] or ('STDERR:' + outs['M2'][1][:200])
    sg = outs['SING'][0] or ('STDERR:' + outs['SING'][1][:200])
    ms = outs.get('MSOLVE', ('n/a', ''))[0]
    print(f"    [{tag}] vars={nvars} eqs={neqs}")
    print(f"      M2      : {m2}")
    print(f"      SINGULAR: {sg}")
    print(f"      MSOLVE  : {ms}")
    return m2, sg, ms


def main():
    mods = [int(x) for x in sys.argv[1:]] or [397, 199, 331]
    print("=" * 74)
    print("GATE-0  generator self-check")
    g0 = gate0()
    print("=" * 74)
    print("GATE-1  engine parser controls (mod %d)" % mods[0])
    g1 = gate1(mods[0])
    assert g0 and g1, "GATES FAILED -- verdicts below would be untrustworthy"

    print("=" * 74)
    print("GATE-2  free-support NON-EMPTY control at sigma=7, e=13 "
          "(pentagon-line covers live there; all engines must say NON-UNIT)")
    Sf = System(7, 13, w={pr: 0 for pr in PAIRS}, wp={pr: 0 for pr in PAIRS}, free=True)
    # the witness: D_49 = 1, D_34 = -z^2  (a pentagon line, sigma = 7)
    wit = {v: Fraction(0) for v in Sf.vars}
    wit[vname((4, 9), Sf.exps[(4, 9)].index(0))] = Fraction(1)
    wit[vname((3, 4), Sf.exps[(3, 4)].index(2))] = Fraction(-1)
    print(f"  witness residues: {'ALL ZERO' if not evaluate(Sf, wit) else 'NONZERO (FAIL)'}")
    vl, gens, nz, outs = solve(Sf, f"gate2free_p{mods[0]}", mods[0],
                               rabino=False, normalize=False)
    m2, sg, ms = report('GATE-2', outs, len(vl), len(gens))
    g2 = ('unit=false' in m2) and ('leadone=0' in sg) and (ms == 'NONUNIT')
    print(f"  GATE-2 verdict: {'PASS' if g2 else 'FAIL'}")
    assert g2, "GATE-2 FAILED"

    prof = json.load(open(os.path.join(HERE, 'f55_exact_lift_profiles.json')))
    sigma = prof['sigma']
    w = {tuple(int(c) for c in k): v for k, v in prof['w'].items()}
    emin = min(q['e'] for q in prof['profiles'])
    plist = [p for p in prof['profiles'] if p['e'] == emin]
    e = emin
    print("=" * 74)
    print(f"MAIN  Lemma G profiles, sigma = {sigma}, e = {e}, count = {len(plist)}")
    results = {}
    for idx, p in enumerate(plist):
        wp = {tuple(int(c) for c in k): v for k, v in p['wp'].items()}
        S = System(sigma, e, w=w, wp=wp)
        print(f"\n  --- profile {idx}: w' = {p['wp']}")
        print(f"      form supports: "
              f"{ {f'{a}{b}': S.exps[(a,b)] for (a,b) in INDEP} }")
        for mod in mods + [None]:
            vl, gens, nz, outs = solve(S, f"lemG{idx}_p{mod}", mod)
            results[f"{idx}_{mod}"] = report(f"profile {idx} char {mod or 0}",
                                             outs, len(vl), len(gens))
    print("=" * 74)
    json.dump(results, open(os.path.join(HERE, 'f55_exact_lift_results.json'), 'w'), indent=1)


if __name__ == '__main__':
    main()
