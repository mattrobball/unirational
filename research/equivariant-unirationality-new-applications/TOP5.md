# Top five candidates: exact obstruction tests

## 1. Smooth quartic double solid with \((C_7\rtimes C_3)\times C_2\)

### Action

The equation and generators are recorded in `THEOREM_KLEIN_QUARTIC_DOUBLE_SOLID.md`.

### Subgroup configuration

Use the central deck involution \(\tau\). Its residual group on the fixed K3 surface is

\[
G/\langle\tau\rangle=C_7\rtimes C_3.
\]

### Fixed geometry

\[
X^\tau=B\text{ is a smooth K3 surface},
\qquad
X^G=\varnothing.
\]

The normal-subgroup/PGL2 argument proves that \(B\) has no residual-stable rational curve.

### Obstruction status

```text
residual-RCC fixed-locus hypothesis  PROVED
X^G=empty                           PROVED
Condition (A)                       PROVED
universal torsor obstruction        ZERO
all higher Amitsur groups           ZERO
```

### Outcome

Closed in this packet: not weakly versal and not \(G\)-unirational.

---

## 2. Odd exceptional conic bundles with \(D_{2g}\times C_2\)

### Action

Use the minimal resolution of

\[
T_0T_1(T_0^{2g}+T_1^{2g})+T_2T_3=0
\subset\mathbf P(1,1,g+1,g+1),
\]

with the dihedral base action and the central swap \(j:T_2\leftrightarrow T_3\).

### Subgroup configuration

Use \(j\in Z(G_g)\). The full residual group is \(D_{2g}\).

### Fixed geometry

\[
S_g^j=C_g,\qquad g(C_g)=g,
\qquad S_g^{G_g}=\varnothing.
\]

### Obstruction status

```text
central fixed curve has no rational component  PROVED
full fixed locus empty                         PROVED
Condition (A)                                  PROVED
```

### Outcome

Closed in this packet for every odd \(g\ge3\): the rational conic bundle is not weakly versal and not equivariantly unirational.

---

## 3. Fermat-discriminant Fano threefold No. 2.18

### Action

Abe studies the rational Fano threefold that is a double cover

\[
X_F\longrightarrow\mathbf P^1\times\mathbf P^2
\]

branched over a smooth divisor of bidegree \((2,2)\). In the conic-bundle presentation the defining net can be taken as

\[
Q_1=ix^2+y^2,\qquad Q_2=z^2,\qquad Q_3=ix^2-y^2,
\]

whose discriminant is the Fermat quartic

\[
\Delta_F=\{x^4+y^4+z^4=0\}\subset\mathbf P^2.
\]

The resulting automorphism group has order \(192\).

### Promising subgroup configuration

There are two routes.

1. Use the central covering involution \(\tau\), then analyze the residual group on the fixed branch surface.
2. Select a nondeck involution \(\sigma\) whose image in \(\operatorname{Aut}(\Delta_F)\) has a large centralizer, and test \(X_F^{C_G(\sigma)}\).

### Fixed geometry

The deck-fixed locus is the branch surface, a degree-2 del Pezzo surface and hence rational. Therefore the one-stratum central theorem does **not** apply: the whole fixed surface is an allowed residual-stable RCC image.

### Exact missing work

```text
(a) enumerate involution classes in Aut(X_F);
(b) compute X_F^sigma and C_G(sigma);
(c) classify C_G(sigma)-stable rational curves on the deck-fixed surface;
(d) compute normal characters at intersections of those curves;
(e) prove a connected exceptional-fiber/network propagation theorem.
```

This is a finite computation after the three-dimensional network theorem is formulated. It is the best unresolved target because the variety is rational, the action is explicit, and current linearizability results do not decide equivariant unirationality.

---

## 4. Mukai–Umemura \(V_{22}\) with the icosahedral \(A_5\)

### Action

The Mukai–Umemura threefold is the distinguished prime Fano threefold of genus \(12\) with

\[
\operatorname{Aut}(X)=\operatorname{PGL}_2.
\]

Let \(G=A_5\subset\operatorname{PGL}_2\) be the icosahedral subgroup. This is an exact intrinsic action; no coordinate choice is needed.

### Promising subgroup configuration

Choose an involution \(\sigma\in A_5\). Then

\[
C_{A_5}(\sigma)=V_4.
\]

This is the closest available analogue of the successful \(V_{14}\) centralizer configuration.

### Fixed geometry and missing calculation

The \(\operatorname{SL}_2\)-orbit compactification gives a representation-theoretic route to \(X^\sigma\), but the audit found no published scheme-theoretic table of the involution and \(V_4\) fixed loci suitable for the obstruction. The finite target is:

```text
compute X^sigma, its component genera, and X^V4.
```

If \(X^\sigma\) is a positive-genus curve plus points and \(X^{V_4}=\varnothing\), the repository's \(V_{14}\) theorem applies verbatim. If rational curves occur, the residual-RCC refinement applies after classifying \(V_4\)-stable curves.

### Boundary

No theorem deciding \(A_5\)-unirationality or weak versality of this action was found. Ordinary rationality is available from the classical genus-12 geometry. The literature status remains `LITERATURE-STATUS-UNCERTAIN` because the fixed-locus computation has not yet been extracted from the orbit model.

---

## 5. Kummer double solid \(X_1\) with a non-Q8 test subgroup

### Action

Let

\[
X_1=\{w^2=x_1^4+x_2^4+x_3^4+x_4^4-4i x_1x_2x_3x_4\}
\subset\mathbf P(2,1,1,1,1),
\]

and let \(\widetilde X_1\) be the blowup of its \(16\) nodes. The known automorphism group is

\[
C_2^{\rm deck}\times(C_4^2\rtimes S_4).
\]

Take the specific subgroup

\[
G_0=C_2^{\rm deck}\times(C_4^2\rtimes C_3),
\]

where \(C_3\subset S_4\) is generated by a 3-cycle. Its 2-Sylow is abelian, so it contains none of the Q8 subgroups responsible for the known nonzero third Amitsur group.

### Promising subgroup configuration

Use the central deck involution. Its fixed locus on the smooth model is the resolved Kummer K3 surface, containing the classical \(16_6\) node/trope configuration of rational curves.

### Why the simple theorem fails

The fixed K3 surface contains many rational curves. Unlike the smooth quartic in rank 1, these curves are not incidental: the residual group acts on a distinguished finite configuration of 32 curves. A residual-stable curve or stable union may receive the RCC source survivor.

### Exact finite target

```text
(a) verify Condition (A) for G0;
(b) compute the G0-orbits and stabilizers of the 16 exceptional and 16 trope curves;
(c) decide whether any irreducible rational curve is G0-stable;
(d) compute intersections and normal characters for stable unions;
(e) test X^G0.
```

The 2026 higher-Amitsur theorem already excludes the Q8-containing actions. The subgroup above is selected precisely because that obstruction is silent. The fixed-curve permutation calculation is the smallest honest test of whether the geometric method adds a new Kummer case.

## Final ordering

The first two candidates are theorems. Among unresolved cases, the order is:

1. Fermat-discriminant No. 2.18;
2. Mukai–Umemura \((V_{22},A_5)\);
3. the non-Q8 Kummer subgroup \((\widetilde X_1,G_0)\).

The No. 2.18 case is the best target for developing the missing three-dimensional exceptional-network theorem; the Mukai–Umemura case is the best target for a small direct centralizer computation.
