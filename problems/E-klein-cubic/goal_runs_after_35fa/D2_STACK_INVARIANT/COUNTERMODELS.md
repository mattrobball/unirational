# Countermodels to multiplier-free bridges

## 1. Arbitrary multisection degree

Let `Y` be any smooth projective `G`-variety and put

\[
Z=Y\times\mathbf P^1,
\qquad f=\operatorname{pr}_1,
\]

with trivial `G`-action on the second factor.  For every positive integer
`n`, the `G`-linearized relatively ample line bundle

\[
L_n=\operatorname{pr}_2^*\mathcal O_{\mathbf P^1}(n)
\]

satisfies

\[
f_*c_1(L_n)=n.                                   \tag{1.1}
\]

Hence the projection formula gives

\[
f_*(c_1(L_n)f^*x)=nx.                            \tag{1.2}
\]

This family satisfies characteristic zero, smoothness, projectivity, finite
group equivariance, and relative dimension one.  It realizes every multiplier
`n`, including `2,3,5,11,660`.  Therefore none of those formal hypotheses can
force a retraction at a fixed bad prime.

This is a bridge countermodel, not a model birational to `P^4`.  It proves
that any stronger conclusion needs an additional geometric hypothesis about
the actual resolution.

## 2. Polarization scaling

For classes `x,y in H^3(Y,Z)`, define the form on the pullback image by

\[
q_{Z,L_n}(f^*x,f^*y)
=\int_Zc_1(L_n)f^*x f^*y.
\]

Projection gives

\[
q_{Z,L_n}(f^*x,f^*y)=nq_Y(x,y).                  \tag{2.1}
\]

On a rank-ten lattice, scaling by `n` multiplies the discriminant by
`n^10`.  Thus an integral polarization invariant cannot ignore the same
uncontrolled prime support.

## 3. Prime-local data do not glue additively

The four CRT idempotents

```text
165, 220, 396, 540 modulo 660
```

show that an element of a `660`-torsion abelian obstruction group is exactly
the direct sum of its primary pieces.  There is no additional additive
compatibility class.  A proposed mixed-prime invariant that stores only these
four pieces is therefore not new.

## 4. Tautological canonical-dimension model

The generic-twist point functor is genuinely global and does not decompose
prime-by-prime, but saying

```text
the invariant is 1 iff the generic twist has a point
```

is exactly the original decision problem.  Without an independently
computable class and a lower-bound theorem, it is not a Goal D2 invariant
selection.
