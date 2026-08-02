# G3H phase5_next — polar data at \((q,a_i)\)

With sealed ambient \(q=[1:0:0:0:0]\) and trilinear \(B\),

\\[
A=\\Phi(q),\\qquad
C=B(q,q,a_i),\\qquad
D=B(q,a_i,a_i).
\\]

## Exact secondary expansions (K_proj)

- \(A=t_3\\cdot e_0\) (secondary-0 only), nonzero on \(t_3\\ne0\).
- Second-polar coefficients \(L_j=B(q,q,e_j)\) — sparse secondary vectors
  (ledger in `polar_data.json`).
- First-polar matrix \(M_{jk}=B(q,e_j,e_k)\) — full secondary expansion
  (ledger in `polar_data.json`).

## \(C,D\) as \(L_i\)-elements

With \(a_i^{(j)}=\\sum_t \\beta_{jt}\\theta^t\),

\\[
C=\\sum_t\\Bigl(\\sum_j L_j\\beta_{jt}\\Bigr)\\theta^t,
\\qquad
D=\\sum_{s,t}\\Bigl(\\sum_{j,k}M_{jk}\\beta_{js}\\beta_{kt}\\Bigr)\\theta^{s+t}\\bmod\\mu.
\\]

The structure constants \(L_j,M_{jk}\) are fully secondary-expanded; the
\(\\beta\) tables are residual as in `AI_EXPANSION.md`.

## Line residual (not over K_proj)

\\[
A s^2 + 3 C s t + 3 D t^2 = 0
\\]

is the residual binary quadratic on the line \(qa_i\). Coefficients \(C,D\)
lie in \(L_i\), so the object is **not** \(K_{\\mathrm{proj}}\)-defined.
