G7-CROSS-CLASS-PROJECTOR-PASS

# Goal G7A status — exact two-class design and projectors

**Primary exit:** `G7-CROSS-CLASS-PROJECTOR-PASS`  
**Also achieved:** `G7-PALEY-BIPLANE-IDENTIFIED`  
**Module correction recorded:** `Ind = 1+10` (naive `1+5+5` / `1⊕W⊕W'` refuted)  
**Headline:** OPEN (structural; not a Problem-E decision)  
**Stages:** G7.0, G7.1 only (no G7B cycles, no G7C geometry)

## Decision

### G7.0 — two-class subgroup geometry

1. Reconstructed \(G=\mathrm{PSL}_2(\mathbf F_{11})\) order 660 from installed
   Möbius generators \(S,T\).
2. Found all 22 maximal A5 subgroups; split into two conjugacy classes of size 11.
3. All 121 cross-intersections: 55 of type A4 (order 12), 66 of type D5 (order 10).
4. Exactly two G-orbits on \(\mathcal H\times\mathcal K\) (sizes 55 and 66).
5. Incidence \(N\) from A4-intersections is 5-regular; identities
   \(NN^t=N^tN=3I+2J\) hold exactly ⇒ symmetric **2-(11,5,2)** Paley biplane.
6. Installed \(G\) acts as Aut(design), image order 660.

### G7.1 — projectors / constituents

1. Both permutation modules: **\(1\oplus 10\)** over \(\mathbf Q\), 10 absolutely irreducible.
2. Naive \(1\oplus W\oplus W'\) (Klein/companion 5s) **refuted** for these Ind modules.
3. Klein/companion 5s: character field \(\mathbf Q(\sqrt{-11})\), Galois swaps them;
   not summands of either degree-11 perm module.
4. Projectors \(P_1=J/11\), \(P_{10}=I-P_1\) over \(\mathbf Q\).
5. \(N\) intertwines: eigenvalue 5 on trivials; on augmentations
   \(N^{-1}=\frac1{3}N^t\) exactly (char ≠ 3).

## Nonclaims

- No induced point coordinates (G7B).
- No projective scaling / geometry (G7.2–G7.C).
- Does not reseal H_A5 or G4.
- Does not claim a \(K_{\rm proj}\)-point of \(X_{\rm gen}\).

## Peak resource

Producer wall ≈ 0.45 s; peak RSS ≈ 62.4 MB.

## Replay

See `REPLAY.md`. Marker: `G7A_VERIFY_DESIGN_OK`.
