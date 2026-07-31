# Director correction — T8 Jacobian claim is false and uncomputed

**Author:** director session, 2026-07-31, auditing the T8 packet in response to the owner's
Request T8-N1 step 1.
**Applies to:** `SUBRESULTANT_UNIT_TARGET.md` line 100.
**Effect on the exit:** none. `T8-S1-UNDECIDED` stands, and the three gate-passing binodal
witnesses remain independently confirmed.

The T8 packet is left byte-identical; this is the correction layer, following the
`DIRECTOR_CORRECTION_C0.md` / `ROUTE_G_VERDICT.md` pattern.

---

## 1. The incorrect claim

```text
At L4/p=101 and L4/p=199, the Jacobian of (H,s_1)|_Lambda w.r.t. (s,t) is
invertible (dets 96 and 29), so these points are **isolated** on the plane
section and Hensel-liftable p-adically.
```

Three separate problems: the determinant is not 96 or 29, it is **0**; the points are **not**
isolated zeros of that system; and **no such computation exists in the packet**.

## 2. `∇H = 0` at every gate-passing witness

Director computation from the sealed `H` TSV (37992 terms), all four partials mod `p`:

| Point | `∇H = (∂_A, ∂_B, ∂_Y, ∂_Z)` | gates |
|---|---|---|
| L4/`p`=101 `(36,55,77,80)` | `(0,0,0,0)` | pass |
| L4/`p`=199 `(125,130,79,75)` | `(0,0,0,0)` | pass |
| L2/`p`=89 `(67,81,86,2)` | `(0,0,0,0)` | pass |
| L2/`p`=101 `(50,41,64,16)` | `(21,95,74,42)` | **fail** (`G=0`, `delta=0`) |

This is forced, and is the owner's Proposition 3.1: at a binodal point with `G ≠ 0` both
discriminant branches lie in `H`, so locally `H = unit · h_1 · h_2` and `H` is singular there.
The control is decisive — the one listed point where the gates fail is the one point where
`∇H ≠ 0`.

**Consequence.** By the chain rule `∂(H|_Λ)/∂s = ∇H · x_s = 0` and likewise in `t`, so the first
row of the `(H,s_1)|_Λ` Jacobian vanishes identically and its determinant is `0`. The naive
Hensel lift of `(H, s_1)|_Λ` does **not** apply. Deflation is required — which is exactly why
the owner's Request T8-N1 prescribes the system `P(u_1)=P_u(u_1)=P(u_2)=P_u(u_2)=0`.

## 3. The determinants were never computed

```text
grep -i "jac\|det" produce_t81.py sres_eval_t81.py verify_t81.py   ->   no matches
```

The packet contains no Jacobian or determinant code at all, and `96` / `29` appear nowhere in
the code or in `t81_payload.json`. They do occur in `modular_nonunit_discovery.json` as
`"Puu": 96` (L4/`p`=199, root `u=35`) and `"C": 29` (the L2/`p`=101 non-witness) — i.e. as a
`P_uu` value and a gate value belonging to two different points.

They are also not the plausible alternative matrices. Director-computed:

| Witness | branch 2×2 `det[[dh_1·x_s, dh_1·x_t],[dh_2·x_s, dh_2·x_t]]` | deflated 4×4 `det J_4` |
|---|---:|---:|
| L4/101 | 14 | ±88 |
| L4/199 | 155 | ±95 |
| L2/89 | 40 | ±20 |

No candidate yields 96 or 29. The correct reading is that line 100 is an **unsupported prose
claim**: no computation behind it, and false as stated.

`verify_t81.py` returned `FOLD_DECISION_T81_VERIFIER_ACCEPT` because it recomputes the witness
points and never examines this sentence. That is the discipline lesson — a verifier that
genuinely recomputes its decisive invariant can still leave adjacent prose entirely unchecked.

## 4. What is unaffected

The substantive T8 result stands, independently re-verified by the director:

- three gate-passing binodal points at `p = 89, 101, 199` with `H = 0`, `deg_u gcd(P,P_u) = 2`
  with two distinct roots, and every gate nonzero;
- `deg gcd = 2` forces `Sres_1 ≡ 0`, so these are `F_p`-points of `V(H,P,P_u,s_1) ∩ D(q)`;
- the evidence continues to favour `T8-S1-NONUNIT`;
- the exit `T8-S1-UNDECIDED` was and remains correct — no char-0 point was lifted.

## 5. Correction to the downstream recommendation

`DIRECTOR_HANDOFF.md` §8 previously said the witnesses were "Hensel-liftable" on the strength of
this claim. They are, but **only via the deflated system**, whose Jacobian factors as

```text
det J_4 = ± P_uu(u_1) · P_uu(u_2) · det [ dh_1·x_s  dh_1·x_t ]
                                        [ dh_2·x_s  dh_2·x_t ],     dh_i = grad_x P(x, u_i),
```

nonzero at all three witnesses (table above). The notes have been corrected accordingly.

**Problem E remains OPEN.**
