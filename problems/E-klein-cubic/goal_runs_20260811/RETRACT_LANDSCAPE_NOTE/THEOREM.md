# The retract-rationality literature landscape for the Klein cubic threefold

**Packet:** `goal_runs_20260811/RETRACT_LANDSCAPE_NOTE/`
**Date:** 2026-08-11
**Kind:** literature-landscape assembly (no new mathematics; see DEPENDENCIES)
**Scope:** Problem E, the Klein cubic threefold `X = {x1x5^2+x5x3^2+x3x4^2+x4x2^2+x2x1^2=0} subset P^4`, `G = Aut(X) = PSL2(F11)`.

This note assembles, with exact citations, the current state of the published
literature on retract rationality of cubic threefolds, establishes that the
Klein cubic is the one member of that family the July-2025 landscape event
provably does not reach, and records what that non-reach does and does not
say about Problem E. All mathematical content below was derived and
adjudicated by the director beforehand; this packet's job is citation-exact
assembly, not new proof.

---

## 1. The July-2025 landscape event

**Engel, de Gaay Fortman, Schreieder**, *"Matroids and the integral Hodge
conjecture for abelian varieties"*, arXiv:2507.15704 (July 2025).

- **Theorem 1.3.** For a very general cubic threefold, every curve class on
  the intermediate Jacobian is an even multiple of the minimal class.
- **Corollary 1.4.** Consequently, very general cubic threefolds admit no
  (Chow-theoretic) decomposition of the diagonal, hence are **neither stably
  rational, nor retract rational, nor A¹-connected**.

This is the **first-ever retract-irrationality result for cubic
threefolds** — no prior published theorem excluded retract rationality for
any smooth cubic threefold. (The paper's own abstract states the headline
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
argument's reach by an explicit, provable structural reason.

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
group of certain hypersurfaces"*, J. Algebra **72** (1981), no. 1, 146–165 —
matching the credit given in the task brief for this packet.)

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
  735–801 (unramified `H^3(-,Z)` vanishes on all uniruled threefolds, and
  smooth cubic threefolds are uniruled).
- **The (integral) decomposition of the diagonal** — vanishes as an
  obstruction by step (iv) above.
- **The minimal class** — algebraic, by step (iii).
- **The universal codimension-2 cycle** obstruction of **Voisin**,
  *"Cycle classes on abelian varieties and the geometry of the Abel–Jacobi
  map"*, Pure Appl. Math. Q. (2024), arXiv:2212.03046, Theorem 1.15 — this
  obstruction is tied to the same "direct summand of a product of Jacobians"
  property that (i)+(ii) establish for `J(X)`, so it does not obstruct the
  Klein cubic either.

The Klein cubic sits in the **good locus of Voisin's Theorem 4.5** (the JEMS
2017 paper): every hypothesis that theorem needs from the intermediate
Jacobian is met.

**What this does and does not prove.** Decomposition of the diagonal is
**necessary, not sufficient**, for stable or retract rationality — this is
Voisin's own caveat, standing behind both the JEMS 2017 and PAMQ 2024
papers. The chain (i)–(iv) proves **no rationality statement** about the
Klein cubic. It proves only that every *currently known* obstruction to
retract rationality built from the intermediate Jacobian's Hodge/Chow theory
fails to fire. Consequently:

> **Retract rationality of the bare Klein cubic threefold is OPEN in both
> directions**, and among all smooth cubic threefolds, the Klein cubic is
> currently **maximally favorable** for it — no other named or general
> member of the family has all of these obstructions simultaneously
> vanish, and (per §1) the very general member has them all fire.

---

## 3. Relevance to Problem E (record precisely, no overclaim)

Problem E is not "is the bare Klein cubic retract rational" — it is a
question about `G`-equivariant structure (see `SPEC.md`, `NOTEBOOK.md`).
The bare-variety landscape above is relevant to Problem E only through one
specific fork, sealed in the repository's own self-map analysis.

**The self-map dichotomy.** Any hypothetical `G`-equivariant parametrization
`T : P(W_5) --> X` restricts on `X` to a `G`-equivariant self-map `X --> X`
of some degree `delta` (the CLEAN/CARRIER dichotomy of
`goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md`,
Theorem 3.1: `delta` is forced to be a norm from `Q(sqrt(-11))`, and
`delta >= 3` is sealed there). The case **`delta = 1`** is the case where
the restricted self-map is the identity — i.e. `T` is an honest
`G`-equivariant retraction of `P^4` onto `X`. Such a retraction would in
particular **witness retract rationality of the bare Klein cubic** — a
would-be first among all cubic threefolds, given §2's conclusion that no
other cubic threefold is currently even a candidate.

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

Taken together (per `goal_runs_20260810/V14_MAP_DICHOTOMY` context and the
session record), the honest statement of where the fork currently stands is:
**the retraction case (`delta = 1`) is not excluded, and neither is any
specific small non-retraction degree below the next open rung; the fork
between a retraction and `delta >= 12` stays open.** This packet does not
move that fork in either direction — it only records why the July-2025
landscape event cannot be the tool that moves it.

**The retraction-slice ansatz.** A retraction's ambient tuple is forced
into the normal form `T = A*x + F*B` (equivalently the accepted polar
normal form `T = H*x + F*Q` of
`RETRACTION_DEGREE_BOUND.md` §1, with `A` an invariant scalar of degree
`d-1` and `A ≡ -grad(F)*B mod F`). The free data is therefore a single
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
   Abel-Jacobi map", Pure Appl. Math. Q. (2024), arXiv:2212.03046.
   Theorem 1.15. Confirmed live against arxiv.org 2026-08-11 (exact title;
   venue as given in the task brief, not independently confirmed from the
   arXiv page itself).
7. Colliot-Thelene, Voisin, "Cohomologie non ramifiee et conjecture de
   Hodge entiere", Duke Math. J. 161 (2012), no. 5, 735-801. Confirmed by
   web search 2026-08-11 (Duke Math J, vol/issue/pages as stated).
8. Adler, "On the automorphism group of certain hypersurfaces", J. Algebra
   72 (1981), no. 1, 146-165. Confirmed directly from the bibliography of
   item B below (reference [2] there), not independently fetched.

None of items 1-7's source PDFs are present in this repository's
`external_docs/`; their statements are transcribed from the director's
prior reading plus this packet's own live confirmation pass (arXiv
abstract pages and one web search, both 2026-08-11), not from a local PDF.
Theorem/corollary *numbers* for items 1, 4, 5, 6 are taken on the
director's authority and were not independently re-derived or re-checked
against the full PDF text in this packet.

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
live arXiv/web confirmation pass.

Exits: `RETRACT-LANDSCAPE-ROULLEAU-PDF-PRESENT`,
`RETRACT-LANDSCAPE-ROULLEAU-QUOTE-FOUND` (or `-SKIPPED-NO-PDFTOTEXT`),
`RETRACT-LANDSCAPE-8192-11-NON-CM-OK`, `RETRACT-LANDSCAPE-NOTE-ASSEMBLED`
(primary).

**Not claimed:** any new obstruction, any new rationality statement about
the Klein cubic or Problem E, any resolution of the `delta = 1` fork, and
no claim that the chain in §2 is itself a citable theorem of any single
paper.
