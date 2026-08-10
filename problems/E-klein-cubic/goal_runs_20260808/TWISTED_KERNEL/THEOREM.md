# The generic twisted `C11` kernel

**Date:** 2026-08-08  
**Status:** `EXACT REDUCTION / ORDINARY ESSENTIAL DIMENSION OPEN`

Let

```text
K = C(t),  L = K(s),  s^5=t,
```

and let `A/K` be the form of `mu_11` split by `L/K` for which a generator of
`Gal(L/K)` acts on `X(A_L)=F_11` by multiplication by `9` (equivalently by
the inverse order-five multiplier).  This is the twisted normal kernel arising
from the generic `C5` quotient of `F55=C11:C5`.

## 1. Exact unconditional bounds

```text
2 <= ed_K(A) <= 4.
```

The upper bound is realized by the five-character orbit

```text
{1,9,4,3,5}
```

and its faithful projectivization `P4`.  The lower bound follows from the
essential-dimension-one embedding theorem: an order-eleven subgroup of
`PGL2` lies in a one-dimensional torus, whose Weyl group acts by at most
`+/-1`; it cannot realize the order-five multiplier `9`.

Every faithful linear representation has vector dimension at least five.  The
same holds projectively: descent acts affinely on geometric weights by
`j |-> 9j+c`; translation by its unique fixed point conjugates this to
`j |-> 9j`, whose nontrivial orbits have length five.  This is only a
linear/projective lower bound and does not exclude a nonlinear threefold
compression.

Likewise every torus containing `A` has dimension at least four: its character
lattice must surject `C5`-equivariantly onto `F_11(9)`, while every nontrivial
rational representation of `C5` has dimension at least `deg Phi_5=4`.
The norm/projective torus realizes equality.  Thus toric and monomial models
are settled; additive cancellation is the surviving layer.

## 2. Bayarmagnai's exact conjectural endpoint

Bayarmagnai conjectures for an odd-prime twist that

```text
ed_k(G) = phi([K_p:k]) [K:K_p].
```

In Bayarmagnai's notation, her base field `k` is our `K`, while both of her
splitting fields `K` and `K_p` are our `L`.  Since `[L:K]=5`, the conjecture
specializes exactly to

```text
ed_K(A) = phi(5) = 4.
```

Her Theorem 3.2 proves only the matching upper bound.  A search of the primary
citation trail through 2026-08-08 found no later theorem proving the ordinary
lower bound in this mixed-prime case.

Lötscher--MacDonald--Meyer--Reichstein Proposition 6.1 gives only

```text
ed_K(A;11) = 1,
```

because the minimal splitting degree five is prime to eleven.  Their equality
between ordinary and `p`-essential dimension assumes a `p`-power splitting
extension and is inapplicable.  For primes different from eleven the local
essential dimensions vanish.  Hence no prime-local or standard torsion
cohomological lower bound can see the desired value four.

## 3. One-way implication to the Klein cubic

If the Klein cubic were `F55`-unirational, twist a dominant `F55`-map by the
generic `C5`-torsor.  The source remains a projective linear `A`-source, and
the twisted three-dimensional target is `A`-very versal.  Therefore

```text
Klein F55-YES  =>  ed_K(A) <= 3.
```

Consequently

```text
ed_K(A)=4  =>  Klein F55-NO
             => Klein PSL2(F11)-NO.
```

The converse is not formal.  An arbitrary three-dimensional `A`-compression
may vary with `t` and need not be the prescribed twisted Klein cubic.  Thus
Bayarmagnai's equality is a stronger sufficient obstruction, not an equivalent
reformulation of the headline.

## 4. Strict verdict

```text
TWISTED-C11-ORDINARY-ED-UNDECIDED
BAYARMAGNAI-p11-DEGREE5-CASE-OPEN
KLEIN-NEGATIVE-HEADLINE-NOT-PROVED
```
