# Prior-work audit

## 1. Documents audited

The theorem boundary was checked against the current versions of:

- `NOTEBOOK.md`
- `REPAIR.md`
- `HANDOFF.md`
- `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md`
- `theory/FIX_VII_carrier.md`
- `theory/FIX_VI_prym.md`
- `goals_2026-08-01/J_FIXED_CENTRE_PRYM/HODGE_ISOGENY.md`
- `goals_2026-08-01/J_FIXED_CENTRE_PRYM/CENTRE_REALIZABILITY.md`
- `goals_2026-08-01/J_FIXED_CENTRE_PRYM/BLOWUP_FORMULA.md`
- `goals_2026-08-01/J_FIXED_CENTRE_PRYM/ONE_MOTIVE.md`
- `goals_2026-08-01/J_FIXED_CENTRE_PRYM/STATUS.md`
- every required file in
  `goal_runs_20260809/EXCEPTIONAL_CARRIER_RIGIDITY/`
- `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/STATUS.md`
- `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/INTERMEDIATE_JACOBIAN_AFTER_REES.md`
- `goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION/STATUS.md`
- `goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION/INTERMEDIATE_JACOBIAN.md`
- `goal_runs_20260809/RETRACTION_FANO_REES_CARRIER/THEOREM.md`
- `goal_runs_20260809/RETRACTION_FANO_REES_CARRIER/STATUS.md`
- the newer Fano-carrier Hodge representation packet and the 2026-08-10
  Wave-32 status corrections.

The audit frontier was the main-branch commit
`4b858312bb4f6388a494c393588af693c3feccd8` (2026-08-10).  This includes the
notebook reconciliation at `d963f17da77b23f80c9bb256aeb7effa1c488be2` and
the Fano-carrier Hodge representation theorem at
`2301b4501170c3d6fd533a8d886f4ea05e9ed41a`.

Later correction layers were treated as binding.  In particular, no use was
made of the old generically-finite proof of the ambient split injection, the
stale marked-\(E[2]\) charge description, or a clean Rosati norm identity for
rational selfmaps.

## 2. N1–N4 classification

### N1 — already proved; exact accepted form

For a resolved ambient landing morphism

\[
g:Z^4\to X^3
\]

and a \(G\)-invariant relatively ample class \(\eta\) with
\(g_*\eta=n>0\),

\[
s(\beta)=\frac1n g_*(\eta\cup\beta)
\]

satisfies \(s\circ g^*=\operatorname{id}\) on \(H^3(X)\).  Thus \(g^*\) is a
split \(G\)-equivariant injection of rational Hodge structures.

This is not new in the present packet.

### N2 — already proved as a necessary orbit condition; exact correction

The blowup formula over \(\mathbf P^4\) implies that an orbit of curve or
irregular-surface centers receives the target Hodge module.  If \(B\) is a
representative center with stabilizer \(H\), the exact necessary condition is

\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,
H^1(B,\mathbf Q)
\right)\ne0.
\]

One must not conclude that one representative contains the full
ten-dimensional rational Hodge structure or all five \(E_{-11}\) factors.
The orbit statement and Frobenius reciprocity are essential.

This is not new in the present packet.

### N3 — already substantially executed

The repository has already carried out:

- exact restriction of the Weil module to the relevant subgroup classes;
- the surviving \((H,\rho)\) channel screen;
- constructive Chevalley–Weil and Riemann–Hurwitz realizability models;
- the Auto-CM identification with \(E_{-11}\);
- the genus-26 Hessian/\(X(11)\) carrier candidate;
- genus-four and Prym covers over the fixed elliptics;
- the warning that \(H=1\) is representation-theoretically soft.

The new packet does not repeat these computations and does not reinterpret
achieved genera as exact minima.

### N4 — genuinely missing before this packet

The missing theorem was not another occurrence statement in \(H^3(Z)\).
It was a resolution-independent object attached to the actual normalized
ambient graph and carrying the actual image \(g^*V\).

The present packet supplies that object in the intersection-cohomology/Hodge-
module category:

\[
V\hookrightarrow IH^3(\widehat P)(1)
\]

together with a canonical perverse degree and a canonical nonempty set of
proper strict-support orbits receiving a nonzero \(V\)-projection.

The stronger ambient-to-restricted transfer remains missing.

## 3. Why Goal J applies and does not apply

Goal J constructs free \(G\)-orbits of positive-genus curves that may be blown
up after a map is already resolved.  Their new summands have the form

\[
\operatorname{Ind}_{1}^{G}H^1(C)(-1)
\]

and can contain any desired rational \(G\)-representation.  Therefore the
statement

```text
some resolution contains an abstract copy of V
```

is too weak.

However, if \(h:Z'\to Z\) is such a later refinement, then

\[
(g\circ h)^*V=h^*g^*V.
\]

Under the blowup decomposition of \(H^3(Z')\), this lies in the old pullback
summand and has zero projection to the newly inserted free-orbit summands.
The ambient normalized graph \(Y\), the canonical map
\(V\to IH^3(Y)(1)\), and its perverse strict-support blocks are unchanged.

Thus Goal J is a decisive counterexample to abstract occurrence, but not to
the stronger actual-image formulation proved here.

## 4. Relation to the 2026-08-09 carrier packets

The restricted carrier packet correctly proves mapwise finiteness and
refinement invariance for the normalized graph of one fixed restricted ideal.
It also correctly distinguishes Rees divisors, contracted weak divisors,
normalized point-fiber curves, and fixed slices in stable surfaces.

It does not prove that an ambient Hodge-essential support meets the dominant
restricted component, and it does not identify ambient and restricted Rees
valuations.  The new ambient theorem therefore precedes, rather than replaces,
that packet.

The Fano-retraction packet supplies explicit genus-four carriers whose
\(H^1\) has the needed Weil multiplicity.  This confirms that
representation-theoretic availability is not an obstruction.  It does not
prove that every ambient support restricts to those curves.

## 5. New progress recorded here

Only the following are new theorem-level advances:

1. the canonical injection of the actual landing Hodge structure into
   \(IH^3\) of the ambient normalized graph;
2. proper strict-support localization via the perverse filtration over
   \(\mathbf P^4\);
3. the exact generalized support condition (AHS);
4. the separation between unconditional Hodge-module support and the
   conditional ordinary \(H^1\) case;
5. the precise identification of restricted transfer as a
   non-characteristic/nonvanishing problem rather than a Rees-field problem.

N1, N2, the subgroup table, the Auto-CM calculation, and the existing carrier
examples are inputs, not claimed progress.
