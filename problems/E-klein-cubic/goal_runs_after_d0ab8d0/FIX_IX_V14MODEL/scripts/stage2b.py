"""Stage 2 (final): the fixed-point arrangement, exactly, with G-orbit census
of every special point, plus the A5 / D12 emptiness confirmations."""
import json
import os
import subprocess
import sys

import fixloci
import fp
import geom
import groups
import v14lib as V

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
CHK = os.path.join(ROOT, "results", "checks.log")
M2DIR = os.path.join(HERE, "m2")
os.makedirs(M2DIR, exist_ok=True)

ORDER = ["C2", "C3", "C5", "C6", "C11", "V4", "D12", "A5"]
# Lefschetz prediction  L(g) = 4 - (chi_5 + chi_5bar)(g),  H^3(V14) = 5 + 5bar
LEF = {"C2": 2, "C3": 6, "C5": 4, "C6": 2, "C11": 5}


def check(name, ok, detail=""):
    line = f"CHECK {name} {'PASS' if ok else 'FAIL'} {detail}".rstrip()
    with open(CHK, "a") as f:
        f.write(line + "\n")
    print(line, flush=True)
    return ok


def lift10(model, basis10):
    return [geom._lincomb(model.Mrows, v, model.p) for v in basis10]


def m2_section(quads, nvars, label, p):
    names = [f"x{i}" for i in range(nvars)]
    qs = [q for q in (V.quad_to_str(qq, names) for qq in quads) if q != "0"]
    L = [f"kk = ZZ/{p};", f"R = kk[{','.join(names)}];"]
    if not qs:
        L.append(f'print("{label}|ALL|dim {nvars-1}|deg 1");')
    else:
        L.append("I = saturate ideal(" + ", ".join(qs) + ");")
        L.append(f'if I == ideal(1_R) then print("{label}|EMPTY") else (')
        L.append("  cs = minimalPrimes I;")
        L.append(f'  s := "{label}|dim " | toString(dim I - 1) | "|deg " | toString degree I '
                 '| "|ncomp " | toString(#cs);')
        L.append('  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | '
                 'toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";')
        L.append("  print s;)")
    return "\n".join(L) + "\n"


def run_m2(text, name):
    path = os.path.join(M2DIR, name)
    with open(path, "w") as f:
        f.write(text)
    r = subprocess.run(["M2", "--script", path], capture_output=True, text=True, timeout=7200)
    if r.returncode != 0:
        return "ERROR|" + (r.stderr or "")[-300:].replace("\n", " ")
    return r.stdout.strip()


def m2_determinantal_fix(model, D, label, p):
    """Fixed locus of a single element on V14, as an F_p-scheme (catches
    eigenvalues that are not in F_p)."""
    names = [f"y{i}" for i in range(10)]
    quads = model.quadrics()
    qs = [V.quad_to_str(q, names) for q in quads]
    rows = ",".join("{" + ",".join(str(D[i][j]) for j in range(10)) + "}" for i in range(10))
    L = [f"kk = ZZ/{p};", f"R = kk[{','.join(names)}];",
         f"Dm = matrix{{{rows}}};",
         "yv = transpose matrix{{" + ",".join(names) + "}};",
         "Nm = yv | (Dm * yv);",
         "I = saturate(ideal(" + ", ".join(qs) + ") + minors(2, Nm));",
         f'if I == ideal(1_R) then print("{label}|EMPTY") else '
         f'print("{label}|dim " | toString(dim I - 1) | "|deg " | toString degree I);']
    return "\n".join(L) + "\n"


def main(p, tag):
    model = V.Model(p)
    g15 = model.group15()
    allmats10 = [model.to10(X) for X in g15.values()]
    subs, byord = groups.pick(model)
    out = {}
    special = {}          # normalized point -> list of labels

    for name in ORDER:
        mats10 = [model.to10(g) for g in subs[name]]
        H = groups.subgroup(subs[name], p)
        pieces = fixloci.fixed_pieces(mats10, p)
        rec = dict(order=len(H), pieces=[])
        print(f"--- {name}  |H|={len(H)}  fixed pieces: "
              f"{[len(b) for _, b in pieces]}", flush=True)
        for evs, basis in pieces:
            d = len(basis)
            quads = model.quadrics(basis=lift10(model, basis))
            lbl = f"{name}[{','.join(map(str, evs))}]"
            m2out = run_m2(m2_section(quads, d, lbl, p),
                           f"sec_{tag}_{name}_{'_'.join(map(str, evs))}.m2")
            pts = []
            if d <= 4:
                for y in fixloci.points_in_P(quads, d, p):
                    full = geom._lincomb(basis, y, p)
                    pts.append(fixloci.normalize(full, p))
            rec["pieces"].append(dict(evs=list(evs), dim=d, m2=m2out,
                                      npts_Fp=len(pts), pts=[list(t) for t in pts],
                                      basis=basis))
            for t in pts:
                special.setdefault(t, []).append(lbl)
            print(f"    P^{d-1}  {m2out}   F_p-points: {len(pts)}", flush=True)
        out[name] = rec

    # ---- determinantal (field-independent) fixed locus for the cyclic groups
    det = {}
    for name in ["C2", "C3", "C5", "C6", "C11"]:
        D = model.to10(subs[name][0])
        det[name] = run_m2(m2_determinantal_fix(model, D, f"det{name}", p),
                           f"det_{tag}_{name}.m2")
        print("   ", det[name], flush=True)
    out["determinantal"] = det

    # ---- CHECKs
    def euler_from(name):
        """Euler characteristic of the fixed locus from the M2 component data."""
        chi = 0
        for pc in out[name]["pieces"]:
            s = pc["m2"]
            if "EMPTY" in s:
                continue
            if "|ALL|" in s:                     # whole linear piece lies on V14
                chi += 1 if pc["dim"] == 1 else 0
                continue
            for part in s.split("|"):
                if part.startswith("(d"):
                    dm = int(part[2:part.index(" ")])
                    if dm == 0:
                        chi += int(part[part.index("e") + 1:part.index(")")])
                    elif dm == 1:
                        g = int(part[part.index("g") + 1:part.index(")")])
                        chi += 2 - 2 * g
        return chi

    for name in ["C2", "C3", "C6", "C11"]:
        e = euler_from(name)
        check(f"lefschetz_{name}_{tag}", e == LEF[name],
              f"chi(V^{name}) = {e}, Lefschetz 4-(chi5+chi5bar) = {LEF[name]}")

    c5 = det["C5"]
    c5deg = int(c5.split("deg ")[1]) if "deg " in c5 else 0
    check(f"lefschetz_C5_{tag}", ("EMPTY" not in c5) and c5deg == LEF["C5"],
          f"det fixed locus of C5 on V14: {c5} (Lefschetz predicts {LEF['C5']} points)")

    nonempty = {}
    for name in ["C2", "C3", "C5", "C6", "C11", "V4"]:
        if name == "C5":
            nonempty[name] = "EMPTY" not in det["C5"]
        else:
            nonempty[name] = any("EMPTY" not in pc["m2"] for pc in out[name]["pieces"])
    check(f"condition_A_{tag}", all(nonempty.values()),
          "V14^H nonempty for every abelian H: " +
          ", ".join(f"{k}={'Y' if v else 'N'}" for k, v in nonempty.items()))

    for name in ["A5", "D12"]:
        emp = all("EMPTY" in pc["m2"] for pc in out[name]["pieces"])
        check(f"{name}_fixed_empty_{tag}", emp,
              f"V14^{name} = empty ({len(out[name]['pieces'])} character pieces, all empty)")

    # ---- G-orbit census of the special points
    census = []
    for t, labels in sorted(special.items()):
        y = list(t)
        orb = fixloci.orbit(y, allmats10, p)
        st = 660 // len(orb)
        census.append(dict(pt=y, labels=sorted(set(labels)), orbit=len(orb), stab=st))
    # collapse to orbits
    orbits = {}
    for c in census:
        orbits.setdefault(c["orbit"], []).append(c)
    print("\n  special F_p-points:", len(census))
    for k in sorted(orbits):
        labs = sorted({l for c in orbits[k] for l in c["labels"]})
        print(f"   orbit size {k:4d} (stab order {660//k:3d}):  "
              f"{len(orbits[k])} of the found points; from {labs}", flush=True)
    out["census"] = census

    with open(os.path.join(ROOT, "payload", f"fixed_loci_{tag}.json"), "w") as f:
        json.dump(out, f)
    return out


if __name__ == "__main__":
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 397
    main(p, f"p{p}")
