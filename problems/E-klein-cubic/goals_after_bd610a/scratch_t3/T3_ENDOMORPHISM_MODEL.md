# T3 endomorphism normalization model

## Scope and corrected RUR seal

This note gives the exact algebraic shape of the one-step normalization that
must be computed.  It is a conditional reduction, not a completed T3.A/T3.B
certificate: the two-generator identities listed below have not yet been
produced over `Q(A,u)`, and exhaustiveness of the height-one singular support
is still open.

The corrected trace-dual RUR inputs are

```text
generic_singular_rur_QZ.tsv  23be9dbe72a9a4089924accde05fc9f8d43b13e644a2e2c8528fabdb3608ef9f
generic_singular_rur_NB.tsv  3ffd1fad77d6e66d40ee8f447bb898c87d0fefb936ef6ea1bf24a02ac7a228ee
generic_singular_rur_NY.tsv  5a57c14e530a4ec111731b09a59da510f578f850d8655e31e7c318849a5209ae
```

Write

\[
q=Q_Z(A,u,Z),\qquad
r_B=Bq_Z'-N_B,\qquad r_Y=Yq_Z'-N_Y.
\]

Every inverse or normalizer probe made from the earlier `NB/NY` signs is
obsolete and must not be sealed.

## Stable-ideal presentation

Let

\[
S=\bigl(\mathbf Q[A,B,Y,Z,u]/(P,P_u)\bigr)[h^{-1}]
\]

on the authoritative common open, where `h` contains all accepted Cramer and
fold gates.  Suppose direct reductions prove that

\[
\mathfrak p=(q,r_B,r_Y)S
\]

is the exhaustive height-one nonnormal prime.  The generic local node implies
that, after shrinking the common open, there are `c,d in p` and
`alpha,beta in S` satisfying

```text
p = (c,d),
d^2 = alpha*c^2 + beta*c*d,
(c : d) = p.
```

Equivalently, `p^2=c*p`; the displayed quadratic identity is the only
nonautomatic generator of that equality.

Define

\[
\theta=d/c\in\operatorname{Frac}(S),\qquad
T=S+S\theta=\mathfrak p/c.
\]

Then

\[
\theta^2-\beta\theta-\alpha=0,
\]

so `T` is a finite birational `S`-algebra with the same fraction field.  This
is the compact integral-basis presentation that avoids expanding the enormous
generic inverse of `q'`.

## Why this is the endomorphism algebra

The equality `p^2=c*p` gives

\[
(\mathfrak p/c)\mathfrak p=\mathfrak p,
\]

hence `p/c` is contained in `End_S(p)=(p:p)`.  At the generic point of `p`,
the completed nonsplit node has normalization

\[
B=L'[[t]],\qquad L'/L\text{ quadratic},
\]

and the original completed local ring is

\[
A=L+tB.
\]

Its maximal ideal and conductor are both `m=tB`.  For every
`c in m minus m^2`, one has `cB=m`, and therefore

\[
(m:m)=B=m/c.
\]

Thus `T_p=End_{S_p}(p_p)` is already the local normalization.  Away from
`V(p)`, the stable-ideal equality forces `c` to be a unit and `T=S`.
Consequently `T` and `End_S(p)` agree after deleting the proper closed locus
where the two-generator/stability certificates fail.

## One correction is enough

The fold algebra `S` is a three-dimensional complete intersection, hence
Cohen--Macaulay.  On an open where `S/p` is regular (in particular
Cohen--Macaulay of dimension two), the exact sequence

\[
0\longrightarrow\mathfrak p\longrightarrow S
\longrightarrow S/\mathfrak p\longrightarrow0
\]

shows that `p` is maximal Cohen--Macaulay.  Since `T=p/c` is isomorphic to
`p` as an `S`-module, `T` is `S_2`.

At every height-one prime other than `p`, `T=S` and the accepted fold ring is
regular.  At `p`, the preceding completed model identifies `T_p` with the DVR
`L'[[t]]`.  Hence `T` is `R_1`.  Serre's criterion now proves that `T` is
normal.  Thus the stable-ideal presentation proves in one step, rather than
merely suggesting, the integral closure on the certified open.

## Conductor and local invariants

From `T=S+S(d/c)`,

\[
\operatorname{cond}_{S\subset T}
=\{s\in S:s(d/c)\in S\}=(c:d)=\mathfrak p.
\]

Therefore the conductor has height-one support `p` and exponent one.  Reducing
the monic equation modulo `p` gives the quadratic residue extension with
discriminant

\[
\Delta_{\rm norm}=\beta^2+4\alpha\in\kappa(\mathfrak p)^\times/
\kappa(\mathfrak p)^{\times2}.
\]

For the nonsplit node this class is nonsquare, so the normalization has one
branch over the ground residue field, residue degree two, ramification index
one, delta invariant one, and conductor exponent one.  The exact
`A=u=-6` packet proves this pattern on a characteristic-zero fibre; descent
to the generic component still requires the regular-model and specialization
certificates stated in that packet.

## Exact computation that remains

The smallest decisive normalization computation is now:

1. directly reduce `P,P_u,P_A,P_B,P_Y,P_Z` by the corrected RUR and certify
   that `p` is prime, finite flat of degree six over the chosen parameter
   open, and exhaustive in codimension one;
2. find a two-generator chart `p=(c,d)` and verify all gate norms;
3. output exact `alpha,beta` with
   `d^2=alpha*c^2+beta*c*d`;
4. verify the two colon/equality certificates
   `p^2=c*p` and `(c:d)=p`;
5. verify that `S/p` is regular and that
   `beta^2+4*alpha` is a nonzero nonsquare in the degree-six residue field.

Those five items supply the requested integral basis, monic equation,
normality proof, conductor, and generic local data without a full expanded
`normal.lib` colon.  Until they are executed, the correct status remains
`T3-UNDECIDED`.
