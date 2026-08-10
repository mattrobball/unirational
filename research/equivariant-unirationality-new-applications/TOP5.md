# Top five actions: exact obstruction tests

## 1. Smooth quartic double solid with `(C7:C3) × C2deck`

Let

\[
B=2x_0^4+6x_0x_1x_2x_3+x_1x_3^3+x_1^3x_2+x_2^3x_3,
\qquad
X=\{w^2=B\}\subset\mathbf P(1,1,1,1,2).
\]

For a primitive seventh root `ζ`, set

\[
a=\operatorname{diag}(1,\zeta^4,\zeta^2,\zeta),
\qquad
b(x_0,x_1,x_2,x_3)=(x_0,x_2,x_3,x_1).
\]

Then `bab^{-1}=a^4`, so `H=<a,b>=C7:C3`. Let `τ:w↦-w` and `G=H×<τ>`.

Use the central deck involution. Its fixed locus is the smooth K3 surface `B`, with

\[
B^H=\varnothing,
\qquad
B^{C_7}=\{e_1,e_2,e_3\}.
\]

An `H`-stable rational curve would induce an action of `H` on its normalization. The kernel must contain the normal `C7`, because the nonabelian group of order 21 is not a finite subgroup of `PGL2`; the curve would lie in the finite set `B^{C7}`, a contradiction. Thus the K3 has no positive-dimensional `H`-stable RCC subvariety.

```text
Condition (A)                                      PROVED
residual-RCC fixed-locus hypothesis                PROVED
X^G                                                 EMPTY
equivariant universal-torsor obstruction           ZERO
all higher Amitsur groups                          ZERO
```

The residual-RCC central theorem gives

\[
\boxed{X\text{ is not weakly }G\text{-versal}.}
\]

The underlying smooth quartic double solid is classically unirational. See `THEOREM_KLEIN_QUARTIC_DOUBLE_SOLID.md`.

---

## 2. Odd exceptional conic bundles with `D_{2g} × C2`

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

The fixed locus of `j` is

\[
S_g^j=C_g:\ U^2=-T_0T_1(T_0^{2g}+T_1^{2g}),
\qquad g(C_g)=g.
\]

Moreover `C_g^{D_{2g}}=∅`, hence `S_g^{G_g}=∅`. Every abelian subgroup fixes a point: rotation subgroups fix the two ramification points over `0,∞`, and reflection subgroups fix points over their base eigendirections because `g+1` is even.

```text
S_g rational exceptional conic bundle              PROVED
Condition (A)                                      PROVED
central fixed locus has no rational component       PROVED
S_g^G                                               EMPTY
```

Thus for every odd `g≥3`,

\[
\boxed{S_g\text{ is not weakly }G_g\text{-versal}.}
\]

See `THEOREM_ODD_EXCEPTIONAL_CONIC_BUNDLES.md`.

---

## 3. Rational genus-12 `V22` with `PSL2(F7)` — DECIDED 2026-08-10: ROUTE BLOCKED

```text
V22-D8-GATE-FAILS      see EXIT_KLEIN_V22.md, verify with python3 verify_klein_v22.py
gate (a)  FAILS   X^sigma contains an irreducible D8-stable SMOOTH RATIONAL curve
gate (b)  HOLDS   X^{D8} = empty
```

Exact over `Q(sqrt(-7))` in Mukai's model `X = Gr(3,7) cap P^13` on the 7-dimensional irreducible of `PSL2(F7)` (the Cheltsov-Shramov net, arXiv:1010.1918 App. A + Thm 4.5), independently confirmed in Macaulay2 over `Q(sqrt(-7))` and mod 11, 23:

\[
X^{\sigma} = C \sqcup \{p_1,p_2\},\qquad
C\cong\mathbf P^1\ (\deg 6,\ \text{Hilbert polynomial }6i+1),\qquad
\chi(X^\sigma)=4 .
\]

`C` is the image of the smooth plane conic `(-32-32s)u1^2 + (48-16s)u2^2 - 64 u3^2 = 0` in `P(A_+) = P^2`, `s = sqrt(-7)`; the residual `D8/<sigma> = V4` acts on it as the Klein four-group in `PGL2`, fixed-point free, and swaps `p_1, p_2` (stabilizer `C4`) — hence `X^{D8} = empty`, but `C` is a `D8`-stable rational curve and gate (a) dies. The failure is character-forced (`chi_7(2A) = chi_3(2A) = -1`), and by Euler rigidity (`b_2 = 1, b_3 = 0` implies `chi(X^g) = 4` for every automorphism) no other element of `PSL2(F7)` can be substituted: its centralizer would be cyclic and gate (b) would fail outright. **`G`-unirationality and weak `G`-versality of this action remain open.**

The original work order is preserved below for the record.

**Literature status:** `OPEN-CONFIRMED` through the search cutoff for equivariant unirationality and weak versality.

Let `C⊂P2` be the Klein quartic and

\[
X=\operatorname{VSP}(C,6).
\]

Cheltsov–Shramov identify `X` as a smooth rational prime Fano threefold of genus 12, degree 22, and Picard rank one, with faithful

\[
G=\operatorname{PSL}_2(\mathbf F_7)
\]

action. The action is `G`-birationally superrigid.

The Mori–Mukai family No. 1.10 containing `X` satisfies Condition (A) for every smooth member. Since

\[
\operatorname{Pic}(X)=\mathbf Z[-K_X]
\]

and `-K_X` is canonically `G`-linearized, the equivariant universal-torsor obstruction and every higher Amitsur obstruction vanish.

The global fixed locus is empty by a short VSP argument. A `G`-fixed point of `VSP(C,6)` would give a `G`-stable length-six subscheme of the dual Klein plane. The irreducible three-dimensional representation has no projective fixed point, and every nontrivial projective orbit has size at least seven: an orbit of size at most six would give an injection of the simple group of order 168 into `S_6`, impossible by Lagrange. Hence no such length-six subscheme exists.

For an involution `σ∈G`,

\[
N=C_G(\sigma)\simeq D_8.
\]

The exact missing calculation is

\[
X^\sigma
\quad\text{and}\quad
X^{D_8}.
\]

The VSP model and the anticanonical representation

\[
H^0(X,-K_X)\simeq\mathbf1\oplus W_6\oplus W_7
\]

make this finite. The acceptance test is:

```text
(a) every D8-stable irreducible RCC subvariety of X^sigma is a point;
(b) X^D8 is empty.
```

If both pass, the residual-RCC centralizer theorem proves that `X` is not weakly `G`-versal. This is the best remaining target: rational, explicit, Condition (A) verified, all known cohomological invariants silent, no global fixed point, and one involution-centralizer computation between the question and a theorem.

---

## 4. Fermat-discriminant Fano conic bundle No. 2.18

**Literature status:** `PARTIALLY-COVERED`—automorphisms and projective linearizability are studied; equivariant unirationality is not decided.

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

and `|Aut(X_F)|=192`. Abe's explicit subgroup

\[
G_1=\langle\alpha,\tau\rangle\simeq C_4\times C_2^{\rm deck}
\]

is not projectively linearizable, but it has a fixed point and is therefore weakly versal. Its `G_1`-unirationality remains a dominance question.

The relevant obstruction target is instead the full order-192 action or a nonabelian subgroup mapping onto `S3⊂Aut(Δ_F)` and containing the deck involution. The deck-fixed branch surface is a rational degree-2 del Pezzo, so the whole fixed surface is an allowed residual-stable RCC image. The needed work is:

```text
(a) freeze a nonabelian subgroup with Condition (A) and X^G=empty;
(b) enumerate involution classes and centralizers;
(c) compute fixed curves and surfaces;
(d) classify residual-stable rational curves on the deck-fixed del Pezzo;
(e) prove connected exceptional-fiber/network propagation in dimension three.
```

This is the best test bed for a genuinely three-dimensional fixed-network theorem.

---

## 5. Kummer double solid `X1` with a non-Q8 subgroup

**Literature status:** `PARTIALLY-COVERED`—Q8-containing actions are already cohomologically obstructed; the subgroup below is not covered by that criterion.

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
G_0=C_2^{\rm deck}\times(C_4^2\rtimes C_3).
\]

Its 2-Sylow is abelian, so it contains none of the Q8 subgroups responsible for the published nonzero third Amitsur obstruction. The deck-fixed locus is the resolved Kummer K3 surface with the classical 16 exceptional and 16 trope rational curves.

The exact finite target is:

```text
(a) verify Condition (A) for G0;
(b) compute G0-orbits and stabilizers of the 32 distinguished curves;
(c) decide whether any irreducible rational curve is G0-stable;
(d) compute deeper fixed loci and normal characters at curve intersections;
(e) test \widetilde X_1^G0.
```

This is the cleanest remaining stress test of the residual-RCC refinement in the presence of many rational curves.

## Final ordering

The first two actions are theorems. The `V22` centralizer calculation has now been done and that route is blocked (`EXIT_KLEIN_V22.md`). The unresolved order is:

1. Fermat-discriminant No. 2.18—best three-dimensional network laboratory;
2. non-Q8 Kummer subgroup—best residual-rational-curve stress test;
3. `V22` with `PSL2(F7)`—reopens only if the theory task `V22-D8-NORMAL-CHAIN` is closed, since gate (b) already holds there.