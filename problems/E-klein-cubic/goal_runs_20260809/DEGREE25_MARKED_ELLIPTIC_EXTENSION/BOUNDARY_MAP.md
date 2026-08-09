# Intrinsic construction of the boundary map

## 1. The marked group and origin changes

Fix an involution `t` and choose a type-I marked point `O` as origin on `E_t`.
The installed marked configuration is

\[
M_t=E_t[2]+\langle q_t\rangle,
\qquad 0\ne q_t\in E_t[3].
\]

It has 12 elements and exponent 6. If the origin is changed from `O` to
`O'=O+b`, then multiplication by an integer `n` changes by

\[
[n]_{O'}(P)=[n]_O(P)+(1-n)b.
\]

For `n=-5` and every marked shift `b in M_t`, the correction is `6b=0`.
Thus `[-5]` is independent of the allowed marked-origin ambiguity. This proves
more than needed when only type-I origins are permitted, since those shifts
form the subgroup `<q_t>`.

## 2. Residual S3, with the coordinate convention repaired

With a type-I origin, the free residual order-three element is

\[
r(P)=P+q_t.
\]

The same origin convention and the installed stabilizer incidence force the
three residual reflections to be

\[
s_a(P)=a-P,\qquad a\in\langle q_t\rangle.
\]

Indeed, the fixed set of `s_a` is `2P=a`, consisting of exactly one type-I
point and the three type-II points in the corresponding `E[2]`-coset. These
three four-point fixed sets partition the 12 marked points, exactly as the
three `V4` subgroups through `t` require.

This corrects a coordinate mismatch in the older prose formulation
`P mapsto e-P` with `e in E[2]`: under the simultaneous convention
`type-I=<q>` and `type-II=e+<q>`, those affine involutions do not have the
installed marked fixed sets. The commutation calculation itself remains valid
for any six-torsion affine constant.

Now

\[
[-5](P+q_t)=[-5]P+q_t
\]

because `-5=1 mod 3`, and

\[
[-5](a-P)=a-[-5]P
\]

because `6a=0`. Hence `[-5]` commutes with the generators and therefore with
the full residual `S3`.

A shorter coordinate-free proof is

\[
g[n]_Og^{-1}=[n]_{gO}.
\]

Every residual element carries `O` to another marked origin, and the preceding
origin-independence identifies `[−5]_{gO}` with `[−5]_O`.

## 3. Marked points

For every `P in M_t`,

\[
[-5]P-P=-6P=0.
\]

Thus `[-5]` fixes all 3 type-I and all 9 type-II points on `E_t` pointwise.
The identity fixes all six type-I points on `L_t`.

## 4. Conjugation by G

For `g in G`, the projective linear action identifies `E_t` with
`E_{gtg^{-1}}` and transports the marked configuration. Functoriality gives

\[
g\,[-5]_{E_t}\,g^{-1}=[-5]_{E_{gtg^{-1}}}.
\]

The identity maps on the lines are transported in the same way. Therefore the
whole collection of component maps is globally `G`-equivariant before any
gluing argument is used.
