# Target-branch route-refutation theorem

## Verdict

The route commissioned by `GOAL_T_TARGET_BRANCH_INDEX3.md` cannot establish
that the generic Klein twist is pointless.  Its strongest proposed branch
theorem concerns an auxiliary fixed-frame Pfaffian plane cubic, while the
headline concerns the genuine generic Klein cubic twist.  The missing arrow
is explicitly denied by the binding `FAIL-SCOPE` and fixed-frame terminality
audits.

Therefore the exact terminal exit is

```text
T-ROUTE-REFUTED
```

and the Problem E headline remains **OPEN**.

## Theorem

Let

```text
F      = C(A,B,Y,Z),
K_proj = C(P(W))^G,
```

and let `D` and `R` be the accepted multiplicity-one branch and prime with
`(e,f)=(2,1)` and `k(R)=k(D)`.  Let `C_fix/F` be the full fixed-frame
Pfaffian plane cubic.

If `ind(C_fix over k(D))=3`, the valuative criterion for the common proper
model gives

```text
C_fix(K_proj)=empty.
```

That conclusion does not imply `X_gen(K_proj)=empty` for the genuine generic
Klein twist.  A projector-open point of `C_fix` gives only a
sigma-self-adjoint reduced-rank-two Morita projector.  The accepted route to
the Fano partner and genuine Klein twist requires, separately, a common
isotropic right `D`-line for all five descended Hermitian Klein forms.  The
binding bridge audit identifies the projector-to-common-line arrow as false
as written, and the fixed-frame terminality audit explicitly withholds any
Klein-unirationality implication from `C_fix(K_proj)`.

Thus T1--T3 could prove at most the displayed fixed-frame pointlessness.  They
cannot meet T4 without a new exhaustiveness theorem relating every genuine
Klein point/common line to this fixed coordinate plane.

## Exact geometric counterexample

Put `K=C((s))((t))` and consider

```text
C0: x^3+s*y^3+t*z^3=0  in P2_K.
```

The partial derivatives are `3x^2,3s*y^2,3t*z^2`, so `C0` is smooth.  If a
projective `K`-point existed, the three summands would have `t`-valuations
congruent to `0,0,1` modulo three.  The least valuation in a vanishing sum
must occur at least twice; hence the first two terms have equal least
valuation.  Reduction of their leading coefficients modulo `t` would make
`-s` a cube in `C((s))`, contradicting `v_s(-s)=1`.  Therefore `C0(K)` is
empty.  A line gives a rational divisor of degree three, while index one on a
smooth genus-one curve would yield a degree-one effective divisor and a
rational point.  Hence `ind(C0/K)=3`.

Now let

```text
Y: x^3+s*y^3+t*z^3+w^2*x+q^3=0  in P4_K.
```

It contains `C0` as `w=q=0` and contains the smooth `K`-point
`[0:0:0:1:0]`.  It is globally smooth: `Y_y=Y_z=Y_q=0` forces
`y=z=q=0`, and the identities

```text
3*x^3 = x*Y_x-(w/2)*Y_w,
w^3   = w*Y_x-(3*x/2)*Y_w
```

put powers of `x,w` in the derivative ideal.  Thus all homogeneous
coordinates lie in its radical, so the projective singular locus is empty.

Consequently, even in smooth cubic geometry, an index-three coordinate plane
section does not force pointlessness of the ambient cubic threefold.  Since
the repository's `C_fix` is not even a section of `X_gen` but of an auxiliary
projector cubic, the proposed negative implication has no valid formal or
binding bridge.

## Boundary

This theorem resolves the target-branch commission by refuting its headline
bridge.  It does not prove a rational point on the generic Klein twist, does
not prove the twist pointless, and does not decide `ed_C(PSL(2,F_11))`.
