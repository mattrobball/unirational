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
