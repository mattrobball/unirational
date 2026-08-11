# The retract-rationality literature landscape for the Klein cubic threefold

**Packet:** `goal_runs_20260811/RETRACT_LANDSCAPE_NOTE/`
**Date:** 2026-08-11
**Kind:** literature-landscape assembly (no new mathematics; see DEPENDENCIES)
**Scope:** Problem E, the Klein cubic threefold `X = {x1x5^2+x5x3^2+x3x4^2+x4x2^2+x2x1^2=0} subset P^4`, `G = Aut(X) = PSL2(F11)`.

This note assembles, with exact citations, the current state of the published
literature on retract rationality of cubic threefolds, establishes that the
Klein cubic is a member of the family that the July-2025 landscape event
provably does not reach, and records what that non-reach does and does not
say about Problem E. All mathematical content below was derived and
adjudicated by the director beforehand; this packet's job is citation-exact
assembly, not new proof.

> **Adjudication amendment, 2026-08-11.** An earlier revision of this note said
> the Klein cubic is *the* one such member and is *maximally favorable* among
> all cubic threefolds. That was **refuted** and is retracted; see
> `ADJUDICATION_PR38.md` and §2.1 below. What survives — and is what the rest
> of the note uses — is that the Klein cubic **is** in the escaping locus, with
> the sharpest available form of the input (an isomorphism `J(X) ≅ E^5`, not
> merely an isogeny).

---

## 1. The July-2025 landscape event

**Engel, de Gaay Fortman, Schreieder**, *"Matroids and the integral Hodge
conjecture for abelian varieties"*, arXiv:2507.15704 (July 2025).

- **Theorem 1.3.** For a very general cubic threefold, every curve class on
  the intermediate Jacobian is an even multiple of the minimal class.
- **Corollary 1.4.** Consequently, very general cubic threefolds admit no
  (Chow-theoretic) decomposition of the diagonal, hence are **neither stably
  rational, nor retract rational, nor A¹-connected**.

This is, to the best of this note's literature survey, the **first published
retract-irrationality result for cubic threefolds** — no earlier published
theorem is known to us that excludes retract rationality for any smooth cubic
threefold. This is a survey judgement, not a verified statement, and is
recorded as such. (The paper's own abstract states the headline
consequence directly: "This disproves the integral Hodge conjecture for
abelian varieties and shows that very general cubic threefolds are not
stably rational"; Corollary 1.4's sharper retract/A¹ statement is the one
that matters for this note.)

The result is endorsed and surveyed in **Schreieder**, *"Rationality of
hypersurfaces"*, arXiv:2510.13679, to appear in the Proceedings of ICM 2026 —
a survey of cycle-theoretic and combinatorial methods for hypersurface
rationality problems.

**Independent unrefereed duplicate:** **Banerjee**, *"Universal codimension
two cycle on a very general cubic threefold"*, arXiv:2509.06013 (September
2025), proves the overlapping statement that a very general cubic threefold
admits no universal codimension-two cycle and is hence stably irrational.
This is noted here as an **unrefereed** independent arrival at essentially
the same conclusion by a different route (non-existence of a universal
codimension-2 cycle, rather than the matroid/minimal-class argument), not as
a second landscape event.

**What "very general" means here, and why it matters.** All three papers
prove statements for a very general member of the family of cubic
threefolds — a property holding outside a countable union of proper closed
subvarieties of the moduli space. This says nothing, by itself, about any
*named* cubic threefold, including the Klein cubic. Section 2 shows the gap
is not merely a labeling accident: the Klein cubic is excluded from the
argument's reach by an explicit, provable structural reason. Section 2.1
records that the excluded locus is **not** just the Klein cubic — it is
positive-dimensional and was already known to be non-empty before 2025.

---

## 2. The Klein cubic provably escapes that machinery

The escape route is a chain of four steps, each a previously published
theorem, apparently never assembled into a single statement in print before
now. Each step is cited exactly; the chain as a whole is **not** a
published statement (see DEPENDENCIES).

### (i) `J(Klein) ≅ E^5` as abelian varieties

**Roulleau**, *"The Fano surface of the Klein cubic threefold"*, J. Math.
Kyoto Univ. **49** (2009), arXiv:1001.4853, Theorem 2, together with the
introduction remark immediately following it.

Theorem 2 computes the period lattice of the Fano surface of the Klein cubic
exactly, in terms of `nu = (-1+i*sqrt(11))/2` and `E = C/Z[nu]`. The
introduction then states (p. 2 of the arXiv PDF, quoted verbatim from
`external_docs/roulleau_fano_klein_cubic_arxiv1001.4853.pdf`, director-verified
against the PDF):

> "We remark that J(F) ≃ Alb(S) is isomorphic to E⁵ but by [7] (0.12), this
> isomorphism is not an isomorphism of principally polarized abelian
> varieties (p.p.a.v.). The fact that J(F) is isomorphic to E⁵ is proved in
> [2] in a different way."

(`F` is Roulleau's name for the Klein cubic threefold, `S` its Fano surface;
reference [7] is Clemens–Griffiths, *"The intermediate Jacobian of the cubic
threefold"*, Ann. of Math. **95** (1972), 281–356; reference [2] is confirmed
from the same PDF's bibliography as **A. Adler**, *"On the automorphism
groups of certain hypersurfaces"*, J. Algebra **72** (1981), no. 1, 146–165 —
matching the credit given in the task brief for this packet. The plural
"groups" is the title as published; Roulleau's bibliography entry has the
singular.)

The precise content needed below: `J(X)` is isomorphic to `E^5` **as an
abelian variety** (equivalently, as a complex torus with its group
structure), but **not** as a principally polarized abelian variety — the
polarization on `J(X)` is not the product principal polarization on `E^5`.
This distinction is exactly what step (ii) is built to not need.

### (ii) The integral Hodge conjecture for 1-cycles holds on any product of Jacobians, polarization-free

**Beckmann, de Gaay Fortman**, *"Integral Fourier transforms and the
integral Hodge conjecture for one-cycles on abelian varieties"*, Compositio
Math. **159** (2023), arXiv:2202.05230, Theorem 1.2.

Theorem 1.2 proves the integral Hodge conjecture for 1-cycles on any
abelian variety that is a product of Jacobians of smooth projective curves,
by lifting the Fourier–Mukai transform to integral Chow groups. The
statement is about the abelian variety **as an abelian variety** — it does
not reference or depend on which polarization is placed on it. Since
`J(X) ≅ E^5` as an abelian variety by (i), and `E^5` is (tautologically) a
product of Jacobians of curves (five copies of the elliptic curve `E`,
each its own Jacobian), Theorem 1.2 applies to `J(X)` — **despite** the
polarization on `J(X)` not being the product polarization.

### (iii) The minimal class is algebraic on `J(Klein)`

Immediate from (i)+(ii): the minimal class `theta^4/4!` on `J(X)` is
algebraic — i.e. is the class of an actual algebraic 1-cycle, not merely a
Hodge class that fails integrally.

This is precisely the property whose *failure* (the minimal class being only
an even multiple, not itself algebraic) is Engel–de Gaay Fortman–Schreieder's
Theorem 1.3 for a very general cubic threefold. The Klein cubic sits on the
opposite side of that dichotomy from the very general member.

### (iv) Universally trivial `CH0` and integral decomposition of the diagonal

**Voisin**, *"On the universal `CH0` group of cubic hypersurfaces"*, JEMS
**19** (2017), no. 6, 1619–1653, arXiv:1407.7261, Theorem 1.7 / Corollary
4.4.

For a cubic threefold, Voisin's Theorem 4.1/4.5 machinery ties universal
triviality of `CH0` (equivalently, existence of an integral Chow-theoretic
decomposition of the diagonal) to algebraicity of the minimal class on the
intermediate Jacobian. By (iii), the hypothesis is met for the Klein cubic,
so the Klein cubic **has universally trivial `CH0` and admits an integral
Chow-theoretic decomposition of the diagonal.**

### Consequences

Every known obstruction to retract rationality that could apply to a bare
cubic threefold **vanishes for the Klein cubic**:

- **Torsion in `H^3`, the Brauer obstruction, unramified `H^3`** — all
  already known to vanish for *every* smooth cubic threefold (not specific
  to Klein), by **Colliot-Thélène, Voisin**, *"Cohomologie non ramifiée et
  conjecture de Hodge entière"*, Duke Math. J. **161** (2012), no. 5,
  735–801: unramified `H^3(-, Q/Z)` vanishes on all uniruled threefolds,
  and smooth cubic threefolds are uniruled. (The coefficient group is
  `Q/Z`, not `Z`; an earlier revision of this note said `Z`.)
- **The (integral) decomposition of the diagonal** — vanishes as an
  obstruction by step (iv) above.
- **The minimal class** — algebraic, by step (iii).
- **The universal codimension-2 cycle** obstruction of **Voisin**,
  *"Cycle classes on abelian varieties and the geometry of the Abel–Jacobi
  map"*, Pure Appl. Math. Q. **20** (2024), no. 5, 2469–2496,
  arXiv:2212.03046, Theorem 1.15: *a smooth cubic threefold admits a
  universal codimension-2 cycle **if** the minimal class of its intermediate
  Jacobian is algebraic.* This is a one-directional implication (the partial
  converse is the separate Theorem 1.16, which is not used here), and the
  direction stated is exactly the one needed: step (iii) supplies the
  hypothesis, so the Klein cubic **does** admit a universal codimension-2
  cycle and that obstruction does not fire.

The Klein cubic therefore sits in the **good locus of Voisin's Theorem 1.7 /
Corollary 4.4** (the JEMS 2017 paper), whose criterion is an equivalence:
*a smooth cubic threefold has universally trivial `CH0` if and only if
`theta^4/4!` is algebraic on `J(X)`*.

**What this does and does not prove.** Decomposition of the diagonal is
**necessary, not sufficient**, for stable or retract rationality — this is
Voisin's own caveat, standing behind both the JEMS 2017 and PAMQ 2024
papers. The chain (i)–(iv) proves **no rationality statement** about the
Klein cubic. It proves only that every *currently known* obstruction to
retract rationality built from the intermediate Jacobian's Hodge/Chow theory
fails to fire. Consequently:

> **Retract rationality of the bare Klein cubic threefold is OPEN in both
> directions.** The Klein cubic lies in the locus where every currently known
> bare-variety obstruction vanishes, while (per §1) the very general member
> has them all fire.

## 2.1 The escaping locus is not just the Klein cubic — REFUTED CLAIM, recorded

An earlier revision of this note claimed the Klein cubic is *maximally
favorable* and that "no other named or general member of the family has all of
these obstructions simultaneously vanish". **That claim is false**, and it is
refuted by two sources this note already cites or is adjacent to.

1. **Voisin's own Theorem 1.7** (JEMS 2017, arXiv:1407.7261) continues past
   the equivalence quoted above: *"This happens (at least) on a countable union
   of closed subvarieties of codimension ≤ 3 of the moduli space of `X`."* Her
   Theorem 4.5 constructs those families explicitly — cubic threefolds with an
   order-3 automorphism acting as `(X0, jX1, j^2X2, X3, X4)`, for which an
   odd-degree isogeny of `J(X)` to a Jacobian of a reducible curve, combined
   with `2·theta^4/4!` always being algebraic on a Prym, forces `theta^4/4!`
   itself to be algebraic. So a **positive-dimensional, Zariski-dense countable
   union** of cubic threefolds with universally trivial `CH0` was published in
   2017, by a route that does not use the Klein cubic, CM, or step (ii) at all.
2. **The step-(i) input is not unique to Klein either.** Roulleau, *"Fano
   surfaces with 12 or 30 elliptic curves"*, arXiv:1001.4855, Theorem 23: for
   the **Fermat** cubic threefold the intermediate Jacobian `A` is *isomorphic*
   to `E^4 × E'` with `E = C/Z[alpha]`, `E' = C/Z[3 alpha]`, `alpha` a primitive
   cube root of unity — a product of elliptic curves, hence of Jacobians, so
   steps (ii)–(iv) apply verbatim. (Note `E^4 × E'`, **not** `E^5`: `E` and `E'`
   are 3-isogenous but not isomorphic, so sources writing `J ∼ E^5` for Fermat
   are stating an isogeny.) Roulleau, *"Elliptic curve configurations on Fano
   surfaces"*, arXiv:0804.1861, Theorem 27, gives a one-parameter family
   `F_lambda = {x1^3+x2^3+x3^3-3 lambda x1x2x3 + x4^3 + x5^3 = 0}` whose
   Albanese is isomorphic to a product of elliptic curves at the CM values of
   `lambda`.

**What survives.** The Klein cubic is in the escaping locus, and it is the
member where the step-(i) input is available in its sharpest published form —
an **isomorphism** `J(X) ≅ E^5` (Adler 1981; Roulleau 2009), not an isogeny,
with `E` having CM by `Q(sqrt(-11))`. Its interest for Problem E (§3) comes
from `Aut(X) = PSL(2,11)`, which is genuinely unique to it, not from any
uniqueness in the bare-variety landscape.

---

## 3. Relevance to Problem E (record precisely, no overclaim)

Problem E is not "is the bare Klein cubic retract rational" — it is a
question about `G`-equivariant structure (see `SPEC.md`, `NOTEBOOK.md`).
The bare-variety landscape above is relevant to Problem E only through one
specific fork, sealed in the repository's own self-map analysis.

**The self-map dichotomy.** Any hypothetical `G`-equivariant parametrization
`T : P(W_5) --> X` restricts on `X` to a `G`-equivariant self-map `X --> X`
of some degree `delta`. The CLEAN/CARRIER dichotomy of
`goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md`,
Theorem 3.1, says: either the exceptional part `r_phi` is non-zero (CARRIER)
or it vanishes and then `u_phi^dagger u_phi = delta·id` on `V`, forcing
`delta = x^2 + xy + 3y^2`, i.e. **`delta` is a norm from `Q(sqrt(-11))`**.
Theorem 3.1 does **not** bound `delta` from below; `delta >= 3` is a separate,
weaker statement, and it holds only on the non-retraction side — `2` is not a
norm, so the norm condition rules out `delta = 2`, and `delta = 1` is precisely
the retraction case (see `goal_runs_20260810/COMBINED_DEGREE_SIEVE/STATUS.md`
§4, which runs the retraction branch at `delta = 1` and the all-ambient branch
over the norms in `[3, d^3 - d]`). An earlier revision of this note attributed
`delta >= 3` to Theorem 3.1, which is a mis-citation and contradicted its own
next sentence.

The case **`delta = 1`** is the case where the restricted self-map is the
identity — i.e. `T` is an honest `G`-equivariant retraction of `P^4` onto `X`.
Such a retraction would in particular **witness retract rationality of the bare
Klein cubic**. Per §2.1 that would not be a first among cubic threefolds in the
*obstruction-vanishing* sense — Voisin's 2017 families already have universally
trivial `CH0` — but it would be the first actual retraction ever exhibited, on
any cubic threefold, since §2 only removes obstructions and constructs nothing.

**Why §1–2's machinery cannot decide this fork.** The July-2025 landscape
event and its published relatives are all statements about the intermediate
Jacobian's Hodge/Chow theory on the *bare* variety; §2 already shows this
machinery provably does not reach the Klein cubic (it needs the minimal
class to fail to be algebraic, and on the Klein cubic it does not fail).
No method built only from the bare variety can decide `delta = 1` versus
`delta > 1` either way, for the same structural reason: the bare-variety
obstructions are already exhausted (§2) without deciding rationality, let
alone the sharper equivariant retraction question. **Killing `delta = 1`,
if it can be killed at all, therefore requires the group action** — it is
not a question the literature surveyed in §1–2 is equipped to touch.

**Current status of the fork.** Nothing in the repository supports
`delta = 1` either — it is not a live conjecture, only an unclosed case.
The repository's own arithmetic and degree bookkeeping bound the fork from
one side without closing it:

- `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/RETRACTION_DEGREE_BOUND.md`
  proves any retraction's ambient coordinate degree `d` satisfies `d >= 24`
  (exit `DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`).
- `goal_runs_after_2666fdb/FIX_P2_GATEWAY_D36` (`FIX-P2-SWEEP2-EMPTY-THROUGH-30`)
  independently empties the retraction and all-ambient branches for
  `22 <= d <= 30`.
- `goal_runs_20260810/COMBINED_DEGREE_SIEVE/` synthesizes these: the
  **sealed exclusions already cover every retraction with `d <= 30`**; for
  `31 <= d <= 60` both the retraction branch (at the single value
  `delta = 1`) and the all-ambient branch (at every norm value of
  `Q(sqrt(-11))` in `[3, d^3-d]`) remain live, and the packet proves no
  congruence-type sieve can close this — every sealed constraint is an
  upper bound or a membership condition on `delta`, none is a lower bound
  past `delta >= 3`.
- The 2026-08-10 routing note (`NOTEBOOK.md`, "Wave-33 routing") records
  that the degree of the constructed tangent-residual self-map — which
  would decide whether the `delta = 3` cell is realized — was never
  computed, and flags this as the missing ingredient.
- `goal_runs_after_88f0967/FIX_VIII_A5LADDER` (read-only reference here;
  **not touched by this packet**) independently hunts for low-degree
  `A5`-equivariant landing data and is `EMPTY-THROUGH-10`, with rungs 11
  and 12 boxed `UNDECIDED`.

Taken together, the honest statement of where the fork currently stands is:
**the retraction case (`delta = 1`) is not excluded, and neither is the
smallest non-retraction cell; the fork between `delta = 1` and `delta >= 3`
stays open.** `COMBINED_DEGREE_SIEVE/STATUS.md` is explicit that "the cell
`delta = 3` satisfies every sealed constraint at every live degree", and `3` is
a norm from `Q(sqrt(-11))`, so no repository result pushes the non-retraction
side above `3`. (An earlier revision of this note wrote `delta >= 12`; that
figure has no support anywhere in the repository — the A5-ladder's
`EMPTY-THROUGH-10` with rungs 11, 12 undecided is a statement about the
coordinate degree `d` of `A5`-equivariant landing data, not about `delta` — and
it is retracted.) This packet does not move the fork in either direction; it
only records why the July-2025 landscape event cannot be the tool that moves
it.

**The retraction-slice ansatz.** A retraction's ambient tuple is forced
into the accepted polar normal form `T = H*x + F*Q` of
`RETRACTION_DEGREE_BOUND.md` §1, with `H` an invariant scalar of degree `d-1`,
`Q` a `W`-valued covariant of degree `d-3`, `gcd(H,F) = 1`, and
`H ≡ -grad(F)·Q mod F` — the latter being that file's identity (1.2)
`H + 3·Phi(x,x,Q) = F·R` together with `3·Phi(x,x,Q) = grad(F)(x)·Q`. (Beware
the letter clash: that file's own `A` and `B` are `Phi(x,x,Q)` and
`Phi(x,Q,Q)`, not the `H` and `Q` used here.) The free data is therefore a single
`W`-valued `G`-covariant `B` of degree `d-3` — a strictly thinner slice of
the general covariant search than the unrestricted landing-tuple problem.
The sealed exclusions through `d <= 30` (above) already cover this thinner
slice for retractions in that range; nothing here reopens or narrows it
further.

---

## 4. Two elliptic curves — do not conflate

Two different elliptic curves attached to the Klein cubic appear in this
landscape and must be kept distinct.

**`E` — the CM factor of `J(Klein) ≅ E^5`.** `E = C/Z[nu]`,
`nu = (-1+sqrt(-11))/2`, from Roulleau Theorem 2 (§2(i) above). This curve
**has complex multiplication**, by `Q(sqrt(-11))` — its endomorphism ring is
(an order in) `Z[nu]` by construction, not merely `Z`. This is the curve
whose fifth power is `J(X)` as an abelian variety.

**`E_sigma` — the involution-fixed curve.** For each of the 55 involutions
`sigma` in `G`, `X^sigma = E_sigma ⊔ L_sigma` splits into a smooth plane
elliptic curve `E_sigma` and a line `L_sigma`. Sealed in
`goal_runs_after_2880a28/FIX_A0_INVOLUTION_ARRANGEMENT` (exit
`FIX-A0-C3-ELLIPTIC-J-PASS`): `j(E_sigma) = 8192/11` exactly, identically
for all 55 involutions, verified by two independent characteristic-0 routes.
This curve is explicitly **non-CM**: `8192/11 = 2^13/11` has denominator 11,
so it is **not an algebraic integer**, and every CM elliptic curve has an
integral `j`-invariant (`FIX_A0_INVOLUTION_ARRANGEMENT/STATUS.md`, "Non-CM
corollary"). The two facts are independent and consistent with each other:
`E` (CM, `j = j(nu)`, the intermediate-Jacobian factor) and `E_sigma`
(non-CM, `j = 8192/11`, a fixed-locus curve on `X` itself) are different
curves playing different roles, and neither statement bears on the other.

---

## DEPENDENCIES

This packet cites and depends on the following, in three tiers.

### A. Published theorems (cited exactly; not independently re-derived)

1. Engel, de Gaay Fortman, Schreieder, "Matroids and the integral Hodge
   conjecture for abelian varieties", arXiv:2507.15704 (July 2025).
   Theorem 1.3, Corollary 1.4. Title/authors/abstract confirmed live against
   arxiv.org 2026-08-11.
2. Schreieder, "Rationality of hypersurfaces", arXiv:2510.13679, to appear
   Proc. ICM 2026. Confirmed live against arxiv.org 2026-08-11 (confirmed:
   ICM 2026 proceedings survey; MSC classes include 05B35 matroids).
3. Banerjee, "Universal codimension two cycle on a very general cubic
   threefold", arXiv:2509.06013 (September 2025) — **unrefereed**.
   Confirmed live against arxiv.org 2026-08-11.
4. Beckmann, de Gaay Fortman, "Integral Fourier transforms and the integral
   Hodge conjecture for one-cycles on abelian varieties", Compositio Math.
   159 (2023), arXiv:2202.05230. Theorem 1.2. Confirmed live against
   arxiv.org 2026-08-11.
5. Voisin, "On the universal CH0 group of cubic hypersurfaces", JEMS 19
   (2017), no. 6, 1619-1653, arXiv:1407.7261. Theorem 1.7 / Corollary 4.4;
   Theorem 4.1/4.5 machinery cited in §2 consequences. Confirmed live
   against arxiv.org 2026-08-11.
6. Voisin, "Cycle classes on abelian varieties and the geometry of the
   Abel-Jacobi map", Pure Appl. Math. Q. **20** (2024), no. 5, 2469-2496,
   arXiv:2212.03046. Theorem 1.15, a one-directional "if" (Theorem 1.16 is
   the partial converse and is not used). Title, author, venue, volume,
   issue and pages confirmed 2026-08-11; Theorem 1.15's statement extracted
   from the paper text in adjudication.
7. Colliot-Thelene, Voisin, "Cohomologie non ramifiee et conjecture de
   Hodge entiere", Duke Math. J. 161 (2012), no. 5, 735-801. Bibliographic
   data confirmed. **Coefficient group corrected in adjudication:** the
   vanishing is for unramified `H^3(-, Q/Z)` on uniruled threefolds, not
   `H^3(-, Z)` as an earlier revision of §2 stated.
8. Adler, "On the automorphism **groups** of certain hypersurfaces",
   J. Algebra 72 (1981), no. 1, 146-165. Bibliographic data confirmed;
   **title corrected in adjudication** — "groups", plural (an earlier
   revision, following item B's bibliography entry, had the singular).

None of items 1-7's source PDFs are present in this repository's
`external_docs/`. Their statements were transcribed from the director's prior
reading plus this packet's own live confirmation pass (arXiv abstract pages
and one web search, both 2026-08-11). **In adjudication (2026-08-11) items
1, 4, 5, 6 were re-checked against the actual paper text, not just the
abstract pages, and all four theorem/corollary numbers and statements were
confirmed verbatim** — including the load-bearing item 4 (Beckmann-de Gaay
Fortman Thm 1.2 really is "the integral Hodge conjecture for one-cycles holds
for the product of Jacobians `J(C1) × ... × J(Cn)`", a standalone theorem, not
a misattributed corollary of their more general Thm 1.1), and item 5 (Voisin
JEMS Thm 1.7 really is the stated equivalence for smooth cubic threefolds).
See `ADJUDICATION_PR38.md`.

### B. Director-verified joint (quoted from the local PDF)

Roulleau, "The Fano surface of the Klein cubic threefold", J. Math. Kyoto
Univ. 49 (2009), arXiv:1001.4853. PDF present at
`external_docs/roulleau_fano_klein_cubic_arxiv1001.4853.pdf` (212270 bytes).
Theorem 2 and the introduction remark on p. 2 (page 2 of the arXiv PDF,
the page headed "2 XAVIER ROULLEAU") are quoted verbatim in §2(i) above,
extracted with `pdftotext -layout` and checked by this packet's own
`verifier.py` (see below) — independently reproducing the director's
earlier verification against the same PDF.

### C. Assembled-chain status

The four-step chain in §2 ((i)-(iv), plus its "Consequences") is **NOT a
published statement**. It is an assembly, by the director, of items A5/A7
(Voisin JEMS 2017, Colliot-Thelene-Voisin 2012) and B (Roulleau + Adler)
with item A4 (Beckmann-de Gaay Fortman 2023), noting that step (ii)'s
polarization-independence is what lets step (i)'s "not a p.p.a.v.
isomorphism" caveat be safely stepped around. No single cited paper states
"the Klein cubic has universally trivial CH0" or "the Klein cubic escapes
the July-2025 obstruction" — that conclusion exists only in this note and
in the director's prior derivation, and should be cited as such (an
assembly, flagged), never as a theorem of any of the papers in tier A or B
individually.

The same caveat applies, with the same force, to the *non-uniqueness*
statement of §2.1: the observation that Roulleau's Fermat and `F_lambda`
results feed the identical chain is likewise an assembly by this packet, not
a published corollary. What §2.1 cites as published, and what does the
refuting work on its own, is Voisin's Theorem 1.7 sentence about the
codimension-`<= 3` countable union.

Section 3's "relevance to Problem E" is entirely internal repository
content (packets named therein); it cites no external literature beyond
what's already listed above.

---

## Verification

`verifier.py` (pure python3, standard library only): confirms the cited
external PDFs present in `external_docs/` with their sizes; greps the exact
Roulleau quote out of a fresh `pdftotext -layout` extraction (skipped with a
clear message if `pdftotext` is unavailable); and re-checks trivially that
`8192/11` is not an algebraic integer (denominator `!= 1` in lowest terms).
It does not and cannot verify the tier-A published theorems themselves —
that verification is literature review, not computation, and is recorded
in DEPENDENCIES above as the director's prior reading plus this packet's
live arXiv/web confirmation pass and the adjudication's full-text pass.

**Added 2026-08-11 in adjudication** — §3 is the only part of this note making
load-bearing *repository* claims, and the adjudication found two mis-citations
there, so those claims are now machine-guarded:

* every in-repo path named in §3 must exist on disk (6 paths);
* every exit marker attributed to a packet must appear verbatim somewhere in
  that packet's own files (5 markers);
* the three statements refuted in adjudication (`delta >= 12`, "maximally
  favorable", "no other named or general member") must not reappear as
  assertions — only inside an explicit retraction passage.

Exits: `RETRACT-LANDSCAPE-ROULLEAU-PDF-PRESENT`,
`RETRACT-LANDSCAPE-ROULLEAU-QUOTE-FOUND` (or `-SKIPPED-NO-PDFTOTEXT`),
`RETRACT-LANDSCAPE-8192-11-NON-CM-OK`, `RETRACT-LANDSCAPE-REPO-PATHS-RESOLVE`,
`RETRACT-LANDSCAPE-REPO-EXITS-RESOLVE`,
`RETRACT-LANDSCAPE-REFUTED-CLAIMS-STAY-RETRACTED`,
`RETRACT-LANDSCAPE-NOTE-ASSEMBLED` (primary). 7 checks, 0 failures.

**Not claimed:** any new obstruction, any new rationality statement about
the Klein cubic or Problem E, any resolution of the `delta = 1` fork, any
uniqueness or maximality of the Klein cubic within the family of cubic
threefolds (see §2.1), and no claim that the chain in §2 is itself a citable
theorem of any single paper.
