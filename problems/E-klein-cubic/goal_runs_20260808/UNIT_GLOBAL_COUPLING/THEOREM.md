# Global reciprocity and higher-local boundary for the exact `F55` unit class

**Date:** 2026-08-08  
**Scope:** the complete divisor ledger of the resolvent Kummer class, all
`C5`-eigen projections of that ledger, and arbitrary complete Parshin flags  
**Verdict:** these global/flag constructions do not obstruct the actual class;
the unrestricted trace equation remains open

Keep

\[
 E=\mathbf C(r_0,\ldots,r_4)/(r_0r_1r_2r_3r_4-1),\qquad
 K=E^{\langle\sigma\rangle},\qquad \sigma(r_i)=r_{i+1},
\]

\[
 c=r_2^{-1},\qquad \psi(a)=a^2\sigma(a),\qquad
 \Phi_c(a)=\operatorname {Tr}_{E/K}(c\psi(a)).       \tag{0.1}
\]

At a free orbit, the projective coefficient quotient is detected by

\[
 \rho(x)=\prod_{i=0}^4\sigma^{-i}(x)^{\lambda_i},
 \qquad \lambda=(1,9,4,3,5),                         \tag{0.2}
\]

as in `UNIT_RESIDUE_TOROIDAL`.  The question addressed here is whether
coupling *all* divisor orbits by a product formula, or continuing down a
complete higher-local flag, can distinguish the actual Laurent-unit class
from soluble classes.

## 1. The complete linear reciprocity complex has no mixed transgression

Let `V` be a smooth projective rational `C5`-model of `E`; an equivariant
resolution of a projective toric model is enough.  Since `V` is smooth
projective and rational over `C`,

\[
 \mathcal O(V)^*=\mathbf C^*,\qquad
 \operatorname {Pic}(V)[11]=0.                        \tag{1.1}
\]

Reducing the ordinary divisor sequence modulo eleven therefore gives the
exact sequence

\[
 0\longrightarrow E^*/E^{*11}
 \mathrel{\mathop\longrightarrow}^{\operatorname {div}_{11}}
 \bigoplus_{D\in V^{(1)}}\mathbf F_{11}[D]
 \longrightarrow \operatorname {Pic}(V)/11
 \longrightarrow0.                                   \tag{1.2}
\]

The first arrow is injective because every complex constant is an eleventh
power.  Thus (1.2) is the **complete**, untruncated divisor ledger of a
degree-one Kummer class.  Its only product-formula relation is that the
residue divisor has trivial class in `Pic(V)/11`.  In particular, for every
coefficient `x`,

\[
 [\operatorname {div}(\rho(x))]=0
 \quad\hbox{in }\operatorname {Pic}(V)/11.             \tag{1.3}
\]

There is no second Gersten boundary originating in degree one.  In Milnor
notation the class is in `K_1^M(E)/11`: after taking a divisorial valuation
one lands in `K_0^M/11`, and the next residue group is zero.

The cyclic coupling adds no hidden order-eleven obstruction to (1.2).  Over
`F_11` the group algebra of `C5` is semisimple.  For every character `chi` of
`C5`, the projector

\[
 e_\chi={1\over5}\sum_{j=0}^4\chi(\sigma)^{-j}\sigma^j
                                                               \tag{1.4}
\]

is exact on `F_11[C5]`-modules.  Equivalently,

\[
 H^q(C_5,M)=0\qquad(q>0)                              \tag{1.5}
\]

for every `F_11[C5]`-module `M`.  Applying any eigenspace projector to
(1.2) remains exact.  Hence orbit coupling cannot manufacture a
group-cohomological transgression between the divisor ledger and the Picard
product formula.

### Theorem 1.1 (linear all-orbit reciprocity no-go)

Any order-eleven obstruction obtained by

1. taking the complete collection of divisorial residues of `[rho(x)]`,
2. applying linear `C5` orbit/eigen combinations, and
3. passing to the global divisor-class or product-formula boundary

vanishes for **every** coefficient `x`.  In particular it vanishes both for
the actual coefficient `r_2^-1` and for the globally soluble coefficient

\[
 c_d={\prod_i(r_i-r_{i+1})
       \over (r_0-r_1)^3(r_1-r_2)^2}.                  \tag{1.6}
\]

This is stronger than failure on a fixed finite fan: (1.2) already contains
all prime divisors on the selected complete model.  It is deliberately
limited to **linear degree-one Kummer reciprocity**.  It does not say that
the two complete labelled divisors are equal, and it does not exclude a
nonlinear invariant retaining the additive trace equation.

For reference, the actual resolvent is the Laurent character

\[
 \rho(c)=r_2^{-1}r_1^{-9}r_0^{-4}r_4^{-3}r_3^{-5}.     \tag{1.7}
\]

Its boundary divisor and the interior divisor of `rho(c_d)` are visibly
different.  The point is that both are principal cycles, so every genuine
Picard/product-formula output in Theorem 1.1 is zero.  Merely summing more
prime-orbit residues cannot turn this placement difference into a
reciprocity obstruction.

## 2. An explicit full-decomposition interior place is soluble

Let

\[
 H=F_{55}=C_{11}\rtimes C_5
\]

act on its five-dimensional irreducible representation `W`, and let

\[
 X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
 \subset\mathbf P(W)                                  \tag{2.1}
\]

be the Klein cubic.  The action of `H` on `X` is faithful.  Since `H` is
finite, it is generically free: the union of the fixed loci of the finitely
many nonidentity elements is a proper closed subset of `X`.

Consider the generic projective representation torsor

\[
 \mathbf C(\mathbf P(W))/\mathbf C(\mathbf P(W))^H.    \tag{2.2}
\]

The invariant prime divisor `X` gives a divisorial valuation downstairs.
Its decomposition group is all of `H`, because `X` is `H`-invariant.  Its
inertia is trivial, because inertia is the kernel of the action on
`C(X)` and the action on `X` is faithful.  Its residue torsor is therefore

\[
 \mathbf C(X)/\mathbf C(X)^H,                         \tag{2.3}
\]

a genuine unramified full-`H` torsor over a transcendence-degree-three
field.

The twist of `X` by (2.3) has a rational point.  Indeed, a point of that
twist is the same as an `H`-equivariant rational map from the torsor to `X`,
and the generic-point map

\[
 \operatorname {Spec}\mathbf C(X)\longrightarrow X    \tag{2.4}
\]

is such a map.  Smooth Hensel lifting then gives a point over the completion
at the divisor below `X`.

The generic point of `X` has every coordinate nonzero, so this is an
**interior** divisor for the `C11`-quotient torus, not a coordinate-boundary
place.

### Theorem 2.1 (full-decomposition counterplace)

There exists an interior divisorial place of the generic `F55` projective
torsor which is unramified, has full decomposition group `F55`, and whose
residue Klein twist has a rational point.  Thus

```text
unramified + interior + full F55 decomposition
```

is only the exact *possible bad-place type* from
`TRACE_LOCAL_PLACE_CLASSIFICATION`; it is not itself a pointlessness
criterion.

This counterplace is intrinsic: it is the divisor defined by the target
Klein cubic inside the generic linear source.  It uses no bounded support or
degree search.

## 3. Every complete higher-local flag over `C` is soluble

Put

\[
 F_n=\mathbf C((t_1))\cdots((t_n)),\qquad n\ge0,       \tag{3.1}
\]

with any fixed order of iteration.  Let `T/F_n` be an arbitrary `H`-torsor
and let `X_T` be the corresponding twist of the Klein cubic.

### Theorem 3.1 (iterated-Henselian solubility)

For every `n>=0` and every `H`-torsor `T/F_n`,

\[
 X_T(F_n)\ne\varnothing.                              \tag{3.2}
\]

### Proof

Induct on `n`.  The assertion for `n=0` is immediate because `C` is
algebraically closed.

Let `F_n=F_{n-1}((t_n))`, and let `D subset H` be the image of the twisting
cocycle.  Every proper subgroup of `H` is, up to conjugacy,

\[
 1,\qquad C_{11},\qquad C_5,                           \tag{3.3}
\]

and each fixes a complex point of `X`: a coordinate vertex for `C11`, and
one of the four Fourier points

\[
 p_j=(\epsilon^{ij})_{i=0}^4,\qquad j=1,2,3,4,        \tag{3.4}
\]

for `C5`.  Hence `D!=H` immediately gives an `F_n`-point on the twist.

Suppose `D=H`.  The field has residue characteristic zero, so inertia is
tame and cyclic.  Its image `I` is normal in `H`.  Moreover the residue
field contains every root of unity, so tame conjugation on `I` is trivial;
thus `I` lies in the center of `H`.  But

\[
 Z(H)=1,                                                \tag{3.5}
\]

and therefore `I=1`.  The torsor is unramified and descends to an
`H`-torsor over `F_(n-1)`.  Twisting the smooth proper cubic commutes with
reduction.  The induction hypothesis gives a point on the special fibre,
and smooth Hensel lifting gives (3.2).  QED.

A complete regular Parshin flag on a smooth complex fourfold has iterated
completed fraction field of the form (3.1).  Consequently every
specialization of the exact twist to every such complete flag has a point.
This includes flags passing through full-decomposition interior divisors:
full decomposition simply remains unramified and descends until either a
proper decomposition group occurs or the algebraically closed terminal
residue is reached.

### Corollary 3.2 (higher-local reciprocity no-go)

No pointlessness proof can be obtained by exhibiting anisotropy over one
complete Parshin-flag completion of a complex model.  In particular,
iterating valuations below the unresolved interior residue cubic does not
force a bad terminal form: every resulting higher-local twist is soluble.

This does not prove a Hasse principle.  A variety can be soluble at every
flag completion and still lack a point over its global function field.
What remains could therefore be a genuinely global higher-dimensional
failure, or a nonlinear semilinear-descent obstruction not determined by
degree-one Kummer residues.

## 4. Exact boundary

The proved conclusions are

```text
ALL-PRIME-LINEAR-KUMMER-RECIPROCITY-COMPLEX-EXACT
C5-EIGEN-COUPLING-HAS-NO-ORDER11-TRANSGRESSION
FULL-F55-UNRAMIFIED-INTERIOR-RESIDUE-PLACE-CAN-BE-SOLUBLE
EVERY-COMPLETE-COMPLEX-PARSHIN-FLAG-TWIST-IS-SOLUBLE
LINEAR-PRODUCT-FORMULA-AND-HIGHER-LOCAL-FLAG-ROUTES-EXCLUDED
NONLINEAR-GLOBAL-SEMILINEAR-COUPLING-OPEN
ACTUAL-r2-INVERSE-TRACE-EQUATION-OPEN
F55-GLOBAL-QUESTION-OPEN
```

The surviving target is narrower than before: it must distinguish the
actual constant translate inside the evaluation map on the trace
hyperplane by a nonlinear global invariant.  It cannot be a linear sum of
the complete divisor residues, a `C5`-cohomological correction of that sum,
or anisotropy at a complete higher-local flag.
