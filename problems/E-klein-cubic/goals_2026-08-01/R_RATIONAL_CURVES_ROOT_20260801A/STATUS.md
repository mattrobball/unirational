R-HILBERT-COMPONENT-STRUCTURAL

# Goal R status

## Verdict

The rational-curve route reaches the sanctioned structural exit above.  It
does **not** produce a rational curve or a point on the genuine generic Klein
twist, so the Problem E headline remains **OPEN**.

Over

\[
K=K_{\rm proj}=\mathbf C(\mathbf P(W))^G,
\qquad G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

this packet proves the following exact statements.

1. The generic twist of the intermediate Jacobian has only its origin:
   \({}^T J(K)=\{0\}\).
2. More generally, every degree component \(J_e\) of the codimension-two
   cycle torsor has exactly one point after twisting.  The arithmetic input is
   the independently certified equality
   \(H^1(G,J[3])=0\).
3. There are no geometrically integral \(K\)-conics on \({}^T X\): every
   conic has a residual \(K\)-line, and the binding no-line theorem applies.
4. A plane rational cubic gives a \(K\)-point through its unique geometric
   singular point.  A generalized twisted-cubic Hilbert point maps to the
   theta desingularization and hence also forces a point of \({}^T X\).
5. The elliptic-normal-quintic component has **no** \(K\)-point.  Its unique
   possible Abel--Jacobi fibre is the twist of
   \(\mathbf P(H^0(E_0(1)))=\mathbf P(V_6^*)\), and the repository's exact
   Schur-class theorem identifies it as a nonsplit Severi--Brauer fivefold of
   index two.
6. Rational normal quartics are the first unresolved rational component.  A
   point must lie over the unique distinguished Abel--Jacobi value, but the
   theorem identifying a general quartic fibre with a threefold birational to
   \(X\) assumes a generic cubic and does not apply to the Klein cubic.

The exact proof and scope are in `THEOREM.md`; the degree-by-degree ledger is
in `HILBERT_INVENTORY.md`.

## Why this is a terminal structural exit

Any geometrically rational curve over \(K\) acquires a point over an
extension of degree at most two.  Since \({}^T X\) lies in a split
\(\mathbf P^4_K\), third intersection descends a quadratic point to a
\(K\)-point (the contained-line case is already impossible).  Conversely, a
smooth \(K\)-point on a cubic threefold over this infinite field gives the
standard tangent construction and hence \(K\)-unirationality and rational
curves.  Thus continuing Goal R past the distinguished quartic fibre is no
longer a lower-dimensional auxiliary problem: it is the open Problem E
headline itself.

No finite-degree emptiness claim is promoted to an all-degree theorem.

## Replay

From this directory:

```text
python3 produce_fixed_jacobian.py
/opt/homebrew/bin/python3 verify_fixed_jacobian.py
/opt/homebrew/bin/python3 probe_full_group_h1_mod3.py
/opt/homebrew/bin/python3 verify_group_cohomology.py
/opt/homebrew/bin/python3 verify_all.py --with-repository-dependencies
python3 produce_seal.py
python3 verify_seal.py
```

Required final lines include

```text
KLEIN_JACOBIAN_COMMON_FIXED_SUBGROUP_TRIVIAL
KLEIN_JACOBIAN_H1_MOD_3_TRIVIAL
R_RATIONAL_CURVES_STRUCTURAL_PACKET_VERIFIED
R_RATIONAL_CURVES_SEAL_VERIFIED
```

## Repository state consumed

- pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`;
- live commit at the final dependency snapshot:
  `e1fc474a448db9d93df13967a4cef5f9918ff443`;
- the work is uncommitted and isolated entirely under
  `R_RATIONAL_CURVES_ROOT_20260801A/` as requested;
- concurrent changes elsewhere in the worktree were neither edited nor
  staged.

## Strict nonclaims

- No \(K\)-point of \({}^T X\) is constructed or excluded.
- Rational quartics, rational quintics, and higher rational curves are not
  declared empty.
- A generic-cubic theorem is not specialized to the Klein cubic.
- A component, a zero-cycle, or an Abel--Jacobi value is not called a curve.
- A nonsplit genus-zero normalization is not silently called \(\mathbf P^1\).

