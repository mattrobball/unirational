# The characteristic-five modular-invariant boundary

**Date:** 2026-08-08  
**Status:** `EXACT MIXED-PRIME REDUCTION / LOWER BOUND OPEN`  
**Strict verdict:** neither finite generation of covariants, the `C5` Jordan
filtration, nor any theorem located in the literature through 2026-08-08 proves
`ed_k(F55)=4`.  The strongest clean replacement target is a four-dimensional
generic torsor for a degree-five twist of `mu_11`; its incompressibility is an
unresolved mixed `5/11` essential-dimension problem.

Throughout, `k` is algebraically closed of characteristic five,

\[
 G=F_{55}=C_{11}\rtimes C_5,
 \qquad t s t^{-1}=s^5,
\]

and `V` is the faithful irreducible five-space used in
`CHAR5_ED_AUDIT.md`.  Its restriction to `C5` is the indecomposable regular
module `V_5`, with

\[
                     \operatorname{codim} V^{C_5}=4.       \tag{0.1}
\]

## 1. What the current modular-covariant theorems do not cover

For a finite group, the module of polynomial covariants

\[
       \mathcal C=(k[V]\otimes V)^G
\]

is finitely generated over the noetherian invariant ring `k[V]^G`, including
in modular characteristic.  This statement does not give a degree cutoff for
dominance.  If `c_1,...,c_r` generate `mathcal C`, an arbitrary homogeneous
covariant
has the form

\[
                       c=\sum_i a_i c_i,
       \qquad a_i\in k[V]^G,                              \tag{1.1}
\]

where the degrees of the invariant coefficients are unbounded.  Dominance is
not preserved by sums: even two dominant polynomial maps can have a
nondominant difference.  Consequently, checking dominance of a finite module
generating set does not check (1.1).  Finite generation would become useful
only with an additional theorem controlling the degeneracy locus for **all**
invariant-coefficient combinations; no such theorem was located.

The explicit modular theorems have a separate scope failure:

- Elmer's 2022 paper treats indecomposable source `V_2`, and source `V_3`
  with bounded target in its second main case.
- Elmer's 2025 preprint, in its current 22 March 2026 revision, constructs
  generators for cyclic `p`-group covariants under
  `codim(V^G) <= 2`.  It explicitly lists the faithful source modules to which
  this applies.  Equation (0.1) excludes our source `V_5`.
- The underlying Broer--Chuai Cohen--Macaulay theorem has the same
  `codim(V^G) <= 2` hypothesis.  In fact, the cited modular invariant-ring
  criterion says that this codimension boundary is exactly where the
  Cohen--Macaulay conclusion holds in this cyclic setting.

Thus the 2025--2026 update does not supply either a finite generating set for
the present covariant module over a homogeneous parameter algebra or, more
importantly, an all-combinations dominance theorem.

The transfer/Jordan route also stops for a structural reason already certified
in `CHAR5_MINIMAL_REDUCTION.md`.  The Klein landing equation is

\[
 K(T_f)=N(f^2\rho f),\qquad
 N=1+\rho+\cdots+\rho^4=(\rho-1)^4.                      \tag{1.2}
\]

The corresponding Tate quotient is zero away from degrees divisible by five
and one-dimensional in degrees divisible by five.  In the latter degrees its
single class is invisible to `N(g)=0` and is nonzero on explicit
`p`-primitive expressions `g=f^2 rho(f)`.  The progression packets then give
cyclic Artin--Schreier countermodels to any argument using only the universal
five-bucket/Jordan identities.  Polynomiality, the `C11` weights, or genuinely
birational geometry must enter.

## 2. The generic Artin--Schreier twist

Take the generic `C5`-torsor

\[
 K=k(a),\qquad L=K(u),\qquad u^5-u=a,\qquad
 \Gamma=\operatorname{Gal}(L/K)=\langle\gamma\rangle\simeq C_5. \tag{2.1}
\]

Twisting the normal kernel `C11` by (2.1) gives a finite group of
multiplicative type

\[
                         A={}^{L/K}C_{11}.                 \tag{2.2}
\]

Its character module is

\[
       M=X^*(A)=\mathbf Z/11,
       \qquad \gamma\cdot m=9m.                           \tag{2.3}
\]

The multiplier may be replaced by its inverse `5`; the two conventions give
the same order-five module.  We use `9` because conjugation on characters is
contragredient to `tst^{-1}=s^5`.

The prime-local invariants do not see the desired lower bound.  The
Loetscher--MacDonald--Meyer--Reichstein formula for a twisted cyclic
`11`-group gives

\[
                         \operatorname{ed}_K(A;11)=1,      \tag{2.4}
\]

because the splitting degree five is prime to eleven.  Also
`ed_K(A;5)=0`, since `A` is smooth of order eleven.  Absolute essential
dimension is not the maximum of these values in this mixed-prime situation.

The existing `p`-group equality theorem behind Ruozzi's result requires the
splitting group and the finite quotient by the maximal torus to be `p`-groups
for the **same** prime.  Here those orders are five and eleven, so its
hypothesis fails.

## 3. Exact rank-four permutation presentation

Let `P=Z[Gamma]`, let `I=(gamma-1)P` be its augmentation ideal, and define

\[
  h:I\longrightarrow M,\qquad
  h\bigl(\gamma^i(\gamma-1)\bigr)=9^i(9-1)\pmod {11}.
                                                               \tag{3.1}
\]

Then:

1. `I` has rank four.
2. The map (3.1) is equivariant and surjective, since `9-1=8` is a unit
   modulo eleven.
3. It factors as `I -> P -> M`, so it is a permutation representation in
   Ruozzi's sense.
4. No permutation representation of `M` has lattice rank below four.

For the last assertion, let `B -> M` be any surjective `Gamma`-lattice map.
After reduction modulo eleven, `9` occurs as an eigenvalue of `gamma` on
`B/11B`.  Over the rationals, a matrix of order five has characteristic
polynomial

\[
                    (x-1)^e\Phi_5(x)^f.                   \tag{3.2}
\]

Since `9 != 1 mod 11` but

\[
                     \Phi_5(9)=0\pmod {11},               \tag{3.3}
\]

we must have `f>=1`; hence `rank(B)>=deg(Phi_5)=4`.

It follows unconditionally that the minimum lattice rank in Ruozzi's formula
is four and that

\[
                          \operatorname{ed}_K(A)\leq4.     \tag{3.4}
\]

Ruozzi's conjecture predicts equality in (3.4).  The lattice calculation is
not a lower bound for essential dimension without that conjecture.

Replay the arithmetic and integral-lattice certificate with

```text
python3 verify_char5_modular_lattice.py
```

Expected terminal marker:

```text
F55-CHAR5-MIXED-PRIME-LATTICE-BOUNDARY-OK
```

## 4. A concrete all-degree object that survives every current refutation

Write `D(-)` for the diagonalizable group with the indicated character
module, and put

\[
       H=D(I)\simeq (R_{L/K}\mathbf G_m)/\mathbf G_m,
       \qquad J=\ker(h),\qquad S=D(J).                     \tag{4.1}
\]

Dualizing `0 -> J -> I -> M -> 0` gives a degree-eleven isogeny

\[
                    1\longrightarrow A\longrightarrow H
                    \stackrel{\pi}{\longrightarrow}S
                    \longrightarrow1.                    \tag{4.2}
\]

Because `h` factors through the permutation lattice `P`, the embedding
`A -> H` factors through the quasi-split torus `R_{L/K} G_m`.  Hence `S` is
a four-dimensional classifying variety for `A`.  The generic fiber

\[
       \tau_{\rm gen}: H\mathbin{\times_S}\operatorname{Spec}K(S)
                    \longrightarrow\operatorname{Spec}K(S)
                                                               \tag{4.3}
\]

is a concrete versal `A`-torsor.  The exact remaining lower-bound statement is

\[
                   \operatorname{ed}_K(\tau_{\rm gen})=4. \tag{4.4}
\]

Equivalently, the degree-eleven generic torsor (4.3) does not descend to a
subfield of transcendence degree at most three.  This is genuinely
all-degree/birational: it is not a bounded covariant computation.  None of the
following packets refutes or proves (4.4): the Tate-class calculation, the
fixed-line jet obstruction, the normal-fan test, or the cyclic finite-field
progression countermodels.  Those packets only rule out proposed identities
inside the `C5` polynomial/Jordan model.

Thus (4.3)--(4.4) is the clean surviving invariant.  Proving (4.4), rather
than finding more covariant generators, is the most precise analytic route
left by this audit.

## 5. Relation to `F55` covariants and to the Klein cubic

Twisting `P(V)` by (2.1) gives `P(L)`.  Its dense torus is `H` in (4.1), and
`A` acts by translation.  A nonzero homogeneous `G`-self-covariant gives a
`G`-equivariant rational self-map of `P(V)`; twisting gives an
`A`-equivariant rational self-map of `P(L)` of the same image dimension.
Consequently,

\[
  \operatorname{ed}_K(A)=4
   \quad\Longrightarrow\quad
  \text{every nonzero homogeneous `G`-self-covariant is dominant}
   \quad\Longrightarrow\quad
  \text{there is no Klein landing covariant}.             \tag{5.1}
\]

The first implication uses that a nondominant twisted map would give a
faithful `A`-compression of dimension at most three.  The second is immediate,
since the Klein cubic has dimension three.

Neither converse is established.  In particular:

- `ed_K(A)=4` is a **stronger sufficient target** than the actual Klein
  landing nonexistence statement, not a weaker one.
- Klein landing asks only whether the image lies in one specified cubic
  threefold.  It does not exclude a compression to another threefold.
- The `A`-maps over the generic field `K` include maps which need not descend
  from a `k`-defined `G`-self-covariant.  Hence all `G`-self-covariants being
  dominant does not presently imply `ed_K(A)=4`.

This directionality prevents an accidental claim that the original Klein
condition is equivalent to the Ruozzi problem.

## 6. Literature audit through 2026-08-08

The audit located no 2025--2026 theorem proving (4.4), or the general
degree-five, order-eleven twisted case.

- Bayarmagnai (2007) proves a general upper bound for twists of `mu_(p^n)`
  and proves equality for twists of `mu_8`.  The paper does not prove the
  order-eleven, splitting-degree-five equality.
- Loetscher--MacDonald--Meyer--Reichstein compute the essential
  **p-dimension** of twisted cyclic `p`-groups.  Applied here, their result is
  exactly (2.4), not absolute essential dimension four.
- Merkurjev's multiplicative-type survey records Ruozzi's permutation-
  representation conjecture and states that even the related constant
  `C_p` problem over `Q` is unknown for `p>=11`.
- Kaur--Reichstein (2024) list `C11 semidirect C5` with essential dimension
  in the interval `3--4` (over their characteristic-zero base convention),
  rather than resolving it.
- Elmer's only directly relevant 2025 paper, including its March 2026
  revision, retains `codim(V^G)<=2`; it does not reach `V_5`.

The phrase "the `p=11`, degree-five open case" must be used carefully.  Our
`A/K` is a specific generic Artin--Schreier twist with splitting group `C5`.
It is an instance of the unresolved Bayarmagnai/Ruozzi mixed-prime pattern.
It is **not** literally the constant group `C11/Q`: the latter has cyclotomic
splitting group `C10` (although both minimal permutation ranks happen to be
four).  No reduction between those two base-field instances is asserted.
Characteristic five may in principle provide extra structure; the current
literature simply supplies no theorem that exploits it to prove (4.4).

Primary sources checked:

- G. Bayarmagnai, *Essential dimension of some twists of `mu_(p^n)`*,
  RIMS Kokyuroku Bessatsu B4 (2007), 145--151,
  <https://repository.kulib.kyoto-u.ac.jp/dspace/bitstream/2433/174166/1/B04_010.pdf>.
- R. Loetscher, M. MacDonald, A. Meyer, Z. Reichstein,
  *Essential p-dimension of algebraic tori*,
  <https://arxiv.org/abs/0910.5574>.
- A. Merkurjev, *Essential dimension: a survey*, Section 8b,
  <https://www.math.ucla.edu/~merkurev/papers/survey-update.pdf>.
- D. Kaur, Z. Reichstein, *Essential Dimension of Small Finite Groups*,
  <https://arxiv.org/abs/2407.21449>.
- J. Elmer, *Modular Covariants of Cyclic Groups of Order p*,
  <https://arxiv.org/abs/1806.11024>.
- J. Elmer, *Cohen--Macaulay modules of covariants for cyclic p-groups*,
  <https://arxiv.org/abs/2506.03677>.

## 7. Final boundary

The exact unconditional conclusions are

\[
  2\leq\operatorname{ed}_K(A)\leq4,
  \qquad \operatorname{ed}_K(A;11)=1,
  \qquad \min\{\operatorname{rank}(B):B\twoheadrightarrow X^*(A)}=4.
                                                               \tag{7.1}
\]

In the last minimum, `B` ranges over `Gamma`-lattices and the displayed
surjections are `Gamma`-equivariant.  The first lower bound is the `PGL_2`
obstruction already proved in
`CHAR5_ED_AUDIT.md`; the rank-four equality in (7.1) is a lattice theorem,
not an essential-dimension theorem.  Upgrading either (7.1) or the generic
torsor (4.3) to a four-dimensional lower bound is precisely the missing
step.  Without a new mixed-prime incompressibility theorem, this route does
not settle `ed_k(F55)=4` and does not settle all-degree Klein landing.
