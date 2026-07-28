# Problem F — PSL(2,7)-unirationality of the degree-2 del Pezzo surface

**Status: OPEN** (WP-0 triage on record in `RESOLUTION.md`, 2026-07-28:
Cheltsov–Tschinkel–Zhang explicitly state the degree-2 del Pezzo case of
equivariant unirationality "remains open"; Duncan's Condition-(A)
sufficiency stops at degree 3).

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
F_{11})\)); here the essential-dimension invariant is already known
(\(\operatorname{ed}_{\mathbf C}=2\), Duncan/Beauville) and carries no
leverage; the problem is instead the first open case of Duncan's
Condition-(A) sufficiency frontier, which stops at degree 3 — a sharply
posed question with decisive first computation (the abelian fixed-point
audit).  Provenance of the problem selection: external suggestion
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
