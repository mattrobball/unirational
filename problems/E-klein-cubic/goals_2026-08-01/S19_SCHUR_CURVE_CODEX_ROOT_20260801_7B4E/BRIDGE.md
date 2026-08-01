# Re-audit of `BR-SCHUR19-POS`

## Conditional positive bridge

Let \(F=K_{\rm Schur}\), let \(X_T=V(f_3)\subset\mathbf P(W_T)\), and let
\(Z_{55}\subset X_T\) be the certified degree-55 closed point.  For a pure
ambient curve \(B\subset M\simeq\mathbf P^3_F\), the audited chain is:

1. \(B\), \(X_T\), and \(Z_{55}\) are defined over \(F\).
2. No geometric component of \(B\) lies in \(X_T\), so
   \(B\cap X_T\) is proper and zero-dimensional.
3. If \(\deg B=19\), Bézout gives intersection length
   \(3\cdot19=57\).  Multiplicity one at the 55 marked geometric points
   leaves an effective \(F\)-cycle \(R\) of degree two on \(X_T\).
4. If \(R\) has no \(F\)-rational support, its conjugate quadratic support
   spans an \(F\)-line.  The accepted no-\(F\)-line theorem prevents this
   line from lying in \(X_T\); its third cubic intersection is an
   \(F\)-point.
5. The accepted projective-source and quadratic-descent comparison promotes
   an \(F\)-point of the generic Schur twist to the positive
   \(G\)-unirationality headline.

The field, length, noncontainment, residual-line, and final comparison arrows
are explicit in the upstream audit.  The load-bearing condition is step 2.

## Failure for the exact target

The exact target instead imposes \(C\subset X_F\cap M\).  Closed-subscheme
containment reverses ideals:

\[
I_{X_F}=(f_3)\subset I_C.
\]

The scheme-theoretic intersection is defined by the ideal sum, hence

\[
I_{C\cap X_F}=I_C+I_{X_F}=I_C+(f_3)=I_C.
\]

Thus \(C\cap X_F=C\), so the intersection is not proper and has no finite
degree-57 cycle from which \(Z_{55}\) could be subtracted.  This independently
violates Q3 as soon as \(C\) is geometrically integral.

## Minimal coherent correction

The target line would have to be replaced by

```text
B subset M
no geometric component of B lies in X_F
Z_55 subset B intersection X_F with local multiplicity one
```

Substitution into the cubic should then produce the marked degree-55 factor
times a residual binary quadratic; it should not make the cubic vanish
identically on \(B\).  This repair is recorded but not silently adopted.
Under it, the two non-ACM marked branches remain undecided.

## Scope

The literal route is closed.  The corrected ambient rescue construction and
the Klein-cubic headline remain open.
