-- FIX-C5 : Macaulay2 route for the branch quartic Delta_v.
-- packet goal_runs_after_9094303/FIX_C5_BRANCH_QUARTIC ; theory sec. 5.18-5.19
--
-- Field  K = Q(om, s),  om^2+om+1 = 0,  s^2 = 33   (degree 4 over Q; equals the
-- frame field Q(om,nu) since sqrt33 = -nu*(2om+1)).  No underscore variables.
-- Everything exact; no floating point.
--
--   run:  M2 --script c5_sing.m2

A = QQ[om,s]/(om^2+om+1, s^2-33);
K = toField A;
R = K[a,b,y,z];

kp = (13+3*s)/16;  km = (13-3*s)/16;
Q1 = a+b;  Q2 = om*a+om^2*b;  Q3 = om^2*a+om*b;  C = kp*a^3+km*b^3;
c  = 1;
D  = c^2*y^2*z^2 - 4*Q1*(Q2*y^2+Q3*z^2+C);

print "== FIX-C5 / Macaulay2 ==";
print ("Delta_v = ", toString D);
print ("Delta_v is homogeneous of degree 4 : ", isHomogeneous D and (first degree D) == 4);

-- (1) the reduction modulo Q1
print ("Delta_v mod Q1 == (c y z)^2 : ", (D - c^2*y^2*z^2) % (ideal Q1) == 0);

-- (2) the singular locus.  Euler: char 0, deg 4 => Sing = V(jacobian).
J  = ideal jacobian D;
irr = ideal(a,b,y,z);
Js = saturate(J, irr);
print ("Sing is empty (unit ideal)? ", Js == ideal(1_R));
print ("dim of the affine cone over Sing = ", dim Js);
print ("PROJECTIVE dim Sing(Delta_v)     = ", dim Js - 1);
print ("degree Sing(Delta_v)             = ", degree Js);
print ("Delta_v lies in the jacobian ideal (Euler) : ", D % Js == 0);

-- the six nodes lie on {Q1 = 0}  (Q1 belongs to the (radical) jacobian ideal):
print ("Sing subset {Q1 = 0} : ", Q1 % Js == 0);

-- the two K-rational nodes, and the two conjugate pairs:
Py = ideal(a,b,z);          -- [0:0:1:0]
Pz = ideal(a,b,y);          -- [0:0:0:1]
Ny = ideal(z, a+b, 8*a^2*(kp-km) + 8*(2*om+1)*y^2);   -- y^2 = -(kp-km)/delta a^2
Nz = ideal(y, a+b, 8*a^2*(kp-km) - 8*(2*om+1)*z^2);   -- z^2 =  (kp-km)/delta a^2
print ("node component Py subset Sing : ", isSubset(Js, Py));
print ("node component Pz subset Sing : ", isSubset(Js, Pz));
print ("node component Ny subset Sing : ", isSubset(Js, Ny));
print ("node component Nz subset Sing : ", isSubset(Js, Nz));
print ("degrees (Py,Pz,Ny,Nz) = ", {degree Py, degree Pz, degree Ny, degree Nz});
print ("intersection of the four components == Sing : ",
       (intersect(Py,Pz,Ny,Nz)) == Js);

-- (3) the incidence system of lines through v : {ell = q = k = 0}
I5 = ideal(Q1, y*z, C + Q2*y^2 + Q3*z^2);
Is = saturate(I5, irr);
print ("contracted locus: proj dim = ", dim Is - 1, "  degree = ", degree Is);
print ("contracted locus == Sing(Delta_v) : ", Is == Js);

-- (4) CONTROLS (so that an empty/zero-dimensional answer is not vacuous)
Dred = (a*b - y*z)*(a^2+b^2+y^2+z^2);
print ("CONTROL reducible quartic  : proj dim Sing = ",
       dim saturate(ideal jacobian Dred, irr) - 1);
Dsq = (a^2+b^2+y^2+z^2)^2;
print ("CONTROL nonreduced quartic : proj dim Sing = ",
       dim saturate(ideal jacobian Dsq, irr) - 1);
Dsm = a^4+b^4+y^4+z^4;
print ("CONTROL smooth quartic     : Sing = unit ideal? ",
       saturate(ideal jacobian Dsm, irr) == ideal(1_R));
print ("CONTROL nonunit: Js != (1) as printed above.");

print "FIX_C5_M2_OK";
