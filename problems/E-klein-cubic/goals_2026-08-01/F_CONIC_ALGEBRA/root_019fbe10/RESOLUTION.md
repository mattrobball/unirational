# Independent terminal audit: the conic criterion is empty

## Verdict and scope

The exact Goal F decision is

```text
F-CONIC-CRITERION-EMPTY
```

More precisely, for

```text
F = C(A,B,Y,Z),
K_proj = F[u]/(P),
```

with the selected primitive sextic and fixed-frame cubic installed one
directory above, the following is proved:

```text
C(K_proj) = empty.
```

Consequently no nondegenerate `F`-conic has scheme-theoretic intersection
algebra isomorphic to the selected `K_proj`.  This is the permitted scoped
negative exit in `GOAL_F_CONIC_INTERSECTION_ALGEBRA.md`.  It is not a theorem
about the genuine generic Klein twist: the repository still lacks the
required bridge from this auxiliary fixed-frame cubic to that twist, so the
Klein-cubic headline remains `OPEN`.

This file is an independent theorem-boundary audit of the terminal packet in
`../`.  It supersedes this worker's earlier honest-stop status without
promoting any of the bounded searches in `SOURCE_VALUATION_AUDIT.md`.

## 1. A residue-degree-one place of `K_proj`

Set

```text
T = Z - 11*A^2/18
```

and write the sealed primitive as

```text
P = c6*u^6 + c5*u^5 + ... + c0.
```

Exact coefficient extraction gives

```text
c6 = 38263752 * B^2 * (A-15) * D(A,B,Y,T),
```

where the 18-term polynomial `D` is recorded in
`../infinity_obstruction.json`.  Put

```text
p   = 100*A + 4*B + 2*T + 12*Y - 1623,
q   = 212*B + 106*T + 36*Y + 81,
rho = 53*p-q = 100*(53*A+6*Y-861).
```

The change from `(A,B,Y,T)` to `(p,q,Y,T)` is invertible, and the exact
identity

```text
6625000*D =
  150*(107219*p^2 + 954*p*q - 9*q^2)
  - 600*Y*(53*p-q)^2
  + (53*p-q)^3
```

exhibits `D` as a primitive linear polynomial in `Y`.  Its leading
coefficient is a scalar multiple of `(53*p-q)^2`, while the constant term is
not divisible by `53*p-q`; hence `D` is irreducible.

On `rho != 0`, let `r=p/rho`.  Modulo `D`, the exact inverse identities are

```text
A - (33/2 - 3750*r^2)
  = D / (8*(53*A+6*Y-861)^2),

Y - (33125*r^2 - 9/4 + rho/600)
  = -53*D / (48*(53*A+6*Y-861)^2),

B - (-5625*r^2 - T/2 + (r/4-1/200)*rho)
  = 3*D / (16*(53*A+6*Y-861)^2).
```

Conversely, substituting the three displayed parameter formulas gives
`p=rho*r`, `q=rho*(53*r-1)`, and `D=0`.  Thus

```text
C(D) = C(r,rho,T).
```

At `(r,rho,T)=(0,1,0)`, the exact parameter values are

```text
(A,B,Y,Z)=(33/2,-1/200,-1349/600,1331/8)
```

and direct evaluation gives

```text
c5=4782969/625000000 != 0.
```

Therefore `ord_D(c6)=1` and `ord_D(c5)=0`.  In the henselization of the
`D`-adic DVR, the reciprocal polynomial

```text
s^6*P(1/s)=c6+c5*s+...+c0*s^6
```

has the simple residual root `s=0`.  Hensel's lemma gives a linear factor,
and hence a place of `K_proj/F` with

```text
e=1, f=1, residue field=C(D)=C(r,rho,T).
```

This is a place of the installed degree-six field, not merely a root of a
specialized polynomial: the henselian root has positive valuation and its
reciprocal is a root of the irreducible primitive `P`.

## 2. The residual cubic is a generic net with one degree-three base point

Over `k=C(r)`, reduction at this place gives

```text
C0(r) + rho*Crho(r) + T*CT,
```

where

```text
C0   = F0 + (33/2-3750*r^2)*FA - 5625*r^2*FB
          + (33125*r^2-9/4)*FY,
Crho = (r/4-1/200)*FB + FY/600,
CT   = -FB/2 + FZ.
```

The exact cyclotomic calculations in the parent payload exhibit a closed
degree-three subscheme of the common base scheme:

```text
(C0,Crho,CT) subset (y-c*w, G),

G = X^3 + (a0+a2*r^2)*X*w^2 + (b0+b2*r^2)*w^3.
```

The right ideal defines a finite flat degree-three scheme `B` over the good
local cyclotomic model: `G` is monic of degree three on `w=1`, and both charts
at `w=0` are empty.  At the split prime `89`, a saturated projective
Groebner replay proves equality of this scheme with the common base scheme
`Z`.

Here is the exact lift from that good fibre; no heuristic modular inference is
being used.  The inclusion `B subset Z` gives a surjection
`O_Z -> O_B` over the local DVR.  Its kernel `Q` is coherent.  Since `B` is
flat, tensoring with the residue field remains left-exact at `Q`; equality of
the special fibres gives `Q tensor kappa=0`.  Nakayama therefore makes `Q`
zero near the special fibre.  If `Q` had nonempty generic support, properness
of `Z` would make its support meet the special fibre, a contradiction.  Thus
`Q=0`, so the characteristic-zero base ideal is exactly `(y-c*w,G)`.

Write `G=N(X)+r^2 L(X)` on `w=1`, with `L=a2*X+b2`.  Here `a2` is nonzero and
`N(-b2/a2)` is nonzero (its good reduction is `17 mod 89`).  Thus `-N/L` has
a simple pole and is not a square over the algebraic closure of the constant
field.  Hence `r^2=-N/L` defines an irreducible curve and `G` is irreducible
in `C(r)[X]`.  In characteristic zero it is also separable.  Accordingly the
base scheme is one integral separable closed point `B` of degree three over
`k`; it is deliberately not described as a geometrically integral finite
point.

The independent smooth-member check at `(r,rho,T)=(1,0,0)` proves that the
generic member of the net is a smooth plane cubic.

## 3. The residual generic cubic has index three

Let `Lambda=P^2_k` parameterize the net and set

```text
X_net = {lambda0*C0 + lambda1*Crho + lambda2*CT = 0}
        in P^2_z x Lambda.
```

The threefold `X_net` is normal.  Indeed, over
`U=P^2_z-B`, the three sections have no common zero, so their evaluation map
is a surjection

```text
O_U^3 -> O_U(3).
```

The inverse image of `U` is the projective bundle of its rank-two kernel and
is smooth.  At each of the three geometric points of the reduced lci base
scheme, equality of the base ideal with `(y-c*w,G)` implies that the three
section differentials span the two-dimensional conormal.  The lambda values
for which their linear combination vanishes therefore form a single
projective point.  Thus the singular locus of `X_net` is finite.  The
incidence is an integral hypersurface in the smooth fourfold
`P^2 x P^2`, hence it is Cohen--Macaulay and satisfies `S2`; the finite
singular locus gives `R1`.  Serre's criterion proves normality.  The nine
modular product-chart calculations in this folder independently bound the
singular locus by dimension zero.

Let

```text
E = B x Lambda,
V = X_net-E.
```

Since `V` is the projective bundle above and deleting a codimension-two
closed point does not change `Cl(P^2)`,

```text
Cl(V) = Z*H_z + Z*H_lambda.
```

The localization sequence for the normal `X_net` is surjective onto
`Cl(V)` and its kernel is generated by the prime divisor `E` (there is only
one because `B` is integral).  Therefore

```text
Cl(X_net) is generated by H_z, H_lambda, E.
```

On the generic cubic over `k(Lambda)=C(r,rho,T)`, their degrees are

```text
3, 0, 3.
```

Every closed point of the generic cubic closes to a horizontal prime Weil
divisor on `X_net`, so its degree is a multiple of three.  Intersecting with
a line gives an effective divisor of degree three.  Hence

```text
ind(C/C(D))=3,
C(C(D))=empty.
```

This is an all-closed-points index computation, not a bounded point search.

## 4. Specialization and the conic criterion

If a `K_proj`-point of the fixed-frame cubic existed, use the `(e,f)=(1,1)`
place from section 1.  Properness of the plane cubic extends that point over
the corresponding valuation ring and reduces it to a `C(D)`-point of the
residual cubic.  Section 3 excludes such a point.  Therefore

```text
C(K_proj)=empty.
```

An isomorphism from any length-six conic intersection algebra to the selected
`K_proj`, together with the selected embedding, would evaluate to a
`K_proj`-point of the original fixed-frame cubic.  Thus no such conic exists.
The stronger bidirectional point/conic equivalence, including the `w=0`
chart, is independently audited in `../CRITERION.md`.

## 5. Replay boundary

Run the command in `REPLAY.md`.  The terminal verifier checks:

1. the sealed parent field and infinity-obstruction packets;
2. the inverse normalization identities above;
3. the exact inclusion, finite-flat degree-three model, and good-fibre ideal
   equality used in the proper Nakayama lift;
4. all nine universal-incidence singular-locus charts at the good prime;
5. this isolated packet's hashes and exact terminal marker.

The older exploratory files remain as provenance only.  None is an input to
the terminal mathematical implication except where explicitly hash-bound by
the verifier and seal.
