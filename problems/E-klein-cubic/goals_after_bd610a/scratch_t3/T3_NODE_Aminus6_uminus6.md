# Exact characteristic-zero node witness at `(A,u)=(-6,-6)`

## Scope

This packet is an exact characteristic-zero specialization for the singular
locus of the **fold algebra**

\[
S_G=\bigl(\mathbf Q[A,B,Y,Z,u]/(P,P_u)\bigr)
[(\ell P_{uu}C\delta G)^{-1}].
\]

It is not a normalization of the raw degree-43 branch and it does not, by
itself, prove that the sampled degree-six field is the exhaustive generic
singular/conductor component.  The specialization-to-generic gates are listed
below.

## Exact finite field

Specialize `A=u=-6`, form

\[
I=(P,P_u,P_A,P_B,P_Y,P_Z),
\]

and saturate successively by `B`, `ell`, `Q4`, `Puu`, `C`, and `delta`, exactly
as in the accepted T11 specialized-fibre computation.  Macaulay2 returns a
zero-dimensional algebra of degree six with triangular lexicographic basis.
Its primitive eliminant is

\[
\begin{aligned}
W(Z)={}&7496192000Z^6-52290461509632Z^5
+11255510823558912Z^4\\
&-390879388669351936Z^3+9952790175318655728Z^2\\
&-695267365283514324504Z+8639408520488202974741.
\end{aligned}
\]

Exact factorization returns `W` itself with exponent one, so

\[
L=\mathbf Q[Z]/(W)
\]

is a degree-six field.  The two other lex generators express `Y` and `B`
linearly in `Z`; they are printed in the replay output.

## Bordered Hessian and chart unit

The specialized display routines primitive-normalize `P` and `P_u`
separately.  The script restores the consistent accepted primitive scalings

```text
P_original  = 531441 * P_display
Pu_original = 3188646 * Pu_display.
```

Let `H` be the `3 x 3` Hessian of `P_original` in `(B,Y,Z)`, and let

\[
v=(P_{uB},P_{uY},P_{uZ}).
\]

The transverse node discriminant is represented, up to a square unit, by the
bordered Hessian

\[
D_{\rm node}=\det\begin{pmatrix}H&v^{\mathsf T}\\v&0\end{pmatrix}.
\]

In the exact field `L`:

- `gcd(W, rem(D_node)) = 1`;
- `gcd(W, rem(det(H))) = 1`.

Thus the bordered Hessian and the `(B,Y,Z)` chart determinant are units at all
six conjugate singular points of this specialization.

The M2 line labelled `NORM` is the resultant.  Since `W` is not monic, the
actual field norm is

\[
N_{L/\mathbf Q}(D_{\rm node})
=\frac{\operatorname{Res}_Z(W,\operatorname{rem}D_{\rm node})}
       {\operatorname{lc}(W)^5}.
\]

Its denominator is a rational square and its numerator has square-free part

\[
\boxed{
1225218781398035017274311805993749028078559822648842787814154826112957440765
}.
\]

Equivalently, PARI factors the square class as

```text
3 * 5 * 97 * 48677
  * 17299232981643214398331208816116349650636386168377365260944167921879.
```

Therefore the norm, and hence `D_node` itself in `L`, is not a square.

## Local normalization consequence

The two unit tests give a transverse ordinary double point.  Over the residue
field `L`, the completed one-dimensional transverse slice has the form

\[
L[[x,y]]/(a x^2+bxy+c y^2),
\qquad b^2-4ac\equiv D_{\rm node}\pmod{L^{\times2}}.
\]

The discriminant is nonsquare, so the node is nonsplit.  Its normalization is

\[
L(\sqrt{D_{\rm node}})[[t]],
\]

the normalization residue degree is `2`, and the conductor is the maximal
ideal `(x,y)` with exponent `1`.  This is the standard one-step
Grauert--Remmert correction for a nonsplit node.

## What must still be proved before promoting this to the generic T3 model

1. Construct and directly verify the finite degree-six algebra over
   `Q(A,u)` for the full gate-saturated singular ideal; interpolation alone is
   not an algebra certificate.
2. Prove that algebra is a field/domain (or decompose it) and that its
   specialization at `(-6,-6)` is flat and is the field `L` above.
3. Verify the generic `(B,Y,Z)` chart determinant and all required gate norms.
   The exact unit values here then put the specialization in the regular
   chart.
4. For nonsquareness descent, work in that regular integral model with
   `D_node` a unit.  A square in the generic field would then specialize to a
   square in `L`, contradicting the exact norm computation above.
5. Prove that this component is exhaustive among dominant singular/conductor
   components.  Only then does the local model determine every height-one
   normalization correction of `S_G`.
6. Globalize the local quadratic generator and verify the resulting finite
   algebra is normal away from the conductor.  This packet determines the
   generic local conductor type; it is not yet a global finite presentation.

## Replay

From `goals_after_bd610a`:

```bash
M2 --script scratch_t3/t3_node_Aminus6_uminus6.m2 \
  > scratch_t3/t3_node_Aminus6_uminus6.out
/opt/homebrew/bin/python3 \
  scratch_t3/verify_t3_node_Aminus6_uminus6.py
```

The independent verifier reconstructs quotient arithmetic directly from the
accepted primitive TSV and the triangular lex basis.  It checks that all six
defining critical equations vanish, recomputes the bordered-Hessian remainder,
computes its multiplication-matrix norm, and verifies the displayed square
class as an integer-square identity.

