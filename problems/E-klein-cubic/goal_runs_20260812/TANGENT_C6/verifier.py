#!/usr/bin/env python3
"""Replayable verifier for TANGENT_C6.

Default: polar identities over Z + stored artefacts.
--live: rebuild the 37-cell at p=331, recompute ρ(0) and two random ranks.

Machine markers: TANGENT_C6_VERIFY_OK / ALLGREEN
"""
from __future__ import annotations

import json
import os
import sys

os.environ.setdefault("OMP_NUM_THREADS", "1")
os.environ.setdefault("OPENBLAS_NUM_THREADS", "1")
os.environ.setdefault("MKL_NUM_THREADS", "1")
os.environ.setdefault("VECLIB_MAXIMUM_THREADS", "1")
os.environ.setdefault("NUMEXPR_NUM_THREADS", "1")

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
SCR = os.path.join(HERE, "scripts")
sys.path.insert(0, SCR)

import polar as P  # noqa: E402

fails = []
checks = []
skips = []
groups = {"H": [0, 0], "A": [0, 0], "B": [0, 0], "C": [0, 0], "L": [0, 0]}


def ck(group, name, cond, detail=""):
    checks.append(name)
    groups[group][1] += 1
    if cond:
        groups[group][0] += 1
        print("  OK  [%s] %s %s" % (group, name, detail))
    else:
        fails.append(name)
        print("  FAIL [%s] %s %s" % (group, name, detail))


def skip(group, name, reason):
    skips.append(name)
    print("  SKIP [%s] %s (%s)" % (group, name, reason))


def loadj(name):
    path = os.path.join(RES, name)
    if not os.path.isfile(path):
        return None
    return json.load(open(path))


def main():
    live = "--live" in sys.argv
    print("TANGENT_C6 verifier", flush=True)

    th = open(os.path.join(HERE, "THEOREM.md")).read()
    ck("H", "headline OPEN", "Problem E remains OPEN" in th)
    ck("H", "excludes no degree", "excludes no degree" in th)
    ck("H", "no REPORT.md", not os.path.isfile(os.path.join(HERE, "REPORT.md")))
    ck("H", "registration present",
       os.path.isfile(os.path.join(HERE, "REGISTRATION_SNIPPET.md")))
    ck("H", "Not claimed section", "Not claimed" in th)
    ck("H", "exit ledger present", "TANGENT-C6-ORIGIN-VACUOUS" in th)
    ck("H", "exit no-degree", "TANGENT-C6-NO-DEGREE-EXCLUSION" in th)
    ck("H", "honesty tiers", "[T1]" in th and "[T2]" in th and "[T3]" in th)

    print("[A] polar identities over Z (fatal gate)", flush=True)
    polar = P.run_checks()
    ck("A", "polar all ok", polar["all_ok"], "fails=%s" % polar["fails"])
    ck("A", "polar n_checks=121", polar["n_checks"] == 121, str(polar["n_checks"]))
    stored_polar = loadj("polar_identities.json")
    ck("A", "polar artefact present", stored_polar is not None)
    if stored_polar:
        ck("A", "polar artefact matches replay",
           stored_polar.get("n_checks") == polar["n_checks"]
           and stored_polar.get("n_fail") == 0)
    ck("A", "F(0)=grad(0)=hess(0)=0",
       P.F([0, 0, 0, 0, 0]) == 0
       and P.gradF([0, 0, 0, 0, 0]) == [0, 0, 0, 0, 0]
       and all(P.hessF([0, 0, 0, 0, 0])[i][j] == 0
               for i in range(5) for j in range(5)))
    y = [1, -2, 3, -4, 5]
    ck("A", "Euler on a Z-point", P.dot(P.gradF(y), y) == 3 * P.F(y))
    s = [2, 0, 1, -1, 4]
    ck("A", "25.1 = 3 Phi", P.first_order(y, s) == P.Phi3(y, y, s))
    r = [0, 1, 0, 1, 0]
    ck("A", "25.2 = polar",
       P.second_order(y, s, r)
       == 2 * P.Phi3(y, s, s) + 2 * P.Phi3(y, y, r))
    z = [0, 0, 0, 0, 0]
    got = P.collect_lambda_coeffs(z, s, z)
    ck("A", "origin third order is F(S)",
       got == [0, 0, 0, P.F(s), 0, 0, 0], str(got))
    if fails:
        print("FATAL gate failed; stopping before artefact groups")
        emit()
        return 1

    print("[B] sealed cell / summary artefacts", flush=True)
    summary = loadj("summary.json")
    ck("B", "summary present", summary is not None)
    jump = loadj("jump_locus.json")
    ck("B", "jump_locus present", jump is not None)
    if summary:
        ck("B", "summary headline OPEN",
           "OPEN" in summary.get("headline", ""))
        ck("B", "summary excludes no degree",
           summary.get("excludes_no_degree") is True)
        ck("B", "no nonzero landing point claimed",
           summary.get("nonzero_landing_point") is False)
        ck("B", "polar_ok in summary", summary.get("polar_ok") is True)
    for p in (331, 661):
        o = loadj("origin_p%d.json" % p)
        g = loadj("generic_rank_p%d.json" % p)
        ck("B", "origin p=%d present" % p, o is not None)
        ck("B", "generic p=%d present" % p, g is not None)
        if summary and summary.get("cells"):
            cell = summary["cells"].get(str(p)) or summary["cells"].get(p)
            ck("B", "cell p=%d shape 37x637" % p,
               cell is not None and cell.get("shape") == [37, 637],
               str(cell))
            ck("B", "cell p=%d rank_U=2" % p,
               cell is not None and cell.get("rank_U") == 2)

    print("[C] origin, generic rank, Euler, jump", flush=True)
    for p in (331, 661):
        o = loadj("origin_p%d.json" % p)
        g = loadj("generic_rank_p%d.json" % p)
        if not o or not g:
            continue
        ck("C", "p=%d rho(0)=0" % p, o.get("rho") == 0, str(o.get("rho")))
        ck("C", "p=%d A(0)=0" % p, o.get("A_is_zero") is True)
        ck("C", "p=%d tan_dim(0)=37" % p, o.get("tan_dim") == 37)
        ck("C", "p=%d rho_generic=37" % p,
           g.get("rho_generic") == 37, str(g.get("rho_generic")))
        ck("C", "p=%d all positive samples 37" % p,
           g.get("all_positive_samples_constant") is True
           and g.get("rho_min_positive_samples") == 37)
        ck("C", "p=%d no jump in samples" % p,
           g.get("jump_seen_in_samples") is False)
        ck("C", "p=%d Euler holds" % p, g.get("euler_all_ok") is True)
        ck("C", "p=%d homogeneity holds" % p, g.get("homog_all_ok") is True)
        ck("C", "p=%d 25.2 holds" % p, g.get("second_order_all_ok") is True)
        ck("C", "p=%d common ker 0" % p,
           g.get("common_kernel_dim_of_4_random") == 0)
        ck("C", "p=%d 12 random" % p,
           isinstance(g.get("ranks_random"), list)
           and len(g["ranks_random"]) == 12
           and set(g["ranks_random"]) == {37})
        ck("C", "p=%d 37 basis rays" % p,
           isinstance(g.get("ranks_basis_rays"), list)
           and len(g["ranks_basis_rays"]) == 37
           and set(g["ranks_basis_rays"]) == {37})
    ck("C", "THEOREM states generic rank 37", "generic rank on the cell is therefore **37**" in th
       or "Generic rank on the cell is therefore **37**" in th)
    ck("C", "THEOREM states origin vacuous", "cone vertex" in th)
    ck("C", "THEOREM new vs restatement", "What is new" in th or "what is a restatement" in th)
    ck("C", "THEOREM Z36 does not cut V", "cuts nothing" in th)
    if jump:
        ck("C", "jump rho_generic 37 both",
           jump.get("rho_generic_by_prime", {}).get("331") == 37
           and jump.get("rho_generic_by_prime", {}).get("661") == 37)
        ck("C", "jump interpretation present",
           "interpretation" in jump
           and "new_vs_restatement" in jump.get("interpretation", {}))

    # zero / all-dead audit: no census zero
    ck("C", "no census zero / all-dead",
       summary is not None and summary.get("excludes_no_degree") is True)

    if live:
        print("[L] live rebuild p=331", flush=True)
        import numpy as np
        import paths
        import celllib as CL
        import slicelib as SL
        cell = CL.cell37(331)
        ck("L", "live cell 37x637", list(cell["B37"].shape) == [37, 637])
        ck("L", "live rank_U=2", cell["rank_U"] == 2)
        Aseed, Cseed = CL.load_AC()
        fr = SL.build_frame(331, verbose=False)
        rng = np.random.default_rng(20260812 + 331)
        W = rng.integers(1, 331, size=(48, 5)) % 331
        V = CL.seed_values(fr, Aseed, Cseed, W)
        Tbasis = CL.tbasis_from_seeds(cell["B37"], V, 331)
        origin = np.zeros(37, dtype=np.int64)
        rho0 = CL.rho(origin, Tbasis, 331)
        ck("L", "live rho(0)=0", rho0 == 0, str(rho0))
        A0 = CL.A_matrix(origin, Tbasis, 331)
        ck("L", "live A(0)=0", bool(np.all(A0 == 0)))
        ranks = []
        for _ in range(2):
            c = rng.integers(1, 331, size=37) % 331
            ranks.append(CL.rho(c, Tbasis, 331))
            lhs, rhs, ok = CL.euler_residual(c, Tbasis, 331)
            ck("L", "live Euler", ok)
        ck("L", "live random ranks 37", set(ranks) == {37}, str(ranks))
    else:
        skip("L", "live rebuild", "pass --live")

    return emit()


def emit():
    n = len(checks)
    nf = len(fails)
    ns = len(skips)
    rec = {
        "n_checks": n,
        "n_fail": nf,
        "n_skip": ns,
        "fails": fails,
        "skips": skips,
        "groups": {g: {"ok": a, "n": b} for g, (a, b) in groups.items()},
    }
    os.makedirs(RES, exist_ok=True)
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(rec, f, indent=1)
    print()
    print("%d checks, %d failures, %d skips" % (n, nf, ns))
    for g, (a, b) in groups.items():
        print("  group %s: %d/%d" % (g, a, b))
    if nf == 0:
        print("TANGENT_C6_VERIFY_OK")
        print("ALLGREEN")
        open(os.path.join(RES, "verifier_stdout.txt"), "w").write(
            "%d checks, %d failures, %d skips\nTANGENT_C6_VERIFY_OK\nALLGREEN\n"
            % (n, nf, ns))
        return 0
    print("TANGENT_C6_VERIFY_FAIL")
    open(os.path.join(RES, "verifier_stdout.txt"), "w").write(
        "%d checks, %d failures, %d skips\nFAILS %s\n" % (n, nf, ns, fails))
    return 1


if __name__ == "__main__":
    sys.exit(main())
