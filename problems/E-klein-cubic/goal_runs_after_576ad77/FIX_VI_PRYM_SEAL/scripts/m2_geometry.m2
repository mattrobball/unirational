-- Independent engine (Macaulay2) confirmation of the Section C geometry.
-- Char 0 throughout: coefficient field Q(sqrt 33) = QQ[y]/(y^2-33), made a field.
-- Confirms: (1) E_sigma is a smooth plane cubic, (2) E_sigma ∩ K_c is a reduced
-- 0-dimensional scheme of degree 6, (3) the conic K_c is smooth.

A = QQ[y]/(y^2-33);
F = toField A;
S = F[a,b,x];

kp = (13+3*y)/16;
km = (13-3*y)/16;

F0    = kp*a^3 + km*b^3 + (a+b)*x^2;
conic = x^2 - 4*(a^2-a*b+b^2);

<< "== trace relations ==" << endl;
<< "kp+km-13/8      = " << kp+km-13/8 << endl;
<< "kp*km+1/2       = " << kp*km+1/2 << endl;
<< "(kp+4)(km+4)-22 = " << (kp+4)*(km+4)-22 << endl;

<< "== (1) smoothness of E_sigma ==" << endl;
J = ideal(diff(a,F0), diff(b,F0), diff(x,F0));
Jsat = saturate(J, ideal(a,b,x));
<< "saturated Jacobian ideal == unit ideal : " << (Jsat == ideal(1_S)) << endl;
<< "dim Proj of Jacobian (expect -1/empty) : " << dim Jsat << endl;

<< "== conic smoothness ==" << endl;
Jc = ideal(diff(a,conic), diff(b,conic), diff(x,conic));
<< "conic saturated Jacobian == unit ideal  : " << (saturate(Jc, ideal(a,b,x)) == ideal(1_S)) << endl;

<< "== (2) E_sigma ∩ K_c ==" << endl;
I = saturate(ideal(F0, conic), ideal(a,b,x));
<< "dim (affine cone, expect 1)            : " << dim I << endl;
<< "degree (expect 6)                      : " << degree I << endl;
-- NOTE: `radical` has no strategy over toField(QQ[y]/(y^2-33)) in M2 1.26, so
-- reducedness is tested by the (stronger, and directly relevant) transversality
-- criterion: the intersection is 6 distinct transverse points iff the Jacobian of
-- (F0, conic) has rank 2 at every point of I, i.e. V(I + minors_2) is empty.
Jac = matrix{{diff(a,F0), diff(b,F0), diff(x,F0)},
             {diff(a,conic), diff(b,conic), diff(x,conic)}};
bad = saturate(I + minors(2, Jac), ideal(a,b,x));
<< "non-transverse locus empty             : " << (bad == ideal(1_S)) << endl;
<< "  => 6 distinct transverse points      : " << (degree I == 6 and bad == ideal(1_S)) << endl;

<< "== (3) restriction identity mod the conic ==" << endl;
<< "F0 - ((kp+4)a^3+(km+4)b^3) mod conic   : " << (F0 - ((kp+4)*a^3+(km+4)*b^3)) % (ideal conic) << endl;

<< "== (4) eliminate x: expect ((kp+4)+(km+4)b^3)^2 up to a unit ==" << endl;
T1 = F[bb,xx];
phi = map(T1, S, {1_T1, bb, xx});
E = eliminate(ideal(phi F0, phi conic), xx);
<< "elimination ideal generator            : " << (gens E) << endl;
<< "claimed factor ((kp+4)+(km+4)bb^3)     : " << ((kp+4)+(km+4)*bb^3) << endl;
G = (gens E)_(0,0);
<< "generator divisible by claimed cube-form: " << (G % ideal((kp+4)+(km+4)*bb^3) == 0) << endl;

<< "M2_DONE" << endl;
