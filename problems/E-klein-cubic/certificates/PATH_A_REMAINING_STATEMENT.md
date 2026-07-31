# Path A — the exact remaining statement

**Issued by:** repository owner (director), 2026-07-31.
**Recorded by:** director session.
**Base:** `17e0e5f`.

## Status correction

The proved `P^1` reduction (`A1-PASS`: any qualifying curve with Hilbert
polynomial `19t+1` is `F`-isomorphic to `P^1`, since `index | 55` and
`index | 2` with `55` odd forces index `1`) **does not yet prove emptiness of
the Path A incidence.**

## The exact remaining statement

\[
\forall\text{ primitive }\tau\in L,\qquad
K_{34}(\tau,V_Z)=L.
\tag{A\(_{\mathrm{empty}}\)}
\]

Equivalently, **some `55 x 55` minor of the block Krylov matrix must be
nonzero at every primitive `tau`.**

## Why this is hard in the right way

Proving that universal full-rank assertion **requires special information
about the marked four-space `V_Z`**.  It is **not** a general theorem about
degree-55 extensions.  Any argument that would apply verbatim to an arbitrary
4-dimensional subspace of an arbitrary degree-55 field either fails or proves
something strictly weaker.

**The blocking gap:** the repository currently seals the **abstract** `V_Z`
and its Hilbert function, but **not expanded generic power-basis
coordinates**.  That is what limits a direct symbolic proof.

## Directed attack

The next mathematical attack is on `(A_empty)` **using the special
`G/D_12` orbit code — not another general-purpose elimination.**

This is reinforced by the sealed collapse audit
(`certificates/schur_krylov/STRUCTURAL_COLLAPSE.md`): no lossless collapse
brings the residual under the gate, and the dense Macaulay ledger at the
required degree is astronomically beyond any machine (`n=52`:
`D=3 ~ 20.5 GiB`, `D=8 ~ 2e11 GiB`, `D=19 ~ 2e26 GiB`).  More memory is not
the answer; the orbit combinatorics are.

Relevant structure already owned: `L = E^H` with `H = D_12`; the degree-55
point is the `G/D_12` coset space; `D_12` is maximal in `G` so `L/F` has no
intermediate fields and `Aut(L/F) = 1`; the `H`-subdegrees
`1,3,3,6,6,6,6,12,12` are geometric after base change and are **not** an
`F`-splitting.

## Boundary

Even a full proof of `(A_empty)` gives exit `N-A`, which closes the
**degree-19 rescue route only**.  It is **not** a proof of
non-unirationality and does not bear on `ed_C(G)`.  **Problem E remains
OPEN.**
