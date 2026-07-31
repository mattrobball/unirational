# G4.1 — Symbolic free-fibre terminal residual formula

**Headline: OPEN.**
**Gate G4.1 exit: `G41-FORMULA`.**
**Not claimed: `G-NEGATIVE`, `G-POLYNOMIAL`, all-order `α_r≠0`.**
**Previous cycle: `G-PATTERN` (numerical only) — superseded for free fibre.**

---

## 0. Theorem boundary

This package produces an **exact free-fibre** formula for the polar residual
at the proved isolation cutoff

$$N_\star(m,d)=d+2m+1.$$

It does **not** promote a formal jet to a `G`-covariant, does **not** exclude
global multi-Rees equalizer zeros, and does **not** close `ed_C(G)`.

---

## 1. Symbolic polar recursion (universal jets)

Leading jet (pure powers free open):

$$a = y_0^m f_0 + y_1^m f_1\in \mathrm{Sym}^m E_-^*\otimes E_-.$$

Based-style relative E− jets: $a_{m+2}=a_{m+4}=\cdots=0$.

Ker-$L_1$ seed (first nullspace basis vector):

$$b^{(1)} = -2\, y_0^{m+1} e_1 + y_0\, y_1^{m} e_0.$$

Ansatz at odd relative order $r\ge 1$ (coefficients **independent of $m$**):

`b^{(r)} = alpha_r y0^{m+r} e_{sigma_r} + beta_r y0^{r} y1^{m} e_{tau_r}`

with $\sigma_r = ((r+1)/2)\bmod 3$, $\tau_1=0$, $\tau_r=1$ for $r>1$.

Polar operator on pure powers:

`L(b)=B(b;a,a)=2 b0 y0^m y1^m + b1 y1^{2m} + b2 y0^{2m}`

Recurrence (exact identity in the integer coefficient ring):

$$L\bigl(b^{(r)}\bigr) = -R^{\mathrm{pre}}_r,
\qquad R^{\mathrm{pre}}_r=\sum_{s_1+s_2+s_3=r}\Phi_+\bigl(b^{(s_1)},b^{(s_2)},b^{(s_3)}\bigr)$$

solved on the 2-dimensional ansatz space. Inactive monom classes of
$R^{\mathrm{pre}}$ vanish (consistency of the ansatz).

Computed through $r\le 81$:
all $\alpha_r\neq 0$; growth $|\alpha_r|\ge 2|\alpha_{r-2}|$ for odd
$r\in[5,81]$ (certified in `recurrence_certificate.json`: True).

---

## 2. Structural terminal identity

Let $k=d-m$. Then

$$
\boxed{
\operatorname{Res}_{m,d}
= -L\bigl(b^{(k+1)}\bigr)
=
-B\bigl(b^{(k+1)};a,a\bigr)
}
$$

as a binary form of order $N_\star=d+2m+1$.

Proof sketch:

1. Based a_odd=0 ⇒ only E- jet is a_m (pure powers).
1. Mixed (E+,E-,E-) triples at order N_star require E+ order N_star - 2m = d+1 > d, unavailable as a polynomial jet.
1. Hence Res at N_star is pure triple-E+ Phi_+ of jets b^{(s)}, s odd, m+s <= d i.e. s <= k.
1. Those triples are exactly R_pre at formal stage r = k+1.
1. The recurrence defines b^{(k+1)} by L(b^{(k+1)}) = -R_pre.
1. Therefore Res = -L(b^{(k+1)}).

Support type by $k\bmod 6$ follows from the L-image of $b^{(k+1)}$:

| $k\bmod 6$ | primary support | type |
|----------:|-----------------|------|
| 0 | $y_0^{N-2m} y_1^{2m}$ (and possibly mixed) | A |
| 2 | $y_0^{N}$ and $y_0^{N-3m} y_1^{3m}$ | B |
| 4 | $y_0^{N-m} y_1^{m}$ | C |

---

## 3. Grid and regression

- Grid: 1 <= m <= 11 odd, m <= d <= 6m+25 odd (171 bidegrees).
- Nonzero for every $k=d-m\ge 2$: **True**.
- Expected vanishing at $k=0$ ($d=m$, no E+ jet): **6** points.
- Structural identity holds on every grid point: **True**.
- common_g3 cross-check failures: **0**.

Director samples (regression against G3 sealed towers):

| (m,d) | N★ | residual norm² | C3 weights | match TERMINAL_PATTERN |
|------:|---:|---------------:|------------|:----------------------:|
| (1, 7) | 10 | 1296 | [0] | True |
| (1, 13) | 16 | 156816 | [0] | True |
| (3, 19) | 26 | 15968016 | [2] | True |

All three matches: **True**.

---

## 4. C3/S3 residual characters

The free-fibre residual is a binary form of order $N_\star$ under the residual
C3 action on $E_-$ ($y_0\mapsto \omega y_0$, $y_1\mapsto \omega^{-1} y_1$).
Weight of $y_0^a y_1^b$ is $(a-b)\bmod 3$. Samples:

- `m1_d7`: C3 weights [0], isotypic=True.
- `m1_d13`: C3 weights [0], isotypic=True.
- `m3_d19`: C3 weights [2], isotypic=True.

This is a **local normal-cone obstruction type**, not a full $G$-isotypic
of $\mathrm{Hom}(\mathrm{Sym}^d W,W)^G$.

---

## 5. STOP rule / what is proved

| Proved (exact identity) | Certified finite range | Not proved |
|-------------------------|------------------------|------------|
| Isolation cutoff $N_\star=d+2m+1$ | — | — |
| Universal 2-term jet ansatz + recurrence | $r\le r_{\max}$ integers | closed form of $\alpha_r$ |
| $\mathrm{Res}=-L(b^{(k+1)})$ | all grid $(m,d)$ | — |
| Nonzero residual on grid | $k+1\le r_{\max}$ | all-order $\alpha_r\neq 0$ |
| C3 weight decomposition | samples + formula | full $S_3$ Molien |

The recurrence and structural identity are **not** a mere numerical pattern.
All-order nonvanishing of $\alpha_r$ remains a growth statement certified
only through $r\le 81$.

---

## 6. Files and terminal markers

```text
certificates/global_terminal_module/common_g4.py
certificates/global_terminal_module/produce_free_formula.py
certificates/global_terminal_module/verify_free_formula.py
certificates/global_terminal_module/free_terminal_formula.json
certificates/global_terminal_module/recurrence_certificate.json
certificates/global_terminal_module/FREE_TERMINAL_FORMULA.md
```

```text
G41_FREE_TERMINAL_FORMULA
G41_RECURRENCE_CERTIFICATE
G41_FREE_FORMULA_VERIFY_OK
```

**Headline remains OPEN.**
