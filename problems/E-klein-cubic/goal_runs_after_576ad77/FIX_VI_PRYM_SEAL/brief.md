# FIX-VI-PRYM-SEAL — machine-seal the Note VI curve computations

You are a CAS verification worker on the Klein-cubic project. Repo root:
`/Users/worker/unirational`. Work ONLY inside this packet directory:
`problems/E-klein-cubic/goal_runs_after_576ad77/FIX_VI_PRYM_SEAL/`.
Everything below is a WORKED PLAN — execute and verify it; do not
redesign it. Char 0, exact arithmetic throughout (sympy Rational +
sqrt; no floats except for stated numeric cross-checks).

## Hard rules

- NEVER run `git commit` or touch `.git` (the director commits).
- Output discipline (MANDATORY — a prior worker died on output-token
  overflow): write results INCREMENTALLY to files as you go
  (`results/*.txt`, one logical block per file); your final chat
  report must be UNDER 30 lines: pass/fail per section + check count
  + any deviation. Never paste large expressions into chat.
- Scripts must PRINT check results and also append machine lines
  `CHECK <name> PASS|FAIL` to `results/checks.log`. A FAIL is not a
  disaster — record it honestly and continue; do NOT tweak inputs to
  force a pass.
- Engines available: python3 (sympy), Macaulay2 (`M2`), msolve,
  Singular, official Julia+OSCAR (load is slow; only if needed).
  Known landmines are documented in
  `problems/E-klein-cubic/goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/MSOLVE_PARSER.md`
  (msolve false-verdict modes) — for THIS packet sympy + one
  independent M2 or numeric route suffices; do not use msolve.

## Input data (sealed frame constants — cite, do not re-derive)

The V4 normal form of the Klein cubic (director-derived, constants
verified against packet FIX-L1):

    F = κ₊ a³ + κ₋ b³ + (a+b) x² + (ω a + ω² b) y² + (ω² a + ω b) z² + x y z

with κ± = (13 ± 3√33)/16, ω = primitive cube root of unity. Trace
relations (verify as CHECK trace_relations): κ₊+κ₋ = 13/8,
κ₊κ₋ = −1/2, (κ₊+2)(κ₋+2) = 27/4, (κ₊+4)(κ₋+4) = 22.

Named plane objects in P²(a,b,x):
- E_σ := {F₀ = 0}, F₀ := κ₊a³ + κ₋b³ + (a+b)x²  (arrangement elliptic)
- K_c := {x² = 4(a²−ab+b²)}  (conic; note (ωa+ω²b)(ω²a+ωb) = a²−ab+b²)

## Section A — restriction identity and branch data

1. CHECK restriction_identity: on K_c (i.e. modulo x²−4(a²−ab+b²)),
   F₀ ≡ (κ₊+4)a³ + (κ₋+4)b³ exactly. (Use (a+b)(a²−ab+b²)=a³+b³.)
2. CHECK product_22: (κ₊+4)(κ₋+4) = 22.
3. Parameterize K_c: b(t) = −4(t+1)/((t−2)(t+2)), a = 1,
   x(t) = 2 + t·b(t). CHECK param_on_conic: x(t)² − 4(1 − b(t) + b(t)²) ≡ 0.
4. Branch sextic P6(t) := numerator of (κ₊+4) + (κ₋+4)·b(t)³ (clear
   denominators; degree must be 6). CHECK sextic_degree.
5. CHECK tau_preserves_roots: the involution τ(t) = (−t−4)/(t+1)
   maps the root set of P6 to itself (verify P6(τ(t))·(t+1)⁶ is a
   constant multiple of P6(t)).

## Section B — bielliptic structure and the two j-invariants

6. Conjugate τ to s ↦ −s via s = (t−t₁)/(t−t₂), t₁,₂ = −1 ± √−3
   (the two fixed points of τ). Substitute t(s) = (t₂ s − t₁)/(s − 1)
   into P6, clear denominators, get a degree-6 polynomial in s.
   CHECK evenness: ALL odd-degree s-coefficients are EXACTLY zero.
7. Write the even part as a cubic c(u) in u = s² (monic after
   normalization). K̃ is w² = c̃(s²); E₊: v² = c(u); E₋: v² = u·c(u).
8. CHECK j_plus_exact: j(E₊) = −32768 exactly, computed symbolically
   (route 1: g₂,g₃ from the cubic; simplify over the tower
   Q(√33, √−3, √11 as needed)).
9. CHECK j_minus_exact: j(E₋) = −32768 exactly (route 1: binary
   quartic invariants S, T of u·c(u): S = a0a4 − a1a3/4 + a2²/12,
   T = a0a2a4/6 − a0a3²/16 − a1²a4/16 + a1a2a3/48 − a2³/216,
   j = 1728·S³/(S³−27T²)).
10. INDEPENDENT ROUTE 2 for both (different implementation, not a
    rerun): compute the 6 roots of P6 numerically to 60 digits,
    form the cross-ratio/λ-invariant of the 4 branch points of each
    quotient (E₊ branch: {c-roots, ∞}; E₋ branch: {0, c-roots}),
    evaluate j(λ) = 256(λ²−λ+1)³/(λ²(λ−1)²), and CHECK
    j_plus_numeric / j_minus_numeric: agreement with −32768 to ≥ 40
    digits.
11. CHECK j_not_arrangement: −32768 ≠ 8192/11 and ≠ −4096/11
    (trivial but record it).
12. CHECK cm_minus_11: the discriminant-(−11) CM j-invariant is
    −32768: verify by checking that j = −32768 satisfies the Hilbert
    class polynomial H_{−11}(X) = X + 32768 (class number 1 — cite:
    standard tables; the CHECK is that your computer-algebra route
    for H_{−11} returns X + 32768 if sympy/pari-free route exists,
    else verify via the Weber/modular-polynomial-free numeric route:
    j((1+√−11)/2) computed from q-expansion of j to 30 digits equals
    −32768 to ≥ 20 digits).

## Section C — cover/genus arithmetic (small, exact)

13. CHECK genus_Esigma: E_σ is a smooth plane cubic (nonzero
    discriminant), and its j-invariant is 8192/11 (coherence with
    the sealed arrangement value; compute from the ternary cubic F₀
    by putting it in Weierstrass form or via classical S,T
    invariants of a ternary cubic).
14. CHECK six_intersection_points: E_σ ∩ K_c is 6 distinct points
    (resultant/discriminant computation; exact).
15. CHECK rh_arithmetic: Riemann–Hurwitz consistency: double cover
    of E_σ (genus 1) branched at 6 points has genus 4; double cover
    of P¹ branched at 6 points has genus 2; p_a of the nodal union
    Δ₅ = E_σ ∪ K_c meeting transversally in 6 points is
    1 + 0 + 6 − 1 = 6; admissible-cover arithmetic p_a(Δ̃₅) = 4 + 2
    + 6 − 1 = 11 = 2·6 − 1; Prym dimension 11 − 6 = 5. (Pure
    arithmetic — encode the formulas and assert.)

## Section D — verifier and payload

- `payload/` : the computed objects (P6 coefficients, c(u)
  coefficients, both j's, E_σ j, intersection count) as plain text /
  JSON, exact expressions stringified.
- `verifier.py`: an INDEPENDENT implementation (do not import your
  computation scripts; re-derive from the brief's formulas with
  structurally different code — e.g., different parameterization of
  K_c, resultants instead of substitution where feasible) that
  re-checks every CHECK above and exits 0 iff all pass, printing
  `VERIFIER: N/N PASS`.
- `REPORT.md`: ≤ 60 lines; table of checks, engines used, wall
  times, deviations, and the exact exit name below.

Exit names: `FIX-VI-PRYM-SEAL-ALLGREEN` if every check passes;
`FIX-VI-PRYM-SEAL-DEVIATION` otherwise (with the failing checks
named in REPORT.md).

What this packet does NOT claim: the Prym isogeny decomposition
itself (Beauville admissible-cover theory — literature), Kollár's
theorem, Roulleau's Theorem 2. Those are anchors; you verify the
computational claims only.
