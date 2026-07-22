-- Exact checks for three_center_genus_counterexample.md.
--
-- The characteristic-five calculation proves absolute irreducibility: the
-- reduction is irreducible over GF(5) and has a smooth GF(5)-point.  An
-- irreducible curve over a finite field that is geometrically reducible has
-- no rational smooth point, since such a point lies on every Frobenius-
-- conjugate geometric component.

R5 = ZZ/5[x,y,z];
F5 = x^3*(x-z)^4 + x*y^2*z^4 + y^3*(x^4+z^4);
fac5 = factor F5;
assert(#fac5 == 1);
scan(fac5,p -> (
    assert(degree first p == {7});
    assert(last p == 1)
    ));

ev5 = (g,a,b,c) -> sub(g,{x=>a_R5,y=>b_R5,z=>c_R5});
assert(ev5(F5,1,2,1) == 0);
gradAtSmoothPoint = {
    ev5(diff(x,F5),1,2,1),
    ev5(diff(y,F5),1,2,1),
    ev5(diff(z,F5),1,2,1)
    };
assert(any(gradAtSmoothPoint,a -> a != 0));
print "mod 5: one irreducible degree-7 factor and smooth point [1:2:1]";

R = QQ[x,y,z];
F = x^3*(x-z)^4 + x*y^2*z^4 + y^3*(x^4+z^4);
C = y*F;

p1 = ideal(x,z);
p2 = ideal(x,y);
p3 = ideal(x-z,y);
threePoints = intersect(p1,p2,p3);

singH = ideal(F,diff(x,F),diff(y,F),diff(z,F));
singC = ideal(C,diff(x,C),diff(y,C),diff(z,C));
assert(trim radical singH == trim threePoints);
assert(trim radical singC == trim threePoints);
print "characteristic 0: the singular support of H and C is exactly p1,p2,p3";

-- The line L is y=0.  Its complete scheme-theoretic intersection with H is
-- x^3(x-z)^4, hence the local intersection numbers are 3 and 4.
assert(sub(F,R/{y}) == x^3*(x-z)^4);
print "H.L: multiplicities 3 at p2 and 4 at p3, with no other intersections";

-- Local leading forms.  Codimension two of the Jacobian ideal of a binary
-- homogeneous form says that the form is square-free.
R1 = QQ[a,b];
h1 = a^3*(a-b)^4 + a*b^4 + a^4 + b^4;
t1 = a^4+b^4;
m1 = ideal(a,b);
assert((h1-t1) % m1^5 == 0);
assert(codim ideal(t1,diff(a,t1),diff(b,t1)) == 2);
print "p1: square-free quartic tangent cone (ordinary quadruple, delta 6)";

R2 = QQ[a,b];
h2 = a^3*(a-1)^4 + a*b^2 + b^3*(a^4+1);
t2H = a^3+a*b^2+b^3;
t2C = b*t2H;
m2 = ideal(a,b);
assert((h2-t2H) % m2^4 == 0);
assert(codim ideal(t2H,diff(a,t2H),diff(b,t2H)) == 2);
assert(codim ideal(t2C,diff(a,t2C),diff(b,t2C)) == 2);
print "p2: H ordinary triple and C ordinary quadruple (delta_H 3)";

R3 = QQ[u,v,w];
h3 = (1+u)^3*u^4 + (1+u)*v^2 + v^3*((1+u)^4+1);

-- Put v=u^2*w.  After division by u^4 the specialization at u=0 is
-- 1+w^2, with two simple roots over C.  H therefore has two smooth branches
-- v=u^2*w_+(u), v=u^2*w_-(u), meeting to order two: an A3 tacnode.
tacnodeScaled = (1+u)^3 + (1+u)*w^2
    + u^2*w^3*((1+u)^4+1);
assert(sub(tacnodeScaled,{u=>0_R3}) == 1+w^2);
assert(gcd(1+w^2,diff(w,1+w^2)) == 1);

-- First blowup v=u*w.  The H strict transform has tangent cone u^2+w^2.
-- The strict transform of L is w=0, and because mult_p3(C)=3 is odd the
-- corrected branch also contains the exceptional u=0.  Its tangent cone at
-- q3 is u*w*(u^2+w^2), a square-free quartic.
h3Strict = (1+u)^3*u^2 + (1+u)*w^2
    + u*w^3*((1+u)^4+1);
m3 = ideal(u,w);
assert((h3Strict-(u^2+w^2)) % m3^3 == 0);
t3Corrected = u*w*(u^2+w^2);
assert(codim ideal(t3Corrected,diff(u,t3Corrected),diff(w,t3Corrected)) == 2);
print "p3: H is A3 (delta 2); corrected sequence is r=(3,4)";

-- Cluster-system vanishings.  For D=E_p1+E_p2+E_q3, a line must pass
-- through the three origins.  The displayed evaluation matrix has rank 3.
Rlin = QQ;
lineConditions = matrix(Rlin,{{0,1,0},{0,0,1},{1,0,1}});
assert(rank lineConditions == 3);

-- On the conic basis (x^2,xy,xz,y^2,yz,z^2), double points at p1 and p2
-- leave only x^2.  The last row is evaluation at p3, already a necessary
-- part of the doubled q3 condition; it kills x^2.  Thus the rank is 6.
conicConditions = matrix(Rlin,{
    {0,0,0,1,0,0},
    {0,1,0,0,0,0},
    {0,0,0,0,1,0},
    {0,0,0,0,0,1},
    {0,0,1,0,0,0},
    {1,0,1,0,0,1}
    });
assert(rank conicConditions == 6);
print "cluster systems: H^0(J_D(1))=0 and H^0(J_(2D)(2))=0";

-- p_a(H)=15 and its only delta contributions are 6,3,2.
assert(binomial(6,2) == 15);
assert(15-(6+3+2) == 4);
assert((6+3+2)+(3+4) == 18);
assert(18-2+1 == 17);
print "normalization genus: g(H)+g(L)=4; delta(C)-2+1=17";
print "all three-center genus-counterexample checks passed";
