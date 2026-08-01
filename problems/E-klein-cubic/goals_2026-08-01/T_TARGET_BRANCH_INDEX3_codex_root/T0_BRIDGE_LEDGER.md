# T0 implication ledger — `T-BRIDGE-BLOCKED`

This is the mandatory pre-computation audit from the work order.  It stops the
target-branch calculation because the object controlled by the branch is not
the genuine generic Klein twist.

## 1. Fields and objects

Let

```text
G       = PSL(2,F_11),
K_proj  = C(P(W))^G,
F       = C(A,B,Y,Z),
```

with `[K_proj:F]=6`.  Let `D` be the accepted multiplicity-one branch and
`R` the accepted prime above it with

```text
(e(R/D),f(R/D))=(2,1),  k(R)=k(D).
```

There are three distinct objects:

```text
C_fix/F       the full fixed-frame Pfaffian plane cubic;
I_sigma       the open space of Morita/structure projectors;
X_gen/K_proj  the genuine generic Klein cubic twist.
```

`C_fix` is a three-coordinate section of the auxiliary Pfaffian
characteristic cubic in `Sym(A,sigma)`.  A point in its projector open yields
a sigma-self-adjoint reduced-rank-two idempotent, hence a point of the
auxiliary Morita space.  It is not a point of `X_gen`.

## 2. The valid valuative arrow

Suppose a later calculation proved

```text
ind(C_fix over k(D))=3.
```

On a common proper cubic model over the DVR at `R`, a hypothetical
`C_fix(K_proj)` point would extend by properness and specialize to a
`k(R)=k(D)` point.  This contradicts index three.  Thus

```text
ind(C_fix over k(D))=3  =>  C_fix(K_proj)=empty.
```

This arrow uses the normalization prime `R`, residue degree one, and
properness.  It is the full conclusion available from T1--T3.

## 3. The unavailable headline arrow

The authoritative Pfaffian bridge says

```text
common isotropic right D-line for all five Klein forms
  => F14_T(K_proj) is nonempty
  => X_gen(K_proj) is nonempty.
```

It also proves that a bare Morita projector is not a common isotropic line:
five additional Hermitian isotropy equations are required.  The fixed-frame
curve is an even smaller coordinate section of the projector cubic.  Hence
none of the following is an accepted theorem:

```text
C_fix(K_proj)=empty => no Morita projector;
C_fix(K_proj)=empty => no common isotropic line;
C_fix(K_proj)=empty => X_gen(K_proj)=empty.
```

The current fixed-frame terminality audit explicitly records that even
`C_fix(K_proj) != empty` does not by itself imply `G`-unirationality; the
descent from a fixed-frame projector to simultaneous common isotropy is a
separate live gate.  The negative direction in the goal cannot bypass this
object mismatch.

## 4. Exact counterexample to the formal section inference

Set `K=C((s))((t))` and

```text
C0: x^3+s*y^3+t*z^3=0  in P2_K.
```

The curve is smooth.  It has no `K`-point: the three summands have
`t`-valuations congruent to `0,0,1 (mod 3)`.  In a vanishing sum the least
valuation occurs at least twice, so only the first two can be the minimal
pair.  Reducing their equal leading terms modulo `t` makes `-s` a cube in
`C((s))`, impossible because its `s`-valuation is one.  A line section has
degree three; for a smooth genus-one curve, index one would give a
degree-one divisor and hence a rational point by Riemann--Roch.  Therefore

```text
ind(C0/K)=3.
```

Nevertheless the cubic threefold

```text
Y: x^3+s*y^3+t*z^3+w^2*x+q^3=0  in P4_K
```

is smooth and has the `K`-point `[0:0:0:1:0]`, while its coordinate section
`w=q=0` is exactly `C0`.  Smoothness is certified by the derivative ideal:
`y^2,z^2,q^2` lie in it up to field units, and

```text
3*x^3 = x*Y_x-(w/2)*Y_w,
w^3   = w*Y_x-(3*x/2)*Y_w.
```

Thus the projective singular locus is empty.  This exact example disproves
any formal principle that index three of a coordinate plane section forces
pointlessness of a smooth cubic threefold.

## 5. Verdict

The branch-index calculation can at most prove pointlessness of `C_fix`.
The work order demands pointlessness of `X_gen` and explicitly requires an
exhaustiveness bridge.  No such bridge exists in the binding packets, while
the accepted `FAIL-SCOPE` audit identifies the precise missing system.

```text
T-BRIDGE-BLOCKED
T-ROUTE-REFUTED
```

Revival would require a new theorem forcing every genuine generic Klein
point/common isotropic line into this fixed coordinate plane, or a valuation
applied directly to a proper model of `X_gen`.  Neither is part of the target
branch route resolved here.
