# FIX-N2 — the local cell classification at the V4 stratum

Program FIX ([E56]), packet **FIX-N2**.  Completes (as far as stated) the table
of Note II `theory/FIX_II_jets.md` §4.  Base packet:
`goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/`.

**Problem E headline: OPEN.**  Nothing here bears on the headline; these are
stalk statements in the sense of Note II §5.

---

## 0. Convention reconciliation

Everything below matches the base packet's `THEOREM.md` §1–§2 and `verify.py`.

* **Characters.**  `x,y,z` are normal coordinates of the three nontrivial
  `V4`-characters, `chi_1 chi_2 chi_3 = triv`.  We encode a character as a pair
  in `(Z/2)^2` and set `char(x^A y^B z^C) = ((A+C) mod 2, (B+C) mod 2)`; this is
  literally the encoding of `verify.py::check_j3_character_classification`
  (which is how the packet obtains `1_triv + 3_B + 3_C + 3_D` in degree six).
  `verify_cells.py` re-derives the same partition from the explicit `V4` sign
  action `diag(1,-1,-1), diag(-1,1,-1), diag(-1,-1,1)`, so nothing depends on
  the labelling convention.
* **Orders.**  Plus-planes `P_1 = (y,z)`, `P_2 = (x,z)`, `P_3 = (x,y)`
  (packet (1.3)); for a monomial `ord_{P_1} = B+C`, `ord_{P_2} = A+C`,
  `ord_{P_3} = A+B`, `ord_R = A+B+C` = the degree in `(x,y,z)`.
* **Cell `(m,r)`.**  `m` = common involution-plane order `= min_i ord_{P_i}`,
  `r` = triple-line order `= ord_R`.  This is the FIX-N2 brief's and Note II
  §4's convention.  Equivalently, a degree-`r` form lies in
  `J_m = (y,z)^m ∩ (x,z)^m ∩ (x,y)^m` iff **every exponent is `<= r-m`**, so

  ```
  m  =  r  -  (largest exponent occurring).
  ```

* **LETTER CLASH, resolved.**  The base packet's §4 uses `r` for the auxiliary
  index in `m = 2r+1`, `(J_m)_{3r+3} = (xyz)^{r-1}(J_3)_6`.  That is *not* the
  `r` of the brief.  Throughout this packet `r` is the triple-line order and the
  packet's §4 index is written `k`:  `m = 2k+1`, first permissible layer at
  `r = 3k+3`.  So the packet's populated stratum is the cell `(m,r) = (3,6)`
  for `k = 1`, `(5,9)` for `k = 2`, and so on.  Under this dictionary the
  packet's Theorem 2.12 is the cell `(1,3)`, and its §3 computation is the cell
  `(3,6)`.  Both are reproduced below from independent code (§7).
* **Klein constants.**  `om^2+om+1 = 0`; `kp + km = 13/8`, `kp*km = -1/2`, i.e.
  `8 kp^2 - 13 kp - 4 = 0`, `kp,km = (13 ± 3 sqrt 33)/16`, `(kp-km)^2 = 297/64`.
  Smoothness of the two character surfaces gives `kp, km != 0, -4` (packet
  (1.2)); we also use `kp != km` (true: `297 != 0`).
* **Landing family.**  A tuple `T = (a',b',u_0',u_1',u_2')` of forms in
  `(x,y,z)` with binary-form coefficients on the triple line, of the prescribed
  `K`-characters (`a',b'` trivial, `u_i'` of `chi_i`), residually
  `C_3`-equivariant projectively, with `F(T) = 0`.  "All line degrees" means:
  the binary coefficients have arbitrary degree `n >= 0`.

---

## 1. The shape of a cell (parity table, made explicit)

Lemma 2.2 of Note II, written out.  Put `U = x^2, V = y^2, W = z^2`.

* `r` **odd**, `d = (r-1)/2`:
  `a' = xyz*Q(U,V,W)`, `b' = xyz*S(U,V,W)` (`deg Q = deg S = d-1`),
  `u_0' = x*A_0(U,V,W)`, `u_1' = y*A_1`, `u_2' = z*A_2` (`deg A_i = d`).
* `r` **even**, `d = r/2`:
  `a' = P(U,V,W)`, `b' = R(U,V,W)` (`deg P = deg R = d`),
  `u_0' = yz*B_0(U,V,W)`, `u_1' = zx*B_1`, `u_2' = xy*B_2` (`deg B_i = d-1`).

Substituting into (1.1) and dividing by `xyz` (odd case) gives **exactly the
packet's equation (2.4)** with polynomial entries:

```
A_0A_1A_2 + r_0 U A_0^2 + r_1 V A_1^2 + r_2 W A_2^2 + c UVW = 0,          (odd)
r_0 = Q+S, r_1 = om Q + om^2 S, r_2 = om^2 Q + om S, c = kp Q^3 + km S^3;
```

and in the even case

```
kp P^3 + km R^3 + rho_0 VW B_0^2 + rho_1 WU B_1^2 + rho_2 UV B_2^2
       + UVW B_0B_1B_2 = 0,                                              (even)
rho_0 = P+R, rho_1 = om P + om^2 R, rho_2 = om^2 P + om R.
```

The packet's §2 is the odd case `d = 1` and its §3 is the even case `d = 3`
with the `m = 3` monomial restriction; both are re-derived in
`verify_cells.py`.

**Plane-order dictionary** (used constantly below).

* `m >= 1` odd `r`  ⟺ `A_0` has no `U^d`, `A_1` no `V^d`, `A_2` no `W^d`.
* `m = 1` exactly, odd `r` ⟺ in addition at least one of the six *corner*
  coefficients `[V^d]A_0, [W^d]A_0, [W^d]A_1, [U^d]A_1, [U^d]A_2, [V^d]A_2`
  is nonzero.  (At `d = 1` these six are precisely the packet's
  `alpha,beta,delta,gamma,epsilon,varphi`.)
* `m >= 1` even `r` ⟺ `P` and `R` have no `U^d, V^d, W^d`;
  `m = 1` exactly ⟺ some `B_i` contains a pure power of one of its two
  *other* variables.

Cell dimensions `(dim a', dim b', dim u_0', dim u_1', dim u_2')`, computed in
`cell_lib.cell_dims` (payload `PAYLOAD_dims.txt`):

| m \ r | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|
| 1 | 0,0,1,1,1 | 1,1,2,2,2 | 3,3,3,3,3 | 3,3,5,5,5 | 7,7,6,6,6 | 6,6,9,9,9 | 12,12,10,10,10 | 10,10,14,14,14 |
| 2 | — | 1,1,0,0,0 | 3,3,1,1,1 | 3,3,3,3,3 | 7,7,4,4,4 | 6,6,7,7,7 | 12,12,8,8,8 | 10,10,12,12,12 |
| 3 | — | — | — | 0,0,1,1,1 | 1,1,3,3,3 | 3,3,5,5,5 | 6,6,7,7,7 | 7,7,10,10,10 |
| 4 | — | — | — | — | 1,1,0,0,0 | 3,3,1,1,1 | 6,6,3,3,3 | 7,7,6,6,6 |
| 5 | — | — | — | — | — | — | 0,0,1,1,1 | 1,1,3,3,3 |

The first nonzero entry of each row is at `r = ceil(3m/2)` (Lemma 2.1); for odd
`m` it is `(0,0,1,1,1)` and the next layer is `(1,1,3,3,3)` (`m >= 3`) — Note
II's "type-II delay".  For even `m` the first layer is `(1,1,0,0,0)`.

---

## 2. The Specialisation Lemma (the packet's new instrument)

This replaces the base packet's "`[p:q]` is constant, and the only `C_3`-fixed
points are the character points" step by a statement that works at every `r`.

Let `sigma` generate the residual `C_3`.  On the triple line `sigma` has exactly
two fixed points, the character points; in coordinates `[s:t]` on `P(A) = P^1`
(so `(s,t) = (a,b)` up to scale) `sigma` acts by `s -> om^{e1} s`,
`t -> om^{e2} t` with `e1 != e2 mod 3` (or trivially, which is also covered
below); with the packet's normalisation `e1 = 1, e2 = 2`, and then
`sigma^*(l_i) = om * l_{i+1}` for `l_i = s - om^i t`, which is the packet §4
statement "cyclically permuted up to one common scalar".

Let `Theta` be the substitution `s -> om s, t -> om^2 t, (x,y,z) -> (y,z,x)`,
and let `g` be the residual `C_3` on `W`,
`g:(a,b,u_0,u_1,u_2) -> (om a, om^2 b, u_1, u_2, u_0)` — the substitution that
preserves the normal form (1.1) (verified in `verify_cells.py`).  Projective
`A_4`-equivariance of a family `T` reads

```
Theta(T) = lam * g(T),      lam in mu_3
```

(`lam` is a scalar: applying `Theta` three times gives `lam^3 = 1`; a
positive-degree `lam` is impossible once the common binary divisor of `T` is
cancelled, because `lam * Theta(lam) * Theta^2(lam) = 1`).

> **Lemma S (specialisation).**  Let `T != 0` be an `A_4`-equivariant
> simultaneous landing family of triple-line order `r` and common plane order
> `>= m`, with its common binary divisor cancelled.  Write
> `T = sum_{j>=0} t^j T_j` for the `t`-adic expansion at the `C_3`-fixed point
> `[1:0]`.  Then
>   1. every `T_j` is a `C_3`-equivariant **pointwise** `K`-tuple of degree `r`
>      lying in `J_m` (with the projective scalar `lam` replaced by
>      `lam * om^{-(n+j)}`, `n` = line degree);
>   2. `T_0 != 0`;
>   3. `F(T_0) = 0`.
>
> Consequently: **if the only `C_3`-equivariant pointwise tuple of degree `r`
> in `J_m` satisfying `F = 0` is the zero tuple, then there is no
> `A_4`-equivariant landing family of triple-line order `r` and plane order
> `>= m`, in any line degree whatsoever.**

*Proof.* (1) `Theta` multiplies `t^j (s-degree n-j)` by `om^{2j + (n-j)}`, so
the equivariance decouples over the `t`-grading and each `t`-graded piece
satisfies the pointwise equivariance with `lam` twisted by a cube root of unity;
the same computation with general weights `e1,e2` (including the trivial action)
only changes that cube root, and we quantify over all three values of the
scalar, so nothing is lost.  (2) `T_0 = T|_{t=0} = 0` would mean `t` divides
every coefficient, i.e. `t` divides the common binary divisor, which was
cancelled.  (3) `F(T) = 0` identically; its `t^0` level is `F(T_0)`.  Finally
the `(x,y,z)`-support of `T_0` is contained in that of `T`, so `T_0` lies in
`J_m` and is homogeneous of degree `r`. ∎

Both halves of Lemma S are re-verified symbolically on a generic bidegree
`(n,r) = (2,3)` family in `verify_cells.py`
(`check_specialisation_lemma`).

**How it is used.**  The space of `C_3`-equivariant pointwise tuples in
`(J_m)_r` is computed exactly (an eigenspace of `psi` over `QQ(om)`; the three
eigenvalue blocks have dimensions summing to the full cell dimension — this is
the arithmetic self-check printed by `produce_c3_equivariant.py`).  The landing
equations on it are homogeneous cubics, so the solution set is a cone; it is
trivial iff its affine dimension is `0`.  We decide that twice:

* `produce_c3_solve.py` — Macaulay2, `dim I`, over `ZZ/100057` with `om,kp,km`
  the exact Klein values reduced mod `p` (`om=1140, kp=74361, km=63219`);
* `verify_cells.py` — a **Macaulay rank computation** in one degree over the
  same field, implemented from scratch: if the degree-`D` Macaulay matrix has
  full rank mod `p` then it has full rank in characteristic zero, so
  `(v_0,...,v_k)^D ⊂ I` and the cone is `{0}`.  This direction is rigorous for
  the exact Klein values.

---

## 3. Two branches that die at every cell (uniform)

Independently of Lemma S, the following hold for **every** `(m,r)` and every
line degree, and are used to interpret the pointwise varieties.

> **Lemma B1.**  If `u_0' = 0` in an `A_4`-equivariant family then
> `u_1' = u_2' = 0` (residual `C_3`), and `F(T) = kp a'^3 + km b'^3 = 0`.  In
> the UFD `k[s,t,x,y,z]` this forces `a' = c_1 h`, `b' = c_2 h` with constants
> `c_i` and `kp c_1^3 + km c_2^3 = 0`; then `[c_1:c_2]` is a constant point of
> the three-point scheme, which the residual `C_3` (weights `om, om^2`) must fix
> — impossible since the fixed points `[1:0], [0:1]` need `kp = 0` or `km = 0`,
> excluded by (1.2).  So `T = 0`.

> **Lemma B2.**  If `a' = b' = 0` then `F(T) = u_0'u_1'u_2' = 0`, so some
> `u_i' = 0`, and Lemma B1 applies.  So `T = 0`.

These are the all-line-degree versions of the packet's "type-II triple" and
"image in a triangle edge" branches (its (2.10), (2.11)).

---

## 4. Results

### 4.1 Order-`r` emptiness (the main output)

> **Theorem A.**  For `r = 2, 3, 4, 5` the only `C_3`-equivariant pointwise
> tuple of degree `r` in `J_1` with `F = 0` is zero, for each of the three
> projective scalars `lam in mu_3`.  Hence **no `A_4`-equivariant simultaneous
> landing family with common plane order `>= 1` and triple-line order
> `r in {2,3,4,5}` exists, in any line degree.**

Certified twice (Macaulay2 `dim I = 0`; independent Macaulay rank over
`F_100057`).  Payload: `PAYLOAD_c3_cones.txt`.

Consequences, cell by cell:

* `(1,2)` **EMPTY** (also elementarily: the unique shape is
  `(0,0, A yz, B zx, C xy)`, the landing equation is the single equation
  `ABC = 0`, and residual `C_3` turns `A = 0` into `A = B = C = 0`).
* `(1,3)` **EMPTY** — this is the base packet's Theorem 2.12, re-proved from
  scratch and *strengthened*: the whole `m >= 1` stratum at `r = 3` is empty,
  not only the exact-order-three one.
* `(1,4)`, `(1,5)` **EMPTY** — new; the first two open cells of the
  principal target.
* `(2,3)`, `(2,4)`, `(2,5)` **EMPTY**; `(3,5)` **EMPTY** (the type-II delay
  cell, also immediate from Lemma B2 since its shape is `(0,0,1,1,1)`).

### 4.2 The even-`m` bottom cell, for every even `m` (uniform)

> **Theorem B.**  For every even `m`, the bottom cell `(m, 3m/2)` is EMPTY for
> all line degrees.

*Proof.*  At `r = 3m/2` every exponent must be `<= r-m = m/2` and they sum to
`3m/2`, so all three equal `m/2`: the only monomial is `(xyz)^{m/2}`, of trivial
character.  Hence `u_i' = 0` and Lemma B1 applies. ∎

(Concretely `a' = p (xyz)^{m/2}`, `b' = q (xyz)^{m/2}`, and the landing equation
is exactly `kp p^3 + km q^3 = 0`.)

### 4.3 The `xyz`-shift (propagation, in both directions)

`xyz` is `K`-invariant (all exponents odd, so trivial character), is
`psi`-invariant, and has `ord_{P_i}(xyz) = 2` for each `i`.  Since
`F(xyz*T) = (xyz)^3 F(T)`, multiplication by `xyz` sends an `A_4`-equivariant
landing family at `(m,r)` to one at `(m+2, r+3)`, with the same projective
scalar `lam` and the same line degree.  Hence:

> **Lemma C (population shift).**  `(m,r)` populated `=>` `(m+2,r+3)` populated.

> **Lemma C' (emptiness shift).**  If `r <= 2m` then
> `(J_{m+2})_{r+3} = xyz * (J_m)_r`, and therefore `(m,r)` is empty (all line
> degrees) **iff** `(m+2,r+3)` is.

*Proof of C'.*  A degree-`(r+3)` monomial in `J_{m+2}` has all exponents
`<= r-m+1`; if one exponent were `0` the other two would sum to `r+3 <=
2(r-m+1)`, i.e. `r >= 2m+1`. ∎

So Theorem A propagates: `(1,2) -> (3,5) -> (5,8) -> ...` all EMPTY;
`(2,3) -> (4,6) -> (6,9) -> ...` all EMPTY (also Theorem B);
`(2,4) -> (4,7)` EMPTY.  (`(1,3)` does **not** propagate to `(3,6)`: there
`r = 3 > 2m = 2`, and indeed `(3,6)` is populated.)

Note the parity consequence used repeatedly below: for a `K`-**invariant** form
`G`, `ord_{P_i}(G)` is always **even** (the exponents of any monomial of `G`
have equal parities, so `ord_{P_1} = B+C` is even).  Hence dividing a family by
the largest invariant factor of the gcd of its components lowers `m` by an even
number.  **A family at `m = 1` is therefore automatically primitive for
invariant factors** — it cannot be obtained by multiplying a lower cell by an
invariant.  This is exactly why `m = 1` is the hard row and `m = 2` is not.

### 4.4 The populated side: a generalised §4 construction

The base packet's §4 family is one member of a one-parameter *family of
constructions*.

> **Theorem D.**  Let `X` be any form of degree `delta` in `(x,y,z)` of
> character `chi_1`, put `Y = psi(X)`, `Z = psi^2(X)` with
> `psi:(x,y,z)->(y,z,x)`, and let `B` satisfy `(B^3-1)^2/B^3 = kp`.  Then
>
> ```
> a' = -XYZ,  b' = 0,
> u_0' =      X(X^2 + B Y^2 + B^{-1} Z^2),
> u_1' = om   Y(Y^2 + B Z^2 + B^{-1} X^2),
> u_2' = om^2 Z(Z^2 + B X^2 + B^{-1} Y^2)
> ```
>
> is a `K`-equivariant landing tuple of triple-line order `r = 3 delta` which is
> residually `C_3`-equivariant with projective scalar `lam = om^2` — i.e. an
> `A_4`-equivariant landing family already at line degree `0`.  Diagonal
> precomposition `x -> l_0 x, y -> l_1 y, z -> l_2 z` (packet (4.3)) turns it
> into a primitive family of positive line degree without changing `(m,r)`.

The scalar bookkeeping matters and is the reason the packet's (4.1) needs the
extra `om, om^2`: the rescaling that turns `F|_{b=0}` into
`kappa w^3 + w(v_0^2+v_1^2+v_2^2) + v_0v_1v_2` is
`a = w, u_0 = v_0, u_1 = om v_1, u_2 = om^2 v_2` (then `kappa = kp`), and
exactly with these factors `Theta(T) = om^2 g(T)` holds.  Verified in
`verify_cells.py`.

> **Theorem E (the plane orders this construction reaches).**  Let
> `p_i = ord_{P_i}(X)`.  Then `p_2, p_3 >= 1` always (a pure power `y^delta` or
> `z^delta` cannot have character `chi_1`), and:
> * if `p_1 = 0` (i.e. `X` contains `x^delta`, possible only for odd `delta`)
>   then `u_0'` contains `x^{3delta}` with no possible cancellation, so `m = 0`;
> * otherwise `min(p_1,p_2,p_3) >= 1` and
>   `ord_{P_i}(T) >= 3 min_j p_j >= 3`, so `m >= 3`.
>
> So the construction itself yields `m = 0` or `m >= 3`, never `1` or `2`.
> Combined with Lemma C (`xyz`-shift by `(m,r) -> (m+2,r+3)`), the plane orders
> reachable from it are
>
> ```
> {2k : k >= 0}  ∪  {m_0 + 2k : m_0 >= 3, k >= 0}   —   never m = 1.
> ```

> **Corollary E' (a populated even-`m` cell).**  Taking the `delta = 1` seed
> `X = x` (which has `(m,r) = (0,3)`) and multiplying by `xyz` gives an
> `A_4`-equivariant landing family at **`(m,r) = (2,6)`**:
>
> ```
> a'  = -(xyz)^2,   b' = 0,
> u_0' = x^2 y z (B^2 y^2 + B x^2 + z^2)/B,
> u_1' = om   x y^2 z (B^2 z^2 + B y^2 + x^2)/B,
> u_2' = om^2 x y z^2 (B^2 x^2 + B z^2 + y^2)/B,       kp = (B^3-1)^2/B^3,
> ```
>
> residual `C_3` scalar `lam = om^2`, line degree `0` (positive after the `l_i`
> precomposition).  Verified in characteristic zero.  More generally
> `(2, 3 delta + 3)` is populated for every odd `delta` (take `X = x^delta`),
> and `(2k, 3 delta + 3k)` likewise.
>
> **This was found by machine**: the `msolve` probe of the `r = 6`
> `C_3`-equivariant cone reported that the plane-order-2 coefficient of `u_0'`
> at `x^4yz` can be nonzero, and the point it produced turned out to be exactly
> `xyz` times the seed.

Explicit members (all verified in characteristic zero to land, to be
residually `C_3`-equivariant with `lam = om^2`, and to have the stated
`(m,r)` — `verify_cells.py`, `PAYLOAD_witnesses.txt`):

| tuple | `(m,r)` | note |
|---|---|---|
| `X = x` | `(0,3)` | the seed |
| `X = yz` | `(3,6)` | the base packet's §4 family |
| `xyz * (X = x)` | `(2,6)` | **new — an even-`m` cell is POPULATED** |
| `(x^2+y^2+z^2) * (X = yz)` | `(3,8)` | **new** — above the first `m=3` layer, imprimitive |
| `X = x y^2` | `(3,9)` | **new** — above the first `m=3` layer, primitive |
| `X = x^2 y z` | `(6,12)` | |

### 4.5 Cells above the first layer at odd `m` (Task 3)

> **Theorem F.**  For `m = 3` there exist `A_4`-equivariant landing families
> whose first nonzero common-line layer lies strictly above the first
> permissible layer `(J_3)_6`:
> * `(3,8)`: multiply the §4 family by the `C_3`-invariant `x^2+y^2+z^2`
>   (which has `ord_{P_i} = 0`, so `m` stays `3`, while `r` becomes `8`);
> * `(3,9)`: the primitive witness `X = x y^2` of Theorem D — **not** of the
>   form `(invariant) * (lower family)`.
>
> The same holds at every odd `m = 2k+1`: multiplying by `(xyz)^{k-1}` sends
> `(3,r) -> (2k+1, r+3(k-1))`, so the layers `r = 3k+5` and `r = 3k+6` above the
> first permissible layer `r = 3k+3` are populated.

So the Note II row "odd `m >= 3`, above the first layer" is **POPULATED**, not
empty; the honest refinement is that above the first layer one must distinguish
*imprimitive* population (an invariant times a lower family) from *primitive*
population, and both occur.

---

### 4.6 The `r = 6` cone, resolved by plane order

An `msolve` probe (`probe_order1_r6.py`) decides, for each coefficient of each
monomial realising plane order exactly `1` (resp. `2`), whether it can be
nonzero on the `C_3`-equivariant solution cone at `r = 6`.  Result:

* **no plane-order-1 point** in any of the three `lam`-blocks;
* plane-order-2 points **exist** in the `lam = om` and `lam = om^2` blocks —
  and they are exactly `xyz` times the seed (Corollary E').

Consequently `(1,6)` is **not populated at line degree zero**, whereas `(2,6)`
**is populated**.

## 5. What is NOT proved

* **`m = 1`, general `r >= 6`.**  Theorem A is a per-`r` finite computation.
  It is done for `r <= 5`.  At `r = 6` the `C_3`-equivariant pointwise cone is
  *not* trivial (the §4 family and `xyz*seed` sit there), so Lemma S alone
  cannot close `(1,6)`; by Lemma S plus §4.6 the bottom `t`-graded piece `T_0`
  of any `m = 1`, `r = 6` family must be one of the plane-order `>= 2`
  solutions, and closing the cell requires one further step of the ladder,
  namely showing
  `{ e in C_3-equivariant (J_1)_6 : Phi(T_0,T_0,e) in J_9 } ⊂ (J_2)_6`.  That
  step is **not** carried out here.
* **`r >= 7`.**  The full triviality decision at `r = 7` (13 free parameters,
  18 orbit-reduced cubic equations) did not terminate within this packet's
  budget in any of the three engines.  Note that `(2,7)` and `(3,7)` would need
  an `m=0` family of order `4`, resp. a primitive `m=3` family of order `7`, and
  no construction is known for either; `r = 8` and `r = 9` are populated
  (`(3,8)`, `(3,9)`).
* The plane-order-graded criterion (`F(T-bar) in J_{3m+1}` for the leading
  layer `T-bar`) is *vacuous* at `(1,6)`: the order-exactly-one layer at `r=6`
  has `a' = b' = 0` and `u_i'` supported on `y^5z, yz^5` and cyclic, whose
  product automatically has plane order `8 >= 4`.  So that shortcut does not
  decide `(1,6)` either; recorded so that it is not re-attempted.
* Consequently **the principal target — `m = 1`, all `r >= 4`, all line degrees
  — is settled only for `r = 4, 5`**, and remains OPEN in general.  What is now
  known in its favour: no `m = 1` family exists at `r <= 5`; none exists at
  `r = 6` at line degree zero; and by Theorem E plus the parity of
  `ord_{P_i}(invariant)` no `m = 1` family can be built by multiplying a lower
  cell by an invariant — an `m = 1` family would have to be genuinely
  primitive, unlike the `m = 2` population found here.

---

## 6. Completed Note II §4 table

| cell | status | source |
|---|---|---|
| `m=1`, `r <= 1` | forbidden by the cone | Lemma 2.1 |
| `m=1`, `r = 2` | **EMPTY**, all line degrees | Thm A (+ elementary proof, §4.1) |
| `m=1`, `r = 3` | **EMPTY**, all line degrees | packet Thm 2.12; re-proved & strengthened (Thm A) |
| `m=1`, `r = 4` | **EMPTY**, all line degrees | **Thm A (new)** |
| `m=1`, `r = 5` | **EMPTY**, all line degrees | **Thm A (new)** |
| `m=1`, `r = 6` | not populated at line degree `0`; OPEN for positive line degree (one explicit ladder step) | **§4.6 (new)**, §5 |
| `m=1`, `r >= 7` | **OPEN** (per-`r` decidable by Lemma S; `r=7` did not terminate) | §5 |
| `m=2`, `r = 3` | **EMPTY**, all line degrees | Thm A, Thm B |
| `m=2`, `r = 4,5` | **EMPTY**, all line degrees | **Thm A (new)** |
| `m=2`, `r = 6` | **POPULATED** — `xyz` times the `delta=1` seed | **Cor. E' (new)** |
| even `m`, bottom cell `(m,3m/2)` | **EMPTY**, all line degrees, every even `m` | **Thm B (new)** |
| even `m`, `(m+2,r+3)` shifts of empty cells with `r <= 2m` | **EMPTY** | **Lemma C' (new)** |
| even `m = 2k`, `(2k, 3delta+3k)`, `delta` odd | **POPULATED** | **Cor. E' + Lemma C (new)** |
| `m=3`, `r = 5` (type-II delay) | **EMPTY**, all line degrees | Thm A; Lemma B2; Lemma C' from `(1,2)` |
| `m=3`, `r = 6` (first layer) | **POPULATED** | packet §4 = T5 witness; re-verified |
| odd `m>=3`, above the first layer | **POPULATED** — witnesses `(3,8)` (imprimitive) and `(3,9)` (primitive) | **Thm D/F (new)** |
| any cell with `m = 1` | none known; unreachable by invariant multiplication (parity of `ord_{P_i}` on invariants) | **§4.3, Thm E (new)** |

---

## 7. Cross-checks (Task 5)

* **Packet Theorem 2.12 machinery.**  `verify_cells.py::check_packet_m1_r3`
  rebuilds the tuple (2.1), divides `F` by `xyz`, matches the result termwise
  against (2.4), reproduces the six factored equations (2.5) and the central
  equation (2.6) exactly as printed in `THEOREM.md`, substitutes (2.7) and
  obtains `c + 4 r_0r_1r_2` (2.8).  Independent code path from the base
  packet's `verify.py`.  Theorem 2.12 itself is then re-obtained as the `r = 3`
  case of Theorem A — by a completely different argument (Lemma S instead of
  the `[p:q]`-constancy argument), and in the stronger form "the whole `m>=1`,
  `r=3` stratum is empty".
* **Packet §4 family.**  `verify_cells.py::check_section4_and_generalisation`
  re-derives the trisection identity as an identity in three free variables,
  checks that the rescaled tuple satisfies the Klein normal form `F = 0` with
  `kp = (B^3-1)^2/B^3`, and checks the residual-`C_3` equivariance with
  `lam = om^2` — a property the base packet asserts ("projective-character
  `A_4`-equivariant") but does not exhibit; the exact scalars are recorded in
  Theorem D.
