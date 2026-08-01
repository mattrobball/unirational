# Exact KLS interface audit

## 1. Two problems that must not be conflated

Let `q:W -> W` be a nonzero primitive homogeneous `G`-self-covariant.

- A **KLS solution** means `det(Dq)=0`.  The exact covariant-dimension input
  forces generic rank four, and its projective image is an irreducible
  invariant unirational hypersurface `H=V(F)` which may be singular and need
  not be the Klein cubic.
- A **landing covariant** means `f3(q)=0`, where `X=V(f3)` is the smooth Klein
  cubic.  If it has generic rank four, its projective image has dimension
  three and is contained in the irreducible threefold `X`; therefore the
  image equals `X`.

The conductor and `P22` packets belong to the first, broader problem.  They
analyze the singular non-Klein alternative for `H`.  They do not create a
conductor configuration for an already-landing covariant.

## 2. Smooth landing forces `h=1`

For a KLS image `H=V(F)`, define

\[
 A_i=F_i(q),\qquad h=\gcd_i A_i.
\]

If `q` lands in `X`, take `F=f3`.  Suppose an irreducible source divisor
`D=V(g)` divides `h`.  Primitivity of `q` says that the five coordinates of
`q` do not all vanish at the generic point of `D`, so they define a
projective point `q(eta_D)` of `X`.  The divisibility `g | F_i(q)` for every
`i` says that every partial derivative of `F` vanishes at this point.  That
would be a singular point of `X`, contradicting smoothness.  Hence no prime
divides `h`, and

\[
 \boxed{h=1.}
\]

The normalization of the image is `X` itself and its normalization conductor
is zero.  Thus a finite `P22` conductor classification cannot eliminate a
landing covariant: in the landing branch the configuration is already the
single divisor-clean case `h=1`, whose existence is the original open
problem.

## 3. Exact general KLS ledger

For a general KLS solution let `e=deg(H)`, `d=deg(q)`, and put

\[
 \bar A=(\nabla F)(q)/h.
\]

Choose primitive rows `v` and `bar A` in the rank-one factorization

\[
 \operatorname{adj}(Dq)=b\,v\,\bar A^t.
\]

Writing

\[
 s=\deg h,\qquad r=\deg v,\qquad t=\deg b,
\]

degree comparison gives

\[
 \boxed{s=r+t+d(e-5)+4.} \tag{1}
\]

The normalized dual Gauss covariant

\[
 p=(\nabla F)(q)/h:W\longrightarrow W^*
\]

has rank four and degree

\[
 \boxed{m=d(e-1)-s=4d-4-r-t.} \tag{2}
\]

Since `W*` is not isomorphic to `W`, minimality of a self-covariant does not
apply to `p`.  Composing with the quadratic dual Klein polar returns to `W`
and gives the strongest currently justified inequality

\[
 \boxed{d\le 2m,\qquad
 r+t\le\left\lfloor\frac{7d-8}{2}\right\rfloor.} \tag{3}
\]

For a source prime `D | h`, let `E` be the induced divisorial valuation over
the normalization pair `(Y,C)=(H^nu,C)`, and let `epsilon` be the contact
index.  With `a=ord_D(h)` and `beta=ord_D(b)`, the accepted identity is

\[
 \boxed{\beta-a=\epsilon A_E(Y,C)-1.} \tag{4}
\]

If `D` dominates an actual conductor prime `T` of coefficient `c`, and `mu`
is the normalization-differential order, then

\[
 \boxed{a=\epsilon(c+\mu),\qquad
 \beta=(\epsilon-1)+\epsilon\mu.} \tag{5}
\]

In particular, `a=1` forces an immersed transverse ordinary node and
`(epsilon,c,mu,beta)=(1,1,0,0)`.

## 4. Exact `P22` boundary

For either maximal `A5` subgroup, its unique invariant smooth quadric has an
orbit of eleven distinct factors; their squarefree product is `P22` of
degree 22.

Proved exclusions:

1. if `H` is normal, no orbit quadric divides `h`, hence `P22` does not divide
   `h`;
2. if `H` is nonnormal, `h=P22*k`, the eleven quadrics are all the
   conductor-dominating support, `k` is coprime and squarefree with
   codimension-at-least-two centers, then (1), (4), and the degree-nine
   certificates exclude the branch;
3. the same holds for repeated factors of `k` only when their discrepancies
   are at least one; and
4. the degree-25 and degree-28 logarithmic fields do not realize the closed
   normal-image `P22` branch.

Not proved:

- that `P22` occurs for an actual KLS image;
- that it exhausts conductor-dominating support;
- that the normalization pair is lc or plt at all extracted valuations;
- that conductor pullback has bounded reduced support;
- that repeated factors have bounded multiplicity; or
- that every minimal KLS image is normal, canonical, or the Klein cubic.

## 5. Quartic precomposition

The primitive quartic covariant `C` defines a finite surjective
`G`-endomorphism of `P(W)` of degree 256.  For a primitive KLS solution `q`,
finiteness keeps the preimage of its codimension-at-least-two base locus in
codimension at least two.  Consequently

\[
 \deg_{sat}(q\circ C^n)=4^n d,
\]

and the chain rule preserves rank drop.  This operation produces larger
solutions.  It cannot contradict the assertion that `d` is minimal.  A
degree-lowering theorem would have to descend a mixed `C`-adic expansion;
the repository proves that the decomposition does not commute with the
derivations because of the degree-15 ramification divisor.

## 6. Theorem-boundary ledger

| Statement | State |
|---|---|
| KLS image is an invariant unirational hypersurface | proved |
| canonical or divisor-clean KLS image is the Klein cubic | proved |
| identities (1)--(5) | proved and independently replayed |
| normal-image `P22` exclusion | proved |
| squarefree proper-`P22` exclusion under exact support hypotheses | proved |
| foliation lc follows from algebraic integrability | false in general |
| target-pair lc implies full repeated-factor cancellation | false; it may leave one reduced copy |
| target-pair plt bounds conductor pullback support | false in general |
| quartic precomposition contradicts minimality | false direction of inequality |
| minimality forces positive discrepancy | open |
| minimality bounds conductor support | open |
| finite exhaustive conductor list | not available |
| no KLS solution / no landing covariant | open |

## 7. Source-exhaustiveness bridge

Universal nonexistence of rank-four self-covariants would imply the negative
headline through the accepted KLS/covariant-dimension reduction.  The
conductor route reaches that conclusion only after eliminating every
singular non-Klein minimal image and then eliminating the divisor-clean
Klein branch.  The current packets do neither: they close selected `P22`
subbranches and retain unbounded families.  Therefore no all-degree or
headline conclusion is licensed.
