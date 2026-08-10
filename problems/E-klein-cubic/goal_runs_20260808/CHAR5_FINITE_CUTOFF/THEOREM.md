# Characteristic-five finite-generator and differential-cutoff audit

**Date:** 2026-08-08  
**Status:** `FROBENIUS COUNTERTOWER / NO DIFFERENTIAL CUTOFF / LANDING CUTOFF OPEN`

Let `k` be algebraically closed of characteristic five and let

\[
 H=C_{11}\rtimes C_5
 =\langle s,t\mid s^{11}=t^5=1,\ tst^{-1}=s^5\rangle .
\]

On the faithful irreducible five-space use the weight and shift conventions

\[
 (w_0,\ldots,w_4)=(1,9,4,3,5),\qquad
 se_i=\zeta^{w_i}e_i,\qquad te_i=e_{i+1}.
\]

Indices below are modulo five.  This packet decides one proposed finite
target and records the exact boundary of what it decides.

## 1. The `H`-specific Frobenius countertower

For every integer `n>=1`, put `D_n=5^n` and define

\[
 \Phi_n:\mathbb A^5\longrightarrow\mathbb A^5,
 \qquad (\Phi_n)_i=x_{i+n}^{D_n}.                    \tag{1.1}
\]

### Theorem 1.1

Every `Phi_n` is a nonzero homogeneous `H`-self-covariant.  Moreover:

1. `Phi_n` is finite, radicial, and surjective; in particular it is
   dominant and its five coordinate functions are algebraically independent.
2. The five coordinates have gcd one.
3. Its ordinary differential is zero:

   \[
                         d\Phi_n=0.                   \tag{1.2}
   \]

4. Every positive multivariate Hasse derivative of total order strictly
   below `D_n` is zero.  The order-`D_n` derivative in the corresponding
   coordinate direction is one.
5. For the Klein form

   \[
                  K(y)=\sum_i y_i^2y_{i+1},
   \]

   one has

   \[
                     K(\Phi_n(x))=K(x)^{D_n}\ne0.     \tag{1.3}
   \]

Proof.  Since `w_i=9^i mod 11` and `9*5=1 mod 11`,

\[
        w_{i+n}5^n=w_i\pmod {11}.
\]

This proves `C11`-equivariance, while the cyclic indexing proves
`C5`-equivariance.  The coordinate-ring map sends the five target variables
to a permutation of `x_0^(D_n),...,x_4^(D_n)` and is injective and integral.
This proves the first two assertions.  Equation (1.2) follows from
`D_n=0 in k`.  Lucas' theorem gives

\[
             {D_n\choose r}=0\pmod5\qquad(0<r<D_n),
\]

which proves the Hasse assertion.  Finally, the freshman's dream and a
cyclic reindexing give (1.3).  QED.

### Corollary 1.2 (no bounded differential or Hasse target)

For every prescribed positive jet order `J`, choose `n` with `5^n>J`.
Then `Phi_n` satisfies every positive ordinary/Hasse differential equation
of order at most `J` that is satisfied by the zero map.  In particular

\[
             \bigwedge^r d\Phi_n=0\qquad(r\ge1),       \tag{1.4}
\]

although `Phi_n` is dominant.

Thus an exact CAS computation of the schemes cut out by
`wedge^4 dT=0`, by `det(dT)=0`, or by any fixed finite list of Hasse-rank
conditions cannot prove `ed_k(H)=4`.  Those schemes contain dominant false
positives in the unbounded degrees `5^n`.  This is an obstruction to the
*logical target*, not a resource objection to running the computation.

## 2. An explicit finite `R`-submodule with unbounded jet behavior

There is also an exact invariant-coefficient recurrence inside the actual
`H`-covariant module.  Put

\[
 B_i=x_i^{11}-x_{i+1}^{11},\qquad
 (\Psi_M)_i=B_i^M x_{i+1}^5\quad(M\ge0),              \tag{2.1}
\]

and let `e_j` be the `j`-th elementary symmetric polynomial in
`B_0,...,B_4`.  Each `e_j` is an `H`-invariant: `C11` fixes every eleventh
power and `C5` permutes the five `B_i`.  Also `e_1=sum B_i=0`.
The identity `w_(i+1)5=w_i mod 11` and cyclic indexing show at once that
every `Psi_M` is an `H`-self-covariant.

Every `B_i` satisfies its common characteristic polynomial.  Therefore,
coordinate by coordinate, for `M>=5`,

\[
 \Psi_M=e_1\Psi_{M-1}-e_2\Psi_{M-2}+e_3\Psi_{M-3}
          -e_4\Psi_{M-4}+e_5\Psi_{M-5}.               \tag{2.2}
\]

Thus every member of the infinite family belongs to the five-generated
`R`-submodule

\[
                  R\Psi_0+\cdots+R\Psi_4.             \tag{2.3}
\]

Nevertheless, all `B_i` vanish on every one of the eleven affine lines
fixed by a Sylow `C5`.  Hence every positive Hasse jet of `Psi_M` of order
strictly below `M` vanishes along all eleven lines.  Its coordinate Newton
polytope is a segment, so the segment theorem in
`TRACE_POSITIVE/CHAR5_NORMAL_FAN_ADDENDUM.md` proves that every `Psi_M` is
dominant.  In particular it does not land on the Klein cubic.

Equation (2.2) is an explicit `H`-specific instance of the phenomenon hidden
by abstract finite generation: five fixed module elements, combined with
invariant coefficients, produce arbitrarily high jet vanishing.  It does
not rely on an unknown presentation of the full module.

## 3. What finite generation actually says

Put

\[
 S=k[x_0,\ldots,x_4],\quad R=S^H,\quad
 M=(S\otimes V)^H.
\]

The graded `R`-module `M` is finite.  Fix any finite homogeneous generating
set `c_1,...,c_m`, and put `B=max deg(c_j)`.  If `5^n>B`, graded finite
generation writes

\[
                 \Phi_n=\sum_j a_{n,j}c_j,
 \qquad a_{n,j}\in R_{5^n-\deg(c_j)}.                 \tag{3.1}
\]

Every nonzero coefficient in (3.1) has positive degree, so

\[
                         \Phi_n\in R_+M.               \tag{3.2}
\]

Consequently the finite generator quotient `M/R_+M` does not see the
unbounded Frobenius tower at all.  Applying ordinary or Hasse differentiation
to (3.1) necessarily introduces the arbitrary invariant coefficients and
their derivatives.  The exact vanishing in Theorem 1.1 is produced only
after those terms are assembled.  Checking the generators, their constant
linear combinations, or a bounded coefficient window therefore does not
check all differential-rank conditions in `M`.

This is `H`-specific: the maps (1.1) use the exact relation
`w_(i+n)5^n=w_i` for the faithful `F55` weight orbit.  It is stronger than a
general warning that sums of dominant maps need not be dominant.

## 4. Why this does not refute dominance

In characteristic zero, a polynomial map between equal-dimensional affine
spaces is dominant exactly when its Jacobian determinant is nonzero.  That
equivalence fails in characteristic five.  The maps `Phi_n` are the simplest
possible counterexamples: they are dominant while their complete ordinary
differential is zero.

Accordingly, `wedge^4 dT=0` is not the characteristic-five covariant-dimension
condition.  Dominance must be tested by algebraic independence / function
field transcendence degree, including the purely inseparable part.  A finite
degree computation can do that for one prescribed degree, but Theorem 1.1
gives no all-degree cutoff.

## 5. The separate Klein-landing target

The Frobenius tower does not land on the Klein cubic, by (1.3).  Therefore it
does **not** prove or disprove the existence of a Klein-landing covariant.

Finite generation gives a useful finite *generic-field formulation*.  After
passing to

\[
                       K=k(\mathbf P(V))^H,
\]

generic descent identifies rational self-covariants with a five-dimensional
`K`-space.  In a rational covariant frame the Klein equation becomes one
explicit cubic in five `K`-coordinates: the generic twisted Klein cubic.
This is a finite-type target, and a `K`-point would be headline-positive.

It is not a finite-dimensional coefficient scheme over `k`: the five
coordinates range over the function field `K`, so polynomial numerators and
denominators have unbounded degree.  Finite generation supplies coordinates
for this rational-point problem, not a bound on the height of a rational
point and not an emptiness certificate.  No representation-specific theorem
bounding a least Klein-landing coordinate is proved here.

The strict conclusions are therefore:

```text
ordinary wedge/determinant cutoff                 REFUTED
any fixed finite Hasse-jet cutoff                 REFUTED
finite-generator/constant-coefficient inference  REFUTED
non-differential dominance degree cutoff          NOT PROVED OR REFUTED
Klein-landing degree cutoff                       NOT PROVED OR REFUTED
ed_k(F55)=4                                       OPEN
Problem E headline                               OPEN
```

## 6. Replay

Run

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/CHAR5_FINITE_CUTOFF/verify.py
```

The terminal markers are

```text
F55-CHAR5-FROBENIUS-COUNTERTOWER-EXACT
F55-CHAR5-NO-FINITE-DIFFERENTIAL-CUTOFF
F55-CHAR5-LANDING-CUTOFF-OPEN
```
