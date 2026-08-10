kk = ZZ/397;
R = kk[x0,x1];
I = saturate ideal(98*x0*x0+265*x0*x1+156*x1*x1, 269*x0*x0+266*x0*x1+222*x1*x1, 324*x0*x0+1*x0*x1+262*x1*x1, 112*x0*x0+16*x0*x1+251*x1*x1, 153*x0*x0+286*x0*x1+280*x1*x1, 392*x0*x0+93*x0*x1+379*x1*x1, 279*x0*x0+175*x0*x1+62*x1*x1, 179*x0*x0+344*x0*x1+83*x1*x1, 51*x0*x0+93*x0*x1+17*x1*x1, 334*x0*x0+388*x0*x1+68*x1*x1, 346*x0*x0+381*x0*x1+98*x1*x1, 274*x0*x0+290*x0*x1+10*x1*x1, 294*x0*x0+159*x0*x1+59*x1*x1, 295*x0*x0+307*x0*x1+51*x1*x1, 360*x0*x0+322*x0*x1+85*x1*x1);
if I == ideal(1_R) then print("C6[34]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C6[34]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
