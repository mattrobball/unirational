# NOTEBOOK registration snippet — `STAGE1_TIGHTEN`

Paste into the repository manifest.

```yaml
- path: problems/E-klein-cubic/goal_runs_20260811/STAGE1_TIGHTEN/
  entry: E56
  kind: goal_run
  verification_class: two-engine (exact finite-group character arithmetic in
    mu_6 + F_p linear algebra at two split primes 331, 661), cross-checked
    against the sealed STAGE1 Layer-3 exact Z[zeta_6] table
  primary_exit: STAGE1-TIGHTEN-SATURATION-THEOREM
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: Proposition 0.1 (the full-flag dichotomy -- exactly two
    of the 15 sweep rows have slots exhausting W, so psi = 1 is forced only
    there); Theorem S(a) periodicity, S(b) propagation (the Gamma-invariance of
    prod_{gamma} gamma.ell is formal), S(c) monotone contribution; Proposition
    2.1 (the D10 row splits 13 + 10 by the tau-weight).
    Two-prime finite exact computation: g_r | 6 for all 27 slots; the up-set
    property and the threshold Theta = 6; the residue table K(0) = 10752,
    K(2) = K(4) = 672; the 3-usable-classes-per-residue count; the character
    rule against explicit evaluation (1176 cases, 0 failures).
    NOT char 0 and NOT claimed: the odd-residue zeros (THEOREM.md sec. 2.5).
  tracked: true
  notes: |
    Two deliverables on top of STAGE1_COMPLEX_MAPS (PR #32) and
    STAGE2_ODD_ORDER_PINNING.

    Headline: Problem E remains OPEN.  NO DEGREE IS EXCLUDED by this packet.

    (1) SATURATION THEOREM (discharges STAGE1 sec. 15.6(1)).  Theorem S: the
    value of a component is periodic in the multidegree mod 6; multiplication by
    the Gamma-invariant form prod_{gamma in Gamma}(gamma.ell_r)^{6/g_r} of
    multidegree 6.e_r, which does not vanish at any child (minimal invariant
    degree g_r divides 6 for every slot of every sweep row -- computed),
    propagates both non-vanishing of the module and non-degeneracy of the
    evaluation; hence contributions decrease along +6e_r and the image is the
    union over the coordinatewise-minimal realized multidegrees.  Those all have
    coordinates <= 6, so THETA = 6: the image over ALL multidegrees equals the
    image over the box a_r <= 6.  Corollary: STAGE1's stratum-coherent count
    1088847395778723840000 is the ALL-multidegree count, not a bounded-degree
    approximation, and its empirical stability at maxdeg 3-6 is explained.  No
    obstruction to saturation exists.

    (2) RESIDUE-INDEXED COUNT.  A correction first: STAGE2 Lemma 0.1 (G perfect,
    so T is exactly G-invariant) does NOT license forcing psi = 1 on every sweep
    row -- psi absorbs the degrees transverse to the stratum, and the slots
    exhaust W for exactly two rows, the dimension-3 divisors D_{P_sigma} and
    D_{L^-_sigma} (Proposition 0.1).  Those two are precisely where the covariant
    degree enters the order-0 sigma-band.  With psi = 1 and sum_r a_r = d there
    the sealed parities fall out (m odd on D_{P_sigma} = H0-1; ord_{L_sigma}(T)
    = d+1 mod 2 = STAGE2 Prop 1.4(ii)), and the sigma-band factor becomes

        K(d mod 6) = 10752  (d = 0),  672  (d = 2, 4).

    Degree-blind STAGE1 had K = 43008, so knowing d mod 6 divides the sigma-band
    freedom by 4 or 64.  Combined with STAGE2's odd-order collapse (3^8) and the
    new D10-row split (23 -> 13 or 10 by the tau-weight parity of the value):

        count(d) = K(d mod 6) . D10 . 3^8,   D10 in {13, 10}
        d = 0 mod 6: 917070336   (L-branch 705438720)
        d = 2 mod 6:  57316896   (L-branch  44089920)
        d = 4 mod 6:  57316896   (L-branch  44089920)

    against STAGE1 x STAGE2 degree-blind = 43008 . 23 . 3^8 = 6490036224.  The
    refinements from d mod 3, 5, 11 are already inside the 3^8 (STAGE2 sec. 4);
    the residue dependence of the total is carried entirely by d mod 6, so the
    mod-330 table has three non-trivial rows.

    FLAGGED, NOT CLAIMED: the enumeration returns 0 for d = 1, 3, 5 mod 6, which
    at face value would exclude every odd degree at order 0.  It is reproduced at
    both primes, each degree constraint alone is consistent at every residue (the
    zero is a joint effect through the eight V4-stabilised C2-rows), and the
    model is verified against the sealed Layer-3 module and the two sealed
    parities -- but d = 25 (odd) was a live window until an independent slice
    sweep killed it, and STAGE2 Theorem 4.1 points the other way.  THEOREM.md
    sec. 2.5 states the four audit targets and the recommended independent
    rebuild.  Nothing is asserted.

    Exits: STAGE1-TIGHTEN-SATURATION-THEOREM, STAGE1-TIGHTEN-THRESHOLD-SIX,
    STAGE1-TIGHTEN-FULL-FLAG-DICHOTOMY, STAGE1-TIGHTEN-RESIDUE-TABLE,
    STAGE1-TIGHTEN-D10-ROW-SPLIT,
    STAGE1-TIGHTEN-NO-DEGREE-EXCLUSION-CLAIMED.
    Machine markers: STAGE1_TIGHTEN_VERIFY_OK, ALLGREEN.
```
