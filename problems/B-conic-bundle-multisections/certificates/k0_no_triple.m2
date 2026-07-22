-- Certificate for the k=0 exclusion in a general (2,3) hypersurface.
--
-- For a symmetric 3 x 3 matrix A of ternary cubics and a constant
-- sigma in P^2, the branch sextic is
--
--              B(A,sigma) = sigma^T adj(A) sigma.
--
-- In characteristic prime to 2, 3, and 5, a point y of this sextic has
-- multiplicity at least three iff all six second y-derivatives vanish.
-- The nine affine charts below cover P^2_sigma x P^2_y.  Dimension -1
-- means that the chart ideal is the unit ideal.
--
-- A single finite-field A with all nine charts empty proves, by properness
-- of the universal projective incidence, that a general characteristic-zero
-- A has no such (sigma,y).  The same explicit integral A is reduced in two
-- characteristics as a reproducibility check; one is mathematically sufficient.

checkPrime = p -> (
    R := (ZZ/p)[y0,y1,y2,s0,s1,s2,
        Degrees => {{1,0},{1,0},{1,0},{0,1},{0,1},{0,1}},
        MonomialOrder => GRevLex];

    a00 := 4944*y0^3 + 3813*y0^2*y1 - 4050*y0*y1^2 - 8072*y1^3
          - 5532*y0^2*y2 - 2152*y0*y1*y2 + 11483*y1^2*y2
          + 7747*y0*y2^2 - 11710*y1*y2^2 + 9862*y2^3;
    a01 := -8284*y0^3 - 1498*y0^2*y1 + 9066*y0*y1^2 - 5917*y1^3
          + 7218*y0^2*y2 - 2587*y0*y1*y2 - 8708*y1^2*y2
          - 11836*y0*y2^2 - 6942*y1*y2^2 + 9040*y2^3;
    a02 := 10971*y0^3 - 7098*y0^2*y1 - 8552*y0*y1^2 + 6909*y1^3
          - 3498*y0^2*y2 - 11382*y0*y1*y2 - 5629*y1^2*y2
          - 13120*y0*y2^2 + 8281*y1*y2^2 - 161*y2^3;
    a11 := 3575*y0^3 + 11441*y0^2*y1 - 9478*y0*y1^2 + 8779*y1^3
          + 4124*y0^2*y2 - 13583*y0*y1*y2 - 4375*y1^2*y2
          + 5100*y0*y2^2 + 2143*y1*y2^2 - 2135*y2^3;
    a12 := 14165*y0^3 - 1193*y0^2*y1 + 7287*y0*y1^2 + 7222*y1^3
          - 10531*y0^2*y2 - 11817*y0*y1*y2 - 5113*y1^2*y2
          + 9987*y0*y2^2 - 12883*y1*y2^2 + 90*y2^3;
    a22 := -2432*y0^3 - 7679*y0^2*y1 - 11272*y0*y1^2 + 3401*y1^3
          + 9602*y0^2*y2 + 2193*y0*y1*y2 + 15476*y1^2*y2
          + 14405*y0*y2^2 - 9048*y1*y2^2 + 1114*y2^3;

    Delta := a00*a11*a22 + 2*a01*a02*a12
           - a00*a12^2 - a11*a02^2 - a22*a01^2;

    B := s0^2*(a11*a22-a12^2)
       + 2*s0*s1*(a02*a12-a01*a22)
       + 2*s0*s2*(a01*a12-a02*a11)
       + s1^2*(a00*a22-a02^2)
       + 2*s1*s2*(a01*a02-a00*a12)
       + s2^2*(a00*a11-a01^2);

    ys := {y0,y1,y2};
    ss := {s0,s1,s2};
    secondDerivatives := flatten for i from 0 to 2 list
        for j from i to 2 list diff(ys#i,diff(ys#j,B));

    << "prime " << p << endl;
    chartDimensions := flatten for j from 0 to 2 list
        for i from 0 to 2 list (
            J := ideal secondDerivatives
               + ideal(ss#j-1_R,ys#i-1_R);
            d := dim J;
            << "  (sigma_" << j << " != 0, y_" << i
               << " != 0): " << d << endl;
            d
        );

    assert all(chartDimensions,d -> d == -1);

    -- These checks are not needed for the proper-incidence argument, but
    -- show that the chosen witness itself is a smooth conic-bundle
    -- threefold with smooth discriminant.
    discriminantGradient := apply(ys,z -> diff(z,Delta));
    discriminantChartDimensions := for i from 0 to 2 list
        dim(ideal discriminantGradient + ideal(ys#i-1_R));
    assert all(discriminantChartDimensions,d -> d == -1);

    F := s0^2*a00 + 2*s0*s1*a01 + 2*s0*s2*a02
       + s1^2*a11 + 2*s1*s2*a12 + s2^2*a22;
    ambientVariables := join(ys,ss);
    jacobianEntries := apply(ambientVariables,z -> diff(z,F));
    xChartDimensions := flatten for j from 0 to 2 list
        for i from 0 to 2 list
            dim(ideal jacobianEntries
                + ideal(ss#j-1_R,ys#i-1_R));
    assert all(xChartDimensions,d -> d == -1);

    << "  discriminant smooth: true" << endl;
    << "  X smooth: true" << endl;
    true
    );

assert checkPrime 32003;
assert checkPrime 65537;
