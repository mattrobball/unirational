# Notebook supplement — 2026-08-11: residuals campaign, step 0 — the dependency map. `O4` blocks the headline regardless of `R1`, `R2`, `R3`

## What was asked

Close the three boxed residuals of `TOTAL_DEGENERATION.md` §6 and cascade.
Step 0, to be done and pushed *before* any attack: for each census cell, state
which of `R1`/`R2`/`R3` controls it, and decide whether closing all three would
close the cell — in particular whether `O4`'s Hesse-cubic witness survives
regardless. If it does, say so immediately and re-scope.

Packet: `DEPENDENCY_MAP.md`, `verify_r0_dependency.py`.

## The answer

**It does.** `R1` and `R2` are constraints on the fibres of `p` over a **point**
support (the quantity `delta(x) = dim q(p^{-1}(x))`, forced into `{2,3}`).
`R3` is a constraint on **nonconstant** local systems. The Theorem O4-5 witness
is a constant-coefficient block on a positive-dimensional **support** — a plane
cubic isomorphic to `E_{-11}` in each of the 110 eigenplanes — which is the one
combination none of the three addresses. All three hypotheses fail on it, and
they fail structurally, not by an accident of statement.

A second family survives for the same reason and had not been named: the
positive-dimensional layer of the free cell `S0`/`(O1)` (`H_0 = 1`,
`1 <= s <= n-3`, constant coefficients). The `(O1)` box records a witness only
for its **point** layer `P0`; its positive-dimensional layer is open,
unwitnessed and uncontrolled by all three residuals.

So `RESIDUALS-ALL-CLOSED => SPIN-ROUTE-CLOSED-NEGATIVE` is **false as an
implication**, and the Cor IX.5 consequence chain cannot be triggered by this
campaign however the residuals come out. The campaign is re-scoped at its start.

## What `R1`-`R3` actually buy — the reduced frontier

They remove the entire **point layer** (nine cells, `R1` and `R2` jointly —
neither alone kills anything, since `delta(x) in {2,3}` is exhaustive) and the
entire **nonconstant-coefficient layer** (`R3`). What remains is one line:

> a `G`-orbit of irreducible `S subset Bs(phi)`, `1 <= dim S <= n-3`, carrying
> a constant-coefficient block whose `IH^1(Sbar,Q) = H^1(Stilde,Q)` has
> `E_{-11}` as an isogeny factor of `Jac`/`Alb`, in a channel surviving
> `K-d, K-f, K-i, K-j, K-k, K-l, K-m, K-n`.

New structural input that organises this (**Proposition D2**, one jump, one
dimension): in the constant-coefficient channel the carrier `IH^{s+4-n-j_0}` is
pure of that weight and must be weight one, so `j_0 = s+3-n`. Since the
perverse jump `j_0` is **unique** (Thm S3(2), from the `Q`-irreducibility of
`T`), *all* carrying supports of a given `phi` have the *same* dimension, and
points can coexist only with curves. The frontier therefore splits into three
mutually exclusive scenarios `FRONTIER-1/2/3` by `s = 1, 2, 3` — and
`FRONTIER-1` is occupied by the O4-5 curve, which is why the reduction is a
reduction and never a closure.

Two corrections to the `TOTAL_DEGENERATION.md` §6 box are recorded in place.
**Observation D1**: `R2` is not confined to the 352 mandatory points — its
proof (Prop O2-3) uses only `rho(V14) = 1` and `b_1(V14) = 0`, so it applies at
all nine point cells. And `R1`/`R2` must be proved for an **arbitrary** base
point of a dominant equivariant spin map, not only at the 364 mandatory ones: a
carrying point support may be a free point (cell `P0`) that no theorem places
in `Bs(phi)` in advance. That is a strictly larger demand than the box states.

## Exits

```text
DEPENDENCY-MAP-COMPUTED
O4-BLOCKS-HEADLINE-REGARDLESS
FREE-LAYER-BLOCKS-HEADLINE-REGARDLESS
UNIQUE-JUMP-DIMENSION-RULE
R2-SCOPE-IS-ALL-POINT-CELLS
REDUCED-FRONTIER-BOXED
R0_DEPENDENCY_OK
```

Headline unchanged: **OPEN**.

## Verification

`verify_r0_dependency.py` (`R0_DEPENDENCY_OK`), 323 exact assertions, well
under a second, Python standard library only, and an **independent code path**
from `verify_spin_hodge_census.py` / `verify_total_degeneration.py`: a
cyclotomic engine `Z[zeta_N]` built from `Phi_N` by exact integer polynomial
division and self-tested (degree, divisibility, root sums, conjugation); the
`PSL(2,11)` class data self-validated (`sum` of class sizes, the order profile
reconstructed from the 55 nonsplit tori, the 66 split tori and the 12 Sylow
11-subgroups, `<chi_T,chi_T> = 2`, `<chi_T,1> = 0`, and Lefschetz agreement at
orders 2 and 11); a **metacyclic character-table builder** which constructs
`Irr(H)` for every `H in Sigma_spin` and for `D_12` by Clifford theory from
`H = C_m x| C_k` and validates each table by orthonormality, the
sum-of-squares identity and the vanishing of the regular character off the
identity; the full `Res_H T` decomposition recomputed from `chi_T` alone,
reproducing `dim T^H`, the floors `k(H)`, and every dead channel (`K-d` at
`S_3`, `D_10`, `C_6`; `K-m` at `C_11`; `K-n` at `F_55`, together with the
`Q`-irreducibility of both odd-order restrictions); the perverse ledger and
Proposition D2 for `n = 5..12` with the ambient `n = 5` regression; and the
dependency table itself, whose closure under `{R1,R2,R3}` is computed rather
than asserted.

`scripts/check_manifest_parity.py` passes. The packet is on
`agent/residuals-campaign-20260811`. This notebook revision was authored
against parent head `770ecbc0f5b6f66b57670e3873fa62ecee0725c1`.
