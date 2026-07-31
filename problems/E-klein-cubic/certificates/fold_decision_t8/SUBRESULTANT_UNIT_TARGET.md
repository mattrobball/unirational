# T8 — first-subresultant unit theorem

**Headline: OPEN.**  
**Exit: `T8-S1-UNDECIDED`.**  
**Binding:** `WORKORDER_CAS_AFTER_5E72D8E.md` §0, §1, §3, §7, §8; `REPAIR.md` §0, §1, §4, §5.  
**Scope:** T8.1 (and discovery toward T8.2). T8.3/T8.4 not started (director-gated on `T8-S1-UNIT`).

---

## Exact object

\[
R=\mathbf Q[A,B,Y,Z,u],\qquad
J_{s_1}=(H,P,P_u,s_1),\qquad
q=\ell\,P_{uu}\,C\,\delta\,G.
\]

Question:

\[
J_{s_1}:q^\infty\stackrel{?}{=}(1).
\]

- \(P\): sealed global primitive \(u\)-sextic (1593 terms), sha256 `921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344`.
- \(H\): sealed irreducible factor of \(\operatorname{Res}_u(P,P_u)\) (37992 terms), sha256 `b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501`.
- \(s_1\): first principal subresultant coefficient of \((P,P_u)\); circuit, not sparse-expanded.

---

## T8.1 results

### Independent subresultant circuit

Rebuilt without importing T6 producers (`sres_eval_t81.py`, `produce_t81.py`):

- rational Euclidean PRS over \(\mathbf Q\);
- field Euclidean PRS over \(\mathbf F_p\);
- classical \(\operatorname{Sres}_1\) via `sympy.subresultants` for absolute-value / Bézout cross-checks;
- extended Euclidean Bézout: \(s_1 u+s_0=a\cdot P+b\cdot P_u\) pointwise over \(\mathbf Q\).

**Agreement with T6 / classical (discovery + verification samples):**

| Check | Result |
|---|---|
| Zero-locus of Euclidean \(s_1\) vs classical PSC\(_1\) over \(\mathbf Q\) (≥20 random points) | full agreement |
| Same over \(\mathbf F_{89}\), \(\mathbf F_{101}\) (30 points each) | full agreement |
| Common scalar ratio \(s_1^{\mathrm{euc}}/s_1^{\mathrm{cl}}=s_0^{\mathrm{euc}}/s_0^{\mathrm{cl}}\) when nonzero | holds |
| Bézout identity at 3 ambient points | holds |

Sparse multipolynomial expansion of \(s_1\) was **not** completed (same densification barrier as T6: intermediate PRS degree-2 has \(\sim 10^5\) terms). Status: `BOTTLENECK-T8-SRES1-EXPANSION` (optional; circuit is workorder-legal).

### Structural reduction (§4 of dispatch brief) — verified

On \(D(\ell)\) with \(\operatorname{Res}_u(P,P_u)=0\):

\[
s_1=0 \iff \deg_u\gcd(P,P_u)\ge 2.
\]

Verified on \(V(H)\) samples over \(\mathbf F_{101}\), \(\mathbf F_{199}\), \(\mathbf F_{353}\) (0 failures among 26+22+25 independent base points with \(\ell\neq 0\)).

Degree-\(\ge 2\) gcd splits into:

- **(a) binodal:** two distinct double roots, \(P_{uu}\neq 0\) generically at each → lives in the open if other gates pass → **witnesses `T8-S1-NONUNIT`**;
- **(b) cuspidal:** a root of multiplicity \(\ge 3\) forces \(P_{uu}=0\) at that root → killed by the \(P_{uu}\) gate.

Consequently the unit question on the open is equivalent to: the \(s_1=0\) stratum of \(V(H)\), off the gates, is entirely cuspidal (or empty).

The decisive base object is the codimension-2 locus \(V(H,s_1)\subset\mathbf A^4_{A,B,Y,Z}\) (\(H,s_1\) are \(u\)-free). Variable support re-checked: \(\ell,C,H,L,M,Q_4,s_1\) are \(u\)-free; \(P_{uu},\delta\) carry \(u\).

### Directed 2-plane sections (discovery, not UNIT proofs)

Fixed replayable planes (no unseeded RNG), recorded in `planes.json`:

| Plane | Parametrization \((s,t)\mapsto(A,B,Y,Z)\) |
|---|---|
| L1 | \((3+s,\ 5+t,\ 7+2s+3t,\ 11+5s+7t)\) |
| L2 | \((1+2s+5t,\ 4+3s+t,\ s+4t,\ 2+6s+t)\) |
| L3 | \((s+t,\ 1+2s,\ 2+3t,\ 3+4s+5t)\) |
| L4 | \((13+7s+2t,\ 2+5s+9t,\ 8+s+6t,\ 4+3s+11t)\) |

Method: interpolate \(H|_\Lambda\) (deg 43 bivariate, holdouts clean), full \(\mathbf F_p\)-grid of \(V(H)\cap\Lambda\), evaluate \(s_1\) / \(\gcd\) degree, then gates including modular \(F_{27}\).

**Summary (primes 89, 101, 199):** multiple planes carry \(\mathbf F_p\)-points with

\[
H=s_1=0,\quad \deg\gcd=2,\quad \ell\cdot C\cdot L\cdot M\cdot Q_4\cdot F_{27}\neq 0,
\]

and two distinct common roots both with \(P_{uu}\neq 0\) and \(\delta\neq 0\).

**Strong modular NONUNIT witnesses (discovery only):**

| Plane | \(p\) | \((A,B,Y,Z)\) | \(F_{27}\) | roots \(u\) | \(P_{uu},\delta\) |
|---|---:|---|---:|---|---|
| L4 | 101 | \((36,55,77,80)\) | 36 | 46, 72 | all nonzero |
| L4 | 199 | \((125,130,79,75)\) | 8 | 35, 171 | all nonzero |
| L2 | 89 | \((67,81,86,2)\) | 8 | 46, 82 | all nonzero |

At L4/\(p=101\) and L4/\(p=199\), the Jacobian of \((H,s_1)|_\Lambda\) w.r.t. \((s,t)\) is invertible (dets 96 and 29), so these points are **isolated** on the plane section and Hensel-liftable \(p\)-adically. That is not yet a characteristic-zero algebraic certificate.

**Trap observed and respected:** empty or gate-killed sections would **not** prove the unit ideal (affine sections do not bound dimension from above). Nonemptiness of modular gate-pass points is a legitimate discovery signal for `NONUNIT` but is **not** an exact exit.

### What was not obtained (exact)

- No exact Nullstellensatz identity \(q^N\in J_{s_1}\).
- No exact radical / Gröbner certificate of \(J_{s_1}:q^\infty=(1)\).
- No exact algebraic point over \(\mathbf Q\) (or a number field with minimal polynomial) substituted back into the original equations with all gates nonzero.
- Sparse char-0 expansion of \(s_1\) not completed.
- Factorwise saturation T8.2 not closed (exploratory budget used for circuit + directed sections + modular lift attempts; exact QQ plane-section GB / CRT lift remains the bottleneck).

---

## Exit: `T8-S1-UNDECIDED`

| Claim | Status |
|---|---|
| Independent \(\operatorname{Sres}_1\) circuit | installed |
| Bézout identity (pointwise / circuit) | installed |
| §4 structural reduction | verified |
| \(s_1\) unit on open | **not proved exactly** |
| Exact gated \(s_1=0\) point | **not produced** (modular candidates only) |
| Normality / isomorphism | **not inferred** (forbidden) |

Bottleneck:

```text
BOTTLENECK-T8-S1-EXACT-CHAR0-WITNESS
```

Resource floor for the next exact step: characteristic-zero 0-dimensional solve of a plane section of \(V(H,s_1)\) (or Hensel+recognition of an isolated modular binodal point), expected to need the authorized 64 GiB slot with preflight if full multipoly \(s_1\) or high-degree bivariate GB is expanded; alternatively CRT of a rational univariate representation across good primes \(\{89,101,103,107,199,331,353\}\) without expanding \(s_1\) (binodal formulation in \((s,t,u_1,u_2)\)).

Secondary optional bottleneck: `BOTTLENECK-T8-SRES1-EXPANSION`.

**Do not promote modular binodal points to `T8-S1-NONUNIT` without exact char-0 verification.**  
**Do not start T8.3/T8.4 without `T8-S1-UNIT`.**

---

## Artifacts

```text
certificates/fold_decision_t8/
  SUBRESULTANT_UNIT_TARGET.md
  subresultant_identities.json
  factor_ledger.json
  planes.json
  modular_nonunit_discovery.json
  sres_eval_t81.py
  produce_t81.py
  verify_t81.py
  t81_payload.json
```

Supporting work files (not part of the sealed claim surface): `tmp/t8_*/`.

Verifier:

```text
/opt/homebrew/bin/python3 certificates/fold_decision_t8/verify_t81.py
```

**Problem E remains OPEN.**
