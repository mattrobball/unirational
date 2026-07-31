# T2R.4 — Resultant factor identity and saturation data

**Headline: OPEN.**  
**Gate: T2R.4.**  
**Exit: `T2R4-PASS`.**  
**Binding:** `WORKORDER_CAS_HEADLINE_REVISED.md` §4 T2R.4; `REPAIR.md` Part I.  
**Base pin:** `b222573`.

---

## Objects installed

On the sealed inputs

- \(P\in\mathbf Z[A,B,Y,Z,u]\) (1593 terms, content 1, \(\deg_u=6\)),
- \(H\in\mathbf Z[A,B,Y,Z]\) (37992 terms, irreducible mult-1 factor of \(\operatorname{Res}_u(P,P_u)\)),

the following factors of the simple-fold / \(S_G\) open are installed under
`certificates/fold_normalization_t2r/saturation_factors/`.

| Factor | Representation | Terms | Role |
| --- | --- | ---: | --- |
| \(\ell=\mathrm{lc}_u(P)\) | sparse TSV | 31 | gate |
| \(P_{uu}\) | sparse TSV | 881 | gate |
| \(C\) | sparse TSV (sealed parameter content) | 2630 | gate |
| \(\delta\) | sparse TSV (Cramer minor of BKK frame) | 10507 | gate |
| \(G=\operatorname{Res}_u(P,P_u)/H\) | **exact quotient circuit** + partial factorization | — | inverted in \(S_G\); saturation factor |

---

## Identity

\[
\operatorname{Res}_u(P,P_u)=H\cdot G
\quad\text{in }\mathbf Q[A,B,Y,Z].
\]

### Verification (mathematical, not hash-only)

1. **Modular exact division.** For every good prime in the recorded set
   (including holdouts \(p\in\{71,101,167\}\) and the twenty-prime batch
   \(71,\ldots,167\)), Nemo computes \(\operatorname{Res}_u(P,P_u)\bmod p\),
   exact-divides by \(H\bmod p\), obtains zero remainder, and checks
   \(H\cdot G\equiv\operatorname{Res}\pmod p\). Peak RSS stayed inside the
   exploratory 8 GiB envelope (~4.5–8.1 GiB).

2. **Evaluation probes.** At rational points with \(H\neq 0\) (e.g.
   \((1,2,3,0)\), \((1,2,3,1)\), \((2,3,5,7)\), \((1,1,1,1)\)), the
   univariate resultant \(\operatorname{Res}_u(P|_{pt},P_u|_{pt})\) divided by
   \(H(pt)\) is a well-defined nonzero rational \(G(pt)\).

3. **Factorization shape (good primes).** On primes with full leading form
   (\(\deg\operatorname{Res}=106\)),
   \[
   G \;\equiv\; c\cdot L\cdot M^{4}\cdot Q_4\cdot F_{27}^{2}
   \pmod p,
   \]
   with \(\deg G=63\), where
   - \(L=A-15\) (exact),
   - \(M=B\) (exact),
   - \(Q_4\) = sealed primitive deg-4 poly (21 terms; monic-rational LT \(A^4\)),
   - \(F_{27}\) = unique monic-in-\(A\) deg-27 factor with line restriction
     degree 11 (multiplicity 2). Sparse integer CRT of \(F_{27}\) is modularly
     executable; full char-0 expansion requires \(\sim 80\)–\(100\) good primes
     (coeff bit growth comparable to \(H\)).

Bad leading-form example: \(p=67\) gives \(\deg\operatorname{Res}=100\),
\(\deg G=57\), and a deg-24 factor in place of deg 27 — excluded from the
shape claim.

---

## Cramer \(\delta\)

From the sealed sparse BKK frame matrix \(M\) (3 rows, columns
\((t,v)\in\{(0,0),(0,1),(1,0)\}\)):

\[
\delta = M_{0,1}M_{1,2}-M_{1,1}M_{0,2},
\]

cleared to a primitive integer polynomial in \(\mathbf Z[A,B,Y,Z,u]\)
(10507 terms, total degree 23). The independent verifier rebuilds \(\delta\)
from the BKK certificate and checks equality with the sealed TSV.

---

## Circuit operations (G)

| Operation | Implementation |
| --- | --- |
| Evaluation | Specialize \(P\) to \(\mathbf Q[u]\); univariate resultant; divide by \(H(pt)\) |
| Good-prime reduction | Nemo `resultant` + `divrem` by \(H\) |
| Ideal membership | Via \(G\cdot q\), or modular CRT of membership |
| Saturation aux | \(I:G^\infty=I:(L\cdot M\cdot Q_4\cdot F_{27})^\infty\); \(L,M,Q_4\) expanded; \(F_{27}\) via modular images or pending sparse CRT |
| Identity | Modular rem=0 and product check; evaluation probes |

A fully expanded sparse \(G\) (~110k terms mod \(p\)) is **not** required for
executability of the primary exact-quotient circuit.

---

## Exit

```text
T2R4-PASS
```

All factors required by T2R.5’s saturation product
\(\ell\cdot P_{uu}\cdot\delta\cdot C\cdot G\) are executable.  \(F_{27}\) remains
available as a modular sparse factor with CRT expansion optional for exact
sequential saturation by that factor alone.

Independent verifier:

```text
python3 certificates/fold_normalization_t2r/verify_saturation_factors.py
```

Terminal marker: `FOLD_NORMALIZATION_T2R4_VERIFIER_ACCEPT`.

**Problem E remains OPEN.**  Proceed to T2R.5.
