# NOTEBOOK registration snippet — `GUNIRATIONALITY`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/GUNIRATIONALITY/
  entry: E56
  kind: goal_run
  verification_class: literature survey; python3 replay of packet presence,
    honesty labels, ODDZERO fields, and the [T1] identities |PSL(2,11)|=660
    and the character-degree sum of squares; no external CAS
  primary_exit: GUNI-NO-LITERATURE-OBSTRUCTION
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: none. This packet proves no new geometric theorem.
    Finite exact computation: |PSL(2,11)| = 11*(121-1)/2 = 4*3*5*11 = 660;
    irrep-degree list 1,5,5,10,10,11,12,12 has square-sum 660; 2-Sylow has
    order 4; Borel C11 rtimes C5 has index 12.
    NOT claimed: any degree exclusion; any construction or obstruction for
    a G-map P(W) -> X; any value of ed(G); any application of CTZ
    Proposition 3.5 to the Hessian section; any claim that Scavia decides
    the Klein cubic.
  tracked: true
  notes: |
    Authority: worker task 2026-08-12, packet goal_runs_20260812/GUNIRATIONALITY/.
    Framing the campaign has used only through Duncan: no-name lemma,
    Merkurjev/Buhler-Reichstein/Reichstein-Youssin essential dimension,
    Serre versal torsors, and the (L)/(SL)/(U) hierarchy as published
    by Cheltsov-Tschinkel-Zhang.

    Headline: Problem E remains OPEN; this packet excludes no degree.

    RESULT. The existence literature supplies neither an obstruction nor
    a construction for the exact map P(W) -> X. CTZ Theorem 5.1 still
    lists (X, G) and (X, C11 rtimes C5) as open. No-name cannot shrink
    the source below P(W). ed(G) is still {3,4} and bounds the question
    only through the already-sealed house equivalence with G-unirationality.

    Import (inferred, not claimed): CTZ Proposition 3.5 / Remark 3.6 on a
    non-hyperplane G-invariant divisor (first candidate: the Hessian section).

    Exits: GUNI-SURVEY-ASSEMBLED, GUNI-NONAME-NO-SHRINK,
    GUNI-ED-INTERVAL-ONLY, GUNI-CTZ51-KLEIN-OPEN,
    GUNI-NO-LITERATURE-OBSTRUCTION, GUNI-NO-LITERATURE-CONSTRUCTION,
    GUNI-IMPORT-CTZ-PROP35, GUNI-NO-DEGREE-EXCLUSION.
    Machine markers: PACKET_VERIFY_OK, ALLGREEN.
```

```text
entry: E56
goal_run: goal_runs_20260812/GUNIRATIONALITY
tracked: true
primary_exit: GUNI-NO-LITERATURE-OBSTRUCTION
zeros: none
transport: Corollary 3.4 not armed
```
