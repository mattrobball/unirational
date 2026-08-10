# Characteristic-five audit for `F55 = C11 semidirect C5`

**Date:** 2026-08-08  
**Status:** `EXACT REDUCTIONS / DEGREE-5 KLEIN LANDING EMPTY / ED UNDECIDED`  
**Strict verdict:** this route does **not** currently prove
`ed_k(F55)=4`, and it does not produce a three-dimensional compression.

Let `k` be algebraically closed of characteristic five.  The exact result of
the audit is

\[
             2\leq \operatorname {ed}_k(F_{55})\leq 4.
\]

The upper endpoint is equivalent to an all-degree dominance statement for
homogeneous covariants (Theorem 3.1 below).  That statement remains open.
The natural modular shortcuts are ruled out uniformly, and the complete
degree-five covariant landing scheme on the Klein cubic is empty.

## 1. The faithful modular module

Put

\[
 F_{55}=\langle s,t\mid s^{11}=t^5=1,\quad
 t s t^{-1}=s^5\rangle .
\]

Choose a primitive eleventh root `zeta` in `k`, and put

\[
 (w_0,w_1,w_2,w_3,w_4)=(1,9,4,3,5),\qquad w_{i+1}=9w_i\pmod {11}.
\]

Up to reversing the cyclic indexing, the faithful five-space has a basis
`e_0,...,e_4` on which

\[
 s e_i=\zeta^{w_i}e_i,\qquad t e_i=e_{i+1}.
\]

The restriction to `C11` is semisimple, with five distinct weights, and `t`
acts transitively on them.  Hence the module is irreducible and faithful.
Conversely, every faithful representation contains one of the two
five-element orbits of nonzero `C11`-characters, so no faithful linear
representation has dimension below five.

In characteristic five the permutation matrix of `t` satisfies

\[
 X^5-1=(X-1)^5
\]

and has minimal polynomial `(X-1)^5`; it is a single unipotent Jordan block.
This does not make the `F55`-module reducible.

The projective action on `P(V)` is faithful: an element acting by a scalar on
an irreducible faithful module lies in the center, and `Z(F55)=1`.  A faithful
action of a finite constant group is generically free.  Thus

\[
                    \operatorname {ed}_k(F_{55})\leq 4.       \tag{1.1}
\]

The same normalizer argument used in Section 7 shows that `F55` does not
embed in `PGL2(k)`.  The essential-dimension-one criterion therefore gives
the lower bound two.

## 2. Exact homogeneous covariant model

Use point-coordinate weights `(1,9,4,3,5)` and let `rho` cyclically shift the
variables.  A homogeneous self-covariant of degree `d` is exactly

\[
 T_f=(f,\rho f,\rho^2f,\rho^3f,\rho^4f),                 \tag{2.1}
\]

where `f` is an arbitrary degree-`d` polynomial of `C11`-weight one.  There
are no additional equations in (2.1).

Indeed, `C11`-equivariance imposes the weight condition, and `C5`-equivariance
then forces the other four coordinates.  Notice also that any nonzero map
(2.1) is faithful: the linear span of its image is a nonzero `F55`-submodule
of the irreducible target `V`, hence is all of `V`.

## 3. Essential dimension four is an all-covariant theorem

The group has no nontrivial normal five-subgroup, so it is semi-faithful in
the terminology of Loetscher.  Corollary 6 of
*Application of Multihomogeneous Covariants to the Essential Dimension of
Finite Groups* applies in the modular characteristic, and a minimal
covariant can be homogenized on the irreducible module `V`.  Theorem 34 of
that paper gives, because the `k`-center is trivial,

\[
 \operatorname {covdim}_k(F_{55})
   =\operatorname {ed}_k(F_{55})+1.                       \tag{3.1}
\]

Since the identity has covariant dimension five, (2.1) and (3.1) give the
following exact equivalence.

### Theorem 3.1 (exact remaining characteristic-five target)

The following are equivalent.

1. `ed_k(F55)=4`.
2. `covdim_k(F55)=5`.
3. Every nonzero homogeneous polynomial self-covariant `T_f:V -> V` is
   dominant.

Thus a proof about a bounded set of degrees cannot establish the desired
essential-dimension lower bound.  Conversely, one nonzero homogeneous
covariant whose image has dimension at most four would refute (3), and its
projectivization would give a compression of dimension at most three.

## 4. Uniform families which cannot compress

### 4.1 Every monomial covariant is dominant

Let `f=x^u`, where `u=(u_0,...,u_4)` has nonnegative integral entries and
`C11`-weight one.  On the dense torus, the exponent matrix of (2.1) is the
circulant matrix with rows `rho^i u`.  If it had rank below five over `Q`,
the polynomial

\[
                       U(z)=\sum_{j=0}^4u_jz^j
\]

would vanish at a fifth root of unity.  It cannot vanish at `1`, since its
value there is the positive degree of `f`.  If it vanishes at a nontrivial
fifth root, irreducibility of `Phi_5` over `Q` forces

\[
                       u_0=u_1=u_2=u_3=u_4.
\]

But then the `C11`-weight is zero because

\[
                       1+9+4+3+5=0\pmod {11},
\]

contrary to the required weight one.  Hence the exponent matrix has full
rank and the monomial covariant is dominant.  This is an all-degree result.

### 4.2 Every additive polynomial covariant is dominant

An additive polynomial coordinate in characteristic five is a sum of
fifth-power iterates of linear forms.  The `C11` weight condition leaves, for
each exponent `5^e`, exactly one variable.  Consequently every additive
self-covariant has the form

\[
 T_0=\sum_e a_e x_{j(e)}^{5^e},\qquad T_i=\rho^iT_0.      \tag{4.1}
\]

Let `E` be maximal with `a_E != 0`.  The five highest homogeneous parts of
(4.1) are a nonzero scalar times the `5^E`-th powers of the five variables,
in permuted order.  They have no common projective zero.  Hence the kernel
of the additive group homomorphism (4.1) is finite.  Its image has dimension
five, so (4.1) is dominant.

In particular, the forced Frobenius covariant in degree five is not a
compression.  In the indexing used by the verifier it is

\[
                         T_i=x_{i+1}^5.                   \tag{4.2}
\]

These two lemmas eliminate the most natural characteristic-five mechanisms
uniformly; neither is a bounded degree scan.

## 5. The sharp finite checks at the Frobenius boundary

### 5.1 Every covariant of degree below five is dominant

For `d<5`, ordinary differentials detect separable dominance.  The complete
weight-one spaces have dimensions

\[
                    1,1,3,7\quad\text{for }d=1,2,3,4.
\]

For the general member of each space, the verifier expands the Jacobian
determinant.  Its coefficients in the source variables form a homogeneous
ideal in the covariant parameters.  Exact Groebner bases over `F5` give:

| degree | covariant parameters | distinct Jacobian coefficients | affine dimension | quotient length |
|---:|---:|---:|---:|---:|
| 1 | 1 | 1 | 0 | 5 |
| 2 | 1 | 1 | 0 | 5 |
| 3 | 3 | 14 | 0 | 48 |
| 4 | 7 | 69 | 0 | 1186 |

Because each coefficient ideal is homogeneous and zero-dimensional, its
only geometric point is the zero covariant.  Every nonzero covariant in
degrees `1,...,4` therefore has nonzero Jacobian and is dominant.

Replay:

```text
python3 verify_char5_subfrobenius.py
F55-CHAR5-ALL-DEGREE-LT5-COVARIANTS-DOMINANT
```

This boundary is sharp: at degree five the Frobenius covariant (4.2) is
dominant but has zero ordinary Jacobian.

### 5.2 Complete degree-five landing scheme on the Klein cubic

The Klein form in these coordinates is

\[
                         K(y)=\sum_i y_i^2y_{i+1}.         \tag{5.1}
\]

In characteristic five, `k^*` has no element of order five, so the only
projective `C5` character is the trivial one.  Thus there is one complete
degree-five landing scheme, not five.

The weight-one degree-five space has exactly eleven monomials.  Substituting
the general covariant (2.1) into (5.1) and equating all source coefficients
gives 350 nonzero homogeneous cubic equations in eleven parameters.  The
exact Singular result over `F5` is

```text
BASIS_SIZE=11
EQUATION_COUNT=350
GB_SIZE=637
DIM=0
VDIM=555
PROJECTIVE_LANDING_EMPTY=1
F55-CHAR5-DEGREE5-LANDING-EMPTY
```

Since the affine coefficient scheme is a homogeneous zero-dimensional cone,
it is supported only at the origin; the projective landing scheme is empty.
The canonical generated Singular input has SHA-256

```text
5d6ce3b5d178847d19538b52ddf6c1a81deea58900335dd37b7d5c3d5754e0ce
```

Replay:

```text
python3 verify_char5_degree5.py
```

For calibration, (4.2) alone satisfies

\[
                          K(T)=K(x)^5,
\]

so it is visibly not a landing map.  The computation proves that no linear
combination with the other ten degree-five covariants repairs it.

## 6. Torsor normal form and the mixed-prime residue

For a field `K/k`, quotienting an `F55`-torsor by the normal `C11` gives a
`C5`-torsor.  In characteristic five this is an Artin--Schreier algebra

\[
                          L=K[y]/(y^5-y-a).
\]

The fiber is governed by the twist

\[
                          A={}^{L/K}C_{11},                \tag{6.1}
\]

where `Gal(L/K)` acts through the order-five subgroup of
`Aut(C11)=(Z/11)^*`.  Since `k` contains the eleventh roots of unity, `A` is
a finite group of multiplicative type whose character module is the
one-dimensional `F11`-space with this order-five Galois action.

The `11`-essential dimension of (6.1) is one: the splitting extension has
degree five, which is prime to eleven and is invisible to `ed(-;11)`, and
over it `A` becomes split cyclic of order eleven.  This fact does **not**
compute the absolute essential dimension of `A`.

The hypotheses in Loetscher--MacDonald--Meyer--Reichstein that identify
absolute essential dimension with `p`-essential dimension require a
`p`-special base / a `p`-power splitting group.  Here `p=11` but the
splitting group has order five.  This is exactly the excluded mixed-prime
case.

There is also a direct contradiction to the tempting assertion
`ed_K(A)=1`.  A theorem of Fakhruddin says that a finite group scheme of
essential dimension one embeds in `PGL2`.  If (6.1) embedded in `PGL2`, its
geometric `C11` would lie in a one-dimensional torus.  Because `K` contains
`mu_11`, Galois could act on this subgroup only through the Weyl group
`N(T)/T=C2`, i.e. by `+1` or `-1`.  It cannot realize the order-five action
in (6.1).  Hence

\[
                          2\leq \operatorname {ed}_K(A)\leq4.       \tag{6.2}
\]

The upper bound in (6.2) comes from the projectivization of its five-character
orbit representation.  Thus the twisted-kernel fibration does not yield a
four-dimensional lower bound by existing `p`-local theorems; it isolates the
same mixed-prime compression problem.

## 7. What BRV would give, and what is still missing

`F55` has no nontrivial normal five-subgroup, so it is weakly tame at five.
Corollary 3.4(b) of Brosnan--Reichstein--Vistoli therefore gives

\[
 \operatorname {ed}_{L}(F_{55})
       \geq \operatorname {ed}_{k}(F_{55})
\]

for a characteristic-zero field `L` and an algebraically closed
characteristic-five field `k`.  Consequently, a proof that the right side is
four would indeed force the characteristic-zero value to be at least four.

What is missing is precisely Theorem 3.1(3): a uniform proof of dominance
for arbitrary homogeneous covariants, including genuinely multi-orbit
supports at and above the Frobenius degree.  The results in Sections 4 and 5
do not supply such a proof, and no non-dominant covariant was found.

## References

- R. Loetscher, *Application of Multihomogeneous Covariants to the Essential
  Dimension of Finite Groups*, Transform. Groups 15 (2010), arXiv:0811.3852.
- P. Brosnan, Z. Reichstein, A. Vistoli, *Essential Dimension in Mixed
  Characteristic*, Doc. Math. 23 (2018), arXiv:1801.02245.
- R. Loetscher, M. MacDonald, A. Meyer, Z. Reichstein, *Essential
  p-Dimension of Algebraic Tori*, J. Reine Angew. Math. 677 (2013),
  arXiv:0910.5574.
- N. Fakhruddin, *Finite Group Schemes of Essential Dimension One*, Doc.
  Math. 25 (2020), arXiv:1908.02438.

## Strict nonclaims

- No proof of `ed_k(F55)=4`.
- No proof of `ed_k(F55)<=3` and no three-dimensional compression.
- No all-degree covariant dominance theorem.
- No inference from `ed(A;11)=1` to absolute `ed(A)=1`.
- No characteristic-zero verdict from the degree-five modular calculation.

