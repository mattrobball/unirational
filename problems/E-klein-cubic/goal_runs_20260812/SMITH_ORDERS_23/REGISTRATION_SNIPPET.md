# NOTEBOOK registration snippet — `SMITH_ORDERS_23`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.** No git operation was performed; nothing outside
`goal_runs_20260812/SMITH_ORDERS_23/` was written.

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/SMITH_ORDERS_23/
  entry: E56
  kind: goal_run
  verification_class: exact integer arithmetic; sealed inputs re-read from
    SMITH_I3 / STEIN_LERAY / L12_ORDER11 / STAGE1_COMPLEX_MAPS /
    TERMINUS_STRATA_PW; CRT table and locus dimension counts computed in
    python3 standard library only; 60-check verifier with produce.py replay
  primary_exit: SMITH-O23-CHI0-DOES-NOT-PIN
  superseded_by: null
  char0_scope: |
    Char-0 unconditional, complete arguments in THEOREM.md:
    (a) Reconstruction of the two SMITH_I3-parametric branches, including the
        director-adopted referee S4 widening of the L^X_sigma display to
        chi(q^{-1}(x)) == chi(F_1)+chi(F_2)+n_3+sum_j chi(F_j) (mod 2).
    (b) CRT gap: chi_0 = 35+55k does not determine 2*chi_0 (mod 3).  Both
        Stein-dichotomy branches hit all three residues.  Pinning the order-3
        Smith residue would need chi_0 mod 165.  2*chi_0 is always even, so
        Smith at p=2 is tautological on U in the smooth row.
    (c) Locus: STAGE1 Thm 3 puts two dim-3 rows onto L^X_sigma, so generic
        fibre dimension is 2 and L^X_sigma cap U is empty; chi_0 does not
        bind on the order-2 L-branch.  The two C3-surfaces of Z^{C3} are
        contracted to receiver points, which therefore lie outside U.
    (d) Joint non-implication: STEIN_LERAY's chi_0 == 35 (mod 55) rigidity
        and L12_ORDER11 (all 60 C11-points based, forced depths, genus-0
        dead 0/2674) do not pin the two parametric Smith branches.
    Exact finite computation: the CRT table on k in [-12,12]; re-read of
    n_x = 4 and 5 on Z; census C2 {146,80,11,2} and C3 {62,16,2}; A4 menu
    56644; F_odd(35) = 36252160; 22 cells live.
    NOT claimed: any exclusion, any cut of the 22, any numeric order-2 or
    order-3 congruence, any value of chi(Z^sigma) or chi(Z^{C3}), any
    death of the irrational escape.
  tracked: true
  notes: |
    Director-commissioned closure attempt on the two branches SMITH_I3 left
    parametric, using only the seals that landed after it (STEIN_LERAY,
    L12_ORDER11).

    Headline: Problem E remains OPEN.  This packet EXCLUDES NO DEGREE and
    cuts none of the 22 live d = 35 cells.

    RECONSTRUCTION.  Order 2: E^X_sigma branch closed (== 0 mod 2) on Z and
    on admissible refinements, by Lemma R (rationality + Luroth) against the
    genus-1 curve j = 8192/11; named escape a sigma-fixed irrational stratum
    dominating E^X_sigma, still live (Group G).  L^X_sigma branch parametric
    in the widened display (three forced STAGE1 Thm 3 rows plus unforced
    dominating rows).  F3 at order 2 not closable (11 surfaces + 2
    threefolds unpinned).  Order 3: chi(Z^{C3}) = 94 + chi(S_1) + chi(S_2)
    with chi(S_i) >= 3; six mod-3 congruences parametric in that split.
    Census models are blowups of products, not isomorphism types.

    WHAT THE POST-I3 SEALS DO NOT SPEND.  chi_0 == 35 (mod 55) is a single
    integer on U = {1-dimensional fibres}, smooth row, n_x = 4 and 5 read
    on Z.  It does not determine 2*chi_0 mod 3 (CRT).  It does not bind on
    L^X_sigma or on the C3-surface receivers (those points have fibre
    dimension >= 2).  L12's 60 base points are already the STEIN_LERAY
    pinned points; forced depths move n_x = 4 + Delta/5 and therefore the
    chi_0 residue; the genus-0 death is at C11 and is consistent with the
    dichotomy, not a pin of chi(S_i) or chi(F_i).  PIN and J1 constrain
    invariant divisors on X, not Euler characteristics of source strata.
    L12 itself says orders 2 and 3 are untouched.

    VERDICT.  Order-2 L-branch stays parametric.  Order 3 stays parametric.
    E-branch remains closed as SMITH_I3 left it; the escape stays live.
    The named remainder of SMITH_I3 sec.7.3 is unchanged: closing F3 at
    orders 2 and 3 still needs the per-component models of t2_strata.txt
    promoted to closures, or the wonderful-blowup delta over the 14-orbit
    centre inventory.

    ZERO / ALL-DEAD AUDIT.  Nothing returns a zero or an all-dead outcome:
    22 cells stay live, both Stein branches stay live, both parametric
    Smith branches stay parametric, n_x = 4 and 5 stay positive.  No
    ODDZERO-standard audit is triggered; none is claimed.

    Exits: SMITH-O23-BRANCHES-RECONSTRUCTED, SMITH-O23-CRT-GAP,
    SMITH-O23-LOCUS-L-NOT-IN-U, SMITH-O23-LOCUS-C3-SURFACES-NOT-IN-U,
    SMITH-O23-CHI0-DOES-NOT-PIN, SMITH-O23-L12-NO-ORDER23-PIN,
    SMITH-O23-ORDER2-L-STILL-PARAMETRIC, SMITH-O23-ORDER3-STILL-PARAMETRIC,
    SMITH-O23-ESCAPE-STILL-LIVE, SMITH-O23-NO-DEGREE-EXCLUSION.
    Machine markers: SMITH_ORDERS_23_VERIFY_OK, ALLGREEN (60 checks,
    0 failures, 0 skips; groups A = 16, B = 18, C = 26).
```

## Honesty tiering

| tier | content |
|---|---|
| `[T1]` complete argument here | CRT gap; locus facts; the non-implication that `χ₀ ≡ 35 (mod 55)` and L12 do not pin the two branches |
| `[T2]` machine-verified, exact | sealed-input re-reads; CRT table; 60-check verifier |
| `[T3]` stated with an explicit gap | membership of generic `E^X_σ` in `U`; the value of `Δ` |
| `[EXT]` via sealed packets | Smith theory; miracle flatness; Lüroth |

## Downstream edits this packet implies (for the director, NOT made here)

1. `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.2 / L15: orders 11 and 5
   stay closed; order 2 stays half-closed; order 3 stays parametric. Record
   that the `χ₀` rigidity does *not* spend on L15 at orders 2 and 3.
2. The named remainder of `SMITH_I3` §7.3 is still the live route to closing
   F3 at those orders (promote `t2_strata.txt` models, or run the wonderful
   delta).
3. No headline changes anywhere: this packet, like the packets it consumes,
   excludes no degree.
