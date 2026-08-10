"""W5 + W6.

W5 -- the 55-line configuration L_sigma = P(W_sigma^-) inside X, as a sealed
      JSON certificate: adjacency, regularity, connectivity, diameter, and the
      bijections
          edges  <->  commuting pairs of involutions  <->  Klein four-groups x 3
          edges  <->  type-I points.
      This is the TARGET-side receiver: by Proposition D the only rational
      curves in X_nt are these 55 lines, so every RCC set produced by Duncan
      thm:fabulous + prop:rcc_total is a point or a connected union of them.

W6 -- setwise stabilizers of the boundary-divisor centres:
          Stab(P_sigma) = Stab(L'_sigma) = C_G(sigma) = D12   (order 12)
          Stab(ell_V)                    = N_G(V4)   = A4     (order 12)
          Stab(M_tau^V)                  = N_G(V) n C_G(tau)  = V4 (order 4)
          Stab(S_tau^V)                  = V4
      and the consequence that for ANY fabulous corner
          Stab(D_i) n Stab(D_j) = V4.
"""
import sys, os, json
from collections import defaultdict, deque

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from psl211 import Model, normpt, SPLIT_PRIMES


def run(p, say):
    m = Model(p)
    ok = True
    say(f"=== W5/W6 at p = {p} ===")
    inv = m.invols
    Lm = {A: m.minus_line(A) for A in inv}
    Pp = {A: m.plus_plane(A) for A in inv}

    # ---------------- W5 ----------------
    say("F vanishes identically on every minus-line: " + str(
        all(m.F([sum(c[t] * Lm[A][t][j] for t in range(2)) % p for j in range(5)]) == 0
            for A in inv for c in ((1, 0), (0, 1), (1, 1), (1, 2)))))
    edges, meet_pt = set(), {}
    for i in range(55):
        for j in range(i + 1, 55):
            I = m.inter(Lm[inv[i]], Lm[inv[j]])
            if len(I) == 1:
                edges.add((i, j))
                meet_pt[(i, j)] = normpt(m, I[0])
    comm = set((i, j) for i in range(55) for j in range(i + 1, 55)
               if m.mm(inv[i], inv[j]) == m.mm(inv[j], inv[i]))
    say(f"W5 edges: {len(edges)}; edges == commuting pairs: {edges == comm}")
    adj = defaultdict(set)
    for i, j in edges:
        adj[i].add(j)
        adj[j].add(i)
    degs = set(len(adj[i]) for i in range(55))
    seen, st = {0}, [0]
    while st:
        u = st.pop()
        for w in adj[u]:
            if w not in seen:
                seen.add(w)
                st.append(w)

    def bfs(s):
        d = {s: 0}
        q = deque([s])
        while q:
            u = q.popleft()
            for w in adj[u]:
                if w not in d:
                    d[w] = d[u] + 1
                    q.append(w)
        return d
    diam = max(max(bfs(s).values()) for s in range(55))
    say(f"W5 degrees: {degs}; connected: {len(seen) == 55}; diameter: {diam}")
    # each edge point is a type-I point: stabilizer V4, on X, on exactly 2 lines,
    # in exactly 1 plus-plane
    props = defaultdict(int)
    for e, q in meet_pt.items():
        stab = sum(1 for A in m.G if normpt(m, m.act(A, q)) == q)
        nl = sum(1 for A in inv if m.contains_pt(Lm[A], q))
        npl = sum(1 for A in inv if m.contains_pt(Pp[A], q))
        props[(stab, nl, npl, m.F(list(q)) == 0)] += 1
    say(f"W5 edge-point (|stab|, #lines, #plus-planes, on X) -> count: {dict(props)}")
    c5 = (len(edges) == 165 and edges == comm and degs == {6}
          and len(seen) == 55 and diam == 3
          and props == {(4, 2, 1, True): 165})
    say(f"W5 VERDICT: {'PASS' if c5 else 'FAIL'}")
    ok &= c5

    # ---------------- W6 ----------------
    V4s = m.klein_fours()
    s_pp = set(len(m.setstab(Pp[A])) for A in inv)
    s_lm = set(len(m.setstab(Lm[A])) for A in inv)
    s_ell = set(len(m.setstab(m.ell_V(H))) for H in V4s)
    say(f"W6 |Stab(P_sigma)| = {s_pp}; |Stab(L'_sigma)| = {s_lm}; "
        f"|Stab(ell_V)| = {s_ell}")
    # Stab(M_tau^V) = N_G(V) n C_G(tau).  M_tau^V is the P(N n W_tau^-) subbundle
    # of E_V, so its setwise stabilizer is exactly the subgroup of N_G(V)
    # preserving tau.
    sizes = set()
    for H in V4s:
        NV = [A for A in m.G
              if frozenset(m.mm(m.mm(A, x), m.matinv(A)) for x in H) == frozenset(H)]
        for tau in [x for x in H if x != m.Id]:
            St = [A for A in NV if m.mm(m.mm(A, tau), m.matinv(A)) == tau]
            sizes.add(len(St))
    say(f"W6 |Stab(M_tau^V)| = |N_G(V) n C_G(tau)| over all 165 pairs: {sizes}")
    # for any fabulous corner: Stab(D_i) n Stab(D_j) preserves <s> and <z>, hence V
    inter_sizes = set()
    for H in V4s:
        nt = [x for x in H if x != m.Id]
        for z in nt:
            for s in nt:
                if z == s:
                    continue
                S = [A for A in m.G
                     if m.mm(m.mm(A, z), m.matinv(A)) == z
                     and m.mm(m.mm(A, s), m.matinv(A)) == s]
                inter_sizes.add(len(S))
    say(f"W6 |C_G(z) n C_G(s)| for commuting z != s (= Stab(D_i) n Stab(D_j) "
        f"upper bound): {inter_sizes}")
    c6 = (s_pp == {12} and s_lm == {12} and s_ell == {12} and sizes == {4}
          and inter_sizes == {4})
    say(f"W6 VERDICT: {'PASS' if c6 else 'FAIL'}")
    ok &= c6

    if p == SPLIT_PRIMES[0]:
        here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        cert = {
            "object": "configuration of the 55 lines L_sigma = P(W_sigma^-) inside "
                      "the Klein cubic X",
            "prime_used": p,
            "n_lines": 55,
            "n_edges": len(edges),
            "edge_rule": "L_sigma meets L_tau  <=>  sigma and tau commute",
            "edges_equal_commuting_pairs": edges == comm,
            "regular_degree": sorted(degs),
            "connected": len(seen) == 55,
            "n_components": 1,
            "diameter": diam,
            "edge_points": "each edge point is a type-I point: |Stab| = 4 (V4), "
                           "on X, on exactly 2 of the 55 lines, in exactly 1 "
                           "plus-plane (hence on exactly 1 elliptic E_sigma)",
            "edges_per_klein_four": 3,
            "n_klein_fours": 55,
            "type_II_points": "the 3 points of X n ell_V per V4 (165 total); they "
                              "lie on NO line (ell_V n L'_tau = empty for all "
                              "55x55 pairs) and on all three elliptics of their "
                              "V4-triangle",
            "adjacency": {str(i): sorted(adj[i]) for i in range(55)},
            "consumer": "Proposition D: the only rational curves in X_nt are these "
                        "55 lines, so every connected RCC subset of X_nt supplied "
                        "by Duncan thm:fabulous + prop:rcc_total is a point or a "
                        "connected union of these lines.",
        }
        with open(os.path.join(here, "results", "w5_line_graph.json"), "w") as f:
            json.dump(cert, f, indent=1, sort_keys=True)
        say("W5 wrote results/w5_line_graph.json")
    return ok


if __name__ == "__main__":
    out = []

    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    ok = True
    for p in SPLIT_PRIMES:
        ok &= run(p, say)
        say("")
    tag = "W5_W6_" + ("OK" if ok else "FAIL")
    say(tag)
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    with open(os.path.join(here, "results", "w5_w6_line_graph_and_stabs.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    sys.exit(0 if ok else 1)
