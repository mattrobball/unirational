<!-- RT_FOLIATION_20260811 -->

## 2026-08-11 The foliation forced by a landing tuple; interpolation closes the local-data lane

Packet: `goal_runs_20260811/RT_ACTUAL_LANDING/` (extended). Branch
`agent/rt-foliation-20260811`. Adjudication of external round 4, verdicts
`R24`-`R45` in `ADJUDICATION.md`. Problem E remains **OPEN**.

Four new documents (`INTERPOLATION_THEOREM.md`, `THEOREM_FORCED_FOLIATION.md`,
`DEFECT_IDENTITY.md`, `FOLIATION_REFORMULATION.md`), sections 3-5 added to
`BOXED_GLOBAL_COVARIANT.md`, and four new verifiers, all `RESULT: PASS`:
`forced_foliation_witness.m2`, `verify_forced_foliation.py`,
`verify_interpolation_scope.py`, `verify_covariant_dimensions.py`.

**The box's object is the headline object.** The equivalence chain "a
`G`-covariant landing tuple in some degree exists `<=>` a `G`-equivariant
dominant rational map `P(W) --> X` exists `<=>` `X_gen(K_proj)` is nonempty" is
already sealed here: `G_UNIVERSAL/ALL_DEGREE_THEOREM.md`
(`G2-FINITE-GENERATION-PASS`) plus `G3A_EXACT_ARITHMETIC_DOMINANCE`
(`G3-DOMINANCE-AUTOMATIC`), with `RESOLUTION.md`'s `ed_C(G) = 4 <=>` not
`G`-unirational. So proving "no single homogeneous `G`-covariant tuple" **is**
proving the headline, and gives `ed_C(PSL(2,11)) = 4`; it is not a reduction to
anything smaller. Audit flag kept: the dominance bridge's step 6 is
`ACCEPTED_INPUT` (`ed_C(G) >= 3`, Beauville), not a repo proof, and the earlier
`G_UNIVERSAL/DECISION.md` says the opposite about dominance and is superseded.

**Third lane bottoms out at the headline.** Equivariant interpolation: for a
*fixed* `G`-stable `Z`, Serre vanishing plus Reynolds make
`(Sym^d W^v (x) W)^G -> H^0(Z, (O(d)(x)W)|_Z)^G` surjective for `d >> 0`. Hence
no obstruction program built from fixed finite local, cluster, incidence or
attachment data can give all-degree nonexistence - which explains why the
decorated-cluster classification came out empty of constraint. The scope
boundary is supplied here, not by the source, and machine-checked exactly:
`d_0` depends on `Z` and is unbounded (`d_0 = m` for the order-`m` jet); data
that **grows with `d`** is not covered (order-`(d+1)` jets fail for every `d`,
deficiency `2,3,4,5,6,7,8`); only stabiliser-**compatible** data is interpolable
in any degree; and the theorem is blind to the nonlinear `F(T) = 0`. Joins the
F55 coefficient circuits (`F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE`) and the
CLEAN arithmetic sieve (`COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED`) as the
third lane whose residual is the headline itself.

**The forced foliation - the theorem for lane C5.** Every primitive landing
tuple of degree `d` forces a nonzero `G`-covariant `P_T` of degree exactly
`2d-4` with `adj(J_T) = P_T grad F(T)^t`, `J_T P_T = 0`, `div P_T = 0`, of which
all five landing coordinates are first integrals: a `G`-invariant
divergence-free rank-one algebraically integrable foliation on `P^4`. The lane
was already registered as `theory/CONSTRAINT_ADDITIONS_20260811.md` item **C5**
("the biggest genuinely new lane") from a different external audit the same day;
what is new is the explicit generator, its pinned degree, and its module. Two
steps the source compresses are supplied: the content/primitivity step (Gauss's
lemma against `gcd_j F_j(T) = 1`, which is where smoothness of `X` is consumed,
and which is *not* removable - an explicit rank-one polynomial matrix with
non-primitive `Q` and non-polynomial `P` is exhibited), and the identity
`adj(gJg^{-1}) = g adj(J) g^{-1}` behind the character bookkeeping. The
character is real: on a `mu_3`-covariant tuple landing on a semi-invariant conic
one gets `P(gx) = chi(g)^{-1} g P(x)` and **not** `P(gx) = g P(x)`; perfectness
of `G` is what kills it.

**An exact witness, and what it costs.** A smooth cubic threefold and an
explicit primitive dominant degree-7 tuple (Segre conic-bundle construction)
satisfy every identity symbolically over `Q`. Consequence, recorded as a
negative: **no contradiction is available from the forced structure alone** -
any exclusion must consume the equivariance, the specific `G`-module, or the
Klein `F`. Same shape as the round-3 refutation and the `O4` witness. The
witness also corrects the source: `P_T` need not be primitive (content of degree
`8` out of `10` here), so the covariant's degree is pinned but the *foliation*'s
is not.

**Two deflations.** The `ch_2` defect identity
`ch_2(C_T) = [Q_T]_2 - 10(d-1)H^2` replays exactly and constrains nothing - its
terms carry opposite signs, so there is no effectivity argument; recorded as the
negative exit `DEFECT-IDENTITY-IMPOSES-NO-EFFECTIVITY-CONSTRAINT`. And the
first-order tangent-extension gate `H + 3Phi(x,x,Q) = F R` of the retraction
branch is vacuous: the Klein Jacobian ring is an Artinian complete intersection
with Hilbert function `(1,5,10,10,5,1,0,...)`, socle degree `5` (verified twice,
and matching the sealed Griffiths-residue computation in
`HODGE_CENTER_NECESSITY.md`), so the gate is exactly one linear condition in
degree `5` and nothing above it; the vacuity survives passage to the equivariant
category by Reynolds; and with the sealed floor `d >= 24` there
(`DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`) it carries no information at
all. The branch's content is entirely the recorded `Delta = R^2 + 4S` nonsquare
residual, unchanged.

**New exact arithmetic.** Character computation of
`dim (Sym^k W^v)^G` and `dim (Sym^k W^v (x) W)^G` for `k <= 24`, reproduced by a
second independent implementation, plus a lemma that `div` is onto the
invariants (so the divergence-free dimension is `C(k) - I(k-1)` exactly). Two
consequences: `C(2) = C(3) = 0` and `C(1) = 1` (spanned by `x`, `F(x) != 0`), so
**every landing tuple has `d >= 4`** with no branch hypothesis; and the
divergence-free space is **one-dimensional** for `d = 4` and `d = 5`, then `4`
and `7`. The bottom of the foliation lane is a finite question about one named
vector field.

Exits added: `FINITE-EQUIVARIANT-JET-DATA-ASYMPTOTICALLY-INTERPOLABLE-PROVED`,
`FIXED-FINITE-LOCAL-DATA-NOT-AN-ALL-DEGREE-OBSTRUCTION-PROVED`,
`DECORATED-CLUSTER-OBSTRUCTION-PROGRAM-BOTTOMED-OUT`,
`GLOBAL-JACOBIAN-ADJUGATE-FACTORIZATION-PROVED`,
`FORCED-DIVERGENCE-FREE-COVARIANT-DEGREE-2D-MINUS-4-PROVED`,
`LANDING-COORDINATES-ARE-FIRST-INTEGRALS-PROVED`,
`FORCED-FOLIATION-WITNESS-EXACT`,
`FORCED-FOLIATION-CONDITIONS-CONSISTENT-NON-EQUIVARIANTLY`,
`GLOBAL-JACOBIAN-COMPLEX-DEFECT-IDENTITY-PROVED`,
`DEFECT-IDENTITY-IMPOSES-NO-EFFECTIVITY-CONSTRAINT`,
`JACOBIAN-SOCLE-DEGREE-FIVE-EXACT`,
`FIRST-ORDER-TANGENT-EXTENSION-GATE-VACUOUS-ABOVE-DEGREE-FIVE-PROVED`,
`COVARIANT-AND-DIVERGENCE-FREE-DIMENSIONS-EXACT`,
`LANDING-DEGREE-AT-LEAST-FOUR-PROVED`, `BOXED-OBJECT-IS-THE-HEADLINE-OBJECT`,
`RT-OBSTRUCTION-LADDER-CLOSED`, `FOLIATION-CLASSIFICATION-TARGET-REGISTERED`.
Unchanged: `GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED`,
`G3D-UNDECIDED`, `DELTA1-KLEIN-RETRACTION-BRANCH-OPEN`,
`PROBLEM-E-HEADLINE-OPEN`.

The lane's live content is now two boxed alternatives and nothing else:
complete the direct arithmetic on `V(Phi)` (`G3D-UNDECIDED`), or classify the
`G`-invariant divergence-free foliations and exclude a Klein-cubic
first-integral field.
