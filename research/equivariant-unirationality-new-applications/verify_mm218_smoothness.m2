-- Exact smoothness certificate for the Fermat-discriminant No. 2.18 model.
--
--   P^1 x P^2, coordinates (t0,t1 ; x,y,z), over k = QQ(i).
--   Q1 = i x^2 + y^2,  Q2 = z^2,  Q3 = i x^2 - y^2
--   Z  = { F = 0 },  F = t0^2 Q1 + 2 t0 t1 Q2 + t1^2 Q3   (a (2,2)-divisor)
--   Delta = { Q2^2 - Q1 Q3 = 0 } = { x^4 + y^4 + z^4 = 0 }
--   X  = double cover of P^1 x P^2 branched along Z.
--
-- Claims verified here:
--   (1) Delta is a smooth plane quartic;
--   (2) Q1, Q2, Q3 have no common zero, so pi_2 : Z -> P^2 is a finite double cover;
--   (3) Z is smooth as a divisor in P^1 x P^2;
--   (4) the conic-bundle discriminant of pi_1 : Z -> P^1 is 2i t0 t1 (t0^4 - t1^4),
--       with six distinct roots, so pi_1 has exactly six reducible fibres.
-- (3) + the fact that a double cover of a smooth variety branched along a smooth
-- divisor is smooth give that X is smooth.
--
-- Run:  M2 --script verify_mm218_smoothness.m2

kk = toField(QQ[iu]/(iu^2+1));
R = kk[t0,t1,x,y,z];

Q1 = iu*x^2 + y^2;
Q2 = z^2;
Q3 = iu*x^2 - y^2;
F  = t0^2*Q1 + 2*t0*t1*Q2 + t1^2*Q3;
Delta = Q2^2 - Q1*Q3;

mt = ideal(t0,t1);
mx = ideal(x,y,z);

print "(0) discriminant identity";
assert(Delta - (x^4+y^4+z^4) == 0);
print "    Q2^2 - Q1*Q3 = x^4 + y^4 + z^4   OK";

print "(1) Delta is a smooth plane quartic";
JD = ideal(diff(x,Delta), diff(y,Delta), diff(z,Delta));
assert(saturate(JD, mx) == ideal(1_R));
print "    singular locus of Delta is empty   OK";

print "(2) Q1, Q2, Q3 have no common zero in P^2";
assert(saturate(ideal(Q1,Q2,Q3), mx) == ideal(1_R));
print "    base locus empty, so pi_2 : Z -> P^2 is finite of degree 2   OK";

print "(3) Z is smooth in P^1 x P^2";
JF = ideal(diff(t0,F), diff(t1,F), diff(x,F), diff(y,F), diff(z,F));
sing = saturate(saturate(JF, mt), mx);
assert(sing == ideal(1_R));
print "    singular locus of Z is empty   OK";

print "    (hence X, the double cover of P^1 x P^2 branched along the smooth Z,";
print "     is a smooth Fano threefold of Mori-Mukai family No. 2.18)";

print "(4) conic-bundle discriminant of pi_1 : Z -> P^1";
S = kk[t0,t1];
M = matrix{{iu*(t0^2+t1^2), 0, 0}, {0, t0^2-t1^2, 0}, {0, 0, 2*t0*t1}};
M = sub(M, S);
d = det M;
print("    det = " | toString d);
assert(d - 2*iu*t0*t1*(t0^4 - t1^4) == 0);
disc = ideal(d, diff(t0,d)) ;
assert(saturate(ideal(d, diff(t0,d), diff(t1,d)), ideal(t0,t1)) == ideal(1_S));
print "    six distinct roots: pi_1 has exactly six reducible fibres   OK";

print "";
print "ALL SMOOTHNESS CHECKS PASSED";
