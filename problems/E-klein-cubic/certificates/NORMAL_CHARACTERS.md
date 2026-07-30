# Normal characters (WP-2)

**Headline: OPEN.**

This certificate decorates the Gate-1 stabilizer stratification of

\[
Y=\mathbf P(W)\simeq\mathbf P^4,\qquad
X=\Bigl\{\sum_{i\in\mathbf Z/5}x_i^2 x_{i+1}=0\Bigr\}\subset Y,\qquad
G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

with tangent and normal representation data needed for first nonzero normal
jets.  It does **not** compute jets, landing covariants, or unirationality.

### Theorem boundary

**Proved here:** for one exact representative of every mandatory stratum orbit
type, the generic projective stabilizer \(H\), setwise stabilizer \(N_G(S)\),
residual \(N_G(S)/H\), the \(H\)-character of \(\mathcal O_Y(1)\), the tangent
module \(T_yY\) (and \(T_yX\) when on \(X\)), normal-bundle fibres as
\(H\)-modules for positive-dimensional strata, and incidence-flag characters
at the V4 triangle.  All four regression targets of the work order.

**Not proved here:** normal jets; associated-graded landing equations; marked
`S3`/`E[2]` geometry (WP-3); any statement about existence or nonexistence of
homogeneous landing self-covariants; \(\operatorname{ed}_{\mathbf C}(G)\).

---

## 1. Representation source and Gate-1 dependency

- Matrices: `certificates/exact_weil_check.py` over \(\mathbf Q(\zeta_{11})\).
- Gate-1 strata/incidence: accepted as sealed
  (`certificates/strata/strata_exact.json`, `incidence_exact.json`).
- Type-I/II verdict (CLAIM_1 survives, CLAIM_2 refuted) is used, not re-litigated.

## 2. Regression targets (all PASS)

| Target | Result |
|--------|--------|
| involution \((\dim E_+,\dim E_-)=(3,2)\) | **PASS** (`tr(t)=1` exact) |
| V4 joint-character dimensions \((2,1,1,1)\) | **PASS** |
| three V4 minus-lines form a triangle | **PASS** (`dim(L_i+L_j)=3`, vertices type-I) |
| D10, D12, both A4 character lines off \(X\) | **PASS** (`F=5`, \(F\neq0\), \(F\neq0\)) |

Replay:

```text
/opt/homebrew/bin/python3 certificates/strata/normal_characters.py
/opt/homebrew/bin/python3 certificates/strata/verify_normal_characters.py
# terminal marker:
NORMAL_CHARACTERS_VERIFY_OK
```

## 3. Orbit-type decorations (summary)

Characters are exact over the stated splitting field.  For a point \(y=[v]\)
with projective stabilizer \(H\) and \(\mathcal O(1)\)-character \(\lambda\),

\[
T_yY\simeq\operatorname{Hom}(\lambda,W/\lambda),\qquad
N_{X/Y,y}\simeq\lambda^{\otimes 3}
\quad\text{(cubic hypersurface)},
\]

and \(T_yX=\ker(dF)\) when \(y\in X\) is smooth.

### Positive-dimensional ambient strata

| Label | \(H\) | \(N_G(S)\) | residual | \(\mathcal O(1)\) | normal fibre as \(H\)-mod |
|-------|-------|------------|----------|-------------------|---------------------------|
| C2 plane \(P(E_+)\) | \(C_2\) | \(D_{12}\) | \(S_3\) | triv | \(\operatorname{sign}^{\oplus 2}\) |
| C2 line \(P(E_-)\subset X\) | \(C_2\) | \(D_{12}\) | \(S_3\) | sign | \(E_+\) (dim 3; see JSON) |
| V4 line \(P(A)\) | \(V_4\) | \(A_4\) | \(C_3\) | triv | \(\chi_z\oplus\chi_s\oplus\chi_r\) |
| C3 eigenline | \(C_3\) | \(C_6\) | \(C_2\) | \(\omega\) or \(\omega^2\) | Hom to complement (JSON) |

### Point strata

| Label | \(H\) | on \(X\)? | \(\mathcal O(1)\) | \(T_yX\) (if on \(X\)) | residual \(N/H\) |
|-------|-------|:---------:|-------------------|------------------------|------------------|
| D10 | \(D_{10}\) | no | triv | — | 1 |
| D12 | \(D_{12}\) | no | unique lin. char. | — | 1 |
| A4(a), A4(b) | \(A_4\) | no | \(1'\), \(1''\) | — | 1 |
| C6(line) | \(C_6\) | yes | faithful \(\zeta_6^k\) | dim 3 | \(C_2\) |
| C6(plane) | \(C_6\) | no | lin. char. | — | \(C_2\) |
| V4 type I | \(V_4\) | yes | \(\chi_z\) at \([B]\) | \(\chi_z\oplus\chi_s\oplus\chi_r\) | \(C_3\) |
| V4 type II | \(V_4\) | yes | triv | \(\chi_z\oplus\chi_s\oplus\chi_r\) | \(C_3\) |
| C5(a), C5(b) | \(C_5\) | yes | \(\zeta_5\), \(\zeta_5^2\) | dim 3 | 1 |
| C11 | \(C_{11}\) | yes | \(\zeta_{11}^{j^2}\) | dim 3 | \(C_5\) (in \(11:5\)) |

### V4 triangle and tangent (detailed)

Joint characters: \(W=A\oplus B\oplus C\oplus D\) with dims \((2,1,1,1)\) and
characters \((\mathrm{triv},\chi_z,\chi_s,\chi_r)\).

Minus-lines: \(L_z=P(C\oplus D)\), \(L_s=P(B\oplus D)\), \(L_r=P(B\oplus C)\),
meeting at type-I vertices \([B],[C],[D]\).

At type-I vertex \([B]\) with \(\lambda=\chi_z\):

\[
T_{[B]}Y\simeq \chi_z^{\oplus 2}\oplus\chi_s\oplus\chi_r,\qquad
T_{[B]}X\simeq \chi_z\oplus\chi_s\oplus\chi_r.
\]

At type-II points on \(P(A)\), the same three nontrivial characters appear in
\(T_yX\).  Residual \(A_4/V_4\simeq C_3\) cycles the three vertices, the three
edges, the three type-II points, and the three local elliptics.

## 4. Artifacts

| File | Role |
|------|------|
| `certificates/strata/normal_characters.json` | sealed character data |
| `certificates/strata/normal_characters.py` | producer |
| `certificates/strata/verify_normal_characters.py` | independent verifier (no producer import) |

## 5. Named remainders

1. **C3 residual 220 points on \(X\):** still combinatorial from Gate 1;
   scheme-theoretic reducedness not sealed here (carried to WP-3 if cheap).
2. **Full flag character tables** for every incidence pair beyond the V4
   triangle and the involution plane/line are recorded at the level of
   \(H\)-module structure in the JSON; explicit matrix models of residual
   actions on all flags for C3/C6/A4 chains are deferred to WP-4 transition
   modules.
3. **WP-3** marked \(S_3\) geometry is separate.

## 6. Seal

```text
/opt/homebrew/bin/python3 certificates/strata/verify_normal_characters.py
```

Marker: **NORMAL_CHARACTERS_VERIFY_OK**.

Content hashes at seal (SHA-256):

| Artifact | SHA-256 |
|----------|---------|
| `certificates/strata/normal_characters.json` | `7651f92b990136e5b06415eaab9018606c9765be21357fa3a2b9e467e33170c6` |
| `certificates/strata/normal_characters.py` | `8cb2a9a7d8b0405672308fc300cecd639de994cd73e29ef272328fa919e5b671` |
| `certificates/strata/verify_normal_characters.py` | `8c7a0e984ab757294c849340e4b4c3801d81d0c04ffefdb73ef9ad80b1bf1bdf` |

JSON body self-hash (excludes `self_sha256` field):
`5fcf161790db120e424a39f4b0f0392fd51b5970271e790ee6a8393115acfb14`.

**NORMAL_CHARACTERS_OK**
