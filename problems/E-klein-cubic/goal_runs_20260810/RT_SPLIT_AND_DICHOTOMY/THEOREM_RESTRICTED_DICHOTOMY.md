# Restricted-graph dichotomy and the CM norm equation

## 1. Setup

Let

\[
\Gamma=\operatorname{Proj}_{X}\overline{\mathcal R(J)},
\qquad
\pi,q:\Gamma\longrightarrow X
\]

be the normalized graph of the primitive restricted ideal of a hypothetical ambient landing map. Thus `pi` is birational, `q` is generically finite, and

\[
\delta=\deg(q)>0.
\]

Put

\[
V=H^3(X,\mathbf Q)(1),
\qquad
K_\Gamma=R\pi_*IC_\Gamma^H.
\]

All projectors and correspondence identities below are in polarizable Hodge modules or the induced rational Hodge structures. No Chow-correspondence projector is asserted.

## 2. Strict support and the canonical middle-cohomology projector

Because `pi` is birational and `X` is smooth, strict-support decomposition gives

\[
{}^pH^j(K_\Gamma)=
\begin{cases}
IC_X^H\oplus \mathcal Q_{0,\mathrm{prop}},&j=0,\\
\mathcal Q_{j,\mathrm{prop}},&j\ne0,
\end{cases}
\tag{2.1}
\]

where every simple constituent of every `Q_{j,prop}` has proper support and the full-support constituent `IC_X^H=Q_X^H[3]` occurs with multiplicity one. Equation (2.1) is canonical inside each semisimple perverse cohomology object. We do **not** claim a canonical splitting of the entire derived object `K_Gamma`.

The birational map supplies canonical pullback and trace maps on middle intersection cohomology,

\[
\pi^*:V\hookrightarrow IH^3(\Gamma,\mathbf Q)(1),
\qquad
\pi_*:IH^3(\Gamma,\mathbf Q)(1)\longrightarrow V,
\tag{2.2}
\]

normalized by

\[
\pi_*\pi^*=\operatorname{id}_V.
\tag{2.3}
\]

The trace is the polarized adjoint of pullback. Hence

\[
e_0=\pi^*\pi_*,
\qquad
e_{\mathrm{exc}}=1-e_0
\tag{2.4}
\]

are canonical self-adjoint idempotents on `IH^3(Gamma)(1)`, and

\[
IH^3(\Gamma)(1)=\pi^*V\ \widehat\oplus\ E_\Gamma,
\qquad
E_\Gamma=\ker(\pi_*)=(\pi^*V)^\perp.
\tag{2.5}
\]

By (2.1) and the decomposition theorem, every constituent of `E_Gamma` is contributed by proper strict supports. This assertion is independent of a choice of derived decomposition; a relatively ample splitting may be used only to display those proper-support constituents.

## 3. The dichotomy

The generically finite map `q` has canonical diagonal pullback and trace on the middle summand,

\[
q^*:V\hookrightarrow IH^3(\Gamma,\mathbf Q)(1),
\qquad
q_*:IH^3(\Gamma,\mathbf Q)(1)\longrightarrow V,
\]

with

\[
q_*q^*=\delta\,\operatorname{id}_V.
\tag{3.1}
\]

On the finite-etale locus this is the diagonal inclusion and trace in the degree-`delta` local system; middle extension gives the canonical actual class of PR #15, Theorem D.

Define

\[
r=e_{\mathrm{exc}}q^*:V\longrightarrow E_\Gamma,
\qquad
u_\varphi=\pi_*q^*:V\longrightarrow V.
\tag{3.2}
\]

Exactly one of the following occurs.

### CARRIER branch

If `r` is nonzero, then `r` is injective because its kernel is a rational `G`-submodule of the irreducible module `V`. Filter `E_Gamma` by the perverse filtration. At the first degree `j_Gamma` in which the image of `r` is nonzero, the map to the associated graded is injective. Choose a proper strict support `T` whose `G`-orbit receives a nonzero projection, let

\[
\mathcal N_{T,j_\Gamma}\subset\mathcal Q_{j_\Gamma,\mathrm{prop}}
\]

be the maximal strict-support block on `T`, and put `H=Stab_G(T)`. Then

\[
\boxed{
\operatorname{Hom}_{\mathrm{HS},H}
\left(
\operatorname{Res}_H V,
H^{-j_\Gamma}(X,\mathcal N_{T,j_\Gamma})(1)
\right)\ne0.
}
\tag{3.3}
\]

Moreover

\[
T\subset\operatorname{Bs}(J),
\qquad
\dim T\le1.
\tag{3.4}
\]

Indeed, `pi` is an isomorphism off the primitive restricted base locus, and primitive reduction removes every divisorial common factor on the smooth threefold `X`. Equation (3.3) is the intrinsic restricted analogue of (AHS). It allows local systems, point support, and nonsemismall perverse degrees.

### CLEAN branch

If `r=0`, then

\[
q^*=\pi^*u_\varphi
\quad\text{on }V.
\tag{3.5}
\]

Taking polarized adjoints gives the exact correction identity

\[
\boxed{
u_\varphi^\dagger u_\varphi+r^\dagger r
=\delta\,\operatorname{id}_V.
}
\tag{3.6}
\]

Indeed,

\[
u_\varphi^\dagger u_\varphi
=q_*\pi^*\pi_*q^*,
\qquad
r^\dagger r=q_*(1-\pi^*\pi_*)q^*,
\tag{3.7}
\]

and their sum is `q_*q^*`. In the CLEAN branch the exceptional correction vanishes, so

\[
\boxed{
u_\varphi^\dagger u_\varphi=[\delta]
\quad\text{on }V.
}
\tag{3.8}
\]

This is conditional on CLEAN; it is not the false universal selfmap identity rejected in the prior packet.

## 4. The rational and integral commutants

The complexification of the rational Klein Hodge representation is

\[
V_{\mathbf C}\simeq W_5\oplus\overline W_5,
\]

and the two absolutely irreducible halves have character field

\[
K=\mathbf Q(\sqrt{-11}).
\]

Schur's lemma together with the accepted Auto-CM input gives

\[
\operatorname{End}_{G\text{-}\mathrm{HS}}(V)=K.
\tag{4.1}
\]

Roulleau's period lattice is stable under

\[
\nu=\frac{-1+\sqrt{-11}}2.
\]

Since

\[
\mathbf Z[\nu]
=\mathbf Z\left[\frac{1+\sqrt{-11}}2\right]
=\mathcal O_K
\tag{4.2}
\]

is the maximal order, the integral scalar commutant is exactly `O_K`. Rosati restricts to complex conjugation. Therefore in the CLEAN branch

\[
u_\varphi=[\alpha],
\qquad
\alpha\in\mathcal O_K,
\qquad
\delta=\alpha\bar\alpha.
\tag{4.3}
\]

Writing

\[
\omega=\frac{1+\sqrt{-11}}2,
\qquad
\alpha=x+y\omega,
\qquad x,y\in\mathbf Z,
\]

gives

\[
\boxed{
\delta=N_{K/\mathbf Q}(\alpha)=x^2+xy+3y^2.
}
\tag{4.4}
\]

The field has discriminant `-11` and class number one. The imaginary-quadratic Minkowski bound is `(2/pi)sqrt(11)<2.12`; two is inert because `t^2-t+3` is irreducible modulo two, so no nonprincipal ideal class can survive the bound. Equivalently, a positive integer is represented by (4.4) exactly when every inert prime occurs to even exponent.

## 5. Mandatory consistency audit

| degree/bookkeeping entry | norm-form result | consistency verdict |
|---|---|---|
| `1`, identity | `1=N(1)` | CLEAN allowed |
| `2` | not represented | CLEAN impossible; independently excluded |
| `3` | `3=N(omega-1)=N(nu)` | audited degree-three branch passes |
| `5` | `5=N(1+omega)` | CLEAN allowed by the sieve |
| unknown `delta>=3` | conditional | represented degrees may be CLEAN; nonrepresented degrees are forced CARRIER |
| iterates `delta^m` | conditional | a CLEAN scalar iterates to `alpha^m`; no claim is made for a CARRIER map |
| elliptic `[-5]` line | `N(5)=25` | compatible, but this local degree is not identified with global `delta` |

The final row respects the existing carrier identity

\[
75=3d\delta_t-B\cdot C_t.
\]

It does not replace that identity by `d=25`. The exact verifier `verify_norm_sieve.py` finds no mismatch with any degree statement in `FULL_G_SELFMAP_CLASSIFICATION`.

## Exit

```text
RESTRICTED-DICHOTOMY-PROVED
RESTRICTED-CARRIER-BRANCH-PROVED
RESTRICTED-CLEAN-CM-NORM-PROVED
```
