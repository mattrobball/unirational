# Work order — T3 normalization and `Cl/Pic[3]`

## 0. Scope fence

The object is the normalized dominant incidence attached to the selected
multiplicity-one target branch of the **fixed-frame plane cubic**. The task is
to decide its horizontal three-primary non-Cartier defect.

Do not claim that this settles the genuine generic Klein twist. The current
Task-B theorem proves that the selected ternary frame is not exhaustive under
the available five-plane-preserving gauge group. A T3 success is therefore a
fixed-frame index theorem and a reusable local/global class-group theorem.

All CAS is local. Do not add or invoke a GitHub Actions workflow.

---

## T3.0 — freeze one common open and replay the inputs

### Ring

Use

```text
R   = Q[A,B,Y,Z,u],
S_G = (R/(P,P_u))[(ell*P_uu*delta*C*G)^(-1)].
```

Record the exact factor chosen for `G`; do not replace `G` by an unevaluated
resultant quotient. Every later normality, conductor, discriminant, and class
group statement must refer to this same ring or to an explicitly covered
boundary chart.

### Required input replay

Recheck hashes and terminal markers for:

```text
certificates/fold_normalization/FINITE_BIRATIONAL.md
certificates/fold_normalization_t2r/T2R.md
goals_after_bd610a/scratch_t3/generic_singular_rur_QZ.tsv
goals_after_bd610a/scratch_t3/generic_singular_rur_NB.tsv
goals_after_bd610a/scratch_t3/generic_singular_rur_NY.tsv
goals_after_bd610a/scratch_t3/verify_t111_generic_rur_identities_result.json
goals_after_bd610a/scratch_t3/verify_t111_q_and_special_fibre_result.json
goals_after_bd610a/scratch_t3/T3_NODE_Aminus6_uminus6.md
goals_after_bd610a/scratch_t3/T3_ENDOMORPHISM_MODEL.md
goals_after_bd610a/scratch_t3/discriminant/SEAL.json
goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/STATUS.md
```

Write `INPUT_MANIFEST.json` containing the consumed commit, SHA-256 values,
software versions, and the exact common-open product.

**Exit on mismatch:** `T3-LOCAL-RUNNER-BLOCKED` with the first failed input.

---

## T3.1 — prove the corrected RUR prime is exhaustive in codimension one

Let

```text
q   = QZ(A,u,Z),
r_B = B*q_Z-NB(A,u,Z),
r_Y = Y*q_Z-NY(A,u,Z),
p   = (q,r_B,r_Y) S_G.
```

The stored identities prove `p` lies in the full critical scheme. They do not
yet prove equality with the full saturated generic fibre.

### T3.1.a — characteristic-zero lower bound

Replay the exact six critical identities and the irreducibility/squarefree
certificate for `q`. Prove on an explicit open that:

```text
q_Z is a unit,
S_G/p is a degree-six field over Q(A,u),
B=NB/q_Z and Y=NY/q_Z in that field.
```

This gives an exact length-six component, not merely six sample points.

### T3.1.b — generic upper bound from one good reduction

Run locally the existing emitter

```text
goals_after_bd610a/scratch_t3/emit_mod101_generic_upper_bound.py
```

and compute the **unconstrained**, sequentially gate-saturated critical ideal
over `F_101(A,u)`.

The desired certificate is

```text
dimension = 0,
vector-space dimension = 6,
```

plus the final reduced Groebner basis, leading monomial ideal, Hilbert function,
and all saturation multipliers. A mod-101 quotient of length six gives a
characteristic-zero length upper bound of six because Macaulay ranks can only
drop after reduction. Together with T3.1.a it proves equality and
exhaustiveness.

Do not consume only a printed `VDIM=6` boolean. The verifier must reconstruct
the quotient basis from the saved Groebner basis.

If prime 101 is bad, run at least two independently selected good primes and
identify the bad factor. If every good reduction has length greater than six,
return `T3-RUR-NOT-EXHAUSTIVE` with the extra leading components.

### T3.1.c — unit and flatness ledger

In the degree-six field, compute exact norms or inverses for

```text
B, ell, P_uu, delta, C, G,
q_Z,
the (B,Y,Z)-Jacobian chart determinant,
the bordered Hessian discriminant.
```

Specify the localization polynomial `h(A,u)` whose inversion makes the family
finite flat of degree six. The specialization `(A,u)=(-6,-6)` must meet this
open before it is used to descend nonsquareness.

### T3.1.d — component theorem

Produce:

```text
DOMINANT_COMPONENTS.md
components.json
verify_components.py
```

The theorem must state that `p` is the unique dominant height-one singular
prime of `S_G` on the certified open. Account separately for every divisor
removed by `G` or another gate; deletion is not exhaustion.

---

## T3.2 — construct the normalization and conductor

Use the one-step endomorphism/stable-ideal model whenever possible.

### Preferred two-generator certificate

Find `c,d in p` and `alpha,beta in S_G` such that, after one explicit further
localization,

```text
p=(c,d),
p^2=c*p,
(c:d)=p,
d^2=alpha*c^2+beta*c*d.
```

Set

```text
theta=d/c,
T=S_G[theta]=S_G+S_G*theta,
theta^2-beta*theta-alpha=0.
```

Verify the four displayed identities by exact ideal membership and colon
computations. If no single chart works, use a finite principal-open cover and
write the transition formulae for `theta`.

### Normality proof

Prove:

1. `S_G/p` is regular on the chosen open;
2. `p` is maximal Cohen–Macaulay by the exact sequence
   `0 -> p -> S_G -> S_G/p -> 0`;
3. `T` is `S_2` as an `S_G`-module isomorphic to `p/c`;
4. at `p`, `T_p` is the DVR normalization of the generic node;
5. at every other height-one prime, `T=S_G` and is regular.

Conclude by `R_1+S_2` that `T` is the integral closure on the common open.

### Conductor and branch data

Prove exactly

```text
cond(S_G subset T)=(c:d)=p.
```

Compute:

```text
number of branches over the ground residue field,
ramification index,
residue degree,
delta invariant,
conductor exponent,
normalization discriminant beta^2+4*alpha.
```

The expected generic pattern is one nonsplit branch with residue degree two,
ramification index one, delta invariant one, and conductor exponent one. The
`(-6,-6)` field witness may prove generic nonsquareness only after the regular
flat model and unit conditions in T3.1.c are established.

Required files:

```text
COMMON_OPEN.md
NORMALIZATION.md
normalization_payload.json
CONDUCTOR.md
verify_normalization.py
```

---

## T3.3 — exhaustive discriminant contacts and local class groups

Pull back the authoritative fixed-frame discriminant to the normalized base
`Spec T` and work chart by chart.

### T3.3.a — conductor generic point

Replay the exact nonzero discriminant norm on the RUR field. Conclude that the
conductor prime is not itself a cubic-discriminant component. Record any
proper closed intersection with the conductor for the residual audit.

### T3.3.b — affine contact plane

For

```text
S=(A-15L,Y-12L)
```

consume the exact contact order `2` and the generic ordinary-node model.
After tangent-cone splitting the expected incidence chart is `xy=pi^2`; prove
that the actual-field three-primary local class group is zero.

### T3.3.c — projective boundary

For

```text
E=(L,A)
```

the normalized Newton branches have `v(Delta)=4`. Determine the actual minimal
local cubic model rather than inferring it from the discriminant alone.
The cheapest route is to compute `v(c4)` and `v(c6)` on both Newton branch
types. If `c4` is a unit, certify multiplicative type `I_4`, hence a split
`xy=pi^4` chart after at most a quadratic extension and geometric class group
`Z/4`. If the reduction is additive, compute its actual punctured local Picard
group directly. In either case prove the actual-field three-primary part is
zero or exhibit the contrary class.

### T3.3.d — residual height-one support

The existing good-reduction plane audit shows the residual raw intersection
is reduced in one slice; it is not a characteristic-zero normalized ledger.
Prove exhaustively on the normalization that every remaining height-one
component has contact order prime to three. Acceptable certificates are:

- exact factorization in the finite normalized algebra;
- Fitting/associated-cycle computation with exact characteristic-zero degree;
- a squarefree norm plus a degree budget that accounts for all components.

### T3.3.e — codimension-three and conductor intersections

Classify all remaining punctured local Picard groups, including:

```text
L  = B+8Z-992,
D  = the irreducible second-node direction cubic,
C  = B-Z+133,
J1 = B-10Z+1258,
J2 = 2B+Z-133,
F15,
all intersections with the conductor and projective boundary.
```

The existing exact packets settle the generic points of `L`, `D`, and `C` as
three-primary harmless. The local types above `J1`, `J2`, and `F15` remain
open and must be computed on the **normalized** base. Do not promote finite
jet vanishing to an all-orders normal form.

Required files:

```text
DISCRIMINANT_CONTACTS_MOD3.md
LOCAL_MODELS.md
LOCAL_CLASS_GROUPS.md
contacts.json
verify_contacts.py
```

---

## T3.4 — residual Picard audit and global assembly

Let `mathcal T` be the normalized total cubic incidence over the certified
normal base. Remove the explicitly classified conductor/discriminant strata
and prove one of:

```text
residual singular locus has codimension at least four and parafactoriality applies;
every remaining punctured local Picard group has exponent prime to three;
a localization sequence shows residual classes have zero horizontal degree.
```

Then write the exact conductor/localization sequence used to pass from local
class groups to

```text
(Cl(mathcal T)/Pic(mathcal T))[3]_horizontal.
```

Vertical and exceptional classes must be named and quotiented explicitly.
It is not enough to state that all listed local groups are prime to three;
prove that the list controls every global non-Cartier class.

Consume the accepted ordinary Picard theorem

```text
Pic(mathcal T)=Z*H_z + Z*H_lambda
```

only at its proved scope. Combine it with the local-to-global result and the
accepted `Pic^0=0` statement to compute the generic horizontal degree image.

Required files:

```text
RESIDUAL_PICARD.md
GLOBAL_DEGREE_IMAGE.md
global_class_group_payload.json
verify_global_assembly.py
```

---

## T3.5 — terminal theorem

### Vanishing exit

Use `T3-FIXED-FRAME-INDEX3-PASS` only after proving all of:

```text
normalization and conductor are exhaustive;
all normalized height-one discriminant contacts are classified;
all residual codimension-three contributions are controlled;
(Cl/Pic)[3]_horizontal=0;
deg_horizontal=3 Z;
the selected residual fixed-frame cubic is smooth generically;
ind(C_fix over k(D))=3.
```

State explicitly:

```text
This proves the fixed-frame branch-index theorem.
It does not imply pointlessness of X_gen/K_proj after B-BRIDGE-REFUTED.
```

### Dangerous-class exit

Use `T3-DANGEROUS-3-CLASS` only with:

- an exact height-one or punctured-local divisor class;
- proof of order divisible by three over the actual residue field;
- proof it survives normalization/descent and is horizontal;
- its contribution to the horizontal degree image.

### Honest partial exits

`T3-NORMALIZATION-PASS-CLPIC3-OPEN` is permitted only after the normalization
and conductor packet is complete. `T3-LOCAL-RUNNER-BLOCKED` must identify the
smallest exact ideal/module calculation still unresolved and preserve all
successful intermediate certificates.

---

## Prohibitions

1. No GitHub Actions or hosted CAS.
2. No `msolve`-only characteristic-zero emptiness claim.
3. No reuse of the dead `(P_B,P_Y,P_Z)` chart with the old gates.
4. No inference of generic exhaustiveness from finitely many affine fibres.
5. No inference `Cl=Pic` from normality, rational Picard rank, or smooth slices.
6. No promotion of modular reducedness without a characteristic-zero degree
   or flatness argument.
7. No mixing of the two conductors `B subset S` and `S subset normalization`.
8. Every point, divisor, and coordinate change must be substituted into the
   original primitive equations.
9. Keep all scripts deterministic and record peak RSS and wall time.
