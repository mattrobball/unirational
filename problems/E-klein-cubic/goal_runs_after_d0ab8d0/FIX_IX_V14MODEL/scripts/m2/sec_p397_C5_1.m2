kk = ZZ/397;
R = kk[x0,x1];
I = saturate ideal(199*x0*x0+336*x0*x1+261*x1*x1, 252*x0*x0+151*x0*x1+182*x1*x1, 243*x0*x0+305*x0*x1+19*x1*x1, 58*x0*x0+181*x0*x1+327*x1*x1, 353*x0*x0+81*x0*x1+177*x1*x1, 127*x0*x0+28*x0*x1+127*x1*x1, 382*x0*x0+23*x0*x1+270*x1*x1, 30*x0*x0+213*x0*x1+93*x1*x1, 178*x0*x0+1*x0*x1+321*x1*x1, 360*x0*x0+148*x0*x1+300*x1*x1, 253*x0*x0+158*x0*x1+329*x1*x1, 150*x0*x0+59*x0*x1+142*x1*x1, 387*x0*x1+350*x1*x1, 299*x0*x0+330*x0*x1+79*x1*x1, 302*x0*x0+210*x0*x1+144*x1*x1);
if I == ideal(1_R) then print("C5[1]|EMPTY") else (
  cs = minimalPrimes I;
  s := "C5[1]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
