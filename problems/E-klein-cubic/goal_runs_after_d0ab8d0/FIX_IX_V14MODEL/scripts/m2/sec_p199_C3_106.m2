kk = ZZ/199;
R = kk[x0,x1,x2];
I = saturate ideal(62*x0*x0+43*x0*x1+51*x0*x2+82*x1*x1+184*x1*x2+100*x2*x2, 85*x0*x0+182*x0*x1+67*x0*x2+37*x1*x1+166*x1*x2+99*x2*x2, 136*x0*x0+32*x0*x1+2*x0*x2+175*x1*x1+149*x1*x2+176*x2*x2, 101*x0*x0+123*x0*x1+5*x0*x2+120*x1*x1+165*x1*x2+176*x2*x2, 50*x0*x0+140*x0*x1+144*x0*x2+93*x1*x1+132*x1*x2+150*x2*x2, 27*x0*x0+91*x0*x1+108*x0*x2+196*x1*x1+12*x1*x2+185*x2*x2, 6*x0*x0+3*x0*x1+12*x0*x2+125*x1*x1+98*x1*x2+65*x2*x2, 70*x0*x0+68*x0*x1+61*x0*x2+115*x1*x1+116*x1*x2+185*x2*x2, 147*x0*x0+75*x0*x1+198*x0*x2+123*x1*x1+141*x1*x2+19*x2*x2, 45*x0*x0+180*x0*x1+96*x0*x2+160*x1*x1+172*x1*x2+142*x2*x2, 92*x0*x0+13*x0*x1+98*x0*x2+115*x1*x1+29*x1*x2+110*x2*x2, 16*x0*x0+102*x0*x1+120*x0*x2+5*x1*x1+34*x1*x2+160*x2*x2, 4*x0*x0+106*x0*x1+155*x0*x2+137*x1*x1+171*x1*x2+71*x2*x2, 10*x0*x0+83*x0*x1+86*x0*x2+77*x1*x1+34*x1*x2+175*x2*x2, 87*x0*x0+111*x0*x1+142*x0*x2+16*x1*x1+191*x1*x2+71*x2*x2);
if I == ideal(1_R) then print("C3[106]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C3[106]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
