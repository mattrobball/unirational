# Ambient Rees selfmap classification: status

**Date:** 2026-08-09  
**Exit:** `FULL-G-AMBIENT-SELFMAP-CLASSIFICATION-UNDECIDED`

## Executive verdict

The requested ambient identity / degree-one / finite-profile program is not the
correct theorem target once the accepted existence of nontrivial intrinsic
`G`-selfmaps is combined with a simple composition lemma.

Let

\[
A:\mathbf P(W_5)\dashrightarrow X
\]

be any dominant `G`-equivariant ambient landing map, represented by a
homogeneous tuple `P` with `F(P)=0`. Let

\[
\sigma:X\dashrightarrow X
\]

be any dominant `G`-equivariant rational selfmap. Choose homogeneous ambient
lifts `S=(S_0,...,S_4)` of its coordinate sections. Since `sigma` lands in `X`,

\[
F(S)=F\,B
\]

for a homogeneous polynomial `B`. Substitution gives the exact polynomial
identity

\[
F(S(P))=F(P)B(P)=0.
\]

Hence `S(P)` is another ambient landing tuple and represents `sigma o A`.
After removing any common factor it remains a primitive landing tuple.
Therefore the set of ambient landing maps is closed under postcomposition by
**every** rational `G`-selfmap of `X`.

The preceding `FULL_G_SELFMAP_CLASSIFICATION` packet proves a nonidentity
selfmap `sigma` of degree at least 3, with iterates of unbounded degree. It
follows:

> **Dichotomy.** Either no dominant ambient landing map
> `P(W_5) --> X` exists, or ambient-extendable restrictions contain maps of
> unbounded degree.

In particular, conditional on nonemptiness, all three requested rigidity
exits are false:

```text
FULL-G-AMBIENT-SELFMAP-IDENTITY-THEOREM          FALSE IF NONEMPTY
FULL-G-AMBIENT-SELFMAP-DEGREE-ONE-THEOREM        FALSE IF NONEMPTY
FULL-G-AMBIENT-SELFMAP-FINITE-TYPE-CLASSIFICATION FALSE IF NONEMPTY
```

The third statement uses the requested meaning of finite type, which includes
the global restriction degree in the profile.

Thus proving either the ambient identity theorem or the ambient degree-one
theorem would actually prove **emptiness** of the ambient landing set, hence
solve the headline non-unirationality problem directly. There is no separate
nonempty degree-one/retraction branch compatible with the accepted arbitrary
selfmaps.

## Required checkpoint

### Q1 — finite syzygy module?

**No, not in the stated sense.** The set

\[
\mathcal L=\{P:F(P)=0\}
\]

inside the graded covariant module is a cubic nonlinear cone, not an additive
submodule: polarization of `F` shows that `F(P+Q)` has mixed terms even when
`F(P)=F(Q)=0`. Hilbert-Noether finite generation applies to the ambient
covariant module over `C[W]^G`, but the landing locus is a closed nonlinear
subscheme in that finite module, not a syzygy module. Matrix factorization / MCM
technology does not linearize this basic cubic condition.

### Q2 — generic involution plus-plane layer?

Let `t` have `W=W_+ plus W_-`, dimensions `(3,2)`, and let `(u,v)` be normal
coordinates to `W_+`. Since every landing tuple vanishes on `W_+`, write its
first nonzero normal term as `P^(r)`. Equivariance gives

\[
P^{(r)}(x,-u,-v)=tP^{(r)}(x,u,v).
\]

Hence an even layer takes values in `W_+` and an odd layer takes values in
`W_-`. The leading term of `F(P)=0` gives `F(P^(r))=0` after passing to the
corresponding associated graded quotient, so a defined first-layer exceptional
map lands in

\[
X cap P(W_+)=E_t \quad (r\text{ even}),
\qquad
P(W_-)=L_t \quad (r\text{ odd}).
\]

This does **not** canonically produce the elliptic carrier. The ordinary order
valuation need not be a Rees valuation, its initial tuple may retain base
points on the exceptional `P^1`, and the normalized blowup may have several
Rees valuations above the plane. The actual elliptic carrier may therefore
occur only at a higher normalized-Rees component.

### Q3 — type-II V4 relation?

At a type-II point use local character coordinates `(b,c,d)` for the three
nontrivial characters. The three involution plus-planes have local ideals

\[
(c,d),\quad (b,d),\quad (b,c).
\]

Forced vanishing on all three gives

\[
I_P\subset (c,d)\cap(b,d)\cap(b,c)=(bc,bd,cd)
\]

on the local slice. Consequently the quadratic initial tuple has no trivial
character component and has the form

\[
P_B^{(2)}=\alpha\,cd,\qquad
P_C^{(2)}=\beta\,bd,\qquad
P_D^{(2)}=\gamma\,bc.
\]

The Klein cubic restricted to `P(B plus C plus D)` vanishes on the three
coordinate lines (the V4 minus-triangle) and is not identically zero, hence is
`kappa BCD` with `kappa != 0`. Therefore the degree-six initial term of the
global landing identity is

\[
\kappa\alpha\beta\gamma\,b^2c^2d^2=0,
\]

so

\[
\boxed{\alpha\beta\gamma=0.}
\]

Thus the first point-exceptional `P^2` cannot simultaneously carry all three
nonzero character directions. At least one direction is pushed to higher
Rees order. This is a genuine simultaneous local consequence of one landing
ideal, but it does not classify the higher layers.

### Q4 — degree one or finite profiles?

**No from these local constraints, and finite nonempty classification is
impossible globally.** If one ambient landing exists, postcomposition with the
accepted intrinsic selfmap and its iterates yields ambient restrictions of
unbounded degree. Therefore local Rees constraints can force `delta=1` only by
forcing the ambient landing set to be empty; they cannot produce a nonempty
finite profile list containing global degree.

## Smallest remaining theorem

The correct remaining problem is now the headline existence problem itself:

> **Ambient landing emptiness theorem.** Prove that no primitive homogeneous
> `G`-covariant tuple `P` with `F(P)=0` defines a dominant map
> `P(W_5) --> X`.

Normalized Rees geometry remains potentially useful for proving emptiness, but
it can no longer support the proposed classification of a nonempty rigid
ambient submonoid.

The most concrete unresolved local-to-global statement is:

> classify the higher normalized-Rees valuations forced after the type-II
> product-zero relation, and show that their globally synchronized occurrence
> over all 55 V4 configurations is impossible.

No such theorem is proved in this packet.
