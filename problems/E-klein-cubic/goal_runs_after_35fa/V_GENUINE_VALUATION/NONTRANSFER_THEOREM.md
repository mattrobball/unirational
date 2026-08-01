# Fixed-frame infinity nontransfer theorem

## Verdict

```text
V2-FIXED-FRAME-PLACE-NONTRANSFERABLE
```

The genuine Klein-cubic headline remains open.

## Theorem

Let `nu` be the selected `u=infinity` valuation of

```text
K=K_proj=C(P(W))^G
```

above the reciprocal-leading divisor `D` of `F=C(A,B,Y,Z)`.  Then:

1. The selected place of `K/F` has `(e,f)=(1,1)` and residue field
   `C(r,rho,T)`.
2. The selected fixed ternary characteristic cubic has a proper model whose
   smooth special fibre has index three.  Hence that fixed cubic has no
   `K`-point.
3. In the degree-three residual-scalar affine extension
   `K_aff=K(f5)`, the place is totally ramified with inertia `mu3`.  This
   extension is linearly disjoint from the genuine splitting extension
   `L=C(P(W))/K`.
4. The Cramer calculation does not determine genuine `G`-inertia.  If that
   inertia is nontrivial, the genuine twist has a henselian point.  If it is
   trivial, the special fibre is the genuine residue twist and has index one,
   while its point status remains open.
5. The full auxiliary characteristic cubic has a `K`-point and its proper
   closure likewise has a residue point.  The selected fixed ternary frame
   is not exhaustive on that auxiliary cubic.
6. No accepted arrow sends an arbitrary point of the genuine twist or of
   `F14_T` into the selected fixed frame.  A base valuation does not select a
   centre on the function field of `F14_T` without such a point/prolongation.

Therefore the index-three fixed-plane fibre is not the certified special
fibre of a point-obstructing proper model of the genuine twist, the full
auxiliary cubic, or the genuine `F14_T` incidence.  The Goal F specialization
theorem cannot transfer to any of those objects.

## Proof

Statements 1 and 2 are the exact Goal F infinity theorem.  For statement 3,
the independent Cramer replay gives

```text
nu(t)=2.
```

The identity `t=f5^3` holds in `K_aff`, the residual-scalar cover created by
the normalization `f3=1`.  Since `[K_aff:K]=3` and `nu(t)=2`, its Newton
polygon gives

```text
e(K_aff/K)=3, f(K_aff/K)=1.
```

This `mu3` is not a subgroup of genuine torsor inertia.  Indeed, if
`K_aff` met `L` nontrivially, then the Galois `PSL_2(F_11)` extension `L/K`
would contain a degree-three intermediate field.  Its coset action would
give a nontrivial map from the nonabelian simple group to `S3`, impossible.
Thus `K_aff intersect L=K`, proving statement 3 and the uncontrolled-cover
boundary.

For statement 4, apply the exact genuine-torsor dichotomy.  Nontrivial
inertia is central in its decomposition group because the constant field
contains every root of unity; the centralizer census then supplies a stable
point or contained line, hence a henselian point of the twist.  With trivial
inertia, the torsor extends etale and the special fibre is the genuine
residue twist.  Every Klein twist carries effective cycles of degrees
`60,132,165,220`, so that special fibre has index one.  Nothing in this
argument decides its rational point.

Statement 5 follows from the accepted Morita/Gram--Schmidt projector and the
valuative criterion.  It also supplies a direct exhaustiveness
contradiction: if the distinguished-data stabilizer moved every auxiliary
projector into the fixed frame, an existing auxiliary point would produce a
point of the fixed cubic, contradicting statement 2.

Finally, the exact incidence ledger contains only the forward sufficient
arrows

```text
selected fixed frame -> auxiliary structure projector,
F14_T point -> genuine Klein point.
```

It contains neither a map from every auxiliary projector to `F14_T` nor a
map from every genuine point to `F14_T` or to the fixed frame.  Emptiness
cannot be propagated against these arrows.  This proves statement 6 and the
nontransfer conclusion.

## Strong consistency check

Every scalar extension of every genuine Klein twist has effective zero
cycles of degrees `60,132,165,220`, whose gcd is one.  Thus its local generic
index is always one.  This alone does not produce a point, but it rules out
identifying any genuine local generic fibre with an index-three obstruction.
At the present `D`-place the genuine inertia branch is not determined.  The
failure of transfer is nevertheless unconditional: the ramified branch has
a point, while the unramified branch has the genuine index-one residue twist,
and neither branch identifies it with the auxiliary index-three plane.

## Scope

This theorem completely decides the transfer question posed by Goal V2.  It
does not decide genuine inertia at `D`, `F14_T(K)`, `X_gen(K)`,
`ed_C(PSL_2(F_11))`, or the open
unramified residue twists at `f5=0` and `f6=0`.
