# FIX-IX-SEAL — REPORT

Exit: **FIX-IX-SEAL-PASS**. Director-run, 2026-08-06. Two engines
(python exact linear algebra + Macaulay2), primes 397 and 199,
verifier at fresh prime 353, and EXACT CHAR 0 over K = Q(z)/Phi11
(the field of the explicit even-Weil model; entries in Z[z, 1/11]).

## Sealed statements

1. **Model.** `<T6,S6>` closes to SL(2,11) of order 1320 with
   `S^2 = -I`, `c = 1/gauss`, `gauss^2 = -11`; projective order
   profile (2,110,220,528,220,240). `Lambda^2 U = 5 + 10'` — by
   chi-averaging AND by the verifier's independent trace-sum
   method (both 5-dim candidates pair only with X10'). `M` = the
   10-dim column space of the isotypic projector; `Ann(M)` in
   `Lambda^4 U` is 5-dimensional. [397, 199, 353, K]
2. **(a) The sigma fixed locus.** `V14 cap P(M+)` (the +1-piece,
   dim 6): saturated ideal has dim 1, degree 6, Hilbert
   polynomial `6i` (so chi(O) = 0, p_a = 1), is radical, prime
   (ncomp 1), and SMOOTH (Jacobian minors saturate to the
   irrelevant ideal) — a smooth irreducible genus-1 sextic; the
   arithmetic-genus trap (nodal rational sextic) is excluded by
   the smoothness certificate. `V14 cap P(M-)` (dim 4): dim 0,
   degree 2, reduced — two points. So `V14^sigma` contains NO
   rational curve. [radical/ncomp: 397, 199, 353; smoothness +
   dim/deg/p_a: 397, 199, 353 AND char 0*; see note]
3. **(b) The D12 fixed locus.** Character pieces of `M` under
   `C_G(sigma)`: dims (2,1,1,0); `V14 cap P(piece)` is EMPTY in
   all four. `V14^{D12}` = empty. [397, 199, 353, K]
4. **Ambient.** The dual system `J = (Pf6) + (adjoint bivector
   in M)` on `P(Ann M)` is EMPTY [397, 199, 353, K]. Since any
   singular or excess-dimension point of `Gr(2,U) cap P(M)`
   yields a tangent hyperplane `phi in Ann(M)` with
   `rank(phi) <= 4` whose Pfaffian-adjoint bivector spans
   `Lambda^2(ker phi)` and lies in `M` (rank <= 2 lands in V(J)
   trivially), J-emptiness proves: **V14 is smooth, pure dim 3,
   over K and at all three primes**; degree 14 then follows by
   transversality (smooth expected-dim section of the degree-14
   Gr(2,6)), and connectedness from the Enriques–Severi–Zariski
   principle for linear sections of the ACM Grassmannian.
   Cross-check: direct GB gives dim 3, degree 14 [397, 199, 353].
5. **Group side.** `C_G(sigma)` has order 12 with 7 projective
   involutions (= D12, matching FIX-A0's sealed group fact); the
   two isolated sigma-points have stabilizer EXACTLY C6 (order-6
   check at 397: stab 6, swapped by the other 6 elements of D12
   — forced consistently by (b)). `Pf6` on `Ann(M)` is a nonzero
   G-invariant cubic — by E38's sealed uniqueness of the
   invariant cubic on the 5-dim rep, `{Pf6 = 0}` IS the Klein
   cubic threefold: the Pfaffian-partner identification.

(*) Char-0 status of item 2: dim/deg/p_a computed exactly over K.
Smoothness over K holds TWICE OVER: a priori from item 4 (the
fixed locus of a finite-order automorphism of a smooth projective
variety in char 0 is smooth), AND by the direct Jacobian-minors
saturation over K, which completed after the initial seal
(results/m2_sigma_K.out, ~36 min: SIGPLUS smooth true, SIGMINUS
smooth true).
Connectedness/reducedness over K: the saturated K-ideal and its
mod-397 reduction have the SAME Hilbert polynomial 6i, so the
O_K-model is flat at 397; the fiber there is smooth, reduced,
connected; by semicontinuity of h^0 the K-fiber is connected,
and smooth => reduced. (Two independent primes corroborate.)

## Consequence (with theory/FIX_IX_v14.md §5)

Hypotheses (a), (b) of Corollary IX.1 hold for the PSL(2,11)
action on the V14. Therefore: no G-equivariant rational map
P(V) -> V14 or V -> V14 exists for ANY faithful linear
representation V — the V14 action is NOT G-unirational and NOT
weakly versal; its generic twist has no rational point. With
Prokhorov's two-class theorem and D-R Thm 10.5 (Cor IX.2):
**ed_C(PSL2(F11)) = 3 iff the Klein cubic is G-unirational.**

## Replay

python3 scripts/seal.py 397|199|353|K  (~3s per prime, ~70s K)
M2 --script scripts/m2_{sigma,d12,smooth,ambient}_<tag>.m2
python3 verifier.py   (fresh-prime end-to-end; ALLGREEN)
Outputs under results/ (checks_*.log, m2_*.out).
