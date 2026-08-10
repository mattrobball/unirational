kk = ZZ/199;
R = kk[x0,x1];
I = saturate ideal(103*x0*x0+29*x0*x1+144*x1*x1, 184*x0*x0+135*x0*x1+130*x1*x1, 142*x0*x0+51*x0*x1+121*x1*x1, 39*x0*x0+81*x0*x1+4*x1*x1, 118*x0*x0+108*x0*x1+49*x1*x1, 197*x0*x0+173*x0*x1+16*x1*x1, 144*x0*x0+120*x0*x1+146*x1*x1, 67*x0*x0+33*x0*x1+137*x1*x1, 68*x0*x0+12*x0*x1+1*x1*x1, 104*x0*x0+176*x0*x1+178*x1*x1, 32*x0*x0+8*x0*x1+118*x1*x1, 2*x0*x0+71*x0*x1+92*x1*x1, 132*x0*x0+99*x0*x1+53*x1*x1, 191*x0*x0+104*x0*x1+131*x1*x1, 26*x0*x0+66*x0*x1+28*x1*x1);
if I == ideal(1_R) then print("C5[1]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C5[1]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
