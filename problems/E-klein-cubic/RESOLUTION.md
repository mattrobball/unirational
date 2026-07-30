# Problem E — resolution status and proved boundary

## Verdict

**OPEN.** No unconditional affirmative or negative answer is proved here.
As checked on 2026-07-30, the author version of
Cheltsov–Tschinkel–Zhang dated 2026-07-18 still explicitly lists the
\(\operatorname{PSL}_2(\mathbf F_{11})\)-action on the Klein cubic among the
two open Klein-cubic cases (Theorem 5.1 and the discussion on printed page
23).

What is proved below is an exact reduction to the remaining essential-
dimension dichotomy, an explicit generic-twist presentation, and a certified
bounded covariant exclusion, together with several all-degree structural
closures and feasibility theorems.  None of these results supplies the
missing dominant map or generic-twist nonpoint required for a headline
solution.

Artifact scope matters when replaying the ledger: the tracked
`certificates/` directory is the portable verification subset. The approximately 9.1 GB
`tmp/` tree containing newer solver outputs and intermediate matrices is
intentionally ignored, so `tmp/...` citations below are local provenance
pointers rather than remotely published files.

## 2026-07-30 latest fixed-frame result

The main question is again: is the Klein cubic
\(\operatorname{PSL}_2(\mathbf F_{11})\)-unirational?  The answer remains
**OPEN**.  The newest exact conclusions concern only the minimal fixed-frame
Pfaffian plane cubic.

- The `f5=0` residual cubic over `C(A,Y,Z)` has an explicit constant smooth
  point `[x1:t1:1]` with nonzero projector derivative.  It Hensel-lifts, so
  `D5` is no longer a possible local obstruction; the accepted `E[3]`
  representative lies in the local Kummer image.
- Over

  \[
  F=\mathbf C(A,B,Y,Z),
  \]

  the full fixed-frame equation is the generic member of a basepoint-free
  four-parameter linear system of plane cubics.  The regular universal
  incidence and its projective-bundle Picard group prove

  \[
  \operatorname{ind}(C/F)=3,\quad C(F)=\varnothing,
  \quad \operatorname{Pic}^0(C)(F)=0.
  \]

- A sparse exact BKK calculation, with a separate hostile replay, proves

  \[
  [K_{\rm proj}:F]=6
  \]

  and affine scaled-frame length `18`.  Its special arithmetic monodromy is
  `S6`; the degree packet first gives geometric monodromy `A6` or `S6`,
  enough to prove that the sextic extension has no proper intermediate
  field.  The later simple-branch theorem upgrades it to geometric `S6`.
  The degree proof uses exact polynomial identities and mixed volume `6`,
  not the timed-out generic
  Groebner calculations or the rejected naive homogenization.
- The residual point itself fails globally by `B*rB(t1)!=0`.  Holding its
  binary direction fixed produces an irreducible cubic extension, hence no
  `K_proj` point on that fixed line because no cubic intermediate field
  exists.  A point with varying direction is not excluded.
- On the exact target line `(A,B,Y,Z)=(1,2,3,s)`, a primitive element has
  sextic discriminant `Q11^2*H21`, with the irreducible `H21` factor of
  exponent one and coprime to content and leading coefficient.  The global
  specialization plus index-square/different formula proves the existence
  of a target branch divisor with one ramified prime `(e,f)=(2,1)`; hence
  `[k(R):k(D)]=1`.  Degree `21` is only the degree of the chosen line point.
  A separate exact two-chart calculation modulo `67` proves that `H21` is
  coprime to the necessary affine and infinite singularity conditions for
  the fixed-frame cubic.  Thus the selected branch component has smooth
  generic cubic.  The remaining valuation gate is `ind(C_{k(D)})=3`.
- The degree-37 upstairs critical determinant of the four-parameter map is
  geometrically integral and reduced.  Its first proposed incidence
  compactification fails exactly: the five coordinate points are base points
  with differential rank two, so the incidence has `P2` fibres and the
  cleared cubic has `P2 x P2` components.  Thus the naive semiample Picard
  argument is not a proof.  Extracting the multiplicity-one target branch
  and controlling the integral Picard/class group of its cubic incidence is
  still new work; a base-ideal blow-up and strict-transform Picard
  calculation is the longer alternative.

There is now a uniform fixed-member Picard theorem for the target incidence.
For every integral target hypersurface `D` with integral generic cubic, the
two-equation Koszul vanishing and SGA2 XII.3.6--3.7 prove

```text
Pic(T_D) = Z*H_z + Z*H_lambda
```

even if `T_D` is singular.  Flatness over `D` supplies integrality.  This is
ordinary Picard control only: the exact remaining obstruction is the
three-primary part of `Cl(T_D)/Pic(T_D)` (after the necessary normalization
and removal of vertical classes).  Local factoriality would close it;
normality and rational Picard control do not.  At a codimension-two nodal
contact on the normalization, the local model is `xy=pi^m` with class group
`Z/m`, so only pullback orders divisible by three are dangerous.

The naive smooth primitive-root complete intersection is also rejected.
On the exact characteristic-zero slice `A=Y=0,B=1`, its primitive sextic has
discriminant factors `(11,2),(21,1)`.  Every full Jacobian minor vanishes on
the degree-11 factor, and that factor divides the Cramer norm; the simple
degree-21 factor is Cramer-open and has no rank drop.  Hence only the selected
simple component after Cramer saturation and normalization remains viable.
Exact pointwise evaluation and the true projective-line factorization show
that the Cramer norm contains the entire squared part and is coprime to the
simple factor, so this saturation is canonical in the tested charts.

The raw target branch cannot itself serve as a normal Lefschetz base.  A
smooth ordered-double-fold point modulo `7` lifts to characteristic zero;
there two distinct ordinary Cramer-open folds have independent target
normals.  Geometric `S6` monodromy puts the two branches on the same
irreducible target divisor, proving a codimension-one self-intersection and
nonnormality.  After Cramer saturation, the singularity warning is now exact
in characteristic zero.  On `A=0,B=2`, a squarefree degree-12 polynomial
`H(u)` and derivative-coordinate RUR

```text
D=H'(u),  Y=NY(u)/D,  Z=NZ(u)/D
```

make all six singular equations vanish in `QQ[u]/(H)` while `D`, the
primitive content, and `delta` are units.  This constructs a finite etale
degree-12 closed singular subscheme and hence twelve distinct geometric
singular points.  Exact Python and independent Macaulay2 replays agree.
Thus a direct smooth-ramification/Sommese proof is false as stated.

The singularities are not ordinary double points: `E_uu` is a unit, the
full five-variable Hessian has rank exactly `3`, and the eliminated
four-variable Schur Hessian has rank exactly `2` at every certified point.
This rejects the ODP/small-resolution shortcut.  Exact quotient-algebra
calculations further show that both the binary cubic on the Hessian kernel
and the correctly Morse-corrected effective quartic vanish identically at all
twelve points.  Thus the residual `h` in the local branch form
`x*y-h(z,w)` is zero or has order at least five.  This does not show that
normalization is smooth or singular.  After removing the now-exact parameter
content, the decisive remaining local test is the single all-orders
membership `P in (P_A,P_B,P_Y)` at the degree-12 RUR prime.  The transverse
Hessian unit makes the quotient regular of dimension two, so this one
membership automatically gives the two tangent-derivative memberships.  It
must distinguish a nonnormal Morse--Bott
crossing removed by normalization from a normal higher `cA`-type
singularity.  Global projective small resolvability and the
normalized/vertical class-group obstruction remain open.
The replayable certificates and hash bindings are recorded in
`tmp/target_branch_delta_saturated_singularity/PROOF_AUDIT.md` and
`tmp/target_branch_delta_saturated_singularity/HESSIAN_PROOF_AUDIT.md`.

The global primitive sextic is now exact in characteristic zero, rather than
only a modular feasibility estimate.  Sparse determinant expansion followed
by an exact Nemo/FLINT multivariate gcd gives

```text
E_raw=C(A,B,Y,Z)*P(A,B,Y,Z,u),
C: 2630 terms, total degree 22,
P: 1593 terms, u-degree 6.
```

Literal multiplication recovers all 72,286 terms of `E_raw`.  The exact
primitive reproduces the earlier `1474`-term mod-13 and `1556`-term mod-67
objects up to certified nonzero scalars.  The degree-12 RUR polynomial is
irreducible and squarefree; in its quotient field, `P` and all five first
derivatives are zero, while the parameter content, `P_uu`, and the selected
transverse Hessian determinant are units.  Thus the all-orders question
reduces to

```text
P in (P_A,P_B,P_Y)_mRUR.
```

Direct local-ring, colon, Mora, sparse-F4, and parameter-field computations
all reached the one-GiB/180-second caps without a membership verdict.  Exact
determinantal reconstruction does prove that the sparse consequence matrix
has rank exactly two at every point of the irreducible RUR orbit.  Its
Cramer minor is a unit, the right and left kernels are explicit, and all
five contractions `ell^T*(partial_x M)*r` vanish.  This is exact pointwise
tangency, not the missing two-dimensional component.  The discarded
parameter content factors into two linear factors, a squared irreducible
degree-eight factor, and a quadratic, all invertible at the orbit.
The reconstructed `(v,t)` also satisfies every one of the original nine
projective frame relations.  Their `9 x 7` Jacobian has exact rank two: a
`2 x 2` minor is a unit and all 2,940 `3 x 3` minors vanish.  Thus the orbit
is not a special-fibre artifact of the three consequence equations, and the
original projective incidence is singular there as well.

On the regular formal critical surface, the implication

```text
P_Z,P_u in (P,P_A,P_B,P_Y)_m  ==>  P in (P_A,P_B,P_Y)_m
```

is valid in characteristic zero: a nonzero positive-order series cannot
divide both partial derivatives of itself.  Its two hypotheses remain
unproved.  Exact full-rank linear algebra modulo `29` excludes identities in
the selected box `deg(q),deg(a_i)<=6`, `deg(b)<=5`, but this is only a
bounded negative.  A separate mod-13 v1 audit leaves three rank-deficient
boxes explicitly undecided; its search script is repaired without rerunning
the memory-heavy eliminations.

Exact
finite-field Newton solves at good primes `13`, `29`, and `31` find zero
residual on every rational kernel line through order `128`, with two
`p=29` lines also zero through order `256`; Padé reconstruction finds no
low-degree rational critical arc.  These checks and the bounded multiplier
exclusions are strictly finite/modular and do not prove `h=0`.
Complete grevlex bases after the line restriction `Z=Z0+t,u=u0` give
nonzero global normal forms for `P` at both `p=29` and `p=31`.  This is exact
all-degree global-line nonmembership, but both remainders vanish at the
selected point; it demonstrates contamination by other critical sheets and
does not decide the selected local component.  The corresponding general
Bézout contact bound is `11000`, so zero residual modulo `t^257` is not
decisive.
On an exact line in the actual projective coefficient coordinates
`(A,B,Y,T)`, the discriminant factors as degrees/exponents
`(1,2),(23,2),(39,1)`.  This corrects the affine-line reconnaissance but does
not yet certify a global degree-39 equation; the `H21` test line is
degree-dropped.

The no-intermediate-field theorem does not preserve a three-torsion class
across a degree-six extension.  Equivalently, a `K_proj` point is still
possible and would be encoded by an `F`-conic whose six-point intersection
algebra with `C` is isomorphic to `K_proj`.  This is an exact interface, not a
finite search.  None of these statements constructs or excludes the full
15-coordinate self-adjoint Pfaffian idempotent, and none settles the headline.
This latest section supersedes the older `D5`-undecided and
field-degree-undecided sentences retained in the longer audit ledger below.

## 2026-07-30 audited advances

The main question remains **OPEN**.  The following new conclusions are exact
at their stated scope.

1. For an actual source divisor dominating a normalization-conductor prime,
   the KLS multiplicities satisfy

   \[
   a=\epsilon(c+\mu),\qquad
   \beta=(\epsilon-1)+\epsilon\mu,qquad
   a-\beta=1+\epsilon(c-1)>0.
   \]

   Thus multiplicity one forces a transverse immersed ordinary node and
   \(\beta=0\).  For every divisor over the normalization pair one has the
   refinement

   \[
   \beta-a=\epsilon A_E(H^\nu,C)-1.
   \]

   In particular, a squarefree gcd factor centered in codimension at least
   two cancels from `deg(h)-deg(b)`.  The unique invariant quintic is normal.
   More strongly, the universal Jacobian scheme of the invariant sextic pencil
   \(f_6+t f_3^2\) has affine dimension two, so every genuine invariant
   sextic is geometrically integral and normal.  A nonnormal non-Klein image
   has degree at least seven.  If the complete gradient gcd is exactly the
   product `P22*k`, where `P22` is the complete conductor-dominating support
   and `k` is coprime, squarefree, and centered in codimension at least two,
   the KLS degree identity gives `d<=9`; the complete characteristic-zero
   dominance theorem through degree nine excludes the branch.  Repeated `k`
   is also covered when every associated discrepancy is at least one.  The
   exact lc/plt frontier is now proved.  Cartier integrality shows that
   target-pair lc removes multiplicity dependence but may leave one reduced
   copy at an `A_E=0` place; plt gives full cancellation for valuations
   exceptional over codimension-at-least-two centers, not for conductor
   divisors themselves.  A homogeneous rank-four normal-image family with lc
   kernel foliation realizes `A_E=5-e`, and a fixed nodal plt pair has
   pullbacks with arbitrarily many conductor-dominating source divisors.
   These models are non-`G` and nonminimal, so they prove that the missing
   input must be a representation-specific minimality-to-discrepancy theorem
   plus a separate conductor-support bound.  They do not construct a KLS
   counterexample for the Klein action.

2. A maximal `D12` stabilizes an honest two-dimensional submodule whose
   projective line lies on the Klein cubic and has full stabilizer `D12`.
   Every twist consequently has an effective degree-55 zero-cycle, and the
   generic Schur twist has an actual closed point of exact degree 55.  A
   degree-three section gives index one.  Neither statement gives a rational
   point.  Balestrieri supplies only an extension of degree at most 107 with
   the stated coprimality properties, and Ma's degree-seven theorem is
   inapplicable.  A proper degree-19 curve through the degree-55 point would
   leave a residual degree-two cycle and prove solubility; it must depend on
   the torsor because a constant invariant degree-19 curve would cut an
   invariant length-57 scheme, below the minimum orbit length 60.  For a
   negative Schur-source result, any boundary-zero no-point torsor over an
   infinite field suffices; a valuation construction is optional.  Every
   qualifying pure degree-19 curve through a line-orbit point with the
   certified maximal geometric semilinear `D12` stabilizer is now forced to
   be geometrically integral.  For a descended
   hyperplane-selected degree-55 point the exact Hilbert function is
   `1,4,10,19,31,45,55,...`, and no geometrically integral ACM degree-19
   curve works.  This leaves non-ACM integral curves, as well as ACM curves
   through other independently chosen orbit points, outside the theorem.
   The selected hyperplane can simultaneously be chosen so that
   `Y=V(f3,f5)` is a smooth geometrically integral `(3,5)` complete
   intersection of degree `15` and genus `31`.  The selected point ideal has
   five new minimal sextic generators and
   `O_Y(6)(-Z)` has `(degree,h0,h1)=(35,5,0)`.  A smooth rational survivor
   has forced Rao dimensions
   `(0,16,29,38,42,40+epsilon)`, `epsilon in {0,1}`.  In the
   `epsilon=1` branch its unique quintic carrier is `f5+f3*q` and `Y~3H`.
   Picard rank one for that actual carrier would exclude degree `19`, but
   the standard Brevik--Nollet/Lopez theorem does not apply because
   `I_Y(4)=f3*S1` is not globally generated, and a very-general Picard
   result would not control the special carrier selected by a curve.
   Complete-intersection links of types `(5,6)` and `(5,7)` force residual
   genera `-28` and `-12`, but disconnected or nonreduced residuals remain.
   Thus this is an exact non-ACM frontier, not a nonexistence theorem.

3. The Pfaffian descent now proves existence of the Morita idempotent and
   isolates its explicit-coordinate equation.  The exact
   characteristic-zero alignment gives
   \(\dim\operatorname{Hom}_G(W,\wedge^2V_6^*)=1\), and 36 explicit
   weight-zero rational matrices form a generic `K_proj`-basis.  A rank-25
   Reynolds map `End(W)->End(V6)` and eleven complement covariants give a
   normalized `25+11` frame with determinant `7 mod 23`.  Multiplication is
   ordinary `6 x 6` multiplication followed by one frame solve.  The
   descended involution is

   \[
   \sigma_x(M)=Q(x)^{-1}M^tQ(x),\qquad
   \operatorname{Pf}Q(x)=\lambda f_3(x),\quad\lambda\ne0.
   \]

   The rank-25 map is linear rather than multiplicative; the generic matrix
   circuit is a correct formula, while its fully instantiated replay is at
   the good prime.  The generic Brauer class has period and index exactly two,
   so the algebra is `M3(D)` for a quaternion division algebra and a
   `sigma`-self-adjoint reduced-rank-two idempotent exists abstractly.  On a
   certified 15-element basis of `Sym(A,sigma)`, explicit extraction is the
   single system

   \[
   c_3(a)=0,\qquad c_2(a)\ne0,
   \]

   with projector

   \[
   e=(a^2-c_1(a)a+c_2(a)1)/c_2(a).
   \]

   The system has a `K_proj`-point abstractly, but no installed-frame
   coordinates are supplied.  The direct homogeneous Grassmannian-covariant
   shortcut is excluded through degree eight only.  In the degree-14 Reynolds
   symmetric frame, every one of the 105 coordinate-pair Pfaffian cubics is
   geometrically irreducible, so no support-one or support-two point exists
   over `K_proj`.  All 455 coordinate ternary cubics are now proved smooth
   and geometrically integral over `K_proj`; this is a basis-dependent
   coordinate-plane theorem.  The unique minimal fixed-frame triple `(0,1,2)`
   has the exact depressed model

   \[
   F=u^3+u(q_0v^2+q_1vw+q_2w^2)
     +r_0v^3+r_1v^2w+r_2vw^2+r_3w^3=0,
   \]

   with seven explicit `K_proj` coefficients, exact Hessian/Jacobian/flex
   data, and projector open `c2=F_u!=0`.  Exactly 34 of the 38 ambient
   invariant-basis slots are nonzero; the four zero slots are precisely the
   two `u^2v,u^2w` rows.  Neither the construction nor its independent audit
   decides the genus-one torsor class.  The exact flex eliminant is monogenic:
   `K[t]/(Phi)` is a degree-nine field and `u=-L0/L1`, so there is no rational
   flex.  The Jacobian 3-division quartic is irreducible, excluding rational
   nonzero 3-torsion and a rational 3-isogeny kernel.  This still does not
   decide whether the genus-one curve has a rational point.  At the genuine
   `f3=0` quotient valuation, `pi=f3*f5/f8` gives a simple Hensel point in
   `F_u!=0`; hence this divisor supplies no obstruction and even gives a
   local projector.  The `f5=0` scaling has a generically smooth explicit
   residual genus-one cubic, but its residue-field point is undecided.  The
   affine `E[3]` cocycle and first Kummer representative are now explicit:
   a 755,647-node determinant-free circuit constructs
   `alpha_R in R^x/R^(x3)`, and an independent audit checks two actual
   Pfaffian sheets, projective translation orientation, and the rank-729 Cech
   triple overlap.  The normalized first-descent chart has ten variables and
   nine cubics.  It has 729 geometric degree-nine components, but their
   component torsor cannot obstruct this class: `alpha_R=w1(xi)` supplies a
   base-defined component representing the original covering.  The first
   local Kummer layer is now exact, with the prime-`3` injectivity theorem for
   `w1` included explicitly.  The `f3=0` Hensel point forces local Kummer
   membership, so that place is retired.  At `f5=0`, the primitive rescaled
   cubic extends the same degree-three covering over the henselian DVR, its
   Jacobian has good reduction, and local membership is equivalent to a
   point on the residual plane cubic.  The raw nine saved `alpha_R`
   coordinates have no certified homogeneous gauge; their mixed-weight DAG
   pass is not an actual coordinate valuation and cannot be reduced naively.
   The residual cubic descends exactly to
   `F0=C(A,Y,Z)`, with `A=f6/f3^2`, `Y=f9/f3^3`, and `Z=f12/f3^4`.
   A direct characteristic-zero Jacobian witness proves algebraic
   independence.  The corrected possibly disconnected finite-etale `mu3`
   slice and generically free `G` quotient give the factor-three rank
   identity.  A hostile audit rejects the attempted generic bound from the
   exact length-`3960` affine fibre because the projective boundary is
   nonempty.  Its replacement is an exact generic characteristic-zero
   calculation: the rank-12 Hironaka module quotient by `f9-Y` and `f12-Z`
   over `QQ(A,Y,Z)[f8,f11]` has length `6`.  Hence
   `[k(D5):F0]=2` exactly.  The plane degree-three divisor and genus-one
   Riemann--Roch then show that this quadratic residue extension cannot
   create a point absent over `F0`.  The three coordinate-infinity valuations
   are locally soluble and the distinguished double-root direction is empty
   even over `k(D5)`.  The remaining Pfaffian gate is the residual Kummer
   class or a non-coordinate discriminant place for the explicit cubic over
   `C(A,Y,Z)`, followed by a global point with `F_u!=0`, the quaternion
   corner, five Hermitian matrices, and a simultaneous common isotropic right
   line.

Replays are listed at the top of `HANDOFF.md`.  The local packets are
`tmp/kls_actual_conductor_geometry/`,
`tmp/kls_actual_conductor_geometry_audit/`, `tmp/kls_f5_normality/`,
`tmp/kls_f5_normality_audit/`, `tmp/schur_unrestricted_point_attack/`,
`tmp/schur_unrestricted_point_attack_audit/`,
`tmp/pfaffian_representation_alignment/`,
`tmp/pfaffian_representation_alignment_audit/`, and
`tmp/pfaffian_25plus11_descent/`, together with
`tmp/pfaffian_25plus11_descent_audit/`,
`tmp/quadratic_grassmannian_covariant/`,
`tmp/pfaffian_rank2_idempotent_attack/`,
`tmp/pfaffian_rank2_hostile_audit/`,
`tmp/pfaffian_binary_cubic_attack/`,
`tmp/pfaffian_binary_cubic_geometric_audit/`, and
`tmp/kls_proper_multiple_structure/`, with its independent
`tmp/kls_proper_multiple_structure_audit/`, together with
`tmp/pfaffian_ternary_cubic_triage/`,
`tmp/pfaffian_ternary_cubic_hostile_audit/`,
`tmp/pfaffian_minimal_ternary_model/`,
`tmp/pfaffian_minimal_ternary_model_audit/`,
`tmp/pfaffian_depressed_torsor_next/`, with its independent
`tmp/pfaffian_depressed_torsor_next_audit/`,
`tmp/pfaffian_torsor_valuation_attack/`, with its independent
`tmp/pfaffian_torsor_valuation_attack_audit/`,
`tmp/pfaffian_depressed_alpha_r/`, with its independent
`tmp/pfaffian_depressed_alpha_r_audit/`,
`tmp/pfaffian_alpha_local_kummer/`, with its independent qualified audit
`tmp/pfaffian_alpha_local_kummer_audit/`,
`tmp/pfaffian_d5_residual_attack/`, with its independent corrective audit
`tmp/pfaffian_d5_residual_attack_audit/`, the independent invariant-module
salvage `tmp/d5_degree_bound_invariant_salvage/`, and the independent
projective cross-check `tmp/pfaffian_d5_degree_projective_audit/`,
`tmp/kls_discrepancy_next_gate/`,
`tmp/kls_discrepancy_next_gate_audit/`, and
`tmp/schur_degree19_structural_design/`, with its independent
`tmp/schur_degree19_structural_design_audit/`, together with
`tmp/schur_degree19_nonacm_attack/` and its independent
`tmp/schur_degree19_nonacm_attack_audit/`.

## 2026-07-29 structural advances

The headline remains open.  The following are all-degree structural results,
not a replacement for either acceptance criterion.

1. Let \(q:W\to W\) be a primitive rank-four self-covariant of least
   primitive saturated degree, let its irreducible image be \(H=V(F)\), and
   set

   \[
   h=\gcd_i F_i(q),\qquad s=\deg h.
   \]

   Then \(h\in\mathbf C[W]^G\).  A non-stable orbit of irreducible
   components of \(V(h)\) has at least eleven members, and the Klein cubic
   \(f_3\) does not divide \(h\).  The low invariant ledger therefore gives

   \[
   s\leq4\Longrightarrow h=1.
   \]

   Every surviving non-Klein branch has \(s\geq5\), with either a stable
   invariant component of degree at least five or a non-stable orbit-product
   of degree at least eleven.  Each component is a Darboux-invariant leaf
   divisor for the primitive kernel foliation.  There is now an additional
   degree-independent obstruction for an individually stable component.
   Assume `H` is normal and `D=V(g)` is one irreducible vertical component
   stable under the full group `G`.  Normality forces its image in `Sing(H)`
   to be a curve; fixed-point exclusion and simplicity make the action on its
   normalization faithful.  The exact element-order/orbifold calculation
   gives genus at least 26, so pullback of regular one-forms yields

   \[
   q(\widetilde D)=h^1(\widetilde D,\mathcal O_{\widetilde D})\geq26.
   \]

   A projective hypersurface in `P4` has `H^1(O_D)=0`, hence `D` cannot have
   rational singularities.  In characteristic zero this excludes smooth,
   klt, and canonical `D`, and inversion of adjunction excludes `(P4,D)`
   being plt.  The proper-stabilizer classification gives component-orbit
   lengths
   `11,12,55,60,66,110,132,165,220,330,660`.  For normal `H`, stabilizer
   `11:5` (orbit 12) still forces a faithful image curve; its branch orders
   `5,11` give genus and resolution irregularity at least 12, with the same
   singularity exclusions.  This is the only extension forced by proper-
   stabilizer curve geometry alone.  At that coarse level the orbit-11 `A5`
   model is sharp: for both `A5` classes there is one nondegenerate invariant
   quadratic, and its eleven translates form a squarefree degree-22
   `G`-invariant made of smooth rational quadrics; `A5` also admits a faithful
   `P1` action.  Logarithmic tangency is not strong enough.  For their product
   \(P_{22}\), the exact induced degree-25 field

   \[
   v=\sum_i(P_{22}/q_i)
      \bigl(c_i\nabla_{q_i}f_3-f_3\nabla_{q_i}c_i\bigr)
   \]

   is \(G\)-equivariant, satisfies \(P_{22}\mid v(P_{22})\), and has nonzero
   class modulo \(R E+P_{22}\operatorname{Der}R\).  Removing its component gcd
   gives a primitive survivor of degree at most 25.  The induced degree-25
   field and its degree-28 backup have the exact rational integrating factor
   \(1/P_{22}\).  A separate degree-32 Nambu field is nontrivial on the
   divisor and becomes, after gcd removal, a primitive field with a
   polynomial integrating factor and four algebraically independent
   polynomial first integrals.  Thus logarithmic/Darboux tangency, closed
   forms, and ordinary scalar algebraic integrability cannot exclude orbit
   11.  A valid KLS comparison must instead detect the homogeneous
   \(W^*\)-valued first-integral module of a generic-rank-four self-covariant,
   its adjugate/image and degree identities, minimality, or stronger
   conductor/discrepancy input.

   The new linearized-pencil theorem supplies exactly such a comparison in
   the normal-image orbit-11 branch.  If `H` is normal and one invariant
   quadric \(Q_{A_5}\) divided \(h\), restriction would give a dominant
   `A5`-equivariant rational map from the smooth rational quadric threefold to
   a curve in `Sing(H)`.  Its normalization is \(\mathbf P^1\) with faithful
   icosahedral action.  But the affine cone over the quadric is factorial, so
   a primitive rational pencil on it spans an honest two-dimensional
   `A5`-subrepresentation.  No such representation exists.  Hence no
   \(Q_{A_5}\) divides \(h\), and the full product \(P_{22}\) cannot occur in
   the contracted-gradient gcd of a normal-image KLS covariant.  Thus neither
   the degree-25 nor the degree-28 field realizes this normal-image branch,
   regardless of its scalar first-integral field.  The separate Stein
   fixed-point proof still excludes the degree-28 induced field and its
   primitive form independently.  On the generic surface
   \(S_r=V(q,c-rf)\), the geometrically integral \(A_5\)-stable divisor
   \(D_r=V(d_4)\) gives an \(A_5\)-fixed rational point on the normal curve
   of the finite Stein field of \(t=d_4^3/f^4\).  A nontrivial \(A_5\)-action
   would be faithful, but a finite faithful stabilizer of a smooth
   characteristic-zero curve point is cyclic.  Thus \(A_5\) fixes the whole
   local Nambu constant field pointwise.  The irreducible nontrivial module
   \(W^*|_{A_5}\) then forces every coordinate of a hypothetical homogeneous
   KLS first-integral tuple to vanish modulo the selected quadric; conjugacy
   puts \(P_{22}\) in the coordinate gcd, contradicting primitivity.  The
   pencil has a degree-72 base scheme, so the proof deliberately does not
   assert that the Stein degree is one.

   There is also a general normal-image multiplicity theorem.  In the
   primitive rank-one factorization

   \[
   \operatorname{adj}(Dq)=b\,v\,\bar A^t,
   \qquad \bar A=(\nabla F)(q)/h,
   \]

   rank drop along every prime component of \(V(h)\) gives

   \[
   \operatorname{rad}(h)\mid b.
   \]

   If \(\rho=\deg\operatorname{rad}(h)\), \(r=\deg v\), \(t=\deg b\),
   \(d=\deg q\), and \(e=\deg H\), the exact degree identity sharpens to

   \[
   s-\rho\ge r+d(e-5)+4.
   \]

   For a normal non-Klein image \(e\ge5\), so every nonzero \(h\) is
   non-squarefree and has multiplicity excess at least \(r+4\).  This does
   not force \(h=1\): repeated factors can supply the excess.
   The symbol \(P_{22}\) here denotes the degree-22 divisor, not a
   coordinate-\(\mathbf P^{22}\) landing slice.  Smaller stabilizers likewise
   allow point or
   rational-curve images.  If `H` is nonnormal, a vertical component may
   dominate a divisorial conductor surface, and rational singularities force
   only `q=p_g=0` there.  A new feasibility theorem shows that this is not a
   gap which can be closed by a formal surface analogue of the pencil
   argument.  For the invariant smooth quadric threefold \(Q\) of either
   maximal `A5`, the exact decomposition

   \[
   H^0(Q,\mathcal O_Q(3))
     \simeq2\cdot\mathbf1\oplus\mathbf3\oplus\mathbf3'
       \oplus3\cdot\mathbf4\oplus2\cdot\mathbf5
   \]

   supplies a cubic `A5`-equivariant rational map
   \(Q\dashrightarrow\mathbf P^2\), and an exact differential-rank witness
   proves it dominant.  Thus there is no blanket prohibition on an
   `A5`-equivariant map from \(Q\) to a surface.  The target here is an
   abstract `A5`-surface, not an embedded conductor of a KLS image, and the
   theorem constructs neither a `G`-self-covariant nor a realization of
   \(P_{22}\).  An actual nonnormal obstruction must use the conductor
   embedding, normalization compatibility, Jacobian origin, or
   multiplicities.  The surviving KLS branches therefore include a
   nonnormal image with such a conductor surface, other `A5`-stabilized
   factors, repeated normal-image components satisfying the displayed
   excess, and stable components with non-rational singularities.  In
   particular `h=1` remains unproved.  The proofs and independent audits are
   `tmp/kls_vertical_divisor_geometry/REPORT.md`, its `PROOF_AUDIT.md`, and
   `tmp/kls_vertical_divisor_geometry_audit/REPORT.md`, followed by
   `tmp/kls_nonstable_vertical_orbits/REPORT.md` and
   `tmp/kls_nonstable_vertical_orbits/INDEPENDENT_AUDIT.md`, then
   `tmp/kls_a5_logarithmic_divisor/REPORT.md` and its `PROOF_AUDIT.md`, then
   `tmp/kls_wstar_first_integrals/REPORT.md` and its `PROOF_AUDIT.md`, and
   `tmp/kls_degree28_stein_fixed_point/REPORT.md` with its
   `PROOF_AUDIT.md`, and finally
   `tmp/kls_a5_linearized_pencil_obstruction/REPORT.md`, its
   `PROOF_AUDIT.md`, and its independent `AUDIT.md`, followed by
   `tmp/kls_a5_conductor_surface_feasibility/REPORT.md`, its
   `PROOF_AUDIT.md`, and its `INDEPENDENT_AUDIT.md`.
2. The normalized dual Gauss covariant

   \[
   p=(\nabla F)(q)/h:W\longrightarrow W^*
   \]

   is primitive of rank four and has degree
   \(m=d(\deg H-1)-s=4d-4-r-t\).  The two five-dimensional modules \(W\)
   and \(W^*\) are not isomorphic, so this does not contradict self-covariant
   minimality.  Composing with the unique quadratic dual Klein polar gives a
   primitive self-covariant of degree \(2m\), and minimality yields only

   \[
   d\leq2m,\qquad
   r+t\leq\left\lfloor\frac{7d-8}{2}\right\rfloor.
   \]

   Explicit normal rational counterfamilies show that primitivity,
   normality, rationality, Stein factorization, or foliation log canonicity
   alone cannot remove \(h\).
3. Spicer--Tasin makes the remaining foliation hypothesis exact: at every
   zero, log canonicity is equivalent to nonnilpotence of the linear part.
   If the KLS foliation is log canonical, their theorem produces a
   **reduced** divisor \(\Gamma\) such that

   \[
   (\mathbf P^4,\Gamma)\text{ is lc},\qquad
   \deg\Gamma=r+4.
   \]

   This supplies no absolute bound on \(r\), and \(\Gamma\) is not
   automatically \(G\)-invariant or supported on \(V(h)\).  The order-eleven
   eigenpoints prove the necessary condition

   \[
   \mathcal F\text{ lc}\Longrightarrow
   r\bmod11\in\{1,3,4,5,9\}.
   \]

   The complete \(V_4\) first-jet character audit gives no further parity
   obstruction.  Thus the minimal-contraction route requires two genuinely
   separate statements: an **LC-minimality lemma** excluding nilpotent zeros
   and a **vertical-divisor comparison lemma** which turns \(h\ne1\) into a
   lower-degree self-covariant or excludes it.  Direct canonicity of one
   minimal image remains an alternative.
4. At a representative \(V_4\) centre with normalizer \(A\simeq A_4\),
   projection from the fixed projective line has a reduced three-point base
   orbit.
   Blowing up that orbit gives a genus-one fibration over the triangle plane.
   Every \(A\)-stable prime divisor which dominates the base has multisection
   degree divisible by three, and the exceptional orbit realizes degree
   three.  Hence any \(A\)-equivariant
   \(f:\mathbf P(U)\dashrightarrow X\) with dominant projected composite
   satisfies

   \[
   \deg(\pi\circ f)\equiv0\pmod3.
   \]

   The projected degree-one quadratic Cremona transition is impossible; an
   exact good-reduction calculation further proves that no nonzero quadratic
   \(A_4\)-equivariant landing map exists in characteristic zero.  On the
   positive side, the minimum allowed degree is actually realized.  Each of
   the two genuine \(A_4\)-character hyperplanes cuts a smooth cubic surface
   \(S(a,b,c)\), and the explicit cyclic cubic formula in
   `tmp/fable_trisection_attack/REPORT.md` gives an \(A_4\)-equivariant
   birational map \(\mathbf P(U)\dashrightarrow S\) whose projected composite
   has degree three.  It has six simple basepoints forming a new \(A_4\)-orbit
   and restricts with degree one to every triangle edge after cancellation.
   Thus the one-centre trisection gate is solved.  Precomposition with the
   triangle Cremona map gives an exact landing tuple in \(J_3/J_5\).  The
   minimal character-corrected tuple fails the split \(D_{12}\) boundary in
   degrees six and seven, but high stable point factors, simultaneous
   \(D_{10}/D_{12}\) fat-point conditions, and equivariant Serre extension
   produce a nonzero high-twist global section of
   \(\widetilde{I^{(3)}/I^{(5)}}(d)\otimes W\) carrying the prescribed
   trisection at every generic triple line.  Thus all linear all-centre
   compatibility is solved asymptotically.  Its arbitrary ambient lift need
   not land on \(X\), but the independently audited Koszul construction now
   gives one nonzero compatible high-twist class with
   \(F(\sigma)=0\bmod I^{(11)}\).  This closes exactly the target
   \(\widetilde{I^{(9)}/I^{(11)}}(3d)\), supplying only the first formal
   landing correction, not all-order lifting, algebraization, or dominance.
   The canonical next correction would be the map
   \(I^{(5)}/I^{(7)}\to I^{(11)}/I^{(13)}\); the factorized attempt at this
   correction is now obstructed below.  High twist and smoothness do
   not make these maps automatically surjective: on every edge the
   order-three initial has the six-basepoint factor \(Q\).  The resulting
   fixed-factor quotient is now computed equivariantly.  In odd orders nine
   and eleven its doubled \(Q^2\) layer is \(4U\), with no \(A_4\)- or induced
   \(G\)-invariants, so invariant defects are automatically \(Q^2\)-divisible.
   Even orders ten and twelve retain a simple \(Q\)-layer with invariant fibre
   rank one; over the centre line it is a rank-one invariant residue sheaf,
   not one global scalar.  The missing affine boundary is now fixed
   canonically: transverse degree five is zero, degree six is
   \(A_L(q_B\circ C)\), and the tangent begins in degree seven.  The genuine
   joint-symbolic degree-seven directions make the factor-saturated
   constrained two-layer differential rank two at every generic \(Q\)-root,
   including the stabilizer-allowed invariant fibre.  Its saturated cokernel
   therefore has no component dominating the six resolved base sections.
   The raw order-ten rank-one target survives, but its first quadratic residue
   factors through the preceding upper linear equation and vanishes
   automatically on the homogeneous kernel.  The pure-boundary order-twelve
   residue vanishes; the first post-boundary one is nonautomatic, with exact
   local kernel witness
   \(v_3=(0,0,By^2z,y^3),v_4=0\) and value
   \(-cy^{12}(B^6-1)\ne0\).  The characteristic-zero old-point interface is
   now complete: exact Fourier frames identify all seven tangent branches
   and all three simultaneous Rees flags.  There is a homogeneous invariant
   \(H\), nonzero generically on every centre line, with order at least 660
   at each of the 121 old `D10/D12` points.  Thus, for every finite cutoff,
   \(H^N\sigma_0\) retains the same projective trisection but has zero Artin
   jet at every old point.  For the constructed Koszul first-gate class the
   generic-line equation is satisfied, so the raw old-point residue is zero.
   Its raw differential is also
   zero, not surjective.  Colon saturation kills the finite-length cokernel
   formally, while the whole raw quotient survives as the descent defect
   \(B_{\rm desc}\).  Finite old-point rank calculations are consequently
   retired under the arbitrary-high-factor policy.  In the raw point stalk
   \(Q\in\mathfrak m_p^2\), whereas its exceptional transform is a unit at
   the old flags.  The nonautomatic order-twelve equation instead lives on
   the genuine \(Q=0\) sections.  A denominator-free polynomial solution on
   one edge and both roots is now certified inside the exact Koszul tangent
   image.  Its naive cyclic transports fail six joint coefficients, but the
   exact joint Koszul equalizer repairs them by `Q`-multiples and has full rank
   one on the invariant residue target.  Degree-seven/eight parity witnesses
   and `H2=x^2+y^2+z^2` split every normalized simple-`Q` grade.  The ambient
   `J5/J7` correction image is now proved to equal the complete
   residue-cleared `J11/J13` target in every transverse grade, including the
   zero low-grade bulk and both stable parity strands.  The strict
   Koszul-tangent bulk image is zero, but the full ambient correction is the
   permitted source after the first gate.  This is still only the normalized
   centre-line module.  The attempted global relative-divisor antecedent is
   now impossible for the factorized family.  A residue-zero `p4_P` on
   `V(q_P)` would define a point of the fixed elliptic cubic over a quadratic
   function algebra.  Its elliptic trace descends to `P^2` and is constant,
   while the effective `S3` order-three stabilizer translates it by nonzero
   `2T`.  Split, nonreduced, singular, nonnormal, and irregular covers give
   no escape, and the exact common-basis audit finds all six prescribed
   boundary values in one orbit.  Thus the global factorized Koszul family
   cannot reach `I11/I13`.  The proposed primitive nonfactorized continuation
   is impossible as well.  The constant map `Sym^2(E_-) -> E_+^*` is an
   isomorphism, so Hilbert--Burch forces every regular `p4` syzygy into
   `(A,B)E_+` and hence to zero on the forced common-zero scheme.  A common
   divisor compatible with both nonzero roots is necessarily quadratic and
   reduces to the trace-obstructed case.  Therefore every normal-order `3/4`
   planewise extension retaining these line germs is closed; a Fable escape
   must change the boundary or leading normal order.  No later correction or
   algebraization is proved.  This is a scoped negative landing theorem and
   uses no instantiated degree.  The corrected
   calculations are in `tmp/fable_constrained_cokernel/REPORT.md` with its
   `AUDIT_NOTES.md`, followed by
   `tmp/fable_finite_d12_constrained/REPORT.md` and
   `tmp/fable_finite_d12_constrained/interface_design.json`, followed by
   `tmp/fable_d12_char0_bridge/REPORT.md` and its `PROOF_AUDIT.md`, followed by
   `tmp/fable_d12_rees_sigma_interface/REPORT.md` and its
   `PROOF_AUDIT.md`, followed by
   `tmp/fable_d12_simultaneous_successor/REPORT.md` and
   `tmp/fable_order12_qsection_correction/PROOF_AUDIT.md`, then the sealed
   `tmp/fable_d12_joint_rank/` and `tmp/fable_d12_koszul_rank/` packets,
   `tmp/fable_d12_module_adversary/`,
   `tmp/fable_d12_bulk_correction_rank/`,
   `tmp/fable_d12_triangular_bulk_closure/`,
   `tmp/fable_relative_divisor_trace_obstruction/`,
   `tmp/fable_fixed_plane_boundary_adversary/`, the synthesis packet
   `tmp/fable_relative_q_trace_obstruction/`, and the independent
   `tmp/fable_nonfactorized_successor/`,
   `tmp/fable_nonfactorized_syzygy_obstruction/`, and
   `tmp/fable_nonfactorized_feasibility/` packets.
5. A primary-source audit through 2026-07-29 finds no missed theorem deciding
   the action.  It did find the July 27 Jung--Saito defect/factoriality
   interface, which first proved the Klein sextic base factorial and, after
   the completed census/rank-720 slice argument, now makes the total `C6`
   factorial as recorded in item 6.  The higher-Amitsur
   branch is now terminal: since
   \(\operatorname{Pic}(X)=\mathbf Z[\mathcal O_X(1)]\) and the generator is
   honestly \(G\)-linearized, the universal-torsor obstruction and every
   higher Amitsur group vanish, also after subgroup restriction.  Recent
   henselian GAGA and perfect-complex algebraization theorems do not imply
   surjectivity
   \(\operatorname{Cl}(B)\to\operatorname{Cl}(\widehat B)\) for the local,
   nonproper `xCD` ring.  That local membership question remains unresolved
   but is retired: the general-slice theorem proves the plane-section result
   without it.  The historical alternative was an explicit finite graded
   Rees lattice or descent cocycle on an open meeting \(s=1\).  The exact relative
   critical curve gives a finite diagnostic, but residue-Galois "monodromy"
   does not control its Zariski contraction partition.  That retired
   conditional exclusion would have required an algebraic four-branch divisor, factorial
   complement, and no singleton contraction block.  The natural two-minor
   polar field cannot supply the factorial complement by a polynomial chart:
   its generic function-field degree is at least two, as certified by two
   distinct unramified points in one good fibre and the off-diagonal etale
   fibre-product argument.  This remains true after every triangular
   correction `a0+P(b,t,c)`, including `a1,a2`; direct local factoriality and
   the class image remain unresolved only inside that retired alternative.
6. The local `xCD` comparison, activating census, and global defect
   implication are now certified.  Saito's comparison identifies the
   pole-four coefficients with the actual eigenvalue-one local groups and
   gives restricted-source rank `660+60=720`; the Cayley bridge identifies
   surjective localization with `def(Y)=0`.  The formerly extra `F_67`
   invariant rank branches all have squarefree induced binary cubics.  On the
   known axis, the saturated projective repeated-factor incidence has local
   Hilbert function `1,2,3,2,1` and length nine over both `QQ` and `F_67`.
   Its entire special length is `60*9=540`, exactly the contribution of the
   known generic orbit.  Properness excludes any additional generic
   repeated-factor base.  Combined with the `L=0` total-incidence theorem,
   this proves that the reduced one-dimensional support of `Sing(C6)` is
   exactly the 120 known fibre lines.

   A genuinely general ample slice avoids residual isolated points and line
   vertices and meets the lines transversely in 180 `A3` plus 180 ordinary
   four-branch `cA` points.  The rank-720 open therefore gives `def(Y)=0`.
   Picard restriction, Ravindra--Srinivas, and Jung--Saito make `Y` and `C6`
   factorial and force the horizontal Weil degree image to be `3Z`.  Hence
   the residue plane cubic has no `C(H6)`-point, and proper specialization
   proves that the original projective `xCD` plane cubic has no
   `K_proj,C`-point.  This closes only the plane section
   `F(a*x+b*C+c*D)=0`, not the full generic twisted Klein cubic threefold;
   the headline remains open.
7. Put

   \[
   K_{\rm Schur}:=\mathbf C(\mathbf P(V_6))^G.
   \]

   The exhaustive degree-eight Schur frame now has a degree-free geometric
   audit.  This is a different generic field from
   \(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\).  All ten ternary coordinate
   sections are smooth geometrically integral genus-one curves.  The generic
   Schur twist has no rational line and no geometrically integral rational
   plane conic, geometric Picard rank one excludes a regular fibration to a
   lower-dimensional projective base, and a separated model
   \(N_{L/K_{\rm Schur}}(z)=B_3(u,v)\) is impossible because its three
   coordinate points are universally singular.  Projection from each
   ambient coordinate line is resolved after blowing up its irreducible
   degree-three intersection with the cubic and gives a genus-one fibration
   over \(\mathbf P^2_{K_{\rm Schur}}\) whose generic fibre is

   \[
   P_{ij}(s,t)+3uB_\Phi(v,v,r_b)+3u^2B_\Phi(v,r_b,r_b)
      +u^3\Phi(r_b)=0.
   \]

   That section attack is now closed for every one of the ten lines.  If
   \(Y_{ij}\) is the blow-up, \(H\) the pulled-back hyperplane class, \(E\)
   its connected degree-three exceptional divisor, and \(F_{ij}\) the
   generic fibre, then

   \[
   \operatorname{Pic}(Y_{ij})=\mathbf ZH\oplus\mathbf ZE,
   \qquad H\cdot F_{ij}=E\cdot F_{ij}=3.
   \]

   Hence every horizontal Cartier divisor has fibre degree divisible by
   three, whereas the closure of a rational section would have degree one.
   The exceptional divisor supplies a closed point of degree three on the
   generic fibre, so

   \[
   \operatorname{ind}(F_{ij})=\operatorname{per}(F_{ij})=3,
   \qquad \xi_{ij}\ne0
   \]

   for all ten pairs.  This no-section theorem does not imply that the total
   threefold has no \(K_{\rm Schur}\)-point: such a point can lie on a special
   fibre.  Chevalley--Warning and Tsen also show that closed finite-field and
   one-parameter geometric specializations of the full five-variable cubic
   always have a point, so a negative specialization must retain at least two
   parameters.  See `tmp/schur_structural_routes/REPORT.md` and its
   `PROOF_AUDIT.md`, together with
   `tmp/schur_fibration_picard_obstruction/REPORT.md`, its
   `PROOF_AUDIT.md`, and its `INDEPENDENT_AUDIT.md`.
8. The Schur central extension is now exact on the generic projective
   torsor over \(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\), not over the
   preceding Schur-source field.  The explicit restriction \(Q_8\to V_4\),
   together with the torsor having boundary quaternion \((s,t)\), proves by
   versality that

   \[
   0\ne\alpha_{\rm proj}\in\operatorname{Br}(K_{\rm proj})[2],
   \qquad \operatorname{ind}(A_{\rm proj})=2.
   \]

   Hence the generic twist of \(\mathbf P(V_6)\) is a nonsplit, non-stably-
   rational Severi--Brauer fivefold; there is no stable replacement of this
   projective factor by projectivizations of honest `G`-representations.
   Passing to two-planes absorbs the ambient obstruction exactly:

   \[
   {}^{T_{\rm proj}}\!\operatorname{Gr}(2,6)
      =\operatorname{SB}_2(M_3(D))\simeq\mathbf P_D^2,
   \]

   which is rational with affine chart \(D^2\).  The distinguished
   \(F_{14}\) section remains the exact problem of a common isotropic right
   \(D\)-line for the descended special five-plane of quaternionic Hermitian
   forms on \(D^3\).  A common line for the generic tuple proves the headline
   positively.  The proposed converse attack by finding one anisotropic
   member is now impossible: twisting the accepted `A4`-fixed point of
   \(F_{14}\) gives a degree-55 zero-cycle, hence a common line after some
   odd-degree extension; for each individual Hermitian member its evaluation
   on \(D^3\) is a 12-dimensional quadratic form, so Springer's odd-degree
   theorem descends isotropy to \(K_{\rm proj}\).  Every member is therefore
   individually isotropic, but their isotropic lines need not agree.  The
   simultaneous common-line problem remains the exact gate.  The current
   artifacts do not yet contain an explicit quaternion over
   \(K_{\rm proj}\), a Morita idempotent, or the five global Hermitian
   matrices; their construction must pass through characteristic-zero
   representation alignment and the 36-dimensional descended algebra with
   involution.  Degree sixteen remains a strict solver nonverdict rather than
   a reason to continue large bounded elimination.  See
   `tmp/pfaffian_generic_schur_audit/REPORT.md` and its `PROOF_AUDIT.md`, and
   `tmp/pfaffian_explicit_descent/REPORT.md`, its `PROOF_AUDIT.md`, and its
   independent `AUDIT.md`.

The structural packet replays are:

```text
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
/opt/homebrew/bin/python3 -u tmp/schur_structural_routes/verify.py
/opt/homebrew/bin/python3 -u tmp/schur_fibration_picard_obstruction/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_generic_schur_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/pfaffian_explicit_descent/verify.py
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
/opt/homebrew/bin/python3 -u tmp/recent_structural_tools_audit/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_class_image_attack/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_ca_class_group/verify.py
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
/opt/homebrew/bin/python3 -u tmp/xcd_char0_candidate_support/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_char0_candidate_support_audit/verify.py
```

No new bounded degree, support, chart, or finite-state sweep is justified by
these results.  The one grandfathered coordinate-`P^21` degree-five
computation is now complete as a strict nonverdict; it does not reopen a
successor ladder, and no `P^22` run is authorized.

## 2026-07-28 exact advances

The headline remains open, but the proof boundary is now sharper in nine
places.

1. The homogeneous landing-covariant exclusion extends through degree
   **24**.  The degree-15 structural proof remains the last scalar-quotient
   step.  The forced-plus-plane restriction is injective in degree 16; its
   complete special-fibre kernels in degrees 17--21 have dimensions
   `2,3,7,11,16`, and exact landing equations have empty projective loci.
   Degree 22 is closed by the exact common-line/even-minus-line ledger
   `25 -> 12 -> 4 -> 0`, without retrying the failed 24-variable chart.
   Degree 23 compresses `34 -> 20`, where 392 necessary cubics give unit
   ideal on all 20 projective charts.  Degree 24 has first-jet rank `43/44`;
   its unique exceptional line has exact transverse order two, while the
   fixed-locus ledger compresses `44 -> 29 -> 20`, where 484 necessary
   cubics give unit ideal on all 20 charts.  From-scratch independent audits
   passed for degrees 23 and 24.  Degree 25 is the first bounded unknown.
   Its exact structural probe has `M25=189`, restriction rank 130, and
   `K25=59`; it parity-excludes the order-two three-space and excludes the
   order-at-least-four six-space by full cubic rank `56/56`.  The unresolved
   leading common-line order-exactly-three system factors through a 37-dimensional quotient, so
   no nonlinear chart or characteristic-zero exclusion is claimed.  A
   from-scratch audit rebuilt the entire degree-25 space, both jet
   filtrations, both multiple-point maps, the full `56/56` landing span on
   the six-space, and the complete `3124/3124` overlap rank.
   See `tmp/degree22_compression/REPORT.md`,
   `tmp/degree23_common_line_landing/REPORT.md`,
   `tmp/degree24_landing/REPORT.md`,
   `tmp/degree25_structural_probe/REPORT.md`, and
   `tmp/degree25_structural_probe_independent_audit/REPORT.md`.
2. In degree 12, the mixed Jacobian-zero incidence is empty over a nonempty
   open subset of its primitive \(\mathbf P^3\), in characteristic 67 and
   characteristic zero.  Any survivor lies on a proper closed exceptional
   locus.  With \(A=\mathbf F_{67}[p_1,p_2,p_3]\), the retained degree-seven
   border map \(A^{65,611}\to A^{50,388}\) is only a truncation, not a presentation of
   that locus: specialized unit membership does not automatically lift to a
   relative annihilator.  Its parameter-independent degree-five block has a
   certified \(721\times721\) minor of determinant \(18\bmod67\).  The fixed
   top ideal has Hilbert function
   `[1,12,78,364,1365,3647,3726,0,0]`, colength `9,193`, and a fully audited
   15,283,769-term reduced Groebner basis.  This proves finite top control,
   not full degree-12 emptiness or an explicit exceptional equation.  A
   checked determinant lemma shows that a right inverse for the
   `31,824 x 56,238` degree-seven top map plus any degree-at-most-two
   multiplier whose rank-18,564 reduced multiplication operator is invertible
   at the sample point produces a determinant killing the full relative
   quotient over \(\mathbf F_{67}\).  A characteristic-zero determinant would
   additionally require lifting the pivot minors and replaying the solves over
   an integral or number-field model.  A length-65,611 specialized unit vector guarantees such a
   multiplier, but a sparse one may suffice.  The required right inverse and
   full-rank operator have not been certified.  The survivor-only,
   ancestor-pruned replay now completes under the `768 MiB` trace-allocation
   gate: `55,966` roots, `45,751,159` committed operations, `479,691,384`
   discarded zero-row operations, and `372,506,624` allocated bytes.  The
   corrected trace maps every sorted and normalized leaf back to the original
   721 generators.  Structural replay passes.  An exact semantic evaluator
   checks all 721 degree-five final rows coefficientwise in 4,368 ambient
   monomials: all 2,882 selected roots and 474,949 trace operations replay
   with zero mismatches at a planned live footprint of 19,111,096 bytes.  One
   complete cross-round degree-seven row with 48,255 nonzero transform entries
   independently multiplies the original forms to exactly `d11^7`.  A compact
   verified division plan covers
   all 31,824 degree-seven targets using 8,181 basis rows and 72,484,088 lower-
   tail edges.  It makes a right-inverse circuit constructible, but the
   selected degree-six and remaining degree-seven roots still need
   coefficientwise semantic comparison with the retained basis; no full right
   inverse or `M7 R = I` check has been emitted.
   Dense expansion is rejected (`782,526,535` live bytes before overhead and
   about `1.59e12` scalar updates).  The exact next gate is to extend the
   ambient-polynomial semantic verifier from the completed 721 degree-five
   rows to the remaining 7,846 degree-six/seven rows.  The audited all-row
   plan uses `478,080,096` peak bytes and about `1.05e12` updates.  Everything remains over `F_67`.  See
   `tmp/relative_kls_chart/REPORT.md`,
   `tmp/relative_kls_chart/TOP_IDEAL_REPORT.md`, and
   `tmp/relative_kls_chart/DEGREE_LOWERING_DETERMINANT.md`; the extraction
   measurement is in `tmp/relative_kls_chart/TRANSFORM_EXTRACTION_GATE.md`;
   the completed trace and its strict evaluator boundary are in
   `tmp/relative_kls_chart/survivor_trace/REPORT.md`,
   `tmp/relative_kls_chart/survivor_trace/evaluator/REPORT.md`, and
   `tmp/relative_kls_chart/survivor_trace/semantic_check/REPORT.md`.
   The separate `p3=0` hyperplane cover produced three exact degree-seven
   timeouts (14, 13, and 12 variables), and a deterministic
   coordinate-nondegenerate projective line has the same first-round size
   profile, so no direct dimension test is being extended.  The line was not
   proved generic relative to the unknown exceptional image.  This proves no
   hyperplane emptiness, finite projection, or
   exceptional-image dimension bound.  See
   `tmp/relative_kls_hyperplane/REPORT.md` and `LINE_PILOT.md` there.
3. For the exact flat connection, the horizontal determinant has only the
   frame and trace-branch polar divisors away from \(t_3=0\):
   \[
   N(\det A)=\frac{2^{10}3^8 11^{12}}{5^4t_3^{24}}D\Delta.
   \]
   The two simple residue spectra are computed.  Their general leading
   systems are rational determinant hypersurfaces of dimensions 19 and 24,
   so neither is a local obstruction.  Beyond 140 one-parameter families,
   all 60 smallest constant simultaneous `P2` modifications are excluded.
   The full constant-coefficient `P4` is empty, upgrading the former 121-point
   sample, and the simultaneous constant centralizer is exactly scalar.  A
   complete two-fibre screen also excludes all 720 projective families in
   which one coefficient in those three-section planes has one affine slope
   in one base coordinate.  A stronger complete screen excludes all 240 `P5`
   families in which the three coefficients have independent slopes in one
   common base-coordinate direction.  One canonical `P8` family with two
   base directions and three regular fibres is completely projectively empty
   as well.  This sequence is not exhaustive: the local determinant
   hypersurface has dimension 19, while the full first-jet space with fixed
   three-coordinate support has dimension at most 10.  The first
   full-support `P9` chart reached the 700 MiB stop without a verdict.  A new
   all-degree correction shows that a pole/degree bound on every solution is
   impossible in the positive case: the primitive quartic covariant defines
   a finite surjective `G`-endomorphism of `P4` of degree 256, and
   precomposition preserves KLS rank drop while multiplying primitive
   saturated degree by four.  The associated rank-1,024 finite free `C`-adic
   decomposition has residue degrees at most 15 but no proved Jacobian
   descent.  The global image/foliation successor proves that every KLS
   solution has an irreducible invariant unirational hypersurface image
   `H`.  If `H` is canonical, it has degree at most four and Adler's invariant
   ledger forces it to be the Klein cubic.  More generally, if `h` is the gcd
   of the pulled-back gradient, `r` is the primitive right-kernel/foliation
   degree, and `t` is the residual adjugate degree, then
   `deg(h)=r+t+d(deg(H)-5)+4`.  Thus `h=1` again forces the Klein cubic, while
   every non-Klein solution contracts a nonzero invariant divisor into the
   image singular locus.  The remaining negative theorem is the minimal
   contraction lemma (or canonicity) for one minimal solution.
   See `tmp/kls_divisor_ansatz/REPORT.md`,
   `tmp/kls_residue_next/REPORT.md`, and
   `tmp/kls_first_jet_two_fiber/REPORT.md` and `REPORT_P5.md`,
   `tmp/kls_first_jet_three_fiber/REPORT.md`, and
   `tmp/kls_structural_audit/REPORT.md` and
   `tmp/kls_global_foliation_theorem/REPORT.md`.
4. On the soluble characteristic-23 `xCD` control, the point
   \(Q=[H-3O]\), the irreducible degree-eight nonzero \(E[3]\) field, and the
   genuine nonzero Kummer representative \(G(Q)\) are explicit.  The
   translation-matrix interpolation remains a strict timeout.  On the
   generic characteristic-zero side, replay-locked DAGs now install the
   monic degree-nine flex eliminant, its first subresultants and inverse, the
   universal rank-nine flex point, and all 81 coordinates of the diagonal
   idempotent.  A typed nested-etale-algebra circuit executes the
   off-diagonal tangent inverse and constructs the actual Cech `X,Y`
   coordinates; exact rank-81 replay checks the short curve, 3-division,
   diagonal, and factor-swap identities without a splitting field.  The
   outputs are typed whole-`K_proj` algebra nodes rather than distributed
   Hironaka vectors.  The raw determinant ratio is exactly not in the
   rank-nine group algebra (rank `108`, augmented rank `109`).  Dividing the
   projective translation lift by the unit scalar cochain `ell(M0)` corrects
   it: the generic descent lemma and an exact selected `9 x 9` solve produce
   a generic-open rational representative
   `alpha_R=det(M0)/ell(M0)^3` modulo cubes.  The geometric lemma, not the one
   finite-field membership sheet, proves generic descent; the full-81 replay
   corroborates it.  Cubic scaling and orientation agree, while
   `alpha_R(O)=71^-3` is a cube rather than literally one.  The affine unit
   chart for `G(P)=alpha_R*z^3` is now assembled exactly.  After
   fixing `z_O=71`, it has ten variables and nine cubics over `K_proj,QQ`,
   with `Norm_R8(z_star)!=0`.  Its `3^8` sheets split geometrically into
   `3^6=729` degree-nine 3-covering components, so geometric nonemptiness is
   automatic and irrelevant.  The CFOSS distinguished base-defined component
   is \(K_{\mathrm{proj},\mathbf C}\)-isomorphic as a covering to the original explicit
   projective `xCD` plane cubic; it need not be literally the same embedded
   component.  Thus the direct arithmetic target is that existing plane
   cubic, not extraction or projective closure of the raw 729-component
   union.  A `K_proj,QQ` point suffices positively after scalar extension,
   but a negative result must hold over
   \(K_{\mathrm{proj},\mathbf C}=K_{\mathrm{proj},\mathbf Q}
   \otimes_{\mathbf Q}\mathbf C\); arithmetic primes and a `QQ`-only Selmer
   result are insufficient.  The exact gauge `q=f6/f5` proves that every
   prime component of `A=0`, `B=0`, and `C=0` has a smooth coordinate residue
   point, so those three divisor families cannot obstruct.  A full-degree
   squarefree `F_23` line restriction now proves that the degree-120
   discriminant is geometrically squarefree in characteristic zero and
   coprime to `f5*f6`.  The normalized discriminant has valuation one at every
   component on the normal quotient.  Poonen--Stoll's 2026-06-30 theorem then
   gives one residue-rational nondegenerate node, so projection and Hensel
   lifting give a local point at every discriminant component.  This closes
   the discriminant as a negative local route, not by itself the `xCD` point
   problem or the headline.  The two motivated smooth-reduction primes `f5=0` and
   `f6=0` are geometrically integral and admit alternate unit gauges.  Their
   three coordinate vertices and every complete invariant-polynomial
   `x,C,D` ansatz of total source degree at most 15 are empty.  This was only a
   height lower bound.  The later general-slice theorem obstructs `f6=0`; the
   `f5=0` residue and a genuinely full-threefold relative descent remain
   independent open diagnostics.
   See
   `tmp/xcd_control_next/REPORT.md`,
   `tmp/xcd_generic_cech_next/REPORT.md`,
   `tmp/xcd_first_descent_next/REPORT.md`,
   `tmp/xcd_arithmetic_next/REPORT.md`,
   `tmp/xcd_discriminant_divisor/REPORT.md`, and
   `tmp/xcd_gauge_divisors/REPORT.md`.
5. The July 2026 level-11 theta/Schwarz construction is exactly identified
   with the correct projective representation, but
   \(F(H\Phi_{11})=\xi_{44}^5u^{11}+O(u^{99})\ne0\), and all 25 classical
   Hessian-minor tests are nonzero.  This particular recent modular lead is
   therefore closed.  See `tmp/theta11_test/REPORT.md`.
6. The former direct degree-16 residual is retained only as superseded
   provenance.  Its complete landing system was reduced to a finite-over-`P3`
   relative incidence.  The quotient dimension is 20 and landing rank
   is 93.  The pure-normal ideal is Artinian of length `6,169`, giving finite
   projection to the scalar `P3`; the scalar locus has a common
   nine-dimensional tangent kernel, and that full straight slice is empty by
   a weighted cokernel of length `713`.  The weighted-projective second-order
   lifting incidence is empty, so no nonzero normal tangent direction admits
   a second-order lift.  The global rank-15 shortcut is exactly refuted: the `93 x 15`
   matrix has rank five on the tangent-kernel `P8`, although that kernel does
   not meet the required `y=(Sym^2(s),s,1)` locus.  The remaining exact
   question is the constrained Veronese-affine residual incidence.  Off
   `P8`, the quotient subspace depends only on `P(im T)=P6`, but the projected
   `Q(n),C(n)` retain all nine kernel coordinates; the honest base is the
   blowup of `P15` along `P8`, not `P6`.  Clearing the quotient and Veronese
   recovery gives 93 equations of degrees 12 and 13 in 19 variables, so this
   is not a smaller solve.  The first relative image equation is now exact in
   characteristic 67.  A normal linear form
   `L=(1,38,20,6,8,2,25,56,9,25,34,21,38,12,54,64)` annihilates the common
   kernel, and a fixed combination of the 93 original cubics is exactly
   `59*L^3`.  Thus every residual special-fibre point lies above
   `t0+38*t1+20*t2+6*t3+8*t4+2*t5+25*t6=0` in `P6`.  The generic row rank
   on this hyperplane is 91.  All 264 retained full-fibre solves there are
   unit ideals, but they are finite tests; the first complete 18-variable
   hyperplane chart reached the 700 MiB watchdog without output in both
   four-thread and one-thread runs.  The deeper hyperplane support and any
   characteristic-zero lift of this equation remained open in that
   formulation.  The injective plus-plane restriction now closes degree 16,
   so this route is no longer a re-entry point.  See
   `tmp/degree16_landing_probe/REPORT.md` and
   `tmp/degree16_exceptional_search/REPORT.md`.

7. The first structural residue audit at \(f_6=0\) isolates an exact
   period-three gate without proving a local obstruction.  Upstairs on
   \(H_6=V(f_6)\), the residue cubic lies in
   \(\mathbf P_{H_6}(\mathcal O(-1)\oplus\mathcal O(-4)\oplus
   \mathcal O(-5))\).  Exact reduction modulo 67 rules out every triple-line
   fibre.  Conversely, the five coordinate fibres are \(a c^2\), and the
   total model inherits a codimension-three singular stratum from
   \(\operatorname{Sing}(H_6)\), so blanket fibrewise geometric reducedness
   fails and no total-space UFD conclusion follows from fibre geometry.  The pullback total space is now
   proved integral and normal.  Modulo 998244353, a deterministic plane
   section of \(V(f_6,\Delta)\) consists of 720 distinct points; this proves
   that the discriminant restricted to \(H_6\) is geometrically reduced in
   characteristic zero.  A separate under-cap certificate excludes zero
   cubic fibres, so flatness, \(S_2\), generic smoothness, and the
   Poonen--Stoll valuation-one theorem give \(R_1\).  The first
   codimension-three class maps are now exact.  The singular locus of
   \(H_6\) is one 60-point orbit of \(A_3\) points, with Jacobian-scheme length
   180.  The July 27 Jung--Saito pole-order calculation is exact here: the
   two diagonal ranks are `75,2125`, the full rank is `2200`, and the
   characteristic-zero degree-13 Jacobian quotient has dimension 255.  Thus
   \(\operatorname{def}(H_6)=0\), and Jung--Saito factoriality gives

   \[
   \operatorname{Cl}(H_6)=\mathbf Z[\mathcal O_{H_6}(1)].
   \]

   In particular every algebraic local ring of \(H_6\), also after the
   relevant \(\mathbf C(\lambda)\)-extension, is a UFD.  At the simple fibre
   line the **completed/henselian** base class map is an isomorphism.  At the
   doubled line there are four henselian branches and the completed map
   \(\mathbf Z\to\mathbf Z^3\) has column \((1,1,0)\), hence cokernel
   \(\mathbf Z^2\).  The actual algebraic base class group is zero, so that
   pair-sum vector is created by completion.  This removes the base as a
   source of algebraic total classes but neither proves \(B\) or \(C_6\)
   factorial nor excludes a primitive horizontal branch class.  The global
   Picard/Cartier step is now proved.  With the corrected bundle convention
   the ample cubic class is \(D=3\zeta=15H+3\xi\), and exact all-negative-
   twist cohomology plus SGA 2 gives

   \[
   \operatorname{Pic}(C_6)=\mathbf ZH\oplus\mathbf Z\xi,
   \qquad
   \operatorname{Pic}(C_6)\xrightarrow{\sim}\operatorname{Pic}(Y)
   \]

   for an effective-Cartier \(Y\in|D|_{C_6}\).  For general \(Y\), the
   Ravindra--Srinivas class-group isomorphism therefore identifies the two
   \(\operatorname{Cl}/\operatorname{Pic}\) defects.  In particular all
   Cartier horizontal degrees are divisible by three.  The singular-locus
   input is now proved: an \(L^2M\) fibre forces the three fibre derivatives
   to span at most two quadrics, while modulo 67 the twenty maximal minors of
   their 6-by-3 coefficient matrix and \(f_6\) have unit ideal on one chart
   of the invariant hyperplane \(w_0+\cdots+w_4=0\).  Cyclic symmetry,
   properness, and the projective dimension theorem give

   \[
   \dim\operatorname{Sing}(C_6)\le1.
   \]

   The intended local census and general-slice transversality are now
   exhaustive.  Four non-axis invariant rank-support branches modulo 67 have
   squarefree induced binary cubics.  On the known axis, the intrinsic
   saturated projective repeated-factor incidence has local length nine over
   both `QQ` and `F_67`; its full special length and the known generic
   contribution are both `60*9=540`.  Properness therefore excludes every
   extra characteristic-zero repeated-factor base.  Together with the `L=0`
   verticality theorem, this makes the reduced positive-dimensional singular
   support exactly the 120 known fibre lines.  A general ample slice avoids
   all residual isolated points and vertices and meets those lines
   transversely in 180 `A3` plus 180 ordinary four-branch `cA` points.  The
   rank-720 local comparison and global bridge therefore prove
   \(\operatorname{def}(Y)=0\).  Jung--Saito makes \(Y\) and \(C_6\)
   factorial and forces the full Weil degree image to be \(3\mathbf Z\).
   Thus the residue plane cubic has no `C(H6)`-point, and proper specialization
   proves that the original projective `xCD` plane cubic has no
   `K_proj,C`-point.  This closes only the distinguished plane section, not
   the full generic twisted Klein cubic threefold; the headline remains open.

   The local class-image/Rees discussion below is retained as a failure ledger
   for an alternative proof of the same plane-section result.  It is no longer
   a live gate.
   A base hyperplane is not ample and one fixed-\(\lambda\) specialization
   has no known injective class specialization.  The full stabilizer is
   \(C_{11}\), it
   fixes all four branches, and the invariant henselian defect still has rank
   two.  The two within-pair branch differences span only an index-four
   sublattice, so primitive individual branch patterns must still be tested.
   Algebraic factorization upgrades the four formal branches to henselian
   branches, but faithful-flat contraction does not prove individual Zariski
   descent: re-extension may group conjugate branches.  Before the
   general-slice completion, the same negative plane-section result would
   have followed if the horizontal divisor-degree image of the normalized
   quotient total space modulo vertical classes were \(3\mathbf Z\).  The
   then-open gate was the image of the global class group in the four
   labelled valuations of the equivariant weighted Rees boundary, followed
   by horizontal degree.  The section-preserving weighted Rees deformation
   is now exact: its special equation is `u*v+g4(t,c)`, and the four primitive
   special branch modules have explicit `2 x 2` matrix factorizations.
   Individual descent is equivalent to a graded, `s`-torsion-free rank-one
   reflexive Rees lattice with primitive special reflexive hull `I1` or `I3`.
   The sufficient defect-free `2 x 2` ansatz now lifts to every **formal**
   `s`-order for all four branches.  The exact tangent determinant map has an
   all-weight right inverse, so determinant induction constructs formally
   homogeneous matrices over `K[u,v,t,c][[s]]`; their cokernels are
   `s`-torsion-free rank-one MCM/reflexive and specialize exactly to the four
   branch modules.  Hence no higher formal obstruction can occur in this
   ansatz.  The infinite matrices are not finite algebraic `G_m`-graded
   matrices and cannot be evaluated at `s=1`.  Artin--Popescu approximation
   nevertheless promotes them to exact factorizations over the henselization
   of the pair along `(s)`, congruent to the chosen special matrices.  This
   proves pair-henselian effectivity, but not section-preserving Zariski
   algebraization: `1-s` is a unit in the henselization, and equivariant
   coherent completeness recovers only the completed original local ring.
   The unresolved local condition is exactly
   `[I_i] in image(Cl(B) -> Cl(Bhat))`, or an explicit finite graded Rees
   lattice/descent cocycle on an open meeting `s=1`.  The formal survivor also
   does not test general Rees lattices with a
   finite-length special-fibre defect.  The exact relative critical curve is
   now cut out by the Jacobian minors
   `p_y=U_x*f6_y-f6_x*U_y` and
   `p_z=U_x*f6_z-f6_x*U_z`; its henselization is the four-branch curve `g=0`.
   Strict-henselian residue Galois fixes all four branches and supplies no
   monodromy obstruction.  An explicit normal cA UFD whose completion has
   class group `Z` demonstrates the failure.  The correct conditional
   negative theorem requires an algebraic element `a` with reduced henselian
   divisor `Q1+...+Q4` and no extra primes, factorial complement `B[1/a]`,
   and no singleton block in the contraction partition.  Nagata localization
   would then exclude every primitive branch class; the critical-curve
   component partition alone does not.  This distinction is now sharp.  For
   an algebraic standard `cA` equation `u*v+g(t,c)`, the algebraic factors of
   `g` give `Cl=Z^r/Z*(1,...,1)`, and henselian refinement sends each source
   factor to its exact block sum; a primitive target branch is algebraizable
   exactly for a singleton block.  In contrast, the fused equation
   `u*v+c^4-t^4*(1+t)` and the split equation `u*v+c^4-t^4` have isomorphic
   four-branch completions but class images zero and full `Z^3`.  Thus the
   completed equation and branch tangents do not determine the image; the
   actual ring still needs an algebraic ruling/incidence comparison or a
   direct finite reflexive module.  The natural exact null polar
   `a0=p_z-(5/2)*lambda^4*p_y`, with `b=p_y/6`, is now refuted: although
   `(U,a0,b,t,c)` has Jacobian determinant `6` and initials `(u,v)`, the
   tangent quartic on `U=a0=0` differs from `g4`, and
   `H4(b,0,0)=-(8235/2)*lambda^10*b^4`.  Therefore
   `div_(B^h)(a0) != Q1+...+Q4`.  The unique ordinary cubic correction in
   `(b,t,c)`, `a1=a0+phi3(b,t,c)`, repairs this necessary tangent test but
   fails the exact next test.  On `U=a1=0`, the common-axis order is five,
   with coefficient `12*lambda^2*(195*lambda^11+2)`, whereas four reduced
   smooth branches tangent to `C-r_i*T` require product order at least eight.
   Hence `div_(B^h)(a1) != Q1+...+Q4`.  The complete fifth-order error
   `H5=(3/8)*b^2*P3` gives the finite ordinary-quartic candidate
   `a2=a1+H5/b`; its divisor and `B[1/a2]` factoriality remain open, and no
   further jet ladder is justified.  The degree-one Zariski Morse chart is
   now refuted for this entire polar field.  At
   `p=67, lambda=1, t=c=0`, the two distinct points `(0,0,0)` and
   `(15,48,57)` have the same `(U,a0,b)` value and nonzero full Jacobian
   determinants `6` and `38`.  The etale locus off the diagonal in the
   fibre product promotes this exact collision to

   \[
   [\mathbf Q(\lambda,x,y,z,t,c):
     \mathbf Q(\lambda,U,a_0,b,t,c)]\geq2.
   \]

   Since `(a0,b)` is an invertible recombination of `(p_z,p_y)`, no
   birational reparametrization of the polar minors, including `a1`, `a2`,
   or any `a0+P(b,t,c)`, has a dense-open rational inverse.  This closes only
   the polar-coordinate proof of factoriality: the divisor of `a2`, direct
   factoriality of `B[1/a2]`, a genuinely different transverse field, and
   the primitive class image remain open.
   No general Lefschetz theorem applies to this fixed
   special cubic.  The default verifier checks sealed exact outputs; its
   opt-in full Gröbner recomputation measured about 0.95 GB RSS, above the
   700 MiB gate.  See `tmp/xcd_residue_class_gate/REPORT.md`,
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
8. The Problem F involution obstruction has been tested rather than imported
   formally.  For every involution \(t\), the eigenspace dimensions are
   \((3,2)\), the plus-plane cuts \(X\) in a smooth genus-one cubic, and the
   invariant odd-cubic identity gives \(F|_{E_-(t)}=0\).  Thus the whole
   minus-line lies on \(X\), and a pointwise-\(t\)-fixed exceptional divisor
   can map nonconstantly to it.  The centralizer has no fixed point on \(X\).
   It follows exactly that all 55 plus-planes are base components of any
   hypothetical primitive landing covariant, their common transverse order
   is odd, and their leading exceptional maps dominate the fixed lines.  This
   is a useful all-degree necessary condition but not a contradiction.  For
   \(K=V_4\), the exact joint dimensions are \((2,1,1,1)\), the three fixed
   lines form a triangle, and the three triangle vertices are accompanied by
   a reduced three-point set on the common fixed line.  Every triangle vertex
   has stabilizer exactly \(K\) and tangent representation equal to the sum
   of all three nontrivial characters; no involution has scalar differential.
   The exact \(D_{12}\) restriction module has dimension zero in even degree
   and \(\lfloor(d+2)/3\rfloor\) in odd degree.  Its six neighboring-plane
   intersections form the reflection discriminant \(x^6-y^6\); the
   mandatory odd power forces a swap only when the normalized endpoint is
   nonzero, while extra endpoint factors realize every transition ledger.
   Thus Fable's finite transition graph closes rather than obstructs.  A
   successor would have to control the complete symbolic 55-plane arrangement
   or higher-dimensional exceptional centers.  The first associated-graded
   constraint is exact: for common odd plane order \(m=2r+1\), landing rules
   out transverse order \(3r+2\) on a common \(V_4\)-fixed line, hence the
   order is at least \(3r+3\).  Mixed trivial/nontrivial terms appear at that
   next order, so no iteration is proved.  At degree 25, `m=1`, this is
   exactly the common-line order-at-least-three condition already built into
   the strict 43-space and hence adds no row to the 842-cubic/rank-28
   presentation.  Odd degree permits a dominant minus-line restriction, so
   no universal minus-line equation follows.  See
   tmp/involution_exceptional_divisor/REPORT.md and V4_REPORT.md there, and
   tmp/d12_line_restriction/REPORT.md and
   tmp/v4_surface_slice_audit/REPORT.md.
9. The first 55-plane symbolic complex has been calibrated, while the
   all-degree global theorem remains open.  The reduced split-fibre
   arrangement has 55 triple lines and 121 multiple points, no scalar
   equations through degree 14, and ideal dimensions `42,171,412,797` in
   degrees 15--18.  These scalar spaces are not the equivariant odd symbolic
   module.  On complete self-covariant spaces, the restriction and landing
   calculation gives the degree-24 cutoff in item 1.  The degree-17
   common-line computation is independent; the corrected extension reuses
   the restriction kernels in degrees 18--21 and corroborates that part of the cutoff by
   a separate initial-form test after converting joint-\(V_4\) initials back
   to the original cyclic coordinates.  The induced `D12` ordinary/jet
   blocks and the first `A4`/`D10`/`D12` line/point maps are now exact.  The
   complete scalar overlap map is surjective in degrees 5--23 and separately
   in degree 25.  Over split `F_67`, compact induced `W`-block calculations construct actual
   higher-compatibility quotient bases of dimension 16 in every degree
   18--29.  Nine `f3`, seven `f5`, and one `f11` multiplication maps are all
   isomorphisms over `F_67`; a from-scratch independent audit agrees.  The
   ordinary defect sheaf is now proved to be supported exactly at the 121
   multiple points, with scalar length 13 at each and `W`-multiplicities 9
   and 7 on the two point orbits.  Arrangement regularity gives
   `dim D_d[W]=16` for every `d>=54` in characteristic zero as well as the
   split good fibre.  Degrees 30--53 remain a finite gap.  At all 121 multiple points, the minimal
   local symbolic
   layers are now presented for every `m`: their first degree is `3m` and
   their character is reflection-sign when `m` is odd.  Hence common odd
   plane order `m` forces point order at least `3m+1`, but the first
   post-minimal layer already contains the target representation.  The
   symbolic normalization is qualitatively different from the ordinary one:
   its first exact cokernel is supported along every triple line, with
   explicit `A4` characters for `m=1,3`.

   The symbolic compatibility packet and its independent audit prove the
   exact local orientation: `I^(m)/I^(m+2)` injects into plane normalization;
   generic triple-line equalizers are imposed next; residual point quotients
   come only after that.  The subsequent global theorem proves that these
   iterated kernels give the correct associated sheaf in every twist.  It
   does not make the naive four-term Cech complex exact, and literal
   low-degree graded equality still requires the finite irrelevant-torsion
   saturation `T_m`.  Over split `F_67`, the bounded `m=1` calculation gives
   `[(T_1)_d tensor W]^G=0` through degree 34 and in every degree at least
   164.  Every induced map `D_d->D_(d+3)` with `14<=d<=31` is injective, and
   the quotient truncated through degree 34 has dimension 1,459.  Degree 35
   refutes the proposed continuation: the compact saturation has dimension
   362 and the independently rebuilt literal image has dimension 361, hence
   `dim [(T_1)_35 tensor W]^G=1`.  Finite irrelevant-torsion nilpotence gives
   a nonzero element of `(0 :_D1 f3)` in some degree.  Thus the all-degree
   split-fibre colon-zero statement and its target-1,572 certificate are
   false.  The first killed degree is unknown, and no characteristic-zero
   saturation conclusion follows.  A complete second split fibre at
   `(89,zeta11-2)` again has compact dimension 362, while its ambient global
   dimension 637 and order-zero restriction rank 276 bound the literal image
   by 361.  This is a second positive fibre defect, not a lift.  The raw
   degree-10 cyclotomic line matrix has a 492.8 MiB coefficient floor before
   field/bignum overhead; a generic theorem needs intrinsic compressed
   differentials or a small exact cycle/nonboundary certificate.  Direct
   plane jets give
   `[(I^(3)/I^(5))_d tensor W]^G=0` for `25<=d<=31`, promoted to
   characteristic zero by full-rank good reduction.  Over split `F_67`, the
   `m=3` total-degree-19 first line stratum is killed by a rank-`8/8`
   assembled `D12` boundary.  Separately, also over split `F_67`, the compact
   `m=1`, degree-25 complex has ledger `673 --309--> 364 --305--> 59` and recovers the direct
   global `K1/K3` exactly.  Its landing filtration has ranks `16,37,6`; the
   available point initials do not cut the 37-dimensional leading
   common-line quotient.  The full factored order-four plane system has now
   been assembled as an exact rank-842 cubic space and normalized to 833
   monic relations plus a nine-equation determinantal tail.  These finite
   calculations are not `(ID_m)`, characteristic-zero survival statements,
   or a revival of the Problem F path argument.

   The exact all-degree successors are intrinsic characteristic-zero
   saturation maps, higher symbolic order, and uniform relative border/Fitting
   landing detection on
   `[(I^(m)/I^(m+2))_d tensor W]^G`, not another raw scalar Hilbert degree,
   isolated point-row sweep, or finite transition table.  See
   `tmp/local_symbolic_rees/REPORT.md`,
   `tmp/d12_block_attack/REPORT.md`,
   `tmp/higher_compatibility_regularity/REPORT.md`, and
   `tmp/ordinary_defect_support/REPORT.md`, together with
   `tmp/symbolic_compatibility_complex/REPORT.md`,
   `tmp/m3_line_point_boundary/REPORT.md`,
   `tmp/m1_compact_degree25/REPORT.md`,
   `tmp/m1_t1_saturation/REPORT.md`,
   `tmp/m1_t1_propagation_design/REPORT.md`,
   `tmp/m1_t1_f3_colon_attack/REPORT.md`,
   `tmp/m1_t1_f3_colon_degree35_audit/REPORT.md`, and
   `tmp/m1_t1_char0_d35_gate/REPORT.md`, together with
   `tmp/all_degree_arrangement_attack/REPORT.md`.

## Exact reduction to essential dimension

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

let \(C\) be the Klein cubic with its faithful five-dimensional action, and
let \(F_{14}\) be the associated genus-eight Fano threefold.

### Theorem

The following are equivalent:

1. \(C\) is \(G\)-unirational;
2. \(\operatorname{ed}_{\mathbf C}(G)=3\).

Since \(3\leq \operatorname{ed}_{\mathbf C}(G)\leq4\), it follows as well
that

\[
C\text{ is not }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=4.
\]

### Proof

Suppose first that \(C\) is \(G\)-unirational. A dominant equivariant map
from a representation to the faithful threefold \(C\) is a three-dimensional
compression. Hence \(\operatorname{ed}(G)\leq3\), and the known lower bound
gives equality.

Conversely, assume \(\operatorname{ed}(G)=3\). Duncan–Reichstein Remark 2.6
gives a faithful, generically free, three-dimensional very versal
\(G\)-variety \(Z\). It is dominated by a linear representation. Equivariant
compactification and resolution preserve that dominance and give a smooth
projective unirational, hence rationally connected, model.

Because \(G\) does not embed into \(\operatorname{Cr}_2(\mathbf C)\),
Prokhorov Theorem 1.1 and the equivariant MMP in §4.2 reduce to a Fano–Mori
model; Theorem 1.5 classifies it as
\(G\)-birational to one of the two \(\operatorname{PSL}_2(11)\) models,
namely \(C\) or the Pfaffian \(F_{14}\) of Example 2.9. This identification
may precompose the action by
an automorphism of the abstract group \(G\). That is harmless: very
versality and the all-torsors criterion are unchanged by relabeling \(G\),
and the equivariant bridge below may be precomposed by the same automorphism.
Thus either \(C\) or \(F_{14}\) is very versal.

If it is \(C\), the conclusion follows. Assume that \(F_{14}\) is very
versal. Let \(K/\mathbf C\) be any extension and \(T/K\) any \(G\)-torsor.
Twisting Tschinkel–Zhang Proposition 4.1 gives a \(K\)-birational map

\[
{}^T C\times\mathbf P^2\times S_T
\dashrightarrow
{}^T F_{14}\times\mathbf P^2\times S_T,
\]

where \(S_T\) is the Brauer–Severi twist of the projective five-space coming
from the six-dimensional representation of
\(\operatorname{SL}_2(\mathbf F_{11})\).

Write \(\alpha_T=[S_T]\in\operatorname{Br}(K)\). It is the boundary of
\(T\) for

\[
1\longrightarrow\mu_2\longrightarrow
\operatorname{SL}_2(\mathbf F_{11})\longrightarrow G\longrightarrow1,
\]

so \(\exp(\alpha_T)\mid2\). The associated central simple algebra has degree
six, hence \(\operatorname{ind}(\alpha_T)\mid6\). Index and exponent have
the same prime divisors, so the index is one or two. In the index-two case,
the underlying division algebra has a separable quadratic maximal subfield.
Consequently \(S_T\) splits over a separable extension \(L/K\) of degree at
most two.

Very versality of \(F_{14}\) implies that \({}^T F_{14}\) is
\(K\)-unirational. After base change to \(L\), the right-hand product above
has Zariski-dense \(L\)-points, so one may choose a point in the domain of the
inverse birational map. Projection to the first factor gives

\[
{}^T C(L)\ne\varnothing.
\]

We now use an elementary descent lemma.

> **Quadratic descent for cubics.** Let \(D\subset\mathbf P^n_K\) be a cubic
> hypersurface and let \(L/K\) be separable of degree at most two. If
> \(D(L)\ne\varnothing\), then \(D(K)\ne\varnothing\).

For a quadratic extension, join a point \(P\) to its conjugate. Their line is
defined over \(K\). If it lies in \(D\), it is a \(K\)-line and supplies a
\(K\)-point. Otherwise the conjugate pair accounts for two points in the
degree-three intersection with \(D\), and the residual degree-one subscheme
is a \(K\)-point.

The honest five-dimensional linear representation is crucial here: it makes
\({}^T\mathbf P(W)=\mathbf P({}^T W)\) a split \(\mathbf P^4_K\), so
\({}^T C\) is an ordinary cubic hypersurface in split projective space. The
lemma gives \({}^T C(K)\ne\varnothing\). This holds for every \(T/K\), hence
\(C\) is weakly versal; Duncan–Reichstein Theorems 1.1 and 10.5 make it very
versal, equivalently \(G\)-unirational. This proves the theorem.

### Consequence and limitation

The headline is now exactly the still-open dichotomy

\[
\operatorname{ed}_{\mathbf C}
\bigl(\operatorname{PSL}_2(\mathbf F_{11})\bigr)\in\{3,4\}.
\]

An unconditional proof of the value three settles Problem E positively; an
unconditional proof of the value four settles it negatively. Current
conditional routes point in opposite directions: Cassels–Swinnerton-Dyer or
Duncan–Reichstein Conjecture 8.8 would give three, while Dolgachev's proposed
inequality \(\operatorname{Crdim}(G)\leq\operatorname{ed}(G)\) would give
four. Here \(\operatorname{Crdim}(G)=4\): Prokhorov gives the lower bound and
the faithful action on \(\mathbf P(W)=\mathbf P^4\) gives the upper bound.

## Exact action

Put \(\zeta=\zeta_{11}\) and

\[
\gamma=
\sum_{a\in\{1,3,4,5,9\}}\zeta^a-
\sum_{a\in\{2,6,7,8,10\}}\zeta^a,
\qquad \gamma^2=-11.
\]

Let

\[
(j_0,\ldots,j_4)=(1,3,2,5,4),
\qquad
(\epsilon_0,\ldots,\epsilon_4)=(1,1,-1,1,1).
\]

Exact generators on coordinate columns are

\[
T_{ik}=\delta_{ik}\zeta^{j_i^2},
\qquad
S_{ik}=\frac{\epsilon_k}{\epsilon_i}
       \frac{\zeta^{9j_i j_k}-\zeta^{-9j_i j_k}}{\gamma}.
\]

The certificate checks in \(\mathbf Q(\zeta_{11})\) that

\[
S^2=T^{11}=(ST)^3=1,
\]

traverses the complete 660-element Cayley graph of
\(\operatorname{PSL}_2(\mathbf F_{11})\), and verifies

\[
F(Sx)=F(Tx)=F(x),
\qquad
F(x)=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}.
\]

This is an exact faithful honest linear action, not a projective action of the
double cover.

## Explicit generic-twist frame

Let \(x,C,D,E,K:W\to W\) be the primitive covariants of degrees
\(1,4,5,6,7\) constructed and checked in `certificates/`. Their determinant

\[
\Delta(x)=\det[x,C,D,E,K]
\]

is a degree-23 invariant. The exact integer witness

\[
x=(-2,-2,-2,-2,-1),
\qquad
\Delta(x)=-295136920
\]

proves that it is not the zero polynomial.

Let \(L=\mathbf C(W)\) and \(K_0=L^G\). At the generic point, each covariant
is a semilinear invariant vector and hence descends to the twisted vector
space \({}^{T_{\rm gen}}W\). Since \(\Delta\in K_0^\times\), the matrix

\[
M=[x\ C\ D\ E\ K]
\]

is an explicit Hilbert-90 trivialization: its columns descend to a
\(K_0\)-basis. In coordinates \(a=(a_0,\ldots,a_4)\), the generic twisted
Klein cubic is therefore

\[
\Phi(a)=F(Ma)=0,
\qquad
\Phi\in K_0[a_0,\ldots,a_4].
\]

This completes the generic ambient-space descent explicitly. It does **not**
produce a nonzero \(a\in K_0^5\) with \(\Phi(a)=0\); that is precisely the
remaining generic-twist point problem.

The field can be reduced by one transcendence degree. Put

\[
K_{\mathrm{proj}}=\mathbf C(\mathbf P(W))^G.
\]

The affine generic torsor is the base change of the projective generic torsor
and \(K_0\simeq K_{\mathrm{proj}}(u)\). Since the twisted cubic is proper, a
point over the purely transcendental extension specializes to a
\(K_{\mathrm{proj}}\)-point. Thus the generic point problem is already over a
transcendence-degree-four field. Tsen--Lang makes this a \(C_4\)-field, but
the automatic cubic-form bound requires more than \(3^4=81\) variables, not
the five variables available here.

Let \(T_{\mathrm{proj}}\) be the generic torsor of the free locus of
\(\mathbf P(W)\), and put \(C_{\mathrm{gen}}={}^{T_{\mathrm{proj}}}C\).
Twisting adjunction and the lower bound \(\operatorname{ed}(G)\ge3\) show
that any \(K_{\mathrm{proj}}\)-point gives an automatically dominant rational
map \(\mathbf P(W)\dashrightarrow C\). Hence the remaining dichotomy is the
single exact point problem

\[
\boxed{
\operatorname{ed}(G)=3\iff C_{\mathrm{gen}}(K_{\mathrm{proj}})\ne\varnothing,
\qquad
\operatorname{ed}(G)=4\iff C_{\mathrm{gen}}(K_{\mathrm{proj}})=\varnothing.}
\]

The subgroup-fixed orbit cycles have degrees \(60,132,165,220\) and gcd one,
so every Klein twist has index one.  This is not a point theorem: the missing
implication is precisely the relevant index-one cubic-threefold boundary.
The prime-local essential dimensions are \(2\) at 2 and \(1\) at 3, 5, and
11, while the honestly linearized hyperplane class kills the audited Brauer,
Amitsur, and standard stable-cohomology obstructions.  The full theorem and
obstruction ledger are in `tmp/step4_essential_dimension/REPORT.md`.

### Why homogeneous self-covariants are exhaustive

Searching maps \(W\dashrightarrow C\) loses no generality. If any honest
linear representation \(U\) dominates \(C\) equivariantly, then \(C\) is
very versal, so the generic \(W\)-torsor twist has a \(K_0\)-point. Because
the twisted ambient vector space \({}^{T_{\rm gen}}W\) is split, a vector on
the corresponding \(K_0\)-line lifts this point to a rational
\(W\)-valued covariant \(f\in\mathbf C(W)\otimes W\). Explicitly, if
\(d\in\mathbf C[W]\) clears its coordinate denominators, then

\[
D=\prod_{g\in G}(g\cdot d)\in\mathbf C[W]^G
\]

is divisible by \(d\), so \(Df=(D/d)(df)\) is a polynomial covariant.

Write the resulting nonzero polynomial covariant as
\(f=f_0+\cdots+f_d\) by ordinary degree. Linearity of the action makes every
\(f_i\) a covariant. Since \(F(f)=0\), its top-degree term is
\(F(f_d)=0\). Thus any positive solution from any honest linear source forces
a nonzero **homogeneous self-covariant** \(f_d:W\to W\) landing in \(C\).

Conversely, every such nonzero landing covariant is automatically dominant
here. The closure of its projective image is very versal. Its action has a
normal kernel; the kernel is not all of the simple group \(G\), since
\(C^G=\varnothing\), so it is trivial. The image is therefore a faithful very
versal variety and has dimension at least \(\operatorname{ed}(G)\geq3\).
Since \(\dim C=3\), the image is all of \(C\).

There is one further exact scoped exclusion in these coordinates. For every
unordered pair \(U,V\in\{x,C,D,E,K\}\), the checker forms

\[
F(U+tV)\in\mathbf Z[x_0,\ldots,x_4,t].
\]

All ten polynomials retain \(t\)-degree three after reduction modulo two and
are irreducible over both \(\mathbf F_2\) and \(\mathbf F_8\). This certifies
absolute irreducibility: if an \(\mathbf F_2\)-irreducible cubic in \(t\)
split geometrically, its absolute factors would be a three-element Frobenius
orbit and the splitting would already occur over \(\mathbf F_8\). A
degree-preserving absolutely irreducible reduction is absolutely irreducible
in characteristic zero. Hence none of these ten binary cubics has a root in
\(L=\mathbf C(W)\), and no coordinate line of the frame supplies a
\(K_0\)-point. Any point found in this frame must involve at least three
coordinates. This remains only a coordinate-plane search boundary, not a
point obstruction for \(\Phi\).

### Three-coordinate frame planes

The ten planes spanned by triples from \(x,C,D,E,K\) have also been audited.
At the exact specialization

\[
x=(-1,-1,-1,-1,0),\qquad \det[x,C,D,E,K]=-4400,
\]

each specialized ternary cubic has all ten monomials and its singular ideal
is the unit ideal on every standard projective chart. Consequently every
generic plane section is a smooth geometrically integral genus-one curve.
This rules out a factorization or singular-point parametrization, but
smoothness does not rule out a \(K_0\)-point.

There is a further bounded exclusion. For each triple and each total source
degree \(N=11,12,13,14\), the checker constructs the complete ansatz

\[
A_UU+A_VV+A_WW,\qquad A_Z\in\mathbf C[W]^G_{N-\deg Z}.
\]

It uses the exact invariant Hilbert series and Reynolds averaging at the good
prime \((23,\zeta_{11}-2)\). The selected reductions have the full
characteristic-zero dimensions, and the reduced frame has determinant
\(3\ne0\) at an explicit point. In all 40 triple-degree cases, necessary
landing cubics already generate an ideal whose affine cone has Macaulay2
dimension zero. Projective properness over the cyclotomic DVR therefore
excludes the corresponding characteristic-zero ansätze.

Any \(K_0\)-point in one of these planes can have its invariant rational
coordinates cleared to invariant polynomials; the highest homogeneous part
would be one of these landing ansätze in some total degree. There is no bound
on that degree, so the calculation through fourteen remains a scoped
exclusion. Degree fifteen has no verdict.

There is also an unbounded but narrower flex exclusion. For each of the ten
smooth plane cubics, intersecting with its Hessian gives the degree-nine flex
scheme. An exact specialization to one source line modulo 23 produces a
degree-nine eliminant which remains irreducible over
\(\mathbf F_{23^3}\). Degree preservation, the nonzero infinity resultant,
and good-reduction lifting prove that the generic flex scheme is a single
Galois orbit even over \(\mathbf C(W)\). Thus none of the ten planes has a
\(K_0\)-rational flex. This closes the rational-flex/Hesse-normal-form
shortcut, but not the ordinary point problem: a pointed plane cubic need not
have a rational flex for its chosen degree-three line bundle.

## The `xCD` flex and 3-descent audit

For the plane spanned by the first three frame columns, the ternary cubic

\[
F(ax+bC+cD)=0
\]

is retained exactly in ten coefficient polynomials, with 1,256 terms in
total. Universal integral formulas for the 25-term invariant \(c_4\), the
103-term invariant \(c_6\), and

\[
E:\ y^2=x^3-27c_4x-54c_6
\]

give an exact compositional model of its Jacobian in characteristic zero.

On one certified source line over \(\mathbf F_{23}(s)\), elimination of the
cubic and its Hessian gives a degree-nine flex algebra together with the
missing flex coordinate by a linear subresultant. The flex eliminant remains
irreducible after the cubic constant extension, so its flex-torsor class is
nonzero. Over \(\mathbf F_{23}(s)\) this is an exact primitive-element
presentation; serialization of the full multiplication table stalled during
denominator inversion. The only completed \(9\)-by-\(9\) multiplication,
trace, norm, and tangent packet is the \(s=1\) control fiber, where the algebra
factors as \(1+8\) and the rational flex \([9:16:1]\) makes that fiber's class
trivial. It is not evidence for generic Kummer membership. The line model is
nevertheless everywhere locally soluble: all
finite bad fibers are transverse geometrically integral nodal cubics, and
infinity is good. At \(s=1\), the Jacobian has 28 points, proving that its
function-field Mordell--Weil group has no 3-torsion. Thus a genuine rank-zero
certificate would prove that this one plane cubic has no
\(\mathbf F_{23}(s)\)-point. The public L-function run timed out after its
setup marker, and the independent 2-Selmer submission returned HTTP 504, so
both are strict nonverdicts.

An exhaustive bounded line search found a lower-height prototype

\[
x=e_0+s(1,1,1,1,1)
\]

whose expected L-polynomial degree is 86 instead of 116. Its degree-nine flex
class is still nonzero and a good fiber again excludes 3-torsion. Frozen
L-function and 2-Selmer inputs exist but have not been run. Even a completed
rank-zero calculation would concern only this characteristic-23,
codimension-four specialization; no theorem currently transfers it to the
generic characteristic-zero plane.

A separate low-height coordinate-line plane over \(\mathbf F_{23}(t)\) has
the rational point \(O=[1:0:1]\), while its degree-nine flex eliminant remains
one exponent-one factor over the cubic constant extension.  Hence this
distinct flex torsor is nonzero but abstractly Kummer:

\[
\operatorname{Flex}(C)=[3]^{-1}(Q),\qquad Q=[H-3O],
\]

where \(H\) is a hyperplane section.

This is a positive control for the cohomological statement, not an explicit
generic descent computation.  The tangent residual gives exact coordinates
for \(Q\) on the saved short Weierstrass Jacobian.  The irreducible
degree-eight nonzero \(E[3]\) field and the values \(G_T(Q)\) are serialized,
and exact replay verifies that they form the genuine nonzero first-Kummer
representative of \(\delta(Q)\).  Independent translation interpolation
timed out before producing a matrix or determinant, but is not needed for
this verification.  No theorem transfers the characteristic-23
function-field control to the generic characteristic-zero plane.  See
`tmp/xcd_nonzero_kummer/REPORT.md` and
`tmp/xcd_control_next/REPORT.md`.

The implementation audit also separates genuine from fake descent. If
\(F_{\rm flex}\) is the coordinate algebra of the nine flexes, tangent forms
give only the fake map to

\[
F_{\rm flex}^{\times}/K^{\times}F_{\rm flex}^{\times3}.
\]

The genuine first-Kummer equation instead uses the distinct algebra

\[
\mathcal R=\operatorname{Map}_{K_{\rm proj}}
  (E[3],\overline K_{\rm proj})
\]

together with a representative \(\alpha_{\mathcal R}\) and normalized functions
\(G_T\).  This algebra is now installed generically over the projective
invariant field as

\[
K_{\rm proj}\times
K_{\rm proj}[x,y]/(\psi_3(x),y^2-x^3-Ax-B),
\]

with exact group, difference, and normalized Kummer-function formulas.  The
determinant-free circuit is implemented for the rank-nine flex algebra \(F\),
its universal flex \(P\), and

\[
c_{12}=P_2-P_1\in E[3](F\otimes_KF).
\]

It has passed its structural checks: the triple-overlap identity
\(c_{13}=c_{12}+c_{23}\) holds, and the circuit induces a rank-81 isomorphism
\(F\otimes_K\mathcal R\simeq F\otimes_KF\) on a certified generic open.
Replay-locked `K_proj` DAGs now contain the monic degree-nine flex
eliminant, its first subresultants and inverse, the universal flex point, and
all 81 coordinates of the divided-difference diagonal idempotent.  The
typed nested-etale circuit also executes

\[
\lambda^\#=(\lambda+e_\Delta)^{-1}(1-e_\Delta),
\]

and the saved short-Weierstrass `X,Y` formulas.  Exact replay checks the curve,
3-torsion, diagonal, and factor-swap identities.  The raw determinant ratio
does not descend to \(\mathcal R\) (coefficient rank `108`, augmented rank
`109`).  Dividing the projective translation lift \(M_0\) by the generically
invertible scalar cochain \(c=\ell(M_0)\) corrects it: the geometric descent
lemma gives the generic-open rational representative
\(\alpha_{\mathcal R}=\det(M_0)/c^3\) modulo cubes.  The retained `GF(101)`
all-coordinate computation is a replay check, not the proof of generic
descent.  The saved representative retains the identity coefficient
`71^-3` and fixes `z_O=71`; the equivalent cube-normalized gauge instead has
  identity coefficient one and `z_O=1`.  The original projective `xCD` cubic,
  equivalently the distinguished base-defined component of
  `G(P)=alpha_R*z^3`, is now proved to have no `K_proj,C`-point by the exact
  `f6=0` general-slice factoriality theorem.  The saved ten-variable affine unit chart is
over the exact `QQ`-model and has 729 geometric degree-nine components; the
raw union is provenance, not the smallest arithmetic target.  A negative
result over `QQ` or at an arithmetic prime is insufficient after extending
constants to `C`.  The pure-coefficient divisors `A=0`, `B=0`, and `C=0` are
locally soluble.  The geometric degree-120 discriminant divisor is now closed
as a local-obstruction route too: it is geometrically squarefree and
gauge-coprime, and every normalized component has discriminant valuation one,
so Poonen--Stoll gives a residue-rational node and hence a local point.  At
the smooth-reduction primes `f5=0` and `f6=0`, alternate gauges are integral
and all invariant-polynomial residue points through total degree 15 are
  excluded; for `f6=0` the later degree-image theorem supplies the actual
  obstruction.  The `f5=0` residue and a genuinely full-threefold relative
  unramified obstruction remain open.
A true second 3-descent then needs the degree-twelve algebra of the twelve
lines through triples of flexes, its line
forms, and the fixed curve constants.
See `tmp/xcd_generic_cech_next/REPORT.md`,
`tmp/xcd_first_descent_next/REPORT.md`,
`tmp/xcd_arithmetic_next/REPORT.md`,
`tmp/xcd_discriminant_divisor/REPORT.md`,
`tmp/xcd_gauge_divisors/REPORT.md`, and
`tmp/xcd_total_normality/REPORT.md`.

Honest arithmetic in the projective invariant field is now complete. Exact
primitive integral invariants of degrees 10, 11, 12, and 14 are installed.
Their constructions are

\[
\langle df_5,E\rangle,\quad
\tfrac12\langle df_7,D\rangle,\quad F(C),\quad
\langle df_8,K\rangle,
\]

and exact indecomposable-rank and invariance certificates are in
`tmp/xcd_invariant_field/f10_probe/REPORT.md`.  The primaries
\(f_3,f_5,f_6,f_8,f_{11}\) are certified algebraically independent; Adler's
twelve secondaries form a certified free Hironaka basis; the complete
12-by-12 multiplication table is checked; and normalization by
\(\tau=f_3^2/f_5\) gives a degree-twelve model over a rational four-variable
field with exact addition, inversion, trace, and norm.

All ten generic `xCD` coefficients, and the universal \(c_4,c_6,\Delta\),
have been evaluated exactly in this model.  At the independent \(s=1\)
control fiber, the genuine \(E[3]\) algebra, distinct flex torsor, and true
three-flex-line algebra with Frobenius orbit degrees `4+8` satisfy all group,
incidence, norm, and Frobenius identities.  Its rational flex makes the class
trivial, so it does not validate a nonzero generic
\(\alpha_{\mathcal R}\).  The generic twisted line algebra, line forms, and
constants also remain open.  See
`tmp/kproj_arithmetic/REPORT.md`, `tmp/xcd_genuine_descent/REPORT.md`, and
`tmp/xcd_descent_math/REPORT.md`.  The separate nonzero-Kummer control above
is the exact conventions check in `tmp/xcd_control_next/REPORT.md`; it is not
a specialization of the generic characteristic-zero torsor.

## Certified covariant exclusion through degree 24

The exact Molien calculation gives

\[
\dim\operatorname{Hom}_G(\operatorname{Sym}^d W,W)
=0,1,0,0,2,1,2,4,5,6,10,12,16,21,26
\]

for \(d=0,\ldots,14\). Characteristic-zero formulas and rational Gröbner
bases exclude every homogeneous self-covariant landing in \(C\) through
degree seven.

Independent good-reduction certificates extend this through degree twelve.
They reduce the same cyclotomic matrices at
\((23,\zeta_{11}-2)\). Since \(23\nmid660\), the Reynolds idempotent is
integral and formation of covariants commutes with base change. In every
degree, the script constructs as many independent Reynolds covariants as the
exact characteristic-zero Molien multiplicity, hence a full reduced basis.

For degrees seven through nine, exact Gröbner bases on every projective
coefficient chart give the unit ideal. In degree ten, the covariant space has
dimension ten and sampled evaluations give 80 independent necessary cubic
landing equations in ten coefficient variables. Macaulay2 computes

```text
generators=80
dimension=0
hilbertFunction[3]=140
hilbertFunction[4]=6
hilbertFunction[5]=0
```

In degree eleven, the complete reduced covariant space has dimension twelve.
Fresh reconstruction gives 108 independent sampled necessary cubic landing
equations, and a second Macaulay2 calculation gives

```text
basisRank=12
generators=108
dimension=0
hilbertFunction[4]=76
hilbertFunction[5]=0
```

In degree twelve, the complete reduced covariant space has dimension sixteen.
Fresh direct-Weil reconstruction gives 143 independent sampled necessary
landing equations in sixteen coefficient variables. The exact finite-field
solver
`msolve` computes a homogeneous Gröbner basis with 3840 leading monomials,
distributed by degree as

```text
degree 3: 143
degree 4: 813
degree 5: 2884
```

Independent monomial-ideal enumeration gives the quotient Hilbert function

```text
1, 16, 136, 673, 1589, 0
```

in degrees zero through five. Thus the leading ideal contains every
degree-five monomial and the projective landing locus is empty.

Because the ideal is homogeneous, dimension zero of its affine cone is
equivalent to emptiness of its projective zero locus. Properness of projective
coefficient space over the DVR transfers this emptiness back to
characteristic zero.

Degree thirteen is excluded by a separate structural calculation at the
split prime \((67,\zeta_{11}-64)\). Write \(M_d\) for the degree-\(d\)
self-covariants and \(f\) for the source Klein cubic. The quotient

\[
M_{13}/fM_{10}
\]

has dimension \(21-10=11\). Forty-eight sampled necessary landing cubics in
this quotient have geometric support equal to the scalar plane
\(\mathbf P(R_{12}/fR_9)\simeq\mathbf P^2\). This support statement is
certified by eight expanded Rabinowitsch unit-ideal calculations;
completeness of the sampled equations is not needed because every genuine
landing class satisfies them.

Thus a landing covariant can be written \(q=rx+fh\). Polarizing \(f\) gives
\(f(x+th)=f+A_ht+B_ht^2+f(h)t^3\), and reduction of \(f(q)=0\) modulo the
geometrically integral source cubic gives \(r^2(r+A_h)=0\). If \(f\mid r\),
then \(q=fh'\) for a degree-ten landing covariant; 80 necessary cubics have
leading-ideal Hilbert function \([1,10,55,140,6,0]\). Otherwise the gauge
\((r,h)\mapsto(r-fu,h+ux)\) puts

\[
q=T(h)=fh-A_hx.
\]

The map \(T\) is injective, and 104 necessary tangent-landing cubics have
leading-ideal Hilbert function \([1,10,55,116,3,0]\). Both projective
branches are therefore empty. Proper specialization of the original
projective landing locus transfers this empty special fiber to
characteristic zero. Full details and the replay checker are in
`tmp/structural_degree13/REPORT.md`.

An independent direct calculation on the full 21-dimensional coefficient
space reaches the same bounded conclusion. At the same split prime 67, 202
necessary landing cubics have a completed exact Gröbner basis with 21,674
leading monomials. The hash-verified leading ideal contains a pure power of
every coefficient variable (with exponents between 3 and 7), hence is
Artinian. The run completed with return code zero after 7,458.060 seconds;
its verifier and strict provenance are in `tmp/degree13_opt/REPORT.md`. The
earlier partial F4 basis by itself remains a noncertificate.

Degree fourteen is excluded by the structural successor at the same split
prime 67. Exact dimensions give

\[
\dim M_{14}=26,\qquad \dim M_{11}=12,\qquad
\dim(M_{14}/fM_{11})=14.
\]

The quotient landing equations have rank 64, equal to the exact ambient
bound \(\dim(R_{42}/fR_{39})=64\). Scalar classes form the two-dimensional
subspace \(R_{13}/fR_{10}\). Twelve independent normal forms cut out this
subspace, and all twelve corresponding Rabinowitsch systems are unit ideals.
Thus every landing lift has the form \(q=rx+fh\).

Reduction modulo the geometrically integral source cubic gives the same two
branches as in degree thirteen. The branch \(f\mid r\) reduces to a
degree-eleven landing covariant; its 111 necessary cubics have 711 leading
monomials and Hilbert function

```text
[1,12,78,253,76,0].
```

In the other branch the gauge normalizes the lift to
\(T(h)=fh-A_hx\). This map is injective, and 131 necessary residual cubics
have 642 leading monomials and Hilbert function

```text
[1,12,78,233,34,0].
```

Both branch ideals are Artinian. A verifier reconstructs the quotient and
both branch row spaces, rematerializes every solver input, checks the twelve
unit outputs, and recomputes both Hilbert functions. Projective properness
transfers the empty special fiber to characteristic zero. Full details are
in `tmp/degree14_structural/REPORT.md`.

Degree fifteen is excluded by the next structural calculation at the same
split prime 67.  Exact dimensions give

\[
\dim M_{15}=32,\qquad \dim M_{12}=16,\qquad
\dim(M_{15}/fM_{12})=16.
\]

The quotient landing-coefficient image has exact rank 75.  Completeness here
does not come from assuming the ambient bound is attained: an explicit
76-element Hironaka basis of \(R_{45}/fR_{42}\) has evaluation rank 76 on the
same source points, and the landing rows on those unisolvent points still
have rank 75.  Scalar quotient classes form the four-dimensional space
\(R_{14}/fR_{11}\).  Twelve independent normal linear forms cut out this
space, and every homogeneous affine chart \(\ell_i=1\) has literal `msolve`
output `[-1]:`.  Thus the geometric support of the complete quotient landing
ideal is exactly the scalar \(\mathbf P^3\).

Writing a lift as \(q=rx+fh\) again yields
\(r^2(r+A_h)=0\bmod f\).  In the \(f\mid r\) branch, 153 necessary
degree-12 landing cubics have 3,528 leading monomials and Hilbert function

```text
[1,16,136,663,1453,0].
```

In the normalized branch \(q=T(h)=fh-A_hx\), 198 necessary residual cubics
have 2,346 leading monomials and Hilbert function

```text
[1,16,136,618,771,0].
```

Both leading ideals contain a pure power of every coefficient variable and
are Artinian.  A single verifier reconstructs the quotient and ambient
unisolvence ranks, all twelve chart inputs and outputs, both branch row
spaces, and both Hilbert functions.  The degree-15 projective landing scheme
therefore has empty special fiber, and properness transfers emptiness to
characteristic zero.  Full details are in
`tmp/degree15_structural/REPORT.md`.

The structural quotient calculations consequently gave the former cutoff:

> No nonzero homogeneous polynomial \(G\)-covariant \(W\to W\) of degree at
> most **15** has image contained in the Klein cubic.

Historically, the direct degree-16 successor was not decided by its complete
quotient calculation, but that calculation had been put in scalar/normal
coordinates.  The 93 complete landing cubics have
bidegree ranks `0,66,77,93`.  Their pure-normal cubic ideal is Artinian of
length `6,169`, so the full degree-16 scheme projects finitely to the scalar
`P3`.  Its linear normal part has constant rank seven with a common
nine-dimensional kernel, and the restriction to that kernel is empty by an
exact weighted cokernel of length `713`.  The weighted-projective
second-order lifting incidence is empty as well: no nonzero normal tangent
direction admits a second-order lift.  The old global rank-15 target is
false: the `93 x 15` matrix has rank exactly five on the kernel `P8`, so its
weighted cokernel necessarily has positive-dimensional support.  This does
not give a landing point because the matrix kernel misses the constrained
`y=(Sym^2(s),s,1)` locus there.  The actual residual problem is this
Veronese-affine incidence on the blowup of `P15` along `P8`.  Although the
injective ten-column block defines an `83 x 5` quotient matrix whose quotient
subspace is controlled by `P6`, the projected `Q(n),C(n)` still vary in all
nine kernel coordinates.  The cleared quotient plus Veronese equations are
93 equations of degrees 12 and 13 in 19 variables, so they do not reduce the
original cubic solve.  The absence of nonzero second-order lifts instead
suggests splitting or saturating away the scalar component first.  The first relative support
equation is now exact in the mod-67 fibre: a fixed 93-row combination is
`59*L^3`, where `L` annihilates `K`.  Hence the residual image is contained in
the explicit hyperplane
`t0+38*t1+20*t2+6*t3+8*t4+2*t5+25*t6=0` of `P6`.  Two fixed row relations
hold there and its generic row rank is 91.  Exact full solves exclude 264
retained points of the hyperplane, but do not cover it.  The first complete
18-variable hyperplane chart hit the 700 MiB watchdog with no output.  The
next relative calculation must use a sparse/block image or saturation on this
hyperplane rather than more isolated directions; no characteristic-zero
support equation follows yet.  See `tmp/degree16_landing_probe/REPORT.md` and
`tmp/degree16_exceptional_search/REPORT.md`.

The forced-plus-plane restriction now supersedes that residual calculation.
For an involution \(t\), a landing covariant must vanish on
\(E_+(t)\): otherwise its projectivization would give a rational map from
\(\mathbf P^2\) to the smooth elliptic section, hence a constant fixed by
\(C_G(t)\), but the centralizer has no point on the Klein cubic.  At the split
good prime 67 the complete restriction ledger is

```text
degree                 16  17  18  19  20  21  22  23  24
Molien dimension       41  49  59  73  86 100 121 140 161
restriction rank       41  47  56  66  75  84  96 106 117
arrangement kernel      0   2   3   7  11  16  25  34  44
```

Thus degree 16 is excluded by injectivity.  In degrees 17--19 the necessary
cubic landing identities span all cubic coefficient monomials on the kernel.
In degree 20, all ten nontrivial charts of the 11-dimensional kernel are unit
ideals; in degree 21, all fifteen nontrivial charts of the 16-dimensional
kernel are unit ideals.  These last-nonzero-coordinate charts form complete
disjoint projective covers.  The projective coefficient incidence over the
DVR is proper, so empty special fibre implies empty characteristic-zero
generic fibre.  Full replay and the exact lifting boundary are in
`tmp/covariant_arrangement_module/REPORT.md`.

The old degree-22 nonverdict is superseded.  At a common `V4` line, the three
order-two maps on its 25-dimensional kernel have common rank 13 and identical
kernels, leaving a strict 12-space.  Even-degree minus-line vanishing cuts
this to dimension four, and the order-three necessary landing cubics span
all `20/20` cubic coefficient monomials.  Thus degree 22 is excluded by
linear algebra.

In degree 23, the 34-dimensional arrangement kernel has common-line strict
dimension 20.  A combined rank-392 family of necessary common-line and
ambient landing cubics has exact unit ideal on all 20 disjoint projective
charts.  In degree 24, the coefficient-exact first jet has rank `43/44`; the
unique exceptional line has exact transverse order two.  The order-one
branch is cut by the common line from 44 to 29 dimensions and by the even
minus-line condition to 20 dimensions.  A rank-484 necessary cubic family
has unit ideal on all 20 projective charts.  The exceptional line itself lies
in this residual 20-space, so the chart calculation excludes it independently
of parity.  Independent scripts rebuilt the degree-23 and degree-24 modules,
row spaces, chart ideals, and solver-output connections from scratch.

Consequently:

> No nonzero homogeneous polynomial \(G\)-covariant \(W\to W\) of degree at
> most **24** has image contained in the Klein cubic.

The reduced scalar arrangement and its 55 triple lines plus 121 multiple
points are in `tmp/plane_arrangement_hilbert/REPORT.md`; this reduced ideal is
not the odd symbolic equivariant module.  The first ordinary/jet and
higher-center block computations are in `tmp/d12_block_attack/REPORT.md`.
Over split `F_67`, they include actual quotient bases for a 16-dimensional
higher-compatibility piece in every audited degree 18--29, together with 17
invertible multiplication maps by `f3`, `f5`, and `f11`.  Its ordinary
all-degree successor identifies the defect with a length-1573 skyscraper on
the 121 multiple points and proves `dim D_d[W]=16` for every `d>=54`, in
characteristic zero and the split good fibre.  The finite window itself does
not fill degrees 30--53.  See
`tmp/higher_compatibility_regularity/REPORT.md`,
`tmp/ordinary_defect_support/REPORT.md`, and their independent audits.

The degree-25 structural probe extends this finite ledger without extending
the cutoff.  Its exact first jet on `K25` has rank `56/59`; the
three-dimensional kernel has exact even plane order two and is excluded by
the fixed-locus parity theorem.  The common-line order-two map leaves a
43-space.  Exact unisolvent order-three and order-four maps give the
filtration `43 -> 6 -> 0`; the order-at-least-four six-space is excluded
because its leading landing cubics span all `56/56` cubic forms.  The
remaining leading common-line order-exactly-three equations factor through a 37-dimensional
quotient and were not sent to a nonlinear solver.  Thus degree 25 remains
open.  See `tmp/degree25_structural_probe/REPORT.md` and
`tmp/degree25_structural_probe_independent_audit/REPORT.md`.

The independently audited compact `m=1` normalization complex reconstructs
the same degree-25 object from the plane/line/point incidence.  Its exact
split-`F_67` ledger is

```text
plane normalization 673 --line rank 309--> 364
line kernel          364 --point rank 305--> 59,
```

and the last 59-space has the same row space as the direct global `K1/K3`.
The two normal layers give `K1=59`, `K2=3`, `K3=0`.  Exact factored
order-four plane landing equations have been constructed, but the filtration
comparison confirms that `D10`/`D12` point initials add no equation on the
37-dimensional leading common-line exact-order-three quotient.  This
calibration validates the
compact linear construction only; it neither excludes degree 25 nor proves
`(ID_1)`.  See `tmp/m1_compact_degree25/REPORT.md` and the two independent
audits under `tmp/m1_compact_degree25*_independent_audit/`.

The global status of that compact construction is now precise.  For every
fixed `m`, the iterated plane-normalization, triple-line-equalizer, and
residual-point-kernel construction is the sheaf associated to
`I^(m)/I^(m+2)` in every twist.  The non-surjectivity of the line and point
maps is harmless because only kernels are used.  In contrast, the naive
surjective four-term Cech complex is false: the local `D12` right cokernel
has scalar Hilbert function `(4,5,1)`.  At the graded-module level the only
possible discrepancy is

```text
T_m = H^0_(irrelevant)(E_m/(I^(m)/I^(m+2))).
```

It is finite length.  Derksen--Sidman regularity gives literal graded
exactness for `d>=55m+109`; computing `T_m`, or just its `W`-multiplicity
space, is the exact finite low-degree saturation problem.  Over split
`F_67`, exact compact/literal comparison, injectivity on the plane-normal
source below degree 14, and the regularity bound first give

```text
[(T_1)_d tensor W]^G = 0 for every d <= 34 and every d >= 164.
```

Multiplication by the literal invariant `f3` was formed on the ambient source
before quotienting, and every induced map `D_d->D_(d+3)` for `14<=d<=31` is
injective.  The exact truncated quotient is

```text
dim (D_1/f3 D_1)_(<=34) = 1459.
```

Degree 35 then has compact saturation dimension 362 and literal global image
dimension 361, so `dim [(T_1)_35 tensor W]^G=1`.  Because this is finite
irrelevant torsion, a power of `f3` kills a nonzero class and produces a
nonzero element of `(0 :_D1 f3)` in some degree.  Thus the proposed
split-`F_67` all-degree colon-zero statement and total target 1,572 are
refuted.  The first killed degree is not identified.  No characteristic-zero
or higher-`m` statement follows.
See `tmp/symbolic_global_exactness/REPORT.md`,
`tmp/graded_symbolic_architecture/REPORT.md`, and
`tmp/m1_compact_graded_pilot/REPORT.md`, together with
`tmp/m1_t1_saturation/REPORT.md`,
`tmp/m1_t1_propagation_design/REPORT.md`, and
`tmp/m1_t1_f3_colon_attack/REPORT.md`, and
`tmp/m1_t1_f3_colon_degree35_audit/REPORT.md`, together with
`tmp/m1_t1_char0_d35_gate/REPORT.md`.

The formerly unsolved order-four plane landing equations in degree 25 have
also been assembled completely over split `F_67`.  On the strict space
`V=Q_37 direct_sum K_6`, their exact 842-dimensional row space has filtered
ranks

```text
K^3                                  56
K^3 + Q K^2                        833
K^3 + Q K^2 + Q^2 K                842
all cubic monomials                 842.
```

Three independent implementations audit the high blocks, the rank-nine
increment, and the final full row space.  After normalizing the first 833
monic pivots, the remaining relations have the form
`M(q)k+b(q)=0`, where `M` is a `9 x 6` quadratic matrix and `b` is cubic.
There is no linear solution graph `k=Tq`.  Exact determinantal certificates
give

```text
I_6(M):      height 4, projective dimension 32, degree 2016;
I_7([M|b]):  height 3, projective dimension 33, degree 835.
```

The rank-six compatibility locus is therefore nonempty and dense in the
second scheme: the nine tail equations generically determine `k` and cannot
exclude landing.  The other 833 relations are indispensable.  Eight finite
slice diagnostics and one exhaustive projective `P3(F_67)` enumeration find
tail-compatible points, but all tested points fail almost all complete
equations; these are diagnostics only.  A separate complete-system
certificate restricts all 842 cubics to a deterministic mixed-coordinate
`P^18`.
The degree-four Macaulay map has shape `15998 x 7315`, and a square minor has
determinant `1 mod 67`.  Hence the restricted projective locus is empty over
the algebraic closure.  By the projective dimension theorem, any nonempty
full locus `Z subset P^42` satisfies the now-weaker bound `dim Z<=23`; this
conclusion uses no genericity of the chosen linear space.  A 20-variable
dense successor would exceed the memory gate, so this remains independent
mixed-coordinate evidence rather than the start of a larger slice sweep.
Raw 43- and 64-equation homogeneous
solver probes reach the 700 MiB gate at degree five and have no verdict.  The
exact `Q_0=1` border presentation has 821 rows on the seven-element basis
`{1,K_i}`.  A search through 399,756 structured maximal-minor profiles finds
no constant minor, nonexhaustively.  The smallest generically overdetermined
`43 x 7` subsystem yields seven rank-drop charts with 43 equations in 42
variables; each expanded Macaulay interface already has an optimistic
710.386 MiB sparse-storage floor, so no solve was launched.

A sealed circuit packet gives three exact lowest-profile separations on this
chart.  First, `q0^4 e0` is not in the span of the 756 homogenized reduced
`QK2` rows and linear multiples of the nine residual rows.  Second, no
constant combination of all 821 lowest-profile rows equals `q0^5 e0`.
Third, on one nonempty rank-six residual-minor chart, the 815 aligned wedge
circuits are linearly independent and no constant combination equals
`q0^17`.  The accepted coordinate-Schur filtration then refutes the full
34,355-unknown raw-821 scalar-`Q` degree-five identity by exact restriction
to `q0,...,q16`: the terminal `10659 x 1913` map has source rank 1,913 and
augmented rank 1,914.  This is still not a statement about the `T_i`-stable
rank-28 kernel or its support, and higher cleared degrees remain open; hence
neither emptiness nor nonemptiness follows.

The global relative formulation is nevertheless exact.  The 56 monic `K^3`
relations define six multiplication operators on the rank-28 `S=F_67[Q]`
module with basis `{1,K_i,K_iK_j}`.  The smallest submodule containing the
remaining 786 relations, all multiplication commutators, and their
operator-stable closure has quotient canonically isomorphic to the original
842-cubic algebra.  Exact normalization checks every one of the 14,190 cubic
coefficients.  On one sparse `P^10 subset P(Q)` the closure fills all 4,103
degree-four module columns, while an independent direct calculation fills
all 4,845 quartics.  More importantly, the monic rules make the original
landing algebra finite over `S`, and at `Q=0` they specialize to all cubic
`K` monomials.  Thus the projective landing scheme has no point in the
projection centre and maps finitely to its support in `P(Q)=P^36`.

The coordinate `P^16` supplies an exact full-rank anchor.  Recursive Schur
extensions through `P^17` and `P^18` give nested degree-four
blocks of sizes

```text
13872 + 2544 + 2869 = 19285
```

with pivot products `5,14,11 mod 67`, hence total product 33.  A fresh full
verifier rebuilds the final 2,869-square coefficientwise and reranks it by an
independent exact path at 675.41 MiB.  Therefore the support misses the
coordinate `P^18`, first giving

```text
dim Z <= 17
```

for any nonempty split-fibre landing locus.  The next `P^19` has only 20,751
candidate rows for 22,505 degree-four columns, so degree-four closure is
impossible there.  Degree five nevertheless closes exactly.  With
`x=q19`, write

```text
F_4(20) = F_4(19) direct_sum x F_3(20),
F_5(20) = F_5(19) direct_sum x F_4(19) direct_sum x^2 F_3(20).
```

The accepted 19,285 inherited rows form a graph over `F_4(19)`.  Reducing
the 1,466 remaining degree-four relations and all 20 `Q`-multiplication
images gives a `29320 x 3220` terminal matrix of exact rank 3,220.  Its
selected square has pivot product `58 mod 67`.  Thus actual degree-five
relations supply all of `x^2 F_3(20)`, after which the inherited rows supply
`x F_4(19)` and `F_5(19)`.  This curvature-safe argument does not assert an
exact inherited rank of 124,754 or the identity `M_5=xM_4`.  The support
therefore misses the coordinate `P^19`, and the projective dimension theorem
first improves the bound to

```text
dim Z <= 16.
```

This `P^19` bound is now a superseded historical step.  Put `y=q20`.  On 21
`Q` variables the degree-four relation space has rank 21,410, leaving a
4,693-dimensional quotient.  A curvature-safe family of genuine degree-five
relations supplies an exact `4693 x 4693` residual square of full rank, with
pivot product `32 mod 67`.  The 19-stage full segmented replay has maximum
RSS `580.828125 MiB`, below the 700 MiB cap.  Hence after base change to the
algebraic closure of `F_67`, the projected support misses the coordinate
`P^20`.  The projective dimension theorem gives the current split-fibre bound

```text
dim Z <= 15.
```

This arithmetic packet makes no characteristic-zero claim.  The modular
`Q/K` frame is not asserted to lift.  Instead, the canonical
linear and order-four equations define a projective family in the full
189-dimensional Reynolds lattice over the DVR
`O_{Q(zeta_11),(67,zeta_11-64)}`.  The special fibre is the certified scheme,
and projective specialization gives `dim generic <= dim special`.  Hence the
actual characteristic-zero degree-25 landing locus satisfies

```text
dim L_25 <= 15
```

over `Q(zeta_11)` and after base change to `C`.  This is not emptiness and
does not exclude degree 25.  The verifier audits the bound inputs and
provenance; the properness and upper-semicontinuity implication is the
geometric argument recorded in `tmp/char0_lift_p20_d5/REPORT.md`.

The completed coordinate `P^21` degree-five test is a strict nonverdict.  Its
exact `21407 x 7911` matrix over `F_67` has coefficient SHA256
`aaa835c09cf5dafea89678d9370eb359cc511c2721e0315904d1eefc60c3c4b7`.
The first 3,933 columns are independent.  An explicit normalized vector in
`F_67^3934`, with last coordinate one, verifies a dependency among columns
`0,...,3933` coefficientwise in all 21,407 rows.  Therefore the exact
certificate gives only

```text
3933 <= total rank <= 7910 < 7911.
```

The exact total rank was not computed, and 3,933 must not be reported as that
rank.  The fixed row family is non-full, so it proves no coordinate-`P^21`
emptiness and does not improve `dim Z<=15`.  The pre-registered selected
full-rank replay and the canonical DVR/upper-semicontinuity promotion to
`dim L_25<=14` were conditional on full rank and were correctly skipped.  No
`P^22` or other successor slice was run.  The packet is
`tmp/m1_relative_border_p21_d5_design/`; its accepted overall peak RSS is
`555.171875 MiB` under the 700 MiB cap.

A Macaulay2 direct-presentation control on the sparse `P^10` gives
`H(3)=127`, `H(4)=0` at peak RSS 696,680,448 bytes.  Its operator-bearing
precursor crossed the cap before returning the commutator module, so no
global trim, saturation, Fitting ideal, or support test was run.  Globally
the first dense closure block would occupy at least 5.49 GB.  The viable
successor is therefore symmetry-compressed sparse polynomial-module
saturation/Fitting support or a circuit certificate, not dense closure,
expanded maximal minors, or another slice sweep.  No characteristic-zero
emptiness, degree-25 exclusion, or `(ID_1)` follows yet.  See
`tmp/m1_full_plane_block_rank/REPORT.md`,
`tmp/m1_determinantal_geometry/REPORT.md`, and
`tmp/m1_landing_commalg_pilot/REPORT.md`, together with
`tmp/m1_landing_chart_fitting/REPORT.md`,
`tmp/m1_rank6_circuit_support/REPORT.md`,
`tmp/m1_rank6_schur_compression/REPORT.md`,
`tmp/m1_rank6_schur_compression/PROOF_AUDIT.md`,
`tmp/recent_equivariant_tools_2026/REPORT.md`,
`tmp/m1_border_module_m2/REPORT.md`,
`tmp/m1_cubic_slice_macaulay/REPORT.md`,
`tmp/m1_relative_border_rank28/REPORT.md`, and
`tmp/m1_qslice_border_dimension/REPORT.md`, together with
`tmp/m1_relative_border_maxslice/REPORT.md`,
`tmp/m1_relative_border_p19_d5/REPORT.md`,
`tmp/m1_relative_border_p20_d5/REPORT.md`, and its `PROOF_AUDIT.md`, together
with `tmp/char0_lift_p19_d5/REPORT.md`,
`tmp/char0_lift_p20_d5/REPORT.md`, and
`tmp/m1_relative_border_p21_d5_design/REPORT.md` with its `PROOF_AUDIT.md`.

The multiple-point local symbolic edge is known and independently audited in
every order.  In split
coordinates on the quotient tangent representation, the five `D10`
reflection lines are the complete intersection of bidegrees `(2,1)` and
`(1,2)` on `P1 x P1`; the six `D12` reflection lines are the complete
intersection `(2,1),(0,3)`, together with the central line.  Bezout induction
gives

```text
D10: (J_m)_(3m) = Sym^m<a,c5>,
D12: (J_m)_(3m) = direct_sum_j k*a^(m-2j)*b^j,
      0 <= j <= floor(m/2),  b=a*c6.
```

For odd `m` these are reflection-sign representations, absent from the
restriction of `W` to both point stabilizers.  Thus any equivariant class of
common plane order `m` has order at least `3m+1` at all 121 multiple points.
This remains a one-order local gate: the first post-minimal layer already
contains `W`, so it does not prove the global implication
`p in I^(m+2)`.  Moreover, the first symbolic normalization calculation
shows a nonzero cokernel supported along each entire triple line, not merely
at the multiple points; its exact `A4` character is computed for `m=1,3`.
The sealed compatibility packet first proved the injection into plane
normalization and the local generic-line/equalizer/residual-point sequences.
The subsequent global theorem proves that their iterated kernels give the
correct associated sheaf in every twist; it does not make the false
four-term Cech complex exact or suppress the finite irrelevant-torsion
correction in low graded degrees.  Direct plane jets do give
`[(I^(3)/I^(5))_d tensor W]^G=0` for `25<=d<=31`, including characteristic
zero by the audited full-rank good-reduction argument.

One assembled point boundary is also closed.  For `m=3`, transverse degree
six and binary line degree one, the required `D_L^4` factor gives total
degree 19.  At a representative `D12` point, the three incident line germs
must give equal jets in their single common central-plane summand.  Their two
difference blocks have rank `8/8`, so the split-`F_67` length-48 generic-line
chart becomes the unit scheme.  This is an associated-graded finite-field
stratum only; it does not prove `(ID_3)`, a characteristic-zero lift, or a
global complex theorem.  See `tmp/local_symbolic_rees/REPORT.md`,
`tmp/symbolic_compatibility_complex/REPORT.md`, and
`tmp/m3_line_point_boundary/REPORT.md`, together with their independent
audits.

Fast replay of the current symbolic boundary is:

```text
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
```

This is a bounded exclusion only. Clearing denominators of a rational
equivariant map gives a polynomial covariant, but there is no degree bound;
therefore this calculation supplies no negative answer. The next unrestricted
homogeneous degree is twenty-five. The earlier interrupted partial-basis package
is retained only as a diagnostic: its exact partial leading ideal leaves 26
standard monomials in degrees six and seven and, by itself, proves no
emptiness statement (`tmp/degree13_step2/REPORT.md`).

## Six-dimensional projective-source route

Let

\[
1\longrightarrow\mu _2\longrightarrow
\widetilde G=\operatorname{SL}_2(\mathbf F_{11})
\longrightarrow G\longrightarrow1
\]

and let \(V_6\) be the six-dimensional Schur representation. Its central
involution acts as \(-1\), while it acts trivially on the Klein module \(W\).
Thus \(\mathbf P(V_6)\) carries an honest projective \(G\)-action, and every
homogeneous \(\widetilde G\)-covariant \(V_6\to W\) has even degree.

### Projective-source lemma

If there is any rational \(G\)-equivariant map

\[
\mathbf P(V_6)\dashrightarrow C,
\]

then it is dominant and \(C\) is \(G\)-unirational.

Indeed, the map cannot be constant because \(C^G=\varnothing\). The kernel
on the closure of its image is normal and hence, by simplicity, trivial. A
proper image would be a faithful unirational curve or surface; after taking a
trivial product in the curve case, this contradicts the known exclusion of
faithful \(G\)-actions on rational surfaces. Hence the image is all of the
threefold.

For the all-torsors assertion, twist the source by an arbitrary \(G\)-torsor
\(T/K\). The result is the Brauer--Severi variety of a degree-six central
simple algebra \(A_T\). Its class comes from the displayed central extension,
so \(\exp(A_T)\mid2\); also \(\operatorname{ind}(A_T)\mid6\). Index and
exponent have the same prime divisors, hence the index is one or two and the
source splits over a separable extension \(L/K\) of degree at most two. A
point in the open domain of the twisted map gives \({}^T C(L)\ne\varnothing\).
The honest action on \(W\) puts \({}^T C\) in a split \(\mathbf P^4_K\), so
the line joining a quadratic point to its conjugate supplies the residual
\(K\)-point of the cubic. Thus every twist has a \(K\)-point, proving the
lemma by the twist criterion.

The exact characteristic-zero multiplicities of \(W\) in
\(\operatorname{Sym}^d(V_6^*)\) for even \(d=0,2,\ldots,20\) are

\[
0,0,1,2,11,21,48,85,158,249,408.
\]

Good-reduction calculations at split primes give the following complete
bounded exclusions:

- the unique degree-four covariant does not land;
- the full two-dimensional degree-six constant-coefficient locus is empty;
- the full eleven-dimensional degree-eight locus is empty; and
- the full twenty-one-dimensional degree-ten locus is empty. In degree ten,
  470 independent necessary cubics over \(\mathbf F_{23}\) have a leading
  ideal with 5,516 generators and quotient Hilbert function
  \([1,21,231,1301,889,0]\). It contains every degree-five monomial, so
  projective properness transfers geometric emptiness to characteristic zero.

There is one stronger rational-coefficient result in the complete
degree-six pencil. The primitive cubic \(F(q_0+tq_1)\) is absolutely
irreducible after good reduction: direct factorization over
\(\mathbf F_{23^3}\) leaves one factor of \(t\)-degree three, and an
independent discriminant specialization is nonsquare. Hence the pencil has
no root over \(\mathbf C(V_6)\). This statement does not exclude rational
combinations in the degree-eight or degree-ten spaces.

There is now an exact all-degree normal form for the rational-coefficient
problem. Five explicit degree-eight Reynolds covariants \(q_0,\ldots,q_4\),
divided by a degree-eight invariant \(I_8\), form a basis of the descended
Klein five-space over

\[
K_{\rm Schur}:=\mathbf C(\mathbf P(V_6))^G.
\]

This Schur-source field is distinct from the generic projective-torsor field
\(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\).

Thus every rational equivariant projective-source map has the form

\[
\left[\sum_{i=0}^4 a_iq_i/I_8\right],\qquad a_i\in K_{\rm Schur},
\]

and landing is exactly the existence of a nonzero \(K_{\rm Schur}\)-point on
the resulting generic twisted Klein cubic; write this cubic as \(X_T\).
Exact good-reduction factorization
over both \(\mathbf F_{23}(s)\) and \(\mathbf F_{23^3}(s)\) proves that none
of the ten coordinate lines
\(K_{\rm Schur}q_i+K_{\rm Schur}q_j\) contains such a point. Any solution in
this frame must use at least three coordinates. This support exclusion is not
an exclusion of ternary or larger rational combinations.

All ten coordinate planes in this same Schur frame are now known, without a
coefficient-degree bound, to cut smooth geometrically integral genus-one
curves.  Exact good reduction reconstructs the five Reynolds columns and the
target cubic and proves the derivative ideal is the unit ideal on all three
charts for every triple.  Thus none of these sections hides a reducible or
singular norm curve, although any one may still have a
\(K_{\rm Schur}\)-point.

There are also global degree-free exclusions on the Schur generic twist.  It
has no \(K_{\rm Schur}\)-rational line: such a line would give a rational
equivariant map from \(\mathbf P(V_6)\) to the Fano surface of lines, whose
nonconstant image would be a faithful unirational variety of dimension at
most two, contrary to the rational-surface classification.  A geometrically
integral \(K_{\rm Schur}\)-rational plane conic would leave a residual
\(K_{\rm Schur}\)-line in its plane section, so no such conic exists either.
Geometric Picard rank one excludes any nonconstant regular fibration from the
twist to a lower-dimensional projective base.  Finally a projective-linear
separated cubic norm equation

\[
N_{L/K_{\rm Schur}}(z)=B_3(u,v)
\]

would become \(z_0z_1z_2=B_3(u,v)\) after splitting \(L\), with three
universal singular coordinate points; it cannot define the smooth twist.

There is nevertheless a precise birational fibration successor.  Put
\(P_{ij}(s,t)=\Phi(se_i+te_j)\) and let \(D_{ij}\) be its irreducible
degree-three zero scheme on the ambient coordinate line.  Projection from
that line is resolved by

\[
\operatorname{Bl}_{D_{ij}}(X_T)
  \longrightarrow\mathbf P^2_{K_{\rm Schur}}.
\]

For base vector \(r_b=\sum_{k\ne i,j}b_ke_k\), line vector
\(v=se_i+te_j\), and the normalized symmetric polarization \(B_\Phi\), the
generic fibre has the exact equation

\[
P_{ij}(s,t)+3uB_\Phi(v,v,r_b)+3u^2B_\Phi(v,r_b,r_b)
  +u^3\Phi(r_b)=0.
\]

Write \(Y_{ij}=\operatorname{Bl}_{D_{ij}}(X_T)\), let \(H\) be the pullback
of the hyperplane class, \(E\) the connected exceptional divisor, and
\(F_{ij}\) the smooth generic fibre.  The Picard calculation over the
nonsplit centre is exact:

\[
\operatorname{Pic}(Y_{ij})=\mathbf ZH\oplus\mathbf ZE,
\qquad H\cdot F_{ij}=E\cdot F_{ij}=3.
\]

Thus every divisor has fibre degree in \(3\mathbf Z\), while the closure of a
rational section would be a horizontal Cartier divisor of degree one.  No
one of these ten fibrations has a rational section.  Moreover \(E\cap F_{ij}\)
is a closed point of degree three and every closed-point degree is divisible
by three, so

\[
\operatorname{ind}(F_{ij})=\operatorname{per}(F_{ij})=3.
\]

Equivalently, every \(\xi_{ij}\) is nontrivial of exact order three.  This
closes the coordinate-line section attacks; it does not exclude a
\(K_{\rm Schur}\)-point of \(X_T\) on a special fibre.  Closed finite-field
and one-parameter geometric specializations of the full five-variable cubic
cannot give a negative certificate, because Chevalley--Warning and Tsen make
them soluble.  See `tmp/schur_structural_routes/REPORT.md` and its
`PROOF_AUDIT.md`, and
`tmp/schur_fibration_picard_obstruction/REPORT.md`, its
`PROOF_AUDIT.md`, and its `INDEPENDENT_AUDIT.md`.

There is nevertheless a substantial bounded ternary exclusion.  On each of
the ten coordinate planes, the full invariant-coefficient ansätze in degrees
0, 4, 6, 8, and 10 are projectively empty.  In degree 12 put

\[
S_{12}=f_4R_8+\langle f_6^2\rangle,\qquad
\dim S_{12}=5,\quad \dim(R_{12}/S_{12})=9.
\]

All ten \(S_{12}\) systems and all 90 enlargements
\(S_{12}+\langle p_j\rangle\) have exact Artinian leading ideals at the good
prime 23 and are therefore empty in characteristic zero.  The single tested
two-direction slice \(L(012,S_{12}+\langle p_0,p_1\rangle)\) is also empty.
Its 47.288-second gate projects all 360 such slices to 4.73 hours, beyond the
authorized 20-minute budget, so the other 359 were not run.  Those other
two-direction slices, all combinations of three or more quotient directions, the full
\(R_{12}\), higher coefficient degrees, and unrestricted ternary
\(K_{\rm Schur}\)-points remain open.  See
`tmp/schur_ternary_planes/REPORT.md` and
`tmp/schur_ternary_planes/one_primitive/REPORT.md`.

The full degree-twelve constant-coefficient space has dimension 48. Its
decomposable part

\[
D_{12}^{V_6}=R_4M_8+R_6M_6+R_8M_4=(R_+M)_{12}
\]

has exact dimension 16, leaving a 32-dimensional primitive quotient. Exact
leading ideals exclude the complete projective landing locus in \(D_{12}^{V_6}\)
and in each of the 32 spaces \(D_{12}^{V_6}+\langle p_j\rangle\) for one explicit
primitive quotient basis. A separate complete 48-vector Reynolds basis first
gave 1,093 independent necessary cubics on the saved prime-field evaluations.
Restricting those equations to every coordinate support of size at most five
gives full cubic-monomial rank: all 1,925,356 such supports are empty. This
last statement is basis-dependent.

Quadratic-extension evaluation now removes the equation-span ambiguity. The
old base-field points together with 48 deterministic \(\mathbf F_{23^2}\)
points are unisolvent on the full 1,157-dimensional degree-36 invariant
space. The corresponding landing rows have exact rank 1,124, so a retained
1,124-row base-field matrix spans **every** degree-twelve landing coefficient
polynomial in the characteristic-23 fiber. Its 48-variable `msolve` input is
hash-verified. This proves only the complete special-fiber equation rank; it
does not prove projective emptiness, nonemptiness, or equality with the
characteristic-zero equation rank. The earlier 1,093-row Gröbner run timed
out in degree four after 600.67 seconds with an empty leading-output file and
therefore supplies no geometric verdict. The complete 1,124-row run likewise
timed out after 600.591 seconds during its second degree-four matrix
\(39399\mathbin{\times}245608\), with return code \(-15\) and a zero-byte
leading-output file. It also supplies no Gröbner, Hilbert-function, or
geometric verdict.

The complete solve has now been carried to a terminally justified stopping
rule.  All four upstream rank/unisolvence verifiers pass, the two copies of
the 287,747,633-byte input are byte-identical, and its metadata pointer to the
landing certificate has been repaired and hash-checked.  The recorded F4
rounds contain only aggregate timings: no reduced rows, leading monomials,
basis, PBM data, or checkpoint were saved, so they cannot be resumed or used
geometrically.  Exact restriction to every coordinate hyperplane
\(a_i=0\) has rank 1,124 on the 18,424 surviving cubic monomials.  Thus none
of the 48 standard dehomogenizations gains a quadratic or lower equation by
constant row reduction.  Independent 120-second probes on the charts
\(a_0=1\) and \(a_{47}=1\) both stop with empty outputs on the same first
degree-four matrix \(36595\mathbin{\times}244805\) as the homogeneous run.

There is also a rigorous size bound.  If \(I\) is generated by these 1,124
cubics in 48 variables, then

\[
\dim(S/I)_d\geq \dim S_d-1124\dim S_{d-3}.
\]

The resulting lower bounds in degrees zero through six are
\(1,48,1176,18476,195948,1277136,927080\); degree seven is only the first
degree where Hilbert-function vanishing is numerically possible.  This count
does not rule out a lower-degree pure-power leading-ideal certificate, but no
such leading data were emitted.  Consequently no further
characteristic-23 sampling, identical 600-second retry, or sweep of the
remaining standard charts is justified.  Resume only after a certified
coordinate/elimination reduction, a solver that preserves checkable
intermediate data, or a materially larger resource-and-certificate plan.
The exact terminal state and verifier are in
`tmp/step4_degree12_solver_terminal/REPORT.md`.

Degree twelve, all higher degrees, and
general rational maps remain open; the projective-source route is not a
resolution. See
`tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`,
`tmp/projective_source_degree12_structural/REPORT.md`, and
`tmp/projective_source_degree12_extension/REPORT.md`.

The first structural audit of degree twelve is also exact. Products of the
degree-four, -six, and -eight covariants with source invariants of complementary
degrees give 17 displayed old generators. Their forced overlap
\(R_4^2M_4\) bounds the span by 16, and a nonzero rank-16 minor modulo 23
proves that this bound is attained in characteristic zero. Consequently the
48-dimensional degree-twelve space has a 16-dimensional lower-invariant part
and a 32-dimensional primitive quotient. This filtration by itself is not a
landing theorem: old directions can cancel the landing equations in a mixed
covariant, so one cannot delete those 16 variables. The subsequent leading-
ideal calculations above separately exclude the old sector, each selected
old-plus-one-primitive slice, and all 496 selected
old-plus-two-primitive slices.  Hence a landing covariant needs at least
three primitive coordinates in this fixed quotient basis.  This still does
not justify a general quotient, arbitrary-plane exclusion, or mixed-variable
elimination.  It does, however, give the exact next chart cover: any landing
point has a nonzero primitive quotient coordinate, so the 32 opens
\(p_j\ne0\) cover the full locus.  The complete 1,124 equations have now been
transformed to the \(D_{12}^{V_6},p_0,\ldots,p_{31}\) basis and the authorized gate
\(p_0=1\) has been run.  It timed out after 600.877 seconds with zero leading
output at a `44328 x 245460` matrix, a worse trajectory than the original
standard chart.  The other 31 charts were therefore not launched.  The
decomposable quotient has Hilbert function `[1,16,136,286,0]` and length 439,
but using it for relative elimination requires monic reductions and explicit
control of determinant, Fitting, and rank-drop exceptional strata.  It is not
a flatness theorem and cannot simply be imposed on mixed charts.  See
`tmp/projective_source_degree12_primitive_chart/REPORT.md`.

## Covariant-dimension criterion and the third symmetric power

Kraft--Loetscher--Schwarz prove for this centerless group that
\(\operatorname{covdim}(G)=\operatorname{ed}(G)+1\), and their placement and
homogeneity results allow a minimal covariant to be taken as a homogeneous
self-covariant of \(W\). Since every nonzero such covariant is faithful, the
essential-dimension dichotomy has the exact reformulation

\[
\begin{aligned}
\operatorname{ed}(G)=3
&\Longleftrightarrow
\text{some nonzero homogeneous }f:W\to W
\text{ has }\det Df\equiv0,\\
\operatorname{ed}(G)=4
&\Longleftrightarrow
\det Df\not\equiv0
\text{ for every nonzero polynomial self-covariant }f.
\end{aligned}
\]

This criterion is broader than landing in the Klein cone. Exact complete
good-reduction calculations prove that every nonzero homogeneous
self-covariant through degree eleven has nonzero Jacobian and is dominant.
In degree ten, 338 independent necessary determinant quintics return the unit
ideal on all ten triangular charts of \(\mathbf P^9\). In degree eleven, the
complete covariant space has dimension 12. The same 640 source points are
unisolvent on the full 509-dimensional degree-50 invariant space, so the 496
retained Jacobian quintics span the complete determinant-coefficient space.
Exact `msolve` calculations return the unit ideal on all twelve triangular
charts of \(\mathbf P^{11}\); the two hardest charts take 85.89 and 18.57
seconds. Proper specialization transfers both exclusions to characteristic
zero.

Degree twelve has also been reconstructed completely.  The covariant space
has dimension 16, the determinant has source degree 55, and 728 deterministic
source points produce the full rank-721 universal coefficient span inside
the 721-dimensional invariant space \(R_{55}\).  In the exact splitting

\[
M_{12}^{W}=D_{12}^{W}\oplus P_{12}^{W},\qquad \dim D_{12}^{W}=12,
\quad \dim P_{12}^{W}=4,
\]

the pure primitive restriction has rank 56, all quintics in four variables,
and hence empty projective locus.  All twelve triangular charts of
\(\mathbf P(D_{12}^{W})\) are unit ideals.  The original genuinely mixed
chart \(p_0=1\) timed out at a degree-seven matrix
`104836 x 166810`.  Relative specialization has since completed the fiber
\([p_0:p_1:p_2:p_3]=[1:1:1:1]\) with a unit ideal.  Because the
decomposable projection center is empty, proper projection proves that the
mixed incidence is empty over a nonempty open subset of primitive
\(\mathbf P^3\), also in characteristic zero.  Degree twelve remains open
only over a proper closed exceptional subset of the mixed parameter space,
not on either pure stratum and not generically on the mixed locus.  See
`tmp/degree12_jacobian/REPORT.md`,
`tmp/degree12_jacobian_structural/REPORT.md`, and
`tmp/relative_kls_chart/REPORT.md`.

Neither the KLS theorem nor finite generation of the covariant module gives
an all-degree cutoff; an explicit \(S_5\)-module counterexample rules out that
shortcut. All higher degrees also remain open for this Jacobian test.

Voisin's current construction is equivariant for every projective
automorphism of a smooth cubic threefold and gives a dominant map from a
product of Grassmannians to \(C^{[3]}\). The Grassmannian source is itself
dominated equivariantly by a linear representation, so unconditionally

\[
C^{[3]}\text{ is }G\text{-very-versal}.
\]

This nine-dimensional variety does not improve the essential-dimension
bound and does not select one of the three points. Pulling back the universal
marked family replaces the rational Grassmannian source by a variety
rationally fibered over \(C\) itself; after twisting it is a projective bundle
over \({}^T C\). A rational point on that marked cover is therefore already
the missing rational point, so the apparent selection step is circular.

## All-degree self-covariant normal form

Let \(S=\mathbf C[W]\), \(R=S^G\), and
\(M=(S\otimes W)^G\). Adler's invariant-ring presentation makes

\[
A=\mathbf C[f_3,f_5,f_6,f_8,f_{11}]
\]

a polynomial parameter subring over which \(R\) is free of rank 12. The exact
Molien series shows that \(M\) is free of rank 60 over \(A\), hence has generic
rank five over \(R\), but \(M\) is not globally free over \(R\).

This finite module structure does not impose a degree bound on a landing
covariant. Put \(B=[x\ C\ D\ E\ K]\) and \(\Delta=\det B\). Since the exact
witness above proves \(\Delta\ne0\), Cramer's rule and equivariance give

\[
M[1/\Delta]=R[1/\Delta]x\oplus R[1/\Delta]C\oplus
R[1/\Delta]D\oplus R[1/\Delta]E\oplus R[1/\Delta]K.
\]

Consequently, over \(K_0=\operatorname{Frac}(R)\), the all-degree landing
problem is exactly the same single cubic

\[
\Phi(a)=F(a_0x+a_1C+a_2D+a_3E+a_4K)=0
\]

in five variables. A global module presentation supplies coordinates for
this equation but neither forces nor obstructs a nonzero zero. Equivalently,
restriction of scalars along the rank-12 extension
\(\operatorname{Frac}(R)/\operatorname{Frac}(A)\) gives 12 cubics in 60
variables, still far outside any applicable automatic point theorem.

As a further finite check, all 15 generalized cross products of four
gradients among the six explicit invariants of degrees 3 through 9 are
self-covariants of degrees 17 through 26. Exact evaluation at
\((-2,-2,-2,-2,-1)\) shows that none lands in the Klein cubic. This structured
family is not an all-degree exclusion.

### Degree-free Jacobian equation

The same frame gives an exact all-degree form of the KLS criterion.  Put

\[
\tau=\frac{f_3^2}{f_5},\qquad
P=\mathbf C(t_3,t_6,t_8,t_{11}),\qquad
K=\mathbf C(\mathbf P(W))^G,
\]

where \(t_d=f_d/\tau^d\).  The monomial coordinate change is unimodular,
Adler's Hironaka decomposition gives \([K:P]=12\), and the normalized frame

\[
\overline B=[\tau^{-1}x,\tau^{-4}C,\tau^{-5}D,
              \tau^{-6}E,\tau^{-7}K]
\]

defines, for the four extensions of the coordinate derivations of \(P\),

\[
\Gamma_r=\overline B^{-1}\partial_r\overline B\in\operatorname{Mat}_5(K),
\qquad \nabla_r=\partial_r+\Gamma_r.
\]

This connection is flat.  Clearing denominators and using the Euler
derivation proves the exact equivalence

\[
\det Dq=0
\Longleftrightarrow
\mathcal J_\nabla(a):=
\det[a,\nabla_1a,\nabla_2a,\nabla_3a,\nabla_4a]=0,
\]

with \([a]\in\mathbf P^4(K)\); the gauge law
\(\mathcal J_\nabla(ha)=h^5\mathcal J_\nabla(a)\) makes this projective.
Thus \(\operatorname{ed}(G)=3\) iff this first-order determinant equation has
a rational point, and \(\operatorname{ed}(G)=4\) iff it is nonzero at every
point. Equivalently, one seeks a \(K\)-line preserved by the connection along
one nonzero rational vector field. Irreducibility only forbids preservation
in all four directions and therefore does not settle this condition.

The finite infrastructure is now complete.  The rank-12 Hironaka basis and
all 78 products are certified, and the four \(\Gamma_r\) are compiled as
exact arithmetic circuits over that field.  Their inputs comprise 101 exact
frame/structure reductions and 20 secondary-derivative reductions over
\(\mathbf Q\).  At the regular specialization
\((t_3,t_6,t_8,t_{11})=(1,2,3,4)\), the horizontal operator has rank 48,
the frame determinant has an exact inverse, all 100 matrix entries and all
twelve basis derivatives are reconstructed, and Leibniz is checked on all 78
products.

The executable circuit gives two sound bounded exclusions.  A good-prime
rank-60 certificate for the 60-by-60 regular block determinant excludes all
121 projective constant directions in \(\{-1,0,1\}^5\) and all 440 ordered
directions \(e_i\pm b_s e_j\), with no survivor.  These are exactly 561
literal ansätze, not an exhaustive subset of the infinite field.  Rational
solvability or universal nonvanishing of the PDE remains a new theorem, not a
finite-degree Gröbner calculation.  The exact derivation and certificates are
in `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`,
`tmp/kproj_arithmetic/REPORT.md`, and `tmp/kproj_connection/REPORT.md`.

## Finite-orbit and secant audit

The subgroup-fixed configurations do not yield a positive map by iterated
third intersection. Using the standard maximal-subgroup list
\(A_5,11{:}5,D_{12}\), exact character-line checks prove that every complex
\(G\)-orbit on \(C\) has length at least 60. Indeed, the restrictions to
\(A_5\) and \(11{:}5\) are irreducible; the only relevant proper
order-greater-than-11 case inside \(A_5\) is \(A_4\), whose two character
lines are off \(C\); and the unique character line for \(D_{12}\) is also off
\(C\). A coordinate point has stabilizer \(C_{11}\), so the bound 60 is
sharp.

The Sylow-fixed constructions give effective cycles of degrees

\[
60,132,165,220,
\qquad -13\cdot60+3\cdot132+165+220=1.
\]

This is a degree-one formal zero-cycle, not an effective point. Exact secant
calculations show that the five diagonals of the \(C_{11}\) coordinate
pentagon are contained in \(C\), while its five sides are tangent and return
an endpoint. The normalizer pairs the four \(C_5\)-eigenpoints by inversion,
but both paired chords are contained in \(C\).

Finally, a \(G\)-invariant pairing of an orbit \(G/H\) is equivalent to an
index-two overgroup of \(H\). Exact subgroup enumeration gives: no step from
\(C_{11}\) or \(V_4\); \(C_5<D_{10}\) and then no further step; and three
order-six choices above \(C_3\) (one \(C_6\), two \(S_3\)), all folding to
\(D_{12}\) and then stopping. The \(D_{12}\)-character-line calculation also
forces the last paired chord to be contained or degenerate. Thus no such
binary chord tree reaches a singleton or a two-point orbit.

This excludes only finite-orbit binary folding. It does not exclude a
continuous covariant mixing an entire orbit at once. Likewise
\(\operatorname{Sym}^2(C)\) is \(G\)-birational to the \(\mathbf P^3\)-bundle
of lines through a point over \(C\), so the residual-intersection map merely
repackages the original problem.

The 220-point \(C_3\)-orbit also resists the most direct higher-arity
linkage. Exact good reduction at 331 gives its evaluation ranks on
\(H^0(C,\mathcal O_C(d))\)

```text
1, 5, 15, 34, 65, 110, 165, 220     (d=0,...,7).
```

Hence no divisor of degree at most four contains the orbit, and its space of
containing quintics is one-dimensional. A three-divisor complete intersection
containing it must start in degrees at least \((5,6,6)\), whose residual has
degree at least \(3\cdot5\cdot6\cdot6-220=320\). A constant
\(G\)-invariant curve of degree 74 cannot do better: if it contained the
orbit simply, its intersection with the cubic would leave a constant
\(G\)-invariant effective cycle of degree two, contradicting the minimum
orbit length 60. A torsor-dependent semilinear degree-74 interpolation curve
would evade this argument and would solve the problem, but constructing it is
another form of the unresolved varying-covariant problem.

## Other audited boundaries

- The generic twist contains no \(K_0\)-rational line. Let \(S(C)\) be the
  Fano surface of lines. A point of \({}^{T_{\rm gen}}S(C)(K_0)\) would, by
  twisting adjunction, give a rational \(G\)-equivariant map
  \(W\dashrightarrow S(C)\). The closure of its image cannot have trivial
  \(G\)-action: that would give a \(G\)-invariant line in \(C\), hence a
  two-dimensional invariant subspace of the irreducible representation
  \(W\). Simplicity of \(G\) therefore makes the image faithful and very
  versal. But it has dimension at most two, contradicting
  \(\operatorname{ed}(G)\ge3\). Thus a line-based parametrization of the
  generic twist is unavailable even if the cubic ultimately has a point. The
  twist contains no \(K_0\)-defined conic either: its span is a
  \(K_0\)-plane, and the residual component of the cubic plane section would
  be a \(K_0\)-line.
- Gross--Popescu identify the level-structure moduli space
  \(\mathcal A^{\mathrm{lev}}_{11}\) birationally with the Klein cubic, and
  the natural change-of-level action is the same \(G\)-action. This does not
  furnish an equivariant parametrization: their unirationality conclusion at
  this point uses only the ordinary unirationality of a smooth cubic
  threefold. No linear or already very versal source for the deck action is
  produced, so the modular interpretation restates rather than solves the
  current problem.
- The projective factor in the Pfaffian bridge is generically and
  intrinsically nonsplit.  The inverse image of an explicit
  \(V_4\subset G\) in \(\operatorname{SL}_2(11)\) is \(Q_8\); the associated
  \(V_4\)-torsor over \(\mathbf C(s,t)\) has nonzero boundary quaternion
  \((s,t)\).  Extending structure group and using versality of the free open
  in \(\mathbf P(W)\) proves

  \[
  \alpha_{\rm proj}\ne0,
  \qquad \operatorname{ind}(A_{\rm proj})=2.
  \]

  Thus the generic twist of \(\mathbf P(V_6)\) is a nonsplit
  Severi--Brauer fivefold and is not stably rational: its function field
  splits the nonzero Brauer class, while a purely transcendental extension
  does not.  Consequently this projective factor has no stable replacement
  by projectivizations of honest `G`-representations.  This does not weaken
  the projective-source lemma: the algebra still splits over a quadratic
  extension, after which third-intersection descent applies to the honestly
  embedded cubic.
- In contrast, every twist of the ambient
  \(\operatorname{Gr}(2,6)\) is rational. It is
  \(\operatorname{SB}_2(A_T)\), where \(A_T\) has degree six and index one or
  two. In the index-two case \(A_T=M_3(D)\) for a quaternion algebra \(D\),
  and this generalized Severi--Brauer variety is the \(D\)-projective plane
  with affine chart \(D^2\). Intrinsically, the distinguished \(F_{14}\)
  section asks for a common isotropic \(D\)-line in \(D^3\) for five
  quaternionic Hermitian forms, equivalently a common zero of five scalar
  quadrics on the eight-dimensional chart \(D^2\).  For the generic torsor,
  existence of such a common line would give a dominant map to \(F_{14}\)
  and settle Problem E positively through the Pfaffian bridge.  The formerly
  proposed search for an anisotropic member is now proved impossible.  The
  accepted `A4`-fixed point on \(F_{14}\) twists to a degree-55 zero-cycle,
  hence gives a common \(D\)-line after an odd-degree residue extension.
  For any one descended Hermitian form \(h\), the equation
  \(q_h(v)=h(v,v)\) is an ordinary 12-dimensional quadratic form over
  \(K_{\rm proj}\).  Springer descends its isotropy through that odd-degree
  extension.  Consequently every individual member of the special
  five-plane is isotropic over \(K_{\rm proj}\).  This does not descend a
  simultaneous line: the individual isotropic vectors may differ, so the
  common-line problem remains open.  Moreover
  \(\operatorname{Br}({}^T F_{14})=\operatorname{Br}(K)\), so a nonsplit
  quaternion class remains nonsplit over the function field of the section;
  the tautological reduced-dimension-two ideal does not split it. Exact
  good-reduction calculations also exclude matched polynomial covariants
  into the Pfaffian cone through degree fifteen. In degree sixteen the full
  80-dimensional covariant space and 1,313 independent necessary Pluecker
  quadrics have been reconstructed, but a 1,800-second exact Gröbner run
  timed out in a \(105039\times88559\) degree-three matrix without emitting a
  leading ideal. Thus degree sixteen is a strict nonverdict, not an
  exclusion or an all-degree gate; the preferred successor is the explicit
  quaternion-plus-five-Hermitian-matrices problem.  The installed data do not
  yet give a quaternion symbol over \(K_{\rm proj}\), a Morita idempotent, or
  five global Hermitian matrices.  The exact construction dependency is

  \[
  \text{characteristic-zero alignment}\longrightarrow
  \text{36-dimensional descended algebra with involution}\longrightarrow
  \text{rank-two idempotent}\longrightarrow D_{\rm proj}\longrightarrow
  \text{five Hermitian matrices}\longrightarrow\text{common-line test}.
  \]

  See `tmp/fano14_degree16/REPORT.md`,
  `tmp/pfaffian_generic_schur_audit/REPORT.md` with its `PROOF_AUDIT.md`,
  and `tmp/pfaffian_explicit_descent/REPORT.md` with its
  `PROOF_AUDIT.md` and independent `AUDIT.md`.
- Kresch--Tschinkel's equivariant integral decomposition of the diagonal does
  not furnish a new obstruction here. Their proved implication starts from
  stable linearizability, whereas the target is only dominance from a linear
  representation; failure of decomposition would not obstruct mere
  \(G\)-unirationality. Conversely, its existence would not prove
  \(G\)-unirationality. The relevant Amitsur and universal-torsor necessary
  conditions already vanish for the honestly linearized hyperplane class.
- The ordinary and all higher Amitsur obstructions vanish, even after
  restriction to subgroups: \(\mathcal O_C(1)\) is honestly linearized, so
  the equivariant universal-torsor obstruction is zero and
  Scavia--Tschinkel--Zhang Theorem 1.2 applies. Likewise every twist \(Y\)
  satisfies \(\operatorname{Br}(Y)=\operatorname{Br}(K)\). These are
  necessary-condition checks, not point theorems.  The primary-source
  closure of this branch is recorded in
  `tmp/recent_structural_tools_audit/REPORT.md`.
- Prime-local essential dimension cannot force the value four: the local
  values are two at \(2\) and one at \(3,5,11\).
- Equivariant birational superrigidity excludes birational linearization, not
  a dominant equivariant map of higher degree.

## Current open boundary

A complete solution must still do at least one of the following:

- find a landing self-covariant in degree at least 25, or another dominant
  equivariant parametrization;
- solve the generic Pfaffian Hermitian gate: write
  \(A_{\rm proj}=M_3(D_{\rm proj})\) and the descended special five-plane
  explicitly, then exhibit a common isotropic right \(D_{\rm proj}\)-line.
  This would settle the headline positively.  Every individual member is
  now proved isotropic by the degree-55 `A4` orbit and Springer, so an
  anisotropic-member search is not viable; simultaneous isotropy remains
  open.  The next executable construction is characteristic-zero
  representation alignment, followed by the 36-dimensional descended
  algebra with involution, a reduced-rank-two Morita idempotent, the
  quaternion core, and the five global Hermitian matrices.  The matched
  degree-sixteen covariant system remains a strict solver nonverdict; no
  isolated higher-degree elimination is an all-degree substitute;
- find a point on the unrestricted Schur generic twist over
  \(K_{\rm Schur}=\mathbf C(\mathbf P(V_6))^G\).  The ten ambient
  coordinate-line genus-one fibrations are no longer positive targets:
  their generic fibres all have exact period and index three and hence no
  rational section.  This does not exclude a point on a special fibre or on
  the total threefold.  A live Schur target must therefore address an
  unrestricted point, for example on one of the coordinate-plane genus-one
  curves or on the full twist.  The no-line, no-geometrically-integral-plane-
  conic, no-regular-fibration and separated-norm exclusions retire those
  shortcuts, while the degree-twelve and other bounded coefficient windows
  remain nonverdicts;
- find a Jacobian-zero self-covariant over the proper closed exceptional
  locus in the degree-twelve primitive parameter space, or in a higher
  degree, equivalently a four-dimensional faithful covariant image;
- solve the equivalent degree-free connection equation
  \(\mathcal J_\nabla(a)=0\) over \(K=\mathbf C(\mathbf P(W))^G\), or prove
  its universal nonvanishing;
- for one minimal KLS solution, prove both LC-minimality and the
  vertical-divisor comparison lemma, or prove its image canonical directly.
  The comparison must now use differential/minimality or conductor geometry:
  coarse stabilizer geometry excludes full-`G` and `11:5` rational factors
  but by itself permits the orbit-11 `A5` quadric model.  The new
  linearized-pencil theorem closes that model whenever the image `H` is
  normal: no invariant `A5` quadric divides \(h\), so \(P_{22}\) and both its
  degree-25 and degree-28 fields cannot realize a normal-image KLS branch.
  More generally normality gives

  \[
  \operatorname{rad}(h)\mid b,
  \qquad
  \deg h-\deg\operatorname{rad}(h)
    \ge r+d(\deg H-5)+4.
  \]

  Thus a surviving normal non-Klein branch has repeated components with
  multiplicity excess at least \(r+4\).  The actual residual cases are a
  nonnormal image with a conductor surface, other `A5`-stabilized factors,
  repeated normal-image factors satisfying this inequality, stable
  components with non-rational singularities, and smaller-stabilizer
  branches.  The degree-25 logarithmic vector field remains only a
  tangency/integrability counterexample, not a live normal-image candidate.
  The exact dominant cubic `A5`-map \(Q^3\dashrightarrow\mathbf P^2\) now
  rules out a blanket prohibition on equivariant surface images as a way to
  dispatch the nonnormal conductor case.  A successor must use the actual
  conductor embedding and normalization compatibility, the same-degree
  \(W^*\)-valued polynomial first-integral module, the
  adjugate/image/degree identities, Jacobian multiplicities, minimality, or
  genuinely stronger conductor/discrepancy input;
- on the Fable branch, retain the audited nonzero compatible class with
  \(F(\sigma)=0\bmod I^{(11)}\) as a completed first correction, but do not
  continue its fixed-boundary ansatz through \(I^{(11)}/I^{(13)}\).
  Equivariance already forces the odd
  order-nine/eleven
  doubled-\(Q^2\) residue classes to vanish.  A resolved/saturated calculation
  now proves constrained generic surjectivity along the six base sections for
  the canonical fixed affine boundary.  The first order-ten quadratic residue
  vanishes on its preceding homogeneous linear kernel, whereas the first
  post-boundary order-twelve residue is not automatic.  The exact three-flag
  interface and invariant high-factor theorem now make the prescribed finite
  old-point jets zero simultaneously.  The raw point residue is then zero,
  but so is its differential; colon saturation moves the entire finite defect
  into \(B_{\rm desc}\).  The joint Koszul equalizer now repairs all six naive
  conflicts and splits the normalized simple-`Q` residue in every transverse
  grade.  The ambient residue-cleared centre-line bulk is now exact in every
  grade as well.  The quadratic-trace obstruction now proves that no
  boundary-compatible factorized `q_P R_P` extension can kill the residue on
  the complete `V(q_P)`.  The Veronese/Hilbert--Burch obstruction further
  proves that a primitive nonfactorized pair with the same line germs makes
  `p4` vanish on the required common-zero sections; a compatible common
  divisor is forced back to `q_P`.  The current fixed-boundary order-`3/4`
  branch is therefore closed.  A future Fable target must change the boundary
  data or leading normal order before addressing higher formal corrections,
  effectivity, algebraization/descent, and dominance;
- find a \(K_0\)-point on the explicit generic twisted cubic \(\Phi=0\), or a
  full-threefold obstruction.  The distinguished `xCD` component now has a
  certified `K_proj,C` nonpoint, and its local `f6=0` class-image/Rees route is
  retired; this does not decide any other component or the full cubic;
- if an independent true-second-descent route is pursued, construct the
  generic twisted three-flex-line algebra, line forms, and constants;
- construct a torsor-dependent semilinear degree-74 curve through the
  degree-220 orbit point, leaving a quadratic residual cycle;
- find such a point in a three-column frame plane in total degree at least 15;
- for one frame plane, decide whether its nontrivial flex class in
  \(H^1(K_0,E[3])\) lies in the Kummer image \(E(K_0)/3E(K_0)\);
- prove \(\operatorname{ed}_{\mathbf C}(G)=3\) by another compression;
- prove \(\operatorname{ed}_{\mathbf C}(G)=4\), or exhibit a twist with no
  rational point.

## Primary references

- A. Duncan and Z. Reichstein, *Versality of algebraic group actions and
  rational points on twisted varieties*, especially Remark 2.6, Theorems 1.1,
  10.3, 10.5, and Proposition 10.8:
  <https://arxiv.org/abs/1109.6093>.
- A. Duncan, *Equivariant unirationality of del Pezzo surfaces of degree 3
  and 4*, especially Lemma 7.3 on smooth \(A_4\)-cubic surfaces:
  <https://arxiv.org/abs/1410.8434>.
- Yu. Prokhorov, *Simple finite subgroups of the Cremona group of rank 3*,
  Theorems 1.1 and 1.5: <https://arxiv.org/abs/0908.0678>.
- Yu. Tschinkel and Zh. Zhang, *Stable equivariant birationalities of cubic
  and degree 14 Fano threefolds*, Proposition 4.1 and Remark 3.4:
  <https://arxiv.org/abs/2409.08392>.
- I. Cheltsov, Yu. Tschinkel, and Zh. Zhang, *Equivariant unirationality of
  Fano threefolds*, author manuscript dated 2026-07-18, Theorem 5.1 and
  printed page 23:
  <https://math.nyu.edu/~tschinke/papers/yuri/25bguni/bguni.pdf>.
- C. Spicer and L. Tasin, *Rank one foliations on toroidal varieties*,
  Proposition 2.1(3) and Theorem 1.1:
  <https://arxiv.org/abs/2604.08100>.
- B. Poonen and M. Stoll, *The valuation of the discriminant of a
  hypersurface*, Theorem 1.1 and Corollaries 10.1--10.2, dated 2026-06-30:
  <https://math.mit.edu/~poonen/papers/discriminant.pdf>.  Valuation one is
  the theorem-level bridge from the exact `xCD` divisor calculation to a
  residue-rational nondegenerate node.
- S.-J. Jung and M. Saito, *Defect of projective hypersurfaces with isolated
  singularities*, v3, Theorems 1 and 3.1 and Example 3.1:
  <https://arxiv.org/abs/2512.23522>; and *Factoriality of normal projective
  varieties*, v6, Theorem 2:
  <https://arxiv.org/abs/2601.13151>.  Both were revised 2026-07-27 and give
  the exact defect-zero-to-factoriality bridge for the Klein sextic base.
- A. Grothendieck, *SGA 2*, Expose XII, Corollaire 3.6:
  <https://arxiv.org/abs/math/0511279>, for the fixed-member Picard
  restriction used on the `xCD` projective bundle and its cubic.
- G. V. Ravindra and V. Srinivas, *The Grothendieck--Lefschetz theorem for
  normal projective varieties*, Theorem 1:
  <https://arxiv.org/abs/math/0511134>, for the general ample-slice
  class-group isomorphism.
- M. Bender, L. Busé, Y. Checa, and E. Tsigaridas, *Solving bihomogeneous
  polynomial systems with a zero-dimensional projection*, for the
  conditional admissible-bidegree/multiplication-matrix test on the
  degree-12 exceptional incidence: <https://arxiv.org/abs/2502.07048>.
- Y. Kopeliovich and C. Sanabria Malagón, *Schwarz maps for modular curves*:
  <https://arxiv.org/abs/2607.06900>.  Its level-11 theta model was tested
  directly; the paper gives an explicit ODE only at level 9.
- V. Chestnov and G. Crisanti, *Sampling Polynomial Rational Remainders with
  SPQR*: <https://arxiv.org/abs/2511.14875>, for candidate reconstruction by
  elimination orders even in positive-dimensional systems; its
  companion-matrix route is the zero-dimensional branch, and every candidate
  here would still need exact verification.  A. Demin and F. Rouillier,
  *Fast Rational Univariate Representation via Gaussian Elimination*:
  <https://arxiv.org/abs/2607.06397>, is instead conditional on first obtaining
  a zero-dimensional ideal.
- A. Demin and S. Gowda, *Groebner.jl: Fast Groebner Tracing in Julia*:
  <https://arxiv.org/abs/2607.06372>, and the current
  [change-matrix interface](https://sumiya11.github.io/Groebner.jl/interface/).
  The latter was tested under `tmp/groebnerjl_change_matrix_pilot/`: exact
  small identities pass, but the two-row fixed-input change calculation and
  512-row parsing already cross the `768 MiB` RSS gate, so the public
  high-level route is not viable for all 721 rows under that bound.
- Yu. Tschinkel and Zh. Zhang, *Cohomological obstructions to equivariant
  unirationality*: <https://arxiv.org/abs/2504.10204>.  Its degree-two and
  degree-three obstructions vanish for the present honestly linearized
  Picard-rank-one action, so it supplies no headline obstruction here.
- I. Dolgachev, *The essential and Cremona dimensions of a group*, version 3:
  <https://arxiv.org/abs/2507.15096>.
- H. Kraft, R. Loetscher, and G. W. Schwarz, *Compression of finite group
  actions and covariant dimension II*, especially Theorem 3.1,
  Corollary 3.5, Proposition 2.1, and Theorem 2.4:
  <https://arxiv.org/abs/0807.2016>.
- J. E. Cremona, T. A. Fisher, C. O'Neil, D. Simon, and M. Stoll,
  *Explicit n-descent on elliptic curves. I. Algebra*:
  <https://arxiv.org/abs/math/0606580>, and
  *III. Algorithms*:
  <https://arxiv.org/abs/1107.3516>, for the genuine and fake descent
  algebras and Kummer equations used in the `xCD` audit.
- T. A. Fisher, *The Hessian of a genus one curve*:
  <https://arxiv.org/abs/math/0610403>, for the ternary-cubic Hessian and
  Jacobian invariant normalization.
- C. Voisin, *Rank 2 vector bundles and degrees of points of del Pezzo
  surfaces*, version 2, especially Theorem 1.1 and Section 2:
  <https://arxiv.org/abs/2509.17996>.
- A. Kresch and Yu. Tschinkel, *Invariants in equivariant birational
  geometry*, especially the higher Amitsur obstruction and the scope of
  equivariant Burnside invariants: <https://arxiv.org/abs/2602.23998>.
- A. Kresch and Yu. Tschinkel, *Linearizability notions in equivariant
  birational geometry*, especially Theorems 2.5, 4.4, 4.6 and Proposition
  5.1: <https://arxiv.org/abs/2606.10965>.
- A. Adler, *Invariants of* \(\operatorname{SL}_2(\mathbf F_q)\cdot
  \operatorname{Aut}(\mathbf F_q)\) *acting on* \(\mathbf C^n\), especially
  the Klein cubic and Hessian discussion:
  <https://library.slmath.org/books/Book35/files/inv.pdf>.
- A. Adler, *Invariants of* \(\operatorname{PSL}_2(\mathbf F_{11})\)
  *acting on* \(\mathbf C^5\), Comm. Algebra 20 (1992), 2837--2862, for the
  invariant-ring Hironaka presentation.
- F. Scavia, Yu. Tschinkel, and Zh. Zhang, *Birational invariance of higher
  Amitsur groups*, especially Theorem 1.2:
  <https://arxiv.org/abs/2605.02763>.
- ATLAS of Finite Group Representations, maximal subgroups of
  \(\operatorname{PSL}_2(11)\):
  <https://brauer.maths.qmul.ac.uk/Atlas/v3/lin/L211/>.
- M. Gross and S. Popescu, *The moduli space of (1,11)-polarized abelian
  surfaces is unirational*, especially Theorem 0.1 and the discussion after
  it: <https://arxiv.org/abs/math/9902017>.

## 2026-07-28 — director review and synthesis of the generic Cech-circuit packet

Reviewed: `tmp/xcd_generic_cech_next/`, `tmp/xcd_first_descent_next/`, and
`tmp/xcd_arithmetic_next/` (reports dated 2026-07-28).  The frozen typed,
corrected-alpha, first-descent, and arithmetic-gate verifiers replay their
stated PASS and strict-status lines.

**Verdict: sound, correctly scoped, and it closes the four structural gates
of the determinant-free generic first descent.**

*Inference pattern checked.*  The pre-alpha flex/Cech generic-open rank and
unit claims rest on nonvanishing of a literal integer or `GF(67)`
specialization of a universal formula — the correct direction (nonvanishing
reflects along specialization).  Verified at each load-bearing site: smoothness
(`c_4, c_6, Δ`), the flex resultant plus the `a^3`-coefficient (all nine
flexes affine), the unit markers `N_F(g) = 31`, `N_F(d) = 3`, square-freeness
of the degree-nine eliminant (so the divided-difference idempotent
`e_Δ` is legitimate), and the `81×81` determinant (so rank 81 holds on a
nonempty generic open, not on one split fiber).  By contrast, membership of
the corrected `alpha_R` in the rank-nine group algebra is proved by the
geometric scalar-cochain descent lemma.  The `GF(101)` sheet proves that the
chosen `ell` chart and selected `9 x 9` subsystem are generically
nonempty/invertible and corroborates all-coordinate reconstruction; it is not
the proof of generic `R`-membership.

*The two convention traps are closed properly.*  The differential
alignment `ρ = −g⁻¹` with the `c_4/c_6` weight check pins the sign/scale
ambiguity that a bare Weierstrass-equation check would leave — exactly the
failure mode the characteristic-23 control (`tmp/xcd_control_next/`) was
built to catch.  And the repeated-point components of the triple-overlap
identity are NOT claimed via collinearity (tautological there); the report
derives them from the formal definition `c_{ij} = P_j − P_i` and claims no
stronger expanded triple packet.

*Geometric inputs.*  `λ_{12}` unit-off-diagonal rests on smooth-cubic
flex-tangent geometry (tangent at a flex meets the cubic only there, with
multiplicity three) plus certified étaleness — both in place.

*Consequence for the queue.*  The "Best re-entry points → Generic twist"
needs list (rank-nine flex algebra `F`, Cech difference
`c_{12} ∈ E[3](F⊗F)`, triple-overlap identity, rank-81 isomorphism) is now
  satisfied AT CIRCUIT LEVEL; the former circuit-construction gate is done.
  The selected arithmetic covering curve is now closed negatively, while the
  full twisted-threefold problem remains open.  The subsequent
coefficient pass implemented the length-twelve Hironaka DAG through the
generic flex point and diagonal
idempotent; a typed nested-etale-algebra continuation now also supplies the
off-diagonal inverse `lambdaSharp` and its actual `X,Y` packet, with the full
rank-81 identities replayed.  The subsequent scalar-cochain normalization
also supplies a generic-open rational first-Kummer representative `alpha_R`
modulo cubes; the raw
  determinant ratio is explicitly shown not to descend.  CFOSS identifies a
  distinguished component of the 729-component first-descent union that is
  base-defined and isomorphic as a covering to the original projective `xCD`
  cubic.  The later general-slice theorem proves that component has no
  `K_proj,C`-point, closing this selected first-descent plane construction but
  not the full twisted Klein cubic.  The pure-coefficient places `A=0`, `B=0`, and
`C=0` are exactly locally soluble.  The geometric degree-120 discriminant is
now also closed as a local-obstruction route by the squarefree line
  certificate and Poonen--Stoll's valuation-one theorem.  At both motivated
  smooth-reduction primes, invariant-polynomial residue points through degree
  15 were excluded; local solubility remains undecided only at `f5=0`.  At
  `f6=0`, the pullback
  total space is integral and normal; the exact repeated-factor census and
  general-slice theorem make it factorial and prove quotient-relative
  horizontal degree image `3Z`.  The earlier Rees-lattice/class-image problem
  is therefore retired for this plane.  The triple-line route is
closed and the exact `a*c^2`
fibres prevent a fibrewise total-factoriality shortcut.  The base itself is
  factorial with `Cl(H6)=Z[O(1)]`, and now
  `Cl(C6)=Pic(C6)=Z[H] direct_sum Z[xi]`; the local `Cl(B)` question is not
  needed for the scoped conclusion.
Relative unramified 3-descent, the `f5=0` residue, and true second descent
remain independent diagnostic branches over `K_proj,C`; they are not missing
steps for the refuted selected component.  A true second descent would need
the twelve-flex-lines algebra as before.  The engineering directive
(no five-variable resultant expansion, no splitting field, hash-consed DAG)
remains in force.  These are diagnostics for the distinguished `xCD` plane
over \(K_{\rm proj}\), not the now-closed coordinate-line section attacks on
the separate Schur twist over \(K_{\rm Schur}\).

The sibling `tmp/kls_residue_next/` packet has also been replayed: its general
residue systems are positive-dimensional determinant hypersurfaces, and its
60 simultaneous constant `P2` families are empty.  The follow-up
`tmp/kls_first_jet_two_fiber/` packet excludes all 720 one-slope first-jet
families and all 240 stronger `P5` families with independent slopes in all
three coefficients along one common base direction.  The follow-up canonical
`P8` two-coordinate family is now completely projectively empty as well, and
the full constant `P4` is excluded.  The structural audit proves that these
three-support families cannot be exhaustive: their local first-jet union has
dimension at most 10 inside the 19-dimensional KLS determinant hypersurface.
The first full-support `P9` chart reached the memory stop.  The structural
successor proves that the primitive quartic covariant is a finite surjective
`G`-endomorphism of `P4` of degree 256.  If one primitive KLS solution exists,
precomposition produces solutions of saturated degrees `4^n d`; hence a
uniform bound on all solutions is false in the positive case and vacuous in
the negative case.  Its rank-1,024 `C`-adic decomposition with residue degrees
  at most 15 is a possible recursive interface, but Jacobian descent through
  the residue terms is open.  The global successor now identifies the exact
  image branch.  Every KLS solution has an irreducible invariant unirational
  hypersurface image `H`; canonical singularities force `deg(H)<=4`, hence
  `H` is the unique invariant cubic.  For
  `h=gcd_i (partial_i F)(q)`, primitive kernel degree `r`, and residual
  adjugate degree `t`, one has
  `deg(h)=r+t+d(deg(H)-5)+4`.  Consequently a divisor-clean image is the
  Klein cubic, while every non-Klein image requires a nonzero invariant
  divisor contracted into `Sing(H)`.  In the Klein branch `r+t=2d-4`.
  Further negative progress requires the minimal-contraction lemma or
  canonicity for one minimal solution, not another finite sparse-support
  sweep.  See `tmp/kls_structural_successor/REPORT.md` and
  `tmp/kls_global_foliation_theorem/REPORT.md`.

Headline unchanged: this installs descent infrastructure; it does not
decide `ed_C(PSL_2(F_11))`.
