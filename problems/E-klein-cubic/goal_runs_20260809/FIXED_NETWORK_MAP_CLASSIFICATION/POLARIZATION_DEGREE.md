# Polarization and ambient degree

## 1. Principalized linear system

Let the hypothetical ambient map

\[
f:P(W_5)\dashrightarrow X
\]

be represented primitively by homogeneous forms of degree `d`. Principalize their common base ideal:

\[
p:\widetilde Y\to P(W_5),
\qquad I O_{\widetilde Y}=O_{\widetilde Y}(-F),
\]

and let

\[
q:\widetilde Y\to X
\]

be the resulting morphism. If `H_Y=O_{P(W_5)}(1)` and `H_X=O_X(1)`, then the base-point-free system defining `q` gives the exact identity

\[
q^*H_X
\simeq
p^*H_Y^{\otimes d}\otimes O_{\widetilde Y}(-F).
\tag{1.1}
\]

Numerically,

\[
c_1(q^*H_X)=d\,p^*c_1(H_Y)-[F].
\tag{1.2}
\]

This is the correct relation on every principalization. No degree comparison may omit `F`.

## 2. Elliptic carrier formula

Let `C` be a smooth elliptic horizontal carrier stable under the residual group. Assume:

- `p|_C:C->E_t subset P(W_5)` is finite of degree `delta`;
- after identifying `C` with the marked source elliptic, the target restriction is
  \[
  q|_C(P)=[n]P+a
  \]
  onto `E_t`.

The plane embedding has degree

\[
deg(H_Y|_{E_t})=deg(H_X|_{E_t})=3.
\]

Translation by `a` does not change degree, while multiplication by `n` has degree `n^2`. Therefore

\[
deg(q^*H_X|_C)=3n^2,
\qquad
deg(p^*H_Y|_C)=3\delta.
\]

Restricting (1.1) to `C` yields

\[
\boxed{3n^2=3d\delta-F\cdot C.}
\tag{2.1}
\]

If `p|_C` is birational, `delta=1` and

\[
3n^2=3d-F\cdot C.
\tag{2.2}
\]

The intersection `F.C` means the degree of `O(F)|_C`; it remains meaningful when `C` lies in an exceptional divisor and need not be nonnegative term-by-term.

## 3. When `d=n^2` follows

Equation (2.2) gives

\[
d=n^2
\]

exactly when

\[
F\cdot C=0.
\]

Thus the desired square relation is not a consequence of the abstract elliptic map. It is a statement that the canonical elliptic carrier is base-neutral after principalization.

For the proposed multiplier `n=-5`,

\[
75=3d-F\cdot C.
\]

Hence `d=25` follows only after proving `F.C=0`. Without that theorem, an ambient map with the same component multiplier could have another degree compensated by base multiplicity.

In the more general degree-`delta` case,

\[
75=3d\delta-F\cdot C,
\]

so one must also prove `delta=1`.

## 4. Rational line carrier formula

Let `R` be a rational horizontal carrier with

- `p|_R:R->L_t` of degree `delta_L`;
- `q|_R:R->L_t` of degree `r`.

Since both line polarizations have degree one, restriction of (1.1) gives

\[
\boxed{r=d\delta_L-F\cdot R.}
\tag{4.1}
\]

For a birational carrier,

\[
r=d-F\cdot R.
\tag{4.2}
\]

Thus an identity line map gives

\[
1=d-F\cdot R,
\]

not `d=1`. A degree-25 ambient covariant with identity line restriction would necessarily carry base intersection `F.R=24` on a birational line carrier.

This observation is important: the pair `([-5],id)` is not internally inconsistent with ambient degree 25; it requires different base corrections on the elliptic and rational carriers.

## 5. Plus-plane base component

The installed involution-plane transition theorem says every plus-plane

\[
P(E_+(t))=P^2
\]

is a base component, with first transverse order odd and leading image in `L_t`. Since `E_t` lies inside this plus-plane, the direct restriction of the original degree-`d` forms to `E_t` is zero.

Therefore an elliptic map in the resolved graph cannot be read from an order-zero restriction to the original `E_t`. It must arise on a later exceptional carrier after removing the common base factor. This is precisely why `F.C` is load-bearing and why the formal normal-jet order is not automatically the pullback degree of an actual elliptic carrier.

## 6. Relation to normal orders

Write

\[
F=\sum_i m_i E_i.
\]

Then

\[
F\cdot C=\sum_i m_i(E_i\cdot C).
\]

The local transition modules constrain possible first normal orders `m_i` along named strata. They do not determine:

- which exceptional divisors meet the essential carrier;
- the intersection numbers `E_i.C`;
- cancellations after normalization;
- whether a formal leading jet integrates to the carrier;
- whether further blowups alter the visible component while preserving the valuation.

A finite degree theorem requires the normalized Rees data, not only the associated graded orders.

## 7. Arithmetic consequences already valid

For a birational elliptic carrier, (2.2) implies

\[
F\cdot C\equiv0\pmod3.
\]

Together with residual equivariance and unbroken marked incidence,

\[
n\equiv1\pmod6.
\]

These are genuine necessary conditions. They still allow infinitely many `n`, and equation (2.2) allows infinitely many ambient degrees until `F.C` is controlled.

## 8. Acceptance condition for degree 25

To reduce the positive problem to one degree, it is enough to prove all of:

1. every hypothetical ambient map has a canonical residual-`S_3` elliptic carrier `C_t` over each involution;
2. `p|_{C_t}:C_t->E_t` is birational;
3. the carrier map fixes the full marked set, hence is `[n]` with `n=1 mod 6`;
4. `F.C_t=0`;
5. all possibilities except `n=-5` and the identity/retraction branch are excluded by the global carrier incidence.

Only then does `n=-5` force `d=25`.

## 9. Conclusion

Polarization supplies an exact and useful bridge, but its output is the base-corrected formula (2.1), not the unconditional identity `d=n^2`. The smallest missing numerical theorem is the computation of `delta` and `F.C` for a canonical essential elliptic carrier.
