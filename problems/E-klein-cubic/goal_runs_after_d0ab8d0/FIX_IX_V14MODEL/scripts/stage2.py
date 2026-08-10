"""Stage 2: the fixed-point arrangement of V14 under every abelian subgroup,
plus the A5 / D12 emptiness confirmations."""
import json
import os
import subprocess
import sys

import fp
import geom
import groups
import v14lib as V

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
CHK = os.path.join(ROOT, "results", "checks.log")
M2DIR = os.path.join(HERE, "m2")
os.makedirs(M2DIR, exist_ok=True)


def check(name, ok, detail=""):
    line = f"CHECK {name} {'PASS' if ok else 'FAIL'} {detail}".rstrip()
    with open(CHK, "a") as f:
        f.write(line + "\n")
    print(line, flush=True)
    return ok


def eig_split(mats10, p):
    """Simultaneous eigenspaces over F_p.  Returns list of (eigvals, basis) and
    the total dimension covered (< 10 iff some eigenvalues are irrational)."""
    pieces = [((), [list(r) for r in fp.ident(10)])]
    for D in mats10:
        new = []
        for evs, basis in pieces:
            if not basis:
                continue
            k = len(basis)
            # matrix of D restricted to span(basis) in that basis
            _, piv = fp.rref(basis, p)
            Rb = fp.rowspace_basis(basis, p)
            _, piv = fp.rref(Rb, p)
            Dres = []
            for a in range(len(Rb)):
                w = fp.matvec(D, Rb[a], p)
                Dres.append([w[c] for c in piv])
            Dres = [[Dres[a][i] for a in range(len(Rb))] for i in range(len(Rb))]
            n = len(Rb)
            for lam in range(p):
                Y = fp.madd(Dres, fp.scal(fp.ident(n), (-lam) % p, p), p)
                ns = fp.nullspace(Y, p)
                if ns:
                    sub = [geom._lincomb(Rb, v, p) for v in ns]
                    new.append((evs + (lam,), fp.rowspace_basis(sub, p)))
        pieces = new
    tot = sum(len(b) for _, b in pieces)
    return pieces, tot


def lift10(model, basis10):
    """M-coordinate vectors -> Lambda^2 U (15-dim) coordinate vectors."""
    return [geom._lincomb(model.Mrows, v, model.p) for v in basis10]


def restrict_quads(model, basis10):
    return model.quadrics(basis=lift10(model, basis10))


def m2_for(quads, nvars, label, p):
    names = [f"x{i}" for i in range(nvars)]
    qs = [V.quad_to_str(q, names) for q in quads]
    qs = [q for q in qs if q != "0"]
    lines = [f"kk = ZZ/{p};", f"R = kk[{','.join(names)}];"]
    if not qs:
        lines.append(f'print("{label} dim {nvars - 1} degree 1 comps LINEAR_ALL");')
    else:
        lines.append("I = saturate ideal(" + ", ".join(qs) + ");")
        lines.append('if I == ideal(1_R) then print("%s EMPTY") else (' % label)
        lines.append('  cs = minimalPrimes I;')
        lines.append('  print("%s dim " | toString(dim I - 1) | " degree " | toString degree I | '
                     '" ncomp " | toString(#cs));' % label)
        lines.append('  for c in cs do print("%s   comp dim " | toString(dim c - 1) | '
                     '" degree " | toString degree c | " genus " | toString(if dim c == 2 then '
                     'genus c else -999));' % label)
        lines.append(");")
    return "\n".join(lines) + "\n"


def run_m2(text, name):
    path = os.path.join(M2DIR, name)
    with open(path, "w") as f:
        f.write(text)
    r = subprocess.run(["M2", "--script", path], capture_output=True, text=True, timeout=3600)
    if r.returncode != 0:
        return "ERROR " + (r.stderr or "")[-400:]
    return r.stdout.strip()


def main(p, tag):
    model = V.Model(p)
    g15 = model.group15()
    subs, byord = groups.pick(model)
    results = {}
    report = []

    order = ["C2", "C3", "C5", "C6", "C11", "V4", "D12", "A5"]
    for name in order:
        gens15 = subs[name]
        mats10 = [model.to10(g) for g in gens15]
        pieces, tot = eig_split(mats10, p)
        H = groups.subgroup(gens15, p)
        info = dict(order=len(H), pieces=[], rational_dim=tot)
        for evs, basis in pieces:
            d = len(basis)
            lbl = f"{name}:{'.'.join(str(e) for e in evs)}"
            quads = restrict_quads(model, basis)
            outp = run_m2(m2_for(quads, d, lbl, p), f"fix_{tag}_{name}_{'_'.join(map(str,evs))}.m2")
            info["pieces"].append(dict(evs=list(evs), dim_lin=d, m2=outp, basis=basis))
            report.append(f"[{tag}] {lbl}  P^{d-1}:  {outp}")
        results[name] = info
        print(f"--- {name} (|H|={len(H)}) rational eigen-dim {tot}/10", flush=True)
        for ln in report[-len(pieces):]:
            print("   ", ln, flush=True)

    with open(os.path.join(ROOT, "payload", f"fixed_loci_{tag}.json"), "w") as f:
        json.dump(results, f)
    return results


if __name__ == "__main__":
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 397
    main(p, f"p{p}")
