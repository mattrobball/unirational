# Goal Q2 — genuine index-one Schur twist decision run

This is the isolated packet for
`GOAL_Q_SCHUR_INDEX_ONE_DECISION.md`, pinned at repository state
`35fa8f59b6a1423cc89300aeaceefe91552be5ba` and audited from live head
`37d61c19a108781cf74af837e24810a9f7f7c3be`.

The exact exit is

```text
Q-UNDECIDED
```

Neither a `K_Schur`-point nor pointlessness of the genuine twist is proved.
The canonical twist is now installed by an exact characteristic-zero
degree-eight Reynolds/Hilbert--90 frame and a complete 35-entry descended
cubic coefficient table.  The remaining Q2.0 gaps are a minimal
transcendence-basis-and-relations presentation of the invariant field and a
machine-replayed coordinate comparison for the inherited ten
coordinate-fibration statements.
The packet adds a complete post-pinned screen: for the maximal `11:5` local
survivor, every homogeneous projective covariant landing scheme in degrees
one through nine is empty, for all five character multipliers.  Degrees
one through five are reconstructed over the integral cyclotomic coefficient
ring and rerun in Singular; degrees six through eight have independent exact
support certificates, and degree nine has a terminal 26912397-state exact
deletion replay.  This is an all-coefficient theorem in those nine
degrees, not an all-degree theorem.

Four infinite `11:5` trace ansatz families are excluded.  An all-exponent
Smith-form classification eliminates every nonzero two-Laurent-term ansatz
with constant complex coefficients.  A separate Newton-polygon certificate
eliminates every two-Kummer-basis ansatz with an arbitrary coefficient ratio
in `K=C(U1,U2,U3,U4)`.  The ten three-Kummer-coordinate restrictions are
also reconstructed exactly and proved to be smooth geometrically integral
genus-one curves; the two-basis theorem excludes points with exactly two
nonzero coordinates, while the nonzero diagonal coefficients exclude the
vertices.  Thus any rational point must lie in the dense coordinate torus.
An exhaustive all-exponent support certificate further excludes points whose
three nonzero coordinates are each a single Laurent monomial with arbitrary
nonzero complex constants.  A rank-stratified collision certificate likewise
excludes all five four-coordinate hyperplanes when every nonzero coordinate is
one Laurent monomial with an arbitrary nonzero complex constant.  The
Fisher-normalized `c4`, `c6`, and Jacobian
are computed exactly for `C_012`.  No point or torsor class is found on any
of these curves, and coordinate sums, arbitrary rational functions, the
five-coordinate Laurent-monomial case, and arbitrary elements of the cyclic
extension remain open.

Two additional exact screens do not change that boundary.  Both complete
five-coordinate constant families, in the normalized Kummer basis and in the
direct `R_i` basis, have empty coefficient schemes at split primes 11 and 31.
For the one-parameter specialization `(U2,U3,U4)=(3,5,7)`, the `C_012`
Jacobian has fibre pattern `IV* + 27 I1 + I1`, and exact mod-11 charts exclude
polynomial-coordinate sections of degree at most three.  Neither theorem
allows general coefficients in `K` or decides a genus-one torsor.

Both maximal `A5` valuation survivors are now eliminated functorially.  The
exact degree-eleven landing maps have honest three-dimensional linear
sources; twisting leaves a split projective plane, so every twist by either
embedded `A5` has a rational point.  The unramified nonpoint frontier is
therefore reduced to decomposition group `G` or `11:5`.

The same maps give the full generic twist an effective degree-11 zero-cycle,
so its shortest installed signed degree-one identity is now `4*3-11=1`.
Six explicit transferred cycles have complete quadric/linkage and secant
audits.  None lies on a degree-at-most-four curve, and their 55 secant
residuals form a distinct `D12` orbit rather than a rational point.  The
unrestricted positive gate is nevertheless exact: a descended rational
normal quartic through a reduced degree-11 orbit would leave a residual
degree-one intersection.  Its seven-point chart, four determinantal
conditions, dimension 21, and generic degree 120 are replayed; existence of
a `K_Schur`-point on that incidence locus remains open.

It also proves that Schur splitting produces a smooth `K_Schur`-defined
Pfaffian elliptic normal quintic and the associated `V14`.  The accompanying
audit proves why the tautological Schur point and the known degree-3/11/55
cycles do not extract a point.  Full rank-21 incidence computations also
prove that every descended Pfaffian member is disjoint from both the 55-line
`D12` and 66-line `D10` unions, closing the tempting coprime-degree exit.
An exact characteristic-zero Palatini packet now identifies the full-Schur
rank-drop quartic, constructs a degree-seven projective Hilbert--90 frame,
and reduces the remaining `V14` point gate to one explicit quartic identity
over `K_Schur`.  A new complete factor/SAT certificate excludes the entire
19-dimensional constant-coefficient degree-nine self-covariant space.  Ten
natural pencils and a bounded 218596225-pair search on the canonical
three-frame genus-three slice also have no survivor, but arbitrary invariant
rational coefficients remain open.  The fixed-curve
bridge also proves that an actual odd-degree genus-zero stable map or an
actual generalized-twisted-cubic Hilbert point would be decisive, while the
known virtual/orbit data are not such objects.

Packet map:

- `GENUINE_TWIST.md` — canonical field, twist, degree-11/55 points, and bridge;
- `exact_schur_frame/` — exact characteristic-zero Hilbert--90 frame and all
  35 descended Klein-cubic coefficients;
- `a5_valuation_elimination/` — exact weak-versality maps eliminating both
  maximal `A5` decomposition classes from the local nonpoint frontier;
- `a5_degree11_cycle_next/` — functorial effective degree-11 cycle on the
  full twist and the prime-degree descent dichotomy;
- `degree11_secant_descent_agent/` — all-six quadric/linkage, pair-secant,
  `D12`, and `CH_0` audit for displayed degree-11 cycles;
- `incidence_splitting/` — the exact rational-normal-quartic residual-point
  theorem and four remaining rank conditions;
- `ZERO_CYCLE_LEDGER.md` — exact degree `3/11/55` index-one arithmetic;
- `DESCENT_OBSTRUCTION.md` — standard-obstruction no-go, local narrowing,
  maximal-`A5` elimination, and the new `11:5` theorems;
- `FIBRATION_AUDIT.md` — exact reach of the installed birational models;
- `schur_enq_v14/` — Pfaffian quintic, Fano--Iskovskikh link, and exact
  point-extraction boundary;
- `f55_covariant_results.json` — 25 complete landing-scheme records;
- `probe_f55_covariants.py`, `run_f55_covariants.py`, and
  `verify_f55_covariants.py` — producer and standalone cyclotomic replay;
- `f55_degree6_degree7/`, `f55_degree8/`, and `f55_degree9/` — independent
  exact support certificates for degrees six through nine;
- `h_trace_two_laurent/` and `h_trace_fourier_pair_k/` — the two exact
  infinite trace-ansatz exclusions;
- `h_trace_three_kummer_planes/` — exact equations and generic smoothness for
  all ten three-Kummer genus-one restrictions, with their coordinate
  boundaries proved to have no `K`-points;
- `h_trace_three_kummer_laurent/` — all-exponent exclusion when each of the
  three nonzero coordinates is one Laurent monomial with a complex constant;
- `h_trace_four_kummer_laurent/` — all-exponent collision-rank exclusion when
  four nonzero Kummer coordinates are single Laurent monomials;
- `full_trace_tropical_obstruction_next/` — two complete constant
  five-coordinate projective-emptiness certificates at split primes 11 and
  31;
- `h_trace_plane_012_jacobian/` — exact Fisher invariants and Jacobian for
  `C_012`, with the torsor class and rational-point question left open;
- `c012_oneparam_section_agent/` — exact one-parameter fibre audit and
  degree-at-most-three polynomial-section exclusion;
- `f55_all_degree_boundary/` — exact Hilbert-series and Newton-support audit
  explaining why finite generation and unique exposed monomials give no
  all-degree cutoff;
- `full_schur_palatinian/` — exact characteristic-zero Palatini quartic and
  bounded full-Schur self-covariant audit;
- `full_schur_palatinian_point_next/` — ten pencil exclusions, the complete
  degree-nine constant-coefficient theorem, and the bounded canonical
  three-frame search;
- `fixed_curve_bridge/` — exact arithmetic implications for actual descended
  genus-zero maps and generalized twisted cubics;
- `CONTINUATION_AUDIT.md` — new exact results, repaired scope boundaries, and
  the smallest surviving positive and negative gates;
- `COMPLETION_AUDIT.md`, `decision.json`, and `STATUS.md` — the exact verdict;
- `REPLAY.md`, `verify_all.py`, and `SEAL.json` — operational verification.

`SEAL.json` seals the packet and its `Q-UNDECIDED` scope.  It is not a seal
of either binary headline.
