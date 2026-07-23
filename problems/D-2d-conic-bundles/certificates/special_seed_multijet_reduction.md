# Special-seed multijets: the restricted-family obstruction and local rank atlas

## Verdict and scope

This note records a strict reduction of the remaining quartic special-seed
problem.  It does **not** prove the all-special-seeds theorem and it does not
produce a counterexample to that theorem.

There is, however, an unavoidable obstruction to the most direct proposed
proof: the 90-dimensional family of `(2,4)` equations is not a full
two-point first-jet family in the `x`-variables.  Consequently one cannot cite
ordinary Thom multijet transversality merely from the dimension of the
coefficient space.  The smaller coefficient quotients which occur in the
residual fold/cusp and double-value incidences often still have the expected
ranks.  The exact local ranks checked here isolate the projective strata which
remain to be proved uniformly.

Everything below concerns the open residual multiplier stratum
\(\lambda _2\ne0\), except for the explicitly labelled first-order boundary
rows.  Subsequent certificates compute the saturated closure through
\(\lambda _2=0\), identify it with the smooth actual ramification curve, and
prove generic two-point separation.  They also prove the ordinary
middle/bottom boundary fold and nonzero-\(\gamma\) condition.  Uniform
open-residual fold/cusp and higher-Morin classification and isolated
triple-value or forced-discriminant collisions remain open.

The exact-arithmetic replay is
`special_seed_multijet_reduction_checks.py`; its checked output is in
`special_seed_multijet_reduction_checks.log`.

## 1. Why full Thom multijet generation fails

Let \(x_0\ne x_1\) be two points of \(\mathbf P^2_x\), and let
\(L_{01}\) be their joining line.  The map

\[
H^0(\mathbf P^2_x,\mathcal O(2))
 \longrightarrow J^1_{x_0}\mathcal O(2)\oplus
 J^1_{x_1}\mathcal O(2)
\tag{1.1}
\]

has rank five, not six.  Its kernel is exactly
\(\langle L_{01}^2\rangle\): a conic with a double zero at both points has
degree two and must be the doubled joining line.

For example, put \(x_0=(0,0)\), \(x_1=(1,0)\), with joining line
\(B=0\), and use the basis

\[
1,A,B,A^2,AB,B^2.
\]

The six value/first-derivative rows have rank five and kill precisely
\(B^2\).  Tensoring (1.1) with the fifteen quartic `y`-coefficients shows
that the full `(2,4)` coefficient map to two `x`-first-jets has rank

\[
5\cdot15=75<90.
\tag{1.2}
\]

This is a rigorous obstruction to a black-box argument requiring surjectivity
onto the full two-point jet bundle.  It is not a geometric counterexample:
the singularity-specific incidences below use only fourteen or fewer scalar
rows, and those rows can remain independent despite (1.2).

## 2. Flat residual coordinates and the intrinsic cusp rows

Use the affine coordinates from
`special_seed_stability_frontier.md`:

\[
x=[1:A:B],\qquad p=(u=v=0),\qquad
\ell=\{v=Lu\},\qquad r=(T,LT).
\]

For the length-three divisor \(2p+r\), write the restriction remainder as
\(s=(s_0,s_1,s_2)\) in the basis \(1,u,u^2\).  Thus

\[
u^m\equiv T^{m-2}u^2\pmod {u^2(u-T)},\qquad m\ge2,
\tag{2.1}
\]

including \(T=0\).  Put \(z=(A,B,L,T)\).  On the residual multiplier chart
normalize \(\lambda_2=1\).  A residual critical point is cut out by the seven
linear coefficient rows

\[
s=0,\qquad \lambda D_zs=0.
\tag{2.2}
\]

Their rank is seven both at \(T=1\) and \(T=0\).

Here is a convenient linear incidence for the next Boardman stratum.  Choose
\([k]\in\mathbf P^3_z\) and \(\mu\in\mathbf A^3\), and impose

\[
D_zs(k)=0,
\qquad
\lambda D_z^2s(k,-)=\mu D_zs.
\tag{2.3}
\]

The second equation says that \(k\) is in the radical of the Hessian induced
on \(\ker D_zs\).  The auxiliary multiplier has the gauge
\(\mu\mapsto\mu+c\lambda\).  If \(a\) is a second-order correction satisfying

\[
D_zs(a)=-D_z^2s(k,k),
\]

then (2.3) gives

\[
\lambda D_z^2s(k,a)=-\mu D_z^2s(k,k).
\]

Consequently the intrinsic cubic of the reduced plane-curve singularity is

\[
\boxed{
\mathfrak c
=\lambda D_z^3s(k,k,k)-3\mu D_z^2s(k,k).}
\tag{2.4}
\]

The equation \(\mathfrak c=0\) is again linear in the 90 coefficients once
\((z,\lambda,k,\mu)\) is fixed.

## 3. Exact representative one-point ranks

The checker performs rational Gaussian elimination and then repeats every
rank modulo 101 and 103.  For the displayed representatives it gives the
following ranks.  The first entry is the rank of (2.2)--(2.3), whose matrix
has fourteen rows and one universal relation; the second is the rank after
adjoining (2.4).

| direction of \(k=(k_A,k_B,k_L,k_T)\) | \(T=0\) | \(T=1\) |
|---|---:|---:|
| `(1,2,3,4)` (all directions present) | `13 / 14` | `13 / 14` |
| `(1,1,0,0)` (pure `x`-plane) | `13 / 14` | `13 / 14` |
| `(0,0,1,1)` (no `x`, mixed `L,T`) | `12 / 13` | `12 / 13` |
| `(0,0,1,0)` (pure `L`) | `12 / 12` | `12 / 13` |
| `(0,0,0,1)` (pure residual direction) | `11 / 11` | `11 / 11` |

The expected dimension bookkeeping explains why this table is promising but
does not by itself prove transversality.  Before the \(\mu\)-gauge is removed,
the variables \((\text{flag},\lambda,k,\mu)\) have dimension

\[
6+2+3+3=14.
\]

Thus rank 13 for (2.2)--(2.3), followed by rank 14 after (2.4), is exactly
what gives isolated cusps and excludes the next Morin stratum for a general
equation.  The no-`x` directions form a codimension-two subspace of
\(\mathbf P^3_k\), compensating for the observed one-rank drop if this table
is uniform on that stratum.

The pure residual direction has a separate geometric exclusion.  In a smooth
tangent chart the quartic residual is quadratic in \(r\).  A double residual
root already gives \(Q=Q_r=0\); making the residual direction Hessian-radical
forces \(Q_{rr}=0\), hence \(Q\equiv0\).  This says that \(\ell\) is a
component of \(C_x\), which does not occur for a general equation.  The lower
rank in the last row therefore records a forbidden line-component boundary,
not evidence of an unavoidable higher Morin point.

What is still missing here is a characteristic-zero row-space proof that the
same ranks hold on every projective \((\lambda,k,\mu)\)-stratum, with a complete
description of all further rank drops.  Checking representatives, even
exactly over \(\mathbf Q\), is not that uniform proof.

## 4. First-order boundary rows

At both \(T=1\) and \(T=0\), adjoining the three equations
\(\nabla_yF(x,p)=0\) to (2.2) gives rank eight: two gradient rows are already
the value and tangent-direction rows in \(s=0\), and the transverse
`y`-derivative adds one row.  Adjoining instead the three equations saying
that the conic fiber is singular at \(x\),

\[
F(x,p)=F_A(x,p)=F_B(x,p)=0,
\]

gives rank nine.

Together with rank seven after imposing \(T=0\), these are the expected
first-order counts:

| incidence | coefficient rank | expected consequence after uniformization |
|---|---:|---|
| residual critical | 7 | a critical curve |
| plus `p=r` | 7 | finite diagonal intersection |
| plus tangent-base gradient | 8 | finite same-source interaction |
| plus conic-fiber gradient | 9 | no general same-source interaction |

They show that none of these boundaries is forced to be a whole residual
critical component at the checked normal forms.  They do **not** compute the
saturation at \(\lambda_2=0\), its embedded structure, or the coefficient
\(\gamma\) in the forced local model.

## 5. Two-point ranks over a common base point

For two residual critical flags over the same marked point \(p\), the checker
stacks two copies of the seven rows (2.2).  Exact rational ranks at canonical
representatives are:

| configuration | rank |
|---|---:|
| distinct `x`, distinct lines | 14 |
| distinct `x`, same line and distinct residual points | 14 |
| distinct `x`, identical `(ell,r,lambda)` | 13 |
| same `x`, distinct lines | 13 |
| same `x`, distinct lines, both `r=p` | 12 |
| same `x` and line, distinct residual points | 11 |

The drops match the geometric codimensions.  In particular, the general
two-point space has parameter dimension fourteen (including the common
\(p\)) and rank fourteen.  Imposing the same `x` removes two parameters while
the rank drops only one.  The apparently borderline last row is globally
empty for a general equation: on a fixed line the quartic is

\[
F_x|_\ell=p^2Q,
\qquad \deg Q=2.
\]

Two distinct residual critical points would make two distinct roots of
\(Q\) multiple, forcing \(Q=0\), again a forbidden line component.

The exact source of the rank-13 identical-flag row is (1.1).  In coordinates
on the joining line of the two `x`-points, the value and tangential derivative
jets obey one universal relation.  This is dimension-compensated because
equality of the `y`-flag and of \(\lambda\) is a proper diagonal stratum.

The checker also records ranks 21 for one generic three-point representative
and 18 for a representative with all three `x`-points equal.  Those two
numbers are diagnostics only; they are not a complete triple-coincidence
classification.

## 6. Exact remaining work

The strongest current reduction is therefore the following.

1. A black-box full-jet Thom theorem is unavailable because of (1.1)--(1.2).
   One must prove transversality on the smaller row spaces dictated by
   (2.2)--(2.4).
2. On the open residual chart, the expected fold/cusp ranks and the expected
   two-point ranks occur at every canonical representative tested over
   \(\mathbf Q\), including the flat diagonal \(T=0\).  The only borderline
   same-line strata found force a line component and are globally excluded.
3. To turn this atlas into a theorem, one must stratify the full projective
   spaces of \(\lambda,k,\mu\), and of two or three flags, and exhibit uniform
   pivot minors or dimension-compensating equations on every rank-drop
   stratum.
4. The saturated closure through \(\lambda_2=0\) and its smooth
   scheme-theoretic comparison with actual ramification were subsequently
   completed in `special_seed_residual_saturation.md` and
   `special_seed_ramification_comparison.md`.  The first-order ranks in
   Section 4 alone did not supply that calculation.
5. The joint middle/bottom boundary rows were subsequently completed in
   [`special_seed_boundary_fold_theorem.md`](special_seed_boundary_fold_theorem.md).
   The intrinsic Hessian proves an
   ordinary fold, and the simultaneous local model is

   \[
   uv=s,\qquad z^2=u+v+\gamma t.
   \]

   Reducedness of the already identified boundary then proves
   \(\gamma\ne0\).  This conclusion was not supplied by the calculations in
   the present note alone.
6. The off-diagonal pair table was subsequently completed projectively and
   now proves generic one-to-one mapping of every ramification component.
   A full isolated triple-value and collision-with-forced-discriminant audit
   remains.

Thus there is still no proved global all-special-seeds upgrade, and no
unavoidable geometric counterexample has emerged.  This note proves the
failure of full multijet generation and the exact local rank atlas above;
the later certificates close its saturation and generic two-point gaps.
What remains is the open-residual radical/cubic projective stratification in
item 3 and the isolated triple-value or forced-discriminant collision audit
in item 6, rather than an appeal to unrestricted Thom transversality.
