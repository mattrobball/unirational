kk = ZZ/199;
R = kk[x0,x1,x2];
I = saturate ideal(24*x0*x0+95*x0*x1+80*x0*x2+140*x1*x1+16*x1*x2+41*x2*x2, 22*x0*x0+74*x0*x1+115*x0*x2+3*x1*x1+148*x1*x2+21*x2*x2, 166*x0*x0+183*x0*x1+196*x0*x2+92*x1*x1+58*x1*x2+48*x2*x2, 137*x0*x0+165*x0*x1+68*x0*x2+184*x1*x1+53*x1*x2+155*x2*x2, 11*x0*x0+83*x0*x1+68*x0*x2+81*x1*x1+96*x1*x2+97*x2*x2, 43*x0*x0+88*x0*x1+12*x0*x2+158*x1*x1+186*x1*x2+174*x2*x2, 160*x0*x0+138*x0*x1+69*x0*x2+168*x1*x1+175*x1*x2+99*x2*x2, 12*x0*x0+110*x0*x1+38*x0*x2+162*x1*x1+150*x1*x2+139*x2*x2, 32*x0*x0+177*x0*x1+142*x0*x2+178*x1*x1+35*x1*x2+164*x2*x2, 161*x0*x0+95*x0*x1+102*x0*x2+2*x1*x1+186*x1*x2+11*x2*x2, 106*x0*x0+74*x0*x1+89*x0*x2+35*x1*x1+164*x1*x2+32*x2*x2, 59*x0*x0+132*x0*x1+113*x0*x2+90*x1*x1+14*x1*x2+96*x2*x2, 16*x0*x0+49*x0*x1+103*x0*x2+102*x1*x1+136*x1*x2+53*x2*x2, 162*x0*x0+103*x0*x1+153*x0*x2+72*x1*x1+83*x1*x2+12*x2*x2, 125*x0*x0+107*x0*x1+109*x0*x2+186*x1*x1+7*x1*x2+193*x2*x2);
if I == ideal(1_R) then print("C3[92]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C3[92]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
