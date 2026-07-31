# P25Y.1 — Fixed DVR coefficient model of \(V_{25}\) at \(p = 89\)

**Headline: OPEN.**

**Exit:** see `dvr_certificate.json` (`P25Y-DVR-PASS` / `P25Y-DVR-FAIL`).

---

## 0. Object

Work over the cyclotomic field

\[
K = \mathbf Q(\zeta_{11}),
\]

and the discrete valuation ring

\[
\mathcal O = \mathcal O_{K,\mathfrak p},
\qquad
\mathfrak p = (p,\zeta_{11}-\zeta),\quad p=89,\ \zeta=78,
\]

with residue field \(\mathbf F_{89}\). Holdouts: \(p\in\{199,353\}\).

The strict degree-\(25\) covariant space \(V_{25}\) is the kernel of the
common-line order-\(2\) map on the arrangement kernel inside the Reynolds
module \(M_{25}\) of dimension \(189\). Exact Molien dimensions (trusted):

\[
\dim M_{25}=189,\quad
\dim\mathrm{Arr}=59,\quad
\dim V_{25}=43=37+6.
\]

---

## 1. Integral circuit (not an entrywise global \(K\)-matrix)

The model is the **canonical Reynolds/nullspace circuit** of `P25X0-PASS`
(`certificates/degree25_exact/COEFFICIENT_MODEL.md` §2), executed as an
\(\mathcal O\)-linear construction:

1. **Group and Reynolds lattice.** The Klein representation matrices \(S,T\)
   of `exact_weil_check.py` lie in \(\mathrm{Mat}_5(K)\) with denominators
   dividing \(11\) (from \((-\gamma)/11\), \(\gamma^2=-11\)). The group
   \(\mathrm{PSL}(2,11)\) has order \(660=2^2\cdot 3\cdot 5\cdot 11\). At
   \(\mathfrak p\mid 89\) one has \(p\nmid 660\) and \(p\neq 11\), so
   \(1/660\), \(1/11\), and \(\gamma^{-1}\) are units in \(\mathcal O\).
   Reynolds seeds are the sealed monomial generators of
   `tmp/degree25_structural_probe/seeds.json` (189 seeds). After Reynolds
   averaging, the seed lattice is free of rank \(189\) over \(\mathcal O\)
   (special-fibre rank \(189\) on the monic pivot block).

2. **Arrangement evaluation.** Fix the involution eigenbasis of a
   commuting involution pair (joint \(D_{12}\) chart). On the plus
   \(3\)-plane, evaluate the \(189\) seeds on the triangular integral grid
   of \(351\) points \(\{u+ a v+ b w: a+b\le 25\}\). This yields an
   \(\mathcal O\)-linear map
   \[
   \varphi\colon \mathcal O^{189}\to \mathcal O^{1755}.
   \]

3. **Strict restriction.** On \(\ker\varphi\), form the common-line
   order-\(2\) map \(\psi\) (three chart directions, Vandermonde
   coefficient extraction at order \(2\)). Then
   \[
   V_{25}^{\mathcal O} := \ker\psi \subset \ker\varphi.
   \]

4. **Monic basis-lift.** Row-reduce a free generating set of
   \(V_{25}^{\mathcal O}\) in Reynolds coordinates to monic RREF. Pivot
   columns are \(0,\ldots,42\) with leading minor \(1\).

5. **Restriction map.** \(\rho_{\le 25}\) is the block sum of free jets
   of orders \(r=1,\ldots,25\) along the minus line: shape \(868\times 43\).

An entrywise global matrix over \(K\) is **not** claimed. A fixed DVR
basis-lift with unit pivots **is** claimed.

---

## 2. Unit pivot minors (decision fibre \(p=89\))

| Map | Shape (special fibre) | Rank | Unit minor \(\det\bmod 89\) |
|-----|----------------------:|-----:|----------------------------:|
| arrangement \(\varphi\) | \(1755\times 189\) | \(130\) | nonzero (see certificate) |
| order-\(2\) \(\psi\) | \(72\times 59\) | \(16\) | nonzero |
| monic left block of basis | \(43\times 43\) | \(43\) | \(1\) |

Nonzero residue determinant \(\Leftrightarrow\) unit in \(\mathcal O^\times\).

**Local freeness.** A map \(f\colon \mathcal O^n\to\mathcal O^m\) of constant
rank \(r\) admitting a unit \(r\times r\) minor is split-surjective onto a
free direct summand of rank \(r\); its kernel is free of rank \(n-r\).
Applying this to \(\varphi\) and then to \(\psi\) yields

\[
V_{25}^{\mathcal O}\ \text{free of rank }43\text{ over }\mathcal O.
\]

The monic RREF with unit pivots is the unique monic \(\mathcal O\)-basis
reducing to the stored \(\mathbf F_{89}\) monic basis (same circuit as
`P25X0`, hash-matched in `dvr_certificate.json`).

Holdouts \(p=199,353\) reproduce unit-pivot bundles and monic pivots
\(0..42\) (structural compatibility; decision fibre remains \(p=89\)).

---

## 3. Denominator / unit ledger

| Element | Role | Unit at \(\mathfrak p\mid 89\)? |
|---------|------|:--:|
| \(1/660\) | Reynolds factor | yes (\(89\nmid 660\)) |
| \(1/11\) | Weil matrix \(S\) | yes |
| \(\gamma^{-1}\) | \(\gamma^2=-11\) in \(S\) | yes (residue \(\neq 0\)) |
| Vandermonde \(0..25\) | jet / order-\(2\) samples | yes (\(p>25\)) |

No further denominators enter the seed lattice, the \(\mathbf Z\)-grid in the
plus chart, or the monic RREF (pivots already units).

---

## 4. Properness argument (why emptiness at \(p=89\) would lift)

Hypotheses, all supported by this certificate when `P25Y-DVR-PASS`:

1. **Integral model of the coefficient space.** \(V_{25}^{\mathcal O}\) is
   free of rank \(43\) over \(\mathcal O\), so
   \(\mathbf P(V_{25}^{\mathcal O})\cong \mathbf P^{42}_{\mathcal O}\) is
   proper over \(\operatorname{Spec}\mathcal O\).

2. **Integral landing ideal.** For \(c\in \mathcal O^{43}\) and
   \(p_c=\sum c_i p_i\) with \(\{p_i\}\) the monic \(\mathcal O\)-basis,
   the coefficients of \(F(p_c(x))\) as a form in \(x\) are homogeneous
   cubics in \(c\) with coefficients in \(\mathcal O\). They define a
   closed subscheme
   \[
   Z\subset \mathbf P^{42}_{\mathcal O}
   \]
   (the full projective landing scheme over the DVR).

3. **Special-fibre equations.** Any cubic form obtained by evaluating
   \(F(p_c(-))\) at an integral source point \(\tilde x\in\mathcal O^5\)
   is an \(\mathcal O\)-section of the landing ideal; its reduction
   mod \(\mathfrak p\) is the corresponding \(\mathbf F_p\)-row used in
   P25Y.2. A subsystem \(J_N\) of such reductions cuts out a closed
   subscheme containing the special fibre of \(Z\).

**Properness.** The structure morphism \(Z\to\operatorname{Spec}\mathcal O\)
is proper (closed immersion into a projective \(\mathcal O\)-scheme).
The image is closed in \(\operatorname{Spec}\mathcal O\), which has two
points (generic and closed). If the generic fibre were nonempty, the
image would contain the generic point, hence equal all of
\(\operatorname{Spec}\mathcal O\), hence contain the closed point: the
special fibre would be nonempty. Contrapositive:

\[
\boxed{\text{special fibre empty}\ \Longrightarrow\ \text{generic fibre empty.}}
\]

If a **subsystem** of special-fibre equations already has empty projective
zero locus, then the full special fibre of \(Z\) is empty, and the same
implication yields emptiness of the generic fibre of \(Z\).

### Weakest hypothesis

The weakest link is **(2)–(3) jointly**: one must know that the computed
rows are reductions of **global** coefficient sections of \(F(p_c(x))\),
not merely of a different modular basis. This packet ties rows to the
**same monic DVR basis-lift** as Y.1 (hash-locked to the decision fibre),
and records the integral-section argument in `rank_growth.json`. What is
*not* claimed: that a sampled subsystem equals the full cubic coefficient
ideal (rank is a lower bound only).

Without Y.1, emptiness at \(p=89\) would be a single prime’s accident and
would **not** imply a characteristic-zero exclusion.

---

## 5. What is proved / not proved

**Proved (on `P25Y-DVR-PASS`):** fixed free rank-\(43\) model of \(V_{25}\)
over \(\mathcal O_{K,\mathfrak p}\) at \(p=89\); unit pivots; monic
basis-lift circuit reducing to the stored \(\mathbf F_{89}\) basis;
integral \(\rho_{\le 25}\) circuit; denominator ledger; properness
hypotheses for the projective landing scheme over \(\operatorname{Spec}\mathcal O\).

**Not proved:** entrywise \(K\)-matrix of the basis; emptiness or
nonemptiness of the landing scheme; any covariant; any use of the
quarantined rank-\(842\) / border packets as the landing ideal.

**Headline remains OPEN.**
