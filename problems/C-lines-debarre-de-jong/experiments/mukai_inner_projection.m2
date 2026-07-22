-- A line-family-first dead-end test for the degree-9 problem.
--
-- Start with a genus-6 Mukai sixfold in P^10: a quadric section of the
-- projective cone over Gr(2,5).  The chosen point [p12=1] lies on it.  We
-- certify that this particular section is smooth over QQ, project from that
-- point to P^9, and record the ideal of the image.  The image ideal has five
-- generators of degrees 2,2,3,3,3.  Consequently every degree-9 form in the
-- ideal is singular somewhere on the sixfold: write F=sum A_i G_i and use a
-- common zero of the five positive-degree A_i on the sixfold.

R0 = QQ[p12,p13,p14,p15,p23,p24,p25,p34,p35,p45,z,
        MonomialOrder => GRevLex];

pluecker = {
    p12*p34-p13*p24+p14*p23,
    p12*p35-p13*p25+p15*p23,
    p12*p45-p14*p25+p15*p24,
    p13*p45-p14*p35+p15*p34,
    p23*p45-p24*p35+p25*p34
    };

-- This ten-monomial quadric vanishes at [p12=1].  The saturated
-- Jacobian-rank calculation below is an exact certificate over QQ.
Q = (z^2 + p12*p13 + 2*p14^2 + 3*p15^2 + 5*p23^2 + 7*p24^2
    + 11*p25^2 + 13*p34^2 + 17*p35^2 + 19*p45^2);
centerMap = map(QQ,R0,{1,0,0,0,0,0,0,0,0,0,0});
assert(centerMap Q == 0_QQ);

sourceIdeal0 = ideal(pluecker | {Q});
sourceSingularIdeal0 = saturate(
    sourceIdeal0 + minors(4,jacobian sourceIdeal0),
    ideal vars R0);

assert(dim sourceIdeal0 == 7); -- affine cone dimension; projective dimension 6
assert(isPrime sourceIdeal0);
print("source_singular_rank_locus_dimension=" | toString dim sourceSingularIdeal0);
assert(dim sourceSingularIdeal0 == -1);

-- Re-enter the source ideal with an elimination order.  The smoothness
-- calculation above deliberately uses GRevLex; saturation with the
-- elimination order is both slower and unreliable for this certificate.
R = QQ[p12,p13,p14,p15,p23,p24,p25,p34,p35,p45,z,
       MonomialOrder => Eliminate 1];
sourceIdeal = sub(sourceIdeal0,R);

-- Eliminate the coordinate of the projection center [p12=1].
eliminated = trim eliminate({p12},sourceIdeal);
S = QQ[p13,p14,p15,p23,p24,p25,p34,p35,p45,z];
imageIdeal = trim sub(eliminated,S);
imageGeneratorDegrees = sort apply(
    flatten entries gens imageIdeal,
    g -> first degree g);

assert(dim imageIdeal == 7); -- projective image dimension 6 in P^9
assert(isPrime imageIdeal);
assert(imageGeneratorDegrees == {2,2,3,3,3});

-- The image has codimension three.  Its projective singular locus is cut out
-- by the 3x3 Jacobian minors and has dimension two.
imageSingularIdeal = saturate(
    imageIdeal + minors(3,jacobian imageIdeal),
    ideal vars S);
assert(dim imageSingularIdeal == 3); -- affine cone dimension

print("source_projective_dimension=6");
print("source_projectively_smooth=true");
print("projection_center=p12");
print("image_projective_dimension=6");
print("image_projective_singular_dimension=2");
print("image_generator_degrees=" | toString imageGeneratorDegrees);
print("degree_9_containing_hypersurface_status=forced_singular");
