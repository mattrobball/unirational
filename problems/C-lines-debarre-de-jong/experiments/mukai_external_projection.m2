-- A stronger line-family-first dead-end test for the degree-9 problem.
--
-- Start with the same smooth genus-6 Mukai sixfold in P^10 used by
-- mukai_inner_projection.m2, but project from the external coordinate point
-- q=[p14=1].  The image is a prime sixfold in P^9 with eight minimal ideal
-- generators, of degrees 2,2,4,4,4,4,4,4, so it escapes the elementary
-- six-generator obstruction.  Exact elimination nevertheless exhibits the
-- point y=[z=1] at which every ideal generator and every generator
-- differential vanishes (equivalently, the embedded tangent space is all of
-- P^9).  Every hypersurface containing the image is
-- therefore singular at y, in every degree.

R0 = QQ[p12,p13,p14,p15,p23,p24,p25,p34,p35,p45,z,
        MonomialOrder => GRevLex];

pluecker = {
    p12*p34-p13*p24+p14*p23,
    p12*p35-p13*p25+p15*p23,
    p12*p45-p14*p25+p15*p24,
    p13*p45-p14*p35+p15*p34,
    p23*p45-p24*p35+p25*p34
    };

Q = (z^2 + p12*p13 + 2*p14^2 + 3*p15^2 + 5*p23^2 + 7*p24^2
    + 11*p25^2 + 13*p34^2 + 17*p35^2 + 19*p45^2);
sourceIdeal0 = ideal(pluecker | {Q});

-- The center is outside the source: Q(q)=2.
centerMap = map(QQ,R0,{0,0,1,0,0,0,0,0,0,0,0});
assert(centerMap Q == 2_QQ);

-- Re-certify the source properties used by the geometric line-family
-- argument, so this script is independent of the inner-projection script.
sourceSingularIdeal0 = saturate(
    sourceIdeal0 + minors(4,jacobian sourceIdeal0),
    ideal vars R0);
assert(dim sourceIdeal0 == 7); -- affine cone dimension
assert(degree sourceIdeal0 == 10);
assert(isPrime sourceIdeal0);
assert(dim sourceSingularIdeal0 == -1);

-- Eliminate the coordinate of q.  The remaining ten variables are the
-- homogeneous coordinates on the target P^9.
R = QQ[p14,p12,p13,p15,p23,p24,p25,p34,p35,p45,z,
       MonomialOrder => Eliminate 1];
sourceIdeal = sub(sourceIdeal0,R);
eliminated = trim eliminate({p14},sourceIdeal);

S = QQ[p12,p13,p15,p23,p24,p25,p34,p35,p45,z,
       MonomialOrder => GRevLex];
imageIdeal = trim sub(eliminated,S);
imageGeneratorDegrees = sort apply(
    flatten entries gens imageIdeal,
    g -> first degree g);

assert(dim imageIdeal == 7); -- projective image dimension 6
assert(degree imageIdeal == 10);
assert(isPrime imageIdeal);
assert(imageGeneratorDegrees == {2,2,4,4,4,4,4,4});

-- The simultaneous zero locus of the image ideal and every entry of its
-- Jacobian is exactly y=[z=1].  This is stronger than saying merely that the
-- codimension-three image is singular: the span of its embedded conormal
-- differentials vanishes at y.
rankZeroIdeal = saturate(
    imageIdeal + ideal jacobian imageIdeal,
    ideal vars S);
rankZeroPointIdeal = ideal(p12,p13,p15,p23,p24,p25,p34,p35,p45);

assert(rankZeroIdeal == rankZeroPointIdeal);
assert(dim rankZeroIdeal == 1); -- projective dimension 0
assert(degree rankZeroIdeal == 1);

pointMap = map(QQ,S,{0,0,0,0,0,0,0,0,0,1});
assert(all(flatten entries gens imageIdeal, g -> pointMap g == 0_QQ));
assert(all(flatten entries jacobian imageIdeal, g -> pointMap g == 0_QQ));

print("center=p14");
print("center_Q_value=2");
print("source_prime=true");
print("source_projectively_smooth=true");
print("source_degree=10");
print("image_prime=true");
print("image_projective_dimension=6");
print("image_degree=10");
print("image_generator_degrees=" | toString imageGeneratorDegrees);
print("rank_zero_point=[z=1]");
print("rank_zero_projective_dimension=0");
print("rank_zero_degree=1");
print("containing_hypersurface_status=forced_singular_in_every_degree");
