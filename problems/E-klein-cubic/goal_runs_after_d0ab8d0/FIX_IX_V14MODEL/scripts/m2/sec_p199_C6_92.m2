kk = ZZ/199;
R = kk[x0,x1];
I = saturate ideal(14*x0*x0+157*x0*x1+28*x1*x1, 23*x0*x0+185*x0*x1+110*x1*x1, 189*x0*x0+146*x0*x1+57*x1*x1, 88*x0*x0+124*x0*x1+25*x1*x1, 196*x0*x0+6*x0*x1+163*x1*x1, 77*x0*x0+44*x0*x1+28*x1*x1, 49*x0*x0+76*x0*x1+147*x1*x1, 169*x0*x0+170*x0*x1+153*x1*x1, 71*x0*x0+42*x0*x1+112*x1*x1, 62*x0*x0+126*x0*x1+176*x1*x1, 7*x0*x0+16*x0*x1+17*x1*x1, 90*x0*x0+146*x0*x1+75*x1*x1, 169*x0*x0+72*x0*x1+168*x1*x1, 87*x0*x0+160*x0*x1+81*x1*x1, 88*x0*x0+4*x0*x1+39*x1*x1);
if I == ideal(1_R) then print("C6[92]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C6[92]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
