kk = ZZ/397;
R = kk[x0,x1,x2];
I = saturate ideal(279*x0*x0+197*x0*x1+18*x0*x2+175*x1*x1+362*x1*x2+150*x2*x2, 125*x0*x0+290*x0*x1+280*x0*x2+67*x1*x1+321*x1*x2+258*x2*x2, 220*x0*x0+180*x0*x1+270*x0*x2+76*x1*x1+243*x1*x2+219*x2*x2, 143*x0*x0+103*x0*x1+222*x0*x2+193*x1*x1+45*x1*x2+195*x2*x2, 395*x0*x0+133*x0*x1+219*x0*x2+42*x1*x1+90*x1*x2+211*x2*x2, 146*x0*x0+7*x0*x1+196*x0*x2+175*x1*x1+383*x1*x2+372*x2*x2, 243*x0*x0+161*x0*x1+201*x0*x2+154*x1*x1+83*x1*x2+316*x2*x2, 250*x0*x0+221*x0*x1+257*x0*x2+362*x1*x1+167*x1*x2+43*x2*x2, 20*x0*x0+167*x0*x1+139*x0*x2+192*x1*x1+63*x1*x2+89*x2*x2, 63*x0*x0+183*x0*x1+165*x0*x2+115*x1*x1+208*x1*x2+278*x2*x2, 389*x0*x0+274*x0*x1+381*x0*x2+30*x1*x1+173*x1*x2+183*x2*x2, 133*x0*x0+232*x0*x1+357*x0*x2+235*x1*x1+19*x1*x2+61*x2*x2, 4*x0*x0+220*x0*x1+189*x0*x2+1*x1*x1+272*x1*x2+15*x2*x2, 269*x0*x0+34*x0*x1+302*x0*x2+277*x1*x1+91*x1*x2+161*x2*x2, 387*x0*x0+10*x0*x1+29*x0*x2+260*x1*x1+264*x1*x2+150*x2*x2);
if I == ideal(1_R) then print("C3:362 EMPTY") else (
  cs = minimalPrimes I;
  print("C3:362 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("C3:362   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
