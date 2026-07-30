# Rao resolutions and Betti constraints — Attempt 3, Task 3C.1

**Date:** 2026-07-30  
**Scope:** geometrically integral degree-19 curves through the **selected
descended hyperplane** degree-55 point \(Z\subset M\simeq\mathbf P^3_F\),
with Hilbert polynomial \(19t+1\) (arithmetic genus 0).  
**Companion machine data:** `betti_tables.json`  
**Headline:** OPEN

---

## 0. Accepted ledger (not re-derived)

Over the ground field \(F=K_{\mathrm{Schur}}\) of the generic Schur twist,
after a torsor-dependent hyperplane choice in the certified open
(§ structural design packet):

\[
h_Z(d)=1,4,10,19,31,45,55\qquad(d=0,\ldots,6),
\]

\[
I_Z(d)=0\ (d\le2),\quad
I_Z(3)=\langle f_3\rangle,\quad
I_Z(4)=f_3 S_1,\quad
I_Z(5)=f_3 S_2\oplus\langle f_5\rangle.
\]

Every qualifying curve \(C\) through \(Z\) is geometrically integral, lies in
\(M\), and satisfies

\[
I_C\subset I_Z,\qquad
I_C(d)=0\ (d\le4),\qquad
\varepsilon:=\dim I_C(5)\in\{0,1\}.
\]

ACM integral curves are excluded (exhaustive \(h\)-vector check).  The two
live branches are \(\varepsilon=0\) and \(\varepsilon=1\).

A **smooth rational** survivor has \(\mathcal O_C(1)\simeq\mathcal O_{\mathbf P^1}(19)\)
and Rao dimensions

\[
\bigl(h^1(I_C(d))\bigr)_{d=0}^{5}
=(0,16,29,38,42,40+\varepsilon).
\]

Replay: `tmp/a3_schur19/rao_betti_analysis.py`.

---

## 1. Postulation from the Rao ledger

From the restriction sequence and \(h^1(\mathcal O_{\mathbf P^3}(d))=0\),

\[
h^1(I_C(d))
= h^0(\mathcal O_C(d)) - \bigl(\dim S_d - \dim I_C(d)\bigr).
\]

For smooth rational \(C\), \(h^0(\mathcal O_C(d))=19d+1\) (\(d\ge0\)), so

\[
\dim I_C(d)
=\dim S_d - (19d+1) + h^1(I_C(d)).
\]

Through degree five this recovers exactly \(\dim I_C(d)=0\) for \(d\le4\) and
\(\dim I_C(5)=\varepsilon\), matching the prime-ideal bound.  The large Rao
spaces are **accounted for** by postulation failure; they are not a numerical
contradiction.

### Degree-six bound forced by \(I_C\subset I_Z\)

\[
\dim I_C(6)=\mathrm{rao}(6)-31,
\qquad 0\le\dim I_C(6)\le\dim I_Z(6)=29,
\]

hence

\[
31\le h^1(I_C(6))\le 60.
\]

No tighter value is forced by the degree-five ledger alone.

---

## 2. Rejected Betti / resolution patterns

Machine enumeration: `betti_tables.json`.  Summary of rejections that apply
to **both** live branches unless noted.

| Pattern | Constraint violated |
|---|---|
| ACM / pure Hilbert–Burch codim-2 | ACM \(h\)-vectors of degree 19 with init degree \(\ge5\) force \(\dim I_C(5)\in\{2,3,4,5\}\), contradicting \(\dim I_C(5)\le1\) |
| Minimal generator in degree \(\le4\) | \(I_C(d)=0\) for \(d\le4\) |
| \(\dim I_C(5)\ge2\) | primality inside \(I_Z(5)\): two quintics produce \(f_3 q_2\in I_C\) |
| Complete intersection of two surfaces | degree \(ab=19\) forces a plane factor; planar curves have \(I_C(1)\ne0\) |
| Contained in a quadric / cubic / quartic | \(I_C(2)=I_C(3)=I_C(4)=0\) |
| Resolution defined only after splitting \(Z_{55}\) into non-descent summands | marked data and Betti numbers must be over \(F\), not merely \(\overline F\) |

### ACM \(h\)-vectors (exhaustive for init degree 5)

| \(h\)-vector | forced \(\dim I_C(5)\) | status |
|---|---|---|
| \((1,2,3,4,5,4)\) | 2 | REJECTED |
| \((1,2,3,4,5,3,1)\) | 3 | REJECTED |
| \((1,2,3,4,5,2,2)\) | 4 | REJECTED |
| \((1,2,3,4,5,2,1,1)\) | 4 | REJECTED |
| \((1,2,3,4,5,1,1,1,1)\) | 5 | REJECTED |

Init degree \(\ge6\) needs \(h\)-mass at least \(21>19\): impossible.

---

## 3. Live shape — Branch \(\varepsilon=0\) (no quintic)

```text
min generators: all in degree >= 6
dim I_C(5) = 0
Rao (d=0..5) = (0, 16, 29, 38, 42, 40)
first possible surface carrier degree: 6
module type: non-ACM; Rao module nonzero at least in degrees 1..5
```

### Compatible free-resolution outline

Let \(M=\bigoplus_d H^1(I_C(d))\) be the Rao module.  A minimal free resolution
of \(I_C\) over \(S=F[x_0,x_1,x_2,x_3]\) has the shape

\[
0\to F_3\to F_2\to F_1\to I_C\to 0
\]

with \(F_1=\bigoplus S(-d_i)\), all \(d_i\ge6\), and intermediate homology
controlled by \(M\) (nonvanishing prevents a pure Hilbert–Burch matrix of
maximal minors).  The precise Betti numbers
\((b_{i,j})\) are **not unique** given only the degree-five Rao ledger:
different finite-length modules with the same Hilbert function through
degree five can have different minimal resolutions.

**What is certified for this branch:**

1. generator-degree lower bound \(\ge6\);
2. Hilbert polynomial \(19t+1\);
3. containment \(I_C\subset I_Z\);
4. Rao dimensions through degree five;
5. degree-six bounds above;
6. Galois-descent: Betti numbers are integers (dimensions of \(F\)-vector
   spaces), and the resolution may be chosen Gal\((\overline F/F)\)-stable
   because \(C\) and \(Z\) are \(F\)-schemes.

**What is not certified:** a single numerical Betti table; nonemptiness of
the corresponding stratum of the Hilbert scheme.

### Semilinear \(D_{12}\) constraint

The geometric stabilizer of one orbit point is the certified maximal
\(D_{12}\).  After descent, \(Z\) is a single closed point of degree 55, so
the residue field \(L=F(Z)\) carries a semilinear \(D_{12}\)-action
compatible with the embedding \(Z\subset\mathbf P^3_F\).  Any \(F\)-defined
curve through \(Z\) has ideal stable under \(\mathrm{Gal}(L/F)\).  This
forbids writing a resolution that exists only after choosing a geometric
point of \(Z\) and does not descend.  It does **not**, by itself, kill either
live numerical Rao ledger.

---

## 4. Live shape — Branch \(\varepsilon=1\) (unique quintic carrier)

```text
min generators: exactly one in degree 5; others in degree >= 6
dim I_C(5) = 1
carrier: F_q = f5 + f3*q,  q in S_2
Rao (d=0..5) = (0, 16, 29, 38, 42, 41)
on S_q = V(F_q): Y = V(f3,f5) ~ 3H
```

### Unique carrier equation

Primality and \(I_C(5)\subset I_Z(5)=f_3 S_2\oplus\langle f_5\rangle\) force
the unique quintic to be, after scaling,

\[
F_q=f_5+f_3 q,\qquad q\in S_2.
\]

(The \(\mathbf P^{10}\)-family of quintics through \(Y\) is
\(\mathbf P(f_3 S_2\oplus\langle f_5\rangle)\); the open chart with nonzero
\(f_5\)-coefficient is exactly this affine 10-space in \(q\).)

### Resolution outline

\[
I_C = (F_q,\; g_1,\ldots,g_r,\; \ldots)
\]

with \(\deg g_j\ge6\), still non-ACM.  The same non-uniqueness of full Betti
numbers applies.  Additional geometric constraint: \(C\subset S_q\), so the
resolution of \(I_C\) factors through the ideal of \(C\) on \(S_q\).

### Picard obstruction (conditional)

If \(\operatorname{Pic}(S_q)=\mathbf Z H\), then every curve degree is a
multiple of \(H^2=5\), excluding degree 19.  This is **conditional** on
Picard rank one for the **actual** carrier selected by \(C\).  See
`quintic_carriers.md` for why the standard Noether–Lefschetz theorems do
not force this for all \(q\).

---

## 5. Liaison tables (control of residuals)

Suppose \(C\) admits a proper complete-intersection link of type \((5,s)\)
with an independent degree-\(s\) surface.  Residual degree and arithmetic
genus:

| \(s\) | \(\deg C'\) | \(p_a(C')\) | reduced connected residual? |
|---|---|---|---|
| 6 | 11 | \(-28\) | no |
| 7 | 16 | \(-12\) | no |
| 8 | 21 | 9 | possible |
| 9 | 26 | 35 | possible |
| 10 | 31 | 66 | possible |

**House rule on liaison.**  Negative arithmetic genus excludes a reduced
connected residual.  It does **not** exclude disconnected or nonreduced
locally Cohen–Macaulay residuals, and it does not prove that an independent
degree-\(s\) carrier exists.  Liaison is used in this packet only with that
residual control explicit (`quintic_carriers.md`).

---

## 6. Theorem boundary

| Proved | Not proved |
|---|---|
| exhaustive rejection of ACM Betti/\(h\)-tables for the selected point | nonemptiness of either live branch |
| generator-degree constraints for \(\varepsilon\in\{0,1\}\) | a unique full Betti table per branch |
| Rao ledger through degree 5 for smooth rational survivors | Rao dimensions in all degrees |
| degree-six bounds from \(I_Z\) | exact \(\mathrm{rao}(6)\) |
| liaison genera for \((5,s)\) | exclusion of either branch by liaison |

Terminal marker:

```text
SCHUR_DEGREE19_RAO_RESOLUTIONS_ENUMERATED
```
