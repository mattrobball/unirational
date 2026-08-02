# Acceptance matrix

No row may be marked pass unless an independent verifier reconstructs the
claim from exact source equations.

| ID | Requirement | Passing evidence |
|---|---|---|
| A0 | Correct baseline and sources | `INPUT_MANIFEST.json`, hashes, software versions, consumed commit |
| A1 | One common open | Exact product `ell*P_uu*delta*C*G*h`; every theorem names the same localization or a separately audited boundary chart |
| A2 | Corrected RUR identities | All six critical equations reduce to zero over `Q(A,u)` with the proved interpolation degree bound |
| A3 | RUR domain | `QZ` irreducible and squarefree; `q_Z` invertible; exact degree-six field presentation |
| A4 | Full generic exhaustiveness | Unconstrained gate-saturated critical quotient has characteristic-zero length exactly six, proved by lower and upper bounds |
| A5 | Unique dominant component | Exact equality of the full generic critical ideal with `(QZ,BQZ_Z-NB,YQZ_Z-NY)` after localization; removed divisors accounted separately |
| A6 | Gate units and flat model | Exact norms/inverses for every gate and chart determinant; explicit localization polynomial in `Q[A,u]` |
| N1 | Finite birational normalization | Integral generator(s) with monic equation and same fraction field |
| N2 | Stable-ideal identities | Exact checks of `p=(c,d)`, `p^2=c*p`, `(c:d)=p`, and the quadratic relation |
| N3 | Normality | `S_2` plus regularity at every height-one prime on the chosen open |
| N4 | Conductor | Exact equality `cond(S_G subset T)=p`; support and exponent certified |
| N5 | Generic branch data | Branch number, residue degree, ramification index, delta invariant, and nonsplitting over the actual residue field |
| D1 | Conductor/discriminant relation | Exact proof that `Delta_cub` is a unit at the conductor generic point |
| D2 | Affine contact `S` | Normalized contact order two and actual-field local `Cl[3]=0` |
| D3 | Boundary contact `E` | Minimal local cubic type on both Newton branches and actual-field local `Cl[3]=0`, or an exact dangerous class |
| D4 | Residual height-one contacts | Exhaustive characteristic-zero list and exact valuations modulo three |
| D5 | Special curves | Normalized local models for `L,D,C,J1,J2,F15` and all conductor/boundary intersections |
| P1 | Residual Picard control | Codimension/parafactoriality theorem, prime-to-three local exponents, or an exact localization argument |
| P2 | Global local-to-global sequence | Every non-Cartier class arises from the audited local strata; vertical classes explicitly quotiented |
| P3 | Horizontal three-primary result | Exact proof of `(Cl/Pic)[3]_horizontal=0`, or exact surviving class |
| P4 | Degree image | Exact computation `deg_horizontal=3 Z`, or the corrected subgroup if a dangerous class survives |
| T1 | Fixed-frame theorem | `ind(C_fix/k(D))=3` with all hypotheses and field identifications checked |
| T2 | Headline scope fence | Explicit statement that Task B refutes the proposed exhaustiveness conversion to `X_gen` |
| V1 | Independent replay | `verify_all.py` rebuilds every load-bearing CAS claim and emits the matching terminal marker |
| V2 | Seal | `SEAL.json` and `SHA256SUMS` cover all inputs, scripts, outputs, and proofs |

## Required result packet

```text
STATUS.md
THEOREM.md
INPUT_MANIFEST.json
COMMON_OPEN.md
DOMINANT_COMPONENTS.md
components.json
NORMALIZATION.md
normalization_payload.json
CONDUCTOR.md
DISCRIMINANT_CONTACTS_MOD3.md
LOCAL_MODELS.md
LOCAL_CLASS_GROUPS.md
contacts.json
RESIDUAL_PICARD.md
GLOBAL_DEGREE_IMAGE.md
global_class_group_payload.json
cas/
logs/
certificates/
verify_components.py
verify_normalization.py
verify_contacts.py
verify_global_assembly.py
verify_all.py
SHA256SUMS
SEAL.json
```

## Exit matrix

### `T3-FIXED-FRAME-INDEX3-PASS`

Requires every row A0–T2 and V1–V2 to pass, with P3 equal to zero and P4 equal
to `3 Z`.

### `T3-DANGEROUS-3-CLASS`

Requires A0–N5, the local model supporting the class, proof of actual-field
three-primary order, proof of horizontal survival, and the corrected degree
image. It does not require vanishing rows D/P that the exhibited class
refutes.

### `T3-NORMALIZATION-PASS-CLPIC3-OPEN`

Requires A0–N5 and V1–V2. `STATUS.md` must identify the first unresolved
local/global class-group row.

### `T3-RUR-NOT-EXHAUSTIVE`

Requires an exact extra component or a certified generic quotient length
strictly greater than six. Give its prime ideal, dimension, degree, gates, and
relation to the candidate RUR component.

### `T3-LOCAL-RUNNER-BLOCKED`

Permitted only after preserving all successful certificates and recording the
smallest exact failed calculation, resource floor, command, software version,
and full log.

## Automatic rejection conditions

- any GitHub Actions or hosted-CAS dependency;
- generic conclusions from finitely many special fibres alone;
- a normality claim without one-ring `R_1+S_2` control;
- `Cl=Pic` inferred from normality or ordinary Picard rank;
- discriminant order used as a local class group without classifying the
  minimal local model;
- modular reducedness promoted without characteristic-zero degree/flatness;
- a fixed-frame result relabelled as a Problem-E headline theorem.
