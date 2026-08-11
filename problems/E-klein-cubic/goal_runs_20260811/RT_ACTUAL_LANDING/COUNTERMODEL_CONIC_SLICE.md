# The Klein conic-slice countermodel

Exit: `GENERIC-COMMON-FACTOR-LINE-NORMAL-FORM-REFUTED`.

Verifier: `verify_conic_slice.py`, exact over `Q`, `RESULT: PASS`.
Provenance: external message `[20]` section 3, replayed and confirmed here in
full.

---

## 1. What is refuted

An intermediate stage of the external work asserted a **weighted line normal
form** for the generic normal slice of a landing tuple along a common-factor
surface: writing `A = HB + FC`, the exceptional `P^1` of the normalized blowup
was claimed to map by `[u:v] ↦ [uB(eta_S) + vC(eta_S)]`, hence to a **line** in
`X`, so that every leakage block would sit on the universal Fano-line incidence
space. From this were drawn:

```
GENERIC-COMMON-FACTOR-WEIGHTED-LINE-NORMAL-FORM-PROVED
COMMON-FACTOR-TOP-LOCAL-SYSTEM-RANK-ONE-IN-ALL-CASES
AMBIENT-RETRACTION-EXCLUDED
CLEAN-DEGREE-DIVISIBLE-BY-4
ODD-DEGREE-CLEAN-EXCLUDED
```

All five are withdrawn by `[20]` section 5, and we confirm the withdrawal: the
refuting artifact below is exact.

## 2. The countermodel

For the Klein cubic `F(x) = sum_{i in Z/5} x_i^2 x_{i+1}`, set

```
P(u,v) = ( u^2 - v^2,  -2(u^2 + v^2),  (u - v)^2,  -2(u^2 + v^2),  0 ).
```

**Verified exactly** (`verify_conic_slice.py`):

| tag | claim | result |
|---|---|---|
| C1 | `F(P(u,v)) = 0` identically in `Q[u,v]` | PASS |
| C2 | the components span `<u^2, uv, v^2>`, so the base ideal is `I_P = (u,v)^2`, whose normalized blowup is the ordinary blowup of `(u,v)` | PASS, rank 3, with explicit integral rewritings of `u^2, uv, v^2` |
| C3 | the tuple is primitive (gcd of components is a unit) | PASS |
| C4 | the image is a **smooth conic**, not a line: exactly two linear forms vanish on it (`x_4` and `x_1 - x_3`), the three remaining quadrics are independent (`det = -8`), the image satisfies exactly one quadric in that plane, `x_0^2 + x_1 x_2 + x_2^2`, whose symmetric matrix has **rank 3** | PASS |
| C5 | on the slice `v = 0`, `P(u,0) = u^2·(1,-2,1,-2,0)`: a genuine divisorial common factor `u^2`, primitive value the Klein point `[1:-2:1:-2:0]`, and `F(1,-2,1,-2,0) = 0` | PASS |
| C6 | the parametrization is degree 1 onto its image (every `2x2` minor is divisible by `u v' - v u'`) | PASS |

Hand check of C1, for the record: `x_4 = 0` kills two terms, and

```
F(P) = -2(u^2+v^2)[(u^2-v^2)^2 + (u-v)^4] + 4(u^2+v^2)^2 (u-v)^2
     = 2(u^2+v^2)(u-v)^2 [ -(u+v)^2 - (u-v)^2 + 2(u^2+v^2) ]  =  0.
```

## 3. Why this is a countermodel

At the generic point of a common-factor surface `S`, the relevant local data is
the normalized two-dimensional slice ideal. The tuple `P` is exactly such a
datum: all five entries lie in `m^2 = (u,v)^2` and generate `m^2`, so on
`Bl_m(A^2)` the tuple divided by the local equation of `2E` restricts on
`E ≅ P^1` to the five quadrics themselves. By C4 that map is the 2-uple Veronese
followed by a linear isomorphism: an **embedding of `P^1` onto a smooth conic**
lying in `X`.

Hence the three assertions

* the generic slice ideal must be `(t, s^m)`,
* the generic exceptional curve must map to a line,
* every leakage block lies on the universal Fano-line incidence space,

all fail. The weighted-line derivation covered only the rank-two cell in which
`B(eta_S)` and `C(eta_S)` are independent — `[15]` section 6 already hedged this
("when `B` and `C` are proportional ... such higher-order cells remain open") —
and the higher normal jets can produce pointed conics or higher-degree rational
curves.

## 4. Scope of the countermodel — stated honestly

`P` is a **local/slice** witness: it is an exact map `P^1 → X` realising the
forbidden behaviour, with the exact base ideal `(u,v)^2` and an exact divisorial
common factor on a slice line. What it establishes is that the *local normal
form* is not forced — that no argument from the landing identity alone can
deliver "line" at the generic point of `S`.

It does **not** exhibit a global homogeneous `G`-covariant landing tuple `A` on
`P^4` whose common-factor surface has this normal behaviour. Producing one is
part of the boxed remaining problem (`BOXED_GLOBAL_COVARIANT.md`). The
distinction is recorded because it is exactly the distinction the boxed theorem
turns on.

## 5. What survives about lines

The conditional statement of `[20]` section 4 survives as a conditional and is
ported as such: for a line-type block, with `pi : I = P(T_{F(X)}) → F(X)` and
`e : I → X` the universal line, `eta = e^*H`, `C` the primitive invariant
incidence class, an orbit-summed incidence divisor of class
`[D] = r·eta + n·pi^*C` has cylinder endomorphism `T_D = ±2n·id` on `H^3(X)`,
the coefficient `r` cancelling. This controls the line-type subchannel only; it
says nothing about the conic slice above, and therefore proves **no** parity
statement for CLEAN. We port it as
`LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL` and do **not** replay its computation
here (it is not load-bearing for anything this packet claims).
