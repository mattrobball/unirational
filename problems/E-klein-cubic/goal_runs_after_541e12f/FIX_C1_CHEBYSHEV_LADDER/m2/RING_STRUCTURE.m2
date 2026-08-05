-- FIX-C1: is the Chebyshev parameter ring a field?
-- K = QQ(om,kp),  R_j = K[c,P1]/(c^3-3c-kap, P1^3-(8/9)om^(j+1) kap P1^2+(32/27)kap)
A = QQ[om,kp];
K = toField(A/ideal(om^2+om+1, 8*kp^2-13*kp-4));
kap = kp+2;
S = K[c,P1];
for j from 0 to 2 do (
  omj = om^((j+1)%3);
  I = ideal(c^3-3*c-kap, P1^3-(8/9)*omj*kap*P1^2+(32/27)*kap);
  << "j = " << j << "  dim = " << dim I << "  degree = " << degree I
     << "  isPrime = " << isPrime I << endl;
  << "   c-cubic irreducible over K : " << isPrime ideal(c^3-3*c-kap) << endl;
  << "   P1-cubic irreducible over K: " << isPrime ideal(P1^3-(8/9)*omj*kap*P1^2+(32/27)*kap) << endl;
  << "   radical=I : " << (radical I == I) << endl;
);
-- control ring: B^6 - kap B^3 + 1
SB = K[B];
JB = ideal(B^6-kap*B^3+1);
<< "control: dim = " << dim JB << " degree = " << degree JB << " isPrime = " << isPrime JB << endl;
