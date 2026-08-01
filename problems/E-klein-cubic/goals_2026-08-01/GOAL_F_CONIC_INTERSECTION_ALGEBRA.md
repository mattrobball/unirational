# Goal F — solve the exact conic/intersection-algebra criterion

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous theorem/CAS worker in goal mode  
**Priority tier:** serious positive arithmetic route  
**Permitted headline direction:** positive  
**Current headline:** **OPEN**

## 0. Mission

Use the exact fixed-frame cubic over

\[
F=\mathbf C(A,B,Y,Z)
\]

and the exact separable degree-six extension \(K_{\rm proj}/F\) to construct an \(F\)-conic whose length-six intersection algebra with the cubic is isomorphic to \(K_{\rm proj}\). By the accepted conic-algebra equivalence, this gives a \(K_{\rm proj}\)-point of the genuine fixed-frame cubic and a positive headline bridge.

This route is intentionally separate from reconstructing the full Pfaffian–Morita algebra. It attacks the exact finite cover and plane-cubic geometry directly.

## 1. Binding current state

1. The fixed-frame cubic \(C/F\) is the generic member of an exact basepoint-free five-form linear system and has
   \[
   \operatorname{ind}(C/F)=3,
   \qquad C(F)=\varnothing.
   \]
2. The extension \(K_{\rm proj}/F\) has exact degree six, no proper intermediate fields, and geometric monodromy \(S_6\).
3. The natural fixed-binary-direction continuation is excluded: it would produce a cubic intermediate field.
4. A \(K_{\rm proj}\)-point is equivalent to an \(F\)-conic \(Q\subset\mathbf P^2\) for which the finite length-six algebra
   \[
   A_Q=\Gamma(Q\cap C,\mathcal O)
   \]
   is \(F\)-isomorphic to \(K_{\rm proj}\), with the point corresponding to the selected embedding/residue factor.
5. The conic parameter space is \(\mathbf P^5_F\). This is an existential algebraic problem, not a finite list of coordinate conics.
6. Earlier discriminant/resolvent pruning and a fixed-direction search are partial only; neither existence nor emptiness has been proved.

## 2. Exact target

Construct coefficients of a nondegenerate conic

\[
Q=q_{00}x_0^2+q_{01}x_0x_1+\cdots+q_{22}x_2^2=0
\]

over \(F\) and an explicit \(F\)-algebra isomorphism

\[
A_Q\simeq K_{\rm proj}.
\]

Then identify the \(K_{\rm proj}\)-rational intersection point and verify it in the original fixed-frame cubic. All denominators and open conditions must be recorded.

## 3. Work packages

### F0 — rebuild the exact finite extension and criterion

Install a monogenic or other exact presentation

\[
K_{\rm proj}=F[t]/(\mu(t))
\]

with the correct primitive sextic and field open. Reprove the equivalence between:

- a \(K_{\rm proj}\)-point of \(C\);
- an \(F\)-conic whose intersection algebra is \(K_{\rm proj}\);
- the corresponding norm/characteristic-polynomial equations.

Track embeddings and residue idempotents carefully; an abstract isomorphism of degree-six étale algebras must select a genuine point on \(C\).

### F1 — derive low-dimensional equations on conic space

For a universal conic \(Q\):

1. parameterize \(Q\simeq\mathbf P^1\) over a suitable chart or use the rank-three quadratic algebra intrinsically;
2. restrict the cubic to \(Q\), obtaining a binary sextic or a length-six quotient algebra;
3. express equality with \(K_{\rm proj}\) through characteristic polynomials, trace/norm tensors, resolvents, or a Tschirnhaus transformation;
4. quotient by the \(\operatorname{PGL}_2\) reparameterization of \(Q\) without losing descent data;
5. reduce to the smallest exact system over \(F\).

A system valid only after algebraic closure or after choosing an uncontrolled ordering of the six points is insufficient.

### F2 — exploit \(S_6\) monodromy and resolvents

Use the full monodromy to prune impossible conic intersection types and to control descent. Compare:

- discriminants and cubic/quintic resolvents;
- trace forms and different ideals;
- cross-ratio invariants of the six points;
- Galois action on the conic parameterization;
- the known branch divisor and simple transposition.

Seek either an explicit rational section of the conic-to-sextic map at the installed sextic or a finite low-degree torsor whose class can be solved exactly.

### F3 — exact solution and verification

Find a solution by symbolic, modular-reconstruction, homotopy-discovery-plus-certification, or geometric means. Then:

1. reconstruct all conic coefficients in \(F\);
2. prove nondegeneracy;
3. compute \(A_Q\) exactly;
4. construct the algebra isomorphism to \(K_{\rm proj}\);
5. recover the \(K_{\rm proj}\)-point;
6. substitute it into the original fixed-frame equation and all projector/open conditions;
7. apply the accepted versal positive bridge.

## 4. Exits

### Headline success

```text
F-CONIC-ALGEBRA-HEADLINE-POSITIVE
```

Required: exact conic, exact algebra isomorphism, exact point, original-equation verification, and positive bridge.

### Scoped emptiness

```text
F-CONIC-CRITERION-EMPTY
```

If the equivalence in F0 is truly bidirectional for all points, exact emptiness would prove the fixed-frame cubic has no \(K_{\rm proj}\)-point and may feed the negative target route. The worker must explicitly re-audit whether this reaches the headline before claiming more than scoped pointlessness.

### Honest stop

```text
F-UNDECIDED
```

Name the smallest conic-moduli/torsor/algebra equation remaining.

## 5. Prohibitions

1. Do not search only coordinate conics or fixed binary directions.
2. Do not confuse matching discriminants/resolvents with algebra isomorphism.
3. Do not infer a point from an unordered degree-six algebra without selecting the correct residue embedding.
4. No raw elimination on the unreduced universal system without first quotienting reparameterization symmetry.
5. Every point must be checked in the original cubic.
6. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/F_CONIC_ALGEBRA/
```

Provide `STATUS.md`, `CRITERION.md`, exact conic/algebra payloads or an emptiness certificate, producer scripts, an independent verifier, and `SEAL.json`.