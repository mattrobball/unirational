# NOTEBOOK registration snippet — `ODDZERO_AUDIT`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260811/ODDZERO_AUDIT/
  entry: E56
  kind: goal_run
  verification_class: independent rebuild (interleaved-flag census + explicit
    polynomial linear algebra in sigma-adapted coordinates) at two split primes
    331, 661; no STAGE1 / STAGE1_TIGHTEN code imported, only the shared raw
    660-matrix group model psl211.py
  primary_exit: ODDZERO-AUDIT-VERDICT-ARTIFACT
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: Proposition A (the full-flag dichotomy, re-derived --
    the slots exhaust W exactly on the two dimension-3 divisor rows, so psi = 1
    and sum a_r = d are forced there and nowhere else); the observation that
    STAGE1_TIGHTEN's psi model on the other 13 rows is a RELAXATION and so
    cannot manufacture a zero; Proposition B(ii) (W^-_sigma is D12-irreducible,
    hence every non-zero equivariant multiform is a dominant sweep); B(iii) (the
    k-th term of the expansion has Lambda-character chi_B^{a+k} mu_1, a
    two-line character computation); B(iv) (the exponent bookkeeping on the
    wonderful model: the order pair is (m+1, m) and the plus half cannot
    interfere).
    Two-prime finite exact computation: the independent census (940/220/55,
    4901 flags, 11076 components, 80 rows, row multiset EQUAL to the sealed
    TERMINUS_STRATA_PW census); 54 / 18 children of the two divisors; N(d,m)
    and the H0-1 parity for d <= 12; STAGE2 Prop 1.4(ii); Thm 15.1 rigidity;
    the odd/even clash tables; dim V0 = N(d,m) - 2 and the escape witnesses.
    NOT claimed: any corrected count.
  tracked: true
  notes: |
    Adversarial audit, director-commissioned, of the UNCLAIMED odd-residue zero
    of STAGE1_TIGHTEN (THEOREM.md sec. 2.5): its residue-indexed enumeration
    returns K = 0 for every odd d mod 6, which at face value would exclude every
    odd degree at order 0.

    VERDICT: ODD-ZERO-ARTIFACT.  The zero is not an exclusion.  The packet's
    author was right to withhold the claim.

    Headline: Problem E remains OPEN.  NO DEGREE IS EXCLUDED and none is shown
    to survive.  The first open window STAYS at d = 35; it does not move to 36.

    WHAT IS SOUND.  The model of the two dimension-3 divisor rows is correct and
    is re-derived here from scratch in sigma-adapted coordinates (u0,u1,u2 on
    W^+, v0,v1 on W^-), with a direct equivariance test on every computed
    section.  It reproduces the sealed anchors: H0-1 (m odd), the Layer-3 table
    N(d,m) for d <= 12 including N(12,3) = 73, and STAGE2 Prop 1.4(ii)
    (ord_{L_sigma}(T) = d+1 mod 2) as module non-vanishing.  The census is
    rebuilt independently as interleaved flags and matches the sealed
    TERMINUS_STRATA_PW row multiset exactly, as do STAGE1 sec. 15.2's child
    counts 54 and 18.  The psi question (audit item 2) is settled in the
    packet's favour and then some: on the 13 non-full-flag rows the truth is
    NARROWER than the model (the achievable psi at degree d is
    {prod chi_i^{b_i} : sum b_i = d - sum a}), so that model is a relaxation and
    an error there could only over-count -- it cannot make a zero.

    THE MECHANISM, REPRODUCED.  No minus-line lies in any plus-plane, so the two
    divisor rows share no child; the coupling is two-step and local to the
    exceptional divisor over a type-I V4 point [B] of the plus-plane.  For the
    six V4-components there, closure alone pins the value to L_z cap L_r (a
    single type-I vertex), while the class (d-m, m), m odd, psi = 1 evaluates
    them to the eigenline of chi_B^{d-m} mu_1 -- the required vertex when d is
    even, the FORBIDDEN one when d is odd, since d - m = d - 1 mod 2.  Verified
    against explicit sections: 0 agreements / 120 clashes at odd d, 90
    agreements / 0 clashes at even d, both primes.

    THE ERROR (precise).  s3residue.py:55 drops a class whose contribution
    leaves a child's arc-consistent domain -- legitimate.  The unsound step is
    how contribution decides DEGENERACY: s3sat.py:72-78 takes rk == 0 from
    s3sweep.py:271-276, where rk is the rank of the evaluation of a BASIS OF THE
    WHOLE MODULE.  That reports "the whole module vanishes at q".  Theorem
    15.1's second branch ("or s(q) = 0, in which case phi is undefined along R")
    is a property of the INDIVIDUAL SECTION; {s : s(q) = 0} is a codimension-1
    subspace inside the same connected component of the moduli.  The identical
    test is upstream at STAGE1_COMPLEX_MAPS/scripts/s1coherence.py:293-296.

    THE REFUTATION.  V0 = {f in V((d-m,m),1) : f vanishes at all six attaching
    points} has codimension EXACTLY 2, so dim V0 = N(d,m) - 2 >= 1 whenever
    N(d,m) >= 3 (e.g. 366 at d = 25, 418 at d = 35).  Every non-zero f in V0 is
    still a dominant sweep, because W^-_sigma is D12-irreducible and so has no
    Gamma-stable line.  For such an f the stratum's value is the t^1 coefficient
    of f(B + t.alpha, D), whose Lambda-character is chi_B^{a+1} mu_1 =
    chi_B.mu_1 = the OTHER vertex -- exactly the one closure demands at odd d.
    The wonderful-model exponent bookkeeping confirms this is genuinely the
    leading datum of T (order pair (m+1, m); the plus half sits at j >= m+1 and
    cannot contribute).  Machine witnesses for every odd d in [3,11] at both
    primes, and the escape section changes no other child's value.

    COLLATERAL.  The same line governs STAGE1 sec. 15.2's "38 of the 48
    computed components of M_{D_{P_sigma}} evaluate some child outside its
    arc-consistent domain".  So STAGE1's stratum-coherent count
    1088847395778723840000 is a LOWER BOUND, not the count, and the 64 = 2^6
    cut against arc consistency is an upper bound on the true cut.  No corrected
    number is offered here; the repair is to stratify the degeneracy test by
    order of vanishing at pi(F_R).

    CONSISTENCY PROBES, all clean.  (a) No sealed object induces a coherent
    order-0 section at odd d: T5's Q_{B,ell} is local (its own gate says the
    formalism cannot close E on local data) and FIX-D2's (7;1,1,1) / (6;3,3,3)
    survivors are jet-level at c_sigma.  (b) STAGE2 Thm 4.1 ranges over the
    odd-order rows plus the single-involution C6 layer and explicitly defers the
    V4 band -- no theorem-level conflict either way.  (c) FIX-P1 killed d = 25
    by a dimension collapse of the forced-profile slice (189 -> 59 -> 3 -> 0),
    exhibiting no order-0 section at all, so there is no conflict in either
    direction.  (d) D34_GUIDED_SWEEP closes d = 34 through (M) = Prop 1.4(i) and
    (E) = Prop 1.6; it quotes N(34,1) = 397 only as background and states the
    bite does not come from the sweep datum -- d = 34 neither depends on the
    odd-zero mechanism nor conflicts with this audit.

    Exits: ODDZERO-AUDIT-VERDICT-ARTIFACT,
    ODDZERO-AUDIT-MECHANISM-REPRODUCED,
    ODDZERO-AUDIT-DEGENERACY-SEMANTICS-ERROR,
    ODDZERO-AUDIT-ESCAPE-WITNESS, ODDZERO-AUDIT-PSI-MODEL-SOUND,
    ODDZERO-AUDIT-ANCHORS-REPRODUCED, ODDZERO-AUDIT-NO-DEGREE-EXCLUSION,
    ODDZERO-AUDIT-STAGE1-COHERENCE-UNDERCOUNTS.
    Machine markers: ODDZERO_AUDIT_VERIFY_OK, ALLGREEN (52 checks, 0 failures).
```

## Downstream edits this audit implies (for the director, NOT made here)

1. `STAGE1_TIGHTEN` §2.5 should record the verdict and the located error; its
   §2.2/§2.4 tables should mark the odd rows "not determined" rather than `0`,
   and the even rows as lower bounds.
2. `STAGE1_COMPLEX_MAPS` §15.2/§15.3 should carry the same caveat: the
   stratum-coherent total and the `2⁶` cut are bounds until the degeneracy test
   is stratified by order of vanishing.
3. Neither packet's headline changes: both already claim no degree exclusion.
