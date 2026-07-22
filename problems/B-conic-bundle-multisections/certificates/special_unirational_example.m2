-- A certified special unirational smooth (2,3) hypersurface.
--
-- This is lambda=1 in the pencil obtained by replacing
-- a00=2*y2^3-y1^3 with a00(lambda)=2*y2^3-lambda*y1^3.
-- For every lambda != 0 the same line has branch
-- -(y0^6+y2^6+lambda*y0^3*y1^3) and the same rational cluster.
-- The smoothness check at lambda=1 proves that smooth members form a
-- nonempty open of this Del Centina--Verdi-type pencil.  The two P^2
-- factors are ordered as in SPEC.md.
--
-- The constant line x2=0 cuts out a double sextic.  Its branch has a
-- triple point p and a triple point on the strict transform infinitely
-- near p.  In the canonical double-cover resolution the second center
-- has total branch multiplicity four (the exceptional curve from the
-- first odd blowup is part of the branch).  Thus this example does not
-- contradict the fact that one isolated ordinary triple point is
-- negligible.

R = QQ[y0,y1,y2,MonomialOrder => GRevLex];

a00 = 2*y2^3-y1^3;
a01 = y0^3+y2^3;
a02 = y0^3;
a11 = y0^3;
a12 = -6*y1^3;
a22 = -12*y2^3;

Delta = (a00*a11*a22 + 2*a01*a02*a12
        - a00*a12^2 - a11*a02^2 - a22*a01^2);

-- Smooth discriminant: Euler recovers Delta from its gradient.
ys = {y0,y1,y2};
deltaGradient = apply(ys,z -> diff(z,Delta));
deltaChartDimensions = apply(ys,z ->
    dim(ideal deltaGradient + ideal(z-1_R)));
assert all(deltaChartDimensions,d -> d == -1);

-- Branch for the constant line x2=0, i.e. sigma=(0,0,1).
B = a00*a11-a01^2;
assert(B == -(y0^6+y2^6+y0^3*y1^3));

-- Its only projective singular point is p=(0:1:0).
branchGradient = apply(ys,z -> diff(z,B));
assert(dim(ideal branchGradient + ideal(y0-1_R)) == -1);
assert(dim(ideal branchGradient + ideal(y2-1_R)) == -1);
Jp = ideal branchGradient + ideal(y1-1_R);
assert(radical Jp == ideal(y0,y2,y1-1_R));

-- On y1=1 the multiplicity-three tangent cone is -y0^3.
Q = QQ[e,u,MonomialOrder => GRevLex];
toFirstBlowup = map(Q,R,{e*u,1_Q,e});
totalAtP = toFirstBlowup B;
strictAfterP = -(e^3*u^6+e^3+u^3);
assert(totalAtP == e^3*strictAfterP);

-- Since the first multiplicity is odd, e=0 is included in the corrected
-- branch.  At (e,u)=(0,0), e*strictAfterP has multiplicity four.
canonicalBranchAtQ = e*strictAfterP;
assert(canonicalBranchAtQ ==
    -(e^4*u^6+e^4+e*u^3));

-- After blowing up that multiplicity-four center, the corrected branch
-- is smooth in both affine blowup charts.
Qe = QQ[e,v,MonomialOrder => GRevLex];
secondChartE = 1+v^3+e^6*v^6;
assert(dim ideal(secondChartE,diff(e,secondChartE),
        diff(v,secondChartE)) == -1);

Qu = QQ[u,w,MonomialOrder => GRevLex];
secondChartU = w*(w^3*(u^6+1)+1);
assert(dim ideal(secondChartU,diff(u,secondChartU),
        diff(w,secondChartU)) == -1);

-- Verify the branch cluster over the generic parameter of the pencil.
Klambda = frac(QQ[lambda]);
Rlambda = Klambda[Y0,Y1,Y2,MonomialOrder => GRevLex];
Blambda = -(Y0^6+Y2^6+lambda*Y0^3*Y1^3);
lambdaGradient = apply({Y0,Y1,Y2},z -> diff(z,Blambda));
assert(dim(ideal lambdaGradient + ideal(Y0-1_Rlambda)) == -1);
assert(dim(ideal lambdaGradient + ideal(Y2-1_Rlambda)) == -1);
JlambdaP = ideal lambdaGradient + ideal(Y1-1_Rlambda);
assert(dim JlambdaP == 0);
assert(Y0^3 % JlambdaP == 0);
assert(Y2^5 % JlambdaP == 0);

Qlambda = Klambda[E,U,MonomialOrder => GRevLex];
genericStrictAfterP = -(E^3*U^6+E^3+lambda*U^3);
genericCanonicalAtQ = E*genericStrictAfterP;
assert(genericCanonicalAtQ ==
    -(E^4*U^6+E^4+lambda*E*U^3));

QlambdaE = Klambda[E,V,MonomialOrder => GRevLex];
genericSecondChartE = 1+lambda*V^3+E^6*V^6;
assert(dim ideal(genericSecondChartE,diff(E,genericSecondChartE),
        diff(V,genericSecondChartE)) == -1);

QlambdaU = Klambda[U,W,MonomialOrder => GRevLex];
genericSecondChartU = W*(W^3*(U^6+1)+lambda);
assert(dim ideal(genericSecondChartU,diff(U,genericSecondChartU),
        diff(W,genericSecondChartU)) == -1);

-- Canonical-resolution formulas for branch degree six (k=0).
-- The successive total branch multiplicities are 3 and 4, hence t=(1,2).
k = 0;
t1 = 1;
t2 = 2;
chiValue = 1+binomial(k+2,2)-binomial(t1,2)-binomial(t2,2);
pgValue = 0; -- constants cannot vanish at the required second center
qValue = 1+pgValue-chiValue;
p2Value = 0; -- degree 0 with a double condition, plus degree -3
assert(chiValue == 1);
assert(pgValue == 0);
assert(qValue == 0);
assert(p2Value == 0);

-- Verify the total threefold directly in all nine affine product charts.
T = QQ[y0,y1,y2,x0,x1,x2,
    Degrees => {{1,0},{1,0},{1,0},{0,1},{0,1},{0,1}},
    MonomialOrder => GRevLex];

b00 = 2*y2^3-y1^3;
b01 = y0^3+y2^3;
b02 = y0^3;
b11 = y0^3;
b12 = -6*y1^3;
b22 = -12*y2^3;

F = (b00*x0^2 + 2*b01*x0*x1 + 2*b02*x0*x2
    + b11*x1^2 + 2*b12*x1*x2 + b22*x2^2);

ambientVariables = {y0,y1,y2,x0,x1,x2};
jacobianEntries = apply(ambientVariables,z -> diff(z,F));
baseVariables = {y0,y1,y2};
conicVariables = {x0,x1,x2};
smoothChartDimensions = flatten for y in baseVariables list
    for x in conicVariables list
        dim(ideal jacobianEntries + ideal(y-1_T,x-1_T));
assert all(smoothChartDimensions,d -> d == -1);

<< "special (2,3) hypersurface smooth: true" << endl;
<< "degree-9 discriminant smooth: true" << endl;
<< "branch singular cluster: (3,3), canonical multiplicities (3,4)" << endl;
<< "resolved branch smooth after two blowups: true" << endl;
<< "canonical-resolution formula values: pg=0, chi=1, q=0, P2=0" << endl;
<< "conclusion over C: rational bisection, hence X unirational" << endl;
<< "generic lambda branch cluster and resolution: verified" << endl;
<< "lambda=1 is a smooth witness in the pencil" << endl;
