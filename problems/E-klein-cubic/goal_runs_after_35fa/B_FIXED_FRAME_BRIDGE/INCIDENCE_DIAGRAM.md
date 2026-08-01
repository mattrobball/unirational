# Incidence and implication diagram

## Sound diagram

```text
selected full cubic C_K  -- closed projective linear slice -->  Z_aux=V(c3)
        | restrict to c2!=0                                  ^
        v                                                     | open immersion
selected spectral open C_K^open  --->  P_aux=Z_aux cap D(c2) ---> I_sigma
                                                |
                                                | open immersion
                                                v
                                             P^2_D
                                                ^
                                                | five-form incidence locus
                                                |
F14_T = {common isotropic right D-lines for H_T}
        | genuine Pfaffian incidence; sufficient
        v
X_gen(K) nonempty
        | accepted generic-twist/versal-compression criterion
        v
G-unirationality of the Klein cubic
```

There is no upward implication from emptiness of the selected slice.

## Arrow ledger

| Arrow | Classification | Field/gauge boundary |
|---|---|---|
| `C_K -> Z_aux` | closed projective linear slice, equivalently intersection with `P(<S0,S1,S2>)` | defined over `K` after the ordered base change `F -> K` |
| `C_K^open -> P_aux` | restriction of that slice to `c2!=0`; sufficient construction | defined over `K` |
| `P_aux -> Z_aux` | open immersion | defined over `K`; the full cubic also contains the `c2=0` boundary |
| `P_aux -> I_sigma` | surjective functional-calculus map with section `p -> a=1-p`; not an equivalence because many `a` give one projector | defined over `K` |
| `I_sigma -> P^2_D` | open immersion of lines nondegenerate for `h_struct` | defined over `K` |
| `F14_T -> P^2_D` | closed five-form incidence locus | defined over `K`; it need not be contained in `I_sigma` |
| `I_sigma -> F14_T` | **no implication** | five additional equations `hi(q,q)=0`; full Morita gauge does not preserve `H_T` |
| `F14_T(K) <-> common isotropic right D-line` | equivalence by the definition of the twisted Fano functor | defined over `K`; a split-field line needs descent to count |
| `F14_T(K) nonempty -> X_gen(K) nonempty` | sufficient construction | twisted Pfaffian incidence; a rational line is a `P1_K` of points |
| `X_gen(K) nonempty -> G`-unirational | accepted versal criterion | applies only to the genuine generic twist |
| `X_gen(K) nonempty -> F14_T(K) nonempty` | not asserted | a rational point need not lie on a rational line |
| `C(K)=empty -> I_sigma(K)=empty` | false | `I_sigma(K)` is nonempty by exact Gram--Schmidt/Morita theory |
| `C(K)=empty -> F14_T(K)=empty` | **undecided** | a common line outside the fixed frame is the live bypass; none is currently known |
| `C(K)=empty -> X_gen(K)=empty` | **undecided** | no accepted reverse arrow exists, but lack of an arrow is not a counterexample |

## Exact auxiliary non-exhaustiveness test

The two accepted theorems

```text
I_sigma(K) != empty,
C(K) = empty
```

give the exact rational-point statement

```text
I_sigma(K) - image(C_K^open(K) -> I_sigma(K)) != empty.
```

Thus no rational-gauge procedure can supply a `K`-rational selected-frame
representative for every `K`-rational auxiliary projector.  This is a claim
about the image on `K`-points, not about the scheme-theoretic or geometric
image: a rational image point can in general have only nonrational
preimages.

This does not satisfy B1 for the genuine five-plane: the existing projector
need not obey any of the five equations defining `F14_T`.  In particular it
does not furnish a rational orbit of `F14_T` missed by the frame, and it does
not prove a torsor or quotient obstruction for the stabilizer of `H_T`.

The exact possible bypass is:

```text
F14_T(K) - image(C_K^open(K) -> P^2_D(K)) != empty,
```

i.e. a common isotropic right `D`-line outside the selected fixed frame.

## Formal geometric counterexample

Even without the Pfaffian dictionary, index three of a plane section cannot
force pointlessness of an ambient cubic.  Over

```text
K0=C((s))((t))
```

put

```text
C0: x^3+s*y^3+t*z^3=0,
Y0: x^3+s*y^3+t*z^3+w^2*x+q^3=0.
```

For the `t`-adic valuation, the binary form `x^3+s*y^3` cannot cancel in the
residue field `C((s))`: cancellation would make `-s` a cube, contrary to its
`s`-valuation.  Its nonzero valuation is therefore `0 mod 3`, whereas
`v(t*z^3)=1 mod 3`.  The same argument works after every finite extension of
degree prime to three: its ramification and residue degrees are prime to
three, and `-s` cannot become a cube in such a residue extension.  Hence all
closed-point degrees are divisible by three.  Adjoining a cube root of `-s`
gives the degree-three point `[cube_root(-s):1:0]`, so the index is exactly
three.

The smooth cubic threefold `Y0` contains `[0:0:0:1:0]`.  Its partials are

```text
3*x^2+w^2, 3*s*y^2, 3*t*z^2, 2*w*x, 3*q^2.
```

Their common projective zero would have `y=z=q=0`, then `wx=0` and
`3*x^2+w^2=0`, forcing `x=w=0`, a contradiction.  The independent verifier
checks the point, these partials, and the derivative identities.
Thus any bridge must use special Klein incidence data; it cannot follow from
the formal fact that the fixed curve is a plane section or coordinate slice.
This counterexample refutes that *formal principle*.  It is not a point on
the actual `F14_T` and therefore does not settle B1 by itself.
