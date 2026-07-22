-- Reproducible local calibration harness for degree-9 hypersurfaces in P^9.
--
-- This script certifies two deliberately separate facts:
--   (1) projective smoothness, by saturating (F, dF) by the irrelevant ideal;
--   (2) the local dimension of one affine Grassmann chart at one supplied line,
--       when the chart Jacobian has full row rank.
--
-- It does NOT compute the global dimension of the Fano scheme.  A global
-- upper bound requires all binomial(10,2)=45 pivot charts (or an equivalent
-- rank-two Stiefel/Plucker computation).

emit = values -> print("CAL|" | demark("|", apply(values, value -> toString value)));

candidateForm = (name, R) -> (
    x := flatten entries vars R;
    if name === "fermat" then
        sum(0..9, i -> (x#i)^9)
    else if name === "klein_10_cycle" then
        sum(0..9, i -> (x#i)^8 * x#((i + 1) % 10))
    else if name === "five_2_cycles" then (
        sigma := {1, 0, 3, 2, 5, 4, 7, 6, 9, 8};
        sum(0..9, i -> (x#i)^8 * x#(sigma#i))
        )
    else if name === "chain" then
        sum(0..8, i -> (x#i)^8 * x#(i + 1)) + (x#9)^9
    else error("unknown candidate: " | name));

-- Each fixture is (pivot pair, first spanning vector, second spanning vector).
-- The vectors are integral and are reduced in the requested coefficient field.
lineFixture = name -> (
    if name === "fermat" then
        {
            {0, 1},
            {1, 0, -1, 0, 1, -1, 1, -1, 2, -2},
            {0, 1, 0, -1, 1, -1, 2, -2, 3, -3}
        }
    else
        {
            {0, 2},
            {1, 0, 0, 0, 1, 0, 1, 0, 1, 0},
            {0, 0, 1, 0, 1, 0, 2, 0, 3, 0}
        });

smoothnessCertificate = F -> (
    R := ring F;
    singularIdeal := ideal(F) + ideal jacobian F;
    started := cpuTime();
    saturatedSingularIdeal := saturate(singularIdeal, ideal vars R);
    elapsed := cpuTime() - started;
    {
        saturatedSingularIdeal == ideal(1_R),
        dim singularIdeal,
        elapsed
    });

chartCertificate = (F, fixture) -> (
    R := ring F;
    K := coefficientRing R;
    pivot := fixture#0;
    u := fixture#1;
    v := fixture#2;

    -- Work first with 20 row-vector entries, then set the four pivot entries
    -- to (1,0) and (0,1).  The remaining 16 entries are the affine chart.
    B := K[a_0..a_9, b_0..b_9];
    bv := flatten entries vars B;
    T := B[s, t];
    lineImages := toList apply(0..9, i -> s * bv#i + t * bv#(10 + i));
    lineMap := map(T, R, lineImages);
    restrictedForm := lineMap F;
    rawCoefficients := toList apply(0..9, k ->
        coefficient(s^(9-k) * t^k, restrictedForm));

    i := pivot#0;
    j := pivot#1;
    canonicalPivot := u#i == 1 and u#j == 0 and v#i == 0 and v#j == 1;
    fixedImages := toList apply(0..19, k ->
        if k == i or k == 10 + j then 1_B
        else if k == j or k == 10 + i then 0_B
        else bv#k);
    fixPivot := map(B, B, fixedImages);
    fixedCoefficients := apply(rawCoefficients, f -> fixPivot f);
    activeCoefficients := select(fixedCoefficients, f -> f != 0_B);

    point := toList apply(u | v, z -> z_K);
    evaluateAtLine := map(K, B, point);
    -- Do not silently certify the normalized pivot line while reporting an
    -- inconsistent fixture.  Current fixtures are already canonical.
    lineOnHypersurface := canonicalPivot and all(activeCoefficients,
        f -> evaluateAtLine f == 0_K);

    started := cpuTime();
    jacobianRank := if #activeCoefficients == 0 then 0
        else rank(evaluateAtLine jacobian ideal activeCoefficients);
    elapsed := cpuTime() - started;

    tangentDimension := 16 - jacobianRank;
    krullLowerBound := 16 - #activeCoefficients;
    regularLocalCertificate := lineOnHypersurface
        and jacobianRank == #activeCoefficients;
    localDimension := if regularLocalCertificate then tangentDimension else -1;
    status := if not lineOnHypersurface then "invalid_line_fixture"
        else if regularLocalCertificate then "certified_regular_local_dimension"
        else "tangent_and_krull_bounds_only";

    {
        toString(i) | "," | toString(j),
        demark(",", apply(take(point, 10), z -> toString z)),
        demark(",", apply(drop(point, 10), z -> toString z)),
        #activeCoefficients,
        lineOnHypersurface,
        jacobianRank,
        tangentDimension,
        krullLowerBound,
        status,
        localDimension,
        elapsed
    });

candidateNames := {"fermat", "klein_10_cycle", "five_2_cycles", "chain"};
fields := {{"QQ", QQ}, {"F2", ZZ/2}, {"F7", ZZ/7}};

scan(fields, fieldData -> (
    fieldName := fieldData#0;
    K := fieldData#1;
    scan(candidateNames, candidateName -> (
        R := K[x_0..x_9, MonomialOrder => GRevLex];
        F := candidateForm(candidateName, R);
        smoothData := smoothnessCertificate F;
        chartData := chartCertificate(F, lineFixture candidateName);
        emit {
            candidateName,
            fieldName,
            smoothData#0,
            smoothData#1,
            smoothData#2,
            chartData#0,
            chartData#1,
            chartData#2,
            chartData#3,
            chartData#4,
            chartData#5,
            chartData#6,
            chartData#7,
            chartData#8,
            chartData#9,
            chartData#10,
            "not_checked"
        };
        ))));
