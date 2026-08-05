A = QQ[om,kp,c,P1, MonomialOrder=>Lex];
kap = kp+2;
I = ideal(om^2+om+1, 8*kp^2-13*kp-4, c^3-3*c-kap,
          27*P1^3 - 24*om*kap*P1^2 + 32*kap);
R = A/I;
<< "dim_QQ R = " << numgens source basis R << endl;
K = toField R;
<< "toField OK" << endl;
-- can we invert a random-looking element?
u = 1 + 2*om + 3*kp + 5*c + 7*P1 + c*P1;
<< "u^-1 = " << (1/u) << endl;
<< "check = " << (u*(1/u)) << endl;
M = matrix{{c, P1, om}, {kp*c, 1+P1, c*P1}, {c+P1, 1, om*kp}};
<< "rank M = " << rank M << endl;
<< "ker M = " << (generators kernel M) << endl;
