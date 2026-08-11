## 2026-08-11 Retract-rationality literature landscape: the Klein cubic provably escapes the July-2025 obstruction, and Problem E's delta=1 fork stays open

Packet: `goal_runs_20260811/RETRACT_LANDSCAPE_NOTE/`. Entry [E51](#e51).
Problem E remains **OPEN**. Adjudicated 2026-08-11 (`ADJUDICATION_PR38.md`):
all nine citations re-checked against the actual paper text; three
corrections and one refutation applied in place; verifier 7/7.

Engel-de Gaay Fortman-Schreieder (arXiv:2507.15704, Thm 1.3/Cor 1.4, July
2025) prove very general cubic threefolds are neither stably nor retract
rational -- per this note's survey, the first published retract-irrationality
result for cubic threefolds; endorsed in Schreieder's ICM 2026 survey
(arXiv:2510.13679); an unrefereed independent duplicate is Banerjee
arXiv:2509.06013.

This packet assembles (it proves nothing new) a four-step published-theorem
chain showing the Klein cubic escapes that machinery: `J(Klein) ~= E^5` as
abelian varieties (Roulleau arXiv:1001.4853 Thm 2 + intro remark, quoted from
the local PDF; also Adler 1981) + the integral Hodge conjecture for 1-cycles
on a product of Jacobians, which is polarization-free (Beckmann-de Gaay
Fortman arXiv:2202.05230 Thm 1.2) => the minimal class is algebraic on
`J(Klein)` despite the polarization not being the product one => the Klein
cubic has universally trivial `CH0` and an integral decomposition of the
diagonal (Voisin JEMS 2017 arXiv:1407.7261 Thm 1.7/Cor 4.4, an iff). Every
known bare-variety obstruction to retract rationality vanishes for the Klein
cubic; retract rationality of the bare Klein cubic stays OPEN in both
directions (decomposition of the diagonal is necessary, not sufficient --
Voisin's own caveat).

**Refuted in adjudication and retracted (THEOREM.md 2.1):** the draft's claim
that the Klein cubic is *the* one such cubic threefold and is *maximally
favorable* among all of them. Voisin's own Thm 1.7 continues "This happens (at
least) on a countable union of closed subvarieties of codimension <= 3 of the
moduli space", constructed explicitly in her Thm 4.5 by an order-3-automorphism
/ odd-isogeny route that has nothing to do with Klein or with CM; and the
step-(i) input is not unique either -- Roulleau arXiv:1001.4855 Thm 23 gives
`J(Fermat cubic 3-fold) ~= E^4 x E'` (an isomorphism; note NOT `E^5`, since `E`
and `E'` are 3-isogenous but distinct), and arXiv:0804.1861 Thm 27 gives a
1-parameter family with Albanese isomorphic to a product of elliptic curves.
What survives: the Klein cubic is in the escaping locus, with the sharpest
form of the input (an isomorphism, not an isogeny). Its Problem-E interest
comes from `Aut(X) = PSL(2,11)`, which is unique to it.

Relevance to Problem E: the sealed self-map dichotomy's `delta = 1` case
(an equivariant retraction of `P^4` onto `X`) would witness exactly this
bare-variety retract rationality. The July-2025 machinery cannot decide it
either way (it needs the minimal class to fail algebraicity, which it does
not here); no bare-variety method can; killing `delta = 1` requires the
group action. The repository's own degree bookkeeping excludes retractions
through ambient coordinate degree `d <= 30`
(`AMBIENT_REES_SELFMAP_CLASSIFICATION` + `FIX_P2_GATEWAY_D36` +
`COMBINED_DEGREE_SIEVE`) without closing the fork; the `delta = 3` cell's
realizability is still uncomputed (2026-08-10 Wave-33 routing note). The fork
between `delta = 1` and `delta >= 3` stays open -- `delta = 3` satisfies every
sealed constraint at every live degree, so nothing in the repository pushes the
non-retraction side higher. (Also corrected in adjudication: `RT_SPLIT` Thm 3.1
gives the CM-norm condition on `delta`, not a lower bound; and Colliot-Thelene-
Voisin's vanishing is of unramified `H^3(-, Q/Z)`, not `H^3(-, Z)`.)

Keep `E` (CM, `J(Klein) ~= E^5`'s factor, `j = j((-1+sqrt(-11))/2)`) and
`E_sigma` (non-CM, `j = 8192/11`, the involution-fixed curve, sealed
`FIX-A0`) distinct -- both appear in this landscape and are easy to
conflate.

Exits: `RETRACT-LANDSCAPE-NOTE-ASSEMBLED` (primary),
`RETRACT-LANDSCAPE-ROULLEAU-PDF-PRESENT`,
`RETRACT-LANDSCAPE-ROULLEAU-QUOTE-FOUND`,
`RETRACT-LANDSCAPE-8192-11-NON-CM-OK`,
`RETRACT-LANDSCAPE-REPO-PATHS-RESOLVE`,
`RETRACT-LANDSCAPE-REPO-EXITS-RESOLVE`,
`RETRACT-LANDSCAPE-REFUTED-CLAIMS-STAY-RETRACTED`.

Not claimed: any rationality statement about the Klein cubic; any movement
on the `delta = 1` fork; any uniqueness of the Klein cubic in the
bare-variety landscape; that the section-2 chain is a published theorem of
any single cited paper (it is an assembly, flagged as such). Headline
status unchanged: OPEN.
