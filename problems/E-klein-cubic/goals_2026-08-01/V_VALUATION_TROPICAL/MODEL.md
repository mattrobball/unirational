# The genuine generic twist and its valuation boundary

## 1. Actual object

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\{F=0\}\subset \mathbf P(W),\qquad
F(x)=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}.
\]

Put

\[
Y=\mathbf P(W)/G,qquad K=\mathbf C(Y),
\]

and let `T/K` be the generic projective `G`-torsor.  The variety under
valuation is the genuine twist

\[
X_T={}^T X/K.
\]

The five primitive covariants

```text
x, C, D, E, K                 degrees 1,4,5,6,7
```

form a Hilbert--90 frame over the affine generic field.  In that frame the
equation is

\[
\Phi(a)=F(a_0x+a_1C+a_2D+a_3E+a_4K).
\]

The exact expansion has all 35 degree-three monomials in the five `a`
variables.  A weight-one local gauge converts this affine frame into a frame
over the projective invariant field at any named divisor where the gauge is a
unit.  A failure of one chosen gauge or of the determinant of this chosen
frame is not a degeneration of `X_T`; the twist itself is smooth.

The `xCD` plane curve and the minimal Pfaffian ternary cubic are not
interchangeable with `X_T`:

- a point on the `xCD` plane is a point on `X_T`, so local solubility of that
  plane retires a valuation of the full twist;
- pointlessness of the `xCD` plane does not exclude a point of `X_T` using
  the `E` or `K` directions;
- the minimal Pfaffian ternary cubic is an auxiliary characteristic cubic.
  Its local points or nonpoints do not reach `X_T` without the missing
  simultaneous-isotropy bridge.

## 2. Universal local index-one theorem

Every Klein twist has effective zero-cycles of degrees

\[
60,\quad132,\quad165,\quad220
\]

coming from the fixed points of `C11`, `C5`, `V4`, and `C3`.  Their gcd is
one; explicitly,

\[
-13\cdot60+3\cdot132+165+220=1.
\]

Let `v` be any valuation of `K`, of arbitrary rank, and let `K_v` denote its
completion (or henselization).  Base change preserves the total degree of
each of the four zero-cycles.  Hence

\[
\operatorname{ind}(X_T\otimes_KK_v)
\mid\gcd(60,132,165,220)=1,
\]

so

\[
\boxed{\operatorname{ind}(X_T\otimes_KK_v)=1.}
\]

This rules out, for the genuine twist, every proposed valuation certificate
whose conclusion is any of the following:

- local index divisible by three;
- special-fibre degree subgroup `3 Z`;
- absence of a degree-prime-to-three zero-cycle;
- a regular-model multiplicity theorem whose stated consequence is local
  index divisible by three.

It does **not** rule out a pointless index-one completion.  That is the same
index-one-versus-point boundary already present globally.

## 3. Smooth divisorial reduction and the covariant-divisor theorem

The exact stabilizer census shows that the nonfree locus in `P(W)` has
dimension at most two.  Therefore the generic point of every divisor lies in
the free locus.  For a divisor `Q` of `Y` obtained from a `G`-stable divisor
upstairs, the generic projective torsor extends, after localizing at `Q`, to a
finite etale torsor over the DVR.  Twisting the constant smooth cubic gives a
smooth proper DVR model.  Properness and Hensel's lemma give

```text
X_T(K_Q) is nonempty  <=>  the residue twist has a k(Q)-point.
```

Now let `V:W -> W` be a nonzero homogeneous `G`-covariant and put

\[
h_V=F(V).
\]

On every component of `h_V=0` on which `V` is generically nonzero, the map

\[
[w]\longmapsto[V(w)]
\]

is a rational `G`-map to `X`.  Twisting adjunction gives a point on the
residue twist, and smooth Hensel lifting gives a point on the completion.

For each primitive frame vector `x,C,D,E,K`, the exact gcd of its five
coordinate polynomials is one.  Thus none has a divisorial base locus.  The
five diagonal coefficient divisors

\[
F(x)=0,\quad F(C)=0,\quad F(D)=0,\quad F(E)=0,\quad F(K)=0
\]

of respective source degrees

```text
3, 12, 15, 18, 21
```

are locally soluble component by component.  In particular `F(x)=f3` and
`F(C)=f12`, so the named `f3` and `f12` boundary divisors cannot obstruct the
genuine twist.

This is a point theorem for the full five-coordinate twist, not merely for a
plane section.

## 4. Inertia theorem: every ramified valuation is locally soluble

Let `v` be a Krull valuation of `K` trivial on `C`, replace `K` by its
henselization, and choose a prolongation to the generic `G`-splitting field.
Write `D` for the decomposition group and `I` for inertia.  The base-changed
`G`-torsor is induced from the resulting `D`-torsor, so its twist is the
twist of `X|_D` by that local `D`-torsor.

Because both the field and residue field have characteristic zero, there is
no wild inertia.  Tame inertia embeds into the character group of the finite
value-group quotient.  The decomposition group acts trivially on the value
group and fixes all roots of unity in `C`; consequently

\[
I\text{ is abelian and }I\subset Z(D).
\]

Choose a nonidentity `g` in `I`.  Then `D` is contained in `C_G(g)`.  The
independent exact 660-element census in `inertia_centralizers.json` gives

| order of `g` | order and type of `C_G(g)` | point construction |
|---:|---|---|
| 2 | `12`, nonabelian `D12` | `P(E_-(g))=P1` is `C_G(g)`-stable and contained in `X` |
| 3 | `6`, abelian `C6` | its involution minus-line is stable and contained in `X` |
| 5 | `5`, cyclic | a projective eigenline is a fixed point on `X` |
| 6 | `6`, abelian `C6` | its involution minus-line is stable and contained in `X` |
| 11 | `11`, cyclic | a coordinate eigenline is a fixed point on `X` |

These are all nonidentity element orders in `G`.  A stable two-dimensional
linear subspace twists to a two-dimensional vector space, so its
projectivization is a split `P1` over the henselian base.  A projectively
fixed point twists to a point.  Therefore

\[
\boxed{I\ne1\ \Longrightarrow\ X_T(K_v^h)\ne\varnothing.}
\]

This includes arbitrary-rank valuations; it is not a divisorial-only
statement.

## 5. Unramified reduction is the only local obstruction boundary

If `I=1`, the splitting extension is unramified.  The torsor extends as a
finite etale torsor of henselian valuation rings, and twisting the constant
smooth cubic gives a smooth proper model.  Smooth Hensel lifting and proper
reduction give the exact equivalence

```text
X_T(K_v^h) is nonempty
    <=> the residue D-twist of X has a k(v)-point.
```

If `k(v)=C`, the residue torsor is trivial.  Combining this with the
ramified theorem shows that **every valuation with residue field `C` is
locally soluble**.  Thus full-rank monomial/flag valuations with closed
centre cannot be negative sites.

The unramified equivalence explains the surviving `f5` and `f6` gates.  At
their generic divisors the quotient torsor is unramified but has a nontrivial
generic residue torsor over a field of positive transcendence degree.  Its
full residue twist can still be pointless; the inertia theorem does not
decide it.

## 6. Tropical nonintersection is impossible in every rank

Let `Gamma_K` be the value group.  If inertia is nontrivial, the local point
just constructed supplies a tropical point.  If inertia is trivial, the
splitting field has the same value group as the base.  Over that splitting
field choose a constant point of `X` away from the five coordinate
hyperplanes of the Hilbert--90 frame.  Its five nonzero frame coordinates
have values in `Gamma_K`; since their substitution in `Phi` is zero, the
minimum term value is attained at least twice.  Hence

\[
\operatorname{Trop}(\Phi)(\Gamma_K)\ne\varnothing
\]

for **every rank**.  A Newton/tropical obstruction can only occur in the
residue initial forms, and in the unramified case that residue problem is
exactly the residue twist point problem above.

### Rank-one coefficient-only lemma

Let `v` be a discrete rank-one valuation, normalized to value group `Z`, and
write `c_alpha=v(Phi_alpha)` for the 35 nonzero coefficients of `Phi`.

### Lemma

The tropical hypersurface of `Phi` contains an integral point of
`Z^5/Z(1,1,1,1,1)`.

### Proof

Consider the five pure-cube coefficients `c_(3e_i)`.  Two are congruent
modulo three.  Restrict the lifted Newton polytope to the binary edge joining
the corresponding pure cubes.  Its lower Newton polygon has total horizontal
length three.

- If it has more than one edge, one edge has horizontal length one, hence
  integral slope.
- If it has one edge of length three, its slope is integral because the two
  endpoint heights are congruent modulo three.

Choose the integral difference of the two coordinate weights to be the
negative of that slope.  Give the other three coordinates sufficiently large
integral weights.  Exactly the terms on the chosen lower edge are minimal,
so the minimum is attained at least twice.  This is an integral tropical
point.  QED.

The all-rank torsor/inertia theorem supersedes the final scope restriction of
this combinatorial lemma.  A viable tropical proof would have to show that
the unramified residue twist has no point, including all cancellation and
boundary charts; this is no longer a value-group nonintersection problem.

## 7. Exact remaining negative gate

The universal index, ramified-inertia, closed-residue, and all-rank
tropical-support mechanisms are exhausted.  A headline-negative valuation
must now be unramified and have a full five-coordinate residue twist which is
pointless despite index one, or an equivalent nonconstant unramified residue
invariant evaluating on every section.

There is also a complementary completion theorem for standard geometric
Parshin chains.  The `D12` line gives every twist an effective zero-cycle of
degree `55`.  Coray's complete-DVR theorem for cubic forms converts its
prime-to-three field point into a base-field point whenever the residue
field has the same Cassels--Swinnerton-Dyer property.  Iterating from a
terminal residue field of transcendence degree at most one over `C` proves
actual solubility over every standard successive complete-DVR field of a
length-three or length-four saturated Parshin chain on `K_proj`.  This is a
completion theorem, not a henselization statement, and it does not cover
rank-one or rank-two chains.

The two smallest installed smooth-reduction candidates are the quotient
divisors `f5=0` and `f6=0`.  Their `xCD` plane sections remain undecided, and
the full five-coordinate residue cubics are strictly larger point problems.
The current exact bounded screen excludes homogeneous full-frame points
through degree 15 at `f5`, through degree 14 at `f6`, and gives a strict
timeout/nonverdict at degree 15 for `f6`.  The next `f5` case, degree 16,
also times out after five minutes with 19 variables and 151 independent
cubics.  No bounded range is an all-degree theorem.
