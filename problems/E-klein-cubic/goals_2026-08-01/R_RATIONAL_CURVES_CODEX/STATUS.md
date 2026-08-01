R-HILBERT-COMPONENT-STRUCTURAL

# Goal R status

## Verdict

The rational-curve route has a new exact structural closure in degrees two
and three, but it has **not** produced a point of the genuine generic Klein
twist.  Consequently the Problem E headline remains **OPEN**.

The sanctioned structural exit above records the following unconditional
theorems over the genuine projective generic field

\[
K=K_{\rm proj}=\mathbf C(\mathbf P(W))^G,
\qquad T=\operatorname{Spec}\mathbf C(\mathbf P(W)).
\]

1. If \(J=J(X)\) is the intermediate Jacobian of the Klein cubic, then
   \({}^T J(K)=\{0\}\).
2. The generic twist \({}^T X\) has no geometrically integral
   \(K\)-defined conic.  This closes all conics, not merely the ten audited
   coordinate-plane models: every conic is planar and has a residual
   \(K\)-line, while the generic twist has no \(K\)-line.
3. Let \(M_X\to\Theta\subset J\) be the Aut\((X)\)-equivariant moduli
   desingularization associated with generalized twisted cubics.  After
   twisting,

   \[
   {}^T M_X(K)={}^T X(K)
   \]

   as subsets over the exceptional fibre: every \(K\)-point of the twisted
   moduli space maps to \(0\in{}^T J(K)\), and the fibre over zero is exactly
   the exceptional divisor \({}^T X\).  Hence a \(K\)-Hilbert point in the
   generalized twisted-cubic component forces a \(K\)-point of the original
   twist; the Abel-Jacobi parameter supplies no independent descended point.

The exact proof is in `THEOREM.md`.  The integral lattice calculation is
produced by `produce_fixed_jacobian.py`, serialized in
`fixed_jacobian_payload.json`, and independently recomputed by
`verify_fixed_jacobian.py`.

## Theorem boundary

This packet does **not** assert any of the following:

- that \({}^T X(K)\) is empty;
- that rational quartics, rational quintics, or all higher rational curves
  are absent;
- that the quartic Abel-Jacobi theorem proved for a generic cubic applies
  without repair to the maximally special Klein cubic;
- that a zero-cycle of degree one is a point;
- that a geometrically stable Hilbert component automatically descends a
  geometrically integral curve.

A curve with normalization \(\mathbf P^1_K\) would itself give a
\(K\)-point, so constructing one remains a headline-positive result.  No
such curve is present in this packet.

## Repository state consumed

- pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`;
- live repository commit: `2140419410cfff2f7d7dcca166acef8c16a0d41b`;
- later tracked commits touching `problems/E-klein-cubic` after the pinned
  baseline: none in the live history;
- binding no-line input: `problems/E-klein-cubic/RESOLUTION.md`, section
  “Other audited boundaries”;
- produced state: uncommitted, isolated under
  `goals_2026-08-01/R_RATIONAL_CURVES_CODEX/` as directed.

## Smallest remaining positive theorem

Produce a \(K\)-point of \({}^T X\).  Within degree three this is exactly a
\(K\)-point of the exceptional divisor of \({}^T M_X\to{}^T\Theta\) over
zero.  A quartic-or-higher continuation must instead construct and verify a
geometrically integral split rational curve (or an exact residual point) in
the original twist; a component or Abel-Jacobi value alone is insufficient.

