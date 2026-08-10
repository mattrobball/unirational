# Audit

## Scope

This packet audits only invariants functorially built from the integral
`Z[C5]`-lattice extension

```text
0 -> I --alpha--> I -> F11(9) -> 0
```

by ordinary Ext, exterior powers, Tate cohomology, and the standard
mod-eleven group-cohomology ring.  It does not classify arbitrary
birational compressions and does not claim `ed_K(A)=4` or `ed_K(A)<=3`.

## Independent checks

1. The equivariant-Ext spectral sequence has only its `q=1` row because
   the target lattice is torsion-free and `Z` has global dimension one.
2. Every positive group-cohomology term of `C5` on an `F11`-vector space
   vanishes by the averaging operator `5^-1 sum gamma`.
3. The roots of `Phi5` modulo eleven are exactly `3,4,5,9`; their exterior
   products give the displayed Ext table.
4. The existing Smith form `(1,1,1,11)` implies the exterior Smith forms
   without a basis assumption: exterior powers of the two unimodular Smith
   transformations remain unimodular.
5. Modulo eleven, `alpha` has exactly one zero eigenspace, the `9` line.
   Hence the exterior cokernel character tables are wedges containing this
   line.
6. Each exterior cokernel is eleven-primary, so all of its `C5` Tate
   cohomology vanishes.  The exterior maps therefore induce Tate
   isomorphisms.
7. In `H*(BC11,F11)`, the first invariant monomials have degrees nine and
   ten.  Their Bockstein factor evaluates to zero because every Kummer
   `C11` torsor lifts to `C121` over a field containing `mu121`.

All finite arithmetic in items 3--7 is replayed by `verify.py`.

## Boundary

The exact conclusion is a method exclusion:

```text
NO degree-four obstruction is present in the ordinary
Ext/exterior/Tate/group-cohomology package of alpha.
```

A nonlinear invariant retaining the full birational self-isogeny could
exist outside this package.  The ordinary essential dimension remains in
the interval `3<=ed_K(A)<=4` established by the preceding packets.

