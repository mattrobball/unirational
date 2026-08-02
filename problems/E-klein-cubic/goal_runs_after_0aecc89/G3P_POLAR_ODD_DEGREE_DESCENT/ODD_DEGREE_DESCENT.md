# Odd-degree quadratic descent (G3P.3)

## Inputs

Both maximal \(A_5\) classes from `G4-INDUCED-DEGREE11-POINT-PASS` supply finite
étale extensions \(L_H/K_{\mathrm{proj}}\) of **degree 11** (odd) and induced
closed points of \(X_{\mathrm{gen}}\) of residue degree 11.  Explicit 5-tuples in
the normalized G3 frame are **not** provided (G4 residual / G7B).

## Audited path (required)

1. From \(p\in X_{\mathrm{gen}}(L)\) and ambient \(q\), build an \(L\)-point on a
   **quadratic** object from G3P.1/2.
2. Prove that quadratic object descends to \(K_{\mathrm{proj}}\).
3. Use that \([L:K_{\mathrm{proj}}]\) is odd on the open.
4. Apply **Springer only** to that quadratic form/quadric.
5. Push the isotropic vector through inverse formulas to \((v,t)\) and then to a
   point of \(X_{\mathrm{gen}}\).

## Execution status (both \(A_5\) classes, separate)

| Step | Class 1 | Class 2 |
|---|---|---|
| Degree 11 odd | yes | yes |
| Explicit \(p\) in G3 frame | **no** | **no** |
| \(L\)-point on K_proj-quadratic | blocked | blocked |
| Springer applied | no | no |
| \(K_{\mathrm{proj}}\) cubic point | no | no |

## Rejected inference

```text
cubic has an odd-degree point  =>  cubic has a ground-field point
```

**Rejected** for both classes: the quadratic interface was never entered.

Machine ledger: produced JSON block inside the producer output
`odd_degree_descent.json` (written below).
