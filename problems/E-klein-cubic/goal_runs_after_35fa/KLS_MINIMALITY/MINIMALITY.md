# Exact minimality notion and parametrization bridge

## 1. The literal landing category

Let `S=C[x_0,...,x_4]`, let `W` be the five-dimensional Klein
representation, and let `f3` be the Klein cubic.  A degree-`d`
**Klein-landing tuple** is a nonzero homogeneous `G`-covariant

```text
q=(q_0,...,q_4) in (S_d tensor W)^G
```

such that

```text
f3(q)=0,
generic rank(Dq)=4.
```

It is **primitive** when `gcd(q_0,...,q_4)=1`.  Its projectivization is the
rational map `[q]:P(W) --> X=V(f3)`.

### Primitive presentation uniqueness

If two primitive homogeneous tuples `q` and `q'` define the same projective
rational map, then `q'=lambda*q` for a nonzero scalar `lambda`, and their
degrees agree.

Indeed, the identities `q_i q'_j=q_j q'_i` hold in the UFD `S`.  Over its
fraction field, `q'=a q` for one rational function `a`.  Prime-by-prime
valuation and primitivity of both rows show that `a` and `a^-1` have no
divisorial zeros or poles, hence `a` is a nonzero scalar.  Homogeneity then
forces equal degree.

Consequences:

- multiplication by a common invariant scalar is removed uniquely by
  primitive saturation;
- “common projective factors” are the same operation, not a second quotient;
- birational changes which preserve the rational map literally do not
  change its primitive tuple;
- precomposition by a nontrivial source map does not preserve the rational
  map and is not an equivalence in this category.

### Minimality

If the set of primitive rank-four Klein-landing tuples is nonempty, its set
of positive integer degrees has a least element.  A tuple of that degree is
**minimal**.  This is the exact well-founded notion required in KLS2.0; no
quotient by quartic precomposition or by source Cremona transformations is
needed or valid.

The accepted exhaustive covariant reduction says that a hypothetical
`G`-parametrization supplies at least one homogeneous Klein-landing tuple.
Primitive saturation preserves its projective map and generic rank, and the
well-ordering argument then supplies a minimal representative.  This proves
the KLS2.0 existence bridge at exactly the accepted reduction's scope.

## 2. Quartic precomposition

Let `C:W->W` be the installed primitive quartic equivariant endomorphism.
Its projectivization is finite and surjective.  If `q` is a primitive
rank-four landing tuple of degree `d`, then

```text
q o C
```

is another primitive rank-four landing tuple of degree `4d`.  It defines
`[q] o [C]`, not `[q]`.  Thus it is a new parametrization and cannot be
quotiented away as a map-preserving change.  Iteration produces degrees
`4^n d`; minimality only says that none of these larger tuples is the chosen
least-degree representative.

The pure-pullback implication is valid in the other direction: if a minimal
tuple were known to equal `q_0 o C`, then `q_0` would be a lower-degree
landing tuple.  The installed rank-1,024 `C`-adic decomposition does not
show that an arbitrary tuple is a pure pullback, and derivations mix its
residue terms across the degree-15 ramification divisor.

## 3. The broader KLS category

A **KLS rank-drop tuple** is instead a primitive homogeneous `G`-self-
covariant with `det(Dq)=0` and generic rank four.  Its image is an invariant
unirational hypersurface `H`, not necessarily the Klein cubic.  Least-degree
minimality is again well-defined if this category is nonempty.

The two categories must remain distinct:

```text
Klein-landing  => KLS rank drop,
KLS rank drop =/=> Klein-landing.
```

The conductor and `P22` packets concern the second category until an extra
minimal-contraction theorem forces `H=X`.  They do not supply discrepancy or
conductor data for the first category, whose image is already smooth.

## 4. Exact KLS minimality consequence

For a minimal KLS tuple with image `H=V(F)`, define

```text
h = gcd_i (partial_i F)(q),
adj(Dq)=b v Abar^t,
s=deg(h), r=deg(v), t=deg(b), e=deg(H).
```

The normalized dual Gauss covariant `p=(grad F)(q)/h:W->W*` has degree

```text
m = d(e-1)-s = 4d-4-r-t.
```

Because `W*` is not isomorphic to `W`, minimality applies only after the
quadratic dual Klein polar returns to `W`.  The exact conclusion is

```text
d <= 2m,
r+t <= floor((7d-8)/2).
```

No discrepancy, conductor coefficient, or reduced-support term occurs in
this inequality.

