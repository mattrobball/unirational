# Restricted-graph dichotomy and the clean CM norm equation

## 1. Setup and conventions

Let
\[
\phi:X\dashrightarrow X
\]
be the dominant `G`-equivariant rational selfmap obtained by restricting a
hypothetical ambient landing map.  Let `J` be its primitive base ideal and
\[
\Gamma=\operatorname{Proj}_{X}\overline{\mathcal R(J)}
\]
the normalized graph, with source and target maps
\[
\pi:\Gamma\to X,
\qquad
q:\Gamma\to X.
\]
The degree of `q` is the degree `delta` of `phi`.  Put
\[
V=H^3(X,\mathbf Q)(1).
\]
We use intersection complexes normalized to be perverse.  Thus
`IC_X^H=Q_X^H[3]`, and
\[
IH^3(\Gamma,\mathbf Q)=
\mathbb H^0\bigl(X,R\pi_*IC_\Gamma^H\bigr).
\]
All maps and decompositions below are in polarizable rational Hodge modules or
on their Hodge-theoretic hypercohomology.  No Chow-correspondence projector is
used.

## 2. Canonical unit and trace maps

### Lemma 2.1 — birational unit--trace splitting

There are canonical `G`-equivariant morphisms
\[
\eta_\pi:IC_X^H\longrightarrow R\pi_*IC_\Gamma^H,
\qquad
\tau_\pi:R\pi_*IC_\Gamma^H\longrightarrow IC_X^H
\]
whose restrictions to the largest open set on which `pi` is an isomorphism are
the identity, and
\[
\tau_\pi\eta_\pi=\operatorname{id}_{IC_X^H}.
\tag{2.1}
\]
Consequently
\[
e_X:=\eta_\pi\tau_\pi,
\qquad
e_{\mathrm{exc}}:=1-e_X
\tag{2.2}
\]
are canonical complementary idempotents.  The image of `e_X` is the unique
full-support summand `IC_X^H`; every strict support in the image of
`e_exc` is proper and is contained in `Bs(J)`.

#### Proof

On the common isomorphism locus, use the identity of the two constant Hodge
modules.  Intermediate extension gives the full-support map `eta_pi`.
Verdier duality and the fixed polarizations give `tau_pi`, normalized to be the
identity on that open set.  The composite is an endomorphism of the simple
Hodge module `IC_X^H` and restricts to the identity on a dense open set, so it
is the identity globally.  The idempotents follow.  Over `X\Bs(J)`, `pi` is an
isomorphism; therefore every support in the complementary image lies in the
base locus.  Since `J` is primitive, the base locus has no divisorial
component, hence these supports have dimension at most one.  This construction
uses only Hodge-module morphisms, not a chosen splitting of the decomposition
theorem.  ∎

### Lemma 2.2 — generically finite unit and trace

There are canonical `G`-equivariant morphisms
\[
\eta_q:IC_X^H\longrightarrow Rq_*IC_\Gamma^H,
\qquad
\tau_q:Rq_*IC_\Gamma^H\longrightarrow IC_X^H
\]
with
\[
\tau_q\eta_q=\delta\operatorname{id}_{IC_X^H}.
\tag{2.3}
\]
On a dense open set where `q` is finite étale, these are the diagonal pullback
and the usual trace.  Equation (2.3) follows there and hence everywhere by
simplicity of `IC_X^H`.

Taking degree-zero hypercohomology, write the induced maps as
\[
i_\pi,t_\pi,i_q,t_q.
\]
The canonical class called `q_Gamma^*V` in the ambient bridge packet is
`i_q(V)`.  The graph-correspondence action and its polarization adjoint are
\[
u_\phi:=t_\pi i_q:V\to V,
\qquad
u_\phi^\dagger:=t_q i_\pi:V\to V.
\tag{2.4}
\]
On a common smooth resolution these are respectively `pi_*q^*` and `q_*pi^*`,
so (2.4) is the Hodge realization of the graph and transpose-graph
correspondences.

## 3. The restricted dichotomy

Define the canonical exceptional projection of the actual class by
\[
c_\phi:=e_{\mathrm{exc}}i_q|_V:
V\longrightarrow IH^3(\Gamma)(1).
\tag{3.1}
\]
This definition is independent of any decomposition-theorem splitting.
Because `V` is irreducible over `Q` as a `G`-module, `c_phi` is either zero or
injective.

### Theorem 3.1 — CARRIER/CLEAN dichotomy

Exactly one of the following alternatives holds.

#### (i) CARRIER branch

If `c_phi` is nonzero, then an intrinsic restricted carrier exists.  More
precisely, there are

- a perverse degree `j_0`,
- a proper irreducible strict support `T subset Bs(J)` with `dim T<=1`, and
- its stabilizer `H=Stab_G(T)`,

such that, for a strict-support block
\[
\mathcal M_{T,j_0}\subset
{}^pH^{j_0}(R\pi_*IC_\Gamma^H),
\]
one has
\[
\operatorname{Hom}_{\mathrm{HS},H}
\left(
 \operatorname{Res}^G_H V,
 H^{-j_0}(X,\mathcal M_{T,j_0})(1)
\right)\ne0.
\tag{AHS-Gamma}
\]
If a simple constituent is
`IC_{\overline T}^H(L)` and `s=dim T`, this can be written
\[
\operatorname{Hom}_{\mathrm{HS},H'}
\left(
 \operatorname{Res}^G_{H'}V,
 IH^{s-j_0}(\overline T,L)(1)
\right)\ne0
\tag{3.2}
\]
for the stabilizer `H'` of that constituent.  The statement is intrinsic to
`Gamma`: `e_exc`, the perverse filtration, and strict-support decomposition are
canonical, although no individual decomposition-theorem splitting is chosen.

#### Proof of the CARRIER branch

The nonzero map (3.1) is injective by irreducibility.  Give its target the
perverse Leray filtration induced by `Rpi_*IC_Gamma^H`; strictness of morphisms
of Hodge structures gives a unique jump on the irreducible source.  The
associated graded map is nonzero in some perverse degree.  The canonical
strict-support decomposition of that perverse cohomology then gives a nonzero
map to at least one `G`-orbit of proper support blocks.  Frobenius reciprocity
for that orbit gives (AHS-Gamma).  The shift is `-j_0`, rather than the ambient
`-1-j_0`, because `Gamma` has dimension three and `IH^3(Gamma)` is degree-zero
hypercohomology.  The support and dimension assertions follow from Lemma 2.1.
∎

#### (ii) CLEAN branch

If `c_phi=0`, then
\[
i_q|_V=i_\pi u_\phi.
\tag{3.3}
\]
The exceptional correction to graph--transpose-graph composition is
\[
C_{\mathrm{exc}}
:=t_qe_{\mathrm{exc}}i_q|_V.
\tag{3.4}
\]
It vanishes, and on `V`
\[
\boxed{
 u_\phi^\dagger u_\phi
 =\delta\operatorname{id}_V.
}
\tag{3.5}
\]

#### Proof of the CLEAN branch

The equation `e_exc i_q=0` and `e_X=i_pi t_pi` give (3.3).  By (2.3),
\[
\delta\operatorname{id}_V=t_qi_q.
\]
Using (3.3) and (2.4),
\[
t_qi_q=t_qi_\pi u_\phi=u_\phi^\dagger u_\phi.
\]
Equivalently,
\[
\delta\operatorname{id}_V-u_\phi^\dagger u_\phi
=t_q(1-i_\pi t_\pi)i_q=C_{\mathrm{exc}},
\]
which is zero in the CLEAN branch.  This is a Hodge-level identity; no cycle
projector onto intersection cohomology is asserted.  ∎

The dichotomy and both conditional conclusions prove the exit

```text
RESTRICTED-DICHOTOMY-PROVED
CARRIER-INTRINSIC-RESTRICTED-AHS
CLEAN-CORRECTION-VANISHES
```

## 4. The `G`-Hodge commutant and its integral order

Let
\[
K=\mathbf Q(\sqrt{-11}),
\qquad
\omega=\frac{1+\sqrt{-11}}2,
\qquad
\nu=\omega-1=\frac{-1+\sqrt{-11}}2.
\]
The accepted representation-theoretic decomposition is
\[
V_{\mathbf C}=W_5\oplus\overline{W}_5,
\]
with two nonisomorphic conjugate irreducible representations.  Hence
\[
\operatorname{End}_{\mathbf Q[G]}(V)\otimes_{\mathbf Q}\mathbf C
\simeq\mathbf C\oplus\mathbf C.
\]
Rational irreducibility and Schur's lemma therefore make the commutant a
quadratic field; its character field is `K`.  Each element acts separately on
the two Hodge summands, so it preserves the Hodge decomposition.  Thus
\[
\operatorname{End}_{G\text{-HS}}(V)=K.
\tag{4.1}
\]

For the integral lattice
\[
V_{\mathbf Z}=H^3(X,\mathbf Z)(1)/\mathrm{tors},
\]
its `G`-Hodge endomorphism ring is an order in `K`.  Roulleau's explicit period
lattice for the Klein intermediate Jacobian is a rank-five
`Z[nu]`-lattice; in particular scalar multiplication by `nu` preserves the
actual integral lattice and commutes with `G`.  Since
\[
\mathbf Z[\nu]=\mathbf Z[\omega]=\mathcal O_K
\]
is already the maximal order, one obtains
\[
\operatorname{End}_{G\text{-HS}}(V_{\mathbf Z})=\mathcal O_K.
\tag{4.2}
\]

The Rosati involution on `K` is complex conjugation.  Indeed the identity
involution would violate positivity on `sqrt(-11)`, while conjugation is the
unique positive involution on this imaginary quadratic field.  Since the graph
correspondence is integral, `u_phi` lies in `O_K`; write
\[
u_\phi=x+y\omega,
\qquad x,y\in\mathbf Z.
\]
Equation (3.5) becomes
\[
\delta=u_\phi\overline{u_\phi}
=x^2+xy+3y^2.
\tag{4.3}
\]
This proves the clean arithmetic record

```text
CLEAN-CM-NORM-EQUATION
```

### Class number

The discriminant of `O_K` is `-11`.  Minkowski's bound says that every ideal
class contains an integral ideal of norm at most
\[
\frac2\pi\sqrt{11}<3.
\]
The only possible nontrivial norm would be `2`.  But the minimal polynomial
`T^2-T+3` of `omega` reduces to `T^2+T+1`, irreducible over `F_2`; hence `2` is
inert and there is no ideal of norm `2`.  Therefore
\[
h(K)=1.
\tag{4.4}
\]
Equivalently, an integer is represented by (4.3) exactly when every inert prime
has even valuation.

## 5. Degree sieve and mandatory consistency audit

Immediate values are
\[
N(\nu)=3,
\qquad
N(1+\omega)=5,
\qquad
N(5)=25.
\]
Thus `2` is not represented, while `3` and `5` are represented.  The notation
`[-5]` on an elliptic carrier means the scalar integer `-5`, whose CM norm is
`25`; it does **not** assert that the threefold selfmap degree is `5`.

The complete consistency comparison with
`FULL_G_SELFMAP_CLASSIFICATION` is:

| classified selfmap datum | CM-norm comparison | verdict |
|---|---|---|
| `delta=1` identity branch | `1=N(1)` | compatible |
| `delta=2` | not represented; independently excluded in the classification packet | compatible |
| the constructed nonidentity map has an unspecified `delta>=3` | if its degree is represented it may be CLEAN; if not, Theorem 3.1 forces its CARRIER branch | no mismatch |
| iterates of a CLEAN map, degrees `delta^m` | `delta^m=N(u_phi^m)` | compatible |
| elliptic boundary multiplier `[-5]` | `N(-5)=25`; the carrier formula remains `75=3d delta_t-B.C_t` | compatible; no identification with selfmap degree `5` |

The classification packet does not assign any further exact degree to its
constructed tangent-residual selfmap.  Therefore the norm sieve is a
conditional CLEAN-branch sieve, not an unconditional exclusion of all
selfmaps whose degree is not represented.  The exact script
`verify_norm_sieve.py` checks the norm form, the examples, powers, and every
numeric datum actually recorded in the classification packet.
