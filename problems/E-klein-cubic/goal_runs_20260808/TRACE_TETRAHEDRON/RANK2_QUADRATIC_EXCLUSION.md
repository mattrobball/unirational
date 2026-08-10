# Rational rank-two quadratic landing exclusion

**Date:** 2026-08-08  
**Result:** `F55-TRACE-RATIONAL-RANK2-QUADRATIC-LANDING-EXCLUSION`

Let `V_Q` be the four-dimensional sum-zero cyclic representation of
`C_5=<sigma>`, and let

\[
 \mathcal K(Q)=\sum_{i=0}^4 Q_i^2Q_{i+1},
 \qquad Q_i=\sigma^iQ.
\tag{0.1}
\]

This note proves the exact universal statement needed by the planar circuit
reduction:

> If `Q` is a nonzero rational quadratic form of rank two on `V_Q`, then
> `mathcal K(Q)` is not the zero polynomial.

No lattice supports or collision hyperplanes are enumerated.

## 1. Factor lines and the cyclic branch

Over `Qbar`, write

\[
 Q=\ell m                                                   \tag{1.1}
\]

with two distinct nonzero linear-factor lines.  Call a linear form cyclic if
its five `sigma`-translates span `V^*`; equivalently, all four of its Fourier
components are nonzero.

Suppose first that `ell` is cyclic.  Put `L_i=sigma^i ell`.  Then
`L_0,...,L_3` are coordinates and

\[
 L_4=-(L_0+L_1+L_2+L_3).
\]

There are unique `a_0,...,a_3` with

\[
 m=\sum_{k=0}^3a_kL_k,
 \qquad
 M_i=\sigma^im=\sum_{k=0}^3a_kL_{i+k},                 \tag{1.2}
\]

where indices on `L` are modulo five.  Write `x,y` for independent
variables.  On the slice

\[
 (L_0,L_1,L_2,L_3,L_4)=(x,y,0,-x-y,0),
\]

the landing polynomial

\[
 \mathcal L=\sum_i(L_iM_i)^2(L_{i+1}M_{i+1})             \tag{1.3}
\]

factors exactly as

\[
 \mathcal L=x^2y\big((a_0-a_3)x+(a_1-a_3)y\big)^2
 \big(-a_2x+(a_0-a_2)y\big).                            \tag{1.4}
\]

Since `Qbar[x,y]` is a domain, either

\[
 \text{(I) }a_0=a_2=0,
 \qquad\text{or}\qquad
 \text{(II) }a_0=a_1=a_3.                               \tag{1.5}
\]

Now use the slice `(L_0,...,L_4)=(x,y,-x-y,0,0)`.  In case
(I), (1.3) becomes

\[
 -a_1^2xy^2(x+y)\big(a_1xy+a_3(x+y)^2\big),              \tag{1.6}
\]

so `a_1=0`.  In case (II), write `t=a_0=a_1=a_3` and
`u=a_2`; then (1.3) becomes

\[
 -t x^2y(x+y)
 \big((t-u)^2x(x+y)-t^2y^2\big),                         \tag{1.7}
\]

so `t=0`.  Thus only `a_3` can remain in case (I), and only `a_2=u`
can remain in case (II).  Finally,

\[
\begin{array}{c|c}
(L_0,\ldots,L_4)&\mathcal L\\ \hline
(1,1,0,1,-3)&-3a_3^3\quad\text{in case (I)},\\
(1,1,1,-3,0)&-3a_2^3\quad\text{in case (II)}.
\end{array}                                                \tag{1.8}
\]

Both remaining coefficients vanish, so `m=0`, a contradiction.  The same
argument applies if `m` rather than `ell` is cyclic.

This proof uses four exact evaluations of one universal normal form.  The
companion script `derive_rank2_quadratic_landing.py` also expands all 80
coefficients and supplies an independent four-parameter Groebner audit, but
that calculation is not needed for the proof.

## 2. Absolute-Galois support lemma

It remains to treat the case in which neither factor is cyclic.  Put
`F=Q(zeta_5)` and decompose

\[
 V_{\overline{\mathbf Q}}^*=V_1^*\oplus V_2^*\oplus V_3^*\oplus V_4^*,
 \qquad \sigma|_{V_q^*}=\zeta^q.
\]

For a factor line `[r]` over `Qbar`, let

\[
 S(r)=\{q:\operatorname{pr}_{V_q^*}(r)\ne0\}.            \tag{2.1}
\]

This zero-pattern is independent of the representative of the line.  If
`gamma in Gal(Qbar/Q)` restricts on `F` by `zeta -> zeta^e`, then

\[
 S(\gamma r)=eS(r)\pmod5.                                \tag{2.2}
\]

Choose `tau in Gal(Qbar/Q)` above `zeta -> zeta^2`.

* If `tau` fixes a factor line, (2.2) makes its support invariant under
  `q -> 2q`.  This permutation is transitive on `{1,2,3,4}`, so a nonzero
  fixed factor has full Fourier support and is cyclic.
* If `tau` swaps the two factor lines, `tau^2` fixes each.  Its restriction
  is `zeta -> zeta^4`, so each support is invariant under `q -> -q`.  Under
  the standing assumption that neither factor is cyclic, each nonempty
  support is therefore exactly one of

  \[
   \{1,4\},\qquad\{2,3\}.                                \tag{2.3}
  \]

  Moreover `tau` interchanges these two pairs, so the two factors have the
  two opposite supports.

For completeness, this does not assume that a factor field is contained in
`F`.  The absolute Galois group permutes the two factor lines, giving a
homomorphism to `S_2`; let `K` be the fixed field of its kernel.  Then
`[K:Q]<=2`.  If `K intersect F=Q`, linear disjointness supplies a lift of
`zeta -> zeta^2` which fixes `K`, hence fixes both lines, and the first bullet
forces full support.  Otherwise `K` is the unique quadratic subfield
`F^+=Q(sqrt(5))` of `F`.  Every lift of `zeta -> zeta^2` then acts
nontrivially on `K` and swaps the lines, while its square fixes them.  The
second bullet applies.  Only factor-line permutations and Fourier
zero-patterns are used; no choice of factor coefficients inside `F` is made.

Consequently the only possible neither-cyclic case, after swapping factors,
is

\[
 \ell=ax_1+bx_4,\qquad m=cx_2+dx_3,
 \qquad abcd\ne0.                                       \tag{2.4}
\]

## 3. Four explicit spectral witnesses

For (2.4), set

\[
 L_i=a\zeta^ix_1+b\zeta^{4i}x_4,
 \qquad
 M_i=c\zeta^{2i}x_2+d\zeta^{3i}x_3.
\]

Exact collection in `Q(zeta_5)` shows that (1.3) has precisely four
monomials, with coefficients

\[
\begin{array}{c|l}
(x_1,x_2,x_3,x_4)\text{-powers}&\text{coefficient}\\ \hline
(3,2,1,0)&5a^3c^2d(\zeta^3-\zeta^2-\zeta-1),\\
(2,0,3,1)&-5a^2bd^3(2\zeta^3+\zeta^2+2\zeta+2),\\
(1,3,0,2)&5ab^2c^3\zeta(\zeta^2+2),\\
(0,1,2,3)&5b^3cd^2\zeta(2\zeta+1).
\end{array}                                               \tag{3.1}
\]

Each displayed cyclotomic factor is coprime to
`Phi_5=Z^4+Z^3+Z^2+Z+1`, hence nonzero in `Q(zeta_5)`.  Since
`abcd ne 0`, none of the four coefficients vanishes.  This contradicts
`mathcal K(Q)=0` and completes the rank-two exclusion.

## 4. Scope

The theorem excludes every rational rank-two quadratic form, not just those
arising from a bounded exponent box.  In `PLANAR_CIRCUIT_REDUCTION.md`, the
last convex-quadrilateral branch produces exactly such a nonzero rational
rank-two circuit moment.  It is therefore empty.

```text
F55-TRACE-RATIONAL-RANK2-QUADRATIC-LANDING-EXCLUSION
```
