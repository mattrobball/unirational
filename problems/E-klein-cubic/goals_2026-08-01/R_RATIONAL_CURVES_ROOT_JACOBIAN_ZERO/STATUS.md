R-HILBERT-COMPONENT-STRUCTURAL

# Goal R status

## Verdict

The rational-curve route has a new exact structural closure through degree
five, together with an all-degree secant bridge, but it has **not** produced
a point of the genuine generic Klein
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
   coordinate-plane models: every conic is planar; if its plane is not
   contained in the cubic it has a residual \(K\)-line, while a contained
   \(K\)-plane itself contains \(K\)-lines.  Both cases contradict the
   binding no-line theorem.
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
4. More generally, every geometrically integral \(K\)-curve on \({}^T X\)
   whose normalization has genus zero forces a \(K\)-point of \({}^T X\),
   even when the genus-zero normalization is a nonsplit conic.  A
   \(K\)-rational anticanonical divisor of degree two on the normalization
   spans a \(K\)-secant line; the residual degree-one intersection with the
   cubic is a \(K\)-point (or the secant line is contained in the cubic and
   already has \(K\)-points).
5. For every smooth complex cubic threefold, the smooth rational-quartic and
   rational-quintic loci are irreducible of dimensions \(8\) and \(10\).
   Their usual Abel--Jacobi maps are dominant with general irreducible
   unirational fibres of dimensions \(3\) and \(5\).  On the Klein cubic the
   canonically normalized maps

   \[
   a_e(C)=\operatorname{AJ}(3[C]-eH^2),\qquad e=4,5,
   \]

   are Aut\((X)\)-equivariant, and every point of their generic twists must
   lie over zero.  Harris--Roth--Starr analyze only the general geometric
   fibre, not this distinguished zero fibre; thus these results do not
   manufacture a descended curve.
6. A smooth \(K\)-defined degree-five genus-two curve on \({}^T X\) is
   impossible: its span and a containing quadric are defined over \(K\),
   and the residual degree-one curve is a forbidden \(K\)-line.  For an
   elliptic quintic, by contrast, cubic-scroll residuation requires a
   \(K\)-point of \(\operatorname{Pic}^2\); the degree-five polarization
   does not provide one.  In Weil--Châtelet terms these conditions are
   \(2\alpha=0\) and \(5\alpha=0\), so a scroll choice would already split
   the elliptic curve and produce a point.
7. A smooth \(K\)-defined quartic elliptic curve is also impossible.  Its
   pencil of containing quadrics has a canonical constant residual line,
   giving an Aut\((X)\)-equivariant morphism to the Fano surface and hence
   a forbidden \(K\)-line after twisting.

The exact proof is in `THEOREM.md`.  The integral lattice calculation is
produced by `produce_fixed_jacobian.py`, serialized in
`fixed_jacobian_payload.json`, and independently recomputed by
`verify_fixed_jacobian.py`.

## Theorem boundary

This packet does **not** assert any of the following:

- that \({}^T X(K)\) is empty;
- that rational quartics, rational quintics, or all higher rational curves
  are absent;
- that a general-fibre Abel--Jacobi theorem identifies the distinguished
  canonical zero fibre on the maximally special Klein cubic;
- that a zero-cycle of degree one is a point;
- that a geometrically stable Hilbert component automatically descends a
  geometrically integral curve.

A curve with normalization \(\mathbf P^1_K\) would itself give a
\(K\)-point, so constructing one remains a headline-positive result.  No
such curve is present in this packet.

## Repository state consumed

- pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`;
- live repository commit consumed: `9f58d6cbe889997fbd8af2fc23bf9ef0e28a55e2`;
- route-scoped commits after the pinned baseline were audited through that
  head.  Commit `8a14d67` introduced Goal R without later changes to its
  requirements.  Commit `80f2469` added Roulleau's source and an independent
  exact fixed-Jacobian probe; its full-rank checks modulo 5 and 11 agree with
  this packet's Smith-form/normalizer calculation.  Commit `2140419` is a
  degree-25 landing-support result and does not alter this route's inputs;
  commits `2301a43` and `9f58d6c` add and bind the sibling Goal H subgroup
  sweep and do not change Goal R, `SPEC.md`, or the binding no-line theorem;
- binding no-line input: `problems/E-klein-cubic/RESOLUTION.md`, section
  “Other audited boundaries”;
- produced commit: none (the result is intentionally uncommitted and
  isolated under
  `goals_2026-08-01/R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO/` as directed).

## Smallest remaining positive theorem

Produce a \(K\)-point of \({}^T X\).  Within degree three this is exactly a
\(K\)-point of the exceptional divisor of \({}^T M_X\to{}^T\Theta\) over
zero.  In every degree, a descended geometrically integral genus-zero curve
would already imply such a point by the secant bridge.  A quartic-or-higher
continuation must therefore construct an actual Hilbert point in the
distinguished canonical zero fibre and verify geometric integrality; knowing
that the component or a general Abel--Jacobi fibre is unirational is
insufficient.
