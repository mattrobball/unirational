# Fixed-network boundary theorem

## Setting

Let

\[
G=PSL_2(F_{11}),\qquad Y=P(W_5),\qquad X\subset Y
\]

be the Klein cubic threefold. Assume hypothetically that

\[
f:Y\dashrightarrow X
\]

is a dominant `G`-equivariant rational map. Restriction to `X` gives a dominant rational `G`-self-map

\[
\varphi=f|_X:X\dashrightarrow X.
\]

Let `p:Z->X` and `q:Z->X` be a smooth `G`-equivariant resolution of the normalized graph of `varphi`. For every involution `t`,

\[
X^t=E_t\sqcup L_t,
\]

with `E_t` elliptic and `L_t=P^1`. Let `N` be the reduced union of all `E_t` and `L_t`.

## Theorem A: resolution category

A degree-`d` representative of `f` has a `G`-stable base ideal. Equivariant principalization in characteristic zero gives a sequence of blowups with smooth `G`-stable centers, each having normal crossings with the accumulated exceptional boundary, on which `f` becomes a morphism.

For an abelian subgroup `H`, a connected component `S` of the `H`-fixed part of a smooth center `C`, and the character decomposition

\[
N_{C/Y}|_S=\bigoplus_\chi N_\chi,
\]

the new exceptional `H`-fixed pieces over `S` are the projective bundles

\[
P(N_\chi)\longrightarrow S.
\]

The trivial-character piece is contained in the transformed old fixed component. This formula is exact for each blowup.

However, the literal collection of all fixed components is not invariant under further equivariant blowup: a later smooth `G`-stable center can have fixed part of positive genus. Therefore a resolution-independent theorem must classify essential horizontal carriers or corresponding valuations, not every refinement component on equal footing.

## Theorem B: corrected marked residual action

Choose a type-I point of `E_t` as origin and orient `q_t in E_t[3]`. The residual `S_3` action is

\[
\tau(P)=P+q_t,\qquad \sigma(P)=-P.
\]

The three reflections are

\[
\tau^i\sigma(P)=iq_t-P,\qquad i=0,1,2.
\]

Their fixed loci satisfy `2P=iq_t`, and their union is

\[
E_t[2]+\langle q_t\rangle.
\]

The type-I orbit is `<q_t>` and the three type-II orbits are `e+<q_t>` for `0 != e in E_t[2]`.

The previously recorded formula using `P -> e-P` for the three nonzero two-torsion points is incompatible with the `S_3` multiplication table.

## Theorem C: actual strict component maps

### Elliptic to elliptic

Every nonconstant residual-`S_3`-equivariant morphism `E_t -> E_t` is uniquely

\[
P\longmapsto[n]P+a,
\qquad n\equiv1\pmod3,\quad a\in E_t[2].
\]

There is no residual-equivariant constant map to `E_t`.

On the marked subgroup:

- the type-I orbit is preserved exactly when `a=0`;
- all four marked `C_3` orbits are preserved exactly when `a=0` and `n` is odd;
- all twelve marked points are fixed pointwise exactly when
  \[
  a=0,\qquad n\equiv1\pmod6.
  \]

Thus `[-5]` is the first nonidentity multiplication in absolute value only after imposing pointwise preservation of the full marked set.

### Elliptic to line

In a standard coordinate on `L_t`, a nonconstant residual-equivariant map `u:E_t->L_t` is exactly a rational function satisfying

\[
u(P+q_t)=\omega u(P),\qquad u(-P)=u(P)^{-1}.
\]

Its degree is divisible by three. Degree-three examples exist by choosing disjoint `q_t`-orbits `D,-D` of degree three with `D~-D` and taking a function with divisor `D-(-D)`.

### Line to line

With

\[
\tau(z)=\omega z,\qquad \sigma(z)=z^{-1},
\]

the nonconstant residual-equivariant rational maps are exactly

\[
R(z)=zA(z^3),
\qquad A(u)A(u^{-1})=1.
\]

Equivalently, after cancellation, `A=B/B^iota` with `iota(u)=u^{-1}`. This is an infinite family. The monomial `z^m` is equivariant exactly when `m=1 mod 3`.

### Line to elliptic

Every morphism `P^1 -> E_t` is constant. Because residual `S_3` has no global fixed point on `E_t`, there is no residual-equivariant map `L_t -> E_t`.

## Theorem D: the unbroken reduced network

Assume the original components of `N` survive on a resolved model and all their restrictions are nonconstant. Then:

1. every `L_t` maps to `L_t`;
2. every `E_t` maps to `E_t`;
3. type-I incidence forces every elliptic translation term to vanish;
4. type-II triple incidence forces the common elliptic multiplier to satisfy `n=1 mod 6`;
5. every line map fixes its six type-I marked points pointwise.

Conversely, for every pair

\[
n\equiv1\pmod6,
\qquad m\equiv1\pmod6,
\]

the maps

\[
[n]:E_t\to E_t,
\qquad z^m:L_t\to L_t
\]

glue over all type-I and type-II points and, by conjugation, define a genuine `G`-equivariant morphism

\[
\Phi_{n,m}:N\to N.
\]

Hence the actual morphisms of the reduced fixed-curve network already form an infinite family. The proposed profile `([-5],id)` is `Phi_{-5,1}`; it is not isolated by the network.

## Theorem E: the Problem-F propagation mechanism fails in dimension three

At either a type-I or a type-II `V_4` point,

\[
T_xX=\chi_z\oplus\chi_s\oplus\chi_r.
\]

The first blowup has exceptional divisor

\[
D=P(T_xX)=P^2.
\]

For the involution `z`,

\[
D^z=P(\chi_z)\sqcup P(\chi_s\oplus\chi_r).
\]

The second component is a rational line, pointwise `z`-fixed, joining the other two character directions. It may map nonconstantly to the rational component `L_z` of `X^z`. Moreover:

- `D^{V_4}` is the disconnected set of three coordinate points;
- the invariant conic `x_z^2+x_s^2+x_r^2=0` is rational and has faithful `V_4` action;
- the incidence object over the point is two-dimensional and admits bypasses.

Therefore connectedness or rational chain connectedness of the total exceptional fiber does not imply connectedness of the relevant fixed locus, and the surface tree/kernel argument from Problem F does not extend formally.

## Theorem F: polarization with base correction

Let `H=O_X(1)`, let the ambient map be represented primitively by degree-`d` forms, and let `F` be the principalized base divisor. Then

\[
q^*H=d\,p^*H-F
\]

in `Pic(Z)`.

If a carrier curve `C` is identified by `p` with `E_t` and `q|_C=[n]+a`, then

\[
3n^2=3d-F\cdot C.
\]

If `C` is identified by `p` with `L_t` and `q|_C` has degree `r`, then

\[
r=d-F\cdot C.
\]

Thus `d=n^2` and `r=d` hold only when the corresponding base intersection vanishes. The installed local transition theory does not prove this vanishing.

## Final boundary

Theorems A-F classify the strict component maps and expose the exact three-dimensional exceptional failure. They do not classify the essential horizontal carriers of the actual principalized base ideal. The correct exit is therefore

\[
\boxed{\texttt{FIXED-NETWORK-CLASSIFICATION-UNDECIDED}}.
\]

The smallest missing theorem is ambient base-carrier rigidity: a refinement-invariant construction and classification of the horizontal carriers, exclusion of the `P^2` bypasses for an actual covariant, computation of the base corrections, and global coupling over all 55 `V_4` configurations.
