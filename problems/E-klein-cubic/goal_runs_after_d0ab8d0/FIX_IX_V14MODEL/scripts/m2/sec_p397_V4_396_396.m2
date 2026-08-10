kk = ZZ/397;
R = kk[x0,x1];
I = saturate ideal(123*x0*x0+164*x0*x1+293*x1*x1, 373*x0*x0+301*x0*x1+205*x1*x1, 162*x0*x0+321*x0*x1+179*x1*x1, 280*x0*x0+129*x0*x1+167*x1*x1, 370*x0*x0+223*x0*x1+83*x1*x1, 140*x0*x0+191*x0*x1+162*x1*x1, 331*x0*x0+189*x0*x1+274*x1*x1, 328*x0*x0+63*x0*x1+267*x1*x1, 265*x0*x0+15*x0*x1+56*x1*x1, 361*x0*x0+164*x0*x1+290*x1*x1, 148*x0*x0+257*x0*x1+293*x1*x1, 109*x0*x0+211*x0*x1+231*x1*x1, 297*x0*x0+128*x0*x1+278*x1*x1, 45*x0*x0+284*x0*x1+237*x1*x1, 102*x0*x0+6*x0*x1+94*x1*x1);
if I == ideal(1_R) then print("V4[396,396]|EMPTY") else (
  cs = minimalPrimes I;
  s := "V4[396,396]|dim " | toString(dim I - 1) | "|deg " | toString degree I | "|ncomp " | toString(#cs);
  for c in cs do s = s | "|(d" | toString(dim c - 1) | " e" | toString degree c | (if dim c == 2 then " g" | toString genus c else "") | ")";
  print s;)
