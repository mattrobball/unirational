<!-- RT_TANGENCY_20260811 -->

## 2026-08-11 The source-tangency identity, and the first exclusion it powers: `d' = 2, 3` are impossible

Packet: `goal_runs_20260811/RT_ACTUAL_LANDING/` (extended). Branch
`agent/rt-tangency-20260811`. Adjudication of external round 5, verdicts
`R5-1`-`R5-21` in `ADJUDICATION.md`. Problem E remains **OPEN**.

Five new documents (`THEOREM_SOURCE_TANGENCY.md`, `EXCLUSION_DPRIME_2_3.md`,
`BASE_GRADIENT_PACKAGE.md`, `D35_BRANCH_TABLE.md`,
`DEFECT_SMITH_CLASSIFICATION.md`), sections 5-7 added to
`FOLIATION_REFORMULATION.md` and section 6 to `BOXED_GLOBAL_COVARIANT.md`, and
three new verifiers, all `RESULT: PASS`: `verify_source_tangency.py` (192
checks), `verify_d35_dimensions.py` (112 checks), `verify_source_tangency.m2`.

**The identity, proved.** Define `Delta_T = grad F(x)^t P_T(x)`, an invariant of
degree `2d-2` built from the forced foliation's generator. The source asserts
`Delta_T|_X = c H^2 j_phi` - the common divisor `H` of the restricted tuple
appears **squared**, and `j_phi` is the ramification determinant of the
primitive restricted selfmap - and justifies it with one phrase. The proof
supplied here has three steps: a pointwise linear-algebra lemma
(`det(A|_{N^perp -> Q^perp}) = (det S/det R) N^t adj(A) w`), which against the
Gelfand-Leray residue form `dF ^ eta = Omega` upgrades to **`Delta_T` is
literally the Jacobian of the restricted cone map**, `Delta_T|_X = Jac(T|_cone)`
with no constant; and then an exact scaling lemma
`Jac(h beta) = ((k+a)/a) h^w Jac(beta)`, proved by pulling back `eta` along
`(z,lambda) -> lambda z` and contracting with the Euler field.

Two sharpenings fall out. The constant is **exactly `d/d'`**, not an
unspecified nonzero scalar, and it is where characteristic zero enters. The
exponent is the **residue weight `w = n - e`**, not universally `2`: it is `2`
here because `K_X = O_X(-2)` for a cubic threefold in `P^4`. Exact instances
with `w = 1` and `w = 3` are exhibited in which the exponent is `1` and `3`, and
the verifier checks that both neighbouring exponents and five alternative
constants **fail**.

**The hypothesis the source omits.** All of this needs the restricted selfmap to
be dominant; if it is not, both sides vanish and the content is that `X` is an
invariant Darboux hypersurface of the kernel foliation. The repository proves
dominance in `goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/THEOREM.md`
(Theorem 1.1, via `X^G` empty and `ed_C(G) >= 3`) - but the 2026-08-10 RT
packets restate it as an unproved "inherited hypothesis, not proved here"
without linking back. The citation is restored; nothing downstream changes.

**Sealed: `d' = 2` and `d' = 3` are impossible, in every ambient degree.** `d'`
is the coordinate degree of the primitive restricted selfmap. Its ramification
section is a nonzero invariant in `H^0(X,O_X(2d'-2))^G`, and that space is `0`
at `d' = 2, 3` - the same invariant-dimension computation the sealed sieve runs
at `k`, run instead at `2d'-2`. So the common-factor cells `k = d-2` and
`k = d-3` die in **every** degree. It is sharp: `d' in {2,3}` are the only
values this argument kills, because `(C[x]/F)^G` is a domain with a nonzero
element in every degree `>= 5`. Note the argument does **not** use the tangency
identity - that identity is what interprets the exclusion inside the ambient
package. Two guards recorded: `d'` is not the topological degree `delta`, so the
sealed sieve's `delta = 3` survivor cell (`k = 0`, `d' = d`, every `d >= 31`)
**survives untouched**; and the exclusion inherits the `ed_C(G) >= 3` accepted
input, as the whole dominance chain does.

**A trap, exposed by the exact witness.** On the packet's genuine degree-7
cubic-threefold witness, `Delta_T = 1008 x_0^2 x_1^2 x_2 x_4 (x_1x_3^2 -
x_0x_4^2)(x_0x_1^2+x_0x_3^2+4x_1x_3x_4)` - visibly containing `x_0^2 x_1^2` -
and yet the restricted map is **primitive**: `H = 1`, `k = 0`, `d' = 7`. Square
factors of `Delta_T` are not evidence of a common factor; they can be doubled
ramification. The identity may not be read backwards.

**The `d = 35` table, exact.** `dim H^0(X,O_X(68))^G = 254`; the `k = 5..9` row
is `160, 145, 131, 117, 105`; `k = 32, 33` are excluded; `k = 34` is the
retraction, where the identity becomes the sharp normal form
`Delta_T|_X = 35 H^2` with no free ramification factor. The source's two tables
(42) and (43) are **one** table, since `68-2k = 2d'-2`. Two cells are
**one-dimensional and immediately actionable**: `k = 31` (`d' = 4`, `j_phi`
spans `H^0(X,O_X(6))^G`, and the candidate `B` lives in a **two**-dimensional
covariant space) and `k = 30` (`d' = 5`, `j_phi` spans `H^0(X,O_X(8))^G`, and
`B` lives in a **one**-dimensional space). Each is one named section against one
named covariant, not a search. Flagged as the concrete next computation; not
done here.

**Everything numerical recomputed, by a second method.**
`verify_d35_dimensions.py` uses exact integer / `Z[(1+sqrt(-11))/2]` linear
recurrences from the class characteristic polynomials - a different route from
the packet's `Q(zeta_330)` computation - and re-derives the `2A/3A/5A/6A`
eigenvalue multisets and the quadratic-residue symmetric functions rather than
assuming them. It reproduces the packet's `k <= 24` table and the sealed sieve's
`n <= 12` table, and confirms `254`, `19 266 655` (the forced singular-scheme
length at `m = 66`), `C(66) = 6992`, `I(65) = 1357`, `5635`, the `ch_1`
cancellation, the `-10(d-1)` codimension-two coefficient, hence the `340`
threshold at `d = 35`, and that `2` is inert in `Q(sqrt(-11))`.

**Also ported.** The socle sandwich `I_T^6 in I_Q in I_T^2` with
`sqrt(I_Q) = sqrt(I_T)`; `I_4(J_T) = I_P I_Q`; `rank J_T <= 2` at base points
(with the no-plane-in-a-smooth-cubic-threefold step proved from scratch, not
cited); the Klein-Nambu wedge identities with signs checked; `a_T = gcd(P_T)` is
a `G`-invariant of degree `0` or `>= 5` every irreducible factor of which is a
Darboux hypersurface; the codimension-one Smith-form classification, which
explains *why* the divisorial defects cancel before `ch_2`; and the foliation
quotient with **postcomposition invariance** - postcomposing by a dominant
`G`-selfmap of `X` leaves the saturated foliation unchanged, so classifying
saturated foliations quotients the semigroup that caveat **C12** warns about.
(Rescaling `T -> hT` is not postcomposition and genuinely does change the
foliation; the two must not be conflated.)

**Deflations recorded.** The tangency invariant alone is empty: for every
`m >= 4` the map `P -> grad F . P mod F` from divergence-free `G`-covariants
onto `H^0(X,O_X(m+2))^G` is **surjective** (Jacobian-ideal saturation plus the
radial correction), so `Delta` detached from `T` obstructs nothing, and
`dim ker(div)^G = 5635` at `d = 35`. The codimension-two balance is
definition-dependent: the coefficient `-10(d-1)` is exact, the term the source
calls `[Q_T]_2` is never defined. And `4 | delta` for even CLEAN `delta` is
honestly a **positive** pointer, not a constraint - a genus-zero `delta = 3`
survivor would give a rational generic fibre and a stable birational
factorization of `P^4` over `X`, and `delta = 3` is exactly the surviving cell.

**Net.** Two cells die in every ambient degree, two one-dimensional cells at
`d = 35` become testable, one load-bearing identity is proved and sharpened, one
lost citation is restored, and the geometric alternative to the arithmetic route
is now stateable as a single coupled package (54) on a single object. No branch
closes. `PROBLEM-E-HEADLINE-OPEN`.

Exits added by this round:

```text
PULLED-GRADIENT-BASE-RADICAL-IDENTITY-PROVED
JACOBIAN-MAXIMAL-MINOR-PRODUCT-PROVED
BASE-POINT-JACOBIAN-RANK-AT-MOST-TWO-PROVED
KLEIN-NAMBU-WEDGE-IDENTITIES-PROVED
SATURATED-CRITICAL-DIVISOR-IS-A-DARBOUX-INVARIANT
SATURATED-FOLIATION-NEVER-NONSINGULAR-PROVED
SOURCE-TANGENCY-IS-THE-CONE-JACOBIAN-PROVED
SOURCE-TANGENCY-RAMIFICATION-FACTORIZATION-PROVED
TANGENCY-EXPONENT-IS-CODIMENSION-WEIGHT-NOT-TWO
SOURCE-TANGENCY-WITNESS-EXACT
RESTRICTED-COORDINATE-DEGREE-TWO-AND-THREE-EXCLUDED-ALL-DEGREES
NONIDENTITY-RESTRICTED-COORDINATE-DEGREE-AT-LEAST-FOUR
COMMON-FACTOR-CELLS-K-EQUALS-D-MINUS-2-AND-D-MINUS-3-EXCLUDED
D35-BRANCH-TABLE-EXACT
D35-COMMON-FACTOR-CELLS-K32-AND-K33-EXCLUDED
D35-ONE-DIMENSIONAL-RAMIFICATION-CELLS-IDENTIFIED
CODIMENSION-ONE-SMITH-DEFECT-CLASSIFICATION-PROVED
DIVISORIAL-DEFECT-LENGTHS-CANCEL-PROVED
CODIMENSION-TWO-BALANCE-COEFFICIENT-EXACT
TANGENCY-SURJECTIVITY-KILLS-THE-ISOLATED-DELTA-LANE
SATURATED-FOLIATION-INVARIANT-UNDER-POSTCOMPOSITION-PROVED
FOLIATION-QUOTIENT-CLASSIFICATION-REGISTERED
GENERIC-FIBRE-INDEX-DIVIDES-DELTA-PROVED
CLEAN-EVEN-DELTA-IS-DIVISIBLE-BY-FOUR-PROVED
```
