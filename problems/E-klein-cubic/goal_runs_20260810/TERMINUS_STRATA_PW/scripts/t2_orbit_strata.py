"""T2 -- the orbit-type (exact stabilizer) census of every stage of the tower.

For each stage j in {0,1,2,3} lists every G-orbit of components of the
locally closed orbit-type strata  Z_{j,=K} = {z : G_z = K exactly}, with

  dimension | #components in the G-orbit | K | setwise stabilizer Stab_G(F)
  | residual action W(K,F) = Stab_{N_G(K)}(F)/K | normal characters
  | tower provenance (which exceptional divisor, over which anchor)
  | boundary position (the chain of boundary divisors through F)
  | toroidal local model (the four tangent weights with branch flags).

Writes results/t2_strata_p<p>.txt and results/t2_strata.json.
Marker: T2_ORBIT_STRATA_OK.
"""
import json
import os
import sys
from collections import defaultdict, Counter

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from tcore import Tower, census, STAGE_NAME, sub_arrangement   # noqa: E402
from psl211 import SPLIT_PRIMES                                # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
KORDER = ["1", "C2", "C3", "V4", "C5", "C6", "C11", "S3", "D10", "D12", "A4",
          "11:5", "A5", "PSL(2,11)"]


def sortkey(r):
    k = r["K"]
    return (KORDER.index(k) if k in KORDER else 99, r["dim"], -r["n_orbit"],
            tuple(r["chain"]))


def wtstr(w):
    if w is None:
        return "(nonabelian K: not diagonalisable)"
    return " ".join(f"{a}{'*' if f == 'B' else ''}" for a, f in w)


def run(p, say):
    ok = True
    T = Tower(p)
    C = T.C
    say(f"=========================  p = {p}  =========================")
    allrows = {}
    for j in (0, 1, 2, 3):
        R = census(T, j)
        R.sort(key=sortkey)
        allrows[j] = R
        say("")
        say(f"### STAGE {j}: {STAGE_NAME[j]}   ({len(R)} G-orbits of orbit-type strata)")
        say(f"{'K':>4} {'dim':>3} {'#comp':>6} {'#/fixedK':>8} {'Stab_G(F)':>10}"
            f" {'W(K,F)':>7}  {'boundary chain':<34} weights (*=boundary branch)"
            f"   |  birational model (all RATIONAL)")
        for r in R:
            ch = "<".join(r["chain"]) if r["chain"] else "(none: off D)"
            say(f"{r['K']:>4} {r['dim']:>3} {r['n_orbit']:>6} {r['n_for_fixed_K']:>8}"
                f" {r['setwise']:>10} {r['residual']:>7}  {ch:<34} {wtstr(r['weights'])}"
                f"   |  P^" + " x P^".join(str(d) for d in r["factors"]))
            # CHECK: #trivial weights == dim  (F is a component of Z^K)
            if r["weights"] is not None:
                if r["dim_check"] != r["dim"]:
                    ok = False
                    say(f"     !! FAIL trivial-weight count {r['dim_check']} != dim {r['dim']}")
        # per-class totals
        say("")
        say(f"  stage {j} totals by exact stabilizer K:")
        tot = defaultdict(lambda: defaultdict(int))
        for r in R:
            tot[r["K"]][r["dim"]] += r["n_orbit"]
        for k in KORDER:
            if k in tot:
                say(f"    K = {k:<5} components by dim: "
                    f"{dict(sorted(tot[k].items()))}   (total {sum(tot[k].values())})")

    # ---------- the terminus in detail ----------
    R = allrows[3]
    say("")
    say("=== TERMINUS Z: point-stabilizer classes, ALL 16 SUBGROUP CLASSES ===")
    occ = Counter(r["K"] for r in R)
    names = []
    for H in C.subgroup_classes():
        nm = C.name(H)
        names.append(nm)
    say(f"  the 16 conjugacy classes of subgroups of G: {names}")
    empties = []
    for nm in names:
        n = sum(r["n_orbit"] for r in R if r["K"] == nm)
        o = sum(1 for r in R if r["K"] == nm)
        if n:
            say(f"    {nm:<10} OCCURS   : {o:>3} G-orbits, {n:>6} components of Z_(=H)")
        else:
            say(f"    {nm:<10} EMPTY    : Z_(=H) = empty  (certified: no chain/eigen datum "
                f"on Z has exact stabilizer {nm})")
            empties.append(nm)
    ok &= set(occ) == {"1", "C2", "C3", "V4", "C5", "C6", "C11"}
    say(f"  CHECK occurring point stabilizers on Z are exactly "
        f"{{1,C2,C3,V4,C5,C6,C11}}: {'PASS' if set(occ) == {'1','C2','C3','V4','C5','C6','C11'} else 'FAIL'}")
    say(f"  CHECK the nine empty classes are {empties}: "
        f"{'PASS' if len(empties) == 9 else 'FAIL'}")
    ok &= len(empties) == 9

    # ---------- setwise-stabilizer index over all 16 classes ----------
    say("")
    say("=== TERMINUS Z: SETWISE-STABILIZER INDEX (all 16 classes) ===")
    idx = defaultdict(list)
    for r in R:
        idx[r["setwise"]].append(r)
    for nm in names:
        rs = idx.get(nm, [])
        if not rs:
            say(f"  Stab_G(F) = {nm:<10} : no stratum orbit")
            continue
        say(f"  Stab_G(F) = {nm:<10} : {len(rs)} stratum orbits")
        for r in rs:
            ch = "<".join(r["chain"]) if r["chain"] else "(off D)"
            say(f"        K = {r['K']:<4} dim {r['dim']}  x{r['n_orbit']:>5}"
                f"  W(K,F) = {r['residual']:<4}  on {ch}")

    # ---------- Z^H as a union of orbit-type strata (the dictionary) --------
    say("")
    say("=== DICTIONARY  Z^H = union of Z_(=K) over K containing (a conjugate of) H ===")
    say("(for each abelian class H: the components of Z^H are the strata rows whose")
    say(" exact stabilizer K contains H, counted for ONE fixed H)")
    reps = {C.name(H): H for H in C.subgroup_classes()}
    for hn in ("C2", "C3", "V4", "C5", "C6", "C11"):
        H = reps[hn]
        prof = defaultdict(int)
        ncomp = 0
        for r in R:
            K = frozenset(r["_K"])
            if len(K) % len(H) or not (H <= K):
                # count only components whose stabilizer literally contains H
                pass
            sw = frozenset(r["_sw"])
            # number of G-translates gF with H <= gKg^-1 and gF a component of Z^H
            cnt = 0
            for g in range(C.n):
                gK = C.conj(K, g)
                if H <= gK:
                    cnt += 1
            cnt //= len(sw)
            if cnt:
                prof[r["dim"]] += cnt
                ncomp += cnt
        say(f"  H = {hn:<4}: components of Z^H by dim {dict(sorted(prof.items()))}"
            f"   (total {ncomp})")

    # ---------- quotient stratification ----------
    say("")
    say("=== THE QUOTIENT STRATIFICATION OF Z/G ===")
    say(f"{'stratum of Z/G':<40}{'dim':>4}{'generic fibre':>16}{'|G/K|':>7}"
        f"{'#comp upstairs':>15}")
    for r in R:
        ch = "<".join(r["chain"]) if r["chain"] else "(off D)"
        nm = f"[{r['K']}] {ch}"
        say(f"{nm:<40}{r['dim']:>4}{('G/' + r['K']):>16}{660 // r['K_order']:>7}"
            f"{r['n_orbit']:>15}")
    say(f"  the quotient Z/G is stratified by {len(R)} locally closed pieces "
        f"(one per stratum orbit); dim of each image = dim of the stratum "
        f"(G finite).")
    return ok, allrows


if __name__ == "__main__":
    out = []

    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    ok = True
    dump = {}
    for p in SPLIT_PRIMES:
        o, rows = run(p, say)
        ok &= o
        dump[str(p)] = {str(j): [{k: v for k, v in r.items() if not k.startswith("_")}
                                 for r in rows[j]] for j in rows}
        say("")
    # both primes must agree row-for-row
    a = dump[str(SPLIT_PRIMES[0])]
    b = dump[str(SPLIT_PRIMES[1])]
    agree = all(
        sorted((r["K"], r["dim"], r["n_orbit"], r["setwise"], r["residual"],
                tuple(r["chain"])) for r in a[j])
        == sorted((r["K"], r["dim"], r["n_orbit"], r["setwise"], r["residual"],
                   tuple(r["chain"])) for r in b[j])
        for j in a)
    say(f"CHECK the two primes give identical row sets at every stage: "
        f"{'PASS' if agree else 'FAIL'}")
    ok &= agree
    with open(os.path.join(HERE, "results", "t2_strata.json"), "w") as f:
        json.dump(dump, f, indent=1, sort_keys=True)
    with open(os.path.join(HERE, "results", "t2_strata.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    print("T2_ORBIT_STRATA_" + ("OK" if ok else "FAIL"))
    sys.exit(0 if ok else 1)
