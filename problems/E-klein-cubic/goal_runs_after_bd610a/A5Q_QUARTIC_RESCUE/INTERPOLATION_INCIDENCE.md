# A5Q degree-four interpolation incidence

## Status and scope

This note gives the exact ambient interpolation criterion needed by A5Q.1.
`SUBGROUP_DESCENT.md` and the two `INDEX11_POINT_CLASS*.json` records supply
the required exact degree-eleven points for both maximal `A_5` classes.  The
raw matrices and nonzero-minor witnesses are in
`modular_index11_discovery.json`; `CHARACTERISTIC_ZERO_LIFT.md` explains why
those good-reduction minors prove the corresponding exact ranks.  Every rank
test is performed separately for the two classes.

Let `K` be the characteristic-zero base field, let `L/K` be a separable field
extension of degree eleven, and let

```text
P = (P_0:...:P_4) in P^4(L).
```

Write

```text
W_P = Span_K(P_0,...,P_4) subset L.
```

The main criterion in this note assumes

```text
dim_K(W_P) = 5.                                      (RANK-5)
```

This hypothesis must be verified exactly.  It is invariant under rescaling
the projective coordinates of `P` by an element of `L^*`.  If it fails, the
rank-one simplification below is not an equivalence; one must return to the
general evaluation/Fitting incidence and separately impose basepoint
freeness.

## 1. Evaluation at a degree-eleven parameter

An exact-degree-eleven point of `P^1(L)` cannot be the point at infinity, so
write it uniquely on the affine chart as

```text
tau = (1:x),   x in L,   K(x)=L.
```

Since `[L:K]=11` is prime, `K(x)=L` is equivalent, for a `K`-rational
element `x`, to `x notin K`.  Put

```text
U_x = Span_K(1,x,x^2,x^3,x^4) subset L.
```

The evaluation map

```text
ev_x : H^0(P^1_K,O(4)) -> L,
       f(s,t)             |-> f(1,x)
```

is injective, because a nonzero polynomial of degree at most four cannot
annihilate an element of degree eleven.  Its image is `U_x`, so it identifies
the five-dimensional spaces `H^0(O(4))` and `U_x`.

### Proposition 1 (power-subspace criterion)

Assume `(RANK-5)`.  The following are equivalent.

1. There are five binary quartics `phi_0,...,phi_4` over `K` and a parameter
   `tau=(1:x)` of exact degree eleven such that

   ```text
   (phi_0(tau):...:phi_4(tau)) = (P_0:...:P_4).
   ```

2. There are `x in L\K` and `lambda in L^*` such that

   ```text
   W_P = lambda * Span_K(1,x,x^2,x^3,x^4).          (1.1)
   ```

When these conditions hold, the quartics are unique after `x` and the
projective interpolation scalar are fixed.

#### Proof

For (1), projective equality gives a scalar `u in L^*` with

```text
phi_j(1,x) = u P_j,  j=0,...,4.
```

The five `P_j` are `K`-independent by `(RANK-5)`, hence so are the five
evaluations `uP_j`.  They lie in the five-dimensional space `U_x`, and
therefore span it.  Thus `uW_P=U_x`, which is (1.1) with
`lambda=u^{-1}`.

Conversely, suppose (1.1) holds.  Each `lambda^{-1}P_j` belongs to `U_x`, so
there is a unique binary quartic `phi_j` satisfying

```text
phi_j(1,x) = lambda^{-1}P_j.
```

These equalities give the required projective interpolation.  QED.

## 2. Coordinate-free rank-one multiplication criterion

Let `q:L -> L/W_P` be the quotient map.  For `x in L`, define

```text
mu_x : W_P -> L/W_P,
       w       |-> xw mod W_P.                       (2.1)
```

Adding an element of `K` to `x` does not change `mu_x`.  Thus multiplication
induces a `K`-linear map

```text
bar_mu : L/K -> Hom_K(W_P,L/W_P),
         x mod K |-> mu_x.                            (2.2)
```

Its kernel is zero.  Indeed, if `xW_P subset W_P` and `x notin K`, then
`K[x]=L`; hence `W_P` is stable under multiplication by all of `L`.  A
nonzero element of `W_P` would then generate all of the field `L` inside
`W_P`, contradicting `dim_K(W_P)=5`.

### Proposition 2 (rank-one criterion)

Under `(RANK-5)`, the equivalent conditions of Proposition 1 hold if and
only if there is `x in L\K` such that

```text
rank_K(mu_x) <= 1.                                    (2.3)
```

For such an `x`, the rank is exactly one.

#### Proof

If `W_P=lambda U_x`, multiplication by `x` sends

```text
lambda*Span(1,x,x^2,x^3,x^4)
```

into `W_P` except for the single new direction `lambda*x^5`.  Since the
powers through `x^5` are independent, `mu_x` has rank one.

Conversely, suppose (2.3) holds.  Rank zero is impossible by the injectivity
argument following (2.2), so

```text
H = W_P intersect x^{-1}W_P
```

has dimension four.  For `r=0,...,4`, set

```text
H_r = W_P intersect x^{-1}W_P intersect ... intersect x^{-r}W_P.
```

The adjacent spaces `x^{-(r-1)}W_P` and `x^{-r}W_P` meet in a hyperplane of
`x^{-(r-1)}W_P`.  Since `H_{r-1}` is contained in that latter space,
intersecting with `x^{-r}W_P` lowers dimension by at most one.  Therefore

```text
dim_K(H_r) >= 5-r.
```

Choose `0 != lambda in H_4`.  Then

```text
lambda, lambda*x, ..., lambda*x^4 in W_P.
```

These five elements are independent: after cancelling the nonzero field
element `lambda`, a dependence would give a polynomial of degree at most four
annihilating the degree-eleven element `x`.  They consequently form a basis
of `W_P`, proving (1.1).  QED.

This proof is also an extraction algorithm.  Once an exact `x` is known,
solve the four membership conditions

```text
x^r lambda in W_P,  r=1,2,3,4,
```

for a nonzero `lambda in W_P`, and then express each
`lambda^{-1}P_j` in the power basis `1,x,...,x^4` to obtain the five binary
quartics.

## 3. Determinantal and Fitting formulation

Fix a `K`-basis `e_0=1,e_1,...,e_10` of `L`.  Let

- `B` be the `11 x 5` matrix whose columns are the coordinates of
  `P_0,...,P_4`;
- `N` be any `6 x 11` full-rank quotient matrix satisfying `NB=0`, so that
  `ker(N)=W_P`;
- `M_a` be the `11 x 11` multiplication matrix for `e_a` on `L`.

For the universal element `X=sum_a X_a e_a`, put

```text
T(X) = N * (sum_a X_a M_a) * B.                       (3.1)
```

This is a `6 x 5` matrix of linear forms.  Because `NB=0`, the scalar
coordinate `X_0` disappears.  Choosing coordinates `Y_1,...,Y_10` on `L/K`
gives

```text
T(Y) in Mat_{6 x 5}(K[Y_1,...,Y_10]).
```

The rank-one incidence is the projective determinantal locus

```text
D_W = V(I_2(T)) subset P(L/K) = P^9_K,                (3.2)
```

where `I_2(T)` is generated by all `2 x 2` minors.  Equivalently it is the
appropriate Fitting degeneracy locus

```text
I_2(T) = Fitt_4(coker(T))
```

for the presentation `O(-1)^5 -> O^6`.  A `K`-point of `D_W` is exactly a
nonzero class `x mod K` for which (2.3) holds, and hence exactly a quartic
interpolation solution.

Geometrically, (2.2) embeds `P(L/K)=P^9` linearly in
`P(Hom(W_P,L/W_P))=P^29`; `D_W` is its intersection with the rank-one Segre
variety

```text
P(L/W_P) x P(W_P^*) = P^5 x P^4 subset P^29.
```

The Segre variety has dimension nine.  Thus the naive expected dimension is

```text
9 + 9 - 29 = -11.
```

This explains why the rescue is high risk, but it is only a dimension
heuristic.  It is not an emptiness proof for either installed class.

For comparison, at a fixed `x` one may also form

```text
U_x = Span_K(1,x,x^2,x^3,x^4)
theta_x : L -> (L/U_x)^5,
          u |-> (uP_j mod U_x)_{j=0}^4.
```

The fixed-parameter interpolation condition is `ker(theta_x) != 0`, or
equivalently `rank(theta_x)<=10`; in quotient bases this is the vanishing of
all `11 x 11` minors of a `30 x 11` matrix.  Proposition 2 replaces this much
larger system by the `2 x 2` minors in (3.2) when `(RANK-5)` holds.

### Exact-degree and geometric-fibre warning

For a `K`-rational element of the prime-degree field `L`, `x notin K` already
means exact degree eleven.  In an elimination or modular calculation after
base change, however, `L tensor_K Kbar` is a product, not a field.  Raw
geometric points of `V(I_2(T))` can arise from idempotents or zero divisors and
need not encode a degree-eleven parameter.

Accordingly, any full scheme-theoretic incidence used for saturation must
retain the exact-degree and unit opens.  One safe formulation introduces
`lambda=Bz in W_P` and imposes

```text
N M(X)^r Bz = 0,  r=1,2,3,4,                         (3.3)
```

together with

```text
disc(charpoly(M(X))) != 0,
Norm_{L/K}(Bz) != 0.                                  (3.4)
```

The opens in (3.4), or equivalent finite affine covers, exclude the split
algebra artifacts.  For an exact `K`-rational candidate in the field `L`, the
smaller rank-one test (3.2) is already equivalent by Proposition 2.

## 4. The immediate square-space obstruction

Let

```text
W_P^2 = Span_K{ww' : w,w' in W_P} subset L.
```

If quartic interpolation exists, Proposition 1 gives

```text
W_P^2
 = lambda^2 * Span_K(1,x,x^2,...,x^8).
```

The nine displayed powers are independent because `x` has degree eleven.
Therefore

```text
dim_K(W_P^2) = 9.                                    (4.1)
```

In coordinates, form the `11 x 15` product matrix whose columns are the
coordinates of

```text
P_i P_j,  0 <= i <= j <= 4.
```

Its rank is exactly `dim_K(W_P^2)`.  Consequently, an exact verified rank
at least ten proves that **no** exact-degree-eleven parameter and **no**
`K`-defined degree-four interpolation map can pass through this rank-five
point.  A single explicitly recorded nonzero `10 x 10` minor is already a
replayable certificate of this obstruction; exact fraction-free row reduction
is equally acceptable.

This is an unconditional emptiness theorem for the degree-four incidence of
that particular descended point.  It is not a dimension count, modular
sample, bounded-support search, or genericity assertion.

The converse does not follow from (4.1) alone over an arbitrary
characteristic-zero base field.  If the product rank is nine, one must still
solve the rank-one incidence (3.2), or equivalently verify by exact projective
algebra that the six-dimensional quadratic kernel cuts out the required
rational normal quartic.  No `PASS` or `EMPTY` marker may be emitted from the
rank-nine equality by itself.

## 5. Basepoint freeness and nondegeneracy are automatic in rank five

For a solution of Proposition 1, the five elements

```text
lambda^{-1}P_0,...,lambda^{-1}P_4
```

form a basis of `U_x`.  Their coefficient matrix relative to
`1,x,...,x^4` is therefore invertible.  Under `ev_x^{-1}`, the resulting five
binary quartics form a basis of `H^0(P^1,O(4))`.  Hence:

1. they have no common zero, so the map is basepoint-free;
2. the map is the complete degree-four linear series;
3. it is a closed immersion onto a nondegenerate rational normal quartic in
   `P^4`.

Thus no extra resultant, birationality, or nondegeneracy condition is needed
after `(RANK-5)` and the rank-one criterion have been certified.  The separate
condition

```text
F(phi) != 0
```

is **not** automatic.  It must be checked in A5Q.3.  If `F(phi)=0`
identically, the image quartic lies on the twist and belongs to the stronger
rational-curve branch rather than the residual-linear-factor branch.

## 6. `PGL_2` and scalar freedoms

The interpolation scalar and common scaling of all five quartics account for
one `K^*` projective freedom.  Precomposition gives the full `PGL_2(K)`
freedom.  Explicitly, for

```text
x' = (a x + b)/(c x + d),   ad-bc != 0,
```

one has

```text
U_{x'} = (cx+d)^(-4) U_x.                             (6.1)
```

Indeed, after multiplying by `(cx+d)^4`, the five powers of `x'` are the
fourth symmetric-power transform of `1,x,...,x^4`.  Thus a solution
`W_P=lambda U_x` yields the entire `PGL_2` orbit of solutions, with

```text
lambda' = lambda*(cx+d)^4.
```

For an element of degree eleven the stabilizer of `x` in `PGL_2(K)` is
trivial: a nonidentity fixed-point equation would give a polynomial of degree
at most two satisfied by `x`.  Therefore the raw incidence in `x` has
three-dimensional `PGL_2` orbits whenever it is nonempty.

Passing to `P(L/K)` in (3.2) exactly removes translations `x |-> x+b` and
nonzero scalings `x |-> ax`.  A one-dimensional residual fractional-linear
freedom remains.  Any claim that an unquotiented solution incidence is finite
or zero-dimensional must therefore be rejected.  A zero-dimensional solve
must state a third exact `PGL_2` gauge and prove that its finite collection of
charts covers every orbit.  For an emptiness proof, keeping the redundant
determinantal incidence is safer.

## 7. Required exact records and theorem boundary

For each maximal `A_5` class, the replay data record exactly the objects used
by the square-space obstruction:

```text
lazy power-basis/companion multiplication interface
the 11 x 5 specialized conjugate-coordinate matrix
a nonzero rank-5 minor
the 11 x 15 product matrix for W_P^2
a nonzero rank-11 minor
```

The field multiplication interface is in `FIELD_L1.json` and `FIELD_L2.json`.
The point-coordinate and product matrices, pivot columns, and determinant
values are in `modular_index11_discovery.json`, with concise bindings in the
two `INDEX11_POINT_CLASS*.json` files.  No candidate `x` exists: the exact
product rank obstruction below disposes of the full incidence before a
rank-one point, `lambda`, quartic coefficients, quotient matrix `N`, or
instantiated linear matrix `T(Y)` needs to be constructed.  Equations (3.1)
and (3.2) are the exact general incidence specification, not a claim that a
redundant instantiated elimination payload is stored after the prior rank
gate has already proved emptiness.

If an exact product rank at least ten is verified, the conclusion is only:

```text
the degree-four rescue incidence is empty for this specific descended
rank-five degree-eleven point.
```

It does not by itself:

- construct or validate the A5Q.0 subgroup-to-full-twist descent;
- decide the other maximal `A_5` class or another degree-eleven point;
- exclude degree-five or reducible-curve variants;
- prove pointlessness or any negative headline for the full twist;
- justify `A5Q-DEGREE4-RESCUE-EMPTY-SCOPED` until the goal's required class
  coverage and exact input manifest have also been audited.

For both transported points the exact coordinate rank is `5` and the exact
product rank is `11`.  Quartic interpolation would force product rank `9` by
(4.1).  Thus the full incidence is empty for each class, and after the A5Q.0
audit the authorized conclusion is exactly

```text
A5Q-DEGREE4-RESCUE-EMPTY-SCOPED.
```
