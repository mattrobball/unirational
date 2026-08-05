R = QQ[om,kp];
K = toField(QQ[om,kp]/ideal(om^2+om+1, 8*kp^2-13*kp-4));
S = K[B2,P1,c];
-- eigenblock lam = one
Ione = ideal(P1^3 - 8*P1^2*kp*om/9 - 16*P1^2*om/9 + 32*kp/27 + 64/27, c^3 - 3*c - kp - 2);
Done = -P1*c*om/2 + P1*c/2 - 2*om - 1;
Jone = Ione + ideal(Done);
<< "BLOCK one  dim I = " << dim Ione << "  degree I = " << degree Ione << "  1 in J = " << (1 % Jone == 0) << endl;
-- eigenblock lam = om
Iom = ideal(P1^3 + 8*P1^2*kp*om/9 + 8*P1^2*kp/9 + 16*P1^2*om/9 + 16*P1^2/9 + 32*kp/27 + 64/27, B2^3 + 9*B2*om + 6*kp*om + 3*kp + 12*om + 6);
Dom = 2*om + 1;
Jom = Iom + ideal(Dom);
<< "BLOCK om  dim I = " << dim Iom << "  degree I = " << degree Iom << "  1 in J = " << (1 % Jom == 0) << endl;
-- eigenblock lam = om2
Iom2 = ideal(P1^3 - 8*P1^2*kp/9 - 16*P1^2/9 + 32*kp/27 + 64/27, B2^3 - 9*B2*om - 9*B2 + 6*kp*om + 3*kp + 12*om + 6);
Dom2 = B2*P1*om/2 + B2*P1/2;
Jom2 = Iom2 + ideal(Dom2);
<< "BLOCK om2  dim I = " << dim Iom2 << "  degree I = " << degree Iom2 << "  1 in J = " << (1 % Jom2 == 0) << endl;
<< "FIX_H1_M2_OK" << endl;
