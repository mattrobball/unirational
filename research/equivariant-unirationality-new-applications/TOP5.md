# Top five actions: exact obstruction tests

## 1. Smooth quartic double solid with `(C7:C3) × C2deck`

### A. Exact action

Let

\[
B=2x_0^4+6x_0x_1x_2x_3+x_1x_3^3+x_1^3x_2+x_2^3x_3
\]

and

\[
X=\{w^2=B\}\subset\mathbf P(1,1,1,1,2).
\]

For a primitive seventh root `ζ`, put

\[
a=[1,\zeta^4,\zeta^2,\zeta],
\qquad
b(x_0,x_1,x_2,x_3)=(x_0,x_2,x_3,x_1).
\]

Then `bab^{-1}=a^4`, so `H=<a,b>=C7:C3`. Let `τ:w↦-w` and `G=H×<τ>`.

### B. Subgroup configuration

Use the central deck involution `τ`. Its residual group on the fixed K3 surface is `H`.

### C. Fixed geometry

\[
X^\tau=B,\qquad B^H=\varnothing,
\qquad B^{C_7}=\{e_1,e_2,e_3\}.
\]

If an `H`-stable rational curve existed on `B`, the induced action on its normalization `P1` would have kernel containing the normal `C7`, because `C7:C3` is not a finite subgroup of `PGL2`. The curve would then lie in the finite set `B^{C7}`, a contradiction. Since a K3 surface is not RCC, `B` has no positive-dimensional `H`-stable RCC subvariety.

### D. Obstruction test

```text
Condition (A)                                      PROVED
residual-RCC fixed-locus hypothesis                PROVED
X^G = empty                                        PROVED
equivariant universal-torsor obstruction           ZERO
all higher Amitsur groups                          ZERO
```

### E. Outcome

Closed in this packet:

\[
X\text{ is not weakly }G\text{-versal}.
\]

The underlying smooth quartic double solid is classically unirational. See `THEOREM_KLEIN_QUARTIC_DOUBLE_SOLID.md`.

---

## 2. Odd exceptional conic bundles with `D_{2g} × C2`

### A. Exact action

For odd `g≥3`, let `S_g` be the minimal resolution of

\[
T_0T_1(T_0^{2g}+T_1^{2g})+T_2T_3=0
\subset\mathbf P(1,1,g+1,g+1).
\]

Let `ξ` be a primitive `2g`-th root and define

\[
r(T_0,T_1)=(\xi T_0,\xi^{-1}T_1),
\qquad
s(T_0,T_1)=(T_1,T_0),
\qquad
j(T_2,T_3)=(T_3,T_2).
\]

In the weighted projective action, `r` has order `g`, `<r,s>=D_{2g}` of order `2g`, and `j` is central. Put `G_g=D_{2g}×<j>`.

### B. Subgroup configuration

Use `j∈Z(G_g)`.

### C. Fixed geometry

\[
S_g^j=C_g:\ U^2=-T_0T_1(T_0^{2g}+T_1^{2g}),
\qquad g(C_g)=g,
\]

and `C_g^{D_{2g}}=∅`. Thus `S_g^{G_g}=∅`.

### D. Obstruction test

```text
S_g rational exceptional conic bundle              PROVED
Condition (A)                                      PROVED
central fixed locus has no rational component       PROVED
S_g^G = empty                                      PROVED
```

### E. Outcome

Closed for every odd `g≥3`:

\[
S_g\text{ is not weakly }G_g\text{-versal}.
\]

This is an infinite rational conic-bundle family for which Condition (A) is not sufficient. See `THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`.

---

## 3. Rational genus-12 `V22` with `PSL2(F7)`

**Literature status:** `OPEN-CONFIRMED` through the search cutoff for equivariant unirationality/weak versality.

### A. Exact action

Let `C⊂P2` be the Klein quartic and

\[
X=\operatorname{VSP}(C,6).
\]

Cheltsov–Shramov identify `X` as a smooth rational prime Fano threefold of genus 12, degree 22, and Picard rank one, with faithful

\[
G=\operatorname{PSL}_2(\mathbf F_7)
\]

action. The action is `G`-birationally superrigid.

### B. Subgroup configuration

For an involution `σ∈G`,

\[
N=C_G(\sigma)\simeq D_8.
\]

This is the closest uncomputed analogue of the successful `V14` involution-centralizer configuration.

### C. Published preliminary gates

The Mori–Mukai family No. 1.10 containing `X` satisfies Condition (A) for every smooth member. Moreover,

\[
\operatorname{Pic}(X)=\mathbf Z[-K_X].
\]

The canonical bundle has its natural `G`-linearization, so the equivariant universal-torsor obstruction vanishes. The 2026 higher-Amitsur theorem then gives vanishing of every higher Amitsur obstruction.

```text
ordinary rationality                                PROVED IN LITERATURE
Condition (A)                                       PROVED IN LITERATURE
universal-torsor obstruction                        ZERO
all higher Amitsur groups                           ZERO
G-fixed point                                       ABSENT IN LITERATURE MODEL
G-unirationality / weak versality                    UNDECIDED
```

### D. Exact missing calculation

Compute scheme-theoretically

\[
X^\sigma
\quad\text{and}\quad
X^{D_8}.
\]

The VSP model and the anticanonical representation

\[
H^0(X,-K_X)\simeq\mathbf 1\oplus W_6\oplus W_7
\]

make this a finite invariant-theory calculation. The acceptance test is:

```text
(a) every D8-stable irreducible RCC subvariety of X^sigma is a point;
(b) X^D8 is empty.
```

If both pass, the residual-RCC centralizer theorem proves that `X` is not weakly `G`-versal.

### E. Assessment

This is the best remaining action: rational target, exact simple group, Condition (A) proved, all known cohomological invariants silent, and one finite fixed-scheme calculation separating the problem from a theorem.

---

## 4. Fermat-discriminant Fano conic bundle No. 2.18

**Literature status:** `PARTIALLY-COVERED`—automorphisms and projective linearizability are studied; equivariant unirationality is not decided.

### A. Exact action/model

Abe considers the rational double cover

\[
X_F\longrightarrow\mathbf P^1\times\mathbf P^2
\]

branched over the smooth `(2,2)` divisor determined by

\[
Q_1=ix^2+y^2,\qquad Q_2=z^2,\qquad Q_3=ix^2-y^2.
\]

Its conic-bundle discriminant is the Fermat quartic

\[
\Delta_F=\{x^4+y^4+z^4=0\}\subset\mathbf P^2,
\]

and `|Aut(X_F)|=192`. Abe also gives the specific subgroup

\[
G_1=\langle\alpha,\tau\rangle\simeq C_4\times C_2,
\]

where `τ` is the covering involution and

\[
\alpha([t_0:t_1],[x:y:z],w)
=
([it_0:-it_1],[ix:iy:z],w).
\]

This action is not projectively linearizable, although it has fixed points and is therefore weakly versal. Its `G_1`-unirationality remains a dominance question rather than an application of the central obstruction.

### B. Better nonabelian target

The full order-192 action, or a nonabelian subgroup mapping onto `S_3⊂Aut(Δ_F)` and containing the deck involution, is the relevant obstruction target. The deck-fixed surface is the branch surface, a degree-2 del Pezzo surface and therefore rational; the whole fixed surface is an allowed residual-stable RCC image.

### C. Exact missing work

```text
(a) choose and certify a nonabelian subgroup G with Condition (A) and X^G=empty;
(b) enumerate involution classes and centralizers;
(c) compute fixed curves and surfaces;
(d) classify residual-stable rational curves on the deck-fixed del Pezzo;
(e) prove connected exceptional-fiber/network propagation in dimension three.
```

The central fiber involution therefore supplies useful fixed geometry, but not a one-stratum contradiction. This is the best test bed for a genuinely three-dimensional fixed-network theorem.

---

## 5. Kummer double solid `X1` with a non-Q8 subgroup

**Literature status:** `PARTIALLY-COVERED`—Q8-containing actions are already cohomologically obstructed; the subgroup below is not.

### A. Exact action

Let

\[
X_1=\{w^2=x_1^4+x_2^4+x_3^4+x_4^4-4i x_1x_2x_3x_4\}
\subset\mathbf P(2,1,1,1,1),
\]

and let `\widetilde X_1` be the blowup of its 16 nodes. The known automorphism group is

\[
C_2^{\rm deck}\times(C_4^2\rtimes S_4).
\]

Take

\[
G_0=C_2^{\rm deck}\times(C_4^2\rtimes C_3),
\]

where `C3⊂S4` is generated by a 3-cycle. Its 2-Sylow is abelian, so it contains none of the Q8 subgroups responsible for the known nonzero third Amitsur obstruction.

### B. Subgroup configuration and fixed geometry

Use the central deck involution. Its fixed locus on the smooth model is the resolved Kummer K3 surface with the classical `16_6` configuration of 16 exceptional and 16 trope rational curves.

### C. Why the simple theorem fails

The fixed K3 contains distinguished rational curves. A residual-stable curve or fixed slice may receive the RCC source survivor, so the original no-rational-curves criterion is unavailable.

### D. Exact finite target

```text
(a) verify Condition (A) for G0;
(b) compute G0-orbits and stabilizers of the 32 distinguished curves;
(c) decide whether any irreducible rational curve is G0-stable;
(d) compute deeper fixed loci and normal characters at curve intersections;
(e) test \widetilde X_1^G0.
```

This is the cleanest remaining test of whether residual-RCC geometry improves on the published Kummer higher-Amitsur results.

## Final ordering

The first two actions are theorems. The unresolved order is:

1. rational `V22` with `PSL2(F7)`—best direct centralizer calculation;
2. Fermat-discriminant No. 2.18—best three-dimensional network laboratory;
3. the non-Q8 Kummer subgroup—best residual-rational-curve stress test.