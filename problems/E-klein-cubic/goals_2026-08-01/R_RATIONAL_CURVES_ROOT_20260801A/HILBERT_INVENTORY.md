# Hilbert-scheme inventory through degree five

## Cutoff and ranking

The exact inventory cutoff is \(e_0=5\).  It is chosen because degrees two
and three admit all-smooth-cubic residual or compactification theorems,
degree four is the first Abel--Jacobi fibre of essential dimension three,
and degree five is the first Serre/Pfaffian component on which the generic
Schur class gives an exact descent obstruction.

This is a ranked structural inventory, not an assertion that degrees above
five are unnecessary.

## Degree ledger

| Degree | Geometric locus over \(\mathbf C\) | Geometry | Result over \(K_{\rm proj}\) |
|---:|---|---|---|
| 1 | Fano surface \(F(X)\) of lines | smooth projective surface | empty by the binding no-line theorem |
| 2 | geometrically integral conics | every conic spans a plane and has a residual line | **empty**, for all integral conics |
| 3 | plane integral rational cubics | discriminant locus among plane sections | any point gives a \(K\)-point of \(X_T\) via the unique singular point |
| 3 | generalized twisted cubics | smooth open of dimension 6; Abel--Jacobi image \(\Theta\), generic fibre \(\mathbf P^2\) | any compactified Hilbert point maps to the exceptional \(X_T\) over zero |
| 4 | rational normal quartics | locally smooth dimension 8; Abel--Jacobi target dimension 5 | every \(K\)-point must lie over the unique \(q_4\); existence is open and headline-positive |
| 5 | elliptic normal quintics | smooth dimension-10 open; \(\mathbf P^5\)-bundle over a 5-fold bundle moduli space | **empty** on the genuine twist: the only possible fibre is nonsplit \(\operatorname{SB}(A_{\rm proj}^{op})\) |
| 5 | geometrically rational quintics | expected dimension 10 at unobstructed curves; no all-smooth-cubic compactification theorem used here | open; odd hyperplane degree splits the normalization, so a Hilbert point is immediately headline-positive |

## Abel--Jacobi target ledger

Let \(J_e\) denote the degree-\(e\) cycle torsor.  The exact cohomology
calculation proves

\[
{}^T J_e(K)=\{q_e\}\quad\text{for every }e,
\qquad q_{e+3}=q_e+[H^2].
\]

Therefore an Abel--Jacobi component does not fail because its target torsor
has no point.  Instead, every candidate is forced into one distinguished
fibre.  The fibre behavior through degree five is:

| Locus | Distinguished fibre |
|---|---|
| conics | disjoint from \(q_2\), since otherwise residual-line descent gives a line |
| twisted cubics | zero fibre of the theta blowup, equal to \(X_T\) |
| rational quartics | a dimension-three fibre over \(q_4\); structure for the Klein cubic is the exact open gate |
| elliptic normal quintics | nonsplit Severi--Brauer fivefold over \(q_5=q_2+[H^2]\); no \(K\)-point |

## Quartic hypothesis boundary

Two primary results must not be conflated.

1. Beauville's fixed-line construction works for every smooth cubic and
   gives, after selecting a line \(\ell\), a family of quartics meeting
   \(\ell\) twice whose Abel--Jacobi map is surjective with rational general
   fibre.  The generic twist has no \(K\)-line, so this auxiliary choice does
   not descend.
2. Iliev--Markushevich identify a generic quartic Abel--Jacobi fibre as a
   smooth irreducible threefold birational to \(X\), but assume both a
   generic cubic and a generic target point.  The Klein cubic and \(q_4\)
   are special.

Thus the quartic row is an exact reduction, not an emptiness or existence
claim.

## Genus-zero index control

For a geometrically rational curve \(C/K\), the normalization is a
genus-zero curve and splits over an extension of degree at most two.  A point
over that extension is a quadratic point of the honestly embedded cubic.
Third intersection with its conjugate descends a \(K\)-point unless the
joining line lies on the cubic, already excluded.  Consequently any
\(K\)-Hilbert point representing a geometrically integral rational curve is
headline-positive, even in even degree.  In odd degree, the pullback of
\(\mathcal O(1)\) already has odd degree and forces the normalization itself
to split.

## Higher-degree ledger

| Candidate | What is known here | Exact missing datum |
|---|---|---|
| rational quintics | a descended integral curve would solve the headline | an Aut\((X)\)-equivariant compactification and a \(K\)-Hilbert point |
| rational curves of degree \(e\ge6\) | unobstructed curves have expected dimension \(2e\) | no bounded cutoff and no descended integral Hilbert point |
| curves through a degree-55 orbit | the orbit may impose incidence conditions | an exact component over the genuine \(K_{\rm proj}\), not the distinct Schur-source field |

## Prohibited inferences checked

- A Galois-stable component is not treated as a \(K\)-point.
- A reducible cycle is not treated as a rational curve.
- The unique Abel--Jacobi value is not treated as a Hilbert point.
- The nonsplit Severi--Brauer fibre is not treated as projective space.
- Generic-cubic quartic geometry is not specialized to the Klein cubic.
- Elliptic quintic emptiness is not promoted to all degree-five curves.
- A degree cutoff is not promoted to an all-degree theorem.

