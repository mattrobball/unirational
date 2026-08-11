-- T6 -- exact Macaulay2 chart verification of the point/line/plane blow-up
-- tower Z -> P^4 (a De Concini-Procesi wonderful model of a linear-subspace
-- arrangement: blow up points, then lines, then planes, in that order).
--
-- Setup.  P^4 = P(W), W = C^5 with basis w0..w4.  A cyclic group G = <zz>,
-- zz a primitive 6th root of unity (exact, in QQ(zeta_6) via toField), acts
-- diagonally: g.wi = zz^(a_i) wi, weights a = (a0,a1,a2,a3,a4) = (0,1,3,4,1).
-- [The M2 symbol "zeta" is reserved by the system, hence "zz".]
--
-- x = [1:0:0:0:0], the line v = <w0>, lambda_0 = a0.  The affine chart of
-- P^4 at x has coordinates ui = wi/w0 (i=1..4), weight(ui) = ai - a0.
--
-- Four genres of flags S_1 (subsetneq S_2 subsetneq S_3) through x, k<=3,
-- V_i = span(S_i), beta_i = the chosen normal eigen-direction in V_{i+1}/V_i:
--   A: k=1, S_1 = {x}                         (POINT)   V_1=<w0>=v
--   B: k=1, S_1 = line  <w0,w1>                (LINE)    V_1=<w0,w1>
--   C: k=1, S_1 = plane <w0,w1,w2>              (PLANE)   V_1=<w0,w1,w2>
--   D: k=3, {x} < line <w0,w1> < plane <w0,w1,w2>          (triple crossing)
-- Each chart is built by the successive substitutions of the blow-up itself
-- (normal coordinate = t_i * new coordinates), NOT asserted from the rule.
--
-- The RULE being checked: chart coordinates at z have weights
--   free lambda_0^{-1}(V_1/v),  BOUNDARY lambda_0^{-1}lambda_1,
--   free lambda_1^{-1}((V_2/V_1)/beta_1),  BOUNDARY lambda_1^{-1}lambda_2,
--   ... ,  free lambda_k^{-1}((W/V_k)/beta_k).
-- For each genre we build gS, the transported G-action on the CHART ring,
-- using ONLY this rule's predicted weights, and CHECK it is forced by
-- equivariance phi.gU = gS.phi with phi the (rule-independent) blow-up
-- substitution and gU the (rule-independent) action on the original chart.
--
-- Marker on success: T6_CHARTS_OK

FAILS = 0
CHECKS = 0
chk = (msg, b) -> (
    CHECKS = CHECKS + 1;
    if b then print("CHECK PASS  " | msg)
    else (FAILS = FAILS + 1; print("CHECK FAIL  " | msg));
    );

kk = toField(QQ[zz]/(zz^2 - zz + 1));   -- QQ(zeta_6), exact cyclotomic field
chk("zz has exact multiplicative order 6 (primitive 6th root of unity)",
    zz^6 == 1 and zz^3 != 1 and zz^2 != 1);
a = {0,1,3,4,1};                         -- weights a0..a4 of w0..w4 under zz
R = kk[u1,u2,u3,u4];                     -- chart at x: ui = wi/w0
gU = map(R,R, apply(4, i -> zz^(a#(i+1)-a#0) * R_i));  -- weight(ui)=ai-a0

print "";
print "=== GENRE A: k=1, S_1 = {x}  (POINT) ===";
SA = kk[t1,p2,p3,p4];
phiA = map(SA,R,{t1, t1*p2, t1*p3, t1*p4});     -- blow up the origin of R
lam1A = a#1;                                     -- beta_1 = <w1>, V_1=v
wA = {lam1A-a#0, a#2-lam1A, a#3-lam1A, a#4-lam1A};
gSA = map(SA,SA,{zz^(wA#0)*t1, zz^(wA#1)*p2, zz^(wA#2)*p3, zz^(wA#3)*p4});
chk("A: chart is a 4-dim'l affine space and the substitution is monomial "
    | "and unimodular (birational, smooth blow-up chart)",
    dim SA == 4 and det matrix{{1,0,0,0},{1,1,0,0},{1,0,1,0},{1,0,0,1}} == 1);
chk("A: induced weights of (t1,p2,p3,p4) match the rule (forced by "
    | "equivariance phi.gU = gS.phi on every original coordinate)",
    all(gens R, u -> phiA(gU(u)) == gSA(phiA(u))));
chk("A: the boundary divisor D_S1 = {t1=0} is exactly a codim-1 divisor",
    codim ideal(t1) == 1);
nnzA = number(wA, w -> zz^w != 1);
chk("A: Fix(zz) in the chart has codim = # nontrivial weights (" | toString nnzA | "/4)",
    codim ideal(gSA(t1)-t1,gSA(p2)-p2,gSA(p3)-p3,gSA(p4)-p4) == nnzA);

print "";
print "=== GENRE B: k=1, S_1 = line <w0,w1>  (LINE) ===";
SB = kk[u1,t1,q3,q4];
phiB = map(SB,R,{u1, t1, t1*q3, t1*q4});         -- u1 free (tangent to S_1)
lam1B = a#2;                                      -- beta_1 = <w2>
wB = {a#1-a#0, lam1B-a#0, a#3-lam1B, a#4-lam1B};
gSB = map(SB,SB,{zz^(wB#0)*u1, zz^(wB#1)*t1, zz^(wB#2)*q3, zz^(wB#3)*q4});
chk("B: chart is a 4-dim'l affine space and the substitution is monomial "
    | "and unimodular",
    dim SB == 4 and det matrix{{1,0,0,0},{0,1,0,0},{0,1,1,0},{0,1,0,1}} == 1);
chk("B: induced weights of (u1,t1,q3,q4) match the rule (forced by "
    | "equivariance phi.gU = gS.phi)",
    all(gens R, u -> phiB(gU(u)) == gSB(phiB(u))));
chk("B: the boundary divisor D_S1 = {t1=0} is exactly a codim-1 divisor",
    codim ideal(t1) == 1);
nnzB = number(wB, w -> zz^w != 1);
chk("B: Fix(zz) in the chart has codim = # nontrivial weights (" | toString nnzB | "/4)",
    codim ideal(gSB(u1)-u1,gSB(t1)-t1,gSB(q3)-q3,gSB(q4)-q4) == nnzB);

print "";
print "=== GENRE C: k=1, S_1 = plane <w0,w1,w2>  (PLANE) ===";
SC = kk[u1,u2,t1,r4];
phiC = map(SC,R,{u1, u2, t1, t1*r4});            -- u1,u2 free
lam1C = a#3;                                      -- beta_1 = <w3>
wC = {a#1-a#0, a#2-a#0, lam1C-a#0, a#4-lam1C};
gSC = map(SC,SC,{zz^(wC#0)*u1, zz^(wC#1)*u2, zz^(wC#2)*t1, zz^(wC#3)*r4});
chk("C: chart is a 4-dim'l affine space and the substitution is monomial "
    | "and unimodular",
    dim SC == 4 and det matrix{{1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,1,1}} == 1);
chk("C: induced weights of (u1,u2,t1,r4) match the rule (forced by "
    | "equivariance phi.gU = gS.phi)",
    all(gens R, u -> phiC(gU(u)) == gSC(phiC(u))));
chk("C: the boundary divisor D_S1 = {t1=0} is exactly a codim-1 divisor",
    codim ideal(t1) == 1);
nnzC = number(wC, w -> zz^w != 1);
chk("C: Fix(zz) in the chart has codim = # nontrivial weights (" | toString nnzC | "/4)",
    codim ideal(gSC(u1)-u1,gSC(u2)-u2,gSC(t1)-t1,gSC(r4)-r4) == nnzC);

print "";
print "=== GENRE D: k=3, {x} < line <w0,w1> < plane <w0,w1,w2> (TRIPLE) ===";
SD = kk[t1,t2,t3,p4];
phiD = map(SD,R,{t1, t1*t2, t1*t2*t3, t1*t2*t3*p4});   -- successive blow-ups
lam1D = a#1; lam2D = a#2; lam3D = a#3;                   -- beta_1,2,3=<w1>,<w2>,<w3>
wD = {lam1D-a#0, lam2D-lam1D, lam3D-lam2D, a#4-lam3D};
gSD = map(SD,SD,{zz^(wD#0)*t1, zz^(wD#1)*t2, zz^(wD#2)*t3, zz^(wD#3)*p4});
chk("D: chart is a 4-dim'l affine space and the substitution is monomial "
    | "and unimodular",
    dim SD == 4
    and det matrix{{1,0,0,0},{1,1,0,0},{1,1,1,0},{1,1,1,1}} == 1);
chk("D: induced weights of (t1,t2,t3,p4) match the rule (forced by "
    | "equivariance phi.gU = gS.phi); free_0,free_1,free_2 are all EMPTY "
    | "since dim(V_{i+1}/V_i)=1 forces beta_i to exhaust them",
    all(gens R, u -> phiD(gU(u)) == gSD(phiD(u))));
chk("D: each boundary divisor D_S1={t1=0}, D_S2={t2=0}, D_S3={t3=0} is a "
    | "codim-1 divisor",
    codim ideal(t1) == 1 and codim ideal(t2) == 1 and codim ideal(t3) == 1);
crossD = ideal(t1,t2,t3);
chk("D: the triple crossing D_S1 cap D_S2 cap D_S3 is smooth of codim 3 "
    | "(three coordinate hyperplanes meeting normally)",
    codim crossD == 3 and isPrime crossD);
nnzD = number(wD, w -> zz^w != 1);
chk("D: Fix(zz) in the chart has codim = # nontrivial weights (" | toString nnzD | "/4)",
    codim ideal(gSD(t1)-t1,gSD(t2)-t2,gSD(t3)-t3,gSD(p4)-p4) == nnzD);

print "";
print(toString(CHECKS-FAILS) | "/" | toString CHECKS | " checks passed");
if FAILS == 0 then print "T6_CHARTS_OK" else print "T6_CHARTS_FAIL";
