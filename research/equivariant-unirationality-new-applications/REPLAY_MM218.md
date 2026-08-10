# Replay: Fermat-discriminant Mori–Mukai No. 2.18 fixed network

All checks are exact. Toolchain: `python3` and `Macaulay2` only. Run from
`research/equivariant-unirationality-new-applications/`.

```bash
cd research/equivariant-unirationality-new-applications

M2 --script verify_mm218_smoothness.m2      # ~5 s
python3 verify_mm218_model.py               # ~20 s
python3 verify_mm218_strata.py              # ~50 s
python3 verify_mm218_curves.py              # ~45 s
```

Each script exits nonzero if any assertion fails.

## What each script certifies

### `verify_mm218_smoothness.m2` (Macaulay2, over `QQ(i)`)

* `Q_2^2 - Q_1 Q_3 = x^4+y^4+z^4`;
* the Fermat quartic `Delta` is smooth;
* `Q_1,Q_2,Q_3` have no common zero, so `Z \to P^2` is a finite double cover;
* `Z` is smooth in `P^1 x P^2` (saturated Jacobian ideal is the unit ideal),
  hence `X` is smooth;
* the conic-bundle discriminant of `pi_1 : Z \to P^1` is
  `2i t_0t_1(t_0^4-t_1^4)`, with six distinct roots.

### `verify_mm218_model.py` (exact arithmetic in `K = Q(zeta_24)`)

* the cyclotomic field arithmetic (`i`, `sqrt2`, `(1+i)/2`);
* Abe's four generators are in `SL_2 x SL_3` and satisfy `F(At,Bx) = mu^2 F`;
* `|G| = 192`, every element satisfies the defining identity;
* `tau` has order 2 and `Z(G) = <tau>`;
* `|Gbar| = 96`; order statistics `{1:1,2:31,3:32,4:48,6:32,8:48}`, 15 classes;
* every `A`, `B` is diagonalizable with 24th-root-of-unity eigenvalues (this is
  what makes the downstream fixed-locus computation exact).

### `verify_mm218_strata.py`

1. `X^G = \varnothing`; `X^\tau = Z` has dimension 2.
2. **Condition (A) FAILS for `G`**: six maximal abelian subgroups have empty
   fixed locus, each an elementary abelian `(Z/2)^3` containing `tau`.
3. The 15 element classes with their fixed loci.
4. The four involution classes with centralizer orders and `X^s`,
   `X^{C_G(s)}`.
5. The 24 conjugacy classes of subgroups containing `tau`, with
   `X^H = Z^{\bar H}`.
6. The subgroup audit: 46 classes, 12 with Condition (A) and empty fixed locus,
   6 maximal ones; the unique order-96 laboratory `H` with `Z(H) = <tau>`.
7. **Condition (A) fails for the residual `\bar H`-action on `Z`**, witnessed by
   an abelian `\bar A` of order 16 whose preimage `A'` is nonabelian with
   `[A',A'] = <tau>`.
8. Abe's order-12 example: `|Aut(X_{12})| = 12`, `tau` central, Condition (A)
   **holds**, `X_{12}^{Aut} = \varnothing` — a second, smaller laboratory.

### `verify_mm218_curves.py`

1. The 28 bitangents of the Fermat quartic, with contact patterns
   `12 x (4)` and `16 x (2+2)`.
2. The 56 `(-1)`-curves with the full `56 x 56` intersection matrix:
   `C^2 = -1`, `-K_Z\cdot C = 1`, `K_Z^2 = 2`, each curve meets exactly 27 of
   the other 54, and `-K_Z = C_L^+ + C_L^-` is independent of `L`.
3. The action on the 56 curves is a permutation preserving the intersection
   form; `\bar G`-orbits `12+12+32`, `\bar H`-orbits `12+12+16+16`; no stable
   `(-1)`-curve; `rk Pic(Z)^{\bar G} = rk Pic(Z)^{\bar H} = 2`.
4. The conic-bundle structure and the identification of the second invariant
   class as the fibre class `f`.
5. No `\bar G`- and no `\bar H`-invariant line in `P^2`: `|-K_Z|` has no stable
   member.
6. The normal-subgroup criterion table proving **no `\bar H`-stable irreducible
   rational curve on `Z`**.
7. The incidence table of §7 of `MM218_FERMAT_NETWORK.md`.

## Conventions and caveats

* `X` is presented in the total space of `O(1,1)` as `w^2 = F`, with the scaling
  equivalence `(t,x,w) ~ (a t, b x, ab w)`; group elements are triples
  `(A,B,mu)` with `A in SL_2`, `B in SL_3`, modulo the central `\Delta_6` of
  order 6. This SL-normalization is what keeps every eigenvalue inside
  `Q(zeta_24)`; without it the eigenvalues of normalized matrices leave every
  fixed cyclotomic field.
* `(P^1 x P^2)^H` is a union of products `P(W_1) x P(W_2)` of simultaneous
  eigenspaces because the action is a product action. On such a component the
  character `chi_g = mu_g/(alpha_g beta_g)` is constant, and `chi(tau) = -1`;
  hence `X^H = Z^{\bar H}` for every `H` containing `tau`.
* Subgroup enumeration uses cyclic extension with normalizers, valid because
  `|G| = 192 = 2^6\cdot3` is solvable. Abelian-subgroup enumeration extends by
  centralizing elements. Both are complete.
* Condition (A) is tested on maximal abelian subgroups only; this is sufficient
  because `X^{A'} \subseteq X^{A}` for `A \subseteq A'`.
* Points of a stratum lying on a positive-dimensional fixed component are
  obtained by solving a binary quadratic; when its discriminant is not a square
  in `K` the incidence row is flagged `(K-rational points only)`. This affects
  presentation of the incidence table only, never any of the assertions.
