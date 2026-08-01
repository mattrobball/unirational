# Resource preflight and remaining finite computation

No full Gröbner, determinantal, or elimination job was launched.

The normalized split presentation has 220 incidence equations in an ambient
dimension ledger of 190.  Before expansion it has at most about 4,620
displayed incidence terms.  The quintic substitution block has 96 x 56 =
5,376 polynomial entries, each of degree five in 80 map coefficients.

The rank-55 determinantal equation set has

`binomial(96,56) = 1,709,451,737,069,041,941,337,340,712`

maximal minors.  The rank-55 open cover itself has

`56*binomial(96,55) = 130,752,210,913,378,427,513,021,962,752`

possible 55-minor charts.  Enumerating those minors, rather than using the
96 carrier-coefficient alternative, is structurally inappropriate.

The epsilon-one carrier formulation replaces maximal-minor enumeration by
96 coefficient equations with ten quadric parameters.  Even then, the
required saturation includes the basepoint-free, embedding, distinct-mark,
proper-intersection, and multiplicity-one gates before projection to the
four h-parameters.  A smaller earlier elimination in the audited upstream
work exceeded the 8 GiB exploratory ceiling.  This larger symbolic job was
therefore not started without a chart/sparsity implementation and a measured
checkpoint plan.

The companion `marked_incidence_presentation.json` makes the preferred
branch gate smaller still: use the 96 x 11 restriction matrix for
`I_Z(5)=F3_h*S2+<F5_h>`.  The full 96 x 56 matrix remains the independent
definition, while the 11-column block is the exact computational route.

The next exact computation is finite and fully specified:

1. Choose a named nonzero 11-minor chart for epsilon zero, or a rank-10
   compressed-kernel plus carrier chart for epsilon one.
2. Add every qualification saturation from
   `marked_component_presentation.json`.
3. Perform sparse modular elimination in several good characteristics only
   as reconnaissance.
4. Lift any candidate eliminant or point to the cyclotomic integral ring.
5. Prove dominance/non-dominance over the h-base in characteristic zero.
6. For a positive geometric result, separately solve the twisted F-descent
   problem and replay the universal curve ideal.

An unsaturated unit ideal, one empty modular fiber, or a failed chart is not
a branch exclusion.
