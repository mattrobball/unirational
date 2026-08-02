# G3C — full \(K_{\mathrm{proj}}\) Fano scheme of lines
**Exit:** `G3C-UNDECIDED`  **Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`  **G3A:** `G3A-ARITHMETIC-DOMINANCE-PASS`  **G3B residual input:** `G3B-UNDECIDED`  **Peak RSS (produce):** 85.8 MB  **Elapsed:** 16.6 s
## Setup
A line \(\operatorname{span}(A,B)\subset\mathbf P^4\) lies on \(V(\Phi)\) iff the four \(K_{\mathrm{proj}}\)-conditions

\[
\Phi(A)=B(A,A,B)=B(A,B,B)=\Phi(B)=0
\]

hold. Each condition is a length-12 vector over \(P_0=\mathbf Q(t_3,t_6,t_8,t_{11})\). The Fano scheme is covered by the \(\binom{5}{2}=10\) Grassmann big cells (G3B formal recipe), each with 6 free parameters.
## Chart expansions (full secondary basis)
| pivots | Phi_A terms | B_AAB terms | B_ABB terms | Phi_B terms | B_AAB linear in free B |
|---|---:|---:|---:|---:|---|
| [0, 1] | 20 | 40 | 40 | 20 | True |
| [0, 2] | 20 | 40 | 40 | 20 | True |
| [0, 3] | 20 | 40 | 40 | 20 | True |
| [0, 4] | 20 | 40 | 40 | 20 | True |
| [1, 2] | 20 | 40 | 40 | 20 | True |
| [1, 3] | 20 | 40 | 40 | 20 | True |
| [1, 4] | 20 | 40 | 40 | 20 | True |
| [2, 3] | 20 | 40 | 40 | 20 | True |
| [2, 4] | 20 | 40 | 40 | 20 | True |
| [3, 4] | 20 | 40 | 40 | 20 | True |

## Linear elimination
In every chart, \(B(A,A,B)\) is degree \(\le 1\) in the three free \(B\)-parameters. Formal pivots on each free \(B_i\) are recorded in `line_fano_kproj.json` → `chart_summaries[].linear_elimination`. After eliminating one free \(B\), the residual is three \(K_{\mathrm{proj}}\)-equations in five free parameters (36 \(P_0\)-component equations) — not zero-dimensional in the scalar free-parameter model.
## Probes performed
- Coordinate spans \(e_i\wedge e_j\): none on full \(K_{\mathrm{proj}}\) (0 hits).
- Sparse QQ free-param search (chart (0,1), full secondary components): 625 pairs, 0 hits.
- Modular discovery (p=101,103,107; all 12 components): p=101: 0 found, p=103: 0 found, p=107: 0 found (discovery-only).
- Residual CAS after linear \(B_0\)-elim on secondary-0 at t=(2,3,5,7): status `linear_elim_residual_recorded`.
- Plane-conic light lane: 10 coordinate planes; no transferred \(K_{\mathrm{proj}}\) line×conic split.
## Residual gates (named)
1. A point of the line Fano scheme with free parameters valued in full \(K_{\mathrm{proj}}\) (secondary content), after linear \(B\)-elimination.
2. Zero-dimensional residual CAS on the 72-variable / 48-equation P0-model of a single chart (free params expanded in the secondary basis).
3. A \(K_{\mathrm{proj}}\)-plane whose cubic restriction factors as line × conic.
## Non-claims
- No `G3-POINT-HEADLINE-POSITIVE`.
- Modular lines are discovery-only.
- Scalar free-param non-hits and specialized residual CAS are **not** emptiness of the full \(K_{\mathrm{proj}}\) Fano scheme.
- G2/G3A/G3B exits are not resealed.
