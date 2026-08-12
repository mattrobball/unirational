# NOTEBOOK registration snippet — `TANGENT_C6`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.** No git operation was performed; nothing outside
`goal_runs_20260812/TANGENT_C6/` was written.

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/TANGENT_C6/
  entry: E56
  kind: goal_run
  verification_class: in-packet polar calculus of the Klein cubic over Z
    (gradient, Hessian, (25.1)–(25.2), λ-expansion) plus exact rank of the
    sampled polar Jacobian A(c) on the sealed 37-cell at p=331 and p=661;
    python3+numpy only; no landing Gröbner basis; full 37-dimensional
    deformation space (never a subset)
  primary_exit: TANGENT-C6-JUMP-LOCUS
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: F = sum y_k^2 y_{k+1}; dF/dy_k = 2 y_k y_{k+1} +
    y_{k-1}^2; Hessian H_kk = 2 y_{k+1}, H_{k,k+1} = 2 y_k; first-order
    condition A(c)(s) = sum (dF/dy_k)(T_c) T_{s,k} = 0; second-order
    condition Hess(T_c)(T_s,T_s) + 2 gradF(T_c)·T_r = 0; ranks
    ρ(c)=rank A(c), dim Tan(c)=37-ρ(c), dim Obs_P3(c)=1380-ρ(c); Euler
    A(c)c = 3 F(T_c) so c in V implies ρ(c) ≤ 36; A(λc)=λ² A(c); at the
    origin ∇F(0)=H_F(0)=0 so A(0)=0 and both (25.1) and (25.2) vanish,
    the first nonzero condition being λ³ F(T_s) (the landing cubic). The
    origin is the vertex of the cubic cone V, hence uninformative for C6.
    Z_36 = {ρ ≤ 36} contains V\{0} and intersecting it with landing cuts
    nothing. Z_35 is a Jacobian-criterion cut, not a condition every
    landing point must satisfy. Deformation theory yields no new equations
    that every point of V must satisfy, independent of the landing cubics.
    Finite exact computation: ρ(0)=0 and A(0)=0 at p=331 and 661; generic
    ρ=37 on 12 random + 37 basis rays + 8 weight-2 points at both primes;
    Euler, homogeneity and (25.2) hold on all those samples; common kernel
    of four random A(c) is 0.
    NOT claimed: any exclusion; emptiness of V; a nonzero landing point;
    ρ on V\{0}; Z_36 = V ∪ {0}; smoothness of P(V); C6 at a genuine
    landing point (still deferred, for the right reason).
  tracked: true
  notes: |
    Item C6 of theory/CONSTRAINT_ADDITIONS_20260811.md (audit §25).
    Authority: the polar calculus of F in campaign coordinates, the sealed
    37-cell of PAIR_ATTACK_D35, and the Euler identity on Φ_land(c)=F(T_c).

    Headline: Problem E remains OPEN.  This packet excludes no degree and
    cuts none of the 22 live d = 35 cells.

    WHAT IS NEW.  Explicit campaign-coordinate tangent/obstruction formulae
    and the rank function ρ(c); the origin computation with the precise
    reason it is vacuous (cone vertex, not missing theory); generic rank 37
    at two primes; the jump-locus analysis (Z_36 proper closed and
    Euler-implied on V; Z_35 optional singular-locus cut).

    WHAT IS A RESTATEMENT.  Audit (25.1)–(25.2); V a cubic cone; Euler;
    landing cubics = coefficients of F(T_c).

    ZERO / ALL-DEAD AUDIT.  No census zero and no all-dead outcome.  The
    number ρ(0)=0 is a rank at the cone vertex, not a census zero.

    Exits: TANGENT-C6-POLAR-FORMULAS, TANGENT-C6-RANKS-AS-FUNCTIONS,
    TANGENT-C6-ORIGIN-VACUOUS, TANGENT-C6-GENERIC-RANK-37,
    TANGENT-C6-JUMP-LOCUS, TANGENT-C6-NEW-VS-RESTATEMENT,
    TANGENT-C6-NO-DEGREE-EXCLUSION.
    Machine markers: TANGENT_C6_VERIFY_OK, ALLGREEN.
```

## Honesty tiering

| tier | content |
|---|---|
| `[T1]` | Polar calculus; (25.1)–(25.2) in campaign coordinates; origin vacuity; Euler ⇒ `V \ {0} ⊂ Z_{36}`; new/restatement split |
| `[T2]` | Cell 37×637; `ρ(0)=0`; generic `ρ=37`; Euler / homogeneity / (25.2) on samples; both primes |
| `[T3]` | `Z_{36} =? V ∪ {0}`; `V ⊂? Z_{35}`; C6 at a genuine landing point |
| `[EXT]` | Klein `F`; sealed 37-cell; sealed `P3=1380`; audit §25 |

## Downstream edits this packet implies (for the director, NOT made here)

1. `theory/CONSTRAINT_ADDITIONS_20260811.md` C6 and
   `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` C6 can record that the
   tangent/obstruction spaces are now written in campaign coordinates and
   evaluated at the origin (vacuous), and that the remaining deferral is
   only the absence of a nonzero point of `V`.
2. Packets that still say “C6 deferred, needs a candidate” should stop
   citing the origin as if the theory were missing.
