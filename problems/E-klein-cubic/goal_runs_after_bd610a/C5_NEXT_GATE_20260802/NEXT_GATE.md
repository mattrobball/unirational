# C5 next exact gate

**Date:** 2026-08-02  
**Portfolio front:** C / C5 Fano–common-line  
**Exit at intake:** `C5-UNDECIDED`  
**This packet exit:** `C5-UNDECIDED` (gate advanced, not closed)

---

## Smallest remaining exact gate

### Gate name

```text
G_MORITA_SOURCE_INTERPRETER
```

### Missing object

An **exact generic interpreter** that consumes every serialized Morita coefficient
record (not merely a parallel independent reconstruction of the intended
formula) and evaluates it from sealed source leaves:

| Object | Dimensions / counts | Field |
|---|---|---|
| Homogeneous Morita quadrics | 5 forms × 78 upper-triangular coeffs = **390** records | intended over \(K_{\mathrm{proj}}\) |
| Normalized charts \(q_r=1_D\) | 3 charts × 5 × 45 = **675** records | same |
| Split \(q_0=1\) DAG | **517** nodes (9 sources + matmul/pairing + 225 trace roots + 225 split transforms + affine/det nodes) | ambient embedding of \(K_{\mathrm{proj}}\) in \(\mathbb{Q}(\zeta_{11},t)(x)\) |
| Scalar variables (homogeneous) | 12 over \(D^3\) (3 rows × 4 corner basis) | |
| Scalar variables (chart \(q_0=1\)) | 8 free | |
| Target equations | 5 scalar quadrics (Hermitian values land in \(\mathrm{Sym}(D,\overline{\phantom a})=K\)) | |

### Exact coefficient formula (already specified, not yet generically executable)

For corner basis \(d_\alpha=e M_\alpha e\), Morita generators \(G_r\), and
\(B_i=Q(V_i)\), \(e=-PQ/s\):

\[
C_i\bigl((r,\alpha),(s,\beta)\bigr)
=
-\frac{\operatorname{Tr}\bigl(
P\,M_\alpha^{\mathsf T}\,Q\,P\,G_r^{\mathsf T}\,B_i\,G_s\,P\,Q\,M_\beta
\bigr)}{2\,s^3}.
\]

Serialized factors are prose labels
`P`, `transpose(M[α])`, `Q`, `B[i]`, … — not resolved circuit IDs in a
machine-checked generic source table.

### Why this is the smallest gate

Already sealed and **not** the missing object:

1. Canonical lazy algebra API (`multiply`, `σ`, `Trd`, five-plane).
2. Refutation of the literal self-adjoint idempotent incidence (`e S_0 e=0` with \(S_0=1\)).
3. Corrected Plücker model: fully serialized generic split hyperplanes + 15
   Plücker quadrics + 15 charts; modular smooth degree-14 fibres at
   \(331,463,419\).
4. Pairwise \(K_{\mathrm{proj}}\)-common-line theorem (Amer–Brumer + Springer);
   does **not** extend to 3 or 5 forms.
5. Bounded covariant exclusions through deg 16 (+ sparse deg-17 classes).
6. Smooth modular Morita seeds at \(p=23\).

The honest completion audit names the gap as:

> exact generic source resolver/interpreter (or explicit descent data) that
> consumes every serialized Morita record.

Until that exists, `C5-EXECUTABLE-FULL-INCIDENCE` over \(K_{\mathrm{proj}}\) is not
authorized. Modular seeds and pairwise descent do not close it.

### Planned certificate (when the gate closes)

```text
C5-EXECUTABLE-FULL-INCIDENCE
```

Required payload:

1. **Source-leaf binding:** every prose leaf
   `P,Q,a,b,B0..B4,M[·],G[·]` maps to a sealed lazy circuit or modular
   multiprime oracle with SHA-256 pins.
2. **Record consumption:** verifier walks *stored*
   `ordered_trace_terms.factors` (and/or split-DAG `nodes[*].op/args`) and
   evaluates them; it must fail if a single stored factor string is
   corrupted while left/right indices stay fixed.
3. **Holdout fibre:** at least one unused good prime where all 390 + 675
   (or the 225 \(q_0=1\) roots) match an independent Hermitian table.
4. **Open ledger:** nonvanishing of \(2\), \(\mathrm{Pf}(Q)\), \(s\), \(f_{14}\),
   corner minor, Morita-module minor as exact circuits (or multiprime
   nonidentical-vanishing certificates).
5. Optional strengthening: lowering of coefficients into the preferred
   length-12 \(\mathbb{Q}(t_3,t_6,t_8,t_{11})\) basis (normal-form recipe already
   written in `morita_generic_split.md`).

### Immediate geometric successor (after executability)

```text
G_HENSEL_ELIMINANT_LINEAR_FACTOR
```

On chart \(q_0=1_D\), fix free coordinates \((u_9,u_{10},u_{11})\) at the sealed
residue line residues, form the denominator-saturated zero-dimensional
\(K_{\mathrm{proj}}\)-algebra of the five equations in \((u_4,\ldots,u_8)\), and test
whether the \(u_8\) eliminant has a \(K_{\mathrm{proj}}\)-linear factor reducing to the
simple residue root (Jacobian minor \(11 \bmod 23\)). A simple residue root
alone proves only an étale/formal local section.

### What this packet advances (2026-08-02)

| Artifact | Advance |
|---|---|
| `source_leaf_binding.json` | Deterministic binding of all Morita prose leaves to sealed evaluation recipes |
| `produce_record_interpreter.py` | Walks every stored factor string / DAG node at the accepted fibre |
| `verify_record_interpreter.py` | Independent consumption + corruption self-test + multi-check against Hermitian tables |
| `interpreter_probe.json` | Machine record of counts, primes, checksums, and remaining gaps |

Still **not** claimed: \(K_{\mathrm{proj}}\)-point, char-0 eliminant factorization,
`C5-EXECUTABLE-FULL-INCIDENCE`, or `BR-FANO-POS`.
