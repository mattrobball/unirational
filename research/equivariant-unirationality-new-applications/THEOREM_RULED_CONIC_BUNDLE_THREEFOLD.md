# Theorem: a rational conic-bundle threefold with a ruled central fixed divisor

This is the salvaged unique content of PR #13. Its adjudication record is
`ADJUDICATION_PR13.md`.

## 1. The variety and the action

Let

\[
p:\mathbb F_1=\mathbf P_{\mathbf P^1}
(\mathcal O\oplus\mathcal O(1))\longrightarrow\mathbf P^1
\]

be the first Hirzebruch surface. Let `S3` act on the base through the
standard two-dimensional irreducible representation

\[
r=\operatorname{diag}(\omega,\omega^{-1}),
\qquad
s=\begin{pmatrix}0&1\\1&0\end{pmatrix},
\qquad \omega^3=1,\ \omega\neq1,
\tag{1.1}
\]

so that on the base

\[
r[x:y]=[\omega x:\omega^{-1}y]=[\omega^2x:y],
\qquad
s[x:y]=[y:x].
\tag{1.2}
\]

This really is a linear lift of `S3`: `r^3=s^2=1` and `srs=r^{-1}` hold in
`GL2`, not merely in `PGL2`. Consequently `O_{P^1}(1)`, hence
`O ⊕ O(1)`, hence `F_1`, carries an `S3`-equivariant structure.

Put

\[
L=p^*\mathcal O(3),\qquad f=p^*(x^6+y^6),
\]

and

\[
X=\{uv=f w^2\}\subset
\mathbf P_{\mathbb F_1}(L\oplus L\oplus\mathcal O).
\tag{1.3}
\]

The weights match: `u` and `v` each carry `L`, so `uv` carries
`L^{\otimes2}=p^*O(6)`, and `f` is a section of `p^*O(6)`. The binary
sextic `x^6+y^6` is invariant under (1.1), so (1.3) is `S3`-invariant.

Let `z` exchange `u` and `v`, and set

\[
G=\langle z\rangle\times S_3\simeq C_2\times S_3.
\]

> **Theorem.** With the above notation:
>
> 1. `X` is a smooth rational projective threefold with a faithful,
>    generically free `G`-action;
> 2. `X^A` is nonempty for every abelian subgroup `A <= G`;
> 3. every Sylow subgroup of `G` has a fixed point;
> 4. `X^G` is empty;
> 5. `X` is not weakly `G`-versal, hence not `G`-unirational.
>
> The proof uses a central fixed divisor that contains infinitely many
> rational curves, so the older "no rational curve in the fixed locus"
> criterion does not apply; the residual-RCC theorem of
> `GENERALIZATIONS.md` does.

## 2. Smoothness and rationality

The binary sextic `x^6+y^6` has six distinct roots, so the divisor
`{f=0} ⊂ F_1` is the disjoint union of six ruling fibers of `p`, each with
multiplicity one.

Smoothness is checked in the three fiber charts. On `{u≠0}` the equation
reads `v=f w^2` and on `{v≠0}` it reads `u=f w^2`; both are graphs, hence
smooth. On `{w≠0}` the equation is `uv=f`, whose differential is
`v\,du+u\,dv-df`. At a point with `u=v=0` we have `f=0`, and `df≠0` there
because `f` is reduced. Hence `X` is smooth.

The two sections `{v=w=0}` and `{u=w=0}` lie on `X` and split the generic
conic, so `X` is birational to `P^1×F_1` over `F_1`. Since `F_1` is
rational, `X` is rational.

The `G`-action is faithful (`z` is nontrivial, and `S3` is faithful on the
base) and generically free (each nontrivial element has proper fixed locus).

## 3. The central fixed divisor

Fiberwise, `z` acts on `P^2_{u,v,w}` by swapping `u` and `v`. Its fixed
locus is the line `{u=v}` together with the isolated point
`{u=-v,\ w=0}`. On the second, the equation gives `-v^2=0`, hence
`u=v=0`, which is not a point of `P^2`; the anti-invariant eigenpoint
therefore misses `X` entirely.

On `{u=v=:q}` the equation becomes `q^2=f w^2`. Here `w=0` forces `q=0`,
so `X^z` lies in the affine part `{w≠0}` and

\[
T:=X^z=\{q^2=f\}\subset\operatorname{Tot}(L).
\tag{3.1}
\]

Since `f=p^*(x^6+y^6)`, this is the pullback along `p` of the double cover

\[
C:\ q^2=x^6+y^6
\subset\mathbf P(1,1,3),
\]

so

\[
T\simeq\mathbb F_1\times_{\mathbf P^1}C.
\tag{3.2}
\]

`C→P^1` is a smooth double cover branched at the six distinct roots of
`x^6+y^6`, so Riemann--Hurwitz gives `g(C)=2`. The fiber product (3.2) is
smooth, and `T→C` is a `P^1`-bundle. In particular `T` is a ruled surface
over a genus-two curve and contains a whole family of rational curves.

## 4. Residual action and the obstruction

`S3` acts on `C` compatibly with `C→P^1`, acting trivially on `q`.

The rotation `r` fixes exactly `[1:0]` and `[0:1]` on the base, and `s`
exchanges them, so

\[
(\mathbf P^1)^{S_3}=\varnothing,
\qquad\text{hence}\qquad
C^{S_3}=\varnothing.
\tag{4.1}
\]

**Hypothesis 1.** Let `W ⊆ T` be an irreducible `G`-stable rationally chain
connected closed subvariety. Since `z` acts trivially on `T`, `G`-stable
means `S3`-stable. The image of `W` in `C` is irreducible and rationally
chain connected; because `g(C)=2`, it is a point `c`. That point is
`S3`-stable, hence lies in `C^{S_3}=∅`. So no such `W` exists at all; in
particular every `G`-stable irreducible RCC subvariety of `T` is
zero-dimensional, vacuously.

**Hypothesis 2.** A `G`-fixed point of `X` is `z`-fixed, so it lies in `T`,
and its image in `C` is `S3`-fixed. By (4.1),

\[
X^G=\varnothing.
\tag{4.2}
\]

`z` is central in `G`, so its centralizer is all of `G`. The central form
of the residual-RCC theorem in `GENERALIZATIONS.md` therefore excludes every
`G`-equivariant rational map from a faithful linear source to `X`,
dominant or not. Since `X` is complete,

\[
\boxed{X\text{ is not weakly }G\text{-versal},}
\]

and in particular it is not `G`-unirational.

## 5. Condition (A) and Sylow fixed points

Let `A <= G` be abelian and let `B` be its projection to `S3`. Then `B` is
abelian, hence cyclic (`1`, `C2` generated by a transposition, or `C3`),
and `A ⊆ ⟨z⟩ × B`. Since `z` acts trivially on `T`, it is enough to find a
point of `T` fixed by `B`.

**Step 1: `C^B ≠ ∅`.** Work in `P(1,1,3)` with `q` of weight three.

- `B=⟨r⟩`: take `c=[1:0:1]`, which satisfies `1^2=1^6+0^6`. Then
  `r\cdot(1,0,1)=(\omega,0,1)`, and rescaling by `λ=ω^{-1}` gives
  `(1,0,\omega^{-3})=(1,0,1)`. So `c∈C^{⟨r⟩}`.
- `B=⟨h⟩` for a transposition `h=s r^k`: `h` fixes two points of the base
  (for `h=s` these are `[1:1]` and `[1:-1]`), and it acts trivially on `q`,
  so both points of `C` above such a base point are `h`-fixed. For `h=s`
  and base point `[1:1]` the fiber is `q^2=2`, giving `[1:1:\sqrt2]`.
- `B=1`: any point of `C`.

**Step 2: from `C` to `X`.** Let `c∈C^B` and let `T_c ≅ P^1` be the fiber
of `T→C` over `c`, which is the ruling fiber of `F_1` over the image of
`c`. It is `A`-stable. The action of `A` on `T_c` factors through `B`,
because `z` is trivial on `T`; `B` is cyclic, and every cyclic subgroup of
`PGL2` has a fixed point on `P^1`. Any such fixed point lies in
`T ⊆ X` and is fixed by `A`. Hence `X^A ≠ ∅`.

Both Sylow subgroups of `G` are abelian — the Sylow 2-subgroup is
`⟨z⟩×⟨h⟩ ≅ C2×C2` for a transposition `h`, and the Sylow 3-subgroup is
`⟨r⟩ ≅ C3` — so item 3 of the theorem is a special case of Condition (A).

The group-theoretic side of this argument (all abelian subgroups of
`C2 × D_{2n}` for odd `n`, the impossibility of a commuting
rotation/reflection pair, and the explicit witnesses on `q^2=x^{2n}+y^{2n}`)
is machine-checked for `n=3,5,7,9` by
`verify_dihedral_conic_bundle.py`; the case `n=3` is the one used here.

## 6. Relative Néron--Severi data

This section records a computation. It is **not** used in the proof of the
theorem.

Over each of the six discriminant fibers the conic splits into a component
in `{u=0}` and a component in `{v=0}`. Their sum is a pullback from `F_1`,
hence zero in `N^1(X/F_1)=N^1(X)/π^*N^1(F_1)`, so their difference class
`D_i` satisfies `[u=0]_i=-[v=0]_i=D_i`. The involution `z` exchanges the two
components, so `z·D_i=-D_i`, and each `D_i` is anti-invariant. The relative
hyperplane class `H` is `G`-invariant. Therefore

\[
N^1(X/\mathbb F_1)^G_{\mathbf Q}=\mathbf Q\cdot H
\]

has rank one, and `-K_X` is `π`-ample. So `π:X→F_1` is a `G`-equivariant
conic-bundle contraction of relative invariant Picard rank one.

No claim is made here about the output of a relative or absolute
`G`-MMP, and none is needed: the obstruction in Section 4 is a statement
about `X` itself.

## 7. Scope

- The theorem uses only the accepted residual-RCC theorem of
  `GENERALIZATIONS.md` in its central form. It does not use the withdrawn
  assertion that arbitrary fixed strata remain rationally chain connected on
  arbitrary models.
- The reduction of Hypothesis 1 goes through an honest equivariant
  **morphism** `T→C` onto a positive-genus curve, not through a maximal
  rationally connected quotient that is only a rational map.
- No cohomological claim is made. Neither the ordinary Amitsur group nor
  any higher Amitsur group of this action is computed here.
- The interest of the example is that the central fixed locus is a ruled
  surface, so it contains infinitely many rational curves; the older
  criterion "the fixed locus contains no rational curve" is unavailable and
  the residual-stability refinement is doing the work.
