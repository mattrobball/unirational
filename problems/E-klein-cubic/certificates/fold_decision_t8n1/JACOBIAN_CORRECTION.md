# Jacobian correction — T8 line 100 is false and uncomputed

**Author:** Worker N, Request T8-N1 step 1 (2026-07-31).  
**Applies to:** `certificates/fold_decision_t8/SUBRESULTANT_UNIT_TARGET.md` line 100.  
**Sealed T8 packet:** left byte-identical (do not edit).  
**Effect on the T8 exit:** none. `T8-S1-UNDECIDED` stands.  
**Pattern:** `DIRECTOR_CORRECTION_C0.md` / `ROUTE_G_VERDICT.md` — correction lives beside the seal.

---

## 1. The incorrect claim

```text
At L4/p=101 and L4/p=199, the Jacobian of (H,s_1)|_Lambda w.r.t. (s,t) is
invertible (dets 96 and 29), so these points are isolated on the plane section
and Hensel-liftable p-adically.
```

Three independent failures:

1. the determinant is **0**, not 96 or 29;
2. the points are **not** isolated zeros of `(H,s_1)|_Λ`;
3. **no Jacobian or determinant computation exists in the T8 packet**.

---

## 2. Independent recomputation of `∇H`

Source: sealed `H_primitive_integer.tsv` (37992 terms, sha
`b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501`).
All four partials `∂H/∂A, ∂H/∂B, ∂H/∂Y, ∂H/∂Z` evaluated mod `p` by termwise
differentiation (producer: `tmp/t8n1_work/step1_2_modular_audit.py`; verifier
recomputes independently).

| Point | `(A,B,Y,Z)` | `∇H` | gates |
|---|---|---|---|
| L4/`p`=101 | `(36,55,77,80)` | **`(0,0,0,0)`** | pass |
| L4/`p`=199 | `(125,130,79,75)` | **`(0,0,0,0)`** | pass |
| L2/`p`=89 | `(67,81,86,2)` | **`(0,0,0,0)`** | pass |
| L2/`p`=101 (control) | `(50,41,64,16)` | `(21,95,74,42)` | **fail** |

Matches the director table exactly. Control is decisive: the one listed point
with failed gates (`delta=0` at one root, `G=0`) is the one with `∇H ≠ 0`.

**Geometric reason (owner Prop. 3.1).** At a binodal point with `G ≠ 0` both
discriminant branches lie in `H`, so locally `H = unit · h_1 · h_2` and `H` is
singular. Hence `∇H = 0` is forced, not accidental.

**Chain-rule consequence.** On any plane `Λ` with parametrization `x(s,t)`,

```text
∂(H|_Λ)/∂s = ∇H · x_s = 0,    ∂(H|_Λ)/∂t = ∇H · x_t = 0.
```

The first row of the Jacobian of `(H, s_1)|_Λ` w.r.t. `(s,t)` is identically
zero, so its determinant is **0**. The naive Hensel lift of that system does
not apply. Deflation to `(P,P_u)` at two roots is required (step 2 of T8-N1).

---

## 3. Audit of the T8 packet code

```text
rg -i "jac|det|jacobian|determinant" \
  produce_t81.py sres_eval_t81.py verify_t81.py t81_payload.json
→ no matches
```

The packet contains **no Jacobian code and no determinant computation**.
`verify_t81.py` recomputes the modular witnesses and never touches line 100 of
the prose. That is why the verifier passed while the adjacent sentence was
false — the discipline failure this request exists to correct.

---

## 4. Origin of the numbers 96 and 29

Best-supported statement, after independent search:

| Number | Where it actually appears | What it is |
|---:|---|---|
| **96** | `modular_nonunit_discovery.json`, L4/`p`=199, root `u=35`, field `"Puu"` | `P_uu(35) mod 199` |
| **29** | same file, L2/`p`=101 non-witness, field `"C"` | gate `C(50,41,64,16) mod 101` |

They do **not** appear as Jacobian determinants anywhere in the code or in
`t81_payload.json`. They are **not** the branch 2×2 determinants (14, 155, 40)
nor the deflated 4×4 determinants (±88, ±95, ±20) computed in step 2.

**Finding:** unsupported prose claim. No computation of those determinants
exists in the packet. The numbers 96 and 29 were almost certainly copied from
nearby gate/`P_uu` values in the discovery JSON by a prose-writing error, not
by a matrix computation that was later deleted.

---

## 5. Correction notice

```text
CORRECTION: The claim that the Jacobian of (H,s_1)|_Λ is invertible at
L4/p=101 and L4/p=199 with determinants 96 and 29 is FALSE.
  - ∇H = 0 at all three gate-passing witnesses ⇒ that Jacobian has det 0.
  - No Jacobian/determinant code exists in the T8 packet.
  - 96 and 29 are gate/P_uu values from modular_nonunit_discovery.json,
    not matrix determinants.
  - The three modular binodal witnesses remain valid discovery data.
  - Hensel applies to the *deflated* system (step 2), not to (H,s_1)|_Λ.
```

The sealed T8 exit `T8-S1-UNDECIDED` was and remains correct on the exact
char-0 question; only the incidental Hensel-liftability sentence was wrong.

---

## 6. What this file proves / does not prove

**Proves:**
- `∇H = 0` at the three gate-passing witnesses and `∇H ≠ 0` at the control;
- absence of Jacobian code in the T8 producer/verifier/payload;
- traced origin of 96 and 29 as non-determinant JSON fields;
- that `(H,s_1)|_Λ` is singular at those points.

**Does not prove:**
- characteristic-zero nonunit of `s_1`;
- dimension of the binodal locus;
- `T-NONNORMAL` or `dim Sing(S_G) = 2` (still suspended, `REPAIR.md` §1).
