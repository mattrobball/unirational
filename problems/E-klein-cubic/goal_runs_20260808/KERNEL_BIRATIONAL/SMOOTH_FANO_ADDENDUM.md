# Smooth geometric Picard-rank-one Fano sieve

**Date:** 2026-08-08
**Scope:** smooth Fano threefolds whose **geometric** Picard rank is one
**Status:** exact classification reduction; no CAS

Keep the notation of `THEOREM.md`.  Let `F/K` be regular, so that `A_F`
still has splitting field of degree five and character multiplier `9`.

## Theorem

Let `X/F` be a smooth Fano threefold with `rho(X_bar)=1` and a faithful
`A_F`-action.  Then exactly one of the following two geometric possibilities
remains:

1. `X_bar` is the Klein cubic threefold (index two, degree three);
2. `X_bar` has index one and genus eight, and its associated smooth Pfaffian
   cubic threefold is the Klein cubic.

This is a survivor list, not an existence or versality assertion.  In
particular it does not prove `ed_K(A)>=4`.

## 1. Two representation exclusions

The projective-weight lemma in `THEOREM.md` says that `A_F` does not embed in
an `F`-form of `PGL_n` for `n<=4`.

It also does not embed in an `F`-form of `PSO_5`.  Indeed, after splitting the
quadratic form and `A`, the five projective weights are invariant under
`j |-> 9j+c`.  A nontrivial invariant multiset of cardinality five must be
one five-cycle

```text
p + uR,       R=<9>={1,3,4,5,9} subset F_11^*.
```

If a nondegenerate quadratic form is preserved projectively with character
`lambda`, this multiset must also be invariant under the reflection
`j |-> lambda-j`.  Since `sum(R)=0`, comparison of sums gives
`lambda=2p`; after translating by `p`, this would say `-R=R`.  But `-1` is
not in the order-five subgroup `R` of `F_11^*`.  Contradiction.

These arguments work for inner forms because they are made after a separable
splitting extension and retain the Galois multiplier `9`.

## 2. Applying the smooth rank-one classification

Use the standard classification by index `iota(X_bar)`.

### Index at least two

* `iota=4`: `P3`, excluded by the projective-weight lemma.
* `iota=3`: the smooth quadric threefold, excluded by the orthogonal argument
  above.
* `iota=2`, degree five: `Aut(X_bar)=PGL2`, excluded by the projective-weight
  lemma.
* `iota=2`, degrees one, two, and four: Theorem A of Konovalov gives orders of
  the finite automorphism groups not divisible by `11`.
* `iota=2`, degree three: this is a smooth cubic threefold.  Roulleau,
  Proposition 2.1, proves that the Klein cubic is the unique smooth cubic
  threefold with an automorphism of order `11`.

Thus the only survivor of index at least two is the Klein cubic.

### Index one

For genera `2,3,4,5,7,9,10`, Theorem B of Konovalov gives an automorphism
order not divisible by `11`.  The two genus-six types and genus twelve need
separate arguments.

* For the special genus-six double-cover type, Konovalov, Theorem B(7), again
  gives no factor `11`.
* For an ordinary genus-six Gushel--Mukai threefold, Debarre--Mongardi,
  Corollary 4.4(2), proves that the only smooth example with an automorphism
  of prime order at least `11` is their threefold `X_A^3`, with prime `11`.
  Section 4.2.2 of the same paper computes

  ```text
  Aut((X_A^3)_C) = C11.
  ```

  Hence this geometric model cannot carry the nonsplit group scheme `A_F`.
  Any `F`-form of this unique complex model is obtained by descent through
  its constant automorphism group `C11`; conjugation on that group is
  trivial, so every descended order-eleven subgroup scheme is split.  This
  contradicts the multiplier-`9` Galois action defining `A_F`.
* In genus twelve, Kuznetsov--Prokhorov--Shramov, Corollary 4.3.5(v), gives a
  faithful action

  ```text
  Aut(X_bar) -> Aut(S(X_bar)) = PGL3,
  ```

  where `S(X_bar)` is the Hilbert scheme of conics and is a projective plane.
  This construction is intrinsic and descends to an `F`-form of `P2`.
  Therefore a faithful `A_F`-action would embed `A_F` in an inner form of
  `PGL3`, contrary to the projective-weight lemma.

Only genus eight remains.  By Kuznetsov--Prokhorov--Shramov,
Proposition B.6.1, every such `X_bar` has an associated **smooth** cubic
threefold

```text
Y = P(A_5) intersect Pf(W_6),
```

and `S(X_bar)` is isomorphic to the Fano surface of lines `Sigma(Y)`.
The Mukai bundle defining this construction is unique (their
Proposition B.1.5).  Thus every automorphism of `X_bar` acts projectively on
`W_6=H^0(E)^*`, preserves the five-dimensional annihilator `A_5`, and hence
acts on `Y`.  The incidence correspondence `R` in their Proposition B.6.3
constructs `S(X_bar)=R=Sigma(Y)` from `(A_5,W_6)`, so this isomorphism is
equivariant for that action.  Moreover their Lemma 4.3.4 says that
`Aut(X_bar)` acts faithfully on `S(X_bar)` for genus at least seven.
Consequently the induced `C11`-action on `Y` is faithful: an element trivial
on `Y` is trivial on `Sigma(Y)=S(X_bar)`, hence trivial on `X_bar`.
Roulleau's uniqueness theorem now forces `Y` to be the Klein cubic.

This proves the theorem.

## 3. Exact boundary left by the sieve

The Klein cubic really admits the required multiplier-`9` normalizer
`C11:C5`, so its generic `C5` twist survives.

The genus-eight branch is reduced to the fibre of the Pfaffian association
over the Klein cubic.  The cited results do not say that every member of this
fibre descends with multiplier `9`, nor that any such descent is `A`-versal.
It therefore remains a survivor, not a constructed compression.

There is, however, one exact constant survivor in this branch.  Cheltsov--
Krylov--Ma'u, Theorem 12 and Lemma 13, construct an `F55`-equivariant
birational map from the Klein cubic to a smooth genus-eight Fano threefold

```text
Y = Gr(2,6) intersect P9,       Pic(Y)=Z[-K_Y],       (-K_Y)^3=14.
```

Thus the cubic and genus-eight entries are not two unrelated birational
configurations: at least this explicit genus-eight entry lies in the same
`F55`-birational class as the Klein cubic.  Their result neither classifies
all multiplier-`9` descents in the Pfaffian fibre nor proves versality.

The theorem does **not** cover:

* terminal singular Fano threefolds;
* smooth Fano threefolds of geometric Picard rank greater than one;
* an arithmetic MMP output for which only the Picard rank of a descended or
  invariant lattice is one, rather than `rho(X_bar)=1`.

No equivariant-smoothing theorem used here turns those branches into the
smooth geometric rank-one case.  They must remain explicit open branches in
any claim about `ed_K(A)>=4`.
