# Deflated binodal system — nonsingular at all three witnesses

**Request:** T8-N1 steps 2 and 4 (modular).  
**Inputs:** sealed `P` (1593 terms, sha `921816…c344`), planes from
`certificates/fold_decision_t8/planes.json`.

---

## 1. System

On plane `Λ` with `x(s,t) = (A,B,Y,Z)(s,t)`, unknowns `(s,t,u_1,u_2)`:

```text
E_1 = P(x(s,t), u_1) = 0
E_2 = P_u(x(s,t), u_1) = 0
E_3 = P(x(s,t), u_2) = 0
E_4 = P_u(x(s,t), u_2) = 0
```

No expansion of `s_1` is used.

---

## 2. Jacobian structure (director-derived, independently verified)

Write `dh_i = ∇_x P(x, u_i)`. Because `P_u(u_i) = 0` on the locus, the
`u`-columns of `J_4` contribute factors `P_uu(u_i)`, and

```text
det J_4 = P_uu(u_1) · P_uu(u_2) · det [ dh_1·x_s   dh_1·x_t ]
                                       [ dh_2·x_s   dh_2·x_t ]
```

Independent check at the three witnesses (all values mod `p`):

| Witness | `dh_1` | `dh_2` | branch 2×2 | `P_uu` | `det J_4` |
|---|---|---|---:|---|---:|
| L4/`p`=101 | `(31,44,1,89)` | `(0,93,83,1)` | **14** | `(48,35)` | **88** |
| L4/`p`=199 | `(20,5,46,129)` | `(136,138,63,77)` | **155** | `(96,20)` | **95** |
| L2/`p`=89 | `(70,25,20,7)` | `(44,4,63,86)` | **40** | `(87,22)` | **20** |

All match the director table (sign of `det J_4` reported positive; director
allowed ±). Rank of `{dh_1, dh_2}` is 2 at every witness (branch matrix
nondegenerate and the two 4-vectors are visibly non-parallel).

**Control (non-witness L2/`p`=101):** `dh_2 = (0,0,0,0)`, branch det `0`,
`det J_4 = 0` — consistent with a failed gate (`delta = 0` at one root).

**Conclusion:** the deflated system is nonsingular at all three gate-passing
witnesses. Hensel applies to *this* system even though it does not apply to
`(H,s_1)|_Λ`.

---

## 3. Branch identification for normal crossing (step 4, modular)

Near a binodal point, each double root continues as `u_i(x)` solving
`P_u(x, u_i(x)) = 0`, and the discriminant branch is `h_i(x) = P(x, u_i(x))`.
Differentiating and using `P_u = 0`,

```text
dh_i = ∇_x P(x, u_i).
```

This is exactly the `dh_i` of §2. Independence of `dh_1, dh_2` (rank 2) at all
three witnesses is the modular normal-crossing differential condition:
locally `H = unit · h_1 · h_2` with transverse branches, over `F_p`.

**Completed local ring over `Q`:** not sealed in this packet (requires the
char-0 point of step 3). Modular certificate only.

---

## 4. What this proves / does not prove

**Proves (mod `p` at the three witnesses):**
- `P = P_u = 0` at both roots;
- `det J_4 ≠ 0` (deflated Hensel hypothesis);
- rank `{dh_1, dh_2} = 2` (transverse branches).

**Does not prove:**
- exact char-0 algebraic point;
- normal crossing in the completed local ring over `Q`;
- dimension of the binodal locus in `A^4`.
