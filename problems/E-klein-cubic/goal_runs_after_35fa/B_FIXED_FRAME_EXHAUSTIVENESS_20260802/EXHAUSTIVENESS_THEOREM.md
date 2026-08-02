# Fixed-frame exhaustiveness theorem — refutation

## 1. Setup

Put `K=K_proj`.  Let

```text
Y = F14_T
```

be the genuine twisted degree-14 Fano threefold of common isotropic right
`D`-lines for the distinguished five-plane `H_T`.  Let

```text
C_K^open --> I_sigma --> P^2_D
```

be the functional-calculus map from the selected fixed ternary cubic, and let
`Sigma` be the Zariski closure of its image.  Finally put

```text
Gamma = PGU(h_struct) ∩ Stab_{PGL_3(D)}(H_T).
```

The proposed negative bridge was the assertion that every point of `Y` can be
moved by `Gamma` into `Sigma`.

## 2. Theorem

**Theorem.**  After base change to an algebraic closure of `K`, the locus of
points of `Y` that are `Gamma`-equivalent to a point of `Sigma` has dimension at
most one.  In particular it is a proper closed subset of the threefold `Y`.
Consequently the generic point of `Y` over `K(Y)` is not normalizable into the
selected fixed frame.

Equivalently, the functorial statement

```text
for every field L/K and every y in Y(L),
there is gamma in Gamma(L) with gamma*y in Sigma(L)
```

is false.

## 3. Proof

### 3.1 The fixed-frame image is at most a curve

The source `C_K^open` is an open subscheme of a projective plane cubic.  Hence
its image under functional calculus has dimension at most one, and therefore

```text
dim Sigma <= 1.
```

No injectivity or generic-finiteness assertion is needed.

### 3.2 The effective gauge image on the Fano threefold is finite

By definition, `Gamma` preserves the structure form and the distinguished
five-plane `H_T`.  It therefore preserves the five common-isotropy equations
and acts on `Y`.  After base change to an algebraic closure, `Y` is the smooth
prime Fano threefold of degree fourteen, Picard number one, and genus eight.

Kuznetsov--Prokhorov--Shramov, Theorem 1.1.2, classifies the smooth
Picard-rank-one Fano threefolds with infinite automorphism group.  A genus-eight
prime Fano threefold is not among the exceptions.  Hence

```text
Aut(Y_Kbar) is finite.
```

Consequently the image `Gamma_eff` of `Gamma_Kbar` in `Aut(Y_Kbar)` is finite.
A possibly positive-dimensional kernel acts trivially on `Y` and therefore
does not enlarge orbit saturation inside `Y`.

### 3.3 Finite saturation cannot exhaust a threefold

Let `Gamma_eff` be that finite image.  The normalizable locus is contained in

```text
N = Y_Kbar ∩ union_{g in Gamma_eff} g(Sigma_Kbar).
```

This is a finite union of closed subsets of dimension at most one.  Therefore

```text
dim N <= 1 < 3 = dim Y.
```

The corrected C5 incidence identifies `Y_Kbar` as the smooth geometrically
integral degree-14 Fano threefold, so `N` is proper.  Its complement is a
nonempty open subset.  In particular the generic point `eta_Y` lies outside
`N`; after viewing `eta_Y` as a `K(Y)`-point, no element of
`Gamma(K(Y))` moves it into the fixed-frame image.  This proves the theorem.

## 4. Exact consequence for Goal B

The proposed **exhaustiveness theorem is false**, not merely unproved.  The
selected frame misses the generic rational orbit, and in fact misses a dense
open family of geometric orbits.  Thus fixed-frame pointlessness cannot be
promoted to genuine Fano pointlessness by five-plane-preserving normalization.

The authorized Task B exit is

```text
B-BRIDGE-REFUTED
```

This is not the forbidden promotion of a geometric dimension count to a
headline.  Finiteness of the effective gauge action first turns the proposed
normalization into a finite orbit-saturation; the strict dimension inequality
then gives the explicit generic-point counterexample required by B1.  The
headline is left open.

## 5. What is not concluded

The argument does not construct a point over the original field `K_proj`.
Therefore it does not decide either of the single-field statements

```text
F14_T(K_proj) = empty,
X_gen(K_proj) = empty.
```

Nor does it formally negate the bare implication

```text
C(K_proj)=empty => F14_T(K_proj)=empty,
```

which could hold for an unrelated arithmetic reason or vacuously.  It proves
that **exhaustiveness cannot be that reason**.  Any remaining negative proof
must attack `F14_T` or `X_gen` directly; any positive proof must construct a
`K_proj` common line or twist point.  Those are C/C5 and other headline fronts,
not an unfinished part of B.

## 6. Sources consumed

Repository inputs:

- the sealed historical B object dictionary: definitions of `C_K^open`,
  `Sigma`, `F14_T`, and `Gamma`;
- the C0 structural audit: the split target is the smooth degree-14 Fano
  threefold of genus eight and Picard number one;
- corrected C5 status: the genuine incidence is a geometrically integral
  projective threefold of dimension three and degree fourteen, with exhaustive
  projective/Morita chart covers.

Classical external pin:

- A. Kuznetsov, Y. Prokhorov, and C. Shramov, *Hilbert schemes of lines and
  conics and automorphism groups of Fano threefolds*, Japanese Journal of
  Mathematics **13** (2018), Theorem 1.1.2.
