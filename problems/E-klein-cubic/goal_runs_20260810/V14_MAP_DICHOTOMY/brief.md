# V14_MAP_DICHOTOMY — brief

Charge (director, 2026-08-10): seal the two theorems derived in the
external ChatGPT session "Existence Of A Map"
(https://chatgpt.com/share/6a7a121d-0994-83ea-9e1f-510064072ea6),
after director review and adjudication. The raw extract is kept
verbatim in `import/chatgpt_existence_of_a_map_extract.txt`.

Notation and model conventions follow the sealed packet
`goal_runs_after_c53d89a/FIX_IX_SEAL` (generators `T6`, `S6` at primes
397/199/353, `gauss^2 = -11`, `M` = the `10'` summand of `Lambda^2 U`,
`A = Ann(M)` in `Lambda^4 U`, `X = {Pf = 0}` in `P(A)`).

## Items to seal

1. **Theorem A** — for every `alpha` in `Aut(G)` there is no
   `alpha`-twisted `G`-equivariant rational map `X --> V14`, dominant
   or not. Analytic; the residual-RCC centralizer obstruction of
   `research/.../GENERALIZATIONS.md` §2 run with source `X`, initial
   carrier `L_sigma`. Consumes `FIX-A0-ARRANGEMENT-PASS` and
   `FIX-IX-SEAL-PASS`.
2. **Theorem B** — a nonconstant `G`-equivariant rational map
   `Phi: V14 --> X` exists. Analytic; generic torsor, degree ≤ 2
   splitting of the 2-torsion Brauer class, Pfaffian–Grassmannian
   birationality over `L`, Nishimura, cubic-secant descent of the
   quadratic point, Duncan–Reichstein twisting adjunction. Pinned
   inputs: Tschinkel–Zhang arXiv:2409.08392,
   `GP-THETA11-G-EQUIVARIANT`, `SPEC.md`.
3. **Corollaries** — transfer of pointed twists along `Phi`; both
   comparison routes between `X` and `V14` are closed as headline
   tests.
4. **Import hygiene** — replay what is replayable (degrees 1–2),
   record what is not (degrees 3–5), record the session's `Sym^2(10')`
   dimension error and its unverified dominance sketch.

## Machine layer

`verifier.py` (pure python3, no dependencies, primes 397 and 199,
writes `results/checks.log`): rebuild the FIX_IX_SEAL group model;
generate `V14` points and check the Plücker equations; `Hom_G(M,A)=0`;
`Sym^2(10')` multiplicities by character inner products; build the
quadratic covariant by averaging and test it on the sampled `V14`
points; the cubic-secant residual identity over `F_{p^2}`; `A^G = 0`;
repository pins (exit strings, external documents).

## Exits

`V14MAP-DICHOTOMY-SEALED` (primary), `V14MAP-KLEIN-TO-V14-EMPTY`,
`V14MAP-V14-TO-KLEIN-EXISTS`, `V14MAP-TRANSFER-POINTED-TWISTS`,
`V14MAP-DEGREE12-REPLAYED`, `V14MAP-DEGREE-3-4-5-IMPORT-UNREPLAYED`.

Not claimed: dominance of `Phi`, any explicit `Phi`, any headline or
`ed` value. Headline stays OPEN.
