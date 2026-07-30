# Implication audit — Attempt 3, Gate 1 (3B)

**Date:** 2026-07-30  
**Base:** `b7be961` (work-order pin / director gate); working tree may sit later  
**Packet:** `certificates/schur_degree19/`  
**Headline:** OPEN  
**Gate 1 decision:** `PASS` (implication holds under the explicit hypotheses below)

---

## 0. Executive verdict

The claimed positive chain

```text
qualifying degree-19 curve
  ==> residual degree-2 zero-cycle
  ==> K-point on the cubic
  ==> G-unirationality of X
```

is audited with no omitted arrows.  Each arrow records the five required
attributes: field of definition; intersection multiplicities; purity /
geometric-integrality hypotheses; the quadratic-descent (residual-line)
step; possible boundary components.

**House rule 10 is binding and is checked explicitly in §4.**  A degree-2
zero-cycle yields a ground-field point on the cubic only after the residual
line is formed **over the correct field** and is proved not to lie on the
cubic (or the support already contains a ground-field point).  The Schur
route passes this check.  This is the opposite of Attempt 1 Gate 1, where
the first arrow failed because the abstract object lived on an auxiliary
space; here the source object is already a curve on the twisted ambient of
the cubic.

**Field discipline (do not conflate).**  The residual construction produces a
point of the **generic Schur twist** over

\[
F \;:=\; K_{\mathrm{Schur}} \;=\; \mathbf C\!\bigl(\mathbf P(V_6)\bigr)^G,
\]

not an a-priori written point of the generic Klein twist over
\(K_{\mathrm{proj}}=\mathbf C(\mathbf P(W))^G\).  Headline conversion uses
the accepted projective-source + quadratic-descent package and the
Tschinkel–Zhang / Prokhorov equivalence
\(X\) is \(G\)-unirational \(\Leftrightarrow\operatorname{ed}_{\mathbf C}(G)=3\).
The work-order phrase “\(K_{\mathrm{proj}}\)-point” is therefore understood
as the headline consequence, not as an identification of the two fields.

**Gate 1 decision: `PASS`.**  Proceed to Gate 2 (3C).  No qualifying curve
is constructed in this packet; only the implication is certified.

---

## 1. Notation and accepted inputs

| Symbol | Meaning |
|---|---|
| \(G=\operatorname{PSL}_2(\mathbf F_{11})\) | order 660 |
| \(W\) | honest irreducible 5-dimensional Klein representation |
| \(X=V(f_3)\subset\mathbf P(W)\) | Klein cubic, \(f_3=\sum x_i^2 x_{i+1}\) |
| \(V_6\) | Schur representation of \(\widetilde G=\operatorname{SL}_2(\mathbf F_{11})\) |
| \(F=K_{\mathrm{Schur}}=\mathbf C(\mathbf P(V_6))^G\) | generic Schur invariant field |
| \(T/F\) | generic free-locus \(G\)-torsor of \(\mathbf P(V_6)\) |
| \(X_T={}^T X\) | generic Schur twist (cubic threefold over \(F\)) |
| \(\mathbf P(W_T)\) | twisted ambient \(\mathbf P^4_F\) (split: \(W\) is honest) |
| \(\ell\subset X\) | certified \(D_{12}\)-stable line on the split model |
| \(Z_{55}\) | degree-55 closed point of \(X_T\) obtained by twisting the orbit \(G\cdot\ell\) |
| \(B\subset\mathbf P(W_T)\) | candidate pure curve of degree 19 over \(F\) |

Accepted upstream facts (not re-derived; scope as in their packets):

1. Maximal \(D_{12}\) stabilizes an honest line on \(X\); twisting yields the
   exact degree-55 closed point \(Z_{55}\) on \(X_T\)
   (`tmp/schur_unrestricted_point_attack`, `tmp/schur_degree19_structural_design`).
2. Every qualifying pure degree-19 curve through a line-orbit point with the
   certified maximal geometric semilinear \(D_{12}\) stabilizer is
   geometrically integral
   (`tmp/schur_degree19_structural_design`, component theorem).
3. \(X_T\) has no \(F\)-rational line and no \(F\)-rational plane conic
   (`tmp/schur_structural_routes`).
4. A rational \(G\)-map \(\mathbf P(V_6)\dashrightarrow X\) solves the
   headline by the projective-source and quadratic-descent lemmas
   (`SPEC.md`, `RESOLUTION.md`); equivalently
   \(X_T(F)\neq\varnothing\) is headline-positive.
5. Index one of \(X_T\) is already known (degree-55 point + degree-three
   linear section); index one alone is not a point.

---

## 2. Definition: qualifying degree-19 curve

A pure 1-dimensional closed subscheme \(B\subset\mathbf P(W_T)\) defined
over \(F\) is **qualifying** if all of the following hold.

| # | Hypothesis | Role |
|---|---|---|
| Q1 | \(\deg B=19\) | Bézout budget \(3\cdot 19=57\) |
| Q2 | \(B\) is pure of dimension 1 (no embedded points needed for the cycle class) | purity of the intersection cycle |
| Q3 | no irreducible component of \(B_{\overline F}\) lies in \(X_T\) | properness / no excess component |
| Q4 | \(B\cap X_T\) is 0-dimensional (automatic from Q3 + hypersurface) | proper intersection |
| Q5 | the support of \(Z_{55}\) lies in \(B\cap X_T\), and at every geometric point of the orbit the local intersection multiplicity is exactly 1 | marks the 55 points and fixes residual length |
| Q6 | (forced) \(B\) is geometrically integral of degree 19 | component theorem from maximality of \(D_{12}\) + mult-one + Bézout |

Q6 is not an independent design choice: under Q1–Q5 and maximality of
\(D_{12}\), the structural component theorem already forces geometric
integrality (`tmp/schur_degree19_structural_design` §2).  It is recorded as
a hypothesis of the residual arithmetic so the chain does not silently use
it.

**Non-claims of the definition.**  Qualifying does **not** require: ACM;
smoothness; rationality; containment in a hyperplane; a quintic carrier;
or any Rao bound.  Those enter only in Gate 2.

---

## 3. Arrow 1 — qualifying curve \(\Rightarrow\) residual degree-2 zero-cycle

### Statement

Let \(B\) be qualifying.  Write \(I(B,X_T)\) for the 0-cycle of intersection
of \(B\) with the Cartier divisor \(X_T\subset\mathbf P(W_T)\).  Then

\[
\deg I(B,X_T)=57,
\qquad
R \;:=\; I(B,X_T)-Z_{55}
\]

is an effective 0-cycle of degree 2 on \(X_T\), defined over \(F\).

### Five attributes

| Attribute | Record |
|---|---|
| **Field of definition** | \(B\), \(X_T\), and \(Z_{55}\) are defined over \(F\).  Intersection and difference of cycles are therefore \(F\)-cycles.  No extension of scalars is used. |
| **Intersection multiplicities** | Hypersurface Bézout: a pure curve of degree 19 not contained in a cubic hypersurface meets it in a 0-cycle of degree \(3\cdot 19=57\).  Q5 assigns multiplicity exactly 1 to each of the 55 geometric points of \(Z_{55}\), so those points contribute length 55.  Residual length \(57-55=2\). |
| **Purity / geometric integrality** | Q2–Q4 give a pure 0-dimensional intersection cycle (no curve components in \(X_T\)).  Q6 (geometric integrality of \(B\)) is used only to exclude pathological multi-component bookkeeping already ruled out by the component theorem; Bézout itself needs purity and non-containment, not integrality. |
| **Quadratic descent step** | Not used in Arrow 1.  Arrow 1 produces a degree-2 cycle, not a point. |
| **Possible boundary components** | (i) A component of \(B\) contained in \(X_T\) would make the intersection non-proper — excluded by Q3.  (ii) Multiplicity \(\ge 2\) at a marked orbit point would reduce residual length below 2 or force residual to absorb excess — excluded by Q5.  (iii) An embedded 0-dimensional component of \(B\) supported off \(X_T\) does not meet \(X_T\) and does not change the intersection cycle of the pure 1-dimensional part; the definition requires purity (Q2).  (iv) Non-reduced structure of \(B\) along a 1-dimensional component would change the degree of \(B\); degree is read in the cycle class, so Q1 uses the cycle degree 19. |

### Verdict

**Arrow 1 holds** under Q1–Q5 (with Q6 free from the component theorem).

---

## 4. Arrow 2 — residual degree-2 zero-cycle \(\Rightarrow\) \(F\)-point on \(X_T\)

### Statement (house rule 10)

Let \(R\) be an effective 0-cycle of degree 2 on the smooth cubic threefold
\(X_T\), defined over \(F\).  Then \(X_T(F)\neq\varnothing\).

### Classification of degree-2 zero-cycles over \(F\)

Any effective 0-cycle of degree 2 over a field of characteristic zero is
one of:

| Type | Scheme | Support over \(F\) |
|---|---|---|
| (T1) | two distinct \(F\)-points | already \(F\)-rational points |
| (T2) | non-reduced length-2 point \(\operatorname{Spec} F[\varepsilon]/(\varepsilon^2)\) | unique reduced support is an \(F\)-point |
| (T3) | one closed point of residue degree 2 (or a Galois conjugate pair) | support is a quadratic closed point |

There is no other length-2 Artinian \(F\)-algebra up to isomorphism: residue
field either \(F\) (reduced or dual numbers) or a quadratic extension
(reduced).

### Residual-line construction (types T1–T3)

- **(T1), (T2).**  The support already contains an \(F\)-point of \(X_T\).
  No residual line is required.  House rule 10 is satisfied because the
  point is read from the support over \(F\), not from an auxiliary degree-2
  divisor on a curve over a wrong field.

- **(T3).**  Let \(p,\overline p\) be the two geometric points of the
  closed point, conjugate under \(\mathrm{Gal}(\overline F/F)\).  They span
  a unique line \(L\subset\mathbf P(W_T)\).  The line \(L\) is Galois-stable,
  hence defined over \(F\).  Restrict the cubic equation to \(L\simeq
  \mathbf P^1_F\): one obtains a binary cubic form over \(F\), i.e. a
  degree-3 effective 0-cycle \(I(L,X_T)\) on \(L\).

  **Claim.**  \(L\not\subset X_T\).  Indeed, an \(F\)-line on \(X_T\) is
  forbidden by the accepted no-rational-line theorem for the generic Schur
  twist (`tmp/schur_structural_routes` §3).  Therefore \(I(L,X_T)\) is a
  genuine 0-cycle of degree 3 on \(L\).

  The two geometric points \(p,\overline p\) appear in \(I(L,X_T)\).  Their
  residual

  \[
  q \;:=\; I(L,X_T) - (p+\overline p)
  \]

  is an effective 0-cycle of degree 1 on \(L\), defined over \(F\) (both
  \(I(L,X_T)\) and \(p+\overline p=R\) are \(F\)-cycles).  A degree-1
  effective 0-cycle over \(F\) is an \(F\)-point.  Moreover \(q\in X_T(F)\).

### Five attributes for Arrow 2

| Attribute | Record |
|---|---|
| **Field of definition** | All of \(R\), \(L\), \(I(L,X_T)\), and \(q\) are formed over \(F=K_{\mathrm{Schur}}\).  No base change to a residue field of \(Z_{55}\), to \(K_{\mathrm{proj}}\), or to a finite field is used.  **House rule 10 check:** the residual line is the \(F\)-span of the support of \(R\); a degree-2 cycle produced only after extending scalars to a field where the 55 points split would **not** be an \(F\)-cycle and is **not** claimed to give an \(F\)-point. |
| **Intersection multiplicities** | On \(L\), \(\deg I(L,X_T)=3\) because \(L\not\subset X_T\).  In type (T3) the two geometric residual points each contribute multiplicity one to \(R\) as a cycle on \(X_T\) when \(R\) is reduced; if \(R\) is non-reduced of type (T2) the residual-line step is not invoked.  If the binary cubic has a multiple root at the residual support, the degree-1 residual \(q\) may coincide with that support only in degenerate configurations already covered by (T1)/(T2). |
| **Purity / geometric integrality** | \(X_T\) is smooth (twist of a smooth cubic).  \(L\) is a line (geometrically integral).  No purity hypothesis on \(B\) is re-used beyond Arrow 1 having already produced a pure 0-cycle \(R\). |
| **Quadratic descent step** | Exactly the residual third intersection of the \(F\)-line through a quadratic closed point of a cubic hypersurface.  This is the classical “quadratic point on a cubic \(\Rightarrow\) rational point” construction.  It is **not** Springer’s theorem, **not** a Brauer–Manin argument, and **not** a claim that every degree-2 divisor class is rational. |
| **Possible boundary components** | (B1) \(L\subset X_T\): excluded for the generic Schur twist by the no-\(F\)-line theorem.  (If one worked on a special twist that **did** contain an \(F\)-line, type (T3) would fail to produce a new point — the whole line would be residual — but type (T1) would already have points if the residual points were \(F\)-rational; the present chain is scoped to \(X_T\).)  (B2) Residual \(q\) lands on a singular point: impossible, \(X_T\) smooth.  (B3) Residual \(R\) is not effective: excluded by Arrow 1.  (B4) Conflation of \(R\) with a degree-2 divisor on the **curve** \(B\) that is not the intersection cycle with \(X_T\): such a divisor is **not** an input to Arrow 2; only the intersection residual is.  (B5) Using a degree-2 cycle over the residue field of \(Z_{55}\) (degree 55) and claiming an \(F\)-point: **forbidden by house rule 10**; not used. |

### Explicit house-rule-10 checklist

```text
[x] R is defined over F (not over Fbar only, not over k(Z_55))
[x] for type (T3), the joining line L is defined over F
[x] L is proved not contained in X_T over F (no-line theorem)
[x] the degree-1 residual q is formed over F
[x] no positive claim is made from a degree-2 cycle on an auxiliary variety
[x] Attempt-1-style scope error avoided: R lives on X_T, not on P^2_D
```

### Verdict

**Arrow 2 holds** for the generic Schur twist over \(F\).

---

## 5. Arrow 3 — \(F\)-point on \(X_T\) \(\Rightarrow\) headline

### Statement

\[
X_T(F)\neq\varnothing
\quad\Longrightarrow\quad
\text{\(X\) is \(G\)-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3
\quad\Longleftrightarrow\quad
\text{generic Klein twist has a \(K_{\mathrm{proj}}\)-point}.
\]

### Five attributes

| Attribute | Record |
|---|---|
| **Field of definition** | Source: \(X_T(F)\).  Target headline is field-independent (property of the \(G\)-variety \(X/\mathbf C\)).  The intermediate map is a rational \(G\)-map \(\mathbf P(V_6)\dashrightarrow X\) defined over \(\mathbf C\). |
| **Intersection multiplicities** | Not applicable (no residual intersection in this arrow). |
| **Purity / geometric integrality** | Twisting adjunction identifies \(X_T(F)\) with rational \(G\)-maps from the free locus of \(\mathbf P(V_6)\) to \(X\).  Dominance of any nonconstant such map follows from simplicity of \(G\) and irreducibility of \(W\) (accepted projective-source package). |
| **Quadratic descent step** | Used **once more**, at the level of essential dimension: the Schur projective source is not weakly versal, but every twisted source has Brauer index at most 2, and a quadratic point of a cubic descends by third intersection.  This is the accepted reason a map from \(\mathbf P(V_6)\) is headline-sufficient (`SPEC.md` pitfalls; `RESOLUTION.md`).  It is **not** a second residual-line argument on \(R\). |
| **Possible boundary components** | (i) A point of an **auxiliary** open (e.g. Morita \(\mathbf P^2_D\)) is not an \(X_T(F)\)-point — that was Attempt 1’s FAIL-SCOPE; it does not apply here.  (ii) A point of a proper closed subtwist or of a special fibre is not \(X_T(F)\).  (iii) \(\delta(T_{\mathrm{Schur}})=0\) (Schur boundary vanishes) is compatible with, but not a substitute for, an actual point. |

### Verdict

**Arrow 3 holds** by the accepted projective-source + quadratic-descent +
ed-equivalence package.  Theorem boundary: this packet does not re-prove
that package; it cites it as an accepted input (§1).

---

## 6. Composite chain and exact theorem boundary

### Composite

```text
qualifying B over F
  --Arrow1-->  residual F-cycle R of degree 2 on X_T
  --Arrow2-->  X_T(F) ≠ ∅
  --Arrow3-->  X is G-unirational  (headline positive; ed_C(G)=3)
```

### What this does **not** prove

1. Existence of a qualifying \(B\).  Gate 2 addresses the two surviving Rao
   branches; this audit only certifies the implication.
2. That every degree-19 curve through \(Z_{55}\) is qualifying — mult-one
   and purity must still be checked for any constructed candidate.
3. An explicit point of the generic Klein twist over \(K_{\mathrm{proj}}\)
   written in \(K_{\mathrm{proj}}\)-coordinates.  Arrow 3 converts through
   ed-equivalence.
4. Anything about boundary-zero pointless torsors (negative subroute 3D).
5. Exclusion or construction in either Rao branch.

### Comparison with Attempt 1 FAIL-SCOPE

| | Attempt 1 Arrow A | Attempt 3 Arrows 1–2 |
|---|---|---|
| Source object | abstract \(\sigma\)-self-adjoint rank-2 idempotent | pure curve \(B\) on \(\mathbf P(W_T)\) |
| Lives on | open in rational \(\mathbf P^2_D\) (auxiliary) | the twisted ambient of \(X_T\) |
| Target | common isotropic line / Fano section | residual 0-cycle on \(X_T\) itself |
| Break? | yes — scope | no — residual is on \(X_T\) |
| House rule | rule 1 (no headline from auxiliary point) | rule 10 (residual line over correct field) |

---

## 7. Gate 1 decision

| Item | Result |
|---|---|
| Arrow 1 | PASS under Q1–Q5 |
| Arrow 2 | PASS with house rule 10 checklist complete |
| Arrow 3 | PASS by accepted source/descent/ed package |
| Qualifying curve constructed? | **no** (Gate 2) |
| Headline | **OPEN** |
| **Gate 1** | **`PASS`** — authorize Gate 2 (3C) |

Terminal marker:

```text
SCHUR_DEGREE19_GATE1_IMPLICATION_PASS
```
