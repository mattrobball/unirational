-- Binary cubic discriminant identity (characteristic 0).
-- disc(a,b,c,d) = 18abcd - 4b^3 d + b^2 c^2 - 4a c^3 - 27 a^2 d^2
-- vanishes iff the binary cubic a s^3 + b s^2 t + c s t^2 + d t^3 is non-reduced.

R = QQ[a,b,c,d];
disc = 18*a*b*c*d - 4*b^3*d + b^2*c^2 - 4*a*c^3 - 27*a^2*d^2;
assert( disc != 0 );

-- Square (s-t)^2 (s+2t) = s^3 - 3 s t^2 + 2 t^3  has a=1,b=0,c=-3,d=2 and disc=0.
assert( sub(disc, {a=>1, b=>0, c=>-3, d=>2}) == 0 );

-- A square-free example s^3 + t^3 has a=1,b=0,c=0,d=1 and disc = -27 ≠ 0.
assert( sub(disc, {a=>1, b=>0, c=>0, d=>1}) == -27 );

<< "C3_BINARY_CUBIC_DISC_IDENTITY_OK" << endl;
exit 0;
