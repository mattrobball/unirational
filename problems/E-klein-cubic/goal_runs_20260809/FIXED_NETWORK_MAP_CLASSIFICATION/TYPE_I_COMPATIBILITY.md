# Type-I compatibility

## 1. Local geometry

Let `x` be a type-I point with stabilizer

\[
V_4=\{1,z,s,r\}.
\]

Exactly three positive-dimensional fixed curves pass through `x`:

- the elliptic `E_z`;
- the rational line `L_s`;
- the rational line `L_r`.

The third line `L_z` does not pass through `x`. The exact tangent representation is

\[
T_xX=\chi_z\oplus\chi_s\oplus\chi_r,
\]

where the tangent to `E_z` is the `chi_z` line, and the tangents to `L_s,L_r` are the other two character lines. The residual `C_3=N_G(V_4)/V_4` cycles the three vertices and character labels globally.

## 2. Compatibility when the original branches survive

Suppose the three original branches survive on the resolved model, the resolved morphism is regular at their common point, and all three restrictions are nonconstant.

A map from `P^1` to an elliptic curve is constant. Hence

\[
L_s\to L_s,
\qquad L_r\to L_r.
\]

The two target lines meet only at the same type-I point:

\[
L_s\cap L_r=\{x\}.
\]

Therefore both line maps fix `x`. The elliptic branch has the same image value. Since `x` is not on `L_z`, the elliptic branch cannot land in `L_z`; it lands in `E_z` and fixes `x`.

Doing this at all three type-I points of `E_z` gives, for

\[
u(P)=[n]P+a,
\]

that the type-I orbit `<q_z>` is preserved pointwise. Hence

\[
a=0,
\qquad n\equiv1\pmod3.
\]

Thus actual unbroken type-I gluing is stronger than a formal endpoint label: it eliminates every nonzero two-torsion translation.

## 3. First blowup at the type-I point

Blow up `x`. The exceptional divisor is

\[
D=P(T_xX)
=P(\chi_z\oplus\chi_s\oplus\chi_r)
\simeq P^2.
\]

Its three coordinate points are the tangent directions of `E_z,L_s,L_r`.

For the involution `z`,

\[
D^z=P(\chi_z)\sqcup P(\chi_s\oplus\chi_r).
\]

The second component is a projective line joining the `L_s` and `L_r` tangent directions. It is pointwise `z`-fixed because `z` acts by the same scalar on `chi_s` and `chi_r`.

Since

\[
X^z=E_z\sqcup L_z
\]

and `L_z` is rational, this exceptional line can map nonconstantly to `L_z`. It can connect the two line directions without passing through the elliptic direction. This is the **type-I bypass**.

The corresponding bypasses exist cyclically for `s` and `r`.

## 4. Character compatibility at the exceptional divisor

The differential of the resolved morphism is `V_4`-equivariant. A nonzero first derivative can therefore send a character line only to the same target character. This constrains first-order contact, but it does not determine:

- whether the map on an involution-fixed exceptional line is constant;
- its rational degree;
- which later exceptional component is horizontal;
- whether a horizontal carrier is a coordinate line, a conic, or a more complicated curve in an exceptional surface;
- the base multiplicity carried by it.

Associated-graded normal jets record necessary leading terms. They do not integrate themselves into a component map or select a horizontal section of the exceptional surface.

## 5. Faithful `V_4` rational curves

The conic

\[
x_z^2+x_s^2+x_r^2=0
\subset D
\]

is smooth and rational. It is `V_4`-stable, and the induced `V_4` action is faithful: no nonidentity element acts pointwise on the conic.

This gives an explicit counterexample to the surface-style assertion that every exceptional rational curve has a nontrivial stabilizer kernel.

## 6. Higher blowups

Further smooth `V_4`-stable centers may be:

- coordinate points;
- point orbits on an exceptional line;
- invariant curves inside an exceptional surface;
- centers meeting several exceptional divisors normally.

The resulting incidence object is not canonically a tree. A path chosen in one dual graph can be bypassed through an exceptional surface, and the fixed loci of the three involutions may be disconnected.

In particular, connectedness of the full exceptional fiber is insufficient for endpoint propagation.

## 7. Conditional carrier statement

The following implication is valid but conditional:

> Suppose the normalized Rees algebra of the actual base ideal determines a unique `N_G(V_4)`-stable one-dimensional horizontal carrier through the three marked tangent directions, and suppose every pointwise-`z`-fixed rational component in its fiber is forced to land in `E_z` rather than `L_z`. Then the `z`-fixed part of that carrier is constant. If the analogous statement holds for `z,s,r` and the carrier incidence graph is connected, endpoint values propagate.

Neither premise follows from the installed fixed-stratum and normal-character data. The first exceptional `P^2` explicitly shows why the second premise requires an ambient base-ideal argument.

## 8. Boundary

Type-I incidence proves `a=0` for the unbroken network. It does not prove that the actual resolved map possesses an unbroken elliptic carrier, and it does not exclude a line-valued exceptional bypass. This is one of the two smallest local components of the missing ambient base-carrier rigidity theorem.
