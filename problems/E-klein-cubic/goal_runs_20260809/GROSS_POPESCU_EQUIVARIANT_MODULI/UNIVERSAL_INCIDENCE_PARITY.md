# Universal Palatini incidence and the parity obstruction

Let `G=PSL2(F11)`, let `Gtilde=SL2(F11)`, and let `U=V_+` be the
six-dimensional even Weil module.  The central element `z=-I` acts as `-1`
on `U`, while the projective space `P(U^*)` carries the effective `G`-action.

## Even-degree lemma

**Lemma.** Every `G`-stable effective divisor in `P(U^*)` has even degree.

Indeed, let the divisor have homogeneous equation `F` of degree `d`.  Its
stability means that the line spanned by `F` in `Sym^d(U)` is
`Gtilde`-stable, so `Gtilde` acts on that line through a character.
The group `SL2(F11)` is perfect, hence the character is trivial.  But the
central element acts on `F` as `(-1)^d`.  Therefore `d` is even.

The same argument applies to an orbit product of hyperplanes.  In particular,
there is no odd-degree invariant hyperplane average hidden behind Remark 2.8.

## Controlled correspondences from invariant divisors

Let `Gamma subset P(U^*)` be the Palatini quartic.  Away from its exceptional
locus, a point `x in Gamma` lies on a unique ruling line `L_p`, with `p in
V14`, and on a unique center line `N_q`, with `q in K`.  Thus the common
incidence identifies dense opens in the two projective-line bundles

```text
P(U_V14)  -->>  P(E_K^vee).
```

Let `D subset P(U^*)` be a `G`-stable divisor of degree `d` that does not
contain `Gamma` and meets the generic ruling and center lines properly.  The
cycle

```text
C_D = Gamma intersect D
```

then defines a `G`-stable correspondence between `V14` and `K`.  Since both
`L_p` and `N_q` are lines, the two generic projection degrees are

```text
(deg(C_D/V14), deg(C_D/K)) = (d,d).
```

The even-degree lemma therefore forces both degrees to be even.  If `D`
contains the Palatini quartic, remove the quartic factor; its degree is four,
so every remaining proper finite contribution still has even degree.  The
quartic itself contains every ruling and center line and gives no finite
correspondence.

A noninvariant hyperplane has `d=1` and recovers the Fano--Iskovskikh
birational map.  Averaging its orbit replaces that birational slice by an
even-degree multisection.

## Generic-twist interpretation

On the generic `G`-torsor, `P(U^*)` becomes the Severi--Brauer variety attached
to the order-two Schur class of the spin representation.  An odd-degree
zero-cycle would split that class by restriction-corestriction: if an odd
extension killed a 2-torsion Brauer class, corestriction would give the class
itself as zero.  The divisor parity above is the geometric manifestation of
this obstruction.

## Scope

This proves that the universal-hyperplane/Palatini construction cannot yield
an odd-degree bridge by choosing or averaging a divisor in the hyperplane
parameter.  It does not classify every conceivable `G`-equivariant
correspondence between the two threefolds.  In particular, it is not by itself
a non-unirationality theorem for the standard Klein action.
