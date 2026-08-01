# Abstract restriction theorem and cohomological cross-check

## 1. Inputs and notation

Let

```text
F = C(A,B,Y,Z),
K = K_proj,
N/F = the Galois closure of K/F,
Gal(N/F) = S6,
V = E[3](Fbar) = F3^2.
```

The accepted rank-nine CFOSS algebra is

```text
R = F x L,
[L:F] = 8,
```

where the field factor `L` represents the single orbit
`V - {0}`.  Hence the absolute Galois image on `V` is transitive on its
eight nonzero vectors.  The installed class

```text
xi in H^1(F,V)
```

maps under the Kummer connecting sequence to the plane-cubic torsor class
`[C] in H^1(F,E)[3]`.  Since `C(F)` is empty, `[C]` and therefore `xi` are
nonzero.

## 2. No 3-torsion appears over the S6 closure

Let `Gamma=Gal(Fbar/F)` and `Gamma_N=Gal(Fbar/N)`.  Put

```text
W = V^(Gamma_N) = E[3](N).
```

Because `Gamma_N` is normal in `Gamma`, `W` is a Galois-stable subspace of
`V`.  Transitivity on `V-{0}` says that a nonzero stable subspace contains
every nonzero vector.  Thus `W` is either `0` or all of `V`.

If `W=V`, the representation on `V` factors through
`Gamma/Gamma_N=S6`.  Its image would simultaneously

1. be a quotient of `S6`;
2. lie in `GL(2,F3)`, which has order 48; and
3. act transitively on eight nonzero vectors.

The only normal subgroups of `S6` are `1`, `A6`, and `S6`; hence its only
quotients are `S6`, `C2`, and `1`.  An `S6` image cannot lie in a group of
order 48, and groups of order one or two cannot have an orbit of size eight.
This contradiction proves

```text
E[3](N) = 0.
```

## 3. Restriction on first cohomology is injective

Inflation--restriction for the finite Galois extension `N/F` begins

```text
0 -> H^1(S6,E[3](N))
  -> H^1(F,E[3])
  -> H^1(N,E[3]).
```

The left group is zero because `E[3](N)=0`.  Restriction from `F` to `N`
is therefore injective.  Since `N` contains `K`, a class which vanished over
`K` would also vanish over `N`.  Consequently

```text
res_{K/F}: H^1(F,E[3]) -> H^1(K,E[3]) is injective,
res_{K/F}(xi) != 0.
```

Via the pinned CFOSS injection `w1`, this also forces the nonidentity
component of `alpha_R` to be a noncube in

```text
(L tensor_F K)^x / ((L tensor_F K)^x)^3.
```

No expansion of the 755,647-node representative is needed.

## 4. Why this does not by itself decide the curve

Over `K`, the Kummer sequence has the exact fragment

```text
E(K)/3E(K) --delta--> H^1(K,E[3]) -> H^1(K,E)[3].
```

Therefore

```text
C(K) nonempty
  iff res(xi) lies in delta(E(K)/3E(K)),
```

not iff `res(xi)=0`.  Since the preceding theorem proves `res(xi)!=0`, a
hypothetical point would require a **nonzero** Mordell--Weil Kummer class.
Restriction--corestriction does not exclude it:

```text
cor(res(xi)) = 6*xi = 0,
Tr_{K/F}(Q) = 0 in E(F)
```

for any representing `Q`, because `xi` is 3-primary and the accepted input
gives `E(F)=0`.

There is also no abstract representation contradiction.  The augmentation
lattice

```text
A5 = { (a1,...,a6) in Z^6 : sum(ai)=0 }
```

has no torsion and no rational `S6`-fixed vector, but `A5/3A5` has the
nonzero invariant class represented by

```text
(-5,1,1,1,1,1) mod 3.
```

Thus a trace-zero orbit of six points can be congruent modulo three without
creating 3-torsion.  This is exactly the lattice phenomenon that a
nonzero Kummer image would use.  Accordingly, `S6`, trace, and
restriction--corestriction alone cannot replace the geometric index
calculation.

## 5. Cross-check of the infinity-divisor theorem

The separate exact packet `F_CONIC_ALGEBRA/INFINITY_OBSTRUCTION.md` supplies
an `(e,f)=(1,1)` place of `K/F`.  Its residual cubic over `C(D)` has index
three, by the class group of the normal universal incidence of the residual
net.  Properness gives

```text
C(K) = empty.
```

Cohomologically this says

```text
image(res(xi)) = res([C]) != 0 in H^1(K,E)[3].
```

It is strictly stronger than the abstract theorem of Section 3 and is fully
consistent with it.  In particular:

- the infinity obstruction rules out the remaining possibility that
  `res(xi)` is a nonzero Kummer class;
- any certificate claiming `alpha_R` is a cube over `R tensor K` would
  contradict both the abstract injection theorem and the valuation exit;
- a certificate merely proving `alpha_R` is a noncube would corroborate the
  abstract theorem but would not independently prove pointlessness.

The adversarial replay checks the exact infinity payload and its independent
verifier markers.  No headline implication for the genuine generic Klein
twist is asserted here.

