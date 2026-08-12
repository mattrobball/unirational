# NOTEBOOK registration snippet — `BURNSIDE_ASSESS`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.** No git operation was performed; nothing outside
`goal_runs_20260812/BURNSIDE_ASSESS/` was written.

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/BURNSIDE_ASSESS/
  entry: E56
  kind: goal_run
  verification_class: literature assessment plus exact integer arithmetic on
    sealed character weights (C11 T-weights, C5 regular residues, C6 character
    set); no group reconstruction; sealed RECEIVER_LEDGER_X and FIX-B payloads
    re-read, not rebuilt; python3 standard library only
  primary_exit: BURNSIDE-ASSESS-ORTHOGONAL-NO-NEW-OBSTRUCTION
  superseded_by: null
  char0_scope: |
    Char-0 unconditional, in THEOREM.md:
    (a) Kresch--Tschinkel Burn_n(G) is a G-birational invariant
        (arXiv:2007.12538 Thm 5.1, read). It has no stated variance under a
        dominant non-birational G-map. Problem E is a dominance question.
    (b) [X] lives in Burn_3(G) and [P(W)] lives in Burn_4(G); comparison is
        a type error. Equality against [P(U)] for dim U = 4 is linearizability,
        already false.
    (c) Condition (A) holds (sealed receiver). Am^2 = Am^3 = 0 for every
        subgroup because O_X(1) is linearized and Pic(X) = Z (Lefschetz).
        Tschinkel--Zhang Am^3 examples need Q8, which G does not contain.
    (d) Cheltsov--Tschinkel--Zhang arXiv:2502.19598 Thm 5.1 (read) lists this
        action as an open exception to G-unirationality of smooth cubics.
    (e) Specialization (Kontsevich--Tschinkel; the equivariant Burnside volume)
        specializes birationality, not dominance, and the Klein cubic is rigid.
    (f) Naive X-side symbols assembled from the sealed character
        decompositions; Assumption 2 fails on E_sigma and on type-II V4
        points; the reduced Burn_3 class is NOT computed.
    NOT claimed: any exclusion, any degree cut, the reduced Burnside class
    of X, a reopening of E44.
  tracked: true
  notes: |
    Director-commissioned assessment of the equivariant Burnside group
    (Kresch--Tschinkel) and the related Hassett / Kontsevich / Tschinkel /
    Pirutka specialization toolkit, against Problem E.

    Headline OPEN; this packet excludes no degree.

    WHAT IS SOUND.  Burnside obstructs G-birationality / G-linearizability /
    specialization of birational type.  It does not obstruct a dominant
    G-map.  The dominance-capable cousins (Condition (A), Amitsur, torsor)
    vanish.  CTZ leave this action open.  The X-side naive symbols and the
    C5 split (absent on P(W)) are assembled from the sealed ledger; the
    C11/C5/C6 weight cuts are replayed exactly.

    PRIOR STATE.  E44 REJECTED (wrong implication); DELTA1 "no retraction
    variance"; FIX-B computed the P(W) shadow.  This packet is the 2025-26
    literature pass and the X-side assembly.  It does not reopen E44.

    VERDICT.  Orthogonal / inapplicable as a new obstruction.  The
    complex-of-groups / b-complex program already keeps a strictly finer
    object with dominant-map functoriality.

    Exits:
      BURNSIDE-ASSESS-SCOPE-BIRATIONAL-NOT-DOMINANT
      BURNSIDE-ASSESS-DIMENSION-MISMATCH
      BURNSIDE-ASSESS-X-SYMBOLS-ASSEMBLED
      BURNSIDE-ASSESS-ASSUMPTION2-GAPS-FLAGGED
      BURNSIDE-ASSESS-AMITSUR-AND-A-VANISH
      BURNSIDE-ASSESS-SPECIALIZATION-NO-FAMILY
      BURNSIDE-ASSESS-CTZ-LISTS-THIS-ACTION-OPEN
      BURNSIDE-ASSESS-PRIOR-E44-CONSISTENT
      BURNSIDE-ASSESS-ORTHOGONAL-NO-NEW-OBSTRUCTION
      BURNSIDE-ASSESS-NO-DEGREE-EXCLUSION
    Machine markers: ASSEMBLE_BURNSIDE_OK, BURNSIDE_ASSESS_VERIFY_OK, ALLGREEN
```

## Honesty tiering

| tier | content |
|---|---|
| `[T1]` | Burnside variance is birational only; CTZ open list; Amitsur vanishing; C2/C3/V4 weights; no dominance functoriality in the papers read |
| `[T2]` | ledger re-read; C5/C6/C11 cuts; FIX-B present; dim+\|β\|=3; zero/all-dead |
| `[T3]` | no hidden Burnside relation creates a dominance obstruction; HPT role inferred |
| `[EXT]` | uniqueness of the Klein cubic; B0(G)=0; Clemens–Griffiths; superrigidity |

## Downstream edits this packet implies (for the director, NOT made here)

None. E44 stays REJECTED.
