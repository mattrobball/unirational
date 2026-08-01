M2-EXPLICIT-LINK-PASS

# Goal M2 status

## Verdict

Over the genuine projective Schur generic field

\[
K=K_{\rm Schur}=\mathbf C(\mathbf P(V_6))^G,
\qquad G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

the generic Klein twist admits an exact type-I Sarkisov link

\[
X_T\xleftarrow{\ \pi\ }
Y=\operatorname{Bl}_{C_{012}}(X_T)
\xrightarrow{\ f\ }\mathbf P^1_K,
\]

where \(C_{012}=X_T\cap\{a_3=a_4=0\}\) is a smooth plane cubic
in the equal-degree Schur Reynolds frame. The endpoint is a degree-3 del
Pezzo Mori fibre space with relative Picard rank one.

The coordinate plane is not merely generically smooth. An exact good-prime
witness proves that it is simultaneously disjoint from all 55 involution
minus-lines. Their connected \(D_{12}\)-orbit therefore becomes a degree-55
multisection, while the exceptional divisor supplies a degree-3
multisection. The generic cubic surface has index one. Voisin's theorem then
gives the unconditional alternative

\[
\text{rational section}\quad\text{or}\quad
\text{integral degree-4 multisection}.
\]

No branch of that alternative is selected here. A multisection is not
promoted to a section, so the Problem E headline remains **OPEN**. The exact
goal exit is `M2-EXPLICIT-LINK-PASS`, not either headline exit.

## Replay

From `goals_2026-08-01` run the authored copy:

```sh
/opt/homebrew/bin/python3 M2_EQUIVARIANT_SARKISOV_CODEX_ROOT_20260801/verify.py
```

The byte-identical nominal installation also replays from the Problem E
root with:

```sh
/opt/homebrew/bin/python3 goal_runs_after_35fa/M_SARKISOV/verify.py
```

The replay checks the sealed inputs, reconstructs the projective Schur frame,
the plane equation and all smoothness charts, enumerates all 55 involution
lines and proves simultaneous disjointness, recomputes the line normal
bundle witness, and verifies the Cox/intersection payload.

## Repository state

- goal pinned state: `35fa8f59b6a1423cc89300aeaceefe91552be5ba`;
- worker entry HEAD: `37d61c19a108781cf74af837e24810a9f7f7c3be`;
- produced state: isolated, uncommitted packet under this directory;
- no sibling worker directory is part of the seal.
