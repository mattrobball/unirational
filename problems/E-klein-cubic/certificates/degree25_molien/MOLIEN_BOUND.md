# P25Y-M — Exact Molien bound for the degree-25 landing row space

**Headline: OPEN.**

**Exit fields:** see `molien_values.json`.

**Decisive value:**

\[
m_{75}
=
\dim\bigl(\mathrm{Sym}^{75} W^\vee\bigr)^{G}
=
2343.
\]

**Seal status:** `P25Y-FULL-ROWSPACE-746` is **NOT sealed**, because \(746\neq 2343\).
The historical 842-row packet remains quarantined under work order §1.2.6 (unaffected).

---

## 0. Why \(m_{75}\) bounds the landing row rank

Each basis element \(p_i\) of the strict space \(V_{25}\) is a degree-25
**covariant**: a \(G\)-equivariant polynomial map \(W\to W\). For
\(c\in V_{25}\) write \(p_c=\sum_i c_i p_i\). Equivariance gives
\(p_c(gx)=g\cdot p_c(x)\). The Klein cubic \(F\) is \(G\)-invariant, so the
degree-75 form

\[
x\;\longmapsto\; F\bigl(p_c(x)\bigr)
\]

is \(G\)-**invariant**. The cubic map \(c\mapsto F(p_c(\cdot))\) linearises to

\[
\Lambda\colon \mathrm{Sym}^3(V_{25})\;\longrightarrow\;
\bigl(\mathrm{Sym}^{75} W^\vee\bigr)^{G}.
\]

Evaluation rows at source points \(x_j\) span the image of the transpose.
Therefore

\[
\mathrm{rank}(\text{row space})
=
\mathrm{rank}(\Lambda)
\le
\min\bigl(\dim\mathrm{Sym}^3(V_{25}),\, m_{75}\bigr)
=
\min(14190,\,2343)
=
2343.
\]

### What this does **not** prove

- The observed \(\mathbf F_{89}\)-rank \(746\) is a **lower bound only**
  (house rule 8). The Molien upper bound \(2343\) does **not** force \(746\)
  to be the full span.
- Both \(746\) and the quarantined historical \(842\) lie strictly below
  \(2343\), so the bound does not separate them.
- \(m_{75}=2343\neq 746\), so the owner-suggested seal
  `P25Y-FULL-ROWSPACE-746` does **not** fire, and the 842-row packet is
  **not** quarantined on this basis.

---

## 1. Three independent computations of \(m_{75}\)

| Method | \(m_3\) | \(m_{25}\) | \(m_{43}\) | \(m_{75}\) |
|--------|--------:|----------:|----------:|----------:|
| GAP `MolienSeries` on a degree-5 irrep of \(L_2(11)\) (director) | 1 | 43 | 289 | **2343** |
| Eigenvalue reconstruction by inverse DFT from class data + power maps, complete-homogeneous expansion (director) | 1 | 43 | 289 | **2343** |
| **This packet:** group-sum over the project's 660 exact \(5\times 5\) matrices (modular Newton/CRT at four split primes; verifier uses complex eigenvalue product) | 1 | 43 | 289 | **2343** |

Validations that the setup is the project's:

- \(m_3=1\): the Klein cubic is the unique invariant cubic.
- \(m_{25}=43\): matches the sealed \(\dim V_{25}=43\) **numerically** (see §3).
- \(\dim\mathrm{Sym}^{75}(\mathbf C^5)=\binom{79}{4}=1502501\), and
  \(1502501/660\approx 2276.5\), so \(2343\) is the right order of magnitude.

### Method details (this packet)

**Producer** (`produce_molien.py`):

1. Load the project's modular realisation of \(W\) at each split prime
   \(p\in\{89,199,331,353\}\) (\(p\equiv 1\pmod{11}\), \(p>75\), \(p\nmid 660\))
   via the sealed \(S,T\) generators and Cayley graph of order \(660\).
2. For each of the \(660\) matrices \(g\), compute power traces
   \(\mathrm{tr}(g^k)\) and convert to the complete-homogeneous series
   \(h(t)=1/\det(I-tg)\) by Newton identities
   \(n\,h_n=\sum_{k=1}^n \mathrm{tr}(g^k)\,h_{n-k}\).
3. Average with \(1/660\) over the group; CRT-reconstruct the integer series.

**Verifier** (`verify_molien.py`) — does **not** import the producer:

1. Embed the exact cyclotomic generators of `exact_weil_check.py` into
   \(\mathbf C\) via \(\zeta_{11}=\exp(2\pi i/11)\).
2. Enumerate the Cayley graph independently; expand
   \(1/\det(I-tg)=\prod_j(1-\lambda_j t)^{-1}\) from eigenvalues in floating
   complex arithmetic; average and round (max residual \(\sim 10^{-11}\)).
3. Recompute the special-fibre residues at \(p=89\) by an independently coded
   modular group sum; check \(m_d\bmod 89\).

Agreement on \(m_{75}=2343\) is the decisive check. A verifier that merely
read \(2343\) from JSON would have verified nothing; this one recomputes it.

---

## 2. Special fibre at \(p=89\)

Because \(89\nmid 660\), the Reynolds operator
\(\frac1{|G|}\sum_g g\) is defined over \(\mathbf F_{89}\) and projects onto
the space of invariants with the **same dimension** as in characteristic zero.
The modular group-sum at \(p=89\) therefore yields

\[
\dim\bigl(\mathrm{Sym}^{75} W^\vee\bigr)^{G}_{\mathbf F_{89}}
=
m_{75}
=
2343.
\]

(Residually: \(2343\equiv 29\pmod{89}\), matching the direct modular sum.)

The Molien bound is therefore available for the DVR model of P25Y.1, not only
in characteristic zero.

---

## 3. \(W\) versus \(W^\vee\); both degree-5 irreps

PSL\((2,11)\) has two degree-5 irreducibles, Galois conjugates over
\(\mathbf Q(\sqrt{-11})\). Duality interchanges \(W\) and \(W^\vee\), and
Galois conjugation preserves integer invariant dimensions. Explicitly, the
substitution \(g\mapsto g^{-1}\) reindexes the Molien sum without changing
the average. Hence

\[
\dim\bigl(\mathrm{Sym}^{d} W^\vee\bigr)^{G}
=
\dim\bigl(\mathrm{Sym}^{d} W\bigr)^{G}
\]

for every \(d\), and both degree-5 irreps give the same \(m_d\). The
\(W\) vs \(W^\vee\) distinction does **not** change \(m_{75}\).

The third method uses the project's **actual** matrices, so it also certifies
that the project's \(W\) is one of these two irreducibles (matching
\(m_3=1\), \(m_{25}=43\), \(m_{75}=2343\)).

---

## 4. Self-covariants and the project filtration

Alongside the invariant series the producer records the self-covariant
dimensions

\[
c_d
=
\dim\mathrm{Hom}_G(\mathrm{Sym}^{d} W,\,W)
=
\frac1{|G|}\sum_g \chi(g^{-1})\,[t^d]\,\frac1{\det(I-tg)}.
\]

| \(d\) | \(c_d\) (self-covariants) | \(m_d\) (invariants) | project object |
|------:|--------------------------:|---------------------:|----------------|
| 1 | 1 | 0 | — |
| 3 | 0 | 1 | Klein cubic \(F\) |
| 25 | **189** | **43** | \(M_{25}\) / \(V_{25}\) |
| 75 | 11440 | **2343** | row-rank bound |

In particular \(c_{25}=189=\dim M_{25}\): the project's Reynolds module
\(M_{25}\) is the **full** self-covariant space of degree 25.

---

## 5. Audit: \(V_{25}\) is not the space of degree-25 invariants

### Determination

| Object | Type | Dimension |
|--------|------|----------:|
| \((\mathrm{Sym}^{25} W^\vee)^G\) | degree-25 **invariants** (scalar forms) | \(m_{25}=43\) |
| \(M_{25}=\mathrm{Hom}_G(\mathrm{Sym}^{25} W,W)\) | degree-25 **self-covariants** (maps \(W\to W\)) | \(c_{25}=189\) |
| \(\mathrm{Arr}\subset M_{25}\) | arrangement kernel (plus-plane evaluation) | 59 |
| \(V_{25}=\ker(\text{order-2 common-line})\subset\mathrm{Arr}\) | strict **covariant** space | 43 |

**Verdict: equal dimension only — not the same object.**

\(V_{25}\) is a \(43\)-dimensional subspace of the self-covariant module
\(M_{25}\), cut out by the arrangement and strict-order-2 conditions. The
space of degree-25 invariants is a completely different representation
(scalar forms, not maps \(W\to W\)). The numerical equality
\(\dim V_{25}=m_{25}=43\) is a coincidence of dimensions, not an
identification.

### Implication for the P25Y.1 constant-rank citation

`certificates/degree25_direct_support/DVR_MODEL.md` §0 lists

\[
\dim M_{25}=189,\quad \dim\mathrm{Arr}=59,\quad \dim V_{25}=43
\]

as “Exact Molien dimensions,” and §2 discharges constant rank via
\(189-59=130\) and \(59-43=16\).

| Claimed as Molien | Actual status |
|-------------------|---------------|
| \(\dim M_{25}=189\) | **Correct Molien:** \(c_{25}=189\). |
| \(\dim\mathrm{Arr}=59\) | **Construction dimension** of the arrangement kernel inside \(M_{25}\); not a pure Molien number. Trusted by work order §1.1 items 5–6 and multiprime realisation. |
| \(\dim V_{25}=43\) | **Construction dimension** of the strict kernel; equals the **invariant** Molien \(m_{25}\) only numerically. Trusted as a filtration dimension, not as “the” degree-25 invariant space. |

**Citation repair (this packet; sealed P25Y.1 left byte-identical):**

- The constant-rank freeness argument remains **valid** when it invokes the
  trusted construction dimensions \(189,59,43\) (special-fibre ranks and unit
  minors are independently certified in `dvr_certificate.json`).
- It is **mislabelled** to call \(\mathrm{Arr}\) and \(V_{25}\) “Molien
  dimensions.” Only \(M_{25}=189\) is a pure Molien self-covariant
  coefficient among the three.
- Substituting the invariant Molien \(m_{25}\) *by name* for \(\dim V_{25}\)
  would be a type error (invariants vs strict covariants), even though the
  integers agree.
- **Exit impact:** `P25Y-DVR-PASS` is not overturned. No edit is made to the
  sealed packet; this section is the correction record beside it
  (director handoff §5.3).

---

## 6. What is proved / not proved

**Proved:**

- \(m_{75}=2343\) by an independent third method (project matrix group-sum),
  agreeing with two director methods.
- Special-fibre invariant dimension at \(p=89\) equals \(2343\).
- Both degree-5 irreps / \(W\) vs \(W^\vee\) give the same \(m_d\).
- Row-rank upper bound \(\le 2343=\min(14190,m_{75})\).
- \(V_{25}\) and degree-25 invariants are equal in dimension only.
- `P25Y-FULL-ROWSPACE-746` does **not** seal.

**Not proved:**

- That the observed rank \(746\) is the full row span.
- Emptiness or nonemptiness of the landing scheme.
- Any covariant.
- Any change to the quarantined 842-row / rank-28 border status beyond the
  reasons already in work order §1.2.6.

**Headline remains OPEN.**
