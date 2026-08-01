# Object, field, and incidence map

Put

```text
F = C(A,B,Y,Z),
K = K_proj = C(P(W))^G = Frac(F[u]/(P)),
L = C(P(W)),
G = PSL_2(F_11).
```

The class of `u` is the ordered root selected by the accepted sextic
presentation.  `L/K` is the generic splitting extension of the genuine
projective `G`-torsor.  On the chart `f3=1`,

```text
t=f5^3,  u=f8/f5,  vcoord=f10*f5.
```

Here `f5` is not an element of `L=C(P(W))`.  Choosing `f3=1` lifts a
projective point to the residual-scalar affine cover.  Its invariant field
is

```text
K_aff=K(f5),  [K_aff:K]=3,
```

with Galois group `mu3`.  Confusing `K_aff` with the genuine projective
splitting field `L` is precisely the uncontrolled-extension error excluded
by Goal V2.

The objects over `K` are distinct:

| Object | Definition | Sound implication |
|---|---|---|
| `X_gen` | genuine generic twist of the Klein cubic threefold | a `K`-point is the accepted versal-compression target |
| `F14_T` | five simultaneous isotropy equations on a right quaternionic line | a point is a sufficient construction for a point of `X_gen`; no converse is accepted |
| `P_aux` | full self-adjoint Pfaffian characteristic cubic `c3=0`, on the open `c2!=0` | functional calculus produces a structure projector; the five `F14_T` equations are absent |
| `C_fix` | the selected ternary linear slice of `P_aux` | a point gives an auxiliary projector only |

The accepted Morita/Gram--Schmidt construction gives

```text
P_aux(K) != empty,
```

whereas Goal F proves

```text
C_fix(K) = empty.
```

Thus the selected ternary frame is not exhaustive even inside the auxiliary
projector space.  The missing moduli are the right-quaternionic-line
coordinates outside this slice together with all five simultaneous
isotropy conditions.  A full Morita basis change does not preserve the
distinguished Klein five-plane, and a gauge available only after extending
the field is not a `K`-rational gauge.

## Valuation incidence

The divisor `D=0` is a base valuation on `F`.  Its simple root at `u=infinity`
selects a valuation `nu` on the genuine invariant field `K` with
`(e,f)=(1,1)` relative to `F`.  Consequently every `K`-variety above can be
base-changed to `K_h` and modeled over its valuation ring.  This fact alone
does not identify their special fibres.

```text
base divisor D in F
       |
       | selected u=infinity place, (e,f)=(1,1)
       v
valuation nu of K=K_proj
       |
       +--> fixed proper plane model: residual smooth cubic, index 3
       |
       +--> full P_aux closure: residual point, since P_aux(K) is nonempty
       |
       +--> F14_T model: no centre selected by C_fix and no reverse arrow
       |
       +--> scalar affine cover K_aff/K: totally ramified mu3
       |
       +--> genuine torsor L/K: inertia not determined by that mu3 cover
                 |
                 +--> I_G!=1: X_gen(K_h) is nonempty
                 |
                 +--> I_G=1: genuine index-1 residue twist, point status open
```

A base valuation has a centre on a chosen proper base compactification.  It
does not by itself choose a centre on the function field of `F14_T`; that
requires a point or a prolongation of the valuation to that function field.
The empty fixed slice supplies neither.  This is the precise sense in which
the requested `F14_T` centre is absent rather than merely uncomputed.

The two covers above are linearly disjoint over `K`.  Indeed, their
intersection has degree dividing three.  A nontrivial intersection would be
a degree-three intermediate field of the Galois `G`-extension `L/K`, hence
would give an index-three subgroup of `PSL_2(F_11)`.  The induced action on
three cosets would map the nonabelian simple group into `S3`, which is
impossible.  Scalar `mu3` ramification therefore supplies no genuine
`G`-inertia element.

## Distinct target branch

The fixed-frame infinity divisor satisfies

```text
lc_u(P)=0, u=infinity, (e,f)=(1,1) for K/F.
```

The separate finite double-root target branch satisfies

```text
lc_u(P)!=0, P=P_u=0, P_uu!=0, (e,f)=(2,1) for K/F.
```

Their centres lie on disjoint coefficient opens and their ramification
indices over `F` differ.  They are not the same valuation, even if their
residue fields happened to be abstractly birational.
