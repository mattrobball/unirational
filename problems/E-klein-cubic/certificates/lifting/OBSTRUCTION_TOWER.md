# WP-L2 — Relative obstruction tower

**Headline: OPEN.**  
**Decision exit: L-P.**  
**Dispatch:** Second — free-module stages \(L_1,\omega_1\) and \(L_3,\omega_3\).  
**8 GB RSS gate:** observed free-module matrices only; no dense full-C2
instantiation beyond the gate.

## 1. Setup

Corrected WP-5 survivor families (no new family from the category repair):

1. `based_minus_lines_odd_m`
2. `residual_e1_swap_both`
3. `residual_e_ge7_generic_swap_both`

Universal equations (WP-L1, accepted):

\[
L_1(b_{m+1})=B(b_{m+1};a_m,a_m)=0,
\qquad
L_3(b_{m+3})=-R_3,\quad
R_3=2B(b_{m+1};a_m,a_{m+2})+F_+(b_{m+1}).
\]

Source-line based/residual conditions are **coefficient couplings** on
\(L_t^{\mathrm{src}}\) (WP-R0); they do not replace the normal-cone
operators \(L_r\).

## 2. Multi-Rees / free \(R\)-module formulation (all-degree)

Let \(R=\operatorname{Sym}(E_+^*)\). Normal-order jets of order \(k\) with
values in a target of dimension \(t\) form a **free** \(R\)-module of rank
\(\dim\operatorname{Sym}^k E_-^*\cdot t = (k+1)t\).

| object | free rank |
|--------|----------:|
| leading \(a_m\) | \(2(m+1)\) |
| domain \(L_1\) | \(3(m+2)\) |
| codomain \(L_1\) (order \(3m+1\)) | \(3m+2\) |
| domain \(L_3\) | \(3(m+4)\) |
| codomain \(L_3\) (order \(3m+3\)) | \(3m+4\) |

**Mixed polar model.** Up to D12-weight scale,

\[
B(z;y,y)=z_0\cdot 2y_0 y_1+z_1\cdot y_1^2+z_2\cdot y_0^2,
\]

realising \(\varphi:E_+\xrightarrow{\sim}\operatorname{Sym}^2 E_-^*\)
(\(\det\varphi=2\)). Representation-theoretic ranks transport to the
concrete Klein polar.

**Relative sparse matrix.** Each entry of \(L_r\) is a quadratic form in the
leading coefficients \(A_p\):

\[
(L_r)_{u,v}=\sum_{p,q} c_{u,v,p,q}\,A_p A_q
\quad\text{(COO of quadratic terms in `free_module_stages.json`)}.
\]

Base ring: coordinate ring of free leading jets; multi-Rees restores
\(O(d-m)\) when degree is instantiated.

### Representation before elimination

1. **C2** — built into target eigenspaces.
2. **Residual C3-weights** (order-three \(\rho=r^2\)) — domain and codomain
   split into weight spaces \(\{0,1,2\}\); block ranks computed **before**
   full product elimination.
3. **D12 ordinary / det-twisted** — source-line coupling only; orthogonal to
   \(L_r\).
4. Full residual \(S_3\) (triv / sign / std) refines C3 when needed.

## 3. First two nonautomatic stages (exact free-module)

### Stage \(r=1\) (\(L_1,\omega_1\))

- \(R_1=0\), so \(\omega_1=0\) in \(\operatorname{coker} L_1\) identically.
- Equation is \(L_1(b)=0\): always solvable (\(b=0\)); the lifting locus
  \(B_1\) is the relative kernel of \(L_1\) over \(B_0\).

| \(m\) | shape \(L_1\) | generic rank (exact over \(\mathbf Q\)) | nullity | coker |
|------:|-------------:|------------------------------------------:|--------:|------:|
| 1 | \(5\times 9\) | 5 | 4 | 0 |
| 3 | \(11\times 15\) | 11 | 4 | 0 |

**Structural pattern (observed, free-module level).** At generic leading jets,
\(L_1\) is surjective of rank \(3m+2=\operatorname{codomain}\), with

\[
\operatorname{nullity}(L_1)=3(m+2)-(3m+2)=4
\]

independent of \(m\). Generic rank is the maximum over exact \(\mathbf Q\)-
specializations of the leading jet (upper semicontinuity); samples are
constant on the test set. Characteristic zero, not modular (house rule 11).

### Stage \(r=3\) (\(L_3,\omega_3\))

- Same polar operator as \(L_1\) on order-\((m+3)\) jets.
- \(\omega_3=\) class of \(R_3\) in \(\operatorname{coker} L_3\).

| \(m\) | shape \(L_3\) | generic rank | nullity | coker |
|------:|-------------:|-------------:|--------:|------:|
| 1 | \(7\times 15\) | 7 | 8 | 0 |
| 3 | \(13\times 21\) | 13 | 8 | 0 |

At generic leading jets \(L_3\) is likewise surjective (coker \(=0\)), so
\(\omega_3=0\) automatically on that open set: every \(R_3\) lies in
\(\operatorname{im} L_3\). Sample Fitting tests for \(m=1,3\) confirm
this. Nullity \(=3(m+4)-(3m+4)=8\) independent of \(m\).

The remaining locus where \(\omega_3\) can obstruct is the **rank-drop**
closed set of \(L_3\) (Fitting ideal of coker), not the generic fibre.

**No family is empty** at stages \(r=1,3\).

## 4. Instantiated bidegrees (regression / director start)

Every numerical \((m,d)\) below is labelled **regression_bidegree**: free-
module theorems reduce the universal family by tensoring with
\(\operatorname{Sym}^{d-*}E_+^*\). Director-authorized starts:

| family | \((m,d)\) or \((m,d,e)\) |
|--------|---------------------------|
| based | \((1,7),\ (1,13),\ (1,25),\ (3,19)\) |
| e1 swap_both | \((1,7),\ (3,19)\) |
| generic \(e\ge7\) | \((1,13,7),\ (3,25,7)\) |

Full C2 upper dimensions and sparse memory floors are in each family's
`tower_stages.json`. Free-module matrices stay far under 8 GB; dense full-C2
at large \(d\) is **not** launched.

## 5. Surviving formal parameters and next obstruction module

For each family (none killed):

- **Parameters:** \(a_m\) on \(B_0\); \(b_{m+1}\in\ker L_1\) (generic rank 4 at
  \(m=1\)); \(a_{m+2}\) free relative (no exclusive equation at \(r=2\)).
- **Next obstruction module:** \(\omega_3\in\operatorname{coker} L_3\) as a
  coherent sheaf on \(B_1\times(\text{\(a_{m+2}\)-space})\), **not** a
  covariant (house rule 3).

## 6. Decision exit

| code | meaning | this dispatch |
|------|---------|---------------|
| L-N | every family killed at finite order | **not reached** |
| **L-P** | a family survives to the computed order | **reached** |
| L-F | tower reduces by periodicity / finite generation | **not proved** |

**L-P:** all three families survive the free-module stages through order
\(3m+3\) at generic leading jets. Combine with WP-E1: the order-twelve
quadratic-trace kills a *different* (factorized Fable) ansatz, not these
families.

## 7. Files

```text
certificates/lifting/families/common_tower.py
certificates/lifting/families/produce.py
certificates/lifting/families/verify.py
certificates/lifting/families/SUMMARY.json
certificates/lifting/families/free_module_stages.json
certificates/lifting/families/*/tower_stages.json
certificates/lifting/OBSTRUCTION_TOWER.md
certificates/lifting/SEAL.json
```

```sh
/opt/homebrew/bin/python3 -u certificates/lifting/families/produce.py
/opt/homebrew/bin/python3 -u certificates/lifting/families/verify.py
```

## 8. Boundary

**Proved:** relative sparse \(L_r\); C3-before-elimination; generic exact
ranks; \(\omega_1=0\); sample \(\omega_3\) Fitting tests; L-P survival.

**Not proved:** all-degree emptiness; closed Fitting generators of the
\(\omega_3\) locus in all degrees; L-F reduction; existence of a landing
covariant; global \(G\)-gluing.

**Headline remains OPEN.**
