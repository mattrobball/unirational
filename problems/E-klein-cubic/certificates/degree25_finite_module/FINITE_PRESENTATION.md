# P25Z.1 — Exact finite \(S\)-module presentation of \(R/J_N\)

**Headline: OPEN.**

**Exit:** `P25Z-FINITE-PRESENTATION`

**Peak RSS:** \(\approx 450\) MiB (under the 8 GiB exploratory ceiling).

---

## 0. Scope

Build an exact finite presentation of \(\mathcal M = R/J_N\) as an \(S\)-module,
where

\[
S=\mathbf F_{89}[q_0,\ldots,q_{36}],\qquad
R=S[k_0,\ldots,k_5],
\]

and \(J_N\) is the certified 746-row direct subsystem at the fixed \(Q(37)\oplus K(6)\)
frame.  Fitting/annihilator support is **out of scope** (P25Z.2); this packet only
seals the presentation and writes `preflight_p25z2.json`.

Does **not** import quarantined 842-row / rank-28 packets.  Does **not** repeat
the raw degree-4 F4/Macaulay job.

---

## 1. Accepted inputs (not re-derived)

| Fact | Source |
|---|---|
| 746 certified direct rows, rank 746 at \(p=89\) | `certificates/degree25_direct_support/` |
| Fixed \(QK\) frame; rows in `tmp/p25yf4_border/rows_qk.npz` | P25Y-B |
| Monic pure-\(K^3\) 56/56, finite over \(S\) on \(B=1\oplus K\oplus\mathrm{Sym}^2K\) | `SUPPORT_P25YB_STEP5.md` |
| Pivot profile \(K^3{:}56\), \(QK^2{:}690\), mixed higher \(0\) | same |
| Finite generation on 28 generators is **not** freeness | work order §2.4 |

---

## 2. Construction

### 2.1 Basis and free module

\[
\mathcal B=\{1\}\cup\{k_i\}\cup\{k_ik_j:i\le j\},\qquad
|\mathcal B|=28,\qquad
F=S^{28}.
\]

Sealed in `basis_B.json`.

### 2.2 Monic \(K^3\) rewrite rules (sealed)

Preferred left-to-right RREF of the \(746\times 14190\) QK-ordered cubic matrix yields
**56 monic** pivots on pure-\(K^3\) columns.  Each rule is

\[
\mu + \mathrm{tail}_\mu = 0\quad\text{in }R/J_N,
\]

with \(\mu\) a pure-\(K\) cubic monom, leading coefficient \(1\), and
\(\mathrm{tail}_\mu\in\sum_{b\in\mathcal B}S\cdot b\) (dense mixed tails).  Sealed in
`rewrite_rules.npz` / `rewrite_rules.json` (lex-sorted on the six-exponent keys).

### 2.3 Multiplication operators \(T_i\)

Multiplication by \(k_i\) on \(F\), reducing pure-\(K^3\) via the sealed rules:

- \(\deg b\le 1\): \(T_i(e_b)=e_{k_ib}\) (permutation `low_target`);
- \(\deg b=2\): \(T_i(e_b)=-\mathrm{tail}_{k_ib}\) as an \(F_3\)-polyvector
  (`T_quad_F3`).

Sealed in `multiplication_matrices.npz`.  These are \(S\)-linear endomorphisms of \(F\).

### 2.4 Residual cubic generators

The 690 non-\(K^3\) RREF pivots, already \(K^3\)-free, are polyvectors in \(F\):

\[
s_a\in F_3\subset F,\qquad a=1,\ldots,690,
\]

stored as the dense graded matrix `seed_F3` of shape \(690\times 14134\)
(\(9139+6\cdot703+21\cdot37\)).  This is the degree-3 presentation block

\[
S^{690}\xrightarrow{\;V\;}S^{28},\qquad
\mathrm{im}(V)=N_0:=S\cdot\{s_a\}.
\]

### 2.5 Commutators and confluence

- On \(\deg b\le 1\): \(T_iT_j e_b=T_jT_i e_b\) by monom commutativity (exact).
- On \(\deg b=2\): the operators \([T_i,T_j]\) are nonzero at sample points
  (\(\sim 15\) pairs, \(\sim 315\) nonzero defect columns), but every specialized
  defect lands in the specialized seed span (40/40 trials, seed PM `2026073189`).

Commutator defects lie in \(N=\ker(F\to R/J_N)\) because the \(k_i\) commute in \(R\).

### 2.6 Relation submodule and closure

Define

\[
N \;=\; \text{smallest \(T_i\)-stable \(S\)-submodule of \(F\) containing all }s_a.
\]

Then \(N=\ker(F\to R/J_N)\): the cubics generate \(J_N\) as an ideal, their
\(K^3\)-normal forms are the \(s_a\) (or zero), and ideal multiples reduce to
\(T\)-words on the \(s_a\).

**Closure ledger** (`closure_ledger.json`):

| Round | Event | Generators |
|------:|---|---:|
| 0 | residual cubic seeds | 690 |
| 1 | \(T_i\)-closure + commutators (specialized) | +0 fibre relations; rank already 28/28 |

Specialized stabilization: **0 rounds** beyond the seeds (seed span already full
rank 28 at every tested \(q_0\)).  Stabilized at round 1 of the ledger.

### 2.7 Presentation shape

\[
S^{690}\xrightarrow{V}S^{28}\longrightarrow F/N_0\longrightarrow 0
\]

with \(V\) the sealed seed matrix, together with the sealed operators \(T_i\),
presents \(\mathcal M=R/J_N\) in the **operator form** used for finite algebras
over \(S\):

\[
\mathcal M \;\simeq\; F\big/N,\qquad
N=T\text{-stable hull of }\mathrm{im}(V).
\]

Numerical shape of the sealed degree-3 generating matrix: **\(690\times 28\)**.
The full set of \(S\)-module generators of \(N\) is finite (Hilbert basis / order
ideal of size 28) and is obtained by applying \(T\)-words to the seeds; on a
Zariski-dense open of \(\operatorname{Spec} S\) the seed span is already full
rank 28, so the hull does not enlarge the fibre.

---

## 3. Isomorphism \(\mathcal M\simeq R/J_N\)

Mutually inverse maps (details in `iso_proof.json`):

**\(\varphi:F/N\to R/J_N\).**  Send basis element \(e_b\) to the class of monom
\(b\).  Well-defined because seeds (and their \(T\)-stable hull) lie in
\(\ker(F\to R/J_N)\).  Surjective by monic \(K^3\) finite generation on \(\mathcal B\).

**\(\psi:R/J_N\to F/N\).**  Reduce any representative by the sealed monic \(K^3\)
rules to an element of \(F\), then pass to \(F/N\).  Well-defined on \(J_N\)
because cubic generators reduce into \(N\) and ideal multiples are \(T\)-words.

**\(\varphi\psi=\mathrm{id}\):** rewrites are equalities in \(R/J_N\).

**\(\psi\varphi=\mathrm{id}\):** elements of \(F\) are already \(K\)-normal forms.

---

## 4. Specialized fibre certificate (recomputed by verifier)

At 40 (producer) / 25 (verifier) independent random \(q_0\in\mathbf F_{89}^{37}\)
(Park–Miller-compatible seed `2026073189`):

| Invariant | Value |
|---|---|
| Rank of specialized seed matrix \(690\times 28\) | **28** (always) |
| \(T_i\)-stable | **yes** (always) |
| Commutator defects in seed span | **yes** (always) |
| Specialized fibre dimension of \(F/N\) | **0** |
| Rounds to stabilize specialized closure | **0** |

This is **not** a Nullstellensatz proof of projective emptiness (that is P25Z.2).
It certifies that the presentation is fibrewise full rank on a dense sample.

---

## 5. Independent verification

`verify_presentation.py` does **not** import the producer.  It recomputes:

1. RREF pivot profile \(56+690\);
2. monic \(K^3\) tails and byte-match to sealed rules;
3. residual seeds and byte-match to sealed `seed_F3`;
4. \(T_i\) tails from recomputed rules vs sealed `T_quad_F3`;
5. specialized rank / \(T\)-stability / commutator span (25 trials);
6. sample identity \(T_0(k_0^2)=-\mathrm{tail}(k_0^3)\).

Result: `verify_presentation_result.json` — **PASS** (20/20).

---

## 6. Theorem boundary

**Proved:**

- Sealed monic pure-\(K^3\) rewrite system (56/56) for the 746-row subsystem.
- Sealed multiplication operators \(T_i\) on \(F=S^{28}\).
- Exact residual cubic generators: 690 polyvectors; presentation block \(690\times 28\).
- \(N:=T\)-stable \(S\)-hull of those generators equals \(\ker(F\to R/J_N)\).
- \(\mathcal M=F/N\simeq R/J_N\) as \(S\)-modules via mutually inverse reduction maps.
- Specialized fibres of the presentation are empty (rank 28) on 40 random points.

**Not proved:**

- \(\operatorname{Supp}_S(\mathcal M)=\varnothing\) after saturating \(\operatorname{Fitt}_0\) by
  \((q_0,\ldots,q_{36})^\infty\) — **P25Z.2**.
- Completeness of the 746-row span among all direct landing rows — **P25Z.3 / Worker R**.
- Headline PSL\((2,11)\)-unirationality of the Klein cubic threefold.

---

## 7. Artifacts

```text
certificates/degree25_finite_module/
  FINITE_PRESENTATION.md
  produce_presentation.py
  verify_presentation.py
  verify_presentation_result.json
  rewrite_rules.{npz,json}
  multiplication_matrices.{npz,json}
  relation_matrix.{npz,json}
  closure_ledger.json
  iso_proof.json
  basis_B.json
  exit_p25z1.json
  preflight_p25z2.json
```

**Exit marker:** `P25Z-FINITE-PRESENTATION`

**What remained:** P25Z.2 Fitting/annihilator support (preflight written; not started).

---

## 8. Intended commit split (path-scoped)

1. `certificates/degree25_finite_module/` — P25Z.1 finite presentation + verifier + preflight_p25z2
2. `tmp/p25z1_build/` / `tmp/p25z1_probe/` — optional local RREF cache only (not required in git)

---

**Problem E remains OPEN.**  An empty degree-25 scheme (if obtained in P25Z.2) is a
degree-25 exclusion only.
