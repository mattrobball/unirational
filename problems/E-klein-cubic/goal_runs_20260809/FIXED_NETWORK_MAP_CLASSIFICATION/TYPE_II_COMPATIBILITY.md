# Type-II compatibility

## 1. Local geometry

Let `x` be a type-II point with stabilizer

\[
V_4=\{1,z,s,r\}.
\]

The three positive-dimensional fixed curves through `x` are the elliptics

\[
E_z,\qquad E_s,\qquad E_r.
\]

The three rational lines `L_z,L_s,L_r` do not pass through a type-II point. The exact tangent representation is

\[
T_xX=\chi_z\oplus\chi_s\oplus\chi_r,
\]

with the three elliptic tangent directions equal to the three character lines. The residual `C_3=N_G(V_4)/V_4` cycles the elliptics, tangent directions, and the three type-II points on the `V_4`-fixed ambient line.

## 2. Compatibility on the unbroken triple

Assume the original elliptic branches survive, their restrictions are nonconstant, and type-I compatibility has already forced

\[
u_t(P)=[n]P
\]

on every `E_t`. The integer `n` is common by `G`-conjugacy and satisfies `n=1 mod 3`.

A type-II point on `E_t` has the form

\[
e+iq,
\qquad 0\ne e\in E_t[2].
\]

Multiplication gives

\[
[n](e+iq)=(n\bmod2)e+iq.
\]

If `n` is odd, the point is fixed. If `n` is even, it is sent to the type-I orbit `<q>` on each elliptic. The three resulting type-I points belong to the three distinct vertices of the local `V_4` line triangle and are not a common point of `E_z,E_s,E_r`. Therefore the three branch restrictions cannot agree at the original common point when `n` is even.

Thus actual unbroken type-II gluing forces

\[
n\equiv1\pmod6.
\]

Conversely, every such multiplication fixes all type-II points pointwise, so it is compatible with every unbroken triple.

## 3. First blowup at a type-II point

Blow up `x`. Again

\[
D=P(T_xX)=P(\chi_z\oplus\chi_s\oplus\chi_r)\simeq P^2.
\]

The coordinate points are now the tangent directions of `E_z,E_s,E_r`.

For the involution `z`,

\[
D^z=P(\chi_z)\sqcup P(\chi_s\oplus\chi_r).
\]

The exceptional line `P(chi_s+chi_r)` connects the `E_s` and `E_r` directions and is pointwise `z`-fixed. Its image under the resolved morphism lies in

\[
X^z=E_z\sqcup L_z.
\]

Because `L_z` is rational, the exceptional line may map nonconstantly to `L_z`. Hence a connection from the `E_s` branch to the `E_r` branch can bypass the `E_z` direction entirely.

The corresponding bypasses exist for all three involutions.

## 4. Disconnected fixed loci

The total exceptional divisor is connected and rationally connected, but

\[
D^{V_4}=\{P(\chi_z),P(\chi_s),P(\chi_r)\}
\]

is disconnected, while each involution-fixed locus is a disjoint point plus line. Thus neither connectedness nor rational chain connectedness of the full fiber gives a connected object on which all three fixed-locus constraints propagate.

This is already a counterexample at the first blowup; no complicated resolution is needed.

## 5. Residual `C_3` and exceptional curves

The residual `C_3` cyclically permutes the coordinate axes. A horizontal exceptional curve can therefore be:

- a coordinate orbit;
- an invariant conic or higher-degree invariant plane curve;
- a curve created after subsequent invariant blowups.

For example,

\[
x_z^2+x_s^2+x_r^2=0
\]

is a smooth rational `V_4`-stable conic with faithful `V_4` action. It is not pointwise fixed by any nonidentity involution, so the Problem-F kernel lemma does not apply.

First-order character matching constrains the tangent directions of a map from such a curve. It does not determine whether the curve occurs in the normalized blowup of the actual base ideal or where it maps.

## 6. Why the formal type-II state is insufficient

A compatible triple of associated-graded normal maps specifies leading homogeneous forms in the three character directions. It does not specify:

- a component of the normalized Rees algebra;
- a horizontal curve in the exceptional `P^2`;
- integration of the three leading terms to a morphism on that curve;
- the base multiplicity of the carrier;
- exclusion of a line-valued bypass.

Therefore a formal state can be necessary for an ambient map without being an actual type-II component profile.

## 7. Conditional type-II theorem needed

A finite classification would follow locally from a theorem of the following form:

> For the principalization of any actual `G`-covariant base ideal, the normalized fiber over a type-II point has a canonical residual-`C_3`-stable horizontal curve meeting all three elliptic tangent directions; every involution-fixed connector on that curve maps to the corresponding elliptic component, not to the rational line component; and the curve is unique up to further equivariant blowup.

The explicit exceptional `P^2` shows that this is not a theorem of fixed-locus representation theory alone. It must use the equations and Rees algebra of the actual covariant.

## 8. Boundary

Type-II incidence gives the parity restriction `n` odd, and hence `n=1 mod 6`, only on the unbroken elliptic triple. It does not propagate through arbitrary resolved fibers. Excluding the three rational bypass lines is the second local component of the missing ambient base-carrier rigidity theorem.
