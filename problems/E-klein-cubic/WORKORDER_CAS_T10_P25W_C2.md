# Problem E — T10 / P25W / C2 CAS work order after `dbd27e6`

**Repository:** `mattrobball/unirational`  
**Pinned base:** `dbd27e62936cc0576ce9a9a049b9316f6433fcb3`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** exact CAS production and independent verification only  
**Headline:** **OPEN**

---

# 0. Purpose and supersession

This work order supersedes `WORKORDER_CAS_T9_P25Z.md` for new execution. The
older work orders, `REPAIR.md`, and all sealed packets remain binding historical
inputs at their corrected theorem boundaries.

The latest round settles or changes three issues.

1. **Track T.** `T8-S1-NONUNIT-ANALYTIC` is settled by the Hensel point. The
   target branch has an ordinary binodal conductor divisor. The expensive
   degree-\(\sim 2000\) closed-point reconstruction is not on the critical path.
   The next genuine gate is normality of the fold algebra in codimension one,
   followed by the three-primary discriminant-contact ledger.
2. **Track P25.** The direct landing row rank is exactly **746 over the fixed
   special fibre \(\mathbf F_{89}\)**. The historical 842-row packet is not the
   direct \(p=89\) landing ideal and remains unusable. The 690-row finite-module
   packet is a certified **lower presentation**, not an exact presentation.
   Emptiness may nevertheless be proved from it.
3. **Track C.** The full \(36^3\) structure-constant table is not the minimal
   install. A two-generator regular-representation model can reduce the exact
   reconstruction to two left-multiplication matrices before the Morita and
   Hermitian steps.

The first priorities are:

| Priority | Track | Exact target |
|---:|---|---|
| **1** | `T10` | decide \(R_1\) for the fold by ten generic-coordinate fibres; then compute the mod-3 obstruction |
| **2** | `P25W` | decide degree-25 support via a multigraded kernel-incidence certificate; close the finite-module presentation in degree four |
| **3** | `C2` | install a two-generator executable model of \(A_{\rm proj}\), then the genuine common-isotropic-line system |

The Schur degree-19 route and KLS remain lower-priority. Universal Path G,
Path A elimination, the historical 842/rank-28 packets, and further free-fibre
degree ladders are not authorized.

---

# 1. Binding analytic results and corrections

## 1.1 `T8-S1-NONUNIT-ANALYTIC` remains settled

At the preferred \(p=101\) binodal witness, the deflated system

\[
P(u_1)=P_u(u_1)=P(u_2)=P_u(u_2)=0
\]

has unit Jacobian determinant and every gate is a unit. Multivariate Hensel
therefore gives a \(\mathbf Q_{101}\)-point with two distinct double roots,
\(s_1=H=0\), and

\[
(H,P,P_u,s_1):
(\ell P_{uu}C\delta G)^\infty\ne(1)
\]

over \(\mathbf Q\). No algebraic-number reconstruction is needed to prove this.

Consume marker:

```text
T9-HENSEL-NONUNIT-SEALED
T8-S1-NONUNIT-ANALYTIC
```

## 1.2 The target branch has a divisorial ordinary-binodal locus

At the Hensel point, the two critical values

\[
h_i(x)=P(x,u_i(x))
\]

have independent differentials and

\[
H=\text{unit}\cdot h_1h_2.
\]

Thus, after a finite extension of \(\mathbf Q_{101}\),

\[
\widehat{\mathcal O}_{B,z}
\simeq K'[[x,y,z_1,z_2]]/(xy).
\]

The ordered-double-root incidence is smooth of dimension two and separates the
two branches. Since normality is preserved under the regular extension
\(\mathbf Q\to\mathbf Q_{101}\), the target branch \(B\) is nonnormal over
\(\mathbf Q\). The singular locus of \(B\) has a two-dimensional component.

This concerns the **target branch**. It does not decide normality of the fold
algebra \(S_G\).

## 1.3 Ordinary binodal gluing contributes no 3-primary local Picard defect

After splitting the two branches, the completed node is the conductor fibre
product

\[
A=B_1\times_D B_2,
\qquad
B_1=K'[[x,z_1,z_2]],\quad
B_2=K'[[y,z_1,z_2]],\quad
D=K'[[z_1,z_2]].
\]

On punctured spectra, \(B_1,B_2,D\) are factorial and have trivial Picard
group. The conductor Mayer–Vietoris sequence has unit map

\[
B_1^\times\times B_2^\times\times D^\times
\longrightarrow D^\times\times D^\times,
\qquad
(u_1,u_2,d)\mapsto(u_1|_D/d,u_2|_D/d),
\]

which is surjective because \(B_i^\times\to D^\times\) is surjective. Hence the
split ordinary node contributes no local Picard class. If the two branches are
exchanged before a quadratic separable extension, restriction–corestriction is
multiplication by two, so the original local Picard group has no odd-primary
torsion. In particular, the binodal conductor itself contributes no
3-primary defect.

**CAS consequence:** do not spend the next round reconstructing a global
binodal closed point solely to analyze its local class group. The remaining
3-primary dangers are:

- additional height-one defects of the fold normalization;
- cubic-discriminant contacts of order divisible by three;
- residual codimension-two or codimension-three local Picard defects.

## 1.4 Scope of `P25Z-ROW-RANK-746`

The unisolvence packet proves exactly

\[
\operatorname{rank}_{\mathbf F_{89}}\Lambda_{89}=746.
\]

Therefore the 746 rows are the **complete special-fibre landing ideal** at the
fixed \(p=89\) DVR model.

It does **not** by itself prove

\[
\operatorname{rank}_{K}\Lambda_K=746
\]

in characteristic zero: rank may drop under reduction. The generic rank is at
least 746. The historical 842 packet cannot be the direct \(p=89\) row space;
it remains retired operationally. A characteristic-zero rank assertion needs a
separate exact certificate.

For P25 emptiness, no characteristic-zero row-rank certificate is needed:
empty special fibre implies empty generic fibre by the sealed DVR properness
argument.

## 1.5 Exact degree-four closure criterion for the P25 finite module

Let

\[
S=\mathbf F_{89}[q_0,\ldots,q_{36}],
\qquad
F=S\oplus S(-1)^6\oplus S(-2)^{21},
\]

and let \(N_0\subset F\) be generated by the 690 homogeneous degree-three seed
relations. The six multiplication operators \(T_i\) have degree one.

The following finite criterion is sufficient for the sealed 690-row
presentation to be exact:

1. for every seed \(s_a\) and every \(i\),
   \[
   T_i(s_a)\in (N_0)_4;
   \]
2. for every basis vector \(b\in1\oplus K\oplus\operatorname{Sym}^2K\) and every
   \(i<j\),
   \[
   (T_iT_j-T_jT_i)b\in(N_0)_4.
   \]

Indeed, condition 1 makes \(N_0\) \(T_i\)-stable because it is generated over
\(S\) by the seeds. Condition 2 makes the induced operators commute on
\(F/N_0\). The monic \(K^3\) reduction then defines mutually inverse maps

\[
F/N_0\rightleftarrows R/J.
\]

Thus the entire closure question is an exact **degree-four graded membership
problem**. Random fibre tests are not a substitute.

## 1.6 Kernel-incidence criterion for P25 emptiness

Let \(M(q)\) be the exact \(690\times28\) seed-relation matrix. For
\(q\ne0\),

\[
(F/N_0)_q\ne0
\iff
\operatorname{rank}M(q)<28
\iff
\exists\,0\ne b\in\mathbf P^{27}:M(q)b=0.
\]

Write

\[
b=(b_0,b_1,b_2)
\]

according to basis degree \(0,1,2\). Assign the bigrading

\[
\deg q_i=(1,0),\qquad
\deg b_0=(0,1),\qquad
\deg b_{1,j}=(1,1),\qquad
\deg b_{2,j}=(2,1).
\]

Every equation in \(M(q)b=0\) then has bidegree \((3,1)\). The projective
kernel incidence is the corresponding multihomogeneous scheme saturated by the
\(q\)-irrelevant and \(b\)-irrelevant ideals.

Any deterministic linear compression of the 690 equations gives a **weaker**
system containing the true incidence. Therefore:

```text
compressed incidence empty  ==>  seed incidence empty
                              ==>  full special landing scheme empty.
```

A nonempty compressed incidence proves nothing until the point is checked
against all 690 seed rows and all 746 landing cubics.

## 1.7 Ten-coordinate-pair criterion for divisorial fold singularities

Let

\[
I_{\rm sing}=(P,P_u,P_A,P_B,P_Y,P_Z)
\]

in \(\mathbf Q[A,B,Y,Z,u]\), localized at the exact common gates. The fold has
dimension three. A codimension-one singular component has dimension two.

Because its function field is generated by the five coordinate functions
\(A,B,Y,Z,u\), some pair among these five is algebraically independent on every
two-dimensional component. Hence:

\[
\dim V(I_{\rm sing})\le1
\]

on the open if and only if, for **all ten coordinate pairs** \((x_i,x_j)\), the
generic fibre of the singular ideal over

\[
\mathbf Q(x_i,x_j)
\]

is empty after gate saturation.

Conversely, a nonempty generic fibre for one pair gives a finite algebra over
\(\mathbf Q(x_i,x_j)\) and a two-dimensional singular component.

This replaces the failed full five-variable saturation and avoids all invalid
affine-section dimension arguments.

## 1.8 Two-generator compression for `A_proj`

A central simple algebra of degree six over an infinite field is generated by a
generic pair of elements. For this project, it is enough to exhibit two fixed
linear combinations \(a,b\) of the 36 Reynolds-frame elements such that the
span of words in \(a,b\) has rank 36 at one good integral specialization. A
unit word-basis determinant then proves that the same pair generates the generic
algebra on the corresponding open.

Consequently, an executable regular representation can be installed from the
two left-multiplication matrices

\[
L_a,L_b\in\operatorname{Mat}_{36}(K_{\rm proj}),
\]

rather than reconstructing all \(36^3\) structure constants independently.
Once a word basis is fixed, all multiplication is recovered by matrix products
and basis reduction.

---

# 2. Binding status corrections

1. `T9-HENSEL-NONUNIT-SEALED` is accepted. Do not reopen the \(s_1\)-unit route.
2. `T-BRANCH-NONNORMAL` concerns the target branch, not the fold algebra.
3. Ordinary binodal gluing is harmless for 3-primary local Picard data.
4. `P25Z-ROW-RANK-746` is exact over \(\mathbf F_{89}\). Do not silently call it
   the characteristic-zero rank.
5. The 746 rows are nevertheless the complete special-fibre landing ideal.
6. `P25Z-FINITE-PRESENTATION-LOWER` is binding. The 690 seed rows generate a
   submodule of the true relation module; random specialized closure is not a
   proof over \(S\).
7. The historical 842-row and rank-28 packets may not be imported.
8. Repeating the same 54.6-GiB degree-four F4/Macaulay calculation is forbidden.
9. Picard rank one excludes fibrations as morphisms on the prime \(F_{14}\)
   model, not birational links after modification.
10. No auxiliary Morita projector is a Fano point.

---

# 3. Track T10 — normal fold and the 3-primary target-branch obstruction

## T10.0 — seal the binodal 3-primary local lemma

Produce a small exact note/verifier packet recording:

- the conductor square for the split ordinary node;
- surjectivity of the unit map;
- vanishing of the split punctured Picard group;
- the degree-two restriction–corestriction argument for the unsplit case.

This is an analytic replay packet. No large CAS job is authorized.

Deliverables:

```text
certificates/target_branch_t10/
  BINODAL_ODD_PRIMARY.md
  verify_binodal_local_model.py
```

Exit:

```text
T10-BINODAL-NO-3-DEFECT
```

## T10.1 — decide `R_1` of the fold by ten generic fibres

Work on

\[
S_G=
\left(\mathbf Q[A,B,Y,Z,u]/(P,P_u)\right)
[(\ell P_{uu}C\delta G)^{-1}].
\]

For each pair in

```text
(A,B), (A,Y), (A,Z), (A,u),
(B,Y), (B,Z), (B,u),
(Y,Z), (Y,u), (Z,u)
```

perform the following.

1. Treat the pair as independent transcendental parameters.
2. Work over the rational function field in those parameters.
3. Form the singular ideal
   \[
   (P,P_u,P_A,P_B,P_Y,P_Z)
   \]
   in the remaining three variables.
4. Saturate factorwise by all gates, including the exact quotient circuit for
   \(G\).
5. Decide whether the generic fibre is empty.
6. If nonempty, produce a finite algebra/RUR over the parameter field and
   verify all gates exactly.

Use modular discovery first, then exact characteristic-zero reconstruction.
No affine linear section is a dimension proof.

### Exits

- `T10-FOLD-NORMAL`: all ten generic fibres are empty. Since the fold is \(S_2\)
  and has no two-dimensional singular component, it is \(R_1\), hence normal.
- `T10-FOLD-HEIGHT1`: one pair yields a verified nonempty generic fibre. Seal the
  corresponding two-dimensional singular component and its generic local model.
- `T10-FOLD-UNDECIDED`: list the unresolved coordinate pairs and exact resource
  floor.

The independent verifier must re-run at least one empty and every nonempty pair
without importing the producer.

## T10.2 — install the normalization of the target branch

### If `T10-FOLD-NORMAL`

1. Prove the finite birational map \(S_G\to B_G\) identifies \(S_G\) with the
   normalization of \(B_G\).
2. Compute the conductor \(\mathfrak c_{B\subset S}\).
3. Verify that the ordinary-binodal component is one conductor component and
   that its local gluing contributes no 3-primary defect.

### If `T10-FOLD-HEIGHT1`

1. Normalize each additional height-one defect of \(S_G\).
2. Construct the full normal base \(\widetilde B\).
3. Keep \(\mathfrak c_{B\subset S}\) and
   \(\mathfrak c_{S\subset\widetilde B}\) distinct.

Deliverables:

```text
certificates/target_branch_t10/
  NORMAL_BASE.md
  conductor_components.json
  normalization_presentation.*
  verify_normal_base.*
```

## T10.3 — compute only the 3-primary discriminant-contact ledger

On the installed normal base \(\widetilde B\):

1. pull back the fixed-frame cubic family;
2. factor the cubic discriminant in codimension one;
3. compute every contact multiplicity modulo three;
4. compute the 3-primary part of every codimension-two local class group;
5. audit residual codimension-three punctured Picard groups or prove the needed
   parafactoriality;
6. assemble
   \[
   (\operatorname{Cl}/\operatorname{Pic})[3]
   \]
   and the horizontal degree subgroup.

Do not recompute ordinary Picard data already sealed. Do not spend resources on
2-primary binodal gluing.

Complete exit:

```text
T10-INDEX3
```

requires

\[
\deg_{\rm horiz}=3\mathbf Z.
\]

This is consumed by the accepted negative headline bridge.

---

# 4. Track P25W — exact degree-25 support

## P25W.0 — preserve the field scope of the row-rank certificate

Create a short correction/status record:

```text
rank over F_89 = 746 exactly
characteristic-zero rank = not yet decided
complete p=89 special landing ideal = the 746 rows
```

No producer work is needed beyond replay.

## P25W.1 — close the finite presentation in degree four

Construct the degree-four component

\[
(N_0)_4=S_1(N_0)_3.
\]

Test exactly:

1. all \(6\cdot690\) elements \(T_i(s_a)\);
2. all nonzero commutator defects
   \((T_iT_j-T_jT_i)b\).

Each test is membership in the finite-dimensional \(\mathbf F_{89}\)-vector
space \((N_0)_4\). Use the block grading and the existing Q/K monomial layout;
do not repeat the full 43-variable F4 computation.

### Exits

- `P25W-PRESENTATION-EXACT`: every degree-four test passes; seal
  \(F/N_0\simeq R/J\).
- `P25W-PRESENTATION-ENLARGE`: list the failed vectors, append them as true
  relations, and write the next finite closure round.
- `P25W-PRESENTATION-UNDECIDED`: exact degree-four matrix dimensions and resource
  floor.

A specialized fibre test is not an accepted exit.

## P25W.2 — multigraded kernel-incidence emptiness test

Use the certified lower presentation matrix \(M(q)\), even if P25W.1 is still
open. Its support contains the true landing support, so emptiness is safe.

### Stage A — linear top block

First test the stratum \(b_0=b_1=0\), where only the 21 quadratic-basis dual
variables remain. This is a bilinear rank-one-tensor incidence. Decide its
multihomogeneous saturation exactly.

### Stage B — full kernel incidence

Form

\[
I_{\rm ker}=\langle M(q)b\rangle
\]

with the bigrading in §1.6. Saturate by both irrelevant ideals.

Before a full 690-equation solve, use deterministic exact row compressions:

1. choose 64, then 72, then 84 deterministic linear combinations of the 690
   equations;
2. compute the multihomogeneous saturated ideal of each compressed system;
3. stop immediately if one compressed system is empty.

Because compression weakens the equations, an empty compressed incidence is a
valid certificate for the full system.

### Exact exits

- `P25-DEGREE25-EMPTY`: a compressed or full kernel incidence is empty after
  exact irrelevant saturation. By the fixed DVR properness theorem, the
  characteristic-zero degree-25 landing scheme is empty. This is a scoped
  degree-25 exclusion, not a headline negative theorem.
- `P25W-SUPPORT-POINT`: produce a point satisfying all 690 seed equations and
  all 746 complete special-fibre landing cubics.
- `P25W-SUPPORT-UNDECIDED`: smallest compressed system not decided and resource
  floor.

### Survivor branch

For every true support point:

1. verify all 746 cubics directly;
2. compute the Jacobian of the complete special-fibre landing scheme;
3. if smooth, Hensel-lift in the fixed DVR model;
4. verify \(F(p_c)\equiv0\), primitivity, and generic Jacobian rank four over
   characteristic zero.

Only then claim:

```text
P25-COVARIANT
```

which closes the headline positively.

## P25W.3 — optional characteristic-zero landing rank

This is not a gate for P25W.2.

To determine the generic rank of \(\Lambda\):

1. reproduce exact unisolvent ranks at additional good primes, including
   \(199\) and \(353\);
2. reconstruct a characteristic-zero image or kernel basis over
   \(K=\mathbf Q(\zeta_{11})\) by multiprime CRT;
3. certify the upper bound by exact substitution/congruence and a holdout prime.

Acceptable exits:

```text
P25W-RANK-K-746
P25W-RANK-K-GT746
P25W-RANK-K-UNDECIDED
```

Do not use this task to delay the support calculation.

---

# 5. Track C2 — two-generator Fano descent

## C2.0 — find a unit two-generator word basis

At the certified \(p=23\) split witness:

1. search deterministic pairs \(a,b\) in the 36 Reynolds-frame algebra;
2. enumerate words in \(a,b\) until 36 independent matrices are obtained;
3. choose a canonical word basis and seal its determinant;
4. verify the same pair at at least one additional good split prime.

Exit:

```text
C2-TWO-GENERATORS-MODULAR
```

## C2.1 — reconstruct only `L_a` and `L_b` over `K_proj`

Using the executable rank-12 model of \(K_{\rm proj}\):

1. compute modular left-multiplication matrices for \(a,b\) at many good
   parameter specializations and split primes;
2. reconstruct
   \[
   L_a,L_b\in\operatorname{Mat}_{36}(K_{\rm proj});
   \]
3. reconstruct the word-basis change matrix;
4. verify exact multiplication identities, the minimal/characteristic
   polynomials of \(a,b\), and a holdout specialization.

The full algebra is then the subalgebra of \(\operatorname{End}(K_{\rm proj}^{36})\)
generated by \(L_a,L_b\). Do not reconstruct 46656 independent constants unless
this compressed route fails.

Exit:

```text
C2-APROJ-EXECUTABLE
```

## C2.2 — involution, Morita corner, and five Hermitian matrices

After `C2-APROJ-EXECUTABLE`:

1. reconstruct the symplectic involution \(\sigma\);
2. construct a certified self-adjoint reduced-rank-two idempotent \(e\);
3. compute
   \[
   D=eA_{\rm proj}e=(a_D,b_D)_{K_{\rm proj}};
   \]
4. choose a right-\(D\) basis of the Morita module;
5. transport the aligned five-plane to
   \[
   h_1,\ldots,h_5\in\operatorname{Herm}_3(D);
   \]
6. independently construct restricted Plücker equations after splitting;
7. verify the split fibre has dimension three, degree fourteen, and is smooth.

Exit:

```text
C2-FANO-MODEL
```

## C2.3 — common-isotropic-line search

Search the genuine system

\[
h_r(q,q)=0,\qquad r=1,\ldots,5,
\]

on all quaternionic charts. Structural searches on birational modifications or
Gal-stable centres are allowed; morphism-fibration searches on the prime model
and odd-degree Brauer-splitting searches are closed.

Complete exit:

```text
C-FANO-POINT
```

which closes the headline positively through the accepted bridge.

---

# 6. Lower-priority tracks

## S19 — marked degree-19 Schur curve

Do not restart primitive-element/Krylov elimination. The only authorized next
interface is the universal hyperplane family and the two marked Quot/Rao
branches. No worker is dispatched this round unless T10, P25W, and C2 all stop.

## KLS — minimality/conductor

CAS remains conditional on an analytic theorem reducing minimal primitive
covariants to a finite list of conductor configurations. No broad sweep is
authorized.

---

# 7. First dispatch

Run in parallel under path-scoped write fences.

```text
Worker T:
  T10.0;
  modular discovery for all ten T10.1 coordinate pairs;
  exact characteristic-zero solve for the cheapest decisive pairs.

Worker P:
  P25W.1 degree-four closure test;
  P25W.2 Stage A and compressed-incidence preflight.

Worker C:
  C2.0 two-generator modular word basis;
  preflight C2.1 reconstruction of L_a,L_b.

Worker R:
  P25W.3 additional-prime exact row ranks and characteristic-zero rank preflight.
```

One memory-heavy job may run at a time. The first heavy slot goes to a T10
coordinate-pair solve that has a credible exact matrix floor; otherwise it goes
to the smallest P25W compressed-incidence system. Repeating the old raw F4 job
is forbidden.

---

# 8. Verification rules

1. Every producer has an independent verifier that does not import the producer.
2. The verifier recomputes the decisive rank, saturation, membership, or point.
3. Random fibres are discovery only.
4. Empty solver output is a failed run, not an empty scheme.
5. Affine sections are not dimension certificates.
6. A modular rank is not silently promoted to characteristic zero.
7. Every reconstructed object receives a final congruence check and exact
   substitution check.
8. Prime 67 is never the sole decision fibre.
9. Historical 842/rank-28 artifacts are not inputs.
10. A nonempty lower-presentation support point is not a landing covariant until
    all 746 special equations and the characteristic-zero identity are checked.
11. A measured `UNDECIDED` exit with a named bottleneck is successful work.
12. Workers do not edit shared narrative files and do not run git.

---

# 9. Exit table

| Exit | Meaning | Headline consequence |
|---|---|---|
| `T10-FOLD-NORMAL` | fold is the normal base after the binodal normalization | continue mod-3 ledger |
| `T10-FOLD-HEIGHT1` | additional height-one fold defect installed | normalize it, then continue |
| `T10-INDEX3` | horizontal degree subgroup remains \(3\mathbf Z\) | headline negative |
| `P25W-PRESENTATION-EXACT` | exact 28-generator finite-module presentation | support can be interpreted both ways |
| `P25-DEGREE25-EMPTY` | complete special degree-25 landing scheme empty | scoped exclusion only |
| `P25-COVARIANT` | exact primitive dominant landing covariant | headline positive |
| `C2-FANO-MODEL` | executable genuine twisted Fano section | continue point search |
| `C-FANO-POINT` | exact common isotropic line / Fano point | headline positive |
| `*-UNDECIDED` | exact bottleneck and resource floor | no headline claim |

**Problem E remains OPEN.**
