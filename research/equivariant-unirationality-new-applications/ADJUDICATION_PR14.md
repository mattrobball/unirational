# Adjudication of PR #14 (`agent/double-quadrics-cubic-bundle-family`)

Adjudicated against the artifacts on this branch, with every mathematical
link rechecked independently. Verdict codes: `CONFIRMED`,
`FIXED-IN-PLACE`, `REFUTED`.

Corrective commits on `main` that must not be regressed — `dd68f08`,
`bb62f5f`, `c92b994` — were checked against every changed file. None is
regressed. The withdrawn assertion ("every fixed stratum on every model
remains RCC") is not reintroduced anywhere; the only occurrence of that
phrase on the branch is the sentence in `STATUS.md` that explicitly
disclaims it.

## A. Cubic-surface-bundle theorem

| # | claim | verdict |
|---|---|---|
| A1 | `Phi` of (1.5) is exactly `G_n`-invariant: `A0`, `A1` are literally `D_{2n}`-invariant, `D_{2n}` acts trivially on `(U,V,X,Y)`, and every monomial of (1.5) has `z`-weight zero | `CONFIRMED` |
| A2 | the action of `G_n=C3 x D_{2n}` is faithful and generically free, and `r` has order `n` on the base because `n` is odd | `CONFIRMED` |
| A3 | the linear system `{A0 F0 + A1 F1}` has base locus exactly `Z={X=Y=0}`, so Bertini gives smoothness off `Z` | `CONFIRMED` |
| A4 | the derivative identities (3.2)--(3.3) on `Z`, and the three-case argument using squarefreeness of `S^{2n}+T^{2n}` | `CONFIRMED` (all five identities now machine-checked symbolically) |
| A5 | the three sections `[S:T] -> ([S:T],[1:-rho:0:0])`, `rho^3=1`, lie on `X` | `CONFIRMED` (checked against the full `Phi`, not only `U^3+V^3`) |
| A6 | Kollár's theorem applies to the smooth generic cubic-surface fiber with a rational point, giving ordinary unirationality of the total space | `CONFIRMED` |
| A7 | the `z`-fixed locus in `P^3` is `P(X,Y)` plus `[1:0:0:0]` and `[0:1:0:0]` | `CONFIRMED` |
| A8 | `X^z = C` (bidegree `(2n,3)`) `+ P_U + P_V` with `|P_U|=|P_V|=2n` | `CONFIRMED` (the restrictions `Phi|_{U=V=0}=A0F0+A1F1`, `Phi|_{V=X=Y=0}=A0U^3`, `Phi|_{U=X=Y=0}=A0V^3` are now machine-checked) |
| A9 | `C` is smooth for generic `(F0,F1)` and `g(C)=(2n-1)(3-1)=4n-2 >= 10`, so `C` carries no rational curve | `CONFIRMED` (also implied by smoothness of `X`; noted in Section 3) |
| A10 | `X^{G_n}=empty`, because `r` fixes only `0,infinity` on the base and `s` interchanges them | `CONFIRMED` |
| A11 | Condition (A): abelian subgroups of `D_{2n}` are cyclic for odd `n`; the reflection-containing case `C3 x <s>` really is handled | `FIXED-IN-PLACE` |
| A12 | `Pic(X)=Z^2` by Grothendieck--Lefschetz | `FIXED-IN-PLACE` |
| A13 | both `O(1,0)` and `O(0,1)` admit genuine `G_n`-linearizations | `CONFIRMED` (the two lifting representations are now displayed) |
| A14 | Scavia--Tschinkel--Zhang give `Am^m(X,G_n)=0` for all `m>=2` | `CONFIRMED` |
| A15 | the obstruction step invokes the accepted single-carrier central theorem of `GENERALIZATIONS.md` | `FIXED-IN-PLACE` |

### Notes on the fixes

**A11.** The original text asserted "the dihedral group acts trivially on the
fiber coordinates" only in passing. That statement is *true* — it is part of
the definition (1.1)--(1.3), and the reflections therefore act trivially on
`(U,V,X,Y)` — so the conclusion was never in doubt, but the proof did not
display it where it is used. Section 7 now states `A subseteq C3 x B`,
exhibits the fixed base point of an arbitrary reflection `h=s r^k` explicitly
(`u = +/- epsilon^{-k}` on `u=S/T`, which is `[1:1]` and `[1:-1]` for `h=s`),
and then says explicitly why the chosen curve point is fixed by the
reflection and by `z`.

**A12.** `P^1 x P^3` has dimension exactly four, which is the threshold in
the Grothendieck--Lefschetz theorem for Picard groups of ample divisors. The
original text cited the theorem without noting that the hypothesis is met
only marginally. The dimension is now stated.

**A15.** Section 8 quoted the right theorem but verified the hypotheses
loosely ("every positive-dimensional component ... is a curve of genus
`4n-2`"). It now checks Hypotheses 1 and 2 of the central form separately and
in the theorem's own words.

### Verdict

The cubic-surface-bundle theorem is **sound as stated**. No claim was
trimmed or refuted.

## B. Double-quadric audit

| # | claim | verdict |
|---|---|---|
| B1 | screening lemma: `(T_pQ)^H=0` at an isolated fixed point, semisimplicity forbids a trivial quotient of `T_pQ`, hence `ds_p=0` and `B` is singular at `p` | `CONFIRMED` |
| B2 | on the Fermat quadric threefold with `c=(0123)`, the fixed locus is four isolated points: two on `P(+1-eigenspace) cap Q` (`4a^2+b^2=0`), plus the `i`- and `-i`-eigenlines; the `-1`-eigenline has `q`-value `4` and is not on `Q` | `CONFIRMED` |
| B3 | `O_Q(4)` has trivial fiber character at every fixed point, since every eigenvalue is a fourth root of unity | `CONFIRMED` |
| B4 | every smooth `c`-invariant quartic branch misses all four points, so `X^{<c,tau>}=empty` and Condition (A) fails for `C4 x C2deck` | `CONFIRMED` **for a genuinely invariant section**; sharpened, see below |
| B5 | covers branched over a quadric are `ALREADY-DECIDED` | `CONFIRMED` |

**B4 sharpening.** The branch already carried a one-sentence caveat that a
semi-invariant section "must be checked separately". That caveat is correct
and load-bearing, so the boundary is now made exact rather than left as a
warning. The `c`-characters of `T_pQ` are computed and recorded:
`{-1,i,-i}` at the two `+1`-eigenspace points and `{i,-i}` (with a
multiplicity) at each of the `i`- and `-i`-eigenlines. The trivial character
is absent at all four points — that is precisely the screening lemma — but
`chi = i, -i` occurs everywhere and `chi = -1` occurs at two points, so a
smooth semi-invariant branch divisor with such a character is *not* excluded
by this argument. A second remark records that a character of order four
would force the lift of `c` to have order eight, changing the abelian
subgroup under test. The `chi != 1` cases are recorded as open.

**B5 citation check.** `SOURCES_CUBIC_AND_DOUBLE_QUADRICS.md` attributes to
Cheltsov--Tschinkel--Zhang, *Equivariant unirationality of Fano threefolds*
(arXiv:2502.19598), the statement that a generically free action on a smooth
quadric threefold is stably linearizable exactly when Condition (A) holds.
The paper's Theorem 4.1 reads: "Let `X subset P^4` be a smooth quadric
threefold, with a generically free action of a finite group `G`. Then the
`G`-action is stably linearizable if and only if it satisfies Condition (A)."
The citation is exact. A double cover of `P^3` branched over a smooth quadric
is the quadric threefold `w^2=q_2` in `P^4`, so the `ALREADY-DECIDED` label is
correct.

## C. Verifier replay and load-bearing content

Both new scripts replay with the expected markers. Both used exact
arithmetic already, but each contained assertions that were true by
construction rather than by computation, so both were strengthened:

- `verify_cubic_surface_bundle_family.py` now builds `Phi` symbolically with
  generic binary-cubic coefficients and checks `r`-, `s`- and `z`-invariance,
  bidegree, the three `z`-fixed-locus restrictions, all five base-locus
  derivative identities, `res(A0,A1) != 0`, and the sections against the full
  equation. The previous `assert len([0,1,2]) == 3` placeholder is gone.
- `verify_double_quadric_c4_screen.py` now constructs the permutation matrix,
  checks its order, checks that it preserves the Fermat form, computes its
  eigenvalues exactly, verifies each eigenline as an eigenline, derives
  `4a^2+b^2` by evaluating the form rather than asserting it, and computes
  the tangent characters at all four fixed points. `REPLAY.md` had claimed
  the script "checks the exact eigenspace decomposition"; before this change
  it did not, and now it does.

## D. Packet-consistency findings

| # | finding | verdict |
|---|---|---|
| D1 | `TOP5.md`, `LITERATURE_SURVEY.md`, `QUESTIONS_ANSWERED.md` reintroduce no withdrawn claim, regress no corrective commit, and drop no literature-status hedge | `CONFIRMED` |
| D2 | numeric consistency of `4n-2`, `4n`, `(2n,3)`, `C3 x D_{2n}` across `STATUS.md`, `TOP5.md`, `CANDIDATE_TABLE.md`, `QUESTIONS_ANSWERED.md`, and the theorem file | `CONFIRMED` |
| D3 | `TOP5.md` silently dropped `main`'s proof that `V22^{PSL2(F7)}` is empty (the length-six-orbit/Lagrange argument) | `FIXED-IN-PLACE` — restored |
| D4 | `STATUS.md` dropped the expected markers of the two round-one verifiers and the `verification_output.txt` pointer | `FIXED-IN-PLACE` — restored, and the double-quadric marker added |
| D5 | `CANDIDATE_TABLE.md` listed score 52 above score 55 | `FIXED-IN-PLACE` — rows swapped |
| D6 | `SOURCES.md` (inherited from `main`) gave arXiv:2605.02763 the title *Cohomological invariants from the equivariant universal torsor*; the real title is *Birational invariance of higher Amitsur groups*, which is also the title used elsewhere in this repository and on this branch | `FIXED-IN-PLACE` — corrected in `SOURCES.md` |

## E. Merge readiness

Nothing on this branch is refuted. The cubic-surface-bundle theorem and the
double-quadric audit both stand, with the double-quadric rejection now
scoped exactly to the invariant-section model. All fixes are contained in
this packet directory.
