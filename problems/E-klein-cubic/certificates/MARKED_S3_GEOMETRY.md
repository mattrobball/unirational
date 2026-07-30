# Marked residual \(S_3\) geometry (WP-3)

**Headline: OPEN.**

This certificate freezes the residual normalizer geometry of a fixed involution
\(t\in G=\operatorname{PSL}_2(\mathbf F_{11})\) on

\[
X^t=E_t\sqcup L_t,\qquad
E_t=X\cap\mathbf P(E_+(t))\ \text{smooth plane cubic},\qquad
L_t=\mathbf P(E_-(t))\simeq\mathbf P^1\subset X,
\]

with residual group \(N_G(\langle t\rangle)/\langle t\rangle\cong S_3\).

### Theorem boundary

**Proved here:** exact residual \(S_3\) structure; marked point counts on \(L_t\)
(two \(C_6\), six type-I); exact \(j(E_t)=8192/11\) in characteristic zero;
freeness of residual order-three as translation by nonzero \(q\in E_t[3]\);
structural proof of the \(E[2]\)-charge labeling after origin choice; consistency
with the Gate-1 type-II triple-elliptic verdict.

**Not proved here:** explicit Weierstrass coordinates of \(q\) and the three
nonzero \(2\)-torsion points in a fixed integral model; scheme-theoretic
reducedness of the 220 residual \(C_3\)-points (carried forward); normal jets or
landing covariants; unirationality; \(\operatorname{ed}_{\mathbf C}(G)\).

**Tooling substitution.** The work order names SageMath for WP-3. SageMath is
not installed on this machine. All elliptic-curve computations use
**PARI/GP** (`/opt/homebrew/bin/gp`): `ellfromeqn`, `ellfromj`, `Ea.j`,
`elltors`, `polclass`. Recorded in the JSON under `sage_substitution`.

---

## 1. Residual \(S_3\)

For the standard involution \(t=S\) from `exact_weil_check.py`:

| Object | Value |
|--------|------:|
| \(\|C_G(t)\|\) | 12 |
| residual \(C_G(t)/\langle t\rangle\) | \(S_3\) (order 6) |
| order-3 elements in \(C_G(t)\) | 2 |
| order-2 elements in \(C_G(t)\setminus\{t\}\) | 6 |
| order-6 elements in \(C_G(t)\) | 2 |
| Sylow \(V_4\)s through \(t\) | 3 |

## 2. Geometry of \(L_t\)

Exact: \(F|_{E_-}\equiv 0\) by parity (\(t=-1\) on \(E_-\)), so
\(L_t\subset X\) scheme-theoretically.

### Marked points

| Marked set | Count | Description |
|------------|------:|-------------|
| \(C_6\) points | 2 | Fix of residual \(C_3\) on \(L_t\); size-two \(S_3\)-orbit |
| type-I \(V_4\) points | 6 | two per residual reflection (three reflections) |

Certified modularly at \(p=67\) and \(p=331\) by restricting residual generators
to \(E_-\) and computing projective fixed points; counts and orbit sizes agree.
Tangent multipliers are eigenvalue ratios of residual generators on \(E_-\);
cross-ratios of the marked configuration are recorded mod \(p\) in the JSON.

### \(S_3\)-orbits on \(L_t\)

- **Size-two order-three orbit:** the two \(C_6\) points.
- **Type-I points:** six points, partitioned by the three residual reflections
  into three fixed pairs; full \(S_3\)-orbit sizes recorded modularly in JSON
  (`typeI_S3_orbit_sizes` at 67 and 331).

## 3. Geometry of \(E_t\)

### Exact \(j\)-invariant

\[
j(E_t)=\frac{8192}{11}=\frac{2^{13}}{11}.
\]

**Proof.**

1. All involutions are conjugate, so the isomorphism class of \(E_t\) is
   \(G\)-invariant and \(j(E_t)\in\mathbf Q\).
2. Restrict \(F\) to \(E_+(t)\) over the good reductions at the ten primes
   \(23,67,89,331,353,397,419,463,617,661\) (all split for \(\zeta_{11}\)).
   Convert the plane cubic to Weierstrass via PARI `ellfromeqn` and read \(j\).
3. Chinese remainder + rational reconstruction uniquely yields \(8192/11\)
   (height far below the CRT modulus).
4. Direct check: \(8192\cdot 11^{-1}\equiv j_p\pmod p\) at every sample prime.
5. PARI `ellfromj(8192/11)` returns a Weierstrass model with this \(j\).

### Director hint \(j=-32768\) — **REFUTED**

The Hilbert class polynomial of discriminant \(-11\) is \(x+32768\), so
\(j=-32768=-2^{15}\) is the \(j\)-invariant of the CM curve by
\(\mathbf Z[\sqrt{-11}]\).  Our \(j=8192/11\) is **not** a root.  Moreover
\(8192/11\) is not an algebraic integer, so \(E_t\) has **no complex
multiplication** by any imaginary quadratic order.

### Free residual order-three

**Theorem.** The residual order-three element acts freely on \(E_t\), as
translation by a nonzero \(q\in E_t[3]\).

**Proof.** Any order-three algebraic automorphism of a genus-one curve is
translation by nonzero \(3\)-torsion after choosing an origin, unless it is a
group automorphism of \((E,O)\).  Group automorphisms of order three occur only
for \(j=0\).  Here \(j=8192/11\neq 0\), so \(\operatorname{Aut}(E,O)=\{\pm1\}\)
and residual \(\rho\) is free translation by unique \(q\in E_t[3]\setminus\{0\}\)
(up to \(q\leftrightarrow -q\)).

### Marked \(V_4\) points on \(E_t\)

| Type | Count per \(E_t\) | Source |
|------|------------------:|--------|
| type I | 3 | one \(Q\)-vertex per \(V_4\) through \(t\), lying in \(E_+\) |
| type II | 9 | three per \(V_4\) through \(t\) (\(R=X\cap P(A)\)) |

Agrees with Gate 1: type-II points are triple elliptic meetings; on a fixed
\(E_t\), nine type-II points arise as \(3\) \(V_4\)s \(\times 3\) type-II each.

### \(E[2]\)-charge model — **PROVED structurally**

**Proposed labeling** (after origin choice):

```text
type-I orbit   = <q>
type-II orbits = e + <q>,  for 0 ≠ e in E_t[2]
```

**Theorem.** After choosing an origin \(O\) on \(E_t\) to be one of the three
type-I points, there is \(q\in E_t[3]\setminus\{0\}\) (unique up to sign) such
that residual \(C_3\) acts by translation by \(q\), the type-I set equals
\(\langle q\rangle=\{O,q,2q\}\), and the nine type-II points are the three
cosets \(e+\langle q\rangle\) for the three nonzero \(2\)-torsion points.  Residual
\(S_3\) is generated by translation by \(q\) and the three hyperelliptic
involutions \(P\mapsto e-P\).

**Parts that are theorems.**

1. Free order-three as translation by nonzero \(q\in E[3]\) (from \(j\neq 0\)).
2. Type-I set is a single \(C_3\)-orbit of size 3.
3. Type-II set is a union of three \(C_3\)-orbits of size 3.
4. The marked 12-point set is \(S_3\)-stable and equals \(E[2]\oplus\langle q\rangle\).
5. Charge labeling as above after origin choice at a type-I point.

**Parts not claimed.** Explicit numerical Weierstrass coordinates of \(q\) and
the \(e_i\) in a fixed global minimal model (existence/uniqueness up to sign
only); integral models and reduction types beyond \(j\).

## 4. C3 residual 220 points

**Status: CARRIED FORWARD.**

Combinatorial count sealed in Gate 1 (110 \(C_3\)-lines \(\times 2\) residual
points).  Modular binary-cubic root counts at \(p=331\) are consistent with
three distinct points per nontrivial eigenplane, but this is **not** a
characteristic-zero scheme-theoretic reducedness certificate.  No large Gröbner
basis was run.

## 5. Artifacts and replay

| File | Role |
|------|------|
| `certificates/strata/marked_s3_geometry.py` | producer |
| `certificates/strata/marked_s3_geometry.json` | sealed data |
| `certificates/strata/marked_s3_geometry.pari-substitute` | portable PARI script (Sage substitute) |
| `certificates/strata/verify_marked_s3.py` | independent verifier |

```text
/opt/homebrew/bin/python3 certificates/strata/marked_s3_geometry.py
/opt/homebrew/bin/gp -q certificates/strata/marked_s3_geometry.pari-substitute
/opt/homebrew/bin/python3 certificates/strata/verify_marked_s3.py
# terminal marker:
MARKED_S3_VERIFY_OK
```

## 6. Seal

```text
/opt/homebrew/bin/python3 certificates/strata/verify_marked_s3.py
/opt/homebrew/bin/gp -q certificates/strata/marked_s3_geometry.pari-substitute
```

Markers: **MARKED_S3_VERIFY_OK**, **MARKED_S3_PARI_OK**.

Content hashes at seal (SHA-256):

| Artifact | SHA-256 |
|----------|---------|
| `certificates/strata/marked_s3_geometry.json` | `6662f850028c4df8c7e33a1749d948153d0fc9ca6da4b733daa88536343a59a6` |
| `certificates/strata/marked_s3_geometry.py` | `a90d50ce039c02084216921d9cd3580a1f204463c151dbff0b93cd41f9323018` |
| `certificates/strata/marked_s3_geometry.pari-substitute` | `0cded00abdbbafbf739dde5b472c0cc27a8e0abb487b71b9e6e58baec8539636` |
| `certificates/strata/verify_marked_s3.py` | `0cb29c700150b0ecf1583595ac617abf5b81d794cbea72080a81570c642ab4e8` |

JSON body self-hash (excludes `self_sha256` field):
`365756f80de7d655d44e9ef3145b85b5c72614b74bf9cde79c5cd26c534fc01e`.

**MARKED_S3_GEOMETRY_OK**
