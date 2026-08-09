# Corrigendum: marked residual `S_3` geometry on `E_t`

## Scope

This corrects one clause of `certificates/MARKED_S3_GEOMETRY.md`. The following installed facts remain accepted:

- `j(E_t)=8192/11`, hence `End(E_t)=Z`;
- residual order three acts freely as translation by a nonzero `q in E_t[3]`;
- the three type-I points form one residual `C_3` orbit;
- the nine type-II points form three residual `C_3` orbits;
- the union of the twelve marked points is `E_t[2]+<q>`.

The erroneous clause is the asserted simultaneous formula

\[
P\longmapsto e-P,\qquad 0\ne e\in E_t[2],
\]

for the three residual reflections.

## Correct normal form

Choose a type-I point `O` as origin, choose the orientation of `q`, and let

\[
\tau(P)=P+q.
\]

A residual reflection fixes one of the type-I points. Choose the origin to be such a fixed point. Since `j(E_t) != 0,1728`, every automorphism fixing the origin is `+1` or `-1`; the reflection is therefore

\[
\sigma(P)=-P.
\]

The relation in `S_3` is

\[
\sigma\tau\sigma=\tau^{-1}.
\]

The three reflections are consequently

\[
\sigma_i=\tau^i\sigma,
\qquad
\sigma_i(P)=iq-P,
\qquad i\in Z/3.
\]

Their products are

\[
\sigma_i\sigma_j=\tau^{i-j},
\]

which is the required `S_3` multiplication table.

## Fixed points and marked set

A point is fixed by `sigma_i` exactly when

\[
2P=iq.
\]

Each equation has four solutions, and the three fixed sets are disjoint because `q` has order three. Since multiplication by two is an automorphism of `<q>`,

\[
\bigcup_{i=0}^2 Fix(\sigma_i)
=[2]^{-1}(<q>)
=E_t[2]+<q>.
\]

The fixed set of `sigma_0` contains the chosen type-I origin. Its other three points are one representative from each nonzero `E_t[2]` coset. Translating by `q` transports these four points to the fixed sets of `sigma_1` and `sigma_2`. Thus the type-I orbit is `<q>` and the type-II points are the three nonzero cosets `e+<q>`.

## Why the old formula is impossible

For `r_e(P)=e-P` and `r_f(P)=f-P`, with `e,f in E_t[2]`,

\[
r_e r_f(P)=P+e-f.
\]

If `e != f`, this is translation by nonzero two-torsion and has order two. The product of two distinct reflections in `S_3` must instead be a nontrivial order-three rotation. Hence the three maps indexed by nonzero `E_t[2]` cannot be the residual reflections.

## Consequence for equivariant self-maps

For `u(P)=[n]P+a`, commutation with `tau` and `sigma` gives

\[
n\equiv1\pmod3,
\qquad 2a=0.
\]

Thus residual equivariance permits every `a in E_t[2]`; it does not force `a=0`. Global unbroken type-I incidence later forces `a=0`, but that is a separate argument and may fail on an exceptional detour.

The finite verifier in this packet checks the corrected relations, the four fixed points per reflection, the twelve-point union, and the failure of the old formula.
