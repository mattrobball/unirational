kk = ZZ/397;
R = kk[x0,x1];
I = saturate ideal(225*x0*x0+358*x0*x1+233*x1*x1, 361*x0*x0+74*x0*x1+25*x1*x1, 67*x0*x0+13*x0*x1+351*x1*x1, 95*x0*x0+334*x0*x1+96*x1*x1, 262*x0*x0+162*x0*x1+330*x1*x1, 222*x0*x0+37*x0*x1+160*x1*x1, 115*x0*x0+188*x0*x1+387*x1*x1, 391*x0*x0+184*x0*x1+195*x1*x1, 32*x0*x0+269*x0*x1+378*x1*x1, 360*x0*x0+161*x0*x1+300*x1*x1, 116*x0*x0+55*x0*x1+151*x1*x1, 176*x0*x0+60*x0*x1+176*x1*x1, 329*x0*x0+106*x0*x1+332*x1*x1, 336*x0*x0+264*x0*x1+44*x1*x1, 394*x0*x0+159*x0*x1+263*x1*x1);
if I == ideal(1_R) then print("C6:1 EMPTY") else (
  cs = minimalPrimes I;
  print("C6:1 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("C6:1   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
