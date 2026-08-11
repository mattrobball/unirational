# The restricted-degree exclusion: `d' = 2` and `d' = 3` are impossible

Exits: `RESTRICTED-COORDINATE-DEGREE-TWO-AND-THREE-EXCLUDED-ALL-DEGREES`,
`NONIDENTITY-RESTRICTED-COORDINATE-DEGREE-AT-LEAST-FOUR`,
`COMMON-FACTOR-CELLS-K-EQUALS-D-MINUS-2-AND-D-MINUS-3-EXCLUDED`.

Provenance: external round 5, section 6 (unaudited). Verdict: **CONFIRMED WITH
SUPPLIED PROOF AND A SUPPLIED HYPOTHESIS.** The source's three-line argument is
correct in outline, omits the dominance hypothesis it needs, and does not use
(34) at all — the exclusion is a statement about the restricted selfmap alone.
Recorded here at the strength the proof supports.

Exact inputs: `verify_d35_dimensions.py` (`RESULT: PASS`, 112 checks, exact
character arithmetic). Supporting identity: `THEOREM_SOURCE_TANGENCY.md`.

---

## 1. Statement

`G = PSL(2,11)`, `X = V(F) ⊂ P^4` the Klein cubic threefold. Let `T` be a
primitive landing tuple of degree `d`, `T|_X = H B` with `deg H = k`,
`d' = d - k`, and `phi = [B] : X --> X` the primitive restricted selfmap.

> **Theorem 1.1.** `d' = 2` and `d' = 3` are impossible, in **every** ambient
> degree `d`. Equivalently the common-factor cells
> ```
>          k = d - 2      and      k = d - 3
> ```
> are excluded in every ambient degree. No other value of `d' >= 1` is excluded
> by this argument.

Combined with the sealed invariant-degree lemma
(`goal_runs_20260810/COMBINED_DEGREE_SIEVE/THEOREM_COMBINED_SIEVE.md`, Lemma
2.3, `COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED`: `k in {0} ∪ {5,6,7,...}`),
the surviving restricted-degree set in ambient degree `d` is exactly

```
        d' = 1        (retraction, k = d-1)
   or   d' in {4,5,...,d-5}
   or   d' = d        (k = 0).                                       (39)
```

## 2. Proof

**Step 1 (the ramification section exists and is nonzero).** `phi` is dominant
— `goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/THEOREM.md`, Theorem 1.1;
see `THEOREM_SOURCE_TANGENCY.md` §5 for the citation audit — hence generically
finite, hence (characteristic zero) generically étale. Let `beta` be the cone
lift of `phi` and `j_phi = Jac(beta)` its cone Jacobian, defined by
`beta^* eta = j_phi · eta` for the residue form `eta` of `F`. Then
`j_phi != 0`, and `div_X(j_phi) = R_phi`, the ramification divisor
(`THEOREM_SOURCE_TANGENCY.md`, Corollary 4.2).

**Step 2 (the section is invariant, of degree `2d'-2`).** `K_X = O_X(-2)` and
`phi^* K_X = O_X(-2d')`, so

```
R_phi ~ K_X - phi^*K_X = O_X(2d'-2),   i.e.  j_phi in H^0(X, O_X(2d'-2)).
```

`j_phi` is `G`-invariant: `Omega` is `G`-invariant (`G` perfect, so it acts
through `SL(W)`), `F` is `G`-invariant, hence `eta` is; `H` is `G`-invariant
(its divisor is `G`-stable and `G` has no nontrivial characters), hence `B` and
`beta` are `G`-equivariant; and `g^*(beta^*eta) = beta^*(g^*eta)` then forces
`j_phi o g = j_phi`. So

```
0 != j_phi in H^0(X, O_X(2d'-2))^G.                                  (E1)
```

**Step 3 (the invariant space vanishes exactly at `d' = 2, 3`).** Since
multiplication by `F` is an injective `G`-map `Sym^{n-3}W^v -> Sym^n W^v` and
taking `G`-invariants is exact in characteristic zero,

```
dim H^0(X, O_X(n))^G = I(n) - I(n-3),   I(n) = dim (Sym^n W^v)^G.    (E2)
```

This is Lemma 2.3 of the sealed sieve. The relevant values (recomputed
independently in `verify_d35_dimensions.py`, and agreeing with the sealed table
`1,0,0,0,0,1,1,1,1,1,2,2,3` for `n = 0..12`):

| `d'` | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|
| `2d'-2` | 0 | 2 | 4 | 6 | 8 | 10 | 12 | 14 |
| `dim H^0(X,O_X(2d'-2))^G` | 1 | **0** | **0** | 1 | 1 | 2 | 3 | 4 |

At `d' = 2` the section would lie in `H^0(X,O_X(2))^G = 0`; at `d' = 3`, in
`H^0(X,O_X(4))^G = 0`. Both contradict (E1). ∎

**Step 4 (nothing else dies this way).** `A := (C[x]/(F))^G` is a graded domain
(`X` is irreducible) with `dim A_n = 1` for `n = 5,6,7,8,9` by (E2), and
multiplication by a nonzero element of `A_5` is injective, so `dim A_n >= 1`
for every `n >= 5`. Hence `H^0(X,O_X(2d'-2))^G != 0` for every `d' >= 4`, and
`= C` for `d' = 1`. The script confirms `d' in {2,3}` is the complete list for
`d' <= 40`. So Theorem 1.1 is sharp: this argument excludes those two values
and no others.

## 3. Three things to keep straight

**(a) `d'` is not `delta`.** `d'` is the *coordinate degree* of the primitive
restricted selfmap; `delta = deg phi` is its *topological* degree. They are
different invariants (`delta <= d'^3 - d'` or `d'^3`, Corollary 3.5 of the
sealed sieve). In particular this exclusion says nothing about the sealed
sieve's `delta = 3` survivor cell `(k, d', zeta, a, delta) = (0, d, 1,
d^3-d-3, 3)`, which has `k = 0`, `d' = d` and **survives unchanged**.

**(b) The source's (34) is not needed.** The source presents the exclusion as a
corollary of `Delta_T|_X = c H^2 j_phi`. It is not: Steps 1–3 use only the
restricted selfmap. (34) is what *interprets* the exclusion inside the ambient
package — it says the excluded cells are exactly those where the ambient
tangency invariant would have to be `H^2` times nothing.

**(c) The dominance hypothesis is load-bearing and was missing.** Without
dominance, `j_phi = 0` and there is no contradiction; by
`THEOREM_SOURCE_TANGENCY.md` (T6) that branch is exactly "`X` is an invariant
hypersurface of the kernel foliation". It is closed by
`FULL_G_RESTRICTION_DOMINANCE`, at the cost of the accepted input
`ed_C(PSL_2(F_11)) >= 3`.

## 4. Sealing status

**Sealed at this strength:** `d' in {2,3}` impossible for every `d`, conditional
on exactly the accepted inputs the rest of the repository's dominance chain
already carries (`ed_C(G) >= 3`, Beauville / Duncan–Reichstein) and on nothing
else. Every dimension used is recomputed exactly and cross-checked against the
sealed sieve table.

**Composition with existing sealed results.**

| existing result | composition |
|---|---|
| `COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED` (`k in {0} ∪ {5,...}`) | intersect: gives (39). The two sieves are independent — one is about `H^0(X,O_X(k))^G`, this one about `H^0(X,O_X(2d'-2))^G` — and they cut different ends of the `k`-range. |
| `RT-DX0-PROVED` (`D_X = 0 => CARRIER`) | untouched: `k = 0` means `d' = d`, excluded only if `d in {2,3}`, and `d >= 4` already (`LANDING-DEGREE-AT-LEAST-FOUR-PROVED`). |
| `DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24` | untouched: the retraction branch is `d' = 1`. |
| `COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED` (`delta = 3` witness at every `d >= 31`) | untouched: that cell has `d' = d`. **This exclusion does not revive the arithmetic sieve.** |
| `LANDING-DEGREE-AT-LEAST-FOUR-PROVED` (`d >= 4`) | consistent: at `d = 4` the only cells are `k = 0` (`d' = 4`) and `k >= 5` (impossible), so `d = 4` forces `d' = 4`. |

**What it does not do.** It removes two cells from every ambient degree,
including two of the thirty-one cells at the first open degree `d = 35`. It
does not close any branch and does not touch the headline. The
`d = 34` window is already closed by other means; the first open degree remains
`d = 35`.

## 5. Non-claims

* No statement about `delta`, the topological degree.
* No statement about whether any surviving cell is realisable.
* The argument is uniform in `d` but is not an all-degree closure: `d' = 1` and
  `d' >= 4` both survive in every degree.

**Problem E headline: OPEN.**
