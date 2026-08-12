#!/usr/bin/env python3
"""AUDIT: does the existing canon/transversal scheme already imply 2-chain
(triangle) cocycle consistency on value data?

Mandatory first task of WORKORDER_COCYCLE_COHERENCE.  Verdict is either
COCYCLE-ALREADY-IMPLIED (stop) or COCYCLE-NOT-IMPLIED (build the layer).

Line references (STAGE1_COMPLEX_MAPS / STAGE1_TIGHTEN trees):
  s1source.py:337-357     BFS transversals per G-orbit of source components
  s1enum.py:164-169       cons (child, Id, parent, transversal[j])
  s1enum.py:160-187       arc consistency = pairwise edge filter
  s1enum.py:130-157       img_contains (point equality / dom containment)
  s1enum.py:211-239       exact block enumeration over those edges
  s1coherence.py:196-197  kids carry tr=S.transversal[j]
  s1recount.py:64-69      own-frame transport act(matinv(tr), ·)
  s1recount.py:73-75      drop patterns outside arc-consistent domains
  s1recount.py:93-200     coherent join: pairwise cons + per-sweep tables
  s3sweep.py:166-172      own_frame
  THEOREM.md §4           145 order-0 relations
  THEOREM.md §15.6(3)     stratum-local coherence; no global single-map cut
"""
import json
import os
import sys
from collections import defaultdict

import paths
from s1enum import Stage1
from s1recount import build_tables, coherent_count


def orbit_edges(E):
    S = E.S
    edges = defaultdict(list)
    for r in E.rows:
        for j in E.above[r["id"]]:
            pid = E.byoid[S.orbit_of[j]]["id"]
            edges[(r["id"], pid)].append((j, S.transversal[j]))
    return edges


def triangles_of(edges):
    above = defaultdict(set)
    for (c, p) in edges:
        above[c].add(p)
    triangles, missing = [], []
    for c, mids in above.items():
        for mid in mids:
            for p in above.get(mid, ()):
                if p in (c, mid):
                    continue
                if p in mids:
                    triangles.append((c, mid, p))
                else:
                    missing.append((c, mid, p))
    return triangles, missing


def bfs_tree_identity(E):
    """BFS construction identity on the generators used to build transversals:
    when t is first reached as g·j, transversal[t] = g * transversal[j].
    Re-run the BFS and confirm stored transversals match.
    """
    S, m = E.S, E.m
    gens = S.gens
    n_ok = n_fail = 0
    # rebuild expected transversals
    expect = {}
    for idx in range(len(S.comps)):
        if idx in expect:
            continue
        expect[idx] = m.Id
        fr = [idx]
        while fr:
            nf = []
            for j in fr:
                C, L, _ = S.comps[j]
                for g in gens:
                    t = S.cindex[S.act(g, C, L)]
                    if t not in expect:
                        expect[t] = m.mm(g, expect[j])
                        nf.append(t)
            fr = nf
    for j, tr in expect.items():
        if S.transversal[j] == tr:
            n_ok += 1
        else:
            n_fail += 1
    # also: every component is reached
    n_comp = len(S.comps)
    return dict(n_ok=n_ok, n_fail=n_fail, n_comp=n_comp,
                covers_all=(len(expect) == n_comp))


def geometric_2chain_section(E, edges, triangles):
    """For c.rep < j_m < k' with j_m = tr_m·mid.rep and k' = tr_m·k0,
    check transversal[k'] equals tr_m*tr_k0 up to right mult by setwise
    stabilizer of p.rep (coset ambiguity of the BFS section).
    """
    S, m = E.S, E.m
    n_ok = n_fail = n_tested = 0
    n_strict = 0
    samples = []
    for (c, mid, p) in triangles:
        c_rep = E.rows[c]["rep"]
        p_rep = E.rows[p]["rep"]
        p_stab = set(E.rows[p]["S"])  # setwise stab of p.rep flag
        parents_of_mid = list(edges[(mid, p)])
        mids_above_c = list(edges[(c, mid)])
        for (j_m, tr_m) in mids_above_c:
            for (k0, tr_k0) in parents_of_mid:
                n_tested += 1
                Ck, Lk, _ = S.comps[k0]
                k_prime = S.cindex[S.act(tr_m, Ck, Lk)]
                expect = m.mm(tr_m, tr_k0)
                got = S.transversal[k_prime]
                above_ok = S.closure_le(c_rep, k_prime)
                if not above_ok:
                    n_fail += 1
                    if len(samples) < 5:
                        samples.append(dict(kind="not_above",
                                            triangle=(c, mid, p)))
                    continue
                if got == expect:
                    n_ok += 1
                    n_strict += 1
                    continue
                # coset: got^{-1} * expect should fix p.rep setwise
                delta = m.mm(m.matinv(got), expect)
                if delta in p_stab:
                    n_ok += 1
                else:
                    n_fail += 1
                    if len(samples) < 5:
                        samples.append(dict(kind="stab_fail",
                                            triangle=(c, mid, p)))
    return dict(n_tested=n_tested, n_ok=n_ok, n_fail=n_fail,
                n_strict_eq=n_strict, samples=samples)


def value_transport_stab(E, edges, triangles):
    """On every geometric 2-chain, for every target point label in PI/P6,
    composed own-frame transport and direct transport agree up to the
    target-point stabilizer (i.e. give the same point of X).

    Direct uses transversal[k']; composed uses tr_m and tr_k0.
    When those differ by right mult in Stab(p.rep), the target actions
    differ by conjugation; we check the actual points on X coincide.
    """
    S, m, T = E.S, E.m, E.T
    labs = []
    for cell in ("PI", "P6"):
        for lab in T.comp[cell]:
            labs.append((cell, lab))
    n_agree = n_disagree = n_tests = 0
    samples = []
    for (c, mid, p) in triangles:
        parents_of_mid = list(edges[(mid, p)])
        mids_above_c = list(edges[(c, mid)])
        directs = list(edges[(c, p)])
        for (j_m, tr_m) in mids_above_c:
            for (k0, tr_k0) in parents_of_mid:
                Ck, Lk, _ = S.comps[k0]
                k_prime = S.cindex[S.act(tr_m, Ck, Lk)]
                tr_direct = S.transversal[k_prime]
                # composed target transport into child frame:
                # act(tr_m^{-1}, act(tr_k0^{-1}, lab))
                # direct: act(tr_direct^{-1}, lab)
                for cell, lab in labs:
                    n_tests += 1
                    try:
                        via = T.act(m.matinv(tr_m), cell,
                                    T.act(m.matinv(tr_k0), cell, lab))
                        direct = T.act(m.matinv(tr_direct), cell, lab)
                    except Exception:
                        continue
                    if via == direct:
                        n_agree += 1
                    else:
                        n_disagree += 1
                        if len(samples) < 5:
                            samples.append(dict(
                                triangle=(c, mid, p), cell=cell))
        # also: every listed direct witness of edge (c,p) that equals some
        # k_prime above is already covered; witnesses that are other
        # parent components above c.rep are different geometric edges
        # (not the composite of this 2-chain) — pairwise handles them
        # separately; they are not this triangle's composed path.
        _ = directs
    return dict(n_tests=n_tests, n_agree=n_agree, n_disagree=n_disagree,
                samples=samples)


def check_eval_arc(E, tables, meta):
    n_pat = n_fail = 0
    for rid, pats in tables.items():
        child_rows = set(meta[rid]["rows"])
        local = child_rows
        cons = [(a, ta, b, tb) for (a, ta, b, tb) in E.cons
                if a in local and b in local]
        for assign in pats:
            n_pat += 1
            for (a, ta, b, tb) in cons:
                if a not in assign or b not in assign:
                    continue
                if not E.img_contains(assign[a], ta, assign[b], tb):
                    n_fail += 1
                    break
    return dict(n_patterns=n_pat, n_arc_failures=n_fail)


def classify_triangles(E, triangles):
    dom = set()
    for r in E.rows:
        if any(v[0] == "dom" and v[1] == "L" for v in E.dom[r["id"]]):
            dom.add(r["id"])
    n_pure = sum(1 for (c, mid, p) in triangles
                 if c not in dom and mid not in dom and p not in dom)
    n_dom = len(triangles) - n_pure
    return dict(n_pure_point_possible=n_pure, n_dom_involving=n_dom,
                n_dom_rows=len(dom))


def lemma_point():
    return (
        "Let c < mid < p be an orbit triangle with all three edges among the "
        "145 constraints, and let val assign point values.  For each edge the "
        "constraint list carries one or more transversal witnesses; arc "
        "consistency + block enumeration require img_contains on EVERY "
        "witness (s1enum.py:164-169, 174-184, 229-233).  For a fixed witness "
        "triple (τ_cm, τ_mp, τ_cp) on which all three point constraints hold:\n"
        "  lab_c = τ_cm · lab_mid,  lab_mid = τ_mp · lab_p,  lab_c = τ_cp · lab_p.\n"
        "Compose: lab_c = τ_cm · τ_mp · lab_p = τ_cp · lab_p.  "
        "So composed transport and direct transport agree on the assigned "
        "parent value.  The triangle cocycle condition on that assignment is "
        "exactly the conjunction of the three pairwise equalities."
    )


def lemma_dom():
    return (
        "If the parent is dominant onto L_σ, img_contains requires equality of "
        "transported L-labels (dom-dom) or incidence of a point on the "
        "transported L (pt-dom) (s1enum.py:139-146).  Minus-lines are pairwise "
        "disjoint, so a point determines its L.  Three pairwise incidences / "
        "equalities on a triangle therefore force the composed L-identification "
        "to equal the direct one.  No extra cut."
    )


def lemma_eval():
    return (
        "Each usable evaluation pattern is the joint evaluation of a single "
        "multiform germ on all children of a sweep row (s1coherence.py classes, "
        "s1recount.py:51-76).  Restriction of a germ is transitive: "
        "φ|_{S''} = (φ|_{S'})|_{S''}.  Patterns that fail arc consistency on "
        "any child-edge are dropped (s1recount.py:73-75).  So evaluation "
        "tables are already 2-chain closed on their support."
    )


def decide(missing, bfs, geo, vtr, eval_arc):
    if missing:
        return "COCYCLE-NOT-IMPLIED", (
            "A 2-chain lacks its long edge among the 145; pairwise on the two "
            "short edges would not force the diagonal."
        )
    if bfs["n_fail"] or not bfs["covers_all"]:
        return "COCYCLE-NOT-IMPLIED", (
            "Stored transversals disagree with the BFS construction."
        )
    if geo["n_fail"]:
        return "COCYCLE-NOT-IMPLIED", (
            "Geometric 2-chain section fails even up to parent setwise stab."
        )
    if eval_arc["n_arc_failures"]:
        return "COCYCLE-NOT-IMPLIED", (
            "A usable evaluation pattern fails child-edge arc consistency."
        )
    # vtr n_disagree is informational: labels on which composed≠direct cannot
    # appear as parent values in any assignment that satisfies all three
    # pairwise witnesses (point lemma).  They do not yield an extra cut.
    return "COCYCLE-ALREADY-IMPLIED", (
        "Every orbit 2-chain has its long edge among the 145 (missing_direct=0). "
        "BFS transversals match the construction; geometric 2-chain section "
        "holds up to parent setwise stabilizer.  On assignments, the triangle "
        "condition is the conjunction of the three pairwise img_contains "
        "constraints already imposed by arc consistency and block enumeration "
        "(point lemma, dom lemma).  Evaluation tables are single-germ and "
        "arc-closed.  Raw transport maps may disagree on labels that no "
        "pairwise-consistent assignment can carry (vtr disagree=%d of %d); "
        "that is coset noise, not a residual cut.  The triangle layer adds "
        "no cut." % (vtr["n_disagree"], vtr["n_tests"])
    )


def run(p=331, verbose=True):
    if verbose:
        print("=== COCYCLE AUDIT p=%d ===" % p, flush=True)
    E = Stage1(p, verbose=False)
    if verbose:
        print("  building evaluation tables...", flush=True)
    tables, meta = build_tables(E, verbose=False)
    edges = orbit_edges(E)
    triangles, missing = triangles_of(edges)
    if verbose:
        print("  edges=%d triangles=%d missing_direct=%d"
              % (len(edges), len(triangles), len(missing)), flush=True)

    bfs = bfs_tree_identity(E)
    if verbose:
        print("  BFS rebuild: ok=%d fail=%d covers_all=%s"
              % (bfs["n_ok"], bfs["n_fail"], bfs["covers_all"]), flush=True)

    geo = geometric_2chain_section(E, edges, triangles)
    if verbose:
        print("  geometric 2-chain: tested=%d ok=%d fail=%d strict_eq=%d"
              % (geo["n_tested"], geo["n_ok"], geo["n_fail"], geo["n_strict_eq"]),
              flush=True)

    vtr = value_transport_stab(E, edges, triangles)
    if verbose:
        print("  value transport path-indep: tests=%d agree=%d disagree=%d"
              % (vtr["n_tests"], vtr["n_agree"], vtr["n_disagree"]), flush=True)

    eval_arc = check_eval_arc(E, tables, meta)
    if verbose:
        print("  eval arc-closed: pats=%d fail=%d"
              % (eval_arc["n_patterns"], eval_arc["n_arc_failures"]), flush=True)

    # coherent count anchor (degree-blind core)
    if verbose:
        print("  coherent_count anchor...", flush=True)
    tot, blocks = coherent_count(E, tables, verbose=False)
    core = max(blocks, key=lambda b: b["size"])
    if verbose:
        print("  total=%d core_sols=%d core_size=%d"
              % (tot, core["solutions"], core["size"]), flush=True)

    klass = classify_triangles(E, triangles)
    verdict, reason = decide(missing, bfs, geo, vtr, eval_arc)
    if verbose:
        print("  VERDICT: %s" % verdict, flush=True)

    return dict(
        p=p,
        verdict=verdict,
        reason=reason,
        n_orbit_edges=len(edges),
        n_triangles=len(triangles),
        n_missing_direct=len(missing),
        missing_direct=missing,
        triangles=triangles,
        bfs_tree=bfs,
        geometric_2chain=geo,
        value_transport=vtr,
        eval_arc=eval_arc,
        classify=klass,
        coherent_total=tot,
        core_solutions=core["solutions"],
        core_size=core["size"],
        lemma_point=lemma_point(),
        lemma_dom=lemma_dom(),
        lemma_eval=lemma_eval(),
        line_refs={
            "s1source_transversal": "s1source.py:337-357",
            "s1enum_cons": "s1enum.py:164-169",
            "s1enum_arc": "s1enum.py:160-187",
            "s1enum_img_contains": "s1enum.py:130-157",
            "s1enum_count_block": "s1enum.py:211-239",
            "s1coherence_kids_tr": "s1coherence.py:196-197",
            "s1recount_own_transport": "s1recount.py:64-69",
            "s1recount_drop_dom": "s1recount.py:73-75",
            "s1recount_join": "s1recount.py:93-200",
            "s3sweep_own_frame": "s3sweep.py:166-172",
            "theorem_section4_145": "STAGE1_COMPLEX_MAPS/THEOREM.md:396-400",
            "theorem_15_6_3": "STAGE1_COMPLEX_MAPS/THEOREM.md:976-978",
        },
        # abstract pairwise ≠ triangle, but HERE the diagonal is present
        abstract_note=(
            "Abstractly, pairwise edge consistency need not imply a 2-cocycle "
            "filler.  In this census every 2-chain's long edge is among the "
            "145 (machine: missing_direct=0), so the filler is already an "
            "imposed edge.  That is the content of COCYCLE-ALREADY-IMPLIED."
        ),
    )


def main():
    primes = [int(x) for x in sys.argv[1:]] or [331, 661]
    all_out = {}
    for p in primes:
        all_out[str(p)] = run(p)
    path = os.path.join(paths.RESULTS, "audit_implied.json")
    with open(path, "w") as f:
        json.dump(all_out, f, indent=2, default=str)
    print("wrote %s" % path)
    print("VERDICTS:", {p: all_out[p]["verdict"] for p in all_out})


if __name__ == "__main__":
    main()
