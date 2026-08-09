# Index-one Fano threefolds

## 1. Current benchmark: `V14`

The repository's genus-8 threefold `V14` is the model case. For

\[
G=\operatorname{PSL}_2(\mathbf F_{11})
\]

and an involution `σ`,

\[
C_G(\sigma)=D_{12},
\]

\[
V_{14}^{\sigma}=C_6\sqcup\{p_1,p_2\},
\qquad g(C_6)=1,
\]

and

\[
V_{14}^{D_{12}}=\varnothing.
\]

The centralizer obstruction proves that `V14` is not weakly `G`-versal. It remains the only index-one application in the repository with every fixed-scheme input sealed.

## 2. Best second target: the rational Klein `V22`

Let `C_K⊂P2` be the Klein quartic and

\[
X_{22}=\operatorname{VSP}(C_K,6).
\]

Cheltsov–Shramov identify `X22` as a smooth rational prime Fano threefold with

\[
\operatorname{Pic}(X_{22})=\mathbf Z[-K_{X_{22}}],
\qquad
(-K_{X_{22}})^3=22,
\]

carrying a faithful action of

\[
G=\operatorname{PSL}_2(\mathbf F_7).
\]

They prove that this action is `G`-birationally superrigid. Thus ordinary rationality is known but equivariant birational linearization fails.

### Published obstruction boundary

The recent classification of smooth Fano threefolds satisfying Condition (A) proves that every member of Mori–Mukai family No. 1.10 satisfies Condition (A). Therefore the exact `X22` action passes the going-down fixed-point test for every abelian subgroup.

Moreover, the canonical generator `-K_X` has its natural `G`-linearization. Hence the equivariant universal-torsor obstruction vanishes. By the 2026 universal-torsor theorem, all higher Amitsur groups vanish as well. The exact action therefore satisfies the desired silent-invariant profile:

```text
ordinary rationality                               PROVED
Condition (A)                                      PROVED
G-birational linearizability                        FALSE
universal-torsor obstruction                       ZERO
all higher Amitsur groups                          ZERO
G-fixed locus                                      EMPTY
G-unirationality / weak versality                   UNDECIDED
```

The current targeted literature search found no paper deciding the last line.

## 3. The full group has no fixed point

A point of

\[
X_{22}=\operatorname{VSP}(C_K,6)
\]

is represented by a length-six subscheme of the dual projective plane giving a six-term power-sum presentation of the Klein quartic. If a point of `X22` were fixed by `G`, that length-six subscheme would be `G`-stable.

The standard three-dimensional Klein representation is irreducible, so the dual projective plane has no `G`-fixed point. Every orbit in it therefore has cardinality equal to the index of a proper subgroup of `G`. The smallest index of a proper subgroup of

\[
G=\operatorname{PSL}_2(\mathbf F_7)
\]

is seven: a subgroup of index at most six would give a nontrivial homomorphism `G→S_6`, impossible since `G` is simple of order 168 and `168∤|S_6|=720`; equivalently, the familiar index-seven subgroup is `S4`.

The support of a nonempty `G`-stable zero-dimensional subscheme is a union of `G`-orbits. A length-six subscheme cannot contain an orbit of length at least seven. Hence no `G`-stable length-six subscheme exists, and

\[
\boxed{X_{22}^{G}=\varnothing.}
\]

This closes the first fixed-point gate without a computer calculation. It does not determine the fixed locus of an involution or its centralizer.

## 4. Involution-centralizer target

For an involution `σ∈PSL2(F7)`,

\[
N=C_G(\sigma)\simeq D_8.
\]

The residual-RCC centralizer theorem reduces the problem to the finite conditions

\[
\tag{A}
\text{every irreducible }D_8\text{-stable RCC subvariety of }X_{22}^{\sigma}
\text{ is a point},
\]

and

\[
\tag{B}
X_{22}^{D_8}=\varnothing.
\]

If (A) and (B) hold, `X22` is not weakly `PSL2(F7)`-versal.

### Exact models available for the computation

Two finite presentations are available.

1. **VSP model.** An automorphism of the Klein quartic acts functorially on length-six power-sum presentations. Fixed points and curves can be found in the corresponding Hilbert/VSP equations.
2. **Anticanonical model.** Cheltsov–Shramov record
   \[
   H^0(X_{22},-K_{X_{22}})\simeq\mathbf1\oplus W_6\oplus W_7.
   \]
   Restricting this 14-dimensional module to an involution and to `D8` gives finitely many ambient character pieces; one then intersects them with the anticanonical ideal.

The required calculation is substantially smaller than a covariant search: one involution class and one centralizer class suffice.

## 5. Acceptance table for the fixed-scheme audit

For every irreducible component `F⊂X22^σ`, record:

| datum | purpose |
|---|---|
| dimension and normalization | distinguish curves, surfaces, and points |
| genus/MRC quotient | decide whether `F` itself is RCC |
| residual `D8/<σ>` action | detect stable rational components |
| incidence with `X22^{D8}` | test the deeper fixed locus |
| normal characters | prepare an exceptional-network fallback |

The ideal successful output is

\[
X_{22}^{\sigma}=C\sqcup\{\text{points}\},
\qquad g(C)>0,
\qquad X_{22}^{D_8}=\varnothing.
\]

Rational components do not automatically end the route: the generalized theorem only asks that none be `D8`-stable.

## 6. Secondary genus-12 target: Mukai–Umemura

The Mukai–Umemura `V22` has

\[
\operatorname{Aut}(X_{MU})\simeq\operatorname{PGL}_2
\]

and contains the icosahedral subgroup `A5`. For an involution,

\[
C_{A_5}(\sigma)=V_4.
\]

This remains a legitimate fixed-locus computation, but it is weaker than the Klein `X22` target:

- the Klein action uses the larger simple group `PSL2(F7)`;
- Condition (A) is already published for the whole family;
- the VSP model is tied directly to the same Klein geometry that powered Problem F;
- the centralizer `D8` supplies a richer residual character network.

The Mukai–Umemura action is retained as a lower-ranked backup rather than the primary work order.

## 7. Other index-one directions

### Double-cover families

Sextic double solids and special Gushel–Mukai/Verra models provide central involutions fixing K3 or general-type surfaces. They become useful when a concrete residual group has no stable rational curve. Many have unresolved ordinary unirationality or insufficiently explicit finite actions, so they rank below `X22`.

### Genera 4 through 10

Special symmetric complete intersections and linear sections exist, but the search found no second action for which all of the following are already available simultaneously: ordinary rationality/unirationality, Condition (A), silent cohomological invariants, and a class-named involution centralizer.

### Del Pezzo fibrations

A central involution may fix a positive-genus multisection. No explicit rational index-one del Pezzo fibration with the full residual fixed-network data tabulated was found in this pass.

## 8. Answer to the `V14` question

> Does the `V14` centralizer phenomenon plausibly recur on another index-one Fano threefold?

Yes. The strongest current candidate is

\[
\boxed{
(X_{22},G)=
(\operatorname{VSP}(C_{\mathrm{Klein}},6),\operatorname{PSL}_2(\mathbf F_7)).
}
\]

It is rational, satisfies Condition (A), has no global `G`-fixed point, and has vanishing universal-torsor and all higher-Amitsur obstructions. Its status is separated from a theorem by the finite pair

\[
(X_{22}^{\sigma},X_{22}^{D_8}).
\]

No new all-degree machinery is required unless those fixed schemes contain residual-stable rational components.

## 9. Work order

```text
V22-PSL27-INVOLUTION-CENTRALIZER-AUDIT
```

1. Freeze the VSP or anticanonical equations over an exact splitting field.
2. Write one involution and its `D8` centralizer.
3. Decompose `H^0(-K)` into `σ`-eigenspaces and `D8` characters.
4. Compute `X22^σ` scheme-theoretically and normalize every curve component.
5. Compute `X22^{D8}`.
6. Classify residual-stable rational components, if any.
7. Apply the centralizer or residual-RCC theorem.

This is the recommended next theorem-forced finite computation in the entire application portfolio.