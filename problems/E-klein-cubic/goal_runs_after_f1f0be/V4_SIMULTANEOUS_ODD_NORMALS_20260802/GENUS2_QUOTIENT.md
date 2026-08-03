# Genus-two quotient of the nondegenerate trisection stratum

**Exit:** `V4-TRISECTION-GENUS2-QUOTIENT-PASS`  
**Problem E headline:** **OPEN**

This note sharpens Section 3 of `THEOREM.md`.  It computes the two character-surface parameters from the exact five-dimensional Weil representation and identifies the complete nondegenerate scalar quotient of the simultaneous order-three normal maps.

## 1. Exact character-surface parameters

For a representative

\[
K=V_4\subset A_4=N_G(K),
\]

write

\[
W=A\oplus B\oplus C\oplus D,
\qquad \dim A=2,\quad \dim B=\dim C=\dim D=1.
\]

Diagonalize the residual `A4/K=C3` action on `A` and cyclically order the three nontrivial `K`-character lines.  Restricting the Klein cubic to either residual-character hyperplane and normalizing it to

\[
S_\kappa:\qquad
\kappa w^3+w(u_0^2+u_1^2+u_2^2)+u_0u_1u_2=0
\]

gives two scale-invariant parameters \(\kappa_+,\kappa_-\).  Exact reconstruction in
\(\mathbf Q(\zeta_{11},\omega)\) yields

\[
\kappa_++\kappa_-=\frac{13}{8},
\qquad
\kappa_+\kappa_-=-\frac12,
\qquad
(\kappa_+-\kappa_-)^2=\frac{297}{64}.
\]

Hence, after ordering,

\[
\boxed{
\kappa_\pm=\frac{13\pm3\sqrt{33}}{16}
}.
\]

In particular,

\[
\kappa_+\ne\kappa_-;
\qquad
\kappa_\pm\ne0,-4.
\]

The exact representation-theoretic reconstruction is replayed by
`verify_kappa_genus2.py`.

## 2. The reciprocal-cover equation

On the nondegenerate common-plane-order-three branch, Section 3 of
`THEOREM.md` gives

\[
\tau+\tau^{-1}
=2+\frac{\kappa_+p^3+\kappa_-q^3}{p^3+q^3}.
\]

Set \(t=p/q\).  The discriminant of the quadratic equation in \(\tau\) is

\[
\begin{aligned}
\Delta(t)
&=\left(2+\frac{\kappa_+t^3+\kappa_-}{t^3+1}\right)^2-4\\
&=\frac{
(\kappa_+t^3+\kappa_-)
((\kappa_++4)t^3+\kappa_-+4)
}{(t^3+1)^2}.
\end{aligned}
\]

Consequently the normalization of the scalar quotient is the hyperelliptic curve

\[
\boxed{
C:\quad
y^2=(\kappa_+t^3+\kappa_-)
((\kappa_++4)t^3+\kappa_-+4).
}
\]

Each cubic factor has three simple roots.  Their resultant is

\[
64(\kappa_+-\kappa_-)^3\ne0.
\]

Thus the branch polynomial has six distinct roots, and \(C\) is a smooth curve of genus two.

## 3. Classification consequence for arbitrary line degree

Let a simultaneous nondegenerate order-three normal family vary over the triple line

\[
T\simeq\mathbf P^1.
\]

Its scalar parameters define a rational map \(T\dashrightarrow C\).  Since \(C\) is proper, this extends to a morphism.  By Riemann--Hurwitz, every morphism

\[
\mathbf P^1\longrightarrow C
\]

is constant because \(g(C)=2\).  Therefore both the character ratio \([p:q]\) and the reciprocal parameter \(\tau\) are constant in every nondegenerate rational line family.

All nonconstant line dependence occurs in the remaining diagonal-scaling directions.  Over the nondegenerate locus these directions form a torus; a nonconstant complete rational curve must therefore meet its toric boundary.  The explicit diagonal-precomposition families in `THEOREM.md` do exactly this: their three scaling forms acquire zeros in a residual-C3 orbit, while the total projective tuple remains primitive.

This gives a precise classification:

> The nondegenerate scalar moduli of simultaneous common-plane-order-three maps are genus two and cannot vary along the triple line.  Positive line degree is possible only through boundary-crossing in the toric scaling compactification.

## 4. Consequence for the proposed resolution-path proof

The genus-two rigidity is genuine, but it is not a contradiction.  The toric boundary contains the rational triangle transitions absent in the degree-two del Pezzo example.  Explicit primitive positive-degree curves cross those boundary strata.  Hence one cannot replace the full local state space by the genus-two quotient and propagate a constant target value along a resolution path.

A negative headline theorem would require a global obstruction to every allowable toric-boundary crossing, or a different mechanism outside this local normal classification.  Neither is proved here.

## Replay

```sh
python3 verify_kappa_genus2.py
```

Expected terminal line:

```text
V4_KAPPA_GENUS2_VERIFY_OK
```
