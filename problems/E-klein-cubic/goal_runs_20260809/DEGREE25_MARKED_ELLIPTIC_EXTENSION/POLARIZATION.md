# Polarization and degree

## 1. Symmetry of the actual plane polarization

Let `L=O_{E_t}(1)` for the actual plane embedding
$E_t\subset\mathbf P(W_+(t))$. Choose a marked point `O` fixed by a residual
reflection and use it as origin. That reflection becomes inversion `[-1]` on
the elliptic curve. Because the reflection is induced by the projective linear
normalizer action, it preserves the hyperplane line bundle. Hence

\[
[-1]^*L\simeq L;
\]

`L` is symmetric for this origin.

The theorem of the cube for a symmetric line bundle gives

\[
[n]^*L\simeq L^{\otimes n^2}.
\]

Taking `n=-5` yields the exact identity

\[
[-5]^*O_{E_t}(1)\simeq O_{E_t}(25).
\]

Changing to another allowed marked origin does not change the map `[-5]`, by
the six-torsion calculation. Choosing a reflection-fixed marked origin again
makes the same plane polarization symmetric, so the conclusion is intrinsic.

## 2. Equivariant linearization

The two sides carry normalizer linearizations. Their ratio is a linearized
trivial line bundle and hence a character of `N_G(<t>)`. It is trivial:
central `t` acts trivially on `W_+(t)`, and at the chosen reflection-fixed
origin the reflection has the same fiber character on `L^{25}` and on
`[-5]^*L` (the exponent 25 is odd). The central involution and a reflection
detect the character group of the dihedral normalizer. Thus the isomorphism
can be chosen normalizer-equivariantly.

## 3. What degree 25 does and does not force

For a degree-`d` tuple representing `[-5]` nontrivially on `E_t`, its scalar
multiplier is a regular section of

\[
L^d\otimes([-5]^*L)^{-1}\simeq L^{d-25}.
\]

Therefore:

- `d<25` is impossible even as a rational restriction of a regular tuple;
- `d=25` gives a constant scalar and no elliptic base point;
- `d>25` can represent the same projective map on a dense open, but necessarily
  introduces zeros of the scalar section on the elliptic.

Thus 25 is the **minimal and basepoint-free elliptic restriction degree**. The
polarization alone does **not** prove that every higher-degree rational
representative differs by a global invariant common factor; a componentwise
zero divisor need not extend to a principal invariant divisor on `P(W)`.

## 4. Incompatibility with the identity lines

For `lambda_D|L_t=id`, the same comparison line bundle is

\[
O_{P^1}(d)\otimes id^*O_{P^1}(-1)=O_{P^1}(d-1).
\]

A projective tuple defined at every point of the line requires a nowhere-zero
section, forcing `d=1`. Hence no single homogeneous degree can define the full
`[-5]/id` morphism everywhere on `D`; the degree-25 proposal already fails on
each line.

Allowing line base points removes this literal obstruction, but not the
landing obstruction of `THEOREM.md`: every landing covariant vanishes on the
entire plus-plane, so it cannot recover the elliptic map even generically.
