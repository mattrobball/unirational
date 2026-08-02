# Packet L1 — full finite polar recursion

**Exit:** `L1-FULL-RANGE-PASS`  
**Pinned base:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`  
**Problem E headline:** **OPEN**

## 1. Scope

The historical WP-L1 certificate proves the exact symmetric polarization of the
Klein cubic and writes the first two nonautomatic normal equations, at orders
`3m+1` and `3m+3`.  Its sealed ledger stops there.  This packet supplies the
missing finite completion for a degree-`d` covariant jet: every coefficient of
`F(p)` from normal order `3m` through the terminal order `3d` is now covered.

Historical sealed artifacts under `certificates/lifting/` are left byte-identical.
This packet extends their range; it does not rewrite them or invalidate packets
that recorded their hashes.

## 2. Exact polarization

Write

\[
F(x)=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}.
\]

Its symmetric trilinear polarization, normalized by
\(\Phi(x,x,x)=F(x)\), is

\[
\Phi(u,v,w)=\frac13\sum_i
\bigl(u_iv_iw_{i+1}+u_iw_iv_{i+1}+v_iw_iu_{i+1}\bigr).
\]

The producer and verifier independently compare this formula with
inclusion–exclusion on all 125 triples of standard basis vectors over
\(\mathbf Q\).  Put

\[
B(z;y_1,y_2)=3\Phi(z,y_1,y_2).
\]

For the involution normal decomposition used in WP-L1,

\[
F(z+y)=F_+(z)+B(z;y,y),
\]

so terms containing one or three \(E_-\)-arguments vanish.

## 3. Complete coefficient formula

Let `m` be odd, let `d >= m`, and write

\[
p(t)=\sum_{r=m}^{d}p_rt^r,
\qquad
p_{m+s}\in
\begin{cases}
E_-,&s\text{ even},\\
E_+,&s\text{ odd}.
\end{cases}
\]

Set

\[
q=d-m,
\qquad
N=3m+\delta,
\qquad
0\leq\delta\leq3q.
\]

Then

\[
C_\delta:=[t^{3m+\delta}]F(p(t))
 =\sum_{\substack{s_1+s_2+s_3=\delta\\0\le s_i\le q}}
 \Phi\bigl(p_{m+s_1},p_{m+s_2},p_{m+s_3}\bigr),
\]

where the displayed sum is over ordered triples.  Equivalently, one may sum
over

\[
0\leq s_1\leq s_2\leq s_3\leq q
\]

with multiplicity `1`, `3`, or `6` according to the number of distinct
permutations.  The packet verifies the ordered/sorted equality exhaustively
for `0 <= q <= 24`; the equality itself is purely combinatorial.

Since `3m` is odd and `F(p(t))` is even in `t`, every even `delta` gives the
automatic identity `C_delta=0`.  Only odd `delta` produce equations.

## 4. Isolable correction range

Suppose `delta` is odd and `1 <= delta <= q`.  Among all sorted triples
summing to `delta`, the only triple involving the as-yet-new coefficient
`p_{m+delta}` is

\[
(0,0,\delta).
\]

Its multiplicity is three, and its contribution is

\[
3\Phi(a_m,a_m,b_{m+\delta})
 =B(b_{m+\delta};a_m,a_m).
\]

Every other term uses offsets strictly smaller than `delta`.  Thus the complete
recursive equation is

\[
L_\delta(b_{m+\delta})=-R_\delta,
\qquad
L_\delta(u)=B(u;a_m,a_m),
\]

and the obstruction class is

\[
\omega_\delta=[R_\delta]\in\operatorname{coker}(L_\delta).
\]

The polar *type* of the isolation operator therefore never changes: each
available odd correction is governed by the same contraction
`B(-;a_m,a_m)`, acting on the appropriate normal-order jet module.  Even-offset
coefficients `a_{m+2j}` have no separate isolation equation; they are relative
parameters that enter later residuals.

The first two stages reproduce the work-order formulas exactly:

\[
B(b_{m+1};a_m,a_m)=0,
\]

and

\[
B(b_{m+3};a_m,a_m)
+2B(b_{m+1};a_m,a_{m+2})
+F_+(b_{m+1})=0.
\]

## 5. Terminal compatibility tail

The earlier packet did not distinguish recursive equations from the finite tail.
Once `delta > q`, the formal coefficient `p_{m+delta}` does not exist in a
degree-`d` map.  Hence an odd stage

\[
q<\delta\leq3q
\]

cannot be solved by introducing another jet.  It is instead the terminal
compatibility equation

\[
T_\delta=C_\delta=0,
\]

formed entirely from the already existing coefficients
\(p_m,\ldots,p_d\).

This tail is logically necessary.  Solving every available isolation equation
through normal order `d` does **not** by itself prove `F(p)=0`; all terminal
compatibilities through `3d` must also vanish.

## 6. Completeness theorem

For every odd `m` and every `d >= m`, the following are equivalent:

1. `F(p)=0` coefficientwise in the normal parameter;
2. every odd-offset isolation equation with `1 <= delta <= d-m` holds, and
   every odd-offset terminal compatibility equation with
   `d-m < delta <= 3(d-m)` holds.

There are no equations outside this finite range, because a cubic in a
polynomial jet of degree `d` has normal degree at most `3d`.

The independent verifier reconstructs the entire ledger for all
`0 <= d-m <= 40` and `m in {1,3,5,9}`, verifies the unique isolator at every
recursive stage, verifies the absence of a new coefficient in every terminal
stage, and replays sealed regression cases including `(m,d)=(1,7)`, `(1,13)`,
`(3,19)`, and `(5,35)`.

## 7. Incidence and theorem boundary

The recurrence is a statement about normal jets on the exceptional normal
cone.  It preserves the corrected distinction among:

- the source fixed line;
- the exceptional normal-direction factor;
- the target fixed line.

The separate source-line condition remains a condition on the terminal
coefficient `p_d(0,y)`; it is not substituted for any normal-cone equation.

This packet proves a complete **formal landing-equation ledger**.  It does not
prove that any global survivor family satisfies the equations, that any
obstruction class vanishes, that a formal lift algebraizes, or that a landing
covariant exists.  Consequently it does not decide the Problem E headline.

## 8. CAS statement

No external CAS is required or used.  The certificate uses only exact rational
arithmetic (`fractions.Fraction`) and exhaustive finite combinatorics in the
Python standard library.  There are no conclusions conditional on Sage,
Magma, Singular, Macaulay2, GAP, or a modular computation.
