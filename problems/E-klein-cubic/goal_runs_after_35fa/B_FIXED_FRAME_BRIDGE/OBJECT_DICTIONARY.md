# Exact object dictionary

Throughout, `k=C` and `G=PSL(2,F_11)`.  Put

```text
K = K_proj = C(P(W))^G,
F = C(A,B,Y,Z) subset K,          [K:F]=6.
```

The extension is the ordered presentation

```text
K = Frac(F[u]/(P(A,B,Y,Z,u))),
```

where `P` is the exact primitive sextic and the chosen embedding is the class
of `u`.  This ordered presentation, not merely the abstract degree-six
algebra, is the one used below.

## 1. Genuine generic Klein twist

Let `T_proj -> Spec K` be the generic `G`-torsor obtained from the generically
free action on `P(W)`.  The genuine twist is the fppf contracted product

```text
X_gen = T_proj times^G X.
```

For a `K`-algebra `R`, an `R`-point is equivalently a `G`-equivariant
`R`-morphism `T_proj,R -> X_R`; after a faithfully flat splitting cover
`R'/R`, it is represented by `x in X(R')` satisfying the torsor cocycle
descent condition.  It is not in general the naive quotient of two sets of
`R`-points.  If `H` is a cocycle-compatible Hilbert--90 frame trivializing
the twisted five-space over a splitting algebra, its equation there is exactly

```text
F_Klein(H^(-1)*x)=0,
F_Klein=x0^2*x1+x1^2*x2+x2^2*x3+x3^2*x4+x4^2*x0.
```

The descended coefficients are fixed by the cocycle.  A split-field change
of `H` counts as a `K`-rational gauge only when it is cocycle-compatible and
descends.  No expanded full-group frame `H` over the executable ordered
`K/F` presentation is installed in the accepted inputs; the contracted
product above is the exact intrinsic functor.  A `K`-point of this object is
the point required by the accepted versal-compression criterion.

## 2. Genuine twisted Fano section

Let `A_proj` be the descended degree-six central simple algebra with
symplectic involution `sigma`.  Accepted exact structure gives

```text
A_proj = M_3(D)
```

for a quaternion division algebra `D/K`, after choosing a Morita frame.  The
distinguished descended Klein five-plane is

```text
H_T = <h1,...,h5>_K subset Herm_3(D).
```

The twisted degree-14 Fano section represents the functor

```text
F14_T(R) = {
  locally direct-summand right D_R-submodules L subset D_R^3
  of D_R-rank one : hi restricted to L times L is zero for i=1,...,5
}.
```

Fppf-locally such an `L` is generated as `q*D_R`.  On the standard affine
chart `q=(1,x,y)`, this is five scalar equations in the eight scalar
coordinates of `(x,y) in D^2`.  Equivalently it is the twisted
`Gr(2,6) cap P(B_10)` section.  The accepted packet does not install explicit
quaternion matrices for the five `h_i`; these equations are the exact
intrinsic functor, and the missing executable matrices are part of the live
C0 gate.  A common line gives a line on `X_gen`, hence
a `K`-point of `X_gen`.  The converse is not asserted.

## 3. Full auxiliary characteristic cubic

Put

```text
Sym = Sym(A_proj,sigma),          dim_K Sym=15.
```

For `a in Sym`, let

```text
p_a(T)=T^3-c1(a)*T^2+c2(a)*T-c3(a)
```

be the Pfaffian characteristic polynomial.  The full affine cone, full
projective characteristic cubic, and functional-calculus open are distinct:

```text
Z_aux_aff = {a in Sym : c3(a)=0},
Z_aux = {[a] in P(Sym) : c3(a)=0},
P_aux_aff = Z_aux_aff cap {c2(a)!=0},
P_aux = Z_aux cap D(c2) = P_aux_aff/G_m.
```

Functional calculus gives the line projector

```text
p(a)=(a^2-c1(a)*a+c2(a)*1)/c2(a),
```

a `sigma`-self-adjoint idempotent with split-matrix rank two.  Under Morita,
this is
the orthogonal projector onto a right `D`-line nondegenerate for the
structure Hermitian form.  The formula is invariant under nonzero scalar
rescaling, so `P_aux` maps to the open structure-projector space

```text
I_sigma subset P^2_D.
```

Exact Gram--Schmidt/Morita theory proves `I_sigma(K)`, `P_aux_aff(K)`, and
`P_aux(K)` are nonempty.  Conversely, if `p` is a line projector, then
`a=1-p` has
Pfaffian polynomial `T*(T-1)^2`, lies in `P_aux`, and functional calculus
returns `p`.  (Writing `a=p` would give `c2(a)=0` and is not a section.)
This rank convention and the simple-zero projector calculation are checked
against the primary `pfaffian_rank2_idempotent_attack/PROOF_AUDIT.md`; they
correct an inconsistent rank sentence in the later narrative dictionary.
These spaces are auxiliary: the five equations defining `F14_T` are not part
of `c3=0,c2!=0`.

## 4. Selected fixed ternary frame

Choose the certified three-dimensional coordinate frame

```text
a = X*S0 + y*S1 + w*S2  in Sym.
```

Restriction of `c3(a)=0` gives the plane cubic

```text
C/F:
F0 + A*FA + B*FB + Y*FY + (Z-11*A^2/18)*FZ = 0
```

in `[X:y:w]`.  Thus `C_K -> Z_aux` is the full projective linear slice.
The projector open is the restriction of `c2!=0`; after base change to `K`
it gives the locally closed slice

```text
C_K^open -> P_aux -> I_sigma.
```

Goal F proves the stronger statement `C(K)=empty`.  This is a theorem about
the selected slice, not about the full auxiliary cubic, the Fano section, or
the generic Klein twist.

## 5. Gauge groups and the missing parameter

The full Morita change-of-basis group `GL_3(D)` changes both a right line and
the five-plane `H_T`.  It cannot be used while holding the distinguished
Klein data fixed.  The relevant group for exhaustiveness is

```text
Gamma = PGU(h_struct) cap Stab_{PGL_3(D)}(H_T),
```

not the full Morita group.  Here `PGU(h_struct)` preserves the involution and
the second factor preserves the distinguished five-plane as a subspace.  No
accepted theorem makes `Gamma` move every `K`-rational common isotropic line
into the selected ternary frame.  A
transformation available only after a splitting extension is not a
`K`-rational gauge.  Conversely, the absence of such an accepted theorem is
not a proof that a `K`-rational `F14_T` orbit is missed: `F14_T(K)` itself is
still unknown.

The missing moduli are therefore the right-`D`-line coordinates outside the
fixed ternary slice, together with the requirement that all five equations
`hi(q,q)=0` be preserved simultaneously.

## 6. Quotient and gauge ledger

| Object/presentation | Quotient or choice | What descends over `K` |
|---|---|---|
| `X_gen=(T_proj x X)/G` | diagonal finite-group quotient by `G` | the contracted product; a Hilbert--90 matrix over a splitting algebra is only a coordinate frame |
| `F14_T` in quaternion coordinates | nonzero `q in D^3` modulo right multiplication by `D^x` | the right line `qD` and the five simultaneous equations |
| Morita presentation `A=M_3(D)` | change of Morita basis by `GL_3(D)` | the pair consisting of the right-line space and the transported five-plane `H_T`; changing only the line is not allowed |
| distinguished Klein incidence | action of `Gamma=PGU(h_struct) cap Stab(H_T)` | only a `K`-point of this intersection supplies a rational gauge preserving the involution and all five forms |
| `Z_aux_aff -> Z_aux` | projectivization of the full characteristic cubic away from the cone vertex | the cubic itself, with no `c2` condition |
| `P_aux_aff -> P_aux` | restrict to `c2!=0`, then quotient by nonzero scalar rescaling; further spectral fibers remain after projectivizing | the scale-invariant projector map, not a canonical inverse for a general `a` |
| `C` | `[X:y:w]` is modulo `G_m` | the selected projective ternary slice |
| ordered sextic presentation | choosing the class of `u`; abstract conjugation of the six roots is not discarded | the specified embedding `F -> K`, Cramer reconstruction, and ordered residue root |

In particular, geometric transitivity after splitting `D`, a dimension count,
or an abstract isomorphism of degree-six fields does not produce any of the
required rational gauges.
