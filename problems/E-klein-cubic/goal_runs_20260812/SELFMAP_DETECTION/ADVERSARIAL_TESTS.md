# Adversarial tests

Every claim in this packet was attacked before it was written down. What follows
is the list of attacks, with the outcome of each. Tests that **changed** a claim
are marked ★.

---

## A1. Is the surjectivity theorem circular — does it secretly assume `Land != ∅`?

**Attack.** Theorem 3.3 concludes that `res : Land -> Self` is surjective. If
`Land = ∅` then `res` is the empty map and `Self != ∅` (it contains `id_X`), so
surjectivity would be false — does the theorem therefore prove `Land != ∅`?

**Outcome: no, and the statement is correctly guarded.** The hypothesis is
"*some* `A_0 in Land` has `phi_{A_0}` birational", which already asserts
`Land != ∅`. The theorem is an implication whose antecedent is exactly the thing
in question. This is not a defect; it is what makes Corollary 3.5 usable, because
the contrapositive of an implication with a nonempty-ness antecedent is an
emptiness conclusion.

## A2. Does the composition of Theorem 3.3 contradict the sealed retraction facts?

**Attack.** The sealed facts pin the retraction branch hard: `D_X != 0`,
`deg D_X = k_0 = d_0 - 1 >= 5`, `d_0 >= 24` (and `>= 35` from the ambient floor),
`delta = 1`, `u_phi = ±1`. If the composition `psi o A_0` produced a tuple
violating any of `k in {0} ∪ {5,...}`, `d = k + d'`, `d >= 35`,
`d' in {1} ∪ {6,...}`, one of the two sides would be wrong.

**Outcome: fully consistent.** `Psi(T_0)|_X = H_0^n Psi(x)|_X` gives
`(d,k,d') = (n d_0, n(d_0-1), n)` before ambient content removal. Every sealed
constraint holds for every `n` in the sealed surviving set, for every
`d_0 >= 35`. Checked arithmetically at `d_0 in {35,36,40}`, `n in {1,25,28}` in
block (J) of the verifier. Two sharper consequences fell out and are recorded as
(S1) (the tangency constant on the whole `Self`-orbit of a retraction is `d_0`,
independent of `psi`) and (S2) (the retraction branch imports the CLEAN/CARRIER
dichotomy for all of `Self`).

## A3. ★ Can the content `g` of the composite tuple be divisible by `F`?

**Attack.** Proposition 3.2 divides `Theta = Psi(T)` by `g = gcd(Theta_i)`. If
`F | g` the division would destroy the restriction: `T'|_X` would be computed
from a tuple that vanishes identically on `X`, and the identity
`res(psi o A) = psi o res(A)` would be meaningless.

**Outcome: excluded, and the exclusion needed a proof that the source does not
give.** `Theta|_X = Psi(T|_X) = Psi(HB) = H^n Psi(B)`, and `Psi(B)|_X` is the
primitive tuple of the dominant selfmap `psi o phi_T`, hence nonzero on `X`;
`H|_X != 0` by construction of `H`. So `Theta|_X != 0` and `F ∤ g`. This became
Proposition 3.2(iii). The repository's one-line proof of Theorem A ("removing a
common factor preserves the landing identity by cubic homogeneity") does not
address it.

## A4. Is the `k = 0` observation of the audit real, or an artefact?

**Attack.** The audit table records that no audited nonidentity self-map admits a
`k = 0` cell. Is that a genuine restriction-only consequence or a tautology?

**Outcome: genuine but weak.** `k = 0` forces `d = d'` and the sealed ambient
floor forces `d >= 35`, so a self-map of coordinate degree `n < 35` cannot be the
restriction of a landing tuple with empty divisorial base locus. Since
`RT-DX0-PROVED` says `D_X = 0 => CARRIER`, this says: if `phi_8` is a restriction
at all, its landing tuple has `D_X != 0` of degree `k >= 10`. That is a real
statement about the hypothetical tuple, and it excludes no self-map, which is
why the verdict stays RESTRICTION-COMPATIBLE.

## A5. Does the tangent-section count `N(m)` depend on an unverified surjectivity?

**Attack.** Formula (3.1) uses `FOLIATION_REFORMULATION.md` Proposition 5.1
(surjectivity of `V |-> grad F·V` onto `H^0(X,O_X(m+2))^G` for `m >= 4`). If
that proposition were wrong, `dim K_m` would be larger and `N(m)` could be
positive below `m = 8`, destroying the minimality claim.

**Outcome: the claim does not rest on it.** Blocks (C)–(E) compute
`dim K_m` **directly**, as the kernel of an explicit matrix, for every
`m <= 10`, without using Proposition 5.1 at all; the values agree with (3.1) at
both primes. So Proposition 5.1 is *confirmed* in this range rather than
assumed, and the minimality of `m = 8` stands on the direct computation.

## A6. Is `F_p` arithmetic legitimate for characteristic-zero conclusions?

**Attack.** Everything explicit is computed over `F_p`. Characteristic-zero
statements do not follow from mod-`p` statements in general.

**Outcome: legitimate in exactly the directions used, and the argument is
recorded here.**

1. *Dimensions.* The `iota`-condition matrix has entries in
   `Z[zeta_11][1/11]`. Rank can only **drop** under reduction, so
   `dim ker_p >= dim ker_0`. The computed `dim ker_p` equals the exact
   characteristic-zero Molien value `C(m)` (resp. `I(m)`), so
   `dim ker_p = dim ker_0` and `ker_p` is the reduction of `ker_0`. The same
   argument applies to `K_m` (whose characteristic-zero dimension is
   `Chat(m) - S(m+2)`, exact) and to `Z_m` (dimension `S(m-1)`, exact).
2. *Existence of a characteristic-zero `V_8`.* Because
   `dim (K_8/Z_8)_p = dim (K_8/Z_8)_0 = 1`, the reduction map
   `(K_8/Z_8)_0 -> (K_8/Z_8)_p` is an isomorphism, so the computed `V_8` is the
   reduction of a characteristic-zero `V_8`, up to scalar and up to `Z_8` — and
   modifying `V` by `Z_8` does not change `R(x,V)` modulo `F`
   (`R(x,aV+bx) = a^3 R(x,V)`), so it does not change any conclusion.
3. *Non-vanishing transfers upward.* Every explicit conclusion is of the form
   "some polynomial is nonzero": `R != 0`, `Q(x,V) != 0`, the restricted cone
   Jacobian `!= 0`, `gcd(Res_0, Res_1)` constant. A polynomial that is nonzero
   mod `p` is nonzero in characteristic zero. In particular a
   characteristic-zero common factor `H`, taken integral and primitive, would
   reduce to a nonzero common factor mod `p`; none exists mod `p`, so none
   exists.
4. *Bad primes avoided.* `p ≡ 1 (mod 11)` so `zeta_11 in F_p`; `p > 660` and
   `p ∤ 660`, so the averaging idempotent exists and `|G| = 660` is checked by
   enumeration at each prime. Two independent primes,
   `p = 1000033` and `p = 3000229`.

The one direction that would **not** transfer is "some polynomial is zero", and
no conclusion of this packet has that shape except the covariance identities,
which are re-verified by direct substitution at each prime and are in any case
consequences of the construction.

## A7. Can the plane-section certificate be fooled?

**Attack.** Theorem 4.1 concludes "no divisorial base locus" from one plane. Bad
cases: (i) the plane lies inside `X`; (ii) the plane is tangent or otherwise
special; (iii) the resultant degenerates.

**Outcome: none applies.**
(i) A smooth cubic threefold contains no 2-plane: a plane `P ⊂ X` would be a
divisor of degree `1`, contradicting `Cl(X) = Z·H_X` with `H_X^2` of degree `3`.
The verifier also checks that `F|_P` is a genuine cubic with a nonzero `w^3`
coefficient.
(ii) **No genericity is used.** The argument is "any nonzero divisor on `X` is a
surface in `P^4`, and any two surfaces in `P^4` meet"
(`2 + 2 >= 4`, projective dimension theorem). A special plane is still a plane.
(iii) The verifier asserts that `Res_w(F|_P, R_0|_P)` has the **full** expected
degree `3·25 = 75`, that the eliminated-variable leading coefficients are
nonzero constants (so no roots escape to `w = ∞`), and it separately checks the
line `v = 0` (so no root escapes to the point at infinity of the `(u:v)` line).

## A8. Does the outer-twisted equivariance convention change the count?

**Attack.** `D35_K30_K31_CELLS.md` §7 shows that the `d' = 4,5` exclusions had to
be re-run under the convention `T(rho(g)x) = rho'(g)T(x)`, where `rho'` is the
outer/Galois twist. Does the tangent-section count need the same treatment?

**Outcome: the question does not arise, for a structural reason.** A landing
tuple maps `P(W)` to `X ⊂ P(W)` and the source and target copies of `W` are a
priori independent, which is what makes the twisted convention meaningful there.
A tangent direction field is a section of `P(T_X) -> X`, and the `G`-linearization
of `T_X` is **induced** from the action on `X`, i.e. from the same copy of `W`,
via the Euler sequence `0 -> O -> O(1) ⊗ W -> T_{P^4} -> 0`. There is no free
target copy to twist. So the untwisted convention is the only one available and
§7 of that packet has no analogue here.

## A9. Is "RESTRICTION-COMPATIBLE" a real verdict or a vacuity?

**Attack.** Every audited self-map comes out compatible. Is the test capable of
returning the other answer?

**Outcome: the test has teeth, but the teeth are on a quantity we could not
compute.** Two of the sealed conditions can return EXCLUDED:
(a) `deg_coord in {2,3,4,5}` — excluded for *all* self-maps, so a self-map
landing there would contradict the sealed exclusions rather than fire the
detection corollary. This is the direction A10 tests;
(b) the CLEAN norm condition `delta = x^2+xy+3y^2`, which fails for
`delta in {2,6,7,8,10,...}` — this is a real discriminator, and it is not
reached because `delta` is not computed (blowup point B1). Recorded honestly
rather than dressed up.

## A10. ★ Would a computed coordinate degree in `{2,3,4,5}` have broken the sealed chain?

**Attack.** `D35_K30_K31_CELLS.md` Corollary 3.3 asserts that no `G`-equivariant
selfmap of `X` of primitive coordinate degree `4` or `5` exists, **dominant or
not**, and §8 does the same for `2,3`. The tangent-residual family is an
independent construction of `G`-equivariant selfmaps. If a member had coordinate
degree in `{2,3,4,5}` the sealed exclusions would be false.

**Outcome: no contradiction; the test passed and it was not a formality.** The
minimal section has `m = 8`, so the smallest tangent-residual coordinate degree
is `3·8+1 = 25` before base-locus removal, and the base locus is empty, so
`25` exactly. There is no room for the construction to land in `{2,3,4,5}`:
even a common factor of degree `20` or `21` is impossible, since the surviving
set forbids `d' in {2,3,4,5}` and the invariant-degree set forbids most
intermediate values — but the point is that the computation returned `25`
outright, with no common factor at all. The machinery also reproduces the sealed
`C(4) = 2`, `C(5) = 1`, `Chat(4) = Chat(5) = 1` used by that exclusion, and the
repository's boxed `D_5` is recovered as the generator of `Cov_5`.

## A11. Does `N(m) > 0` mean a *dominant nonidentity* self-map exists in degree `3m+1`?

**Attack.** The count `N(m)` counts sections, not self-maps. A section could give
`phi_V = id_X` (Corollary 2.3) or a non-dominant map.

**Outcome: the gap is real and is closed separately for `m = 8`.** Both
degeneracies are ruled out by explicit point certificates: `Q(q,V_8(q)) != 0`
(so `phi_8 != id_X`) and the restricted cone Jacobian is nonzero at `q` (so
`phi_8` is dominant). For `m = 9` only the coordinate degree is certified; the
audit does not claim `phi_9` is dominant or nonidentity.

## A12. ★ What exactly does Corollary 3.4 import?

**Attack.** `DEGREE_ONE_RETRACTION.md` §1 proves `deg phi = 1 => phi = id_X`
using "full-`G` birational superrigidity" — an accepted repository input, not a
theorem proved there. If the surjectivity theorem were stated only in the
"retraction" form, it would silently inherit that input.

**Outcome: the statement was split.** Theorem 3.3 is stated for `phi_{A_0}`
**birational**, and its proof uses no superrigidity. Corollary 3.4 is the
separate step that identifies "birational" with "retraction", and it is labelled
as carrying the accepted input. Correspondingly Corollary 3.5's unconditional
conclusion is `delta(phi_A) != 1` for every `A`, and only the reading "the
retraction branch is empty" consumes the accepted input. This split is the
change this test produced.

## A13. Is `res` even well defined?

**Attack.** `res(A) = A|_X` must land in `Self`, i.e. must be dominant.

**Outcome: sealed, but conditional.** `goal_runs_20260808/`
`FULL_G_RESTRICTION_DOMINANCE/THEOREM.md` Theorem 1.1 proves restricted
dominance, at the cost of the accepted input `ed_C(PSL_2(F_11)) >= 3` (Beauville
/ Duncan–Reichstein) — the same input the whole dominance chain carries, and the
citation audit in `THEOREM_SOURCE_TANGENCY.md` §5 confirms it applies under the
hypotheses in force. Recorded in the non-claims of
`THEOREM_DETECTION_PRINCIPLE.md`, together with the unconditional workaround
(replace `Self` by all equivariant selfmaps and `res` by a partial map).

## A14. Does postcomposition-invariance of the foliation prove too much?

**Attack.** If `Fol_{psi o A} = Fol_A`, and the leaf space and leaf fibration are
also unchanged, does the quotient `Self \ Land` retain enough to be a
classification target — or has everything collapsed?

**Outcome: it retains the foliation and the leaf geometry, and loses exactly the
finite map, the degrees and the tangency invariant.** Corollary 2.2 tabulates
both columns. In particular the classification target of
`FOLIATION_REFORMULATION.md` §6 survives the quotient, which is what that file
claims; and the `d`-indexed branch tables do **not** survive it, which is why
`CONSTRAINT_ADDITIONS_20260811.md` item C12 remains an obstruction in every
tuple-indexed lane. The one correction: the kernel identity holds **generically**
only, so it is an identity of saturated foliations, not of the maps
`O(5-2d) -> T_{P^4}`.

## A15. Could the `m = 8` section be an artefact of the chosen `F`?

**Attack.** The whole computation is in one model of the Klein cubic
(`F = x_0^2x_1 + ... + x_4^2x_0`, `sigma`, `tau = diag(z^{1,9,4,3,5})`, `iota`
from the Gauss sum). A different model could give a different answer.

**Outcome: the model is pinned to the sealed one.** The verifier checks
`|<sigma,tau,iota>| = 660` by enumeration, `F(gx) = F(x)` for all three
generators, the Gauss sum squares to `-11`, and — decisively — that the
repository's independently boxed `D_5` spans the computed `Cov_5`. Any model
error would show up as a wrong `dim Cov_m` against Molien, and none does for
`m <= 10`.

## A16. Is anything in the packet a headline claim in disguise?

**Attack.** Packets drift toward overclaiming.

**Outcome: no branch closes.** The strongest new statements are (i) a
conditional surjectivity theorem whose antecedent is the very branch it would
constrain, (ii) an exact coordinate degree, and (iii) a canonical explicit
witness for an existence theorem that was previously non-constructive. All three
are recorded as such. `Problem E headline: OPEN.`

---

# Adversarial tests for `PHI8_DEGREE.md` (2026-08-12)

## A17. ★★ Is the degeneracy locus really empty, as the expected dimension suggests?

**Attack.** `V_8` is a section of the rank-three bundle `T_X(7)` on a threefold,
so its zero locus has expected dimension zero and `int_X c_3(T_X(7)) = 1401`.
The first computation run said the locus was **empty** in all five charts, which
would have made the line congruence a morphism and given
`delta = 3(1+8+8^2+8^3) - 2 = 1753`.

**Outcome: the first computation was wrong, and the correct answer changes the
verdict.** The emptiness came from an msolve **input-format** defect, not from
geometry: msolve's parser does not understand parentheses, so systems emitted as
`(3)*x1^2*x2+(-8)` are silently mis-read and reported as having no solution. The
defect was caught by feeding msolve a system whose solution was known by
substitution — `{F, all ten 3x3 minors, x = y}` — and getting "no solution" for a
point that visibly satisfies every equation. With the systems re-emitted fully
expanded, the degeneracy locus is **one-dimensional**: a reduced curve of degree
`72`. And `1753 = 1^2 + 1·24 + 3·24^2` **is** a norm, so the format bug would
have produced a CLEAN-compatible verdict and buried the lever. Both the
regression test for the mis-parse and the fact that `1753` is a norm are now
assertions in `verify_phi8_degree.py`, blocks (C) and (E).

## A18. Are the `208` solutions genuine preimages, or artefacts of the `t`-parametrisation?

**Attack.** Route B solves `y ~ x + tV_8(x)`, not `y ~ R(x)`. A solution with
`x` in the base locus of `R` would be counted but would not be a preimage under
`phi_8`, which is defined by the degree-`25` tuple `R`.

**Outcome: excluded by construction, not by inspection.** The system carries
`z·Q(x,V_8(x)) = 1`. On `X`, `F(x+tV) = t^2(Q + tF(V))` because
`grad F . V_8 = 0 (mod F)`; so a solution with `t != 0` satisfies
`Q + tF(V) = 0`, and `Q != 0` forces `F(V) != 0`, `t = -Q/F(V)` and
`x + tV_8 ~ F(V_8)x - Q V_8 = R(x)`. Conversely `Q = 0` with `t != 0` forces
`F(V) = 0`, which is exactly `l_x ⊂ X`, i.e. `x in Bs(R)`. So the constraint
removes precisely the base locus, and every counted solution is a genuine
preimage under the degree-`25` tuple.

## A19. ★ Is the fiber count complete, or is the chart hiding solutions?

**Attack.** A count in one affine chart misses preimages on the hyperplane at
infinity, and would under-report `delta`.

**Outcome: the count is complete by construction.** Every fiber is solved in all
five **flag** charts `x_0=1`; `x_0=0,x_1=1`; `x_0=x_1=0,x_2=1`; ... , which
partition `P^4` exactly. Charts 1--4 come back empty in every run — `phi_8`,
`phi_9`, both routes, every target. Nothing is at infinity, and no point is
double counted.

## A20. Does the answer depend on the target, i.e. is `208` the *generic* count?

**Attack.** `#phi^{-1}(y) = delta` only for `y` outside a proper closed subset.
Three hand-picked small rational targets could all be special, and a special
fiber can only be *smaller*.

**Outcome: mitigated, not eliminated, and this is the packet's one caveat.** The
lower bound `delta >= 208` is unconditional (Stein factorization on the normal
`X`). The upper bound uses upper semicontinuity of the fiber length of the
proper map `Z' -> X` and needs the target off an at-most-two-dimensional bad
locus. Six independent targets — `y1, y2, y3` and three *random* points of
`X(F_p)` with `p ~ 10^6`, each lying on a fixed surface with probability
`~1/p` — all give exactly `208`, in two characteristics and by two routes. A
special target would ordinarily give a *different* (smaller) count, and none
does. The residual caveat is recorded in `PHI8_DEGREE.md` §8 rather than being
argued away.

## A21. Is the double point at `x = y` really multiplicity two, and not part of the excess?

**Attack.** Route A reports `210` against `209`. If the extra length sat on the
degeneracy curve rather than at `x = y`, then `delta` would be `209`, not `208`
— and `209 = 11·19` is also a non-norm, but a *different* number.

**Outcome: it is at `x = y`, twice over.** Structurally, Lemma 3.1: `ds_y` has
rank `2` because `V_8(y)` lies in the affine tangent space (tangency) and is not
proportional to `y`; both inputs are checked at every target. Computationally,
adding the constraint `x != y` returns `208` points with minimal polynomial of
degree `208` — all simple — at three targets; and the excess curve was already
inverted away before either count. The two agree.

## A22. Could the boxed rational `V_8` be a tangent field but not *the* equivariant one?

**Attack.** Rational reconstruction from `F_p` data proves nothing over `Q` by
itself, and the space of degree-`8` tangent fields that are *not* equivariant is
large. A non-equivariant `V` would give a self-map, just not `phi_8`.

**Outcome: identified, with a characteristic-zero certificate.**
`sigma`-covariance is built into the storage (component `i` is the shift of
component `0`) and `tau`-weight covariance is an exact rational check.
`iota`-covariance is an identity in `Z[zeta_11]` whose coefficients are bounded
in every archimedean absolute value by an explicit integer `H` (the entries of
`iota` have modulus `2 sqrt(11)/11 < 61/100`, and coefficients are bounded by
the sup-norm on the unit polydisc); it is verified at eleven primes above
`10^18` whose product exceeds `H^10`, so any coefficient divisible by all eleven
degree-one primes is zero. Independently, the boxed tuple is checked to reduce
into `Cov_m` and *not* into `Z_m` at the sealed prime, so it spans `K_m/Z_m`,
which by `SELFMAP_AUDIT.md` Theorem 3.1 (`N(8) = 1`) is one-dimensional.

## A23. Does `delta(phi_8) = 208` contradict any sealed constraint?

**Attack.** The sealed excess identity `delta = d'^3 - d' zeta - a` with
`zeta = z/3 >= 1`, `a >= 0`, `zeta <= d'^2` and the interval
`1 <= delta <= d'^3 - d'` must accommodate `208` at `d' = 25`.

**Outcome: consistent, and the identity is too loose to have predicted it.**
`25 zeta + a = 15417` has integer solutions for every `zeta` in `[1, 616]`, and
`3 <= 208 <= 15600`. `COMBINED_DEGREE_SIEVE` Corollary 3.5 says explicitly that
the identity "contributes an interval and nothing else"; the computation is what
pins the value. Also `delta != 1, 2`, as every `G`-selfmap must satisfy, and
`delta(phi_8) != delta(phi_9)`, so the two canonical maps are genuinely
different.

## A24. Is `RETRACTION-BRANCH-CARRIER-ONLY` a headline claim in disguise?

**Attack.** "The retraction branch is now a pure CARRIER question" sounds like a
branch closure.

**Outcome: it is not, and the packet says so in three places.** The statement is
an implication whose antecedent is the retraction branch being nonempty; it
converts one open question into another, strictly smaller one. Nothing is
excluded: `CARRIER-EXCLUSION-NOT-ACHIEVED` is an exit of the packet, the genus
and CM data of the candidate support curve are **not** computed, and the sealed
`j = 8192/11` non-CM data the work order points at belongs to the `V14` fixed
network, not to `Bs(J_{phi_8})`, so it is not used. `Problem E headline: OPEN.`

---

# Round 3 — `PHI8_CARRIER.md` (2026-08-12)

Verified by `verify_phi8_carrier.py`.

## A25. Is the restricted dichotomy really applicable to `phi_8` without the retraction hypothesis?

**Attack.** `THEOREM_RESTRICTED_DICHOTOMY.md` §1 says "the dominant
`G`-equivariant selfmap obtained by **restricting** a hypothetical ambient
landing map". Applying Theorem 3.1 to `phi_8` unconditionally is exactly the
kind of hypothesis-dropping a review should catch. If the clause is live,
`PHI8_CARRIER.md` Theorem 2.1 is void and this packet has no content.

**Outcome: the clause is inert; the theorem is unconditional.** The proof of
Theorem 3.1 is read step by step in `PHI8_CARRIER.md` §2 and its five inputs
are tabulated: `phi` dominant `G`-equivariant; `Gamma` normal with `pi` proper
birational and `X` smooth; `q` generically finite of degree `delta`; `V`
`G`-irreducible over `Q`; `End_{G-HS}(V_Z) = O_K` with `h(K) = 1` and the graph
correspondence integral. No step consumes an ambient tuple `T`, an ambient
degree `d`, a common factor `H`, or `F(T) = 0`. The word "restricted" in
"primitive **restricted** base ideal" names the object — an ideal on `X` rather
than on `P^4` — not the provenance of `phi`. Each input is discharged for
`phi_8` from a sealed statement (dominance: `SELFMAP_AUDIT.md` Theorem 4.3;
`G`-equivariance: `FULL_G_SELFMAP_CLASSIFICATION/THEOREM.md` §1 via
`SOURCES.md` A15; `delta = 208`: `PHI8_DEGREE.md` Theorem 4.1; the rest are
independent of `phi`). This is an **adjudication of the sealed text**, and it is
the load-bearing step of the packet.

## A26. Does Theorem 2.1 contradict `PHI8_DEGREE.md` Corollary 6.2 or any sealed retraction fact?

**Attack.** Corollary 6.2 says "retraction nonempty `=>` `r_{phi_8} != 0`".
Theorem 2.1 says `r_{phi_8} != 0` outright. If the two are inconsistent, one is
wrong.

**Outcome: no contradiction; Corollary 6.2 is true and vacuous.** An
implication with a true consequent is true. Nothing in `PHI8_DEGREE.md` is
retracted; what is retracted is the *plan* built on it — its §7 Box asks to
exclude `(AHS-Gamma)`, whose negation Theorem 2.1 proves. The sealed retraction
facts are conditional statements about a hypothetical `A_0` and are untouched.
`THEOREM_RESTRICTED_DICHOTOMY.md` Corollary 4.3 (`delta = 1` is a norm) is
*reinforced*: at `delta = 1` one has `phi = id_X`, `Gamma = X`, `e_exc = 0`, so
`r_phi = 0`, CLEAN, `1 = N(1)` — Theorem 2.1 correctly does not fire there.

## A27. Could the geometry have refuted the sealed chain?

**Attack.** Theorem 2.1 forces a strict support inside `Bs(J_{phi_8})` carrying
a weight-one block that receives `E_{-11}`. Had `Bs(J_{phi_8})` been empty, or
had every component demonstrably carried no `E_{-11}`, the chain
(`delta = 208` + dichotomy + `End = O_K`) would be refuted. This is a genuine
falsification test, not a rubber stamp.

**Outcome: the chain passes, and the test had teeth.** `Bs(J_{phi_8})` is a
curve of degree `1224` (proper complete intersection of type `(3,24,17)`,
Hilbert polynomial `1224 i - 23868`, matching the adjunction prediction
`2 p_a - 2 = 39 · 1224`). Its reduced degree is `864 = 72 + 792`. The
degree-`792` component `Lambda` is irreducible and `G`-invariant, its line map
is nonconstant, and its image `C_0` in the Fano surface is a `G`-invariant
curve; since `Alb(S) = J(X)`, `S ↪ Alb(S)`, and `H^1(J(X),Q) = V(-1)` is
`G`-irreducible, the abelian subvariety generated by `C_0` is all of `J(X)` and
`V(-1) ↪ H^1(C̃_0)`. The datum exists, exactly where the theory demands.

## A28. Is the `E_{-11}` input itself sound?

**Attack.** The whole arithmetic test rests on `J(X) ≅ E_{-11}^5` and
`End_{G-HS}(V_Z) = O_K`, imported from Roulleau/Adler.

**Outcome: independently reconfirmed from `F` alone.** Exhaustive enumeration of
`P^4(F_p)` for `25` primes `13 <= p <= 113` gives `Tr(Frob | H^3(X)) = 0` for
every `p ≢ 1 mod 11` (21 primes) and `Tr = 5 p a_p` with
`4p = a_p^2 + 11 b^2` for `p = 23, 67, 89, 199` (`a = -9, +13, -9, -20`). That
is the signature of a CM structure induced from `Q(zeta_11)` with `E_{-11}`
factors. Had `H^3(X)` not been of that shape, the counts would have disagreed
at the first split prime.

## A29. Is `deg Lambda = 792` an artefact of one prime, one seed, or one chart?

**Attack.** The degree comes from an msolve slice; a nongeneric hyperplane, a
bad prime, or a missed flag chart would corrupt it.

**Outcome: three `(prime, seed)` pairs, all five flag charts, plus a
characteristic-zero bound.** `(1000003, 20260812)`, `(2000003, 777)`,
`(1000033, 31337)` all give `864` distinct points for `Bs(J)` and `72` for
`D_8`, with all five flag charts solved and charts `1..4` empty. Independently,
the structural multiplicity bound of `PHI8_CARRIER.md` Proposition 5.1 gives
`mult_{D_8} >= 6` in characteristic zero, hence
`deg Lambda <= 1224 - 432 = 792`; the slice gives `>= 792`. Both bounds meet.

## A30. Could `Lambda` be a union of lines, which would be CARRIER-dead?

**Attack.** Lemma 4.4: a component of `Lambda` that is a line `l` with constant
line map has exceptional divisor `l x l` and `H^1 = 0`. If `Lambda` were `792`
such lines (say a free orbit of `660` plus an orbit of `132`), the boxed
candidate would evaporate.

**Outcome: excluded twice over.** First, `Lambda` is *irreducible* of degree
`792` (§5.3), so it is not a line at all. Second, and independently, at
`p = 23, 61, 79, 109` every `F_p`-point `x` of `Lambda` (`990`, `55`, `75`,
`120` of them) has `l_x ⊄ Bs(J)`; the base scheme is a proper complete
intersection with constant Hilbert polynomial, hence flat over `Z`, so a
characteristic-zero line component would specialise to a line component with
the same constant line map, and one witness settles it.

## A31. Does the packet overclaim by not deciding `D_8` and the 60-point orbit?

**Attack.** Two of four orbits are `UNDECIDED`. A packet that boxes a carrier
while leaving orbits open might be papering over a gap.

**Outcome: the open orbits cannot change any verdict here.** The branch verdict
is settled by Theorem 2.1, which is orbit-independent. Deciding `D_8` and the
`60` points would only sharpen *which* support carries the block; it could never
yield `RETRACTION-BRANCH-DEAD`, since that needs **every** orbit dead and
Theorem 2.1 forbids that. The blowup points are recorded exactly
(`PHI8_CARRIER.md` §5.5): the geometric genus and isogeny data of `D̃_8`, the
fibres of `Gamma -> X` over `D_8` and over the `60` points, and two
`minimalPrimes` runs that did not terminate in 61 minutes at 3.2 GB resident.

## A32. Is the (S2) lever really void in general, or only for `phi_8`?

**Attack.** Perhaps `phi_8` is special and (S2) still works for some other
`psi in Self`.

**Outcome: void in general.** The argument uses nothing about `phi_8` beyond
the five inputs of §2, which every dominant `G`-equivariant selfmap satisfies.
For any such `psi`, "`delta(psi)` is not represented by `x^2+xy+3y^2`" implies
CARRIER unconditionally, hence implies that the second half of (S2) — "exclude
the CARRIER branch for `psi`" — asks for a proof of a false statement. The two
halves are mutually exclusive at every degree and for every `psi`.
`S2-DETECTION-LEVER-VOID`.
