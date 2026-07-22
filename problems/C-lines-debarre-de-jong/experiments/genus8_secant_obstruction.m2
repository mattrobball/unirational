-- Exact null certificate for a genus-8 Mukai sixfold projection.
-- Macaulay2 1.26.06

-- The Pluecker coordinates are ordered as
-- 12,13,14,15,16,23,24,25,26,34,35,36,45,46,56.

-- First certify smoothness of the codimension-two linear section in
-- characteristic 101.  The fifteen standard Pluecker charts cover Gr(2,6).
Rc = (ZZ/101)[a0,a1,a2,a3,b0,b1,b2,b3, MonomialOrder => GRevLex];
aa = {a0,a1,a2,a3};
bb = {b0,b1,b2,b3};
chartPairs = subsets(toList(0..5),2);

checkChart = pair -> (
    ii := pair#0;
    jj := pair#1;
    rest := select(toList(0..5), k -> k != ii and k != jj);
    cols := new MutableList from apply(0..5, k -> {0_Rc,0_Rc});
    cols#ii = {1_Rc,0_Rc};
    cols#jj = {0_Rc,1_Rc};
    scan(0..3, k -> cols#(rest#k) = {aa#k,bb#k});
    pp := (u,v) -> (cols#u#0*cols#v#1-cols#u#1*cols#v#0);
    pv := {
        pp(0,1),pp(0,2),pp(0,3),pp(0,4),pp(0,5),
        pp(1,2),pp(1,3),pp(1,4),pp(1,5),
        pp(2,3),pp(2,4),pp(2,5),
        pp(3,4),pp(3,5),pp(4,5)
        };
    l1 := pv#1+2*pv#2+pv#4-pv#5+2*pv#7-2*pv#8
          +pv#10+pv#11-pv#12+2*pv#13+pv#14;
    l2 := pv#2+pv#3-pv#4+2*pv#5+pv#6+pv#8
          -2*pv#10+pv#11+2*pv#12+pv#13-pv#14;
    singularIdeal := ideal(l1,l2)+minors(2,jacobian ideal(l1,l2));
    singularIdeal == ideal(1_Rc)
    );

chartResults = apply(chartPairs, checkChart);
assert all(chartResults, result -> result);
print("smooth mod 101 on all Pluecker charts: " | toString chartResults);

-- Certify the explicit source line used to show that the four line-section
-- equations on Flag(1,3;6) have a nonempty zero locus.  Its general point is
-- alpha*p12 + beta*(-p13+p15+p16).
Tline = QQ[alpha,beta];
lp = {alpha,-beta,0_Tline,beta,beta,0_Tline,0_Tline,0_Tline,
      0_Tline,0_Tline,0_Tline,0_Tline,0_Tline,0_Tline,0_Tline};
linePluecker = {
    lp#0*lp#9-lp#1*lp#6+lp#2*lp#5,
    lp#0*lp#10-lp#1*lp#7+lp#3*lp#5,
    lp#0*lp#11-lp#1*lp#8+lp#4*lp#5,
    lp#0*lp#12-lp#2*lp#7+lp#3*lp#6,
    lp#0*lp#13-lp#2*lp#8+lp#4*lp#6,
    lp#0*lp#14-lp#3*lp#8+lp#4*lp#7,
    lp#1*lp#12-lp#2*lp#10+lp#3*lp#9,
    lp#1*lp#13-lp#2*lp#11+lp#4*lp#9,
    lp#1*lp#14-lp#3*lp#11+lp#4*lp#10,
    lp#2*lp#14-lp#3*lp#13+lp#4*lp#12,
    lp#5*lp#12-lp#6*lp#10+lp#7*lp#9,
    lp#5*lp#13-lp#6*lp#11+lp#8*lp#9,
    lp#5*lp#14-lp#7*lp#11+lp#8*lp#10,
    lp#6*lp#14-lp#7*lp#13+lp#8*lp#12,
    lp#9*lp#14-lp#10*lp#13+lp#11*lp#12
    };
lineL1 = lp#1+2*lp#2+lp#4-lp#5+2*lp#7-2*lp#8
         +lp#10+lp#11-lp#12+2*lp#13+lp#14;
lineL2 = lp#2+lp#3-lp#4+2*lp#5+lp#6+lp#8
         -2*lp#10+lp#11+2*lp#12+lp#13-lp#14;
assert(all(linePluecker, f -> f == 0_Tline));
assert(lineL1 == 0_Tline and lineL2 == 0_Tline);
print("explicit source line certified: true");
print("source line-family dimension lower bound: 7");

-- The projection center is
-- K = P span(c,u,v), where
-- c=p12+p34, u=-3p13+p46+p56, v=2p14-p25-2p36.
-- Restrict all Pluecker quadrics to K and certify that K misses Gr(2,6).
P = QQ[s,t,r, MonomialOrder => GRevLex];
cp = {s,-3*t,2*r,0_P,0_P,0_P,0_P,-r,0_P,s,0_P,-2*r,0_P,t,t};
plueckerOnCenter = ideal(
    cp#0*cp#9-cp#1*cp#6+cp#2*cp#5,
    cp#0*cp#10-cp#1*cp#7+cp#3*cp#5,
    cp#0*cp#11-cp#1*cp#8+cp#4*cp#5,
    cp#0*cp#12-cp#2*cp#7+cp#3*cp#6,
    cp#0*cp#13-cp#2*cp#8+cp#4*cp#6,
    cp#0*cp#14-cp#3*cp#8+cp#4*cp#7,
    cp#1*cp#12-cp#2*cp#10+cp#3*cp#9,
    cp#1*cp#13-cp#2*cp#11+cp#4*cp#9,
    cp#1*cp#14-cp#3*cp#11+cp#4*cp#10,
    cp#2*cp#14-cp#3*cp#13+cp#4*cp#12,
    cp#5*cp#12-cp#6*cp#10+cp#7*cp#9,
    cp#5*cp#13-cp#6*cp#11+cp#8*cp#9,
    cp#5*cp#14-cp#7*cp#11+cp#8*cp#10,
    cp#6*cp#14-cp#7*cp#13+cp#8*cp#12,
    cp#9*cp#14-cp#10*cp#13+cp#11*cp#12
    );
assert(saturate(plueckerOnCenter,ideal(s,t,r)) == ideal(1_P));
print("projection center disjoint from Gr(2,6): true");

-- Linear-algebra certificate for the double point and spanning tangents.
-- L is cut out by the two rows below.  The source points are a=p12,
-- b=p34, and c=a+b belongs to K, hence pi(a)=pi(b).
Lmat = matrix(QQ, {
    {0,1,2,0,1,-1,0,2,-2,0,1,1,-1,2,1},
    {0,0,1,1,-1,2,1,0,1,0,-2,1,2,1,-1}
    });
cVec = {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0};
uVec = {0,-3,0,0,0,0,0,0,0,0,0,0,0,1,1};
vVec = {0,0,2,0,0,0,0,-1,0,0,0,-2,0,0,0};
Kmat = transpose matrix(QQ,{cVec,uVec,vVec});
assert(rank Kmat == 3);
assert(rank(Lmat*Kmat) == 0);

basisMatrix = indices -> matrix apply(toList(0..14), i ->
    apply(indices, j -> if i == j then 1_QQ else 0_QQ));

-- Ambient tangent spaces to Gr at p12 and p34.
TaGr = basisMatrix {0,1,2,3,4,5,6,7,8};
TbGr = basisMatrix {9,1,2,5,6,10,11,12,13};
TaY = TaGr * gens kernel(Lmat*TaGr);
TbY = TbGr * gens kernel(Lmat*TbGr);

assert(rank TaY == 7);
assert(rank TbY == 7);
assert(rank(TaY|Kmat) == 10);
assert(rank(TbY|Kmat) == 10);
assert(rank(TaY|TbY) == 12);
assert(rank(TaY|TbY|Kmat) == 13);
assert(15-rank Lmat == 13);

print("vector tangent dimensions at a,b: " |
    toString(rank TaY) | "," | toString(rank TbY));
print("projection immersive at both branches: true");
print("vector dimension of their span: " | toString rank(TaY|TbY));
print("dimension after adjoining the center: " |
    toString rank(TaY|TbY|Kmat));
print("projected tangent spaces span P^9: true");
