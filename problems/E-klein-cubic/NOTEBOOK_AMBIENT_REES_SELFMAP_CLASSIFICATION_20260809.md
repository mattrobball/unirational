# Notebook supplement — ambient Rees selfmap classification

**Date:** 2026-08-09  
**Packet:** `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/`  
**Headline:** OPEN

## Binding correction

The attempted classification of a nonempty rigid ambient-extendable selfmap
subclass is superseded by an exact postcomposition theorem.

If

\[
A:\mathbf P(W_5)\dashrightarrow X
\]

is any dominant `G`-equivariant ambient landing map represented by `P` with
`F(P)=0`, and

\[
\sigma:X\dashrightarrow X
\]

is any dominant rational `G`-selfmap, choose ambient lifts `S` of the
coordinates of `sigma`. Since `sigma` lands in `X`,

\[
F(S)=F B.
\]

Therefore

\[
F(S(P))=F(P)B(P)=0.
\]

Thus `sigma o A` is again an ambient landing map.

The accepted tangent-residual theorem supplies a nonidentity `G`-selfmap of
degree at least 3 and iterates of unbounded degree. Hence:

```text
NO AMBIENT LANDING MAP EXISTS
or
AMBIENT-EXTENDABLE RESTRICTIONS HAVE UNBOUNDED DEGREE.
```

Consequently the proposed exits

```text
FULL-G-AMBIENT-SELFMAP-IDENTITY-THEOREM
FULL-G-AMBIENT-SELFMAP-DEGREE-ONE-THEOREM
FULL-G-AMBIENT-SELFMAP-FINITE-TYPE-CLASSIFICATION
```

are false conditional on nonemptiness (for the finite-type exit, with the
requested profile data including global restriction degree). Proving either of
the first two would already prove that no ambient landing map exists and hence
solve the negative headline directly. There is no separate surviving
retraction branch after such a theorem.

## Required checkpoint

### Q1

`{P:F(P)=0}` is not an additive syzygy module. It is a nonlinear cubic cone in
the finitely generated covariant module. Finite generation of covariants over
`C[W]^G` therefore does not imply finitely many primitive landing maps or Rees
types.

### Q2

Along an involution plus-plane, if `r` is the first nonzero normal order then
equivariance gives

\[
r\text{ even}\Rightarrow P^{(r)}\in W_+,
\qquad
r\text{ odd}\Rightarrow P^{(r)}\in W_-.
\]

The leading landing equation sends a defined first exceptional map to `E_t`
in even order and to `L_t` in odd order. But the ordinary first blowup need not
be a normalized Rees component and may retain base points; no canonical
elliptic carrier follows.

### Q3

At a type-II `V4` point, with local character coordinates `(b,c,d)`, forced
vanishing on the three plus-planes gives

\[
I_P\subset(c,d)\cap(b,d)\cap(b,c)=(bc,bd,cd).
\]

The quadratic initial tuple has

\[
P_B^{(2)}=\alpha cd,
\quad
P_C^{(2)}=\beta bd,
\quad
P_D^{(2)}=\gamma bc.
\]

The Klein cubic restricts on `P(B+C+D)` to a nonzero scalar multiple of `BCD`,
so the global landing identity forces

\[
\boxed{\alpha\beta\gamma=0.}
\]

Thus the first point-exceptional `P^2` cannot simultaneously carry all three
nonzero character directions; at least one direction is deferred to higher
Rees order.

### Q4

These local constraints do not prove degree one or a finite nonempty profile
list. Globally, postcomposition proves that if one ambient landing exists then
restriction degrees are unbounded. Local Rees rigidity can therefore force
`delta=1` for all ambient maps only by forcing **emptiness**.

## Exact remaining theorem

The correct target is

```text
NO-DOMINANT-G-AMBIENT-LANDING-MAP
```

rather than classification of a nonempty degree-one ambient subclass.

The most concrete remaining Rees theorem is to classify the higher normalized
Rees valuations forced after the type-II product-zero relation and prove that
their synchronized occurrence across all 55 `V4` configurations is
impossible.

No such theorem is proved in the packet.

## Current exit

```text
FULL-G-AMBIENT-SELFMAP-CLASSIFICATION-UNDECIDED
KLEIN-PSL2(11)-NONUNIRATIONAL-NOT-PROVED
```
