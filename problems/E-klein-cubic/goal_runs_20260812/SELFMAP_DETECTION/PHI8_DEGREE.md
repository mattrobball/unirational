# The topological degree of the canonical tangent-residual selfmap

Exits: `MINIMAL-EQUIVARIANT-TANGENT-FIELD-BOXED-OVER-Q`,
`DEGENERACY-LOCUS-ONE-DIMENSIONAL-DEGREE-72`,
`TANGENCY-DOUBLE-POINT-MULTIPLICITY-TWO`,
`PHI8-DELTA-COMPUTED`, `PHI9-DELTA-COMPUTED`,
`PHI8-NOT-CLEAN`, `PHI9-NOT-CLEAN`,
`RETRACTION-BRANCH-CARRIER-ONLY`,
`CARRIER-EXCLUSION-NOT-ACHIEVED`.

Verified exactly: `verify_phi8_degree.py` (`RESULT: PASS`, 149 checks, ~175 s).

**Problem E headline: OPEN.** No branch closes. What does change: the
retraction branch is now a **pure CARRIER question**, on an explicitly computed
curve.

---

## 0. One-paragraph summary

`SELFMAP_AUDIT.md` §7 (B1) records `delta(phi_8)` as not computed, with two
named obstacles. Both are settled here, and the first one settles **against**
the audit's expectation. The degeneracy locus `D_8 = {x in X : V_8(x) ^ x = 0}`
is not a finite set: it is **one-dimensional**, its one-dimensional part is
reduced of **degree 72**, so the line congruence `x |-> l_{x,V_8(x)}` is not a
morphism and the naive Chern-class count is void. The spurious solution `x = y`
has multiplicity exactly **2**, structurally (the line is tangent) and
computationally. With both settled, two independent exact computations give

```
              delta(phi_8) = 208 = 2^4 * 13,
              delta(phi_9) = 288 = 2^5 * 3^2.
```

`13` is inert in `Q(sqrt(-11))` and `v_13(208) = 1` is odd; `2` is inert and
`v_2(288) = 5` is odd. So **neither degree is represented by `x^2+xy+3y^2`**,
and by `THEOREM_RESTRICTED_DICHOTOMY.md` Theorem 3.1 neither `phi_8` nor
`phi_9` can be CLEAN. Via (S2) of `THEOREM_DETECTION_PRINCIPLE.md`: **if the
retraction branch is nonempty, the normalized graph of `phi_8` must carry a
CARRIER block** supported on a proper irreducible `T ⊆ Bs(J_{phi_8})` with
`dim T <= 1` satisfying `(AHS-Gamma)`. Excluding that is now the only remaining
step between here and `RETRACTION-BRANCH-DEAD`; it is **not** achieved in this
packet, and §7 says exactly why. As a by-product, `V_8` and `V_9` are boxed over
`Q` with integer coefficients, closing blowup point (B5).

---

## 1. `V_8` and `V_9`, boxed over `Q`

The audit computed `V_8` only modulo two primes and recorded (B5): an integral
model "is what a future packet would need in order to box `V_8` as a named
repository object". It is short. Normalize the one-dimensional space
`K_8/Z_8` by row-reducing `K_8` and `Z_8 = F·Cov_5 + x·Inv_7` in the monomial
basis and taking the unique class with zeros in the `Z_8` pivot columns; that
representative is defined over any field, and rational reconstruction of its
`F_p`-coordinates at two primes above `10^18` returns the same **integer**
vector at both. Since `V_i(x) = V_0(sigma^{-i}x)`, only the first component is
recorded; the rest are cyclic shifts.

```
V_8 = the G-covariant tuple of degree 8 with
      V_0 = x0^7x4 + x0^6x3^2 - 12 x0^5x1x2x4 + 7 x0^4x1^3x3 + ... + x2^3x4^5
      (40 terms, integer coefficients, max |coefficient| = 24;
       written out in full in verify_phi8_degree.py, block (0))
```

Exactly, over `Q`, in block (A) of the verifier:

| statement | why it matters |
|---|---|
| `deg V_8 = 8`, components integral, content 1 | it is the object the audit names |
| `tau`-weight covariance: every monomial of `V_i` has weight `a_i mod 11` | half of `G`-covariance, combinatorial and rational |
| `grad F . V_8 = c · F · h_7` (exact division, remainder `0`) | `V_8` is **tangent to `X`** — condition (2.1) |
| `x ^ V_8 != 0 (mod F)` | `V_8` is **not radial** — condition (2.2); the section is genuine |
| `deg F(V_8) = 24`, `deg Q(x,V_8) = 17`, `deg R = 25` | the sealed coordinate degree, re-derived from the boxed object |

`V_9` likewise (60 terms, max `|coefficient| = 406`, after clearing the
denominator `105`).

**It is the sealed field, not merely a tangent field.** Block (B) rebuilds the
`F_p` model with the machinery of `verify_selfmap_audit.py` copied verbatim,
re-checks `|<sigma,tau,iota>| = 660` and the `D_5` cross-check that pins the
model, recomputes `dim K_m - dim Z_m = N(m) = 1` for `m = 8, 9`, and verifies
that the boxed tuple reduces **into** `Cov_m` and **not into** `Z_m` — so it
spans `K_m/Z_m` and is, by the uniqueness of Theorem 3.1 of the audit, the
minimal equivariant tangent field. Block (B') upgrades this to characteristic
zero: `sigma`- and `tau`-covariance are exact over `Q`, and `iota`-covariance is
an identity in `Z[zeta_11]` whose coefficients obey the explicit archimedean
bound

```
|coefficient| <= 11^m ( S (5·61/100)^m + (5·61/100) S ),   S = sum |coeff V|,
```

because every entry of `iota` has absolute value `2 sqrt(11)/11 < 61/100` in
every embedding and a coefficient is bounded by the sup-norm on the unit
polydisc. Eleven primes above `10^18` are used, and their product exceeds the
tenth power of that bound, so a coefficient divisible by all eleven degree-one
primes is zero. This is a genuine characteristic-zero certificate, not a
two-prime heuristic.

---

## 2. Preliminary issue (i): the degeneracy locus is a **curve**

> **Theorem 2.1.** `D_8 := {x in X : V_8(x) ^ x = 0}` is one-dimensional. Its
> one-dimensional part is reduced of degree `72`. The saturated ideal
> `(F) + I_2[x ; V_8]` has Hilbert polynomial `72d + 147`.

*Proof.* The ideal is `(F)` together with the ten `2 x 2` minors `x_iV_j-x_jV_i`
of degree `9`. Over `F_p` its Gröbner basis is positive-dimensional (block
(D1)); the leading ideal has `116` minimal generators and its Hilbert function
stabilizes to `72d + 147` from `d = 20` on. Cutting by two independent random
hyperplanes gives, in both cases, a zero-dimensional system with eliminating
polynomial of degree `72` **equal to its squarefree part** — `72` distinct
points. So the one-dimensional part has degree `72` and is generically reduced
along every component. ∎

Two consequences, both needed below.

* Since a reduced curve of degree `72` has `chi(O) <= 72` and the scheme has
  `chi = 147`, the degeneracy scheme carries an additional zero-dimensional part
  of length at least `75`.
* Over `F_23` (where `G` is defined, `23 = 1 mod 11`) the `F_23`-points of `D_8`
  form a **single `G`-orbit of size 60**, and at every one of them `V_8`
  vanishes identically — not merely proportionally to `x`. `60` is the index of a
  Sylow-`11` subgroup of `G`.

**The audit's expectation was wrong in a way that matters.** `SELFMAP_AUDIT.md`
§7 (B1) says the degeneracy locus "is a determinantal locus of expected
dimension zero, so it is expected to be **nonempty**". The expected dimension is
right — `V_8` is a section of the rank-three bundle `T_X(7)` and
`int_X c_3(T_X(7)) = 3 · 467 = 1401` — but the actual locus is **excess**: a
curve, not `1401` points. Every Chern-class count for the congruence therefore
acquires an excess-intersection correction, and the naive answer is wrong; §5
records by how much, and why getting this wrong would have flipped the verdict.

---

## 3. Preliminary issue (ii): the spurious `x = y` multiplicity is `2`

Let `y in X` be a target and let

```
Z_y := { x in X : rank [ x ; V_8(x) ; y ] <= 2 } = { x in X : y in l_x }
```

be the incidence scheme, cut by the ten `3 x 3` minors together with `F`. Away
from `D_8` it is the zero scheme of the induced section of the rank-three
quotient `(W (x) O_X)/E`, `E = <x, V_8>`.

> **Lemma 3.1.** For every `y in X` with `V_8(y) ^ y != 0`, the point `x = y`
> lies in `Z_y` with multiplicity at least `2`, and generically exactly `2`.

*Proof.* Set `s_y(x) = y mod span(x, V_8(x))`. For `u in T_yX`,
`x = y + eps u` gives `y = (y+eps u) - eps u`, so
`ds_y(u) = -u mod span(y, V_8(y))`. The kernel is
`(span(y,V_8(y)) ∩ T̂_y)/<y>`, which is one-dimensional because `V_8(y)` lies in
the affine tangent space `T̂_y` — that is exactly the tangency
`grad F(y) . V_8(y) = 0` — and is not proportional to `y`. So `ds_y` has rank
`2`, not `3`, and `x = y` is not a reduced point. Equivalently: `l_y` is tangent
to `X` at `y`, so the length-three divisor `l_y . X` is `2y + phi_8(y)`. ∎

The verifier checks both inputs at every target used (block (D5)), and Route A
measures the multiplicity: `210` (minimal polynomial) against `209` (distinct
points) is exactly one double point, and removing `x = y` leaves `208` points
with minimal polynomial degree `208` — all simple. So the double point **is**
`x = y`, and its multiplicity is exactly `2`.

---

## 4. The degree, two independent routes

Fix a target `y in X`. Three explicit rational targets are used —
`y1 = (1,-2,-2,1,2)`, `y2 = (1,1,1,2,-2)`, `y3 = (2,3,-2,2,-1)` — plus three
random targets in `X(F_p)`, `p = 1000003`.

### ROUTE A — the line-congruence incidence scheme

Take `Z_y` as above and **invert a random linear combination of the ten `2 x 2`
minors of `[x ; V_8]`**, which is exactly localization away from the excess
curve `D_8`. The resulting system is zero-dimensional and is solved in all five
flag charts of `P^4` (`x_0=1`; `x_0=0,x_1=1`; ...), so nothing is lost at
infinity:

```
chart x_0 != 0 :  209 distinct points, minimal polynomial of degree 210
charts 1..4    :  empty
                                                      (two targets, two seeds)
```

Adding the further constraint `x != y`:

```
                  208 distinct points, minimal polynomial of degree 208
                                                              (three targets)
```

So the isolated part of `Z_y` off `D_8` has length `210 = 2 + 208`: the tangency
double point of Lemma 3.1, and `208` reduced points.

### ROUTE B — the point count

Parametrize the line instead of the rank condition. `x` in a flag chart, `t` a
new variable, and

```
F(x) = 0,     (x + t V_8(x)) ^ y = 0,     w·(x+tV_8(x))_k = 1,
u·t = 1,      z·Q(x, V_8(x)) = 1.
```

The last two constraints are what make the count exact rather than indicative.
`u·t = 1` removes the trivial solution `x = y`. `z·Q = 1` removes the base
locus: on `X`, `F(x+tV) = t^2 (Q + t F(V))` because `grad F . V_8 = 0 (mod F)`,
so a solution with `t != 0` has `Q + tF(V) = 0`; if `Q != 0` then `F(V) != 0`,
`t = -Q/F(V)`, and

```
x + tV_8(x) ~ F(V_8)x - Q(x,V_8)V_8 = R(x),
```

i.e. the solution is a genuine preimage under the degree-`25` tuple `R` and not
an artefact of the parametrisation. (Conversely `Q = 0` with `t != 0` forces
`F(V) = 0`, which is precisely `l_x ⊂ X`, i.e. `x in Bs(R)`.) The count:

```
chart x_0 != 0 :  208 distinct solutions, all simple
charts 1..4    :  empty
```

at all three rational targets, at `p = 1000003`, at `p = 2000003`, **and over
`Q` in characteristic zero** (msolve over the rationals, ~133 s), and at three
random targets of `X(F_p)`.

### The two routes agree

```
        ROUTE A: 210 - 2 (the tangency double point) = 208
        ROUTE B:                                       208
```

They are independent: Route A never uses `t`, `R`, or the residual-point
identity, and measures a multiplicity; Route B never uses the rank condition or
the excess curve, and measures a set of points certified to be preimages under
`R`. They share only `F` and `V_8`.

> **Theorem 4.1.** `delta(phi_8) = 208 = 2^4 · 13` and
> `delta(phi_9) = 288 = 2^5 · 3^2`.

*Proof of the lower bound.* Each of the `208` solutions is a distinct point of
`X` with `phi_8(x) = y`, so `#phi_8^{-1}(y) = 208`; `X` is normal, so Stein
factorization of `pr_2 : Gamma -> X` gives `#pr_2^{-1}(y) <= delta` whenever the
fiber is finite. Hence `delta >= 208`.

*Proof of the upper bound.* Let `Z'` be the closure of `Z \ (D_8 x X)` in
`X x X`; `pr_2 : Z' -> X` is proper and generically finite, so
`y |-> length(Z'_y)` is upper semicontinuous where it is finite. For a general
target `length(Z'_y) = delta + 2` by Lemma 3.1 and Route B; at our targets
Route A computes `210`. Hence `delta + 2 <= 210`, provided the target is not in
the image of `Z' ∩ (D_8 x X)`, which is a closed subset of dimension at most
two. ∎

The genericity proviso in the upper bound is real and is recorded in §7 as the
one residual caveat: it fails only if **every** target tested — three explicit
rational ones and three random points of `X(F_p)` with `p ~ 10^6`, the last of
which lie on a fixed surface with probability `~1/p` each — is special. `delta`
for `phi_9` is computed the same way, Route B, five flag charts, two targets.

**Consistency with the sealed identity.** `COMBINED_DEGREE_SIEVE`
Theorem 3.3 gives `delta = d'^3 - d' zeta - a` with `zeta = z/3 >= 1`,
`a >= 0`, `zeta <= d'^2`. For `d' = 25` and `delta = 208`: `25 zeta + a = 15417`
has solutions with `1 <= zeta <= 616` and `a >= 0`. Consistent; and since the
base scheme is one-dimensional, `1 <= delta <= d'^3 - d' = 15600` (Corollary
3.5) holds. The identity is an interval statement and does not by itself pin
`delta` — which is exactly why this packet had to compute it.

---

## 5. Why the naive count is wrong, and why that was dangerous

Had `D_8` been empty, the congruence order would be
`int_X c_3((W (x) O_X)/E)` with `E = O(-1) ⊕ O(-8)`, i.e.
`3 · (1+8+8^2+8^3) = 1755`, and Theorem 4.1 would have read
`delta = 1755 - 2 = 1753`. The bookkeeping was validated on a case where it is
checkable by hand — a plane cubic with `V = (0,z^2,-y^2)`, where the residual
map is `x |-> -2x` of degree `4`, the naive count is `3(1+2) = 9`, the
degeneracy locus is the three points `{x = 0}` and `9 = 3 + 2 + 4` — and it is
the excess term that carries the correction.

**And `1753 = 1^2 + 1·24 + 3·24^2` IS a norm.** Getting the degeneracy locus
wrong would have produced a CLEAN-compatible verdict and buried the lever. This
is recorded as an adversarial test (`ADVERSARIAL_TESTS.md` A17) and is checked
in block (E) of the verifier.

---

## 6. The detection test

`THEOREM_RESTRICTED_DICHOTOMY.md` (4.4) and `COMBINED_DEGREE_SIEVE` Theorem 4.1:
in the CLEAN branch `delta = N_{K/Q}(u_phi) = x^2+xy+3y^2`, and a positive
integer is so represented **iff `v_p` is even for every prime `p` inert in
`K = Q(sqrt(-11))`**, the inert primes being `p != 11` with
`p mod 11 in {2,6,7,8,10}` — so `2, 7, 13, 17, 19, 29, 41, 43, ...`.

```
delta(phi_8) = 208 = 2^4 · 13 :  13 mod 11 = 2 is a non-residue, 13 is INERT,
                                 v_13 = 1 is ODD          =>  NOT a norm
delta(phi_9) = 288 = 2^5 · 3^2:  2 is INERT, v_2 = 5 is ODD =>  NOT a norm
```

(The valuation criterion is cross-checked against brute-force representation for
every integer up to `400` in block (E).)

> **Theorem 6.1.** `phi_8` is not CLEAN. `phi_9` is not CLEAN. Neither is
> `phi_8^r` for odd `r` (`v_13 = r`), nor `phi_8 o phi_9`.

> **Corollary 6.2 (`RETRACTION-BRANCH-CARRIER-ONLY`).** Suppose some
> `A_0 in Land` is a retraction. Then by `THEOREM_DETECTION_PRINCIPLE.md`
> Theorem 3.3 every `psi in Self` is a restriction, in particular `phi_8` is;
> its normalized graph therefore satisfies the dichotomy of
> `THEOREM_RESTRICTED_DICHOTOMY.md` Theorem 3.1, and the CLEAN branch is
> impossible by Theorem 6.1. Hence `r_{phi_8} != 0` and there are a perverse
> degree `j_0`, a proper irreducible strict support `T ⊆ Bs(J_{phi_8})` with
> `dim T <= 1`, and `H = Stab_G(T)`, with
> ```
> Hom_{HS,H}( Res^G_H V , IH^{s-j_0}(T̄, L)(1) ) != 0,    V = H^3(X,Q)(1).
> ```
> The same holds for `phi_9` and for every odd iterate of `phi_8`.

This is the first time the arithmetic half of the detection lever fires on an
explicit self-map. Before this packet both halves were open
(`THEOREM_DETECTION_PRINCIPLE.md` §4.3: "Both halves are open"); now one half is
closed and the retraction branch is a pure CARRIER question.

---

## 7. What CARRIER now demands, and what is **not** proved

The candidate supports are the components of

```
Bs(J_{phi_8}) = { x in X : R(x) = 0 } = D_8  ∪  { x in X : F(V_8) = Q(x,V_8) = 0 },
```

the second piece being exactly the locus where the line `l_x` lies inside `X`
(Corollary 2.3 of the audit). Both facts used above hold on `D_8`: at a point
with `V_8 = lambda x` one has `F(V_8) = lambda^3F(x) = 0` and
`Q = 3lambda^2F(x) = 0`, so `R = 0`.

What is established about the candidate supports:

* `D_8` is a curve of degree `72`, reduced, with a `G`-orbit of `60` points on it
  at which `V_8` vanishes identically;
* its components are **not** all `F_p`-rational of small degree. Three random
  hyperplane slices at `p = 1000033` (`= 1 mod 11`, so `G` is `F_p`-rational)
  give eliminating polynomials of degree `72` whose irreducible factors have
  degrees `{2,4,4,4,18,40}`, `{4,18,50}` and `{4,6,12,24,26}`. A Frobenius orbit
  of `N` slice points lies on a Frobenius orbit of components whose **total**
  degree is at least `N`; so some orbit of components of `D_8` has total degree
  at least `26`, and at least `50` in one slice. In particular the components
  are not all individually `F_p`-rational of degree `<= 6`.

**What is not done.** The genus and the CM type of that curve are not computed;
neither is the primary decomposition of `Bs(J)`; neither is the local-system
question (the strict-support blocks are `IC_{T̄}(L)` and a nonconstant `L` can
make `IH^1` nonzero even on a rational `T`). The sealed non-CM data the work
order points at — `j = 8192/11`, an algebraic non-integer, hence non-CM — is
about the elliptic curves `E_t` of the `V14` fixed network
(`WORKORDER_STRATA_LIFTING_BLOCKERS.md` WP-3), not about the components of
`Bs(J_{phi_8})`; it does not apply here and is **not** used. So:

```
CARRIER-EXCLUSION-NOT-ACHIEVED.
```

`RETRACTION-BRANCH-DEAD` is **not** claimed. The boxed residual is exactly:

> **Box.** Exclude `(AHS-Gamma)` for every irreducible `T` of dimension `<= 1`
> inside `Bs(J_{phi_8})` — equivalently, show that no `G`-orbit of components of
> the degree-`72` degeneracy curve `D_8`, and none of the lines-in-`X` locus,
> admits a nonzero `H`-Hodge morphism from `Res^G_H H^3(X,Q)(1)` into
> `IH^{s-j_0}(T̄,L)(1)`. That single exclusion kills the retraction branch.

---

## 8. Non-claims

* `delta(phi_8) = 208` is proved as a lower bound unconditionally and as an
  upper bound for a target off an at-most-two-dimensional bad locus. Six
  independent targets (three rational, three random over `F_p`, `p ~ 10^6`) all
  give `208`, in two characteristics and by two routes; but no proof is offered
  that a specific named target is generic. This is the one caveat.
* Nothing here excludes CARRIER for any self-map, and no branch closes.
  `Problem E headline: OPEN.`
* The excess-intersection identity `delta = d'^3 - d' zeta - a` is checked for
  **consistency** only. `zeta` and `a` are not computed; the Segre class of the
  base scheme is not computed.
* The primary decomposition of `D_8` and of `Bs(J_{phi_8})` is not computed;
  §7 records only what the slices force.
* The count `1401 = int_X c_3(T_X(7))` is the *expected* number of zeros of
  `V_8` as a twisted vector field; the actual zero scheme is excess and no claim
  is made about how `1401` distributes over it.
* `V_8` is boxed over `Q`; `V_{10}` and beyond are not, and the audit's (B3)
  (coordinate degrees of the iterates) is untouched. Note however that
  `delta(phi_8^r) = 208^r` follows from multiplicativity of topological degree,
  independently of the coordinate degree of the iterate.

**Problem E headline: OPEN.**
