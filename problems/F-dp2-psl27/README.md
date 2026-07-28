# Problem F — PSL(2,7)-unirationality of the degree-2 del Pezzo surface

**Status: RESOLVED — NEGATIVE** for this exact
\(\operatorname{PSL}_2(\mathbf F_7)\)-action (2026-07-28).
There is no dominant \(G\)-equivariant rational map from any
representation to \(S\).  The final all-degree proof uses a
\(V_4\)-stable exceptional path over a quadruple point of the Klein
21-line arrangement; see
[WP3_ALL_DEGREE_PATH_OBSTRUCTION.md](certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md).

Let \(G=\operatorname{PSL}_2(\mathbf F_7)\) act through its
three-dimensional representation \(V\) on

\[
S=\{w^2=x^3y+y^3z+z^3x\}\subset\mathbf P(1,1,1,2),
\]

the del Pezzo surface of degree 2 branched over the Klein quartic.  The
problem asks whether \(S\) is \(G\)-unirational: whether some
finite-dimensional representation \(U\) of \(G\) admits a dominant
\(G\)-equivariant rational map \(U\dashrightarrow S\).

This began as the exact analogue, one dimension down, of
[Problem E](../E-klein-cubic/README.md) (PSL(2,11) on the Klein cubic
threefold).  E is equivalent to an *open* essential-dimension computation
(\(\operatorname{ed}=3\) vs \(4\) for \(\operatorname{PSL}_2(\mathbf
F_{11})\)); here the essential-dimension invariant is already known
(\(\operatorname{ed}_{\mathbf C}=2\), Duncan/Beauville) and carries no
leverage.  Duncan's sufficiency theorem for Condition (A) stops at degree
3.  General sufficiency in degree 2 is already false for other groups, and
the previously known counterexamples did not settle this simple subgroup.
The exceptional-path obstruction now settles the exact action directly.
The earlier exact exclusions through degree 34 remain useful historical
checks; their former degree-36 frontier is superseded.

## Start here

- [`SPEC.md`](SPEC.md) — authoritative statement, the action model, the
  corrected twist equivalences, verified action facts, and binary
  resolution standard.
- [`HANDOFF.md`](HANDOFF.md) — final replay path and historical
  bounded-work summary.
- [`certificates/`](certificates/) — exact fixed-locus and covariant
  certificates, each with a scope note.
- [`RESOLUTION.md`](RESOLUTION.md) — dated log of verified facts,
  corrections, delimited routes, and the final all-degree theorem.

## House rules (inherited from B and E)

Never state a lemma you believe might be false — stop and record the
obstruction; precise negatives are results.  Every "known" fact in
`SPEC.md` must be re-derived or re-cited with an exact reference before
first use, and the verification logged.  Binary, unconditional resolution
standard: bounded computations are not the headline resolution.
