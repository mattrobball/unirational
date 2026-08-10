# Valuation and canonical-dimension audit for the generic twisted `C11`

**Date:** 2026-08-08  
**Status:** `EXACT METHOD BOUNDARY / HEADLINE OPEN`

Let

```text
K = C(t),  L = K(s),  s^5=t,
```

fix `zeta_5 in C`, and write `sigma(s)=zeta_5*s`.  Let `A/K` be the
form of `mu_11` whose character module is the one-dimensional
`F_11`-module on which `sigma` acts by `9`.  Thus `sigma` acts on the
geometric points of `A_L=mu_11` by the inverse multiplier `5`.

This note proves two exact no-go results for tempting lower-bound arguments.
They do **not** determine `ed_K(A)`.

## 1. Coprime-torus annihilation

### Proposition 1

Let `F/K` be any field extension and let `T_0/F` be a torus split by
`F tensor_K L`.  For every homomorphism

```text
i : A_F -> T_0
```

the induced map

```text
H^1(F,A_F) -> H^1(F,T_0)
```

is zero.

### Proof

The fppf cohomology group `H^1(F,A_F)` is killed by `11`, because
`[11]=0` on the commutative group scheme `A_F`.

If `F tensor_K L` is split, then `T_0` is split and `H^1(F,T_0)=0`.
Otherwise it is a cyclic splitting field of degree five.  Inflation-restriction
and Hilbert 90 identify `H^1(F,T_0)` with a first cohomology group of
`C5`; in particular it is killed by `5`.  Hence the image of an element of
`H^1(F,A_F)` is killed by both `11` and `5`, and is zero.  This is
functorial in `F`.  QED.

The same conclusion holds more generally whenever the degree of a finite
Galois splitting field of `T_0` is prime to `11`.

### The natural four-dimensional torus

Put

```text
T = R^1_{L/K}(G_m).
```

Over `L`, the five characters

```text
(1,9,4,3,5)
```

give a faithful embedding `A -> R_{L/K}(G_m)`.  Their sum is `22=0`
modulo `11`, so the embedding lands in `T`.  Directly,

```text
H^1(F,T_F) = F^*/N_{F tensor L/F}((F tensor L)^*)
```

and this group is killed by five, since `a^5=N(a)` for `a in F^*`.
Consequently every `A`-torsor induces the trivial `T`-torsor.

On the other hand, `T` is an anisotropic four-dimensional torus with minimal
cyclic splitting field of degree five.  Loetscher's Example 5.12 therefore gives

```text
cdim_5(T) = cdim(T) = 4.
```

The same is true for the isogenous torus `T/A`.  This does **not** imply
`ed(A)>=4`: none of the incompressible `T`-torsors used to realize canonical
dimension four is induced from an `A`-torsor.  All torsors in the image of
`H^1(-,A)->H^1(-,T)` are trivial.

Thus the otherwise natural strategy

```text
choose an A-torsor -> extend it to T -> use an incompressible T-torsor
```

has an empty last step.

This is not peculiar to the norm-one model: Proposition 1 disposes of every
torus split by the same degree-five extension.  To evade it, a torus would need
a splitting group whose order is divisible by `11`.  A faithful rational
representation of an element of order `11` has dimension at least
`phi(11)=10`, so no four-dimensional torus can evade the coprime mechanism.
No current ordinary canonical-dimension theorem turns such an extraneous
higher-dimensional embedding into a lower bound for `ed(A)`.

## 2. A one-variable branch-orbit counterexample

The five-place orbit forced by the degree-five monodromy also does not force
four parameters.

Set

```text
F = K(x),  M = L(x),
f_i = x-zeta_5^i*s                    (i modulo 5),
e = (e_0,...,e_4) = (1,9,4,3,5),
b = product_i f_i^e_i in M^*.
```

The exponent identities are

```text
e_{j-1}-5e_j = (0,-44,-11,-11,-22)_j.
```

Consequently, with

```text
c = f_1^-4 f_2^-1 f_3^-1 f_4^-2,
```

one has the exact identity

```text
sigma(b) = c^11 b^5.
```

Equivalently, on the Kummer cover `y^11=b` the semilinear rule

```text
S^*(a)=sigma(a)  (a in M),    S^*(y)=c*y^5
```

preserves the defining equation.  Iterating gives

```text
S^(5)*(y)=D*y^(5^5),
div(D)=(-284,-2556,-1136,-852,-1420)
```

in the ordered basis `(f_0,...,f_4)`.  Since `5^5=1+284*11`, this is
exactly `y`: the displayed divisor is `-284*(e_0,...,e_4)`, so
`D*b^284=1`.  Thus this particular descent rule already has order five;
no unrecorded cocycle adjustment is needed.

The Kummer class `[b] in M^*/M^{*11}` therefore satisfies the descent
condition

```text
sigma([b]) = [b]^5.
```

This is exactly the condition for the point multiplier `5`, dual to the stated
character multiplier `9`.  The higher cohomology of `C5` on the `11`-group
`mu_11` vanishes, so restriction gives an isomorphism from `H^1(F,A)` to
the corresponding twisted-invariant subgroup of `H^1(M,mu_11)`.  Hence
`[b]` descends to an actual `A`-torsor over the one-variable field `K(x)`.

It is visibly nontrivial: the valuations of `b` at the five distinct primes
`f_i=0` are all nonzero modulo `11`.  The cover has a full `C5`-orbit of
five branch places.  The augmentation lattice of that support orbit has rank
four, yet the torsor is defined over transcendence degree one over `K`.

Therefore neither

```text
five conjugate branch divisors
```

nor

```text
rank four of their permutation/augmentation lattice
```

is a lower bound for the essential dimension of a torsor.  A successful
valuation proof would have to retain a genuinely global moduli invariant of a
**versal** family, rather than only the orbit and its ramification residues.

## 3. Why tame specialization loses the faithful component

The same example gives an exact degeneration at the ramified place `s=0`.
There

```text
b|_{s=0} = x^(sum e_i) = x^22.
```

On the dense chart `x != 0`, put `z=y/x^2` in the cover `y^11=b`.  The
normalization of the special fiber satisfies

```text
z^11=1,
```

and is the disjoint union of eleven rational components.  The `C11` deck
transformation sends the component label `k in F_11` to `k+1`.  Since
`c|_{s=0}=x^-8`, the explicit semilinear order-five transformation specializes to

```text
z -> z^5,
```

so it sends `k` to `5k`.  These two permutations generate the faithful
Frobenius group

```text
F55 = C11 : C5.
```

However, `C11` permutes the eleven irreducible components transitively.  No
irreducible component is `C11`-stable, let alone a faithful `F55`-variety.

Thus a generic twisted action can specialize to a faithful `F55`-action only
on a reducible total special fiber, while every individual component loses the
normal subgroup.  Any proposed implication

```text
low-dimensional A-compression over C((t))
    => low-dimensional faithful F55-action on one special component
```

needs an additional component-stabilization theorem.  Such a theorem is false
for arbitrary twisted `A`-varieties, as the explicit family above shows; it would
have to use a further versality or geometric hypothesis.

## 4. Exact surviving boundary

The primary theorems currently give only:

```text
ed_K(A;11)=1,
ed_K(A;5)=0,
cdim_5(T)=4,
2 <= ed_K(A) <= 4.
```

Single-prime canonical dimension cannot mix the `5`-monodromy with the
`11`-torsor.  Loetscher's fiber theorem supplies upper/fiber inequalities and,
under a `p`-exhaustivity hypothesis, lower bounds for the canonical dimension
of quotient groups.  It does not assert the ordinary (`p=0`) exhaustivity or
the ordinary lower bound needed here.  Applying its proved `p=5` statement to
the torus quotient recovers torus incompressibility, while Proposition 1 shows
that this incompressibility is disjoint from the `A`-torsors.

Accordingly the strict verdict is

```text
NORM-TORUS-CANONICAL-LOWER-BOUND-INAPPLICABLE
BRANCH-ORBIT-RANK-LOWER-BOUND-REFUTED
NAIVE-TAME-SPECIALIZATION-COMPONENT-STEP-REFUTED
ORDINARY-ed_K(A)=4-OPEN
KLEIN-NEGATIVE-HEADLINE-NOT-PROVED
```
