# Replay — `EXIT_KLEIN_V22.md`

Toolchain: `python3` and `Macaulay2` only. No external CAS, no network.
All load-bearing arithmetic is exact over `K = Q(√−7)`; the two finite-field
scripts are corroboration and nothing depends on them.

Run everything from `research/equivariant-unirationality-new-applications/`.

## 1. One-command verification (≈ 4 s)

```sh
python3 verify_klein_v22.py
```

Exits 0 and prints an `[OK]` line for each load-bearing claim, ending with

```text
VERDICT: V22-D8-GATE-FAILS
  gate (a)  FAILS  (D8-stable smooth rational curve in X^sigma)
  gate (b)  HOLDS  (X^{D8} = empty)
```

Any failed check raises `AssertionError` — there is no soft-fail path.

## 2. The individual stages

```sh
python3 v22_klein_model.py        # build A, Λ²A*, the net N; G-stability on all 168 elements
python3 v22_klein_fixed_loci.py   # the four strata of X^σ; conic and point equations
python3 v22_klein_crosscheck.py   # the ker φ_u ↔ Q(u) identity at 70 exact rational points
```

Expected key lines:

```text
dim of (3+3')-isotypic part of Lambda^2 A^* = 6
net N is G-stable, dim 3  (checked on all 168 group elements)
dim A_+ = 3   dim A_- = 4
dim N_+ = 1   dim N_- = 2
[k=3]  rank = 2 => U = A_+ is NOT on X
[k=0]  rank of omega_0 restricted to A_- = 4   Pfaffian = (-1/2+3/2*s)
[k=1]  Q = ((-32-32*s))*u1^2 + ((48-16*s))*u2^2 + (-64)*u3^2
       rank of the conic's symmetric matrix = 3 =>  SMOOTH conic (rational curve, D8-stable)
[k=2]  4x4 determinant ... (1024)*m1^2 + ((128+384*s))*m2^2
       the two points of the k=2 stratum are SWAPPED by D8
```

Here `s = √−7`.

## 3. Macaulay2 — ideal-theoretic confirmation

```sh
python3 v22_klein_m2gen.py           # regenerates v22_klein_verify.m2 (exact, over Q(√−7))
M2 --script v22_klein_verify.m2      # ≈ 3 min
```

Expected (byte-identical to what mod 11 and mod 23 produce):

```text
--- X = Gr(3,7) cap P^13 : ambient P^13 ---
   minimal quadric generators = 45
   dim(affine cone) = 4   degree = 22
   projective dim = 3
--- X^sigma stratum sigma_evp : ambient P^7 ---
   dim(affine cone) = 2   degree = 6
   projective dim = 1
   Hilbert polynomial = 6*i+1
--- X^sigma stratum sigma_evm : ambient P^5 ---
   dim(affine cone) = 1   degree = 2
   projective dim = 0
   Hilbert polynomial = 2
--- X^D8 character (eps(r),eps(s)) = (1,1)  ... projective dim = -1   (EMPTY)
--- X^D8 character (eps(r),eps(s)) = (1,-1) ... projective dim = -1   (EMPTY)
--- X^D8 character (eps(r),eps(s)) = (-1,1) ... projective dim = -1   (EMPTY)
--- X^D8 character (eps(r),eps(s)) = (-1,-1)... projective dim = -1   (EMPTY)
DONE
```

Reading: `Hilbert polynomial = 6i+1` gives `p_a = 0`; with one minimal prime
(shown by the mod-`p` runs, where `decompose` is available) the curve is
irreducible of arithmetic genus 0, i.e. **smooth rational** — gate (a) fails.
`projective dim = -1` on all four `D8`-character strata is `X^{D8} = ∅` —
gate (b) holds.

## 4. Corroboration mod 11 and mod 23 (optional, ≈ 30 s each)

```sh
python3 v22_klein_m2gen.py 11 2   &&  M2 --script v22_klein_verify_p11.m2
python3 v22_klein_m2gen.py 23 4   &&  M2 --script v22_klein_verify_p23.m2
```

`(p, r)` must satisfy `r² ≡ −7 (mod p)`; the generator asserts this. These runs
additionally print `decompose` output (unavailable over the number field in
Macaulay2 1.26): one minimal prime for each `X^σ` stratum.

**Note.** `python3 v22_klein_m2gen.py` with no arguments must be re-run to
restore the exact-field `v22_klein_verify.m2` after generating a mod-`p` file;
the three scripts are written to distinct filenames, so no file is clobbered.

## 5. What is cited rather than recomputed

* Mukai's model of the genus-12 prime Fano threefold and the identification of
  `VSP(C_Klein, 6)` with the net `W₃ ⊂ Λ²(W₇^∨)`: Cheltsov–Shramov,
  arXiv:1010.1918, Appendix A + Thm 4.5; `Aut^G(X) = G` and `G`-birational
  superrigidity: their Thm 1.10.
* `b₃(V22) = 0`: Mukai, *Plane quartics and Fano threefolds of genus twelve*, §4
  (`V22` is one of the four Fano threefolds with `b₂ = 1`, `b₃ = 0`).
* Smoothness of `X` is Cheltsov–Shramov's; the Macaulay2 run here independently
  produces `dim 3`, `degree 22`, `45` quadrics, but does **not** recompute the
  singular locus (the Jacobian-minors test is `codim 10` in 14 variables and is
  combinatorially out of reach). Nothing in the verdict depends on it: the
  conic's smoothness is read off its own rank-3 equation, and the
  Hilbert-polynomial certificate `6i+1` is independent of it.
* The centralizer theorem itself: `problems/E-klein-cubic/theory/FIX_IX_v14.md`,
  Cor IX.1 (sealed; not re-derived here).
