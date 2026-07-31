# Director gate report — post-Elo order, first dispatch

**Author:** director session.
**Date:** 2026-07-31.
**Order:** `WORKORDER_POST_ELO_CONSTRUCTION.md` §4.
**Base:** `d96b408`.

## Selection

\[
\textbf{Option 1 — G terminal obstruction found: prioritize proving its
periodic / all-degree form.}
\]

Two options were live (1 and 4); the order requires exactly one.  Option 1
is selected because Path G is rank 1, because `G1` is the more consequential
structural result, and because the periodicity question is the single step
that could convert a scoped obstruction into an all-degree theorem.  Path T's
success is real and is queued as the secondary track, not discarded.

Option 2 does not apply (no polynomial candidate).  Option 3 does not apply
(the `F` binary is undecided).  Option 5 does not apply (two routes crossed
their gates).

**Headline: OPEN.**

## Results of the first dispatch

| Path | Result | Marker | Commit |
|---|---|---|---|
| G | `G1` **PASS**; degree 7 exits `G7-OBSTRUCTION` | `FINITE_TRUNCATION_G1_PASS`, `G7_TOWER_VERIFY_OK` | `c28bb08` |
| T | Gate `T1` = **`T-BIRATIONAL`**; `T2` plan only | `POSTELO_T1_FOLD_BIRATIONAL_VERIFIER_ACCEPT` | `d96b408` |
| F | `F1` installed; `F2`/`F3` plans; binary undecided | `PATH_F_RESTRICTED_ETALE_ALGEBRA_ACCEPT` | `d96b408` |

**Bookkeeping correction.**  Path F's artifacts under
`certificates/restricted_e3/` were swept into commit `d96b408` by a
directory-wide `git add`, so that commit's message describes only Path T.
The Path F artifacts are tracked, pushed, and verified; this report is their
record.

## G — the structural result

`F(p)` has total degree `3d`, and a form of degree `3d` cannot lie in
`(y_0,y_1)^{3d+1}`.  Hence

```text
F(p) in I_{Z_t}^{3d+1}   ==>   F(p) = 0,
```

checked concretely at `d=7`: the space of degree-21 forms in `I^22` is
`0`-dimensional out of `12650`.  Consequences certified: the tower
terminates by normal order `3d`; there is **no infinite
Artin-approximation problem** at fixed `d`; algebraization is a **finite
terminal system**.

At `(m,d)=(1,7)` the terminal order is `21`, but the tower dies at
**F-order 10**, where the `ker-L_1` free-fibre residual is nonzero
(`norm^2 = 1296`).  The dispatch also explained the apparent tension with
the accepted degree-7 exclusion: free-module `L_r` surjectivity produces
power *series*; degree 7 truncates jets at order `<= 7`, so isolators stop
at `b_6`, from F-order 10 the free isolator would need order `>= 8`, and
based coupling kills `a_7`.  Full `G`-equivariance collapses onto the
already excluded 4-dimensional space.  No candidate appeared, and the
verifier checks that reconciliation rather than leaving it to prose.

## T — the wall is routed around

`S = B[u]/(P,P_u)` is finite and birational over `B = Q[A,B,Y,Z]/(H_43)`,
proved **without re-eliminating `u`** — the step that exceeded the memory
gate twice.  Finiteness from inverting `l_u(P)` (monic of degree 6, free rank
6); generic rank `1` from `H | Res` plus multiplicity one of `H` via the
accepted line, subresultants, and a bivariate degree-21 count, with M2
independently reporting `DIM=0, DEG=21`; `Frac(S) = Frac(B)` from `(P,P_u) =
(u-alpha)` reduced under the `P_uu` gate.

Normality may now be tested on the fold rather than on the 37,992-term
degree-43 hypersurface.  That was the entire purpose of the route.

## F — reduced to a clean binary

`R_K = R (x)_F K_proj = K_proj x L_K`, rank `9` over `K_proj`, with `L`
irreducible by a specialization argument at six smooth exact points over
`Q(zeta_11)`.  The question is now

```text
res(xi) = 0   <=>   alpha_R in (R_K^x)^3   <=>   alpha_L in (L_K^x)^3.
```

`Aut(L/F)` was explicitly **not** assumed by analogy with Path A's degree-55
`Aut = 1`; it is recorded as `NOT_COMPUTED_IN_CHAR0`.  Both consequence
branches are recorded honestly, including that `res(xi)=0` still does **not**
give `ed_C(G)=3` without the versal-twist bridge — the unbridged arrow that
produced the Pfaffian `FAIL-SCOPE`.

## Dispatch decision

1. **G3 — periodicity (primary).**  Run the complete finite tower at
   `(1,13)` and `(3,19)` and classify terminal behaviour: does the
   obstruction depend on `d mod N`, on `m`, on `d - 6m`, on the source-line
   ledger, on residual `S_3`-type, or on another finite invariant?  Target
   exits `G-PERIODIC-NEGATIVE`, `G-POLYNOMIAL`, or `G-PATTERN`.  A
   conjectured congruence is **not** a theorem and must be labelled
   `G-PATTERN`.
2. **T2 — Serre normality (secondary).**  The plan is written and scoped;
   execute it on the fold.  `S_2` from the complete-intersection/CM
   presentation, `R_1` by singular locus in codimension `>= 2`.
3. **F2/F3 remain planned, not run.**  They wait on this gate's outcome.
4. Paths A and C stay parked; §4 authorizes A1–A3 and C1 only under option 5,
   which was not selected.

## Boundary

No `K_proj`-point, no landing covariant, no pointless twist, no exclusion of
all landing covariants.  A terminal obstruction at one bidegree is **not** an
all-degree theorem.  **Problem E remains OPEN.**
