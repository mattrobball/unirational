# R2.0 curve-class ranking on the genuine generic twist

## Dimension rule

For a smooth embedded rational curve \(C\subset X\) of degree \(e\) on a
smooth cubic threefold,

\[
\chi(N_{C/X})=(-K_X)\cdot C=2e.
\]

At a free/unobstructed curve, \(H^1(N_{C/X})=0\), so the Hilbert component
has expected dimension \(2e\). The once-marked universal curve has expected
evaluation fibre dimension \(2e-2\) over \(X\); with two marks the expected
fibre dimension over \(X^2\) is \(2e-4\).

These expected dimensions are rankings, not component-existence theorems.

## Ranked ledger

| Rank | Class | Dimension | Descent and evaluation status | R2 decision |
|---:|---|---:|---|---|
| 1 | lines | \(2\) | the twisted Fano surface has no \(K_{\rm proj}\)-point | **empty**, binding theorem |
| 2 | integral conics | \(4\) | every conic spans a plane and leaves a residual \(K\)-line | **empty**, all integral conics |
| 3 | plane rational cubics | discriminant inside the 6-fold of planes | the unique geometric singular point is \(K\)-rational | any member is headline-positive |
| 4 | generalized twisted cubics | \(6\); AJ image \(\Theta\), general fibre \(\mathbf P^2\) | the distinguished zero fibre of the theta blowup is \(X_T\) | Hilbert point is headline-equivalent |
| 5 | rational normal quartics | \(8\); canonical AJ zero fibre expected dimension \(3\) | the all-smooth theorem controls a general fibre, not the distinguished Klein fibre | **first open rational class** |
| 6 | quartic plus a marked chord line in \(X\) | \(8\); finite degree-16 chord incidence | a descended marked pair maps to the twisted Fano surface | marked incidence empty; unmarked quartic open |
| 7 | rational quintics | \(10\); canonical AJ zero fibre expected dimension \(5\) | a descended curve is headline-positive; zero fibre not pointed | open |
| 8 | elliptic normal quintics for scroll residuation | \(10\); \(\mathbf P^5\)-bundle over a 5-fold | unique possible fibre is nonsplit \(\operatorname{SB}(A_{\rm proj}^{op})\) of index \(2\) | **selected: descent-obstructed** |
| 9 | free rational curves, \(e\ge6\) | \(2e\) | no audited equivariant compactification or distinguished-fibre point | open, not selected |
| 10 | curves through the degree-55 closed orbit | expected \(2e-110\) for 55 independent point conditions | first naive nonnegative degree \(e=55\); special dependencies unproved | high-degree open route |

## Abel--Jacobi ranking correction

The classical Abel--Jacobi map is defined only after choosing a reference
curve. For descent, the canonical Aut\((X)\)-equivariant normalization is

\[
a_e(C)=\operatorname{AJ}(3[C]-eH^2).
\]

The exact group-cohomology calculation strengthens the earlier zero-origin
statement: every degree torsor \(J_e\) has one fixed point. Therefore every
descended low-degree curve is forced into one distinguished fibre. General
fibre unirationality does not point that fibre.

## Selected class: why elliptic quintics

The elliptic-normal-quintic component is the first ranked class with all of
the following simultaneously available:

- an all-smooth-cubic Hilbert/Serre description;
- an exact Pfaffian kernel bundle for the Klein cubic;
- a six-dimensional section space with an identified projective \(G\)-action;
- explicit universal equations;
- an exact Brauer obstruction on the genuine projective torsor;
- a classical residual rational-quartic construction whose extra
  \(\operatorname{Pic}^2\) descent gate can be stated exactly.

It therefore supports a theorem-level `R2-DESCENT-OBSTRUCTED` exit. The
unmarked rational-quartic and rational-quintic rows do not: their special
zero fibres remain genuinely open.

## Degree-55 field boundary

The accepted degree-55 point belongs to the Schur-side construction. It is
not silently transported from

\[
K_{\rm Schur}=\mathbf C(\mathbf P(V_6))^G
\]

to the distinct projective generic field \(K_{\rm proj}\). A route through
that orbit must construct its incidence component over the field actually
used and then verify the appropriate generic-twist bridge.

