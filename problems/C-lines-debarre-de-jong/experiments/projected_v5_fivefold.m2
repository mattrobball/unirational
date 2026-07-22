-- Exact obstruction for every one-point projection of the quintic
-- del Pezzo fivefold V_5 = Gr(2,5) cap P^8.
-- Macaulay2 1.26.06; all calculations are over QQ.
--
-- In Pluecker coordinates impose p12+p34=0 and write
--   a=p34=-p12, b=p13, c=p14, d=p15, e=p23,
--   f=p24, g=p25, h=p35, i=p45.
-- The five quadrics below define V_5 in P^8.

expectedBetti = new BettiTally from {
    (0,{0},0) => 1,
    (1,{3},3) => 5,
    (2,{4},4) => 5,
    (3,{5},5) => 1
    };

-- Orbit 0: the primitive component s has s^2 != 0.
-- The stabilizer representative is -e12+e34, i.e. [a=1].
R0 = QQ[a,b,c,d,e,f,g,h,i, MonomialOrder => Eliminate 1];
source0 = ideal(
    -a^2-b*f+c*e,
    -a*h-b*g+d*e,
    -a*i-c*g+d*f,
     b*i-c*h+d*a,
     e*i-f*h+g*a
    );
eliminated0 = trim eliminate({a},source0);

S0 = QQ[b,c,d,e,f,g,h,i, MonomialOrder => GRevLex];
openCubics = {
    d*f*h-c*g*h-d*e*i+b*g*i,
    d*f*g-c*g^2-f*h*i+e*i^2,
    d*e*g-b*g^2-f*h^2+e*h*i,
    d^2*f-c*d*g-c*h*i+b*i^2,
    d^2*e-b*d*g-c*h^2+b*h*i
    };
expected0 = ideal openCubics;
image0 = trim sub(eliminated0,S0);
rankZeroP3Open = ideal(d,g,h,i);

assert(image0 == expected0);
assert(dim image0 == 6); -- projective dimension 5
assert(degree image0 == 5);
assert(isPrime image0);
assert(betti res image0 == expectedBetti);
assert(isSubset(image0,rankZeroP3Open^2));
assert(isSubset(ideal jacobian image0,rankZeroP3Open));
assert(dim rankZeroP3Open == 4); -- a projective P^3
assert(degree rankZeroP3Open == 1);

print("orbit_open_center=[a=1]");
print("orbit_open_prime=true");
print("orbit_open_projective_dimension=5");
print("orbit_open_degree=5");
print("orbit_open_generators=5_cubics");
print("orbit_open_rank_zero_P3=(d,g,h,i)");
print("orbit_open_betti:");
print betti res image0;

-- Orbit 1: s^2=0 and the center is external.
-- The stabilizer representative is e13+e25, i.e. [b=g=1].
-- Put b=u and g=u+v, then eliminate the center coordinate u.
R1 = QQ[u,a,v,c,d,e,f,h,i, MonomialOrder => Eliminate 1];
source1 = ideal(
    -a^2-u*f+c*e,
    -a*h-u*(u+v)+d*e,
    -a*i-c*(u+v)+d*f,
     u*i-c*h+d*a,
     e*i-f*h+(u+v)*a
    );
eliminated1 = trim eliminate({u},source1);

S1 = QQ[a,v,c,d,e,f,h,i, MonomialOrder => GRevLex];
closedCubics = {
    a*d*f-c*f*h-a^2*i+c*e*i,
    a*c*d-c^2*h-v*c*i+d*f*i-a*i^2,
    a^2*d-a*c*h-a*v*i+f*h*i-e*i^2,
    a^2*c-c^2*e-v*c*f+d*f^2-a*f*i,
    a^3-a*c*e-a*v*f+f^2*h-e*f*i
    };
expected1 = ideal closedCubics;
image1 = trim sub(eliminated1,S1);
rankZeroP3Closed = ideal(a,c,f,i);

assert(image1 == expected1);
assert(dim image1 == 6); -- projective dimension 5
assert(degree image1 == 5);
assert(isPrime image1);
assert(betti res image1 == expectedBetti);
assert(isSubset(image1,rankZeroP3Closed^2));
assert(isSubset(ideal jacobian image1,rankZeroP3Closed));
assert(dim rankZeroP3Closed == 4); -- a projective P^3
assert(degree rankZeroP3Closed == 1);

print("orbit_closed_center=[b=g=1]");
print("orbit_closed_prime=true");
print("orbit_closed_projective_dimension=5");
print("orbit_closed_degree=5");
print("orbit_closed_generators=5_cubics");
print("orbit_closed_rank_zero_P3=(a,c,f,i)");
print("orbit_closed_betti:");
print betti res image1;
print("containing_degree_9_hypersurface_status=forced_singular");
