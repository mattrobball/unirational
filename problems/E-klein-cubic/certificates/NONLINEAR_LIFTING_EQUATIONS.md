# Nonlinear lifting equations (WP-L1)

**Headline: OPEN.**  
**Dispatch:** First dispatch — universal polar expansion through normal order \(3m+3\).  
**Status:** Sealed and independently verified.  
**No formal lift is a covariant** (house rule 3).

## 1. Polarization of the Klein cubic

\[
F(x)=\sum_{i\in\mathbf Z/5}x_i^2 x_{i+1}.
\]

The unique symmetric trilinear form over \(\mathbf Q\) with \(\Phi(x,x,x)=F(x)\) is

\[
\Phi(u,v,w)
=
\frac13\sum_{i\in\mathbf Z/5}
\bigl(
u_i v_i w_{i+1}
+
u_i w_i v_{i+1}
+
v_i w_i u_{i+1}
\bigr).
\]

Equivalently,
\(6\Phi(u,v,w)=F(u+v+w)-F(u+v)-F(u+w)-F(v+w)+F(u)+F(v)+F(w)\).

The mixed polar form is

\[
B(z;y_1,y_2)=3\Phi(z,y_1,y_2),
\qquad
B(z;y,y)=3\Phi(z,y,y).
\]

### Director spine (used as given)

- On \(E_+\oplus E_-\), terms odd in \(y\) die:
  \[
  F(z+y)=F(z)+3\Phi(z,y,y)=F_+(z)+B(z;y,y),
  \]
  and \(F|_{E_-}=0\).
- Covariance \(p(tx)=tp(x)\) forces \(p_r\) to be \(E_+\)-valued for even \(r\) and
  \(E_-\)-valued for odd \(r\), and \(p|_{E_-}=p_d(0,y)\).

## 2. Normal expansion

For odd first normal order \(m\),

\[
\begin{aligned}
p_-&=a_m+a_{m+2}+a_{m+4}+\cdots,\\
p_+&=b_{m+1}+b_{m+3}+b_{m+5}+\cdots.
\end{aligned}
\]

Local normal order \(r\) and global polynomial degree \(d\) are **independent**
gradings.

Landing \(F(p)=0\) expands by

\[
F(p)=\Phi(p,p,p)=\sum_{i,j,k}\Phi(p_i,p_j,p_k).
\]

The normal order of \(\Phi(p_i,p_j,p_k)\) is \(i+j+k\). Triple-\(E_-\) contributions
vanish. Moreover \(F(p)\) is even in \(y\), so **odd** normal orders in \(F(p)\)
vanish automatically.

## 3. Universal equations (arbitrary odd \(m\), no instantiated \(d\))

### Order \(3m\) (automatic)

Pure leading \(a_m\) is \(E_-\)-valued and \(F|_{E_-}=0\). Also \(3m\) is odd.

### Order \(3m+1\) — **U.3m+1**

Only live triple: \((m,m,m+1)\) with multiplicity 3.

\[
\boxed{B(b_{m+1};a_m,a_m)=0}
\]

### Order \(3m+2\) (automatic)

Odd normal order.

### Order \(3m+3\) — **U.3m+3**

Live triples:

| triple | mult | term |
|--------|-----:|------|
| \((m,m,m+3)\) | 3 | \(B(b_{m+3};a_m,a_m)\) |
| \((m,m+1,m+2)\) | 6 | \(2B(b_{m+1};a_m,a_{m+2})\) |
| \((m+1,m+1,m+1)\) | 1 | \(F_+(b_{m+1})\) |

\[
\boxed{
B(b_{m+3};a_m,a_m)
+2B(b_{m+1};a_m,a_{m+2})
+F_+(b_{m+1})=0
}
\]

These identities are proved by combinatorial enumeration of triples (independent
of the numerical value of odd \(m\)) together with the exact polarization over
\(\mathbf Q\). They are **not** sample-based.

## 4. Isolation maps \(L_r\) and obstruction classes \(\omega_r\)

| \(r\) | newest unknown | equation | \(L_r\) | \(R_r\) | \(\omega_r\) |
|------:|----------------|----------|---------|---------|--------------|
| 0 | \(a_m\) | auto | \(0\) | \(0\) | free leading jet (residual constraints only) |
| 1 | \(b_{m+1}\) | U.3m+1 | \(B(-;a_m,a_m)\) | \(0\) | class in \(\operatorname{coker} L_1\) |
| 2 | \(a_{m+2}\) | none exclusive | — | — | free relative parameter for stage 3 |
| 3 | \(b_{m+3}\) | U.3m+3 | \(B(-;a_m,a_m)\) | \(2B(b_{m+1};a_m,a_{m+2})+F_+(b_{m+1})\) | class of \(R_3\) in \(\operatorname{coker} L_3\) |

So

\[
L_r(p_{m+r})=-R_r(p_m,\ldots,p_{m+r-1}),
\qquad
\omega_r\in\operatorname{coker}(L_r).
\]

## 5. Compatibility with the repaired category (WP-R0)

- U.3m+1 / U.3m+3 live on normal jets along \(Z_t\) / \(\mathbf P(N)\).
- Source-line based/residual conditions are **coefficient couplings** on
  \(L_t^{\mathrm{src}}\), orthogonal to the normal-cone equations.
- Target line \(L_t^{\mathrm{tgt}}\) receives the odd-\(m\) leading jet; landing
  constraints beyond order \(3m\) are exactly the universal equations above.
- Three copies of \(\mathbf P(E_-)\) remain distinguished.

## 6. Instantiation on WP-5 survivor families (estimate only)

No large elimination was run. Relative matrix **upper bounds** (full scalar
normal codomain before residual/\(S_3\) projection):

### `based_minus_lines_odd_m` (\(p|_{E_-}=0\))

| \((m,d)\) | \(L_1\) shape | dense GB | sparse GB |
|-----------|--------------:|---------:|----------:|
| (1,7) | 855 × 189 | 0.005 | 0.0004 |
| (1,25) | 13140 × 2700 | 1.14 | 0.007 |
| (5,35) | 69615 × 9765 | **21.8** | 0.035 |

### `residual_e1_swap_both` (\(d=6m+1\), ledger `swap_both`)

| \((m,d)\) | \(L_1\) shape | dense GB | sparse GB |
|-----------|--------------:|---------:|----------:|
| (1,7) | 855 × 189 | 0.005 | 0.0004 |
| (3,19) | 12936 × 2040 | 0.84 | 0.006 |
| (5,31) | 52377 × 7371 | **12.4** | 0.026 |

### `residual_e_ge7_generic_swap_both`

| \((m,d,e)\) | \(L_1\) shape | dense GB | sparse GB |
|-------------|--------------:|---------:|----------:|
| (1,13,7) | 3330 × 702 | 0.075 | 0.002 |
| (1,17,11) | 5880 × 1224 | 0.23 | 0.003 |
| (3,25,7) | 24321 × 3795 | 2.95 | 0.012 |

**Finite-order obstruction:** none certified in this dispatch (no elimination).

**Character strategy (for WP-L2):** C2 eigenspace already built into \(p_r\)
targets; residual \(S_3\) projectors on plane jets; D12 ordinary vs det-twisted
on source-line coupling; no naive averaging of affine torsors.

**Proposed certificate format:** relative sparse CSR of \([L_r\mid\omega_r]\) over
the coordinate ring of each stage locus, with sha256 of the CSR + base-ring
presentation; independent verifier rebuilds \(B\)-action and checks Fitting
generators.

## 7. Resource request for the director gate

- Exploratory gate: **8 GB RSS**.
- Dense materialization of full scalar codomains exceeds 8 GB for large sample
  bidegrees (e.g. \(m=5,d=35\): ~26 GB dense for \(L_3\)).
- **Sparse** floors stay \(\ll 1\) GB on all samples.
- WP-L2 should stream sparse relative Fitting / determinantal ideals over the
  multi-Rees base, with residual character blocks, **not** dense global matrices.
- Authorization for >8 GB is **not** requested for the first sparse stages of
  small bidegrees \((m,d)\in\{(1,7),(1,13),(1,25),(3,19)\}\); those fit under
  the exploratory gate in sparse form. A 96 GB request is reserved only if a
  later stage proves that residual projection does not cut the codomain enough.

## 8. Artifacts

```text
certificates/lifting/polar_expansion.py
certificates/lifting/polar_expansion.json
certificates/lifting/verify_polar_expansion.py
certificates/NONLINEAR_LIFTING_EQUATIONS.md
```

## 9. Not proved here

- Vanishing or nonvanishing of \(\omega_r\) on any family.
- Existence of a formal lift through all orders.
- Algebraization, equivariance of a global polynomial, primitivity, or dominance.
- \(\operatorname{ed}_{\mathbf C}(G)\) or unirationality of \(X\).

Problem E remains **OPEN**.
