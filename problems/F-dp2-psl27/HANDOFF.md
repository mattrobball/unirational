# Problem F — worker handoff

Read `SPEC.md` first; it is authoritative. This file is the work order.
Log everything dated in `RESOLUTION.md` (create it with your first entry).
House rules: binary unconditional standard; never state a lemma you
believe might be false; a precise negative (a delimited dead route, a
failed necessary condition) is a deliverable, not a failure.

## WP-0 — literature triage (GATE: nothing else starts until this is logged)

The problem was selected as "an easier case of a very similar problem";
the first duty is to make sure it is not already a *solved* case.

1. **Duncan, "Finite groups of essential dimension 2"** — is
   \(\operatorname{PSL}_2(\mathbf F_7)\) on the ed-2 list?  Record the
   exact theorem/table entry either way.  This single lookup, combined
   with SPEC's expected reduction, may already determine the answer's
   direction.
2. **Cheltsov–Tschinkel–Zhang (July 2026 manuscript and its references)** —
   Problem E's status came from CTZ retaining the Klein *cubic* as an
   exception.  Check what the same literature says about the Klein-quartic
   dP2 with the \(\operatorname{PSL}_2(\mathbf F_7)\)-action:
   linearizability is expected there to be known-false; is
   \(G\)-unirationality / very versality addressed?
3. **Dolgachev–Iskovskikh** (finite subgroups of the Cremona group) and
   the dP2 rigidity literature (Cheltsov, Prokhorov) — collect the
   established facts SPEC marks **(verify)**:
   \(\operatorname{Aut}(S)=G\times\langle\text{Geiser}\rangle\),
   \(\operatorname{rk}\operatorname{Pic}(S)^G\), minimality, rigidity.
4. **Outcome gate.**  (a) Settled in the literature ⟹ the packet pivots
   to a verification/exposition goal — report to the director before any
   further work.  (b) Genuinely open ⟹ proceed, and record the precise
   frontier (who proved what nearest to it).

## WP-1 — action model and unconditional audit

Exact algebra over \(\mathbf Q(\zeta_7)\) or \(\mathbf Q(\sqrt{-7})\) as
needed (the 3-dimensional representation is defined over
\(\mathbf Q(\sqrt{-7})\)); Macaulay2 or the CAS of your choice, with
scripts checked into `certificates/` even for negative or routine runs.

1. Fix generators of \(G\subset\operatorname{GL}(V)\) explicitly (the
   classical \(7\)-cycle/involution pair for the Klein quartic); verify
   \(q_4\) invariance on the nose, smoothness of \(S\), and
   \(S^G=\varnothing\).
2. **Abelian fixed-point audit** (SPEC starting point 2): for every
   conjugacy class of abelian subgroups \(A\subseteq G\), decide
   \(S^A\ne\varnothing\).  Any failure resolves the problem negatively on
   the spot (cite the exact versality-necessary-condition statement when
   invoking it).  The 2-groups (\(\mathbf Z/2\), \(\mathbf Z/2\times
   \mathbf Z/2\), \(\mathbf Z/4\)) are the ones where the double cover
   could surprise; the odd-order cases lift automatically.
3. The 56 lines: orbit structure of \(G\) on the exceptional curves,
   \(\operatorname{rk}\operatorname{Pic}(S)^G\), \(G\)-minimality.
4. \(2\le\operatorname{ed}_{\mathbf C}(G)\le3\) with citations
   (\(G\not\subset\operatorname{PGL}_2(\mathbf C)\) for the lower bound;
   the generically free linear 3-dimensional action for the upper).

## WP-2 — the reduction (the mirror of E's headline theorem)

Target: \(S\) is \(G\)-unirational \(\iff\)
\(\operatorname{ed}_{\mathbf C}(G)=2\), or the sharpest statement that is
actually true — if the equivalence only goes one way, say so and prove
that way.

1. Pin the Duncan–Reichstein equivalences for \(S\) (twists are dP2s over
   \(K\); the action lifts weighted-linearly).
2. Pin the dP2 substitute for Kollár's step: the exact unconditional
   "rational point ⟹ unirational over \(K\)" statement for degree-2 del
   Pezzo surfaces over infinite characteristic-0 fields
   (Salgado–Testa–Várilly-Alvarado; Festi–van Luijk; later improvements).
   If the literature statement carries a general-position hypothesis,
   determine whether the twist's point can be moved into position
   (\(K\) infinite) or whether the gap is real — this is the one step
   with genuine room for a surprise, flag its resolution prominently.
3. The generic-torsor argument and the \(\dim Z\) fork as in SPEC; write
   the compression argument for the converse direction (ed-2 witness ⟹
   this \(S\)), which is where E's proof does not simply transcribe.

## WP-3 — constructions (in parallel with WP-2 once WP-0/1 are logged)

Attempt list, each with a dated post-mortem win or lose:

1. **The weighted cone.**  \(\{w^2=q_4(v)\}\subset V\oplus\mathbf C w\)
   is a \(G\)-invariant affine hypersurface in a 4-dimensional
   representation dominating \(S\).  Determine whether it is
   \(G\)-equivariantly rational or unirational from a representation —
   the naive candidate for a positive resolution.
2. **Equivariant conic-bundle / Bertini structures** on \(S\) (the
   anticanonical double cover, \(G\)-Mori fiber structures from the
   \(G\)-minimal model program on \(S\)): each gives a possible
   \(U\dashrightarrow S\) factory or an obstruction locus.
3. **Sylow-restricted versality** (E starting point 3 mirror): for each
   Sylow \(G_p\), is the restricted action \(G_p\)-unirational?  Positive
   restricted answers are supporting evidence and tooling practice;
   a negative one at any prime is decisive.

## WP-4 — certificates and resolution

Positive: explicit \(U\), explicit polynomial map, machine-checkable
equivariance + dominance, over an exactly-represented number field.
Negative: the failed necessary condition or the \(\operatorname{ed}=3\)
proof plus the WP-2 reduction, at the same standard.  Either way, the
`certificates/` package must be self-contained and re-runnable from a
fresh clone, per the E convention that `tmp/` computation trees are local
provenance only.

## Director protocol

Report at WP gates, not on a clock.  The WP-0 outcome gate (a) — already
settled in the literature — goes to the director immediately with the
citation, before any further effort is spent.
