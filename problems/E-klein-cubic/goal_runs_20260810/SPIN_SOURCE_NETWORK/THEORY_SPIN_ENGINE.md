# The spin-source fixed network — the general engine

Status: **DERIVED**. Every statement below is proved here from
[I] (`FIX_I_bcomplex.md`), Cor T3.1 (`FIX_T_gate.md`) and elementary
representation theory. Nothing is imported from the withdrawn
"every stratum stays RCC" claims, and no Chow projector is used.
The exact instantiation and all numerical claims are in
`KLEIN_SPIN_COMPLEX.md` (Part 2) and `NEW_EXAMPLE.md` (Part 3), and are
machine-checked by `verify_spin_klein_network.py` and
`verify_spin_dp2_psl27.py`.

## 0. Setting and conventions

`G` a finite group, `1 -> <z> -> Gtilde -> G -> 1` a central extension with
`z^2 = 1`, `z != 1` (a *double cover*). A representation `V` of `Gtilde` is a
**spin source** if `z` acts as `-id`; it is *faithful* if `Gtilde` acts
faithfully. The induced `G`-action on `P(V)` is assumed faithful — this is
automatic when `V` is faithful and no `g != 1` has all its lifts scalar.

The source dichotomy for projective `G`-sources is clean and is recorded in
[IX §6]: a `G`-action on a projective space is either `P(linear)` or
`P(pure spin)`, because a mixed sign for `z` is non-scalar and does not
descend. The linear-source theorems (Cor T3.1, Cor IX.1) quantify over all
faithful *linear* sources; everything below quantifies over all faithful
*spin* sources.

Throughout, `Y` is a smooth projective `G`-variety over `C` with faithful
action, and `phi : P(V) --> Y` is a `G`-equivariant rational map (dominance
is **never** assumed unless stated).

Write `i = sqrt(-1)`.

## 1. Involutions whose lifts have order four

**Definition 1.1.** For an involution `sigma` in `G` with lift `sigmatilde`,
the element `sigmatilde^2` lies in `<z>` and does not depend on the lift
(`(z sigmatilde)^2 = sigmatilde^2`). Call `sigma` **spin-obstructed** if
`sigmatilde^2 = z`, i.e. `sigmatilde` has order 4.

**Lemma 1.2 (the swapped pair).** Let `sigma` be spin-obstructed and `V` a
faithful spin source. Then `sigmatilde^2 = -id`, so

    V = V_{+i} (+) V_{-i},

both summands nonzero (otherwise `sigmatilde = +-i.id` and `sigma` would act
trivially on `P(V)`), and

    P(V)^sigma  =  P(V_{+i})  disjoint-union  P(V_{-i}),

a pair of disjoint linear subspaces spanning `P(V)`. Each is irreducible,
rational and pointwise `sigma`-fixed.

**Lemma 1.3 (the index-two stabiliser and the swap).** Put `N = C_G(sigma)`.
For `g` in `N` and any lifts, `gtilde sigmatilde gtilde^{-1}` is a lift of
`sigma`, hence equals `sigmatilde` or `z sigmatilde = sigmatilde^{-1}`.
Define

    eps : N -> {+1,-1},   gtilde sigmatilde gtilde^{-1} = sigmatilde^{eps(g)}.

`eps` is well defined (independent of both lifts, `z` being central) and is a
homomorphism. Set `N_0 = ker(eps)`. Then

1. `N_0` **stabilises each** of `P(V_{+i})`, `P(V_{-i})`;
2. every `g` in `N \ N_0` **interchanges** them; indeed for `v` in `V_{+i}`,
   `sigmatilde(gtilde v) = gtilde sigmatilde^{-1} v = -i gtilde v`;
3. if `eps` is onto then `[N : N_0] = 2` and
   `dim V_{+i} = dim V_{-i} = (dim V)/2`.

Call `sigma` **swap-realised** when `eps` is onto. Equivalently: some element
of `C_G(sigma)` inverts `sigmatilde`.

This is the precise form of the "escape shape" of [IX §6]: a spin source
offers, for each involution, not a single `N`-stable stratum (as in the
linear case, where `P(V_+)` is `C_G(sigma)`-stable) but a **swapped pair of
`N_0`-stable strata**.

## 2. Klein four-groups: the commutator pairing and the Q8 criterion

**Definition 2.1.** For commuting `a, b` in `G` put `c(a,b) = [atilde,btilde]`
in `<z>`. This is independent of the lifts, and on any abelian subgroup
`A <= G` it is an alternating bimultiplicative pairing `A x A -> <z>`.

**Proposition 2.2 (exact criterion for a fixed point).** Let `A <= G` be
abelian with preimage `Atilde`, and `V` any faithful spin source. Then

    P(V)^A != empty   <=>   Atilde is abelian   <=>   c|_{A x A} = 1.

*Proof.* A point of `P(V)^A` is a line `L` on which `Atilde` acts by a
linear character `lambda`, necessarily with `lambda(z) = -1`. If `Atilde` is
nonabelian then `[Atilde,Atilde]` is a nontrivial subgroup of the central
`<z>`, hence equals `<z>`; every linear character of `Atilde` kills its
commutator subgroup, so `lambda(z) = 1`, a contradiction. Conversely if
`Atilde` is abelian, `V|_{Atilde}` is a sum of characters, each with
`lambda(z) = -1`, and each gives a fixed point. The second equivalence is the
definition of `c`. `QED`

**Corollary 2.3 (the V4 / Q8 dichotomy).** Let `A ~ V_4`. Its preimage
`Atilde` has order 8 with `Atilde/<z> ~ V_4`; if nonabelian it is `D_8` or
`Q_8`, and in both cases `[Atilde,Atilde] = <z>`. Hence for **every** faithful
spin source `V`:

    P(V)^{V_4} != empty  <=>  the preimage of V_4 is abelian
                         <=>  V|_{Atilde} has a 1-dimensional summand.

If moreover every involution of `A` is spin-obstructed and `Atilde` has a
unique involution, then `Atilde = Q_8` and

    V|_{Q_8} = (dim V / 2) . H,     H = the 2-dimensional quaternionic irreducible,

with **no** 1-dimensional summand, so `P(V)^{V_4} = empty`. The criterion is
multiplicity-free: it holds for every faithful spin `V` at once.

*Note.* This is the exact sense in which "quaternionic" is the right word:
the obstruction is the nonvanishing of the commutator pairing, and `Q_8`
versus `C_4 x C_2` is what it measures.

## 3. The source fixed network

**Definition 3.1.** Let `V` be a faithful spin source. A **spin stratum** is
a pair `(H, lambda)` with `H <= G`, `Htilde` its preimage, and `lambda` a
linear character of `Htilde` with `lambda(z) = -1` (a *spin linear
character*) and `V_lambda != 0`. Its geometric realisation is the linear
subspace `P(V_lambda) <= P(V)`, which is exactly the set of points of `P(V)`
whose stabiliser contains `H` and whose `Htilde`-character is `lambda`.

**Proposition 3.2 (everything is character theory).**

1. `dim V_lambda = <chi_V|_{Htilde}, lambda>`.
2. `P(V)^H != empty` iff `Htilde` has a spin linear character occurring in
   `V`. In particular `P(V)^H = empty` whenever `Htilde` is perfect, or more
   generally whenever `z` lies in `[Htilde,Htilde]`.
3. **Incidence.** For strata `(H,lambda)`, `(K,mu)` put
   `Ltilde = <Htilde, Ktilde>`. Then
   `V_lambda n V_mu = V_nu` where `nu` is the unique linear character of
   `Ltilde` restricting to `lambda` and `mu` — and `V_lambda n V_mu = 0` if
   no such character exists. *Proof:* a common eigenvector `v` has
   `Ltilde . Cv = Cv`, so `Cv` is a 1-dimensional `Ltilde`-subrepresentation.
4. **Stabilisers.** `g . P(V_lambda) = P(V_{lambda^g})`; the stabiliser of the
   stratum is `{g in N_G(H) : lambda^g = lambda}`.

So the whole network — strata, dimensions, incidences, stabilisers, and the
swap parities of Lemma 1.3 — is computed from the character table of
`Gtilde` plus the subgroup lattice of `G`. No geometry and no search.

The **cyclic layer** of the network (the case `H` cyclic) already carries all
the incidence information, by 3.2(3): joint eigenspaces of cyclic subgroups
are the strata of the groups they generate.

## 4. The carrier theorem for swapped pairs

The accepted single-carrier theorem is Cor T3.1 / Cor IX.1: for a **linear**
source, `P(V_chi)` is `C_G(z)`-stable, so its image is a single
`C_G(z)`-fixed point and `Y^{C_G(z)} = empty` is a contradiction. For a spin
source the stratum is only `N_0`-stable, and this is the whole difficulty.

**Theorem 4.1 (spin carrier theorem).** Let `sigma` be spin-obstructed and
swap-realised, `N = C_G(sigma)`, `N_0 = ker(eps)`. Assume

* **(a)** no positive-dimensional irreducible component of `Y^sigma`
  contains a rational curve.

Let `phi : P(V) --> Y` be equivariant. Then there are points `y_+`, `y_-` of
`Y^sigma` such that

1. the carrier stratum over `P(V_{+i})` is contracted to `y_+`, that over
   `P(V_{-i})` to `y_-`;
2. `y_+` and `y_-` are fixed by `N_0`;
3. the elements of `N \ N_0` interchange `y_+` and `y_-`.

*Proof.* Verbatim the induction of Cor IX.1 with `C_G(z)` replaced by `N_0`
and `P(V_chi)` by `P(V_{+i})`. Resolve equivariantly (char-0 equivariant
Hironaka, [I, Prop 3.3]) to `pitilde : X -> P(V)` with
`phitilde : X -> Y` a morphism. Starting from `F_0 = P(V_{+i})` — irreducible,
rational, pointwise `sigma`-fixed, `N_0`-stable because `N_0` commutes with
`sigmatilde` — run the tower: at a centre `Z` with `F` not inside `Z` take
the strict transform; with `F` inside `Z` split `N_Z|_F` into
`sigma`-eigen-subbundles and take `P(N_lambda|_F)` for a nonzero one. At each
stage the stratum stays irreducible, RCC ([I, Lem 4.3]), pointwise
`sigma`-fixed and `N_0`-stable. At the top, `phitilde(Ftilde)` is an
irreducible RCC closed subvariety of `Y^sigma`; by (a) and going-down
[I, Lem 4.2] it is a point `y_+`, and `N_0`-stability plus equivariance give
`y_+` in `Y^{N_0}`. Applying `g` in `N \ N_0` carries `P(V_{+i})` to
`P(V_{-i})` and hence `y_+` to `y_-`. `QED`

**Corollary 4.2 (why the sigma level alone is non-obstructing).** Theorem 4.1
forces only `Y^{N_0} != empty` together with a free `N/N_0`-action on the
pair `{y_+, y_-}`. It does **not** force `Y^N != empty`. So the hypothesis
`Y^N = empty` that kills every linear source (Cor IX.1(b)) is *compatible*
with a spin source: the two-element `N`-orbit `{y_+, y_-}` with stabiliser
`N_0` is exactly what a spin source needs, and Cor IX.6 shows this escape is
not hypothetical but realised at `D_12` level. Any spin obstruction must be a
statement about **several involutions at once**.

## 5. Rigidity: the carrier assignment is injective in sigma

This is the new content that the single-carrier theorem does not see.

**Theorem 5.1 (rigidity).** Assume (a) of Theorem 4.1 for every involution,
and

* **(b')** for every involution `sigma` and every `y` in `Y^{N_0(sigma)}`,
  `sigma` is the **unique** involution of `Stab_G(y)`.

Then for the assignment `(sigma, eps) |-> y(sigma, eps)` of Theorem 4.1:

    y(sigma, eps) = y(tau, delta)   =>   sigma = tau,
    y(sigma, +)  !=  y(sigma, -)    whenever eps is onto.

*Proof.* The first is immediate from (b'): the common point has both `sigma`
and `tau` in its stabiliser. For the second: if `y(sigma,+) = y(sigma,-)`
then by 4.1(3) that point is fixed by all of `N`, so `Stab_G(y)` contains
`N = C_G(sigma)`, which contains involutions other than `sigma` as soon as
`N != <sigma> x (odd)`; in the swap-realised case `N \ N_0` contains an
element inverting `sigmatilde`, and `N` contains more than one involution
whenever `|N| > 2` — contradicting (b'). `QED`

Two practical ways to verify (b'):

* **Lattice criterion.** If `Y^H = empty` for every `H` properly containing
  `N_0(sigma)` in the subgroup lattice of `G`, then `Stab_G(y) = N_0(sigma)`
  exactly, and (b') holds as soon as `N_0(sigma)` has a unique involution
  (e.g. `N_0 = C_6 = <sigma> x C_3`).
* **Tangent criterion.** At a fixed point `y` of a finite `H` acting
  faithfully on a smooth `Y`, `H` embeds into `GL(T_y Y)`. Hence
  `Y^H = empty` for every `H` with no faithful `dim Y`-dimensional
  representation. For `dim Y = 2` this kills `A_4`, `S_4`, `A_5` and every
  group whose faithful representations all have dimension `>= 3`.

**Theorem 5.2 (mandatory base locus).** Assume 5.1. Let `sigma != tau` be
involutions with `P(V_{eps i}(sigma)) n P(V_{delta i}(tau)) != empty`. Then
**every point of that intersection lies in the indeterminacy locus of
`phi`.**

*Proof.* Two routes, both short. (i) `phi` restricted to `P(V_{eps i}(sigma))`
has image an irreducible RCC subvariety of `Y^sigma` (equivariance), hence by
(a) a point, hence is the constant `y(sigma,eps)` wherever defined; likewise
for `tau`. If `x` in the intersection were a point of definition, then
`y(sigma,eps) = phi(x) = y(tau,delta)`, contradicting 5.1. (ii) If `x` is not
in `Ind(phi)`, no centre of an equivariant resolution meets a neighbourhood of
`x`, so both carriers are the strict transforms there and still meet; adjacent
contracted strata have equal images; same contradiction. `QED`

Theorem 5.2 is an all-degree, search-free necessary condition of a kind the
single-carrier theorem cannot produce: it pins the base locus of *every*
equivariant rational map, dominant or not.

## 6. Why the Problem-F engine does not transplant: no scalar birth

Problem F's all-degree path obstruction
(`F-dp2-psl27/certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md`) runs on the
**scalar-birth lemma** (`FIX_T_gate.md` Lemma T2.1): at the quadruple point
`q = P(E_+(z))` the differential of `z` is the scalar `-1`, so the whole
exceptional curve `A_q` is pointwise `z`-fixed and links the incident
strata. The following says that mechanism is structurally absent on spin
sources.

**Theorem 6.1 (no scalar points on a spin source).** Let `sigma` be
spin-obstructed and `x = [L]` a point of `P(V)^sigma` with `L <= V_{eps i}`.
Then

    T_x P(V) = Hom(L, V/L),

and `sigma` acts on it with eigenvalue `+1` on `V_{eps i}/L` (dimension
`dim V_{eps i} - 1`) and `-1` on `V_{-eps i}` (dimension `dim V_{-eps i}`).
Hence `sigma` acts by a scalar on `T_x` **iff** `dim V_{eps i} = 1`. If
`sigma` is swap-realised, `dim V_{+i} = dim V_{-i} = (dim V)/2`, so a scalar
point exists only for `dim V = 2`. In particular for `dim V >= 4` **no point
of `P(V)^sigma` is a scalar point of `sigma`**, and no blowup at a point of
`P(V)^sigma` produces a pointwise `sigma`-fixed exceptional divisor.

By contrast, for a **linear** source `V = V_+ (+) V_-` with `dim V_+ = 1`,
the point `P(V_+)` *is* a scalar point of `sigma` — this is exactly Problem
F's `q`. So the availability of the scalar-birth linking is precisely the
linear/spin divide.

## 7. The chain system, and the boxed missing lemma

**Definition 7.1 (incidence graph).** `Gamma(V)`: vertices the
`2 x #{involutions}` strata `P(V_{eps i}(sigma))`; an edge whenever two
strata meet. By 3.2(3) the edges and the intersection dimensions are read
off the character table.

**Theorem 7.2 (the chain contradiction, conditional).** Assume (a), (b') and
suppose the following holds for at least one edge of `Gamma(V)` joining
strata of **distinct** involutions:

> **LINKING LEMMA (boxed).** In every `G`-equivariant resolution
> `X -> P(V)` of `phi`, the carriers `Ftilde(sigma,eps)` and
> `Ftilde(tau,delta)` of Theorem 4.1 are joined by a connected chain of
> irreducible RCC subvarieties of `X`, each pointwise fixed by some
> involution of `G`, consecutive members meeting.

Then there is **no** `G`-equivariant rational map `P(V) --> Y` at all.

*Proof.* Each chain member is contracted by 4.1's going-down argument;
adjacent members meet, so their images agree; hence
`y(sigma,eps) = y(tau,delta)`, contradicting Theorem 5.1. `QED`

**Theorem 7.3 (first-order separation — the Linking Lemma is FALSE at
first order for multiplicity-free sources).** Let `x` be a point of
`P(V_{eps i}(sigma)) n P(V_{delta i}(tau))`, `K = <sigma,tau>`, and let
`lambda` be the spin linear character of `Ktilde` on `L`. Then `T_x` is an
*honest* `K`-representation (`z` acts trivially on `Hom(L,V/L)`), with

    <chi_{T_x}, 1_K>  =  <chi_V|_{Ktilde}, lambda> - 1
                      =  dim( V_{eps i}(sigma) n V_{delta i}(tau) ) - 1.

Consequently, if the intersection multiplicity is 1 (the strata meet in a
single reduced point), then `T_x^K = 0`, so

    T_x^{sigma,+1} n T_x^{tau,+1} = 0,

and the traces `P(T_x^{sigma,+1})`, `P(T_x^{tau,+1})` of the two strict
transforms on the exceptional divisor of the blowup at `x` are **disjoint**:
one blowup separates the two carriers.

*Proof.* `T_x = lambda^{-1} (x) (V/L)|_{Ktilde}`; `z` acts by `-1` on
`lambda` and on `V`, so trivially on `T_x`, and
`chi_{T_x}(k) = lambda(ktilde)^{-1} chi_V(ktilde) - 1`. Averaging over `K`
gives the displayed formula. The joint `(+1,+1)`-eigenspace of `sigma, tau`
is the trivial-character isotypic of `K = <sigma,tau>`. `QED`

**Theorem 7.4 (the multiplicity reduction — where the lemma should be
attacked).** For spin `V`, `W`, the map `P(V (+) W) --> P(V)`,
`[v : w] |-> [v]`, is equivariant and dominant. Hence a dominant equivariant
`P(V) --> Y` yields a dominant equivariant `P(V (+) W) --> Y` for every spin
`W`; killing the larger source kills the smaller. Consequently:

* Proving "no dominant map from `P(U)`" for one irreducible spin `U` is
  **not** the all-spin-sources statement; the quantifier "over all faithful
  spin sources" is discharged by killing `P(V_reg^{spin,(+)k})` uniformly in
  `k`, where `V_reg^{spin}` is the spin part of the regular representation of
  `Gtilde` (every faithful spin `V` embeds in a multiple of it).
* Conversely, one may **choose** to work at multiplicity `m >= 2`, and there
  Theorem 7.3's obstruction disappears: for `V = U^{(+)m}` the intersection
  dimension is `m`, so `<chi_{T_x},1_K> = m - 1 >= 1` and the two traces on
  the exceptional divisor **do** meet. The incidence loci become
  `P^{m-1}`'s rather than points.

Corollary 2.3 is multiplicity-free and therefore holds for every faithful
spin source at once; Theorems 4.1, 5.1, 5.2 are likewise multiplicity-free.
Only the local separation analysis of 7.3 is multiplicity-sensitive.

## 8. Summary of the engine

| step | input | output |
|---|---|---|
| 1 | character table of `Gtilde`, subgroup lattice of `G` | which involutions are spin-obstructed; `N_0(sigma)` and the swap |
| 2 | commutator pairing (Prop 2.2) | `P(V)^A` for abelian `A`; the `V_4`/`Q_8` verdict |
| 3 | Prop 3.2 | the full stratum/incidence/stabiliser network |
| 4 | `Y^sigma` has no rational curve | Thm 4.1: swapped pair of carriers |
| 5 | lattice or tangent criterion for (b') | Thm 5.1 rigidity, Thm 5.2 mandatory base locus |
| 6 | Thm 6.1, 7.3 | the two structural reasons the linear engine's chain does not transplant |
| 7 | **boxed Linking Lemma** | Thm 7.2: no equivariant map at all |

Steps 1-5 are unconditional and are what this packet delivers. Step 7 is the
gap, stated exactly, with 7.3 telling us where it fails at first order and
7.4 telling us where to attack it next.
