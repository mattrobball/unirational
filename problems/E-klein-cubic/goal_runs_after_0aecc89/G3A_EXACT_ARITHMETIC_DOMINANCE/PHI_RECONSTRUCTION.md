# G3A — reconstruction of \(\Phi\)

## Definition

With frame \((x,C,D,E,K_7)\) of degrees \((1,4,5,6,7)\) and \(\tau=f_3^2/f_5\),

\[
\Phi(a)=F\!\left(
 a_0\frac{x}{\tau}+a_1\frac{C}{\tau^4}+a_2\frac{D}{\tau^5}
 +a_3\frac{E}{\tau^6}+a_4\frac{K_7}{\tau^7}
\right).
\]

The 35 symmetric coefficients live in \(K_{\mathrm{proj}}\) and are stored in

```text
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
```

## Independent rebuild

`verify_phi.py` reconstructs every coefficient from the literal Klein
covariant frame (`certificates/exact_covariants_check.py` via
`tmp/generic_twist/phi_coefficients.py`), expands the polynomial identity, and
checks coefficient-wise equality with `generic_cubic.json`, including:

- complete nondecreasing triple support (35 triples);
- every secondary-basis component and projective normalization
  \((a_3,a_5,a_6,a_8,a_{11})\mapsto(a_3+2a_5,a_6,a_8,a_{11})\);
- weight / degree identities against frame degrees;
- denominator-clearing back to the original homogeneous identity (via
  `verify_expansion`).

## APIs (`src/phi_api.py`)

```text
load_generic_cubic, coefficient_map, coefficient_entries,
polarization_B, first_partials_specialized, second_partials_specialized,
jacobian_matrix_specialized, specialize_entries_mod_p
```

Polarization and Jacobian helpers are exercised on a secondary-0 slice for
API consistency; the load-bearing coefficient identities are the full
`K_{\mathrm{proj}}\) reconstruction above.
