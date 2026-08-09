# Polarization and ambient degree

## 1. Principalized linear system

Let the hypothetical ambient map

\[
f:\mathbf P(W_5)\dashrightarrow X
\]

be represented primitively by homogeneous forms of degree `d`. Principalize
their common base ideal:

\[
p:\widetilde Y\to\mathbf P(W_5),
\qquad
\mathcal I\mathcal O_{\widetilde Y}=\mathcal O_{\widetilde Y}(-B),
\]

and let

\[
q:\widetilde Y\to X
\]

be the resulting morphism. If `H_Y=O_{P(W_5)}(1)` and `H_X=O_X(1)`, then
the base-point-free system defining `q` gives the exact identity

\[
q^*H_X
\simeq
p^*H_Y^{\otimes d}\otimes\mathcal O_{\widetilde Y}(-B).
\tag{1.1}
\]

Numerically,

\[
c_1(q^*H_X)=d\,p^*c_1(H_Y)-[B].
\tag{1.2}
\]

This is the correct relation on every principalization. No resolved degree
comparison may omit `B`.

## 2. Elliptic carrier formula

Let `C` be a smooth elliptic horizontal carrier stable under the residual
group. Assume:

- `p|_C:C->E_t subset P(W_5)` is finite of degree `delta`;
- after identifying the marked source elliptic, the target restriction is
  \[
  q|_C(P)=[n]P+a
  \]
  onto `E_t`.

The plane embedding has degree

\[
\deg(H_Y|_{E_t})=\deg(H_X|_{E_t})=3.
\]

Translation by `a` does not change degree, while multiplication by `n` has
degree `n^2`. Therefore

\[
\deg(q^*H_X|_C)=3n^2,
\qquad
\deg(p^*H_Y|_C)=3\delta.
\]

Restricting (1.1) to `C` yields

\[
\boxed{3n^2=3d\delta-B\cdot C.}
\tag{2.1}
\]

If `p|_C` is birational, `delta=1` and

\[
3n^2=3d-B\cdot C.
\tag{2.2}
\]

The intersection `B.C` is the degree of `O(B)|_C`; it remains meaningful when
`C` lies in exceptional geometry and need not be nonnegative term by term.

## 3. When `d=n^2` follows

Equation (2.2) gives

\[
d=n^2
\]

exactly when

\[
B\cdot C=0.
\]

Thus the desired square relation is not a consequence of the abstract
elliptic map. It is a statement that a birational canonical elliptic carrier
is base-neutral after principalization.

For the proposed multiplier `n=-5`,

\[
75=3d-B\cdot C.
\]

Hence `d=25` follows only after proving `B.C=0`. Without that theorem, an
ambient map with the same carrier multiplier could have another degree
compensated by the base correction.

In the more general source-degree-`delta` case,

\[
75=3d\delta-B\cdot C,
\]

so one must also prove `delta=1`.

## 4. Rational line carrier formula

Let `R` be a rational horizontal carrier with

- `p|_R:R->L_t` of degree `delta_L`;
- `q|_R:R->L_t` of degree `r`.

Since both line polarizations have degree one, restriction of (1.1) gives

\[
\boxed{r=d\delta_L-B\cdot R.}
\tag{4.1}
\]

For a birational carrier,

\[
r=d-B\cdot R.
\tag{4.2}
\]

Thus an identity line map gives

\[
1=d-B\cdot R,
\]

not `d=1`. A degree-25 ambient covariant with identity on a birational resolved
line carrier would require `B.R=24`.

This is compatible with the later strict-boundary obstruction: a tuple which
is defined **everywhere** on the original line has no base correction and
therefore forces `d=1`; a rational tuple with line base points may have an
identity strict transform after principalization.

## 5. Exact strict-boundary comparison

The later packet
`goal_runs_20260809/DEGREE25_MARKED_ELLIPTIC_EXTENSION/` proves for the actual
plane line bundle `L=O_{E_t}(1)` that

\[
[-5]^*L\simeq L^{25}.
\]

For the strict reduced-network map

\[
\Phi_{-5,1}|_{E_t}=[-5],
\qquad
\Phi_{-5,1}|_{L_t}=\operatorname{id},
\]

a degree-`d` homogeneous tuple defined at every point would require a
nowhere-zero scalar section whose component restrictions are

\[
L^{d-25}
\quad\text{and}\quad
O_{\mathbf P^1}(d-1).
\]

The elliptic components force `d=25`, while the lines force `d=1`. Therefore
no degree gives an everywhere-defined tuple inducing this strict boundary
map.

More strongly, every homogeneous landing covariant satisfies

\[
p|_{W_+(t)}=0
\]

for every involution `t`. Hence the nonzero order-zero map `[-5]` cannot occur
on the original `E_t` in any degree. The exact strict-boundary obstruction is
therefore stronger than failure of a degree-25 coefficient lift.

It does not contradict (2.1): equation (2.1) concerns a horizontal carrier on
a principalized model, whereas the strict original elliptic is contained in
the forced plus-plane base locus.

## 6. Plus-plane base component

Every involution plus-plane

\[
\mathbf P(E_+(t))=\mathbf P^2
\]

is a base component of a landing covariant. The first nonzero transverse order
is odd and its leading target lies in `L_t`. Since `E_t` lies inside this
plus-plane, the direct restriction of the original degree-`d` tuple to `E_t`
is zero.

Therefore an elliptic component map in the resolved graph cannot be read from
an order-zero restriction to the original `E_t`. It must arise, if at all, on
a later exceptional carrier after principalization. This is precisely why
`B.C` is load-bearing and why a formal normal-jet order is not automatically
the pullback degree of an actual elliptic carrier.

## 7. Relation to normal orders

Write

\[
B=\sum_i m_iE_i.
\]

Then

\[
B\cdot C=\sum_i m_i(E_i\cdot C).
\]

The local transition modules constrain possible first normal orders `m_i`
along named strata. They do not determine:

- which exceptional divisors meet the essential carrier;
- the intersection numbers `E_i.C`;
- cancellations after normalization;
- whether a formal leading jet integrates to the carrier;
- whether further blowups alter the visible component while preserving the
  valuation.

A finite degree theorem requires the normalized Rees data, not only the
associated-graded orders.

## 8. Arithmetic consequences already valid

For a birational elliptic carrier, (2.2) implies

\[
B\cdot C\equiv0\pmod3.
\]

Together with residual equivariance and unbroken marked incidence,

\[
n\equiv1\pmod6.
\]

These are genuine necessary conditions. They still allow infinitely many
`n`, and equation (2.2) allows infinitely many ambient degrees until `B.C` is
controlled.

## 9. Acceptance conditions for a degree-25 exceptional profile

To reduce the ambient problem to degree 25, one would need all of:

1. every hypothetical ambient map has a canonical residual-`S_3` elliptic
   carrier `C_t` over each forced plus-plane base stratum;
2. `p|_{C_t}:C_t->E_t` is birational;
3. the carrier map fixes the full marked set, hence is `[n]` with
   `n=1 mod 6`;
4. `B.C_t=0`;
5. all possibilities except `n=-5` and the identity/retraction branch are
   excluded by global carrier incidence;
6. the normal-jet state integrates to the claimed actual carrier map.

Only then would `n=-5` force `d=25`. The strict reduced-network morphism does
not provide any of these carrier statements.

## 10. Conclusion

Polarization supplies an exact bridge, but its resolved output is the
base-corrected formula (2.1), not the unconditional identity `d=n^2`. The
strict map `[-5]/id` is now known not to extend order-zero in any degree. The
smallest missing numerical and geometric theorem is the construction of a
canonical exceptional elliptic carrier together with its source degree and
base intersection.
