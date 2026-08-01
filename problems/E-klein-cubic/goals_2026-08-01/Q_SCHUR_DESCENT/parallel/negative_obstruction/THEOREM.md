# Exhaustive boundary for a valuation obstruction on the Schur twist

## 1. Field discipline

The object in Goal Q is defined over

\[
K_{\rm Schur}=\mathbf C(\mathbf P(V_6))^G,
\qquad \operatorname{trdeg}_{\mathbf C}K_{\rm Schur}=5,
\]

whereas the installed Goal-V divisors `f5=0` and `f6=0` live over

\[
K_{\rm proj}=\mathbf C(\mathbf P(W))^G,
\qquad \operatorname{trdeg}_{\mathbf C}K_{\rm proj}=4.
\]

They are two versal generic-torsor presentations, but they are not silently
identified here.  In particular, a residue calculation at `f5` or `f6` is
not a calculation at a named valuation of `K_Schur` without an explicit
field/place bridge.  The group-theoretic inertia theorem of Goal V is
universal for twists and therefore *does* apply to the Schur torsor.

## 2. The local theorem

Let

\[
E=\mathbf C(\mathbf P(V_6)),\qquad K=E^G=K_{\rm Schur},
\qquad G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

and let `v` be a Krull valuation of `K` trivial on `C`.  Choose a
prolongation to `E`, and write `D` and `I` for its decomposition and inertia
groups.  Let `K_v^h` be the henselization and `k(v)` the residue field.

### Theorem

The genuine Schur twist has a point over `K_v^h` in each of the following
cases:

1. `I` is nontrivial;
2. `trdeg_C k(v) <= 1`;
3. `D` is a proper subgroup other than either maximal `A5` embedding class or
   a maximal `11:5`.

Consequently, if

\[
X_{\rm Schur}(K_v^h)=\varnothing,
\]

then all of the following are necessary:

```text
I = 1;
trdeg_C k(v) >= 2;
D is G, A5_class_1, A5_class_2, or 11:5;
rational_rank(v) <= 3.
```

In particular every valuation of rational rank at least four is locally
soluble.

### Proof

If `I != 1`, Goal V's exact 660-element centralizer census puts `D` inside a
centralizer preserving either a point or a contained projective line on the
split Klein cubic.  Twisting that stable point or line gives a point over the
henselian field.  This argument is independent of which versal source
produced the torsor.

Suppose `I=1`.  The torsor extends etale over the henselian valuation ring,
and twisting the constant smooth cubic gives a smooth proper model.  Proper
reduction and smooth Hensel lifting give the exact equivalence

```text
X_Schur(K_v^h) is nonempty
    iff the residue D-twist of the Klein cubic has a k(v)-point.       (1)
```

Every residue twist in (1) is a smooth Fano threefold: geometrically it is
the Klein cubic and its anticanonical bundle is `O(2)`.  In characteristic
zero a smooth Fano variety is rationally connected.  If
`trdeg_C k(v) <= 1`, descend the finite torsor and cubic to a finitely
generated subfield `k0` of `k(v)`.  One may choose `k0=C` or the function
field of a complex curve.  In the latter case Graber--Harris--Starr gives a
`k0`-point on the rationally connected cubic; in the former case the field
is algebraically closed.  Base change gives a `k(v)`-point, and (1) gives a
henselian point.  The primary source is Graber--Harris--Starr, *Families of
rationally connected varieties*, <https://arxiv.org/abs/math/0109220>.

For a proper `D`, the complete current subgroup audit proves every `D`-action
positive except the two nonconjugate maximal `A5` actions and maximal
`11:5`.  Hence every twist for every other proper `D` has a point, which
again feeds (1).  This uses the current theorem boundary in Cheltsov,
Tschinkel, and Zhang, *Equivariant unirationality of Fano threefolds*,
<https://math.nyu.edu/~tschinke/papers/yuri/25bguni/bguni.pdf>, together with
the exact subgroup enumeration in the Goal-H packet.

Finally Abhyankar's inequality for the five-dimensional finitely generated
field `K/C` is

\[
\operatorname{rr}(v)+\operatorname{trdeg}_{\mathbf C}k(v)\le5.
\]

A surviving nonpoint has residue transcendence degree at least two, so its
rational rank is at most three.  This proves the theorem.

### Companion consequence for Goal V

For the different field `K_proj`, the same proof uses transcendence degree
four and narrows a local nonpoint to rational rank at most two.  This is
consistent with the still-open rank-one divisors `f5=0` and `f6=0`; it does
not decide their residue cubics.

## 3. Why the standard global packages cannot fill the gap

The Schur twist has effective zero-cycles of degrees `3` and `55`.  Let `M`
be an abelian field-valued obstruction theory with restriction and
corestriction, satisfying

\[
\operatorname{cor}_{L/K}\operatorname{res}_{L/K}=[L:K]
\]

and the usual property that a class killed by passage to the variety is
killed after restriction to every closed-point field.  Such a class is
killed by both `3` and `55`, hence is zero because

\[
55-18\cdot3=1.
\]

This covers the base-kernel mechanism for ordinary and higher Amitsur
classes and Rost-cycle-module-style additive obstructions.  It deliberately
does not claim to cover nonlinear or nonabelian invariants.  In this example
the geometric Picard group is `Z[H]`, `H` descends honestly,
`Pic^0=Alb=0`, and the audited relative Brauer and higher Amitsur groups are
already zero.

There is also a direct no-go theorem for the semiabelian-torsor suggestion in
Goal Q.  Let `P/K` be a torsor under a commutative algebraic group `A/K`
(in particular, under a semiabelian variety), and suppose there is a
`K`-morphism

\[
X_{\rm Schur}\longrightarrow P.
\]

Every closed point of `X_Schur` gives a point of `P` over its residue field.
Thus the class `[P] in H^1(K,A)` restricts to zero over the degree-3 and
degree-55 point fields.  Restriction--corestriction makes both `3[P]` and
`55[P]` zero, and the displayed Bezout identity gives `[P]=0`.  Therefore
`P(K)` is nonempty.  No nontrivial commutative or semiabelian torsor receiving
the full twist can obstruct its rational points.  A surviving torsor-style
obstruction must fail one of these hypotheses--for example, it must be
genuinely noncommutative or must not be a functorial recipient of every point
of the full twist.

Thus a surviving residue nonpoint would itself have index one and trivial
relative Brauer group.  Repeating an index, Brauer, or additive
restriction--corestriction calculation cannot decide it.

## 4. Cross-packet implication audit

| Packet | Exact installed output | Why it does not combine into pointlessness |
|---|---|---|
| V | ramified and low-residue valuations are soluble; unramified reduction is exact | the full residue twist at a surviving site is still undecided |
| M | one exact cubic-surface Mori fibration and a degree-55 multisection | a section implies a point, but a point on `X` need not sweep out a section; no converse exists |
| D | standard degree/motive data are reproducible in source blowup closure | the invariant classes overlap rather than separate source and target |
| J | fixed-centre Albanese/Prym/Hodge data are stabilizable on source towers | the proposed invariant is explicitly too weak without landing/base-ideal constraints |
| F | the auxiliary fixed-frame conic/plane-cubic criterion is exactly empty over `K_proj` | no bridge identifies that auxiliary pointlessness with pointlessness of the genuine Schur twist |
| H | all proper subgroup twists except two `A5` classes and `11:5` are positive | it narrows `D`; it supplies no pointless remaining subgroup twist |

There is no valid syllogism in which the route-scoped `SEAL.json` files turn
these nonterminal implications into a negative headline.  A seal certifies
the packet's stated scope, not the missing converse.

## 5. Exact negative-obstruction interface

A valuation certificate capable of closing Goal Q negatively must now
contain all of the following:

1. an exact valuation of `K_Schur` (or an explicitly proved versal-field
   bridge from another generic field);
2. a prolongation to the Schur splitting field with `I=1` and
   `D` in the four surviving classes;
3. residue transcendence degree at least two and rational rank at most three;
4. the full five-coordinate smooth residue cubic, not an `xCD`, Pfaffian, or
   fixed-plane section;
5. a proof that this residue cubic has no rational point despite its
   degree-3 and degree-55 cycles and trivial relative Brauer group;
6. the proper-smooth reduction bridge (1), proving the henselian nonpoint;
7. the injection of a global point into that henselian point set.

Items 1--4 and 6--7 are now a precise interface.  Item 5 is not present in
the repository and is essentially the surviving index-one point problem in
lower transcendence degree.  Until it is supplied, the exact verdict is
nonterminal.
