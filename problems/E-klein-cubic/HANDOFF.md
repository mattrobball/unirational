# Problem E handoff

## Headline

The problem remains **OPEN**. Do not reinterpret the essential-dimension
equivalence, generic-twist frame, or bounded covariant search as a binary
resolution.

The current two-axis ranking and the four-path audit are in
[`CURRENT_PATHS.md`](CURRENT_PATHS.md).

## 2026-07-28 delta

> **DIRECTOR STOPPING RULE (corrected 2026-07-29; owner-confirmed).**  No
> NEW `tmp/` sweep whose conclusion has the form "degree / support / chart
> N excluded" may be dispatched unless it is a step inside a structural,
> degree-independent theorem.  Runs already in flight continue to
> completion unless they contend with newly prioritized work, in which
> case the new work wins.  **Correction to the previous wording:** the
> five F-engine checks are DONE (`tmp/involution_exceptional_divisor/`,
> `tmp/d12_line_restriction/`; RESOLUTION item 8) — the director's
> "unrun" claim was wrong.  Their verdict stands: the finite transition
> graph CLOSES rather than obstructs; per the pre-registered fork in the
> technique-import note, that outcome weighs toward a POSITIVE
> construction along the fixed configuration, and the worker's
> do-not-rerun note on the constant-path argument is endorsed.  Current
> priorities: (1) the structural targets as reformulated by the
> degree-256 endomorphism finding — a global foliation / line-subsheaf
> theorem, or an effective bound for one MINIMAL solution (the uniform
> bound is dead: precomposition saturates degrees 4^n d); (2) the
> positive-construction assessment the closing graph licenses, alongside
> the ongoing xcd descent (DAG implementation, then alpha_R).  Bounded
> sweeps re-enter only on a precise delimitation showing they are needed.


> **Cross-problem import, now audited (see the full section near the end of
> this file):** Problem F — the PSL(2,7) degree-2 del Pezzo — is RESOLVED
> NEGATIVE by an all-degree V₄-fixed exceptional-path obstruction.  Its
> five cheap fixed-locus checks and Fable's finite-state refinement have now
> been run for this problem.  The verbatim transfer fails: for an involution
> \(t\), the \((-1)\)-line lies entirely on the Klein cubic, so a
> pointwise-\(t\)-fixed exceptional divisor
> may map nonconstantly to that rational line.  What survives is a new exact
> all-degree necessary condition: all 55 \((+1)\)-eigenplanes are base
> components of any hypothetical landing covariant, their common transverse
> order is odd, and their leading normal maps dominate the corresponding
> \((-1)\)-lines.  For a \(V_4\), the three fixed lines form a triangle,
> the vertex stabilizers and tangent characters are explicit, and the marked
> transition graph closes rather than obstructs: both endpoint-preserving
> and endpoint-swapping local transitions occur.  Any successor must use the
> full symbolic 55-plane arrangement or a new invariant of the
> higher-dimensional exceptional complex, not the Problem F path lemma or
> its finite triangle state alone.

The headline is still open, but the following next steps were completed and
replayed.

- The characteristic-zero landing self-covariant cutoff is now degree
  **24**.  Fable's forced-plus-plane condition gives the following complete
  split-`F_67` ledger:

  ```text
  degree              16 17 18 19 20  21  22  23  24
  Molien dimension    41 49 59 73 86 100 121 140 161
  restriction rank    41 47 56 66 75  84  96 106 117
  arrangement kernel   0  2  3  7 11  16  25  34  44
  ```

  The old degree-22 24-variable chart is superseded, not retried.  Exact
  common-line and even minus-line compression gives
  `25 -> 12 -> 4 -> 0` by linear algebra.  In degree 23 the common-line gate
  gives `34 -> 20`; 392 necessary cubics have unit ideal on all 20 disjoint
  projective charts.  In degree 24 the full first jet has rank `43/44`; its
  unique exceptional line has exact transverse order two, while the order-one
  branch compresses `44 -> 29 -> 20` using the common line and even
  minus-line.  A 484-cubic system is unit on all 20 residual charts.  The
  exceptional line also lies in that residual space, so the chart cover
  excludes it independently of the parity argument.  Independent
  from-scratch audits passed for degrees 23 and 24, and projective-DVR
  properness transfers all three new empty good fibres to characteristic
  zero.  Degree **25** is the first bounded unknown.  Replay with
  `/opt/homebrew/bin/python3 -u tmp/degree22_compression/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/degree23_common_line_landing/verify.py`,
  and `/opt/homebrew/bin/python3 -u tmp/degree24_landing/verify.py`.
  The older degree-15 structural replay remains
  `python3 tmp/degree15_structural/verify.py`.
- Degree 25 has been structurally reduced but **not excluded**.  Its exact
  split-fibre ledger is `M25=189`, restriction rank 130, and `K25=59`.
  The first jet has rank 56; its three-dimensional kernel has exact plane
  order two and is parity-excluded.  Common order two cuts `59 -> 43`.
  On that strict space, the exact unisolvent common-line filtration is
  `43 --order3 rank37--> 6 --order4 rank6--> 0`, and the order-at-least-four
  six-space is excluded because its landing cubics span all `56/56` forms.
  The unresolved leading common-line order-exactly-three system factors
  through a 37-dimensional quotient, above the 20-variable solver ceiling; no chart was launched and
  no characteristic-zero exclusion is claimed.  The same calculation gives
  `D_25[W]=182-36-130=16`, extending that finite observation through degree
  25.  A from-scratch audit rebuilt the complete degree-25 space, both jet
  filtrations, the `D10`/`D12` point maps, the `56/56` landing span, and the
  previously missing full `3124/3124` overlap rank.  Replay with
  `/opt/homebrew/bin/python3 -u tmp/degree25_structural_probe/verify.py` and
  `/opt/homebrew/bin/python3 -u tmp/degree25_structural_probe_independent_audit/verify.py`.
- The symbolic successor has now been made both globally correct and more
  computationally concrete.  For every fixed symbolic order `m`, the
  iterated construction "plane normalization -> triple-line equalizer ->
  residual point kernel" is exactly the sheaf associated to
  `I^(m)/I^(m+2)` in every twist.  The literal graded construction can differ
  only by the finite irrelevant-torsion module
  `T_m=H^0_m(E_m/(I^(m)/I^(m+2)))`; it is automatically exact for
  `d >= 55m+109`, while low-degree exactness is the finite saturation test
  `T_m=0` (or vanishing of `[(T_m tensor W)^G]`).  The tempting surjective
  four-term Cech complex is false: the `D12` line map has right cokernel
  Hilbert function `(4,5,1)`, and the residual point term is instead a
  quotient on the left of its kernel.  Over split `F_67`, compact/literal
  comparison proves `[(T_1)_d tensor W]^G=0` through degree 34, and automatic
  regularity gives zero in every degree at least 164.  Multiplication by
  `f3`, formed before quotienting, is injective on `D_d -> D_(d+3)` for every
  `14<=d<=31`; the truncated quotient through degree 34 is 1,459.  Degree 35
  changes the conclusion: the line kernel has dimension 878, the combined
  point rank is 516, the compact saturation has dimension 362, and the
  independently rebuilt literal global image has dimension 361.  Hence
  `dim [(T_1)_35 tensor W]^G=1`.  Finite irrelevant-torsion nilpotence then
  gives a nonzero element of `(0 :_D1 f3)` in some degree.  Thus the proposed
  all-degree split-fibre colon vanishing, and with it the target-1,572
  certificate, is **refuted**.  The first killed degree/vector is not known,
  and no characteristic-zero saturation statement follows.  A complete
  second split fibre at `(89,zeta11-2)` again has compact dimension 362, while
  the full 637-dimensional ambient global space has order-zero restriction
  rank 276 and hence literal-image dimension at most 361.  This proves a
  second positive fibre defect but still does not lift it: rank may increase
  generically.  The raw cyclotomic line matrix alone has a 492.8 MiB
  coefficient floor before field/bignum overhead, so a characteristic-zero
  proof now requires intrinsic compressed line/point differentials or a small
  exact cycle/nonboundary certificate, not another prime.
  See
  `tmp/symbolic_global_exactness/REPORT.md`,
  `tmp/graded_symbolic_architecture/REPORT.md`, and
  `tmp/m1_compact_graded_pilot/REPORT.md`, together with
  `tmp/m1_t1_saturation/REPORT.md`,
  `tmp/m1_t1_f3_colon_attack/REPORT.md`, and
  `tmp/m1_t1_f3_colon_degree35_audit/REPORT.md`, together with
  `tmp/m1_t1_char0_d35_gate/REPORT.md`.  The linear successors are
  now a characteristic-zero/integral saturation analysis and higher symbolic
  order; extending the same split-`F_67` zero-colon ladder cannot prove the
  false statement.  The nonlinear relative border/Fitting landing problem is
  unaffected.
- The complete split-`F_67` order-four landing system on the degree-25
  strict 43-space is now known, not merely its former `56/56` high-order
  block.  With `V=Q_37 direct_sum K_6`, its 842-dimensional cubic row space
  has filtered ranks `56,833,842,842` on
  `K^3`, `K^3+QK^2`, `K^3+QK^2+Q^2K`, and all cubics.  Independent audits
  rebuilt every rank and the final 842-row basis.  After the first 833 monic
  eliminations, the last nine equations are
  `M(q)k+b(q)=0`, with `M` a `9 x 6` quadratic matrix and `b` cubic.  There
  is no linear graph `k=Tq`.  Exact determinantal certificates give
  `height I_6(M)=4`, projective dimension 32 and degree 2016, while
  `height I_7([M|b])=3`, projective dimension 33 and degree 835.  Thus the
  nine-equation compatibility locus is nonempty and generically determines
  `k`; the remaining 833 cubics are indispensable.  Raw 43- and 64-equation
  Gröbner probes hit the 700 MiB gate at degree five and are strict
  nonverdicts.  On `Q_0=1`, the exact chartwise border matrix has shape
  `821 x 7` and coefficient degrees at most five.  A bounded exact search of
  399,756 structured maximal minors found no constant (equivalently no pure
  `Q_0`-power before dehomogenizing), explicitly nonexhaustively.  The
  smallest generically overdetermined `43 x 7` submatrix gives seven
  rank-drop incidence charts, each with 43 equations in 42 variables and
  about 980,000 terms; their optimistic sparse Macaulay floor is already
  710.386 MiB, so no blind solve was launched.  See
  `tmp/m1_landing_chart_fitting/REPORT.md`.  A sealed circuit packet gives
  three exact lowest-profile separations: `q0^4 e0` is absent from the
  756-row-plus-residual degree-four span; no constant combination of all 821
  lowest-profile chart rows equals `q0^5 e0`; and, on one nonempty rank-six
  residual-minor chart, the 815 aligned wedge circuits are linearly
  independent and do not constantly generate `q0^17`.  These tests allow no
  landing or support conclusion because polynomial multipliers, higher
  degrees, and the other minor charts remain untested.  The accepted
  coordinate-Schur filtration now refutes the full 34,355-unknown raw-821
  scalar-`Q` degree-five identity already after restriction to
  `q0,...,q16`: the terminal `10659 x 1913` map has source rank 1,913 and
  augmented rank 1,914.  It does **not** refute the `T_i`-stable rank-28
  kernel or its support, and higher cleared degrees remain open.  See
  `tmp/m1_rank6_circuit_support/REPORT.md`,
  `tmp/m1_rank6_schur_compression/REPORT.md`, and its `PROOF_AUDIT.md`.
  The live successor remains a
  relative border/Fitting computation: either a sparser chartwise
  seven-column certificate, or sparse global support/saturation for the
  rank-28 border basis `{1,K_i,K_iK_j}`.  The latter presentation is already
  proved equivalent coefficientwise to the original 842 cubics; on one
  sparse `P^10` its commutator/stable closure fills degree four, independently
  confirmed by the direct restricted ideal.  A separate Macaulay2 control on
  that `P^10` gives `H(3)=127`, `H(4)=0` at 696,680,448 bytes, but the
  operator-bearing precursor crosses the 700 MiB gate before forming its
  commutator module; no global saturation or Fitting calculation was run.
  Its global dense degree-four block would require at least 5.49 GB, so it
  must stay a sparse polynomial-module or circuit computation.  See
  `tmp/recent_equivariant_tools_2026/REPORT.md`,
  `tmp/m1_border_module_m2/REPORT.md`,
  `tmp/m1_full_plane_block_rank/REPORT.md`,
  `tmp/m1_determinantal_geometry/REPORT.md`, and
  `tmp/m1_landing_commalg_pilot/REPORT.md`.  One exact complete-system slice
  remains as independent mixed-coordinate evidence: on a deterministic
  coordinate `P^18` the degree-four
  Macaulay map has shape `15998 x 7315` and full column rank, certified by a
  `7315 x 7315` minor of determinant `1 mod 67`.  Hence that projective slice
  is empty over the algebraic closure, and the projective dimension theorem
  gives the now-superseded bound `dim Z<=23` for any nonempty full landing
  locus `Z subset P^42`; no genericity assumption is used.  The stronger
  exact result uses the global rank-28 module.  The monic `K^3` rules make
  `Z -> P(Q)=P^36` finite, and there is no point over the centre `Q=0`.
  A `P^16` anchor and two exact Schur extensions prove that the support misses
  the coordinate `P^18 subset P(Q)`.  The degree-four square has nested block
  sizes `13872+2544+2869=19285` and pivot products `5,14,11 mod 67`, hence
  total product 33.  The final 2,869-square was rebuilt coefficientwise and
  reranked independently; producer and verifier peaks were 655.81 and
  675.41 MiB.  This first gave `dim Z<=17` for any nonempty split-fibre
  landing locus.

  Although `P^19` cannot close in degree four by row count
  (`20751<22505`), the next closure degree does.  Inheriting the 19,285
  accepted `P^18` rows, reducing the 1,466 remaining degree-four relations,
  and multiplying their Schur residuals by all 20 `Q` variables gives a
  `29320 x 3220` terminal degree-five matrix of exact rank 3,220.  Its
  selected square has pivot product `58 mod 67`.  The curvature-safe proof
  first supplies the full `q19^2 F_3` summand, then `q19 F_4(19)` and
  `F_5(19)`; it does **not** assert the false intermediate equality
  `rank(S_1W)=124754`.  Hence the coordinate `P^19` is empty and

  ```text
  dim Z <= 16.
  ```

  This `P^19` bound is now a superseded historical step over the split fibre.
  On the coordinate `P^20`, degree four has quotient dimension 4,693, and a
  curvature-safe family of genuine degree-five relations gives an exact
  `4693 x 4693` full-rank square with pivot product `32 mod 67`.  All 19
  stages of the segmented full replay pass under the 700 MiB cap, with
  maximum RSS `580.828125 MiB`.  Hence the
  projected support misses `P^20` after base change to the algebraic closure
  of `F_67`, and the projective dimension theorem gives every nonempty
  split-fibre landing locus the bound

  ```text
  dim Z <= 15.
  ```

  The arithmetic `P^20` packet itself makes no characteristic-zero claim.
  The separate canonical projective-DVR argument in the 189-dimensional
  Reynolds lattice promotes the invariant conclusion `dim L_25<=15` to
  `Q(zeta_11)` and hence to `C`; it does not lift the arbitrary modular
  `Q/K` frame.  This is a dimension bound, not emptiness.  Its verifier binds
  the arithmetic provenance and dependencies; the properness and upper-
  semicontinuity step is the geometric proof in the report.
  See
  `tmp/m1_cubic_slice_macaulay/REPORT.md` and
  `tmp/m1_relative_border_rank28/REPORT.md`,
  `tmp/m1_relative_border_maxslice/REPORT.md`,
  `tmp/m1_relative_border_p19_d5/REPORT.md`, and
  `tmp/char0_lift_p19_d5/REPORT.md`, together with
  `tmp/m1_relative_border_p20_d5/REPORT.md`, its `PROOF_AUDIT.md`, and
  `tmp/char0_lift_p20_d5/REPORT.md`.  Degree
  25, `(ID_1)`, emptiness of the
  landing locus, and the headline all remain open.
- The former degree-16 residual calculation is now superseded as a re-entry
  path, but retained as exact provenance.  The complete
  quotient has dimension 20 and the complete landing image rank 93.  The
  pure-normal ideal is Artinian of length `6,169`, so projection to the
  scalar `P3` is finite.  The scalar locus has a common nine-dimensional
  normal tangent kernel, and that entire straight kernel stratum is empty by
  an exact weighted cokernel of length `713`.  The weighted-projective
  second-order lifting incidence is also empty, so no nonzero normal tangent
  direction admits a second-order lift.  Global rank 15 is now exactly refuted, since
  the `93 x 15` weighted matrix has rank five on the tangent-kernel `P8`.
  That forced rank drop does not meet `y=(Sym^2(s),s,1)`.  At that stage the
  unresolved formulation was the true Veronese-affine residual incidence,
  which could not be collapsed to `P6`:
  `Q(n)` and `C(n)` retain all nine kernel coordinates, so the honest base is
  the blowup of `P15` along `P8`.  The cleared `83 x 5` quotient formulation
  has 19 variables and 93 equations of degrees 12 and 13, not a smaller
  solve.  The proposed next move was to use the absence of nonzero
  second-order lifts to split or saturate away the scalar component in the
  original cubic system.  A full 13-variable `K9+s4` fiber
  at `t=[1,2,30,32,60,2,48]` is exactly empty: a saved 93-coefficient linear
  combination of the original cubics equals one, and `msolve` independently
  returned `[-1]:`.  Properness of the controlled boundary puts all possible
  survivors over a proper closed subset of `P6`, also in characteristic zero.
  In the complete mod-67 system the first equation of that exceptional image
  is now exact: a fixed row combination is `59*L^3`, so all residual support
  lies over the explicit hyperplane
  `t0+38*t1+20*t2+6*t3+8*t4+2*t5+25*t6=0`.  Its generic row rank is 91.
  All 264 retained fibres there are empty, but they are finite samples.  The
  complete 18-variable hyperplane chart reached the 700 MiB stop without
  output, and no characteristic-zero lift of the hyperplane equation is
  claimed.  The new injective plus-plane restriction closes degree 16
  globally.  Do not continue the old sparse/block image, add isolated
  samples, expand 5-minors, or extend the false weighted-cokernel target.
  Replay with
  `python3 -u tmp/degree16_landing_probe/verify.py`,
  `python3 tmp/degree16_landing_probe/verify_off_k_residual_audit.py`, and
  `python3 tmp/degree16_landing_probe/verify_off_k_t_fiber_attack.py`.
- The degree-12 mixed Jacobian incidence is generically empty over its
  primitive `P^3`.  The exact fiber `[1:1:1:1]` is a unit ideal, and the
  empty decomposable center makes projection proper.  Remaining solutions,
  if any, lie on a proper closed exceptional locus.  With
  `A=F_67[p1,p2,p3]`, the retained `mu7: A^65611 -> A^50388` is only a
  degree-seven border truncation, not a
  presentation of that locus: specialized membership of `1` does not lift
  automatically to a relative annihilator.  The parameter-independent
  degree-five block has a certified \(721\times721\) minor of determinant
  \(18\bmod67\), and the completed top-form Groebner calculation has Hilbert
  function `[1,12,78,364,1365,3647,3726,0,0]` and colength `9,193`.
  Its full 15,283,769-term reduced basis is audited, proving finite top
  control and identifying a possible `9,193 x 24,416` Schur target.  The
  missing object is still a multiplication-stable relative determinant with
  nonzero value at `(1,1,1)`.  An audited shortcut now reduces this to two
  exact witnesses: a right inverse/PLU circuit for the
  `31,824 x 56,238` degree-seven top map and one degree-at-most-two
  multiplier vector whose lazy rank-18,564 reduced multiplication operator
  has full rank at the sample point.  A length-65,611 specialized unit vector
  guarantees such a choice, but a sparse choice may suffice.  Its determinant
  kills the full quotient over `F_67` without any confluence claim.  A
  characteristic-zero determinant would still require lifting the pivot
  minors and replaying the solves over an integral or number-field model.
  The witnesses are not yet certified.  The ancestor-closed survivor replay
  has now completed under the `768 MiB` trace-allocation gate: `55,966` roots,
  `45,751,159` committed operations, `479,691,384` discarded zero-row
  operations, and `372,506,624` allocated bytes.  Its corrected leaf map
  records the permutation and normalization of all 721 original generators.
  Structural replay passes.  A separate exact semantic replay checks every
  one of the 721 degree-five final rows coefficientwise in 4,368 ambient
  monomials: 2,882 selected roots, 474,949 trace operations, and zero
  mismatches.  One full cross-round degree-seven row with 48,255 nonzero
  source entries also multiplies exactly to `d11^7`.  The verified
  division plan covers all 31,824 target monomials using 8,181 retained basis
  rows.  This is the right circuit format, but the selected degree-six and
  remaining degree-seven roots have not yet been compared coefficientwise
  with the retained basis, so no full `M7` right inverse or `M7 R = I`
  certificate is claimed.  Dense expansion is
  rejected: it would need `782,526,535` live bytes before overhead and about
  `1.59e12` scalar updates.  The exact next gate is to extend the ambient-
  polynomial semantic verifier from the completed degree-five layer to the
  remaining 7,846 degree-six/seven rows (the audited all-row plan uses
  `478,080,096` peak bytes and about `1.05e12` updates), followed by circuit-level right-inverse and
  multiplication-rank checks.  Everything remains over `F_67`.  See
  `tmp/relative_kls_chart/DEGREE_LOWERING_DETERMINANT.md` and
  `tmp/relative_kls_chart/TRANSFORM_EXTRACTION_GATE.md`, plus
  `tmp/relative_kls_chart/survivor_trace/REPORT.md`,
  `tmp/relative_kls_chart/survivor_trace/evaluator/REPORT.md`, and
  `tmp/relative_kls_chart/survivor_trace/semantic_check/REPORT.md`.
  Replay with
  `python3 tmp/relative_kls_chart/verify.py` and
  `python3 tmp/relative_kls_chart/verify_top_full_gb.py`; replay the extraction
  gate with
  `python3 tmp/relative_kls_chart/verify_transform_extraction_gate.py`, and
  replay the corrected survivor circuit with
  `python3 -u tmp/relative_kls_chart/survivor_trace/verify_survivor_trace.py`
  followed by
  `python3 -u tmp/relative_kls_chart/survivor_trace/evaluator/verify.py --manifest tmp/relative_kls_chart/survivor_trace/evaluator/manifest.json`;
  replay the degree-five semantic layer with
  `/opt/homebrew/bin/python3 -u tmp/relative_kls_chart/survivor_trace/semantic_check/verify.py`.
  A complete triangular cover of the base hyperplane `p3=0` also hit its
  bounded stop: all three 14/13/12-variable charts timed out in degree seven.
  A deterministic coordinate-nondegenerate projective line had the same
  first-matrix sizes and densities, so its solver was not launched.  It was
  not proved generic relative to the unknown exceptional image.  These are
  strict non-verdicts: finite
  projection and even a dimension bound remain unproved.  Replay with
  `python3 tmp/relative_kls_hyperplane/verify.py` and
  `python3 tmp/relative_kls_hyperplane/verify_line_pilot.py`.
- The degree-free KLS connection has exactly the frame and trace-branch polar
  divisors (away from `t3=0`).  Its norm determinant is
  \(2^{10}3^8 11^{12}D\Delta/(5^4t_3^{24})\).  The general residue leading
  systems are now solved and are positive-dimensional rational determinant
  hypersurfaces, not local obstructions.  In addition to the earlier 140
  one-parameter families, all 60 smallest constant simultaneous `P2`
  modifications are excluded exactly.  The complete two-fibre first-jet
  screen also excludes all `60*4*3=720` projective families in which one of
  the three coefficients acquires one slope `d*t_q`; every frame triple,
  base direction, and coefficient role is computed directly.  The stronger
  `P5` screen gives all three coefficients independent slopes in one common
  base direction and excludes all `60*4=240` projective families.  The entire
  constant `P4` is now excluded as well, and the simultaneous constant
  centralizer is scalar.  The canonical `P8` two-coordinate family for
  triple `(0,1,2)`, directions `(t3,t6)`, and three regular fibres is also
  completely empty: seven Macaulay2 charts, one exact msolve chart, and the
  last point give a complete projective cover.  Do not scale this into more
  three-support sweeps.  The local KLS determinant hypersurface has dimension
  19, while all four-direction first jets with fixed three-coordinate support
  have dimension at most 10; `P3/P5/P8` families cannot be exhaustive.  The
  first full-support `P9` chart hit the 700 MiB stop with no verdict.  A new
  structural theorem rules out the formerly suggested bound on *all* KLS
  solutions.  The installed primitive quartic covariant defines a finite
  surjective `G`-endomorphism `c:P4->P4` with `c^*O(1)=O(4)` and degree 256.
  Precomposing any primitive KLS solution by `c` preserves the Jacobian rank
  drop and multiplies its saturated degree by four.  Thus one solution would
  generate solutions in degrees `4^n d`; an all-solutions pole/degree bound is
  false in the positive case and vacuous in the negative case.  The same
  packet gives a rank-1024 finite free `C`-adic decomposition with residue
  degrees at most 15, but no Jacobian descent across its residue terms.  The
  valid successor is a theorem bounding one *minimal* KLS solution (an
  effective essential-dimension statement), or a direct global
  foliation/line-subsheaf argument.  Replay with
  `python3 tmp/kls_divisor_ansatz/verify.py` and
  `python3 -u tmp/kls_residue_next/verify.py`, then
  `python3 tmp/kls_first_jet_two_fiber/verify_manifest.py`,
  `python3 tmp/kls_first_jet_two_fiber/verify.py --ledger-only`,
  `python3 tmp/kls_first_jet_two_fiber/verify_manifest_p5.py`, and
  `python3 tmp/kls_first_jet_two_fiber/verify_p5.py --ledger-only`, then
  `python3 -u tmp/kls_first_jet_three_fiber/verify_combined_p8.py`,
  `python3 -u tmp/kls_structural_audit/verify.py`, and
  `/opt/homebrew/bin/python3 -u tmp/kls_structural_successor/verify.py`.
- On the characteristic-23 soluble `xCD` control, \(Q=[H-3O]\), the
  irreducible nonzero \(E[3]\) field, and the genuine nonzero representative
  \(G(Q)\) are explicit.  Translation interpolation still times out before a
  matrix and is no longer the critical control task.  This validates the
  conventions but does not transfer the control class to characteristic
  zero.  Replay with
  `python3 tmp/xcd_control_next/verify.py`.
  The determinant-free generic construction has now passed the full Cech
  coordinate gate.  A replay-locked DAG contains the monic degree-nine
  flex eliminant, first subresultants, their inverse, and the universal flex
  point over the rank-nine algebra.  A segmented extension contains
  `Q'^-1` and all 81 coordinates of the diagonal idempotent.  A typed
  nested-etale circuit executes
  `lambdaSharp=(lambda+eDelta)^-1*(1-eDelta)` and constructs the actual Cech
  `X,Y`; rank-81 replay checks the short curve, 3-division, diagonal, and
  swap identities.  The outputs are typed whole-`K_proj` algebra nodes, not
  distributed Hironaka coordinates.  The raw determinant ratio fails to
  descend (rank `108`, augmented rank `109`), but the corrected unit
  scalar-cochain normalization succeeds.  The exact geometric descent lemma
  and a selected `9 x 9` solve produce a generic-open rational representative
  `alpha_R=det(M0)/ell(M0)^3` modulo cubes.  The `GF(101)` full-81 calculation
  corroborates rather than proves the generic descent.  Cubic scaling and
  orientation agree.  The saved representative retains
  `alpha_R(O)=71^-3` and fixes `z_O=71`; equivalently, cube-normalizing the
  identity coefficient to one would fix `z_O=1`.  The affine first-descent
  unit chart is now assembled: it has ten variables, nine cubics over the
  exact `QQ`-model, and the condition `Norm_R8(z_star)!=0`.  Its
  `3^8`-sheet covering scheme has 729 geometric components, each a
  degree-nine 3-covering, so do not run an algebraic-closure emptiness solve.
  A `K_proj,QQ` point suffices positively after base change, but a negative
  result must hold over
  \(K_{\mathrm{proj},\mathbf C}=K_{\mathrm{proj},\mathbf Q}
  \otimes_{\mathbf Q}\mathbf C\).  CFOSS identifies a
  distinguished base-defined component that is isomorphic as a covering to
  the original projective `xCD` cubic; use that cubic rather than extracting
  or closing all 729 components.  Exact Hensel pilots rule out every prime
  component of `A=0`, `B=0`, and `C=0` as a local-obstruction place.  The
  degree-120 discriminant packet now rejects every one of its height-one
  components as well: its pullback is squarefree and gauge-coprime, every
  normalized discriminant valuation is one, and Poonen--Stoll gives a
  residue-rational node which lifts to a local point.  The two motivated
  smooth-reduction primes `f5=0` and `f6=0` are geometrically integral and
  have alternate unit gauges.  Their coordinate vertices and every complete
  invariant-polynomial `x,C,D` ansatz through total degree 15 are empty.  This
  is not a local obstruction; the next negative gate is their actual residue
  3-descent or a relative unramified 3-Selmer calculation.  Do not use
  arithmetic-prime or `QQ`-only Selmer
  results as negative evidence, enter a splitting field, or expand an `81 x 81`
  determinant.  Even a nonpoint theorem for this component would close only
  this `xCD` plane construction, not the headline.  Replay with
  `python3 -u tmp/xcd_generic_cech_next/verify_generic_dag.py` and
  `python3 -u tmp/xcd_generic_cech_next/verify_cech_extension.py`, then
  `python3 -u tmp/xcd_generic_cech_next/verify_typed_cech.py`,
  `python3 -u tmp/xcd_generic_cech_next/verify_alpha_corrected.py`, and
  `python3 -u tmp/xcd_first_descent_next/verify.py`, then
  `python3 -u tmp/xcd_arithmetic_next/verify.py`,
  `python3 -u tmp/xcd_discriminant_divisor/verify.py`, and
  `/opt/homebrew/bin/python3 -u tmp/xcd_gauge_divisors/verify.py`.
- The first structural residue audit at `f6=0` does not produce a local
  obstruction, but it replaces an open-ended point sweep by a precise
  divisor-class gate.  On the pullback to `H6=V(f6)`, the residue is a
  relative cubic in
  `P_H6(O(-1) direct_sum O(-4) direct_sum O(-5))`; a negative result would
  follow if the quotient-relative horizontal divisor-degree image were
  exactly `3Z`.  The pullback total cubic space is now proved integral and
  normal.  A deterministic plane slice modulo `998244353` has boundary gcd
  one and squarefree resultant of full degree `6*120=720`; hence
  `V(f6,Delta)` is geometrically reduced in characteristic zero.  A separate
  certified six-coefficient computation excludes zero cubic fibres, giving
  flatness.  The total space is `S2`, while generic smoothness and
  Poonen--Stoll at every valuation-one vertical discriminant prime give
  `R1`.  Exact good-reduction calculations also exclude every triple-line
  fibre, while the five coordinate fibres are `a*c^2`: blanket fibrewise
  geometric reducedness and absolute factoriality remain false.  No general
  Grothendieck--Lefschetz/Noether--Lefschetz theorem applies to this fixed
  special member.  The first codimension-three class maps are now exact.
  `Sing(H6)` is one 60-point orbit of `A3` points, with Jacobian-scheme length
  `60*3=180`.  At the simple fibre line the completed and henselian base map
  on class groups is an isomorphism.  At the doubled line the total local
  ring has four henselian branches and the map is
  `Z -> Z^3`, `1 |-> (1,1,0)`, with cokernel `Z^2`.  Thus the hoped-for
  completed-local-surjectivity/factoriality shortcut is false.  Exact
  enumeration gives full stabilizer `C11`; it fixes all four branches, so the
  invariant henselian defect still has rank two.  The two within-pair branch
  differences span only an index-four sublattice, so primitive individual
  branch patterns cannot be discarded.  The recent algebraic splitting lemma
  upgrades the factors from formal to henselian, but individual Zariski
  descent and globalization remain unproved: height-one contraction is
  guaranteed, while re-extension may recover a grouped sum of conjugate
  branches.  The next structural gate is therefore the image of the global
  class group in the four boundary valuations of the normalized
  `G`-equivariant weighted Rees model, followed only then by horizontal fibre
  degree.  That local decision interface is now exact.  The
  section-preserving weighted Rees family has weights
  `(x,y,z,t,c)=(2,2,2,1,1)`, survives at both `s=0` and `s=1`, and has special
  hypersurface `u*v+g4(t,c)`.  Over the quartic splitting field its four
  primitive branch modules have explicit `2 x 2` matrix factorizations.
  Individual descent is equivalent to a graded, `s`-torsion-free rank-one
  reflexive Rees lattice whose special reflexive hull is primitive `I1` or
  `I3`.  The displayed `2 x 2` lift is only a sufficient defect-free positive
  ansatz after algebraization across `s=1`, not a necessary test: a general
  special fibre can have finite-length defect.  No lift has been found or
  excluded.  Replay the normality and local/globalization packets with
  `/opt/homebrew/bin/python3 -u tmp/xcd_total_normality/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/xcd_local_class_defect/verify.py`, and
  `/opt/homebrew/bin/python3 -u tmp/xcd_class_globalization_next/verify.py`;
  replay the Rees descent gate with
  `/opt/homebrew/bin/python3 -u tmp/xcd_zariski_descent_gate/verify.py`;
  replay the earlier residue packet with
  `/opt/homebrew/bin/python3 -u tmp/xcd_residue_class_gate/verify.py`.
  Its optional `--full` Gröbner recomputation measured about 0.95 GB RSS and
  is outside the 700 MiB execution gate; the default replay checks frozen
  outputs and exact symbolic identities but does not independently rerun
  those bases.  The normality replay itself independently reruns only the
  smaller zero-fibre basis and stays below the cap.  See
  `tmp/xcd_total_normality/REPORT.md`,
  `tmp/xcd_local_class_defect/REPORT.md`, and
  `tmp/xcd_class_globalization_next/REPORT.md`, together with
  `tmp/xcd_zariski_descent_gate/REPORT.md`.
- The Problem F involution import has an exact correction packet.  For every
  involution, `(dim E_plus,dim E_minus)=(3,2)`, the plus-plane section is a
  smooth genus-one cubic, and `F|E_minus=0`, so the minus fixed locus is a
  whole projective line.  The order-12 centralizer has no fixed point on
  `X`.  Therefore each plus-plane is necessarily a codimension-two base
  component; even transverse order is impossible, while odd order gives a
  nonconstant dominant normal map to the fixed line and causes no immediate
  contradiction.  Replay with
  `/opt/homebrew/bin/python3 tmp/involution_exceptional_divisor/verify.py`.
- The first global response to Fable's comment is now exact.  The reduced
  55-plane arrangement has 55 triple lines and 121 multiple points; over the
  split good fibre its scalar ideal first appears in degree 15, with
  dimensions `42,171,412,797` in degrees 15--18.  The complete equivariant
  kernels and their higher-center landing equations give the degree-24
  cutoff above.  At the 66 five-plane points and 55 seven-plane points the
  stabilizers are respectively `D10` and `D12`, and all 121 points lie off
  the Klein cubic.  The conjectured local symbolic presentations are now
  proved and independently audited for every order `m`: at a `D10` point the minimal edge is
  `Sym^m<a,c5>` in degree `3m`, while at a `D12` point it is generated by
  `a` and `b=a*c6` of symbolic weights one and two.  For odd `m` both minimal
  layers are reflection-sign, a character absent from `W`, so every
  arrangement covariant has point order at least `3m+1` at all 121 points.
  The next layer already contains `W`, so this does not iterate by character
  theory alone.  The complete scalar line/point overlap map is surjective in
  the audited degrees 5--23 and separately in degree 25.  More directly, a
  compact induced `W`-block constructs over split `F_67` actual
  higher-compatibility quotient bases of dimension 16 in every degree
  18--29.  All nine tested `f3` maps,
  all seven tested `f5` maps, and the first
  `f11:D_18[W] -> D_29[W]` map are isomorphisms over `F_67`.  The missing
  ordinary support theorem is now proved: the defect is a skyscraper on the
  121 multiple points, of scalar length 13 at every point and with local
  `W`-multiplicities 9 on the `D10` orbit and 7 on the `D12` orbit.
  Derksen--Sidman regularity gives `dim D_d[W]=16` for every `d>=54` in
  characteristic zero and the split good fibre; degrees 30--53 remain a
  finite gap.  This ordinary theorem does not transfer to symbolic order:
  the first exact symbolic normalization has nonzero `A4`-equivariant
  cokernel supported along each entire triple line.  The scalar ideal,
  the equivariant kernel, and odd symbolic powers remain distinct objects.
  The symbolic compatibility packet and a from-scratch audit now fix the
  exact boundary: `I^(m)/I^(m+2)` injects into the direct sum of plane-normal
  blocks; one first imposes the generic triple-line equalizers and only then
  takes the residual `D10`/`D12` point quotients.  No globally exact
  four-term line/point complex or low-degree global-section formula has been
  proved.  The direct plane-jet map nevertheless gives
  `[(I^(3)/I^(5))_d tensor W]^G=0` for `25 <= d <= 31`; full rank in the
  split fibre promotes this bounded statement to characteristic zero.
  The split-`F_67`, `m=3`, first line survivor has length 48 before point
  compatibility, but its assembled total-degree-19 boundary at a `D12`
  point has rank `8/8` and is empty.  This is one associated-graded stratum,
  not `(ID_3)` or a characteristic-zero theorem.

  Over the same split fibre, the first compact `m=1` complex is also
  calibrated in degree 25:
  `673 --line rank 309--> 364 --point rank 305--> 59`, and the final
  59-space is literally the direct global `K1/K3`.  Its landing filtration
  is `59 -> 43 -> 6 -> 0`, with ranks `16,37,6`.  The available point
  initials do not cut the unresolved 37-dimensional leading common-line
  quotient.  The full order-four system is now an exact rank-842 cubic
  space, normalized to 833 monic relations plus a nine-equation
  determinantal tail.  Thus degree 25 remains open.  The precise all-degree
  targets are the finite irrelevant-saturation module and uniform relative
  border/Fitting landing detection on
  `[(I^(m)/I^(m+2))_d tensor W]^G`; more raw scalar degrees and another
  finite `V4` transition table do not address it.  Replay with
  `/opt/homebrew/bin/python3 -u tmp/plane_arrangement_hilbert/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/d12_block_attack/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/local_symbolic_rees/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/higher_compatibility_regularity/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/ordinary_defect_support/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/symbolic_compatibility_complex/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/symbolic_compatibility_complex_independent_audit/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/m3_line_point_boundary/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/m3_line_point_boundary_independent_audit/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/m1_compact_degree25/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/m1_compact_degree25_independent_audit/verify.py`, and
  `/opt/homebrew/bin/python3 -u tmp/m1_compact_degree25_filtration_independent_audit/verify.py`,
  together with the degree-22--25
  verifiers above.
- The July 2026 level-11 theta/Schwarz construction uses the correct
  projective representation but does not lie on the Klein cubic:
  \(F(H\Phi_{11})=\xi_{44}^5u^{11}+O(u^{99})\).  It is also outside the
  classical Hessian-singular model.  Close this as a headline path.  Replay
  with `python3 tmp/theta11_test/theta11_test.py`.

The local ignored `tmp/` tree is now about 6.7 GB.  The new material is
dominated by a 647 MiB gated raw-coordinate Cech prototype, the 373 MiB full
top Groebner basis, the 351 MiB degree-12 survivor circuit, the 1.3 GiB local
Julia/Groebner.jl installation and pilot, the degree-12 hyperplane-chart
inputs, the degree-16 probe inputs, and the degree-16--25 arrangement and
landing packets.  The accepted segmented generic DAGs include files of about
95 MB, 62 MB, and 39 MB; the typed Cech `X,Y` extension is under 1 MB.  They remain under
`tmp/` and therefore do not enlarge GitHub history unless deliberately
force-added.  The curvature-safe `P^19` packet adds 103 MiB locally, of which
90 MiB is streamed replay chunks and 7.6 MiB is the compressed certificate.

## Strongest proved progress

1. [RESOLUTION.md](RESOLUTION.md) proves

   \[
   C\text{ is }G\text{-unirational}
   \quad\Longleftrightarrow\quad
   \operatorname{ed}_{\mathbf C}(G)=3.
   \]

   Thus a negative answer is equivalent to essential dimension four. The
   proof uses Prokhorov's two-model classification, the twisted Pfaffian
   bridge, its index-at-most-two Brauer class, and quadratic descent for
   points on cubics.

   Canonically, if \(C_{\rm gen}\) is the generic projective-torsor twist over
   \(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\), then essential dimension three
   is equivalent to \(C_{\rm gen}(K_{\rm proj})\ne\varnothing\), and value four
   is equivalent to emptiness. Every Klein twist has index one from the orbit
   degrees \(60,132,165,220\), but no audited theorem turns that zero-cycle
   into a point. See `tmp/step4_essential_dimension/REPORT.md`.

2. `certificates/` gives exact cyclotomic matrices, checks the complete
   660-element action and Klein cubic invariance, and computes exact Molien
   dimensions.

3. The primitive covariants \(x,C,D,E,K\) of degrees \(1,4,5,6,7\) form a
   generic frame. Their determinant is \(-295136920\) at
   \((-2,-2,-2,-2,-1)\). Hence

   \[
   M=[x\ C\ D\ E\ K]
   \]

   explicitly trivializes the generic twisted ambient five-space and writes
   its cubic as \(F(Ma)=0\) over \(\mathbf C(W)^G\).

   Every one of the ten frame coordinate lines has also been excluded: the
   multivariate polynomial \(F(U+tV)\) has absolutely irreducible good
   reduction over \(\mathbf F_2\) and \(\mathbf F_8\). Hence its cubic in
   \(t\) is irreducible over \(\mathbf C(W)\) and has no rational-function
   root. Thus a frame point must use at least three coordinates.

4. Exact characteristic-zero and good-reduction certificates exclude every
   homogeneous polynomial self-covariant \(W\to W\) landing in \(C\) through
   degree **24**. Degree ten and eleven use dynamically regenerated
   Macaulay2 ideals. Degree twelve reconstructs a 16-dimensional basis and
   143 independent sampled necessary landing cubics; an exact `msolve`
   Gröbner basis has quotient Hilbert function zero in degree five. Degree
   thirteen uses the quotient \(M_{13}/fM_{10}\): 48 necessary cubics force
   the scalar plane, after which exact degree-ten and tangent Hilbert
   functions kill both lifts. Degree fourteen similarly reduces the
   14-dimensional quotient to its scalar line with twelve unit
   Rabinowitsch systems; its two 12-variable branch Hilbert functions vanish
   in degree five. Degree fifteen has a 16-dimensional quotient whose
   complete rank-75 landing system is supported on the scalar four-plane;
   all twelve normal charts are unit ideals, and both 16-variable lift
   branches vanish projectively in degree five.  The forced-plus-plane
   restriction is injective in degree 16; its complete special-fibre kernels
   in degrees
   17--21 have dimensions `2,3,7,11,16`, and their full landing loci are
   empty.  Degree 22 is reduced by exact common-line and even minus-line maps
   from `25` variables to `12` and then `4`, where the necessary cubics span
   all `20/20` coefficient monomials.  Degree 23 reduces `34 -> 20` and is
   excluded on a complete 20-chart cover by 392 necessary cubics.  Degree 24
   has a unique first-jet-kernel line of exact even order two; the remaining
   fixed-locus conditions reduce `44 -> 29 -> 20`, where 484 necessary cubics
   exclude every projective chart.  Independent reconstruction audits passed
   for degrees 23 and 24.  Degree 25 is the first bounded unknown. See
   `tmp/structural_degree13/REPORT.md`,
   `tmp/degree14_structural/REPORT.md`, and
   `tmp/degree15_structural/REPORT.md`, together with
   `tmp/degree22_compression/REPORT.md`,
   `tmp/degree23_common_line_landing/REPORT.md`, and
   `tmp/degree24_landing/REPORT.md`.

5. All ten three-column frame sections are smooth geometrically integral
   plane cubics. A complete good-reduction audit excludes every
   invariant-polynomial landing ansatz in those planes in total degrees
   **11--14**. This closes factor/node shortcuts and a finite degree range; it
   does not show that the plane cubics lack \(K_0\)-points. Their degree-nine
   flex schemes are also geometrically irreducible, so none has a rational
   flex; an ordinary rational point can still exist without one.

6. The all-degree self-covariant module becomes exactly free on
   \(x,C,D,E,K\) after localizing at their determinant. Thus a full module
   presentation leaves precisely the same generic cubic \(\Phi=0\); it does
   not create a finite degree bound.  After normalizing by
   \(\tau=f_3^2/f_5\), the KLS problem is exactly the degree-free equation
   \(\det[a,\nabla_1a,\ldots,\nabla_4a]=0\) on
   \(\mathbf P^4(\mathbf C(\mathbf P(W))^G)\) for the flat connection defined
   by the generic frame.  No solution or universal-nonvanishing theorem is
   known.  The field arithmetic needed to make this explicit is certified:
   the five primaries are algebraically independent, Adler's twelve
   secondaries form a free Hironaka basis, the full multiplication table is
   checked, and the \(\tau\)-normalized degree-12 model implements exact
   addition, inversion, trace, and norm.  The four \(\Gamma_r\) are compiled
   as exact arithmetic circuits backed by 121 characteristic-zero reduction
   identities.  Their exact specialization verifies the horizontal rank 48,
   frame-determinant inverse, all 100 matrix entries, all twelve basis
   derivatives, and Leibniz on 78 products.  Rank certificates exclude 121
   projective constant and 440 ordered Hironaka-linear ansätze, with no
   survivor; the universal PDE remains open.  All 15 canonical
   gradient-cross-product covariants from the explicit
   invariants of degrees 3--9 also fail to land. See
   `tmp/kproj_arithmetic/REPORT.md`, `tmp/kproj_connection/REPORT.md`,
   `tmp/covariant_module/REPORT.md`, and
   `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`.

7. The nonsplit Pfaffian branch has been reduced to five simultaneous
   quaternionic-Hermitian isotropy equations on \(D^3\). The ambient
   \(D\)-projective plane is rational, but the section has no automatic point,
   and its quaternion class remains nonsplit over its function field. Matched
   polynomial covariants into the \(F_{14}\) cone are excluded only through
   degree **15**. The full 80-dimensional degree-16 space and 1,313 necessary
   quadrics are reconstructed, but the exact solver timed out without a
   leading ideal. There is no all-degree cutoff; degree 16 remains open for
   the Pfaffian target.

8. Every complex orbit on \(C\) has length at least 60. Exact chord and
   subgroup-lattice checks show that the natural \(C_{11},C_5,V_4,C_3\)
   fixed configurations cannot be collapsed by an equivariant binary
   residual-intersection tree. The 220-point orbit also has no containing
   divisor through degree four, and its first complete-intersection link only
   increases degree. These are finite-construction no-gos, not an exclusion
   of continuous covariants.

9. Let \(V_6\) be the Schur representation of
   \(\operatorname{SL}_2(11)\). Any rational \(G\)-map
   \(\mathbf P(V_6)\dashrightarrow C\) is automatically dominant and solves
   the headline: every twisted source has index at most two, and a resulting
   quadratic point on the cubic descends by third intersection. Complete
   constant-coefficient landing loci are empty in degrees **4, 6, 8, 10**.
   The exact degree-10 ideal has rank 470 and Hilbert function
   \([1,21,231,1301,889,0]\). Arbitrary rational coefficient ratios are
   described exhaustively by a five-vector degree-eight frame. Its full
   degree-six pencil and all ten rational coordinate lines are excluded.  On
   the ten ternary planes, all invariant-coefficient ansätze through degrees
   0, 4, 6, 8, and 10, the degree-12 space \(S_{12}\), and all 90 spaces
   \(S_{12}+\langle p_j\rangle\) are excluded.  One two-direction gate is
   also empty; its measured cost stopped the other 359.  Unrestricted ternary
   and larger rational supports remain open. In degree 12 the
   16-dimensional decomposable sector \(D_{12}^{V_6}\), all
   decomposable-plus-one-primitive
   slices, and all 496 decomposable-plus-two-primitive slices are excluded;
   equivalently, a landing point needs at least three primitive coordinates
   in that fixed quotient basis. In a fixed complete 48-vector Reynolds basis every
   coordinate support of size at most five is excluded. Quadratic-extension
   unisolvence now proves that the complete characteristic-23 landing-equation
   span has rank 1,124, and a hash-verified 1,124-row base-field solver input
   is installed. Its 600-second exact solve timed out during the second
   degree-four matrix with a zero-byte leading file. This equation-rank
   theorem is not a projective-emptiness theorem; degree 12 remains open. A
   terminal audit now proves that further characteristic-23 sampling cannot
   enlarge the span, that the saved F4 rounds contain no resumable basis, and
   that all 48 standard affine charts retain rank 1,124 in their cubic leading
   parts. Exact probes on charts 0 and 47 reproduce the same
   \(36595\times244805\) degree-four bottleneck. Hence no identical retry or
   standard-chart sweep is justified without a structural or solver-level
   change.  The transformed decomposable-plus-primitive gate \(p_0=1\) also
   times out, at `44328 x 245460` on a worse trajectory, so the other 31
   transformed charts are stopped.  The length-439 decomposable quotient is
   only an anchor for relative elimination with exceptional strata, not a
   mixed-locus theorem. See
   `tmp/projective_source/REPORT.md`,
    `tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`,
    `tmp/schur_ternary_planes/one_primitive/REPORT.md`, and the reports
   under `tmp/projective_source_degree12*` and
   `tmp/step4_degree12_solver_terminal/REPORT.md`.

10. Kraft--Loetscher--Schwarz give the exact alternative
    \(\operatorname{ed}(G)=3\) iff a nonzero homogeneous self-covariant
    \(W\to W\) has identically zero Jacobian. Complete exact checks show every
    such covariant through degree **11** is dominant; no degree cutoff is
    known. The degree-11 certificate reconstructs the full 12-dimensional
    space, proves same-point unisolvence on all 509 degree-50 invariants,
    obtains the complete rank-496 Jacobian-quintic span, and finds unit ideals
    on all twelve charts of \(\mathbf P^{11}\). See
    `tmp/degree10_jacobian/REPORT.md` and
    `tmp/degree11_jacobian/REPORT.md`.  Degree twelve is reconstructed
    completely: \(\dim M_{12}=16\), and the universal coefficient span has
    rank 721 in 15,504 quintic monomials.  In the exact 12+4
    decomposable/primitive splitting, both pure projective strata are empty.
    The first direct mixed chart timed out at `104836 x 166810`, so the other
    three were not launched.  Relative specialization has since proved that
    the fiber `[1:1:1:1]` is a unit ideal.  The empty decomposable center and
    proper projection imply that the mixed incidence is empty on a nonempty
    open subset of primitive `P^3`, also in characteristic zero.  Degree
    twelve remains open only on a proper closed exceptional locus.  The map
    `mu7: A^65611 -> A^50388` is an exact degree-seven truncation, not a
    presentation of that locus.  The fixed top ideal has colength `9,193`
    and no degree-seven standard monomials, but no explicit relative
    annihilator is installed. See
    `tmp/degree12_jacobian/REPORT.md`,
    `tmp/degree12_jacobian_structural/REPORT.md`, and
    `tmp/relative_kls_chart/TOP_IDEAL_REPORT.md`.
    The exact all-degree replacement for blind degree scans is the
    flat-connection determinant in item 6.
    Voisin's current construction proves \(C^{[3]}\) is \(G\)-very-versal,
    but pulling the universal marked cover back along her parameterization
    gives a source birationally fibered over \(C\) and is therefore circular
    for the missing point. See
    `tmp/ed_binary_attack/REPORT.md`.

11. The `xCD` frame plane has an exact characteristic-zero ternary cubic,
    universal \(c_4,c_6,\Delta\), and all ten coefficients evaluated in the
    certified \(K_{\rm proj}\) arithmetic.  The genuine generic rank-nine
    \(E[3]\) algebra
    \(\mathcal R=\operatorname{Map}_{K_{\rm proj}}(E[3],\overline K_{\rm proj})\)
    and normalized group/difference/Kummer functions are
    installed and kept distinct from the flex torsor.  At \(s=1\), the true
    degree-12 three-flex-line algebra has orbit degrees `4+8` and satisfies
    all incidence and norm identities, but the rational flex makes this
    class trivial.  A separate low-height coordinate-line control has rational
    point \(O=[1:0:1]\) and irreducible flex cover, proving a nonzero class
    abstractly equal to \(\delta([H-3O])\), where \(H\) is a hyperplane
    section.  The tangent residual now gives exact coordinates for
    \(Q=[H-3O]\) in the saved Jacobian model, and the irreducible nonzero
    \(E[3]\) field together with \(G_T(Q)\) replays as the genuine nonzero
    first-Kummer representative.  On the generic side, replay-locked DAGs
    now install the monic flex eliminant, universal point over the rank-nine
    flex algebra, and all 81 coordinates of the diagonal idempotent.  A typed
    quotient-algebra circuit now gives the tangent inverse off the diagonal
    and the actual Cech `X,Y`, with the curve, 3-torsion, diagonal, and swap
    identities checked.  A unit scalar-cochain normalization of the induced
    projective translation lift now gives a generic-open rational rank-nine
    first-Kummer representative `alpha_R` modulo cubes.  The actual equation
    `G(P)=alpha_R*z^3` is assembled as a ten-variable, nine-cubic affine unit
    chart.  Its `3^8` sheets split geometrically into 729 degree-nine
    components.  Its distinguished base-defined component is isomorphic as a
    covering to the original projective `xCD` cubic.  The remaining task is a
    `K_proj,C`-rational point or a geometric-divisor obstruction on that
    cubic; the pure-coefficient places `A=0`, `B=0`, and `C=0` are already
    locally soluble.
    Generic true second descent still needs the
    twisted three-flex-line algebra, line forms, and constants. See
    `tmp/kproj_arithmetic/REPORT.md`, `tmp/xcd_genuine_descent/REPORT.md`,
    `tmp/xcd_control_next/REPORT.md`,
    `tmp/xcd_generic_cech_next/REPORT.md`, and
    `tmp/xcd_first_descent_next/REPORT.md`, and
    `tmp/xcd_arithmetic_next/REPORT.md`.

## Verification

The initial `certificates/...` commands below form the portable checked-in
suite. Every later command under `tmp/...` requires the intentionally ignored
about 6.7 GB local artifact tree and will not be available in a fresh clone.

From this directory run:

```sh
python3 certificates/exact_weil_check.py
python3 certificates/exact_molien.py
python3 certificates/exact_covariants_check.py
python3 certificates/septic_landing_check.py
python3 certificates/generic_covariant_basis_check.py
python3 certificates/generic_frame_lines_check.py
python3 certificates/generic_frame_planes_specialization.py
python3 certificates/generic_frame_planes_check.py 11 14
python3 certificates/flex_cover_check.py
python3 certificates/subgroup_secant_check.py
python3 certificates/subgroup_orbit_check.py
python3 certificates/orbit_hilbert_check.py
python3 certificates/modular_covariant_scan.py
python3 certificates/degree10_m2_check.py
python3 certificates/degree11_m2_check.py
python3 certificates/degree12_msolve_check.py --threads 4 --timeout 120
python3 tmp/projective_source/character_scan.py
python3 tmp/projective_source/landing_scan.py
python3 tmp/projective_source/degree6_rational_root.py
python3 tmp/projective_source/verify_degree6_geometric_factor.py
python3 tmp/projective_source/primitive_degree12/verify.py
python3 tmp/ed_binary_attack/check_projective_pencil_skip_factor.py
python3 tmp/projective_source/degree8_m2.py
python3 tmp/projective_source/degree10_msolve_verify.py
python3 tmp/projective_source/degree8_rational_frame.py
python3 tmp/projective_source/degree8_frame_line_probe.py
python3 tmp/projective_source_degree12/verify_artifacts.py
python3 tmp/projective_source_degree12_structural/verify_decomposable.py
python3 tmp/projective_source_degree12_structural/verify_primitive_one_slices.py
python3 tmp/projective_source_degree12_structural/verify_primitive_two_slices.py
python3 tmp/projective_source_degree12_support/audit_coordinate_support.py \
  --verify --batch-size 257
python3 tmp/projective_source_degree12_extension_independent/verify.py
python3 tmp/projective_source_degree12_extension_independent/landing_verify.py
python3 tmp/projective_source_degree12_extension/verify_landing.py
python3 tmp/projective_source_degree12_chart_probe/audit_and_probe.py --verify
python3 tmp/projective_source_degree12_primitive_chart/verify.py
python3 tmp/projective_source_degree12_primitive_chart/analyze_relative.py
python3 tmp/schur_ternary_planes/verify.py
python3 tmp/schur_ternary_planes/one_primitive/verify.py
python3 tmp/d12_solver_strategy/verify.py
python3 tmp/step4_degree12_solver_terminal/verify_terminal.py
python3 tmp/ed_binary_attack/projective_pencil_root_test.py --skip-factor
python3 tmp/ed_binary_attack/covdim_dominance_scan.py
python3 tmp/ed_binary_attack/covdim_degree8_scan.py
python3 tmp/degree10_jacobian/verify_outputs.py
python3 tmp/degree11_jacobian/verify_outputs.py
python3 tmp/degree12_jacobian/verify_outputs.py --require-gate
python3 tmp/degree12_jacobian_structural/verify.py
python3 tmp/degree12_jacobian_structural/verify_decomposable_cover.py
python3 tmp/degree12_jacobian_structural/verify_mixed_gate.py
python3 tmp/ed_binary_attack/verify_all_degree_module_pde.py
python3 tmp/step4_essential_dimension/verify_reductions.py
python3 tmp/kproj_arithmetic/verify.py
python3 tmp/kproj_connection/verify.py
python3 tmp/kls_divisor_ansatz/verify.py
python3 -u tmp/kls_residue_next/verify.py
python3 tmp/kls_first_jet_two_fiber/verify_manifest.py
python3 tmp/kls_first_jet_two_fiber/verify.py --ledger-only
python3 tmp/kls_first_jet_two_fiber/verify_manifest_p5.py
python3 tmp/kls_first_jet_two_fiber/verify_p5.py --ledger-only
python3 -u tmp/kls_first_jet_three_fiber/verify_combined_p8.py
python3 -u tmp/kls_structural_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_structural_successor/verify.py
python3 tmp/kls_full_support_p9_msolve/verify_p9.py --ledger-only
python3 tmp/relative_kls_chart/verify.py
python3 tmp/relative_kls_chart/analyze_exceptional.py
python3 tmp/relative_kls_chart/analyze_top_ideal.py
python3 tmp/relative_kls_chart/verify_top_full_gb.py
python3 tmp/relative_kls_chart/verify_degree_lowering_plan.py
python3 tmp/relative_kls_chart/verify_transform_extraction_gate.py
python3 -u tmp/relative_kls_chart/survivor_trace/verify_survivor_trace.py
python3 -u tmp/relative_kls_chart/survivor_trace/evaluator/verify.py \
  --manifest tmp/relative_kls_chart/survivor_trace/evaluator/manifest.json
/opt/homebrew/bin/python3 -u \
  tmp/relative_kls_chart/survivor_trace/semantic_check/verify.py
python3 tmp/relative_kls_chart/bihomogeneous_pilot.py
python3 tmp/relative_kls_hyperplane/verify.py
python3 tmp/relative_kls_hyperplane/verify_line_pilot.py
python3 tmp/theta11_test/theta11_test.py
python3 tmp/fano14_degree12/degree12_msolve.py \
  --degree 15 --verify-leading tmp/fano14_degree12/leading15.out
python3 tmp/structural_degree13/verify.py
# Optional expensive replay of the exact solvers:
python3 tmp/structural_degree13/verify.py --rerun-msolve
python3 tmp/degree13_step2/verify_certificate.py
python3 tmp/degree13_opt/verify_q67_terminal.py
python3 tmp/degree14_feasibility/audit.py
python3 tmp/degree14_structural/verify.py
python3 tmp/degree15_structural/verify.py
python3 -u tmp/degree16_landing_probe/verify.py
python3 tmp/degree16_landing_probe/verify_off_k_residual_audit.py
python3 tmp/degree16_landing_probe/verify_off_k_t_fiber_attack.py
/opt/homebrew/bin/python3 tmp/degree16_exceptional_search/verify.py --skip-msolve
python3 tmp/fano14_degree16/verify_artifacts.py
python3 tmp/xcd_invariant_field/presentation_audit.py
python3 tmp/xcd_invariant_field/f10_probe/verify.py
python3 tmp/xcd_descent_algebra/verify_xcd.py
python3 tmp/xcd_descent_math/verify_fiber_flex_algebra.py
python3 tmp/xcd_descent_math/verify_hesse_norms.py
PYTHONPATH=tmp/xcd_genuine_descent python3 tmp/xcd_genuine_descent/verify.py
python3 tmp/xcd_nonzero_kummer/verify.py
python3 tmp/xcd_control_next/verify.py
python3 -u tmp/xcd_generic_cech_next/verify.py
python3 -u tmp/xcd_generic_cech_next/verify_generic_dag.py
python3 -u tmp/xcd_generic_cech_next/verify_cech_extension.py
python3 -u tmp/xcd_generic_cech_next/verify_typed_cech.py
python3 -u tmp/xcd_generic_cech_next/verify_alpha_corrected.py
python3 -u tmp/xcd_first_descent_next/verify.py
python3 -u tmp/xcd_arithmetic_next/verify.py
python3 -u tmp/xcd_discriminant_divisor/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_gauge_divisors/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_residue_class_gate/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_total_normality/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_local_class_defect/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_class_globalization_next/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_zariski_descent_gate/verify.py
/opt/homebrew/bin/python3 tmp/involution_exceptional_divisor/verify.py
/opt/homebrew/bin/python3 tmp/involution_exceptional_divisor/verify_v4.py
/opt/homebrew/bin/python3 tmp/d12_line_restriction/verify.py
/opt/homebrew/bin/python3 -u tmp/v4_surface_slice_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/plane_arrangement_hilbert/verify.py
/opt/homebrew/bin/python3 -u tmp/common_line_initial_module/verify.py
/opt/homebrew/bin/python3 -u tmp/covariant_arrangement_module/verify_all.py
/opt/homebrew/bin/python3 -u tmp/d12_block_attack/verify.py
/opt/homebrew/bin/python3 -u tmp/local_symbolic_rees/verify.py
/opt/homebrew/bin/python3 -u \
  tmp/local_symbolic_rees_independent_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/degree22_compression/verify.py
/opt/homebrew/bin/python3 -u tmp/degree23_common_line_landing/verify.py
/opt/homebrew/bin/python3 -u \
  tmp/degree23_common_line_landing_independent_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/degree24_landing/verify.py
/opt/homebrew/bin/python3 -u \
  tmp/degree24_landing_independent_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/degree25_structural_probe/verify.py
/opt/homebrew/bin/python3 -u \
  tmp/degree25_structural_probe_independent_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/d25_overlap_check/verify.py
/opt/homebrew/bin/python3 -u tmp/higher_compatibility_regularity/verify.py
/opt/homebrew/bin/python3 -u \
  tmp/higher_compatibility_regularity_independent_audit/verify.py
python3 tmp/groebnerjl_change_matrix_pilot/verify.py
python3 tmp/xcd_magma_rank_audit/verify_audit.py
python3 tmp/xcd_low_height/verify.py
```

The modular checks use NumPy/SymPy. The frame-line,
`generic_frame_planes_check.py`, flex, degree-10, and degree-11 checkers also
require the `M2` executable; the degree-12 checker requires `msolve`. The
degree-10, degree-11, and degree-12 certificate commands regenerate their
equations from the direct reduction of the cyclotomic matrices. Do not use the older
static files under `tmp/agent_high/` as certificate provenance; those were
generated in an alternate ATLAS basis. The two covariant-dominance commands
use `msolve`; the saved projective degree-10 and Pfaffian degree-15 verifiers
do not rerun their full solver jobs. The degree-six rational-root and
degree-eight projective-source commands require `M2`; the fast discriminant
replay is an independent supplement and does not by itself replace the base
and cubic-extension irreducibility checks in `degree6_rational_root.py`.
The durable q67 terminal wrapper has now recorded normal completion and a
nonempty output. `verify_q67_terminal.py` checks both hashes and confirms that
the 21,674-monomial leading ideal contains a pure power of all 21 variables,
so it is an independent direct certificate of degree-thirteen projective
emptiness. The structural proof above remains the smaller independent
certificate; neither bounded theorem gives an all-degree cutoff.

## Current ranking

The ranked attacks are now: (1) replace the refuted split-`F_67` zero-colon
shortcut by a characteristic-zero/integral saturation analysis, then attack
the full landing ideal through its relative border/Fitting presentation.
Over split `F_67`, `[(T_1)_d tensor W]^G` vanishes through degree 34 but has
dimension one in degree 35; hence the all-degree `f3` colon is nonzero.  No
characteristic-zero or higher-`m` statement follows.  The first
`m=3` line-to-`D12` boundary stratum is also killed.  In degree 25 the
complete 842-cubic system is normalized to 833 monic relations plus a
`9 x 6` determinantal tail.  The tail leaves a pure 33-dimensional
compatibility scheme, so the remaining equations must be imposed through
the seven-column chart module or global rank-28 border basis, not a raw
43-variable solve.  The rank-28 presentation is now proved exact; its global
dense closure needs at least 5.49 GB, while the current `43 x 7` chart
incidence already has a 710.386 MiB storage floor.  The same presentation
proves finite projection to `P(Q)`.  The accepted curvature-safe degree-five
certificates make `P^19` and then `P^20` empty, so the former
`dim Z<=16` split-fibre bound is superseded by `dim Z<=15`.  The separate
canonical projective-DVR family gives `dim L_25<=15` for the
characteristic-zero degree-25 landing locus.  This
sharply limits the support but does not make it empty.  What remains is sparse module/Fitting support,
characteristic-zero/higher-order saturation, and uniform
landing detection on `[(I^(m)/I^(m+2))_d tensor W]^G`, not another finite
`V4` table, isolated point-row sweep, or raw scalar Hilbert degree; (2)
attack the original projective `xCD` cubic at `f6=0` through the
section-preserving graded Rees-lattice lift for primitive branch classes,
then the global class image and quotient-relative degree image `3Z`
(total-space normality and the local class maps are now proved; `f5=0`
descent is the alternative);
(3) run the
ambient-polynomial semantic verifier through the remaining 7,846
degree-six/seven rows before composing the `M7` circuit; and (4) touch
Pfaffian degree sixteen only after a structural reduction.  Landing
self-covariants are already excluded through degree 24; degree 25 is the
first bounded unknown and should be used through the normalized
border/Fitting module, not an unstructured high-dimensional projective solve.
The old degree-22
memory stop is superseded by the `25 -> 12 -> 4 -> 0` proof.  The
finite KLS `P8` screen is complete, and dimension
counts prove that larger sparse three-support boxes cannot be exhaustive;
the quartic-precomposition theorem now rules out a bound on every solution,
so the route needs a global foliation theorem or an effective bound for one
minimal solution.  Do not
launch another bare Problem F path/transition argument, unchanged degree-12
mixed charts, high-dimensional raw degree-25 charts, more isolated degree-16 fibres, or control translation
interpolation.  For headline leverage: (1) the forced 55-plane symbolic
arrangement, (2) the exact flat-connection KLS equation, (3) honest generic
`xCD` descent and point searches using the completed \(K_{\rm proj}\)
arithmetic, (4) an unrestricted rational point in the exhaustive
degree-eight Schur frame, and (5) structural use of the Pfaffian Hermitian
model.
See `CURRENT_PATHS.md` for costs, implications, and stopping rules.

There is one conditional recent-tool branch: generalized multiplication
matrices for bihomogeneous systems can compute the degree-12 elimination ideal
if the exceptional projection is finite or empty and an admissible bidegree
is certified.  Exact Hilbert counts already rule out all fiber degrees five
and six; the first merely count-feasible gate is `(2,7)`, a
`422,484 x 434,763` structured hyperplane-rank problem.  Its dimension is
currently unknown.  The direct `p3=0` cover timed out on all three charts and
the tested deterministic coordinate-nondegenerate line showed no structural
gain, so do not adopt the method or extend those tests without a sparse/block route;
a proper closed projection need not be finite.

The refreshed 2026 tool audit found a more immediate method for degree 25.
Robbiano's July 21 border-basis survey identifies commuting multiplication
matrices and neighbor relations as the correct finite algebra interface.
Here the 56 monic `K^3` equations give six operators on the rank-28 order
ideal `{1,K_i,K_iK_j}`.  Adding the 777+9 remaining relations, commutator
defects, and multiplication-stable closure is proved to present the original
842-cubic quotient exactly over `F_67`; all 14,190 cubic coefficients were
checked.  A sparse `P^10` gate fills the whole degree-four module and agrees
with an independent direct calculation.  Macaulay2 replays the direct
restricted presentation with `H(3)=127`, `H(4)=0` just under the resource
cap, whereas even the operator-bearing `P^10` precursor exceeds it before
commutator closure; the global run was therefore not attempted.  The global
dense closure would already require at least 5.49 GB.  Continue with a
symmetry-compressed sparse module/Fitting or circuit implementation rather
than another uncompressed Macaulay2 run.  The June 2026
BSS/Koszul-homology spline paper supplies a useful model for the graded
plane--line--point homology, but its generic hyperplane-fan theorems do not
apply directly.  See `tmp/recent_equivariant_tools_2026/REPORT.md` and
`tmp/m1_border_module_m2/REPORT.md`.

One very recent theorem did materially change the `xCD` boundary:
Poonen--Stoll, *The valuation of the discriminant of a hypersurface*
(2026-06-30), Theorem 1.1.  It turns the certified valuation-one statement at
every degree-120 discriminant component into a residue-rational nondegenerate
node.  Together with projection and Hensel lifting, this closes those
components as local-obstruction places.  After the new reduced restriction
certificate on `H6`, the same theorem also supplies regularity at every
vertical codimension-one point of the pullback total cubic and is the key
`R1` input in `tmp/xcd_total_normality/REPORT.md`.  It still says nothing
about the global torsor or the relative divisor-class degree image.

The 2026-07-27 Groebner.jl change-matrix API was installed and tested rather
than dismissed.  Exact small identities pass, but the fixed two-generator
change calculation and 512-row parsing already cross the `768 MiB` RSS gate;
the public high-level route is stopped.  SPQR does allow elimination orders
for positive-dimensional systems, but Mathematica is unavailable locally and
its reconstructed candidates would still need independent exact
verification.  No further broad tool search is justified unless a release
offers a public memory-efficient raw change-matrix interface or certified
generic function-field local/Selmer machinery.  See
`tmp/groebnerjl_change_matrix_pilot/REPORT.md`.

## Best re-entry points

- **Generic twist.** The exact invariants, algebraically independent
  primaries, rank-twelve Hironaka basis and multiplication table, normalized
  \(K_{\rm proj}\) arithmetic, and genuine rank-nine \(E[3]\) algebra are all
  certified.  The rank-nine flex algebra, its generic universal point, the
  determinant-free Cech circuit, the triple-overlap/rank-81 markers, and the
  generic diagonal idempotent are also certified.  The typed
  `lambdaSharp=(lambda+eDelta)^-1*(1-eDelta)` circuit and its actual Cech
  `X,Y` packet are certified as well.  The raw determinant ratio is proved
  not to descend, while a unit scalar-cochain normalization supplies the
  certified generic-open rank-nine `alpha_R` modulo cubes.  The actual
  equation `G(P)=alpha_R*z^3` is assembled as a ten-variable, nine-cubic
  unit-chart interface; a universal translation matrix is no longer required.
  The unit-open scheme has 729 geometric degree-nine components, with a
  distinguished base-defined component isomorphic as a covering to the
  original projective `xCD` cubic.  Generic first descent now needs a
  `K_proj,C`-rational point search or geometric-divisor obstruction on that
  cubic.  The three pure-coefficient divisor families are locally soluble;
  nonexistence only over the saved `QQ`-model is insufficient.
  True second descent then needs the generic twisted three-flex-line algebra,
  line forms, and constants.  The soluble coordinate-line control is now
  explicit: \(Q_{\rm ctl}=[H-3O]\), its irreducible nonzero \(E[3]\) field,
  and the genuine nonzero \(G_T(Q_{\rm ctl})\) representative all replay
  exactly.  It validates conventions only and does not transfer to the
  generic characteristic-zero plane. Positive candidate searches may
  proceed immediately in the ambient rational-function field if invariance
  and the cleared cubic identity are checked exactly. Continue the ten
  three-coordinate planes of
  \(\Phi(a)=F(a_0x+a_1C+a_2D+a_3E+a_4K)\) over the invariant field and find
  one nonzero isotropic vector. The frame and all coordinate lines are
  controlled, all plane sections are smooth, and invariant-polynomial plane
  ansätze are excluded only through total degree 14; the cubic point remains
  open. The point problem already descends from \(\mathbf C(W)^G\) to the
  transcendence-degree-four field \(\mathbf C(\mathbf P(W))^G\), but its
  \(C_4\) bound does not apply to a five-variable cubic. Rational flexes are
  excluded in every frame plane; the exact remaining genus-one question is
  whether the flex class lies in the Kummer image. See
  `tmp/plane_genus_one/REPORT.md`.
- **Higher covariants.** Landing self-covariants are completely excluded
  through degree 24.  The structural quotient packets remain the source for
  degrees 13--15.  The forced-plus-plane packet is the source for degrees
  16--21: restriction is injective in degree 16, and the complete
  special-fibre kernels in degrees 17--21 have dimensions `2,3,7,11,16`;
  their necessary cubic landing equations have empty projective loci.
  Degree 22 is excluded by the exact linear ledger `25 -> 12 -> 4 -> 0`;
  degrees 23 and 24 are excluded by independently audited complete
  20-chart covers after compression to 20 variables.  Degree 25 is the next
  unrestricted homogeneous degree.  The ordinary support/regularity theorem
  is now complete: `dim D_d[W]=16` for all `d>=54`, with only the finite gap
  30--53 left.  The first symbolic complex is calibrated exactly over split
  `F_67` in degree 25: its `673 -> 364 -> 59` ledger recovers the direct global space, but
  point initials leave the leading common-line exact-order-three quotient at
  dimension 37.  The
  `m=3` total-degree-19 first line stratum is killed at the assembled `D12`
  boundary, and direct plane jets give `C_(3,d)=0` for `25<=d<=31`.
  Resume by making the compact line/point construction graded and controlling
  its homology/local cohomology, then seek a uniform saturation or
  landing-detection theorem.  Do not return to the superseded degree-16
  residual or launch an uncompressed degree-25 chart.  See
  `tmp/degree22_compression/REPORT.md`,
  `tmp/degree23_common_line_landing/REPORT.md`,
  `tmp/degree24_landing/REPORT.md`, and
  `tmp/symbolic_compatibility_complex/REPORT.md`,
  `tmp/m3_line_point_boundary/REPORT.md`, and
  `tmp/m1_compact_degree25/REPORT.md`.  Any landing point would be
  dominant automatically; the cutoff remains finite and is not a negative
  solution.
- **Pfaffian branch.** The exact quaternionic model and the matched-covariant
  checker are in `tmp/fano14_twist/REPORT.md` and
  `tmp/fano14_degree12/REPORT.md`. Degrees 12--15 are excluded. Degree 16 has
  been fully reconstructed, but its 1,313-quadratic exact solve timed out in
  degree three and remains a strict nonverdict; see
  `tmp/fano14_degree16/REPORT.md`. The structural target is still a common
  isotropic line for the special five-plane of Hermitian forms.
- **Projective Schur source.** `tmp/projective_source/REPORT.md` proves that
  any rational \(\mathbf P(V_6)\dashrightarrow C\) would solve the problem and
  excludes constant-coefficient degrees 4, 6, 8, and 10. Degree 12 has now
  been reconstructed completely (dimension 48), but only the 16-dimensional
  decomposable sector, every one-primitive slice, every one of the 496
  two-primitive slices, and fixed-basis supports of size at most five are
  excluded. Thus the structural quotient basis needs primitive support at
  least three. The old incomplete 1,093-row solve timed
  out; the complete characteristic-23 equation span has rank 1,124 and a
  verified full input. Its complete-input solve also timed out in degree four
  with no leading ideal, so there is still no projective-locus verdict. The
  terminal audit excludes more source sampling and identical retries: all 48
  standard chart leading-cubic restrictions have rank 1,124, and two exact
  chart probes reproduce the same degree-four bottleneck.  The equations have
  now been changed to
  \(D_{12}^{V_6}\oplus\langle p_0,\ldots,p_{31}\rangle\), and the authorized
  \(p_0=1\) gate timed out on a worse trajectory.  Do not run the other 31
  charts; resume only through relative elimination of the 16 decomposable
  variables with explicit exceptional-stratum control. The rational
  problem has an exhaustive degree-eight frame over the invariant quotient
  field.  Its ten coordinate lines and the bounded ternary envelopes through
  all 90 spaces \(S_{12}+\langle p_j\rangle\) are excluded.  Unrestricted
  ternary points remain open; the other 359 two-direction degree-12 slices
  are not budget-justified. Finite scans still cannot prove a negative
  answer. See the reports under `tmp/projective_source_degree12*`,
  `tmp/step4_degree12_solver_terminal/REPORT.md`, and
  `tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`.
- **Covariant dimension.** Search directly for a Jacobian-zero
  self-covariant \(W\to W\). Such a map is equivalent to
  \(\operatorname{ed}(G)=3\), even if its image is not initially presented as
  the Klein cone. Degrees through 11 are excluded; in degree 12 the pure
  decomposable and pure primitive strata are also excluded, and the mixed
  incidence is empty over a certified nonempty open of primitive `P3`; any
  survivor lies on a proper closed exceptional subset.  No equation or
  dimension bound for that subset is known.  The Hironaka arithmetic
  and all four connection circuits are complete; the 561 constant and
  Hironaka-linear ansätze are excluded.  Attack the exact equation
  \(\mathcal J_\nabla(a)=0\) over the invariant field through a structural
  rational-function family or differential-algebraic argument. See
  `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`,
  `tmp/degree11_jacobian/REPORT.md`, `tmp/degree12_jacobian/REPORT.md`,
  `tmp/degree12_jacobian_structural/REPORT.md`,
  `tmp/relative_kls_chart/REPORT.md`, and `tmp/kproj_connection/REPORT.md`.
- **Essential dimension.** Any unconditional proof that
  \(\operatorname{ed}(G)=3\) or \(4\) now settles the headline in the
  corresponding direction.  The canonical target is the generic Klein twist
  over \(K_{\rm proj}\): it has index one, but none of the audited local,
  Brauer, Amitsur, or standard stable-cohomology invariants decides whether it
  has a point. See `tmp/step4_essential_dimension/REPORT.md`.
- **Counterexample twist.** An explicit \(G\)-torsor whose Klein twist has no
  point would prove both the negative headline and \(\operatorname{ed}(G)=4\).
- **Orbit constructions.** A successful orbit-based formula must mix an
  entire configuration continuously; constant orbit selection and binary
  chord trees are now ruled out by the exact subgroup audit. The 220-point
  orbit has no containing divisor through degree four, its first
  complete-intersection link increases the residual degree to at least 320,
  and a constant invariant degree-74 interpolation curve is impossible. A
  torsor-dependent semilinear degree-74 curve remains a precise positive
  target; see `tmp/zero_cycle_descent/REPORT.md`.

## Theorem boundaries

- Current literature explicitly retains this action as open.
- \(\operatorname{Crdim}(G)=4\) does not imply
  \(\operatorname{ed}(G)=4\) without Dolgachev's conjecture.
- Superrigidity rules out equivariant birational linearization, not a
  dominant map of higher degree.
- The three bounded covariant statements have different sources and cutoffs:
  landing \(W\to W\) is excluded through degree 24, with degree 25 the first
  bounded unknown; Jacobian degeneracy for
  \(W\to W\) completely only through degree 11, with the two pure degree-12
  strata excluded and generic-open emptiness on the mixed primitive
  parameter space; its proper closed exceptional locus remains open. The
  constant-coefficient
  landing \(V_6\to W\) completely only in degrees 4, 6, 8, and 10. Its
  degree 12 has only the scoped decomposable and coordinate-support
  exclusions stated above.  Rank 721 or 1,124 is an exact special-fiber
  equation-span statement, not projective emptiness by itself.
  Rational coefficients on the last source have an exhaustive five-vector
  degree-eight frame.  The full degree-six pencil, all ten coordinate lines,
  and the bounded ternary envelopes through all 90 one-direction degree-12
  slices are excluded; arbitrary invariant-field points remain open.
- Very versality of \(C^{[3]}\) does not give very versality of \(C\): no
  rational equivariant operation selecting one point of the degree-three
  cycle is known, and Voisin's marked parameter space is already fibered over
  \(C\).
- The projective Schur source \(\mathbf P(V_6)\) is not itself weakly versal.
  A map from it is sufficient only because its twists split over extensions of
  degree at most two and the resulting quadratic cubic points descend.
- The Pfaffian bridge contains a genuinely nonsplit projective factor. It
  always splits after an extension of degree at most two, but this yields a
  Klein-cubic point only in the \(F_{14}\)-very-versal branch of the
  essential-dimension argument in `RESOLUTION.md`. Rationality of the ambient
  \(D\)-projective plane does not imply a point on its codimension-five Fano
  section, and the quaternion class persists over that section's function
  field.
- The generic twist has no rational line: a point on its twisted Fano surface
  of lines would force a faithful very versal surface, contradicting
  \(\operatorname{ed}(G)\ge3\). It has no \(K_0\)-defined conic either, since
  the residual plane-section component would be such a line. A successful
  point construction must not assume either curve.
- The Gross--Popescu modular interpretation respects the \(G\)-action, but
  its unirationality inference uses ordinary cubic unirationality and supplies
  no equivariant linear source.
- A search through any finite degree is not a negative resolution.

## 2026-07-28 — Technique import from Problem F (label: AUDIT PASSED, resolution committed)

Problem F (the PSL(2,7) degree-2 del Pezzo, `../F-dp2-psl27/`) is
RESOLVED NEGATIVE: director review and an independent adversarial audit
(from-scratch recomputation of all finite inputs) both passed it, and the
proof in fact shows S is not even G-weakly versal.  The mechanism below
may now be cited as a working engine; novelty-vs-antecedents positioning
is under a separate literature sweep.

### The mechanism: a V₄-fixed exceptional-path obstruction

For a hypothetical equivariant map presented by primitive covariants, F's
capstone (`../F-dp2-psl27/certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md`)
derives a contradiction from four ingredients, none degree-dependent:

1. **Parity forcing on involution eigenloci.**  For an involution `s` and
   `v ∈ E₋(s)`, `s·p(v) = p(−v) = ±p(v)` by degree parity, so `p` maps the
   eigenlocus into `E₊(s)` (even) or `E₋(s)` (odd).  Either way the
   restriction of the map to a *rational* eigenlocus lands in an involution
   fixed locus of the target; when that fixed locus contains no rational
   curve (elliptic-or-points), the restriction is CONSTANT and the constant
   is centralizer-fixed — often already a contradiction (F's odd case dies
   on `D₈` having no invariant line).
2. **Forced basepoints.**  At a point where several involution loci meet
   with distinct forced constant values, the map cannot be regular.
3. **Pointwise-fixed exceptional curves.**  Blowing the basepoint orbit:
   when the stabilizer contains a central involution `z` with SCALAR
   differential, the exceptional curve is pointwise `z`-fixed, so its image
   lies in the target's `z`-fixed locus — constant again, with the value's
   projection pinned by a stabilizer-representation argument
   (`[H,H] ∋ z` kills invariant lines in `E₋(z)`).
4. **The path lemma.**  In an equivariant resolution by point blowups, the
   local total transform over the meeting point of two such curves is a
   TREE; `K = ⟨z,s⟩ ≅ V₄` fixes the endpoint-to-endpoint path vertexwise;
   each intermediate exceptional `ℙ¹` is the projectivized tangent rep of a
   `K`-fixed birth center, so the `ℙ(T_x)`-action factors through one
   character and some nonidentity involution of `K` acts POINTWISE on it.
   Every path component therefore maps constantly into an involution fixed
   locus; adjacency propagates one constant across the path, contradicting
   the distinct forced endpoints.  This kills ALL degrees at once — the
   step that degree-by-degree elimination (F went 24–34 before finding it)
   could not reach.

### Why it plausibly speaks to the Klein cubic

- `PSL₂(𝔽₁₁)` has a single conjugacy class of 55 involutions, and its
  2-Sylow is `(ℤ/2)²` — exactly the `V₄ = ⟨z,s⟩` the path lemma consumes
  (Beauville, *Finite simple groups of small essential dimension*, §16.4.5,
  notes the 2-Sylow fixes points on both Prokhorov threefolds).
- **(historical expectation, refuted by the audit below)** The eigenspace
  dimensions are indeed `(dim E₊, dim E₋) = (3,2)`, and
  `X ∩ ℙ(E₊(t))` is a smooth plane cubic.  But
  `X ∩ ℙ(E₋(t))=ℙ(E₋(t))` is an entire line, not the hoped-for finite set.
- The parity forcing (1) applies verbatim to covariant quintuples
  `p : W → W`.

### The honest obstacle to a verbatim transfer

F's path lemma is SURFACE mathematics: point blowups, tree dual graphs.
On `ℙ(W) = ℙ⁴` an equivariant resolution has positive-dimensional centers
and 2-complex dual structure; steps (2)–(4) do not port as stated.  The
candidate workaround is dimensional reduction BEFORE resolving: restrict
the hypothetical map to a well-chosen `G`- or `K`-stable rational SURFACE
in `ℙ(W)` (a span-configuration of involution eigenspaces, or a member of
a stable pencil) on which the forced-value dichotomy already lives, and
run F's argument on that surface.  Choosing the slice so that both forced
endpoint values appear on it is the actual work.

### Cheap exact first checks (before any theory)

1. eigen-dimensions of an involution on `W`; 2. smoothness/genus of
`X ∩ ℙ(E₊(t))`; 3. whether `X ∩ ℙ(E₋(t))` is finite (it is not);
4. explicit `V₄`-fixed
points on `X` and the local characters there; 5. stabilizer structure at
special points of the eigenspace configuration (the `D₈`-analogue), and
whether two involution loci through such a point carry distinct forced
values.  All five are `wp1_fixed_loci.py`-style computations; F's script
is the template.

## 2026-07-28 — Generalizing the F-engine after the first exact check (director)

This is the historical directive whose five checks are completed and
superseded by the exact audit immediately below.

The worker's finding is confirmed and sharpened.  For an involution `t`,
`X^t = E_t ⊔ L_t` with `E_t = X ∩ ℙ(E₊(t))` a smooth genus-one curve and
`L_t = ℙ(E₋(t))` a LINE CONTAINED IN X — so the F-input "no rational
curve in the fixed locus" fails.  Worse, and new: for `K = ⟨z,s⟩ ≅ V₄`
(the 2-Sylow), the trace-1 involution character forces the joint
`K`-decomposition of `W` to have dimensions **(2,1,1,1)** across the sign
classes `(++, +−, −+, −−)` **(verify exactly — derived from
χ(involution) = 1, consistent with the worker's plane/line split)**.
Hence:

- `L_z ∩ L_s = ℙ(W^{−−})`, and cyclically — the three lines form a
  **triangle inside X** with vertices the three mixed joint eigenpoints;
- each `E_t` passes through the vertex opposite its line
  (`ℙ(W^{+−}) ∈ E_z ∩ L_s ∩ L_{zs}` etc.);
- the `V₄`-fixed configuration is therefore CONNECTED, so bare
  constancy-propagation can never reach an F-style contradiction, even
  where constancy holds.

### The generalized engine to build

Replace "every path component maps constantly" by the corrected local
dichotomy and track the richer state:

1. **Dichotomy.**  A rational path component `C` pointwise-fixed by
   `t_C` maps into `E_{t_C} ⊔ L_{t_C}`: either CONSTANT (elliptic side)
   or into the line `L_{t_C}` — possibly nonconstant.
2. **Rigidity on the line.**  `C` is `K`-stable and `f` equivariant, so a
   nonconstant image in `L_{t_C}` is a `K`-stable irreducible curve in a
   line — the line itself; the residual action of `K/⟨t_C⟩ ≅ C₂` on
   `L_{t_C}` has exactly two fixed points, and they are two vertices of
   the triangle **(verify: the mixed eigenpoints on that line)**.
3. **Transition system.**  Adjacency of path components now propagates a
   FINITE state — a constant value, or a line with marked vertices —
   through the configuration (triangle ∪ three elliptic curves).  The
   obstruction target: show the two forced endpoint values (the E-analogs
   of F's `a_q`, `b_s`, to be computed) are NOT connectable in this
   finite transition system, with degree/parity bookkeeping along
   nonconstant components as the second invariant if pure reachability
   is not enough.
4. **Dimension caveat unchanged:** run it on a `K`-stable rational
   surface slice where both forced values live; the ℙ⁴ resolution issue
   is unchanged from the original note.

### Cheap exact next checks (all `wp1`-style, ranked)

1. The `(2,1,1,1)` joint decomposition and the triangle, exactly.
2. The two residual-fixed points on each `L_t` = which triangle vertices.
3. The incidences `E_t ∩ L_{t'}` for all pairs in one `V₄`, exactly.
4. The E-analog of F's §2: what values are FORCED on involution-fixed
   loci by a hypothetical equivariant `p` (parity trick on `E₋(t)`,
   noting `dim E₋ = 2` now, so "constancy on `L_t`" itself needs the
   §2-style recomputation, not citation).
5. Whether the triangle vertices are smooth points of `X` and their
   stabilizers (the `D₈`-analog data for forced basepoints).

If 4 shows the forced values already land on triangle vertices, the
transition system may CLOSE rather than obstruct — that outcome would be
evidence toward a POSITIVE construction attempt along the fixed
configuration instead, and is worth knowing either way.

## 2026-07-28 — Exact audit of Fable's generalized engine

All five finite checks above have now been completed.  The configuration is
exactly the predicted one, but the transition system **closes rather than
obstructs**.

- For \(K=V_4\),
  \(W=A\oplus B\oplus C\oplus D\) has joint-character dimensions
  \((2,1,1,1)\).  The three minus-lines are
  \(\mathbf P(C\oplus D)\), \(\mathbf P(B\oplus D)\), and
  \(\mathbf P(B\oplus C)\); they lie on \(X\) and form the triangle with
  vertices \(B,C,D\).
- The plus elliptics have the exact incidence table predicted by Fable:
  each meets the other two fixed lines at the opposite triangle vertex and
  misses its own line.  In addition,
  \(R=X\cap\mathbf P(A)\) is a reduced three-point set common to all three
  elliptics, so \(X^K=R\sqcup\{B,C,D\}\).
- Each triangle vertex is smooth, has stabilizer exactly \(K\), and has
  tangent representation \(B\oplus C\oplus D\).  No nonidentity involution
  has scalar differential there.  Thus blowing up a triangle vertex does not
  produce the pointwise-fixed exceptional plane required by the Problem F
  argument.
- In even global degree every domain minus-line is forced into the base
  locus.  In odd degree a nonbased restriction is a dominant self-map of
  that line.  The exact \(D_{12}\) binary module has dimension zero in even
  degree and \(\lfloor(d+2)/3\rfloor\) in odd degree.  Its six intersections
  with neighboring plus-planes are the roots of the degree-six reflection
  discriminant \(\Delta_t=x^6-y^6\).  Divisibility by the common odd
  transverse power \(\Delta_t^m\) makes the normalized restriction
  determinant-twisted, so it swaps a marked pair whenever both endpoint
  values are nonzero.  Extra endpoint vanishing is allowed, however, and
  exact \(D_{12}\) examples realize all four endpoint ledgers.  The whole
  line may also remain a base component; if its transverse order is \(n\),
  the necessary parity is \(d+n\) odd.
  Leading maps from a plus-plane exceptional divisor likewise preserve or
  swap marked vertices according to parity when nonzero there.
- The unique \(A_4=N_G(K)\)-stable linear surface is
  \(\mathbf P(B\oplus C\oplus D)\).  Its cut with \(X\) is exactly the
  triangle.  The quadratic Cremona transformation realizes the closed
  blowup incidence but fails the Klein equation away from the triangle, so
  it is a transition model rather than a positive construction.  The other
  \(K\)-stable linear-plane types likewise fail the two-forced-constant
  hypothesis; nonlinear stable surfaces remain unclassified.
- There is one new initial-order constraint.  If the common plus-plane order
  is \(m=2r+1\), the naive minimum transverse order \(3r+2\) along the common
  \(V_4\)-fixed line would have only three nontrivial-character monomials.
  Since \(F|_{B\oplus C\oplus D}\) is a nonzero multiple of \(y_1y_2y_3\)
  and \(A_4/K\) cycles their coefficients, that leading form cannot land in
  \(X\).  Hence
  \[
  \nu_{\mathbf P(W^K)}(p)\ge 3r+3.
  \]
  At order \(3r+3\), trivial and nontrivial target characters can mix, so
  the argument does not iterate automatically.

For the live degree-25 calculation, `m=1`, so the last inequality is exactly
the common-line order-at-least-three condition already used to define the
strict 43-space `Q_37 direct_sum K_6`.  It adds no new row to the complete
842-cubic or rank-28 border presentations.  Conversely, because degree 25 is
odd, Fable's line ledger does not justify appending a universal minus-line
vanishing equation: a minus-line may map dominantly, vanish further at its
marked endpoints, or remain based.  Keep the current border/Fitting ideal
unchanged.

The triangle vertices are therefore mutually reachable, while the three
points of \(R\) are isolated constant states.  Nothing in the finite data
forces one resolution endpoint into \(R\) and another into the triangle.
The surviving all-degree route is the symbolic arrangement module of the 55
plus-planes, together with higher-center compatibility; a bare finite-state
or surface-path argument should not be dispatched again.

### Landing structure through degree 25; first symbolic complex; exclusion through 24

The first symbolic-module step has now been run on complete self-covariant
spaces.  Plus-plane restriction is injective through degree 16.  Its
special-fibre kernels in degrees 17--24 have dimensions
`2,3,7,11,16,25,34,44`, and complete landing tests exclude all of them.
Degree 17 has an independent common-line computation.  In degrees 18--21 the
common-line extension reuses the restriction-kernel construction but gives a
separate initial-form test.  The former degree-22 nonverdict is superseded:
the common-line strict space has dimension 12, even minus-line vanishing cuts
it to four, and the order-three necessary cubics have full rank `20/20`.
Degree 23 compresses `34 -> 20`, after which 392 necessary cubics give unit
ideal on all 20 projective charts.  Degree 24 has first-jet rank `43/44`; its
unique exceptional line has exact order two, while the fixed-locus ledger
compresses `44 -> 29 -> 20`, and 484 necessary cubics give unit ideal on all
20 charts.  Independent from-scratch audits rebuilt both degree-23 and
degree-24 packets, including every chart.  Degree 25 is the first bounded
unknown.  Its structural probe gives `M25=189`, restriction rank 130,
`K25=59`, parity-excludes the exact three-dimensional order-two branch,
compresses common order two to a strict 43-space, and excludes the
order-at-least-four six-space by full cubic rank `56/56`.  The unresolved
leading common-line order-exactly-three system factors through a
37-dimensional quotient.  No
nonlinear chart or characteristic-zero exclusion is claimed.

The reduced scalar arrangement is also known through degree 18, with first
split-fibre equations in degree 15 and 55 triple lines plus 121 multiple
points.  It is not the odd symbolic equivariant module.  The induced `D12`
ordinary/jet blocks and first line/point maps are now exact.  The complete
scalar overlap is also surjective in degree 25.  Over split `F_67`, compact
induced `W`-block bases give higher-compatibility quotient dimension 16 in
every audited degree 18--29.  Multiplication by `f3` and `f5` is invertible on every map
inside that window, as is the first `f11` map from degree 18 to 29.  The
ordinary quotient is now identified sheaf-theoretically with a point-supported
defect of scalar length 1573 and `W`-multiplicity `9+7=16`;
55-regularity of the arrangement ideal makes this exact in every degree at
least 54, including characteristic zero.  At the `D10` and `D12` multiple
points, the minimal local
symbolic layers are now presented for every `m`: their first degree is `3m`,
and for odd `m` they are reflection-sign.  Thus common odd plane order `m`
forces point order at least `3m+1` at all 121 points.  The next layer already
contains the target representation.  At a generic triple line the symbolic
normalization cokernel is free over the line coordinate ring (already
explicit for `m=1,3` with its `A4` character), so it cannot be replaced by
the ordinary point-supported module.

The first global symbolic-normalization packet and an independent audit now
separate the theorem boundaries precisely.  There is an injection
`M_m=I^(m)/I^(m+2) -> N_m` into the sum of branch normalizations.  Generic
triple-line quotients are free along the line.  At a multiple point one must
first impose all incident line equalizers and only then take the residual
point quotient.  The subsequent global theorem proves that these iterated
kernels give the correct associated sheaf in every twist.  The naive
four-term Cech sequence remains false, and the passage to literal
low-degree graded pieces is controlled by the finite irrelevant-torsion
module `T_m`.  Over split `F_67`, `[(T_1)_d tensor W]^G` is zero through
degree 34 and in every degree at least 164.  All induced
`f3:D_d->D_(d+3)` maps with `14<=d<=31` are injective, and their truncated
quotient through degree 34 has dimension 1,459.  In degree 35 the exact
compact/literal dimensions are 362 and 361, so `[(T_1)_35 tensor W]^G` has
dimension one.  Nilpotence of this finite irrelevant torsion forces a
nonzero `f3`-colon element in some degree.  The split-fibre all-degree colon
is therefore refuted; nothing here lifts the torsion to characteristic zero
or higher symbolic order.  Direct plane jets do prove
`C_(3,d)=0` for `25<=d<=31`; the full-rank split-`F_67` matrices promote this
bounded vanishing to characteristic zero by good reduction.

Two finite boundary tests have also been completed.  For `m=3`, line degree
one and transverse degree six, multiplication by the forced invariant
`D_L^4` gives total degree 19.  The three incident line germs at a `D12`
point must prescribe the same central-plane jet; their difference map has
rank `8/8`, killing the saved length-48 generic-line chart.  This is only a
split-`F_67` associated-graded stratum.  Also over split `F_67`, for `m=1`,
degree 25, the compact complex has the exact ledger
`673 --line rank 309--> 364 --point rank 305--> 59`, and its final kernel is
the direct global `K1/K3`.  The landing filtration is
`59 --rank 16--> 43 --rank 37--> 6 --rank 6--> 0`.  Independent comparison
shows that the available `D10` and `D12` point initials impose no extra
condition on the 37-dimensional leading common-line quotient.  Exact
factored order-four plane landing equations are now completely assembled as
an exact rank-842 cubic system, with 833 monic relations and a nine-equation
determinantal tail.  The tail alone leaves a pure projective 33-fold; raw
high-dimensional solver probes hit the memory gate.  The exact rank-28
border module instead makes the full landing scheme finite over `P(Q)=P^36`.
On `q0!=0`, exact lowest-profile circuit tests separate `q0^4 e0` from the
degree-four reduced-row ansatz, `q0^5 e0` from constant combinations of all
821 chart rows, and `q0^17` from constant combinations of 815 independent
wedge circuits on one rank-six minor chart.  The exact coordinate-Schur
restriction through `q16` now refutes the full raw-821 scalar-`Q`
degree-five identity, with terminal ranks `1913/1914`.  It does not refute
the `T_i`-stable rank-28 kernel/support, and higher cleared degrees remain
open.
The two-level degree-four certificate makes a coordinate `P^18` in that base
empty.  Its first curvature-safe degree-five successor makes `P^19` empty;
the exact `29320 x 3220` terminal matrix gives the now-superseded split-fibre
bound `dim Z<=16`.  The next curvature-safe successor makes `P^20` empty:
its exact terminal square has rank `4693/4693` and pivot product `32 mod 67`;
the 19-stage full replay peaks at `580.828125 MiB`,
so the current split-fibre bound is `dim Z<=15`.  The separately sealed
canonical Reynolds-lattice specialization promotes `dim L_25<=15` to
characteristic zero.  The global support is still not proved
irrelevant, so degree 25 remains open.

The all-degree successors are therefore a characteristic-zero/integral
saturation analysis, extension to higher `m`, and a uniform relative
border/Fitting landing-detection lemma on
`[(I^(m)/I^(m+2))_d tensor W]^G`.

Replay:

    /opt/homebrew/bin/python3 tmp/involution_exceptional_divisor/verify.py
    /opt/homebrew/bin/python3 tmp/involution_exceptional_divisor/verify_v4.py
    /opt/homebrew/bin/python3 tmp/d12_line_restriction/verify.py
    /opt/homebrew/bin/python3 -u tmp/v4_surface_slice_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/plane_arrangement_hilbert/verify.py
    /opt/homebrew/bin/python3 -u tmp/common_line_initial_module/verify.py
    /opt/homebrew/bin/python3 -u tmp/covariant_arrangement_module/verify_all.py
    /opt/homebrew/bin/python3 -u tmp/d12_block_attack/verify.py
    /opt/homebrew/bin/python3 -u tmp/local_symbolic_rees/verify.py
    /opt/homebrew/bin/python3 -u tmp/local_symbolic_rees_independent_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/degree22_compression/verify.py
    /opt/homebrew/bin/python3 -u tmp/degree23_common_line_landing/verify.py
    /opt/homebrew/bin/python3 -u tmp/degree23_common_line_landing_independent_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/degree24_landing/verify.py
    /opt/homebrew/bin/python3 -u tmp/degree24_landing_independent_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/degree25_structural_probe/verify.py
    /opt/homebrew/bin/python3 -u tmp/degree25_structural_probe_independent_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/d25_overlap_check/verify.py
    /opt/homebrew/bin/python3 -u tmp/higher_compatibility_regularity/verify.py
    /opt/homebrew/bin/python3 -u tmp/higher_compatibility_regularity_independent_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/ordinary_defect_support/verify.py
    /opt/homebrew/bin/python3 -u tmp/ordinary_defect_support_independent_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/symbolic_compatibility_complex/verify.py
    /opt/homebrew/bin/python3 -u tmp/symbolic_compatibility_complex_independent_audit/verify.py
    /opt/homebrew/bin/python3 tmp/symbolic_landing_design/verify.py
    /opt/homebrew/bin/python3 -u tmp/m3_line_point_boundary/verify.py
    /opt/homebrew/bin/python3 -u tmp/m3_line_point_boundary_independent_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_compact_degree25/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_compact_degree25_independent_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_compact_degree25_filtration_independent_audit/verify.py
    /opt/homebrew/bin/python3 -u tmp/symbolic_global_exactness/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_compact_graded_pilot/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_t1_saturation/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_t1_propagation_design/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_t1_f3_colon_attack/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_t1_f3_colon_degree35_audit/run_bounded.py
    /opt/homebrew/bin/python3 -u tmp/m1_t1_char0_d35_gate/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_determinantal_geometry/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_landing_chart_fitting/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_rank6_circuit_support/verify.py
    for stage in base q11 q12 q13 q14 q15 q16; do
      VECLIB_MAXIMUM_THREADS=1 /opt/homebrew/bin/python3 -u tmp/m1_rank6_schur_compression/verify.py "$stage"
    done
    /opt/homebrew/bin/python3 -u tmp/recent_equivariant_tools_2026/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_border_module_m2/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_cubic_slice_macaulay/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_relative_border_rank28/verify.py
    /opt/homebrew/bin/python3 -u tmp/m1_relative_border_rank28/verify_p16.py
    /opt/homebrew/bin/python3 -u tmp/m1_qslice_border_dimension/verify.py
    VECLIB_MAXIMUM_THREADS=1 /opt/homebrew/bin/python3 -u tmp/m1_relative_border_maxslice/verify.py --full
    VECLIB_MAXIMUM_THREADS=1 /opt/homebrew/bin/python3 -u tmp/m1_relative_border_maxslice/verify_p18.py --full
    VECLIB_MAXIMUM_THREADS=1 /opt/homebrew/bin/python3 -u tmp/m1_relative_border_p19_d5/verify.py --full
    /opt/homebrew/bin/python3 -u tmp/char0_lift_p19_d5/verify.py
    VECLIB_MAXIMUM_THREADS=1 /opt/homebrew/bin/python3 -u tmp/m1_relative_border_p20_d5/verify.py --full
    VECLIB_MAXIMUM_THREADS=1 /opt/homebrew/bin/python3 -u tmp/char0_lift_p20_d5/verify.py

The exact boundary and transition ledger are in
tmp/involution_exceptional_divisor/REPORT.md and
tmp/involution_exceptional_divisor/V4_REPORT.md, with the full line-module
classification in tmp/d12_line_restriction/REPORT.md.
The independent surface audit is tmp/v4_surface_slice_audit/REPORT.md.  The
original cutoff source is tmp/covariant_arrangement_module/REPORT.md; the
degree-22--24 extensions are the dedicated packets named above.  The
corrected initial-form corroboration is
tmp/common_line_initial_module/REPORT.md.  The reduced split-F67 scalar pilot
is tmp/plane_arrangement_hilbert/REPORT.md.  The independently audited all-`m`
local point theorem is tmp/local_symbolic_rees/REPORT.md.  The independently
audited compact ordinary quotient window is
tmp/higher_compatibility_regularity/REPORT.md; its all-degree support
successor and independent audit are under `tmp/ordinary_defect_support*`.
The sealed symbolic packet and audit are
tmp/symbolic_compatibility_complex/REPORT.md and
tmp/symbolic_compatibility_complex_independent_audit/REPORT.md.  The first
assembled `m=3` boundary and its audit are under
`tmp/m3_line_point_boundary*`; the compact `m=1`, degree-25 calibration and
its independent checks are under `tmp/m1_compact_degree25*`.  The global
sheaf architecture, graded pilot, bounded split-fibre `T_1` window,
complete cubic/determinantal reduction, chartwise Fitting interface, and
recent border-module audit are under
`tmp/symbolic_global_exactness/`,
`tmp/m1_compact_graded_pilot/`, `tmp/m1_t1_saturation/`,
`tmp/m1_t1_propagation_design/`, `tmp/m1_t1_f3_colon_attack/`,
`tmp/m1_t1_f3_colon_degree35_audit/`,
`tmp/m1_t1_char0_d35_gate/`,
`tmp/m1_full_plane_block_rank/`,
`tmp/m1_determinantal_geometry/`, `tmp/m1_landing_chart_fitting/`,
`tmp/m1_rank6_circuit_support/`, `tmp/m1_rank6_schur_compression/`,
`tmp/recent_equivariant_tools_2026/`, and
`tmp/m1_border_module_m2/`.
The mixed-coordinate dense-slice certificate, exact rank-28
finite-projection packet, and independent Q-slice audit are under
`tmp/m1_cubic_slice_macaulay/`, `tmp/m1_relative_border_rank28/`, and
`tmp/m1_qslice_border_dimension/`.  The recursive degree-four slice
certificate, its degree-five `P^19` and `P^20` successors, and the current
characteristic-zero promotion are under `tmp/m1_relative_border_maxslice/`,
`tmp/m1_relative_border_p19_d5/`, `tmp/m1_relative_border_p20_d5/`,
`tmp/char0_lift_p19_d5/`, and `tmp/char0_lift_p20_d5/`.  The precise
remaining global lemmas are in tmp/all_degree_arrangement_attack/REPORT.md.
