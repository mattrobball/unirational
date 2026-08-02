# Exact 27-line algebra / RUR of `S_q` (secondary-0 specializations)

## Marker

```text
G3D-LINE-27-RUR-SPECIALIZED-PASS
```

Residual over full `K_proj`: `G3D-LINE-27-RUR-KPROJ-OPEN`.

## Setup

Canonical polar cubic surface `S_q` from G3D.1A. Work on the **secondary-0
component** of the exact K-valued cubic `G_q`, specialized at good
`t = (t3,t6,t8,t11) ∈ QQ^4`.

## Degree ledger

| Check | Result |
|---|---|
| 6 charts at t=(2,3,5,7) | each dim 0, vdim 27, rad_vdim 27, nprim 1 |
| Multi-spec chart 0 | all listed t: vdim 27 reduced, nprim 1 |
| Expected geometric degree | 27 (smooth cubic surface) |

## RUR (chart 0, t=(2,3,5,7))

Lex Groebner basis has **4** generators (shape lemma):

- `G1 = m(d)` monic-up-to-scalar of **degree 27**, **irreducible over QQ**
- `G2, G3, G4` solve for `c,b,a` as functions of `d`

Files: `minpoly_d.txt`, `rur_G2_c.txt`, `rur_G3_b.txt`, `rur_G4_a.txt`.

**Galois:** one prime of degree 27 ⇒ **no QQ-rational line** at this
specialization (no degree-1 factor).

## Modular check

Prime `10007`: vdim 27; linear factor of minpoly; reconstructed `(a,b,c,d)`
makes all four chart equations vanish.

## Full `K_proj`

Not claimed. Coefficients of `G_q` live in the rank-12 secondary model.
Lifting this RUR to free `K_proj` (or proving the same orbit structure over
`K`) is residual.

## Headline

No `K_proj`-line certified; no Problem-E point.
