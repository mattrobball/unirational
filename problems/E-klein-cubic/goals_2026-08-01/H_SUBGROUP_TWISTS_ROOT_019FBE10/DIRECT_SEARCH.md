# Direct point-search boundary

`a4_direct_search.py` computes, rather than samples, for every linear
character \(\chi:A_4\to\mu_3\), the full spaces with transformation law

\[
\Phi(gy)=\chi(g)g\Phi(y).
\]

This exhausts projective polynomial maps: after removing a common factor,
the projective proportionality multiplier is a constant character.

For degrees \(d=1,2,3,4\), the script expands every coefficient of
\(F(\Phi(y))\), covers each projective coefficient space by all standard
affine charts, and obtains the unit ideal on every chart over
\(\mathbf F_{331}\), which splits the cubic characters.  Properness gives
characteristic-zero geometric emptiness in those four degrees for all three
characters.

This proves only:

```text
no nonzero projective A4-equivariant polynomial map P2 -> X of degree <= 4
```

It does not exclude degree five or higher maps, rational maps after invariant
denominators, or a rational point found by a non-covariant presentation of
the generic twist.  Degree five is the smallest untested polynomial landing
space.
