# Explicit dominant map to the Klein cubic

This directory contains the September 2026 explicit resolution of Problem E.
The headline construction is the dominant equivariant rational map

\[
\Phi:\mathbf P(A^{\oplus4})=\mathbf P^{19}\dashrightarrow X,
\qquad G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

where \(A\) is the honest five-dimensional Klein representation and \(X\) is
the Klein cubic.

## Files

- `klein_rational_coordinates.pdf` / `.tex` — one-page basis-dependent
  coordinate formula.  The five output coordinates are explicit homogeneous
  determinant formulas in the 20 source coordinates; their common degree is
  568 before common-factor cancellation.
- `klein_map.py` — exact rational evaluator for the four-copy construction.
- `verify_model_exact.py` — exact Pfaffian identity and cyclotomic covariance
  of the fixed model.
- `verify_explicit.py` — exact rational witness and rank-three differential;
  its additional finite-field computation is only a nonvanishing certificate.

The key witness is

```text
b0 = ( 1,  1,  0,  0,  1)
b1 = ( 0,  1, -1,  1,  0)
b2 = (-1, -1,  1, -1, -1)
b3 = (-1,  1, -1,  0,  0)
```

with

```text
Phi(b0,b1,b2,b3) = [3:-2:2:-1:2]
det Jacobian minor = -221/27
```

so the map is defined on a nonempty open and has differential rank three.

## Reproduction

```bash
python3 klein_map.py
python3 verify_model_exact.py
python3 verify_explicit.py
```

The scripts use the Python standard library and exact integer/rational,
cyclotomic, or finite-field arithmetic as documented in their headers.  No
floating-point rank or randomized emptiness decision is part of the proof.

## Scope

This is a mathematical proof with reproducible exact checks, not a Lean
formalization.  It does not invalidate the older bounded exclusion results on
the standard \(\mathbf P^4\) source, nor the formalized no-map theorem for the
degree-fourteen Fano partner.
