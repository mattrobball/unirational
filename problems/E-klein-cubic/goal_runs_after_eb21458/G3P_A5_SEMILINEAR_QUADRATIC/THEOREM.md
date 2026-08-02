# Corrected A5 semilinear materialization in the G3 frame

**Pinned main:** `eb21458bea684d2399ad18f003e2be8ebdd161ce`  
**Problem E:** **OPEN**  
**Current authorized G3P exit:** `G3P-UNDECIDED`

Scoped results proved here:

```text
G3P-A5-SEMILINEAR-MATERIALIZATION-PASS
G3P-A5-CANONICAL-POLAR-MISS
G3P-A5-CLASSIFYING-DEGREE-LE4-POLAR-EMPTY
```

## 1. The missing coordinate problem

Let `H` be either nonconjugate maximal `A5` subgroup of
`G=PSL(2,11)`, and let

\[
L_H=T\times^G(G/H)
\]

be the degree-eleven étale algebra attached to the generic `G`-torsor. The
sealed H-A5 packet supplies an H-equivariant degree-eleven landing covariant

\[
\Psi_H:V_3\dashrightarrow W,\qquad F(\Psi_H(y))=0,
\]

but an ordered tuple of constant split-model vectors is not an `L_H`-point.
The missing datum is an H-equivariant classifying map from the restricted
generic torsor to the installed three-dimensional A5 source.

## 2. Canonical cubic classifying map

For the five-dimensional A5 representation `W|_H`, exact character theory
gives

\[
\dim\operatorname{Hom}_H(\operatorname{Sym}^3W,V_3)=1,
\]

for either three-dimensional A5 constituent. The corresponding dimensions in
degrees four and five are respectively two and five.

Let

\[
Y_H:W\longrightarrow V_3
\]

be the unique degree-three covariant up to scalar. It is reconstructed by the
Reynolds operator from the seed recorded in `certificate.json`; the independent
verifier instead solves the full generator-equivariance linear system.

At the accepted good prime `p=89`, `Y_H` has Jacobian rank three at an explicit
point for each A5 class. Hence the characteristic-zero affine map is dominant,
and the projective map

\[
\mathbf P(W)\dashrightarrow\mathbf P(V_3)
\]

is dominant. The same witnesses map to `[1:2:3]`, the installed H-A5 good
source point. Therefore the H-A5 frame denominators and its nonzero landing
covariant remain nonzero after pullback on a nonempty open.

## 3. Genuine semilinear point in normalized G3 coordinates

Let

\[
B_{\rm poly}(w)=[x(w),C(w),D(w),E(w),K_7(w)]
\]

and let `tau=f3^2/f5`. The normalized G3 frame is

\[
B_{\rm G3}(w)=B_{\rm poly}(w)
\operatorname{diag}(\tau^{-1},\tau^{-4},\tau^{-5},\tau^{-6},\tau^{-7}).
\]

Define

\[
p_H(w)=\Psi_H(Y_H(w))
\]

and

\[
a_H(w)=B_{\rm G3}(w)^{-1}p_H(w).
\]

Equivalently, as an executable circuit,

\[
a_H(w)=
\operatorname{diag}(\tau,\tau^4,\tau^5,\tau^6,\tau^7)
B_{\rm poly}(w)^{-1}J_H\Phi_H(Y_H(w)).
\]

This is the requested normalized G3 five-tuple over `L_H`. It is not an
ordered constant-field orbit:

- `Y_H(hw)=sigma_H(h)Y_H(w)`;
- `Psi_H(sigma_H(h)y)=rho(h)Psi_H(y)`;
- `B_G3(hw)=rho(h)B_G3(w)`.

Thus `a_H(hw)=a_H(w)`, so its coordinates lie in `L_H`. Source scaling sends
`Y_H` to `lambda^3 Y_H` and `p_H` to `lambda^33 p_H`; the G3 frame has degree
zero, so the projective point `[a_H]` is well defined. Finally,

\[
\Phi(a_H)=F(p_H)=0
\]

by the exact H-A5 landing identity and the G3A frame identity.

This closes the coordinate-materialization gate left open by the earlier G3P
packet.

## 4. Transport of the canonical polars

For `q=(1:0:0:0:0)` in normalized G3 coordinates,
`B_G3(w)q=w/tau`. Therefore

\[
B_\Phi(q,q,a_H)=\tau^{-2}B_F(w,w,p_H),
\]

and

\[
B_\Phi(q,a_H,a_H)=\tau^{-1}B_F(w,p_H,p_H).
\]

The producer reconstructs the actual H-A5 degree-eleven point in the accepted
`F_89` fibre and evaluates these numerators at dominant classifying-map
witnesses. For the two A5 classes the pairs

```text
(second polar, first polar) = (11,78), (11,34) mod 89.
```

Both are nonzero, while `F(p_H)=0`. Since all data have accepted good
reduction at 89, the two characteristic-zero polar numerators are nonzero
rational functions. Consequently neither canonical pulled-back A5 point lies
generically on `H_q` or `Q_q`.

This is an exact nonidentity theorem, not a failure to find a sample.

## 5. Exhaustion through classifying degree four

For each A5 class:

```text
dim Hom_H(Sym^3 W,V3) = 1
dim Hom_H(Sym^4 W,V3) = 2
dim Hom_H(Sym^5 W,V3) = 5
```

The degree-three map is the canonical map above and misses both polars.
For the complete projective degree-four family, write `Y=Y0+z Y1`. Twelve
independent evaluations produce univariate necessary equations for each polar.
Over `F_89`, the gcd of the second-polar equations is `1`, and the gcd of the
first-polar equations is `1`, separately for both A5 classes.

Because the map parameter is projective and the fibre is a good integral
specialization, a characteristic-zero degree-four classifying map satisfying
either polar identity would specialize to a common projective zero. The gcd
certificate excludes it. Thus no constant-coefficient H-equivariant
classifying map of degree at most four sends the installed A5 point identically
into either canonical polar.

This statement does not exclude rational classifying maps with invariant
coefficients, nor the five-dimensional degree-five family.

## 6. Consequences for odd-degree descent

The degree-eleven point is now genuinely available in the G3 frame, but it does
**not** supply the quadratic point required by the attempted direct Springer
step. In particular:

```text
odd-degree point on X  !=>  K-point on X,
point on Q_q alone     !=>  K-point on X without an inverse map.
```

A valid next step must construct a `K_proj`-defined quadratic object together
with an explicit rational map back to the resolved tangent incidence `I_q` or
directly to `X_gen`. The current result does not authorize Springer on the
cubic and does not authorize a headline exit.

## 7. Correction to the split-cycle packet

The latest G7B packet uses the representative-dependent assignment
`gH -> [rho(g)e0]`. The corrected materialization above replaces it. The
abstract degree-eleven H-induced point and the Paley-biplane incidence module
remain usable; the claimed constant split-model eleven-point cycles do not.
No result in this packet consumes `G7-INDUCED-DOUBLE-CYCLE-PASS`.

## 8. CAS statement

No external CAS is needed for this packet. The replay uses Python, SymPy,
exact finite-field linear algebra, Reynolds operators, and gcds of univariate
polynomials.

The next degree-five/quadratic-interface stage does require local CAS; its
binding order is `CAS_NEXT_ORDER.md`.
