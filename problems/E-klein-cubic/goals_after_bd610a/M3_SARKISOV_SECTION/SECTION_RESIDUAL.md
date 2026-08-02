# Residual section alternative after the sealed multisection

**Packet exit (unchanged):** `M3-INTEGRAL-DEGREE4-MULTISECTION`  
**Section question:** `UNDECIDED`  
**Headline:** `OPEN`  
**Field:** \(K=K_{\mathrm{Schur}}=\mathbf C(\mathbf P(V_6))^{\mathrm{PSL}_2(\mathbf F_{11})}\)

This note isolates what remains after the integral degree-four multisection is
already sealed.  It does **not** re-prove multisection existence, does not
claim a \(K_{\mathrm{Schur}}\)-point, and does not execute a versality bridge.

## 1. What the sealed multisection already selects

M2 supplies the exact type-I link and the alternative

\[
\text{rational section of }Y/\mathbf P^1_K
\quad\text{or}\quad
\text{integral finite-flat degree-four multisection}.
\]

M3 seals the second branch **unconditionally**: both the section branch and
the no-section branch produce an integral degree-four multisection (Voisin in
the empty-point branch; cyclic quartic plus Weil restriction of Kollár
unirationality in the nonempty-point branch).  See `DEGREE4.md` and
`QUARTIC_MULTISECTIONS.md`.

Consequently:

- emptiness of the integral quartic locus **cannot** force a section;
- the structural exit `M3-INTEGRAL-DEGREE4-MULTISECTION` is **not** a section
  decision and **not** headline-positive.

## 2. Exact residual alternative

After the multisection is installed, the honest residual dichotomy on the
smooth generic fibre \(S/F\), \(F=K(q)\), is

```text
(R1)  S(F) nonempty  ⇔  rational section of Y/P^1_K
      ⇔  imprimitive integral quartic exists (2+2 block + quadratic residual)

(R2)  S(F) empty
      ⇔  every integral quartic is primitive of Galois type A4 or S4
      ⇔  cubic resolvent irreducible, full P^3 span
```

Equivalences used:

- a rational point of \(S\) is a rational section of \(f\colon Y\to\mathbf P^1_K\);
- imprimitive quartic \(\Leftrightarrow\) section, by conjugate-pair residual
  (Remark 1.6 of Voisin) versus the cyclic construction in the section branch;
- under (R2), transitive subgroups \(C_4,V_4,D_4\subset S_4\) are excluded
  because each preserves a \(2{+}2\) block system (`quartic_branch.json`,
  `residual_gate.json`).

The multisection theorem is true in **both** residual branches.  It no longer
discriminates.

## 3. What constitutes an accepted rational section

Any one of the following, scheme-theoretically over \(K\), closes the section
clause:

| Class | Geometric meaning | Status |
|---|---|---|
| Exceptional | \(C_{012}(K)\ne\varnothing\) (degree-0 graph section on \(D\)) | Open; already headline-positive if found |
| \(H\)-degree \(d=1\) | Graph line section | **Excluded** by active-field no-\(K\)-line theorem |
| \(H\)-degree \(d\) with \(d\equiv1\pmod3\), \(d\ge4\) | Nonexceptional section curve of class \((H,D,L)=(d,d-1,1)\) | Open; first candidate \(d=4\) |
| Generic fibre point | \(S(F)\)-point | Equivalent to a section |

A coefficient model for nonexceptional sections is

\[
\Phi(A_0,A_1,A_2,sr,tr)=0,\qquad
A_i\in K[s,t]_d,\quad r\in K[s,t]_{d-1},\quad
\gcd(A_0,A_1,A_2,r)=1.
\]

For \(d=4\) this is the saturated open in the raw 13-cubic locus in
\(\mathbf P^{18}_K\) (`SECTION_CLASSES.json`).  Modular reductions at
\(p=23,67\) have smooth gcd-free points of Jacobian rank 13; those are
**not** descent data.

**Acceptance criteria for a positive section claim** (M3.5):

1. coordinate identity \(\Phi=0\) over \(K(q)\) (or globally over \(K[s,t]\));
2. coordinates not simultaneously zero;
3. map to base of degree one (automatic for the graph model when \(r\not\equiv0\));
4. extension across \(\mathbf P^1\) or evaluation at one \(K\)-rational base value;
5. blowdown to a point of the authoritative Schur twist \(X_T\);
6. separate bridge ledger to \(G\)-unirationality — **not** claimed here.

Index one, vanishing elementary obstruction, modular sections, and formal
zero-cycle arithmetic are **not** sections.

## 4. Ordered residual gates (smallest first)

These are the remaining decision gates, ordered by how little new input they
need relative to the sealed packet.

### Gate G0 — exceptional centre point

- **Object:** \(C_{012}(K)\).
- **Outcome:** point \(\Rightarrow\) exceptional section \(\Rightarrow\)
  headline-positive; emptiness is consistent with both residual branches if a
  nonexceptional section still exists.
- **Size:** one plane cubic over \(K\); already the classical Schur-twist
  point problem in the plane \(a_3=a_4=0\).

### Gate G1 — saturated \(H\)-degree-4 section scheme (primary computational)

- **Object:** \(K\)-points of the basepoint-free locus of
  \(\Phi(A_0,A_1,A_2,sr,tr)=0\) in \(\mathbf P^{18}_K\)
  (`SECTION_CLASSES.json` / `SECTION_SEARCH.md`).
- **Outcome:** any genuine \(K\)-point is a nonexceptional section and is
  headline-positive after M3.5 evaluation.
- **Hardness:** 13 cubics, saturation against common binary factors; raw
  dimension and modular points do not decide the twisted \(K\)-locus.
- **Conditional filter:** if there is no section of any degree then
  \(\operatorname{ind}(C_{012})=3\), so every nonexceptional section degree
  satisfies \(d\equiv1\pmod3\).  Thus under the no-section hypothesis the
  first admissible class is already \(d=4\); higher classes are \(d=7,10,\ldots\).

### Gate G2 — primitive `A4`/`S4` quartic field algebra (no-section witness)

- **Object:** one chart tuple for
  \(g(T)=T^4+c_2T^2+c_1T+c_0\) with cubic coordinates in \(T\), full-span
  determinant, irreducible \(g\), irreducible cubic resolvent, and
  discriminant square test for \(A_4\) vs \(S_4\)
  (`quartic_branch.json` primitive incidence).
- **Outcome:**
  - an **imprimitive** exact quartic proves a section (by residual);
  - a **primitive** exact quartic refines (R2) but **does not** by itself prove
    absence of a section (a surface can have both a primitive quartic point
    and a rational point).
- **Boundary:** coordinate-free existence of *some* integral quartic is already
  sealed; G2 is about explicit arithmetic type, not multisection existence.

### Gate G3 — actual 27-line monodromy / algebraic Brauer (conditional only)

- **Installed:** 24 transverse \(A_1\) fibres (Lefschetz); six modular 27-line
  Frobenius cycle types inside \(W(E_6)\); abstract
  \(H^1(W(E_6),\operatorname{Pic})=0\).
- **Missing:** labelled geometric generators; arithmetic generic group; hence
  the actual algebraic Brauer quotient of \(S/F\).
- **Usefulness bound:** even full \(W(E_6)\) monodromy with vanishing algebraic
  Brauer is **not** a rational-point theorem.  Line monodromy cannot remove
  residual \(A_4\) or \(S_4\) quartics, because a quartic point need not lie on
  a line (`quartic_branch.json` caveat).  G3 eliminates only some divisor-class
  or Brauer components; it is not the smallest section gate.

### Gate G4 — characteristic-zero residual / secant descent from installed covers

- Degree-3 exceptional cover: residual of any pair returns the third point
  (degree preserved).
- Degree-55 involution-line cover: all 1 485 pairs checked at sealed \(p=23\);
  no specialized singleton residual orbit; no char-0 descent of pair residual
  sealed (`RESIDUAL_CONSTRUCTIONS.md`).
- Without an explicit quartic point, there is no scheme-theoretic secant input
  from the multisection theorem alone.

### Gate G5 — higher \(d\equiv1\pmod3\) section schemes

Only if G1 is emptied over \(K\) **and** a separate theorem bounds section
degree, or a new construction supplies \(d=7,10,\ldots\).  Bounded search
alone never proves no-section.

## 5. Smallest computational / theorem gate (recommendation)

| Priority | Gate | Why |
|---:|---|---|
| **1** | **G1** saturated \(d=4\) section over \(K\) | Direct positive close-out; modular smooth locus already nonempty |
| **2** | **G0** centre point \(C_{012}(K)\) | Same positive strength; classical model |
| **3** | **G2** only as refinement / tool | Explicit primitive or imprimitive quartic; imprimitive \(\Rightarrow\) section |
| **4** | **G3** monodromy/Brauer | Conditional; cannot remove \(A_4/S_4\); not a point theorem |
| **5** | **G4–G5** | Residual recipes and higher degrees after G1 |

The **smallest decision gate for the section question** is therefore:

```text
Decide whether the saturated H-degree-4 section scheme over K is nonempty
(or produce any other K-section: exceptional or higher d≡1 mod 3).
```

The **smallest no-section obstruction gate** (much harder) would require a
theorem that every residual branch is empty — not supplied by multisection
existence, modular emptiness, or conditional Brauer vanishing.

## 6. Light exact residual check (this pass)

Producer/verifier pair:

```text
produce_residual_gate.py  →  residual_gate.json
verify_residual_gate.py
```

Exact checks performed (no new heavy CAS, no monodromy claim):

1. **Transitive \(S_4\) lattice:** every transitive subgroup is one of
   \(C_4,V_4,D_4,A_4,S_4\); the first three are imprimitive (\(2{+}2\) blocks);
   \(A_4\) and \(S_4\) are primitive.  Matches the sealed no-section residual
   stratum.
2. **Index / elementary obstruction arithmetic:** \(\gcd(3,55)=1\) and
   \(55-18\cdot3=1\); elementary obstruction killed by corestriction; not a
   point theorem.
3. **Imprimitive \(\Leftrightarrow\) section linkage** recorded as the residual
   exclusive alternative (R1)/(R2).
4. **Monodromy/Brauer ledger:** re-reads sealed Lefschetz + conditional
   \(H^1(W(E_6))=0\) + unresolved actual groups; does **not** promote
   conditional vanishing to a computed algebraic Brauer group.
5. **Frobenius type compatibility:** sealed six specializations’ cycle types
   all occur in the abstract \(W(E_6)\) line action (counts already in
   `line_frobenius_specializations.json`); still no char-0 monodromy.
6. **Exit firewall:** multisection sealed; section undecided; no
   \(K_{\mathrm{Schur}}\)-point; no bridge.

Markers:

```text
M3_RESIDUAL_GATE_CERTIFICATE_OK
SECTION_QUESTION_STILL_UNDECIDED
```

## 7. Explicit non-claims

- No rational section produced.
- No emptiness of the \(d=4\) section scheme over \(K\).
- No actual geometric or arithmetic 27-line monodromy group.
- No computed algebraic Brauer group of \(S/F\).
- No \(K_{\mathrm{Schur}}\)-point of \(X_T\) and no `BRIDGE_SARKISOV_POS.md`.
- Multisection existence is **not** reopened and **not** re-proved here.
