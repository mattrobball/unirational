# Exact `K_A4`-point certificate

## The map

Let `C0,C1,C2,C3` be the exact degree-three five-component polynomial maps
serialized in `exact_degree3_map.json`.  They are linearly independent and,
for `chi(g)=1`, `chi(h)=omega^2`, satisfy the directly checked identities

\[
 C_i(r y)=\chi(r)\rho(r)C_i(y)
 \quad(r=g,h).
\]

Let `I` be the ten exact coefficient equations obtained from

\[
F(C_0+p_1C_1+p_2C_2+p_3C_3)=0
\]

on the projective parameter chart `p0=1`.  Singular computes a Groebner basis
for `I` over `Q(t)/(Phi_33(t))`.  Its transcript begins with `PROPER`, so
`I` is not the unit ideal.  Since `C` is algebraically closed, choose a
complex zero `p=(p1,p2,p3)` of this explicit ideal and set

\[
 \Phi_p=C_0+p_1C_1+p_2C_2+p_3C_3.
\]

This is an exact algebraic specification of the constants.  The chart
condition makes `Phi_p` nonzero because the four `Ci` are linearly
independent.  By construction,

\[
F(\Phi_p)=0,\qquad
\Phi_p(r y)=\chi(r)\rho(r)\Phi_p(y).
\]

## Coordinates in the installed twist

With the notation of `FIELD_MODEL.md`, define

\[
 Z_K(y)=\frac{M}{S\,xyz}\,
 A_{\rm inst}(P y)^{-1}\Phi_p(y).
\]

This is the promised exact coordinate vector.  It is homogeneous of degree
zero.  Moreover, `S` and `xyz` are invariant, `M(hy)=omega*M(y)`, and
`chi(h)=omega^2`; the two characters cancel.  The Hilbert--90 covariance of
the installed frame then gives

\[
 Z_K(r y)=Z_K(y)
\]

for both generators.  Hence every coordinate belongs to
`K_A4=C(u,v)`.  The vector is nonzero in the function field because
`Phi_p` is nonzero and the frame is invertible.

Exact substitution is immediate and is also replayed coefficientwise:

\[
 F(A_{\rm inst}(Py)Z_K(y))
 =\left(\frac{M}{Sxyz}\right)^3F(\Phi_p(y))=0.
\]

The denominator open is

\[
 Sxyz\left(\prod_{r\in A_4}d_r(y)\right)
 \det A_{\rm inst}(Py)\ne0.
\]

`canonical_model.json` lists every `d_r`; all are nonzero linear forms,
`Sxyz` is visibly nonzero, and the installed determinant is a nonzero rational
function by its exact good-reduction witness.  Thus every denominator is
accounted for.

## Logical conclusion

An `A4`-equivariant rational map from the generic tetrahedral torsor to the
Klein cubic is equivalent to a rational point on its generic twist.  The map
above therefore proves

`H-A4-RATIONAL-POINT`.

This closes only the `A4` subgroup obstruction.  It neither constructs a
`PSL_2(F_11)`-equivariant map nor decides the full-group generic twist.

