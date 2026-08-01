# Goal V decision theorem

## Verdict

The valuation route exits **`V-UNDECIDED`**.  No completion of the genuine
generic Klein twist is proved pointless, so neither
`V-VALUATION-HEADLINE-NEGATIVE` nor a negative answer to Problem E is
available.

The route nevertheless admits three unconditional structural closures, one
new exact family of local-solubility results, and one scoped $f_5$ exclusion.

## Theorem 1 — all index-three specialization exits are impossible

Let $Y$ be any twist of the Klein cubic over a field $K/\mathbf C$.  The
fixed points of $C_{11},C_5,V_4,C_3$ give effective zero-cycles on $Y$ of
degrees

\[
60,\qquad132,\qquad165,\qquad220.
\]

Their gcd is one; explicitly

\[
-13\cdot60+3\cdot132+165+220=1.
\]

After every scalar extension, including every henselian or completed valued
field, the base-changed cycles have the same total degrees.  Hence every such
base change has index one.

Consequences for every valuation of the genuine generic field:

1. a proper model cannot force generic index divisible by three;
2. a specialization theorem cannot force its zero-cycle degree subgroup to
   be $3\mathbf Z$;
3. no residue obstruction that is proved to preserve absence of
   prime-to-three zero-cycles can apply.

Each conclusion would contradict the already existing local degree-one
zero-cycle.  Thus the first three proposed negative mechanisms in Goal V are
not merely unfound; they are globally incompatible with the genuine twist.

This does **not** turn index one into a rational point.  That implication for
cubic hypersurfaces is the Cassels--Swinnerton-Dyer point-versus-zero-cycle
problem and is not used here.

## Theorem 2 — ordinary Brauer evaluation cannot supply the missing exit

For a smooth cubic threefold $Y/K\subset\mathbf P^4_K$, geometric Lefschetz
and the complex comparison theorem give

\[
\operatorname{Pic}(Y_{\bar K})=\mathbf Z[H],\qquad
\operatorname{Br}(Y_{\bar K})=0.
\]

The hyperplane class is defined over $K$, so
$H^1(K,\operatorname{Pic}(Y_{\bar K}))=0$.  The Hochschild--Serre sequence,
together with the degree-one zero-cycle (which makes
$\operatorname{Br}(K)\to\operatorname{Br}(Y)$ injective), yields

\[
\operatorname{Br}(Y)=\operatorname{Br}(K).
\]

Therefore there is no nonconstant ordinary Brauer class whose evaluation on
sections can obstruct a local point.  Higher unramified cohomology is not
computed here and is not claimed to vanish.

## Theorem 3 — five genuine generic-field divisors are locally soluble

Put

\[
K_{\rm aff}=\mathbf C(W)^G,
\quad
\Phi(a)=F(a_0x+a_1C+a_2D+a_3E+a_4K),
\]

where the exact Hilbert--90 frame columns have degrees $1,4,5,6,7$.  For
$V_i\in\{x,C,D,E,K\}$, set $P_i=F(V_i)$.  Then:

- $P_i$ is an absolutely irreducible invariant form of degree
  $3,12,15,18,21$, respectively;
- the invariant divisor valuation of $K_{\rm aff}$ below $P_i=0$ is
  unramified, with $P_i$ as a uniformizer;
- the proper integral model
  \(
  \operatorname{Proj}R_v[a_0,\ldots,a_4]/(\Phi)
  \)
  has the coordinate point $e_i$ on its special fibre;
- at least one derivative
  \(
  \partial\Phi/\partial a_j(e_i)
  \)
  is a unit.

Consequently $e_i$ lifts by multivariate Hensel to a point over the
completion $K_{{\rm aff},v}$.  The first two divisors are the natural
boundaries

\[
P_x=f_3,\qquad P_C=f_{12}.
\]

Absolute primality is certified by smooth plane sections over
\(\overline{\mathbf F}_{23}\), not merely by factorization over
\(\mathbf Q\).  Transversality and frame invertibility are independently
witnessed on each divisor modulo 23.  The producer uses Macaulay2 for the
gradient ideals; the verifier reconstructs the plane identities by an exact
interpolation grid and recomputes smoothness with Singular.

These are local points on the **genuine affine generic twist**, not on the
auxiliary Pfaffian characteristic cubic.  They do not descend to a global
$K_{\rm aff}$-point.

## Theorem 4 — the canonical $f_5$ Hessian line does not produce a point

The repository's literal degree-five invariant satisfies

\[
\det\operatorname{Hess}(F)=32f_5.
\]

At the generic point of $H=(f_5=0)$, let
$y=\operatorname{adj}(\operatorname{Hess}(F))e_0$.  Exact polynomial
division gives

\[
F(sx+ty)=s^3f_3+t^3F(y)\quad\text{in }\mathbf C(H)[s,t].
\]

An independently checked characteristic-23 transverse witness lifts to a
geometric divisor $Z\subset(f_3=f_5=0)$ in characteristic zero with

\[
\operatorname{ord}_Z(f_3)=1,
\qquad
\operatorname{ord}_Z(F(y))=0.
\]

Thus $-f_3/F(y)$ is not a cube in $\mathbf C(H)$.  The canonical projective
line $\langle x,\ker\operatorname{Hess}(F)_x\rangle$ has no generic rational
intersection point with the Klein cubic.  This excludes one canonical point
construction on the genuine $f_5$ residue twist; it does **not** prove that
the full residue cubic is pointless.  The exact identity, noncube witness,
and independent replay are in `HESSIAN_LINE.md` and `hessian_line.json`.

## Theorem 5 — discrete rank-one empty tropicalization is impossible

Let $v$ be a discrete rank-one valuation, normalized to value group
$\mathbf Z$, and let $c_i$ be the valuations of the five nonzero pure-cube
coefficients of the exact 35-term equation $\Phi$.  Two $c_i$ are congruent
modulo three.  On the binary Newton edge between the corresponding pure
cubes, the lower Newton polygon has total horizontal length three.

If it has more than one edge, one edge has length one, hence integral slope.
If it has one edge, its length is three and its slope is integral because its
endpoint heights are congruent modulo three.  Choose the difference of the
two coordinate weights to be the negative of this slope, and give the other
three coordinates sufficiently large integral weights.  At least the two
terms on the chosen edge attain the minimum.  Thus the tropical hypersurface
contains an integral projective value vector.

This rules out a rank-one proof based solely on empty tropicalization.  It
does not produce a valued-field point: the relevant residue initial form may
still be pointless.  It also does not cover higher-rank value groups.
`verify_tropical_rank_one.py` independently reconstructs the 35-term support,
the five pure cubes, the modulo-three pigeonhole step, and every possible
lower-edge length composition.

## Tropical boundary

A non-monomial homogeneous polynomial always has a nonempty tropical
hypersurface: a lower face of its lifted Newton polytope contains at least two
terms after a suitable weight.  Thus pure Newton-polytope nonintersection
cannot settle this single cubic equation.  Any viable tropical negative proof
must additionally show that every relevant initial form has no point over the
actual residue field, in every projective chart and for every cancellation
pattern.  No such exhaustive initial-form theorem is proved.

## Exact remaining terminal theorem

The smallest concrete successor is the genuine $(f_5=0)$ boundary (not the
already soluble auxiliary Pfaffian $D_5$ curve): construct its proper smooth
integral Hilbert--90 model on one certified open and decide whether its
special cubic, away from the excluded canonical Hessian-kernel line, over

\[
\mathbf C(f_5=0)^G
\]

has a rational point.  A proved nonpoint would give a pointless completion
and the headline-negative bridge.  A point would retire this valuation.  Its
index is already one, so the decision must use residue arithmetic beyond
component multiplicities, degree subgroups, and the ordinary Brauer group.

## Replay

From `problems/E-klein-cubic/goals_2026-08-01`:

```sh
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/produce_axis_divisors.py
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/verify_axis_divisors.py
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/produce_hessian_line.py
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/verify_hessian_line.py
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/verify_tropical_rank_one.py
```

Required final markers:

```text
V_AXIS_DIVISORS_PRODUCED
V_AXIS_DIVISORS_INDEPENDENT_ACCEPT
V_F5_HESSIAN_LINE_PRODUCED
V_F5_HESSIAN_LINE_INDEPENDENT_ACCEPT
V_RANK_ONE_TROPICAL_SUPPORT_ACCEPT
```
