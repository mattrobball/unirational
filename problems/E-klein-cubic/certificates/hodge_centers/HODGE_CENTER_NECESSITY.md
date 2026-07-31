# WP-H1 — Equivariant Hodge-center necessity theorem

**Headline: OPEN.**

**Work package:** WP-H1 (Part VI of `WORKORDER_STRATA_LIFTING_BLOCKERS.md`).  
**Scope:** independent global blocker. Does not use the nonlinear lifting tower.  
**Escalation:** character screen only — no equivariant Hilbert-scheme or
invariant-ideal search in this packet.

---

## Theorem boundary (plain statement)

**Proved here (necessary condition).**  
Assume a dominant rational map \(\mathbf P^4\dashrightarrow X\) admits a
\(G\)-equivariant resolution

\[
Z\longrightarrow\mathbf P^4,\qquad f:Z\longrightarrow X.
\]

Then the five-dimensional Hodge representation \(H^{2,1}(X)\) injects into
a direct sum of contributions \(H^{1,0}(C)(-1)\) (and analogous irregular
surface contributions) from the blowup centres of the resolution. Certified
**linear strata and point centres contribute no \(H^1\)**. Therefore any
actual lift of the strata machine must create **additional nonlinear
positive-genus curves or irregular surfaces**.

**Not proved here.**  
This is **not by itself a contradiction**. No numerical obstruction to a
primitive minimal landing covariant is certified in this packet. A numerical
contradiction would require a budget violation that survives self-attack; none
was found.

---

## 1. Split injection \(f^*:H^3(X,\mathbf Q)\hookrightarrow H^3(Z,\mathbf Q)\)

**Repair note (2026-07-31).**  The original write-up treated \(f:Z\to X\) as
generically finite and pushed \(H^3(Z)\) directly to \(H^3(X)\).  That is
wrong: \(Z\) resolves a rational map from \(\mathbf P^4\), so
\(\dim Z=4\) and \(\dim X=3\), and a dominant \(f\) has relative dimension
one.  The argument below replaces that derivation entirely by the relatively
ample class splitting of `REPAIR.md` §8.  Historical character-screen data are
unchanged; only the cohomological splitting is rewritten.  See
`REPAIR.md` §§7–8.

### Setup

Let \(X\subset\mathbf P(W)\simeq\mathbf P^4\) be the Klein cubic threefold,
\(G=\operatorname{PSL}_2(\mathbf F_{11})\) acting linearly on \(W\) via the
exact Weil representation of `certificates/exact_weil_check.py`. Let

\[
\varphi:\mathbf P^4\dashrightarrow X
\]

be a dominant rational map, and let

\[
\pi:Z\longrightarrow\mathbf P^4,\qquad f:Z\longrightarrow X
\]

be a \(G\)-equivariant resolution of indeterminacy: \(\pi\) is a composition
of blowups along smooth \(G\)-invariant centres (or a \(G\)-equivariant
smooth resolution dominating the graph closure), \(f\) is a \(G\)-equivariant
morphism, and \(f=\varphi\circ\pi\) on a dense open.

Dimensions: \(Z\) is four-dimensional (a resolution of a map out of
\(\mathbf P^4\)) and \(X\) is three-dimensional, so a dominant \(f\) has
relative dimension one.  In particular \(f\) is **not** generically finite,
and there is no valid degree-\(d\) identity \(f_*\circ f^*=\times d\) on
\(H^3\).

### Relatively ample class and splitting (`REPAIR.md` §8)

Choose a \(G\)-invariant ample class

\[
\eta\in H^2(Z,\mathbf Q)
\]

(e.g. a sufficiently large multiple of an equivariant very ample class
obtained by averaging).  Then

\[
f_*(\eta)=n\in H^0(X,\mathbf Q)
\]

for some \(n>0\), the degree of \(\eta\) on the generic curve fibre of \(f\).
Define the rational map of Hodge structures

\[
s:H^3(Z,\mathbf Q)\longrightarrow H^3(X,\mathbf Q),
\qquad
s(\beta)=\frac1n\,f_*(\eta\cup\beta).
\]

For \(\alpha\in H^3(X,\mathbf Q)\), the projection formula gives

\[
s(f^*\alpha)
=
\frac1n\,f_*\bigl(\eta\cup f^*\alpha\bigr)
=
\frac1n\,f_*(\eta)\cup\alpha
=
\alpha.
\]

Thus \(f^*\) is a **split injection** of rational Hodge structures, with
left inverse \(s\).  Averaging \(\eta\) over \(G\) (or choosing \(\eta\)
\(G\)-invariant from the start) makes the splitting \(G\)-equivariant, so

\[
f^*:H^3(X,\mathbf Q)\longrightarrow H^3(Z,\mathbf Q)
\]

is a split injection of \(\mathbf Q[G]\)-modules.

**Form used.** We only need: \(f^*\) is injective on \(H^3(-,\mathbf Q)\) as
\(G\)-modules. We do not need integral coefficients or torsion information.
No new CAS computation is required for this replacement.

### Hodge refinement

The map \(f^*\) is a morphism of rational Hodge structures, so it injects

\[
H^{2,1}(X)\hookrightarrow H^{2,1}(Z)
\]

as complex \(G\)-representations (and likewise \(H^{1,2}\)).

---

## 2. Equivariant blowup decomposition

### Smooth centre of codimension \(c\)

Let \(Y\) be smooth projective, \(C\subset Y\) a smooth closed subvariety of
codimension \(c\ge 2\), and \(\widetilde Y=\operatorname{Bl}_C Y\). The
Blanchard–Grothendieck / Voisin decomposition of rational cohomology gives,
for \(k=3\),

\[
H^3(\widetilde Y,\mathbf Q)
\simeq
H^3(Y,\mathbf Q)
\oplus
H^1(C,\mathbf Q)(-1)
\quad\text{if }c=2,
\]

and more generally

\[
H^3(\widetilde Y,\mathbf Q)
\simeq
H^3(Y,\mathbf Q)
\oplus
\bigoplus_{i=1}^{c-1}
H^{3-2i}(C,\mathbf Q)(-i).
\]

**Curve centres** (\(c=\dim Y-1\), so \(C\) a curve when \(\dim Y=4\)): only
the \(H^1(C)(-1)\) summand can feed \(H^3\).  
**Point centres:** \(H^1(\mathrm{pt})=0\), no contribution to \(H^3\).  
**Linear subspace centres** \(\mathbf P^k\subset\mathbf P^4\):  
\(H^1(\mathbf P^k)=0\), no contribution to \(H^3\).

### Equivariance

If a finite group \(H\) acts on \(Y\) preserving \(C\), the blowup is
\(H\)-equivariant and the decomposition is one of \(H\)-representations.
Tate twist \((-1)\) shifts Hodge type by \((1,1)\), so

\[
H^{1,0}(C)(-1)
\subset
H^{2,1}(\operatorname{Bl}_C Y).
\]

Starting from \(H^3(\mathbf P^4)=0\), every class in \(H^{2,1}(Z)\) is
therefore assembled from \(H^{1,0}\) of positive-irregularity centres
(curves of genus \(\ge 1\), or surfaces with \(q\ge 1\), etc.) along the
blowup tower.

### Certified strata contribute nothing

The exact strata machine (`certificates/strata/strata_exact.json`) produces
only:

| Centre type | Geometry | \(H^1\) |
|-------------|----------|--------|
| involution plus-plane | \(\mathbf P(E_+)\simeq\mathbf P^2\) | \(0\) |
| involution minus-line | \(\mathbf P(E_-)\simeq\mathbf P^1\) | \(0\) |
| V4 fixed line | \(\mathbf P^1\) | \(0\) |
| C3 eigenline | \(\mathbf P^1\) | \(0\) |
| all point orbits | \(\mathbf P^0\) | \(0\) |

**Caution (elliptic fixed loci).** For an involution \(t\), the section
\(E_t=X\cap\mathbf P(E_+(t))\) is a smooth plane cubic of genus \(1\) with
\(j(E_t)=8192/11\). This curve lives on the **target** \(X\) (and as a
subvariety of ambient \(\mathbf P^4\)). It is **not** one of the linear
strata centres above. If a resolution centre coincides with a \(G\)-orbit of
such elliptics, it **does** contribute \(H^{1,0}\). That possibility is
recorded among the surviving pairs for stabilizers \(C_2\), \(D_{12}\), and
related residual groups; it is a candidate, not an automatic obstruction.

---

## 3. \(H^{2,1}(X)\) from the Jacobian ring

### Griffiths residue

For a smooth cubic threefold \(X=\{F=0\}\subset\mathbf P^4\),

\[
H^{2,1}(X)
\simeq
R_1(F)
:=
\bigl(\mathbf C[x_0,\ldots,x_4]/J(F)\bigr)_1,
\]

where \(J(F)=(\partial F/\partial x_i)\) is the Jacobian ideal. (Generally
\(H^{3-q,q}_{\mathrm{prim}}(X)\simeq R_{(q+1)\cdot 3-5}\).)

### Macaulay2 dimensions (characteristic zero)

For the Klein equation \(F=\sum_{i\in\mathbf Z/5}x_i^2 x_{i+1}\),

| \(d\) | \(0\) | \(1\) | \(2\) | \(3\) | \(4\) | \(5\) | \(\ge 6\) |
|------:|------:|------:|------:|------:|------:|------:|----------:|
| \(\dim R_d\) | \(1\) | \(5\) | \(10\) | \(10\) | \(5\) | \(1\) | \(0\) |

So \(\dim H^{2,1}(X)=5=\dim H^{1,2}(X)\). Smoothness: the affine cone of the
singular locus has dimension \(0\) over \(\mathbf Q\).

### \(G\)-representation

The graded piece \(R_1\) is the space of linear forms, i.e. \(W^*\) as a
\(G\)-module (polynomials transform by the dual of the ambient action).
Hence

\[
H^{2,1}(X)\;\simeq\;W^*
\quad\text{as complex \(G\)-representations.}
\]

The ambient character \(\chi_W\) is the irreducible

\[
\chi_W
=
\operatorname{Irr}(G)[2]
=
\bigl(5,\;A,\;\overline A,\;1,\;-1,\;1,\;0,\;0\bigr)
\]

on conjugacy classes \((1a,11a,11b,2a,3a,6a,5a,5b)\), where
\(A=E(11)+E(11)^3+E(11)^4+E(11)^5+E(11)^9=(-1+\sqrt{-11})/2\).  
This matches the exact matrices of `exact_weil_check.py`: an order-\(11\)
element \(T\) is diagonal with eigenvalues \(\zeta_{11}^{q}\) for quadratic
residues \(q\), so \(\operatorname{tr}(T)=A\).

Therefore

\[
\chi_{H^{2,1}}
=
\chi_{W^*}
=
\operatorname{Irr}(G)[3]
=
\bigl(5,\;\overline A,\;A,\;1,\;-1,\;1,\;0,\;0\bigr).
\]

Cross-check: GAP character table of \(\operatorname{PSL}_2(11)\) (CTblLib),
degree \(5\), value \(1\) on involutions, \(-1\) on order \(3\).

---

## 4. Character screen

### Method

For every conjugacy class of subgroups \(H\le G\) of a type appearing in the
exact strata table (and the residual types \(S_3\), \(C_6\), \(11{:}5\)),
compute

\[
\dim\operatorname{Hom}_H\bigl(H^{2,1}(X)\big|_H,\,\rho\bigr)
=
\bigl\langle \chi_{H^{2,1}}\big|_H,\,\chi_\rho\bigr\rangle_H
\]

for every irreducible complex representation \(\rho\) of \(H\), via
CTblLib fusion and scalar products in GAP 4.15.1.

**Surviving pair:** \(\operatorname{Hom}_H\neq 0\). By Frobenius reciprocity,
such a \(\rho\) can appear in \(H^{1,0}(C)\) for a curve centre \(C\) with
setwise stabilizer containing \(H\) and still contribute to the
\(G\)-isotypic component of \(H^{2,1}\).

### Subgroup counts (regression)

| Type | \(\lvert H\rvert\) | Count | \([G:H]\) |
|------|-------------------:|------:|----------:|
| \(C_2\) | 2 | 55 | 330 |
| \(C_3\) | 3 | 55 | 220 |
| \(V_4\) | 4 | 55 | 165 |
| \(C_5\) | 5 | 66 | 132 |
| \(S_3\) (2 classes) | 6 | 55+55 | 110 |
| \(C_6\) | 6 | 55 | 110 |
| \(D_{10}\) | 10 | 66 | 66 |
| \(C_{11}\) | 11 | 12 | 60 |
| \(A_4\) | 12 | 55 | 55 |
| \(D_{12}\) | 12 | 55 | 55 |
| \(11{:}5\) | 55 | 12 | 12 |
| \(A_5\) (2 classes) | 60 | 11+11 | 11 |

### Restriction summary

Every restriction has total dimension \(5\). Nonzero multiplicities (surviving
\(\rho\)):

| \(H\) | Surviving \(\rho\) (deg × mult) | Killed \(\rho\) |
|-------|----------------------------------|-----------------|
| \(C_2\) | \(1_{\mathrm{triv}}^{\oplus 3}\), \(\mathrm{sign}^{\oplus 2}\) | — |
| \(C_3\) | triv\(^{\oplus 1}\), \(\omega^{\oplus 2}\), \(\omega^2{}^{\oplus 2}\) | — |
| \(V_4\) | all four linear characters (triv\(^{\oplus 2}\), three nontrivial) | — |
| \(C_5\) | all five linear characters once each | — |
| \(S_3\) | triv once, std\(^{\oplus 2}\) | sign |
| \(C_6\) | triv + four nontrivial; **not** the unique order-2-on-kernel character | one linear |
| \(D_{10}\) | triv + both 2-dim | sign |
| \(C_{11}\) | five of eleven linear characters (QR/QNR orbit) | triv + five others |
| \(A_4\) | both nontrivial linear + the 3-dim | triv |
| \(D_{12}\) | triv + both 2-dim | three linear |
| \(11{:}5\) | one of the two 5-dim irreps | all 1-dim |
| \(A_5\) | the unique 5-dim irrep | 1, 3, 3, 4 |

Full tables with character values: `character_screen.json`.

---

## 5. Genus bounds (Riemann–Hurwitz + Chevalley–Weil / Lefschetz)

### Formulae used

**Riemann–Hurwitz.** For a Galois cover \(C\to C/H\) of signature
\((\gamma;m_1,\ldots,m_r)\),

\[
2g-2
=
\lvert H\rvert\Bigl(2\gamma-2+\sum_i(1-1/m_i)\Bigr).
\]

**Holomorphic Lefschetz / Chevalley–Weil.** For \(h\in H\setminus\{1\}\) with
fixed points of local monodromy eigenvalues \(\xi_p\),

\[
\operatorname{tr}\bigl(h\big|H^{1,0}(C)\bigr)
=
1-\sum_{p\in\operatorname{Fix}(h)}\frac{1}{1-\xi_p},
\]

and \(\operatorname{tr}(1)=g\). Multiplicities of irreps are the character
inner products of this class function. Fixed-point counts from a generating
vector \((c_i)\) of orders \(m_i\):

\[
\lvert\operatorname{Fix}(h)\rvert
=
\lvert C_H(h)\rvert
\sum_{i,k:\,h\sim c_i^k}\frac{1}{m_i}.
\]

(Calibrated on hyperelliptic involutions: \(\operatorname{tr}=-g\).)

**Constructive search.** For each surviving \((H,\rho)\), search small
signatures for generating vectors, compute multiplicities, and record the
minimal genus found. Also use:

- elliptic translations (abelian \(H\)): \(g=1\), only \(\rho=\mathrm{triv}\);
- elliptic extra automorphisms (\(\operatorname{Aut}(E,0)\in\{C_2,C_4,C_6\}\)):
  \(g=1\) for the corresponding nontrivial linear characters;
- safe free high-genus envelope when no tighter model is found.

The recorded `min_genus` is an **achieved upper bound on the true minimum**
(constructive). Hard lower bound used throughout: \(g\ge\deg\rho\).

### Surviving pairs (compressed)

| \(H\) | \(\rho\) (sketch) | mult | \(g_{\min}\) (achieved) | \([G:H]\) | plane-\(\delta\) floor | orbit plane-degree | coh. weight |
|-------|-------------------|-----:|------------------------:|----------:|----------------------:|-------------------:|------------:|
| \(C_2\) | triv | 3 | 1 | 330 | 3 | 990 | 330 |
| \(C_2\) | sign | 2 | 1 | 330 | 3 | 990 | 330 |
| \(C_3\) | triv, \(\omega\), \(\omega^2\) | 1,2,2 | 1 | 220 | 3 | 660 | 220 |
| \(V_4\) | triv | 2 | 1 | 165 | 3 | 495 | 165 |
| \(V_4\) | three nontrivial linears | 1 each | 1–2 | 165 | 3–4 | 495–660 | 165–330 |
| \(C_5\) | triv | 1 | 1 | 132 | 3 | 396 | 132 |
| \(C_5\) | nontrivial linears | 1 each | 2–4 | 132 | 4–5 | 528–660 | 264–528 |
| \(S_3\) | triv | 1 | 7 | 110 | 6 | 660 | 770 |
| \(S_3\) | std (deg 2) | 2 | 2 | 110 | 4 | 440 | 220 |
| \(C_6\) | five linears | 1 each | 1 | 110 | 3 | 330 | 110 |
| \(D_{10}\) | triv | 1 | 11 | 66 | 7 | 462 | 726 |
| \(D_{10}\) | two 2-dim | 1 each | 4 | 66 | 5 | 330 | 264 |
| \(C_{11}\) | five linears | 1 each | 5–10 | 60 | 5–6 | 300–360 | 300–600 |
| \(A_4\) | two linears + 3-dim | 1 each | 1–4 | 55 | 3–5 | 165–275 | 55–220 |
| \(D_{12}\) | triv + two 2-dim | 1 each | 2–13 | 55 | 4–7 | 220–385 | 110–715 |
| \(11{:}5\) | one 5-dim | 1 | 12 | 12 | 7 | 84 | 144 |
| \(A_5\) | 5-dim | 1 | 5 | 11 | 5 | 55 | 55 |

Full character values and models: `character_screen.json` (`surviving_pairs`,
40 pairs total including both \(S_3\) and both \(A_5\) classes).

### Geometric highlight: the 55 elliptics

The orbit of plane cubics \(E_t\) has size 55, stabilizer \(D_{12}\)
(setwise), pointwise kernel \(\langle t\rangle\simeq C_2\) on the plus-plane.
Genus \(1\) supplies one-dimensional \(H^{1,0}\). Since
\(\langle\chi_{H^{2,1}}\big|_{D_{12}},1\rangle=1\), an orbit of centres with
**trivial** \(D_{12}\)-character on \(H^{1,0}\) induces a copy of
\(H^{2,1}\) inside \(\operatorname{Ind}_{D_{12}}^G(1)\). Whether the actual
action on \(H^{1,0}(E_t)\) is trivial is a separate geometric check (the
\(j\)-invariant \(8192/11\) forces \(\operatorname{Aut}(E)=\{\pm 1\}\), so
residual \(S_3\) cannot act faithfully on \(E_t\); the linear action through
the ambient representation may still act on differentials by a character of
\(D_{12}/C_2\)). This packet does **not** promote the 55 elliptics to a
completed obstruction or a construction.

---

## 6. Intersection budget of a primitive minimal landing covariant

### Setup

A homogeneous landing self-covariant of degree \(d\) is a \(G\)-equivariant
polynomial map \(p:W\to W\) of degree \(d\) with \(F\circ p=0\) identically,
inducing a rational map \(\mathbf P^4\dashrightarrow X\) of algebraic degree
\(d\). Primitivity means \(p\) is not a composite through a lower-degree
covariant endomorphism. The base locus \(B=Z(p)\subset\mathbf P^4\) must
contain every centre needed after resolution.

### Cohomological budget

To realise \(\dim H^{2,1}=5\), the total cohomological weight of curve centres
in the resolution must satisfy

\[
\sum_{\text{orbits }O}\lvert O\rvert\cdot g(C_O)
\ge 5,
\]

with matching \(G\)-characters (not just dimensions). Every surviving pair in
§5 has orbit cohomological weight \(\gg 5\), so **dimension counting alone
does not obstruct**.

### Degree budget (plane-model envelope)

For a curve of genus \(g\), a plane model has degree
\(\delta\ge\delta_{\mathrm{pl}}(g)\) with
\((\delta-1)(\delta-2)/2\ge g\) (\(\delta_{\mathrm{pl}}(1)=3\)). An orbit of
size \([G:H]\) then contributes at least
\([G:H]\cdot\delta_{\mathrm{pl}}(g)\) to the degree of the one-dimensional
part of a plane-model base locus. Examples:

- one \(A_5\)-orbit of genus-5 curves: degree \(\ge 11\cdot 5=55\);
- one \(D_{12}\)-orbit of genus-1 curves: degree \(\ge 55\cdot 3=165\);
- one \(C_2\)-orbit of genus-1 curves: degree \(\ge 330\cdot 3=990\).

A degree-\(d\) map given by five forms of degree \(d\) can vanish on a curve
of degree \(\delta\) only if the restriction
\(H^0(\mathcal O(d))\to H^0(\mathcal O_C(d))\) has corank \(\ge 5\). This is
automatic for large \(d\), so **no finite-\(d\) contradiction follows** from
the plane-degree envelope alone.

### Minimal covariant

Known landing exclusions in the repository run through low degrees by direct
elimination; the structural minimal degree of a primitive landing covariant
is not settled here. Combining the character screen with a specific minimal
\(d\) would require a certified lower bound on \(d\) **and** a complete list
of centres forced into the base locus. Neither is available without further
work (Hilbert-scheme search is escalation, deferred).

### Conclusion on budgets

\[
\boxed{\text{numerical_contradiction_found = false}}
\]

The screen forces nonlinear positive-genus centres and lists all character
channels through which they can feed \(H^{2,1}\). It does not yet kill every
primitive landing covariant.

---

## 7. What remains

1. **Decide which surviving channels are geometrically realizable** inside
   \(\mathbf P(W)\) as \(G\)-orbits of smooth centres (escalation:
   equivariant Hilbert schemes / invariant ideals — not done here).
2. **Compute the actual \(D_{12}\)-character on \(H^{1,0}(E_t)\)** for the
   55 fixed elliptics and compare to the surviving \(D_{12}\)-rows.
3. **Surface centres** with \(q>0\) (irregular surfaces) are not screened;
   they supply another possible channel for \(H^1\).
4. **Couple to a minimal degree \(d\)** once a primitive-minimal landing
   bound is available, and test the intersection budget for contradiction.
5. **WP-T1** (class-group) remains an independent parallel blocker.

---

## 8. Files and replay

```text
certificates/hodge_centers/HODGE_CENTER_NECESSITY.md   # this file
certificates/hodge_centers/character_screen.g         # GAP producer
certificates/hodge_centers/character_screen.json      # sealed screen
certificates/hodge_centers/assemble_json.py           # dump → JSON
certificates/hodge_centers/verify.py                  # independent verifier
tmp/wp_h1_hodge/character_screen.dump                 # GAP text dump
```

Replay:

```text
/opt/homebrew/Caskroom/miniforge/base/bin/gap -q certificates/hodge_centers/character_screen.g
/opt/homebrew/bin/python3 certificates/hodge_centers/assemble_json.py --seal
/opt/homebrew/bin/python3 certificates/hodge_centers/verify.py
# terminal marker:
WP_H1_HODGE_VERIFY_OK
```

### Intended commit split

1. `certificates/hodge_centers/character_screen.g` + dump path docs  
2. `assemble_json.py` + sealed `character_screen.json`  
3. `verify.py`  
4. `HODGE_CENTER_NECESSITY.md` (2026-07-31: generically-finite argument replaced by
   relatively ample class splitting of `REPAIR.md` §8)

Narrative theorem-boundary repairs live in a separate commit
(`CURRENT_PATHS.md`, `SPEC.md`, `HANDOFF.md`, `RESOLUTION.md` → `REPAIR.md`).

---

## 9. Acceptance checklist

- [x] Split injection via relatively ample class (`REPAIR.md` §8); equivariant blowup decomposition at the level used  
- [x] Generically-finite / wrong-degree pushforward argument **removed**, not papered over  
- [x] \(H^{2,1}(X)\) as \(G\)-rep from Jacobian ring; dim 5; character vs GAP  
- [x] \(\operatorname{Hom}_H(H^{2,1}\lvert_H,\rho)\) for every strata subgroup type and every irrep  
- [x] Surviving \((H,\rho)\): genus bounds, orbit size, base-locus contribution  
- [x] Combination with minimal-covariant intersection budget (no contradiction)  
- [x] Theorem boundary: necessary condition, not a contradiction  
- [x] Escalation rule respected (no Hilbert-scheme search)  
- [x] Headline OPEN  
