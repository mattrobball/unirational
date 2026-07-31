# T9.0 — sealed p-adic theorem interface (Hensel nonunit)

**Exit:** `T9-HENSEL-NONUNIT-SEALED`  
**Headline:** **OPEN**  
**Witness:** plane L4 at prime `p = 101`, parameters `(s,t) = (0, 62)`,
roots `(u_1, u_2) = (46, 72)`, base point `(A,B,Y,Z) = (36, 55, 77, 80)`.

---

## 1. Deflated system over `Z_(101)`

On the plane

```text
A = 13 + 7s + 2t
B =  2 + 5s + 9t
Y =  8 +  s + 6t
Z =  4 + 3s + 11t
```

the ordered double-root equations in unknowns `(s, t, u_1, u_2)` are

```text
E_1 = P(Λ(s,t), u_1)
E_2 = P_u(Λ(s,t), u_1)
E_3 = P(Λ(s,t), u_2)
E_4 = P_u(Λ(s,t), u_2)
```

where `P` is the sealed global primitive `u`-sextic (1593 terms,
sha `921816…c344`). No expansion of the subresultant `s_1` is used.

---

## 2. Modular recomputation (must match director table)

All values below are recomputed from sealed `P` (and sealed gate TSVs), not
read from prior JSON as authority.

| Quantity | Recomputed mod 101 | Expected |
|---|---:|---:|
| `(A,B,Y,Z)` | `(36,55,77,80)` | `(36,55,77,80)` |
| `u_1, u_2` | `46, 72` | `46, 72` |
| `u_1 − u_2` | `75` | nonzero |
| `E_1…E_4` | `[0, 0, 0, 0]` | `(0,0,0,0)` |
| `dh_1 = ∇_x P(u_1)` | `[31, 44, 1, 89]` | `(31,44,1,89)` |
| `dh_2 = ∇_x P(u_2)` | `[0, 93, 83, 1]` | `(0,93,83,1)` |
| branch 2×2 det | `14` | `14` |
| `P_uu(u_1), P_uu(u_2)` | `48, 35` | `48, 35` |
| `det J_4` (factor form) | `88` | `88` |
| `det J_4` (direct 4×4) | `13` | `±88` |
| `ell` | `18` | `18` |
| `C` | `66` | `66` |
| `L = A−15` | `21` | `21` |
| `M = B` | `55` | `55` |
| `Q_4` | `10` | `10` |
| `delta(u_1), delta(u_2)` | `93, 12` | `93, 12` |
| `G` (formal line Res/H) | `16` | `16` |
| `H` | `0` | `0` |

**Table match:** `EXACT`.

Jacobian factorization used for the formula form:

```text
det J_4 = P_uu(u_1) · P_uu(u_2) · det [ dh_1·x_s  dh_1·x_t ]
                                      [ dh_2·x_s  dh_2·x_t ]
```

---

## 3. Multivariate Hensel — hypotheses and conclusion

**Version invoked.** Nonsingular multivariate Hensel lemma:

> Let `f = (f_1,…,f_n)` have coefficients in `Z_p`. If `a ∈ Z^n` satisfies
> `f(a) ≡ 0 (mod p)` and `det(Df(a))` is a unit in `Z_p` (equivalently
> nonzero mod `p`), then there exists a **unique** `ã ∈ Z_p^n` with
> `f(ã) = 0` and `ã ≡ a (mod p)`.

Standard references: Bourbaki, *Commutative Algebra*, Ch. III, §4, no. 5;
Eisenbud, *Commutative Algebra*, Thm. 7.3 / Ex. 7.25; computational Newton form
with invertible Jacobian mod `p`.

**Literal hypothesis check at the modular point:**

1. **Residual vanishing:** `E_i ≡ 0 (mod 101)` for `i = 1…4` — verified by
   direct evaluation of sealed `P` and `P_u`.
2. **Nonsingular Jacobian:** `det J_4 ≡ 88 ≠ 0 (mod 101)` — verified both by
   the factor formula and by direct 4×4 determinant of
   `∂(E_1,…,E_4)/∂(s,t,u_1,u_2)`.
3. **Precision condition:** for the nonsingular form, residual vanishing mod
   `p` and unit Jacobian already give a unique `Z_p`-lift; no higher
   bootstrap is required.

**Conclusion.** There is a unique solution
`(s,t,u_1,u_2) ∈ Z_101^4` reducing to `(0,62,46,72)` mod 101, and therefore
a `Q_101`-point of the deflated system.

A finite-precision Newton lift to modulus `p^6` was also run as a
computational sanity check; residuals vanish at the lifted point
(`E = 0` at modulus `1061520150601`).

---

## 4. Gates, `s_1`, and `H` at the lifted point

All modular gate values above are nonzero. Polynomials continuous under
`Z_p`-reduction, so each gate remains a **unit** in `Z_101` at the lifted
point. In particular:

- `u_1 − u_2` is a unit ⇒ the two roots stay distinct;
- `P_uu(u_i)`, `delta(u_i)`, `ell`, `C`, and `G` are units.

**`s_1 = 0`.** At the `Z_p` point, `P` and `P_u` vanish at two distinct roots,
so `deg_u gcd(P, P_u) ≥ 2`. The first subresultant `s_1` is (up to units) the
degree-`deg−2` principal subresultant coefficient and therefore vanishes.
No expansion of `s_1` is required.

**`H = 0`.** The sealed identity `Res_u(P, P_u) = H · G` holds. At the point
`Res = 0`. Since `G` is a `Z_p`-unit, necessarily `H = 0`.

**Nonunit ideal over `Q`.** A point over `Q_p` is a characteristic-zero point
over a field extension. The existence of such a point with all gates units
refutes

```text
(H, P, P_u, s_1) : (ell · P_uu · C · delta · G)^∞ = (1)
```

over `Q`. This is the analytic content of marker `T8-S1-NONUNIT-ANALYTIC`.
**No squarefree number-field minimal polynomial is used or required.**

---

## 5. What this packet proves / does not prove

**Proves:**
- unique `Z_101`-solution of the L4 deflated system at the verified witness;
- `Q_101`-point with `P = P_u = H = s_1 = 0` and all gates units;
- saturated ideal nonunitness over `Q` (analytic, via `Q_p`).

**Does not prove:**
- an explicit algebraic number field model of the point;
- global dimension or equations of the binodal component (→ T9.1);
- that `S_G` is globally normal or nonnormal (`T-NONNORMAL` remains
  suspended for `S_G`; the local binodal normal form concerns the target
  branch `B`);
- `dim Sing(S_G) = 2`.

---

## 6. Artifacts

| File | Role |
|---|---|
| `hensel_hypotheses.json` | machine-readable hypotheses, recomputed values, conclusions |
| `verify_hensel_hypotheses.py` | independent verifier (does not import producer) |
| `HENSEL_NONUNIT.md` | this note |

**Exit marker:** `T9-HENSEL-NONUNIT-SEALED`  
**Headline:** **OPEN**
