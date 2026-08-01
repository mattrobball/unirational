R2-DESCENT-OBSTRUCTED

# Goal R2 status

## Verdict

The selected Pfaffian elliptic-quintic/residual-quartic route is
**unconditionally descent-obstructed on the genuine projective generic
twist**. The Problem E headline remains **OPEN**: this packet neither
constructs nor excludes a \(K_{\rm proj}\)-point of the Klein twist.

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
K=K_{\rm proj}=\mathbf C(\mathbf P(W))^G.
\]

The exact selected-component theorem is:

1. Over the splitting field, the Pfaffian kernel bundle \(E_0\) has
   \(H^0(E_0(1))=V_6^*\). The universal section-zero curve is given by

   \[
   A(x)\lambda=0,\qquad
   M(x)A(x)=\operatorname{Pf}(M(x))I_6.
   \]

2. The producer proves exactly that \(\operatorname{Pf}(M(x))\) is a nonzero
   scalar multiple of the original Klein cubic. Independent good reduction
   verifies a smooth geometrically integral elliptic normal quintic of degree
   five, Hilbert polynomial \(5t\), tangent dimension \(10\), and
   \(H^1(N_{C/X})=0\).
3. Exact period-lattice and group-cohomology certificates give

   \[
   J(\mathbf C)^G=0,\qquad H^1(G,J[3])=0.
   \]

   Hence the degree-two Abel--Jacobi torsor has one fixed point \(q_2\), and
   the only possible descended bundle is \(E_0\).
4. The Hilbert fibre over \(E_0\) twists to

   \[
   {}^T\mathbf P(V_6^*)=\operatorname{SB}(A_{\rm proj}^{\rm op}).
   \]

   The pinned Schur-class certificate proves
   \(\operatorname{ind}(A_{\rm proj})=2\), so this fibre and therefore the
   entire selected Hilbert component have no \(K\)-point.

Thus the universal family descends as a family over a Severi--Brauer
fivefold of index two, but it has no base-field member. This is a genuine
descent obstruction, not a failure to find coordinates.

## Scope

The result closes the elliptic-normal-quintic route and its proposed
cubic-scroll residual-quartic extraction over \(K_{\rm proj}\). It does not
exclude:

- unmarked rational quartics or rational quintics;
- higher free rational curves;
- incidence constructions through the degree-55 orbit;
- the corresponding Schur-source route over the distinct field
  \(K_{\rm Schur}\), where this particular Brauer class splits;
- any other route to a point on the genuine twist.

`CLASS_RANKING.md` records the full R2.0 ranking and exact open rows.
`COMPLETION_AUDIT.md` maps every work package and output requirement to its
evidence or its obstruction-exit boundary.

## Replay

From this directory:

```text
/opt/homebrew/bin/python3 produce_pfaffian_universal.py
/opt/homebrew/bin/python3 verify_pfaffian_universal.py
/opt/homebrew/bin/python3 produce_descended_component.py
/opt/homebrew/bin/python3 verify_descended_component.py
/opt/homebrew/bin/python3 verify_all.py --full
/opt/homebrew/bin/python3 make_seal.py
/opt/homebrew/bin/python3 verify_seal.py
```

Required final markers:

```text
R2_PFAFFIAN_UNIVERSAL_INDEPENDENT_VERIFY_OK
R2_DESCENDED_COMPONENT_INDEPENDENT_VERIFY_OK
R2_PACKET_FULL_VERIFY_OK
R2_SEAL_VERIFY_OK
```

## Repository boundary

- pinned R2 state: `35fa8f59b6a1423cc89300aeaceefe91552be5ba`;
- live state audited: `37d61c19a108781cf74af837e24810a9f7f7c3be`;
- no concurrent file outside the R2 output directory was edited or staged.

