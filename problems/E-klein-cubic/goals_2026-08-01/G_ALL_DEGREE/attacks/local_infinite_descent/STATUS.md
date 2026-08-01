# Status

**Exit:** `LOCAL-INFINITE-DESCENT-UNSATURATED-ROUTE-REFUTED`

This is a scoped structural theorem, not a Goal G headline exit.

## Proved

- The complete generic-`V4` symbolic recurrence

  \[
  J_m=xyzJ_{m-2}+((xy)^m,(xz)^m,(yz)^m)
     =\sum_{j=0}^{\lfloor m/2\rfloor}(xyz)^jJ_1^{m-2j}
  \]

  holds in every order and every transverse degree.
- Multiplication by `xyz` injects
  `J_(m-2)/J_m -> J_m/J_(m+2)`.
- Before inverse-character correction, a gcd-one characteristic-zero
  `A4`-equivariant landing tuple exists in `J_3/J_5` in the
  projective-character model.  The actual `W`-valued positive-line-degree
  class acquires a common inverse-character linear factor and is not
  literally primitive.  Multiplication by powers of `xyz` supplies exact
  local landing states for every odd `m >= 3`.
- Finite point jets can be annihilated by common invariant line factors
  without killing the generic line state.  This refutes only unsaturated
  point constraints.
- The elliptic condition `3 | r` is sharp: the marked type-I and type-II
  triples are exact residual-`S3` equivariant split degree-three survivors.
- Common invariant scalar factors explain why raw
  `based_minus_lines_odd_m` and marked coefficient vanishing are not
  primitive support conditions.

## Not proved

- No local state in this folder is called a global coefficient vector or a
  global `G`-covariant.
- The high-twist line/point construction is only a compatible **linear
  symbolic section**.  Its plane interpolation is not known to preserve the
  cubic landing identity.
- No saturated/primitive point-link obstruction is proved or refuted; that
  obstruction remains open after common factors are cancelled.
- This packet proves neither global nonexistence nor global existence and
  makes no unirationality or essential-dimension claim.

## Remaining exact problem

Decide the global nonlinear plus-plane overlap on the complete compatibility
fibre, after saturation by common invariant scalar gcds, together with the
still-open saturated/primitive point-link conditions.  This is the first
place not refuted by the local survivors.

## Replay

```sh
/opt/homebrew/bin/python3 \
  G_ALL_DEGREE/attacks/local_infinite_descent/verify.py
```

Required final lines:

```text
SCOPE gcd-one only before inverse-character correction; actual W class nonprimitive; point-jet no-go unsaturated only; NOT a global covariant
LOCAL_INFINITE_DESCENT_RECURRENCE_OK
```
