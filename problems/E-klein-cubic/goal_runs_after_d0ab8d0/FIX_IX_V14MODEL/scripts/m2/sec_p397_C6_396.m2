kk = ZZ/397;
R = kk[x0,x1];
I = saturate ideal(374*x0*x0+245*x0*x1+272*x1*x1, 23*x0*x0+152*x0*x1+125*x1*x1, 392*x0*x0+36*x0*x1+249*x1*x1, 134*x0*x0+385*x0*x1+314*x1*x1, 310*x0*x0+150*x0*x1+45*x1*x1, 265*x0*x0+77*x0*x1+301*x1*x1, 338*x0*x0+266*x0*x1+318*x1*x1, 280*x0*x0+366*x0*x1+348*x1*x1, 9*x0*x0+94*x0*x1+187*x1*x1, 387*x0*x0+72*x0*x1+101*x1*x1, 352*x0*x0+324*x0*x1+256*x1*x1, 124*x0*x0+60*x0*x1+18*x1*x1, 231*x0*x0+163*x0*x1+168*x1*x1, 190*x0*x0+220*x0*x1+66*x1*x1, 150*x0*x0+111*x0*x1+73*x1*x1);
if I == ideal(1_R) then print("C6[396]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C6[396]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
