# The restricted-graph dichotomy and the CLEAN CM norm equation

## 1. Setup

Let
\[
\varphi:X\dashrightarrow X
\]
be the dominant `G`-equivariant selfmap obtained by restricting a hypothetical
ambient landing map.  Let `J` be its primitive restricted base ideal and let
\[
\Gamma=\operatorname{Proj}_{X}\overline{\mathcal R(J)}
\]
be the normalized graph, with source and target maps
\[
\pi:\Gamma\longrightarrow X,
\qquad
q:\Gamma\longrightarrow X.
\]
The map `pi` is birational and `q` is generically finite of degree `delta`.
Put
\[
V=H^3(X,\mathbf Q)(1).
\]
Intersection complexes are normalized to be perverse, so
`IC_X^H=Q_X^H[3]` and
\[
IH^3(\Gamma,\mathbf Q)(1)
 =\mathbb H^0\!\left(X,R\pi_*IC_\Gamma^H\right)(1).
\]
Everything below is in polarizable rational Hodge modules or their Hodge
realizations.  No Chow-correspondence projector is asserted or used.

## 2. Canonical full-support splitting

### Lemma 2.1 — birational unit and trace

There are canonical `G`-equivariant maps
\[
i_\pi:IC_X^H\longrightarrow R\pi_*IC_\Gamma^H,
\qquad
t_\pi:R\pi_*IC_\Gamma^H\longrightarrow IC_X^H
\]
normalized to be the identity on the largest open set where `pi` is an
isomorphism, and
\[
t_\pi i_\pi=\operatorname{id}_{IC_X^H}.
\tag{2.1}
\]
Thus
\[
e_0=i_\pi t_\pi,
\qquad
e_{\rm exc}=1-e_0
\tag{2.2}
\]
are canonical complementary idempotents.

The image of `e_0` is the unique full-support term `IC_X^H`.  Every strict
support occurring in `im(e_exc)` is proper and lies in `Bs(J)`.  Since `J` is
primitive, `Bs(J)` has no divisorial component, so every such support has
dimension at most one.

#### Proof

Over the common isomorphism locus, both maps are the identity of the constant
Hodge module.  Intermediate extension gives `i_pi`; Verdier duality and the
polarizations give `t_pi`.  Their composite is an endomorphism of the simple
Hodge module `IC_X^H` and equals the identity on a dense open set, hence equals
the identity globally.  Away from `Bs(J)`, `pi` is an isomorphism, so the
complementary summand has no support there.  This gives (2.1)--(2.2) without
choosing a decomposition-theorem splitting.  ∎

The strict-support decomposition of each semisimple perverse Hodge module
\[
{}^pH^j(R\pi_*IC_\Gamma^H)
\]
is canonical after grouping simple summands by support.  The splitting of the
whole derived direct image need not be canonical and will not be used.

### Lemma 2.2 — generically finite unit and trace

There are canonical `G`-equivariant maps
\[
i_q:IC_X^H\longrightarrow Rq_*IC_\Gamma^H,
\qquad
t_q:Rq_*IC_\Gamma^H\longrightarrow IC_X^H
\]
with
\[
t_qi_q=\delta\operatorname{id}_{IC_X^H}.
\tag{2.3}
\]
Indeed, on a dense open set where `q` is finite étale they are diagonal
pullback and trace, whose composite is multiplication by `delta`; simplicity
extends the identity across the complement.

Write the same symbols for the induced maps on degree-three Hodge structures.
The graph correspondence and its polarization adjoint are
\[
u_\varphi=t_\pi i_q:V\longrightarrow V,
\qquad
u_\varphi^\dagger=t_qi_\pi:V\longrightarrow V.
\tag{2.4}
\]
On a smooth resolution of the graph these are `p_*g^*` and `g_*p^*`.

## 3. Intrinsic CARRIER/CLEAN dichotomy

Define the canonical exceptional part of the actual class by
\[
r_\varphi=e_{\rm exc}i_q|_V:
V\longrightarrow IH^3(\Gamma)(1).
\tag{3.1}
\]
This map is independent of a decomposition-theorem splitting.  It is
`G`-equivariant and a morphism of rational Hodge structures.  Since `V` is an
irreducible rational `G`-module, it is either zero or injective.

### Theorem 3.1 — restricted dichotomy

Exactly one of the following branches holds.

### CARRIER branch

If `r_phi` is nonzero, then there exist

- a perverse degree `j_0`;
- a proper irreducible strict support `T subset Bs(J)`, `dim T<=1`; and
- `H=Stab_G(T)` (or the stabilizer of a chosen simple constituent over `T`),

such that a strict-support block
\[
\mathcal M_{T,j_0}\subset
{}^pH^{j_0}(R\pi_*IC_\Gamma^H)
\]
satisfies
\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(
 \operatorname{Res}^G_HV,
 H^{-j_0}(X,\mathcal M_{T,j_0})(1)
\right)\ne0.
\tag{AHS-Gamma}
\]
If a simple constituent is `IC_{\overline T}^H(L)` and `s=dim T`, this becomes
\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(
 \operatorname{Res}^G_HV,
 IH^{s-j_0}(\overline T,L)(1)
\right)\ne0.
\tag{3.2}
\]
This is the intrinsic restricted analogue of `(AHS)`.

#### Proof

Apply the canonical perverse Leray filtration to the nonzero map (3.1).
Strictness for Hodge structures makes its first nonzero associated-graded map
nonzero.  In that perverse degree, the canonical decomposition by strict
support gives a nonzero projection to a `G`-orbit of proper support blocks.
Frobenius reciprocity for that orbit gives `(AHS-Gamma)`.  The cohomological
index is `-j_0` because `Gamma` has dimension three and the class lies in
`H^0(X,Rpi_*IC_Gamma)`, whereas the ambient fourfold formula has the extra
`-1`.  ∎

### CLEAN branch

If `r_phi=0`, then
\[
i_q|_V=i_\pi u_\varphi.
\tag{3.3}
\]
The exceptional correction to graph--transpose-graph composition is
\[
C_{\rm exc}=t_qe_{\rm exc}i_q|_V.
\tag{3.4}
\]
It vanishes, and
\[
\boxed{
 u_\varphi^\dagger u_\varphi
 =\delta\operatorname{id}_V.
}
\tag{3.5}
\]

#### Proof

Since `e_exc i_q=0` and `e_0=i_pi t_pi`, equation (3.3) follows.  Then
\[
\delta\operatorname{id}_V
=t_qi_q
=t_qi_\pi u_\varphi
=u_\varphi^\dagger u_\varphi.
\]
Equivalently,
\[
\delta\operatorname{id}_V-u_\varphi^\dagger u_\varphi
=t_q(1-i_\pi t_\pi)i_q=C_{\rm exc}=0.
\]
This is an identity of Hodge correspondences, not a Chow identity.

For a resolution check, take a smooth `Z` with
`p=pi circ rho` and `g=q circ rho`.  The CLEAN condition says that the
exceptional component of `g^*V` relative to `p^*V` vanishes, hence
`g^*|_V=p^*u_phi`.  Therefore
\[
u_\varphi^\dagger u_\varphi
=g_*p^*p_*g^*
=g_*g^*
=\delta\operatorname{id}_V,
\]
where the middle equality uses `p_*p^*=id` on `H^3(X)` and the CLEAN
factorization.  ∎

This proves

```text
RESTRICTED-DICHOTOMY-PROVED
RESTRICTED-CARRIER-BRANCH-PROVED
```

## 4. The `G`-Hodge commutant and the integral order

Let
\[
K=\mathbf Q(\sqrt{-11}),
\qquad
\omega=\frac{1+\sqrt{-11}}2,
\qquad
\nu=\omega-1=\frac{-1+\sqrt{-11}}2.
\]
The accepted representation decomposition is
\[
V_{\mathbf C}=W_5\oplus\overline W_5
\]
with nonisomorphic conjugate irreducible summands.  Schur's lemma and rational
irreducibility give a quadratic rational commutant, and the character field is
`K`.  Each commutant element preserves the two Hodge summands, so
\[
\operatorname{End}_{G\text{-HS}}(V)=K.
\tag{4.1}
\]

For
\[
V_{\mathbf Z}=H^3(X,\mathbf Z)(1)/\mathrm{torsion},
\]
the integral commutant is an order in `K`.  Roulleau's explicit period lattice
of the Klein intermediate Jacobian is stable under multiplication by `nu`.
Consequently the order contains
\[
\mathbf Z[\nu]=\mathbf Z[\omega]=\mathcal O_K.
\]
As this is already the maximal order,
\[
\operatorname{End}_{G\text{-HS}}(V_{\mathbf Z})=\mathcal O_K.
\tag{4.2}
\]
The positive Rosati involution on the imaginary quadratic field `K` is complex
conjugation.

The discriminant is `-11`.  Minkowski's bound is
\[
\frac2\pi\sqrt{11}<3.
\]
The only possible nontrivial ideal-class representative below that bound would
have norm two, but `T^2-T+3` reduces to the irreducible polynomial
`T^2+T+1` over `F_2`; hence two is inert.  Therefore
\[
h(K)=1.
\tag{4.3}
\]

The graph correspondence is integral, so in the CLEAN branch
\[
u_\varphi=x+y\omega,
\qquad x,y\in\mathbf Z.
\]
Using (3.5) and Rosati conjugation gives
\[
\boxed{
\delta=N_{K/\mathbf Q}(u_\varphi)
=x^2+xy+3y^2.
}
\tag{4.4}
\]
Thus a CLEAN degree is represented by the principal norm form.  In particular,
\[
2\text{ is not represented},
\qquad
3=N(\nu),
\qquad
5=N(1+\omega).
\]
This proves

```text
RESTRICTED-CLEAN-CM-NORM-PROVED
```

## 5. Mandatory consistency audit

The exact comparison with every numerical degree datum in
`FULL_G_SELFMAP_CLASSIFICATION` is:

| classification datum | norm audit | result |
|---|---:|---|
| degree-one branch | `1=N(1)` | compatible |
| degree two | not represented; independently excluded there | compatible |
| constructed tangent-residual selfmap | exact degree not computed; only `delta>=3` | if its degree is a norm it may be CLEAN; otherwise Theorem 3.1 forces CARRIER |
| iterates of a CLEAN selfmap | `deg(phi^m)=delta^m=N(u_phi^m)` | compatible |
| strict elliptic multiplier `[-5]` | `N(-5)=25` | compatible; this is not a claim that the threefold selfmap degree is five |

For the last row, the fixed-carrier polarization formula uses the square of the
elliptic multiplier:
\[
3(-5)^2=75=3d\,\deg(p|_C)-B\cdot C.
\]
There is no `N(5)=5` bookkeeping: the scalar integer five has quadratic-field
norm twenty-five.

A nonrepresented degree is excluded only from the CLEAN branch, not from the
existence of a selfmap.  It automatically places that selfmap in the CARRIER
branch.  Hence the tangent-residual existence theorem creates no mismatch.

`verify_norm_sieve.py` checks the ring law, conjugation, norm
multiplicativity, every displayed small value, exact representations through
40, CLEAN iterates, and the `[-5]` bookkeeping using integer arithmetic only.
