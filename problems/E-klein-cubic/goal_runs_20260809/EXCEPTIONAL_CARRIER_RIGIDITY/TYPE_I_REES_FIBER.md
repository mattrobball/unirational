# Type-I normalized-Rees fiber

## 1. Incident directions

At a type-I point `x` with stabilizer
\[
V_4=\{1,z,s,r\},
\]
the three incident source curves are
\[
E_z,
\qquad L_s,
\qquad L_r,
\]
with tangent characters `chi_z`, `chi_s`, `chi_r`.  The first point blowup has
\[
D=\mathbf P(\chi_z\oplus\chi_s\oplus\chi_r).
\]
The `z`-fixed bypass line is
\[
B_z=\mathbf P(\chi_s\oplus\chi_r).
\]

## 2. Canonical endpoint carriers

Each incident branch has an intrinsic endpoint on the normalized graph.

- Over `E_z`, the ordinary valuation has a canonical center.  By the accepted
  odd-jet theorem its target is `L_z`, not `E_z`.
- Over `L_s` and `L_r`, use the strict transform when the line is generically
  outside the base scheme and the ordinary center otherwise.  Any curve
  carrier is birational to the original line and maps to the corresponding
  rational fixed component.

The specializations of these three carriers in `pi^{-1}(x)` are intrinsic
closed subsets, but need not be points and need not lie on one fixed component.

## 3. Exact restrictions on point-centered components

Let `T` be an irreducible component of the normalized fiber over `x`.
Because `Gamma` is finite over the graph closure, the map
\[
q|_T:T\to q(T)\subset X
\]
is finite.  Hence
\[
\dim T=\dim q(T).
\tag{3.1}
\]
Consequences:

1. every curve component maps nonconstantly to a target curve;
2. every surface component maps generically finitely to a target surface;
3. a point-centered Rees divisor is a surface component;
4. no such surface is fixed pointwise by `z`, `s`, or `r`;
5. every `V4`-stable surface component has faithful generic `V4` action.

Thus a point-centered component mapping to `L_z` can only be a curve, not a
Rees divisor.

## 4. The bypass mechanism that genuinely exists locally

For the exact local landing ideal `(v,w)` with target `L_z`, the normalized
graph is the blowup of the `u`-axis.  Its fiber at `x` is precisely `B_z`, and
\[
B_z\to L_z
\]
is the identity in compatible coordinates.  This is an actual normalized-Rees
curve for that ideal.  It connects the two line directions and bypasses the
elliptic direction.

This model is `V4`-equivariant and satisfies the Klein equation because its
image is contained in `L_z`.  It is a local countermodel to any theorem based
only on `V4` characters and the landing equation.  A full residual-`C3` model
would contain the three conjugate bypass mechanisms; residual symmetry forces
the orbit but does not by itself exclude it.

The packet does **not** claim that the unknown global ideal `J_x` equals this
model.

## 5. Weak bypass divisors do not automatically survive

The pair
\[
(uw+v^3,uv+w^3)
\]
creates a divisor after blowing up a weak base line in `D`, but the divisor is
point-centered and line-valued.  The joint-residue criterion contracts it to a
curve in the normalized graph.  Therefore the actual type-I classification
must inspect the normalized point fiber, not merely list weak divisors.

## 6. Current incidence theorem

The total fiber `pi^{-1}(x)` is connected: `pi` is proper birational and `X` is
normal, so Stein factorization gives `pi_*O_Gamma=O_X`.  This does not imply
that any of the following is connected:

- the `z`-fixed landing-horizontal locus;
- the union of the three involution-fixed carrier curves;
- the carrier subcomplex joining the three branch endpoints;
- the one-skeleton obtained after discarding surface components.

No tree or simple-connectivity theorem follows.  A connected total fiber may
join fixed curves only through a faithful surface or through components on
which the relevant involution acts nontrivially.

## 7. Type-I classification table

| candidate | what is proved | status for the genuine `J_x` |
|---|---|---|
| `B_z` as special fiber of an ordinary curve-centered divisor | exact local model exists | open |
| point-centered divisor mapping to `L_z` | impossible by residue dimension | excluded |
| point-centered `z`-fixed divisor | impossible | excluded |
| faithful `V4` surface Rees divisor | allowed only with surface target | open |
| `z`-fixed curve slice in such a surface | not excluded | open |
| isolated line-valued curve component of the point fiber | compatible with all general theorems | open |
| component joining only `chi_s` and `chi_r` | realized by the ordinary bypass model | not uniformly excluded |

## 8. Smallest missing type-I proposition

For the actual completed tuple, determine:

1. the normalized fiber components over `x`;
2. the surface-valued Rees valuations among all first- and higher-transform
   candidates;
3. the three involution-fixed curve loci inside those components;
4. the specializations of the `E_z`, `L_s`, and `L_r` ordinary carriers;
5. all target maps and base multiplicities.

Only after these data are known can one ask whether the three endpoints lie in
a connected fixed carrier complex and whether type-I marked values propagate.
