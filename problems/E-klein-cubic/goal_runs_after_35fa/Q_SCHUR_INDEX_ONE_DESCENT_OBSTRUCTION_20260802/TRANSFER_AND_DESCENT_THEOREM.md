# Coprime-degree descent and obstruction theorem for the Schur twist

## 1. Exact setup

Let

\[
K=K_{\rm Schur}=\mathbf C(\mathbf P(V_6))^G,
\qquad G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

and let `X/K` be the genuine generic Schur twist of the Klein cubic
threefold.  The installed ledger gives a separable effective zero-cycle `Z_3`
of total degree three and a genuine separable closed point `x_55` of degree
55:

\[
\deg Z_3=3,
\qquad x_{55}\in X,
\qquad [k(x_{55}):K]=55.
\]

Thus `X` has the signed degree-one zero-cycle

\[
[x_{55}]-18Z_3,
\qquad 55-18\cdot 3=1.
\]

No effectivity claim is made.

## 2. Universal transfer-annihilation lemma

### Theorem 2.1

Let `A` be a contravariant functor from finite extensions of `K` to abelian
groups, equipped with corestrictions satisfying

\[
\operatorname{cor}_{L/K}\operatorname{res}_{L/K}(a)
=[L:K]a.
\]

Let `a_X in A(K)` be an obstruction class with the point-trivializing
property

\[
X(L)\ne\varnothing
\quad\Longrightarrow\quad
\operatorname{res}_{L/K}(a_X)=0
\]

for every finite extension `L/K`.  Then

\[
a_X=0.
\]

### Proof

Write `Z_3=sum_i n_i[x_i]`.  Point-triviality over every `k(x_i)` and
restriction--corestriction give

\[
\sum_i n_i[k(x_i):K]a_X=3a_X=0.
\]

Applying the same argument to `x_55` gives `55a_X=0`.

Therefore

\[
a_X=(55-18\cdot3)a_X=0.
\]

This proof uses the two effective zero-cycles, not an unsupported
index-one-to-point principle.  QED.

### Corollary 2.2 — fixed abelian cohomological obstructions

Theorem 2.1 kills every *fixed base-field class* with the stated transfer and
point-trivialization properties.  In particular it covers, when defined in
that form:

- ordinary Galois/fppf cohomology classes with restriction/corestriction;
- torsors under tori, finite commutative groups, abelian varieties, and
  semiabelian varieties;
- additive Rost-cycle-module or Amitsur-style base-kernel classes;
- a correspondence-induced commutative torsor class, provided every
  `X(L)`-point canonically neutralizes that class over `L`.

The last qualification is essential.  An arbitrary intermediate-Jacobian
or curve-class torsor is not automatically killed merely because its group
is commutative: one must prove that an `X(L)`-point neutralizes the particular
torsor.  A morphism `X -> P` to the torsor is one sufficient bridge.

### Corollary 2.3 — no commutative torsor recipient

Let `P/K` be a torsor under a commutative algebraic group for which
restriction/corestriction on `H^1` is available.  If there is a `K`-morphism

\[
X\longrightarrow P,
\]

then `P(K)` is nonempty.  Indeed each closed point of `X` neutralizes `P`
over its residue field, and Theorem 2.1 kills `[P]`.

This contains the previously installed semiabelian-torsor no-go theorem and
makes its precise functorial hypothesis explicit.

## 3. Constant finite nonabelian recipients

### Theorem 3.1

Let `F` be a finite constant group over `K`, not assumed abelian, and let
`P/K` be an `F`-torsor.  Suppose

\[
X(L)\ne\varnothing\Longrightarrow P(L)\ne\varnothing
\]

for every finite separable `L/K`; in particular this holds if there is a
`K`-morphism `X -> P`.  Then `P` is trivial.

### Proof

Choose a geometric point of `P`.  Because `F` is constant, the torsor is
represented by a continuous homomorphism

\[
\rho:\operatorname{Gal}(K^s/K)\longrightarrow F
\]

up to conjugacy.  Let `S/K` be the finite Galois extension fixed by
`ker(rho)`.  If `P(L)` is nonempty, the restriction of `rho` to
`Gal(K^s/L)` is trivial; hence `S` embeds in `L` and `[S:K]` divides
`[L:K]`.  Apply this first to the degree-three cycle.  If it has a degree-one
component, then `X(K)` is already nonempty and the hypothesis gives `P(K)`.
Otherwise, because three is prime, the cycle is a single degree-three closed
point and `[S:K]` divides `3`.  The degree-55 point also gives
`[S:K]` dividing `55`.  Hence `[S:K]=1`, `rho` is trivial, and `P(K)` is
nonempty.  QED.

This removes constant finite nonabelian torsor recipients without invoking a
nonexistent nonabelian corestriction.

## 4. Finite descent over the cubic is geometrically empty

### Theorem 4.1

The geometric étale fundamental group of `X` is trivial:

\[
\pi_1^{\rm et}(X_{\bar K})=1.
\]

Consequently the structural map induces an isomorphism

\[
\pi_1^{\rm et}(X)\simeq\operatorname{Gal}(K^s/K),
\]

and base change gives an equivalence between finite étale `K`-schemes and
finite étale covers of `X`.

### Proof

Over `bar K`, `X` is a smooth cubic hypersurface of dimension three in
`P4`.  The Grothendieck--Lefschetz theorem for étale fundamental groups gives
`pi_1^et(X_bar)=pi_1^et(P4_bar)=1`.  The standard fundamental exact sequence
for a geometrically connected variety then identifies `pi_1^et(X)` with the
absolute Galois group of `K`.  QED.

### Corollary 4.2 — finite étale/fppf descent is tautological

Every finite étale torsor over `X` is pulled back from a finite torsor over
`Spec K`.  Since `char K=0`, finite group schemes are étale, so the same
statement covers finite fppf torsors.

In the descent family of such an arithmetic pullback, the neutralizing twist
is the trivial torsor over `X`; its rational points are copies of `X(K)`.
Thus finite descent on `X` supplies no independent geometric emptiness
certificate.  It can only repackage the original point problem.

This is stronger than checking individual finite groups: there is no hidden
geometric finite cover of the cubic threefold on which a new finite descent
obstruction could live.

## 5. A broad connected nonabelian no-go theorem

### Theorem 5.1

Let `H/K` be a simply connected or adjoint semisimple algebraic group with no
simple factor of type `E8`, and assume every exceptional simple factor other
than type `G2` is quasisplit.  Let `P/K` be an `H`-torsor such that

\[
X(L)\ne\varnothing\Longrightarrow P(L)\ne\varnothing
\]

for every finite `L/K`.  Then `P(K)` is nonempty.

### Proof

The degree-three zero-cycle and the degree-55 point push forward to
zero-cycles of those degrees on `P`.  Their signed combination is a
zero-cycle of degree one.  Jodi Black's theorem, *Zero Cycles of Degree One
on Principal Homogeneous Spaces*, arXiv:1009.4621, then gives a `K`-point of
`P`.  QED.

This retires all recipient torsors in Black's theorem class, including the
standard classical simply connected or adjoint semisimple groups.  It does
not assert the corresponding theorem for arbitrary connected linear groups.
Gordon-Sarney--Suresh, *Totaro's Question on Zero-Cycles on Torsors*,
arXiv:1702.00516, show that the broader degree-divisibility principle fails
in general, so an extension beyond the stated class needs a separate theorem.

## 6. What the theorem does and does not settle

The combined results eliminate the following as negative headline routes:

1. the index and elementary obstruction;
2. fixed abelian transfer classes killed by every point field;
3. commutative torsor recipients of the full threefold;
4. constant finite nonabelian torsor recipients;
5. geometric finite étale/fppf descent on the cubic threefold;
6. semisimple recipient torsors covered by Theorem 5.1;
7. the already computed Picard, Albanese, relative Brauer, and higher
   Amitsur packages.

They do **not** prove `X(K)` nonempty.  The following remain logically open:

- effectivizing the degree-one cycle or descending the primitive quartic;
- a cycle-moduli torsor not neutralized by the mere existence of an `X`-point;
- a genuinely nonlinear or point-dependent evaluation obstruction;
- a gerbe or noncommutative torsor outside the finite and semisimple classes
  above, together with a proved point-trivialization bridge;
- a nonconstant-coefficient higher unramified class surviving on the proper
  twist and excluding every point;
- an actual pointless henselian specialization in the surviving valuation
  classes `G` and `11:5`.

Accordingly this is a close-out of the standard descent/obstruction package,
not a binary solution of Goal Q.
