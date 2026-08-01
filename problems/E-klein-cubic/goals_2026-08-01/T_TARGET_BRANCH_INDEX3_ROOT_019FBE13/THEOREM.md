# T0 bridge-refutation theorem

## Verdict

The target-branch index-three route, as stated, cannot prove that the Klein
cubic is not `PSL(2,F_11)`-unirational.  Its branch specialization can obstruct
only the full fixed-frame Pfaffian plane cubic.  The work order supplies no
valid implication from pointlessness of that auxiliary curve to pointlessness
of the genuine generic Klein cubic twist.

Consequently the exact terminal route exit is

```text
T-ROUTE-REFUTED
```

with the T0 subexit `T-BRIDGE-BLOCKED`.  The Problem E headline remains
**OPEN**.

## Theorem

Let

```text
F      = C(A,B,Y,Z),
K_proj = C(P(W))^G,
```

and let `D` be the accepted multiplicity-one target branch of the degree-six
extension `K_proj/F`.  Let `R` be its accepted prime with residue data

```text
(e(R/D),f(R/D))=(2,1),  k(R)=k(D).
```

Let `C_fix/F` be the full fixed-frame Pfaffian plane cubic.  If

```text
ind(C_fix over k(D))=3,
```

then proper specialization at `R` proves

```text
C_fix(K_proj)=empty.
```

It does **not** prove that the genuine generic Klein cubic threefold
`X_gen/K_proj` is pointless.  In the binding repository audit, `C_fix` is an
auxiliary coordinate-plane construction of a Morita projector.  A Morita
projector is not a common isotropic right `D`-line for the five descended
Hermitian forms, and it is the latter object that maps through the twisted
Fano section to `X_gen(K_proj)`.  In particular, neither of the implications

```text
C_fix(K_proj)=empty  =>  no Morita projector,
C_fix(K_proj)=empty  =>  X_gen(K_proj)=empty
```

is available.  Thus even a complete T1--T3 proof of the displayed branch
index statement would not meet T4.

## Exact structural counterexample

The unavailable inference is false for smooth cubic geometry in the exact
form used by the route.  Put `K=C((s))((t))` and consider

```text
C0: x^3+s*y^3+t*z^3=0
```

in `P2_K`.  This plane cubic is smooth.  It has no `K`-point: the first two
summands have `t`-valuation congruent to zero modulo three, while the third
has valuation congruent to one.  In a vanishing sum the least valuation must
occur at least twice, so it must occur in the first two terms.  Reducing their
equal leading terms modulo `t` would make `-s` a cube in `C((s))`, contrary to
its `s`-valuation one.  A plane section supplies a degree-three divisor;
smooth genus one plus pointlessness excludes index one.  Hence

```text
ind(C0/K)=3.
```

Now consider the cubic threefold

```text
Y: x^3+s*y^3+t*z^3+w^2*x+q^3=0
```

in `P4_K`.  Its coordinate section `w=q=0` is `C0`, but `Y` has the smooth
`K`-point `[0:0:0:1:0]`.  Moreover `Y` is smooth: its derivatives force
`y=z=q=0`, while `2wx=0` and `3x^2+w^2=0` then force `x=w=0`, impossible in
projective space.  Therefore index three of a coordinate plane section does
not imply pointlessness of the ambient cubic threefold.

## Valid implication boundary

The only headline-capable chain retained by this audit is

```text
common isotropic right D-line
  => twisted Fano point
  => X_gen(K_proj) is nonempty
  => the positive generic-twist consequence.
```

Conversely, a genuine proof of `X_gen(K_proj)=empty` would still give the
negative headline and `ed_C(PSL(2,F_11))=4`.  The target-branch calculation
does not reach that antecedent.

To repair the route one must either prove an exhaustiveness theorem forcing
every genuine generic Klein point/common line into this exact fixed coordinate
plane, or apply a residue valuation directly to a proper model of `X_gen`.
Neither theorem is present in the binding packets.
