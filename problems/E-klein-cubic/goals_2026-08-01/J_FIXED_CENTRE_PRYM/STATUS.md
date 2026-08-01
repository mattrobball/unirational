J-INVARIANT-TOO-WEAK

Overall Problem E headline: **OPEN**

# Goal J status

## Binary route verdict

Goal J is completely decided in the permitted route-level sense: the proposed
resolved fixed-centre Albanese/Prym/Hodge package is **not an obstruction** to
all equivariant resolutions.  The data named in the goal are independently
stabilizable by smooth equivariant blowups of a tower over
\(\mathbf P(W)\).  Consequently the proposed source class is not disjoint
from the target class, and J4's required global-incompatibility theorem is
false without extra base-ideal/landing-equation restrictions.

This is the exact exit `J-INVARIANT-TOO-WEAK`.  It is not a headline negative
result, and the overall headline remains OPEN: this packet neither constructs
a dominant \(G\)-map nor proves that one cannot exist.

## Repository state

- Pinned mathematical baseline consumed:
  `715faf441289e2589b9325311b6613ea0331bf88`.
- Live repository commit consumed:
  `2140419410cfff2f7d7dcca166acef8c16a0d41b`.
- Produced commit: `NONE` — this isolated goal workspace has read-only Git
  metadata; the packet is an uncommitted worktree artifact.
- All writes are contained in `goals_2026-08-01/J_FIXED_CENTRE_PRYM/`.
- This packet modifies no sibling path; concurrent sibling worktree changes
  were preserved.

## Decisive findings

1. The residual \(S_3\)-action on \(E_t\) has affine Albanese class of exact
   order three.  Its period and equivariant index are both three.
2. Translation acts trivially on Pic^0.  On \(H^{1,0}(E_t)\), the residual
   character is sign, not the affine translation character.  Thus the old
   identification of affine action with pullback on \(\operatorname{Pic}^0\)
   is invalid.
3. The fixed-blowup formula proves the intended propagation theorem only
   conditionally: if a fixed component first maps nonconstantly to \(E_t\),
   it must inherit an \(E_t\)-quotient from a positive-irregularity fixed
   part of a centre.  Equivariant dominance alone does not force such a
   component, because taking fixed loci does not preserve surjectivity.
4. The literal \(55\)-elliptic target arrangement is already a
   \(G\)-stable subvariety of the source ambient \(\mathbf P(W)\).  Its
   equivariant embedded resolution and subsequent blowup insert the same
   affine Albanese, marked generalized-Jacobian, norm, and incidence data
   into a source tower.
5. A separate free-orbit stabilization inserts any required rational
   \(G\)-Hodge/isogeny factor, including \(H^3(X)(1)\), without changing any
   nontrivial-subgroup fixed locus.  After averaging, its induced polarization
   is a positive rational multiple of the natural theta polarization.

Items 4 and 5 can be combined because their centres may be chosen disjoint.
Hence Albanese/Prym incidence data and Hodge/isogeny data cannot jointly give
the demanded class separation.

## Work-package audit

| package | decision | evidence |
|---|---|---|
| J0 | completed, with correction | `ONE_MOTIVE.md`, finite \(H^1(S_3,\mathbf Z/3_{\rm sign})\) enumeration |
| J1 | completed | `BLOWUP_FORMULA.md` |
| J2 | completed at the exact necessary Hodge boundary | `HODGE_ISOGENY.md`; fixed elliptic channel is killed, free-orbit channel survives |
| J3 | exhaustive for the invariant-only route | `CENTRE_REALIZABILITY.md`; explicit admissible stabilizations realize the data |
| J4 | refuted | source/target invariant classes overlap; extra landing/base constraints are indispensable |

## Replay

From this directory:

```sh
/opt/homebrew/bin/python3 produce.py
/opt/homebrew/bin/python3 make_seal.py
/opt/homebrew/bin/python3 verify.py
```

Expected markers:

```text
J_FIXED_CENTRE_PRYM_PRODUCE_OK
J_FIXED_CENTRE_PRYM_SEAL_OK
J_FIXED_CENTRE_PRYM_VERIFY_OK
```

The verifier independently enumerates cocycles and coboundaries, recomputes
the marked permutation lattices, checks the load-bearing character
multiplicities and source hashes, and checks every file in `SEAL.json`.
