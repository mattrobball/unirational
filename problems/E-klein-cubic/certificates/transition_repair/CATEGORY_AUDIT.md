# WP-R0 — Category audit of `diagram.json`

**Headline: OPEN.**  
**Work package:** WP-R0 (first dispatch).  
**Source:** `certificates/global_transition/diagram.json` (16 flags).

## 1. The three copies of \(\mathbf P(E_-(t))\)

| id | symbol | ambient | path tag | role |
|----|--------|---------|----------|------|
| `L_t_src` | \(L_t^{\mathrm{src}}\) | \(\mathbf P(W)\) | SOURCE | source fixed line |
| `P_E_minus_normal` | \(\mathbf P(E_-)^{N}\) | \(\mathbf P(N_{Z_t/Y})\simeq Z_t\times\mathbf P(E_-)\) | NORMAL | exceptional normal-direction factor |
| `L_t_tgt` | \(L_t^{\mathrm{tgt}}\) | \(X^{t}\) | TARGET | target fixed line |

**Disjointness.** \(L_t^{\mathrm{src}}\cap Z_t=\varnothing\) because \(E_+\cap E_-=0\) in \(W\).

They are isomorphic as residual \(D_{12}\)-spaces but are **not** the same geometric object.

## 2. Arrow types

Every repaired arrow is one of:

```text
SOURCE-RESTRICTION
NORMAL-CONE-SPECIALIZATION
TARGET-EVALUATION
COEFFICIENT-COUPLING
```

## 3. Legacy flag classification

| legacy id | status | type (if retained) |
|-----------|--------|--------------------|
| `plane_to_minus_line` | **REPLACED** | (see span below) |
| `plane_to_triple_line` | retained | NORMAL-CONE-SPECIALIZATION |
| `plane_to_D10` | retained | SOURCE-RESTRICTION |
| `plane_to_D12` | retained | SOURCE-RESTRICTION |
| `plane_to_elliptic` | retained | SOURCE-RESTRICTION |
| `minus_line_to_type_I` | retained | SOURCE-RESTRICTION |
| `minus_line_to_C6` | retained | SOURCE-RESTRICTION |
| `V4_line_to_type_I` | retained | NORMAL-CONE-SPECIALIZATION |
| `V4_line_to_type_II` | retained | NORMAL-CONE-SPECIALIZATION |
| `V4_line_to_A4` | retained | SOURCE-RESTRICTION |
| `V4_line_to_D12` | retained | SOURCE-RESTRICTION |
| `C3_line_to_C6` | retained | SOURCE-RESTRICTION |
| `C3_line_to_A4` | retained | SOURCE-RESTRICTION |
| `type_II_to_three_elliptics` | retained | TARGET-EVALUATION |
| `type_I_to_one_elliptic` | retained | TARGET-EVALUATION |
| `A4_to_planes` | retained | SOURCE-RESTRICTION |

### Why `plane_to_minus_line` is replaced

The legacy geometry string claimed

> \(L_t=\mathbf P(E_-)\subset\) boundary of the normal cone of \(Z_t\)

and the specialization string claimed a restriction/evaluation of the leading jet
as \(\Delta_t^m\cdot h_t\). That single arrow mixed:

1. the exceptional normal factor \(\mathbf P(E_-)^{N}\) (boundary of the normal cone);
2. the target line \(L_t^{\mathrm{tgt}}\) (image of the odd-\(m\) leading jet);
3. the source-line coefficient condition \(p|_{E_-}=\Delta_t^m h_t\).

Items (1)–(2) live on \(\mathbf P(N_{Z_t/Y})\). Item (3) is a **terminal
coefficient** on \(L_t^{\mathrm{src}}\), which does **not** meet \(Z_t\).

## 4. Replacement span

\[
Z_t^{\mathrm{src}}
\;\longleftarrow\;
\mathbf P(N_{Z_t/Y})
\;\longrightarrow\;
L_t^{\mathrm{tgt}}
\qquad\text{plus}\qquad
L_t^{\mathrm{src}}\dashrightarrow X^{t}
\qquad\text{plus coefficient coupling.}
\]

| new arrow id | type | meaning |
|--------------|------|---------|
| `normal_cone_projection` | NORMAL-CONE-SPECIALIZATION | \(\mathbf P(N)\to Z_t\) |
| `normal_cone_to_target_line` | TARGET-EVALUATION | odd-\(m\) jet \(\mathbf P(N)\to L_t^{\mathrm{tgt}}\) |
| `source_line_restriction` | SOURCE-RESTRICTION | \(p|_{L_t^{\mathrm{src}}}\) |
| `coefficient_coupling_terminal` | COEFFICIENT-COUPLING | \(p|_{E_-}=p_d(0,y)\) |

## 5. Coefficient coupling (director-verified)

For \(x=z+y\), \(z\in E_+\), \(y\in E_-\):

- \(F(z+y)=F(z)+3\Phi(z,y,y)=F_+(z)+B(z;y,y)\), and \(F|_{E_-}=0\).
- Covariance \(p(tx)=tp(x)\) forces \(p_r\) to be \(E_+\)-valued for even \(r\) and
  \(E_-\)-valued for odd \(r\), and \(p|_{E_-}=p_d(0,y)\).

The source-line formula \(p|_{E_-}=\Delta_t^m h_t\) (residual families) or \(0\)
(based family) is this terminal coefficient, **not** a restriction of the first
normal jet on \(Z_t\).

## 6. Forbidden identifications (verifier rejects)

1. \(L_t^{\mathrm{src}}\subset Z_t\).
2. \(L_t^{\mathrm{src}}=\mathbf P(E_-)^{N}\) as geometric objects.
3. \(L_t^{\mathrm{src}}=L_t^{\mathrm{tgt}}\) as incidence objects.
4. Legacy `plane_to_minus_line` as ordinary restriction of the first jet on \(Z_t\).

## 7. Corrected necessity (summary)

Every landing covariant still determines a state in the repaired equalizer
\(\Lambda^{\mathrm{rep}}\). The forgetful map to the legacy equalizer is
surjective on linear data, so the corrected state space is **at least as large**
as the WP-5 state space. Exit P is not overturned. **No negative theorem** is
inferred from the repair (house rule 2).

Surviving families retained:

- `based_minus_lines_odd_m`
- `residual_e1_swap_both`
- `residual_e_ge7_generic_swap_both`

No new Level-1 family is created by the repair.

## 8. Artifacts

- `category_repaired.json` — sealed payload
- `produce.py` / `verify.py` — independent producer / verifier
- `../TRANSITION_CATEGORY_REPAIR.md` — package note
