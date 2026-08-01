# Exact zero-cycle ledger for the generic Schur twist

## 1. Field and torsor

Let

\[
\widetilde G=\operatorname{SL}_2(\mathbf F_{11}),\qquad
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad |G|=660,
\]

and let `V6` be the six-dimensional Schur representation of
`tilde G`.  The center acts scalarly, so `G` acts on

\[
Y=\mathbf P(V_6).
\]

On the generically free locus put

\[
E=\mathbf C(Y),\qquad K=K_{\rm Schur}=E^G.
\]

Then `E/K` is a connected `G`-Galois extension and
`trdeg_C K=5`.  The generic Schur twist is

\[
X_T={}^T X\subset\mathbf P^4_K,
\]

where the ambient projective space is split because the Klein module `W` is
an honest five-dimensional `G`-representation.

The five degree-eight Reynolds covariants in the upstream exact frame give a
`K`-basis of the descended Klein space.  Thus `X_T` is not an unspecified
form: in that basis it is the explicit cubic `Phi(a0,...,a4)=0` described in
`tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`.

## 2. Exact degree-55 closed point

Let `H` be the centralizer of an involution.  The exact cyclotomic group
model verifies

\[
H\simeq D_{12},\qquad |H|=12.
\]

The restriction of the Klein module to `H` has two irreducible
two-dimensional summands.  Exactly one of their projective lines is contained
in the Klein cubic.  The full stabilizer of that line is `H`, so its orbit has
size

\[
[G:H]=55.
\]

Put

\[
L=E^H.
\]

The descended line is `P1_L`.  Choosing an `L`-point away from the finitely
many intersections with its other conjugate lines gives a point with exact
semilinear stabilizer `H`.  Its descent is therefore a genuine reduced closed
point

\[
Z_{55}\subset X_T,
\qquad k(Z_{55})=L,
\qquad [L:K]=55.
\]

Because `G` is simple and `H` is proper, `core_G(H)=1`.  Hence the Galois
closure of `L/K` is exactly `E/K`, with group `G`.  Moreover `H` is
self-normalizing, so

\[
\operatorname{Aut}_K(L)=N_G(H)/H=1.
\]

The installed portable algebra is an abstract monogenic schema

\[
L=K[t]/(\mu(t)),\qquad \deg\mu=55,
\]

not an expanded polynomial `mu` in named invariant generators.  No
computation in this run treats that abstract schema as executable generic
coordinates.

## 3. Other exact orbit cycles

The subgroup-fixed configurations give the following effective cycles on
every twist.  For the generic connected torsor, choosing a point with the
certified exact stabilizer gives the displayed residue field.

| stabilizer `J` | order | degree `[G:J]` | generic residue field | `Aut_K(E^J)` |
|---|---:|---:|---|---:|
| `C11` | 11 | 60 | `E^C11` | `N_G(C11)/C11`, order 5 |
| `C5` | 5 | 132 | `E^C5` | `N_G(C5)/C5`, order 2 |
| `V4` | 4 | 165 | `E^V4` | `N_G(V4)/V4`, order 3 |
| `C3` | 3 | 220 | `E^C3` | `N_G(C3)/C3`, order 4 |

Each `J` is core-free, so every one of these non-Galois residue extensions
has Galois closure `E/K` with group `G`.  The exact fixed-point and orbit
checks are replayed by `certificates/subgroup_orbit_check.py` and
`certificates/orbit_hilbert_check.py`.

These cycles give the formal identity

\[
-13Z_{60}+3Z_{132}+Z_{165}+Z_{220}
\quad\text{of degree}\quad 1.
\]

This is a signed element of the zero-cycle group.  It is not an effective
cycle and is not asserted to be rationally equivalent to a rational point.

## 4. The shortest index-one certificate

Because the ambient `P4_K` is split and `K` is infinite, a general `K`-line
meets `X_T` transversely in an effective separable zero-cycle `H3` of degree
three.  Therefore

\[
\deg(Z_{55}-18H_3)=55-18\cdot3=1.
\]

Equivalently,

\[
\operatorname{ind}(X_T)\mid55,qquad
\operatorname{ind}(X_T)\mid3,qquad
\boxed{\operatorname{ind}(X_T)=1}.
\]

The two effective supports are on the same proper model `X_T`, but the
degree-one combination is signed.  No installed rational equivalence turns it
into an effective point.

All transverse cubic linear sections represent the same intersection class
`H^3` in `CH_0(X_T)`.  No relation between `Z55` and `H^3` beyond their
degrees is known here.

## 5. What exact descent is known

A separable quadratic point on a cubic in a split projective space descends:
join the conjugate pair and take the residual third intersection (or use a
ground-field line if the whole line is contained).  Thus an effective
degree-two residual cycle would finish positively.

For the marked degree-55 point, a curve of pure degree 19 meeting `X_T`
properly and containing `Z55` with multiplicity one would leave

\[
3\cdot19-55=2.
\]

That bridge is exact.  No such curve is currently constructed.  Degree 19 is
minimal only for this particular proper-intersection mechanism because
`3*18<55<=3*19`.

Balestrieri's closed-point theorem gives only a point over some extension of
degree at most 107 under the verified hypotheses.  It does not force degree
one or two.

## 6. Point-or-primitive-quartic reduction

Intersect the degree-55 line orbit with a general smooth `K`-hyperplane
section.  This gives a smooth cubic surface of index one.  Voisin, Theorem
1.5 and Remarks 1.6--1.7 of arXiv:2509.17996v2, gives a `K`-point or an
effective degree-four cycle.  If `X_T(K)` is empty, degree-one and degree-two
components are impossible by immediate or secant descent, so the cycle is
one integral quartic point.

An imprimitive action on the four embeddings preserves a pairing.  Applying
third intersection to the two conjugate-pair secants gives a degree-two cycle
over `K`, again forcing a point.  Thus the no-point branch has primitive
quartic Galois closure `A4` or `S4`.  The exhaustive finite-group check is
`verify_quartic_frontier.py`.

This does not solve the primitive quartic case.  Its splitting field need not
be contained in the generic `G`-extension `E/K`.

## 7. Rational-equivalence boundary

The ledger proves:

- effective cycles of degrees 3 and 55 on the genuine generic twist;
- a genuine closed point with residue field `E^D12` and exact degree 55;
- a signed degree-one zero-cycle and therefore index one;
- exact Galois closures and automorphism groups of the standard orbit fields.

It does **not** prove:

- effectiveness of either signed degree-one combination;
- a `K`-rational point;
- rational equivalence of `Z55-18H3` to an effective cycle;
- a degree-two point;
- the Cassels--Swinnerton-Dyer implication for this cubic.
