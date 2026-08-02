# G3B — lines and plane conics on \(X_{\mathrm{gen}}=V(\Phi)\)

**Parent arithmetic:** `G3A-ARITHMETIC-DOMINANCE-PASS`  
**Headline:** OPEN  
**Exit:** `G3B-UNDECIDED` (exact residual ledger; no \(K_{\mathrm{proj}}\)-point)

## Line scheme

A line \(\operatorname{span}(A,B)\subset\mathbf P^4\) lies on \(V(\Phi)\) iff
\(\Phi(sA+tB)\equiv 0\) as a binary cubic, equivalently the four conditions

\[
\Phi(A)=B(A,A,B)=B(A,B,B)=\Phi(B)=0.
\]

The Fano scheme is covered by the \(\binom{5}{2}=10\) Grassmann big cells with
rref pivots \((i,j)\), each with 6 free parameters and 4 equations
(`line_scheme.json`).

Executable coefficient expansions are recorded for the **secondary-0 /
\(t_d=1\)** specialization of \(\Phi\) over \(\mathbf Q\).  The formal recipe over
full \(K_{\mathrm{proj}}\) is in `formal_line_recipe.json`.

## Line search residual

| Probe | Result |
|---|---|
| Coordinate spans \(e_i\wedge e_j\) | none on the specialized cubic |
| Support-\(\le 2\) integer vectors | none on the specialized cubic |
| Modular random search \(p=23,67,89\) | discovery samples only (no transfer) |

No \(K_{\mathrm{proj}}\)-line is claimed.  Emptiness of sparse/specialized probes is
**not** full Fano emptiness over \(K_{\mathrm{proj}}\).

## Plane-conic lane

A \(K_{\mathrm{proj}}\)-plane conic on \(X_{\mathrm{gen}}\) would force a residual
plane line over \(K_{\mathrm{proj}}\) and hence a point.  Tested coordinate and
small-integer planes: plane cubics do not factor as line\(\times\)conic in the
specialized model (`conic_search.json`).  Again, no transfer to \(K_{\mathrm{proj}}\).

## Smallest open gates

1. A point of the line Fano scheme over full \(K_{\mathrm{proj}}\) (any Grassmann chart).  
2. A \(K_{\mathrm{proj}}\)-plane whose cubic restriction factors as line \(\times\) conic.

## Non-claims

- No `G3-POINT-HEADLINE-POSITIVE`.  
- Modular lines are discovery-only.  
- G2/G3A exits are not resealed.
