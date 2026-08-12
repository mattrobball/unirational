# The self-map detection principle

Exits: `LAND-IS-A-SELF-BIR-BIMODULE-PROVED`,
`RESTRICTION-IMAGE-IS-A-LEFT-IDEAL-PROVED`,
`COMPOSITE-LANDING-TUPLE-CONSTRUCTION-PROVED`,
`RETRACTION-BRANCH-SURJECTIVITY-PROVED`,
`SELFMAP-DETECTION-COROLLARY-PROVED`,
`FOLIATION-QUOTIENT-DESCENT-PROVED`,
`DETECTION-BY-DEGREE-ALONE-IMPOSSIBLE-PROVED`,
`RESTRICTION-ONLY-CONDITIONS-ENUMERATED`.

Verified exactly: `verify_selfmap_audit.py` (`RESULT: PASS`, 133 checks, ~12 s,
exact integer / `Fraction` / `F_p` arithmetic, no floating point).

**Problem E headline: OPEN.** Nothing here changes it.

---

## 0. Notation, and what is being quotiented

`G = PSL(2,11)` acting on the five-dimensional Klein representation `W`;
`F = x_0^2x_1 + x_1^2x_2 + x_2^2x_3 + x_3^2x_4 + x_4^2x_0 in Sym^3 W^v`;
`X = V(F) ⊂ P(W) = P^4` the smooth Klein cubic threefold; `S = C[x_0,...,x_4]`.

Two objects, both named in the repository:

```
Land := A_G(X) = { A : P(W) --> X  dominant, G-equivariant }
                                   (AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md)
Self := End^{rat,dom}_G(X) = { psi : X --> X  dominant, G-equivariant }
                                   (FULL_G_SELFMAP_CLASSIFICATION/THEOREM.md (4.3))
```

`Self` is a monoid under composition. By the sealed universal-object theorem
(`goal_runs_after_35fa/G_UNIVERSAL/ALL_DEGREE_THEOREM.md`,
`UNIVERSAL_OBJECT.md` Prop 2.1, exit `G2-FINITE-GENERATION-PASS`) an element of
`Land` is the same datum as a nonzero primitive `T in M_d = (Sym^d W^v ⊗ W)^G`
with `F(T) = 0` identically, up to scalar; `d = deg_coord(A)` is its **ambient
coordinate degree**. Likewise a `psi in Self` is the same datum as a primitive
`B in ((S/F)_n ⊗ W)^G` up to scalar; `n = deg_coord(psi)` is its **primitive
coordinate degree on `X`**, and `delta(psi) = deg psi` is its **topological
degree**. The two are different invariants (`EXCLUSION_DPRIME_2_3.md` §3(a)).

The restriction map is

```
res : Land --> Self,       res(A) = phi_A := A|_X,                        (0.1)
```

well defined because `phi_A` is dominant — `goal_runs_20260808/`
`FULL_G_RESTRICTION_DOMINANCE/THEOREM.md`, Theorem 1.1, conditional on the
accepted input `ed_C(PSL_2(F_11)) >= 3` and on nothing else. Writing
`T|_X = H·B` with `H` the invariant of degree `k` cutting the divisorial base
locus `D_X` and `d' = d - k` (`THEOREM_SOURCE_TANGENCY.md` §4), we have
`deg_coord(phi_A) = d'`.

---

## 1(a). The bimodule structure and the left ideal

### 1.1 The two actions

> **Proposition 1.1.** `Land` carries a left action of the monoid `Self` and a
> right action of the group `Bir^G(P^4)` of `G`-equivariant birational selfmaps
> of `P^4`, and the two commute:
>
> ```
> psi . A := psi o A ,      A . g := A o g ,      (psi o A) o g = psi o (A o g).
> ```
>
> That is, `Land` is a `(Self, Bir^G(P^4))`-bimodule (a set with commuting
> monoid actions).

*Proof.* The left action is the sealed postcomposition closure
(`AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md`, Theorem A); its tuple-level
proof is re-supplied in full as Proposition 3.2 below, because the surjectivity
theorem of §1(c) consumes exactly that proof. For the right action: if
`g in Bir^G(P^4)` and `A in Land` then `A o g` is rational, `G`-equivariant
(composite of equivariant maps), dominant (composite of dominant maps), and
lands in `X`. Commutation is associativity of composition of rational maps,
which is legitimate here because every map involved is dominant, so no
composite is undefined at the generic point. ∎

### 1.2 `res` intertwines the left actions only

> **Proposition 1.2.** `res(psi o A) = psi o res(A)` for all `psi in Self`,
> `A in Land`. The right action does **not** descend: in general
> `res(A o g)` is unrelated to `res(A)`.

*Proof.* The first clause is Theorem A's second sentence, and at the tuple
level it is Proposition 3.2(v) below. For the second: `(A o g)|_X` is the
composite `X --g|_X--> g(X) --A--> X`, and `g(X) != X` for a general
`g in Bir^G(P^4)`, so it is not a composite of `phi_A = A|_X` with anything.
The sub-monoid `Bir^G(P^4)_X = { g : g(X) = X }` is the exception, and it is
uninteresting here: an element of it restricts to a birational `G`-selfmap of
`X`, hence to `id_X` by full-`G` birational superrigidity
(`FULL_G_SELFMAP_CLASSIFICATION/DEGREE_ONE_RETRACTION.md`). So on the
restricted side the right action is trivial and `res` is exactly a map of left
`Self`-sets. ∎

> **Corollary 1.3 (the left ideal).** `Im(res) ⊆ Self` is a **left ideal**:
> `Self o Im(res) ⊆ Im(res)`. In particular `Self o phi_A ⊆ Im(res)` for every
> `A in Land`, so a single element of `Land` already forces a whole left ideal
> into the image.

This is the structural reason the detection principle exists at all: to prove
that `Land` is empty it suffices to prove that `Im(res)` cannot contain any
left ideal that some hypothesis forces it to contain. §1(c) turns that into a
usable statement on one branch.

### 1.3 Degree bookkeeping — exactly, with the inequalities where they belong

Fix `psi in Self` of primitive coordinate degree `n` and topological degree
`delta_psi`, and `A in Land` with tuple `T` of ambient degree `d`, common factor
`H` of degree `k`, restricted degree `d' = d-k` and restricted topological
degree `delta`.

**(D1) Topological degrees multiply, exactly.**

```
delta(psi o phi_A) = delta_psi · delta.                                    (D1)
```

Degrees of dominant generically finite rational maps between varieties of the
same dimension multiply; this is Theorem A's last clause and needs no base-locus
correction because the topological degree is a function-field index.

**(D2) Coordinate degrees satisfy an inequality, not an equality.** Choose a
`G`-equivariant ambient lift `Psi in (Sym^n W^v ⊗ W)^G` of `psi` (Lemma 3.1).
Then `Psi(T)` is a `G`-equivariant tuple of degree `n·d` and

```
deg_coord(psi o A) = n·d - deg g   <=   deg_coord(psi) · deg_coord(A),     (D2)
        g := gcd(Psi(T)_0, ..., Psi(T)_4)   (a G-invariant form, possibly 1).
```

Equality holds **iff** `Psi(T)` is already primitive. Two remarks that the
repository's phrasing of Theorem A ("removing a common factor preserves the
landing identity") does not make:

* the drop is real, not bookkeeping. A common factor of `Psi(T)` is exactly a
  divisorial component of the base locus of the composite ambient map, and
  Theorem A gives no reason for it to be trivial;
* `Psi(T)` does **not** depend on the choice of lift. Two lifts differ by
  `F·U` with `U in (Sym^{n-3}W^v ⊗ W)^G`, and `(Psi + F U)(T) = Psi(T) +
  F(T)·U(T) = Psi(T)` because `F(T) = 0` identically. So the only ambiguity in
  (D2) is `g`, and `g` is an invariant of `psi` and `T` jointly.

**(D3) Restricted coordinate degrees, likewise an inequality.**

```
deg_coord(psi o phi_A)  <=  n · d'.                                        (D3)
```

**(D4) The common factor of the composite.** With `T|_X = H B`,

```
Psi(T)|_X = Psi(H B) = H^n · Psi(B),
```

by homogeneity of `Psi`, and `Psi(B)|_X` is the primitive tuple of
`psi o phi_A`. Hence, writing `g` for the ambient content as in (D2),

```
d(psi o A) = n d - deg g,   k(psi o A) = n k - deg g|_X,
d'(psi o A) = deg_coord(psi o phi_A)  <=  n d'.                            (D4)
```

`g|_X` divides `H^n`, so `F` never divides `g` (Proposition 3.2(iii)) and the
restricted picture stays honest.

**(D5) The retraction case is exact.** If `A_0` is a retraction, i.e.
`phi_{A_0} = id_X`, then `T_0|_X = H_0·x` with `deg H_0 = k_0 = d_0 - 1`
(`DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md`, Theorem 1.1, restated in
`THEOREM_ACTUAL_TRANSFER.md` §5), and `Psi(T_0)|_X = H_0^n Psi(x)|_X`, so

```
(d, k, d') (psi o A_0)  =  (n d_0 - deg g,  n(d_0 - 1) - deg g|_X,  n).    (D5)
```

Here (D3) is an equality: `d'(psi o A_0) = n · 1 = n`. Checked arithmetically in
`verify_selfmap_audit.py` block (J) for `d_0 in {35,36,40}` and
`n in {1, 25, 28}`: every resulting cell satisfies `d = k + d'`,
`k in {0} ∪ {5,6,...}`, `d >= 35` and `d' in {1} ∪ {6,7,...}`.

---

## 1(b). The foliation quotient: what descends and what does not

Recall the sealed forced-foliation package. A primitive landing tuple `T` forces
`P_T in (Sym^{2d-4}W^v ⊗ W)^G` with `adj(J_T) = P_T Q_T^t`, `J_T P_T = 0`,
`div P_T = 0` (`THEOREM_FORCED_FOLIATION.md`, Theorem 2.4), a **saturated**
rank-one `G`-invariant algebraically integrable foliation `Fol_T` on `P^4` of
degree `2d-4-deg gcd(P_T)`, a normal leaf space `Y_T` and a factorization

```
P^4 --lambda_T--> Y_T --rho_T--> X,      rho_T finite                      (32)
```

(`FOLIATION_REFORMULATION.md` §6).

> **Proposition 2.1 (what descends to `Self \ Land`).** Let `psi in Self` with
> ambient lift `Psi` of degree `n`, and let `T' = Psi(T)/g` be the composite
> landing tuple. Then
>
> ```
> Fol_{T'} = Fol_T   as saturated foliations,        Y_{T'} = Y_T,
> lambda_{T'} = lambda_T,        rho_{T'} = psi o rho_T.                   (2.1)
> ```
>
> Consequently the assignment `A |-> (Fol_A, Y_A, lambda_A)` is constant on left
> `Self`-orbits and descends to the quotient set `Self \ Land`. The finite map
> `rho_A` does **not** descend; what descends is its class modulo left
> composition by `Self`, i.e. the point of `Self \ {generically finite
> G-equivariant rational maps Y_A --> X}`.

*Proof.* The foliation statement is Proposition 6.1 of
`FOLIATION_REFORMULATION.md` (`R5-9`, confirmed with supplied proof in
`ADJUDICATION.md`): `J_{Psi o T}(x) = J_Psi(T(x)) J_T(x)`, and
`ker J_Psi(y) ∩ T_y C(X) = 0` at the generic point because `psi` is dominant
generically finite in characteristic zero, so
`ker d(Psi o T) = ker dT` **generically**. Passing to the content-free
(saturated) generator kills the discrepancy between `P_{Psi o T} = a·P_T`,
`deg a = 2d(n-1)`, and `P_T`. Division by `g` does not change the projective
map, hence not the generic kernel.

For the leaf data: `Y_T` is the normal model of the relative algebraic closure
`L^{alg}` of `L = T^* C(X)` in `K = C(P^4)`. Postcomposition replaces `L` by
`L_{psi} = T^*(psi^* C(X)) ⊆ L`, a subfield over which `L` is finite (of degree
`delta_psi`). A finite extension has the same relative algebraic closure in `K`,
so `L_psi^{alg} = L^{alg}` and `Y_{T'} = Y_T`, `lambda_{T'} = lambda_T`. Finally
`rho_{T'} o lambda_T = [T'] = psi o [T] = psi o rho_T o lambda_T`, and
`lambda_T` is dominant, so `rho_{T'} = psi o rho_T`. ∎

> **Corollary 2.2 (the honest ledger of the quotient).**
>
> | datum | descends to `Self \ Land`? |
> |---|---|
> | saturated foliation `Fol_A` | **yes** |
> | leaf space `Y_A` with its `G`-action, and `lambda_A` | **yes** |
> | generic leaf (a curve in `P^4`) and its invariants | **yes** |
> | the finite map `rho_A : Y_A -> X` | **no** — only its `Self`-orbit; its degree is multiplied by `delta_psi` and it stops being finite |
> | the unsaturated generator `P_A`, its degree `2d-4`, its content `gcd(P_A)` | **no** — `P |-> a P`, `deg a = 2d(n-1)` |
> | the source-tangency invariant `Delta_A` (degree `2d-2`) | **no** |
> | the ambient degree `d`, the common factor degree `k`, `d'` | **no** |
> | the topological degree `delta` | **no** — multiplied by `delta_psi` |

Two scope corrections, both of which the merged packet flags and which are easy
to over-read:

1. **The kernel equality is generic only.** Over the ramification locus of
   `psi` the two kernels need not agree; the identity `ker d(psi o T) = ker dT`
   is an identity of saturated foliations (equivalently: on a dense open set),
   not an identity of sheaf maps `O(5-2d) -> T_{P^4}`.
2. **Rescaling is not postcomposition.** `T |-> h T` for an ambient form `h`
   genuinely changes the cone-level foliation
   (`J(hT) = h J_T + T (grad h)^t`; block (C1) of `verify_forced_foliation.py`),
   so Proposition 2.1 does not extend to it. The quotient in Corollary 2.2 is by
   the **left** action only.

---

## 1(c). Retraction-branch surjectivity

### 3.1 The two lemmas the theorem consumes

> **Lemma 3.1 (equivariant ambient lift).** Every `psi in Self` of primitive
> coordinate degree `n` admits a lift `Psi in (Sym^n W^v ⊗ W)^G` with
> `Psi|_X = ` (the primitive tuple of `psi`) and `F(Psi) in (F)`.

*Proof.* `psi` is given by a primitive `B in ((S/F)_n ⊗ W)^G` — the
equivariance carries no character because `G` is perfect. The restriction map
`(Sym^n W^v ⊗ W) --> ((S/F)_n ⊗ W)` is a surjective `G`-map (it is the
degree-`n` part of `S --> S/(F)`), and taking `G`-invariants is exact in
characteristic zero, so it is surjective on invariants; choose `Psi` in the
preimage. Then `F(Psi)|_X = F(B) = 0`, i.e. `F(Psi) in (F)`. ∎

The identity `F(Psi) = F·B_Psi` is the source packet's (7.1); Lemma 3.1 is
where "projective normality lifts them to homogeneous forms" acquires the
missing word *equivariantly*.

> **Proposition 3.2 (the composite is a genuine landing tuple).** Let `T` be a
> primitive landing tuple of ambient degree `d` and `Psi` as in Lemma 3.1. Put
> `Theta := Psi(T)`, a tuple of forms of degree `n d`. Then
>
> (i) `F(Theta) = 0` **identically on `P^4`**, not merely on `X`;
> (ii) `Theta` does not depend on the choice of lift `Psi`, and `Theta != 0`;
> (iii) `g := gcd(Theta_0,...,Theta_4)` is a `G`-invariant form and `F ∤ g`;
> (iv) `T' := Theta/g` is a **primitive** landing tuple: `F(T') = 0`
>      identically, `T'` is `G`-equivariant, `[T']` is dominant onto `X`;
> (v) `[T'] = psi o [T]`, and `T'|_X` represents `psi o phi_T`.

*Proof.*

(i) `F(Psi) = F·B_Psi` for some `B_Psi in S_{3n-3}` by Lemma 3.1. Substituting
the tuple `T` into this **polynomial identity in five variables** gives
`F(Psi(T)) = F(T)·B_Psi(T) = 0`, because `F(T) = 0` identically. This is the
only place the ambient landing identity is used, and it is used as an identity,
not as a statement on `X`; this is exactly why postcomposition closes.

(ii) Two lifts differ by `F·U`, and `(Psi + FU)(T) = Psi(T) + F(T)U(T) =
Psi(T)`. For `Theta != 0`: `[T]` is dominant, so `T(x)` is a general point of
the affine cone `C(X)` for general `x`; `psi` is defined at the general point of
`X`, so its cone lift is defined and nonzero at a general point of `C(X)`; hence
`Theta(x) = Psi(T(x)) != 0` for general `x`.

(iii) `Theta` is `G`-equivariant: `Theta(gx) = Psi(g T(x)) = g Psi(T(x))`. The
gcd of the components of a `G`-equivariant tuple is `G`-semi-invariant, and `G`
is perfect, so it has no nontrivial characters and `g` is `G`-invariant. For
`F ∤ g`: `Theta|_X = Psi(T|_X) = Psi(H B) = H^n Psi(B)`, and `Psi(B)|_X` is the
primitive tuple of the dominant selfmap `psi o phi_T`, hence nonzero on `X`;
also `H|_X != 0` by construction. So `Theta|_X != 0`, i.e. `F ∤ g`.

(iv) `F(T') = F(Theta)/g^3 = 0` by cubic homogeneity of `F` and (i); the
division is exact in the polynomial ring because `g` divides every `Theta_i`.
Equivariance survives because `g` is invariant by (iii). Primitivity is by
construction. Dominance: `[T'] = psi o [T]` is a composite of dominant maps.

(v) Clearing a common factor does not change the induced projective map, so
`[T'] = [Theta] = psi o [T]` as rational maps `P^4 --> X`; restricting to `X`
gives `T'|_X = H^n Psi(B) / g|_X` and `[T'|_X] = psi o phi_T`. ∎

This is the content the repository's one-paragraph proof of Theorem A
compresses. Three steps in it are not formal and each fails without its
hypothesis: the **equivariance** of the lift (Lemma 3.1 — without exactness of
invariants in characteristic zero there is no equivariant `Psi`); the passage
from `F(Psi) in (F)` to `F(Theta) = 0` **identically** (which uses that the
landing identity for `T` is an identity, and is precisely the difference between
(7.1) and (7.2) of `FULL_G_SELFMAP_CLASSIFICATION/THEOREM.md`); and `F ∤ g`
(without it "divide by the content" could destroy the restricted map).

### 3.2 The theorem

> **Theorem 3.3 (retraction-branch surjectivity).** Suppose some `A_0 in Land`
> has `phi_{A_0} : X --> X` **birational**. Then
>
> ```
> res : Land --> Self  is surjective,
> ```
>
> and explicitly, for every `psi in Self`,
>
> ```
> psi = res( (psi o phi_{A_0}^{-1}) o A_0 ) = ( (psi o phi_{A_0}^{-1}) o A_0 )|_X.
> ```

*Proof.* `phi_{A_0}^{-1}` is again a `G`-equivariant dominant rational selfmap
of `X` (the inverse of a `G`-equivariant birational map is `G`-equivariant), so
`chi := psi o phi_{A_0}^{-1} in Self`. By Proposition 3.2, `chi o A_0 in Land`,
and by Proposition 1.2, `res(chi o A_0) = chi o phi_{A_0} = psi`. ∎

> **Corollary 3.4 (collapse of the hypothesis — carries an accepted input).**
> `FULL_G_SELFMAP_CLASSIFICATION/DEGREE_ONE_RETRACTION.md` §1 states that a
> dominant `G`-equivariant rational selfmap of `X` of degree one is `id_X`; its
> proof invokes **full-`G` birational superrigidity** to turn a birational map
> into a regular one, and then `Aut^G(X) = Z(G) = 1`. Taking that as the
> repository does, the hypothesis of Theorem 3.3 is **equivalent to** "`A_0` is
> a retraction", i.e. `phi_{A_0} = id_X`; then `phi_{A_0}^{-1} = id_X` and the
> composition in Theorem 3.3 is plain postcomposition, `psi = (psi o A_0)|_X`.

The general form of Theorem 3.3 is stated and proved first **because it does not
use superrigidity**. That matters for the honesty of the conditionality ledger:
Theorem 3.3 needs only Propositions 1.2 and 3.2 (and, through the well-definedness
of `res`, the accepted `ed_C(G) >= 3`), whereas Corollary 3.4 additionally
consumes the accepted superrigidity input. See `ADVERSARIAL_TESTS.md` A12.

> **Corollary 3.5 (DETECTION COROLLARY).** If **one** `psi_0 in Self` is
> provably **not** the restriction of any landing tuple, then
>
> ```
> no A in Land has phi_A birational,  i.e. delta(phi_A) != 1 for every A.
> ```
>
> Granting the accepted input of Corollary 3.4, this says exactly: **the
> retraction branch is empty** — there is no primitive `G`-equivariant landing
> tuple `T` with `T|_X = H·x`.

*Proof.* Contrapositive of Theorem 3.3, then Corollary 3.4. ∎

The first conclusion (`delta(phi_A) != 1` for all `A`) is the unconditional one
and is already a branch closure in the sealed `delta`-indexed tables; the
identification of that branch with the retraction normal form `T = Hx + FQ` is
where the accepted input enters.

Note the asymmetry that makes this useful: the hypothesis is about **one**
self-map, chosen by us, and the conclusion is about **all** ambient degrees at
once. No degree sweep is involved.

### 3.3 Adversarial duty: consistency with the sealed retraction facts

The sealed retraction facts are

| fact | source |
|---|---|
| `phi_{A_0} = id_X => D_X != 0` | `THEOREM_ACTUAL_TRANSFER.md` Cor 5.1 (`RT-DX0-PROVED` contrapositive) |
| `D_X in \|k H_X\|` with `k = deg H_0 >= 5` | `THEOREM_ACTUAL_TRANSFER.md` Cor 5.2 + `COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED` |
| retraction normal form `T = H x + F Q`, so `d = k+1` | `DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md` Thm 1.1 |
| `d >= 24` for a retraction | `AMBIENT_REES_SELFMAP_CLASSIFICATION/RETRACTION_DEGREE_BOUND.md` (`DELTA1-RETRACTION-COORDINATE-DEGREE-AT-LEAST-24`) |
| `delta = 1` is a norm, `u_phi = ±1` on `H^3`, so the norm sieve never touches this branch | `THEOREM_RESTRICTED_DICHOTOMY.md` Cor 4.3 |
| ambient floor `d >= 35` | `D34_GUIDED_SWEEP/THEOREM.md` (`LADDER-EMPTY-THROUGH-34`) |

**Consistency.** Combining (D5) with these: a retraction has `d_0 >= 35` (the
ambient floor is stronger than the sealed `d_0 >= 24`), hence
`k_0 = d_0 - 1 >= 34`. The composite `psi o A_0` for `psi` of coordinate degree
`n` lands in the cell `(d,k,d') = (n d_0, n(d_0-1), n)` when `Psi(T_0)` is
primitive. Every sealed constraint is satisfied for every `n in {1} ∪ {6,7,...}`:
`d = k + d'` exactly; `k = n(d_0-1) >= 34`, so `k in {0} ∪ {5,6,...}`;
`d = n d_0 >= 35`; `d'` is in the sealed surviving set. There is **no
inconsistency**, and none was expected: the composition is a construction, not a
constraint. Checked arithmetically in `verify_selfmap_audit.py` block (J).

**Two sharper constraints the composition does produce.** Both are recorded as
new, and neither closes anything.

> **(S1) The tangency constant on the retraction-composition cells is `d_0`.**
> For `T_psi = Psi(T_0)` primitive, `d/d' = n d_0 / n = d_0`, so
> `THEOREM_SOURCE_TANGENCY.md` (34) reads
> ```
> Delta_{T_psi}|_X = d_0 · H_0^{2n} · j_psi ,
> ```
> independently of `psi`. Taking `psi = id` recovers the branch table's
> `k = d-1` normal form `Delta_T|_X = d·H^2` exactly. So the whole
> `Self`-orbit of a retraction has **one** tangency constant, namely the
> retraction's own ambient degree. This is a rigid normal form on an infinite
> family, and it is the sharpest thing the composition says about `Delta`.

> **(S2) The retraction branch imports the CLEAN/CARRIER dichotomy for the
> whole of `Self`.** If `A_0` is a retraction then, for **every** `psi in Self`,
> the landing tuple `psi o A_0` has restricted topological degree
> `delta(psi)`, so by `THEOREM_RESTRICTED_DICHOTOMY.md` Theorem 3.1 either its
> graph is CLEAN — and then
> ```
> delta(psi) = x^2 + xy + 3y^2   for some x,y in Z                        (S2)
> ```
> — or its graph is CARRIER. Contrapositive, and this is the concrete detection
> lever: **exhibiting one `psi in Self` whose topological degree is not
> represented by `x^2+xy+3y^2`, together with an exclusion of the CARRIER
> branch for it, kills the retraction branch.** The norm form does not
> represent `2, 6, 7, 8, 10` (checked exactly, block (J)); `2` is already
> excluded for all self-maps by the deck-involution argument, so the first
> usable target values are `delta in {6,7,8,10,...}`. Neither half of the lever
> is available today: no `delta(psi)` has been computed (§4 of
> `SELFMAP_AUDIT.md`), and CARRIER is not excluded.

---

## 1(d). Scope honesty: why degree bookkeeping cannot detect

> **Proposition 4.1.** No `psi in Self` can be shown to lie outside `Im(res)` by
> its coordinate degree `n = deg_coord(psi)` alone, nor by its topological
> degree `delta(psi)` alone.

*Proof.* **Coordinate degree.** The sealed restricted-degree exclusions are
statements about `G`-equivariant tuples on `X`, not about restrictions:
`D35_K30_K31_CELLS.md` Corollary 3.3 reads *"There is no `G`-equivariant
rational selfmap of `X` of primitive coordinate degree `4` or `5`, dominant or
not"*, and §8 of the same file re-proves `d' in {2,3}` by the same
covariant-space route, which likewise never mentions a landing tuple. So

```
every psi in Self already satisfies  deg_coord(psi) in {1} ∪ {6,7,8,...}.  (4.1)
```

Conversely, for every `n` in that set the branch tables leave cells open: for
`n = 1` the retraction cell `(d,k) = (d, d-1)` is open at every `d >= 35`; for
`n >= 6` the cells `(d,k) = (n+k, k)` with `k >= max(5, 35-n)` are open (they
are the `k = 5..29` band at `d = 35` and its analogues). In particular `n = 25`
has the open cells `(35,10), (36,11), ...`. So the constraint set on `n` imposed
by "being a restriction" is exactly (4.1), which every self-map satisfies
anyway. Verified in `verify_selfmap_audit.py` block (J).

**Topological degree.** `delta = 1` forces `psi = id_X` and `delta = 2` is
excluded, both for **all** `G`-selfmaps
(`FULL_G_SELFMAP_CLASSIFICATION/THEOREM.md` §4). For `delta >= 3` the CARRIER
branch of `THEOREM_RESTRICTED_DICHOTOMY.md` imposes no arithmetic condition on
`delta` at all, so no value of `delta >= 3` is excluded for restrictions. ∎

So detection must use conditions that a restriction satisfies and an abstract
self-map need not. Here they are, exactly.

### 4.2 The restriction-only necessary conditions, enumerated

Let `psi in Self` with primitive coordinate degree `n` and topological degree
`delta`. If `psi = phi_A` for `A in Land` with tuple `T`, ambient degree `d`,
common factor `H` of degree `k` and `d' = d-k = n`, then:

**(R1) AMBIENT EXTENSION (the definition, and the only complete condition).**
There is a tuple `T in (Sym^d W^v ⊗ W)^G`, `d = n + k`, with

```
F(T) = 0  identically on P^4        and        T|_X = H · B_psi.          (R1)
```

Every abstract `psi` satisfies only the weaker `F(Psi) = F·B_Psi` (Lemma 3.1);
the gap between `F(Psi) = F B_Psi` and `F(T) = 0` is precisely (7.1) versus
(7.2) of `FULL_G_SELFMAP_CLASSIFICATION/THEOREM.md`, and it is the whole
problem. Everything below is a consequence of (R1).

**(R2) THE TANGENCY FACTORIZATION.** With `Delta_T = grad F · P_T` the
source-tangency invariant of the ambient tuple,

```
Delta_T|_X = (d/d') · H^2 · j_psi   in H^0(X, O_X(2d-2))^G,
div_X(Delta_T) = 2 D_X + R_psi,     R_psi ~ (2n-2) H_X,                   (R2)
```

with `H` of degree `k`, and `k >= 5` whenever the restriction is not a
retraction and has a common factor at all
(`COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED`). An abstract self-map has a
ramification divisor `R_psi` but no ambient `Delta_T` for it to be a cofactor
of. **Honest caveat:** by `FOLIATION_REFORMULATION.md` Proposition 5.1 the map
`P |-> grad F·P (mod F)` from divergence-free covariants onto
`H^0(X,O_X(m+2))^G` is surjective for every `m >= 4`, so (R2) imposes **nothing
on `psi` alone**. It bites only through the simultaneous coupling with
`adj(J_T) = P_T grad F(T)^t` for the same `T`.

**(R3) THE FORCED FOLIATION.** There is a `G`-invariant rank-one algebraically
integrable foliation on `P^4` of degree `2d-4-deg gcd(P_T)`, with normal leaf
space `Y_T`, a finite `G`-equivariant `rho_T : Y_T -> X`, and
`psi = (rho_T o lambda_T)|_X` up to the common factor. An abstract self-map
carries no ambient foliation.

**(R4) THE CLEAN / CARRIER DICHOTOMY OF THE AMBIENT GRAPH.** Exactly one of:
`r_phi = 0` (CLEAN), and then `u_psi in O_{Q(sqrt(-11))}` with
`u_psi^† u_psi = delta`, hence `delta = x^2+xy+3y^2`; or `r_phi != 0`
(CARRIER), and then there is a proper irreducible strict support
`T_supp ⊆ Bs(J)` with `dim T_supp <= 1`. Moreover `D_X = 0 => CARRIER`
(`RT-DX0-PROVED`), i.e. `k = 0` forces CARRIER. This is the **only** condition
in the list that constrains a quantity intrinsic to `psi`, and only in one
branch.

**(R5) THE DEGREE CELL.** `d = k + n`, `k in {0} ∪ {5,6,...}`, `d >= 35`; with
`k = 0 <=> d = n` (and then CARRIER), and `n = 1 <=> ` retraction (and then
`k = d-1 >= 34` and `D_X != 0`).

**(R6) FORCED AMBIENT BASE STRATA.** For a global ambient landing tuple every
plus-plane is a forced base component
(`FULL_G_SELFMAP_CLASSIFICATION/FIXED_NETWORK_SELFMAPS.md` §4); the intrinsic
tangent-residual construction is explicitly built so as to be able to avoid every
positive-dimensional fixed locus (ibid. §2). This is the condition with the
clearest "restriction-only" flavour, and it is also the least developed: no
statement of the form "an abstract self-map with such-and-such behaviour on the
plus-planes cannot be a restriction" exists in the repository.

### 4.3 Where the detection lever actually is

Of (R1)–(R6), only (R4) evaluates a quantity of `psi` alone, and only on the
CLEAN branch. So the shortest honest route to a detection is:

```
find psi in Self with delta(psi) not represented by x^2+xy+3y^2,
and exclude the CARRIER branch for psi o A_0.
```

Both halves are open. The audit in `SELFMAP_AUDIT.md` computes the missing
*coordinate* degrees exactly and records that `delta` is the unresolved
quantity, with the exact blowup point.

---

## 5. Non-claims

* Theorem 3.3 and Corollary 3.5 are **conditional on nothing new**, but they
  inherit the conditionality of `res` being well defined, i.e. of restricted
  dominance, i.e. of the accepted input `ed_C(PSL_2(F_11)) >= 3`. If one wants a
  completely unconditional statement, replace `Self` by the monoid of
  `G`-equivariant rational selfmaps (dominant or not) and `res` by the partial
  map defined where the restriction is dominant; the proofs go through verbatim
  for those `A` whose restriction is dominant.
* No self-map is shown to be outside `Im(res)`. **The retraction branch is not
  killed.**
* Proposition 2.1 quotients the left action only. It says nothing about
  precomposition by `Bir^G(P^4)`, nor about rescaling `T |-> hT`.
* (D2)–(D4) are inequalities. No lower bound for `deg_coord(psi o A)` is proved
  here, and in particular nothing rules out `deg g` being large.
* (R1)–(R6) is a list of **necessary** conditions. No claim that they are
  jointly sufficient, and no claim that the list is complete.

**Problem E headline: OPEN.**
