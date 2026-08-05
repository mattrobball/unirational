# Replay — FIX-H0

Working directory: this packet. Python 3.14 (`/opt/homebrew/bin/python3`),
sympy 1.14.0, Macaulay2 (`/opt/homebrew/bin/M2`). No GAP, Sage, Magma or
PARI/GP is used; msolve is not used at all (so the msolve parenthesis
landmine of `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/MSOLVE_PARSER.md`
does not apply — the single M2 input is nonetheless emitted with bare
integer coefficient vectors).

## Order

```sh
python3 produce_h0.py         # Part A (certificates A1-A6) + Part B   ~65 s
python3 produce_h0_cd.py      # Part C (branch table) + Part D          ~1 s
python3 produce_h0_e.py       # Part E (quotient-complex bookkeeping)  ~44 s
python3 emit_m2.py            # writes m2/eplane_smooth.m2
M2 --script m2/eplane_smooth.m2                                       # ~1 s
python3 verify_h0.py          # independent verifier                    ~9 s
```

## Expected terminal markers

| script | marker |
|---|---|
| `produce_h0.py` | `FIX_H0_PRODUCE_AB_OK` |
| `produce_h0_cd.py` | `FIX_H0_PRODUCE_CD_OK` |
| `produce_h0_e.py` | `FIX_H0_PRODUCE_E_OK` |
| `M2 --script m2/eplane_smooth.m2` | `n_cubics = 55`, `n_singular = 0`, `FIX_H0_EPLANE_SMOOTH_OK` |
| `verify_h0.py` | `checks run: 27, failures: 0` then `FIX_H0_VERIFY_OK` |

`verify_h0.py` contains a **harness self-test**: a deliberately false claim
(`1 == 2`) that must be *recorded* as a failure and then removed; the line

```
    self-test recorded the deliberate failure: True
```

must appear. If it says `False`, the verifier's failure channel is broken and
every other `0 failures` line in this packet is void.

## Independence of producer and verifier

| statement | producer | verifier |
|---|---|---|
| `W±_σ` | nullspace of `M ∓ I` | image of the projector `(I ± M)/2` |
| `F|_{W⁻} ≡ 0`, `F(w+y)` has only even `y`-degrees | symbolic polynomial expansion over `Q(ζ₁₁)` | exact **grid interpolation**: `F(w+y) − F(w−y)` has total degree 3 and is evaluated on `{0,1,2,3}⁵`; vanishing on a grid of side `deg+1` in every variable is a proof of the identity |
| invariant lines in `W±` | ranks of the Reynolds projectors for every linear character of `C_G(σ)`, plus the Burnside algebra-dimension test | character inner products `⟨χ_{W±}, λ⟩` computed from **traces only**, using `tr_{W±}(h) = (tr_W(h) ± tr_W(hσ))/2` |
| `z_σ` off `X` | the unique invariant line inside `W⁺`, lifted | the trivial-isotypic line of the whole of `W` from the Reynolds projector `(1/12)Σ_h h` |
| one conjugacy class | conjugation by all 660 elements | closure of the orbit under conjugation by the generators only |
| branch table | sympy over `QQ(om, B)`; Gröbner reduction in the degree-36 field `K` | independent dict-based expansion in `QQ(om)[B, B^{-1}][x,y,z]` with explicit exponent bookkeeping; 40-digit mpmath at all nine `(c, P₁)` points |
| uniformisation | radicals + symbolic identities | minimal-polynomial/symmetric-function arithmetic + 50-digit mpmath |
| `E_σ` smooth | — | Macaulay2 over `toField(QQ[a]/Φ₁₁)`, all 55 |

## Inputs read (read-only)

* `goal_runs_after_fa02f05/FIX_A3_ELLIPTIC_SITES/klein_exact.py` — copied into
  the packet as `klein_exact.py` (self-contained; no runtime dependency on
  sibling packets).
* `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/payloads/PAYLOAD_witness.txt` —
  the `(1,7)` tuple, transcribed verbatim into `produce_h0_cd.py::cheb_witness`.
* The `D_B` construction (Theorem D) and the witness list from
  `goal_runs_after_fc5e2d3/FIX_N2_CELL_CLASSIFICATION/CELL_TABLE.md` §4.4–4.5;
  the tuples are rebuilt from the construction, not copied.

Nothing outside this packet was written; no git commit was made.
