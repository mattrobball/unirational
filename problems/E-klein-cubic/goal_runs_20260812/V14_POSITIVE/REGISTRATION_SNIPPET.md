# NOTEBOOK registration snippet — `V14_POSITIVE`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/V14_POSITIVE/
  entry: E56
  kind: goal_run
  verification_class: exact ATLAS L2(11) character arithmetic (Newton
    identities in Q, same projective-order collapse as
    V14MAP_DEGREE345_REPLAY) plus two-prime Weil traces at p=23,67
    (SL(2,11) closure 1320, 10' projector); sealed-packet marker ledger
    only, no landing run
  primary_exit: V14-POSITIVE-COMPOSITION-DOES-NOT-SETTLE-HEADLINE
  superseded_by: null
  char0_scope: |
    Char-0 unconditional (logical, citing sealed packets): SPEC defines
    G-unirationality as a dominant G-equivariant map from a linear
    G-representation; FIX_IX_SEAL + Cor IX.1 kill every such map into V14;
    V14_MAP_DICHOTOMY Theorem B gives a nonconstant G-map Phi: V14 --> X
    whose dominance is not claimed; Cheltsov-Shramov Thm A.5 / Cor A.7
    kill G-birational Phi; therefore Phi plus any known parameterization
    of V14 cannot produce a linear G-source map to X.
    Exact characters, no prime: dim Hom_G(Sym^d M*, A) =
    0,0,1,2,7,18,43,94,198 for d=0..8 (d<=5 matches the sealed table).
    Two-prime traces (p=23,67, identical): Hom_SL(Sym^d U*, M) =
    0,0,0,0,3,0,6 for d=0..6, so the first possible spin map P(U)-->P(M)
    is degree 4, dimension 3; Hom_G(Sym^d five*, M) = 0,0,1,1,2,3,5.
    NOT claimed: any exclusion; dominance of Phi; any explicit Phi;
    emptiness of the d=6 landing or the d=4 spin landing.
  tracked: true
  notes: |
    Positive-side reconstruction. Headline: Problem E remains OPEN; this
    packet excludes no degree.

    THEOREM. The sealed Phi: V14 --> X is nonconstant and G-equivariant,
    not known to be dominant, and any explicit linear system has degree
    >= 6. V14 is irrational and unirational as a variety (Prokhorov Rem
    2.10 / Cheltsov-Shramov Rem A.4 + Clemens-Griffiths + Kollar),
    G-birationally superrigid (Cheltsov-Shramov A.5), and not linearly
    G-unirational (IX.1). Composing Phi with a linear parameterization
    P(W') --> V14 would settle the headline, but that parameterization
    is sealed impossible. Classical parameterizations are not
    G-equivariant. A spin parameterization P(U) --> V14 is open and,
    even with dominant Phi, would prove only spin-unirationality of X.

    Smallest remaining computations, not run: (i) degree-6 landing of
    the 43-space C_6(A) on the Klein cubic, by the V14MAP_DEGREE345
    protocol; (ii) degree-4 landing of the 3-space Hom_SL(Sym^4 U*, M)
    on the Plucker ideal, with the 66 SCHUR_V14 base lines. Any
    emptiness is FLAGGED, never claimed, pending an ODDZERO audit.

    Exits: V14-POSITIVE-PHI-SEALED-RECONSTRUCTED,
    V14-POSITIVE-V14-STATUS-RECONSTRUCTED,
    V14-POSITIVE-LINEAR-SOURCE-IMPOSSIBLE,
    V14-POSITIVE-COMPOSITION-DOES-NOT-SETTLE-HEADLINE,
    V14-POSITIVE-SPIN-OPEN-NOT-SUFFICIENT,
    V14-POSITIVE-D6-AMBIENT-43,
    V14-POSITIVE-SPIN-D2-EMPTY-D4-DIM3,
    V14-POSITIVE-NO-DEGREE-EXCLUSION.
    Machine: V14_POSITIVE_VERIFY_OK / ALLGREEN.
```
