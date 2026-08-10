# Semilinear rank-three descent: the coefficient class and its exact boundary

**Date:** 2026-08-08  
**Scope:** the surviving `A=<mu>` Kummer cover, with the coefficient
`c=r_2^-1` retained  
**Verdict:** the coefficient is a nonzero constant torsor translate, but
norm, order, Picard, Brauer, and logarithmic data do not prevent such a
translate from meeting trace zero

## 1. The coefficient is a constant translate of one universal torsor

Put

\[
 E=\mathbf C(r_0,\ldots,r_4)/(r_0r_1r_2r_3r_4-1),
 \qquad \sigma(r_i)=r_{i+1},\qquad K=E^\sigma,
\]

and let

\[
 T=R_{E/K}\mathbf G_m/\mathbf G_m,
 \qquad \psi([a])=[a^2\sigma(a)],
 \qquad A=\ker(\psi).
\]

The projective isogeny `psi` has degree eleven, so `A` is the order-eleven
form of `mu_11` already identified in `H6A_PROJECTIVE_11_ISOGENY`.  Let

\[
 U=\{[b]\in \mathbf P(\ker\operatorname {Tr}_{E/K}):N_{E/K}(b)\ne0\}
 \subset T.                                                   \tag{1.1}
\]

For `c in E*`, pull back `psi` along the map

\[
 U\longrightarrow T,\qquad [b]\longmapsto[c^{-1}b].          \tag{1.2}
\]

This gives an `A`-torsor `Y_c -> U`.  If
`delta:T(K)->H^1(K,A)` is the connecting map, then its fibre at `b` has
class

\[
 \tau_c(b)=\delta([c^{-1}b]).                                \tag{1.3}
\]

Consequently

\[
 Y_c(K)\ne\varnothing
 \quad\Longleftrightarrow\quad
 \exists a\ne0:\operatorname {Tr}_{E/K}(c a^2\sigma(a))=0.   \tag{1.4}
\]

For the authoritative coefficient `c=r_2^-1`, the constant class
`delta([c])` has exact order eleven.  Formula (1.3), however, shows why its
nontriviality is not itself a point obstruction: it translates which fibres
of one fixed torsor split.

## 2. Exact descent calculation on the five-hyperplane complement

After base change to `E`, (1.1) is

\[
 U_E=\{[b_0:\cdots:b_4]:\sum b_i=0,\ \prod b_i\ne0\}.
\]

On `b_0 != 0` its coordinate ring is

\[
 E[x_1^{\pm1},x_2^{\pm1},x_3^{\pm1},
   (1+x_1+x_2+x_3)^{-1}],                                  \tag{2.1}
\]

a localization of a polynomial UFD.  Hence

\[
 \operatorname {Pic}(U_E)=0,\qquad
 \mathcal O(U_E)^*/E^*\simeq
 \Lambda=\{(n_i)\in\mathbf Z^5:\sum n_i=0\}.                \tag{2.2}
\]

Kummer theory gives

\[
 {H^1(U_E,\mu_{11})\over H^1(E,\mu_{11})}
 \simeq\Lambda/11\Lambda.                                  \tag{2.3}
\]

All groups in (2.3) are `11`-primary.  Since the descent group has order
five, its higher cohomology on them vanishes by averaging.  Restriction and
twisted invariants therefore give

\[
 {H^1(U,A)\over H^1(K,A)}
 \simeq (\Lambda/11\Lambda)^{C_5,\mathrm{tw}}.               \tag{2.4}
\]

Cyclic rotation on the augmentation space has the four distinct
eigenvalues `3,4,5,9` over `F_11`.  The twist selects exactly the line

\[
 \langle\mu\rangle,
 \qquad \mu=(1,5,3,4,9),                                   \tag{2.5}
\]

which is the character of the Klein monomial cover.  Thus (2.4) is
one-dimensional.  Every coefficient `c` has the same nonzero geometric
cover class (2.5); replacing `c` changes the class only by the pullback of
the constant element `-delta([c]) in H^1(K,A)`.

There is no hidden transgression here.  The point

\[
 p=[r_0-r_1]\in U(K)                                       \tag{2.6}
\]

is defined because the five conjugate differences are nonzero and telescope
to zero.  Pullback by `p` splits `H^1(K,A)->H^1(U,A)`.  After normalizing the
universal class to vanish at `p`, the open problem is exactly whether its
evaluation map on `U(K)` contains `delta([r_2^-1])`.

## 3. A norm-one, exact-order-eleven coefficient which *does* meet trace zero

The following identity is unrestricted and uses no support or degree
search.

### Proposition 3.1

For any nonzero `b in E` with `Tr(b)=0`, put

\[
 n=N_{E/K}(b),\qquad a=b^2,
 \qquad c_b={n\over b^3\sigma(b)^2}.                         \tag{3.1}
\]

Then

\[
 N(c_b)=1,qquad
 c_b\,a^2\sigma(a)=n b,qquad
 \operatorname {Tr}(c_ba^2\sigma(a))=0.                    \tag{3.2}
\]

Indeed, `N(b^3 sigma(b)^2)=n^5`, while `N(n)=n^5`; and
`a^2 sigma(a)=b^4 sigma(b)^2`.

This construction can carry a genuinely nontrivial order-eleven class.
Take

\[
 d_i=r_i-r_{i+1},\qquad b=d_0,
 \qquad n=\prod_i d_i.                                      \tag{3.3}
\]

The `d_i` are five distinct irreducible Laurent primes and
`sum_i d_i=0`.  Formula (3.1) becomes

\[
 c_b={n\over d_0^3d_1^2}.                                  \tag{3.4}
\]

Along the ordered prime orbit `(d_0,...,d_4)`, its valuation vector is

\[
 w=(-2,-1,1,1,1).                                           \tag{3.5}
\]

For the complete Smith residue of `2+sigma`,

\[
 \sum_iw_i=0\pmod3,
 \qquad
 (1,9,4,3,5)\mathbin\cdot w=1\pmod {11}.                   \tag{3.6}
\]

Thus the class is nonzero in `E*/psi(E*)`.  It has order exactly eleven,
not merely order divisible by eleven.  With

\[
 x=(-13,1,5,3,4),\qquad
 h=\prod_i d_i^{x_i},                                      \tag{3.7}
\]

one has

\[
 (2I+\text{previous shift})x=11w,
 \qquad \psi(h)=c_b^{11}.                                  \tag{3.8}
\]

Finally, the displayed solution is literal:

\[
 c_b\psi(d_0^2)=n d_0,qquad
 \operatorname {Tr}(n d_0)=n\sum_i d_i=0.                  \tag{3.9}
\]

Hence the implication

```text
norm-one coefficient + nontrivial exact order-eleven psi-class
    => no trace-zero point
```

is false.  Any negative theorem for `r_2^-1` must use the particular class,
not only its norm, order, or abstract `A`-torsor type.

## 4. What distinguishes `r_2^-1` from the counterexample

The authoritative coefficient `r_2^-1` is a Laurent unit.  Its obstruction
is the nonzero **unit** residue in the projective cokernel of `2+sigma`.
The coefficient (3.4), in contrast, has the nonzero free-prime residue
(3.6).  Multiplication by `psi(E*)` cannot remove that residue.

Every regular automorphism of the Laurent torus sends units to units and
prime divisors to prime divisors, and an automorphism commuting with `sigma`
preserves free cyclic prime orbits.  Therefore no regular `C_5`-equivariant
torus automorphism can carry the class of (3.4) to the class of `r_2^-1`.

There is also a simple dimension warning.  The five conjugates of (3.4)
depend only on the projective difference tuple

\[
 [d_0:\cdots:d_4],\qquad \sum d_i=0,                        \tag{4.1}
\]

and hence generate a field of transcendence degree at most three.  The five
conjugates of `r_2^-1` generate `E`, of transcendence degree four.  Thus no
`C_5`-equivariant field automorphism sends the literal coefficient (3.4) to
`r_2^-1`.

This does **not** exclude a birational equivalence after changing the
representative by `psi(u)`: such a change preserves the `A`-torsor class but
can introduce a fourth parameter into the displayed coefficient.  Proving
that no such birational compression exists is precisely the unresolved
`ed_K(A)=4` problem.  The regular-automorphism distinction must not be
promoted to a birational-orbit theorem.

The actual unit residue can be written completely.  With the convention
`lambda=(1,9,4,3,5)`, the five conjugates of `c=r_2^-1` have residues

\[
 \bigl(\lambda(-e_2),\lambda(-e_3),\lambda(-e_4),
       \lambda(-e_0),\lambda(-e_1)\bigr)
 =(7,8,6,10,2)
 =7(1,9,4,3,5)\pmod {11}.                                \tag{4.2}
\]

Thus the abstract one-dimensional `C_5` module does not distinguish it from
the counterexample: both are nonzero eigen-orbits, and an automorphism of
the order-eleven group can rescale one to the other.  What differs is where
the residue lives: (4.2) is a torus-unit class, while (3.6) is carried by an
actual free prime orbit.

There is also an exact regular-automorphism calculation on the trace open
`U`.  Over `E`, write `D` for the five-hyperplane boundary in `P^3`.  It is
simple normal crossings and

\[
 K_{\mathbf P^3}+D=-4H+5H=H                              \tag{4.3}
\]

is ample.  Therefore `(P^3,D)` is the intrinsic log-canonical model of
`U_E`; every regular automorphism of `U_E` extends to this pair.  The five
hyperplanes form a projective frame in the dual projective space, so

\[
 \operatorname {Aut}_E(U_E)=S_5.                           \tag{4.4}
\]

Descent acts on this `S_5` by conjugation with the five-cycle permuting the
hyperplanes.  Hence

\[
 \operatorname {Aut}_K(U)=C_{S_5}(C_5)=C_5.                \tag{4.5}
\]

These five rotations preserve the monomial cover and merely rescale its
character line (2.5); they do not add a constant torsor translate.  They
also preserve the unit/free-prime distinction above.  Consequently no
regular `K`-automorphism of `U`, and no regular equivariant automorphism of
the coefficient torus, transfers the soluble counterexample to
`r_2^-1`.

The birational group is a different matter: `U` has rational function field
of transcendence degree three, so arbitrary Cremona self-maps need not
preserve the log boundary.  A birational map compatible with the
order-eleven cover and shifting its constant class from (3.4) to
`r_2^-1` would itself supply the missing three-dimensional compression.
No invariant computed here rules out that map without assuming regularity.

## 5. Why Picard, Brauer, and logarithmic refinements do not see the class

The smooth projective compactification is the twisted Klein cubic `X_c`.
Geometrically,

\[
 \operatorname {Pic}(X_{\bar K})=\mathbf Z[H],\qquad
 \operatorname {Br}(X_{\bar K})=0,                          \tag{5.1}
\]

and the hyperplane class descends.  Hochschild--Serre therefore gives

\[
 \operatorname {Br}(X_c)/\operatorname {Br}(K)=0.           \tag{5.2}
\]

Nonconstant Brauer symbols on the open arrangement complement are ramified
at its boundary; none supplies a new unramified class on `X_c`.

Over `E`, logarithmic one-forms on the five-hyperplane complement are
generated by `dlog(b_i/b_0)`.  Pullback by the monomial cover is the matrix
`2+sigma`, whose determinant on `Lambda` is eleven.  It is consequently an
isomorphism after tensoring with the characteristic-zero field, in every
exterior degree.  Multiplication by `c` contributes
`d_{U_E/E}log(c)=0`, so all coefficients give the same relative logarithmic
map.  These forms have boundary poles and do not become regular
pluricanonical forms on the Fano compactification.

The exact stopping statement is therefore

```text
RANK3-SEMILINEAR-TORSOR-TRANSLATE-IDENTIFIED
RANK3-NORMONE-ORDER11-COEFFICIENT-OBSTRUCTION-REFUTED
RANK3-REGULAR-EQUIVARIANT-AUTOMORPHISM-TRANSFER-EXCLUDED
RANK3-BIRATIONAL-CLASS-TRANSFER-EQUIVALENT-TO-OPEN-COMPRESSION
RANK3-ACTUAL-r2-INVERSE-CLASS-OPEN
F55-GLOBAL-QUESTION-OPEN
```
