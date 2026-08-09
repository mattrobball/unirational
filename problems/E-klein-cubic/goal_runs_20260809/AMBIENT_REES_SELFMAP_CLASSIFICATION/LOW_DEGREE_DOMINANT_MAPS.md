# Low-degree ambient landing obstruction through degree 21

**Date:** 2026-08-09  
**Field:** \(\mathbf C\)  
**Good prime:** \(67\)  
**Exit:** `AMBIENT-LANDING-COORDINATE-DEGREE-AT-LEAST-22`

## Theorem

Let

\[
P=(P_0,\ldots,P_4)\in
\left(\operatorname{Sym}^d W_5^\vee\otimes W_5\right)^G
\]

be a nonzero homogeneous \(G\)-covariant tuple satisfying the global Klein
landing identity

\[
F(P)=0.
\]

Then

\[
\boxed{d\ge 22.}
\]

In fact there is no nonzero landing tuple in any degree \(d\le21\), whether or
not its induced rational map is dominant. Consequently every dominant
\(G\)-equivariant ambient landing map

\[
\mathbf P(W_5)\dashrightarrow X
\]

has ambient coordinate degree at least \(22\).

The previously sealed certificates exclude degrees \(1,\ldots,14\). The new
calculation below excludes degrees \(15,\ldots,21\).

## 1. Forced plus-plane reduction

Fix an involution \(t\) and write

\[
W_5=W_+(t)\oplus W_-(t),
\qquad \dim W_+=3,\quad \dim W_-=2.
\]

The accepted ambient landing theorem gives

\[
P|_{W_+(t)}=0
\]

for every landing tuple. Thus in degree \(d\) every candidate lies in the
kernel

\[
K_d=\ker\!\left[
\left(\operatorname{Sym}^d W_5^\vee\otimes W_5\right)^G
\longrightarrow
\operatorname{Sym}^d W_+(t)^\vee\otimes W_5
\right].
\tag{1.1}
\]

This is a theorem-forced linear reduction before imposing the nonlinear
equation \(F(P)=0\).

## 2. Exact good-reduction calculation

Use the split prime

\[
67\equiv1\pmod {11},
\qquad 67\nmid |G|=660,
\]

with \(\zeta_{11}=64\in\mathbf F_{67}\). The exact Weil matrices reduce to the
full \(660\)-element group, and Reynolds averaging is exact. The dimensions of
the covariant spaces agree with the characteristic-zero Molien dimensions.

The restriction kernels and landing-equation ranks are:

| \(d\) | covariant dimension | \(\dim K_d\) | independent cubic coefficient equations | degree-four Macaulay rank |
|---:|---:|---:|---:|---:|
| 15 | 32 | 0 | — | — |
| 16 | 41 | 0 | — | — |
| 17 | 49 | 2 | \(4/4\) | — |
| 18 | 59 | 3 | \(10/10\) | — |
| 19 | 73 | 7 | \(84/84\) | — |
| 20 | 86 | 11 | \(169/286\) | \(1001/1001\) |
| 21 | 100 | 16 | \(269/816\) | \(3876/3876\) |

Here a denominator in the last two columns is the full dimension of the
corresponding coefficient space.

For \(d=15,16\), the forced restriction kernel is zero.

For \(d=17,18,19\), write a general element of \(K_d\) as

\[
P(a)=\sum_{j=1}^{k_d}a_j C_j.
\]

The coefficients of \(F(P(a))\) span all of

\[
\operatorname{Sym}^3(\mathbf F_{67}^{k_d})^\vee.
\]

Hence the homogeneous landing ideal contains every cubic in the coefficient
variables, and its projective zero locus is empty.

For \(d=20,21\), the cubic equations do not span the entire cubic coefficient
space. Multiplying them by all coefficient variables gives the degree-four
Macaulay space. The resulting ranks are

\[
1001=\dim\operatorname{Sym}^4(\mathbf F_{67}^{11})^\vee
\]

and

\[
3876=\dim\operatorname{Sym}^4(\mathbf F_{67}^{16})^\vee.
\]

Thus the landing ideal contains the entire degree-four piece in both cases.
Equivalently it contains the fourth power of the irrelevant ideal, so its
projective zero locus is empty.

## 3. Characteristic-zero consequence

Suppose a characteristic-zero landing tuple existed in one of these degrees.
Choose the cyclotomic integral lattice at a prime over \(67\) and regard its
coefficient vector projectively. After finite base extension, properness of
projective space gives a nonzero special-fibre coefficient vector.

Equivariance, the forced plus-plane restriction, and the polynomial identity
\(F(P)=0\) all specialize. Exact Reynolds averaging and the matching Molien
dimensions identify the special fibre with the spaces used above. This would
produce a point of one of the empty projective landing loci, a contradiction.

Therefore degrees \(15,\ldots,21\) are excluded in characteristic zero.
Combined with the sealed degree-\(\le14\) result,

\[
\boxed{\text{no nonzero homogeneous ambient landing tuple has degree }\le21.}
\]

## 4. Scope

This is a bounded theorem, not an all-degree emptiness theorem. It does,
however, move the first possible ambient landing degree from \(15\) to \(22\)
and applies to every ambient landing tuple, not only retractions or tuples with
a prescribed fixed-network profile.

The next raw coordinate degree is \(22\). No claim about degree \(22\) is made
here.

## Replay

```text
python3 verify_low_degree_dominant_maps.py
```

The dense degree-four ranks use `numba`; all arithmetic is exact modulo \(67\).

Terminal markers:

```text
LANDING_COVARIANTS_DEGREES_15_THROUGH_21_EXCLUDED
INVARIANT_PLUS_PLANE_RESTRICTION_INJECTIVE_THROUGH_DEGREE_22
DOMINANT_MAP_LOW_DEGREE_CERTIFICATE_OK
```
