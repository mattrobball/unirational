"""Fatal anchors for the L12 order-11 machine phase.

A1  untwisted total on P^4 equals 1.
A2  untwisted total equals 1 after ARBITRARY random blowup towers.
A3  P^4 twisted totals equal chi_{Sym^k W*}(g) for k = 0..6 (Molien-independent
    reimplementation of the character; conventions of
    director_probes_20260811/molien_director.py: chi_W(11A) = sum_{q in QR} z^q).
A4  X twisted totals equal chi_{Sym^k W*}(g) for k = 0,1,2 and
    chi_{Sym^3 W*}(g) - 1 for k = 3.
A5  the LOCAL blowup mass identity (sum of children masses = parent mass).
A6  CONVENTION AUDIT (FLAG-A): the Sec.8 pair (numerator zeta^{-k a_j},
    denominator prod (1 - zeta^{a_k'-a_j})) as LITERALLY written is not a
    consistent Atiyah-Bott pair; exactly one of the two signs must flip.
    Both consistent completions are Galois conjugates of each other, so
    every PASS/FAIL verdict in this packet is convention-independent.
"""
import random

import cyclo as C
import l12core as L
import towers as T

random.seed(20260812)


def _checks():
    out = []

    def chk(name, ok, detail=""):
        out.append({"name": name, "ok": bool(ok), "detail": detail})
        return ok

    # ---- frame
    for k, v in L.check_frame().items():
        chk(f"A0 frame: {k}", v)

    # ---- A1 : untwisted total on P^4 = 1
    tot = C.total([C.inv(L.D_P4(j)) for j in range(5)])
    chk("A1 untwisted total on P^4 = 1", C.eq(tot, C.one()), C.to_str(tot))

    # ---- A5/A2 : blowup mass identity, then random towers
    ok_local = True
    ncomp = 0
    nlocal = 0
    for j in range(5):
        stack = [T.Site("pt", L.tangent_P4(j), 35 * L.A[j], ())]
        for _ in range(24):
            s = stack[random.randrange(len(stack))]
            if s.kind != "pt":
                continue
            for mu in range(0, 11):
                kids = T.blowup(s, mu)
                ncomp += sum(1 for kd in kids if kd.kind == "comp")
                nlocal += 1
                ok_local &= C.eq(T.mass(kids), s.term())
            stack.extend(k for k in T.blowup(s, random.randrange(1, 11))
                         if k.kind == "pt")
    chk(f"A5 local blowup mass identity ({nlocal} blowups, {ncomp} "
        f"positive-dimensional components)", ok_local)

    for trial in range(12):
        sites = [T.Site("pt", L.tangent_P4(j), 35 * L.A[j], ()) for j in range(5)]
        for _ in range(random.randint(1, 6)):
            idx = [i for i, s in enumerate(sites) if s.kind == "pt"]
            i = random.choice(idx)
            s = sites.pop(i)
            sites.extend(T.blowup(s, random.randrange(0, 11)))
        tot = T.mass(sites)
        if not chk(
            f"A2 untwisted total = 1 after random tower #{trial} "
            f"({len(sites)} fixed components)",
            C.eq(tot, C.one()),
        ):
            break

    # ---- A3 : P^4 twisted totals
    for k in range(0, 7):
        s = C.total([C.mul(L.wk(k, j), C.inv(L.D_P4(j))) for j in range(5)])
        chk(f"A3 P^4 twist k={k} equals chi_Sym^{k}W*(g)",
            C.eq(s, L.chi_sym_Wstar(k)), C.to_str(s))

    # ---- A4 : X twisted totals
    for k in range(0, 4):
        s = C.total([C.mul(L.wk(k, j), C.inv(L.D_X(j))) for j in range(5)])
        target = L.chi_sym_Wstar(k)
        if k == 3:
            target = C.sub(target, C.one())
        chk(f"A4 X twist k={k} equals genus-0 right side", C.eq(s, target),
            C.to_str(s))
    # and the Koszul route agrees for a few more k
    for k in range(4, 7):
        s = C.total([C.mul(L.wk(k, j), C.inv(L.D_X(j))) for j in range(5)])
        chk(f"A4' X twist k={k} equals chi_g(X,O(k)) via Koszul",
            C.eq(s, L.chi_OX(k)))

    # ---- A6 : convention audit (FLAG-A)
    def den_sec8(j):
        # prod_{k' not in {j,j+1}} (1 - zeta^{a_k' - a_j})  as literally written
        bad = {j, (j + 1) % 5}
        return C.prod([C.one_minus_zpow((L.A[i] - L.A[j]) % 11)
                       for i in range(5) if i not in bad])

    bad_hits = 0
    for k in (1, 2, 3):
        s = C.total([C.mul(L.wk(k, j), C.inv(den_sec8(j))) for j in range(5)])
        target = L.chi_sym_Wstar(k) if k < 3 else C.sub(L.chi_sym_Wstar(3), C.one())
        if not C.eq(s, target):
            bad_hits += 1
    chk("A6 FLAG-A: Sec.8 numerator+denominator as literally paired FAILS "
        "for k=1,2,3", bad_hits == 3)

    # the OTHER consistent completion (numerator zeta^{+k a_j} with the Sec.8
    # denominator) is the Galois conjugate sigma_{-1} of the adopted one
    ok_conj = True
    for k in (0, 1, 2, 3):
        s_adopt = C.total([C.mul(L.wk(k, j), C.inv(L.D_X(j))) for j in range(5)])
        s_other = C.total([C.mul(C.zpow(k * L.A[j]), C.inv(den_sec8(j)))
                           for j in range(5)])
        ok_conj &= C.eq(s_other, C.sigma(s_adopt, -1))
    chk("A6 both consistent completions are sigma_{-1}-conjugate "
        "(verdicts convention-independent)", ok_conj)

    return out


def run(verbose=True):
    out = _checks()
    if verbose:
        for c in out:
            print(f"  [{'PASS' if c['ok'] else 'FAIL'}] {c['name']}"
                  + (f"  ({c['detail']})" if c["detail"] and not c["ok"] else ""))
    return out


if __name__ == "__main__":
    res = run()
    nf = sum(1 for c in res if not c["ok"])
    print(f"anchors: {len(res) - nf}/{len(res)} pass")
