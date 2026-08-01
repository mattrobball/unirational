# T0 implication ledger for `BR-T-NEG`

This ledger audits the fields and every proposed implication before any
normalization computation.  The audit fails at the object-identification
arrow required for the headline.

## 1. Fields and distinct geometric objects

Let

```text
G       = PSL(2,F_11)
L       = C(W)
K_0     = L^G = C(W)^G
K_proj  = C(P(W))^G
F       = C(A,B,Y,Z)
```

where

```text
A=f6/f3^2,  B=f5*f7/f3^4,  Y=f9/f3^3,  Z=f12/f3^4.
```

The affine generic torsor is the purely transcendental base change of the
projective generic torsor, with `K_0=K_proj(t)`.  The exact degree packet gives
`[K_proj:F]=6` and geometric monodromy `S6`.

There are two different cubics:

```text
C_fix/F       = the full fixed-frame Pfaffian plane cubic;
X_gen/K_proj  = the genuine generic Klein cubic threefold.
```

`C_fix` is the `(0,1,2)` coordinate-plane section of the auxiliary
15-variable Pfaffian characteristic cubic in `Sym(A,sigma)`.  A
`K_proj`-point of `C_fix` with `c2 != 0` produces a sigma-self-adjoint
reduced-rank-two idempotent, hence a point of the auxiliary Morita space.
It is not a point of `X_gen`.

Over `F`, the accepted universal-incidence calculation gives

```text
ind(C_fix/F)=3,  C_fix(F)=empty,  Pic^0(C_fix)(F)=0.
```

## 2. The branch and the valid residue statement

Let `D` be the accepted irreducible multiplicity-one branch divisor of the
degree-six cover.  The line discriminant and global different argument select
a prime `R` above `D` with

```text
(e(R/D), f(R/D)) = (2,1),
k(R) = k(D).
```

The selected branch is not contained in the discriminant of `C_fix`, so its
special generic plane cubic is smooth.

Assume that a later normalization/class-group computation proves

```text
ind(C_fix,k(D)) = 3.
```

On one common proper model, a hypothetical `C_fix(K_proj)` point extends over
the DVR at `R` and specializes to a `k(R)=k(D)` point.  This contradicts
index three.  Thus the following implication is valid:

```text
ind(C_fix,k(D))=3  =>  C_fix(K_proj)=empty.
```

Properness, normalization at `R`, and residue degree one are all essential.

## 3. The invalid headline arrow

The authoritative Pfaffian bridge audit proves the sound positive chain

```text
common isotropic right D-line for all h in H_T
  => F14_T(K_proj) is nonempty
  => X_gen(K_proj) is nonempty.
```

It also proves that the attempted predecessor is false as written:

```text
sigma-self-adjoint reduced-rank-two idempotent
  -/-> common isotropic right D-line for H_T.
```

A Morita projector is an arbitrary point of a rational `P2_D`; the common
line is cut out by five additional Hermitian isotropy equations.  The fixed
plane curve is an even smaller coordinate section used only as a sufficient
construction of one projector.  Hence neither implication below exists:

```text
C_fix(K_proj)=empty  => no Morita projector;
C_fix(K_proj)=empty  => X_gen(K_proj)=empty.
```

The headline work order itself explicitly lists as a non-headline bridge
"triviality or nontriviality of the fixed-frame auxiliary genus-one torsor
without a separate bridge to `F14_T` or the generic Klein twist."  Its
one-line row named `BR-T-NEG` supplies no such separate bridge and conflicts
with both that explicit exclusion and the later binding `FAIL-SCOPE` audit.

## 4. Exact counterexample to the formal inference

The failure is structural, not a missing CAS identity.  Put
`K=C((s))((t))`.  The smooth plane cubic

```text
C0: x^3 + s*y^3 + t*z^3 = 0
```

has index three.  Indeed, the `t`-valuations of the first two terms are
`0 mod 3` and that of the third is `1 mod 3`.  Cancellation would force the
first two terms to have equal minimal valuation; reduction modulo `t` would
then make `-s` a cube in `C((s))`, impossible because its `s`-valuation is
one.  Thus `C0(K)` is empty.  Its period is the nontrivial divisor of three,
so period and index are three.

Nevertheless the smooth cubic threefold

```text
Y: x^3 + s*y^3 + t*z^3 + w^2*x + q^3 = 0
```

contains `C0` as the coordinate section `w=q=0` and has the rational smooth
point `[0:0:0:1:0]`.  Therefore an index-three coordinate-plane section does
not imply pointlessness of an ambient cubic threefold.

## 5. Headline dictionary and route exit

The generic-torsor theorem remains valid:

```text
X_gen(K_proj)=empty
  => X is not G-unirational
  => ed_C(G)=4.
```

But the target-branch calculation reaches only `C_fix(K_proj)=empty`.  T0
therefore exits

```text
T-BRIDGE-BLOCKED
```

and the route-level exit is `T-ROUTE-REFUTED`: T1--T3 cannot support the
advertised negative headline even if they prove `ind(C_fix,k(D))=3`.

## 6. Exact repair requirement

To revive a headline-capable target branch one must first prove one of:

- an exhaustiveness/converse theorem sending every `X_gen(K_proj)` point (or
  every common isotropic line) into this exact fixed coordinate plane; or
- a new branch valuation of `X_gen` itself, with a proper model whose special
  fibre has index greater than one.

The present Pfaffian geometry supplies neither.  The first proposal would
have to overcome the proved distinction between arbitrary Morita projectors
and common isotropic lines.
