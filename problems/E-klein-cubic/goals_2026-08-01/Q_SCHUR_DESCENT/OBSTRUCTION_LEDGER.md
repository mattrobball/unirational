# Picard, Albanese, Brauer, and point-obstruction ledger

Let `X_T/K` be the genuine generic Schur twist from
`ZERO_CYCLE_LEDGER.md`.

## 1. Picard and Albanese

Over an algebraic closure, Lefschetz gives

\[
\operatorname{Pic}(X_{\bar K})=\mathbf Z[H],
\qquad \operatorname{Pic}^0(X_{\bar K})=0,
\]

where `H=O_X(1)`.  The Klein action comes from an honest linear action on
the ambient five-space, so `H` descends to `K` and is honestly linearized.
Consequently

\[
\operatorname{Pic}(X_T)=\mathbf Z[H].
\]

Every component `Pic^n` has the `K`-point `O(n)`.  There is therefore no
nontrivial Picard torsor available from this rank-one Picard scheme.

Also `H^1(X_bar,O)=0`, so the Albanese variety and the usual Albanese torsor
are trivial:

\[
\operatorname{Alb}(X_T)=0.
\]

## 2. Elementary and universal-torsor obstructions

The index-one zero-cycle already annihilates the elementary obstruction.
Independently, the honestly descended generator `H` makes the equivariant
universal-torsor obstruction used in the repository equal to zero.  This
remains true after restriction to every subgroup.

This vanishing is necessary information only.  It supplies no point.

## 3. Brauer and higher Amitsur groups

For every twist in this family, the audited Hochschild--Serre calculation
gives

\[
\operatorname{Br}(X_T)=\operatorname{Br}(K).
\]

Thus the relative Brauer group is zero.  The honest hyperplane linearization
also forces the ordinary and all currently named higher Amitsur groups to
vanish, including after subgroup restriction.

The restriction--corestriction argument visible from degrees 3 and 55 kills
any abelian functorial point obstruction satisfying the usual transfer law:
it is killed by both 3 and 55 and hence by 1.  This statement does not cover
an arbitrary nonlinear or nonabelian invariant.

More precisely, if `P/K` is a torsor under any commutative algebraic group
and there is a `K`-morphism `X_T -> P`, the degree-3 and degree-55 closed
points make `3[P]=55[P]=0` in `H^1(K,A)`.  Since `55-18*3=1`, `[P]=0`.
Thus no nontrivial commutative or semiabelian torsor receiving the whole
threefold can be a point obstruction here.

## 4. Stable cohomology and the exact remaining scope

The audited stable cohomology with finite constant coefficients vanishes
above degree two; degree one vanishes because `G` is perfect, and the
unramified degree-two Bogomolov multiplier is zero for this finite simple
group.

This is not a theorem that every possible unramified invariant with every
nonconstant coefficient system vanishes.  A negative solution must introduce
such genuinely new information and prove both:

1. the class survives on the proper generic twist; and
2. every `K`-rational point would force it to vanish.

No such class is installed.

## 5. Why the known genus-one classes are insufficient

For each of the ten coordinate lines in the exact degree-eight Schur frame,
blowing up the irreducible degree-three base scheme gives a genus-one
fibration over `P2_K`.  Its smooth generic fibre has

\[
\operatorname{per}=\operatorname{ind}=3
\]

and no rational section.  These are ten nontrivial genus-one torsor classes
over the ten base function fields.  They do not obstruct a point on `X_T`
lying over a special base point, so they are not full-threefold point
obstructions.

## 6. Rejected negative shortcuts

- Index one is not a rational point.
- Vanishing Brauer/Amitsur classes do not imply a point.
- Birational superrigidity obstructs birational linearization, not a dominant
  higher-degree map from a representation.
- Failure of the ten coordinate fibrations is not exhaustive.
- A bounded covariant or point search is not a pointlessness proof.
- The nonzero Schur class occurring for the *different* generic projective
  Klein torsor is not the boundary of this Schur-source torsor; the latter is
  zero.

Therefore the standard obstruction side of Q3 is exhausted only at the
named-package level, not at the level required for the negative headline.

## 7. Exact valuation frontier

Let `E=C(P(V6))`, `K=E^G`, and let `v` be a valuation of `K` trivial on `C`.
For a prolongation to `E`, write `D` and `I` for decomposition and inertia.
The independent audit in `parallel/negative_obstruction/` proves that a
henselian nonpoint can survive only if

```text
I = 1,
trdeg_C k(v) >= 2,
rational_rank(v) <= 3,
D in {PSL(2,11), A5_class_1, A5_class_2, 11:5}.
```

In particular, every valuation of rational rank at least four is locally
soluble.  The proof combines the universal inertia-centralizer theorem,
smooth henselian reduction, Graber--Harris--Starr in residue transcendence
degree at most one, the audited proper-subgroup boundary, and Abhyankar's
inequality in transcendence degree five.

No current theorem supplies a point on the surviving residue cubic over a
complex surface or threefold field: the standard rational-simple-connectedness
numerics (`9 <= 4`, or even `9 <= 5`) and the Tsen--Lang inequalities
(`5 > 9`, `5 > 27`) both fail.  Therefore the valuation theorem is an exact
obstruction interface, not an obstruction class or a negative headline.
