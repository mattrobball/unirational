# Exact twist model over `C(u,v)`

## Constant decomposition

Over `Q(t)/(Phi_33(t))`, put `zeta_11=t^3` and `omega=t^11`.  The exact
constant matrix `D` serialized in `exact_degree3_map.json` realizes

\[
 W|_{A_4}=1'\oplus1''\oplus3.
\]

In decomposition coordinates `(U,V,r1,r2,r3)`, the Klein cubic is exactly

\[
\begin{aligned}
F_D={}&aU^3+bV^3
 +cU(r_1^2+\omega^2r_2^2+\omega r_3^2)\\
&+dV(r_1^2+\omega r_2^2+\omega^2r_3^2)
 +e r_1r_2r_3,
\end{aligned}
\]

where `a,b,c,d,e` are five nonzero exact constants.  Their 20-term power-basis
vectors are serialized in `exact_degree3_map.json`; the verifier reconstructs
`F(Dw)` and checks all nine nonzero monomials and the Fourier coefficient
ratios.

## Adapted Hilbert--90 frame

Let

\[
Q(y)=\begin{pmatrix}
Sx/q & yz/S & x^3/q\\
Sy/q & zx/S & y^3/q\\
Sz/q & xy/S & z^3/q
\end{pmatrix}.
\]

Then `Q(r*y)=sigma_can(r)Q(y)` for both generators, and

\[
 \det Q=\Delta/q^2.
\]

The small frame in the original Klein coordinates is

\[
 B(y)=D\,\operatorname{diag}_{\rm blocks}(L/S,M/S,Q(y)).
\]

It satisfies `B(r*y)=rho(r)B(y)` and has determinant, up to the nonzero
constant `det D`,

\[
 \frac{LM\Delta}{S^2q^2}.
\]

Thus the canonical twisted equation is `F(B(y)Z)=0`.  If

\[
T(y)=A_{\rm inst}(Py)^{-1}B(y),
\]

then `T(r*y)=T(y)`.  Therefore `T` is defined over `K_A4`, and the identity

\[
 F(A_{\rm inst}(Py)T(y)Z)=F(B(y)Z)
\]

is the exact equivalence with the installed twist—not a specialization.

## Fully reduced equation

`reduce_twist_uv.py` expands `F(B(y)Z)`, applies Fourier inversion, and
reduces `m^3=v^3/u`.  The resulting 35 coefficients are recorded in
`twist_over_Cuv.json`; 22 are nonzero and every one lies in `C(u,v)`.
For example,

\[
[Z_0^3]=au,\qquad [Z_1^3]=b\,v^3/u,\qquad [Z_4^3]=e,
\]

and the common nontrivial denominator is

\[
D_0=u^2-3uv+u+v^3.
\]

This payload is the requested minimal exact equation over the explicit
transcendence basis.  The structured norm form above remains the more useful
human presentation.

