# Path G Gate G1 — Decision at `(m,d)=(1,7)`

**Headline: OPEN.**  
**Decision exit: `G-SCOPED`.**  
**Containment `G subseteq R_3`: FALSE_AT_THIS_BIDEGREE.**  
**Open meeting: OPEN_MEETING_CERTIFIED.**  
**Forks G-A / G-B: NOT RUN.**

---

## Theorem boundary

| Proved here | Not proved here |
|-------------|-----------------|
| Free-module `L_3` Fitting ideal proper in free `B_0` | All-degree statement for every odd `m` |
| Residual S3-trivial free fibre has `L_3` rank 7 over `Q` with nonzero maximal minor | Full cyclotomic V4 triple-line specialization matrix |
| Residual S3-invariant **based** plane jets at `(1,7)`: dim `10` | Nonzero omega_3 on rank drop (Fork G-A) |
| Pure `a_triv` tensor `f` based subfamily: free-fibre `L_3` rank 7 at char-0 points of `G` | Algebraization of formal lifts (Fork G-B) |
| Open meeting of `G_witness` with `B \ R_3` at this bidegree | `ed_C(G)` / unirationality |

`G-SCOPED` carries **no headline claim**. Problem E remains **OPEN**.

---

## 1. Accepted sizes vs reconstruction

| quantity | accepted (Attempt-5) | actual |
|----------|---------------------:|-------:|
| `dim B_{1,7}` (C2 lead) | 112 | 112 |
| `dim J_plane` C2 | 112 | 112 |
| equalizer shape | <= ~230 x 112 | residual domain 19, based ker 10 |
| free `L_3` | 7 x 15, nnz 80, gen. rank 7 | 7 x 15, nnz 80, rank 7 at `a_triv` |

**Dimension agreement** on `dim B` and `dim J_plane`: **True**.  
Residual domain dim 19 << 112 is the residual S3 projection (expected; not a `G-STOP`).

---

## 2. Repaired category

Three copies of `P(E_-)` kept distinct (`certificates/transition_repair/`):

- `L_t^{src}` — source fixed line, disjoint from `Z_t`
- `P(E_-)^N` — exceptional normal-direction factor
- `L_t^{tgt}` — target fixed line

Based ledger: coefficient coupling `p` restricted to `E_-` is zero (orthogonal to normal-cone `L_r`).

---

## 3. Equalizer witness Lambda^rep_{1,7}

**Construction (Level-2 structural witness, residual form):**

1. Plane module `M_{1,7}`: free rank 4 over `Sym^6 E_+^*`, dim **112**.
2. Residual C3 weight-0 + reflection (+1) to residual S3-invariants, dim **19**.
3. Based equalizer: ker(restriction to residual-stable line `x2=0`), dim **10**.

This is the residual equalizer of plane to line with based coupling. Full V4/point
geometric rows from strata coordinates are **not** assembled here; they contribute
only an O(d) residual target envelope (accepted upper bound). The Level-2 growth
argument places based residual-invariant plane jets in Lambda for large d; at the
director start bidegree (1,7) the based residual space is already nonzero of
dimension 10, and the free-fibre open-meeting certificate lives on an
explicit linear subfamily.

CSR basis: `Lambda_basis_CSR.json`.

---

## 4. Image G_{1,7}

Projection pi retains the plane leading jet. For this witness, G is the same
10-dimensional linear subspace of `B_{1,7}` isomorphic to `Q^{112}`.

Contains pure residual-trivial free-fibre family `a_triv` tensor f (based): dim **4**.

---

## 5. Free-module L_3 and Fitting

- Shape (3m+4) x 3(m+4) = 7 x 15, entries quadratic in A_0..A_3.
- Polar model: B(z;y,y)=z0*2 y0 y1 + z1*y1^2 + z2*y0^2 (ranks transport).
- Fitt_0(coker L_3): proper, dim V = 3, degree 6, **165** GB generators over Q[A].
- Residual S3-trivial free fibre a_triv = (0,1,1,0):
  - rank L_3 = 7, coker 0
  - maximal minor on columns (0,1,2,5,8,11,14) equals **-2** (nonzero)

Hence a_triv is not in R_{3,1}^{free}.

---

## 6. Restriction of L_3 to G — decisive certificate

On the pure based family a_triv tensor f inside G_witness, free-fibre evaluation is a
scalar multiple of a_triv. Therefore L_3 has rank **7** (full free generic
rank) at every char-0 point of this subfamily with nonzero scale.

**Open meeting (char 0, globally compatible at the Level-2 based witness):**

```text
G_witness meet (B_{1,7} minus R_3) is nonempty
```

This is **not** a modular sample: ranks and the maximal minor are exact over Q.

---

## 7. Decision exit

### `G-SCOPED`

- Verdict only at bidegree (1,7) with the residual based witness equalizer.
- **No headline claim** (no all-degree theorem; no ed_C(G) statement).
- Director recommendation: **Fork G-B** (global states meet unobstructed open at
  this witness). Do **not** prioritize Fork G-A obstruction on rank drop from this
  gate alone.
- Forks G-A and G-B themselves were **not** executed.

If a future dispatch assembles full V4 triple-line geometric rows and finds that
every full-rank free-fibre section is killed, that would supersede the witness
scope — report as a new equalizer reconstruction, not a silent reconciliation.

---

## 8. Files

```text
certificates/global_lifting_decision/Lambda_basis_CSR.json
certificates/global_lifting_decision/G_projection_matrix.json
certificates/global_lifting_decision/Fitt_coker_L3.generators
certificates/global_lifting_decision/Fitt_coker_L3.json
certificates/global_lifting_decision/rank_certificate.json
certificates/global_lifting_decision/DECISION.md
certificates/global_lifting_decision/SEAL.json
certificates/global_lifting_decision/produce.py
certificates/global_lifting_decision/verify.py
```

### Terminal markers

```text
GLOBAL_LIFTING_DECISION_G1_OK
GLOBAL_LIFTING_DECISION_VERIFY_OK
```

---

## 9. Intended commit split

1. `certificates/global_lifting_decision/*` — Gate G1 decision packet only.
2. Do not touch `HANDOFF.md`, `RESOLUTION.md`, `CURRENT_PATHS.md`, `SPEC.md`.

**GLOBAL_LIFTING_DECISION_G1_OK**
