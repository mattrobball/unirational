# Problem E — PSL(2,11)-unirationality of the Klein cubic

**Status: OPEN** (checked 2026-07-26).

Let \(G=\operatorname{PSL}_2(\mathbf F_{11})\) act through its faithful
five-dimensional representation on the Klein cubic threefold

\[
C=\{x_0^2x_1+x_1^2x_2+x_2^2x_3+x_3^2x_4+x_4^2x_0=0\}\subset\mathbf P^4.
\]

The problem asks whether \(C\) is \(G\)-unirational: equivalently, whether
there is a dominant \(G\)-equivariant rational map from a finite-dimensional
linear representation to \(C\).

The strongest theorem proved here is the exact reduction

\[
C\text{ is }G\text{-unirational}
\Longleftrightarrow
\operatorname{ed}_{\mathbf C}(G)=3.
\]

Since \(3\leq\operatorname{ed}_{\mathbf C}(G)\leq4\), a negative answer is
equivalent to \(\operatorname{ed}_{\mathbf C}(G)=4\). The work does not decide
between these two values.

## Start here

- [`SPEC.md`](SPEC.md) — authoritative statement, equivalent formulations,
  literature status, success criteria, and theorem boundaries.
- [`RESOLUTION.md`](RESOLUTION.md) — the proved essential-dimension reduction
  and the exact scope of every certified computation.
- [`CURRENT_PATHS.md`](CURRENT_PATHS.md) — ranked current attacks, stopping
  rules, and the most useful next computations.
- [`HANDOFF.md`](HANDOFF.md) — verification commands and safe re-entry points.
- [`certificates/README.md`](certificates/README.md) and
  [`certificates/CHECKS.md`](certificates/CHECKS.md) — the portable checked-in
  certificate package and its recorded successful runs.

## Current proved boundary

The checked-in certificate package verifies the exact 660-element action and
Klein-cubic invariance, explicit invariant and covariant data, the generic
frame, and scoped covariant exclusions. The research ledger records further
exact work: landing self-covariants are excluded through degree 14;
Jacobian-zero self-covariants are completely excluded through degree 11,
with the two pure degree-12 strata also excluded; constant-coefficient
Schur-source covariants are excluded in degrees 4, 6, 8, and 10, with scoped
degree-12 support exclusions; and matched Pfaffian covariants are excluded
through degree 15. The mixed degree-12 Jacobian locus, the full degree-12
Schur locus, Pfaffian degree 16, and the unbounded problems remain open.

These are bounded or construction-specific theorems. They do not provide an
all-degree negative result. A complete solution must still produce a dominant
equivariant parametrization, prove that the generic Klein twist has a rational
point, prove \(\operatorname{ed}_{\mathbf C}(G)=3\), or establish the
corresponding negative alternatives.

## Published artifact scope

The portable `certificates/` directory is tracked and can be replayed from a
fresh clone, subject to the dependencies listed in its README. The 2.4 GB
`tmp/` computation tree is intentionally ignored: it contains solver outputs,
large intermediate matrices, and the newer audit reports cited by
`SPEC.md`, `RESOLUTION.md`, `CURRENT_PATHS.md`, and `HANDOFF.md`. References to
`tmp/...` are local provenance pointers, not links to remotely published
artifacts. The documentation preserves their exact conclusions and stopping
rules without pretending that the scratch tree is part of this repository.
