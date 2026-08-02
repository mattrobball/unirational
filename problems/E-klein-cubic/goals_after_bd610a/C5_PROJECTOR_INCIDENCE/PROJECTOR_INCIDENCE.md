# Projector-incidence audit

## Full prescribed equations

`projector_incidence.json` indexes every one of the prescribed coordinate
equations in the 36-coordinate rectangle:

```text
36  coordinates of e^2-e,
36  coordinates of sigma(e)-e,
1   reduced-trace equation,
180 coordinates of eS_i e, i=0,...,4.
```

No coordinate equation is discarded.  A 15-dimensional symmetric basis is
not selected, because the binding convention gate proves that doing so would
only present a basis-dependent version of the same false, empty scheme.

## Exact unit-ideal certificate

Let

```text
h_k = coord_k(e^2-e),
g_k = coord_k(eS_0e),
tau_k = Trd(r_k).
```

Since the canonical input gives `S_0=1_A`,

```text
g_k-h_k = coord_k(e).
```

It follows that

```text
sum_k tau_k (g_k-h_k) = Trd(e).
```

The following is an exact characteristic-zero certificate in the prescribed
ideal:

```text
(-1/2) * ((Trd(e)-2) - sum_k tau_k (g_k-h_k)) = 1.
```

Therefore the prescribed ideal is the unit ideal over `K_proj`.  This proof
does not depend on a finite-field computation, a selected chart, or a
coordinate projection.

## Scope

This is a proof that the proposed self-adjoint-projector incidence is empty.
It is not an emptiness proof for the genuine Fano section.  The genuine
section is represented either by the installed equations

```text
q^* H_i q=0
```

in the Morita model, or by the corrected general-idempotent equations

```text
f^2=f, Trd(f)=2, sigma(f)S_i f=0.
```

Consequently no discovery-prime dimension/degree computation, Groebner
solve, point lift, or bridge audit is mathematically authorized for the false
15-variable scheme.

