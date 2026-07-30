# Problem E handoff

## Headline

The problem remains **OPEN**. Do not reinterpret the essential-dimension
equivalence, generic-twist frame, or bounded covariant search as a binary
resolution.

The current two-axis ranking and the four-path audit are in
[`CURRENT_PATHS.md`](CURRENT_PATHS.md).

## 2026-07-30 latest Pfaffian closure

The main question is still whether the Klein cubic is
\(G=\operatorname{PSL}_2(\mathbf F_{11})\)-unirational.  The verdict remains
**OPEN**.  The newest exact work replaces the former `D5` residue question
and the unknown degree of the four-parameter fixed-frame cover by the
following sharper boundary.

1. **`D5` is soluble and is retired as an obstruction.**  Over
   \(F_0=\mathbf C(A,Y,Z)\), the residual cubic has the constant point

   \[
   [X:v:w]=[x_1:t_1:1]
   \]

   with `x1,t1 in Q(zeta_11)`.  All five coefficients of the equation vanish
   there identically in `A,Y,Z`, and the `Y` coefficient of `F_X` is nonzero.
   Thus the point is generically smooth and lies in the projector open.  It
   Hensel-lifts, the local genus-one torsor is zero, and the selected
   `E[3]` representative is in the local Kummer image.  This does not say
   that the particular `E[3]` lift is itself zero.

2. **The full fixed-frame cubic has index three over a rational subfield.**
   Put

   \[
   F=\mathbf C(A,B,Y,Z),\qquad
   A=f_6/f_3^2,\ B=f_5f_7/f_3^4,\
   Y=f_9/f_3^3,\ Z=f_{12}/f_3^4.
   \]

   The equation is the generic member of the basepoint-free linear system

   \[
   F_0+A F_A+B F_B+YF_Y+
   \left(Z-\frac{11}{18}A^2\right)F_Z=0.
   \]

   The five constant ternary cubics are independent and have no common
   geometric zero.  The universal incidence is a regular projective bundle
   over `P2`; closure of generic-fibre divisors makes its Picard group
   surject onto that of the generic cubic.  Hence the degree subgroup is
   exactly `3Z`:

   \[
   \operatorname{ind}(C/F)=3,\qquad C(F)=\varnothing,
   \qquad \operatorname{Pic}^0(C)(F)=0.
   \]

   Do not transfer this conclusion to `K_proj` without a new argument.

3. **The missing field degree is now exact.**  A sparse three-equation BKK
   certificate, independently replayed, proves

   \[
   [K_{\rm proj}:F]=6;
   \]

   the scaled affine frame has length `18`.  The proof uses an exact `3 x 9`
   polynomial-combination matrix, the `t` and `u` unit gates, a
   transcendental `v`-translation, normalized mixed volume `6`, and six
   strict-henselian etale branches through an exact reduced rational fibre.
   It does not use either timed-out generic Groebner basis or the false naive
   homogenization.  The special sextic has arithmetic group `S6`; geometric
   monodromy over `C` is `A6` or `S6`.  Either natural action is primitive,
   so `K_proj/F` has no proper intermediate fields.

4. **The natural constant-direction lift is excluded, but the point problem
   is not.**  The `D5` point fails in the full equation by the exact nonzero
   term `B*rB(t1)`.  Keeping `[v:w]=[t1:1]` gives a cubic in `X` that is
   irreducible over `C(A,B,Y,Z)` because it is primitive and linear in the
   independent parameter `B` with nonzero coefficient.  A root would create
   a cubic intermediate field, which the primitive six-sheet monodromy
   excludes.  A point with varying binary direction remains possible.

5. **The branch residue degree is one, while its first compactification is
   rejected.**  On the deterministic target line
   `(A,B,Y,Z)=(1,2,3,s)`, the primitive `u`-sextic has exact discriminant
   `Q11(s)^2*H21(s)`, where `H21` is irreducible, occurs once, and is coprime
   to the coefficient content and leading coefficient.  Binding `u` to the
   actual field uses its six distinct values on the reduced etale fibre plus
   the no-intermediate-field theorem; arithmetic irreducibility alone is not
   used across the extension of constants to `C`.  Specialization in the
   coefficient UFD and the index-square/different formula then give a global
   branch divisor with one ramified prime

   \[
   (e,f)=(2,1),\qquad [k(R):k(D)]=1.
   \]

   This simple transposition also upgrades geometric monodromy from
   `A6 or S6` to `S6`.  The degree `21` is the degree of the chosen closed
   point on the test line, not the residue degree or a certified global
   divisor degree.  A separate exact two-chart screen modulo `67` proves
   that `H21` is coprime to every necessary singularity condition for the
   fixed-frame plane cubic, including the point at infinity.  Hence the
   selected branch component is not contained in the cubic-discriminant
   locus and its generic fixed-frame cubic is smooth.  Independently, the
   degree-37 determinant of
   `d(f3,f6,f5*f7,f9,f12)` is geometrically integral and reduced in
   characteristic zero.  However, at every coordinate point `e_i` its rank
   is exactly two and all five coefficient-map sections vanish.  The naive
   corank incidence therefore has a `P2_ell` fibre there, and the cleared
   cubic total space contains `P2_z x P2_ell` components.  The proposed
   semiample-Lefschetz/Picard proof on that compactification is rejected.  The
   exact remaining negative gate is

   \[
   \operatorname{ind}(C_{k(D)})=3
   \]

   for the multiplicity-one target branch.  Prove it by extracting `D` and
   controlling the integral class group of its cubic incidence.  The
   ordinary Picard part is now complete: an SGA2 fixed-member argument proves
   `Pic(T_D)=Z*H_z+Z*H_lambda` for every integral target hypersurface with
   integral generic cubic, even when `T_D` is singular.  What remains is
   exactly the three-primary non-Cartier Weil defect

   ```text
   (Cl(T_D)/Pic(T_D))/3.
   ```

   Local factoriality would suffice; normality or rational Picard control
   would not.  On the normalization, a codimension-two nodal-cubic contact
   has local model `xy=pi^m` and class group `Z/m`, so only contacts with
   `3|m` are dangerous.  A coefficient-base principalization with all
   exceptional classes is a secondary, substantially longer route.

   The first primitive-root shortcut has also been audited exactly.  On
   `A=Y=0,B=1`, the characteristic-zero primitive sextic again has
   discriminant factors `(11,2),(21,1)`.  The full Jacobian rank drops on the
   degree-11 factor, which is exactly contained in the Cramer-denominator
   norm, while it does not drop on the simple degree-21 factor.  Therefore
   the full derivative incidence is not a smooth complete intersection.
   The selected simple component remains viable only after canonical Cramer
   saturation/component separation and normalization.  Exact pointwise
   evaluation shows `delta=0` on the bad degree-11 repeated root and
   `delta!=0` on the simple degree-21 root.  On the true projective line,
   the Cramer norm contains exactly the squared degree-1 and degree-23
   factors and is coprime to the simple degree-39 factor.  Thus `delta`
   saturation is the correct component separator in every exact line test.

   The raw irreducible target branch itself is now known to be nonnormal in
   codimension one.  A smooth mod-7 ordered-double-fold point lifts to a
   characteristic-zero two-dimensional locus where two distinct ordinary
   Cramer-open folds have independent target normals; `S6` transitivity puts
   both local branches on the same irreducible `D`.  Direct Lefschetz on raw
   `D` is therefore unavailable.  The formerly modular singularity warning
   is now exact in characteristic zero.  On `A=0,B=2`, a rational-univariate
   certificate gives a monic squarefree polynomial `H` of degree `12` and
   coordinates

   ```text
   D=H'(u),  Y=NY(u)/D,  Z=NZ(u)/D
   ```

   for which all six singular equations vanish in `QQ[u]/(H)`, while `D`,
   the primitive slice content, and the Cramer minor `delta` are units.
   Thus the content-open, delta-open ramification model contains a finite
   etale degree-12 characteristic-zero singular subscheme, hence twelve
   distinct geometric singular points.  Exact Python quotient arithmetic
   and an independent Macaulay2 ideal-membership replay both certify this.
   Consequently the direct argument that applies Sommese to a smooth
   ramification model is unavailable.

   These points are not ordinary double points.  The full Hessian in
   `(A,B,Y,Z,u)` has rank exactly `3` at all twelve points and `E_uu` is a
   unit; equivalently, after eliminating `u`, the four-parameter
   Schur-complement Hessian has rank exactly `2`, not `4`.  Therefore the
   proposed ODP/small-resolution shortcut is also rejected.  The higher-jet
   calculation now goes two exact orders farther: the binary cubic on the
   two-dimensional full-Hessian kernel vanishes identically, and so does the
   effective binary quartic after the required Morse-splitting correction
   `U|K-3*L^T*Q^(-1)*L`.  Thus, in the local branch equation
   `x*y-h(z,w)`, either `h=0` or `ord(h)>=5` at all twelve points.  This does
   not prove `h=0`; finite jets cannot do so.  The next decisive gate is the
   all-orders localized critical-surface test

   ```text
   E, E_u, E_Z in (E_A,E_B,E_Y)
   ```

   after inverting a transverse Hessian minor and the content/Cramer gates.
   A successful exact characteristic-zero certificate would show that the
   local branch is a nonnormal Morse--Bott crossing with smooth finite
   normalization.  Failure, or a nonzero higher residual, would leave a
   normal higher `cA`-type singularity.  The present certificates do not
   decide global projective small resolvability or the final class-group
   obstruction.
   The exact certificates, independent replays, proof boundaries, and
   hash bindings are in
   `tmp/target_branch_delta_saturated_singularity/PROOF_AUDIT.md` and
   `tmp/target_branch_delta_saturated_singularity/HESSIAN_PROOF_AUDIT.md`.
   The higher-jet audit and hash manifest are in the same packet.

   The former characteristic-zero primitive-equation bottleneck is now
   closed exactly.  The full 72,286-term eliminant factors over `ZZ` as

   ```text
   E_raw=C(A,B,Y,Z)*P(A,B,Y,Z,u),
   C: 2630 terms, total degree 22,
   P: 1593 terms, u-degree 6.
   ```

   Nemo/FLINT computes the multivariate content, exact division and literal
   remultiplication; independent reductions recover the saved mod-13 and
   mod-67 primitives up to nonzero scalars.  The accepted degree-12 RUR
   polynomial is irreducible and squarefree, and exact quotient arithmetic
   proves `P=P_A=P_B=P_Y=P_Z=P_u=0` while `C`, `P_uu`, and the
   `(A,B,Y)` Hessian determinant are units.  Therefore it is enough to prove

   ```text
   P in (P_A,P_B,P_Y)_mRUR.
   ```

   The regular two-dimensional quotient then supplies the `P_Z` and `P_u`
   memberships automatically.  The exact LocalRings calculation reaches the
   six zero RUR remainders and then times out; colon, Mora, sparse-F4, and
   parameter-field variants likewise give no verdict.  The sparse
   consequence matrix nevertheless admits a useful exact pointwise audit:
   its Cramer minor is a unit on the whole irreducible RUR orbit, its rank is
   exactly two, its normalized right and left kernels are explicit, and
   `ell^T*(partial_x M)*r=0` for all five variables.  This proves tangency at
   the twelve points but does not exhibit the required two-dimensional
   component.  The same kernel coordinates satisfy all nine original
   projective frame relations exactly.  Their `9 x 7` Jacobian has rank two:
   one `2 x 2` minor is a unit and all 2,940 `3 x 3` minors vanish.  Hence the
   singular orbit is not an artifact of retaining only the three sparse
   consequences, and the original incidence is not a smooth local
   normalization.  The parameter content factors exactly as

   ```text
   const*(25A-381)*(5A-81)^3*Q8^2*Q2,
   ```

   with `Q8` irreducible of degree eight and `Q2` quadratic; every factor is
   a unit at the RUR orbit.

   There is also a valid characteristic-zero shortcut: on the regular formal
   critical surface,

   ```text
   P_Z,P_u in (P,P_A,P_B,P_Y)_m  ==>  P in (P_A,P_B,P_Y)_m.
   ```

   Indeed, a nonzero positive-order residual cannot divide both of its
   partial derivatives in characteristic zero.  The hypotheses have not
   been proved.  A mod-29 full-rank calculation excludes both candidate
   logarithmic identities in the bounded box
   `deg(q),deg(a_A),deg(a_B),deg(a_Y)<=6`, `deg(b)<=5`.  In the separate
   mod-13 v1 search, the full-rank negatives are `P_u` through `d=4` and
   `P_Z` through `d=5`; `P_u` at `d=5,6` and `P_Z` at `d=6` are undecided
   because testing sampled-kernel basis vectors one at a time was
   insufficient.  The script is repaired for future runs, but the large
   deficient cases were deliberately not rerun after the memory overrun.

   Modulo `13`, no
   unit-multiplier identity for `P` exists in the recorded boxes through
   `deg(q)<=6`.  Good-prime Newton solves give zero residual through order
   `128` on every rational kernel line at `13`, `29`, and `31`, and through
   order `256` on two `p=29` lines.  Padé/Berlekamp--Massey finds no
   low-degree rational critical arc.  All of these are bounded modular
   diagnostics, not the missing characteristic-zero all-orders proof.
   Complete modular grevlex bases on the critical line
   `Z=Z0+t,u=u0` give nonzero global normal forms for `P` at both `29` and
   `31`.  Those remainders vanish at the selected point, so the result proves
   only that unrelated critical sheets contaminate the global ideal.  It is
   not local nonmembership.  The line generators have degrees `(11,10,10)`
   and the reduced remainder degree `10`; Bézout gives only
   `deg(C)<=1100` and possible contact order at most `11000`.  Therefore the
   order-256 formal vanishing is not a finite-determinacy certificate.

   The exact primitive, localized-attack, and good-prime formal audits are
   `EXACT_PRIMITIVE_PROOF_AUDIT.md`,
   `LOCALIZED_MEMBERSHIP_ATTACK_REPORT.md`, and
   `FORMAL_PRIMITIVE_GOOD_PRIMES_AUDIT.md` in the same packet.  The new
   determinant and logarithmic audits are
   `DETERMINANTAL_CRITICAL_SURFACE_AUDIT.md` and
   `LOGARITHMIC_CRITERION_AUDIT.md`.  The original-relation, global-line, and
   jet-bound audits are `ORIGINAL_PROJECTIVE_RUR_AUDIT.md`,
   `GROEBNER_LOCAL_COMPONENT_AUDIT.md`, and
   `CRITICAL_LINE_DEGREE_BOUND_AUDIT.md`.  Each has a verified SHA-256
   manifest.

6. **The exact remaining fixed-frame gate is narrow.**  Since the extension
   has no intermediate fields and `Pic^0(C)(F)=0`, a `K_proj`-point exists
   exactly when its six conjugates are the complete intersection with a
   unique `F`-conic whose length-six coordinate algebra is isomorphic to
   `K_proj`.  This is a useful finite-dimensional algebra interface, but the
   conics still form `P5(F)`; it is not a finite enumeration and `S6` alone
   gives no contradiction.

Immediate ranking: first separate and normalize the multiplicity-one target
branch.  The immediate computation is now the exact all-orders localized
critical-surface membership at the certified rank-two Schur singularities;
depending on that answer, either pass to a finite smooth normalization or
retire the smooth-model route and prove directly that the cubic incidence has
no three-primary non-Cartier Weil defect.  The ordinary Picard,
residue-degree, generic-cubic-smoothness, and exact primitive-equation gates
are complete.  Do not rerun the raw 72,286-term Groebner calculation or add
more finite jet orders without an effective bound.  The live local attack is
a component-aware exact identity for the 1,593-term primitive, preferably
through the sparse determinant/consequence incidence or a reconstructed
unit separator; the existing direct CAS formulations are engineering
timeouts, not negative membership results.  The source-coordinate
Gröbner attempts also crossed the one-GiB cap before producing a marker and
are nonverdicts.  Do not extend the order-256 jets merely to another
arbitrary cutoff: the first general bound found is 11,000 even on one line.
Exact true-projective-line reconnaissance (linear in `(A,B,Y,T)`, with
`T=Z-11A^2/18`) gives discriminant pattern `(1,2),(23,2),(39,1)`; this is
line evidence for a degree-39 simple component, not a certified global
factorization.  The old degree-21 `Z`-line is highly degree-dropped.
Pursue a base-ideal blow-up only if its exceptional-divisor ledger is
tractable.  In parallel, a positive attack may solve the varying-direction
conic/algebra condition or return to the full 15-coordinate self-adjoint
Pfaffian cubic.  Do not resume generic
12-by-36/four-relation Groebner bases, the naive projective homogenization, or
unstructured support sweeps.

New capped replays:

```sh
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_d5_constant_point/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_d5_constant_point_hostile_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_d5_constant_section_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_global_fixed_frame_hostile_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/full_scaled_frame_degree_attack/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/full_scaled_frame_degree_hostile_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_six_sheet_fixed_direction_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_six_sheet_branch_obstruction/verify.py
/usr/sbin/taskpolicy -m 1024 /opt/homebrew/bin/python3 -u tmp/six_sheet_next_attack_redesign/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/full_scaled_frame_branch_line_hostile_audit/verify.py
/usr/sbin/taskpolicy -m 1024 /opt/homebrew/bin/python3 -u tmp/target_branch_cubic_smoothness_line_probe/probe.py
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py build_hprime_rur_certificate.py
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py verify_hprime_rur_certificate.py
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_m2_1g_capped.py exactcert_derivative_rur_verify.m2
/usr/sbin/taskpolicy -m 1024 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_m2_1g_capped.py exactcert_hessian_rank_verify.m2
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py certify_kernel_cubic_rur.py
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py build_fourth_tensor_rur.py
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py certify_effective_quartic_rur.py
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py emit_raw_e_terms_tsv.py
/usr/sbin/taskpolicy -m 1024 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_julia_capped.py extract_exact_primitive_nemo.jl
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py audit_exact_primitive_rur.py
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py probe_exact_primitive_formal_good_primes.py
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py analyze_primitive_formal_pade_p29.py
/usr/sbin/taskpolicy -m 512 /opt/homebrew/bin/python3 -u tmp/target_branch_delta_saturated_singularity/run_python_capped.py audit_original_projective_relations_rur.py
```

All heavy subprocesses must retain their explicit hard wrapper and the
180-second timeout; the new RUR and Hessian replays use at most one GiB.  The stale
generic `reduced_algebra.m2` process was stopped; no generic Groebner job is
part of the accepted degree proof.

## 2026-07-30 audited delta

The main question is still whether the Klein cubic is
\(G=\operatorname{PSL}_2(\mathbf F_{11})\)-unirational.  The verdict remains
**OPEN**, but three live routes have materially sharper interfaces.

1. **KLS conductor geometry now closes the exact and a proper-multiple
   squarefree `P22` branch.**
   If a source divisor `D` dominates a conductor prime `T` on the
   normalization of a nonnormal image, then, with the notation of the packet,

   \[
   a_D=\epsilon_D(c_T+\mu_T),\qquad
   \beta_D=(\epsilon_D-1)+\epsilon_D\mu_T,
   \]

   so \(a_D-\beta_D=1+\epsilon_D(c_T-1)>0\).  More generally, if the
   restriction of `ord_D` extracts `E` over the normalization pair
   `(H^nu,C)`, then

   \[
   \beta_D-a_D=\epsilon_D A_E(H^\nu,C)-1.
   \]

   Multiplicity one on a conductor branch forces an immersed transverse node
   and \(\beta_D=0\).  A squarefree factor centered in codimension at least
   two has \(\beta_D\ge1\), so it cancels from `deg(h)-deg(b)`.
   Independently, the unique invariant quintic is normal, and the complete
   invariant sextic
   pencil \(f_6+t f_3^2\) is universally integral and normal: its universal
   Jacobian scheme has affine dimension `2` over both `QQ` and `GF(67)`.
   Hence a nonnormal non-Klein image has degree at least seven.  If the full
   gcd has the form `h=P22*k`, where the `P22` factors are the complete
   conductor-dominating support and `k` is coprime, squarefree, and centered
   in codimension at least two after normalization, the KLS degree identity
   still forces `d<=9`; the complete dominance certificates through degree
   nine exclude the branch.  Arbitrarily repeated `k` is also excluded when
   every associated discrepancy is at least one.  The exact remaining
   singularity threshold is now sharp: because \(K_{H^\nu}+C\) is Cartier,
   target-pair lc leaves at most one reduced copy at an `A_E=0` place, while
   plt at an exceptional codimension-at-least-two center gives integral
   `A_E>=1` and full cancellation.  This does not apply to conductor
   divisors themselves.  Explicit homogeneous rank-four countermodels show
   that normality plus log canonicity of the kernel foliation does not imply
   this positivity, and a fixed nodal plt pair admits arbitrarily many source
   divisors over one conductor branch.  Thus the remaining theorem must use
   representation-specific minimality to avoid non-plt places and must
   separately exhaust or bound conductor pullback support.  The countermodels
   are non-`G` and nonminimal, so they refute the shortcut, not the KLS route.

2. **The unrestricted Schur twist has a real degree-55 point, not merely a
   cycle.**  A maximal `D12` stabilizes an honest two-dimensional summand
   whose projective line lies on the Klein cubic and has full stabilizer
   `D12`.  Twisting gives every `G`-twist an effective degree-55 zero-cycle
   and gives the generic Schur twist an exact degree-55 closed point.  With
   a degree-three linear section this proves index one, but not a rational
   point.  Balestrieri gives only a point over some degree at most `107`;
   Ma's degree-seven theorem does not apply.  The sharp positive target is a
   torsor-dependent degree-19 curve through the degree-55 point with proper
   multiplicity-one intersection, leaving a residual degree-two cycle.  A
   constant invariant degree-19 curve is impossible because `57<60`, the
   minimum complex point-orbit size.  The sharp negative target is any
   boundary-zero `G`-torsor over an infinite field whose Klein twist has no
   point; the earlier proposed rank-three valuation realization is optional,
   not necessary.  The degree-19 design is now narrower.  For every exact
   line-orbit point whose geometric semilinear stabilizer is the certified
   maximal `D12`, purity, properness, and multiplicity one force any
   qualifying degree-19 curve to be geometrically integral.  For a descended
   torsor-dependent hyperplane choice, the 55 points have Hilbert function
   `1,4,10,19,31,45,55,...`, and no geometrically integral ACM degree-19
   curve can contain them properly.  The ACM statement is scoped to this
   hyperplane-selected point.  Non-ACM integral curves remain live; a smooth
   rational survivor would have degree-five Rao dimension `40` or `41`.
   The same hyperplane can be chosen so that
   `Y=V(f3,f5)` is a smooth geometrically integral `(3,5)` complete
   intersection of degree `15` and genus `31`.  The point ideal has five new
   sextic generators, identified with
   `H0(Y,O_Y(6)(-Z))`; this line bundle has degree `35`, `h0=5`, and `h1=0`.
   A smooth rational survivor has the exact Rao ledger
   `(0,16,29,38,42,40+epsilon)`, `epsilon in {0,1}`.  If `epsilon=1`, the
   unique quintic carrier is `f5+f3*q` and `Y~3H`.  Picard rank one for the
   actual carrier would exclude degree `19`, but the standard
   Brevik--Nollet/Lopez theorem is unavailable because
   `I_Y(4)=f3*S1` is not globally generated; a very-general theorem would
   not control a special carrier selected by the unknown curve.  The
   `(5,6)` and `(5,7)` liaison genera `-28` and `-12` constrain only reduced
   connected residuals.  Thus neither the no-quintic branch nor the special
   quintic-carrier branch is closed.

3. **The Pfaffian idempotent now exists abstractly and its coordinate gate is
   one cubic.**
   The Pfaffian generators align exactly with the repository Weil model,
   \(\dim\operatorname{Hom}_G(W,\wedge^2V_6^*)=1\), and 36 explicit Reynolds
   covariants give a generic rational `K_proj`-basis of the descended
   degree-six algebra.  An exact rank-25 map
   `End(W)->End(V6)` plus eleven complement covariants gives a normalized
   projective frame; the combined determinant is `7 mod 23`.  The map
   `End(W)->End(V6)` is linear, not multiplicative.  Ordinary `6 x 6`
   matrix circuits give the correct multiplication formula, although only
   the mod-23 frame is currently instantiated end to end; a checked-in
   generic `K_proj` frame constructor is still absent.  The correct
   involution is not constant: if `Q(x)=Jx`, then

   \[
   \operatorname{Pf}Q(x)=\lambda f_3(x),\qquad
   \sigma_x(M)=Q(x)^{-1}M^tQ(x),\qquad \lambda\ne0.
   \]

   Multiplication, involutivity, and anti-multiplicativity have exact replay.
   The generic Brauer class has period and index exactly two, so the algebra
   is abstractly `M3(D)` for a quaternion division algebra and a
   `sigma`-self-adjoint reduced-rank-two idempotent exists.  Fifteen explicit
   symmetrizations form a `K_proj`-basis of `Sym(A,sigma)`.  For
   `a=sum(u_i*S_i)`, it is enough to solve

   \[
   c_3(a)=0,\qquad c_2(a)\ne0,
   \]

   because

   \[
   e=(a^2-c_1(a)a+c_2(a)1)/c_2(a)
   \]

   is then a reduced-rank-two idempotent.  This cubic is known abstractly to
   have a `K_proj`-point, but its coordinates in the installed basis are not
   known.  The tempting direct map to `Gr(2,V6)` is independently excluded
   for every homogeneous covariant through degree eight; this is bounded and
   says nothing about rational covariants with invariant denominators.
   Independently, the degree-14 Reynolds frame removes `B^-1` from the
   Pfaffian numerator.  Every one of the 105 binary restrictions to a
   coordinate pair is geometrically irreducible: saved factor types `[3]`
   and `[1,2]` force arithmetic monodromy `S3` and transitive geometric
   monodromy.  Thus an explicit cubic point uses at least three coordinates
   in this basis.  All 455 coordinate ternary cubics are now proved smooth
   and geometrically integral over `K_proj`; hence no coordinate-plane
   singularity, reducibility, or line-factor shortcut remains.  This is a
   basis-dependent theorem, not an all-plane statement.  The unique minimal
   fixed-frame triple `(0,1,2)` has the exact depressed model

   \[
   u^3+u(q_0v^2+q_1vw+q_2w^2)
     +r_0v^3+r_1v^2w+r_2vw^2+r_3w^3=0,
   \]

   with all seven coefficients explicitly recovered in `K_proj`.  Exactly
   34 of the 38 ambient invariant-basis slots are nonzero; the four zeros are
   the two complete `u^2v,u^2w` rows.  Its Hessian, `c4`, `c6`, discriminant,
   Jacobian, and flex scheme are exact, and the projector open is

   \[
   c_2=F_u=3u^2+q_0v^2+q_1vw+q_2w^2\ne0.
   \]

   Neither the primary packet nor its independent hostile audit finds or
   obstructs a `K_proj` point.  The first torsor-arithmetic layer is now
   compact and exact.  On `w=1`, eliminating the Hessian gives a monic
   degree-nine flex polynomial `Phi(t)` and `u=-L0/L1`; its algebra is a
   degree-nine field over `K_proj,C`, so the curve has no rational flex.  The
   Jacobian 3-division quartic is likewise irreducible, excluding rational
   nonzero 3-torsion and even a rational cyclic order-three subgroup.  These
   conclusions use transitive constant-geometric monodromy, not merely
   finite-field factorization.  They do **not** exclude an arbitrary rational
   point or decide the torsor class.  The first genuine divisorial test also
   closes negatively as an obstruction: with the weight-zero uniformizer
   `pi=f3*f5/f8`, the `f3=0` model has a simple Hensel point and `F_u!=0`, so
   even a local projector exists over that completion.  Its special fibre is
   exactly `L(v,w)^2*(C*U+M(v,w))`.  At `f5=0`, the integral scaling gives an
   explicit generically smooth residual genus-one cubic, but its point over
   the residue field is undecided.  The genuine affine `E[3]` cocycle and
   first Kummer representative are now exact: the compact circuit constructs
   `alpha_R in R^x/R^(x3)`, and an independent two-sheet hostile audit checks
   the translation orientation and rank-729 Cech triple overlap.  The
   normalized first-descent interface has ten variables and nine cubics,
   decomposing geometrically into 729 degree-nine components.  There is no
   new component-torsor obstruction: `alpha_R=w1(xi)` forces one
   base-defined component to recover the original covering.  The exact local
   Kummer comparison, with prime-`3` injectivity of `w1` made explicit,
   retires `f3=0`: its Hensel point forces local membership.  At `f5=0`, the
   primitive rescaled cubic is a proper smooth model, its Jacobian has good
   reduction, and local membership is equivalent to a point on the residual
   cubic.  The saved nine raw `alpha_R` coordinates must not be reduced
   componentwise: the mixed-weight DAG result is only a min-free
   homogeneity diagnostic, and an integral cube gauge is required.  The
   residual curve descends exactly to
   `F0=C(A,Y,Z)`, with `A=f6/f3^2`, `Y=f9/f3^3`, and `Z=f12/f3^4`.
   A direct characteristic-zero Jacobian witness proves that these are
   independent parameters.  The `f3=1` scalar slice may be disconnected;
   the corrected statement is that it is a finite-etale `mu3` torsor over
   the integral projective chart.  The exact characteristic-`67` fibre of
   length `3960` does **not** by itself bound generic rank, because solutions
   can escape to the nonempty boundary.  A new generic characteristic-zero
   computation supplies the missing theorem: after setting
   `f3=1,f5=0,f6=A`, the rank-12 Hironaka module quotient by `f9-Y` and
   `f12-Z` has exact length `6` over `QQ(A,Y,Z)`.  Dividing by the scalar
   `mu3` rank gives `[k(D5):F0]=2` exactly.  A point over the residue field
   therefore pushes to degree two; with the plane degree-three divisor and
   genus-one Riemann--Roch it yields an `F0`-point.  Thus the residue
   extension cannot create a point.  The `A`, `Y`, and `Z` infinity places
   are locally soluble, while the distinguished double-root direction is
   empty even over the quadratic residue field.  The leading gate is now the
   genuine residual Kummer class or a non-coordinate discriminant divisor
   for the explicit cubic over `C(A,Y,Z)`.  After a global point come the
   quaternion corner, five Hermitian matrices, and common isotropic right
   line.

Priority order is now: (i) decide the explicit residual cubic over
`C(A,Y,Z)` through its genuine `E[3]` class or a non-coordinate
discriminant divisor, then construct a global point with `F_u!=0` and the
quaternion corner; (ii) attack the no-quintic marked-incidence Schur branch
or degree-19 divisors on special quintic carriers, or construct a
boundary-zero no-point torsor; and (iii) prove a minimality-to-plt/non-lc-place
avoidance theorem together with a separate KLS conductor-support theorem.
Do not restart an unstructured high-degree, sparse-support, coordinate-place,
or component sweep.

Exact replays:

```sh
/opt/homebrew/bin/python3 -u tmp/kls_actual_conductor_geometry/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_actual_conductor_geometry_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_f5_normality/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_f5_normality_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/schur_unrestricted_point_attack/verify.py
/opt/homebrew/bin/python3 -u tmp/schur_unrestricted_point_attack_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_representation_alignment/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_representation_alignment_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_25plus11_descent/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_25plus11_descent_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/quadratic_grassmannian_covariant/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_rank2_idempotent_attack/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_rank2_hostile_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_binary_cubic_attack/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_binary_cubic_geometric_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/kls_proper_multiple_structure/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/kls_proper_multiple_structure_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_ternary_cubic_triage/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_ternary_cubic_hostile_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_minimal_ternary_model/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_minimal_ternary_model_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_depressed_torsor_next/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_depressed_torsor_next_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_torsor_valuation_attack/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_torsor_valuation_attack_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/kls_discrepancy_next_gate/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/kls_discrepancy_next_gate_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/schur_degree19_structural_design/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/schur_degree19_structural_design/exact_rank.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/schur_degree19_structural_design_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_depressed_alpha_r/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_depressed_alpha_r/verify_interface.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_depressed_alpha_r_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_alpha_local_kummer/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_alpha_local_kummer_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_d5_residual_attack/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_d5_residual_attack_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_d5_residual_attack_audit/module_probe.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/d5_degree_bound_invariant_salvage/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/pfaffian_d5_degree_projective_audit/verify.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/schur_degree19_nonacm_attack/replay.py
/usr/sbin/taskpolicy -m 2048 /opt/homebrew/bin/python3 -u tmp/schur_degree19_nonacm_attack_audit/verify.py
```

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
> degree-256 endomorphism finding — the minimal-contraction/canonicity
> theorem isolated by the global foliation identity, or an effective bound
> for one MINIMAL solution (the uniform
> bound is dead: precomposition saturates degrees 4^n d); (2) genuinely
> full-threefold Schur, Pfaffian, or torsor-arithmetic constructions; and
> (3) a Fable redesign only if it changes the accepted order-three/four line
> germs or their leading normal order.  Both the global `q_P R_P` ansatz and
> its proposed primitive nonfactorized replacement are now obstructed.  The
> selected `xCD` plane and
> its former local class-image gate are closed negatively at their proper
> scope.  Bounded
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

### 2026-07-29 structural KLS, Schur, and Pfaffian update

- The normal-image orbit-eleven KLS branch supported on the `A5` quadrics is
  now **closed**.  Let `Phi:W->W` be a primitive homogeneous rank-four
  self-covariant, `H=V(F)` its image, and
  `h=gcd_i F_i(Phi)`.  If `H` is normal, neither maximal-`A5` invariant
  smooth quadric `Q_A5` can divide `h`.  Indeed, such divisibility would map
  `Q_A5` rationally and equivariantly onto a rational curve in `Sing(H)`.
  The quadric cone is factorial, so its primitive rational pencil would span
  an honest two-dimensional `A5`-subrepresentation; no such representation
  exists.  Consequently the squarefree product `P22` of the eleven
  translates cannot occur in `h`.  The former degree-25 and degree-28
  `P22` fields are therefore no longer normal-image KLS candidates,
  regardless of their scalar first integrals.

  The same packet proves a general normal-image multiplicity theorem.  In

  \[
  \operatorname{adj}(D\Phi)=b\,v\,\bar A^t,
  \qquad \bar A=(\nabla F)(\Phi)/h,
  \]

  one has

  \[
  \operatorname{rad}(h)\mid b.
  \]

  If `s=deg(h)`, `rho=deg(rad(h))`, `r=deg(v)`, `t=deg(b)`,
  `d=deg(Phi)`, and `e=deg(H)`, then

  \[
  s-\rho\ge r+d(e-5)+4.
  \]

  Thus for a normal non-Klein image, where `e>=5`, every nonzero `h` is
  non-squarefree and has multiplicity excess at least `r+4`.  This does not
  prove `h=1`.  The viable KLS branches are a nonnormal image with a
  divisorial conductor surface, another `A5`-stabilized factor not covered
  by the smooth-quadric pencil theorem, repeated normal factors satisfying
  the multiplicity excess, and stable components with non-rational
  singularities.  See
  `tmp/kls_a5_linearized_pencil_obstruction/REPORT.md` and its independent
  `AUDIT.md`; replay
  `/opt/homebrew/bin/python3 -u tmp/kls_a5_linearized_pencil_obstruction/verify.py`.

  Normality is essential here.  For either maximal `A5`, the invariant
  smooth quadric `Q_A5` admits a dominant `A5`-equivariant rational map
  `Q_A5 --> P2` given by three cubic sections.  Thus a divisorial image in a
  nonnormal conductor surface is representation-theoretically possible, and
  the normal-image pencil argument has no blanket surface analogue.  This
  does not construct a KLS self-covariant or conductor surface.  It retires
  only the proposed general prohibition on equivariant maps from `Q_A5` to a
  surface; a successor must use conductor adjunction, normalization
  compatibility, Jacobian multiplicities, or the self-covariant origin of
  the map.  See `tmp/kls_a5_conductor_surface_feasibility/REPORT.md` and its
  `PROOF_AUDIT.md`; replay
  `/opt/homebrew/bin/python3 -u tmp/kls_a5_conductor_surface_feasibility/verify.py`.

- The exhaustive Schur frame has a new degree-independent route audit.  All
  ten ternary coordinate sections are smooth geometrically integral
  genus-one curves.  The generic Schur twist has no rational line and no
  geometrically integral ground-field plane conic.  Picard rank one excludes a nonconstant regular
  fibration from the smooth twist to a lower-dimensional projective base,
  and smoothness excludes a projective-linear separated cubic norm equation
  `N_(L/K)(z)=B_3(u,v)`, whose split form has three universal singular
  coordinate points.

  Projection from any ambient coordinate line nevertheless gives, after
  blowing up its irreducible degree-three base scheme, a genus-one fibration.
  With `v=s e_i+t e_j` and base vector `r_b`, its exact generic fibre is

  \[
  P_{ij}(s,t)+3uB_\Phi(v,v,r_b)+3u^2B_\Phi(v,r_b,r_b)
  +u^3\Phi(r_b)=0.
  \]

  The Picard calculation is now exact for all ten fibrations.  If
  `Y=Bl_D(X)`, then `Pic(Y)=Z*H direct_sum Z*E` and
  `H.F=E.F=3`, so every horizontal divisor has fibre degree in `3Z`.
  Therefore none of the ten fibrations has a rational section, and its
  generic fibre has exact index and period three.  The former
  `xi_ij=0`/3-descent section target is retired.  This is not a no-point
  theorem: a point may still lie on a special fibre or elsewhere on the
  threefold.  Chevalley--Warning makes every closed finite-field
  specialization of the five-variable cubic soluble, and Tsen makes every
  one-parameter specialization over algebraically closed constants soluble.
  A negative specialization must retain at least two parameters.  See
  `tmp/schur_structural_routes/REPORT.md` and its `PROOF_AUDIT.md`, followed
  by `tmp/schur_fibration_picard_obstruction/REPORT.md` and its
  `PROOF_AUDIT.md`; replay
  `/opt/homebrew/bin/python3 -u tmp/schur_structural_routes/verify.py` and
  `/opt/homebrew/bin/python3 -u tmp/schur_fibration_picard_obstruction/verify.py`.

- The generic Schur boundary class is now proved nonzero.  For the generic
  projective versal torsor,

  \[
  0\ne\alpha_{\rm proj}\in\operatorname{Br}(K_{\rm proj})[2],
  \qquad \operatorname{ind}(A_{\rm proj})=2.
  \]

  Hence the twist of `P(V6)` is a nonsplit Severi--Brauer fivefold, is not
  stably rational, and admits no stable replacement by projectivizations of
  honest `G`-representations.  Passing to two-planes removes the ambient
  obstruction exactly.  Writing `A_proj=M_3(D_proj)` for a quaternion
  division algebra,

  \[
  {}^{T_{\rm proj}}\!\operatorname{Gr}(2,6)
  =\operatorname{SB}_2(A_{\rm proj})
  \simeq\mathbf P^2_{D_{\rm proj}}
  \]

  is rational, with affine chart `D_proj^2`.  The residual Fano gate is
  exactly whether the distinguished five-plane of quaternionic Hermitian
  forms on `D_proj^3` has a common isotropic right `D_proj`-line.  Such a
  line is headline-positive through the Pfaffian bridge and quadratic
  descent.  The proposed anisotropic-member certificate is now impossible.
  The degree-55 orbit of an `A4`-fixed point on `F14` gives, after twisting,
  a common line over an odd-degree residue extension.  For each individual
  Hermitian form, its underlying 12-dimensional quadratic form is therefore
  isotropic over an odd extension and hence already isotropic over the base
  by Springer.  This does not descend one line common to all five forms.
  Thus the only residual Pfaffian gate is simultaneous common isotropy.
  The explicit generic quaternion and five global Hermitian matrices are not
  yet installed; build them through characteristic-zero representation
  alignment, descent of the 36-dimensional algebra with involution, Morita
  reduction, and transport of the five-plane, then solve only the common-line
  problem.  See `tmp/pfaffian_generic_schur_audit/REPORT.md` and its
  `PROOF_AUDIT.md`, followed by `tmp/pfaffian_explicit_descent/REPORT.md` and
  its `PROOF_AUDIT.md`; replay
  `/opt/homebrew/bin/python3 -u tmp/pfaffian_generic_schur_audit/verify.py`
  and
  `/opt/homebrew/bin/python3 -u tmp/pfaffian_explicit_descent/verify.py`.

### 2026-07-29 xCD completion and Fable update

- The `xCD` general-slice census, defect, and factoriality chain is now
  complete at its exact **plane-cubic** scope.  The independently audited
  Saito comparison gives restricted-source rank `660+60=720`, and the Cayley
  bridge identifies surjective localization with `def(Y)=0`.  The missing
  census is supplied without the three abandoned global rank charts.  Over
  `F_67` the invariant rank radical has the known `f11` axis and four extra
  components; exact residue-field discriminants show that every extra binary
  cubic is squarefree, so none supports a vertical singular curve.  On the
  axis, the saturated projective repeated-factor incidence has local Hilbert
  function `1,2,3,2,1` and length nine over both `QQ` and `F_67`.  Its entire
  special length is `60*9=540`, while the known generic orbit already
  contributes 540.  Properness therefore excludes every extra generic
  repeated-factor base.  Together with the `L=0` total-incidence theorem this
  proves that the reduced positive-dimensional support of `Sing(C6)` is
  exactly the 120 known fibre lines.

  A genuinely general ample slice avoids the residual isolated singular
  points and the 60 line vertices, meets every line transversely in three
  points, and lies in the already certified rank-720 open.  It consequently
  has exactly 180 `A3` and 180 ordinary four-branch `cA` singularities,
  `def(Y)=0`, and makes `Y` and `C6` factorial.  Thus

  ```text
  Cl(C6)=Pic(C6)=Z*H direct_sum Z*xi,
  horizontal Weil degrees = 3Z,
  C6_eta(C(H6)) = empty.
  ```

  Proper specialization then proves that the original projective `xCD`
  plane cubic has no `K_proj,C`-point.  This closes the construction
  `F(a*x+b*C+c*D)=0`; it does **not** prove that the full generic twisted
  Klein cubic threefold has no point.  The headline remains open.  Replay
  `tmp/xcd_invariant_fibre_discriminants/verify.py`, its independent audit,
  `tmp/xcd_repeated_factor_incidence/verify.py`,
  `tmp/xcd_singular_curve_enumeration_audit/verify.py`, and
  `tmp/xcd_general_slice_completion/verify.py`, in addition to the local
  comparison and global bridge replays.
- The three superseded `L=1` sparse rank solvers were all terminated with
  zero-byte outputs and are noncertificates.  A 15-prime modular radical
  experiment retained degree 27 and one leading-monomial signature, but a
  14-prime CRT modulus still failed withheld-prime rational reconstruction;
  conditionally, every nonleading coefficient has height above
  `65154001869447`.  This makes no `QQ` support claim and is retired for the
  census, which the proper length comparison decides directly.  Replay
  `tmp/xcd_invariant_module_multiprime/verify_reconstruction.py` only for
  provenance.
- Fable's first nonlinear gate is now solved at sufficiently high twist.  An
  exact Koszul construction produces a nonzero compatible
  `sigma in H0(~(I^(3)/I^(5))(d) tensor W)^G` with the prescribed
  trisections and `F(sigma)=0 mod I^(11)`.  The independent audit checks all
  three cyclic factorizations, the common `D12` reflection-sign character of
  `R` and `q`, invariant `eta`, and one common multiplier in the finite
  thickened-line rings.  Ordinary invariant averaging of `R` or `q` would be
  wrong.  The theorem closes only `I^(9)/I^(11)`.  At the then-next
  `I^(11)/I^(13)` gate, a denominator-free polynomial correction on one edge
  and both `Q`-roots is now certified inside the exact Koszul tangent space.
  Its naive cyclic transports fail the degree-seven `J3/J5` equalizer in six
  explicit nonzero-versus-zero coefficients, but the full joint calculation
  now repairs all six conflicts by explicit `Q`-multiples.  The minimal
  Koszul-parameter equalizer has `30` parameters, rank `24`, three genuine
  invariant output directions, and full rank one on the invariant residue
  target.  Explicit odd/even `delta q` witnesses in degrees seven and eight,
  propagated by `H2=x^2+y^2+z^2`, split the normalized simple-`Q` residue in
  every transverse degree.  They also give a finite-cutoff triangular
  nonlinear recursion.  The companion exact correction calculation proves
  that the full ambient `J5/J7` image is the kernel of that residue in every
  transverse degree: the low grades 6 and 7 have zero residue-cleared bulk,
  degrees 8 through 14 have exact ranks `1,2,3,4,5,5,6`, and `H2` propagates
  both stable parity strands.  Corrections tangent to the strict Koszul
  factorization have zero bulk image, but the ambient `I^(5)/I^(7)` source is
  the correct source after the first gate.

  This closes the complete normalized associated-graded module at a generic
  centre line, but the attempted global promotion is now **obstructed**.
  On a whole plus-plane the factorized ansatz has a relative quadratic
  divisor `Z_P=V(q_P)`.  If its necessary raw residue
  `F(p4_P)|Z_P` vanished, `[p4_P]` would define an equivariant rational map
  from the horizontal quadratic algebra to the smooth elliptic plane section
  `E_P`.  Its elliptic trace descends to `P^2` and is therefore constant.
  But `C_G(t)/<t>=S3`, and its order-three element acts on `E_P` as
  translation by a nonzero three-torsion point `T`; equivariance shifts the
  trace by `2T != 0`.  This contradiction works for irreducible, split,
  nonreduced, singular, nonnormal, or irregular double planes.  An exact
  common-basis audit independently finds six distinct boundary values in one
  `S3` orbit for each character cut.  Thus the conditional high-factor bulk
  theorem has an impossible antecedent for this factorized branch.

  The specific global `p3=q_P R_P`,
  `p4=i_(Gamma_RP)(eta_P)` Fable family is closed at the first full
  `I^(11)/I^(13)` gate.  The proposed primitive nonfactorized replacement is
  now closed as well.  The constant polarization
  `Sym^2(E_-(t)) -> E_+(t)^*` is an isomorphism, so after a constant basis
  change `Gamma_(A,B)=(A^2,AB,B^2)`.  Hilbert--Burch forces every regular
  `p4` syzygy for a primitive pair into `(A,B)E_+`, hence makes it zero at
  the six forced common-zero sections where the prescribed Fable `p4` is
  nonzero.  If `(A,B)` has a common divisor, those same two roots on each
  line force it to be quadratic and to restrict to `Q`; this is exactly the
  trace-obstructed factorized case.  The independent feasibility audit also
  gives minimum base coefficient degree `m=2`, raw interpolation dimension
  `(m-1)(4m-5)`, and resultant degree `6m` with multiplicity at least two on
  each centre line; after the forced line factors are stripped, the entire
  regular syzygy kernel has auxiliary bidegree `(2,1)` and only 24 scalar
  parameters, independent of the ambient degree.  Thus the proposed scheme
  of exactly six reduced sections was already degree-incompatible.  Hence
  **every planewise normal-order
  3/4 extension retaining these fixed line germs is impossible**.  A Fable
  escape must change the boundary data or the leading normal order.  Later
  towers, algebraization, dominance, and the headline remain open.  Replay
  `tmp/fable_first_gate_koszul/verify.py` and
  `tmp/fable_first_gate_koszul_audit/verify.py`, then
  `tmp/fable_d12_simultaneous_successor/verify.py`, its
  `verify_transport_equalizer.py`, and the independent
  `tmp/fable_order12_qsection_correction/verify.py`, then
  `tmp/fable_d12_joint_rank/verify.py`,
  `tmp/fable_d12_joint_rank/verify_all_grades.py`, and
  `tmp/fable_d12_koszul_rank/verify.py`, then
  `tmp/fable_d12_module_adversary/verify.py`,
  `tmp/fable_d12_module_adversary/verify_bulk.py`,
  `tmp/fable_d12_bulk_correction_rank/verify.py`, and
  `tmp/fable_d12_triangular_bulk_closure/verify.py`, then
  `tmp/fable_relative_divisor_trace_obstruction/verify.py`,
  `tmp/fable_fixed_plane_boundary_adversary/verify.py`,
  `tmp/fable_relative_q_trace_obstruction/verify.py`,
  `tmp/fable_nonfactorized_successor/verify.py`,
  `tmp/fable_nonfactorized_syzygy_obstruction/verify.py`, and
  `tmp/fable_nonfactorized_feasibility/verify.py`.

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
  `tmp/char0_lift_p20_d5/REPORT.md`.  The grandfathered coordinate `P^21`
  degree-five test is now complete and is a strict nonverdict.  Its exact
  split-`F_67` matrix has shape `21407 x 7911` and coefficient SHA256
  `aaa835c09cf5dafea89678d9370eb359cc511c2721e0315904d1eefc60c3c4b7`.
  The first 3,933 columns are independent, while an explicit normalized
  vector in `F_67^3934`, with last coordinate one, gives a coefficientwise
  dependency among columns `0,...,3933` in all 21,407 rows.  Therefore the
  only certified total-rank statement is
  `3933 <= rank <= 7910`; the exact total rank was not computed.  This fixed
  candidate family fails the sufficient full-rank test, so it proves no
  coordinate-`P^21` emptiness and does not improve `dim Z<=15`.  The
  conditional full-rank replay and the canonical characteristic-zero
  DVR/upper-semicontinuity promotion to `dim L_25<=14` did not trigger.  No
  `P^22` or successor slice was launched.  The accepted peak RSS was
  `555.171875 MiB`.  See
  `tmp/m1_relative_border_p21_d5_design/REPORT.md` and its
  `PROOF_AUDIT.md`.  Degree
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
  global image/foliation successor is now exact.  Every KLS solution has
  three-dimensional projective image an irreducible invariant unirational
  hypersurface `H=V(F)`.  If `H` has canonical singularities, adjunction and
  vanishing of the plurigenera of a unirational resolution give `deg(H)<=4`;
  Adler's invariant ledger then forces `H` to be the Klein cubic.  More
  generally, with `h=gcd_i (partial_i F)(q)`, primitive right-kernel vector
  of degree `r`, and residual adjugate factor of degree `t`, one has
  `deg(h)=r+t+d(deg(H)-5)+4`.  Hence `h=1` again forces the Klein cubic, while
  every non-Klein image requires a nonzero invariant divisor mapped into
  `Sing(H)`; for `deg(H)>=5` its degree is at least
  `d(deg(H)-5)+4`.  In the Klein branch `r+t=2d-4`.  The quartic free
  decomposition is not differential: its defining ideal is not
  derivation-stable and the finite map has ramification divisor `15H`.
  Thus the valid successor is the **minimal contraction lemma** excluding
  that singular-image divisor for one minimal KLS solution, or a theorem
  making its image canonical; neither is proved.  Replay with
  `python3 tmp/kls_divisor_ansatz/verify.py` and
  `python3 -u tmp/kls_residue_next/verify.py`, then
  `python3 tmp/kls_first_jet_two_fiber/verify_manifest.py`,
  `python3 tmp/kls_first_jet_two_fiber/verify.py --ledger-only`,
  `python3 tmp/kls_first_jet_two_fiber/verify_manifest_p5.py`, and
  `python3 tmp/kls_first_jet_two_fiber/verify_p5.py --ledger-only`, then
  `python3 -u tmp/kls_first_jet_three_fiber/verify_combined_p8.py`,
  `python3 -u tmp/kls_structural_audit/verify.py`, and
  `/opt/homebrew/bin/python3 -u tmp/kls_structural_successor/verify.py`, then
  `/opt/homebrew/bin/python3 -u tmp/kls_global_foliation_theorem/verify.py`.
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
  the original projective `xCD` cubic.  The general-slice theorem now proves
  that this component has no `K_proj,C`-point; do not resume its former
  class-image or point-search subroute.  Exact Hensel pilots rule out every prime
  component of `A=0`, `B=0`, and `C=0` as a local-obstruction place.  The
  degree-120 discriminant packet now rejects every one of its height-one
  components as well: its pullback is squarefree and gauge-coprime, every
  normalized discriminant valuation is one, and Poonen--Stoll gives a
  residue-rational node which lifts to a local point.  The two motivated
  smooth-reduction primes `f5=0` and `f6=0` are geometrically integral and
  have alternate unit gauges.  Their coordinate vertices and every complete
  invariant-polynomial `x,C,D` ansatz through total degree 15 are empty.  This
  was not itself a local obstruction; the later `f6=0` degree-image theorem is.
  The `f5=0` residue remains unresolved only as an alternative diagnostic; a
  genuinely full-threefold point or obstruction is the live arithmetic target.
  Do not use
  arithmetic-prime or `QQ`-only Selmer
  results as negative evidence, enter a splitting field, or expand an `81 x 81`
  determinant.  The proved nonpoint theorem closes only this `xCD` plane
  construction, not the headline.  Replay with
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
  geometric reducedness is false, and total-space factoriality does not
  follow from fibre geometry.  The first codimension-three class maps are now exact.
  `Sing(H6)` is one 60-point orbit of `A3` points, with Jacobian-scheme length
  `60*3=180`.  The July 27 Jung--Saito formula now gives an exact new theorem.
  The sextic two-block ranks are `75,2125,2200`, its characteristic-zero
  degree-13 Jacobian quotient has dimension 255, and therefore
  `def(H6)=0`.  Jung--Saito factoriality yields

  ```text
  Cl(H6)=Z[O_H6(1)].
  ```

  Every algebraic local ring of `H6`, including after extension to
  `C(lambda)`, is a UFD.  At the simple fibre line the **completed and
  henselian** base map on class groups is an isomorphism.  At the doubled
  line the total completed local ring has four branches and the map is
  `Z -> Z^3`, `1 |-> (1,1,0)`, with cokernel `Z^2`.  The actual algebraic
  base class group is zero: `(1,1,0)` is a class created by completion, not
  an algebraized base divisor.  This still neither proves `B` or `C6`
  factorial nor excludes a primitive total horizontal Weil class.  The
  global Picard/Cartier step is now closed.  Correcting the projective-bundle
  convention gives the ample cubic class `D=3*zeta=15H+3xi`; exact
  all-negative-twist vanishing and SGA 2 give

  ```text
  Pic(C6)=Z*H direct_sum Z*xi,
  Pic(C6) -> Pic(Y) is an isomorphism for an effective-Cartier Y in |D|.
  ```

  Hence every Cartier horizontal degree is in `3Z`.  For general `Y`,
  Ravindra--Srinivas identifies the Weil class groups, so the `Cl/Pic`
  defects agree.  The singular-locus input is now certified:
  `dim Sing(C6)<=1`.  An `L^2*M` fibre forces rank at most two for the
  `6 x 3` coefficient matrix of its fibre derivatives.  Modulo 67, `f6`
  and the twenty maximal minors have unit ideal on one chart of the cyclic
  hyperplane `w0+...+w4=0`; cyclic symmetry, properness, and the projective
  dimension theorem give the characteristic-zero bound.  The activating
  census is now exhaustive.  Four non-axis invariant rank-support branches
  modulo 67 have squarefree induced binary cubics.  On the known axis, the
  intrinsic saturated projective repeated-factor incidence has local length
  nine over both `QQ` and `F_67`; its full special length and the known generic
  contribution are both `60*9=540`.  Properness excludes every extra
  characteristic-zero repeated-factor base.  Together with the `L=0`
  verticality theorem, this proves that the reduced positive-dimensional
  support of `Sing(C6)` is exactly the 120 known fibre lines.  A general ample
  slice avoids the residual isolated points and vertices and meets the lines
  transversely in 180 `A3` plus 180 ordinary four-branch `cA` points.  The
  actual rank-720 localization therefore proves `def(Y)=0`; Jung--Saito makes
  `Y` and `C6` factorial and forces the full Weil degree image to be `3Z`.
  The residue plane cubic has no `C(H6)`-point, and proper specialization gives
  no `K_proj,C`-point on the original projective `xCD` plane cubic.  This is a
  theorem only about the distinguished plane section; it does not exclude a
  point elsewhere on the full generic twisted Klein cubic threefold, and the
  headline remains open.

  The class-image/Rees discussion below is retained as a failure ledger for
  an alternative proof of that plane-section theorem.  It is no longer a live
  gate.
  A pulled-back base hyperplane is not ample, and
  one fixed `lambda` specialization has no certified injective class
  specialization.  Exact
  enumeration gives full stabilizer `C11`; it fixes all four branches, so the
  invariant henselian defect still has rank two.  The two within-pair branch
  differences span only an index-four sublattice, so primitive individual
  branch patterns cannot be discarded.  The recent algebraic splitting lemma
  upgrades the factors from formal to henselian, but individual Zariski
  descent and globalization remain unproved inside that retired route:
  height-one contraction is guaranteed, while re-extension may recover a
  grouped sum of conjugate branches.  Its formerly next structural gate was
  the image of the global class group in the four boundary valuations of the normalized
  `G`-equivariant weighted Rees model, followed only then by horizontal fibre
  degree.  That local decision interface is now exact.  The
  section-preserving weighted Rees family has weights
  `(x,y,z,t,c)=(2,2,2,1,1)`, survives at both `s=0` and `s=1`, and has special
  hypersurface `u*v+g4(t,c)`.  Over the quartic splitting field its four
  primitive branch modules have explicit `2 x 2` matrix factorizations.
  Individual descent is equivalent to a graded, `s`-torsion-free rank-one
  reflexive Rees lattice whose special reflexive hull is primitive `I1` or
  `I3`.  The defect-free `2 x 2` ansatz is now solved to **all formal
  orders**.  After `s`-adic implicit elimination, the tangent determinant map
  is surjective in every weight by an explicit binary-form right inverse;
  determinant induction therefore gives four formally homogeneous matrix
  factorizations over `K[u,v,t,c][[s]]`.  Their cokernels are
  `s`-torsion-free rank-one MCM/reflexive modules with actual special fibres
  `I1,...,I4`.  Thus no higher finite-order matrix-factorization obstruction
  exists, and an order-five sweep is retired.  This is still only an
  `s`-adic/topological grading: the infinite matrices cannot be evaluated at
  `s=1` and are not finite algebraic `G_m`-graded matrices on the
  section-preserving Rees space.  Artin--Popescu approximation does promote
  each formal solution to an exact `2 x 2` factorization over the
  henselization of the algebraic pair along `(s)`, congruent modulo `s` and
  therefore retaining the actual special module `I_i`.  Pair-henselian
  effectivity is thus proved.  It still cannot give descent across `s=1`:
  `1-s` is a unit in that henselization, so its `s=1` fibre is empty, while
  equivariant coherent completeness dehomogenizes only to the completed
  original local ring.  The exact remaining local gate is
  `[I_i] in image(Cl(B) -> Cl(Bhat))`, equivalently a finite graded Rees
  lattice or an effective descent cocycle on a genuine open meeting `s=1`.
  The corrected class-image attack now supplies an exact finite algebraic
  diagnostic for this gate.  In the regular hypersurface `U=0`, the Jacobian
  minors
  `p_y=U_x*f6_y-f6_x*U_y` and
  `p_z=U_x*f6_z-f6_x*U_z` cut a relative critical curve whose henselization
  is the four-branch curve `g=0`; its special polar ideal is exactly
  `(6v,u+15*lambda^4*v)=(v,u)`.  Strict-henselian residue Galois fixes all
  four tangent-separated branches and gives no monodromy restriction.  An
  explicit normal algebraic cA UFD with completed class group `Z` proves that
  shortcut false.  The correct conditional negative theorem requires an
  algebraic element `a` whose henselian divisor is the reduced sum of the
  four branch primes with no extras, `B[1/a]` factorial, and a contraction
  partition with no singleton block.  Under those hypotheses Nagata
  localization excludes every primitive branch class.  None of the three
  hypotheses has yet been completed here.
  The first exact algebraic null-polar test now rules out the most natural
  candidate.  With `b=p_y/6` and
  `a0=p_z-(5/2)*lambda^4*p_y`, the map
  `(x,y,z,t,c) -> (U,a0,b,t,c)` has Jacobian determinant `6` and special
  initials `(u,v)`, but the tangent quartic on `U=a0=0` is not `g4`; in
  particular it restricts to
  `-(8235/2)*lambda^10*b^4` on `t=c=0`.  Hence
  `div_(B^h)(a0) != Q1+...+Q4`.  There is a unique ordinary cubic correction
  in `(b,t,c)`, `a1=a0+phi3(b,t,c)`, restoring the necessary tangent cone
  `g4`, but the exact five-jet refutes `a1` as well.  On `U=a1=0`, its
  common-axis expansion is
  `12*lambda^2*(195*lambda^11+2)*b^5+O(b^6)`.  Four reduced prescribed
  smooth branches, each with tangent `C-r_i*T`, would each have order at
  least two on that axis and their product order at least eight.  Hence
  `div_(B^h)(a1) != Q1+...+Q4`.  Writing the complete degree-five error as
  `H5=(3/8)*b^2*P3`, the finite ordinary-quartic correction
  `a2=a1+psi4`, `psi4=H5/b`, cancels that error.  Its henselian divisor and
  the factoriality of `B[1/a2]` remain open; do not continue a formal jet
  ladder.  The proposed degree-one Zariski Morse chart is now refuted for
  the whole two-minor polar field.  At `p=67,lambda=1,t=c=0`, the distinct
  points `(0,0,0)` and `(15,48,57)` have the same `(U,a0,b)` value and full
  Jacobian determinants `6` and `38`.  Their ordered pair lies in the etale
  locus off the diagonal of the fibre product, whose open image contains the
  generic point of the integral characteristic-zero target.  Therefore

  ```text
  [Q(lambda,x,y,z,t,c):Q(lambda,U,a0,b,t,c)] >= 2.
  ```

  Since `(a0,b)` is an invertible recombination of `(p_z,p_y)`, no
  birational reparametrization of the polar minors can give a degree-one
  chart.  In particular this persists under `a0 -> a1 -> a2` and every
  `a0+P(b,t,c)`.  This does not refute the henselian divisor of `a2`, direct
  factoriality of `B[1/a2]`, a genuinely different transverse function
  field, or the primitive class image.  Do not compute the exact polar degree
  or run another point-count ladder.
  Moreover, this positive
  The corrected standard-`cA` calculation now makes the algebraization issue
  exact.  For an actual Zariski equation `u*v+g(t,c)`, Nagata gives
  `Cl=Z^r/Z*(1,...,1)` from the algebraic factors of `g`, and henselian
  refinement sends each factor to its block sum; a primitive branch class is
  in the image exactly for a singleton block.  But
  `u*v+c^4-t^4*(1+t)` and `u*v+c^4-t^4` have isomorphic split four-branch
  completions while their algebraic class images are zero and full `Z^3`.
  Hence completed/special `cA` data, tangent labels, and residue Galois cannot
  compute the actual image without an algebraic ruling/incidence comparison
  or a direct reflexive module.  The positive
  defect-free formal survivor does not eliminate general Rees lattices whose
  special fibre has a finite-length defect.  Replay the normality and
  local/globalization packets with
  `/opt/homebrew/bin/python3 -u tmp/xcd_total_normality/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/xcd_local_class_defect/verify.py`, and
  `/opt/homebrew/bin/python3 -u tmp/xcd_class_globalization_next/verify.py`;
  replay the Rees descent gate with
  `/opt/homebrew/bin/python3 -u tmp/xcd_zariski_descent_gate/verify.py`;
  replay the all-order formal theorem with
  `/opt/homebrew/bin/python3 -u tmp/xcd_formal_mf_all_order/verify.py`;
  replay the formal-to-henselian/Zariski boundary audit with
  `/opt/homebrew/bin/python3 -u tmp/xcd_formal_algebraization_audit/verify.py`;
  replay the corrected critical-curve/contraction theorem with
  `/opt/homebrew/bin/python3 -u tmp/xcd_class_image_attack/verify.py`;
  replay the standard-`cA` class-group theorem and formal-data counterexample
  with
  `/opt/homebrew/bin/python3 -u tmp/xcd_ca_class_group/verify.py`;
  replay the exact null-polar test with
  `/opt/homebrew/bin/python3 -u tmp/xcd_algebraic_null_polar/verify.py`;
  replay the exact five-jet refutation with
  `/opt/homebrew/bin/python3 -u tmp/xcd_zariski_morse_chart/verify.py`;
  replay the polar function-field theorem and independent proof audit with
  `/opt/homebrew/bin/python3 -u tmp/xcd_polar_function_field_degree/verify.py`
  and
  `/opt/homebrew/bin/python3 -u tmp/xcd_polar_function_field_degree/verify_audit.py`;
  replay the Klein-sextic defect/factoriality and actual base-class image with
  `/opt/homebrew/bin/python3 -u tmp/xcd_actual_class_image/verify.py`;
  replay the fixed-member and general-slice Picard theorem with
  `/opt/homebrew/bin/python3 -u tmp/xcd_picard_restriction/verify.py`;
  replay the exact singular-locus dimension theorem with
  `/opt/homebrew/bin/python3 -u tmp/xcd_singular_locus_bound/verify.py`;
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
  `tmp/xcd_zariski_descent_gate/REPORT.md` and
  `tmp/xcd_formal_mf_all_order/REPORT.md`, followed by
  `tmp/xcd_formal_algebraization_audit/REPORT.md` and
  `tmp/xcd_class_image_attack/REPORT.md` and
  `tmp/xcd_ca_class_group/REPORT.md`, then
  `tmp/xcd_algebraic_null_polar/REPORT.md` and
  `tmp/xcd_zariski_morse_chart/REPORT.md`, followed by
  `tmp/xcd_polar_function_field_degree/REPORT.md` and its
  `PROOF_AUDIT.md`, then `tmp/xcd_actual_class_image/REPORT.md` with its
  `PROOF_AUDIT.md`, then `tmp/xcd_picard_restriction/REPORT.md` with its
  `PROOF_AUDIT.md`, and finally
  `tmp/xcd_singular_locus_bound/REPORT.md` with its `PROOF_AUDIT.md`.
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
- The minimal-KLS contraction gate has now been sharpened without a degree
  sweep.  For a least-degree primitive rank-deficient self-covariant, let
  `H=V(F)` be its image and let `h=gcd_i F_i(q)`.  Then `h` is invariant,
  every non-stable factor orbit has length at least 11, and the Klein cubic
  `f3` cannot divide `h`; in particular `deg(h)<=4` forces `h=1`.  The
  primitive dual Gauss covariant
  `p=(grad F)(q)/h:W->W*` has rank four and degree
  `m=4d-4-r-t`.  The first map back to `W` is the quadratic dual Klein
  polar, so minimality gives only `d<=2m`, not `h=1`.  Every component of
  `V(h)` is a Darboux-invariant leaf divisor.  Spicer--Tasin supplies a
  useful conditional bridge: if the rank-one kernel foliation is log
  canonical, there is a **reduced** divisor `Gamma` with
  `(P4,Gamma)` log canonical and `deg(Gamma)=r+4`; this gives no support
  inclusion in `V(h)`.  Exact order-11 characters show that log canonicity
  requires
  `r mod 11 in {1,3,4,5,9}`.  The `V4` fixed loci give no additional parity
  obstruction.  Thus the surviving theorem is genuinely paired: prove
  LC-minimality (no nilpotent zero for a minimal solution) **and** a
  vertical-divisor comparison that lowers degree or excludes `h!=1`, or
  prove the minimal image canonical directly.

  The stable-component part of that comparison now has a degree-independent
  obstruction.  Assume `H` is normal and `D=V(g)` is one irreducible vertical
  component which is individually stable under the full group `G` (not merely
  a member of a nontrivial component orbit).  Then the normalized image of
  `D` in `Sing(H)` is a faithful `G`-curve.  The exact
  `PSL_2(F_11)` element orders and all orbifold signatures give genus at least
  26, and pullback of one-forms gives

  ```text
  q(Dtilde) = h^1(Dtilde,O_Dtilde) >= 26
  ```

  for every smooth projective resolution.  Since a hypersurface in `P4` has
  `H^1(O_D)=0`, this excludes rational singularities and hence, in
  characteristic zero, smooth, klt, and canonical `D`; inversion of
  adjunction also excludes `(P4,D)` being plt.  It does not prove `h=1`:
  stable components with non-rational singularities remain.

  The non-stable and nonnormal branches are now sharply audited.  The proper
  stabilizer types give exactly the component-orbit lengths

  ```text
  11,12,55,60,66,110,132,165,220,330,660.
  ```

  If `H` is normal and `Stab_G(D)=11:5` (orbit 12), the normalized image is a
  faithful `11:5`-curve.  Its branch orders are `5,11`; Riemann--Hurwitz gives
  genus at least 12, hence `q(Dtilde)>=12` and the same rational/klt/canonical/
  smooth/plt exclusions.  No other proper stabilizer forces positive
  irregularity from curve geometry alone.

  Coarse geometry and logarithmic tangency had left the orbit-11 `A5`
  quadrics as a stress test, but the audited linearized-pencil theorem now
  excludes them from the contracted-gradient gcd whenever `H` is normal.
  If one invariant quadric divided `h`, its rational image curve in
  `Sing(H)` would be `P1`; factoriality of the quadric cone would lift that
  pencil to an honest two-dimensional `A5`-module, which does not exist.
  Hence neither that quadric nor the squarefree orbit product `P22` divides
  `h`.  The exact degree-25/28 logarithmic fields and degree-32 Nambu field
  remain counterexamples to tangency-, integrating-factor-, and scalar-
  integrability-only rigidity claims, but they are **not** normal-image KLS
  candidates.

  More generally, for normal `H`, every prime factor of `h` divides the
  scalar residual factor `b` in
  `adj(DPhi)=b v bar(A)^t`.  Therefore

  \[
  \operatorname{rad}(h)\mid b,
  \qquad s-\rho\ge r+d(e-5)+4.
  \]

  In the normal non-Klein branch `e>=5`, so a nonzero `h` is necessarily
  non-squarefree and its multiplicity excess is at least `r+4`.  Repeated
  factors can still satisfy this, so `h=1` is not proved.  The remaining
  branches are nonnormal images with divisorial conductor surfaces, other
  `A5`-stabilized factors, repeated normal factors satisfying the excess,
  stable components with non-rational singularities, and smaller-stabilizer
  point or rational-curve images.  The normality hypothesis is sharp for the
  pencil method: the invariant `A5` quadric admits a dominant equivariant
  rational map to `P2` from cubic sections.  Therefore general surface-map
  prohibition is not viable; the nonnormal branch needs actual conductor or
  Jacobian/self-covariant structure.  This divisor `P22` is unrelated to the
  forbidden coordinate-`P^22` landing run.  The next theorem must use the
  differential origin of `h`, minimality, or conductor/discrepancy geometry.
  See
  `tmp/kls_vertical_divisor_geometry/REPORT.md` and its `PROOF_AUDIT.md`, with
  the independent audit in
  `tmp/kls_vertical_divisor_geometry_audit/REPORT.md`, followed by
  `tmp/kls_nonstable_vertical_orbits/REPORT.md` and its independent audit,
  then `tmp/kls_a5_logarithmic_divisor/REPORT.md` and its
  `PROOF_AUDIT.md`, followed by
  `tmp/kls_wstar_first_integrals/REPORT.md` and its `PROOF_AUDIT.md`, then
  `tmp/kls_degree28_stein_fixed_point/REPORT.md` and its
  `PROOF_AUDIT.md`, followed by
  `tmp/kls_a5_linearized_pencil_obstruction/REPORT.md` and its independent
  `AUDIT.md`, and finally
  `tmp/kls_a5_conductor_surface_feasibility/REPORT.md` with its
  `PROOF_AUDIT.md`.
  Replay with
  `/opt/homebrew/bin/python3 -u tmp/kls_minimal_contraction_attack/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/kls_vertical_divisor_geometry/verify.py`,
  and
  `/opt/homebrew/bin/python3 -u tmp/kls_vertical_divisor_geometry_audit/verify.py`,
  then
  `/opt/homebrew/bin/python3 -u tmp/kls_nonstable_vertical_orbits/verify.py`
  and
  `/opt/homebrew/bin/python3 -u tmp/kls_nonstable_vertical_orbits/independent_verify.py`,
  then
  `/opt/homebrew/bin/python3 -u tmp/kls_a5_logarithmic_divisor/verify.py` and
  `/opt/homebrew/bin/python3 -u tmp/kls_wstar_first_integrals/verify.py`, then
  `/opt/homebrew/bin/python3 -u tmp/kls_degree28_stein_fixed_point/verify.py`,
  then
  `/opt/homebrew/bin/python3 -u tmp/kls_a5_linearized_pencil_obstruction/verify.py`,
  then
  `/opt/homebrew/bin/python3 -u tmp/kls_a5_conductor_surface_feasibility/verify.py`.
- Fable's positive-construction suggestion has also been tested at the
  structural, all-degree level.  For one `V4`, put
  `A=N_G(V4)=A4` and `W=T direct_sum U`.  Blowing up the reduced orbit
  `R=X intersect P(T)` resolves projection to the triangle plane `P(U)`.
  Every `A4`-stable prime multisection has degree divisible by three, and
  the three exceptional planes give degree three.  Consequently, for every
  `A4`-equivariant rational map `f:P(U)-->X` with dominant projected map,
  `deg(pi o f)` is divisible by three.  The degree-one quadratic triangle
  Cremona transition therefore cannot globalize.  An exact good-fibre
  computation strengthens this to: no nonzero quadratic `A4`-equivariant
  map lands on `X`.  The smallest permitted projected degree is now attained:
  each of the two genuine `A4`-character hyperplanes cuts a smooth cubic
  surface
  `S(a,b,c): a*w^3+b*w*(x^2+y^2+z^2)+c*x*y*z=0`, and the exact cubic formula
  in `tmp/fable_trisection_attack/REPORT.md` gives an `A4`-equivariant
  birational map `P(U)-->S` whose projected composite has degree three.
  Its six simple basepoints form a new `A4` orbit, disjoint from the old
  marked orbit in the checked fibre, and its restriction to every triangle
  edge has degree one after cancellation.  Thus the one-centre local
  trisection gate is solved positively.  Precomposition with the triangle
  Cremona map gives an exact landing tuple in `J3/J5`, with componentwise
  axis orders `(4,4,4),(4,3,3),(3,4,3),(3,3,4)`.  The minimal
  character-corrected line model fails the split-`F_67` `D12` boundary in
  degrees six and seven, but this is not an all-degree obstruction.  By
  multiplying with high stable point factors, imposing the `D10` and `D12`
  fat-point zero conditions simultaneously, and applying equivariant Serre
  extension, one obtains a nonzero high-twist `G`-invariant section of
  `~(I^(3)/I^(5))(d) tensor W` with the prescribed projective trisection at
  every generic triple line.  Thus **all linear 55-centre compatibility is
  solved asymptotically**.  Lifting an arbitrary such section to an ambient
  polynomial covariant does not preserve the nonlinear Klein equation.
  The new Koszul theorem nevertheless constructs a sufficiently high-twist
  compatible section for which
  `F(sigma)=0 mod I^(11)` in `~(I^(9)/I^(11))(3d)`.  This solves exactly the
  first formal landing correction.  The canonical next correction would be
  the two-term map `I^(5)/I^(7) -> I^(11)/I^(13)`; the factorized attempt at
  that correction is now obstructed below, while later corrections and
  descent remain open for any replacement.  The tempting smooth-target/Serre shortcut
  is now ruled out, but its six-basepoint descent quotient is exactly
  understood.  On each edge the order-three initial is `Q` times the residual
  linear map.  In orders nine and eleven the doubled `Q^2` quotient is
  `2 Ind_C2^A4(sign)=4U`, hence has no `A4`-invariants and, after transport to
  all 55 centres, no `G`-invariants: equivariance forces this fixed-factor
  class to vanish.  Orders ten and twelve leave a simple `Q` quotient
  `Ind_C2^A4(1)` with invariant fibre rank one.  Restoring coefficients along
  the centre line gives a **rank-one invariant residue sheaf**, not one global
  scalar.  The affine boundary omitted from the earlier notation is now
  canonical: transverse degree five is zero, degree six is fixed to
  \(A_L(q_B\circ C)\), and the tangent begins in degree seven.  The actual
  joint-symbolic degree-seven directions make the factor-saturated
  constrained two-layer differential rank two at every generic \(Q\)-root,
  including the stabilizer-allowed invariant fibre.  Thus no saturated
  cokernel component dominates the six resolved base sections.  The raw
  order-ten target sheaf still has rank one.  Its first nonlinear quadratic
  residue factors through the preceding upper linear equation, so it
  vanishes automatically on the homogeneous linear kernel; there is no
  two-null-line monodromy obstruction.  The pure-boundary order-twelve
  residue vanishes, but the first post-boundary one is nonautomatic: the
  exact local kernel direction \(v_3=(0,0,By^2z,y^3),v_4=0\) gives
  \(-cy^{12}(B^6-1)\ne0\).  The characteristic-zero old-point interface is
  now complete.  Exact Fourier frames identify the seven tangent branches
  and the three simultaneous Rees flags at every representative `D12`
  point.  A homogeneous invariant \(H\), nonzero generically on each of the
  55 centre lines, vanishes to order at least 660 at all 121 old points.
  Hence a suitable \(H^N\sigma_0\) has zero Artin jet to any prescribed
  finite order at every old point while preserving every generic projective
  trisection.  For the constructed Koszul first-gate class the generic-line
  equation does vanish, so the raw old-point residue is zero.  Its raw
  differential is also zero, not
  surjective.  Colon saturation kills the finite-length saturated cokernel
  formally and transfers the full raw quotient to the descent defect
  \(B_{\rm desc}\).  Thus a finite `D10/D12` rank matrix is no longer a
  viable obstruction under arbitrary high common factors.  In the raw point
  stalk \(Q\in\mathfrak m_p^2\), whereas its exceptional transform is a unit
  at the old flags.  The genuine \(Q=0\) sections elsewhere carry the
  nonautomatic order-twelve equation.  Its naive one-edge transport fails six
  joint coefficients, but exact `Q`-multiple repairs lie in a three-dimensional
  invariant Koszul output and hit the full rank-one residue target.  Degree
  seven/eight parity generators and the invariant quadratic `H2` split every
  normalized transverse grade, and the accepted factor ledger makes
  `S_L/c_(P,L)` raw and regular for this particular residue correction.
  The ambient residue-cleared centre-line bulk is now exact in every grade,
  with zero low-grade bulk and `H2` propagation in the stable range.  The
  proposed promotion to the complete relative divisor `V(q_P)` is
  impossible: a residue-zero `p4_P` would give an elliptic quadratic trace
  constant over `P^2`, while the order-three plane stabilizer translates it
  by nonzero `2T`.  Thus this factorized Koszul family is closed at
  `I^(11)/I^(13)`.  The subsequent Veronese/Hilbert--Burch theorem also
  excludes every primitive nonfactorized planewise pair retaining the same
  nonzero boundary values; any compatible common divisor is forced to be the
  already obstructed relative quadratic.  All normal-order `3/4` extensions
  of these fixed germs are therefore closed.  A Fable successor must change
  the boundary data or leading normal order.  This is a scoped negative
  landing result, and no degree was instantiated.  Replay with
  `/opt/homebrew/bin/python3 -u tmp/fable_positive_construction/verify.py`
  and
  `/opt/homebrew/bin/python3 -u tmp/fable_trisection_attack/verify.py`, then
  `/opt/homebrew/bin/python3 -u tmp/fable_trisection_compatibility/verify.py`
  and
  `/opt/homebrew/bin/python3 -u tmp/fable_nonlinear_first_gate/verify.py` and
  `/opt/homebrew/bin/python3 -u tmp/fable_resolved_descent/verify.py`, then
  `/opt/homebrew/bin/python3 -u tmp/fable_constrained_cokernel/verify.py`, then
  `/opt/homebrew/bin/python3 -u tmp/fable_finite_d12_constrained/verify.py`
  and
  `/opt/homebrew/bin/python3 -u tmp/fable_d12_char0_bridge/verify.py`, then
  `/opt/homebrew/bin/python3 -u tmp/fable_d12_rees_sigma_interface/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_d12_joint_rank/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_d12_joint_rank/verify_all_grades.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_d12_koszul_rank/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_d12_module_adversary/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_d12_module_adversary/verify_bulk.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_d12_bulk_correction_rank/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_d12_triangular_bulk_closure/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_relative_divisor_trace_obstruction/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_fixed_plane_boundary_adversary/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_relative_q_trace_obstruction/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_nonfactorized_successor/verify.py`,
  `/opt/homebrew/bin/python3 -u tmp/fable_nonfactorized_syzygy_obstruction/verify.py`, and
  `/opt/homebrew/bin/python3 -u tmp/fable_nonfactorized_feasibility/verify.py`.
- A primary-source audit through 2026-07-29 found no recent theorem that
  closes the headline.  Spicer--Tasin materially sharpens KLS, and the July
  27 Jung--Saito revisions prove the Klein sextic base factorial, as stated
  below.  Kresch--Tschinkel reduces the all-twist quantifier to
  a versal twist but supplies no rational point; recent birational rigidity
  does not obstruct a higher-degree dominant map; and the higher Amitsur
  route is exhausted here because `Pic(X)=Z[H]` and `O_X(1)` is honestly
  `G`-linearized, so the relevant groups vanish after restriction to every
  subgroup.  No recent algebraization result proves the required image
  statement `Cl(B)->Cl(Bhat)` for the local nonproper `xCD` pair.  Replay
  the dated source ledger and boundary audit with
  `/opt/homebrew/bin/python3 -u tmp/recent_structural_tools_audit/verify.py`.
- The July 2026 level-11 theta/Schwarz construction uses the correct
  projective representation but does not lie on the Klein cubic:
  \(F(H\Phi_{11})=\xi_{44}^5u^{11}+O(u^{99})\).  It is also outside the
  classical Hessian-singular model.  Close this as a headline path.  Replay
  with `python3 tmp/theta11_test/theta11_test.py`.

The local ignored `tmp/` tree is now about 9.1 GB.  The new material is
dominated by a 647 MiB gated raw-coordinate Cech prototype, the 373 MiB full
top Groebner basis, the 351 MiB degree-12 survivor circuit, the 1.3 GiB local
Julia/Groebner.jl installation and pilot, the degree-12 hyperplane-chart
inputs, the degree-16 probe inputs, and the degree-16--25 arrangement and
landing packets.  The accepted segmented generic DAGs include files of about
95 MB, 62 MB, and 39 MB; the typed Cech `X,Y` extension is under 1 MB.  They remain under
`tmp/` and therefore do not enlarge GitHub history unless deliberately
force-added.  The curvature-safe `P^19` packet adds 103 MiB locally, of which
90 MiB is streamed replay chunks and 7.6 MiB is the compressed certificate.
The accepted `xcd_zariski_morse_chart` packet is only about 32 KiB and peaks
near 75 MiB.  A rejected dense SymPy precursor jumped to `1,044,704 KiB` RSS
before it was killed; it produced no output and is used for no claim.

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

5. All ten three-column sections of the covariant frame
   \(x,C,D,E,K\) are smooth geometrically integral genus-one plane cubics.
   A complete good-reduction audit excludes every
   invariant-polynomial landing ansatz in those planes in total degrees
   **11--14**. This closes factor/node shortcuts and a finite degree range; it
   does not show that the plane cubics lack \(K_0\)-points. Their degree-nine
   flex schemes are also geometrically irreducible, so none has a rational
   flex; an ordinary rational point can still exist without one.

   Separately, all ten ternary sections of the exhaustive degree-eight
   Schur-source frame are smooth genus-one cubics over
   \(K_{\rm Schur}=\mathbf C(\mathbf P(V_6))^G\).  The full Schur twist has
   no \(K_{\rm Schur}\)-rational line or geometrically integral
   \(K_{\rm Schur}\)-defined plane conic, no nonconstant regular
   fibration to a lower-dimensional projective base, and no projective-linear
   separated cubic norm form.  Blowing up the irreducible degree-three base
   scheme cut out by any ambient coordinate line gives instead an explicit
   genus-one fibration.  In every case the resolved Picard group is
   `Z*H direct_sum Z*E`, the fibre-degree image is `3Z`, and the generic
   fibre has exact index and period three.  Hence all ten fibrations have no
   rational section.  This remains only a no-section theorem, not a point
   obstruction for the total threefold.  Closed finite-field and one-parameter geometric
   specializations cannot give a full-cubic no-point certificate, by
   Chevalley--Warning and Tsen.  See
   `tmp/schur_structural_routes/REPORT.md` and its `PROOF_AUDIT.md`, followed
   by `tmp/schur_fibration_picard_obstruction/REPORT.md` and its
   `PROOF_AUDIT.md`.

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
   quaternionic-Hermitian isotropy equations on \(D^3\).  The generic
   projective Schur boundary is nonzero and its degree-six central simple
   algebra has index exactly two.  Thus the generic twist of `P(V6)` is a
   nonsplit, non-stably-rational Severi--Brauer fivefold and cannot be stably
   replaced by projectivizations of honest representations.  The ambient
   obstruction disappears exactly on two-planes:
   `SB_2(M_3(D))=P_D^2` is rational.  Its special codimension-five section
   still has no automatic point, and the residual question is precisely a
   common isotropic right `D`-line for the five Hermitian forms.  Such a line
   is headline-positive.  Every individual Hermitian member is isotropic by
   the odd-degree-55 `A4` orbit and Springer's theorem, so an
   anisotropic-member certificate is impossible; simultaneous common
   isotropy remains open.  Matched
   polynomial covariants into the \(F_{14}\) cone are excluded only through
   degree **15**. The full 80-dimensional degree-16 space and 1,313 necessary
   quadrics are reconstructed, but the exact solver timed out without a
   leading ideal. There is no all-degree cutoff; degree 16 remains open for
   the Pfaffian target.  See
   `tmp/pfaffian_generic_schur_audit/REPORT.md` and its `PROOF_AUDIT.md`, then
   `tmp/pfaffian_explicit_descent/REPORT.md` and its `PROOF_AUDIT.md`.

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
   `tmp/step4_degree12_solver_terminal/REPORT.md`.  The ten explicit
   coordinate-line genus-one fibrations are now exact period/index-three
   no-section models, so the section/3-descent successor is retired.  The
   structural successor is the unrestricted full-threefold point problem;
   do not launch another bounded ternary support sweep.

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
    covering to the original projective `xCD` cubic.  The general-slice
    factoriality theorem now proves that this cubic has no
    `K_proj,C`-rational point, so that distinguished component is closed
    negatively.  This is not an obstruction to points elsewhere on the full
    twisted Klein cubic threefold.  The pure-coefficient places `A=0`, `B=0`,
    and `C=0` were already locally soluble and remain diagnostic only.
    A true second-descent branch pursued independently of this now-refuted
    component would still need the twisted three-flex-line algebra, line
    forms, and constants. See
    `tmp/kproj_arithmetic/REPORT.md`, `tmp/xcd_genuine_descent/REPORT.md`,
    `tmp/xcd_control_next/REPORT.md`,
    `tmp/xcd_generic_cech_next/REPORT.md`, and
    `tmp/xcd_first_descent_next/REPORT.md`, and
    `tmp/xcd_arithmetic_next/REPORT.md`.

## Verification

The initial `certificates/...` commands below form the portable checked-in
suite. Every later command under `tmp/...` requires the intentionally ignored
about 9.1 GB local artifact tree and will not be available in a fresh clone.

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
/opt/homebrew/bin/python3 -u tmp/schur_structural_routes/verify.py
/opt/homebrew/bin/python3 -u tmp/schur_fibration_picard_obstruction/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_generic_schur_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_explicit_descent/verify.py
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
/opt/homebrew/bin/python3 -u tmp/kls_global_foliation_theorem/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_minimal_contraction_attack/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_vertical_divisor_geometry/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_vertical_divisor_geometry_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_nonstable_vertical_orbits/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_nonstable_vertical_orbits/independent_verify.py
/opt/homebrew/bin/python3 -u tmp/kls_a5_logarithmic_divisor/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_wstar_first_integrals/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_degree28_stein_fixed_point/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_a5_linearized_pencil_obstruction/verify.py
/opt/homebrew/bin/python3 -u tmp/kls_a5_conductor_surface_feasibility/verify.py
/opt/homebrew/bin/python3 -u tmp/recent_structural_tools_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_positive_construction/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_trisection_attack/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_trisection_compatibility/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_nonlinear_first_gate/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_resolved_descent/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_constrained_cokernel/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_finite_d12_constrained/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_char0_bridge/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_rees_sigma_interface/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_first_gate_koszul/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_first_gate_koszul_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_simultaneous_successor/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_simultaneous_successor/verify_transport_equalizer.py
/opt/homebrew/bin/python3 -u tmp/fable_order12_qsection_correction/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_joint_rank/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_joint_rank/verify_all_grades.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_koszul_rank/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_module_adversary/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_module_adversary/verify_bulk.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_bulk_correction_rank/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_d12_triangular_bulk_closure/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_relative_divisor_trace_obstruction/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_fixed_plane_boundary_adversary/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_relative_q_trace_obstruction/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_nonfactorized_successor/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_nonfactorized_syzygy_obstruction/verify.py
/opt/homebrew/bin/python3 -u tmp/fable_nonfactorized_feasibility/verify.py
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
/opt/homebrew/bin/python3 -u tmp/xcd_formal_mf_all_order/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_formal_algebraization_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_class_image_attack/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_algebraic_null_polar/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_zariski_morse_chart/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_polar_function_field_degree/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_polar_function_field_degree/verify_audit.py
/opt/homebrew/bin/python3 -u tmp/xcd_actual_class_image/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_picard_restriction/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_singular_locus_bound/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_local_grv_comparison_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_global_defect_bridge/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_rank_invariant_reduction/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_invariant_module_support/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_singular_curve_enumeration_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_invariant_fibre_discriminants/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_invariant_fibre_discriminants_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_repeated_factor_incidence/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_general_slice_completion/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_invariant_module_multiprime/verify_reconstruction.py
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

## Current structural ledger

> **Numbering note (director, 2026-07-30).**  The slot numbers below are the
> historical track labels, not the current priority order.  The authoritative
> route ranking is the "2026-07-30 audited route ranking" in
> [`CURRENT_PATHS.md`](CURRENT_PATHS.md): (1) Pfaffian descent, (2)
> unrestricted Schur, (3) KLS beyond the newly closed branches, (4) Fable as
> a redesign route only.

The structural ledger is now: (1) the fixed-boundary Fable branch is closed.
The completed factorized construction supplies an explicit minimal trisection
and a nonzero all-centre compatible high-twist symbolic class, and the Koszul
theorem solves `F(sigma)=0 mod I^(11)` for one such class; its continuation is
now obstructed at the full `I^(11)/I^(13)` gate.  The structural fixed-factor quotient is
now separated: equivariance automatically clears the doubled `Q^2` residue
in odd orders nine and eleven, while even orders ten and twelve retain a
rank-one invariant residue sheaf along the centre line.  For the canonical
fixed affine boundary, the factor-saturated **constrained** two-layer
differential is now generically onto along all six base sections.  Its first
  order-ten quadratic residue factors through the preceding upper equation and
  vanishes on the homogeneous kernel.  The next condition then checked was the
  first post-boundary order-twelve residue, which is not automatic.  Exact
  characteristic-zero three-flag modules and a universal invariant high
  factor now supply zero jets to every finite order at all old points while
  preserving the generic trisections.  The old-point raw residue and
  differential both become zero, and colon saturation transfers the whole
  finite defect to \(B_{\rm desc}\).  The degree-seven joint Koszul equalizer
  has rank-one residue image, the six naive conflicts are explicitly repaired,
  and degree-seven/eight generators split all normalized simple-`Q` grades.
  The ambient residue-cleared centre-line bulk is also exact in all grades,
  but the quadratic-trace theorem proves that the full relative-`q_P`
  divisor equation is impossible for this factorized family.  The exact
  Veronese/Hilbert--Burch theorem then rules out the proposed primitive
  nonfactorized pair: every regular syzygy vanishes on its common-zero
  scheme.  A common divisor retaining both nonzero boundary roots is forced
  back to the same quadratic cover.  Thus all normal-order `3/4` extensions
  of the fixed line germs are closed; only a changed boundary or leading
  order remains within Fable.  This is a genuine negative conclusion for
  that branch, not the headline; (2) the paired KLS
  LC-minimality/vertical-divisor comparison (or direct canonicity of one
  minimal image), now sharpened by the theorem that a normal-image,
  individually full-`G`-stable vertical component must have resolution
  irregularity at least 26 and therefore cannot be rational, klt, canonical,
  or plt.  The proper-stabilizer audit extends this only to `11:5` components
  (orbit 12), with irregularity at least 12.  The orbit-11 `A5` quadrics
  survive coarse geometry and scalar-integrability tests, but the new
  linearized-pencil theorem excludes them from `h` when `H` is normal.
  Moreover `rad(h)|b` and
  `s-rho >= r+d(e-5)+4`; a normal non-Klein branch with nonzero `h` therefore
  requires repeated factors with multiplicity excess at least `r+4`.
  What remains is a nonnormal conductor surface, another `A5`-stabilized
  factor, such repeated normal factors, stable non-rational-singularity
  branches, and smaller-stabilizer point or rational-curve images.  The
  invariant `A5` quadric has a dominant equivariant cubic map to `P2`, so no
  blanket prohibition on quadric-to-surface maps can close the nonnormal
  conductor branch.  Further
  progress must use the homogeneous \(W^*\)-valued first-integral module and
  its generic-rank-four self-covariant/adjugate/image/degree identities,
  minimality of `h`, or conductor discrepancies; and (3) the genuinely
  generic Schur, Pfaffian, full-threefold, or torsor-arithmetic routes.  The
  Schur line/conic, regular-fibration, and separated-norm shortcuts are now
  closed; its ten explicit ambient-line genus-one fibrations have exact
  index and period three and no rational section, so that constructive
  re-entry is closed as well.  The generic Pfaffian Schur class is
  nonzero of index two and forbids stable linear replacement, while
  `Gr(2,6)` twists to the rational `P_D^2`; its exact remaining gate is a
  common isotropic `D`-line for the special Hermitian five-plane.  Every
  individual member is isotropic by odd-degree Springer, so the former
  anisotropic-member test is impossible.  The `xCD` class-image/globalization problem is retired because the
  general-slice theorem has already proved the needed plane-section
  factoriality; that scoped negative result does not settle the headline.
  The characteristic-zero/integral
symbolic-saturation and relative border/Fitting analysis remain relevant
  inside (1), but another bare bounded ladder does not.  The grandfathered
  coordinate `P^21` degree-five support calculation is complete: its fixed
  candidate family is non-full, with only the certified bounds
  `3933 <= rank <= 7910` and an explicit dependency among its first 3,934
  columns.  It proves no `P^21` emptiness or characteristic-zero promotion.
  No `P^22` or successor slice is authorized.

Within the existing degree-25 landing packet, replace the refuted
split-`F_67` zero-colon shortcut by a characteristic-zero/integral saturation
analysis, then attack the full landing ideal through its relative
border/Fitting presentation.
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
  `V4` table, isolated point-row sweep, or raw scalar Hilbert degree; (2) run the
  ambient-polynomial semantic verifier through the remaining 7,846
  degree-six/seven rows before composing the `M7` circuit; and (3) replace
  the Pfaffian degree-16 retry by the explicit quaternion plus five-Hermitian-
  matrix descent.  Landing
self-covariants are already excluded through degree 24; degree 25 is the
first bounded unknown and should be used through the normalized
border/Fitting module, not an unstructured high-dimensional projective solve.
The old degree-22
memory stop is superseded by the `25 -> 12 -> 4 -> 0` proof.  The
  finite KLS `P8` screen is complete, and dimension
counts prove that larger sparse three-support boxes cannot be exhaustive;
the quartic-precomposition theorem now rules out a bound on every solution,
and the global foliation identity reduces the singular-image branch to its
invariant contracted divisor; the route now needs the minimal-contraction or
canonicity theorem for one minimal solution.  Do not
launch another bare Problem F path/transition argument, unchanged degree-12
mixed charts, high-dimensional raw degree-25 charts, more isolated degree-16 fibres, or control translation
  interpolation.  For headline leverage: (1) the forced 55-plane symbolic
  arrangement and its Fable order-twelve successor, (2) the exact
  flat-connection KLS equation, (3) a full-threefold point or obstruction
  using the completed \(K_{\rm proj}\) arithmetic, (4) an unrestricted
  rational point in the Schur frame, the coordinate-line section routes now
  being closed, and (5) a simultaneous common isotropic quaternionic line in
  the Pfaffian Hermitian model, the anisotropic-member route now being
  impossible.
  The selected `xCD` plane
  is no longer a live point-search target.
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

A second, even newer theorem materially changes the **base** of the `xCD`
class diagram.  Jung--Saito,
[*Defect of projective hypersurfaces with isolated singularities*](https://arxiv.org/abs/2512.23522)
v3 and
[*Factoriality of normal projective varieties*](https://arxiv.org/abs/2601.13151)
v6 were both revised on 2026-07-27.  Their pole-order two-block formula,
applied to the exact Klein sextic, has ranks `75,2125,2200`; the independent
characteristic-zero Jacobian Hilbert value is 255.  Hence `def(H6)=0` and
`Cl(H6)=Z[O(1)]`.  The Zariski local base class group at every `A3` point is
therefore zero, although its completion has class group `Z`.  This explains
the completed pair-sum `(1,1,0)` as a completion-created class.  It does not
compute `Cl(B)` or `Cl(C6)`.  The follow-up Picard theorem does compute the
Cartier side: `Pic(C6)=Z*H direct_sum Z*xi`, restriction to an
effective-Cartier ample slice is an isomorphism, and every Cartier horizontal
  degree is a multiple of three.  Thus there is no remaining Picard/Cartier
  restriction gap.  The exact gradient-rank hyperplane certificate proves
  `dim Sing(C6)<=1`.  The later invariant-branch discriminants and intrinsic
  repeated-factor incidence prove that its reduced one-dimensional singular
  support is exactly the 120 known fibre lines.  General-slice Bertini and
  transversality then give exactly 180 `A3` plus 180 ordinary four-branch
  `cA` points, so the rank-720 theorem proves `def(Y)=0`.  Consequently `Y`
  and `C6` are factorial, the horizontal Weil degree image is `3Z`, and the
  projective `xCD` plane cubic has no `K_proj,C`-point.  This closes the slice
  subroute without deciding the full twisted threefold or the headline.  See
  `tmp/xcd_actual_class_image/REPORT.md`,
  `tmp/xcd_picard_restriction/REPORT.md`,
  `tmp/xcd_singular_locus_bound/REPORT.md`,
  `tmp/xcd_invariant_fibre_discriminants/REPORT.md`,
  `tmp/xcd_repeated_factor_incidence/REPORT.md`, and
  `tmp/xcd_general_slice_completion/REPORT.md` with their proof audits and
  verifiers.

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
  original projective `xCD` cubic.  The general-slice theorem now rules out a
  `K_proj,C`-point on that component.  Generic first descent through this
  particular plane construction is therefore closed negatively; further
  progress must leave it for the full twisted threefold or another genuinely
  generic construction.  The three pure-coefficient divisor families remain
  locally soluble diagnostics only.
  Any independent true second-descent branch still needs the generic twisted
  three-flex-line algebra, line forms, and constants.  The soluble
  coordinate-line control is now
  explicit: \(Q_{\rm ctl}=[H-3O]\), its irreducible nonzero \(E[3]\) field,
  and the genuine nonzero \(G_T(Q_{\rm ctl})\) representative all replay
  exactly.  It validates conventions only and does not transfer to the
  generic characteristic-zero plane.  Positive candidate searches may
  proceed immediately in the ambient rational-function field if invariance
  and the cleared cubic identity are checked exactly.  Independently, over
  \(K_{\rm Schur}=\mathbf C(\mathbf P(V_6))^G\), the ten ternary sections of
  the degree-eight Schur frame are smooth genus-one curves, and the full
  Schur twist has no rational line or geometrically integral ground-field
  plane conic, no regular
  lower-dimensional fibration, and no separated cubic norm presentation.
  Each ambient-line projection fibration, after blowing up its degree-three
  base scheme, has Picard fibre-degree image `3Z`, exact generic-fibre index
  and period three, and no rational section.  The former section/3-descent
  constructive re-entry is therefore closed.  This is not a no-point theorem
  for the threefold; re-enter through an unrestricted point construction or
  obstruction in the full Schur frame.
  Closed finite-field and one-parameter specializations cannot give a
  full-cubic negative certificate.  The point problem already descends from
  \(\mathbf C(W)^G\) to the transcendence-degree-four field
  \(\mathbf C(\mathbf P(W))^G\), but its \(C_4\) bound does not apply to a
  five-variable cubic.  See `tmp/plane_genus_one/REPORT.md`,
  `tmp/schur_structural_routes/REPORT.md` with its `PROOF_AUDIT.md`, and
  `tmp/schur_fibration_picard_obstruction/REPORT.md` with its
  `PROOF_AUDIT.md`.
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
  `tmp/fano14_degree12/REPORT.md`.  The generic projective Schur class is
  nonzero of index two, so its Severi--Brauer fivefold is not stably rational
  and has no stable linear projective replacement.  The Grassmannian twist
  is nevertheless the rational quaternionic plane
  `SB_2(M_3(D_proj))=P^2_(D_proj)`.  Build an explicit quaternion presentation
  and descend the Klein five-plane to five `3 x 3` Hermitian matrices.  A
  common isotropic right `D_proj`-line solves the headline positively.  The
  degree-55 `A4` orbit and Springer prove every individual member isotropic,
  so an anisotropic-member certificate cannot exist.  Degrees 12--15 are excluded.
  Degree 16 has been fully reconstructed, but its 1,313-quadratic exact solve
  timed out in degree three and remains a strict nonverdict; do not rerun it
  without the structural descent.  See `tmp/fano14_degree16/REPORT.md` and
  `tmp/pfaffian_generic_schur_audit/REPORT.md` with its `PROOF_AUDIT.md`, and
  `tmp/pfaffian_explicit_descent/REPORT.md` with its `PROOF_AUDIT.md`.
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
  all 90 spaces \(S_{12}+\langle p_j\rangle\) are excluded.  All ten ternary
  curves are smooth, but unrestricted points remain open; the other 359
  bounded two-direction slices are not justified.  The ten coordinate-line
  fibrations have exact index and period three and no section, so that
  3-descent route is closed.  Attack the full invariant-field point directly.
  Finite scans still cannot prove
  a negative answer. See the reports under `tmp/projective_source_degree12*`,
  `tmp/step4_degree12_solver_terminal/REPORT.md`,
  `tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`, and
  `tmp/schur_structural_routes/REPORT.md`, and
  `tmp/schur_fibration_picard_obstruction/REPORT.md`.
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
  Its generic Brauer class is nonzero of index two, so it is not stably
  replaceable by projectivizations of honest representations.  A map from it
  is nevertheless sufficient because its twists split over extensions of
  degree at most two and the resulting quadratic cubic points descend.
- The Pfaffian bridge contains a genuinely nonsplit projective factor. It
  always splits after an extension of degree at most two, but this yields a
  Klein-cubic point only in the \(F_{14}\)-very-versal branch of the
  essential-dimension argument in `RESOLUTION.md`. Rationality of the ambient
  \(D\)-projective plane does not imply a point on its codimension-five Fano
  section, and the quaternion class persists over that section's function
  field.  The degree-55 `A4` orbit and Springer imply that every individual
  descended Hermitian member is isotropic; only their simultaneous common
  line is open.
- The generic twist has no rational line: a point on its twisted Fano surface
  of lines would force a faithful very versal surface, contradicting
  \(\operatorname{ed}(G)\ge3\). It has no \(K_0\)-defined conic either, since
  the residual plane-section component would be such a line. A successful
  point construction must not assume either curve.
- The ten ambient-line projections yield genus-one fibrations only after a
  blowup.  For each, `Pic(Y)=Z*H direct_sum Z*E`, the fibre-degree image is
  `3Z`, and the generic fibre has exact index and period three.  Thus none
  has a rational section, but this does not exclude a point on the full cubic
  threefold or on a special fibre.  Finite-field and
  one-parameter geometric full-cubic specializations are automatically
  soluble.
- The normal-image `A5` quadric/`P22` KLS branch is closed, but the theorem
  uses normality.  It does not exclude nonnormal conductor surfaces, other
  `A5` factors, repeated normal factors satisfying the multiplicity-excess
  inequality, or stable components with non-rational singularities.  Indeed,
  the invariant quadric admits a dominant `A5`-equivariant cubic rational map
  to `P2`, so dimension and linearization alone cannot exclude a divisorial
  conductor image.
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

### 2026-07-29 — Fable positive-construction assessment

The closing transition graph does not itself produce a positive map.  Fix
`K=V4`, put `A=N_G(K)=A4`, and write `W=T direct_sum U`, where `P(U)` is the
triangle plane.  Projection `X-->P(U)` has reduced base orbit
`R=X intersect P(T)` of length three.  On
`Y=Bl_R(X)`, with `L=H-E_1-E_2-E_3`, every `A4`-stable prime divisor
multisection has class `aH-b(E_1+E_2+E_3)` and hence degree

```text
S.L^2 = 3a-3b.
```

The exceptional union has degree three, so the equivariant multisection
degree subgroup is exactly `3Z`.  Therefore an `A4`-equivariant
`f:P(U)-->X` with dominant projected composite satisfies
`deg(pi o f)=0 mod 3`.  The triangle Cremona map has projected degree one
and cannot be repaired into a landing map by common factors or arbitrary
`T`-coordinates.  Exact character reconstruction also gives
`dim Hom_A4(Sym^2 U,W)=3`, and the complete projective quadratic landing
scheme has unit ideal on all three charts over `F_67`; proper good reduction
excludes it in characteristic zero.

The minimal permitted trisection is now constructed explicitly.  The two
genuine `A4`-character hyperplanes cut smooth cubic surfaces
`S subset X`, proved by exact good reduction after diagonalizing the
order-three action on `T`.  In standard coordinates

```text
S(a,b,c): a*w^3+b*w*(x^2+y^2+z^2)+c*x*y*z=0.
```

Choose `B` with `b^3(B^3-1)^2=a*c^2*B^3`, put `C=B^-1` and
`D=-c/b`, and use

```text
[x:y:z] |-> [D*x*y*z,
             x*(x^2+B*y^2+C*z^2),
             y*(y^2+B*z^2+C*x^2),
             z*(z^2+B*x^2+C*y^2)].
```

The landing identity is exact.  This is an `A4`-equivariant birational map
`P(U)-->S subset X`; its projected composite has degree three.  It has six
simple basepoints, two on each edge, and after canceling the edge factor its
three boundary maps have degree one onto the required minus-lines.  The six
points form a new `A4` orbit, disjoint from the old `D12` marked divisor in
the checked good fibre.  Hence the first local positive gate is **solved**,
but the construction is further based and does not automatically define a
section of the full 55-plane symbolic sheaf.

The all-centre linear gate is now also solved asymptotically.  The primitive
tuple cannot itself be an odd first normal layer, but precomposing with
`[x:y:z] |-> [yz:zx:xy]` gives an exact nonzero landing tuple in `J3/J5`.
After the inverse-character line factor, the minimal degree-six/seven model
fails the split-`F_67` `D12` boundary.  Extra factors change the conclusion:
a high power of the stable divisor of the three `D12` points, together with
independent simultaneous zero jets at every `D10` and `D12` point, clears all
finite residual quotients.  Equivariant Serre extension and the exact
nested-kernel theorem then give a nonzero class

```text
sigma_d in H0(~(I^(3)/I^(5))(d) tensor W)^G
```

with the prescribed projective trisection at every generic triple line.
This proves full **linear** `A4/D10/D12` compatibility at a sufficiently high
twist; an arbitrary lift need not land.  The Koszul construction now chooses
a nonzero compatible high-twist class satisfying

```text
F(sigma) = 0 mod I^(11).
```

This closes only the target `H0(~(I^(9)/I^(11))(3d))^G`.  All higher
corrections, effectivity/algebraization, descent, and dominance remain.  If
`Phi` is the symmetric polarization of the Klein cubic, the
tangent-obstruction complex at this first-gate zero is

```text
K_d -- v |-> 3 Phi(sigma,sigma,v) --> T^0_(3d),
```

and the first higher correction is canonically

```text
I^(5)/I^(7) -- e |-> 3 Phi(p,p,e) --> I^(11)/I^(13).
```

The naive smoothness-plus-Serre shortcut fails before any choice of `d`:
edgewise the order-three initial is
`Q*[0,0,z,B^(-1)y]`.  The refined descent calculation uses the six-point
`A4` orbit with stabilizer `C2`.  In odd orders nine and eleven, the doubled
`Q^2` fixed-factor quotient is `2 Ind_C2^A4(sign)=4U`, so it has no invariant
section; the induced `G`-module has none either.  Thus equivariance makes the
order-nine and order-eleven `Q^2` divisibility conditions automatic.  In even
orders ten and twelve, however, the simple `Q` quotient is
`Ind_C2^A4(1)` and has invariant fibre rank one.  With coefficients along the
centre line restored, this is a rank-one invariant residue sheaf, not one
global scalar.  Fixing the canonical affine boundary
\(\operatorname{gr}^5=0\),
\(\operatorname{gr}^6=A_L(q_B\circ C)\), the actual grade-seven joint-symbolic
directions make the saturated constrained map rank two at each generic
\(Q\)-root.  Hence no cokernel component dominates the six base sections.
The first quadratic order-ten residue factors through the upper linear
equation and vanishes on its homogeneous kernel.  The pure-boundary
order-twelve residue vanishes, but the first post-boundary residue is not
automatic; the explicit kernel witness has value
\(-cy^{12}(B^6-1)\ne0\).  The subsequent characteristic-zero three-flag and
high-factor theorem supersedes that finite-interface gap.  It supplies zero
Artin jets of every prescribed finite order at all old `D10/D12` points while
preserving the generic trisections.  Their raw residue and differential both
become zero; colon saturation moves the full finite defect to
\(B_{\rm desc}\).  The exact joint Koszul computation repairs the six failed
degree-seven transports, has full rank one on the invariant residue target,
and supplies degree-seven/eight generators for every normalized simple-`Q`
grade.  The full ambient residue-cleared centre-line bulk is now exact in
every grade, but the full relative-divisor antecedent is impossible for the
factorized `q_P R_P` family by the elliptic quadratic-trace obstruction.
This rules out that complete Koszul continuation, not the existence
of a landing zero.  Replay with
`/opt/homebrew/bin/python3 -u tmp/fable_positive_construction/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_trisection_attack/verify.py`, and
`/opt/homebrew/bin/python3 -u tmp/fable_trisection_compatibility/verify.py`,
then
`/opt/homebrew/bin/python3 -u tmp/fable_nonlinear_first_gate/verify.py` and
`/opt/homebrew/bin/python3 -u tmp/fable_resolved_descent/verify.py`, then
`/opt/homebrew/bin/python3 -u tmp/fable_constrained_cokernel/verify.py` and
`/opt/homebrew/bin/python3 -u tmp/fable_finite_d12_constrained/verify.py`, then
`/opt/homebrew/bin/python3 -u tmp/fable_d12_char0_bridge/verify.py`, then
`/opt/homebrew/bin/python3 -u tmp/fable_d12_rees_sigma_interface/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_d12_joint_rank/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_d12_joint_rank/verify_all_grades.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_d12_koszul_rank/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_d12_module_adversary/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_d12_module_adversary/verify_bulk.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_d12_bulk_correction_rank/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_d12_triangular_bulk_closure/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_relative_divisor_trace_obstruction/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_fixed_plane_boundary_adversary/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_relative_q_trace_obstruction/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_nonfactorized_successor/verify.py`,
`/opt/homebrew/bin/python3 -u tmp/fable_nonfactorized_syzygy_obstruction/verify.py`, and
`/opt/homebrew/bin/python3 -u tmp/fable_nonfactorized_feasibility/verify.py`.

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

The completed coordinate `P^21` degree-five packet is a strict nonverdict.
Its `21407 x 7911` split-`F_67` matrix has 3,933 independent leading columns
and an explicit normalized dependency among columns `0,...,3933`.  Hence
only `3933 <= rank <= 7910` is certified; 3,933 is not the total rank, and
the exact total rank was not computed.  The fixed family therefore proves no
`P^21` emptiness.  Its conditional selected-square replay and canonical
characteristic-zero promotion to `dim L_25<=14` were correctly skipped, and
no `P^22` run followed.

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
    VECLIB_MAXIMUM_THREADS=1 OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 /opt/homebrew/bin/python3 -u tmp/m1_relative_border_p21_d5_design/verify.py

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
certificate, its degree-five `P^19` and `P^20` successors, their
characteristic-zero promotions, and the completed `P^21` strict nonverdict
are under `tmp/m1_relative_border_maxslice/`,
`tmp/m1_relative_border_p19_d5/`, `tmp/m1_relative_border_p20_d5/`,
`tmp/char0_lift_p19_d5/`, `tmp/char0_lift_p20_d5/`, and
`tmp/m1_relative_border_p21_d5_design/`.  The precise
remaining global lemmas are in tmp/all_degree_arrangement_attack/REPORT.md.
The live 2026-07-29 structural successors are
`tmp/kls_minimal_contraction_attack/`,
`tmp/kls_vertical_divisor_geometry/` with its independent audit
`tmp/kls_vertical_divisor_geometry_audit/`,
the KLS conductor-specific branch bounded by
`tmp/kls_a5_conductor_surface_feasibility/`, the unrestricted full-threefold
Schur/torsor routes (not the ten no-section coordinate-line fibrations), the
Pfaffian simultaneous-common-line route bounded by
`tmp/pfaffian_explicit_descent/`, and only a Fable redesign
with different boundary data or leading normal order.  The fixed-boundary
chain beginning at `tmp/fable_positive_construction/` is now closed
provenance; its terminal certificates are
`tmp/fable_relative_divisor_trace_obstruction/`,
`tmp/fable_fixed_plane_boundary_adversary/`, and
`tmp/fable_relative_q_trace_obstruction/`, followed by the independent
`tmp/fable_nonfactorized_successor/`,
`tmp/fable_nonfactorized_syzygy_obstruction/`, and
`tmp/fable_nonfactorized_feasibility/` packets.  The
structural-tools audit remains current; `tmp/xcd_class_image_attack/`,
`tmp/xcd_algebraic_null_polar/`, and `tmp/xcd_zariski_morse_chart/` are
retired provenance for the now-closed plane-section route.
