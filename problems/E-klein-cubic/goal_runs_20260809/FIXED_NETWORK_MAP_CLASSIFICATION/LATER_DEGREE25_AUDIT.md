# Audit of the later degree-25 boundary packet

## Repository relation

This fixed-network packet was begun from commit
`091d4f5d4314c556da96d1804c49be13f48a78c8`. During the audit, `main`
advanced to commit `ee0a9011c4deb304424be3578e5aef7e9818d346`, adding

`goal_runs_20260809/DEGREE25_MARKED_ELLIPTIC_EXTENSION/`.

That packet directly tests the distinguished reduced-network member

\[
\Phi_{-5,1}|_{E_t}=[-5],
\qquad
\Phi_{-5,1}|_{L_t}=\operatorname{id}.
\]

Its accepted conclusions sharpen, but do not supersede, the fixed-network
boundary below.

## 1. Accepted positive result: the reduced-network map is genuine

Let `D` be the reduced union of the 55 elliptics and 55 fixed lines. The
later packet proves that `[-5]` is independent of the permitted marked-origin
choice, commutes with the corrected residual `S_3`, is transported by `G`, and
fixes every type-I and type-II point. The identity maps fix the marked points
on the lines.

At either a type-I or type-II point, formal `V_4` linearization identifies the
three incident branches with the three coordinate axes, so

\[
\widehat{\mathcal O}_{D,x}
\simeq
k[[u,v,w]]/(uv,uw,vw).
\]

A triple of branch morphisms to a separated target glues exactly when the
three values at the closed point agree. Hence the component maps glue
scheme-theoretically to a genuine `G`-morphism

\[
\Phi_{-5,1}:D\longrightarrow X.
\]

This independently confirms the `n=-5,m=1` member of the infinite family
constructed in this packet.

## 2. Literal homogeneous extension is impossible

For the plane polarization `L=O_{E_t}(1)`, symmetry and the theorem of the
cube give

\[
[-5]^*L\simeq L^{25}.
\]

Suppose a homogeneous degree-`d` tuple were defined at every point of `D` and
projectivized to `Phi_{-5,1}`. Its scalar multiplier would be a nowhere-zero
section of

\[
O_D(d)\otimes\Phi_{-5,1}^*O_X(-1).
\]

On an elliptic component this line bundle has degree `3(d-25)`, while on a
line component it has degree `d-1`. A nowhere-zero section on a complete
integral curve trivializes the line bundle. Thus the elliptics force `d=25`
and the identity lines force `d=1`. No degree works.

This is an obstruction only to an everywhere-defined order-zero polynomial
realization on the original reduced network. Base points on the original
lines can still be resolved, and the base-corrected formula in
`POLARIZATION_DEGREE.md` remains the correct formula for a resolved carrier.

## 3. Stronger order-zero landing obstruction on every original elliptic

Let

\[
p\in(\operatorname{Sym}^dW^*\otimes W)^G,
\qquad F(p)=0.
\]

For an involution `t`, equivariance sends the plus-space `W_+(t)` into itself.
If `p|_{W_+(t)}` were nonzero, projectivization would give a rational map

\[
P(W_+(t))=P^2\dashrightarrow E_t.
\]

Every rational map from `P^2` to an elliptic curve is constant. Residual
normalizer equivariance would then require its value to be fixed by the
residual order-three translation, which is free. Therefore

\[
\boxed{p|_{W_+(t)}=0\quad\text{for every involution }t.}
\]

In particular, no landing covariant in any degree has the nonzero ordinary
restriction `[-5]:E_t->E_t`. Multiplication by an invariant scalar or
primitive reduction does not remove this obstruction.

## 4. Correct interpretation of the proposed survivor

The later packet rules out the statement

```text
Phi_{-5,1} is the order-zero restriction of a degree-25 landing tuple
on the original fixed curves.
```

It does **not** rule out a resolved profile in which:

- the original plus-plane and `E_t` are base strata;
- an exceptional horizontal elliptic carrier born after principalization
  maps to `E_t` by `[-5]`;
- the strict transform or a replacement carrier above `L_t` maps by the
  identity after line base points are resolved.

The existing `(m,d)=(1,25)` transition tower starts with zero ordinary
plus-plane restriction and studies first normal jets. It therefore cannot be
identified with the order-zero boundary morphism merely because both contain
the number 25.

## 5. Consequence for the classification project

The candidate `([-5],id)` is now in a sharper position:

1. it is a genuine and intrinsically defined morphism of the reduced fixed
   network;
2. it is not isolated among reduced-network maps;
3. its naive degree-25 order-zero ambient extension is impossible;
4. any ambient occurrence must be reconstructed on exceptional carriers from
   the actual normalized Rees algebra and normal jets.

Thus the smallest missing theorem is not an extension theorem for the strict
boundary map. It is an **exceptional-carrier integration and rigidity theorem**
which identifies the horizontal carriers selected by an actual landing base
ideal, integrates their normal data to genuine component maps, computes their
base corrections, and couples them over all 55 `V_4` configurations.

The honest exit remains

```text
FIXED-NETWORK-CLASSIFICATION-UNDECIDED
```
