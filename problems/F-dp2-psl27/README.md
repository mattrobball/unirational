# Problem F — PSL(2,7)-unirationality of the degree-2 del Pezzo surface

**Status: AUTHORED 2026-07-28, literature triage not yet run.** Do not cite
the "open" designation until WP-0 is on record in `RESOLUTION.md`.

Let \(G=\operatorname{PSL}_2(\mathbf F_7)\) act through its
three-dimensional representation \(V\) on

\[
S=\{w^2=x^3y+y^3z+z^3x\}\subset\mathbf P(1,1,1,2),
\]

the del Pezzo surface of degree 2 branched over the Klein quartic.  The
problem asks whether \(S\) is \(G\)-unirational: whether some
finite-dimensional representation \(U\) of \(G\) admits a dominant
\(G\)-equivariant rational map \(U\dashrightarrow S\).

This is the exact analogue, one dimension down, of
[Problem E](../E-klein-cubic/README.md) (PSL(2,11) on the Klein cubic
threefold).  E is equivalent to an *open* essential-dimension computation
(\(\operatorname{ed}=3\) vs \(4\) for \(\operatorname{PSL}_2(\mathbf
F_{11})\)); the analogous invariant here (\(\operatorname{ed}=2\) vs \(3\)
for \(\operatorname{PSL}_2(\mathbf F_7)\)) lives in a *classified*
landscape — Duncan's finite groups of essential dimension 2 — which is the
concrete reason to expect this case to be decidable with current
technology.  Provenance of the problem selection: external suggestion
(2026-07-28) — an easier case of a very similar problem, still
publishable, and not entangled with major conjectures.

## Start here

- [`SPEC.md`](SPEC.md) — authoritative statement, the action model, the
  Duncan–Reichstein equivalences with the one genuine change from E (the
  dP2 point-implies-unirational step replacing Kollár's cubic theorem),
  the expected ed-reduction, and the resolution standard.
- [`HANDOFF.md`](HANDOFF.md) — worker-facing work packages, WP-0 first.
- [`certificates/`](certificates/) — resolution artifacts; empty until
  something is proved.
- `RESOLUTION.md` — created by the first worker; dated log of triage
  results, verified facts, delimited routes.

## House rules (inherited from B and E)

Never state a lemma you believe might be false — stop and record the
obstruction; precise negatives are results.  Every "known" fact in
`SPEC.md` marked **(verify)** must be re-derived or re-cited with an exact
reference before first use, and the verification logged.  Binary,
unconditional resolution standard.
