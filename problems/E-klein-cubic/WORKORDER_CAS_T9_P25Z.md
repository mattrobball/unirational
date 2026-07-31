# Problem E — T9/P25Z CAS work order after the binodal and finite-module audit

**Repository:** `mattrobball/unirational`  
**Pinned base:** `a69309dcfcfb3201f1391e8428e33c7d2064aa5b`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** exact CAS production and independent verification only  
**Headline:** **OPEN**

---

## 0. Purpose and supersession

This work order supersedes `WORKORDER_CAS_AFTER_5E72D8E.md` for new execution.
The older orders, `REPAIR.md`, and all sealed packets remain binding historical
inputs at their corrected theorem boundaries.

The recent work changes both leading routes:

1. **Track T:** an explicit algebraic-number reconstruction of a binodal point
   is **not required** to prove characteristic-zero nonemptiness.  The verified
   nonsingular modular point and multivariate Hensel lemma already give a
   \(\mathbf Q_p\)-point.  The route must now study the **binodal normalization
   and conductor**, not continue a degree-\(\sim 2000\) plane RUR merely to
   certify nonunitness.
2. **Track P25:** the direct 746-row subsystem makes the quotient finite over
   \(S=\mathbf F_{89}[Q]\) on the generators
   \(1\oplus K\oplus\operatorname{Sym}^2K\).  The next exact object is a finite
   \(S\)-module presentation and its Fitting/annihilator support, not another
   raw degree-4 F4 run.

The first three priorities are:

| Priority | Track | Exact target |
|---:|---|---|
| **1** | `T9` | global binodal normalization and the three-primary index obstruction |
| **2** | `P25Z` | exact finite-module support of the direct degree-25 subsystem |
| **3** | `C1` | executable genuine twisted Fano model and common isotropic line |

The marked Schur degree-19 route and KLS remain conditional lower-priority
tracks.  Universal Path G, Path A elimination, and further free-fibre degree
ladders are not authorized.

---

# 1. Analytic results that are now binding inputs

The following statements are proved analytically from the verified packets.
The CAS worker must consume them and must not reimpose stronger, unnecessary
certificate requirements.

## 1.1 Hensel promotion: `T8-S1-NONUNIT` is achieved

Let \(\Lambda(s,t)\) be any of the three verified planes and put

\[
\begin{aligned}
E_1&=P(\Lambda(s,t),u_1),&
E_2&=P_u(\Lambda(s,t),u_1),\\
E_3&=P(\Lambda(s,t),u_2),&
E_4&=P_u(\Lambda(s,t),u_2).
\end{aligned}
\]

At each gate-passing modular witness the exact packet verifies:

- \(E_1=E_2=E_3=E_4=0\);
- \(u_1-u_2\ne0\);
- every gate is nonzero;
- the \(4\times4\) Jacobian determinant is nonzero:
  \[
  \det J_4
  =P_{uu}(u_1)P_{uu}(u_2)
   \det\begin{pmatrix}
   dh_1\cdot x_s&dh_1\cdot x_t\\
   dh_2\cdot x_s&dh_2\cdot x_t
   \end{pmatrix}.
  \]

Therefore multivariate Hensel gives a unique solution in
\(\mathbf Z_p^4\), hence a \(\mathbf Q_p\)-point with the same nonvanishing
gates.  At that point \(P\) and \(P_u\) have two distinct common roots, so
\(\deg\gcd(P,P_u)\ge2\), hence \(s_1=0\).  Since \(G\) is a unit and
\(\operatorname{Res}_u(P,P_u)=HG=0\), one also has \(H=0\).

Consequently

\[
(H,P,P_u,s_1):
(\ell P_{uu}C\delta G)^\infty\ne(1)
\quad\text{over }\mathbf Q.
\]

A \(\mathbf Q_p\)-point is a characteristic-zero point over a field extension
and is enough to refute the unit ideal.  **No squarefree number-field minimal
polynomial is needed for this conclusion.**

Binding marker for this order:

```text
T8-S1-NONUNIT-ANALYTIC
```

The previous `T8-S1-UNDECIDED` packet remains byte-identical as a computation
record; this order supplies the analytic promotion.

## 1.2 Local binodal normal form

Let \(z\) be the resulting \(\mathbf Q_p\)-parameter point.  Because
\(P_{uu}(z,u_i)\ne0\), the equations \(P_u(z',u)=0\) define two local critical
sections \(u_i(z')\).  Put

\[
h_i(z')=P(z',u_i(z')).
\]

Then

\[
dh_i=d_zP(z,u_i),
\]

and the verified branch determinant says \(dh_1,dh_2\) are independent.
The other roots of \(P\) are simple.  By the formal Morse/Weierstrass lemma,
the local resultant is

\[
\operatorname{Res}_u(P,P_u)=\text{unit}\cdot h_1h_2.
\]

Since \(G\) is a unit,

\[
H=\text{unit}\cdot h_1h_2.
\]

Thus the completed local branch ring is an ordinary binodal crossing:

\[
\widehat{\mathcal O}_{B,z}
\simeq
K'[[x,y,z_1,z_2]]/(xy)
\]

for a finite extension \(K'/\mathbf Q_p\).  The ordered-double-root incidence
is smooth of dimension two there, and the fold incidence separates the two
branches and is the normalization locally.

Consequences consumed by this order:

```text
T-BRANCH-BINODAL-DIVISOR
T-BRANCH-NONNORMAL
T-FOLD-LOCAL-NORMALIZATION-AT-BINODAL
```

These concern the target branch \(B\).  They do **not** assert that the fold
algebra \(S_G\) is globally normal or nonnormal.

## 1.3 Exact finite-module criterion for P25

Let

\[
S=\mathbf F_{89}[q_0,\ldots,q_{36}],\qquad
R=S[k_0,\ldots,k_5],
\]

and let \(J_N\) be the certified 746-row direct subsystem.  The pure
\(K^3\)-block has rank \(56\), so every cubic monomial in the six \(k\)-variables
has a monic rewrite.  Hence \(R/J_N\) is finite over \(S\), generated by

\[
\mathcal B=\{1\}\cup\{k_i\}\cup\{k_ik_j:i\le j\},
\qquad |\mathcal B|=28.
\]

After overlap and multiplication closure, let

\[
S^r\xrightarrow{M(q)}S^{28}\longrightarrow\mathcal M\longrightarrow0
\]

be an exact presentation of \(\mathcal M=R/J_N\) as an \(S\)-module.
Then

\[
\operatorname{Supp}_S(\mathcal M)
=V(\operatorname{Fitt}_0\mathcal M).
\]

Moreover,

\[
\operatorname{Proj}(R/J_N)=\varnothing
\]

if and only if the support away from the \(q\)-origin is empty:

\[
\left(\operatorname{Fitt}_0\mathcal M:
(q_0,\ldots,q_{36})^\infty\right)=(1).
\]

Indeed, a projective point with \(q\ne0\) projects to the finite
\(S\)-support.  If \(q=0\), all pure \(k\)-cubics vanish in the quotient ideal,
so the radical contains every \(k_i\); the only affine point is the total
origin, which is not projective.

This criterion is exact for the 746-row subsystem.  Completeness of the landing
row space is **not required to prove emptiness of the subsystem**.  Completeness
is needed only to interpret a surviving subsystem point as a full landing
candidate without adding further rows.

---

# 2. Binding status corrections

The worker must preserve the following distinctions.

1. \(m_{75}=2343\) is the scalar-invariant Molien coefficient and only an upper
   bound for the landing-row rank.  It does not decide 746 versus 842.
2. \(\dim M_{25}=189\) is the self-covariant Molien dimension.
   \(\dim\operatorname{Arr}=59\) and \(\dim V_{25}=43\) are exact construction
   dimensions, not scalar Molien coefficients.
3. The historical 842-row and historical rank-28 packets remain quarantined.
4. The newly proved finite generation on 28 generators is **not freeness**.
   An exact presentation requires overlap/commutator and multiplication closure.
5. The universal 84-jet rank is a useful outer support test.  Rank drop of the
   84-jet matrix contains the true support, but need not equal it.  It cannot
   replace the exact finite-module presentation.
6. The degree-4 raw F4/Macaulay job has already reached a measured 54.6 GiB wall.
   Repeating it with the same formulation is forbidden.
7. Picard rank one rules out nontrivial fibrations as morphisms on the prime
   \(F_{14}\) model; it does not rule out birational links after modification.
8. The degree-55 odd extension cannot split a nonzero 2-torsion Brauer class,
   but this does not decide the common-isotropic-line problem.

---

# 3. Track T9 — global binodal normalization and the index-three obstruction

## T9.0 — seal the p-adic theorem interface

This is a small replay packet, not a reconstruction job.

For one preferred witness, L4 at \(p=101\):

1. Rebuild the four deflated equations over \(\mathbf Z_{(101)}\).
2. Recompute the modular solution, \(u_1-u_2\), every gate, and \(\det J_4\).
3. Emit the exact hypotheses of multivariate Hensel and the conclusion that a
   \(\mathbf Z_{101}\)-solution exists.
4. Verify logically and computationally that the lifted point gives
   \(H=s_1=P=P_u=0\) and all gates units.
5. Do **not** attempt a number-field RUR merely to prove nonunitness.

Deliverables:

```text
certificates/fold_binodal_t9/
  HENSEL_NONUNIT.md
  hensel_hypotheses.json
  verify_hensel_hypotheses.py
```

Exit:

```text
T9-HENSEL-NONUNIT-SEALED
```

The independent verifier must recompute the modular determinant and gates.

## T9.1 — construct the ordered binodal component globally

Work with the ordered-double-root incidence

\[
\mathcal Y=
V\bigl(P(u_1),P_u(u_1),P(u_2),P_u(u_2)\bigr)
\subset\mathbf A^4_{A,B,Y,Z}\times\mathbf A^2_{u_1,u_2},
\]

saturated by

\[
(u_1-u_2)\,\ell\,C\,G\,
P_{uu}(u_1)P_{uu}(u_2)\,
\delta(u_1)\delta(u_2).
\]

The analytic input already proves that a smooth two-dimensional component
exists in characteristic zero.  The CAS task is to obtain a usable global
presentation of that component.

Preferred method:

1. Use the verified \(p=101\) point to choose two linear Noether parameters
   on the two-dimensional component.
2. Treat those two parameters as transcendental and solve the four deflated
   equations for the remaining four variables over a rational function field.
3. Use modular factor selection at the Hensel point to isolate the correct
   component before characteristic-zero reconstruction.
4. Produce one of:
   - a prime ideal over \(\mathbf Q\);
   - a finite integral algebra over \(\mathbf Q[t_1,t_2]\);
   - or a rational-univariate/function-field presentation with exact verification.
5. Verify dimension two, generic distinctness of the roots, all gates, and
   transversality of \(dh_1,dh_2\).

Do not use a fully specialized plane section of degree \(\sim2000\) unless it
is only a factor-selection aid.  The output needed is the generic component,
not an explicit high-degree closed point.

Deliverables:

```text
certificates/fold_binodal_t9/
  BINODAL_COMPONENT.md
  component_presentation.*
  noether_parameters.json
  verify_component.*
```

Exit:

```text
T9-BINODAL-COMPONENT
```

## T9.2 — normalize the target branch in codimension one

Let

\[
B_G=\operatorname{Spec}\mathbf Q[A,B,Y,Z]/(H)
\]

on the accepted gates, and let

\[
S_G=\operatorname{Spec}\mathbf Q[A,B,Y,Z,u]/(P,P_u)
\]

on the same open.

Tasks:

1. Construct the off-diagonal fibre product
   \[
   \mathcal C=
   (S_G\times_{B_G}S_G)\setminus\Delta,
   \]
   using variables \(u_1,u_2\).  Identify its relation with the component from
   T9.1.
2. Compute the conductor ideal \(\mathfrak c_{B\subset S}\) at the generic
   binodal component.
3. Verify directly that \(S_G\) is regular at each of the two generic points
   over that component and that the completed map is
   \[
   K'[[x,z_1,z_2]]\sqcup K'[[y,z_1,z_2]]
   \longrightarrow K'[[x,y,z_1,z_2]]/(xy).
   \]
4. Determine every other height-one component where \(S_G\) fails to be regular.
   Since \(S_G\) is \(S_2\), this is the exact remaining normality gate.
5. Conclude either:
   - `T9-S-NORMAL`: \(S_G\) is the normalization of \(B_G\); or
   - `T9-S-EXTRA-HEIGHT1`: list and normalize every additional height-one defect.

The singular-locus computation must be made on the same localization and must
not use affine linear sections as dimension proofs.

## T9.3 — pull back the cubic incidence and compute only the 3-primary defect

Once a normal base \(\widetilde B\) is installed:

1. Pull back the fixed-frame plane cubic family.
2. Factor its discriminant in codimension one on \(\widetilde B\).
3. For every height-one component \(E\), compute
   \[
   v_E(\Delta_{\rm cub})\pmod 3.
   \]
4. Compute the 3-primary part of every codimension-two local class group.
5. Audit residual codimension-three punctured Picard groups or prove the
   required parafactoriality.
6. Assemble
   \[
   \left(\operatorname{Cl}/\operatorname{Pic}\right)[3]
   \]
   and the horizontal divisor-degree subgroup.

Complete negative exit:

```text
T9-INDEX3
```

requires

\[
\deg_{\rm horiz}=3\mathbf Z.
\]

The analyst then applies the already accepted residue-twist obstruction to
settle the headline negatively.

---

# 4. Track P25Z — exact finite-module support

## P25Z.1 — build an exact finite \(S\)-module presentation

Inputs:

- the fixed DVR/special-fibre model at \(p=89\);
- the certified 746-row subsystem;
- the fixed \(Q(37)\oplus K(6)\) coordinates;
- the monic pure-\(K^3\) closure 56/56.

Let \(F=S^{28}\) with basis

\[
\mathcal B=1\oplus K\oplus\operatorname{Sym}^2K.
\]

Required construction:

1. Choose and seal the 56 monic \(K^3\) rewrite rules.
2. Construct multiplication operators by each \(k_i\) on \(F\), reducing with
   the chosen rules.
3. Add all overlap and commutator relations needed for confluence:
   \[
   (T_iT_j-T_jT_i)b,
   \qquad b\in\mathcal B.
   \]
4. Reduce all 746 direct cubic equations to \(F\).
5. Close the relation submodule under every \(T_i\) until stable.
6. Produce a finite presentation
   \[
   S^r\xrightarrow{M(q)}S^{28}\to\mathcal M\to0.
   \]
7. Prove by mutually inverse reduction maps that
   \[
   \mathcal M\simeq R/J_N
   \]
   as an \(S\)-algebra/module.

A matrix obtained from the 690 residual cubic rows alone is insufficient unless
all overlap and multiplication consequences are included.

Deliverables:

```text
certificates/degree25_finite_module/
  FINITE_PRESENTATION.md
  rewrite_rules.*
  multiplication_matrices.*
  relation_matrix.*
  closure_ledger.json
  verify_presentation.*
```

Exit:

```text
P25Z-FINITE-PRESENTATION
```

## P25Z.2 — compute annihilator/Fitting support

Run only after `P25Z-FINITE-PRESENTATION`.

1. Compute \(\operatorname{Fitt}_0(\mathcal M)\) from the exact presentation,
   using structure-exploiting module algorithms rather than the raw
   43-variable F4 matrix.
2. In parallel compute a usable annihilator ideal; either may be smaller.
3. Saturate by the irrelevant ideal
   \[
   \mathfrak q=(q_0,\ldots,q_{36}).
   \]
4. Verify one of:
   - unit saturation;
   - exact positive-dimensional component;
   - exact zero-dimensional support away from the origin.
5. Use the universal 84-jet matrix only as an outer determinantal filter for
   chart selection; do not substitute it for the exact Fitting ideal.

### Empty exit

If

\[
\left(\operatorname{Fitt}_0\mathcal M:\mathfrak q^\infty\right)=(1),
\]

seal

```text
P25-DEGREE25-EMPTY
```

and apply the existing DVR properness argument.  This is a degree-25 exclusion,
not a headline negative theorem.

### Nonempty exit

For every support component away from the origin:

1. produce an exact \(q\)-point or component;
2. solve the finite \(k\)-algebra;
3. add further genuine direct landing rows to remove subsystem artefacts;
4. verify any final candidate by exact substitution into
   \(F(p_c(x))\equiv0\), equivariance, primitivity, and Jacobian rank four.

A verified candidate gives

```text
P25-COVARIANT
```

and settles the headline positively.

## P25Z.3 — determine the exact direct landing-row rank

This is valuable but is not a prerequisite for proving subsystem emptiness.
Run in parallel if it does not consume the heavy slot needed by P25Z.2.

Construct an exact unisolvent model for the invariant degree-75 space of
dimension \(2343\):

1. Build 2343 independent Reynolds orbit sums of degree-75 monomials, or an
   equivalent Hironaka/secondary basis, over \(\mathbf F_{89}\).
2. Construct 2343 source points whose invariant-evaluation matrix is invertible.
3. Evaluate the polarized landing map
   \[
   \operatorname{Sym}^3(V_{25})\to
   (\operatorname{Sym}^{75}W^\vee)^G
   \]
   on this unisolvent set.
4. Compute and independently verify its exact rank.

Exits:

- `P25Z-ROW-RANK-746`: the current subsystem is the complete direct row space;
- `P25Z-ROW-RANK-r`: \(r>746\); append the missing genuine rows, rebuild the
  finite presentation, and re-run P25Z.2.

Do not use random plateau behavior as the upper-bound certificate.

---

# 5. Track C1 — genuine twisted Fano model

This track is third priority and may run only as a low-memory interface job
while T9/P25Z are active.

The target remains

\[
F_{14,T}(K_{\rm proj})\ne\varnothing.
\]

Do not repeat the morphism-fibration or odd-degree-Brauer searches closed by C0.
Do not infer that Picard rank one excludes birational Sarkisov links.

## C1.1 — install the arithmetic model

1. Construct the descended projective algebra \(A_{\rm proj}\) in executable
   coordinates.
2. Extract a Morita corner and an exact quaternion symbol
   \[
   D=(a,b)_{K_{\rm proj}}.
   \]
3. Compute the five exact Hermitian matrices
   \[
   h_1,\ldots,h_5\in\operatorname{Herm}_3(D).
   \]
4. Independently construct the restricted Plücker/rank-one equations.
5. After splitting, verify dimension 3, degree 14, and smoothness of the
   classical \(F_{14}\).

Exit:

```text
C1-MODEL-PASS
```

## C1.2 — common isotropic line

Only after C1.1:

1. search for rational fibrations of a **birational model**, low-degree
   multisections, or an exact common-isotropic line;
2. run elimination only on the smallest certified charts;
3. substitute every candidate into all five original Hermitian equations.

Exit

```text
C-FANO-POINT
```

settles the headline positively through the accepted bridge.

---

# 6. Conditional lower-priority tracks

## S19 — marked degree-19 Schur curve

Run only after a director gate demotes T9, P25Z, and C1.

Required CAS objects:

1. universal 55-point configuration from the \(D_{12}\)-line orbit and
   hyperplane parameters;
2. complete relative ideal and minimal resolution;
3. the two accepted marked Rao/Quot branches only;
4. exact parametrization and residual-degree-two verification for a survivor.

A survivor settles the headline positively.  Emptiness closes only this
construction.

## KLS — minimality/conductor

No broad CAS run is authorized.  The analyst must first produce a theorem that
reduces minimal primitive covariants to a finite list of conductor
configurations.  CAS may then compute that finite list and search for
countermodels.

---

# 7. First dispatch

Run in parallel, path-fenced:

```text
Worker T: T9.0 + T9.1 preflight; begin generic component construction
Worker P: P25Z.1 exact finite-module presentation
Worker R: P25Z.3 exact row-rank preflight / invariant-basis construction
Worker C: C1.1 descent-interface preflight only
```

One memory-heavy slot only.  The first heavy slot goes to:

1. T9.1 if the generic Noether/function-field component has a credible finite
   matrix floor; otherwise
2. P25Z.2 Fitting/annihilator support.

No repeat of the raw degree-4 F4 run.  No plane RUR of degree \(\sim2000\) merely
to prove nonunitness.

---

# 8. Universal verification and resource rules

1. Every producer has an independent verifier that does not import the producer.
2. The verifier recomputes the decisive invariant, not a stored JSON field.
3. Hensel exits require the exact modular Jacobian and gate units; number-field
   reconstruction is not required unless a later task needs explicit global
   coordinates.
4. Modular reconstruction uses a final congruence check and exact substitution.
5. Empty solver output is a failed run, not emptiness.
6. Affine sections are never used as dimension upper bounds.
7. A finite-module presentation must include overlap and multiplication closure.
8. The 84-jet matrix is an outer filter, not the exact support module.
9. Prime 67 is never the sole decision fibre.
10. Historical 842-row/rank-28 packets remain quarantined until direct
    equivalence is proved.
11. Workers write only to their assigned certificate/tmp directories and run
    no git.
12. Verified packets are committed path-scoped and pushed immediately by the
    director.
13. An honest `UNDECIDED` with a named finite bottleneck is a successful exit.

Resource policy:

```text
8 GiB exploratory
64 GiB after written preflight
96 GiB absolute, only with explicit director approval
one memory-heavy process at a time
```

---

# 9. Final exit table

| Exit | Meaning | Headline consequence |
|---|---|---|
| `T9-HENSEL-NONUNIT-SEALED` | p-adic binodal point certified | no headline; T branch geometry fixed |
| `T9-BINODAL-COMPONENT` | global two-dimensional ordered binodal component | no headline; normalization input |
| `T9-S-NORMAL` | fold algebra is the normalized branch on the common open | proceed to 3-primary calculation |
| `T9-INDEX3` | horizontal degree subgroup remains \(3\mathbf Z\) | **headline negative** |
| `P25Z-FINITE-PRESENTATION` | exact finite \(S\)-module for the 746-row subsystem | proceed to Fitting support |
| `P25-DEGREE25-EMPTY` | subsystem/full special-fibre scheme empty | scoped degree-25 exclusion |
| `P25-COVARIANT` | exact primitive dominant degree-25 landing covariant | **headline positive** |
| `C1-MODEL-PASS` | genuine twisted Fano model installed | proceed to point search |
| `C-FANO-POINT` | exact common isotropic line / Fano point | **headline positive** |
| `S19-POSITIVE` | qualifying marked degree-19 curve | **headline positive** |
| `*-UNDECIDED` | exact bottleneck and resource floor | no headline claim |

**Problem E remains OPEN.**
