kk = ZZ/397;
R = kk[x0];
I = saturate ideal(198*x0*x0);
if I == ideal(1_R) then print("C11:290 EMPTY") else (
  cs = minimalPrimes I;
  print("C11:290 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("C11:290   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
