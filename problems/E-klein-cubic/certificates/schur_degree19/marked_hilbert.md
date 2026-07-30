# Marked Hilbert / Quot scheme over \(F\) — Attempt 3, Task 3C.2

**Date:** 2026-07-30  
**Ground field:** \(F=K_{\mathrm{Schur}}=\mathbf C(\mathbf P(V_6))^G\)  
**Ambient after hyperplane choice:** \(M\simeq\mathbf P^3_F\)  
**Marked point:** \(Z\subset M\), the descended degree-55 closed point  
**Headline:** OPEN

---

## 0. The \(F\) vs \(\overline F\) distinction (crux)

Every scheme in this note is constructed over \(F\), not merely after base
change to \(\overline F\).

| Object | Over \(F\) | After \(\overline F\) |
|---|---|---|
| marked point \(Z\) | one closed point, residue degree 55 | 55 geometric points |
| Hilbert scheme \(\operatorname{Hilb}^{p}(M)\) | defined over \(F\) (Grothendieck) | geometric components may split |
| marked locus \(\mathcal H_Z\) | closed \(F\)-subscheme of Hilb cut by containment \(Z\subset C\) | incidence with 55 points |
| curve \(C\) | \(F\)-scheme with Hilbert polynomial \(p(t)=19t+1\) | geometric integral curve of degree 19, genus 0 |

A geometric integral rational curve defined only over \(\overline F\) that
does not descend to \(F\) is **not** a point of \(\mathcal H_Z(F)\) and does
**not** feed Arrow 1 of the implication audit.  This is the same discipline
as house rule 10: objects must be defined over the correct field.

---

## 1. Hilbert polynomial and ambient Hilbert scheme

Set

\[
p(t)=19t+1
\]

(the Hilbert polynomial of a degree-19, arithmetic-genus-0 curve in
\(\mathbf P^3\)).  Let

\[
H \;:=\; \operatorname{Hilb}^{p}_{M/F}
\]

be the Hilbert scheme of closed subschemes of \(M\simeq\mathbf P^3_F\) with
Hilbert polynomial \(p\), constructed over \(F\) by the standard Grassmannian
embedding via saturated ideals in a high degree (Grothendieck).  Equivalently
one may use the Quot scheme

\[
\operatorname{Quot}_{M/F}\bigl(\mathcal O_M,\; p\bigr)
\]

of coherent quotients of \(\mathcal O_M\) with Hilbert polynomial \(p\), and
pass to the open locus of saturated ideal sheaves of pure 1-dimensional
subschemes.

**Nonemptiness of \(H\) over \(F\):** not decided in this packet.  Over
\(\overline F\), smooth rational degree-19 curves in \(\mathbf P^3\) exist
(e.g. rational normal curves of degree 3 are smaller; degree 19 rational
curves exist as images of degree-19 maps \(\mathbf P^1\to\mathbf P^3\)).
Existence over \(\overline F\) does **not** give an \(F\)-point of \(H\), and
does **not** give a curve through \(Z\).

---

## 2. Marked incidence scheme over \(F\)

Define the **marked Hilbert scheme** as the closed subscheme

\[
\mathcal H_Z
\;\subset\;
H
\]

representing the functor of flat families of pure 1-dimensional subschemes
\(C\subset M_T\) with Hilbert polynomial \(p\) such that the closed immersion
\(Z_T\hookrightarrow M_T\) factors through \(C\).  Because \(Z\) is a closed
\(F\)-subscheme of \(M\), the containment condition is a closed condition on
\(H\) defined over \(F\).

### Ideal-theoretic equations (exact format)

In a degree \(d\gg0\) where ideals are generated and saturated, points of
\(H\) correspond to saturated homogeneous ideals \(I\subset S=F[x_0,x_1,x_2,x_3]\)
with Hilbert function eventually \(p\).  Containment \(Z\subset C\) is

\[
I\subset I_Z
\]

as homogeneous ideals.  Through degree five the forced conditions are:

\[
I(d)=0\quad(d\le4),
\qquad
\dim I(5)\in\{0,1\},
\qquad
I(5)\subset I_Z(5)=f_3 S_2\oplus\langle f_5\rangle.
\]

Branch stratification over \(F\):

\[
\mathcal H_Z
\;=\;
\mathcal H_Z^{(0)}
\;\cup\;
\mathcal H_Z^{(1)},
\]

\[
\mathcal H_Z^{(\varepsilon)}
=\bigl\{
I\in\mathcal H_Z:\dim I(5)=\varepsilon
\bigr\}.
\]

Both strata are defined over \(F\) (rank loci of the evaluation /
coefficient maps on \(I(5)\)).

### Further open/closed conditions for “qualifying”

Inside \(\mathcal H_Z\), the qualifying open/closed conditions of the
implication audit are:

| Condition | Type over \(F\) |
|---|---|
| pure dimension 1 | open in Hilb (flat + fibre dimension) |
| no component in \(V(f_3)\) | open (non-containment of components) |
| multiplicity one at the support of \(Z\) along \(C\cap V(f_3)\) | open (Fitting / length of the intersection scheme at \(Z\)) |
| geometrically integral | open on the pure locus |
| smooth rational | open (geometric genus 0 + smoothness) |

The residual degree-2 construction only needs the qualifying closed/open
conditions, not smoothness.

---

## 3. Component dimensions — virtual counts

These are **virtual** dimensions.  They are not certified dimensions of
components of \(\mathcal H_Z\), and negative values are not emptiness proofs
(the 55-point configuration is special; obstructed components may have
excess dimension).

| Model | Formula | Value |
|---|---|---|
| \(\chi(N_{C/\mathbf P^3})\) for smooth \(C\) | \(4\cdot 19\) | 76 |
| maps \(\mathbf P^1\to\mathbf P^3\) degree 19, mod \(\operatorname{Aut}\mathbf P^1\) | \(4\cdot20-3\) | 77 |
| same maps through 55 geometric points (\(\approx2\) conditions each) | \(77-110\) | \(-33\) |
| Hilbert, unmarked, \(h^1(N)=0\) | 76 | 76 |
| Hilbert, 55 points as codim-1 conditions each | \(76-55\) | 21 |
| fixed hyperplane model, maps marked | \(77-110\) | \(-33\) |

The map-count \(-33\) is the most honest expected dimension for a smooth
rational marked curve.  The codim-1 Hilbert model giving \(+21\) overcounts
if each degree-55 closed point imposes more than one condition, or
undercounts if conditions fail to be independent.

**Certified dimension statement:** none.  No component dimension of
\(\mathcal H_Z\) or \(\mathcal H_Z^{(\varepsilon)}\) is proved in this packet.

---

## 4. Nonemptiness

| Question | Status |
|---|---|
| \(H(\overline F)\neq\varnothing\) (unmarked, geometric) | yes (ordinary rational curves of degree 19 exist geometrically) |
| \(H(F)\neq\varnothing\) | undecided |
| \(\mathcal H_Z(\overline F)\neq\varnothing\) | undecided |
| \(\mathcal H_Z(F)\neq\varnothing\) | undecided — this is the construction target |
| \(\mathcal H_Z^{(\varepsilon)}(F)\neq\varnothing\) for \(\varepsilon\in\{0,1\}\) | undecided |

No \(F\)-point of \(\mathcal H_Z\) is exhibited.  No emptiness proof for either
stratum is obtained.

---

## 5. Fields of definition and incidence with the degree-55 point

- **Field of definition of \(Z\):** \(F\).  Residue field \(L=F(Z)\) has
  degree 55 over \(F\).  The geometric points are a single
  \(\mathrm{Gal}(L/F)\)-orbit (transitive, from maximality of \(D_{12}\) and
  the orbit construction).
- **Incidence:** by definition every point of \(\mathcal H_Z\) is a curve
  containing \(Z\).  Geometric incidence with all 55 points is automatic
  after base change to \(\overline F\).
- **Stabilizer constraint:** the semilinear \(D_{12}\)-action on one
  geometric point is already built into the descent of \(Z\); no extra
  numerical equation is imposed beyond \(I\subset I_Z\) over \(F\).

---

## 6. Geometrically integral rational curves on components

If a component \(\Gamma\subset\mathcal H_Z\) defined over \(F\) admits an
\(F\)-point corresponding to a geometrically integral curve of arithmetic
genus 0 that is smooth over \(\overline F\), then that point is a smooth
rational qualifying candidate (after checking mult-one and properness, which
are open).  Arrow 1–3 of the implication audit would then close positively
(`P3`).

**No such \(F\)-point is known.**  Whether any component of \(\mathcal H_Z\)
contains a geometrically integral rational curve over \(F\) is open.

---

## 7. Computational boundary (8 GB gate)

A direct Gröbner / elimination attack on the marked ideal-containment
equations in the coefficient space of degree-\(\ge6\) generators through
\(I_Z\), with the Hilbert polynomial constraint, is expected to exceed the
8 GB exploratory RSS ceiling (cf. Attempt 2’s measured ~9.4 GB stop on a
smaller elimination).  This packet does **not** launch such a job.

**Emitted instead (this section):**

| Item | Content |
|---|---|
| scheme | \(\mathcal H_Z\subset\operatorname{Hilb}^{19t+1}(\mathbf P^3_F)\) |
| equations | \(I\subset I_Z\); rank loci \(\dim I(5)\in\{0,1\}\); saturation / Hilbert polynomial constraints in high degree |
| dimensions | virtual only (§3); no certified component dimension |
| sparse/dense floors | not computed; full coefficient space of \(I_Z(6)\) alone is \(\mathbf P^{28}\), and higher-degree generators enlarge it well past a 8 GB dense linear algebra budget |
| certificate format | ideal membership + Hilbert function checks over \(F\) (or a finite extension with descent) |
| checkpoint plan | attack one Rao branch’s generator-degree stratum; stream sparse coefficient rows; seal only after independent verifier |
| verifier design | independent script that, given generators of \(I\), checks \(I\subset I_Z\), Hilbert polynomial, purity, mult-one residual degree 2, and does not import the producer |

---

## 8. Theorem boundary

| Proved | Not proved |
|---|---|
| \(\mathcal H_Z\) exists as a closed \(F\)-subscheme of Hilb | nonemptiness of \(\mathcal H_Z(F)\) |
| branch stratification \(\varepsilon\in\{0,1\}\) over \(F\) | component dimensions |
| ideal-theoretic equations through degree 5 | explicit equations of a component in higher degree |
| virtual dimension counts | that virtual = actual |

**Decision contribution:** marked Hilbert components are **not excluded** and
**not populated**.  This supports exit `STOP-3` rather than `P3` or
`N3-SCOPED`.

Terminal marker:

```text
SCHUR_DEGREE19_MARKED_HILBERT_OVER_F
```
