# WP-E1 — Pic⁰ obstruction on the marked elliptic

**Headline: OPEN.**  
**Dispatch:** Second — parallel to WP-L2.  
**No formal jet is a covariant** (house rule 3).  
**Full Pic⁰ class, not finite E[2]-charge alone** (house rule 7).

## 0. Accepted geometry

\[
j(E_t)=\frac{8192}{11},\qquad \operatorname{Aut}(E_t,O)=\{\pm1\}
\]

(no CM). Residual order three acts as translation by the unique nonzero
\(q\in E_t[3]\) (up to sign). Marked twelve-point set \(=E[2]+\langle q\rangle\),
type I \(=\langle q\rangle\), type II \(=e+\langle q\rangle\).

Fable packets used read-only after hash-check:

- `tmp/fable_relative_divisor_trace_obstruction/`
- `tmp/fable_relative_q_trace_obstruction/`

## 1. Pic⁰ formalism

After an origin choice, \(\operatorname{Pic}^0(E_t)\simeq E_t\). Residual
actions:

| element | action on \(E_t\) | action on \(\operatorname{Pic}^0\) |
|---------|-------------------|-------------------------------------|
| order-3 \(\rho\) | \(P\mapsto P+q\) | translation by \(q\) |
| residual reflection \(\sigma_i\) | \(P\mapsto e_i-P\) | inversion ∘ translation by \(e_i\) |

**Trace / norm.** For a separable quadratic \(L/K\) with deck involution
\(\tau\) and a class \(\xi\in\operatorname{Pic}^0(E_t)(L)\),

\[
\operatorname{Tr}_{L/K}(\xi)=\xi+\tau(\xi)\in\operatorname{Pic}^0(E_t)(K).
\]

Any \(K\)-point of \(E_t\) with \(K=\mathbf C(\mathbf P^2)\) is constant
(no nonconstant rational map \(\mathbf P^2\dashrightarrow E_t\)).

## 2. Regression: order-twelve quadratic-trace obstruction

### Theorem (Pic⁰ form of the accepted order-twelve obstruction)

**Antecedent.** Factorized first-gate germ on a fixed involution plane with
the audited nonzero three-line Fable boundary:

\[
p_3=q_P R_P,\qquad p_4=\iota_{\Gamma_{R_P}}\eta_P,
\]

and \(Z_P\) the primitive horizontal degree-two part of \(V(q_P)\). The
order-twelve residue ledger forces the necessary condition

\[
F(p_4)\big|_{Z_P}=0;
\]

allowed \(I^{(5)}/I^{(7)}\) corrections cannot alter it.

**Conclusion.** No residual-\(S_3\)-equivariant choice with that boundary
satisfies the condition.

**Proof (Pic⁰).** If the residue vanished with \(p_4\) generically nonzero,
then \(f=[p_4]:Z_P\dashrightarrow E_t\) would be a residual-equivariant
rational map. On an irreducible horizontal quadratic \(L/K\),
\(\xi=[f-O]\in\operatorname{Pic}^0(E_t)(L)\) has constant trace
\(C=\operatorname{Tr}(\xi)\in E_t(\mathbf C)\). Equivariance and
\(P\mapsto P+q\) give

\[
C=\operatorname{Tr}(\xi)=\operatorname{Tr}(\xi+q)=C+2q.
\]

Since \(3q=0\), one has \(2q=-q\neq0\), a contradiction. Split and nonreduced
horizontal quadratics give the same impossibility. \(\square\)

### Finite quotient (house rule 12)

The obstruction class is the nonzero element

\[
-q=2q\in E_t[3]\subset\operatorname{Pic}^0(E_t).
\]

Independence: origin change replaces \(q\) by \(\pm q\); scales and
\(I^{(5)}\)-representatives of \(p_4\) do not change the residue; both
horizontal components give the same pattern. **STOP** for this ansatz — do
not add higher-order corrections around this certified class.

### Strength label

This is a **residual-\(S_3\)-equivariant identity on one elliptic**, for one
factorized ansatz. It is **not** a global \(G\)-equivariant gluing theorem
and does **not** by itself kill the three WP-5 survivor families.

## 3. Induced classes from WP-L2 jets

| jet | target | Pic⁰ content |
|-----|--------|--------------|
| \(a_m\) (leading) | \(E_-\) | Maps exceptional \(\to L_t\); **no** canonical degree-0 class on \(E_t\) |
| \(b_{m+1}\) | \(E_+\) | Can define maps to \(E_t\) only after cutting a cover on which \(b\) projectivizes; \(L_1(b)=B(b;a,a)=0\) is not \(F(b)|_{Z}=0\) |
| \(R_3\) | scalar | Contains \(F_+(b)\); \(F_+|_{E_t}=0\), but contact alone is not a trace obstruction |

Transformations under \(P\mapsto P+q\) and reflections are recorded in
`picard_data.json` for any map that *does* arise.

## 4. Trace tests on live families

| case | applies? | strength |
|------|----------|----------|
| based_minus_lines_odd_m, arbitrary odd \(m\) | **No** | missing equivariant quadratic cover \(\to E_t\) |
| residual_e1_swap_both | **No** | \(e=1\) is source-line coupling, not a plane cover |
| residual_e_ge7_generic_swap_both | **No** | same gap |
| non-planewise corrections | **No** | needs global \(G\)-gluing (not claimed) |
| **Regression: Fable order-twelve** | **Yes** | residual \(S_3\); class in \(E[3]\) |

A structural Pic⁰ kill of the three survivor families would be worth more
than a bidegree kill — but the geometric bridge from those families to an
equivariant quadratic cover map into \(E_t\) is **not established**. That is
a delimited gap, not a negative theorem.

## 5. Files

```text
certificates/elliptic_lifting/PICARD_OBSTRUCTION.md
certificates/elliptic_lifting/produce.py
certificates/elliptic_lifting/verify.py
certificates/elliptic_lifting/picard_data.json
certificates/elliptic_lifting/SEAL.json
```

Replay:

```sh
/opt/homebrew/bin/python3 -u certificates/elliptic_lifting/produce.py
/opt/homebrew/bin/python3 -u certificates/elliptic_lifting/verify.py
```

## 6. Boundary

**Proved:** Pic⁰ formalism; order-twelve quadratic-trace regression; four
trace tests with D / \(S_3\) / \(G\) labels; finite-quotient STOP for the
Fable ansatz.

**Not proved:** Pic⁰ obstruction to any of the three WP-5 families;
global \(G\)-gluing of elliptic classes.

**Headline remains OPEN.**
