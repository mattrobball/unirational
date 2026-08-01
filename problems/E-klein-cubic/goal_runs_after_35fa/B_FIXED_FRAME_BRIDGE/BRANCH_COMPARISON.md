# Infinity divisor versus genuine target branch

Let

```text
P=c6*u^6+c5*u^5+...+c0
```

be the ordered primitive sextic over `F`.

## Goal F infinity place

After the coordinate change `T=Z-11*A^2/18`, Goal F proves

```text
c6 = 38263752*B^2*(A-15)*D_infinity
```

with `D_infinity` irreducible and `c5` a unit at its generic point.  For
`s=1/u`, the reciprocal polynomial has reduction

```text
s^6*P(1/s) = c6+c5*s+...  ==  s*(unit+...) mod D_infinity.
```

Thus the ordered residue root is `s=0`, equivalently `u=infinity`, and

```text
(e,f)=(1,1).
```

This is a simple unramified degree-one place on the leading-coefficient
boundary `c6=0`.

## `BR-T-NEG` target branch

The genuine target divisor is

```text
D_target=V(H),
```

where `H` is the exact irreducible degree-43 multiplicity-one factor of
`Res_u(P,P_u)`.  Its fold model satisfies

```text
P=0, P_u=0,
P_uu != 0, c6 != 0, delta != 0, content != 0.
```

Hence the ordered root is a finite simple double root and the corresponding
place has

```text
(e,f)=(2,1).
```

The target-branch construction explicitly inverts `c6=lc_u(P)`; Goal F's
divisor is contained in `c6=0`.  Thus the accepted simple-fold open used for
the target theorem excludes the generic point of the Goal F divisor.

## Verdict on B2

They are not the same valuation or the same branch over `F`:

```text
D_infinity: c6=0, u=infinity, e=1, f=1;
D_target:   H=0, c6 unit, finite double root, e=2, f=1.
```

The restrictions of the two valuations to the coefficient field are
different: `v_Dinfinity(c6)>0`, while `v_Dtarget(c6)=0`.  Their ramification
indices above those base valuations also differ.  Consequently they cannot
be the same valued ordered extension, and the currently accepted target open
is not a common theorem-level open.  A future proper model could contain both
as distinct divisors, and their residue fields could conceivably be
abstractly birational; neither fact would identify the valuations or transfer
the specialization theorem.

The residual families also have different certified status:

- on `D_infinity`, Goal F identifies the normalized residual net and proves
  index three;
- on `D_target`, the generic fixed cubic is smooth and residue degree one is
  accepted in the sealed `target_branch_mod3` packet, but
  `ind(C_k(D_target))=3` and the three-primary `Cl/Pic` gate remain open.

Therefore Goal F does not complete `BR-T-NEG`.  Equality and the same ordered
residue embedding fail at the first valuation check.  An abstract birational
relation of branch fields and some separately constructed comparison of
residual families are not established; even if established, they would not
identify these valued ordered extensions or by themselves authorize the
specialization transfer.  The genuine target-branch route remains the
separate normalization/class-group problem.
