# C6.1 — Palatini / determinantal model

## Identity

Let \(m(u)\) be the vector of six signed \(5\times 5\) maximal minors of \(M(u)\).
Then

\[
m(u)=Q(u)\,u
\]

for a unique homogeneous quartic \(Q\).  Proof: \(m(u)\in\ker M(u)\) for any
\(5\times 6\) matrix; \(u\in\ker M(u)\) by skew-symmetry; compare dimensions on
the rank-5 open and observe vanishing on the rank-\(\le 4\) locus.

Modular specializations of all 126 coefficients of \(Q\) at the C5 fibres are
recorded in `quartic.json`.

## Birational geometry

- \(D=V(Q)\subset\mathbf P^5\) is the image of the pointed common-line incidence.
- On the open \(\mathrm{{rank}}\,M(u)=4\), \(L=\mathbf P(\ker M(u))\) is the unique
  common line through \([u]\).
- Inverse formulas: linear kernel / Cramer charts on nonzero \(4\times 4\) minors
  (no unstructured Gröbner basis).  See `quartic.json` → `inverse_formulas`.

## Rank \(\le 3\) boundary

Audited by modular sampling; rare in random trials.  Retained as a residual
stratum (lines in a larger kernel, possible singular components).

## Marker

```text
C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS
```
