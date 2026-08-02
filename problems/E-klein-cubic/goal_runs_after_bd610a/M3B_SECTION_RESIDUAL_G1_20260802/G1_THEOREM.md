# M3B — Gate G1 degree-4 section scheme (executable modular form)

**Parent packet:** `goals_after_bd610a/M3_SARKISOV_SECTION/`  
**Parent exit (unchanged):** `M3-INTEGRAL-DEGREE4-MULTISECTION`  
**Section question:** still `UNDECIDED` over \(K=K_{\mathrm{Schur}}\)  
**Headline:** OPEN

## Object

A nonexceptional section of \(H\)-degree \(d=4\) is a basepoint-free tuple

\[
A_i\in K[s,t]_4\ (i=0,1,2),\qquad r\in K[s,t]_3
\]

satisfying the graph cubic identity

\[
\Phi(A_0,A_1,A_2,sr,tr)=0
\]

identically in \(s,t\).  Expanding gives **13** homogeneous cubic equations in
**19** projective coefficients (the raw locus in \(\mathbf P^{18}_K\)).
Saturation against common binary factors is required for a genuine section.

This is residual gate **G1** from `SECTION_RESIDUAL.md` / `residual_gate.json`.

## What this packet seals

1. At sealed good primes \(p=23\) and \(p=67\), the 13 cubics are expanded
   explicitly from the exact Reynolds frame witness (`exact_frame.json`) after
   reduction of the frozen characteristic-zero frame.
2. The sealed parent residual witnesses
   `modular_residual_section_p{23,67}.json` satisfy those rebuilt equations,
   have binary \(\gcd\) degree \(0\), and Jacobian rank \(13\) (smooth of local
   projective dimension \(5\) in the raw 13-cubic scheme).
3. Therefore the specialized G1 locus is **nonempty** over those finite fields.

## Explicit non-claims

- No \(K_{\mathrm{Schur}}\)-rational section is produced.
- Nonemptiness over \(\mathbf F_p\) is **not** a characteristic-zero point.
- Multisection existence is not reopened.
- No `BRIDGE_SARKISOV_POS` and no Problem-E headline.

## Exit semantics

```text
M3B-G1-MODULAR-NONEMPTY-PASS
```

means: executable G1 equations sealed at two good primes; modular saturated
locus nonempty and smooth at known witnesses; section over \(K\) remains open.
