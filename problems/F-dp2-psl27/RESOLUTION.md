# Problem F — resolution log

## 2026-07-28 — WP-0 literature triage (director; primary sources read, not search summaries)

### Verdict: OPEN, and positioned exactly as the motivating suggestion claimed

**1. The class is explicitly open.**  Cheltsov–Tschinkel–Zhang, *Equivariant
unirationality of Fano threefolds* (manuscript dated July 18, 2026; arXiv
2502.19598 lineage), p. 2, read verbatim:

> "Duncan proved that Condition **(A)** is also sufficient for
> \(G\)-unirationality of del Pezzo surfaces of degree \(\ge 3\), with
> generically free actions [17, Theorem 1.4]. The cases of del Pezzo
> surfaces of degree 2 and 1 remain open."

Same source, p. 1–2: their (U) \(G\)-unirationality (dominant equivariant
\(\mathbf P(V)\dashrightarrow X\)) is equivalent to *very versality* in
Duncan–Reichstein terminology; \((L)\Rightarrow(SL)\Rightarrow(U)\);
**Condition (A)** — for every abelian subgroup \(A\subseteq G\),
\(X^A\ne\varnothing\) — is necessary for \(G\)-unirationality.  P. 3:
their smooth-cubic-threefold theorem retains
\(\operatorname{PSL}_2(\mathbf F_{11})\) on the Klein cubic among the
possible exceptions — consistent with Problem E's status.

So Problem F's specific instance — the most symmetric degree-2 del Pezzo
surface — sits inside an explicitly-open class, one degree below Duncan's
solved \(d\ge3\).  TO PIN (worker): the exact bibliographic identity of
CTZ's [17] (Duncan's del Pezzo unirationality paper; a candidate is the
EJM 2016 "Equivariant unirationality of del Pezzo surfaces of degree 3
and 4", authorship to confirm — Springer paywall blocked the check) and
Theorem 1.4's precise hypotheses.

**2. The essential-dimension invariant is already known — SPEC's
"expected reduction" was wrong and is corrected.**  Beauville, *Finite
simple groups of small essential dimension* (Trends in Contemporary
Mathematics, 2014), read directly:

- Proposition 16.3 (p. 223): *the simple finite groups of essential
  dimension 2 are \(\mathfrak A_5\) and
  \(\operatorname{PSL}_2(\mathbf F_7)\)* — via Duncan's classification
  (Comment. Math. Helv. **88** (2013), 555–585); the
  \(\operatorname{PSL}_2(\mathbf F_7)\) upper bound is realized by
  \(\mathbf P(V)\) for the 3-dimensional representation
  \(H^0(C,K_C)\), \(C\) the Klein quartic (p. 224).
- Beauville's "\(G\)-linearizable" = our \(G\)-unirational; so
  \(\mathbf P(V)\) itself is \(G\)-unirational, trivially, and it is the
  ed-2 witness.

Consequence: \(\operatorname{ed}_{\mathbf C}(G)=2\) carries NO leverage
on Problem F.  E's equivalence (problem ⟺ ed computation) rested on
Prokhorov's theorem that only two rationally connected threefolds carry
the \(\operatorname{PSL}_2(\mathbf F_{11})\)-action and they are
birational to each other; here the two minimal
\(\operatorname{PSL}_2(\mathbf F_7)\)-surfaces — \(\mathbf P(V)\) and
\(S\) (Cheltsov–Shramov: \(S\) is one of only two del Pezzo surfaces
with a faithful Klein-group action) — are NOT \(G\)-birational
(\(S\) non-linearizable by rigidity, to be re-cited in WP-1), so no
transfer exists.  SPEC's "expected reduction" section is superseded; the
governing frame is Duncan's Condition-(A) sufficiency question, one
degree down:

> **Corrected frame.**  Condition (A) is necessary.  Duncan proved it
> sufficient for del Pezzo surfaces of degree \(\ge3\).  Problem F asks
> the first open case, at its most symmetric instance:
> WP-1's abelian audit decides (A) for \((S,G)\); if (A) fails, F is
> resolved negatively on the spot; if (A) holds, F becomes a sharp test
> of whether Duncan's sufficiency extends to degree 2 — a positive
> resolution is the first degree-2 case, a negative one refutes the
> natural conjecture at its hardest instance.  Either outcome is a
> publishable unit, none disturbs a major conjecture.  This is the
> precise cash value of the motivating suggestion.

**3. Adjacent literature collected for WP-2/WP-3** (from the same
sweep; to be read before use): CTZ §3 "general unirationality
constructions in the equivariant context" (the toolbox; their double-cover
constructions are the closest to \(S\)); Cheltsov–Shramov, *Nonrational
del Pezzo fibrations admitting an action of the Klein simple group*
(arXiv 1506.05564) and *On conjugacy classes of the Klein simple group in
the Cremona group* (arXiv 1310.5548) — background on the two minimal
models and rigidity; Salgado–Testa–Várilly-Alvarado (arXiv 1304.6798) and
van Luijk et al. for ordinary dP2 unirationality-from-a-point (the
Kollár-step substitute flagged in SPEC).

### Status after triage

- WP-0 outcome gate: **(b) genuinely open** — proceed.  Frontier pinned:
  Duncan [17, Thm 1.4] (\(d\ge3\)) on one side, CTZ's explicit
  "degree 2 and 1 remain open" on the other.
- SPEC corrected in the same commit (expected-reduction section replaced
  by the Condition-(A) frame).
- Next: WP-1 (action model + abelian fixed-point audit = Condition (A)
  for \((S,G)\)) is now the decisive first computation.
