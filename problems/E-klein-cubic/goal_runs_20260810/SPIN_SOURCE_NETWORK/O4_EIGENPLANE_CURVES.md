# Census cell (O4): curves in the eigenplanes and the eigen-line strata

`SUPPORT_CENSUS.md` §6 boxes five surviving cells and singles out `(O4)` as
"the only cell that looks finite and explicit enough to be decided by the
existing machinery", with the closing move named as *"excluding `E_{-11}` from
the Jacobians of the `C_6`-stable plane curves in the 110 eigenplanes — an
explicit, finite-looking question"*.

This file works the cell out.  The verdict is **O4-SPLIT**, and the census's
optimism is **corrected**: the question is not finite, and its answer is the
wrong way round.  Four subcells die unconditionally in the
constant-coefficient channel; the rest survives, and survives *with an
explicit witness* — a plane cubic isomorphic to `E_{-11}` sitting
`C_6`-equivariantly in every one of the 110 eigenplanes, satisfying every
necessary condition the Hodge-support package can impose.  So `(O4)` is not
merely open: it **cannot be closed by this machinery at all**, and the sharp
cells are `(O2)` and `(O3)`.

Machine: `python3 verify_o4_census.py` → `O4_CENSUS_OK`, 92 assertions, exact,
a couple of seconds.  Section references `§A`-`§F` point at that script.

Standing notation: `G = PSL(2,F_11)`, `Gtilde = SL(2,F_11)`, `V = U` the
6-dimensional spin irreducible, `P(U) = P^5`, `n = 6`;
`T = H^3(V14,Q)(1)`, `chi_T = (10,2,-2,0,2,-1)` on element orders
`(1,2,3,5,6,11)`; `S` an irreducible strict support, `H = Stab_G(S)`,
`H_0` its pointwise kernel, `s = dim S`, `j_0` the perverse jump.

---

## 1. The eigenplane, exactly: what acts and how

> **Theorem O4-1 (the residual action is the diagonal `C_3`).**  Let `sigma`
> be an involution of `G`, `Pi = P(U_{+i}(sigmatilde)) ~ P^2` one of its two
> eigenplanes.  Then
>
> 1. `sigma` acts **trivially** on `Pi` (the lift acts on `U_{+i}` by the
>    single scalar `i`);
> 2. `Stab_G(Pi) = C_6 = <sigma> x C_3` exactly, and the six reflections of
>    `C_G(sigma) = D_12` swap the two planes;
> 3. the residual group `C_6/<sigma> = C_3` acts on `Pi ~ P^2` with **three
>    distinct eigenvalues** — in suitable coordinates `diag(1, w, w^2)`,
>    `w = e^{2 pi i/3}` — so its fixed locus in `Pi` is exactly **3 isolated
>    points**, and these are the three `C_6`-fixed points of the plane.

*Proof (§A, §B).*  The preimage of `C_6` in `Gtilde` is the cyclic group
`C_12 = <gtilde>`; `chi_W` on its powers is `(12,0,0,0,0,0,-12,0,0,0,0,0)`, so
orthogonality inside `Z[zeta_12]` gives multiplicity `2` for each of the six
**spin** characters `gtilde -> zeta_12^k`, `k` odd, and `0` for the rest.
`sqrt(-11)` is not in `Q(zeta_12)` (conductor 12), so the halving principle
applies verbatim and `U|_{C_12}` is multiplicity-free on those six.  Now
`sigmatilde = gtilde^3` acts on the character `k` by `i^k` and
`ctilde = gtilde^4` by `w^k`.  The three `k` with `i^k = +i` are
`k = 1, 5, 9`, and `k mod 3 = 1, 2, 0` — pairwise distinct.  That is (1) and
(3); (2) is the sealed `KLEIN_SPIN_COMPLEX.md` §2, re-verified here by
computing `Stab_G` of the eigenspace directly in the 12-dimensional monomial
model (order 6) and by exhibiting the 6 swapping elements of `D_12`.  `QED`

(3) is the reason the cell is not vacuous *and* the reason it is not finite:
`diag(1,w,w^2)` is exactly the standard-Hesse `C_3`, whose invariant curves
form positive-dimensional families in every degree `>= 3`.

> **Theorem O4-2 (stabilisers and orbits).**  Let `S subset Pi` be an
> irreducible **curve**.  Then
> \[
> H_0 = <\sigma> = C_2\ \text{exactly},\qquad H\in\{C_2,\;C_6\},
> \]
> with `G`-orbit of size `330` (`H = C_2`, three curves in each plane,
> permuted by the residual `C_3`) or `110` (`H = C_6`, one per plane).

*Proof.*  Two distinct eigenplanes meet in at most a point (the complete
5995-pair incidence table, `KLEIN_SPIN_COMPLEX.md` §2), so `h(S) = S` forces
`h(Pi) = Pi`, i.e. `H <= Stab_G(Pi) = C_6`.  `sigma` fixes `Pi` pointwise, so
`C_2 <= H_0`.  `H_0 = C_6` would put the curve `S` inside `Fix_Pi(C_3)` = 3
points, impossible.  Orbit sizes are `660/|H|`.  `QED`

This is the promised sharpening of cell `S1` of the census table
(`H_0 = C_2`, `H in {C_2, C_6}`): the residual action is now pinned, not just
the stabiliser.

---

## 2. The channels

`Res_{C_6} T = 2(psi_0 + psi_1 + psi_2 + psi_4 + psi_5)`, `psi_3` absent
(§C; the census's §D').  Write `psi_k(g) = zeta_6^k` for a generator `g` of
`C_6` with `sigma = g^3`, so `psi_k` is `sigma`-trivial iff `k` is even.

In the classical channel `(i,s) = (1,1)`, hence `j_0 = s+4-n-i = -2`, the
carrier attached to `(S, L)` with `L` of trivial monodromy is
`IH^1(Sbar, L)(1) = H^1(Stilde, Q) (x) L`, where the `C_6`-action on the
rank-one `L` is by a character `psi_j` (the equivariant structure) and `C_6`
acts on `H^1(Stilde)` through `C_3`.

> **Proposition O4-3 (the channel table).**  Decompose
> `H^1(Stilde,C) = (+)_{a=0,1,2} H^1_a` into `C_3`-isotypic parts (`c` acts by
> `w^a` on `H^1_a`).  Then the `(a,j)` constituent of the carrier is the
> `C_6`-character `psi_{(2a+j) mod 6}`, and (AHS-spin) can be satisfied there
> only if that character occurs in `Res_{C_6}T`, i.e. only if
> \[
> 2a+j\not\equiv 3 \pmod 6 .
> \]
> Consequently: for a `sigma`-trivial equivariant structure (`j` even) **all
> three** `C_3`-channels are live; for each `sigma`-sign structure
> (`j` odd) **exactly one** `C_3`-channel is dead, namely `a = 1` for `j = 1`,
> `a = 0` for `j = 3`, `a = 2` for `j = 5`.

The case `(a,j) = (0,3)` is the census's kill **K-d** (`psi_3`-isotypic blocks
at a `C_6`-support are dead); `psi_3` and the trivial `C_3`-character are both
rational, so that one is a genuine `Q`-level kill.  The other two dead pairs
involve characters that are Galois-conjugate over `Q`, and are stated at `C`
level.

Note also `dim T^H > 0` for every stabiliser occurring anywhere in this cell
(`C_2: 6`, `C_3: 2`, `C_5: 2`, `C_6: 2`, `D_10: 2`, `D_12: 2` — §C), so by
Frobenius reciprocity **no orbit in `(O4)` is excluded by the permutation
character**.

---

## 3. Degree by degree

Let `S = {F = 0} subset Pi` be `C_3`-stable of degree `delta`.  Since the
lift `ctilde` has order 3, `c^*F = w^{eps}F` for a weight `eps in Z/3`.  For
`S` **smooth**, adjunction gives `H^0(Omega_S) = {G : deg G = delta-3}`
twisted by `w^{-eps}` (the form `x_0 dx_1 ^ dx_2 - ...` has weight
`0 + (-1) + (-2) = 0`), and `H^1 = H^0(Omega) (+) conj`.  §D computes the
resulting `(m_0,m_1,m_2)`:

| `delta` | `eps` | `g` | `(m_0,m_1,m_2)` | dead equivariant structures |
|---:|---:|---:|---|---|
| 3 | 0 | 1 | `(2,0,0)` | `psi_3` only |
| 3 | 1,2 | 1 | `(0,1,1)` | none |
| 4 | any | 3 | `(2,2,2)` | none |
| 5 | any | 6 | `(4,4,4)` | none |
| 6 | 0 / 1,2 | 10 | `(8,6,6)` / `(6,7,7)` | none |
| 7 | any | 15 | `(10,10,10)` | none |
| 8 | any | 21 | `(14,14,14)` | none |

> **Proposition O4-3' (the general principle above `delta = 3`).**  For every
> `delta >= 4` and every weight `eps`, all three `C_3`-channels of
> `H^1(Stilde)` are nonzero.  Hence **no equivariant structure kills a
> smooth `C_3`-stable plane curve of degree `>= 4`**; character arithmetic
> stops working at `delta = 4`.

*Proof.*  All three weight classes occur among the monomials of degree
`delta - 3 >= 1` (e.g. `x^{d}`, `x^{d-1}y`, `x^{d-1}z`), so every `n_b >= 1`
and `m_a = n_a + n_{-a} >= 2`.  §D3'.  `QED`

The only degree with any arithmetic left in it is therefore `delta = 3`, and
there the answer is complete:

> **Theorem O4-4 (the cubic dichotomy).**  Let `S subset Pi` be an
> irreducible `C_3`-stable plane cubic.
>
> 1. If `S` is **singular**, its geometric genus is 0, so
>    `IH^1(Sbar,Q) = H^1(Stilde,Q) = 0` and `S` carries nothing: **DEAD**.
> 2. If `S` is smooth of weight `eps != 0`, then all three coordinate points
>    lie on `S` (no `x_j^3` has nonzero weight, §D2), so the induced order-3
>    automorphism of the elliptic curve `S` **fixes a point**; taking it as
>    the origin, `Aut(S,0) contains Z/3`, hence `j(S) = 0` and
>    `End(S) (x) Q = Q(sqrt(-3))`.  Since `Res_H T` is `E_{-11}`-isotypic
>    (Theorem S0(2)) and `Q(sqrt(-3)) != Q(sqrt(-11))`,
>    `Hom_{HS}(Res_H T, H^1(S)) = 0`: **DEAD**.
> 3. If `S` is smooth of weight `eps = 0`, then `S` is a member of the Hesse
>    family `a x^3 + b y^3 + c z^3 + d xyz` (§D1), the `C_3`-action on it is
>    **fixed-point-free** (no coordinate point lies on a Hesse member with
>    `abc != 0`, §D15), hence is translation by a 3-torsion point, hence acts
>    **trivially** on `H^1(S)`.  Channel `a = 0`, alive for every `psi_j` with
>    `j != 3`: **OPEN**.

The computed `(m_0,m_1,m_2) = (2,0,0)` at `(delta,eps) = (3,0)` and
`(0,1,1)` at `eps != 0` is exactly this geometry seen through characters, and
the two computations were done independently (monomial weights vs. the
translation/fixed-point analysis).  They agree.

---

## 4. The witness — why `(O4)` cannot be closed

> **Theorem O4-5 (an `E_{-11}` plane cubic in every eigenplane).**  Let `Pi`
> be any of the 110 eigenplanes.  There is a smooth `C_3`-stable cubic
> `S subset Pi` with `S ~= E_{-11}`, `Stab_G(S) = C_6`, `H_0 = C_2`, the
> `C_3`-action on `S` a translation by a 3-torsion point, and
> `H^1(S,Q) ~= H^1(E_{-11},Q)` acted on trivially by `C_6`.  Its `G`-orbit is
> a `G`-invariant curve `S_G = union_{110} gS subset P(U)` of degree 330.
> For every `psi_j` with `j != 3`,
> \[
> \operatorname{Hom}_{\mathrm{HS},C_6}\!\left(\operatorname{Res}_{C_6}T,\;
> H^1(S,\mathbf Q)\otimes\psi_j\right)\;\neq\;0 ,
> \]
> i.e. `(AHS-spin)` and its refinement (5.2) are **satisfied**, and Cor S4's
> floor `k(C_6) = 1` is met exactly.

*Proof.*  Put `E = E_{-11}`, `tau in E[3]` nonzero, `L = O_E(3.0)`.  Since
`deg L = 3`, `t_tau^* L ~= L` iff `3 tau = 0`, which holds; so translation by
`tau` preserves the linear system and induces a linear automorphism of
`P(H^0(L)^dual) = P^2`, which can be taken of order 3 (the theta group of odd
level 3 has exponent 3).  Its fixed locus in `P^2` is either three isolated
points or a point plus a line; the latter is impossible, because such a line
would meet the cubic `E` in three points, all fixed by a **fixed-point-free**
translation.  So the induced action is conjugate to `diag(1,w,w^2)`, which by
Theorem O4-1(3) is precisely the residual `C_3`-action on `Pi`.  Choose a
`C_3`-equivariant projective isomorphism `P(H^0(L)^dual) -> Pi` and let `S` be
the image of `E`: a smooth `C_3`-stable plane cubic isomorphic to `E_{-11}`.
Translations act trivially on cohomology, so `C_3` — and `sigma`, which acts
trivially on all of `Pi` — act trivially on `H^1(S)`.  `Stab_G(S) = C_6` by
Theorem O4-2.  Because `S` is `C_6`-stable, `gS` depends only on the coset
`gC_6`, so `S_G` is a well-defined `G`-invariant curve with one component in
each plane, of degree `110 x 3 = 330`.

For the Hom: `T^{C_6}` is a 2-dimensional sub-Hodge structure of `T` (§C,
`dim T^{C_6} = 2`), and by Theorem S0(2) every sub-Hodge structure of `T` is
`E_{-11}`-isotypic, so `T^{C_6} ~= H^1(E_{-11},Q)` as a `Q`-Hodge structure.
Project `Res_{C_6}T` onto its `psi_0`-isotypic part and compose with an
isomorphism onto `H^1(S,Q)`: nonzero, `C_6`-equivariant, a morphism of Hodge
structures.  Twisting by `psi_j` moves the source channel from `psi_0` to
`psi_j`, which occurs in `Res_{C_6}T` for every `j != 3`.  `QED`

*Corroboration, independent of the `(E,tau)` argument.*  The `C_3`-invariant
cubics of `Pi` are exactly the Hesse family (§D1), whose pencil
`x^3+y^3+z^3+lambda xyz` has smooth members (`lambda = 0`, the Fermat cubic)
and singular ones (`lambda = -3` factors as the triangle
`(x+y+z)(x+wy+w^2z)(x+w^2y+wz)`, verified exactly over `Z[w]` in §D13).  The
`j`-invariant is a rational function of `lambda`, finite at `lambda = 0` and
infinite at the four triangles, hence **nonconstant**, hence surjective onto
the `j`-line: the value `j(E_{-11}) = -32768` is attained.

**Consequence.**  The closing move that `SUPPORT_CENSUS.md` §6 proposed for
`(O4)` — *exclude `E_{-11}` from the Jacobians of the `C_6`-stable plane
curves in the eigenplanes* — is not available: `E_{-11}` is not merely not
excludable, it is **realised**, already in degree 3, in every plane, with the
correct equivariant structure and in a live channel.  And the family of
candidates is positive-dimensional in every degree `>= 3`, so the question was
never finite.

---

## 5. Capacity, refined by total degree

`SUPPORT_CENSUS.md` §3.2 bounds the *number* of base components in an orbit:
`N <= d^c`.  Refined Bézout actually bounds the **sum of the degrees** of the
distinguished varieties (Fulton, *Intersection Theory*, Ex. 12.3.1), so:

> **Proposition O4-6 (capacity by degree).**  If a `G`-orbit of `N`
> irreducible **base components** of codimension `c` and degree `delta` each
> occurs for a map given by forms of degree `d`, then `N.delta <= d^c`.
> Combined with Theorem C6 (`d` even), on `P^5` this gives, for the `(O4)`
> orbits (§E):
>
> | support | `N` | `c` | min even `d` |
> |---|---:|---:|---:|
> | eigenplane cubic, `H = C_6` | 110 | 4 | **6** |
> | eigenplane quartic, `H = C_6` | 110 | 4 | 6 |
> | eigenplane cubic, `H = C_2` | 330 | 4 | **6** |
> | eigenplane quartic, `H = C_2` | 330 | 4 | **8** |
> | `C_3` eigen-line, `H = D_12` (orbit 55) | 55 | 4 | 4 |
> | `C_3` eigen-line, `H = C_6` (orbit 110) | 110 | 4 | 4 |
> | `C_5` eigen-line, `H = D_10` | 66 | 4 | 4 |
> | whole eigenplane, `H = C_6` | 110 | 3 | 6 |
>
> In particular the census's `d >= 4` for an eigenplane-curve orbit (Prop C9)
> is **too weak**: a cubic orbit needs `d >= 6`.

The caveat of `THEOREM_POINT_SUPPORT.md` §1 is inherited verbatim and is not
optional here: *a strict support need not be an irreducible component of the
base scheme*, so these rows are necessary conditions on **component** orbits
only.  And since `d` is unbounded on the spin lane, capacity is a low-degree
screen, never a kill.

---

## 6. The eigen-line strata

`(O4)` as boxed also contains the `H_0 = C_3` and `H_0 = C_5` strata.  For
`V = U` these are **lines**, so a curve support inside them is the whole line:

* `H_0 = C_3`: the preimage is `C_6 = <t>`, `t^3 = -I`, and `U|` has the three
  spin characters `zeta_6, -1, zeta_6^5` with multiplicity 2 each (§B5-B6), so
  `P(U)^{C_3}` is three disjoint `P^1`s.  The `(-1)`-line is stabilised by all
  of `N_G(C_3) = D_12` (computed: order 12, §B8), giving an orbit of **55**;
  the six reflections invert `t` and therefore swap the two `zeta_6`-lines
  (§B10), whose common stabiliser is `C_6`, giving an orbit of **110**.
  `55 x 3 = 55 + 110`.
* `H_0 = C_5`: the preimage is `C_10`, `U|` has `-1` with multiplicity 2 and
  the four other spin characters with multiplicity 1 (§B11-B12), so
  `P(U)^{C_5}` is one `P^1` plus 4 points; `Stab_G(line) = D_10` (order 10,
  §B14), one orbit of **66** — the same 66 lines as the destruction centre of
  `MULTIPLICITY_ROUTE.md` Thm N3.

> **Proposition O4-7.**  A curve support inside a `C_3`- or `C_5`-eigen-line
> of `P(U)` is the whole line `~ P^1`, so in the constant-coefficient channel
> its carrier is `IH^1(P^1,Q) = 0`: **DEAD**, for all degrees, all channels
> and both stabiliser types.  What survives is exactly a **nonconstant** local
> system on a dense open subset of the line.

This is Prop C8 of the census made precise for `V = U`: for the *plane* strata
C8 leaves a large residual (all the curves of §§3-4), while for the *line*
strata it leaves only the nonconstant-local-system residual.  For
`V = U^{(+)m}`, `m >= 2`, the strata are `P^{2m-1}` and the residual reopens
in the same way as the plane case.

---

## 7. The split

```text
+---------------------------------------------------------------------------+
| (O4) SPLIT.  Supports inside the linear eigen-strata of P(U).             |
|                                                                           |
| DEAD, unconditionally, in the constant-coefficient channel:               |
|   O4a  the whole eigenplane Pi = P^2         (IH^1(P^2) = 0; Prop C8)     |
|   O4b  an eigenplane curve of geometric genus 0, any degree               |
|                                              (IH^1 = H^1(P^1) = 0)       |
|   O4c  a C_3-stable plane CUBIC of weight eps != 0                       |
|          -- forced j(S) = 0, CM by Q(sqrt(-3)), so Hom(., E_{-11}) = 0   |
|   O4f  a whole C_3- or C_5-eigen-LINE      (IH^1(P^1) = 0; Prop O4-7)    |
|   plus, per channel: the psi_3 structure at any C_6-support (kill K-d),   |
|   and one C_3-channel for each of psi_1, psi_5 (Prop O4-3).              |
|                                                                           |
| BOXED RESIDUAL, still OPEN:                                              |
|   O4d  C_3-stable plane cubics of weight 0 (the Hesse family), channel    |
|        psi_j with j != 3.  WITNESSED: the member isomorphic to E_{-11}    |
|        exists in every one of the 110 planes and satisfies (AHS-spin)     |
|        exactly (Theorem O4-5).  Orbit 110, needs even d >= 6 if it is a   |
|        base COMPONENT.                                                    |
|   O4e  eigenplane curves of geometric genus >= 1 and degree >= 4, either  |
|        stabiliser (orbit 110 or 330).  No character kill exists above     |
|        degree 3 (Prop O4-3').                                            |
|   O4g  ANY of the above strata carrying a NONCONSTANT local system --      |
|        including the whole planes and the whole lines, where this is the  |
|        only survivor.                                                    |
|                                                                           |
| STATUS: (O4) is NOT closable by the Hodge-support census.  The proposed   |
| closing move ("exclude E_{-11} from the Jacobians of C_6-stable plane     |
| curves") is refuted by the witness, and the candidate family is           |
| positive-dimensional in every degree >= 3, not finite.                    |
+---------------------------------------------------------------------------+
```

Cell-by-cell verdict for the census table: `S1` (`H_0 = C_2`) stays **OPEN**
with the residual `O4d/O4e/O4g` and the four kills above; `S2`, `S3`
(`H_0 = C_3, C_5`) become **DEAD in the constant-coefficient channel for
`V = U`**, residual `O4g` only.

---

## 8. Adversarial tests

### O4-T1.  The mandatory `D_12` test (Cor IX.6) — PASSED

`theory/FIX_IX_v14.md` Cor IX.6 proves the `V14` **is** `D_12`-spin-
unirational: a dominant `D_12`-equivariant map from a spin source exists.  Any
kill must be consistent with it.

*Which supports that map's graph could occupy in this cell.*  At `D_12` level
the eigenplane cell is fully visible: `sigma` is the centre of `D_12`, its two
eigenplanes are `D_12`-stable as a pair with each stabilised by
`C_6 <= D_12`, and `Res_{D_12}T = 2.(1(x)triv) (+) 2.(1(x)std) (+)
2.(eps(x)std)` has **all** channels of multiplicity 2 (verifier §D, §I of the
census verifier; recomputed here as `dim T^{D_12} = 2`).  So the realised map
may perfectly well have a strict support that is an eigenplane curve with
`H = C_6` in the trivial channel — which is exactly the channel the witness of
Theorem O4-5 uses.  Our kills do not touch it:

| kill | what it says at `D_12` level | can it contradict Cor IX.6? |
|---|---|---|
| O4a, O4b, O4f | `IH^1` of a `P^k` or of a rational curve is **zero** | no: a vanishing carrier is a statement about the sheaf, not about the map |
| O4c | a curve with CM by `Q(sqrt(-3))` admits no nonzero Hodge map from an `E_{-11}`-isotypic source | no: the realised map simply cannot route through that curve; the Hesse channel is untouched and remains available |
| K-d (`psi_3`) | already in force before this packet, and already `D_12`-tested (`ADVERSARIAL_TESTS.md` §S1) | no |

**PASS**, and informatively: the one subcell that survives is the one the
realised `D_12`-map is free to occupy.  That is the correct sign — a kill that
had emptied the trivial `D_12`-channel would have refuted Cor IX.6.

### O4-T2.  The `j = 8192/11` overreach — NOT COMMITTED

The tempting bad argument: *"`sigma` fixes `S` pointwise, so `phi(S) subset
V14^sigma = E_sigma | | 2` points, and `j(E_sigma) = 8192/11` is not an
algebraic integer, so `Hom(E_sigma, E_{-11}) = 0` and the cell dies."*

It is wrong three times over, and none of §§1-7 uses it.

1. The carrier of a strict-support block is `IH^1` of the **support**, a
   source-side object; it is not `H^1` of the image of anything.
   `SUPPORT_CENSUS.md` §4.1 already records that the exclusion condition is
   always `Hom_{HS,H}(Res_H T, H^1(C)) = 0` for the *actual* carrier `C`, and
   that no argument replaces `C` by `E_sigma`.
2. By Theorem K1 the whole plane `Pi` is contracted to the single point
   `y(Pi) in V14^{sigma}`, so the image is a **point** — there is no curve on
   the target side to compare with in the first place.
3. `S` is inside `Bs(phi)` by Theorem S3(1), so `phi` is not even defined
   along it; the relevant target-side geometry is the fibre of `q`, not
   `phi(S)`.

The `j = 8192/11` exclusion is used **only** where a carrier is *forced* to be
isogenous to `E_sigma`, which is nowhere in `(O4)`.

### O4-T3.  Does the witness contradict anything already proved? — NO

* Theorem K4 (the 352 incidence points are mandatory base locus): the witness
  curve neither contains nor avoids them by force; no interaction.
* Theorem K1 (each plane contracts to a point): compatible — `S subset Bs(phi)`
  and `phi|_{Pi} = y(Pi)` are simultaneously satisfiable.
* Theorem C6 (`d` even) and Prop O4-6 (`d >= 6` if `S` is a component): both
  are satisfiable, since no upper bound on `d` exists on this lane.
* Cor S4 (`k(C_6) = 1`): the witness carries exactly one copy of `E_{-11}`, the
  floor, so it is the *cheapest* possible support — nothing is over-supplied.
* Theorem S3(2) (unique jump, `T` `Q`-irreducible): the witness supplies a
  nonzero Hom, which is all the necessary condition asks; irreducibility then
  makes the projection injective on `T`, consistent because the whole orbit
  block has carrier `Ind_{C_6}^G H^1(S)` of dimension `220 >= 10`, and
  `<chi_T, Ind_{C_6}^G 1> = dim T^{C_6} = 2 > 0` (§C).

### O4-T4.  Is the `eps != 0` kill (O4c) really a kill? — YES, but narrowly

It uses: (i) all three coordinate points lie on `S` — exact monomial
combinatorics, §D2; (ii) hence the order-3 automorphism of the elliptic curve
`S` has a fixed point, so `j(S) = 0`; (iii) `Res_H T` is `E_{-11}`-isotypic,
which is Theorem S0(2), itself now resting on sealed inputs only
(`SEAL_V14_BETTI.md`).  It does **not** extend to `delta >= 4`: there the
automorphism may still have fixed points, but a curve of genus `>= 3` with an
order-3 automorphism has no CM constraint at all.  Prop O4-3' says so
quantitatively.

### O4-T5.  Could a nonconstant local system be excluded after all? — NOT HERE

`(O4g)` is left open on purpose.  The ambient packet's Corollary C
(finite-cover `H^1` carriers) applies only under its own hypotheses
(`s+4-n-j_0 = 1` **and** `L = U(-1)` with `U` of finite monodromy) and is not
imposed anywhere in this packet (`THEOREM_SPIN_HODGE_SUPPORT.md` §8).  A
nonconstant local system on `P^1` minus a finite set, or on `P^2` minus a
curve, can perfectly well have nonzero `IH^1` carrying CM Hodge structures.
Excluding that would need a new input about the geometry of `p` over the
strata, which the packet does not have.

---

## 9. Honest limits

1. **No cell of `(O4)` dies for all degrees and all spin sources.**  The four
   kills are: two vanishing-carrier statements (`P^k` and rational curves),
   one CM mismatch confined to `delta = 3`, and one per-channel character
   kill.  `SPIN-SUPPORT-CENSUS-CLOSED` remains **not** claimed and the Cor
   IX.5 consequence chain is **not** triggered.
2. The degree-by-degree table of §3 is for **smooth** plane curves.  Singular
   ones with geometric genus `>= 1` are not excluded and are not analysed
   channel by channel; they sit in `O4e`.
3. For `V = U^{(+)m}`, `m >= 2`, the eigen-strata are `P^{3m-1}` and
   `P^{2m-1}` and every kill above except the vanishing-carrier ones weakens:
   supports of dimension up to `n-3` live inside them, and Theorem O4-1's
   "three distinct eigenvalues" becomes "three eigenvalues with multiplicity
   `m`".  `(O5)` of the census already records this.
4. The `10`- and `12`-dimensional spin irreducibles have no in-repo fixed-point
   network, so their eigen-strata are not enumerated here either.
5. The minimal live coordinate degree (`SUPPORT_CENSUS.md` §7.4: the smallest
   even `d` with `<S^d U^*, 10'> != 0`) is still **not** computed; §5's rows
   are lower bounds that a future computation could only raise.

## 10. Exit

```text
O4-SPLIT
O4-EIGENPLANE-CURVES-OPEN-WITH-WITNESS
O4_CENSUS_OK                (verifier marker, 92 assertions)
SPIN-SUPPORT-CENSUS-TABLED  (unchanged; the census table is edited, not closed)
```

`O4-DEAD` is **NOT** claimed and is now known to be unreachable by this
machinery: Theorem O4-5 exhibits a support satisfying every necessary
condition the package imposes.  The useful consequence for lane direction is
negative but sharp — `(O4)`, which the census had flagged as the most
tractable cell, is the *least* promising of the five, and the sharp cells are
`(O2)` (the 352 mandatory points) and `(O3)` (`C_11`, `F_55`, where
`Res_H T` is `Q`-irreducible).  Headline unchanged: **OPEN**.
