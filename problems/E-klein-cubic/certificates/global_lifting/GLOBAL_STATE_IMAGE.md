# Global state image in leading-jet space (Attempt 5, Gate 1 / 5B)

**Headline: OPEN.**  
**Containment status: UNDECIDED.**  
**Dispatch:** formulation + size estimates only (WORKORDER first dispatch item 4).  
**Formal states are never covariants** (house rule 8).  
**No Fork A / Fork B work in this package** (house rule 4).

---

## Theorem boundary

| Proved here | Not proved here |
|-------------|-----------------|
| Exact defining data for \(G_{m,d}\subseteq B_{m,d}\) | \(G_{m,d}\subseteq\mathcal R_{3,m}\) |
| \(\mathcal R_{1,m}\), \(\mathcal R_{3,m}\) as Fitting loci of accepted \(L_r\) | \(G_{m,d}\cap(B_{m,d}\setminus\mathcal R_{3,m})\ne\varnothing\) |
| Precise next decision + Fork A/B split | Closed Fitting generators of \(\mathcal R_3\) in all \(m\) |
| §7.2 size estimates for deciding it | Existence of a landing covariant |
| Structural: \(\mathcal R_{3,m}\subsetneq B_0^{\mathrm{free}}\) for \(m=1,3\); \(G\neq 0\) for large \(d\) | Emptiness of any survivor family |

Problem E remains **OPEN**.

---

## 0. Why this is the only meaningful remaining question

Local screens are exhausted:

1. no finite marked-state obstruction (Exit N1 closed);
2. no linear all-order obstruction — plane jets grow \(O(d^2)\) vs \(O(d)\) boundary conditions (Exit N2 closed);
3. first two nonautomatic nonlinear stages kill nothing on generic free-module loci (Exit L-P).

The remaining question is **global**:

> Are the global compatible leading states forced into the rank-drop locus of the nonlinear lifting operators, or do they meet the generic-surjective locus?

Everything downstream forks on that answer. This package formulates the objects and estimates the cost of deciding; it does **not** decide.

---

## 1. Accepted inputs (not re-derived)

```text
certificates/transition_repair/*          # three copies of P(E_-) separated
certificates/lifting/polar_expansion.json # L_r / omega_r through r=3
certificates/lifting/families/*           # three survivor families, Exit L-P
certificates/global_transition/*          # Lambda, Exit P, necessity
```

Survivor families (formal states only):

- `based_minus_lines_odd_m`
- `residual_e1_swap_both`
- `residual_e_ge7_generic_swap_both`

Formal parameters after stages \(r=1,3\): \((a_m,\, b_{m+1}\in\ker L_1,\, a_{m+2})\).  
Next obstruction module: \(\omega_3\) as a coherent sheaf on rank-drop / special fibres — **not** a covariant.

---

## 2. Corrected category (three copies of \(\mathbf P(E_-)\))

From WP-R0 (`transition_repair/category_repaired.json`):

| id | symbol | ambient | path |
|----|--------|---------|------|
| `L_t_src` | \(L_t^{\mathrm{src}}\) | \(\mathbf P(W)\) | SOURCE |
| `P_E_minus_normal` | \(\mathbf P(E_-)^{N}\) | \(\mathbf P(N_{Z_t/Y})\) | NORMAL |
| `L_t_tgt` | \(L_t^{\mathrm{tgt}}\) | \(X^{t}\) | TARGET |

**Disjointness.** \(L_t^{\mathrm{src}}\cap Z_t=\varnothing\).

**Forbidden** (verifier rejects): identifying any two of the three copies; treating legacy `plane_to_minus_line` as ordinary restriction of the first normal jet on \(Z_t\).

**Arrow types.**

```text
SOURCE-RESTRICTION | NORMAL-CONE-SPECIALIZATION | TARGET-EVALUATION | COEFFICIENT-COUPLING
```

**Replacement span.**

\[
Z_t^{\mathrm{src}}
\;\longleftarrow\;
\mathbf P(N_{Z_t/Y})
\;\longrightarrow\;
L_t^{\mathrm{tgt}}
\qquad+\qquad
L_t^{\mathrm{src}}\dashrightarrow X^{t}
\qquad+\qquad
p\big|_{E_-}=p_d(0,y).
\]

---

## 3. Modules \(\Lambda^{\mathrm{rep}}_{m,d}\) and \(B_{m,d}\)

### 3.1 Corrected inverse limit \(\Lambda^{\mathrm{rep}}_{m,d}\)

\[
\Lambda^{\mathrm{rep}}
=
\lim_{\longleftarrow} M_\bullet
\]

is the residual-equivariant **equalizer** of local bigraded modules on objects of the repaired incidence category \(\mathcal C^{\mathrm{rep}}\), in fixed odd normal order \(m\) and global degree \(d\).

**55-plane architecture** (house rule 6):

```text
plane normalization → triple-line equalizer → residual point kernel
```

(retaining finite irrelevant torsion \(T_m\)).

**Additional equalizer factors:** C3 lines (not forced base); A4 / D10 / D12 point modules; minus-line D12 data on \(L_t^{\mathrm{src}}\); marked elliptic charges; **coefficient coupling** \(p|_{E_-}=p_d(0,y)\); **target evaluation** of the odd-\(m\) jet to \(L_t^{\mathrm{tgt}}\); normal-cone projection \(\mathbf P(N)\to Z_t\).

**Nonemptiness (WP-5, char 0).** For every odd \(m\ge 1\) and all large \(d\),

\[
\dim\Lambda_{m,d}\ge c_m d^2-C_m d-C'_m>0.
\]

Forgetful map \(\Lambda^{\mathrm{rep}}\to\Lambda_{\mathrm{legacy}}\) is surjective on linear data (size `AT_LEAST_AS_LARGE`). Elements of \(\Lambda\) are **necessary formal configurations only**.

### 3.2 Leading-jet space \(B_{m,d}\)

\[
B_{m,d}
=
\text{parameter space of residual-allowed leading jets \(a_m\)}
\]

of normal order \(m\), global degree \(d\), valued in \(E_-\) (odd \(m\)). Free \(R\)-module rank over \(R=\operatorname{Sym}(E_+^*)\):

\[
\operatorname{rank}_R(\text{leading fibre})=2(m+1).
\]

Multi-Rees restores \(\operatorname{Sym}^{d-m}E_+^*\). Geometry lives on the **normal** side \(\mathbf P(N_{Z_t/Y})\), not on \(L_t^{\mathrm{src}}\).

The free-module base \(B_0\) of the obstruction tower is the fibre coordinate ring

\[
\mathbf Q[A_0,\ldots,A_{2m+1}]
\]

(sealed in `free_module_stages.json`). Instantiated \(B_{m,d}\) is the corresponding multi-Rees / residual slice.

---

## 4. Scheme-theoretic image \(G_{m,d}\subseteq B_{m,d}\)

### 4.1 Projection

\[
\pi_{m,d}\colon
\Lambda^{\mathrm{rep}}_{m,d}
\longrightarrow
B_{m,d}
\]

retains only the plane / normal-cone leading component \(a_m\). Residual line, V4, point, C3, and marked decorations are forgotten as free variables (they already appear as equalizer constraints).

### 4.2 Image

\[
G_{m,d}
\;:=\;
\text{scheme-theoretic image of \(\pi_{m,d}\)}
\;=\;
\operatorname{Spec}\!\bigl(
\mathcal O(B_{m,d})/\ker(\pi^*)
\bigr)
\;\subseteq\;
B_{m,d}.
\]

**Exact defining data.**

1. Repaired category \(\mathcal C^{\mathrm{rep}}\) with the four arrow types and three distinguished copies of \(\mathbf P(E_-)\).
2. Accepted local modules \(M_S\) from `certificates/transitions/*/module.json`.
3. Equalizer presentation of \(\Lambda^{\mathrm{rep}}_{m,d}\).
4. Component projection \(\pi\) onto the leading jet \(a_m\).
5. Ideal of \(G\): kernel of the dual on coordinate rings (equivalently, the plane-component span of any \(\mathbf Q\)-basis of \(\Lambda\)).

**Linear structure.** \(\Lambda\) and \(B\) are graded pieces of linear modules and \(\pi\) is linear, so \(G_{m,d}=\operatorname{im}(\pi)\) is a **linear subspace (cone)** of \(B_{m,d}\). Scheme-theoretic and set-theoretic images agree.

**Family refinements.** Each Level-1 survivor family cuts a closed subscheme \(G^{\mathrm{fam}}_{m,d}\subseteq G_{m,d}\) by coefficient-coupling ledger (based vs residual). Formal parameters on each:

\[
\bigl(a_m\in G^{\mathrm{fam}},\;
b_{m+1}\in\ker L_1,\;
a_{m+2}\text{ free relative}\bigr).
\]

---

## 5. Rank-drop loci \(\mathcal R_{1,m}\) and \(\mathcal R_{3,m}\)

Accepted universal equations (WP-L1):

\[
\boxed{B(b_{m+1};a_m,a_m)=0}
\qquad\text{(U.3m+1)}
\]

\[
\boxed{
B(b_{m+3};a_m,a_m)
+2B(b_{m+1};a_m,a_{m+2})
+F_+(b_{m+1})=0
}
\qquad\text{(U.3m+3)}
\]

Isolation maps (same polar operator in the leading jet \(a_m\)):

| \(r\) | operator | free shape | RHS |
|------:|----------|------------|-----|
| 1 | \(L_1(b)=B(b;a_m,a_m)\) | \((3m+2)\times 3(m+2)\) | \(R_1=0\) |
| 3 | \(L_3(b')=B(b';a_m,a_m)\) | \((3m+4)\times 3(m+4)\) | \(R_3=2B(b_{m+1};a_m,a_{m+2})+F_+(b_{m+1})\) |

\[
\mathcal R_{1,m}
=
V\bigl(\operatorname{Fitt}_0(\operatorname{coker} L_1)\bigr)
\subseteq B_{m,*},
\qquad
\mathcal R_{3,m}
=
V\bigl(\operatorname{Fitt}_0(\operatorname{coker} L_3)\bigr)
\subseteq B_{m,*}.
\]

**Sealed free-module pattern (\(m=1,3\), char 0).** Generic rank of \(L_1\) equals codomain rank (coker \(0\), nullity \(4\)); generic rank of \(L_3\) equals codomain rank (coker \(0\), nullity \(8\)). Hence both \(\mathcal R_{1,m}\) and \(\mathcal R_{3,m}\) are **proper closed** in free \(B_0\). On the open \(B\setminus\mathcal R_{3,m}\), every right-hand side \(R_3\) is solvable and \(\omega_3=0\).

Obstructions at stages \(1\) and \(3\) live only on Fitting rank-drop loci, not on the generic free fibre (Exit L-P).

---

## 6. Required decision (next question only)

\[
\boxed{
G_{m,d}\subseteq\mathcal R_{3,m}
\qquad\text{or}\qquad
G_{m,d}\cap\bigl(B_{m,d}\setminus\mathcal R_{3,m}\bigr)\ne\varnothing.
}
\]

| Outcome | Fork |
|---------|------|
| forced into rank drop | **Fork A (5C)** — restrict \(\omega_3\) to \(G\); global equalizers; periodicity |
| meets generic-surjective open | **Fork B (5D)** — all-\(m\) rank theorem; polar recursion; formal lift + algebraization |

**Sample-point policy.** A sample of \(a_m\) is **insufficient** for either claim unless both:

1. characteristic-zero validity, and  
2. global compatibility (certified membership in \(\Lambda^{\mathrm{rep}}\)),

are proved. Modular discovery samples are for shape / pivot selection only.

**Status this dispatch: UNDECIDED.**

### Structural free results (not a containment decision)

| claim | label |
|-------|-------|
| \(\mathcal R_{3,m}\subsetneq B_0^{\mathrm{free}}\) for sealed \(m=1,3\) | structural (generic surjectivity of \(L_3\)) |
| \(G_{m,d}\ne 0\) (as a cone) for every odd \(m\) and all large \(d\) | structural (WP-5 nonemptiness + linear \(\pi\)) |
| No free proof that \(G\subseteq\mathcal R_3\) or that \(G\) meets the open, from accepted packets alone | structural meta |

The equalizer cuts are linear of growth \(O(d)\); \(\mathcal R_3\) is a nonlinear polar-determinantal locus. Their incidence is not settled by growth or free generic ranks alone. **No sampled verdict is reported.**

---

## 7. Size estimates only (§7.2)

Exploratory gate: **8 GB RSS**. This formulation job stays \(\ll 1\) GB.

### 7.1 Free-module matrices (decide Fitting shape; independent of \(d\))

| \(m\) | \(L_1\) shape | nnz quad | \(L_3\) shape | nnz quad | # max minors \(L_3\) | minor deg | sparse floor |
|------:|-------------:|---------:|-------------:|---------:|--------------------:|----------:|-------------:|
| 1 | \(5\times 9\) | 48 | \(7\times 15\) | 80 | \(6435\) | 14 | \(\ll 1\) MB |
| 3 | \(11\times 15\) | 320 | \(13\times 21\) | 448 | \(203490\) | 26 | \(\ll 1\) MB |
| 5 | \(17\times 21\) | ~scale | \(19\times 27\) | ~scale | \(\sim 2.2\times 10^6\) | 38 | still sparse-small |
| 7 | \(23\times 27\) | ~scale | \(25\times 33\) | ~scale | \(\sim 1.4\times 10^7\) | 50 | minors heavy; use incremental Fitting |

Nullity formulas (pattern): \(\operatorname{null} L_1=4\), \(\operatorname{null} L_3=8\), independent of \(m\). Sealed for \(m=1,3\); extrapolated beyond that only as a pattern.

Dense free matrices are tiny. Prefer M2/Singular Fitting over enumerating all maximal minors for \(m\ge 5\).

### 7.2 Instantiated equalizer envelopes (full C2 upper bounds)

| \((m,d)\) | \(\dim B\) (C2 lead) | \(\dim J_{\mathrm{plane}}\) | equalizer shape upper | dense GB | sparse GB |
|-----------|---------------------:|----------------------------:|----------------------:|---------:|----------:|
| (1,7) | 112 | 112 | \(\sim 230\times 112\) | \(<0.01\) | \(<0.01\) |
| (1,13) | 364 | 364 | \(\sim 260\times 364\) | \(<0.01\) | \(<0.01\) |
| (1,25) | 1300 | 1300 | \(\sim 310\times 1300\) | \(\sim 0.01\) | \(<0.01\) |
| (3,19) | 1224 | 1224 | \(\sim 415\times 1224\) | \(\sim 0.02\) | \(<0.01\) |
| (3,25) | 2208 | 2208 | \(O(d)\times O(d^2)\) | \(<0.1\) | \(<0.01\) |
| (5,35) | 5952 | 5952 | \(\sim 990\times 5952\) | \(\sim 0.19\) | \(<0.01\) |

Full-C2 \(L_1/L_3\) dense floors (from prior lifting packet): \((1,25)\) \(\sim 1.1\) GB dense; \((5,35)\) exceeds 8 GB dense. **Sparse residual / free-module path stays under the exploratory gate** for director start bidegrees.

### 7.3 Recommended decision path

1. **Free-module Fitting of \(L_3\)** for \(m=1\) then \(m=3\) (\(\ll 1\) GB) → generators of \(\mathcal R_{3,m}\) in \(B_0^{\mathrm{free}}\).
2. **Sparse equalizer** for \(\Lambda_{m,d}\) at start bidegrees \((1,7)\), \((1,13)\), \((3,19)\) → basis; project to \(G\).
3. **Restrict \(L_3\) to \(G\)**: generic rank over \(\operatorname{Frac}(\mathcal O(G))\), or rank at **certified** \(\mathbf Q\)-points of \(G\) with global-compatibility certificates.
4. Verdict rule:
   - rank attains free generic value on a Zariski-open of \(G\) (char 0) \(\Rightarrow\) \(G\) meets \(B\setminus\mathcal R_3\) (Fork B);
   - \(\operatorname{Fitt}\) vanishes identically on \(G\) \(\Rightarrow\) \(G\subseteq\mathcal R_3\) (Fork A).

### 7.4 Proposed certificate format (for a future decision packet)

```text
Lambda_basis_CSR.json          # exact Q sparse basis of equalizer kernel
G_projection_matrix.json       # plane-component map π
Fitt_coker_L3.generators       # M2/Singular ideal over Q[A] or O(G)
rank_certificate.json          # generic rank of L_3 over G + proof type
SHA256SUMS                     # content hashes only; no timing fields
```

Self-hashes written after the last byte on disk.

### 7.5 Checkpoint plan

| CKPT | content |
|------|---------|
| 0 | free-module \(L_1/L_3\) COO + generic ranks (already sealed) |
| 1 | Fitt generators of coker \(L_3\) over free leading ring, \(m=1\) |
| 2 | same for \(m=3\); compare pattern |
| 3 | sparse equalizer rows streamed per orbit-type arrow |
| 4 | \(\Lambda\) basis at \((1,7)\); project to \(G\); store CSR |
| 5 | rank of \(L_3\) over \(G\) at \((1,7)\) with char-0 certificate |
| 6 | replicate at \((1,13)\), \((3,19)\); stop if pattern stable or a structural theorem appears |

On any checkpoint exceeding **8 GB RSS**: halt, re-emit dimensions, request director 96 GB only if the sparse residual path is proved insufficient.

### 7.6 Independent verifier design

- **This gate:** `certificates/global_lifting/verify.py` — does not import `produce.py`; checks defining data, three-copy separation, Fitting formulation, UNDECIDED status, self-hash, no timing fields, no covariant mislabel.
- **Future decision verifier:** rebuild equalizer rows from incidence + local modules; recompute \(\ker\); recompute Fitting or rank over \(G\) independently; reject modular ranks advertised as char 0.
- **Tools (absolute paths):**  
  M2 `/opt/homebrew/bin/M2`, Singular `/opt/homebrew/bin/Singular`,  
  GAP `/opt/homebrew/Caskroom/miniforge/base/bin/gap`,  
  python3 `/opt/homebrew/bin/python3`.  
  Hazard: shell `gap` → `git apply`, `gp` → `git push`.

---

## 8. Artifacts

```text
certificates/global_lifting/GLOBAL_STATE_IMAGE.md
certificates/global_lifting/global_state_image.json
certificates/global_lifting/produce.py
certificates/global_lifting/verify.py
certificates/global_lifting/SEAL.json
```

### Replay

```sh
/opt/homebrew/bin/python3 -u certificates/global_lifting/produce.py
/opt/homebrew/bin/python3 -u certificates/global_lifting/verify.py
```

### Terminal markers

```text
GLOBAL_STATE_IMAGE_FORMULATION_OK
GLOBAL_STATE_IMAGE_VERIFY_OK
```

---

## 9. What remains (out of scope for Gate 1)

- Actually compute \(\operatorname{Fitt}(\operatorname{coker} L_3)\) and the equalizer basis.
- Decide \(G\subseteq\mathcal R_3\) vs open meeting (Fork A vs Fork B).
- Fork A: \(\omega_3|_G\), simultaneous global equalizers, periodicity / finite generation.
- Fork B: all-\(m\) rank theorem, higher polar recursion, global formal lifting, **algebraization** (a formal series alone is not a covariant).

**GLOBAL_STATE_IMAGE_FORMULATION_OK**
