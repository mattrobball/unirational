# Ranked admissible-center census

This census is over the genuine Schur field \(K=K_{\rm Schur}\). A row marked
"unavailable" is not assigned invented normal-bundle data: the reason no
actual center exists is part of the decision.

| rank | candidate | field and geometry | normal / discrepancy / Picard jump | decision |
|---:|---|---|---|---|
| 1 | Schur-frame plane cubic \(C_{012}\) | \(K\); smooth \((g,d)=(1,3)\) | \(\mathcal O_C(1)^\oplus2\); `1`; `+1` | **selected**; exact dP3 fibration |
| 2 | degree-55 closed point \(Z_{55}\) | residue field \(E^{D_{12}}/K\); geometrically 55 reduced points | rank-3 tangent space; `2`; `+1` | exact arithmetic point, but ordinary blowup has \((-K)^3=24-8\cdot55=-416\), hence is not weak Fano |
| 3 | involution minus-line orbit | one line over \(E^{D_{12}}\); 55-line orbit over \(K\) | \(N_{L/X}=\mathcal O_L^\oplus2\); `1`; `+1` for one line | individual line gives classical conic-bundle link only after degree 55; full orbit union has triangle intersections and is not a smooth center; used as multisection |
| 4 | Goal R rational curves | no line/conic; a generalized twisted-cubic Hilbert point already forces a twist point; higher rational curves unresolved | n/a | no independent descended center |
| 5 | Goal S19 curve | literal target empty; corrected degree-19 ambient-curve problem unresolved | n/a | no certified curve center |
| 6 | Pfaffian projector/common line | no projector in the distinguished five-plane and no common isotropic line | n/a | no F14 center or link available |
| 7 | \(A_4\) geometry | subgroup twists are positive; \(A_4\) character points are off \(X\) | n/a | subgroup solubility does not descend a genuine-\(G\) center |
| 8 | two \(A_5\) classes | both exact maximal-subgroup twists remain unresolved | n/a | no center produced |
| 9 | \(D_{12}\) geometry | exactly the degree-55 involution-line construction above | \(\mathcal O_L^\oplus2\); `1`; `+1` over residue field | fully consumed as the horizontal multisection |
| 10 | target branch/singular center | fixed-frame target-branch implication is refuted as a genuine-twist bridge; normalization data remain insufficient | n/a | not a center on \(X_T\) |

## Exact line-normal computation

For the standard involution \(S\), reduce the exact cyclotomic representation
at \((331,\zeta_{11}=270)\). The minus-eigenspace basis in the payload gives
the normal sequence

\[
0\to N_{L/X}(-1)\to\mathcal O_L^3
\longrightarrow\mathcal O_L(2)\to0.
\]

In the monomial basis \((u^2,uv,v^2)\), the map on global sections is

\[
\begin{pmatrix}
39&195&85\\
160&139&185\\
90&74&58
\end{pmatrix}
\quad\text{with determinant }222\ne0\pmod{331}.
\]

Thus \(H^0(N_{L/X}(-1))=0\). Since \(\deg N_{L/X}=0\), the possible cubic
line splittings give

\[
N_{L/X}=\mathcal O_L\oplus\mathcal O_L,
\]

not \(\mathcal O_L(1)\oplus\mathcal O_L(-1)\).

## Standard smooth weak-Fano curve routing

For a smooth geometrically integral curve \((g,d)\) on a cubic threefold,

\[
(-K_{\operatorname{Bl}_C X})^3=22-4d+2g.
\]

The classical ten numerical types are:

| \((g,d)\) | volume | output |
|---|---:|---|
| \((0,1)\) | 18 | conic bundle |
| \((0,2)\) | 14 | dP4 fibration after flop |
| \((0,3)\) | 10 | terminal Fano after flop |
| \((1,3)\) | 12 | dP3 fibration; selected |
| \((1,4)\) | 8 | divisorial anticanonical contraction |
| \((4,6)\) | 6 | divisorial anticanonical contraction |
| \((0,4)\) | 6 | point on \(V_{14}\) |
| \((0,5)\) | 2 | cubic self-link |
| \((1,5)\) | 4 | curve on \(V_{14}\) |
| \((2,6)\) | 2 | cubic self-link |

This standard table is not claimed to classify singular, weighted, or every
semilinear center. Such exhaustiveness would be needed for a rigidity exit,
which is not claimed.

