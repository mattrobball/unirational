# Problem E — T11 / P25V / C3 CAS work order after the T10 and C2 return

**Repository:** `mattrobball/unirational`  
**Pinned base:** `4da9f8f0c8f4a8bed38517f4f42d55b371e6595d`  
**User-supplied checkpoint:** `dbd27e62936cc0576ce9a9a049b9316f6433fcb3`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** exact CAS production and independent verification only  
**Headline:** **OPEN**

---

# 0. Purpose and supersession

The repository advanced six commits beyond the user-supplied checkpoint before
this order was written.  This order consumes the verified returns from
`T10`, `P25W.3`, `C2.0`, and `C2.1`.  It supersedes
`WORKORDER_CAS_T10_P25W_C2.md` for new execution.  Older work orders,
`REPAIR.md`, and sealed packets remain binding at their corrected theorem
boundaries.

The latest round changed the tactical picture:

1. **Fold / target route.**  Every coordinate-pair probe has a nonempty
   gate-saturated modular fibre, with the cheapest `(A,u)` fibre of degree six.
   This is strong evidence for a divisorial singular locus of the fold, but a
   special fibre is not a generic-function-field certificate.  The next task is
   a **local complete-intersection chart** or a finite algebra over
   `Q(A,u)`, not another blind full-gate saturation.
2. **Degree 25.**  The direct special-fibre landing row space is exactly 746 at
   `p=89`, and also has rank 746 at `p=199,353`.  Characteristic-zero rank is
   still unnecessary for the emptiness route.  The next tasks are the exact
   degree-four closure of the 28-generator module and a multigraded
   kernel-incidence emptiness certificate.
3. **Twisted Fano.**  The two-generator route is viable, but entrywise
   reconstruction in the shortlex 36-word basis still leaves roughly 1,249
   varying entries of degree at least five.  The next compression is to a
   maximal étale algebra and a six-dimensional module over it.

Priority order:

| Priority | Track | Exact target |
|---:|---|---|
| **1** | `T11` | prove or refute a horizontal two-dimensional singular component of the fold, then classify its local normalization and continue the mod-3 ledger |
| **2** | `P25V` | decide the exact degree-25 special-fibre support via degree-four module closure and multigraded kernel incidence |
| **3** | `C3` | install the genuine projective algebra through a maximal-étale/right-module compression, then the common-isotropic-line system |

The marked Schur degree-19 route and KLS remain lower-priority.  Universal Path
G, Path A elimination, the historical 842/rank-28 packets, raw degree-four F4
on all 43 coefficient variables, and further free-fibre degree ladders are not
authorized.

---

# 1. Binding analytic results

## 1.1 Target branch and binodal local class group

Consume without re-derivation:

```text
T9-HENSEL-NONUNIT-SEALED
T8-S1-NONUNIT-ANALYTIC
T-BRANCH-NONNORMAL
T10-BINODAL-NO-3-DEFECT
```

The target branch `B` has a divisorial ordinary-binodal locus.  After splitting
its two branches, the completed local ring is

\[
K'[[x,y,z_1,z_2]]/(xy),
\]

and the conductor Mayer–Vietoris sequence shows that this ordinary node
contributes no 3-primary local Picard class.  This says nothing by itself about
normality of the fold algebra `S_G`.

## 1.2 Current fold status

The fold algebra on the exact common open is a three-dimensional complete
intersection and satisfies `S_2`.  The singular ideal is

\[
I_{\rm sing}=(P,P_u,P_A,P_B,P_Y,P_Z)
\subset \mathbf Q[A,B,Y,Z,u],
\]

localized away from

\[
\ell\,P_{uu}\,C\,\delta\,G.
\]

The exact upper bound

\[
\dim \operatorname{Sing}(S_G)\le2
\]

is retained.  The ten modular coordinate-pair fibres are discovery only; no
`T10-FOLD-HEIGHT1` theorem has yet been sealed.

## 1.3 Local chart criterion for a horizontal fold-singular surface

Let the five coordinates be split as

\[
(x_1,x_2;y_1,y_2,y_3),
\]

where `(x_1,x_2)` is one of the ten coordinate pairs.  Let
`g_1,g_2,g_3` be three elements of `I_sing`.  Suppose that on a localization by
all gates and by

\[
\Delta=\det\frac{\partial(g_1,g_2,g_3)}
{\partial(y_1,y_2,y_3)}
\]

one proves the exact ideal equality

\[
(I_{\rm sing})_{\Delta}=(g_1,g_2,g_3)_{\Delta}.
\tag{T-chart}
\]

Then the singular locus is étale over the `(x_1,x_2)`-plane on that chart and
has a horizontal smooth component of relative dimension two.  In particular,
its characteristic-zero fibre has dimension two, so the three-dimensional fold
fails `R_1` and is nonnormal.

**Proof.**  The nonzero Jacobian minor makes
`V(g_1,g_2,g_3)` smooth and étale over the coordinate plane by the Jacobian
criterion.  Equality `(T-chart)` identifies the full singular scheme with this
smooth chart.  Its generic fibre therefore has dimension two.  Since `S_G` is
three-dimensional, the singular component has codimension one.  A normal
Noetherian scheme satisfies `R_1`, so `S_G` is not normal.  ∎

The equality may be proved either by exact localized ideal membership over
`Q(x_1,x_2)`, or by a finite algebra over that function field together with
exact normal forms of the remaining generators.

A nonempty *specialized* fibre without `(T-chart)` does not prove a horizontal
component.

## 1.4 Generic-coordinate-pair criterion

Every two-dimensional component of the fold singular locus admits at least one
algebraically independent pair among `A,B,Y,Z,u`.  Therefore one exact nonempty
finite generic fibre over any one field

\[
\mathbf Q(x_i,x_j)
\]

proves a two-dimensional component; exact emptiness for all ten proves
`R_1`.  The cheapest modular signature is `(A,u)`, degree six.

## 1.5 P25 special-fibre landing ideal

Consume:

```text
P25Y-DVR-PASS
P25Z-ROW-RANK-746
P25W-RANK-K-UNDECIDED
P25Z-FINITE-PRESENTATION-LOWER
```

At `p=89`, the 746 rows are the complete direct landing ideal.  This follows
from the 2343-dimensional invariant basis and an invertible unisolvent
`2343 x 2343` evaluation matrix.  The same rank at `p=199,353` is evidence for
characteristic-zero rank 746, but is not promoted.

Characteristic-zero row rank is not needed for special-fibre emptiness:
projectivity of the fixed DVR landing scheme gives

\[
Z_{\mathbf F_{89}}=\varnothing
\Longrightarrow
Z_K=\varnothing.
\]

## 1.6 Exact degree-four closure criterion

Put

\[
S=\mathbf F_{89}[q_0,\ldots,q_{36}],
\qquad
F=S\oplus S(-1)^6\oplus S(-2)^{21},
\]

and let `N_0` be generated by the 690 homogeneous degree-three seed relations.
The six multiplication operators `T_i` have degree one.

The lower presentation is exact if both finite tests hold:

\[
T_i(s_a)\in(N_0)_4
\quad\text{for every seed }s_a,
\tag{P-closure-1}
\]

and

\[
(T_iT_j-T_jT_i)b\in(N_0)_4
\quad	ext{for all }i<j,\ b\in\mathcal B,
\tag{P-closure-2}
\]

where

\[
\mathcal B=1\oplus K\oplus\operatorname{Sym}^2K.
\]

If these hold, `N_0` is `T`-stable and the induced `T_i` commute, so monic
`K^3` reduction gives

\[
F/N_0\simeq R/J.
\]

This is a degree-four graded membership computation, not a full module Gröbner
basis in 37 parameters.

For **emptiness**, exact closure is not required: because

\[
F/N_0\twoheadrightarrow R/J,
\]

one has

\[
\operatorname{Supp}(R/J)
\subseteq
\operatorname{Supp}(F/N_0).
\]

Thus empty support of the lower module already proves empty landing support.

## 1.7 Multigraded kernel-incidence criterion

Let `M(q)` be the `690 x 28` seed matrix.  For `q != 0`,

\[
(F/N_0)_q\ne0
\iff
\exists\,0\ne b\in\mathbf P^{27}:M(q)b=0.
\]

Split `b` according to basis degree and assign

\[
\deg q_i=(1,0),
\quad
\deg b_0=(0,1),
\quad
\deg b_{1,j}=(1,1),
\quad
\deg b_{2,j}=(2,1).
\]

Every equation of `M(q)b=0` has bidegree `(3,1)`.  The true projective kernel
incidence is saturated by both irrelevant ideals.

For any deterministic row-compression matrix `C`,

\[
M(q)b=0\Longrightarrow C M(q)b=0.
\]

Therefore

```text
compressed incidence empty
    => seed incidence empty
    => complete p=89 landing scheme empty
    => characteristic-zero degree-25 landing scheme empty.
```

A surviving compressed point proves nothing until checked against all 690 seed
relations and all 746 landing cubics.

## 1.8 Maximal-étale compression for the projective algebra

Let `A` be a central simple algebra of degree six over an infinite field `K`.
Let `a in A` have separable minimal polynomial of degree six, and put

\[
E=K[a].
\]

Then `E` is a maximal étale subalgebra and `A` is free of rank six as a right
`E`-module.  If

\[
1,b,b^2,\ldots,b^5
\]

is a right `E`-basis, then

\[
\{b^j a^i:0\le i,j<6\}
\]

is a `K`-basis of `A`.

In this basis, every left multiplication operator is a `6 x 6` matrix over
`E`.  In particular:

- `L_b` is a companion matrix over `E`, determined by the single relation
  \[
  b^6=\sum_{j=0}^5 b^j e_j,
  \qquad e_j\in E;
  \]
- `L_a` is a `6 x 6` matrix over `E`;
- `E` itself is represented by the degree-six minimal polynomial of `a`.

Thus one needs at most 42 elements of `E` plus the six minimal-polynomial
coefficients, rather than 2,592 independent `K`-entries or the historical
46,656 structure constants.

**Proof.**  A maximal étale subalgebra of a degree-six CSA has dimension six,
so `dim_E A=6`.  The assumed powers of `b` form an `E`-basis, giving the stated
`K`-basis after expanding in `1,a,...,a^5`.  Left multiplication commutes with
right multiplication by `E`, hence lies in `End_E(A_E)=Mat_6(E)`.  The formula
for `L_b` follows from the power basis.  ∎

A nonzero determinant at one good integral specialization proves that the same
basis is valid on a nonempty generic open.

---

# 2. Binding corrections and prohibitions

1. The user-supplied `dbd27e6` is not the current repository head; this order is
   pinned to `4da9f8f` and consumes the intervening verified packets.
2. The target branch is nonnormal.  Normality of the fold remains undecided.
3. Modular nonempty coordinate fibres are discovery, not generic-function-field
   theorems.
4. Do not expand the full gate product.  Saturate factorwise or certify each
   gate by its norm in a finite algebra.
5. `P25Z-ROW-RANK-746` is exact at `p=89`, not yet a characteristic-zero rank
   theorem.
6. Do not spend the heavy slot on characteristic-zero rank unless P25 support
   survives and requires it.
7. `P25Z-FINITE-PRESENTATION-LOWER` remains binding until exact degree-four
   membership closes it.
8. Do not repeat the 54.6-GiB raw degree-four F4/Macaulay calculation in 43
   variables.
9. Do not import the historical 842-row or historical rank-28 packets.
10. C2.1's low-degree interpolation failure does not justify reconstructing the
    full 36-word regular representation entry by entry.  Use the maximal-étale
    compression first.
11. Prime 67 is never the sole decision fibre.
12. Empty solver output is a failed run, not an emptiness certificate.
13. Every positive candidate is substituted into the original equations.

---

# 3. Track T11 — horizontal fold-singular component and local normalization

## T11.0 — select and certify a simple modular point

Use the cheapest pair `(A,u)` at `p=101`.

1. Recompute the gate-saturated zero-dimensional fibre at the sealed values
   `(A,u)=(63,35)`.
2. Extract every geometric point over a suitable finite extension of
   `F_101`.
3. At each point compute:
   - all gates;
   - the full `6 x 5` Jacobian of
     `(P,P_u,P_A,P_B,P_Y,P_Z)`;
   - every `3 x 3` minor in the `(B,Y,Z)` columns;
   - local multiplicity of the specialized fibre.
4. Select a point at which:
   - every gate is nonzero;
   - some `3 x 3` minor is nonzero;
   - the specialized local algebra is reduced of multiplicity one.

If no such point exists at `(63,35)`, repeat at the other points in the ten-pair
ledger, prioritizing degree `<=12`.

Deliverables:

```text
certificates/fold_t11/
  MODULAR_SIMPLE_POINT.md
  modular_point.json
  verify_modular_point.py
```

Exit:

```text
T11-MODULAR-SIMPLE-POINT
```

This is discovery plus a certified Hensel chart; it is not yet
`T11-FOLD-HEIGHT1`.

## T11.1 — exact local-chart or generic-fibre certificate

Run after `T11-MODULAR-SIMPLE-POINT`.

Let `g_1,g_2,g_3` be the three singular equations giving the nonzero Jacobian
minor at the selected point.

### Preferred route A: localized ideal equality

1. Work over `Q(A,u)` in variables `(B,Y,Z)`.
2. Compute a Gröbner or triangular basis of
   \[
   J=(g_1,g_2,g_3).
   \]
3. Factor/select the component reducing to the chosen modular point.
4. Reduce the remaining three singular equations modulo the selected component.
5. Prove their normal forms are zero.
6. Prove every gate and the Jacobian minor is nonzero in the finite algebra by
   computing its norm or inverse.
7. Output the exact finite `Q(A,u)`-algebra and its dimension.

### Route B: direct full generic fibre

Compute the saturated full ideal over `Q(A,u)` using separate gate inversions,
not an expanded product.  A nonzero finite algebra is sufficient.

### Route C: exact localized syzygies

Produce exact identities

\[
D^N f=\sum_{i=1}^3 a_i g_i
\]

for each remaining singular generator `f`, where `D` is the product of the
Jacobian minor and the individually named gates.  The identities must be
verified by direct expansion or circuit evaluation.

### Exits

- `T11-FOLD-HEIGHT1`: exact horizontal two-dimensional singular component;
- `T11-PAIR-EMPTY`: the chosen generic fibre is empty despite the modular
  special fibre;
- `T11-FOLD-UNDECIDED`: smallest exact blocker and measured floor.

A `T11-FOLD-HEIGHT1` exit plus the accepted `S_2` theorem proves that the fold is
nonnormal.

### Resource policy

Exploratory ceiling: 8 GiB.  One preflighted job up to 64 GiB is authorized for
this track and has first claim on the heavy slot.  Before launch record:

```text
selected equations
term counts
field representation
expected finite degree
factor-selection method
checkpoint plan
independent verifier
```

## T11.2 — classify the generic height-one local model

Run after `T11-FOLD-HEIGHT1`.

1. On the finite `Q(A,u)`-algebra, solve `P_u=0` locally for `u` where
   `P_uu` is a unit and form the local critical-value function `h` on the four
   base parameters.
2. Construct the generic two-dimensional critical surface.
3. Compute the Hessian of `h` on the two-dimensional normal bundle.
4. Decide whether its determinant is a unit.
5. If yes, seal the formal Morse–Bott model
   \[
   h=xy
   \]
   after at most a quadratic étale extension, and apply the accepted
   no-odd-primary conductor lemma.
6. If the transverse Hessian degenerates, compute the first nonzero residual
   term and its contact multiplicity modulo three.
7. Enumerate every height-one component of the fold singular locus, using the
   ten coordinate-pair models to prove exhaustiveness.

Exits:

```text
T11-FOLD-MORSE-BOTT-NO-3
T11-FOLD-DANGEROUS-3-CONTACT
T11-FOLD-HEIGHT1-LIST
```

## T11.3 — continue the target-branch mod-3 ledger

Once a normal base is installed by normalization of every height-one defect:

1. pull back the fixed-frame cubic family;
2. factor its discriminant in codimension one;
3. compute every contact order modulo three;
4. compute codimension-two local class groups at the dangerous contacts;
5. audit residual codimension-three punctured Picard groups;
6. assemble the horizontal degree subgroup.

Complete negative exit:

```text
T11-INDEX3
```

requires

\[
\deg_{\rm horiz}=3\mathbf Z.
\]

---

# 4. Track P25V — degree-four closure and multigraded support

## P25V.0 — exact degree-four closure

Build the degree-four graded target space

\[
F_4=S_4\oplus S_3^6\oplus S_2^{21}
\]

with sparse block coordinates.  Construct `(N_0)_4` from the `37 x 690`
products `q_j s_a`.

Test exact membership of:

1. all `6 x 690` vectors `T_i(s_a)`;
2. all commutator defects
   \[
   (T_iT_j-T_jT_i)b,
   \quad i<j,\ b\in\mathcal B.
   \]

Requirements:

- one reusable sparse echelon/Krylov solver for `(N_0)_4`;
- no random specialization as proof;
- store explicit coefficient witnesses or independently replayable zero
  remainders;
- if a defect is not in `(N_0)_4`, add it to the relation module and repeat
  closure until stable.

Exits:

```text
P25V-PRESENTATION-EXACT
P25V-PRESENTATION-ENLARGED
P25V-CLOSURE-UNDECIDED
```

The emptiness track below may run on the lower presentation even if closure is
undecided.

## P25V.1 — deterministic compressed kernel incidence

Construct the exact bihomogeneous incidence

\[
M(q)b=0
\subset
\mathbf P^{36}_q\times\mathbf P^{27}_b.
\]

Run deterministic row compressions in this order:

```text
64 rows
72 rows
84 rows
```

Use fixed published seeds and store the compression matrices.  For each
compression:

1. preserve the weighted bidegree `(3,1)`;
2. saturate by both irrelevant ideals;
3. use block/multihomogeneous F4, Macaulay, or a multiprojective resultant;
4. seek one of the accepted emptiness certificates:
   - saturated unit ideal;
   - multihomogeneous irrelevant-power containment;
   - independently verified Nullstellensatz identity.

Stop at the first empty compressed incidence.  That is a rigorous degree-25
special-fibre emptiness certificate.

If a compressed system is nonempty:

1. extract exact points/components;
2. check them against all 690 seed equations;
3. then check all 746 complete landing cubics;
4. discard every compression artefact.

Exits:

```text
P25-DEGREE25-EMPTY
P25V-SPECIAL-CANDIDATE
P25V-SUPPORT-UNDECIDED
```

### Resource policy

P25V.0 and the 64-row incidence begin under 8 GiB.  P25V has second claim on the
single heavy slot, after T11.  A 64-GiB job requires a fresh preflight based on
the compressed incidence, not the forbidden 43-variable degree-four matrix.

## P25V.2 — candidate verification and lift

Run only after a point satisfies all 746 cubics.

1. compute the full Jacobian of the complete landing scheme at the point;
2. verify the point is projectively nonzero and lies in every required open;
3. if smooth over the DVR, Hensel-lift it;
4. reconstruct or retain the resulting `K_\mathfrak p` point;
5. substitute into the original covariant and verify
   \[
   F(p_c(x))\equiv0;
   \]
6. verify primitivity and generic Jacobian rank four of `p_c`.

Exit:

```text
P25-COVARIANT
```

which is consumed by the positive headline bridge.

## P25V.3 — characteristic-zero row rank (parked)

Do not reconstruct the characteristic-zero row space unless:

- a special-fibre component survives all 746 equations; and
- the lift requires a fixed generic image model.

If later needed, reconstruct the image side rather than the 13,444-dimensional
kernel side.

---

# 5. Track C3 — maximal-étale model of the genuine twisted Fano algebra

## C3.0 — modular maximal-étale and rectangular-basis search

Use the sealed pair `(a,b)=(e_1,e_2)` first, at `p=23` and `p=89`.

1. Compute the minimal polynomial of `a` and require degree six and separability.
2. Put `E=F_p[a]`.
3. Test whether
   \[
   1,b,b^2,\ldots,b^5
   \]
   is a right `E`-basis of the specialized algebra.
4. Equivalently test whether the 36 elements
   \[
   b^j a^i,
   \quad 0\le i,j<6,
   \]
   have nonzero determinant in the Reynolds frame.
5. Require the same exponent rectangle and nonzero determinant at both primes.
6. If `(e_1,e_2)` fails, search deterministic small linear combinations of the
   frame and record the first pair succeeding at both primes.

Exit:

```text
C3-RECTANGULAR-BASIS-MODULAR
```

A unit determinant at an integral specialization proves generic validity on a
nonempty open once the characteristic-zero circuit is installed.

## C3.1 — reconstruct the compressed regular representation

Using the rectangular basis, reconstruct only:

1. the degree-six minimal polynomial
   \[
   m_a(T)\in K_{\rm proj}[T];
   \]
2. the six coefficients in `E` of
   \[
   b^6=\sum_{j=0}^5 b^j e_j;
   \]
3. the `6 x 6` matrix of left multiplication by `a` over `E`.

This is at most 42 elements of `E` plus six scalar coefficients.  Express every
`E` element in the basis `1,a,...,a^5`.

Reconstruction method:

- multi-prime modular tables at primes `1 mod 11`, excluding 67;
- adaptive multivariate rational interpolation in the rank-12 `K_proj` model;
- no fixed degree cap below the C2.1 proven floor;
- final congruence check;
- at least one unused holdout prime;
- exact verification of the defining matrix identities.

Exits:

```text
C3-APROJ-EXECUTABLE
C3-RECONSTRUCTION-UNDECIDED
```

Do not fall back to the full `36^3` table.

## C3.2 — involution, Morita corner, and five Hermitian forms

After `C3-APROJ-EXECUTABLE`:

1. reconstruct the symplectic involution in the rectangular model;
2. find a self-adjoint reduced-rank-two idempotent;
3. form the corner quaternion algebra
   \[
   D=eAe;
   \]
4. produce an explicit symbol
   \[
   D=(\alpha,\beta)_{K_{\rm proj}};
   \]
5. transport the aligned five-plane to
   \[
   h_1,\ldots,h_5\in\operatorname{Herm}_3(D);
   \]
6. independently produce restricted Plücker equations after a splitting
   extension;
7. verify split dimension three, degree fourteen, and smoothness.

Exit:

```text
C3-FANO-MODEL-PASS
```

## C3.3 — common-isotropic-line search

Search the genuine system

\[
h_r(q,q)=0,
\qquad r=1,\ldots,5,
\]

on all quaternionic projective charts.  Use structural fibrations or
low-degree sections before raw elimination.  Every candidate must be substituted
into the original Hermitian equations and transported through the incidence to
the generic Klein twist.

Exit:

```text
C-FANO-POINT
```

settles the headline positively.

---

# 6. Lower-priority routes

## S19 — marked Schur degree 19

Retain the universal 55-point hyperplane family, complete relative resolution,
and the two marked Quot/Rao branches.  Do not revive primitive-element Krylov
elimination.

## KLS — minimality/conductor theorem

No CAS dispatch until the analyst supplies a finite conductor-configuration
theorem with a degree-lowering conclusion.

---

# 7. First dispatch

Run in parallel, with only one heavy slot:

```text
Worker T:
  T11.0;
  then T11.1 preflight and exact local-chart attempt.

Worker P:
  P25V.0 under 8 GiB;
  build the 64-row P25V.1 incidence and its preflight;
  wait for the heavy slot if needed.

Worker C:
  C3.0;
  if successful, C3.1 interpolation preflight and low-degree probes.

Worker A:
  independent theorem-boundary audit of every proposed exit;
  no new computation and no narrative-file edits.
```

Heavy-slot priority:

```text
T11 exact generic/local chart
then P25V compressed incidence
then C3 reconstruction
```

Workers write only to their own certificate and scratch directories and do not
run git.  Verified packets are committed and pushed path-scoped as soon as they
are accepted.

---

# 8. Verification requirements

Every packet must have an independent verifier that does not import the
producer.  The verifier must recompute the decisive invariant.

### T11

Must independently:

- reconstruct the selected modular point;
- recompute the Jacobian minor and gates;
- verify every exact generic normal form or localized membership identity;
- verify the finite algebra is nonzero.

### P25V

Must independently:

- rebuild the compressed matrix from the sealed 690 rows;
- verify the compression seed and bidegrees;
- recompute the emptiness certificate;
- check any survivor against all 690 and then all 746 equations.

### C3

Must independently:

- recompute the rectangular-basis determinant at holdout primes;
- verify every reconstructed rational function at an unused prime;
- verify the minimal polynomial and multiplication identities over
  `K_proj`.

Universal rules:

1. Modular evidence is not a characteristic-zero theorem without a valid
   lifting or reconstruction argument.
2. Empty output is not emptiness.
3. Affine linear sections are not dimension certificates.
4. No random fibre closure is promoted to a global module statement.
5. No auxiliary projector is a Fano point.
6. Every candidate is substituted into the original equations.
7. `UNDECIDED` with a precise blocker is an accepted exit.

---

# 9. Resource policy

Exploratory ceiling:

```text
8 GiB RSS
```

One preflighted heavy job at a time:

```text
up to 64 GiB RSS
```

Absolute ceiling with explicit director authorization:

```text
96 GiB RSS
```

A job crossing its limit must stop cleanly, checkpoint, and report:

```text
last completed invariant
matrix / algebra dimensions
observed RSS
smallest reformulation
whether the route remains headline-capable
```

---

# 10. Final exit table

| Exit | Meaning | Consequence |
|---|---|---|
| `T11-FOLD-HEIGHT1` | exact horizontal divisorial singular component of the fold | continue normalization and mod-3 ledger |
| `T11-FOLD-MORSE-BOTT-NO-3` | generic fold defect is ordinary and has no 3-primary local class | removes a major T obstruction |
| `T11-INDEX3` | horizontal degree subgroup remains `3Z` | headline negative |
| `P25-DEGREE25-EMPTY` | complete degree-25 special fibre empty | scoped degree-25 exclusion |
| `P25-COVARIANT` | exact primitive dominant landing covariant | headline positive |
| `C3-APROJ-EXECUTABLE` | genuine projective algebra installed | continue Fano route |
| `C3-FANO-MODEL-PASS` | quaternion/Hermitian/Plücker model verified | search common line |
| `C-FANO-POINT` | exact point on genuine twisted Fano section | headline positive |
| `*-UNDECIDED` | exact blocker and resource floor | no headline claim |

**Problem E remains OPEN.**
