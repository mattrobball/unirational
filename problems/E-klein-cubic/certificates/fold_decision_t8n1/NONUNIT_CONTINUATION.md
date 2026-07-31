# Step 5 — nonunit continuation and dimension floor

**Request:** T8-N1 step 5.  
**Status:** honest `UNDECIDED` on the geometric continuation; no dimension
certificate claimed.

---

## 1. What the modular binodal points do prove

They prove **nonemptiness** of

```text
V(H, P, P_u, s_1) ∩ D(q)
```

over `F_p` for `p ∈ {89, 101, 199}`, with `deg_u gcd(P,P_u) = 2` and two
distinct roots. Combined with nonsingular deflated Jacobian, they lift to
`Z_p`-points. They are discovery evidence for `T8-S1-NONUNIT`, not a char-0
proof.

---

## 2. Dimension of the binodal locus — not certified

`V(H)` has dimension 3 in `A^4`. The binodal locus (two distinct double roots
with gates open) is **expected** to be dimension 2 (codimension one in the
branch). If `S_G` is singular along a codimension-one component of that locus,
`R_1` fails and `T2R-NONNORMAL` would follow — the prize suspended in
`REPAIR.md` §6.

**Binding trap (`DIRECTOR_HANDOFF.md` §6, four prior occurrences):** affine
plane sections prove nonemptiness only. They never bound dimension from above.

Observed on L4:

| `p` | `#` gate-pass binodal with `H=0`, `gd=2`, two roots |
|---:|---:|
| 89 | 1 |
| 101 | 5 |
| 103 | 2 |
| 107 | 2 |
| 199 | 3 |

Finite nonzero counts on 2-planes are compatible with a pure dimension-2
locus (0-dim section) **or** with lower-dimensional components. They do not
distinguish.

**Acceptable dimension certificates (not produced here):**

- an exact height-three prime component of the binodal ideal meeting the open;
- a finite dominant two-parameter map into the locus;
- a saturated projective computation with Noether normalization.

**Floor:**

```text
DIM-FLOOR: no exact component, no Noether normalization, no saturated
projective dimension certificate for the binodal locus. Plane-section
point counts are discovery only. dim binodal and the R_1 / T2R-NONNORMAL
question remain open (REPAIR.md §1, §6 still suspended).
```

---

## 3. Conductors kept distinct

Per `REPAIR.md` §5:

```text
c_{B ⊂ S}  = Ann_B(S/B)     (fold / partial modification)
c_{S ⊂ S~} = Ann_S(S~/S)    (normalization of S, if nonnormal)
```

No identification of these two ideals is claimed. Normality is not inferred
from a fold/branch isomorphism.

---

## 4. Fold incidence regularity at the generic point above this conductor

Not reached: requires the char-0 point (step 3) and a completed-local-ring
analysis (step 4 over `Q`). Modular transverse branches (`rank{dh_1,dh_2}=2`)
are consistent with a regular fold incidence but do not certify it over `Q`.

---

## 5. What this proves / does not prove

**Proves:** nothing new about dimension or `R_1`.

**Records:** the measured floor for the dimension question, and that step 5 is
deliberately `UNDECIDED` without manufactured inference from plane sections.
