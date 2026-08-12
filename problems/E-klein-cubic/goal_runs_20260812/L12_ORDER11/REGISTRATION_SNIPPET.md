# NOTEBOOK registration snippet — `L12_ORDER11`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/L12_ORDER11/
  entry: E56
  kind: goal_run
  verification_class: exact Q(zeta_11) arithmetic on the power basis of Phi_11
    (Fraction coefficients, no floating point, python3 stdlib only); every
    localization term recomputed from scratch, including the characteristic-
    class term of positive-dimensional fixed components; the Sym^k W*
    characters reimplemented independently of molien_director.py in its own
    conventions; the sealed C11 value menu of vectors_d35.json re-derived from
    STAGE2 Thm 1.2 and matched entry-for-entry; STAGE2 Thm 2.1 and SMITH_I3
    Lemma U(b) independently reproduced
  primary_exit: L12-O11-GENUS0-DEAD-DEPTH-LE-3
  superseded_by: null
  char0_scope: |
    Char-0 unconditional, exact: the convention audit of the ledger's Sec.8
    (FLAG-A: numerator zeta^{-k a_j} and denominator prod(1-zeta^{a_k'-a_j})
    are not a consistent Atiyah-Bott pair; the two consistent completions are
    Galois conjugate, so verdicts are convention-independent); the ordering
    a = (1,9,4,3,5) forced by F-invariance; the fatal anchors (untwisted total
    1 on P^4 and after arbitrary test towers, twisted totals = chi_{Sym^k W*}(g)
    for k = 0..6 on P^4 and the genus-0 right sides on X); the local blowup
    mass identity including 682 positive-dimensional components; the complete
    mod-pi content of the k = 0 sum rule (necessary AND sufficient residue
    criterion, with explicit lifts) and its vacuity on the Smith configuration;
    the proved chi-to-trace congruence chi_g(Y,O) = chi(O_Y) mod (1-zeta);
    the genus-free integrality test tr_j = D^X_j M(a_j) in Z[zeta]; the death
    of the mu = 0 branch in EVERY quadratic-residue degree class; the forced
    blowup depth >= 3 (>= 4 for mu1 in {6,9}, >= 5 for mu1 = 7); the exact
    unbounded fibre-trace menu criterion; the depth-2 counterexample to
    SMITH_I3 Lemma U(a)'s induction (repeated tangent weight (2,6,1,2)).
    Finite exhaustive computation: all 1540 towers of total blowup depth <= 3
    at d = 35 over all 10 C11 menu entries -- 0 pass the genus-0 test, 118 pass
    integrality, 0 pass the C7 fibre-trace menu.
    NOT claimed: any degree exclusion; any all-depth genus-0 death (the
    leading-order mod-pi obstruction is PROVED to saturate F_11 at depth >= 4);
    any outright death of a cell at order 11; anything about the genus-1 or
    genus->=2 branches of C14; anything at orders 5, 3, 2, 6.
  tracked: true
  notes: |
    Lane 3 of DATA_SPEC_PIPELINE_FLUSH_20260812.md. First machine
    instantiation of the L12 global localization identity family.

    Headline: Problem E remains OPEN; this packet excludes no degree.
    The first open window stays at d = 35.

    RESULT 1 (the commissioned deliverable). At d = 35 the genus-0 branch of
    the C14 trichotomy is DEAD at order 11 for every one of the 10 C11 menu
    entries -- hence for every one of the 22 canonical cells, constancy
    VERIFIED (the cells are sigma-band/order-2 data and carry no order-11
    content) -- among towers of total blowup depth <= 3, which is the complete
    menu at that depth (1540 towers). Map level: this kills that branch for
    those patterns at their own degree class d = d_min = 35. Scope stated:
    depth <= 3; the all-depth version does NOT close, and the reason is proved
    rather than guessed.

    RESULT 2 (unasked, class-wide, genus-free). The identity forces the fibre
    traces tr_j = D^X_j M(a_j) to be algebraic integers. In every
    quadratic-residue degree class d = 1,3,4,5,9 (mod 11) the branch "mu = 0 at
    the C11-points" gives v_pi(tr_j) = -1 at all five points, so that branch is
    dead in every QR class, with no genus hypothesis. The same integrality
    forces the resolution over every C11-point to have blowup depth >= 3,
    strictly more than STAGE2's depth >= 2.

    RESULT 3 (k = 0 sum rule, Sec.8.4). Evaluated. CONSISTENT: its complete
    mod-pi content is one F_11 condition on the residues of the fibre traces,
    and constant residue vectors always satisfy it because sum_j 1/D_j = 1.
    So on the Smith configuration (five fibre chi's equal) the sum rule is
    vacuous; all of its content is on the differences tr_j - tr_j'. The
    strengthening "the five traces are EQUAL in Z[zeta]" would force tr_j = 1
    and clash with a coherent reading of the sealed "= 4 mod 11" -- recorded at
    TIER C, not claimed, because the sealed 4 is n_x / chi_top.

    TWO CORRECTIONS TO THE SEALED RECORD, both with explicit witnesses.
    (a) FLAG-A: the ledger's Sec.8 numerator/denominator pairing is
    inconsistent; the fix is a single sign and the verdicts are unaffected.
    (b) FLAG-T: SMITH_I3 Lemma U(a)'s induction ("pairwise distinct weights at
    every stage") is false from depth 2 on -- over e_0 in the e_3 direction the
    level-1 tangent multiset is (2,6,1,2) and the next blowup has a fixed P^1.
    Lemma U(b) is untouched and is independently REPRODUCED here (n_x came out
    equal at all five receiver points in every one of the 1540 towers).

    NO ODDZERO-STANDARD AUDIT IS TRIGGERED: the outcome is not an all-22 death.
    118 of the 1540 towers survive the genus-free integrality test, so the L12
    identity does not kill the C11 class.
```
